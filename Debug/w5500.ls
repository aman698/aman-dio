   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  42                     ; 5 static void wizchip_cs_select(void)
  42                     ; 6 {
  44                     	switch	.text
  45  0000               L3_wizchip_cs_select:
  49                     ; 7 }
  52  0000 81            	ret
  76                     ; 9 static void wizchip_cs_deselect(void)
  76                     ; 10 {
  77                     	switch	.text
  78  0001               L32_wizchip_cs_deselect:
  82                     ; 11 }
  85  0001 81            	ret
 109                     ; 13 static uint8_t wizchip_spi_readbyte(void)
 109                     ; 14 {
 110                     	switch	.text
 111  0002               L53_wizchip_spi_readbyte:
 115                     ; 15     return 0;
 117  0002 4f            	clr	a
 120  0003 81            	ret
 155                     ; 18 static void wizchip_spi_writebyte(uint8_t wb)
 155                     ; 19 {
 156                     	switch	.text
 157  0004               L74_wizchip_spi_writebyte:
 161                     ; 20     (void)wb;
 163                     ; 21 }
 166  0004 81            	ret
 211                     ; 23 static void wizchip_spi_readburst(uint8_t* pBuf, uint16_t len)
 211                     ; 24 {
 212                     	switch	.text
 213  0005               L76_wizchip_spi_readburst:
 215  0005 89            	pushw	x
 216       00000000      OFST:	set	0
 219                     ; 25     (void)pBuf;
 221                     ; 26     (void)len;
 223                     ; 27 }
 226  0006 85            	popw	x
 227  0007 81            	ret
 272                     ; 29 static void wizchip_spi_writeburst(uint8_t* pBuf, uint16_t len)
 272                     ; 30 {
 273                     	switch	.text
 274  0008               L311_wizchip_spi_writeburst:
 276  0008 89            	pushw	x
 277       00000000      OFST:	set	0
 280                     ; 31     (void)pBuf;
 282                     ; 32     (void)len;
 284                     ; 33 }
 287  0009 85            	popw	x
 288  000a 81            	ret
 291                     	bsct
 292  0000               _WIZCHIP:
 293  0000 0200          	dc.w	512
 294  0002 57            	dc.b	87
 295  0003 35            	dc.b	53
 296  0004 35            	dc.b	53
 297  0005 30            	dc.b	48
 298  0006 30            	dc.b	48
 299  0007 00            	dc.b	0
 300  0008 000000000000  	ds.b	12
 351                     ; 43 void reg_wizchip_cs_cbfunc(void(*cs_sel)(void),
 351                     ; 44                            void(*cs_desel)(void))
 351                     ; 45 {
 352                     	switch	.text
 353  000b               _reg_wizchip_cs_cbfunc:
 355  000b 89            	pushw	x
 356       00000000      OFST:	set	0
 359                     ; 46     if((cs_sel == 0) || (cs_desel == 0))
 361  000c a30000        	cpw	x,#0
 362  000f 2704          	jreq	L361
 364  0011 1e05          	ldw	x,(OFST+5,sp)
 365  0013 260c          	jrne	L161
 366  0015               L361:
 367                     ; 48         WIZCHIP.CS._select   = wizchip_cs_select;
 369  0015 ae0000        	ldw	x,#L3_wizchip_cs_select
 370  0018 bf08          	ldw	_WIZCHIP+8,x
 371                     ; 49         WIZCHIP.CS._deselect = wizchip_cs_deselect;
 373  001a ae0001        	ldw	x,#L32_wizchip_cs_deselect
 374  001d bf0a          	ldw	_WIZCHIP+10,x
 376  001f               L561:
 377                     ; 56 }
 380  001f 85            	popw	x
 381  0020 81            	ret
 382  0021               L161:
 383                     ; 53         WIZCHIP.CS._select   = cs_sel;
 385  0021 1e01          	ldw	x,(OFST+1,sp)
 386  0023 bf08          	ldw	_WIZCHIP+8,x
 387                     ; 54         WIZCHIP.CS._deselect = cs_desel;
 389  0025 1e05          	ldw	x,(OFST+5,sp)
 390  0027 bf0a          	ldw	_WIZCHIP+10,x
 391  0029 20f4          	jra	L561
 444                     ; 60 void reg_wizchip_spi_cbfunc(
 444                     ; 61     uint8_t (*spi_rb)(void),
 444                     ; 62     void (*spi_wb)(uint8_t wb)
 444                     ; 63 )
 444                     ; 64 {
 445                     	switch	.text
 446  002b               _reg_wizchip_spi_cbfunc:
 448  002b 89            	pushw	x
 449       00000000      OFST:	set	0
 452                     ; 65     if((spi_rb == 0) || (spi_wb == 0))
 454  002c a30000        	cpw	x,#0
 455  002f 2704          	jreq	L312
 457  0031 1e05          	ldw	x,(OFST+5,sp)
 458  0033 260c          	jrne	L112
 459  0035               L312:
 460                     ; 67         WIZCHIP.IF._SPI._read_byte  = wizchip_spi_readbyte;
 462  0035 ae0002        	ldw	x,#L53_wizchip_spi_readbyte
 463  0038 bf0c          	ldw	_WIZCHIP+12,x
 464                     ; 68         WIZCHIP.IF._SPI._write_byte = wizchip_spi_writebyte;
 466  003a ae0004        	ldw	x,#L74_wizchip_spi_writebyte
 467  003d bf0e          	ldw	_WIZCHIP+14,x
 469  003f               L512:
 470                     ; 75 }
 473  003f 85            	popw	x
 474  0040 81            	ret
 475  0041               L112:
 476                     ; 72         WIZCHIP.IF._SPI._read_byte  = spi_rb;
 478  0041 1e01          	ldw	x,(OFST+1,sp)
 479  0043 bf0c          	ldw	_WIZCHIP+12,x
 480                     ; 73         WIZCHIP.IF._SPI._write_byte = spi_wb;
 482  0045 1e05          	ldw	x,(OFST+5,sp)
 483  0047 bf0e          	ldw	_WIZCHIP+14,x
 484  0049 20f4          	jra	L512
 537                     ; 79 void reg_wizchip_spiburst_cbfunc(
 537                     ; 80     void (*spi_rb)(uint8_t* pBuf, uint16_t len),
 537                     ; 81     void (*spi_wb)(uint8_t* pBuf, uint16_t len)
 537                     ; 82 )
 537                     ; 83 {
 538                     	switch	.text
 539  004b               _reg_wizchip_spiburst_cbfunc:
 541  004b 89            	pushw	x
 542       00000000      OFST:	set	0
 545                     ; 84     if((spi_rb == 0) || (spi_wb == 0))
 547  004c a30000        	cpw	x,#0
 548  004f 2704          	jreq	L342
 550  0051 1e05          	ldw	x,(OFST+5,sp)
 551  0053 260c          	jrne	L142
 552  0055               L342:
 553                     ; 86         WIZCHIP.IF._SPI._read_burst  = wizchip_spi_readburst;
 555  0055 ae0005        	ldw	x,#L76_wizchip_spi_readburst
 556  0058 bf10          	ldw	_WIZCHIP+16,x
 557                     ; 87         WIZCHIP.IF._SPI._write_burst = wizchip_spi_writeburst;
 559  005a ae0008        	ldw	x,#L311_wizchip_spi_writeburst
 560  005d bf12          	ldw	_WIZCHIP+18,x
 562  005f               L542:
 563                     ; 94 }
 566  005f 85            	popw	x
 567  0060 81            	ret
 568  0061               L142:
 569                     ; 91         WIZCHIP.IF._SPI._read_burst  = spi_rb;
 571  0061 1e01          	ldw	x,(OFST+1,sp)
 572  0063 bf10          	ldw	_WIZCHIP+16,x
 573                     ; 92         WIZCHIP.IF._SPI._write_burst = spi_wb;
 575  0065 1e05          	ldw	x,(OFST+5,sp)
 576  0067 bf12          	ldw	_WIZCHIP+18,x
 577  0069 20f4          	jra	L542
 621                     ; 96 int8_t wizchip_init(uint8_t* txsize, uint8_t* rxsize){
 622                     	switch	.text
 623  006b               _wizchip_init:
 625  006b 88            	push	a
 626       00000001      OFST:	set	1
 629                     ; 98     int8_t tmp = 0;
 631                     ; 99 }
 634  006c 84            	pop	a
 635  006d 81            	ret
 801                     	xdef	_wizchip_init
 802                     	xdef	_reg_wizchip_spiburst_cbfunc
 803                     	xdef	_reg_wizchip_spi_cbfunc
 804                     	xdef	_reg_wizchip_cs_cbfunc
 805                     	xdef	_WIZCHIP
 824                     	end
