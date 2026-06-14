
#ifndef __STM8S_SPI_H
#define __STM8S_SPI_H

#include "stm8s.h"

typedef enum {
  SPI_DATADIRECTION_2LINES_FULLDUPLEX = (uint8_t)0x00, /*!< 2-line uni-directional data mode enable */
  SPI_DATADIRECTION_2LINES_RXONLY     = (uint8_t)0x04, /*!< Receiver only in 2 line uni-directional data mode */
  SPI_DATADIRECTION_1LINE_RX          = (uint8_t)0x80, /*!< Receiver only in 1 line bi-directional data mode */
  SPI_DATADIRECTION_1LINE_TX          = (uint8_t)0xC0  /*!< Transmit only in 1 line bi-directional data mode */
} SPI_DataDirection_TypeDef;


typedef enum
{
  SPI_NSS_SOFT  = (uint8_t)0x02, /*!< Software slave management disabled */
  SPI_NSS_HARD  = (uint8_t)0x00  /*!< Software slave management enabled */
} SPI_NSS_TypeDef;



typedef enum {
  SPI_DIRECTION_RX = (uint8_t)0x00, /*!< Selects Rx receive direction in bi-directional mode */
  SPI_DIRECTION_TX = (uint8_t)0x01  /*!< Selects Tx transmission direction in bi-directional mode */
} SPI_Direction_TypeDef;

typedef enum {
  SPI_MODE_MASTER = (uint8_t)0x04, /*!< SPI Master configuration */
  SPI_MODE_SLAVE  = (uint8_t)0x00  /*!< SPI Slave configuration */
} SPI_Mode_TypeDef;
typedef enum {
  SPI_BAUDRATEPRESCALER_2   = (uint8_t)0x00, /*!< SPI frequency = frequency(CPU)/2 */
  SPI_BAUDRATEPRESCALER_4   = (uint8_t)0x08, /*!< SPI frequency = frequency(CPU)/4 */
  SPI_BAUDRATEPRESCALER_8   = (uint8_t)0x10, /*!< SPI frequency = frequency(CPU)/8 */
  SPI_BAUDRATEPRESCALER_16  = (uint8_t)0x18, /*!< SPI frequency = frequency(CPU)/16 */
  SPI_BAUDRATEPRESCALER_32  = (uint8_t)0x20, /*!< SPI frequency = frequency(CPU)/32 */
  SPI_BAUDRATEPRESCALER_64  = (uint8_t)0x28, /*!< SPI frequency = frequency(CPU)/64 */
  SPI_BAUDRATEPRESCALER_128 = (uint8_t)0x30, /*!< SPI frequency = frequency(CPU)/128 */
  SPI_BAUDRATEPRESCALER_256 = (uint8_t)0x38  /*!< SPI frequency = frequency(CPU)/256 */
} SPI_BaudRatePrescaler_TypeDef;


typedef enum {
  SPI_CLOCKPOLARITY_LOW  = (uint8_t)0x00, /*!< Clock to 0 when idle */
  SPI_CLOCKPOLARITY_HIGH = (uint8_t)0x02  /*!< Clock to 1 when idle */
} SPI_ClockPolarity_TypeDef;

typedef enum {
  SPI_CLOCKPHASE_1EDGE = (uint8_t)0x00, /*!< The first clock transition is the first data capture edge */
  SPI_CLOCKPHASE_2EDGE = (uint8_t)0x01  /*!< The second clock transition is the first data capture edge */
} SPI_ClockPhase_TypeDef;
typedef enum {
  SPI_FIRSTBIT_MSB = (uint8_t)0x00, /*!< MSB bit will be transmitted first */
  SPI_FIRSTBIT_LSB = (uint8_t)0x80  /*!< LSB bit will be transmitted first */
} SPI_FirstBit_TypeDef;


typedef enum {
  SPI_CRC_RX = (uint8_t)0x00, /*!< Select Tx CRC register */
  SPI_CRC_TX = (uint8_t)0x01  /*!< Select Rx CRC register */
} SPI_CRC_TypeDef;


typedef enum {
  SPI_FLAG_BSY    = (uint8_t)0x80, /*!< Busy flag */
  SPI_FLAG_OVR    = (uint8_t)0x40, /*!< Overrun flag */
  SPI_FLAG_MODF   = (uint8_t)0x20, /*!< Mode fault */
  SPI_FLAG_CRCERR = (uint8_t)0x10, /*!< CRC error flag */
  SPI_FLAG_WKUP   = (uint8_t)0x08, /*!< Wake-up flag */
  SPI_FLAG_TXE    = (uint8_t)0x02, /*!< Transmit buffer empty */
  SPI_FLAG_RXNE   = (uint8_t)0x01  /*!< Receive buffer empty */
} SPI_Flag_TypeDef;

typedef enum
{
  SPI_IT_WKUP   = (uint8_t)0x34,  /*!< Wake-up interrupt*/
  SPI_IT_OVR   = (uint8_t)0x65,  /*!< Overrun interrupt*/
  SPI_IT_MODF   = (uint8_t)0x55,  /*!< Mode fault interrupt*/
  SPI_IT_CRCERR = (uint8_t)0x45,  /*!< CRC error interrupt*/
  SPI_IT_TXE    = (uint8_t)0x17,  /*!< Transmit buffer empty interrupt*/
  SPI_IT_RXNE   = (uint8_t)0x06,   /*!< Receive buffer not empty interrupt*/
  SPI_IT_ERR    = (uint8_t)0x05   /*!< Error interrupt*/
} SPI_IT_TypeDef;

#define IS_SPI_DATA_DIRECTION_OK(MODE) (((MODE) == SPI_DATADIRECTION_2LINES_FULLDUPLEX) || \
                                        ((MODE) == SPI_DATADIRECTION_2LINES_RXONLY) || \
                                        ((MODE) == SPI_DATADIRECTION_1LINE_RX) || \
                                        ((MODE) == SPI_DATADIRECTION_1LINE_TX))


#define IS_SPI_DIRECTION_OK(DIRECTION) (((DIRECTION) == SPI_DIRECTION_RX) || \
                                        ((DIRECTION) == SPI_DIRECTION_TX))


#define IS_SPI_SLAVEMANAGEMENT_OK(NSS) (((NSS) == SPI_NSS_SOFT) || \
                                        ((NSS) == SPI_NSS_HARD))


#define IS_SPI_CRC_POLYNOMIAL_OK(POLYNOMIAL) ((POLYNOMIAL) > (uint8_t)0x00)

#define IS_SPI_MODE_OK(MODE) (((MODE) == SPI_MODE_MASTER) || \
                              ((MODE) == SPI_MODE_SLAVE))

#define IS_SPI_BAUDRATE_PRESCALER_OK(PRESCALER) (((PRESCALER) == SPI_BAUDRATEPRESCALER_2) || \
    ((PRESCALER) == SPI_BAUDRATEPRESCALER_4) || \
    ((PRESCALER) == SPI_BAUDRATEPRESCALER_8) || \
    ((PRESCALER) == SPI_BAUDRATEPRESCALER_16) || \
    ((PRESCALER) == SPI_BAUDRATEPRESCALER_32) || \
    ((PRESCALER) == SPI_BAUDRATEPRESCALER_64) || \
    ((PRESCALER) == SPI_BAUDRATEPRESCALER_128) || \
    ((PRESCALER) == SPI_BAUDRATEPRESCALER_256))


#define IS_SPI_POLARITY_OK(CLKPOL) (((CLKPOL) == SPI_CLOCKPOLARITY_LOW) || \
                                    ((CLKPOL) == SPI_CLOCKPOLARITY_HIGH))

#define IS_SPI_PHASE_OK(CLKPHA) (((CLKPHA) == SPI_CLOCKPHASE_1EDGE) || \
                                 ((CLKPHA) == SPI_CLOCKPHASE_2EDGE))

#define IS_SPI_FIRSTBIT_OK(BIT) (((BIT) == SPI_FIRSTBIT_MSB) || \
                                 ((BIT) == SPI_FIRSTBIT_LSB))


#define IS_SPI_CRC_OK(CRC) (((CRC) == SPI_CRC_TX) || \
                            ((CRC) == SPI_CRC_RX))


#define IS_SPI_FLAGS_OK(FLAG) (((FLAG) == SPI_FLAG_OVR) || \
                               ((FLAG) == SPI_FLAG_MODF) || \
                               ((FLAG) == SPI_FLAG_CRCERR) || \
                               ((FLAG) == SPI_FLAG_WKUP) || \
                               ((FLAG) == SPI_FLAG_TXE) || \
                               ((FLAG) == SPI_FLAG_RXNE) || \
                               ((FLAG) == SPI_FLAG_BSY))


#define IS_SPI_CLEAR_FLAGS_OK(FLAG) (((FLAG) == SPI_FLAG_CRCERR) || \
                                     ((FLAG) == SPI_FLAG_WKUP))


#define IS_SPI_CONFIG_IT_OK(Interrupt) (((Interrupt) == SPI_IT_TXE)  || \
                                        ((Interrupt) == SPI_IT_RXNE)  || \
                                        ((Interrupt) == SPI_IT_ERR) || \
                                        ((Interrupt) == SPI_IT_WKUP))

#define IS_SPI_GET_IT_OK(ITPendingBit) (((ITPendingBit) == SPI_IT_OVR)  || \
                                        ((ITPendingBit) == SPI_IT_MODF) || \
                                        ((ITPendingBit) == SPI_IT_CRCERR) || \
                                        ((ITPendingBit) == SPI_IT_WKUP) || \
                                        ((ITPendingBit) == SPI_IT_TXE)  || \
                                        ((ITPendingBit) == SPI_IT_RXNE))


#define IS_SPI_CLEAR_IT_OK(ITPendingBit) (((ITPendingBit) == SPI_IT_CRCERR) || \
    ((ITPendingBit) == SPI_IT_WKUP))


void SPI_DeInit(void);
void SPI_Init(SPI_FirstBit_TypeDef FirstBit, 
              SPI_BaudRatePrescaler_TypeDef BaudRatePrescaler, 
              SPI_Mode_TypeDef Mode, SPI_ClockPolarity_TypeDef ClockPolarity, 
              SPI_ClockPhase_TypeDef ClockPhase, 
              SPI_DataDirection_TypeDef Data_Direction, 
              SPI_NSS_TypeDef Slave_Management, uint8_t CRCPolynomial);
void SPI_Cmd(FunctionalState NewState);
void SPI_SendData(uint8_t Data);
uint8_t SPI_ReceiveData(void);
FlagStatus SPI_GetFlagStatus(SPI_Flag_TypeDef SPI_FLAG);

#endif 
