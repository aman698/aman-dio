#include "w5500.h"

static uint16_t sock_remained_size[_WIZCHIP_SOCK_NUM_] = {0,0,};
uint8_t  sock_pack_info[_WIZCHIP_SOCK_NUM_] = {0,};
static uint16_t sock_is_sending = 0;
static uint16_t sock_io_mode = 0;


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

uint8_t  WIZCHIP_READ(uint32_t AddrSel)
{
   uint8_t ret;
   uint8_t spi_data[3];

   WIZCHIP_CRITICAL_ENTER();
   WIZCHIP.CS._select();

   AddrSel |= (_W5500_SPI_READ_ | _W5500_SPI_VDM_OP_);

   if(!WIZCHIP.IF._SPI._read_burst || !WIZCHIP.IF._SPI._write_burst) 	// byte operation
   {
	    WIZCHIP.IF._SPI._write_byte((AddrSel & 0x00FF0000) >> 16);
		WIZCHIP.IF._SPI._write_byte((AddrSel & 0x0000FF00) >>  8);
		WIZCHIP.IF._SPI._write_byte((AddrSel & 0x000000FF) >>  0);
   }
   else																// burst operation
   {
		spi_data[0] = (AddrSel & 0x00FF0000) >> 16;
		spi_data[1] = (AddrSel & 0x0000FF00) >> 8;
		spi_data[2] = (AddrSel & 0x000000FF) >> 0;
		WIZCHIP.IF._SPI._write_burst(spi_data, 3);
   }
   ret = WIZCHIP.IF._SPI._read_byte();

   WIZCHIP.CS._deselect();
   WIZCHIP_CRITICAL_EXIT();
   return ret;
}

void WIZCHIP_WRITE(uint32_t AddrSel, uint8_t wb )
{
   uint8_t spi_data[4];

   WIZCHIP_CRITICAL_ENTER();
   WIZCHIP.CS._select();

   AddrSel |= (_W5500_SPI_WRITE_ | _W5500_SPI_VDM_OP_);

   //if(!WIZCHIP.IF._SPI._read_burst || !WIZCHIP.IF._SPI._write_burst) 	// byte operation
   if(!WIZCHIP.IF._SPI._write_burst) 	// byte operation
   {
		WIZCHIP.IF._SPI._write_byte((AddrSel & 0x00FF0000) >> 16);
		WIZCHIP.IF._SPI._write_byte((AddrSel & 0x0000FF00) >>  8);
		WIZCHIP.IF._SPI._write_byte((AddrSel & 0x000000FF) >>  0);
		WIZCHIP.IF._SPI._write_byte(wb);
   }
   else									// burst operation
   {
		spi_data[0] = (AddrSel & 0x00FF0000) >> 16;
		spi_data[1] = (AddrSel & 0x0000FF00) >> 8;
		spi_data[2] = (AddrSel & 0x000000FF) >> 0;
		spi_data[3] = wb;
		WIZCHIP.IF._SPI._write_burst(spi_data, 4);
   }

   WIZCHIP.CS._deselect();
   WIZCHIP_CRITICAL_EXIT();
}

void WIZCHIP_READ_BUF(uint32_t AddrSel, uint8_t* pBuf, uint16_t len)
{
   uint8_t spi_data[3];
   uint16_t i;

   WIZCHIP_CRITICAL_ENTER();
   WIZCHIP.CS._select();

   AddrSel |= (_W5500_SPI_READ_ | _W5500_SPI_VDM_OP_);

   if(!WIZCHIP.IF._SPI._read_burst || !WIZCHIP.IF._SPI._write_burst) 	// byte operation
   {
		WIZCHIP.IF._SPI._write_byte((AddrSel & 0x00FF0000) >> 16);
		WIZCHIP.IF._SPI._write_byte((AddrSel & 0x0000FF00) >>  8);
		WIZCHIP.IF._SPI._write_byte((AddrSel & 0x000000FF) >>  0);
		for(i = 0; i < len; i++)
		   pBuf[i] = WIZCHIP.IF._SPI._read_byte();
   }
   else																// burst operation
   {
		spi_data[0] = (AddrSel & 0x00FF0000) >> 16;
		spi_data[1] = (AddrSel & 0x0000FF00) >> 8;
		spi_data[2] = (AddrSel & 0x000000FF) >> 0;
		WIZCHIP.IF._SPI._write_burst(spi_data, 3);
		WIZCHIP.IF._SPI._read_burst(pBuf, len);
   }

   WIZCHIP.CS._deselect();
   WIZCHIP_CRITICAL_EXIT();
}
uint16_t getSn_TX_FSR(uint8_t sn)
{
   uint16_t val=0,val1=0;

   do
   {
      val1 = WIZCHIP_READ(Sn_TX_FSR(sn));
      val1 = (val1 << 8) + WIZCHIP_READ(WIZCHIP_OFFSET_INC(Sn_TX_FSR(sn),1));
      if (val1 != 0)
      {
        val = WIZCHIP_READ(Sn_TX_FSR(sn));
        val = (val << 8) + WIZCHIP_READ(WIZCHIP_OFFSET_INC(Sn_TX_FSR(sn),1));
      }
   }while (val != val1);
   return val;
}
uint16_t getSn_RX_RSR(uint8_t sn)
{
   uint16_t val=0,val1=0;

   do
   {
      val1 = WIZCHIP_READ(Sn_RX_RSR(sn));
      val1 = (val1 << 8) + WIZCHIP_READ(WIZCHIP_OFFSET_INC(Sn_RX_RSR(sn),1));
      if (val1 != 0)
      {
        val = WIZCHIP_READ(Sn_RX_RSR(sn));
        val = (val << 8) + WIZCHIP_READ(WIZCHIP_OFFSET_INC(Sn_RX_RSR(sn),1));
      }
   }while (val != val1);
   return val;
}
void     WIZCHIP_WRITE_BUF(uint32_t AddrSel, uint8_t* pBuf, uint16_t len)
{
   uint8_t spi_data[3];
   uint16_t i;

   WIZCHIP_CRITICAL_ENTER();
   WIZCHIP.CS._select();

   AddrSel |= (_W5500_SPI_WRITE_ | _W5500_SPI_VDM_OP_);

   if(!WIZCHIP.IF._SPI._write_burst) 	// byte operation
   {
		WIZCHIP.IF._SPI._write_byte((AddrSel & 0x00FF0000) >> 16);
		WIZCHIP.IF._SPI._write_byte((AddrSel & 0x0000FF00) >>  8);
		WIZCHIP.IF._SPI._write_byte((AddrSel & 0x000000FF) >>  0);
		for(i = 0; i < len; i++)
			WIZCHIP.IF._SPI._write_byte(pBuf[i]);
   }
   else									// burst operation
   {
		spi_data[0] = (AddrSel & 0x00FF0000) >> 16;
		spi_data[1] = (AddrSel & 0x0000FF00) >> 8;
		spi_data[2] = (AddrSel & 0x000000FF) >> 0;
		WIZCHIP.IF._SPI._write_burst(spi_data, 3);
		WIZCHIP.IF._SPI._write_burst(pBuf, len);
   }

   WIZCHIP.CS._deselect();
   WIZCHIP_CRITICAL_EXIT();
}
void wiz_send_data(uint8_t sn, uint8_t *wizdata, uint16_t len)
{
   uint16_t ptr = 0;
   uint32_t addrsel = 0;

   if(len == 0)  return;
   ptr = getSn_TX_WR(sn);
   //M20140501 : implict type casting -> explict type casting
   //addrsel = (ptr << 8) + (WIZCHIP_TXBUF_BLOCK(sn) << 3);
   addrsel = ((uint32_t)ptr << 8) + (WIZCHIP_TXBUF_BLOCK(sn) << 3);
   //
   WIZCHIP_WRITE_BUF(addrsel,wizdata, len);
   
   ptr += len;
   setSn_TX_WR(sn,ptr);
}
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

int8_t wizchip_init(uint8_t* txsize, uint8_t* rxsize)
{
    int8_t i;
    int8_t tmp = 0;

    if(txsize)
    {
        for(i = 0; i < _WIZCHIP_SOCK_NUM_; i++)
        {
            tmp += txsize[i];

            if(tmp > 16)
                return -1;
        }

        for(i = 0; i < _WIZCHIP_SOCK_NUM_; i++)
        {
            setSn_TXBUF_SIZE(i, txsize[i]);
        }
        if(rxsize){
            tmp = 0;
            for(i = 0; i < _WIZCHIP_SOCK_NUM_; i++){
                tmp += rxsize[i];
                if(tmp > 16) return -1;
            }
            for(i = 0; i < _WIZCHIP_SOCK_NUM_; i++){
                setSn_RXBUF_SIZE(i, rxsize[i]);
            }
        }
        return 0;
    }

    (void)rxsize;

    return 0;
}

int8_t socket(uint8_t sn, uint8_t protocol, uint16_t port, uint8_t flag){
    CHECK_SOCKNUM();
    switch(protocol)
    {
        case Sn_MR_TCP : 
        {
            uint32_t taddr;
            getSIPR((uint8_t*)&taddr);
            if(taddr == 0) return SOCKERR_SOCKINIT;
        }
        default :
            return SOCKERR_SOCKMODE;
    }
    if((flag & 0x04) != 0) return SOCKERR_SOCKFLAG;
    if(flag != 0){
        switch(protocol){
            case Sn_MR_TCP:
                 if((flag & (SF_TCP_NODELAY|SF_IO_NONBLOCK))==0) return SOCKERR_SOCKFLAG;
               break;
            default:
               break;
        }
    }
    close(sn);
    setSn_MR(sn, (protocol | (flag & 0xF0)));
    if(!port)
    {
        port = sock_any_port++;
        if(sock_any_port == 0xFFF0) sock_any_port = SOCK_ANY_PORT_NUM;
    }
    setSn_PORT(sn,port);
    setSn_CR(sn,Sn_CR_OPEN);
    while(getSn_CR(sn));
    sock_io_mode &= ~(1 << sn);
    sock_io_mode |= ((flag & SF_IO_NONBLOCK) << sn);
    sock_remained_size[sn] = 0;
    sock_pack_info[sn] = PACK_COMPLETED;
    while(getSn_SR(sn) == SOCK_CLOSED);
    return (int8_t)sn;
}
int8_t close(uint8_t sn){
    CHECK_SOCKNUM();
    setSn_CR(sn,Sn_CR_CLOSE);
    while(getSn_CR(sn));
    setSn_IR(sn, 0xFF);
    sock_io_mode &= ~(1 << sn);
    sock_is_sending &= ~(1 << sn);
    sock_remained_size[sn] = 0;
    sock_pack_info[sn] = 0;
    while(getSn_SR(sn) != SOCK_CLOSED);
	return SOCK_OK;
}
int8_t listen(uint8_t sn){
    CHECK_SOCKNUM();
    CHECK_SOCKMODE(Sn_MR_TCP);
    CHECK_SOCKINIT();
    setSn_CR(sn,Sn_CR_LISTEN);
    while(getSn_CR(sn));
    while(getSn_SR(sn) != SOCK_LISTEN)
    {
        close(sn);
        return SOCKERR_SOCKCLOSED;
    }
    return SOCK_OK;
}
void wiz_recv_data(uint8_t sn, uint8_t *wizdata, uint16_t len)
{
   uint16_t ptr = 0;
   uint32_t addrsel = 0;
   
   if(len == 0) return;
   ptr = getSn_RX_RD(sn);
   //M20140501 : implict type casting -> explict type casting
   //addrsel = ((ptr << 8) + (WIZCHIP_RXBUF_BLOCK(sn) << 3);
   addrsel = ((uint32_t)ptr << 8) + (WIZCHIP_RXBUF_BLOCK(sn) << 3);
   //
   WIZCHIP_READ_BUF(addrsel, wizdata, len);
   ptr += len;
   setSn_RX_RD(sn,ptr);
}

int32_t recv(uint8_t sn, uint8_t *buf, uint16_t len){
    uint8_t tmp = 0;
    uint16_t recvsize = 0;
    CHECK_SOCKNUM();
    CHECK_SOCKMODE(Sn_MR_TCP);
    CHECK_SOCKDATA();
    recvsize = getSn_RxMAX(sn);
    if(recvsize < len) len = recvsize;
    while(1){
        recvsize = getSn_RX_RSR(sn);
        tmp = getSn_SR(sn);
        if(tmp != SOCK_ESTABLISHED){
            if(tmp == SOCK_CLOSE_WAIT){
                if(recvsize != 0) break;
                else if(getSn_TX_FSR(sn) == getSn_TxMAX(sn))
                {
                    close(sn);
                    return SOCKERR_SOCKSTATUS;
                }
            }
            else
            {
                close(sn);
                return SOCKERR_SOCKSTATUS;
            }
        }
        if ((sock_io_mode & (1 << sn)) && (recvsize == 0)){
            return SOCK_BUSY;
        }
        if(recvsize != 0) break;
    };
    if(recvsize < len) len = recvsize;
    wiz_recv_data(sn, buf, len);
    setSn_CR(sn,Sn_CR_RECV);
    while(getSn_CR(sn));
}

int32_t send(uint8_t sn, uint8_t * buf, uint16_t len){
    uint8_t tmp = 0;
    uint16_t freesize = 0;

    CHECK_SOCKNUM();
    CHECK_SOCKMODE(Sn_MR_TCP);
    CHECK_SOCKDATA();
    tmp = getSn_SR(sn);
    if(tmp != SOCK_ESTABLISHED && tmp != SOCK_CLOSE_WAIT) return SOCKERR_SOCKSTATUS;
    if(sock_is_sending & (1<<sn)){
        tmp = getSn_IR(sn);
        if(tmp & Sn_IR_SENDOK){
            setSn_IR(sn, Sn_IR_SENDOK);
            sock_is_sending &= ~(1<<sn);
        }
        else if(tmp & Sn_IR_TIMEOUT)
        {
            close(sn);
            return SOCKERR_TIMEOUT;
        }
        else return SOCK_BUSY;
    }
    freesize = getSn_TxMAX(sn);
    if (len > freesize) len = freesize;
    while(1){
        freesize = getSn_TX_FSR(sn);
        tmp = getSn_SR(sn);
        if((tmp != SOCK_ESTABLISHED) && (tmp != SOCK_CLOSE_WAIT)){
            close(sn);
            return SOCKERR_SOCKSTATUS;
        }
        if((sock_io_mode & (1<<sn)) && (len > freesize)) return SOCK_BUSY;
        if(len <= freesize) break;
    }
    wiz_send_data(sn, buf, len);
    setSn_CR(sn,Sn_CR_SEND);
    while(getSn_CR(sn));
    return (int32_t)len;
}

