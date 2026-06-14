#include "w5500.h"

/* Default SPI functions */

static void wizchip_cs_select(void)
{
}

static void wizchip_cs_deselect(void)
{
}

static uint8_t wizchip_spi_readbyte(void)
{
    return 0;
}

static void wizchip_spi_writebyte(uint8_t wb)
{
    (void)wb;
}

static void wizchip_spi_readburst(uint8_t* pBuf, uint16_t len)
{
    (void)pBuf;
    (void)len;
}

static void wizchip_spi_writeburst(uint8_t* pBuf, uint16_t len)
{
    (void)pBuf;
    (void)len;
}

/* Global WIZCHIP object */

_WIZCHIP WIZCHIP =
{
    _WIZCHIP_IO_MODE_SPI_,
    { 'W','5','5','0','0',0 }
};

void reg_wizchip_cs_cbfunc(void(*cs_sel)(void),
                           void(*cs_desel)(void))
{
    if((cs_sel == 0) || (cs_desel == 0))
    {
        WIZCHIP.CS._select   = wizchip_cs_select;
        WIZCHIP.CS._deselect = wizchip_cs_deselect;
    }
    else
    {
        WIZCHIP.CS._select   = cs_sel;
        WIZCHIP.CS._deselect = cs_desel;
    }
}

/* Register SPI byte callbacks */

void reg_wizchip_spi_cbfunc(
    uint8_t (*spi_rb)(void),
    void (*spi_wb)(uint8_t wb)
)
{
    if((spi_rb == 0) || (spi_wb == 0))
    {
        WIZCHIP.IF._SPI._read_byte  = wizchip_spi_readbyte;
        WIZCHIP.IF._SPI._write_byte = wizchip_spi_writebyte;
    }
    else
    {
        WIZCHIP.IF._SPI._read_byte  = spi_rb;
        WIZCHIP.IF._SPI._write_byte = spi_wb;
    }
}

/* Register SPI burst callbacks */

void reg_wizchip_spiburst_cbfunc(
    void (*spi_rb)(uint8_t* pBuf, uint16_t len),
    void (*spi_wb)(uint8_t* pBuf, uint16_t len)
)
{
    if((spi_rb == 0) || (spi_wb == 0))
    {
        WIZCHIP.IF._SPI._read_burst  = wizchip_spi_readburst;
        WIZCHIP.IF._SPI._write_burst = wizchip_spi_writeburst;
    }
    else
    {
        WIZCHIP.IF._SPI._read_burst  = spi_rb;
        WIZCHIP.IF._SPI._write_burst = spi_wb;
    }
}


int8_t wizchip_init(uint8_t* txsize, uint8_t* rxsize){
    int8_t i;
    int8_t tmp = 0;
    if(txsize){
        tmp = 0;
        for(i = 0; i < _WIZCHIP_SOCK_NUM_; i++){
            tmp += txsize[i];
            if(tmp > 16) return -1;
        }
        for(i = 0; i < _WIZCHIP_SOCK_NUM_; i++){
            setSn_TXBUF_SIZE(i, txsize[i]);
        }
    }
}