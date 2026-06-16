#include "stm8s_conf.h"

typedef struct 
{
    uint8_t di1;
    uint8_t di2;
    uint8_t di3;
    uint8_t di4;
} sensor_state_t;

static sensor_state_t current_state = {0, 0, 0, 0};

void hal_w5500_reset_high(void)
{
    GPIO_WriteHigh(W5500_RST_PORT, W5500_RST_PIN);
}

void delay_ms(uint16_t ms)
{
    uint16_t i,j;

    for(i=0;i<ms;i++)
    {
        for(j=0;j<1600;j++)
        {
            nop();
        }
    }
}
uint8_t hal_spi_byte(uint8_t data)
{
    while (SPI_GetFlagStatus(SPI_FLAG_TXE) == RESET);

    SPI_SendData(data);

    while (SPI_GetFlagStatus(SPI_FLAG_RXNE) == RESET);

    return SPI_ReceiveData();
}
void hal_spi_cs_low(void)
{
    GPIO_WriteLow(W5500_CS_PORT, W5500_CS_PIN);
}

void hal_spi_cs_high(void)
{
    GPIO_WriteHigh(W5500_CS_PORT, W5500_CS_PIN);
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
uint8_t hal_spi_read_byte(void)
{
    return hal_spi_byte(0xFF);
}
void hal_spi_write_byte(uint8_t data)
{
    hal_spi_byte(data);
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
    return (GPIO_ReadInputPin(port, pin) == SET) ? 0 : 1;
}
void hal_relay_set(uint8_t relay_num, uint8_t state)
{
    GPIO_TypeDef *port;
    GPIO_Pin_TypeDef pin;

    switch(relay_num)
    {
        case 1: port = RELAY1_PORT; pin = RELAY1_PIN; break;
        case 2: port = RELAY2_PORT; pin = RELAY2_PIN; break;
        case 3: port = RELAY3_PORT; pin = RELAY3_PIN; break;
        case 4: port = RELAY4_PORT; pin = RELAY4_PIN; break;
        case 5: port = RELAY5_PORT; pin = RELAY5_PIN; break;
        case 6: port = RELAY6_PORT; pin = RELAY6_PIN; break;
        default: return;
    }

    /* Active LOW Relay */
    if(state)
    {
        GPIO_WriteLow(port, pin);   // ON
    }
    else
    {
        GPIO_WriteHigh(port, pin);  // OFF
    }
}
void sensor_reader_update(void){
    current_state.di1 = hal_di_read(1);
    current_state.di2 = hal_di_read(2);
    current_state.di3 = hal_di_read(3);
    current_state.di4 = hal_di_read(4);
}
void relay_off(void){
    hal_relay_set(1,1);
    hal_relay_set(2,1);
    hal_relay_set(3,1);
    hal_relay_set(4,1);
    hal_relay_set(5,1);
    hal_relay_set(6,1);
}
void sensor_reader_init(void)
{
    /* GPIO is already initialized by hal_gpio_init() */
    sensor_reader_update();
}
void w5500_chip_init(void)
{
    uint8_t version;
    uint8_t txsize[8] = {16,0,0,0,0,0,0,0};
    uint8_t rxsize[8] = {16,0,0,0,0,0,0,0};
    /* Reset W5500 */
    GPIO_WriteLow(W5500_RST_PORT, W5500_RST_PIN);
    delay_ms(100);
    hal_w5500_reset_high();
    GPIO_WriteHigh(W5500_RST_PORT, W5500_RST_PIN);
    CLK_PeripheralClockConfig(CLK_PERIPHERAL_SPI, ENABLE);
    GPIO_Init(W5500_SCK_PORT,W5500_SCK_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
    GPIO_Init(W5500_MOSI_PORT,W5500_MOSI_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
    GPIO_Init(W5500_MISO_PORT,W5500_MISO_PIN,GPIO_MODE_IN_FL_NO_IT);
    GPIO_Init(W5500_CS_PORT,W5500_CS_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
    GPIO_WriteHigh(W5500_CS_PORT, W5500_CS_PIN);
    GPIO_Init(W5500_RST_PORT,W5500_RST_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
    SPI_DeInit();
        SPI_Init(
        SPI_FIRSTBIT_MSB,
        SPI_BAUDRATEPRESCALER_4,
        SPI_MODE_MASTER,
        SPI_CLOCKPOLARITY_LOW,
        SPI_CLOCKPHASE_1EDGE,
        SPI_DATADIRECTION_2LINES_FULLDUPLEX,
        SPI_NSS_SOFT,
        0x07
    );

    SPI_Cmd(ENABLE);
    reg_wizchip_spi_cbfunc(hal_spi_read_byte,hal_spi_write_byte);
    reg_wizchip_spiburst_cbfunc(hal_spi_read,hal_spi_write);
    reg_wizchip_cs_cbfunc(hal_spi_cs_low,hal_spi_cs_high);
    wizchip_init(txsize, rxsize);
    version = getVERSIONR();
    if(version != 0x04)
    {
        while(1);
    }
}
void hal_gpio_init(void)
{
    /* ===== Digital Inputs (Sensors) ===== */
    GPIO_Init(DI1_PORT, DI1_PIN, GPIO_MODE_IN_PU_NO_IT);
    GPIO_Init(DI2_PORT, DI2_PIN, GPIO_MODE_IN_PU_NO_IT);
    GPIO_Init(DI3_PORT, DI3_PIN, GPIO_MODE_IN_PU_NO_IT);
    GPIO_Init(DI4_PORT, DI4_PIN, GPIO_MODE_IN_PU_NO_IT);

    GPIO_Init(RELAY1_PORT, RELAY1_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
    GPIO_Init(RELAY2_PORT, RELAY2_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
    GPIO_Init(RELAY3_PORT, RELAY3_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
    GPIO_Init(RELAY4_PORT, RELAY4_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
    GPIO_Init(RELAY5_PORT, RELAY5_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
    GPIO_Init(RELAY6_PORT, RELAY6_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);

    /* All OFF */
    hal_relay_set(1,0);
    hal_relay_set(2,0);
    hal_relay_set(3,0);
    hal_relay_set(4,0);
    hal_relay_set(5,0);
    hal_relay_set(6,0);
    delay_ms(3000);
    GPIO_Init(W5500_RST_PORT, W5500_RST_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
    GPIO_Init(HARDRST_PORT, HARDRST_PIN, GPIO_MODE_IN_PU_NO_IT);
    hal_w5500_reset_high();
}

void system_init(void)
{
    CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);
    hal_gpio_init();
    relay_off();
    sensor_reader_init();
    w5500_chip_init();
}

void main_loop(void)
{
    while(1)
    {
    }
}
int main(void)
{
    system_init();
    main_loop();

    while(1);
}