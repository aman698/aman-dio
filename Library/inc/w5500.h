#ifndef __W5500_H__
#define __W5500_H__

#include "stm8s.h"

#define WIZCHIP_SREG_BLOCK(N)       (1+4*N) //< Socket N register block
#define _WIZCHIP_IO_MODE_SPI_    0x0200
#define Sn_MR_TCP                    0x01
#define SOCK_ANY_PORT_NUM  0xC000
static uint16_t sock_any_port = SOCK_ANY_PORT_NUM;
#define Sn_CR_CLOSE                  0x10
#define SIPR        0x000F
#define Sn_MR_ND                     0x20
#define SOCK_OK               1
#define SOCK_CLOSED                  0x00
#define _WIZCHIP_SOCK_NUM_   8
#define _W5500_SPI_WRITE_			   (0x01 << 2) //< SPI interface Write operation in Control Phase
#define Sn_RXBUF_SIZE(N)   (_W5500_IO_BASE_ + (0x001E << 8) + (WIZCHIP_SREG_BLOCK(N) << 3))
#define Sn_TXBUF_SIZE(N)   (_W5500_IO_BASE_ + (0x001F << 8) + (WIZCHIP_SREG_BLOCK(N) << 3))
#define _W5500_IO_BASE_              0x00000000
#define VERSIONR    0x0039
#define SOCK_ERROR            0        
#define SOCKERR_SOCKNUM       (SOCK_ERROR - 1)  
#define SOCKERR_SOCKFLAG      (SOCK_ERROR - 6)     ///< Invalid socket flag
#define _W5500_SPI_READ_			   (0x00 << 2) //< SPI interface Read operation in Control Phase
#define getSIPR(sipr) WIZCHIP_READ_BUF(SIPR, sipr, 4)
#define SOCKERR_SOCKMODE      (SOCK_ERROR - 5) 
#define SOCKERR_SOCKINIT      (SOCK_ERROR - 3) 
#define Sn_CR_LISTEN                 0x02
#define Sn_CR(N)           (_W5500_IO_BASE_ + (0x0001 << 8) + (WIZCHIP_SREG_BLOCK(N) << 3))
#define SOCKERR_SOCKCLOSED    (SOCK_ERROR - 4)  
#define SOCK_LISTEN                  0x14
#define SOCK_INIT                    0x13
#define SOCKERR_TIMEOUT       (SOCK_ERROR - 13)
/* Default SPI functions */
#define _W5500_SPI_VDM_OP_          0x00
#define PACK_COMPLETED           0x00 
#define SF_IO_NONBLOCK           0x01 
#define Sn_CR_OPEN                   0x01    
#define SF_IO_NONBLOCK           0x01
#define SF_TCP_NODELAY         (Sn_MR_ND)   
#define Sn_CR_RECV                   0x40
#define SOCK_CLOSE_WAIT              0x1C
#define SOCKERR_SOCKSTATUS    (SOCK_ERROR - 7)
#define Sn_CR_SEND                   0x20
#define Sn_IR_SENDOK                 0x10
#define SOCK_BUSY             0  
#define Sn_IR_TIMEOUT                0x08
#define SOCKERR_DATALEN       (SOCK_ERROR - 14) 
#define Sn_MR(N)           (_W5500_IO_BASE_ + (0x0000 << 8) + (WIZCHIP_SREG_BLOCK(N) << 3))
#define setSn_TXBUF_SIZE(sn, txbufsize) WIZCHIP_WRITE(Sn_TXBUF_SIZE(sn), txbufsize)
#define setSn_RXBUF_SIZE(sn, rxbufsize) WIZCHIP_WRITE(Sn_RXBUF_SIZE(sn),rxbufsize)

#define getSn_CR(sn) WIZCHIP_READ(Sn_CR(sn))
#define getSn_MR(sn) WIZCHIP_READ(Sn_MR(sn))
#define Sn_SR(N)           (_W5500_IO_BASE_ + (0x0003 << 8) + (WIZCHIP_SREG_BLOCK(N) << 3))
#define getSn_SR(sn) WIZCHIP_READ(Sn_SR(sn))
#define setSn_CR(sn, cr) WIZCHIP_WRITE(Sn_CR(sn), cr)
#define Sn_RX_RSR(N)       (_W5500_IO_BASE_ + (0x0026 << 8) + (WIZCHIP_SREG_BLOCK(N) << 3))
#define getSn_RXBUF_SIZE(sn) WIZCHIP_READ(Sn_RXBUF_SIZE(sn))
#define getSn_RxMAX(sn) (((uint16_t)getSn_RXBUF_SIZE(sn)) << 10)		

#define CHECK_SOCKNUM()                        \
    do {                                       \
        if (sn >= _WIZCHIP_SOCK_NUM_)          \
            return SOCKERR_SOCKNUM;            \
    } while (0)

#define CHECK_SOCKMODE(mode)                   \
    do {                                       \
        if ((getSn_MR(sn) & 0x0F) != (mode))   \
            return SOCKERR_SOCKMODE;           \
    } while (0)

#define CHECK_SOCKINIT()                       \
    do {                                       \
        if (getSn_SR(sn) != SOCK_INIT)         \
            return SOCKERR_SOCKINIT;           \
    } while (0)
#define CHECK_SOCKDATA()   \
   do{                     \
      if(len == 0) return SOCKERR_DATALEN;   \
   }while(0);              \

#define getVERSIONR()          WIZCHIP_READ(VERSIONR)
#define setSn_IR(sn, ir) WIZCHIP_WRITE(Sn_IR(sn), (ir & 0x1F))
#define SOCK_ESTABLISHED             0x17
#define WIZCHIP_CRITICAL_ENTER()  WIZCHIP.CRIS._enter()
#define WIZCHIP_CRITICAL_EXIT()   WIZCHIP.CRIS._exit()
#define Sn_IR(N)           (_W5500_IO_BASE_ + (0x0002 << 8) + (WIZCHIP_SREG_BLOCK(N) << 3))
#define setSn_MR(sn, mr) WIZCHIP_WRITE(Sn_MR(sn),mr)
#define Sn_PORT(N)         (_W5500_IO_BASE_ + (0x0004 << 8) + (WIZCHIP_SREG_BLOCK(N) << 3))
#define WIZCHIP_OFFSET_INC(ADDR, N)    (ADDR + (N<<8)) //< Increase offset address
#define setSn_PORT(sn, port)  { \
		WIZCHIP_WRITE(Sn_PORT(sn),   (uint8_t)(port >> 8)); \
		WIZCHIP_WRITE(WIZCHIP_OFFSET_INC(Sn_PORT(sn),1), (uint8_t) port); \
	}
#define Sn_TX_WR(N)        (_W5500_IO_BASE_ + (0x0024 << 8) + (WIZCHIP_SREG_BLOCK(N) << 3))
#define Sn_TX_FSR(N)       (_W5500_IO_BASE_ + (0x0020 << 8) + (WIZCHIP_SREG_BLOCK(N) << 3))
#define Sn_RX_RD(N)        (_W5500_IO_BASE_ + (0x0028 << 8) + (WIZCHIP_SREG_BLOCK(N) << 3))
#define WIZCHIP_TXBUF_BLOCK(N)      (2+4*N)
#define WIZCHIP_RXBUF_BLOCK(N)      (3+4*N) //< Socket N Rx buffer address block
#define getSn_TX_WR(sn) (((uint16_t)WIZCHIP_READ(Sn_TX_WR(sn)) << 8) + WIZCHIP_READ(WIZCHIP_OFFSET_INC(Sn_TX_WR(sn),1)))		
#define setSn_TX_WR(sn, txwr) { \
		WIZCHIP_WRITE(Sn_TX_WR(sn),   (uint8_t)(txwr>>8)); \
		WIZCHIP_WRITE(WIZCHIP_OFFSET_INC(Sn_TX_WR(sn),1), (uint8_t) txwr); \
		}
#define getSn_RX_RD(sn) (((uint16_t)WIZCHIP_READ(Sn_RX_RD(sn)) << 8) + WIZCHIP_READ(WIZCHIP_OFFSET_INC(Sn_RX_RD(sn),1)))		
#define setSn_RX_RD(sn, rxrd) { \
		WIZCHIP_WRITE(Sn_RX_RD(sn),   (uint8_t)(rxrd>>8)); \
		WIZCHIP_WRITE(WIZCHIP_OFFSET_INC(Sn_RX_RD(sn),1), (uint8_t) rxrd); \
	}
#define getSn_TXBUF_SIZE(sn) WIZCHIP_READ(Sn_TXBUF_SIZE(sn))
#define getSn_TxMAX(sn) (((uint16_t)getSn_TXBUF_SIZE(sn)) << 10)		
#define getSn_IR(sn) (WIZCHIP_READ(Sn_IR(sn)) & 0x1F)

typedef struct __WIZCHIP
{
    uint16_t if_mode;
    uint8_t  id[6];

    struct _CRIS
    {
        void (*_enter) (void);
        void (*_exit) (void);
    }CRIS;

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



void WIZCHIP_WRITE(uint32_t AddrSel, uint8_t wb );
uint8_t WIZCHIP_READ(uint32_t AddrSel);
void WIZCHIP_READ_BUF(uint32_t AddrSel, uint8_t* pBuf, uint16_t len);
void reg_wizchip_cs_cbfunc(void(*cs_sel)(void),
                           void(*cs_desel)(void));
uint16_t getSn_TX_FSR(uint8_t sn);
uint16_t getSn_RX_RSR(uint8_t sn);
void WIZCHIP_WRITE_BUF(uint32_t AddrSel, uint8_t* pBuf, uint16_t len);
void reg_wizchip_spi_cbfunc(
    uint8_t (*spi_rb)(void),
    void (*spi_wb)(uint8_t wb)
);

void reg_wizchip_spiburst_cbfunc(
    void (*spi_rb)(uint8_t* pBuf, uint16_t len),
    void (*spi_wb)(uint8_t* pBuf, uint16_t len)
);
void wiz_send_data(uint8_t sn, uint8_t *wizdata, uint16_t len);

void wiz_recv_data(uint8_t sn, uint8_t *wizdata, uint16_t len);
void wizchip_sw_reset(void);
int8_t wizchip_init(uint8_t* txsize, uint8_t* rxsize);
int8_t socket(uint8_t sn, uint8_t protocol, uint16_t port, uint8_t flag);
int8_t  close(uint8_t sn);
int8_t  listen(uint8_t sn);
int32_t recv(uint8_t sn, uint8_t *buf, uint16_t len);
int32_t send(uint8_t sn, uint8_t * buf, uint16_t len);

#endif