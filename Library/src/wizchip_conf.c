#include <stddef.h>
#include "wizchip_conf.h"

void 	  wizchip_cris_enter(void)           {}
void 	  wizchip_cris_exit(void)          {}
void 	wizchip_cs_select(void)            {}
void 	wizchip_cs_deselect(void)          {}
iodata_t wizchip_bus_readdata(uint32_t AddrSel) { return * ((volatile iodata_t *)((ptrdiff_t) AddrSel)); }
void 	wizchip_bus_writedata(uint32_t AddrSel, iodata_t wb)  { *((volatile iodata_t*)((ptrdiff_t)AddrSel)) = wb; }
uint8_t wizchip_spi_readbyte(void)        {return 0;}
void 	wizchip_spi_writebyte(uint8_t wb) {}
void 	wizchip_spi_readburst(uint8_t* pBuf, uint16_t len) 	{}
void 	wizchip_spi_writeburst(uint8_t* pBuf, uint16_t len) {}

_WIZCHIP  WIZCHIP =
      {
      _WIZCHIP_IO_MODE_,
      _WIZCHIP_ID_ ,
      wizchip_cris_enter,
      wizchip_cris_exit,
      wizchip_cs_select,
      wizchip_cs_deselect,
      wizchip_bus_readdata,
      wizchip_bus_writedata,
      };


void reg_wizchip_cs_cbfunc(void(*cs_sel)(void), void(*cs_desel)(void))
{
   if(!cs_sel || !cs_desel)
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

static uint8_t    _DNS_[4];      // DNS server ip address
static dhcp_mode  _DHCP_;        // DHCP mode

void reg_wizchip_spi_cbfunc(uint8_t (*spi_rb)(void), void (*spi_wb)(uint8_t wb))
{
   while(!(WIZCHIP.if_mode & _WIZCHIP_IO_MODE_SPI_));
   
   if(!spi_rb || !spi_wb)
   {
      WIZCHIP.IF._SPI._read_byte   = wizchip_spi_readbyte;
      WIZCHIP.IF._SPI._write_byte  = wizchip_spi_writebyte;
   }
   else
   {
      WIZCHIP.IF._SPI._read_byte   = spi_rb;
      WIZCHIP.IF._SPI._write_byte  = spi_wb;
   }
}

// 20140626 Eric Added for SPI burst operations
void reg_wizchip_spiburst_cbfunc(void (*spi_rb)(uint8_t* pBuf, uint16_t len), void (*spi_wb)(uint8_t* pBuf, uint16_t len))
{
   while(!(WIZCHIP.if_mode & _WIZCHIP_IO_MODE_SPI_));

   if(!spi_rb || !spi_wb)
   {
      WIZCHIP.IF._SPI._read_burst   = wizchip_spi_readburst;
      WIZCHIP.IF._SPI._write_burst  = wizchip_spi_writeburst;
   }
   else
   {
      WIZCHIP.IF._SPI._read_burst   = spi_rb;
      WIZCHIP.IF._SPI._write_burst  = spi_wb;
   }
}

void wizchip_sw_reset(void)
{
   uint8_t gw[4], sn[4], sip[4];
   uint8_t mac[6];
//A20150601
#if _WIZCHIP_IO_MODE_  == _WIZCHIP_IO_MODE_BUS_INDIR_
   uint16_t mr = (uint16_t)getMR();
   setMR(mr | MR_IND);
#endif
//
   getSHAR(mac);
   getGAR(gw);  getSUBR(sn);  getSIPR(sip);
   setMR(MR_RST);
   getMR(); // for delay
//A2015051 : For indirect bus mode 
#if _WIZCHIP_IO_MODE_  == _WIZCHIP_IO_MODE_BUS_INDIR_
   setMR(mr | MR_IND);
#endif
//
   setSHAR(mac);
   setGAR(gw);
   setSUBR(sn);
   setSIPR(sip);
}

int8_t wizchip_init(uint8_t* txsize, uint8_t* rxsize)
{
   int8_t i;
   int8_t tmp = 0;
   wizchip_sw_reset();
   if(txsize)
   {
      tmp = 0;
   //M20150601 : For integrating with W5300  
      for(i = 0 ; i < _WIZCHIP_SOCK_NUM_; i++)
      {
         tmp += txsize[i];
         if(tmp > 16) return -1;
      }
      for(i = 0 ; i < _WIZCHIP_SOCK_NUM_; i++)
         setSn_TXBUF_SIZE(i, txsize[i]);
   }
   if(rxsize)
   {
      tmp = 0;        
      for(i = 0 ; i < _WIZCHIP_SOCK_NUM_; i++)
      {
         tmp += rxsize[i];
         if(tmp > 16) return -1;
      }
      for(i = 0 ; i < _WIZCHIP_SOCK_NUM_; i++)
         setSn_RXBUF_SIZE(i, rxsize[i]);
   }
   return 0;
}


