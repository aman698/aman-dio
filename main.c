/* MAIN.C file
 *
 * Copyright (c) 2002-2005 STMicroelectronics
 */
#include "stm8s_conf.h"
#include <string.h>

#define UART_RX_BUFFER_SIZE 80
#define UART_TX_BUFFER_SIZE 80
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

typedef struct {
    unsigned long last_alive_time;
    unsigned long last_sensor_time;
    unsigned long current_time;
} task_timer_t;

typedef struct {
    uint8_t loop_active; /* Vehicle on loop */
    uint8_t prev_di2_state; /* Previous acle sensor state */
    uint8_t axle_count;  /* Number of axles counted */
    uint8_t prev_di1_state;  /* Previous loop detection state */
    uint32_t embedded_seq_num; /* Sequence number for AVCC messages */
} axle_counter_t;

static axle_counter_t axle_counter = {
    0,
    0,
    0,
    0,
    0
};

static task_timer_t task_timer = {0, 0, 0,};
static sensor_state_t current_state = {0, 0, 0, 0};
typedef void (*timer_callback_t)(void);
static tcp_state_t server_state = TCP_STATE_IDLE;
static uart_state_t uart_state = UART_STATE_IDLE;
static uint16_t server_port = TCP_SERVER_PORT;
static uint8_t server_socket = 0;
static volatile uint16_t uart_rx_count = 0;
static volatile uint16_t uart_rx_head = 0;
static volatile uint16_t uart_rx_tail = 0;
static uint8_t uart_tx_buffer[UART_TX_BUFFER_SIZE];
static uint8_t uart_rx_buffer[20];
static uint8_t rx_buffer[TCP_RX_BUFFER];
static unsigned long systick_ms = 0;
static timer_callback_t user_callback = 0;


unsigned long hal_get_millis(void)
{
    return systick_ms;
}
int tcp_server_is_connected(void)
{
    return (server_state == TCP_STATE_CONNECTED) ? 1 : 0;
}
void hal_delay_ms(unsigned int ms)
{
    unsigned long start = hal_get_millis();
    while ((hal_get_millis() - start) < ms);
}

int uart_server_is_ready(void){
    return (uart_state != UART_STATE_IDLE) ? 1 : 0;
}

void hal_uart_send_byte(uint8_t byte){
    while (UART1_GetFlagStatus(UART1_FLAG_TXE) == RESET);

    /* Send byte */
    UART1_SendData8(byte);

    /* Wait for transmission to complete */
    while (UART1_GetFlagStatus(UART1_FLAG_TC) == RESET);
}

void hal_uart_send(const uint8_t *data, uint16_t len){
    uint16_t i;
    for(i = 0; i < len; i++){
        hal_uart_send_byte(data[i]);
    }
}
void hal_spi_cs_low(void)
{
    GPIO_WriteLow(W5500_CS_PORT, W5500_CS_PIN);
}

void hal_spi_cs_high(void)
{
    GPIO_WriteHigh(W5500_CS_PORT, W5500_CS_PIN);
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
    if(buf == 0)
        return;

    if(buf_size < 21)
        return;

    buf[0]  = 'S';
    buf[1]  = 'T';
    buf[2]  = 'A';
    buf[3]  = 'R';
    buf[4]  = 'T';
    buf[5]  = ',';
    buf[6]  = 'A';
    buf[7]  = 'L';
    buf[8]  = 'I';
    buf[9]  = 'V';
    buf[10] = 'E';
    buf[11] = ',';

    buf[12] = di1 ? '1' : '0';
    buf[13] = di2 ? '1' : '0';
    buf[14] = di3 ? '1' : '0';
    buf[15] = di4 ? '1' : '0';

    buf[16] = ',';
    buf[17] = 'E';
    buf[18] = 'N';
    buf[19] = 'D';
    buf[20] = '\0';
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

static char* u16_to_str(char *p, uint16_t value)
{
    char temp[6];
    uint8_t i = 0;
    uint8_t j;

    if(value == 0)
    {
        *p++ = '0';
        return p;
    }

    while(value)
    {
        temp[i++] = (value % 10) + '0';
        value /= 10;
    }

    for(j = i; j > 0; j--)
    {
        *p++ = temp[j - 1];
    }

    return p;
}

static char* u32_to_str(char *p, uint32_t value)
{
    char temp[10];
    uint8_t i = 0;
    uint8_t j;

    if(value == 0)
    {
        *p++ = '0';
        return p;
    }

    while(value)
    {
        temp[i++] = (value % 10) + '0';
        value /= 10;
    }

    for(j = i; j > 0; j--)
    {
        *p++ = temp[j - 1];
    }

    return p;
}

void message_formatter_avcc(char *buf,
                            int buf_size,
                            uint16_t lanid,
                            uint32_t seqn,
                            uint16_t axle_count)
{
    char *p;

    if(buf == 0)
        return;

    if(buf_size < 40)
        return;

    p = buf;

    /* START,AVCC, */
    *p++ = 'S';
    *p++ = 'T';
    *p++ = 'A';
    *p++ = 'R';
    *p++ = 'T';
    *p++ = ',';
    *p++ = 'A';
    *p++ = 'V';
    *p++ = 'C';
    *p++ = 'C';
    *p++ = ',';

    p = u16_to_str(p, lanid);

    *p++ = ',';

    p = u32_to_str(p, seqn);

    *p++ = ',';
    *p++ = 'A';
    *p++ = 'X';
    *p++ = 'L';
    *p++ = 'E';
    *p++ = ',';

    p = u16_to_str(p, axle_count);

    *p++ = ',';
    *p++ = 'E';
    *p++ = 'N';
    *p++ = 'D';

    *p = '\0';
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

void sensor_reader_update(void){
    current_state.di1 = hal_di_read(1);
    current_state.di2 = hal_di_read(2);
    current_state.di3 = hal_di_read(3);
    current_state.di4 = hal_di_read(4);
}


void hal_timer_start(void)
{
    TIM4_Cmd(ENABLE);
}

/*
* Process acle counting state machine
*/
void process_axle_counting(void){
    sensor_state_t sensor = sensor_reader_get_state();

    /* Vehicle entered loop detection */
    if(sensor.di1 == 1 && axle_counter.prev_di1_state == 0){
        axle_counter.loop_active = 1;
        axle_counter.axle_count = 0;
    }
    /* Count axle pulses while vehicle is on loop */
    if(axle_counter.loop_active){
        if(sensor.di2 == 1 && axle_counter.prev_di2_state == 0){
            axle_counter.axle_count++;
        }
        axle_counter.prev_di2_state = sensor.di2;
    }

    /* Vehicle left loop */
    if (sensor.di1 == 0 && axle_counter.prev_di1_state == 1 && axle_counter.loop_active){
        uint16_t axle_final_count = axle_counter.axle_count / 2;

        char msg_buf[80];
        message_formatter_avcc(msg_buf, sizeof(msg_buf),DEVICE_LANID,axle_counter.embedded_seq_num,axle_final_count);
        /* Send via UART if ready */
        if(uart_server_is_ready()){
            uart_server_send((uint8_t *)msg_buf, strlen(msg_buf));
        }
        /* RESET COUNTER */
        axle_counter.embedded_seq_num++;
        axle_counter.loop_active = 0;
        axle_counter.axle_count = 0;
    }
    axle_counter.prev_di1_state = sensor.di1;
}
void sensor_reader_init(void)
{
    /* GPIO is already initialized by hal_gpio_init() */
    sensor_reader_update();
}

void send_alive_message(void)
{
    char msg_buf[256];
    sensor_state_t sensor;

    sensor = sensor_reader_get_state();

    message_formatter_alive(
        msg_buf,
        sizeof(msg_buf),
        sensor.di1,
        sensor.di2,
        sensor.di3,
        sensor.di4
    );

    if (uart_server_is_ready())
    {
        uart_server_send((uint8_t *)msg_buf, strlen(msg_buf));
    }
}

void timer_callback(void){
    task_timer.current_time = hal_get_millis();
    if ((task_timer.current_time - task_timer.last_sensor_time) >= SENSOR_READ_INTERVAL){
        sensor_reader_update();
        process_axle_counting();
        task_timer.last_sensor_time = task_timer.current_time;
    }

    if ((task_timer.current_time - task_timer.last_alive_time) >= ALIVE_INTERVAL){
        send_alive_message();  
        task_timer.last_alive_time = task_timer.current_time;
    }
}

void hal_timer_set_callback(timer_callback_t callback)
{
    user_callback = callback;
}

int command_parser_execute(const char *cmd_str, int len)
{
    uint8_t relay_num;
    uint8_t relay_state;

    /* Expected format: Rn,x */
    if (len < 4)
        return -1;

    if (cmd_str[0] != 'R')
        return -1;

    if (cmd_str[1] < '1' || cmd_str[1] > '6')
        return -1;

    if (cmd_str[2] != ',')
        return -1;

    if (cmd_str[3] != '0' && cmd_str[3] != '1')
        return -1;

    relay_num = cmd_str[1] - '0';
    relay_state = cmd_str[3] - '0';

    relay_control_set(relay_num, relay_state);

    return 0;
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
					 	uart_server_send((uint8_t *)resp_buf,strlen(resp_buf));
					}
                    else {
                        uart_server_send((uint8_t *)"ERROR,INVALID_COMMAND\n",strlen("ERROR,INVALID_COMMAND\n"));
                    }
                    uart_rx_count = 0;
				}
			}
            else if (read_byte >= 32 && read_byte < 127){
                uart_rx_buffer[uart_rx_count++] = read_byte;
            }
            available_len--;
		}
        uart_state = UART_STATE_READY;
	}
    else{
        uart_state = UART_STATE_READY;
    }
}
uint8_t hal_spi_byte(uint8_t data)
{
    while (SPI_GetFlagStatus(SPI_FLAG_TXE) == RESET);

    SPI_SendData(data);

    while (SPI_GetFlagStatus(SPI_FLAG_RXNE) == RESET);

    return SPI_ReceiveData();
}
uint8_t hal_spi_read_byte(void)
{
    return hal_spi_byte(0xFF);
}
void hal_spi_write_byte(uint8_t data)
{
    hal_spi_byte(data);
}
void hal_spi_read(uint8_t *buf, uint16_t len){
    uint16_t i;
    for(i = 0; i < len; i++){
        buf[i] = hal_spi_byte(0xFF);
    }
}

void hal_spi_write(uint8_t *buf, uint16_t len){
    uint16_t i;
    for(i = 0; i < len; i++){
        hal_spi_byte(buf[i]);
    }
}

void uart_server_init(uint32_t baudrate){
	uart_state = UART_STATE_IDLE;
	uart_rx_count = 0;
	CLK_PeripheralClockConfig(CLK_PERIPHERAL_UART1, ENABLE);
    UART1_Init(
    baudrate,
    UART1_WORDLENGTH_8D,
    UART1_STOPBITS_1,
    UART1_PARITY_NO,
    UART1_SYNCMODE_CLOCK_DISABLE,
    (UART1_Mode_TypeDef)(UART1_MODE_TX_ENABLE | UART1_MODE_RX_ENABLE)
);
    /* Enable UART1 Receive Interrupt */
    UART1_ITConfig(UART1_IT_RXNE, ENABLE);

    /* Enable UART1 */
    UART1_Cmd(ENABLE);
    /* Clear buffers */
    uart_rx_head = 0;
    uart_rx_tail = 0;
    uart_rx_count = 0;  
	uart_state = UART_STATE_READY;
}

void hal_timer_init(void){
    CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER4, ENABLE);
    TIM4_TimeBaseInit(TIM4_PRESCALER_128, 125);
    TIM4_ClearFlag(TIM4_FLAG_UPDATE);
    /* Enable interrupt */
    TIM4_ITConfig(TIM4_IT_UPDATE, ENABLE);
    /* Enable general interrupts */
    enableInterrupts();
}

void system_init(void){
	/* Configure system clock */
    CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);  /* 16MHz clock */

	/* Initialize HAL layers */
	hal_gpio_init();
    hal_timer_init();

	/* Initialize application modules */
	relay_control_init();
	sensor_reader_init();
	/* Initialize UART server for dual-channel communication */
  //  w5500_chip_init();

  //  tcp_server_init(TCP_SERVER_PORT);
    uart_server_init(UART_BAUDRATE);

    /* Setup timer callback for periodic tasks */
    hal_timer_set_callback(timer_callback);
    hal_timer_start();
	hal_delay_ms(500);
}

/* Main Application Loop */
void main_loop(void)
{
    while(1)
    {
		/* Process TCP server communication */
	//	tcp_server_process();

		/* Process UART server communcation*/
		uart_server_process();

        if(GPIO_ReadInputPin(HARDRST_PORT, HARDRST_PIN) == RESET)
        {
            hal_delay_ms(50);
			if (GPIO_ReadInputPin(HARDRST_PORT, HARDRST_PIN) == 0){
				/* Send reset message */
				char msg[] = "RESET, OK\n";
                if(tcp_server_is_connected()){
                   // tcp_server_send((uint8_t *)msg, strlen(msg));
                }
                if (uart_server_is_ready()){
                    uart_server_send((uint8_t *)msg, strlen(msg));
                }
				hal_delay_ms(100);
			}
        }
    }
}



/* Main Function */
int main(void)
{
	system_init();
    main_loop();
    while(1);
}

// void system_init(void)
// main_loop( ka tcp_server_send(
/* Initialize W5500 and TCP server */
    // w5500_chip_init();
    // tcp_server_init(TCP_SERVER_PORT);
// process_axle_counting(void)
// process_axle_counting(
// send_alive_message(
// w5500_chip_init
// iska dekhenge: message_formatter_avcc
// message_formatter_alive
// uart_server_send
// command_parser_execute(
// sensor_reader_update(
// process_axle_counting(
// uart_server_init(
// uart_server_process(

/*
//  //   reg_wizchip_spi_cbfunc(hal_spi_read_byte,hal_spi_write_byte);
 //   reg_wizchip_spiburst_cbfunc(hal_spi_read,hal_spi_write);
 //   reg_wizchip_cs_cbfunc(hal_spi_cs_low,hal_spi_cs_high);
 // inko bhi banana ha w5500 ki library ko change kerna hoga bcz memory bahut use ker rhe ha
*/
//tcp_server_process(
// w5500_chip_init(
// system_init
// tcp_server_init(
// tcp_server_send(