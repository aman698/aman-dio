#ifndef __W5500_H__
#define __W5500_H__

#include "stm8s.h"

#define _WIZCHIP_IO_MODE_SPI_    0x0200
#define _WIZCHIP_SOCK_NUM_   8
typedef struct __WIZCHIP
{
    uint16_t if_mode;
    uint8_t  id[6];

    struct _CS
    {
        void (*_select)  (void);
        void (*_deselect)(void);
    }CS;

    union _IF
    {
        struct
        {
            uint8_t (*_read_byte)(void);
            void    (*_write_byte)(uint8_t wb);

            void    (*_read_burst)(uint8_t* pBuf, uint16_t len);
            void    (*_write_burst)(uint8_t* pBuf, uint16_t len);

        } _SPI;

    } IF;

} _WIZCHIP;

extern _WIZCHIP WIZCHIP;

void reg_wizchip_cs_cbfunc(void(*cs_sel)(void),
                           void(*cs_desel)(void));

void reg_wizchip_spi_cbfunc(
    uint8_t (*spi_rb)(void),
    void (*spi_wb)(uint8_t wb)
);

void reg_wizchip_spiburst_cbfunc(
    void (*spi_rb)(uint8_t* pBuf, uint16_t len),
    void (*spi_wb)(uint8_t* pBuf, uint16_t len)
);

void wizchip_sw_reset(void);
int8_t wizchip_init(uint8_t* txsize, uint8_t* rxsize);

#endif