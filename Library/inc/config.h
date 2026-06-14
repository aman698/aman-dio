#ifndef __CONFIG_H
#define __CONFIG_H

#include "stm8s.h"

/* ============================================================================
 * GPIO Pin Configuration
 * ========================================================================= */

 /* Digital Inputs (Vehicle sensors ) */

/* Digital Inputs (Vehicle sensors) */
#define DI1_PORT        GPIOD
#define DI1_PIN         GPIO_PIN_2
#define DI2_PORT        GPIOD
#define DI2_PIN         GPIO_PIN_3
#define DI3_PORT        GPIOD
#define DI3_PIN         GPIO_PIN_4
#define DI4_PORT        GPIOD
#define DI4_PIN         GPIO_PIN_7

/* Relay Outputs */
#define RELAY1_PORT     GPIOB
#define RELAY1_PIN      GPIO_PIN_3
#define RELAY2_PORT     GPIOB
#define RELAY2_PIN      GPIO_PIN_2
#define RELAY3_PORT     GPIOB
#define RELAY3_PIN      GPIO_PIN_1
#define RELAY4_PORT     GPIOB
#define RELAY4_PIN      GPIO_PIN_0
#define RELAY5_PORT     GPIOC
#define RELAY5_PIN      GPIO_PIN_3
#define RELAY6_PORT     GPIOC
#define RELAY6_PIN      GPIO_PIN_4

/* Hardware Reset Input */
#define HARDRST_PORT    GPIOB
#define HARDRST_PIN     GPIO_PIN_7

/* ============================================================================
 * W5500 SPI Configuration
 * ========================================================================= */

/* SPI Interface (SPI1 on STM8S003K3) */
#define W5500_SPI       SPI1

/* W5500 SPI Pins */
#define W5500_SCK_PORT  GPIOC
#define W5500_SCK_PIN   GPIO_PIN_5

#define W5500_MOSI_PORT GPIOC
#define W5500_MOSI_PIN  GPIO_PIN_6

#define W5500_MISO_PORT GPIOC
#define W5500_MISO_PIN  GPIO_PIN_7

/* W5500 Chip Select */
#define W5500_CS_PORT   GPIOA
#define W5500_CS_PIN    GPIO_PIN_3

/* W5500 Reset */
#define W5500_RST_PORT  GPIOE
#define W5500_RST_PIN   GPIO_PIN_5

/* W5500 Interrupt */
#define W5500_INT_PORT  GPIOF
#define W5500_INT_PIN   GPIO_PIN_4

/* ============================================================================
 * Network Configuration
 * ========================================================================= */

/* MAC Address */
#define MAC_ADDR        {0x00, 0x08, 0xDC, 0x12, 0x34, 0x56}

/* IP Address (Static or DHCP) */
#define USE_DHCP        0   /* 0 = Static IP, 1 = DHCP */
#define IP_ADDR         {192, 168, 1, 100}
#define SUBNET_MASK     {255, 255, 255, 0}
#define GATEWAY_ADDR    {192, 168, 1, 1}
#define DNS_ADDR        {8, 8, 8, 8}

/* TCP Server Configuration */
#define TCP_SERVER_PORT 5000
#define TCP_MAX_CLIENTS 1
#define TCP_TIMEOUT_MS  5000

/* ============================================================================
 * Device Configuration
 * ========================================================================= */

/* Land ID (Identifier for this device) */
#define DEVICE_LANID    125

/* Serial Communication Parameters */
#define SERIAL_BAUDRATE 115200

/* System Timer Configuration */
#define TIMER_TICK_MS   10      /* 10ms timer tick */
#define ALIVE_INTERVAL  500     /* Send ALIVE message every 500ms */
#define SENSOR_READ_INTERVAL 50 /* Read sensors every 50ms */

/* Message Buffer Sizes */
#define MSG_BUFFER_SIZE 32
#define TCP_RX_BUFFER   32
#define TCP_TX_BUFFER   32


/* ============================================================================
 * UART (COM PORT)
 * ========================================================================= */
#define UART_PORT  GPIOD
#define UART_TX_PIN   GPIO_PIN_5

#define UART_PORT  GPIOD
#define UART_RX_PIN   GPIO_PIN_6

/* UART Baudrate */
#define UART_BAUDRATE   115200


/* ============================================================================
 * Feature Flags
 * ========================================================================= */

#define ENABLE_DEBUG    1       /* Enable debug output via UART */
#define ENABLE_WATCHDOG 0       /* Enable IWDG watchdog */
#define ENABLE_UART_SERVER 1    /* Enable dual-channel UART + TCP communication */


#endif