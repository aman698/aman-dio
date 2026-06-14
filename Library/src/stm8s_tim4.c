/* Includes ------------------------------------------------------------------*/
#include "stm8s_tim4.h"


void TIM4_TimeBaseInit(TIM4_Prescaler_TypeDef TIM4_Prescaler, uint8_t TIM4_Period)
{
    /* Check TIM4 prescaler value */
    assert_param(IS_TIM4_PRESCALER_OK(TIM4_Prescaler));
    /* Set the Prescaler value */
    TIM4->PSCR = (uint8_t)(TIM4_Prescaler);
    /* Set the Autoreload value */
    TIM4->ARR = (uint8_t)(TIM4_Period);
}

void TIM4_Cmd(FunctionalState NewState)
{
    /* Check the parameters */
    assert_param(IS_FUNCTIONALSTATE_OK(NewState));

    /* set or Reset the CEN Bit */
    if (NewState != DISABLE)
    {
        TIM4->CR1 |= TIM4_CR1_CEN;
    }
    else
    {
        TIM4->CR1 &= (uint8_t)(~TIM4_CR1_CEN);
    }
}

void TIM4_ITConfig(TIM4_IT_TypeDef TIM4_IT, FunctionalState NewState)
{
    /* Check the parameters */
    assert_param(IS_TIM4_IT_OK(TIM4_IT));
    assert_param(IS_FUNCTIONALSTATE_OK(NewState));

    if (NewState != DISABLE)
    {
        /* Enable the Interrupt sources */
        TIM4->IER |= (uint8_t)TIM4_IT;
    }
    else
    {
        /* Disable the Interrupt sources */
        TIM4->IER &= (uint8_t)(~TIM4_IT);
    }
}

void TIM4_ClearFlag(TIM4_FLAG_TypeDef TIM4_FLAG)
{
    /* Check the parameters */
    assert_param(IS_TIM4_GET_FLAG_OK(TIM4_FLAG));

    /* Clear the flags (rc_w0) clear this bit by writing 0. Writing �1� has no effect*/
    TIM4->SR1 = (uint8_t)(~TIM4_FLAG);

}

