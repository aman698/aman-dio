#include "stm8s_spi.h"

void SPI_DeInit(void)
{
  SPI->CR1    = SPI_CR1_RESET_VALUE;
  SPI->CR2    = SPI_CR2_RESET_VALUE;
  SPI->ICR    = SPI_ICR_RESET_VALUE;
  SPI->SR     = SPI_SR_RESET_VALUE;
  SPI->CRCPR  = SPI_CRCPR_RESET_VALUE;
}

void SPI_Init(SPI_FirstBit_TypeDef FirstBit, SPI_BaudRatePrescaler_TypeDef BaudRatePrescaler, SPI_Mode_TypeDef Mode, SPI_ClockPolarity_TypeDef ClockPolarity, SPI_ClockPhase_TypeDef ClockPhase, SPI_DataDirection_TypeDef Data_Direction, SPI_NSS_TypeDef Slave_Management, uint8_t CRCPolynomial)
{
  /* Check structure elements */
  assert_param(IS_SPI_FIRSTBIT_OK(FirstBit));
  assert_param(IS_SPI_BAUDRATE_PRESCALER_OK(BaudRatePrescaler));
  assert_param(IS_SPI_MODE_OK(Mode));
  assert_param(IS_SPI_POLARITY_OK(ClockPolarity));
  assert_param(IS_SPI_PHASE_OK(ClockPhase));
  assert_param(IS_SPI_DATA_DIRECTION_OK(Data_Direction));
  assert_param(IS_SPI_SLAVEMANAGEMENT_OK(Slave_Management));
  assert_param(IS_SPI_CRC_POLYNOMIAL_OK(CRCPolynomial));
  
  /* Frame Format, BaudRate, Clock Polarity and Phase configuration */
  SPI->CR1 = (uint8_t)((uint8_t)((uint8_t)FirstBit | BaudRatePrescaler) |
                       (uint8_t)((uint8_t)ClockPolarity | ClockPhase));
  
  /* Data direction configuration: BDM, BDOE and RXONLY bits */
  SPI->CR2 = (uint8_t)((uint8_t)(Data_Direction) | (uint8_t)(Slave_Management));
  
  if (Mode == SPI_MODE_MASTER)
  {
    SPI->CR2 |= (uint8_t)SPI_CR2_SSI;
  }
  else
  {
    SPI->CR2 &= (uint8_t)~(SPI_CR2_SSI);
  }
  
  /* Master/Slave mode configuration */
  SPI->CR1 |= (uint8_t)(Mode);
  
  /* CRC configuration */
  SPI->CRCPR = (uint8_t)CRCPolynomial;
}

void SPI_Cmd(FunctionalState NewState)
{
  /* Check function parameters */
  assert_param(IS_FUNCTIONALSTATE_OK(NewState));
  
  if (NewState != DISABLE)
  {
    SPI->CR1 |= SPI_CR1_SPE; /* Enable the SPI peripheral*/
  }
  else
  {
    SPI->CR1 &= (uint8_t)(~SPI_CR1_SPE); /* Disable the SPI peripheral*/
  }
}

void SPI_SendData(uint8_t Data)
{
  SPI->DR = Data; /* Write in the DR register the data to be sent*/
}

uint8_t SPI_ReceiveData(void)
{
  return ((uint8_t)SPI->DR); /* Return the data in the DR register*/
}

FlagStatus SPI_GetFlagStatus(SPI_Flag_TypeDef SPI_FLAG)
{
  FlagStatus status = RESET;
  /* Check parameters */
  assert_param(IS_SPI_FLAGS_OK(SPI_FLAG));
  
  /* Check the status of the specified SPI flag */
  if ((SPI->SR & (uint8_t)SPI_FLAG) != (uint8_t)RESET)
  {
    status = SET; /* SPI_FLAG is set */
  }
  else
  {
    status = RESET; /* SPI_FLAG is reset*/
  }
  
  /* Return the SPI_FLAG status */
  return status;
}
