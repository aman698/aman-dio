#include "stm8s_clk.h"


CONST uint8_t HSIDivFactor[4] = {1, 2, 4, 8}; /*!< Holds the different HSI Divider factors */
CONST uint8_t CLKPrescTable[8] = {1, 2, 4, 8, 10, 16, 20, 40}; /*!< Holds the different CLK prescaler values */

void CLK_PeripheralClockConfig(CLK_Peripheral_TypeDef CLK_Peripheral, FunctionalState NewState)
{
  /* Check the parameters */
  assert_param(IS_FUNCTIONALSTATE_OK(NewState));
  assert_param(IS_CLK_PERIPHERAL_OK(CLK_Peripheral));
  
  if (((uint8_t)CLK_Peripheral & (uint8_t)0x10) == 0x00)
  {
    if (NewState != DISABLE)
    {
      /* Enable the peripheral Clock */
      CLK->PCKENR1 |= (uint8_t)((uint8_t)1 << ((uint8_t)CLK_Peripheral & (uint8_t)0x0F));
    }
    else
    {
      /* Disable the peripheral Clock */
      CLK->PCKENR1 &= (uint8_t)(~(uint8_t)(((uint8_t)1 << ((uint8_t)CLK_Peripheral & (uint8_t)0x0F))));
    }
  }
  else
  {
    if (NewState != DISABLE)
    {
      /* Enable the peripheral Clock */
      CLK->PCKENR2 |= (uint8_t)((uint8_t)1 << ((uint8_t)CLK_Peripheral & (uint8_t)0x0F));
    }
    else
    {
      /* Disable the peripheral Clock */
      CLK->PCKENR2 &= (uint8_t)(~(uint8_t)(((uint8_t)1 << ((uint8_t)CLK_Peripheral & (uint8_t)0x0F))));
    }
  }
}

void CLK_HSIPrescalerConfig(CLK_Prescaler_TypeDef HSIPrescaler)
{
  /* check the parameters */
  assert_param(IS_CLK_HSIPRESCALER_OK(HSIPrescaler));
  
  /* Clear High speed internal clock prescaler */
  CLK->CKDIVR &= (uint8_t)(~CLK_CKDIVR_HSIDIV);
  
  /* Set High speed internal clock prescaler */
  CLK->CKDIVR |= (uint8_t)HSIPrescaler;
}

uint32_t CLK_GetClockFreq(void)
{
  uint32_t clockfrequency = 0;
  CLK_Source_TypeDef clocksource = CLK_SOURCE_HSI;
  uint8_t tmp = 0, presc = 0;
  
  /* Get CLK source. */
  clocksource = (CLK_Source_TypeDef)CLK->CMSR;
  
  if (clocksource == CLK_SOURCE_HSI)
  {
    tmp = (uint8_t)(CLK->CKDIVR & CLK_CKDIVR_HSIDIV);
    tmp = (uint8_t)(tmp >> 3);
    presc = HSIDivFactor[tmp];
    clockfrequency = HSI_VALUE / presc;
  }
  else if ( clocksource == CLK_SOURCE_LSI)
  {
    clockfrequency = LSI_VALUE;
  }
  else
  {
    clockfrequency = HSE_VALUE;
  }
  
  return((uint32_t)clockfrequency);
}




/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
