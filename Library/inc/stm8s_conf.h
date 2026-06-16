#ifndef __STM8S_CONF_H
#define __STM8S_CONF_H

#include "stm8s.h"
#include "config.h"
#include "stm8s_clk.h"
#include "stm8s_gpio.h"
#include "stm8s_spi.h"
#include "w5500.h"
#define USE_FULL_ASSERT 0

#if USE_FULL_ASSERT
void assert_failed(uint8_t* file, uint32_t line);
#define assert_param(expr) \
((expr) ? (void)0 : assert_failed((uint8_t*)__FILE__, __LINE__))
#else
#define assert_param(expr) ((void)0)
#endif

#endif