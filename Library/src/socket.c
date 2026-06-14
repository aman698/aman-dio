#include "socket.h"

#define SOCK_ANY_PORT_NUM  0xC000

static uint16_t sock_any_port = SOCK_ANY_PORT_NUM;
static uint16_t sock_io_mode = 0;
static uint16_t sock_is_sending = 0;
static uint16_t sock_remained_size[_WIZCHIP_SOCK_NUM_] = {0,0,};

uint8_t  sock_pack_info[_WIZCHIP_SOCK_NUM_] = {0,};


#define CHECK_SOCKNUM()   \
   do{                    \
      if(sn > _WIZCHIP_SOCK_NUM_) return SOCKERR_SOCKNUM;   \
   }while(0);             \

#define CHECK_SOCKMODE(mode)  \
   do{                     \
      if((getSn_MR(sn) & 0x0F) != mode) return SOCKERR_SOCKMODE;  \
   }while(0);              \

#define CHECK_SOCKINIT()   \
   do{                     \
      if((getSn_SR(sn) != SOCK_INIT)) return SOCKERR_SOCKINIT; \
   }while(0);              \

#define CHECK_SOCKDATA()   \
   do{                     \
      if(len == 0) return SOCKERR_DATALEN;   \
   }while(0);              \



int8_t socket(uint8_t sn, uint8_t protocol, uint16_t port, uint8_t flag)
{
	CHECK_SOCKNUM();
	switch(protocol)
	{
      case Sn_MR_TCP :
         {
            uint32_t taddr;
            getSIPR((uint8_t*)&taddr);
            if(taddr == 0) return SOCKERR_SOCKINIT;
         }
      case Sn_MR_UDP :
      case Sn_MR_MACRAW :
         break;
      case Sn_MR_IPRAW:
         break;
      default :
         return SOCKERR_SOCKMODE;
	}
	if((flag & 0x04) != 0) return SOCKERR_SOCKFLAG;
	   
	if(flag != 0)
	{
   	switch(protocol)
   	{
   	   case Sn_MR_TCP:
   		  //M20150601 :  For SF_TCP_ALIGN & W5300
          #if _WIZCHIP_ == 5500
   		     if((flag & (SF_TCP_NODELAY|SF_IO_NONBLOCK))==0) return SOCKERR_SOCKFLAG;
          #endif

   	      break;
   	   case Sn_MR_UDP:
   	      if(flag & SF_IGMP_VER2)
   	      {
   	         if((flag & SF_MULTI_ENABLE)==0) return SOCKERR_SOCKFLAG;
   	      }
   	      #if _WIZCHIP_ == 5500
      	      if(flag & SF_UNI_BLOCK)
      	      {
      	         if((flag & SF_MULTI_ENABLE) == 0) return SOCKERR_SOCKFLAG;
      	      }
   	      #endif
   	      break;
   	   default:
   	      break;
   	}
   }
	close(sn);
	//M20150601
	#if _WIZCHIP_ == 5500
	   setSn_MR(sn, (protocol | (flag & 0xF0)));
    #endif
	if(!port)
	{
	   port = sock_any_port++;
	   if(sock_any_port == 0xFFF0) sock_any_port = SOCK_ANY_PORT_NUM;
	}
   setSn_PORT(sn,port);	
   setSn_CR(sn,Sn_CR_OPEN);
   while(getSn_CR(sn));
   sock_io_mode &= ~(1 <<sn);
	sock_io_mode |= ((flag & SF_IO_NONBLOCK) << sn);   
   sock_is_sending &= ~(1<<sn);
   sock_remained_size[sn] = 0;
   sock_pack_info[sn] = PACK_COMPLETED;
   while(getSn_SR(sn) == SOCK_CLOSED);
   return (int8_t)sn;
}	   

int8_t close(uint8_t sn)
{
	CHECK_SOCKNUM();
	setSn_CR(sn,Sn_CR_CLOSE);
	while( getSn_CR(sn) );
	setSn_IR(sn, 0xFF);
	sock_io_mode &= ~(1<<sn);
	sock_is_sending &= ~(1<<sn);
	sock_remained_size[sn] = 0;
	sock_pack_info[sn] = 0;
	while(getSn_SR(sn) != SOCK_CLOSED);
	return SOCK_OK;
}

int8_t listen(uint8_t sn)
{
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
