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
 * UART (COM PORT)
 * ========================================================================= */
#define UART_PORT  GPIOD
#define UART_TX_PIN   GPIO_PIN_5

#define UART_PORT  GPIOD
#define UART_RX_PIN   GPIO_PIN_6

/* UART Baudrate */
#define UART_BAUDRATE   115200

#endif