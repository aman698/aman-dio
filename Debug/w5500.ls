   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  14                     	bsct
  15  0000               L3_sock_any_port:
  16  0000 c000          	dc.w	-16384
  46                     	bsct
  47  0002               L12_sock_remained_size:
  48  0002 0000          	dc.w	0
  49  0004 0000          	dc.w	0
  50  0006 000000000000  	ds.b	12
  51  0012               _sock_pack_info:
  52  0012 00            	dc.b	0
  53  0013 000000000000  	ds.b	7
  54  001a               L32_sock_is_sending:
  55  001a 0000          	dc.w	0
  56  001c               L52_sock_io_mode:
  57  001c 0000          	dc.w	0
  86                     ; 9 static void wizchip_cs_select(void)
  86                     ; 10 {
  88                     	switch	.text
  89  0000               L72_wizchip_cs_select:
  93                     ; 11 }
  96  0000 81            	ret
 120                     ; 13 static void wizchip_cs_deselect(void)
 120                     ; 14 {
 121                     	switch	.text
 122  0001               L74_wizchip_cs_deselect:
 126                     ; 15 }
 129  0001 81            	ret
 153                     ; 17 static uint8_t wizchip_spi_readbyte(void)
 153                     ; 18 {
 154                     	switch	.text
 155  0002               L16_wizchip_spi_readbyte:
 159                     ; 19     return 0;
 161  0002 4f            	clr	a
 164  0003 81            	ret
 199                     ; 22 static void wizchip_spi_writebyte(uint8_t wb)
 199                     ; 23 {
 200                     	switch	.text
 201  0004               L37_wizchip_spi_writebyte:
 205                     ; 24     (void)wb;
 207                     ; 25 }
 210  0004 81            	ret
 255                     ; 27 static void wizchip_spi_readburst(uint8_t* pBuf, uint16_t len)
 255                     ; 28 {
 256                     	switch	.text
 257  0005               L311_wizchip_spi_readburst:
 259  0005 89            	pushw	x
 260       00000000      OFST:	set	0
 263                     ; 29     (void)pBuf;
 265                     ; 30     (void)len;
 267                     ; 31 }
 270  0006 85            	popw	x
 271  0007 81            	ret
 316                     ; 33 static void wizchip_spi_writeburst(uint8_t* pBuf, uint16_t len)
 316                     ; 34 {
 317                     	switch	.text
 318  0008               L731_wizchip_spi_writeburst:
 320  0008 89            	pushw	x
 321       00000000      OFST:	set	0
 324                     ; 35     (void)pBuf;
 326                     ; 36     (void)len;
 328                     ; 37 }
 331  0009 85            	popw	x
 332  000a 81            	ret
 335                     	bsct
 336  001e               _WIZCHIP:
 337  001e 0200          	dc.w	512
 338  0020 57            	dc.b	87
 339  0021 35            	dc.b	53
 340  0022 35            	dc.b	53
 341  0023 30            	dc.b	48
 342  0024 30            	dc.b	48
 343  0025 00            	dc.b	0
 344  0026 000000000000  	ds.b	16
 396                     ; 47 uint8_t  WIZCHIP_READ(uint32_t AddrSel)
 396                     ; 48 {
 397                     	switch	.text
 398  000b               _WIZCHIP_READ:
 400  000b 5204          	subw	sp,#4
 401       00000004      OFST:	set	4
 404                     ; 52    WIZCHIP_CRITICAL_ENTER();
 406  000d 92cd26        	call	[_WIZCHIP+8.w]
 408                     ; 53    WIZCHIP.CS._select();
 410  0010 92cd2a        	call	[_WIZCHIP+12.w]
 412                     ; 55    AddrSel |= (_W5500_SPI_READ_ | _W5500_SPI_VDM_OP_);
 414                     ; 57    if(!WIZCHIP.IF._SPI._read_burst || !WIZCHIP.IF._SPI._write_burst) 	// byte operation
 416  0013 be32          	ldw	x,_WIZCHIP+20
 417  0015 2704          	jreq	L312
 419  0017 be34          	ldw	x,_WIZCHIP+22
 420  0019 2625          	jrne	L112
 421  001b               L312:
 422                     ; 59 	    WIZCHIP.IF._SPI._write_byte((AddrSel & 0x00FF0000) >> 16);
 424  001b 7b08          	ld	a,(OFST+4,sp)
 425  001d a4ff          	and	a,#255
 426  001f 92cd30        	call	[_WIZCHIP+18.w]
 428                     ; 60 		WIZCHIP.IF._SPI._write_byte((AddrSel & 0x0000FF00) >>  8);
 430  0022 7b09          	ld	a,(OFST+5,sp)
 431  0024 a4ff          	and	a,#255
 432  0026 92cd30        	call	[_WIZCHIP+18.w]
 434                     ; 61 		WIZCHIP.IF._SPI._write_byte((AddrSel & 0x000000FF) >>  0);
 436  0029 7b0a          	ld	a,(OFST+6,sp)
 437  002b a4ff          	and	a,#255
 438  002d 92cd30        	call	[_WIZCHIP+18.w]
 441  0030               L512:
 442                     ; 70    ret = WIZCHIP.IF._SPI._read_byte();
 444  0030 92cd2e        	call	[_WIZCHIP+16.w]
 446  0033 6b01          	ld	(OFST-3,sp),a
 448                     ; 72    WIZCHIP.CS._deselect();
 450  0035 92cd2c        	call	[_WIZCHIP+14.w]
 452                     ; 73    WIZCHIP_CRITICAL_EXIT();
 454  0038 92cd28        	call	[_WIZCHIP+10.w]
 456                     ; 74    return ret;
 458  003b 7b01          	ld	a,(OFST-3,sp)
 461  003d 5b04          	addw	sp,#4
 462  003f 81            	ret
 463  0040               L112:
 464                     ; 65 		spi_data[0] = (AddrSel & 0x00FF0000) >> 16;
 466  0040 7b08          	ld	a,(OFST+4,sp)
 467  0042 a4ff          	and	a,#255
 468  0044 6b02          	ld	(OFST-2,sp),a
 470                     ; 66 		spi_data[1] = (AddrSel & 0x0000FF00) >> 8;
 472  0046 7b09          	ld	a,(OFST+5,sp)
 473  0048 a4ff          	and	a,#255
 474  004a 6b03          	ld	(OFST-1,sp),a
 476                     ; 67 		spi_data[2] = (AddrSel & 0x000000FF) >> 0;
 478  004c 7b0a          	ld	a,(OFST+6,sp)
 479  004e a4ff          	and	a,#255
 480  0050 6b04          	ld	(OFST+0,sp),a
 482                     ; 68 		WIZCHIP.IF._SPI._write_burst(spi_data, 3);
 484  0052 ae0003        	ldw	x,#3
 485  0055 89            	pushw	x
 486  0056 96            	ldw	x,sp
 487  0057 1c0004        	addw	x,#OFST+0
 488  005a 92cd34        	call	[_WIZCHIP+22.w]
 490  005d 85            	popw	x
 491  005e 20d0          	jra	L512
 545                     ; 77 void WIZCHIP_WRITE(uint32_t AddrSel, uint8_t wb )
 545                     ; 78 {
 546                     	switch	.text
 547  0060               _WIZCHIP_WRITE:
 549  0060 5204          	subw	sp,#4
 550       00000004      OFST:	set	4
 553                     ; 81    WIZCHIP_CRITICAL_ENTER();
 555  0062 92cd26        	call	[_WIZCHIP+8.w]
 557                     ; 82    WIZCHIP.CS._select();
 559  0065 92cd2a        	call	[_WIZCHIP+12.w]
 561                     ; 84    AddrSel |= (_W5500_SPI_WRITE_ | _W5500_SPI_VDM_OP_);
 563  0068 7b0a          	ld	a,(OFST+6,sp)
 564  006a aa04          	or	a,#4
 565  006c 6b0a          	ld	(OFST+6,sp),a
 566                     ; 87    if(!WIZCHIP.IF._SPI._write_burst) 	// byte operation
 568  006e be34          	ldw	x,_WIZCHIP+22
 569  0070 261c          	jrne	L542
 570                     ; 89 		WIZCHIP.IF._SPI._write_byte((AddrSel & 0x00FF0000) >> 16);
 572  0072 7b08          	ld	a,(OFST+4,sp)
 573  0074 a4ff          	and	a,#255
 574  0076 92cd30        	call	[_WIZCHIP+18.w]
 576                     ; 90 		WIZCHIP.IF._SPI._write_byte((AddrSel & 0x0000FF00) >>  8);
 578  0079 7b09          	ld	a,(OFST+5,sp)
 579  007b a4ff          	and	a,#255
 580  007d 92cd30        	call	[_WIZCHIP+18.w]
 582                     ; 91 		WIZCHIP.IF._SPI._write_byte((AddrSel & 0x000000FF) >>  0);
 584  0080 7b0a          	ld	a,(OFST+6,sp)
 585  0082 a4ff          	and	a,#255
 586  0084 92cd30        	call	[_WIZCHIP+18.w]
 588                     ; 92 		WIZCHIP.IF._SPI._write_byte(wb);
 590  0087 7b0b          	ld	a,(OFST+7,sp)
 591  0089 92cd30        	call	[_WIZCHIP+18.w]
 594  008c 2022          	jra	L742
 595  008e               L542:
 596                     ; 96 		spi_data[0] = (AddrSel & 0x00FF0000) >> 16;
 598  008e 7b08          	ld	a,(OFST+4,sp)
 599  0090 a4ff          	and	a,#255
 600  0092 6b01          	ld	(OFST-3,sp),a
 602                     ; 97 		spi_data[1] = (AddrSel & 0x0000FF00) >> 8;
 604  0094 7b09          	ld	a,(OFST+5,sp)
 605  0096 a4ff          	and	a,#255
 606  0098 6b02          	ld	(OFST-2,sp),a
 608                     ; 98 		spi_data[2] = (AddrSel & 0x000000FF) >> 0;
 610  009a 7b0a          	ld	a,(OFST+6,sp)
 611  009c a4ff          	and	a,#255
 612  009e 6b03          	ld	(OFST-1,sp),a
 614                     ; 99 		spi_data[3] = wb;
 616  00a0 7b0b          	ld	a,(OFST+7,sp)
 617  00a2 6b04          	ld	(OFST+0,sp),a
 619                     ; 100 		WIZCHIP.IF._SPI._write_burst(spi_data, 4);
 621  00a4 ae0004        	ldw	x,#4
 622  00a7 89            	pushw	x
 623  00a8 96            	ldw	x,sp
 624  00a9 1c0003        	addw	x,#OFST-1
 625  00ac 92cd34        	call	[_WIZCHIP+22.w]
 627  00af 85            	popw	x
 628  00b0               L742:
 629                     ; 103    WIZCHIP.CS._deselect();
 631  00b0 92cd2c        	call	[_WIZCHIP+14.w]
 633                     ; 104    WIZCHIP_CRITICAL_EXIT();
 635  00b3 92cd28        	call	[_WIZCHIP+10.w]
 637                     ; 105 }
 640  00b6 5b04          	addw	sp,#4
 641  00b8 81            	ret
 714                     ; 107 void WIZCHIP_READ_BUF(uint32_t AddrSel, uint8_t* pBuf, uint16_t len)
 714                     ; 108 {
 715                     	switch	.text
 716  00b9               _WIZCHIP_READ_BUF:
 718  00b9 5205          	subw	sp,#5
 719       00000005      OFST:	set	5
 722                     ; 112    WIZCHIP_CRITICAL_ENTER();
 724  00bb 92cd26        	call	[_WIZCHIP+8.w]
 726                     ; 113    WIZCHIP.CS._select();
 728  00be 92cd2a        	call	[_WIZCHIP+12.w]
 730                     ; 115    AddrSel |= (_W5500_SPI_READ_ | _W5500_SPI_VDM_OP_);
 732                     ; 117    if(!WIZCHIP.IF._SPI._read_burst || !WIZCHIP.IF._SPI._write_burst) 	// byte operation
 734  00c1 be32          	ldw	x,_WIZCHIP+20
 735  00c3 2704          	jreq	L113
 737  00c5 be34          	ldw	x,_WIZCHIP+22
 738  00c7 2632          	jrne	L703
 739  00c9               L113:
 740                     ; 119 		WIZCHIP.IF._SPI._write_byte((AddrSel & 0x00FF0000) >> 16);
 742  00c9 7b09          	ld	a,(OFST+4,sp)
 743  00cb a4ff          	and	a,#255
 744  00cd 92cd30        	call	[_WIZCHIP+18.w]
 746                     ; 120 		WIZCHIP.IF._SPI._write_byte((AddrSel & 0x0000FF00) >>  8);
 748  00d0 7b0a          	ld	a,(OFST+5,sp)
 749  00d2 a4ff          	and	a,#255
 750  00d4 92cd30        	call	[_WIZCHIP+18.w]
 752                     ; 121 		WIZCHIP.IF._SPI._write_byte((AddrSel & 0x000000FF) >>  0);
 754  00d7 7b0b          	ld	a,(OFST+6,sp)
 755  00d9 a4ff          	and	a,#255
 756  00db 92cd30        	call	[_WIZCHIP+18.w]
 758                     ; 122 		for(i = 0; i < len; i++)
 760  00de 5f            	clrw	x
 761  00df 1f04          	ldw	(OFST-1,sp),x
 764  00e1 2010          	jra	L713
 765  00e3               L313:
 766                     ; 123 		   pBuf[i] = WIZCHIP.IF._SPI._read_byte();
 768  00e3 92cd2e        	call	[_WIZCHIP+16.w]
 770  00e6 1e0c          	ldw	x,(OFST+7,sp)
 771  00e8 72fb04        	addw	x,(OFST-1,sp)
 772  00eb f7            	ld	(x),a
 773                     ; 122 		for(i = 0; i < len; i++)
 775  00ec 1e04          	ldw	x,(OFST-1,sp)
 776  00ee 1c0001        	addw	x,#1
 777  00f1 1f04          	ldw	(OFST-1,sp),x
 779  00f3               L713:
 782  00f3 1e04          	ldw	x,(OFST-1,sp)
 783  00f5 130e          	cpw	x,(OFST+9,sp)
 784  00f7 25ea          	jrult	L313
 786  00f9 2027          	jra	L323
 787  00fb               L703:
 788                     ; 127 		spi_data[0] = (AddrSel & 0x00FF0000) >> 16;
 790  00fb 7b09          	ld	a,(OFST+4,sp)
 791  00fd a4ff          	and	a,#255
 792  00ff 6b01          	ld	(OFST-4,sp),a
 794                     ; 128 		spi_data[1] = (AddrSel & 0x0000FF00) >> 8;
 796  0101 7b0a          	ld	a,(OFST+5,sp)
 797  0103 a4ff          	and	a,#255
 798  0105 6b02          	ld	(OFST-3,sp),a
 800                     ; 129 		spi_data[2] = (AddrSel & 0x000000FF) >> 0;
 802  0107 7b0b          	ld	a,(OFST+6,sp)
 803  0109 a4ff          	and	a,#255
 804  010b 6b03          	ld	(OFST-2,sp),a
 806                     ; 130 		WIZCHIP.IF._SPI._write_burst(spi_data, 3);
 808  010d ae0003        	ldw	x,#3
 809  0110 89            	pushw	x
 810  0111 96            	ldw	x,sp
 811  0112 1c0003        	addw	x,#OFST-2
 812  0115 92cd34        	call	[_WIZCHIP+22.w]
 814  0118 85            	popw	x
 815                     ; 131 		WIZCHIP.IF._SPI._read_burst(pBuf, len);
 817  0119 1e0e          	ldw	x,(OFST+9,sp)
 818  011b 89            	pushw	x
 819  011c 1e0e          	ldw	x,(OFST+9,sp)
 820  011e 92cd32        	call	[_WIZCHIP+20.w]
 822  0121 85            	popw	x
 823  0122               L323:
 824                     ; 134    WIZCHIP.CS._deselect();
 826  0122 92cd2c        	call	[_WIZCHIP+14.w]
 828                     ; 135    WIZCHIP_CRITICAL_EXIT();
 830  0125 92cd28        	call	[_WIZCHIP+10.w]
 832                     ; 136 }
 835  0128 5b05          	addw	sp,#5
 836  012a 81            	ret
 889                     ; 138 void reg_wizchip_cs_cbfunc(void(*cs_sel)(void),
 889                     ; 139                            void(*cs_desel)(void))
 889                     ; 140 {
 890                     	switch	.text
 891  012b               _reg_wizchip_cs_cbfunc:
 893  012b 89            	pushw	x
 894       00000000      OFST:	set	0
 897                     ; 141     if((cs_sel == 0) || (cs_desel == 0))
 899  012c a30000        	cpw	x,#0
 900  012f 2704          	jreq	L153
 902  0131 1e05          	ldw	x,(OFST+5,sp)
 903  0133 260c          	jrne	L743
 904  0135               L153:
 905                     ; 143         WIZCHIP.CS._select   = wizchip_cs_select;
 907  0135 ae0000        	ldw	x,#L72_wizchip_cs_select
 908  0138 bf2a          	ldw	_WIZCHIP+12,x
 909                     ; 144         WIZCHIP.CS._deselect = wizchip_cs_deselect;
 911  013a ae0001        	ldw	x,#L74_wizchip_cs_deselect
 912  013d bf2c          	ldw	_WIZCHIP+14,x
 914  013f               L353:
 915                     ; 151 }
 918  013f 85            	popw	x
 919  0140 81            	ret
 920  0141               L743:
 921                     ; 148         WIZCHIP.CS._select   = cs_sel;
 923  0141 1e01          	ldw	x,(OFST+1,sp)
 924  0143 bf2a          	ldw	_WIZCHIP+12,x
 925                     ; 149         WIZCHIP.CS._deselect = cs_desel;
 927  0145 1e05          	ldw	x,(OFST+5,sp)
 928  0147 bf2c          	ldw	_WIZCHIP+14,x
 929  0149 20f4          	jra	L353
 982                     ; 155 void reg_wizchip_spi_cbfunc(
 982                     ; 156     uint8_t (*spi_rb)(void),
 982                     ; 157     void (*spi_wb)(uint8_t wb)
 982                     ; 158 )
 982                     ; 159 {
 983                     	switch	.text
 984  014b               _reg_wizchip_spi_cbfunc:
 986  014b 89            	pushw	x
 987       00000000      OFST:	set	0
 990                     ; 160     if((spi_rb == 0) || (spi_wb == 0))
 992  014c a30000        	cpw	x,#0
 993  014f 2704          	jreq	L104
 995  0151 1e05          	ldw	x,(OFST+5,sp)
 996  0153 260c          	jrne	L773
 997  0155               L104:
 998                     ; 162         WIZCHIP.IF._SPI._read_byte  = wizchip_spi_readbyte;
1000  0155 ae0002        	ldw	x,#L16_wizchip_spi_readbyte
1001  0158 bf2e          	ldw	_WIZCHIP+16,x
1002                     ; 163         WIZCHIP.IF._SPI._write_byte = wizchip_spi_writebyte;
1004  015a ae0004        	ldw	x,#L37_wizchip_spi_writebyte
1005  015d bf30          	ldw	_WIZCHIP+18,x
1007  015f               L304:
1008                     ; 170 }
1011  015f 85            	popw	x
1012  0160 81            	ret
1013  0161               L773:
1014                     ; 167         WIZCHIP.IF._SPI._read_byte  = spi_rb;
1016  0161 1e01          	ldw	x,(OFST+1,sp)
1017  0163 bf2e          	ldw	_WIZCHIP+16,x
1018                     ; 168         WIZCHIP.IF._SPI._write_byte = spi_wb;
1020  0165 1e05          	ldw	x,(OFST+5,sp)
1021  0167 bf30          	ldw	_WIZCHIP+18,x
1022  0169 20f4          	jra	L304
1075                     ; 174 void reg_wizchip_spiburst_cbfunc(
1075                     ; 175     void (*spi_rb)(uint8_t* pBuf, uint16_t len),
1075                     ; 176     void (*spi_wb)(uint8_t* pBuf, uint16_t len)
1075                     ; 177 )
1075                     ; 178 {
1076                     	switch	.text
1077  016b               _reg_wizchip_spiburst_cbfunc:
1079  016b 89            	pushw	x
1080       00000000      OFST:	set	0
1083                     ; 179     if((spi_rb == 0) || (spi_wb == 0))
1085  016c a30000        	cpw	x,#0
1086  016f 2704          	jreq	L134
1088  0171 1e05          	ldw	x,(OFST+5,sp)
1089  0173 260c          	jrne	L724
1090  0175               L134:
1091                     ; 181         WIZCHIP.IF._SPI._read_burst  = wizchip_spi_readburst;
1093  0175 ae0005        	ldw	x,#L311_wizchip_spi_readburst
1094  0178 bf32          	ldw	_WIZCHIP+20,x
1095                     ; 182         WIZCHIP.IF._SPI._write_burst = wizchip_spi_writeburst;
1097  017a ae0008        	ldw	x,#L731_wizchip_spi_writeburst
1098  017d bf34          	ldw	_WIZCHIP+22,x
1100  017f               L334:
1101                     ; 189 }
1104  017f 85            	popw	x
1105  0180 81            	ret
1106  0181               L724:
1107                     ; 186         WIZCHIP.IF._SPI._read_burst  = spi_rb;
1109  0181 1e01          	ldw	x,(OFST+1,sp)
1110  0183 bf32          	ldw	_WIZCHIP+20,x
1111                     ; 187         WIZCHIP.IF._SPI._write_burst = spi_wb;
1113  0185 1e05          	ldw	x,(OFST+5,sp)
1114  0187 bf34          	ldw	_WIZCHIP+22,x
1115  0189 20f4          	jra	L334
1179                     ; 191 int8_t wizchip_init(uint8_t* txsize, uint8_t* rxsize)
1179                     ; 192 {
1180                     	switch	.text
1181  018b               _wizchip_init:
1183  018b 89            	pushw	x
1184  018c 89            	pushw	x
1185       00000002      OFST:	set	2
1188                     ; 194     int8_t tmp = 0;
1190  018d 0f01          	clr	(OFST-1,sp)
1192                     ; 196     if(txsize)
1194  018f a30000        	cpw	x,#0
1195  0192 2603          	jrne	L45
1196  0194 cc0259        	jp	L764
1197  0197               L45:
1198                     ; 198         for(i = 0; i < _WIZCHIP_SOCK_NUM_; i++)
1200  0197 0f02          	clr	(OFST+0,sp)
1202  0199               L174:
1203                     ; 200             tmp += txsize[i];
1205  0199 7b02          	ld	a,(OFST+0,sp)
1206  019b 5f            	clrw	x
1207  019c 4d            	tnz	a
1208  019d 2a01          	jrpl	L63
1209  019f 53            	cplw	x
1210  01a0               L63:
1211  01a0 97            	ld	xl,a
1212  01a1 72fb03        	addw	x,(OFST+1,sp)
1213  01a4 7b01          	ld	a,(OFST-1,sp)
1214  01a6 fb            	add	a,(x)
1215  01a7 6b01          	ld	(OFST-1,sp),a
1217                     ; 202             if(tmp > 16)
1219  01a9 9c            	rvf
1220  01aa 7b01          	ld	a,(OFST-1,sp)
1221  01ac a111          	cp	a,#17
1222  01ae 2f04          	jrslt	L774
1223                     ; 203                 return -1;
1225  01b0 a6ff          	ld	a,#255
1227  01b2 2060          	jra	L25
1228  01b4               L774:
1229                     ; 198         for(i = 0; i < _WIZCHIP_SOCK_NUM_; i++)
1231  01b4 0c02          	inc	(OFST+0,sp)
1235  01b6 9c            	rvf
1236  01b7 7b02          	ld	a,(OFST+0,sp)
1237  01b9 a108          	cp	a,#8
1238  01bb 2fdc          	jrslt	L174
1239                     ; 206         for(i = 0; i < _WIZCHIP_SOCK_NUM_; i++)
1241  01bd 0f02          	clr	(OFST+0,sp)
1243  01bf               L105:
1244                     ; 208             setSn_TXBUF_SIZE(i, txsize[i]);
1246  01bf 7b02          	ld	a,(OFST+0,sp)
1247  01c1 5f            	clrw	x
1248  01c2 4d            	tnz	a
1249  01c3 2a01          	jrpl	L04
1250  01c5 53            	cplw	x
1251  01c6               L04:
1252  01c6 97            	ld	xl,a
1253  01c7 72fb03        	addw	x,(OFST+1,sp)
1254  01ca f6            	ld	a,(x)
1255  01cb 88            	push	a
1256  01cc 7b03          	ld	a,(OFST+1,sp)
1257  01ce 5f            	clrw	x
1258  01cf 4d            	tnz	a
1259  01d0 2a01          	jrpl	L24
1260  01d2 53            	cplw	x
1261  01d3               L24:
1262  01d3 97            	ld	xl,a
1263  01d4 58            	sllw	x
1264  01d5 58            	sllw	x
1265  01d6 58            	sllw	x
1266  01d7 58            	sllw	x
1267  01d8 58            	sllw	x
1268  01d9 1c1f08        	addw	x,#7944
1269  01dc cd0000        	call	c_itolx
1271  01df be02          	ldw	x,c_lreg+2
1272  01e1 89            	pushw	x
1273  01e2 be00          	ldw	x,c_lreg
1274  01e4 89            	pushw	x
1275  01e5 cd0060        	call	_WIZCHIP_WRITE
1277  01e8 5b05          	addw	sp,#5
1278                     ; 206         for(i = 0; i < _WIZCHIP_SOCK_NUM_; i++)
1280  01ea 0c02          	inc	(OFST+0,sp)
1284  01ec 9c            	rvf
1285  01ed 7b02          	ld	a,(OFST+0,sp)
1286  01ef a108          	cp	a,#8
1287  01f1 2fcc          	jrslt	L105
1288                     ; 210         if(rxsize){
1290  01f3 1e07          	ldw	x,(OFST+5,sp)
1291  01f5 275f          	jreq	L705
1292                     ; 211             tmp = 0;
1294  01f7 0f01          	clr	(OFST-1,sp)
1296                     ; 212             for(i = 0; i < _WIZCHIP_SOCK_NUM_; i++){
1298  01f9 0f02          	clr	(OFST+0,sp)
1300  01fb               L115:
1301                     ; 213                 tmp += rxsize[i];
1303  01fb 7b02          	ld	a,(OFST+0,sp)
1304  01fd 5f            	clrw	x
1305  01fe 4d            	tnz	a
1306  01ff 2a01          	jrpl	L44
1307  0201 53            	cplw	x
1308  0202               L44:
1309  0202 97            	ld	xl,a
1310  0203 72fb07        	addw	x,(OFST+5,sp)
1311  0206 7b01          	ld	a,(OFST-1,sp)
1312  0208 fb            	add	a,(x)
1313  0209 6b01          	ld	(OFST-1,sp),a
1315                     ; 214                 if(tmp > 16) return -1;
1317  020b 9c            	rvf
1318  020c 7b01          	ld	a,(OFST-1,sp)
1319  020e a111          	cp	a,#17
1320  0210 2f05          	jrslt	L715
1323  0212 a6ff          	ld	a,#255
1325  0214               L25:
1327  0214 5b04          	addw	sp,#4
1328  0216 81            	ret
1329  0217               L715:
1330                     ; 212             for(i = 0; i < _WIZCHIP_SOCK_NUM_; i++){
1332  0217 0c02          	inc	(OFST+0,sp)
1336  0219 9c            	rvf
1337  021a 7b02          	ld	a,(OFST+0,sp)
1338  021c a108          	cp	a,#8
1339  021e 2fdb          	jrslt	L115
1340                     ; 216             for(i = 0; i < _WIZCHIP_SOCK_NUM_; i++){
1342  0220 0f02          	clr	(OFST+0,sp)
1344  0222               L125:
1345                     ; 217                 setSn_RXBUF_SIZE(i, rxsize[i]);
1347  0222 7b02          	ld	a,(OFST+0,sp)
1348  0224 5f            	clrw	x
1349  0225 4d            	tnz	a
1350  0226 2a01          	jrpl	L64
1351  0228 53            	cplw	x
1352  0229               L64:
1353  0229 97            	ld	xl,a
1354  022a 72fb07        	addw	x,(OFST+5,sp)
1355  022d f6            	ld	a,(x)
1356  022e 88            	push	a
1357  022f 7b03          	ld	a,(OFST+1,sp)
1358  0231 5f            	clrw	x
1359  0232 4d            	tnz	a
1360  0233 2a01          	jrpl	L05
1361  0235 53            	cplw	x
1362  0236               L05:
1363  0236 97            	ld	xl,a
1364  0237 58            	sllw	x
1365  0238 58            	sllw	x
1366  0239 58            	sllw	x
1367  023a 58            	sllw	x
1368  023b 58            	sllw	x
1369  023c 1c1e08        	addw	x,#7688
1370  023f cd0000        	call	c_itolx
1372  0242 be02          	ldw	x,c_lreg+2
1373  0244 89            	pushw	x
1374  0245 be00          	ldw	x,c_lreg
1375  0247 89            	pushw	x
1376  0248 cd0060        	call	_WIZCHIP_WRITE
1378  024b 5b05          	addw	sp,#5
1379                     ; 216             for(i = 0; i < _WIZCHIP_SOCK_NUM_; i++){
1381  024d 0c02          	inc	(OFST+0,sp)
1385  024f 9c            	rvf
1386  0250 7b02          	ld	a,(OFST+0,sp)
1387  0252 a108          	cp	a,#8
1388  0254 2fcc          	jrslt	L125
1389  0256               L705:
1390                     ; 220         return 0;
1392  0256 4f            	clr	a
1394  0257 20bb          	jra	L25
1395  0259               L764:
1396                     ; 223     (void)rxsize;
1398                     ; 225     return 0;
1400  0259 4f            	clr	a
1402  025a 20b8          	jra	L25
1480                     ; 228 int8_t socket(uint8_t sn, uint8_t protocol, uint16_t port, uint8_t flag){
1481                     	switch	.text
1482  025c               _socket:
1484  025c 89            	pushw	x
1485  025d 5204          	subw	sp,#4
1486       00000004      OFST:	set	4
1489                     ; 229     CHECK_SOCKNUM();
1491  025f 7b05          	ld	a,(OFST+1,sp)
1492  0261 a108          	cp	a,#8
1493  0263 2504          	jrult	L106
1496  0265 a6ff          	ld	a,#255
1498  0267 2027          	jra	L07
1499  0269               L106:
1500                     ; 230     switch(protocol)
1502  0269 7b06          	ld	a,(OFST+2,sp)
1503  026b a101          	cp	a,#1
1504  026d 2624          	jrne	L135
1507  026f               L725:
1508                     ; 235             getSIPR((uint8_t*)&taddr);
1510  026f ae0004        	ldw	x,#4
1511  0272 89            	pushw	x
1512  0273 96            	ldw	x,sp
1513  0274 1c0003        	addw	x,#OFST-1
1514  0277 89            	pushw	x
1515  0278 ae000f        	ldw	x,#15
1516  027b 89            	pushw	x
1517  027c ae0000        	ldw	x,#0
1518  027f 89            	pushw	x
1519  0280 cd00b9        	call	_WIZCHIP_READ_BUF
1521  0283 5b08          	addw	sp,#8
1522                     ; 236             if(taddr == 0) return SOCKERR_SOCKINIT;
1524  0285 96            	ldw	x,sp
1525  0286 1c0001        	addw	x,#OFST-3
1526  0289 cd0000        	call	c_lzmp
1528  028c 2605          	jrne	L135
1531  028e a6fd          	ld	a,#253
1533  0290               L07:
1535  0290 5b06          	addw	sp,#6
1536  0292 81            	ret
1537  0293               L135:
1538                     ; 238         default :
1538                     ; 239             return SOCKERR_SOCKMODE;
1540  0293 a6fb          	ld	a,#251
1542  0295 20f9          	jra	L07
1543  0297               L335:
1544                     ; 244             case Sn_MR_TCP:
1544                     ; 245                  if((flag & (SF_TCP_NODELAY|SF_IO_NONBLOCK))==0) return SOCKERR_SOCKFLAG;
1546  0297 7b0b          	ld	a,(OFST+7,sp)
1547  0299 a521          	bcp	a,#33
1548  029b 2604          	jrne	L316
1551  029d a6fa          	ld	a,#250
1553  029f 20ef          	jra	L07
1554  02a1               L535:
1555                     ; 247             default:
1555                     ; 248                break;
1557  02a1               L316:
1558                     ; 251     close(sn);
1560  02a1 7b05          	ld	a,(OFST+1,sp)
1561  02a3 cd03b6        	call	_close
1563                     ; 252     setSn_MR(sn, (protocol | (flag & 0xF0)));
1565  02a6 7b0b          	ld	a,(OFST+7,sp)
1566  02a8 a4f0          	and	a,#240
1567  02aa 1a06          	or	a,(OFST+2,sp)
1568  02ac 88            	push	a
1569  02ad 7b06          	ld	a,(OFST+2,sp)
1570  02af 97            	ld	xl,a
1571  02b0 a604          	ld	a,#4
1572  02b2 42            	mul	x,a
1573  02b3 58            	sllw	x
1574  02b4 58            	sllw	x
1575  02b5 58            	sllw	x
1576  02b6 1c0008        	addw	x,#8
1577  02b9 cd0000        	call	c_itolx
1579  02bc be02          	ldw	x,c_lreg+2
1580  02be 89            	pushw	x
1581  02bf be00          	ldw	x,c_lreg
1582  02c1 89            	pushw	x
1583  02c2 cd0060        	call	_WIZCHIP_WRITE
1585  02c5 5b05          	addw	sp,#5
1586                     ; 253     if(!port)
1588  02c7 1e09          	ldw	x,(OFST+5,sp)
1589  02c9 2618          	jrne	L326
1590                     ; 255         port = sock_any_port++;
1592  02cb be00          	ldw	x,L3_sock_any_port
1593  02cd 1c0001        	addw	x,#1
1594  02d0 bf00          	ldw	L3_sock_any_port,x
1595  02d2 1d0001        	subw	x,#1
1596  02d5 1f09          	ldw	(OFST+5,sp),x
1597                     ; 256         if(sock_any_port == 0xFFF0) sock_any_port = SOCK_ANY_PORT_NUM;
1599  02d7 be00          	ldw	x,L3_sock_any_port
1600  02d9 a3fff0        	cpw	x,#65520
1601  02dc 2605          	jrne	L326
1604  02de aec000        	ldw	x,#49152
1605  02e1 bf00          	ldw	L3_sock_any_port,x
1606  02e3               L326:
1607                     ; 258     setSn_PORT(sn,port);
1609  02e3 7b09          	ld	a,(OFST+5,sp)
1610  02e5 88            	push	a
1611  02e6 7b06          	ld	a,(OFST+2,sp)
1612  02e8 97            	ld	xl,a
1613  02e9 a604          	ld	a,#4
1614  02eb 42            	mul	x,a
1615  02ec 58            	sllw	x
1616  02ed 58            	sllw	x
1617  02ee 58            	sllw	x
1618  02ef 1c0408        	addw	x,#1032
1619  02f2 cd0000        	call	c_itolx
1621  02f5 be02          	ldw	x,c_lreg+2
1622  02f7 89            	pushw	x
1623  02f8 be00          	ldw	x,c_lreg
1624  02fa 89            	pushw	x
1625  02fb cd0060        	call	_WIZCHIP_WRITE
1627  02fe 5b05          	addw	sp,#5
1630  0300 7b0a          	ld	a,(OFST+6,sp)
1631  0302 88            	push	a
1632  0303 7b06          	ld	a,(OFST+2,sp)
1633  0305 97            	ld	xl,a
1634  0306 a604          	ld	a,#4
1635  0308 42            	mul	x,a
1636  0309 58            	sllw	x
1637  030a 58            	sllw	x
1638  030b 58            	sllw	x
1639  030c 1c0508        	addw	x,#1288
1640  030f cd0000        	call	c_itolx
1642  0312 be02          	ldw	x,c_lreg+2
1643  0314 89            	pushw	x
1644  0315 be00          	ldw	x,c_lreg
1645  0317 89            	pushw	x
1646  0318 cd0060        	call	_WIZCHIP_WRITE
1648  031b 5b05          	addw	sp,#5
1649                     ; 259     setSn_CR(sn,Sn_CR_OPEN);
1652  031d 4b01          	push	#1
1653  031f 7b06          	ld	a,(OFST+2,sp)
1654  0321 97            	ld	xl,a
1655  0322 a604          	ld	a,#4
1656  0324 42            	mul	x,a
1657  0325 58            	sllw	x
1658  0326 58            	sllw	x
1659  0327 58            	sllw	x
1660  0328 1c0108        	addw	x,#264
1661  032b cd0000        	call	c_itolx
1663  032e be02          	ldw	x,c_lreg+2
1664  0330 89            	pushw	x
1665  0331 be00          	ldw	x,c_lreg
1666  0333 89            	pushw	x
1667  0334 cd0060        	call	_WIZCHIP_WRITE
1669  0337 5b05          	addw	sp,#5
1671  0339               L136:
1672                     ; 260     while(getSn_CR(sn));
1674  0339 7b05          	ld	a,(OFST+1,sp)
1675  033b 97            	ld	xl,a
1676  033c a604          	ld	a,#4
1677  033e 42            	mul	x,a
1678  033f 58            	sllw	x
1679  0340 58            	sllw	x
1680  0341 58            	sllw	x
1681  0342 1c0108        	addw	x,#264
1682  0345 cd0000        	call	c_itolx
1684  0348 be02          	ldw	x,c_lreg+2
1685  034a 89            	pushw	x
1686  034b be00          	ldw	x,c_lreg
1687  034d 89            	pushw	x
1688  034e cd000b        	call	_WIZCHIP_READ
1690  0351 5b04          	addw	sp,#4
1691  0353 4d            	tnz	a
1692  0354 26e3          	jrne	L136
1693                     ; 261     sock_io_mode &= ~(1 << sn);
1695  0356 ae0001        	ldw	x,#1
1696  0359 7b05          	ld	a,(OFST+1,sp)
1697  035b 4d            	tnz	a
1698  035c 2704          	jreq	L06
1699  035e               L26:
1700  035e 58            	sllw	x
1701  035f 4a            	dec	a
1702  0360 26fc          	jrne	L26
1703  0362               L06:
1704  0362 53            	cplw	x
1705  0363 01            	rrwa	x,a
1706  0364 b41d          	and	a,L52_sock_io_mode+1
1707  0366 01            	rrwa	x,a
1708  0367 b41c          	and	a,L52_sock_io_mode
1709  0369 01            	rrwa	x,a
1710  036a bf1c          	ldw	L52_sock_io_mode,x
1711                     ; 262     sock_io_mode |= ((flag & SF_IO_NONBLOCK) << sn);
1713  036c 7b0b          	ld	a,(OFST+7,sp)
1714  036e a401          	and	a,#1
1715  0370 5f            	clrw	x
1716  0371 97            	ld	xl,a
1717  0372 7b05          	ld	a,(OFST+1,sp)
1718  0374 4d            	tnz	a
1719  0375 2704          	jreq	L46
1720  0377               L66:
1721  0377 58            	sllw	x
1722  0378 4a            	dec	a
1723  0379 26fc          	jrne	L66
1724  037b               L46:
1725  037b 01            	rrwa	x,a
1726  037c ba1d          	or	a,L52_sock_io_mode+1
1727  037e 01            	rrwa	x,a
1728  037f ba1c          	or	a,L52_sock_io_mode
1729  0381 01            	rrwa	x,a
1730  0382 bf1c          	ldw	L52_sock_io_mode,x
1731                     ; 263     sock_remained_size[sn] = 0;
1733  0384 7b05          	ld	a,(OFST+1,sp)
1734  0386 5f            	clrw	x
1735  0387 97            	ld	xl,a
1736  0388 58            	sllw	x
1737  0389 905f          	clrw	y
1738  038b ef02          	ldw	(L12_sock_remained_size,x),y
1739                     ; 264     sock_pack_info[sn] = PACK_COMPLETED;
1741  038d 7b05          	ld	a,(OFST+1,sp)
1742  038f 5f            	clrw	x
1743  0390 97            	ld	xl,a
1744  0391 6f12          	clr	(_sock_pack_info,x)
1746  0393               L146:
1747                     ; 265     while(getSn_SR(sn) == SOCK_CLOSED);
1749  0393 7b05          	ld	a,(OFST+1,sp)
1750  0395 97            	ld	xl,a
1751  0396 a604          	ld	a,#4
1752  0398 42            	mul	x,a
1753  0399 58            	sllw	x
1754  039a 58            	sllw	x
1755  039b 58            	sllw	x
1756  039c 1c0308        	addw	x,#776
1757  039f cd0000        	call	c_itolx
1759  03a2 be02          	ldw	x,c_lreg+2
1760  03a4 89            	pushw	x
1761  03a5 be00          	ldw	x,c_lreg
1762  03a7 89            	pushw	x
1763  03a8 cd000b        	call	_WIZCHIP_READ
1765  03ab 5b04          	addw	sp,#4
1766  03ad 4d            	tnz	a
1767  03ae 27e3          	jreq	L146
1768                     ; 266     return (int8_t)sn;
1770  03b0 7b05          	ld	a,(OFST+1,sp)
1772  03b2 ac900290      	jpf	L07
1812                     ; 268 int8_t close(uint8_t sn){
1813                     	switch	.text
1814  03b6               _close:
1816  03b6 88            	push	a
1817       00000000      OFST:	set	0
1820                     ; 269     CHECK_SOCKNUM();
1822  03b7 7b01          	ld	a,(OFST+1,sp)
1823  03b9 a108          	cp	a,#8
1824  03bb 2505          	jrult	L766
1827  03bd a6ff          	ld	a,#255
1830  03bf 5b01          	addw	sp,#1
1831  03c1 81            	ret
1832  03c2               L766:
1833                     ; 270     setSn_CR(sn,Sn_CR_CLOSE);
1835  03c2 4b10          	push	#16
1836  03c4 7b02          	ld	a,(OFST+2,sp)
1837  03c6 97            	ld	xl,a
1838  03c7 a604          	ld	a,#4
1839  03c9 42            	mul	x,a
1840  03ca 58            	sllw	x
1841  03cb 58            	sllw	x
1842  03cc 58            	sllw	x
1843  03cd 1c0108        	addw	x,#264
1844  03d0 cd0000        	call	c_itolx
1846  03d3 be02          	ldw	x,c_lreg+2
1847  03d5 89            	pushw	x
1848  03d6 be00          	ldw	x,c_lreg
1849  03d8 89            	pushw	x
1850  03d9 cd0060        	call	_WIZCHIP_WRITE
1852  03dc 5b05          	addw	sp,#5
1854  03de               L376:
1855                     ; 271     while(getSn_CR(sn));
1857  03de 7b01          	ld	a,(OFST+1,sp)
1858  03e0 97            	ld	xl,a
1859  03e1 a604          	ld	a,#4
1860  03e3 42            	mul	x,a
1861  03e4 58            	sllw	x
1862  03e5 58            	sllw	x
1863  03e6 58            	sllw	x
1864  03e7 1c0108        	addw	x,#264
1865  03ea cd0000        	call	c_itolx
1867  03ed be02          	ldw	x,c_lreg+2
1868  03ef 89            	pushw	x
1869  03f0 be00          	ldw	x,c_lreg
1870  03f2 89            	pushw	x
1871  03f3 cd000b        	call	_WIZCHIP_READ
1873  03f6 5b04          	addw	sp,#4
1874  03f8 4d            	tnz	a
1875  03f9 26e3          	jrne	L376
1876                     ; 272     setSn_IR(sn, 0xFF);
1878  03fb 4b1f          	push	#31
1879  03fd 7b02          	ld	a,(OFST+2,sp)
1880  03ff 97            	ld	xl,a
1881  0400 a604          	ld	a,#4
1882  0402 42            	mul	x,a
1883  0403 58            	sllw	x
1884  0404 58            	sllw	x
1885  0405 58            	sllw	x
1886  0406 1c0208        	addw	x,#520
1887  0409 cd0000        	call	c_itolx
1889  040c be02          	ldw	x,c_lreg+2
1890  040e 89            	pushw	x
1891  040f be00          	ldw	x,c_lreg
1892  0411 89            	pushw	x
1893  0412 cd0060        	call	_WIZCHIP_WRITE
1895  0415 5b05          	addw	sp,#5
1896                     ; 273     sock_io_mode &= ~(1 << sn);
1898  0417 ae0001        	ldw	x,#1
1899  041a 7b01          	ld	a,(OFST+1,sp)
1900  041c 4d            	tnz	a
1901  041d 2704          	jreq	L47
1902  041f               L67:
1903  041f 58            	sllw	x
1904  0420 4a            	dec	a
1905  0421 26fc          	jrne	L67
1906  0423               L47:
1907  0423 53            	cplw	x
1908  0424 01            	rrwa	x,a
1909  0425 b41d          	and	a,L52_sock_io_mode+1
1910  0427 01            	rrwa	x,a
1911  0428 b41c          	and	a,L52_sock_io_mode
1912  042a 01            	rrwa	x,a
1913  042b bf1c          	ldw	L52_sock_io_mode,x
1914                     ; 274     sock_is_sending &= ~(1 << sn);
1916  042d ae0001        	ldw	x,#1
1917  0430 7b01          	ld	a,(OFST+1,sp)
1918  0432 4d            	tnz	a
1919  0433 2704          	jreq	L001
1920  0435               L201:
1921  0435 58            	sllw	x
1922  0436 4a            	dec	a
1923  0437 26fc          	jrne	L201
1924  0439               L001:
1925  0439 53            	cplw	x
1926  043a 01            	rrwa	x,a
1927  043b b41b          	and	a,L32_sock_is_sending+1
1928  043d 01            	rrwa	x,a
1929  043e b41a          	and	a,L32_sock_is_sending
1930  0440 01            	rrwa	x,a
1931  0441 bf1a          	ldw	L32_sock_is_sending,x
1932                     ; 275     sock_remained_size[sn] = 0;
1934  0443 7b01          	ld	a,(OFST+1,sp)
1935  0445 5f            	clrw	x
1936  0446 97            	ld	xl,a
1937  0447 58            	sllw	x
1938  0448 905f          	clrw	y
1939  044a ef02          	ldw	(L12_sock_remained_size,x),y
1940                     ; 276     sock_pack_info[sn] = 0;
1942  044c 7b01          	ld	a,(OFST+1,sp)
1943  044e 5f            	clrw	x
1944  044f 97            	ld	xl,a
1945  0450 6f12          	clr	(_sock_pack_info,x)
1947  0452               L307:
1948                     ; 277     while(getSn_SR(sn) != SOCK_CLOSED);
1950  0452 7b01          	ld	a,(OFST+1,sp)
1951  0454 97            	ld	xl,a
1952  0455 a604          	ld	a,#4
1953  0457 42            	mul	x,a
1954  0458 58            	sllw	x
1955  0459 58            	sllw	x
1956  045a 58            	sllw	x
1957  045b 1c0308        	addw	x,#776
1958  045e cd0000        	call	c_itolx
1960  0461 be02          	ldw	x,c_lreg+2
1961  0463 89            	pushw	x
1962  0464 be00          	ldw	x,c_lreg
1963  0466 89            	pushw	x
1964  0467 cd000b        	call	_WIZCHIP_READ
1966  046a 5b04          	addw	sp,#4
1967  046c 4d            	tnz	a
1968  046d 26e3          	jrne	L307
1969                     ; 278 	return SOCK_OK;
1971  046f a601          	ld	a,#1
1974  0471 5b01          	addw	sp,#1
1975  0473 81            	ret
2012                     ; 280 int8_t listen(uint8_t sn){
2013                     	switch	.text
2014  0474               _listen:
2016  0474 88            	push	a
2017       00000000      OFST:	set	0
2020                     ; 281     CHECK_SOCKNUM();
2022  0475 7b01          	ld	a,(OFST+1,sp)
2023  0477 a108          	cp	a,#8
2024  0479 2505          	jrult	L337
2027  047b a6ff          	ld	a,#255
2030  047d 5b01          	addw	sp,#1
2031  047f 81            	ret
2032  0480               L337:
2033                     ; 282     CHECK_SOCKMODE(Sn_MR_TCP);
2035  0480 7b01          	ld	a,(OFST+1,sp)
2036  0482 97            	ld	xl,a
2037  0483 a604          	ld	a,#4
2038  0485 42            	mul	x,a
2039  0486 58            	sllw	x
2040  0487 58            	sllw	x
2041  0488 58            	sllw	x
2042  0489 1c0008        	addw	x,#8
2043  048c cd0000        	call	c_itolx
2045  048f be02          	ldw	x,c_lreg+2
2046  0491 89            	pushw	x
2047  0492 be00          	ldw	x,c_lreg
2048  0494 89            	pushw	x
2049  0495 cd000b        	call	_WIZCHIP_READ
2051  0498 5b04          	addw	sp,#4
2052  049a a40f          	and	a,#15
2053  049c a101          	cp	a,#1
2054  049e 2705          	jreq	L147
2057  04a0 a6fb          	ld	a,#251
2060  04a2 5b01          	addw	sp,#1
2061  04a4 81            	ret
2062  04a5               L147:
2063                     ; 283     CHECK_SOCKINIT();
2065  04a5 7b01          	ld	a,(OFST+1,sp)
2066  04a7 97            	ld	xl,a
2067  04a8 a604          	ld	a,#4
2068  04aa 42            	mul	x,a
2069  04ab 58            	sllw	x
2070  04ac 58            	sllw	x
2071  04ad 58            	sllw	x
2072  04ae 1c0308        	addw	x,#776
2073  04b1 cd0000        	call	c_itolx
2075  04b4 be02          	ldw	x,c_lreg+2
2076  04b6 89            	pushw	x
2077  04b7 be00          	ldw	x,c_lreg
2078  04b9 89            	pushw	x
2079  04ba cd000b        	call	_WIZCHIP_READ
2081  04bd 5b04          	addw	sp,#4
2082  04bf a113          	cp	a,#19
2083  04c1 2705          	jreq	L547
2086  04c3 a6fd          	ld	a,#253
2089  04c5 5b01          	addw	sp,#1
2090  04c7 81            	ret
2091  04c8               L547:
2092                     ; 284     setSn_CR(sn,Sn_CR_LISTEN);
2094  04c8 4b02          	push	#2
2095  04ca 7b02          	ld	a,(OFST+2,sp)
2096  04cc 97            	ld	xl,a
2097  04cd a604          	ld	a,#4
2098  04cf 42            	mul	x,a
2099  04d0 58            	sllw	x
2100  04d1 58            	sllw	x
2101  04d2 58            	sllw	x
2102  04d3 1c0108        	addw	x,#264
2103  04d6 cd0000        	call	c_itolx
2105  04d9 be02          	ldw	x,c_lreg+2
2106  04db 89            	pushw	x
2107  04dc be00          	ldw	x,c_lreg
2108  04de 89            	pushw	x
2109  04df cd0060        	call	_WIZCHIP_WRITE
2111  04e2 5b05          	addw	sp,#5
2113  04e4               L157:
2114                     ; 285     while(getSn_CR(sn));
2116  04e4 7b01          	ld	a,(OFST+1,sp)
2117  04e6 97            	ld	xl,a
2118  04e7 a604          	ld	a,#4
2119  04e9 42            	mul	x,a
2120  04ea 58            	sllw	x
2121  04eb 58            	sllw	x
2122  04ec 58            	sllw	x
2123  04ed 1c0108        	addw	x,#264
2124  04f0 cd0000        	call	c_itolx
2126  04f3 be02          	ldw	x,c_lreg+2
2127  04f5 89            	pushw	x
2128  04f6 be00          	ldw	x,c_lreg
2129  04f8 89            	pushw	x
2130  04f9 cd000b        	call	_WIZCHIP_READ
2132  04fc 5b04          	addw	sp,#4
2133  04fe 4d            	tnz	a
2134  04ff 26e3          	jrne	L157
2136  0501 200a          	jra	L757
2137  0503               L557:
2138                     ; 288         close(sn);
2140  0503 7b01          	ld	a,(OFST+1,sp)
2141  0505 cd03b6        	call	_close
2143                     ; 289         return SOCKERR_SOCKCLOSED;
2145  0508 a6fc          	ld	a,#252
2148  050a 5b01          	addw	sp,#1
2149  050c 81            	ret
2150  050d               L757:
2151                     ; 286     while(getSn_SR(sn) != SOCK_LISTEN)
2153  050d 7b01          	ld	a,(OFST+1,sp)
2154  050f 97            	ld	xl,a
2155  0510 a604          	ld	a,#4
2156  0512 42            	mul	x,a
2157  0513 58            	sllw	x
2158  0514 58            	sllw	x
2159  0515 58            	sllw	x
2160  0516 1c0308        	addw	x,#776
2161  0519 cd0000        	call	c_itolx
2163  051c be02          	ldw	x,c_lreg+2
2164  051e 89            	pushw	x
2165  051f be00          	ldw	x,c_lreg
2166  0521 89            	pushw	x
2167  0522 cd000b        	call	_WIZCHIP_READ
2169  0525 5b04          	addw	sp,#4
2170  0527 a114          	cp	a,#20
2171  0529 26d8          	jrne	L557
2172                     ; 291     return SOCK_OK;
2174  052b a601          	ld	a,#1
2177  052d 5b01          	addw	sp,#1
2178  052f 81            	ret
2421                     	xdef	_sock_pack_info
2422                     	xdef	_listen
2423                     	xdef	_close
2424                     	xdef	_socket
2425                     	xdef	_wizchip_init
2426                     	xdef	_reg_wizchip_spiburst_cbfunc
2427                     	xdef	_reg_wizchip_spi_cbfunc
2428                     	xdef	_reg_wizchip_cs_cbfunc
2429                     	xdef	_WIZCHIP_READ_BUF
2430                     	xdef	_WIZCHIP_READ
2431                     	xdef	_WIZCHIP_WRITE
2432                     	xdef	_WIZCHIP
2433                     	xref.b	c_lreg
2452                     	xref	c_lzmp
2453                     	xref	c_itolx
2454                     	end
