/* MAIN.C file
 *
 * Copyright (c) 2002-2005 STMicroelectronics
 */
#include "stm8s_conf.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#define UART_RX_BUFFER_SIZE 20
#define UART_TX_BUFFER_SIZE 20

typedef struct 
{
    uint8_t di1;
    uint8_t di2;
    uint8_t di3;
    uint8_t di4;
} sensor_state_t;

typedef enum {
    UART_STATE_IDLE,
    UART_STATE_READY,
    UART_STATE_RX_PENDING,
    UART_STATE_TX_PENDING,
    UART_STATE_ERROR
} uart_state_t;

typedef enum {
	TCP_STATE_IDLE,
	TCP_STATE_LISTENING,
	TCP_STATE_CONNECTED,
	TCP_STATE_ERROR
} tcp_state_t;

static sensor_state_t current_state = {0, 0, 0, 0};

static tcp_state_t server_state = TCP_STATE_IDLE;
static uart_state_t uart_state = UART_STATE_IDLE;
static uint8_t server_socket = 0;
static volatile uint8_t uart_rx_buffer[UART_RX_BUFFER_SIZE];
static volatile uint16_t uart_rx_count = 0;
static volatile uint16_t uart_rx_head = 0;
static volatile uint16_t uart_rx_tail = 0;
static uint8_t uart_tx_buffer[UART_TX_BUFFER_SIZE];
static uint8_t uart_rx_buffer[20];

void hal_uart_send_byte(uint8_t byte)
{
    /* Wait for transmit buffer to be empty */
    while (UART1_GetFlagStatus(UART1_FLAG_TXE) == RESET);
    
    /* Send byte */
    UART1_SendData8(byte);
    
    /* Wait for transmission to complete */
    while (UART1_GetFlagStatus(UART1_FLAG_TC) == RESET);
}


void hal_uart_send(const uint8_t *data, uint16_t len)
{
    uint16_t i;
    for (i = 0; i < len; i++) {
        hal_uart_send_byte(data[i]);
    }
}


int uart_server_send(const uint8_t *data, uint16_t len)
{
    if (uart_state == UART_STATE_IDLE) {
        return -1;
    }
    
    if (len > sizeof(uart_tx_buffer)) {
        len = sizeof(uart_tx_buffer);
    }
    
    /* Copy to TX buffer and send */
    memcpy(uart_tx_buffer, data, len);
    hal_uart_send(uart_tx_buffer, len);
    
    return 0;
}
sensor_state_t sensor_reader_get_state(void)
{
    return current_state;
}

void message_formatter_alive(char *buf,
                             int buf_size,
                             uint8_t di1,
                             uint8_t di2,
                             uint8_t di3,
                             uint8_t di4)
{
    if (buf == 0)
        return;

    if (buf_size < 32)
        return;

    sprintf(buf,
            "START,ALIVE,%d%d%d%d,END",
            di1,
            di2,
            di3,
            di4);
}

uint8_t hal_di_read(uint8_t di_num)
{
    GPIO_TypeDef *port;
    GPIO_Pin_TypeDef pin;
    
    switch (di_num) {
        case 1: port = DI1_PORT; pin = DI1_PIN; break;
        case 2: port = DI2_PORT; pin = DI2_PIN; break;
        case 3: port = DI3_PORT; pin = DI3_PIN; break;
        case 4: port = DI4_PORT; pin = DI4_PIN; break;
        default: return 0;
    }
    return (GPIO_ReadInputPin(port, pin) == SET) ? 1 : 0;
}

void sensor_reader_update(void)
{
    current_state.di1 = hal_di_read(1);
    current_state.di2 = hal_di_read(2);
    current_state.di3 = hal_di_read(3);
    current_state.di4 = hal_di_read(4);
}

void sensor_reader_init(void)
{
    /* GPIO is already initialized by hal_gpio_init() */
    sensor_reader_update();
}

void hal_relay_set(uint8_t relay_num, uint8_t state){
	GPIO_TypeDef *port;
	GPIO_Pin_TypeDef pin;
	BitStatus bit_state = (state == 0) ? SET : RESET;

	switch (relay_num) {
        case 1: port = RELAY1_PORT; pin = RELAY1_PIN; break;
        case 2: port = RELAY2_PORT; pin = RELAY2_PIN; break;
        case 3: port = RELAY3_PORT; pin = RELAY3_PIN; break;
        case 4: port = RELAY4_PORT; pin = RELAY4_PIN; break;
        case 5: port = RELAY5_PORT; pin = RELAY5_PIN; break;
        case 6: port = RELAY6_PORT; pin = RELAY6_PIN; break;
        default: return;
    }

	if (bit_state == SET) {
        GPIO_WriteHigh(port, pin);  /* Set HIGH = relay off */
    } else {
        GPIO_WriteLow(port, pin); /* Set LOW = relay on */
    }
}

void relay_control_set(uint8_t relay_num, uint8_t state)
{
    if (relay_num >= 1 && relay_num <= 6) {
        hal_relay_set(relay_num, state);
    }
}

void relay_control_set_all(uint8_t state)
{
    relay_control_set(1, state);
    relay_control_set(2, state);
    relay_control_set(3, state);
    relay_control_set(4, state);
    relay_control_set(5, state);
    relay_control_set(6, state);
}

int command_parser_execute(const char *cmd_str, int len)
{
    char cmd_copy[64];
    char *cmd = NULL;
    char *value_str = NULL;
    char *comma_pos;
    int relay_num = 0;
    int relay_state = 0;
    
    if (len == 0 || len >= 64) return -1;
    
    /* Copy command to working buffer */
    strncpy(cmd_copy, cmd_str, len);
    cmd_copy[len] = '\0';
    
    /* Find comma separator */
    comma_pos = strchr(cmd_copy, ',');
    if (!comma_pos) return -1;
    
    /* Split into command and value */
    *comma_pos = '\0';
    cmd = cmd_copy;
    value_str = comma_pos + 1;
    
    /* Parse relay command (R1-R6) */
    if (cmd[0] == 'R' && cmd[1] >= '1' && cmd[1] <= '6' && cmd[2] == '\0') {
        relay_num = cmd[1] - '0';
        relay_state = atoi(value_str);
        
        /* Set relay state (0 = off, 1 = on) */
        relay_control_set(relay_num, relay_state);
        return 0;
    }
    
    return -1;
}

void relay_control_init(void)
{
    relay_control_set_all(1);  /* 1 = on for active-low relays */
}

void hal_w5500_reset_high(void)
{
    GPIO_WriteHigh(W5500_RST_PORT, W5500_RST_PIN);
}

void hal_gpio_init(void){
	/* ===== Digital Inputs (Sensors) ===== */
    GPIO_Init(DI1_PORT, DI1_PIN, GPIO_MODE_IN_PU_NO_IT);
    GPIO_Init(DI2_PORT, DI2_PIN, GPIO_MODE_IN_PU_NO_IT);
    GPIO_Init(DI3_PORT, DI3_PIN, GPIO_MODE_IN_PU_NO_IT);
    GPIO_Init(DI4_PORT, DI4_PIN, GPIO_MODE_IN_PU_NO_IT);

	/* ===== Relay Outputs ===== */
    GPIO_Init(RELAY1_PORT, RELAY1_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
    GPIO_Init(RELAY2_PORT, RELAY2_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
    GPIO_Init(RELAY3_PORT, RELAY3_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
    GPIO_Init(RELAY4_PORT, RELAY4_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
    GPIO_Init(RELAY5_PORT, RELAY5_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
    GPIO_Init(RELAY6_PORT, RELAY6_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);

	/* Initialize all relays to HIGH (off state for active-low) */
    hal_relay_set(1, 1);
    hal_relay_set(2, 1);
    hal_relay_set(3, 1);
    hal_relay_set(4, 1);
    hal_relay_set(5, 1);
    hal_relay_set(6, 1);

	/* ===== Hardware Reset Input ===== */
    GPIO_Init(HARDRST_PORT, HARDRST_PIN, GPIO_MODE_IN_PU_NO_IT);
    
    /* ===== W5500 Reset Pin ===== */
    GPIO_Init(W5500_RST_PORT, W5500_RST_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
	hal_w5500_reset_high();
}

uint16_t hal_uart_available(void){
	return uart_rx_count;
}

uint8_t hal_uart_read_byte(void){
	uint8_t byte = 0;
	if (uart_rx_count > 0){
		disableInterrupts();

		byte = uart_rx_buffer[uart_rx_tail];
		uart_rx_tail = (uart_rx_tail + 1) % UART_RX_BUFFER_SIZE;
		uart_rx_count--;
		enableInterrupts();
	} 
	return byte;
}

void uart_server_process(void){
	uint16_t available_len;
	uint8_t read_byte;
	char resp_buf[20];
	sensor_state_t state;
	
	if (uart_state == UART_STATE_IDLE){
		return;
	}
	available_len = hal_uart_available();
	
	if(available_len > 0){
		uart_state = UART_STATE_RX_PENDING;

		while (available_len > 0 && uart_rx_count < sizeof(uart_rx_buffer) - 1){
			read_byte = hal_uart_read_byte();

			if (read_byte == '\n' || read_byte == '\r'){
				if(uart_rx_count > 0){
					uart_rx_buffer[uart_rx_count] = '\0';
					if (command_parser_execute((const char *)uart_rx_buffer,uart_rx_count) == 0){
						state = sensor_reader_get_state();
						message_formatter_alive(resp_buf, sizeof(resp_buf),state.di1,state.di2,state.di3,state.di4);
						uart_server_send();
					}
				}
			}
		}
	}
}

/* Function Prototypes */
void delay_ms(uint16_t ms);
void main_loop(void);
void system_init(void);

/* Software Delay */
void delay_ms(uint16_t ms)
{
    uint16_t i;
    uint16_t j;

    for(i = 0; i < ms; i++)
    {
        for(j = 0; j < 4000; j++)
        {
            _asm("nop");
        }
    }
}

void tcp_server_process(void){
	uint16_t received_len = 0;
	uint8_t sock_status = 0;

	if(server_state ==  TCP_STATE_IDLE)return;
	//sock_status = WIZCHIP_READ(getSn_SR(server_socket));
}

void hal_uart_init(uint32_t baudrate)
{
    /* Enable UART1 clock */
    CLK_PeripheralClockConfig(CLK_PERIPHERAL_UART1, ENABLE);
    
    /* UART1 configuration:
     * - Baudrate: 115200
     * - Word length: 8 bits
     * - Stop bits: 1
     * - Parity: None
     * - Mode: RX and TX enabled
     */
//     UART1_Init(
//     baudrate,
//     UART1_WORDLENGTH_8D,
//     UART1_STOPBITS_1,
//     UART1_PARITY_NO,
//     UART1_SYNCMODE_CLOCK_DISABLE,
//     (UART1_Mode_TypeDef)(UART1_MODE_TX_ENABLE | UART1_MODE_RX_ENABLE)
// );
    /* Enable UART1 Receive Interrupt */
  //  UART1_ITConfig(UART1_IT_RXNE, ENABLE);
	/* Enable UART1 */
//    UART1_Cmd(ENABLE);
	uart_rx_head = 0;
	uart_rx_tail = 0;
    uart_rx_count = 0;
}

void uart_server_init(uint32_t baudrate){
	uart_state = UART_STATE_IDLE;
	uart_rx_count = 0;

	hal_uart_init(baudrate);
	
	uart_state = UART_STATE_READY;
}

/* Main Application Loop */
void main_loop(void)
{
    while(1)
    {
		/* Process TCP server communication */
		tcp_server_process();

		/* Process UART server communcation*/
		uart_server_process();

        if(GPIO_ReadInputPin(HARDRST_PORT, HARDRST_PIN) == RESET)
        {
            delay_ms(50);
			if (GPIO_ReadInputPin(HARDRST_PORT, HARDRST_PIN) == 0){
				/* Send reset message */
				char mssg[] = "RESET, OK\n";
				delay_ms(100);
			}
        }
    }
}

void system_init(void){
	/* Configure system clock */
    CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);  /* 16MHz clock */

	/* Initialize HAL layers */
	hal_gpio_init();

	/* Initialize application modules */
	relay_control_init();
	sensor_reader_init();
	/* Initialize UART server for dual-channel communication */
	delay_ms(500);
}

/* Main Function */
int main(void)
{
	system_init();
    main_loop();

    while(1);
}


// hal_uart_init
// void system_init(void)