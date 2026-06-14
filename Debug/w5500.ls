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
 889                     ; 137 uint16_t getSn_TX_FSR(uint8_t sn)
 889                     ; 138 {
 890                     	switch	.text
 891  012b               _getSn_TX_FSR:
 893  012b 88            	push	a
 894  012c 5205          	subw	sp,#5
 895       00000005      OFST:	set	5
 898                     ; 139    uint16_t val=0,val1=0;
 900  012e 5f            	clrw	x
 901  012f 1f02          	ldw	(OFST-3,sp),x
 905  0131               L353:
 906                     ; 143       val1 = WIZCHIP_READ(Sn_TX_FSR(sn));
 908  0131 7b06          	ld	a,(OFST+1,sp)
 909  0133 97            	ld	xl,a
 910  0134 a604          	ld	a,#4
 911  0136 42            	mul	x,a
 912  0137 58            	sllw	x
 913  0138 58            	sllw	x
 914  0139 58            	sllw	x
 915  013a 1c2008        	addw	x,#8200
 916  013d cd0000        	call	c_itolx
 918  0140 be02          	ldw	x,c_lreg+2
 919  0142 89            	pushw	x
 920  0143 be00          	ldw	x,c_lreg
 921  0145 89            	pushw	x
 922  0146 cd000b        	call	_WIZCHIP_READ
 924  0149 5b04          	addw	sp,#4
 925  014b 5f            	clrw	x
 926  014c 97            	ld	xl,a
 927  014d 1f04          	ldw	(OFST-1,sp),x
 929                     ; 144       val1 = (val1 << 8) + WIZCHIP_READ(WIZCHIP_OFFSET_INC(Sn_TX_FSR(sn),1));
 931  014f 7b06          	ld	a,(OFST+1,sp)
 932  0151 97            	ld	xl,a
 933  0152 a604          	ld	a,#4
 934  0154 42            	mul	x,a
 935  0155 58            	sllw	x
 936  0156 58            	sllw	x
 937  0157 58            	sllw	x
 938  0158 1c2108        	addw	x,#8456
 939  015b cd0000        	call	c_itolx
 941  015e be02          	ldw	x,c_lreg+2
 942  0160 89            	pushw	x
 943  0161 be00          	ldw	x,c_lreg
 944  0163 89            	pushw	x
 945  0164 cd000b        	call	_WIZCHIP_READ
 947  0167 5b04          	addw	sp,#4
 948  0169 6b01          	ld	(OFST-4,sp),a
 950  016b 1e04          	ldw	x,(OFST-1,sp)
 951  016d 4f            	clr	a
 952  016e 02            	rlwa	x,a
 953  016f 01            	rrwa	x,a
 954  0170 1b01          	add	a,(OFST-4,sp)
 955  0172 2401          	jrnc	L03
 956  0174 5c            	incw	x
 957  0175               L03:
 958  0175 02            	rlwa	x,a
 959  0176 1f04          	ldw	(OFST-1,sp),x
 960  0178 01            	rrwa	x,a
 962                     ; 145       if (val1 != 0)
 964  0179 1e04          	ldw	x,(OFST-1,sp)
 965  017b 2748          	jreq	L553
 966                     ; 147         val = WIZCHIP_READ(Sn_TX_FSR(sn));
 968  017d 7b06          	ld	a,(OFST+1,sp)
 969  017f 97            	ld	xl,a
 970  0180 a604          	ld	a,#4
 971  0182 42            	mul	x,a
 972  0183 58            	sllw	x
 973  0184 58            	sllw	x
 974  0185 58            	sllw	x
 975  0186 1c2008        	addw	x,#8200
 976  0189 cd0000        	call	c_itolx
 978  018c be02          	ldw	x,c_lreg+2
 979  018e 89            	pushw	x
 980  018f be00          	ldw	x,c_lreg
 981  0191 89            	pushw	x
 982  0192 cd000b        	call	_WIZCHIP_READ
 984  0195 5b04          	addw	sp,#4
 985  0197 5f            	clrw	x
 986  0198 97            	ld	xl,a
 987  0199 1f02          	ldw	(OFST-3,sp),x
 989                     ; 148         val = (val << 8) + WIZCHIP_READ(WIZCHIP_OFFSET_INC(Sn_TX_FSR(sn),1));
 991  019b 7b06          	ld	a,(OFST+1,sp)
 992  019d 97            	ld	xl,a
 993  019e a604          	ld	a,#4
 994  01a0 42            	mul	x,a
 995  01a1 58            	sllw	x
 996  01a2 58            	sllw	x
 997  01a3 58            	sllw	x
 998  01a4 1c2108        	addw	x,#8456
 999  01a7 cd0000        	call	c_itolx
1001  01aa be02          	ldw	x,c_lreg+2
1002  01ac 89            	pushw	x
1003  01ad be00          	ldw	x,c_lreg
1004  01af 89            	pushw	x
1005  01b0 cd000b        	call	_WIZCHIP_READ
1007  01b3 5b04          	addw	sp,#4
1008  01b5 6b01          	ld	(OFST-4,sp),a
1010  01b7 1e02          	ldw	x,(OFST-3,sp)
1011  01b9 4f            	clr	a
1012  01ba 02            	rlwa	x,a
1013  01bb 01            	rrwa	x,a
1014  01bc 1b01          	add	a,(OFST-4,sp)
1015  01be 2401          	jrnc	L23
1016  01c0 5c            	incw	x
1017  01c1               L23:
1018  01c1 02            	rlwa	x,a
1019  01c2 1f02          	ldw	(OFST-3,sp),x
1020  01c4 01            	rrwa	x,a
1022  01c5               L553:
1023                     ; 150    }while (val != val1);
1025  01c5 1e02          	ldw	x,(OFST-3,sp)
1026  01c7 1304          	cpw	x,(OFST-1,sp)
1027  01c9 2703          	jreq	L43
1028  01cb cc0131        	jp	L353
1029  01ce               L43:
1030                     ; 151    return val;
1032  01ce 1e02          	ldw	x,(OFST-3,sp)
1035  01d0 5b06          	addw	sp,#6
1036  01d2 81            	ret
1089                     ; 153 uint16_t getSn_RX_RSR(uint8_t sn)
1089                     ; 154 {
1090                     	switch	.text
1091  01d3               _getSn_RX_RSR:
1093  01d3 88            	push	a
1094  01d4 5205          	subw	sp,#5
1095       00000005      OFST:	set	5
1098                     ; 155    uint16_t val=0,val1=0;
1100  01d6 5f            	clrw	x
1101  01d7 1f02          	ldw	(OFST-3,sp),x
1105  01d9               L114:
1106                     ; 159       val1 = WIZCHIP_READ(Sn_RX_RSR(sn));
1108  01d9 7b06          	ld	a,(OFST+1,sp)
1109  01db 97            	ld	xl,a
1110  01dc a604          	ld	a,#4
1111  01de 42            	mul	x,a
1112  01df 58            	sllw	x
1113  01e0 58            	sllw	x
1114  01e1 58            	sllw	x
1115  01e2 1c2608        	addw	x,#9736
1116  01e5 cd0000        	call	c_itolx
1118  01e8 be02          	ldw	x,c_lreg+2
1119  01ea 89            	pushw	x
1120  01eb be00          	ldw	x,c_lreg
1121  01ed 89            	pushw	x
1122  01ee cd000b        	call	_WIZCHIP_READ
1124  01f1 5b04          	addw	sp,#4
1125  01f3 5f            	clrw	x
1126  01f4 97            	ld	xl,a
1127  01f5 1f04          	ldw	(OFST-1,sp),x
1129                     ; 160       val1 = (val1 << 8) + WIZCHIP_READ(WIZCHIP_OFFSET_INC(Sn_RX_RSR(sn),1));
1131  01f7 7b06          	ld	a,(OFST+1,sp)
1132  01f9 97            	ld	xl,a
1133  01fa a604          	ld	a,#4
1134  01fc 42            	mul	x,a
1135  01fd 58            	sllw	x
1136  01fe 58            	sllw	x
1137  01ff 58            	sllw	x
1138  0200 1c2708        	addw	x,#9992
1139  0203 cd0000        	call	c_itolx
1141  0206 be02          	ldw	x,c_lreg+2
1142  0208 89            	pushw	x
1143  0209 be00          	ldw	x,c_lreg
1144  020b 89            	pushw	x
1145  020c cd000b        	call	_WIZCHIP_READ
1147  020f 5b04          	addw	sp,#4
1148  0211 6b01          	ld	(OFST-4,sp),a
1150  0213 1e04          	ldw	x,(OFST-1,sp)
1151  0215 4f            	clr	a
1152  0216 02            	rlwa	x,a
1153  0217 01            	rrwa	x,a
1154  0218 1b01          	add	a,(OFST-4,sp)
1155  021a 2401          	jrnc	L04
1156  021c 5c            	incw	x
1157  021d               L04:
1158  021d 02            	rlwa	x,a
1159  021e 1f04          	ldw	(OFST-1,sp),x
1160  0220 01            	rrwa	x,a
1162                     ; 161       if (val1 != 0)
1164  0221 1e04          	ldw	x,(OFST-1,sp)
1165  0223 2748          	jreq	L314
1166                     ; 163         val = WIZCHIP_READ(Sn_RX_RSR(sn));
1168  0225 7b06          	ld	a,(OFST+1,sp)
1169  0227 97            	ld	xl,a
1170  0228 a604          	ld	a,#4
1171  022a 42            	mul	x,a
1172  022b 58            	sllw	x
1173  022c 58            	sllw	x
1174  022d 58            	sllw	x
1175  022e 1c2608        	addw	x,#9736
1176  0231 cd0000        	call	c_itolx
1178  0234 be02          	ldw	x,c_lreg+2
1179  0236 89            	pushw	x
1180  0237 be00          	ldw	x,c_lreg
1181  0239 89            	pushw	x
1182  023a cd000b        	call	_WIZCHIP_READ
1184  023d 5b04          	addw	sp,#4
1185  023f 5f            	clrw	x
1186  0240 97            	ld	xl,a
1187  0241 1f02          	ldw	(OFST-3,sp),x
1189                     ; 164         val = (val << 8) + WIZCHIP_READ(WIZCHIP_OFFSET_INC(Sn_RX_RSR(sn),1));
1191  0243 7b06          	ld	a,(OFST+1,sp)
1192  0245 97            	ld	xl,a
1193  0246 a604          	ld	a,#4
1194  0248 42            	mul	x,a
1195  0249 58            	sllw	x
1196  024a 58            	sllw	x
1197  024b 58            	sllw	x
1198  024c 1c2708        	addw	x,#9992
1199  024f cd0000        	call	c_itolx
1201  0252 be02          	ldw	x,c_lreg+2
1202  0254 89            	pushw	x
1203  0255 be00          	ldw	x,c_lreg
1204  0257 89            	pushw	x
1205  0258 cd000b        	call	_WIZCHIP_READ
1207  025b 5b04          	addw	sp,#4
1208  025d 6b01          	ld	(OFST-4,sp),a
1210  025f 1e02          	ldw	x,(OFST-3,sp)
1211  0261 4f            	clr	a
1212  0262 02            	rlwa	x,a
1213  0263 01            	rrwa	x,a
1214  0264 1b01          	add	a,(OFST-4,sp)
1215  0266 2401          	jrnc	L24
1216  0268 5c            	incw	x
1217  0269               L24:
1218  0269 02            	rlwa	x,a
1219  026a 1f02          	ldw	(OFST-3,sp),x
1220  026c 01            	rrwa	x,a
1222  026d               L314:
1223                     ; 166    }while (val != val1);
1225  026d 1e02          	ldw	x,(OFST-3,sp)
1226  026f 1304          	cpw	x,(OFST-1,sp)
1227  0271 2703          	jreq	L44
1228  0273 cc01d9        	jp	L114
1229  0276               L44:
1230                     ; 167    return val;
1232  0276 1e02          	ldw	x,(OFST-3,sp)
1235  0278 5b06          	addw	sp,#6
1236  027a 81            	ret
1309                     ; 169 void     WIZCHIP_WRITE_BUF(uint32_t AddrSel, uint8_t* pBuf, uint16_t len)
1309                     ; 170 {
1310                     	switch	.text
1311  027b               _WIZCHIP_WRITE_BUF:
1313  027b 5205          	subw	sp,#5
1314       00000005      OFST:	set	5
1317                     ; 174    WIZCHIP_CRITICAL_ENTER();
1319  027d 92cd26        	call	[_WIZCHIP+8.w]
1321                     ; 175    WIZCHIP.CS._select();
1323  0280 92cd2a        	call	[_WIZCHIP+12.w]
1325                     ; 177    AddrSel |= (_W5500_SPI_WRITE_ | _W5500_SPI_VDM_OP_);
1327  0283 7b0b          	ld	a,(OFST+6,sp)
1328  0285 aa04          	or	a,#4
1329  0287 6b0b          	ld	(OFST+6,sp),a
1330                     ; 179    if(!WIZCHIP.IF._SPI._write_burst) 	// byte operation
1332  0289 be34          	ldw	x,_WIZCHIP+22
1333  028b 2632          	jrne	L754
1334                     ; 181 		WIZCHIP.IF._SPI._write_byte((AddrSel & 0x00FF0000) >> 16);
1336  028d 7b09          	ld	a,(OFST+4,sp)
1337  028f a4ff          	and	a,#255
1338  0291 92cd30        	call	[_WIZCHIP+18.w]
1340                     ; 182 		WIZCHIP.IF._SPI._write_byte((AddrSel & 0x0000FF00) >>  8);
1342  0294 7b0a          	ld	a,(OFST+5,sp)
1343  0296 a4ff          	and	a,#255
1344  0298 92cd30        	call	[_WIZCHIP+18.w]
1346                     ; 183 		WIZCHIP.IF._SPI._write_byte((AddrSel & 0x000000FF) >>  0);
1348  029b 7b0b          	ld	a,(OFST+6,sp)
1349  029d a4ff          	and	a,#255
1350  029f 92cd30        	call	[_WIZCHIP+18.w]
1352                     ; 184 		for(i = 0; i < len; i++)
1354  02a2 5f            	clrw	x
1355  02a3 1f04          	ldw	(OFST-1,sp),x
1358  02a5 2010          	jra	L564
1359  02a7               L164:
1360                     ; 185 			WIZCHIP.IF._SPI._write_byte(pBuf[i]);
1362  02a7 1e0c          	ldw	x,(OFST+7,sp)
1363  02a9 72fb04        	addw	x,(OFST-1,sp)
1364  02ac f6            	ld	a,(x)
1365  02ad 92cd30        	call	[_WIZCHIP+18.w]
1367                     ; 184 		for(i = 0; i < len; i++)
1369  02b0 1e04          	ldw	x,(OFST-1,sp)
1370  02b2 1c0001        	addw	x,#1
1371  02b5 1f04          	ldw	(OFST-1,sp),x
1373  02b7               L564:
1376  02b7 1e04          	ldw	x,(OFST-1,sp)
1377  02b9 130e          	cpw	x,(OFST+9,sp)
1378  02bb 25ea          	jrult	L164
1380  02bd 2027          	jra	L174
1381  02bf               L754:
1382                     ; 189 		spi_data[0] = (AddrSel & 0x00FF0000) >> 16;
1384  02bf 7b09          	ld	a,(OFST+4,sp)
1385  02c1 a4ff          	and	a,#255
1386  02c3 6b01          	ld	(OFST-4,sp),a
1388                     ; 190 		spi_data[1] = (AddrSel & 0x0000FF00) >> 8;
1390  02c5 7b0a          	ld	a,(OFST+5,sp)
1391  02c7 a4ff          	and	a,#255
1392  02c9 6b02          	ld	(OFST-3,sp),a
1394                     ; 191 		spi_data[2] = (AddrSel & 0x000000FF) >> 0;
1396  02cb 7b0b          	ld	a,(OFST+6,sp)
1397  02cd a4ff          	and	a,#255
1398  02cf 6b03          	ld	(OFST-2,sp),a
1400                     ; 192 		WIZCHIP.IF._SPI._write_burst(spi_data, 3);
1402  02d1 ae0003        	ldw	x,#3
1403  02d4 89            	pushw	x
1404  02d5 96            	ldw	x,sp
1405  02d6 1c0003        	addw	x,#OFST-2
1406  02d9 92cd34        	call	[_WIZCHIP+22.w]
1408  02dc 85            	popw	x
1409                     ; 193 		WIZCHIP.IF._SPI._write_burst(pBuf, len);
1411  02dd 1e0e          	ldw	x,(OFST+9,sp)
1412  02df 89            	pushw	x
1413  02e0 1e0e          	ldw	x,(OFST+9,sp)
1414  02e2 92cd34        	call	[_WIZCHIP+22.w]
1416  02e5 85            	popw	x
1417  02e6               L174:
1418                     ; 196    WIZCHIP.CS._deselect();
1420  02e6 92cd2c        	call	[_WIZCHIP+14.w]
1422                     ; 197    WIZCHIP_CRITICAL_EXIT();
1424  02e9 92cd28        	call	[_WIZCHIP+10.w]
1426                     ; 198 }
1429  02ec 5b05          	addw	sp,#5
1430  02ee 81            	ret
1504                     ; 199 void wiz_send_data(uint8_t sn, uint8_t *wizdata, uint16_t len)
1504                     ; 200 {
1505                     	switch	.text
1506  02ef               _wiz_send_data:
1508  02ef 88            	push	a
1509  02f0 520a          	subw	sp,#10
1510       0000000a      OFST:	set	10
1513                     ; 201    uint16_t ptr = 0;
1515                     ; 202    uint32_t addrsel = 0;
1517                     ; 204    if(len == 0)  return;
1519  02f2 1e10          	ldw	x,(OFST+6,sp)
1520  02f4 2603          	jrne	L65
1521  02f6 cc03bc        	jp	L45
1522  02f9               L65:
1525                     ; 205    ptr = getSn_TX_WR(sn);
1527  02f9 7b0b          	ld	a,(OFST+1,sp)
1528  02fb 97            	ld	xl,a
1529  02fc a604          	ld	a,#4
1530  02fe 42            	mul	x,a
1531  02ff 58            	sllw	x
1532  0300 58            	sllw	x
1533  0301 58            	sllw	x
1534  0302 1c2508        	addw	x,#9480
1535  0305 cd0000        	call	c_itolx
1537  0308 be02          	ldw	x,c_lreg+2
1538  030a 89            	pushw	x
1539  030b be00          	ldw	x,c_lreg
1540  030d 89            	pushw	x
1541  030e cd000b        	call	_WIZCHIP_READ
1543  0311 5b04          	addw	sp,#4
1544  0313 6b04          	ld	(OFST-6,sp),a
1546  0315 7b0b          	ld	a,(OFST+1,sp)
1547  0317 97            	ld	xl,a
1548  0318 a604          	ld	a,#4
1549  031a 42            	mul	x,a
1550  031b 58            	sllw	x
1551  031c 58            	sllw	x
1552  031d 58            	sllw	x
1553  031e 1c2408        	addw	x,#9224
1554  0321 cd0000        	call	c_itolx
1556  0324 be02          	ldw	x,c_lreg+2
1557  0326 89            	pushw	x
1558  0327 be00          	ldw	x,c_lreg
1559  0329 89            	pushw	x
1560  032a cd000b        	call	_WIZCHIP_READ
1562  032d 5b04          	addw	sp,#4
1563  032f 5f            	clrw	x
1564  0330 97            	ld	xl,a
1565  0331 4f            	clr	a
1566  0332 02            	rlwa	x,a
1567  0333 01            	rrwa	x,a
1568  0334 1b04          	add	a,(OFST-6,sp)
1569  0336 2401          	jrnc	L25
1570  0338 5c            	incw	x
1571  0339               L25:
1572  0339 02            	rlwa	x,a
1573  033a 1f09          	ldw	(OFST-1,sp),x
1574  033c 01            	rrwa	x,a
1576                     ; 208    addrsel = ((uint32_t)ptr << 8) + (WIZCHIP_TXBUF_BLOCK(sn) << 3);
1578  033d 7b0b          	ld	a,(OFST+1,sp)
1579  033f 97            	ld	xl,a
1580  0340 a604          	ld	a,#4
1581  0342 42            	mul	x,a
1582  0343 58            	sllw	x
1583  0344 58            	sllw	x
1584  0345 58            	sllw	x
1585  0346 1c0010        	addw	x,#16
1586  0349 cd0000        	call	c_itolx
1588  034c 96            	ldw	x,sp
1589  034d 1c0001        	addw	x,#OFST-9
1590  0350 cd0000        	call	c_rtol
1593  0353 1e09          	ldw	x,(OFST-1,sp)
1594  0355 90ae0100      	ldw	y,#256
1595  0359 cd0000        	call	c_umul
1597  035c 96            	ldw	x,sp
1598  035d 1c0001        	addw	x,#OFST-9
1599  0360 cd0000        	call	c_ladd
1601  0363 96            	ldw	x,sp
1602  0364 1c0005        	addw	x,#OFST-5
1603  0367 cd0000        	call	c_rtol
1606                     ; 210    WIZCHIP_WRITE_BUF(addrsel,wizdata, len);
1608  036a 1e10          	ldw	x,(OFST+6,sp)
1609  036c 89            	pushw	x
1610  036d 1e10          	ldw	x,(OFST+6,sp)
1611  036f 89            	pushw	x
1612  0370 1e0b          	ldw	x,(OFST+1,sp)
1613  0372 89            	pushw	x
1614  0373 1e0b          	ldw	x,(OFST+1,sp)
1615  0375 89            	pushw	x
1616  0376 cd027b        	call	_WIZCHIP_WRITE_BUF
1618  0379 5b08          	addw	sp,#8
1619                     ; 212    ptr += len;
1621  037b 1e09          	ldw	x,(OFST-1,sp)
1622  037d 72fb10        	addw	x,(OFST+6,sp)
1623  0380 1f09          	ldw	(OFST-1,sp),x
1625                     ; 213    setSn_TX_WR(sn,ptr);
1627  0382 7b09          	ld	a,(OFST-1,sp)
1628  0384 88            	push	a
1629  0385 7b0c          	ld	a,(OFST+2,sp)
1630  0387 97            	ld	xl,a
1631  0388 a604          	ld	a,#4
1632  038a 42            	mul	x,a
1633  038b 58            	sllw	x
1634  038c 58            	sllw	x
1635  038d 58            	sllw	x
1636  038e 1c2408        	addw	x,#9224
1637  0391 cd0000        	call	c_itolx
1639  0394 be02          	ldw	x,c_lreg+2
1640  0396 89            	pushw	x
1641  0397 be00          	ldw	x,c_lreg
1642  0399 89            	pushw	x
1643  039a cd0060        	call	_WIZCHIP_WRITE
1645  039d 5b05          	addw	sp,#5
1648  039f 7b0a          	ld	a,(OFST+0,sp)
1649  03a1 88            	push	a
1650  03a2 7b0c          	ld	a,(OFST+2,sp)
1651  03a4 97            	ld	xl,a
1652  03a5 a604          	ld	a,#4
1653  03a7 42            	mul	x,a
1654  03a8 58            	sllw	x
1655  03a9 58            	sllw	x
1656  03aa 58            	sllw	x
1657  03ab 1c2508        	addw	x,#9480
1658  03ae cd0000        	call	c_itolx
1660  03b1 be02          	ldw	x,c_lreg+2
1661  03b3 89            	pushw	x
1662  03b4 be00          	ldw	x,c_lreg
1663  03b6 89            	pushw	x
1664  03b7 cd0060        	call	_WIZCHIP_WRITE
1666  03ba 5b05          	addw	sp,#5
1667                     ; 214 }
1668  03bc               L45:
1672  03bc 5b0b          	addw	sp,#11
1673  03be 81            	ret
1726                     ; 215 void reg_wizchip_cs_cbfunc(void(*cs_sel)(void),
1726                     ; 216                            void(*cs_desel)(void))
1726                     ; 217 {
1727                     	switch	.text
1728  03bf               _reg_wizchip_cs_cbfunc:
1730  03bf 89            	pushw	x
1731       00000000      OFST:	set	0
1734                     ; 218     if((cs_sel == 0) || (cs_desel == 0))
1736  03c0 a30000        	cpw	x,#0
1737  03c3 2704          	jreq	L755
1739  03c5 1e05          	ldw	x,(OFST+5,sp)
1740  03c7 260c          	jrne	L555
1741  03c9               L755:
1742                     ; 220         WIZCHIP.CS._select   = wizchip_cs_select;
1744  03c9 ae0000        	ldw	x,#L72_wizchip_cs_select
1745  03cc bf2a          	ldw	_WIZCHIP+12,x
1746                     ; 221         WIZCHIP.CS._deselect = wizchip_cs_deselect;
1748  03ce ae0001        	ldw	x,#L74_wizchip_cs_deselect
1749  03d1 bf2c          	ldw	_WIZCHIP+14,x
1751  03d3               L165:
1752                     ; 228 }
1755  03d3 85            	popw	x
1756  03d4 81            	ret
1757  03d5               L555:
1758                     ; 225         WIZCHIP.CS._select   = cs_sel;
1760  03d5 1e01          	ldw	x,(OFST+1,sp)
1761  03d7 bf2a          	ldw	_WIZCHIP+12,x
1762                     ; 226         WIZCHIP.CS._deselect = cs_desel;
1764  03d9 1e05          	ldw	x,(OFST+5,sp)
1765  03db bf2c          	ldw	_WIZCHIP+14,x
1766  03dd 20f4          	jra	L165
1819                     ; 232 void reg_wizchip_spi_cbfunc(
1819                     ; 233     uint8_t (*spi_rb)(void),
1819                     ; 234     void (*spi_wb)(uint8_t wb)
1819                     ; 235 )
1819                     ; 236 {
1820                     	switch	.text
1821  03df               _reg_wizchip_spi_cbfunc:
1823  03df 89            	pushw	x
1824       00000000      OFST:	set	0
1827                     ; 237     if((spi_rb == 0) || (spi_wb == 0))
1829  03e0 a30000        	cpw	x,#0
1830  03e3 2704          	jreq	L706
1832  03e5 1e05          	ldw	x,(OFST+5,sp)
1833  03e7 260c          	jrne	L506
1834  03e9               L706:
1835                     ; 239         WIZCHIP.IF._SPI._read_byte  = wizchip_spi_readbyte;
1837  03e9 ae0002        	ldw	x,#L16_wizchip_spi_readbyte
1838  03ec bf2e          	ldw	_WIZCHIP+16,x
1839                     ; 240         WIZCHIP.IF._SPI._write_byte = wizchip_spi_writebyte;
1841  03ee ae0004        	ldw	x,#L37_wizchip_spi_writebyte
1842  03f1 bf30          	ldw	_WIZCHIP+18,x
1844  03f3               L116:
1845                     ; 247 }
1848  03f3 85            	popw	x
1849  03f4 81            	ret
1850  03f5               L506:
1851                     ; 244         WIZCHIP.IF._SPI._read_byte  = spi_rb;
1853  03f5 1e01          	ldw	x,(OFST+1,sp)
1854  03f7 bf2e          	ldw	_WIZCHIP+16,x
1855                     ; 245         WIZCHIP.IF._SPI._write_byte = spi_wb;
1857  03f9 1e05          	ldw	x,(OFST+5,sp)
1858  03fb bf30          	ldw	_WIZCHIP+18,x
1859  03fd 20f4          	jra	L116
1912                     ; 251 void reg_wizchip_spiburst_cbfunc(
1912                     ; 252     void (*spi_rb)(uint8_t* pBuf, uint16_t len),
1912                     ; 253     void (*spi_wb)(uint8_t* pBuf, uint16_t len)
1912                     ; 254 )
1912                     ; 255 {
1913                     	switch	.text
1914  03ff               _reg_wizchip_spiburst_cbfunc:
1916  03ff 89            	pushw	x
1917       00000000      OFST:	set	0
1920                     ; 256     if((spi_rb == 0) || (spi_wb == 0))
1922  0400 a30000        	cpw	x,#0
1923  0403 2704          	jreq	L736
1925  0405 1e05          	ldw	x,(OFST+5,sp)
1926  0407 260c          	jrne	L536
1927  0409               L736:
1928                     ; 258         WIZCHIP.IF._SPI._read_burst  = wizchip_spi_readburst;
1930  0409 ae0005        	ldw	x,#L311_wizchip_spi_readburst
1931  040c bf32          	ldw	_WIZCHIP+20,x
1932                     ; 259         WIZCHIP.IF._SPI._write_burst = wizchip_spi_writeburst;
1934  040e ae0008        	ldw	x,#L731_wizchip_spi_writeburst
1935  0411 bf34          	ldw	_WIZCHIP+22,x
1937  0413               L146:
1938                     ; 266 }
1941  0413 85            	popw	x
1942  0414 81            	ret
1943  0415               L536:
1944                     ; 263         WIZCHIP.IF._SPI._read_burst  = spi_rb;
1946  0415 1e01          	ldw	x,(OFST+1,sp)
1947  0417 bf32          	ldw	_WIZCHIP+20,x
1948                     ; 264         WIZCHIP.IF._SPI._write_burst = spi_wb;
1950  0419 1e05          	ldw	x,(OFST+5,sp)
1951  041b bf34          	ldw	_WIZCHIP+22,x
1952  041d 20f4          	jra	L146
2047                     ; 268 void wizchip_setnetinfo(wiz_NetInfo* pnetinfo)
2047                     ; 269 {
2048                     	switch	.text
2049  041f               _wizchip_setnetinfo:
2051  041f 89            	pushw	x
2052       00000000      OFST:	set	0
2055                     ; 270    setSHAR(pnetinfo->mac);
2057  0420 ae0006        	ldw	x,#6
2058  0423 89            	pushw	x
2059  0424 1e03          	ldw	x,(OFST+3,sp)
2060  0426 89            	pushw	x
2061  0427 ae0009        	ldw	x,#9
2062  042a 89            	pushw	x
2063  042b ae0000        	ldw	x,#0
2064  042e 89            	pushw	x
2065  042f cd027b        	call	_WIZCHIP_WRITE_BUF
2067  0432 5b08          	addw	sp,#8
2068                     ; 271    setGAR(pnetinfo->gw);
2070  0434 ae0004        	ldw	x,#4
2071  0437 89            	pushw	x
2072  0438 1e03          	ldw	x,(OFST+3,sp)
2073  043a 1c000e        	addw	x,#14
2074  043d 89            	pushw	x
2075  043e ae0001        	ldw	x,#1
2076  0441 89            	pushw	x
2077  0442 ae0000        	ldw	x,#0
2078  0445 89            	pushw	x
2079  0446 cd027b        	call	_WIZCHIP_WRITE_BUF
2081  0449 5b08          	addw	sp,#8
2082                     ; 272    setSUBR(pnetinfo->sn);
2084  044b ae0004        	ldw	x,#4
2085  044e 89            	pushw	x
2086  044f 1e03          	ldw	x,(OFST+3,sp)
2087  0451 1c000a        	addw	x,#10
2088  0454 89            	pushw	x
2089  0455 ae0005        	ldw	x,#5
2090  0458 89            	pushw	x
2091  0459 ae0000        	ldw	x,#0
2092  045c 89            	pushw	x
2093  045d cd027b        	call	_WIZCHIP_WRITE_BUF
2095  0460 5b08          	addw	sp,#8
2096                     ; 273    setSIPR(pnetinfo->ip);
2098  0462 ae0004        	ldw	x,#4
2099  0465 89            	pushw	x
2100  0466 1e03          	ldw	x,(OFST+3,sp)
2101  0468 1c0006        	addw	x,#6
2102  046b 89            	pushw	x
2103  046c ae000f        	ldw	x,#15
2104  046f 89            	pushw	x
2105  0470 ae0000        	ldw	x,#0
2106  0473 89            	pushw	x
2107  0474 cd027b        	call	_WIZCHIP_WRITE_BUF
2109  0477 5b08          	addw	sp,#8
2110                     ; 274 }
2113  0479 85            	popw	x
2114  047a 81            	ret
2178                     ; 276 int8_t wizchip_init(uint8_t* txsize, uint8_t* rxsize)
2178                     ; 277 {
2179                     	switch	.text
2180  047b               _wizchip_init:
2182  047b 89            	pushw	x
2183  047c 89            	pushw	x
2184       00000002      OFST:	set	2
2187                     ; 279     int8_t tmp = 0;
2189  047d 0f01          	clr	(OFST-1,sp)
2191                     ; 281     if(txsize)
2193  047f a30000        	cpw	x,#0
2194  0482 2603          	jrne	L011
2195  0484 cc0549        	jp	L547
2196  0487               L011:
2197                     ; 283         for(i = 0; i < _WIZCHIP_SOCK_NUM_; i++)
2199  0487 0f02          	clr	(OFST+0,sp)
2201  0489               L747:
2202                     ; 285             tmp += txsize[i];
2204  0489 7b02          	ld	a,(OFST+0,sp)
2205  048b 5f            	clrw	x
2206  048c 4d            	tnz	a
2207  048d 2a01          	jrpl	L27
2208  048f 53            	cplw	x
2209  0490               L27:
2210  0490 97            	ld	xl,a
2211  0491 72fb03        	addw	x,(OFST+1,sp)
2212  0494 7b01          	ld	a,(OFST-1,sp)
2213  0496 fb            	add	a,(x)
2214  0497 6b01          	ld	(OFST-1,sp),a
2216                     ; 287             if(tmp > 16)
2218  0499 9c            	rvf
2219  049a 7b01          	ld	a,(OFST-1,sp)
2220  049c a111          	cp	a,#17
2221  049e 2f04          	jrslt	L557
2222                     ; 288                 return -1;
2224  04a0 a6ff          	ld	a,#255
2226  04a2 2060          	jra	L601
2227  04a4               L557:
2228                     ; 283         for(i = 0; i < _WIZCHIP_SOCK_NUM_; i++)
2230  04a4 0c02          	inc	(OFST+0,sp)
2234  04a6 9c            	rvf
2235  04a7 7b02          	ld	a,(OFST+0,sp)
2236  04a9 a108          	cp	a,#8
2237  04ab 2fdc          	jrslt	L747
2238                     ; 291         for(i = 0; i < _WIZCHIP_SOCK_NUM_; i++)
2240  04ad 0f02          	clr	(OFST+0,sp)
2242  04af               L757:
2243                     ; 293             setSn_TXBUF_SIZE(i, txsize[i]);
2245  04af 7b02          	ld	a,(OFST+0,sp)
2246  04b1 5f            	clrw	x
2247  04b2 4d            	tnz	a
2248  04b3 2a01          	jrpl	L47
2249  04b5 53            	cplw	x
2250  04b6               L47:
2251  04b6 97            	ld	xl,a
2252  04b7 72fb03        	addw	x,(OFST+1,sp)
2253  04ba f6            	ld	a,(x)
2254  04bb 88            	push	a
2255  04bc 7b03          	ld	a,(OFST+1,sp)
2256  04be 5f            	clrw	x
2257  04bf 4d            	tnz	a
2258  04c0 2a01          	jrpl	L67
2259  04c2 53            	cplw	x
2260  04c3               L67:
2261  04c3 97            	ld	xl,a
2262  04c4 58            	sllw	x
2263  04c5 58            	sllw	x
2264  04c6 58            	sllw	x
2265  04c7 58            	sllw	x
2266  04c8 58            	sllw	x
2267  04c9 1c1f08        	addw	x,#7944
2268  04cc cd0000        	call	c_itolx
2270  04cf be02          	ldw	x,c_lreg+2
2271  04d1 89            	pushw	x
2272  04d2 be00          	ldw	x,c_lreg
2273  04d4 89            	pushw	x
2274  04d5 cd0060        	call	_WIZCHIP_WRITE
2276  04d8 5b05          	addw	sp,#5
2277                     ; 291         for(i = 0; i < _WIZCHIP_SOCK_NUM_; i++)
2279  04da 0c02          	inc	(OFST+0,sp)
2283  04dc 9c            	rvf
2284  04dd 7b02          	ld	a,(OFST+0,sp)
2285  04df a108          	cp	a,#8
2286  04e1 2fcc          	jrslt	L757
2287                     ; 295         if(rxsize){
2289  04e3 1e07          	ldw	x,(OFST+5,sp)
2290  04e5 275f          	jreq	L567
2291                     ; 296             tmp = 0;
2293  04e7 0f01          	clr	(OFST-1,sp)
2295                     ; 297             for(i = 0; i < _WIZCHIP_SOCK_NUM_; i++){
2297  04e9 0f02          	clr	(OFST+0,sp)
2299  04eb               L767:
2300                     ; 298                 tmp += rxsize[i];
2302  04eb 7b02          	ld	a,(OFST+0,sp)
2303  04ed 5f            	clrw	x
2304  04ee 4d            	tnz	a
2305  04ef 2a01          	jrpl	L001
2306  04f1 53            	cplw	x
2307  04f2               L001:
2308  04f2 97            	ld	xl,a
2309  04f3 72fb07        	addw	x,(OFST+5,sp)
2310  04f6 7b01          	ld	a,(OFST-1,sp)
2311  04f8 fb            	add	a,(x)
2312  04f9 6b01          	ld	(OFST-1,sp),a
2314                     ; 299                 if(tmp > 16) return -1;
2316  04fb 9c            	rvf
2317  04fc 7b01          	ld	a,(OFST-1,sp)
2318  04fe a111          	cp	a,#17
2319  0500 2f05          	jrslt	L577
2322  0502 a6ff          	ld	a,#255
2324  0504               L601:
2326  0504 5b04          	addw	sp,#4
2327  0506 81            	ret
2328  0507               L577:
2329                     ; 297             for(i = 0; i < _WIZCHIP_SOCK_NUM_; i++){
2331  0507 0c02          	inc	(OFST+0,sp)
2335  0509 9c            	rvf
2336  050a 7b02          	ld	a,(OFST+0,sp)
2337  050c a108          	cp	a,#8
2338  050e 2fdb          	jrslt	L767
2339                     ; 301             for(i = 0; i < _WIZCHIP_SOCK_NUM_; i++){
2341  0510 0f02          	clr	(OFST+0,sp)
2343  0512               L777:
2344                     ; 302                 setSn_RXBUF_SIZE(i, rxsize[i]);
2346  0512 7b02          	ld	a,(OFST+0,sp)
2347  0514 5f            	clrw	x
2348  0515 4d            	tnz	a
2349  0516 2a01          	jrpl	L201
2350  0518 53            	cplw	x
2351  0519               L201:
2352  0519 97            	ld	xl,a
2353  051a 72fb07        	addw	x,(OFST+5,sp)
2354  051d f6            	ld	a,(x)
2355  051e 88            	push	a
2356  051f 7b03          	ld	a,(OFST+1,sp)
2357  0521 5f            	clrw	x
2358  0522 4d            	tnz	a
2359  0523 2a01          	jrpl	L401
2360  0525 53            	cplw	x
2361  0526               L401:
2362  0526 97            	ld	xl,a
2363  0527 58            	sllw	x
2364  0528 58            	sllw	x
2365  0529 58            	sllw	x
2366  052a 58            	sllw	x
2367  052b 58            	sllw	x
2368  052c 1c1e08        	addw	x,#7688
2369  052f cd0000        	call	c_itolx
2371  0532 be02          	ldw	x,c_lreg+2
2372  0534 89            	pushw	x
2373  0535 be00          	ldw	x,c_lreg
2374  0537 89            	pushw	x
2375  0538 cd0060        	call	_WIZCHIP_WRITE
2377  053b 5b05          	addw	sp,#5
2378                     ; 301             for(i = 0; i < _WIZCHIP_SOCK_NUM_; i++){
2380  053d 0c02          	inc	(OFST+0,sp)
2384  053f 9c            	rvf
2385  0540 7b02          	ld	a,(OFST+0,sp)
2386  0542 a108          	cp	a,#8
2387  0544 2fcc          	jrslt	L777
2388  0546               L567:
2389                     ; 305         return 0;
2391  0546 4f            	clr	a
2393  0547 20bb          	jra	L601
2394  0549               L547:
2395                     ; 308     (void)rxsize;
2397                     ; 310     return 0;
2399  0549 4f            	clr	a
2401  054a 20b8          	jra	L601
2479                     ; 313 int8_t socket(uint8_t sn, uint8_t protocol, uint16_t port, uint8_t flag){
2480                     	switch	.text
2481  054c               _socket:
2483  054c 89            	pushw	x
2484  054d 5204          	subw	sp,#4
2485       00000004      OFST:	set	4
2488                     ; 314     CHECK_SOCKNUM();
2490  054f 7b05          	ld	a,(OFST+1,sp)
2491  0551 a108          	cp	a,#8
2492  0553 2504          	jrult	L7501
2495  0555 a6ff          	ld	a,#255
2497  0557 2027          	jra	L421
2498  0559               L7501:
2499                     ; 315     switch(protocol)
2501  0559 7b06          	ld	a,(OFST+2,sp)
2502  055b a101          	cp	a,#1
2503  055d 2624          	jrne	L7001
2506  055f               L5001:
2507                     ; 320             getSIPR((uint8_t*)&taddr);
2509  055f ae0004        	ldw	x,#4
2510  0562 89            	pushw	x
2511  0563 96            	ldw	x,sp
2512  0564 1c0003        	addw	x,#OFST-1
2513  0567 89            	pushw	x
2514  0568 ae000f        	ldw	x,#15
2515  056b 89            	pushw	x
2516  056c ae0000        	ldw	x,#0
2517  056f 89            	pushw	x
2518  0570 cd00b9        	call	_WIZCHIP_READ_BUF
2520  0573 5b08          	addw	sp,#8
2521                     ; 321             if(taddr == 0) return SOCKERR_SOCKINIT;
2523  0575 96            	ldw	x,sp
2524  0576 1c0001        	addw	x,#OFST-3
2525  0579 cd0000        	call	c_lzmp
2527  057c 2605          	jrne	L7001
2530  057e a6fd          	ld	a,#253
2532  0580               L421:
2534  0580 5b06          	addw	sp,#6
2535  0582 81            	ret
2536  0583               L7001:
2537                     ; 323         default :
2537                     ; 324             return SOCKERR_SOCKMODE;
2539  0583 a6fb          	ld	a,#251
2541  0585 20f9          	jra	L421
2542  0587               L1101:
2543                     ; 329             case Sn_MR_TCP:
2543                     ; 330                  if((flag & (SF_TCP_NODELAY|SF_IO_NONBLOCK))==0) return SOCKERR_SOCKFLAG;
2545  0587 7b0b          	ld	a,(OFST+7,sp)
2546  0589 a521          	bcp	a,#33
2547  058b 2604          	jrne	L1701
2550  058d a6fa          	ld	a,#250
2552  058f 20ef          	jra	L421
2553  0591               L3101:
2554                     ; 332             default:
2554                     ; 333                break;
2556  0591               L1701:
2557                     ; 336     close(sn);
2559  0591 7b05          	ld	a,(OFST+1,sp)
2560  0593 cd06a6        	call	_close
2562                     ; 337     setSn_MR(sn, (protocol | (flag & 0xF0)));
2564  0596 7b0b          	ld	a,(OFST+7,sp)
2565  0598 a4f0          	and	a,#240
2566  059a 1a06          	or	a,(OFST+2,sp)
2567  059c 88            	push	a
2568  059d 7b06          	ld	a,(OFST+2,sp)
2569  059f 97            	ld	xl,a
2570  05a0 a604          	ld	a,#4
2571  05a2 42            	mul	x,a
2572  05a3 58            	sllw	x
2573  05a4 58            	sllw	x
2574  05a5 58            	sllw	x
2575  05a6 1c0008        	addw	x,#8
2576  05a9 cd0000        	call	c_itolx
2578  05ac be02          	ldw	x,c_lreg+2
2579  05ae 89            	pushw	x
2580  05af be00          	ldw	x,c_lreg
2581  05b1 89            	pushw	x
2582  05b2 cd0060        	call	_WIZCHIP_WRITE
2584  05b5 5b05          	addw	sp,#5
2585                     ; 338     if(!port)
2587  05b7 1e09          	ldw	x,(OFST+5,sp)
2588  05b9 2618          	jrne	L1011
2589                     ; 340         port = sock_any_port++;
2591  05bb be00          	ldw	x,L3_sock_any_port
2592  05bd 1c0001        	addw	x,#1
2593  05c0 bf00          	ldw	L3_sock_any_port,x
2594  05c2 1d0001        	subw	x,#1
2595  05c5 1f09          	ldw	(OFST+5,sp),x
2596                     ; 341         if(sock_any_port == 0xFFF0) sock_any_port = SOCK_ANY_PORT_NUM;
2598  05c7 be00          	ldw	x,L3_sock_any_port
2599  05c9 a3fff0        	cpw	x,#65520
2600  05cc 2605          	jrne	L1011
2603  05ce aec000        	ldw	x,#49152
2604  05d1 bf00          	ldw	L3_sock_any_port,x
2605  05d3               L1011:
2606                     ; 343     setSn_PORT(sn,port);
2608  05d3 7b09          	ld	a,(OFST+5,sp)
2609  05d5 88            	push	a
2610  05d6 7b06          	ld	a,(OFST+2,sp)
2611  05d8 97            	ld	xl,a
2612  05d9 a604          	ld	a,#4
2613  05db 42            	mul	x,a
2614  05dc 58            	sllw	x
2615  05dd 58            	sllw	x
2616  05de 58            	sllw	x
2617  05df 1c0408        	addw	x,#1032
2618  05e2 cd0000        	call	c_itolx
2620  05e5 be02          	ldw	x,c_lreg+2
2621  05e7 89            	pushw	x
2622  05e8 be00          	ldw	x,c_lreg
2623  05ea 89            	pushw	x
2624  05eb cd0060        	call	_WIZCHIP_WRITE
2626  05ee 5b05          	addw	sp,#5
2629  05f0 7b0a          	ld	a,(OFST+6,sp)
2630  05f2 88            	push	a
2631  05f3 7b06          	ld	a,(OFST+2,sp)
2632  05f5 97            	ld	xl,a
2633  05f6 a604          	ld	a,#4
2634  05f8 42            	mul	x,a
2635  05f9 58            	sllw	x
2636  05fa 58            	sllw	x
2637  05fb 58            	sllw	x
2638  05fc 1c0508        	addw	x,#1288
2639  05ff cd0000        	call	c_itolx
2641  0602 be02          	ldw	x,c_lreg+2
2642  0604 89            	pushw	x
2643  0605 be00          	ldw	x,c_lreg
2644  0607 89            	pushw	x
2645  0608 cd0060        	call	_WIZCHIP_WRITE
2647  060b 5b05          	addw	sp,#5
2648                     ; 344     setSn_CR(sn,Sn_CR_OPEN);
2651  060d 4b01          	push	#1
2652  060f 7b06          	ld	a,(OFST+2,sp)
2653  0611 97            	ld	xl,a
2654  0612 a604          	ld	a,#4
2655  0614 42            	mul	x,a
2656  0615 58            	sllw	x
2657  0616 58            	sllw	x
2658  0617 58            	sllw	x
2659  0618 1c0108        	addw	x,#264
2660  061b cd0000        	call	c_itolx
2662  061e be02          	ldw	x,c_lreg+2
2663  0620 89            	pushw	x
2664  0621 be00          	ldw	x,c_lreg
2665  0623 89            	pushw	x
2666  0624 cd0060        	call	_WIZCHIP_WRITE
2668  0627 5b05          	addw	sp,#5
2670  0629               L7011:
2671                     ; 345     while(getSn_CR(sn));
2673  0629 7b05          	ld	a,(OFST+1,sp)
2674  062b 97            	ld	xl,a
2675  062c a604          	ld	a,#4
2676  062e 42            	mul	x,a
2677  062f 58            	sllw	x
2678  0630 58            	sllw	x
2679  0631 58            	sllw	x
2680  0632 1c0108        	addw	x,#264
2681  0635 cd0000        	call	c_itolx
2683  0638 be02          	ldw	x,c_lreg+2
2684  063a 89            	pushw	x
2685  063b be00          	ldw	x,c_lreg
2686  063d 89            	pushw	x
2687  063e cd000b        	call	_WIZCHIP_READ
2689  0641 5b04          	addw	sp,#4
2690  0643 4d            	tnz	a
2691  0644 26e3          	jrne	L7011
2692                     ; 346     sock_io_mode &= ~(1 << sn);
2694  0646 ae0001        	ldw	x,#1
2695  0649 7b05          	ld	a,(OFST+1,sp)
2696  064b 4d            	tnz	a
2697  064c 2704          	jreq	L411
2698  064e               L611:
2699  064e 58            	sllw	x
2700  064f 4a            	dec	a
2701  0650 26fc          	jrne	L611
2702  0652               L411:
2703  0652 53            	cplw	x
2704  0653 01            	rrwa	x,a
2705  0654 b41d          	and	a,L52_sock_io_mode+1
2706  0656 01            	rrwa	x,a
2707  0657 b41c          	and	a,L52_sock_io_mode
2708  0659 01            	rrwa	x,a
2709  065a bf1c          	ldw	L52_sock_io_mode,x
2710                     ; 347     sock_io_mode |= ((flag & SF_IO_NONBLOCK) << sn);
2712  065c 7b0b          	ld	a,(OFST+7,sp)
2713  065e a401          	and	a,#1
2714  0660 5f            	clrw	x
2715  0661 97            	ld	xl,a
2716  0662 7b05          	ld	a,(OFST+1,sp)
2717  0664 4d            	tnz	a
2718  0665 2704          	jreq	L021
2719  0667               L221:
2720  0667 58            	sllw	x
2721  0668 4a            	dec	a
2722  0669 26fc          	jrne	L221
2723  066b               L021:
2724  066b 01            	rrwa	x,a
2725  066c ba1d          	or	a,L52_sock_io_mode+1
2726  066e 01            	rrwa	x,a
2727  066f ba1c          	or	a,L52_sock_io_mode
2728  0671 01            	rrwa	x,a
2729  0672 bf1c          	ldw	L52_sock_io_mode,x
2730                     ; 348     sock_remained_size[sn] = 0;
2732  0674 7b05          	ld	a,(OFST+1,sp)
2733  0676 5f            	clrw	x
2734  0677 97            	ld	xl,a
2735  0678 58            	sllw	x
2736  0679 905f          	clrw	y
2737  067b ef02          	ldw	(L12_sock_remained_size,x),y
2738                     ; 349     sock_pack_info[sn] = PACK_COMPLETED;
2740  067d 7b05          	ld	a,(OFST+1,sp)
2741  067f 5f            	clrw	x
2742  0680 97            	ld	xl,a
2743  0681 6f12          	clr	(_sock_pack_info,x)
2745  0683               L7111:
2746                     ; 350     while(getSn_SR(sn) == SOCK_CLOSED);
2748  0683 7b05          	ld	a,(OFST+1,sp)
2749  0685 97            	ld	xl,a
2750  0686 a604          	ld	a,#4
2751  0688 42            	mul	x,a
2752  0689 58            	sllw	x
2753  068a 58            	sllw	x
2754  068b 58            	sllw	x
2755  068c 1c0308        	addw	x,#776
2756  068f cd0000        	call	c_itolx
2758  0692 be02          	ldw	x,c_lreg+2
2759  0694 89            	pushw	x
2760  0695 be00          	ldw	x,c_lreg
2761  0697 89            	pushw	x
2762  0698 cd000b        	call	_WIZCHIP_READ
2764  069b 5b04          	addw	sp,#4
2765  069d 4d            	tnz	a
2766  069e 27e3          	jreq	L7111
2767                     ; 351     return (int8_t)sn;
2769  06a0 7b05          	ld	a,(OFST+1,sp)
2771  06a2 ac800580      	jpf	L421
2811                     ; 353 int8_t close(uint8_t sn){
2812                     	switch	.text
2813  06a6               _close:
2815  06a6 88            	push	a
2816       00000000      OFST:	set	0
2819                     ; 354     CHECK_SOCKNUM();
2821  06a7 7b01          	ld	a,(OFST+1,sp)
2822  06a9 a108          	cp	a,#8
2823  06ab 2505          	jrult	L5411
2826  06ad a6ff          	ld	a,#255
2829  06af 5b01          	addw	sp,#1
2830  06b1 81            	ret
2831  06b2               L5411:
2832                     ; 355     setSn_CR(sn,Sn_CR_CLOSE);
2834  06b2 4b10          	push	#16
2835  06b4 7b02          	ld	a,(OFST+2,sp)
2836  06b6 97            	ld	xl,a
2837  06b7 a604          	ld	a,#4
2838  06b9 42            	mul	x,a
2839  06ba 58            	sllw	x
2840  06bb 58            	sllw	x
2841  06bc 58            	sllw	x
2842  06bd 1c0108        	addw	x,#264
2843  06c0 cd0000        	call	c_itolx
2845  06c3 be02          	ldw	x,c_lreg+2
2846  06c5 89            	pushw	x
2847  06c6 be00          	ldw	x,c_lreg
2848  06c8 89            	pushw	x
2849  06c9 cd0060        	call	_WIZCHIP_WRITE
2851  06cc 5b05          	addw	sp,#5
2853  06ce               L1511:
2854                     ; 356     while(getSn_CR(sn));
2856  06ce 7b01          	ld	a,(OFST+1,sp)
2857  06d0 97            	ld	xl,a
2858  06d1 a604          	ld	a,#4
2859  06d3 42            	mul	x,a
2860  06d4 58            	sllw	x
2861  06d5 58            	sllw	x
2862  06d6 58            	sllw	x
2863  06d7 1c0108        	addw	x,#264
2864  06da cd0000        	call	c_itolx
2866  06dd be02          	ldw	x,c_lreg+2
2867  06df 89            	pushw	x
2868  06e0 be00          	ldw	x,c_lreg
2869  06e2 89            	pushw	x
2870  06e3 cd000b        	call	_WIZCHIP_READ
2872  06e6 5b04          	addw	sp,#4
2873  06e8 4d            	tnz	a
2874  06e9 26e3          	jrne	L1511
2875                     ; 357     setSn_IR(sn, 0xFF);
2877  06eb 4b1f          	push	#31
2878  06ed 7b02          	ld	a,(OFST+2,sp)
2879  06ef 97            	ld	xl,a
2880  06f0 a604          	ld	a,#4
2881  06f2 42            	mul	x,a
2882  06f3 58            	sllw	x
2883  06f4 58            	sllw	x
2884  06f5 58            	sllw	x
2885  06f6 1c0208        	addw	x,#520
2886  06f9 cd0000        	call	c_itolx
2888  06fc be02          	ldw	x,c_lreg+2
2889  06fe 89            	pushw	x
2890  06ff be00          	ldw	x,c_lreg
2891  0701 89            	pushw	x
2892  0702 cd0060        	call	_WIZCHIP_WRITE
2894  0705 5b05          	addw	sp,#5
2895                     ; 358     sock_io_mode &= ~(1 << sn);
2897  0707 ae0001        	ldw	x,#1
2898  070a 7b01          	ld	a,(OFST+1,sp)
2899  070c 4d            	tnz	a
2900  070d 2704          	jreq	L031
2901  070f               L231:
2902  070f 58            	sllw	x
2903  0710 4a            	dec	a
2904  0711 26fc          	jrne	L231
2905  0713               L031:
2906  0713 53            	cplw	x
2907  0714 01            	rrwa	x,a
2908  0715 b41d          	and	a,L52_sock_io_mode+1
2909  0717 01            	rrwa	x,a
2910  0718 b41c          	and	a,L52_sock_io_mode
2911  071a 01            	rrwa	x,a
2912  071b bf1c          	ldw	L52_sock_io_mode,x
2913                     ; 359     sock_is_sending &= ~(1 << sn);
2915  071d ae0001        	ldw	x,#1
2916  0720 7b01          	ld	a,(OFST+1,sp)
2917  0722 4d            	tnz	a
2918  0723 2704          	jreq	L431
2919  0725               L631:
2920  0725 58            	sllw	x
2921  0726 4a            	dec	a
2922  0727 26fc          	jrne	L631
2923  0729               L431:
2924  0729 53            	cplw	x
2925  072a 01            	rrwa	x,a
2926  072b b41b          	and	a,L32_sock_is_sending+1
2927  072d 01            	rrwa	x,a
2928  072e b41a          	and	a,L32_sock_is_sending
2929  0730 01            	rrwa	x,a
2930  0731 bf1a          	ldw	L32_sock_is_sending,x
2931                     ; 360     sock_remained_size[sn] = 0;
2933  0733 7b01          	ld	a,(OFST+1,sp)
2934  0735 5f            	clrw	x
2935  0736 97            	ld	xl,a
2936  0737 58            	sllw	x
2937  0738 905f          	clrw	y
2938  073a ef02          	ldw	(L12_sock_remained_size,x),y
2939                     ; 361     sock_pack_info[sn] = 0;
2941  073c 7b01          	ld	a,(OFST+1,sp)
2942  073e 5f            	clrw	x
2943  073f 97            	ld	xl,a
2944  0740 6f12          	clr	(_sock_pack_info,x)
2946  0742               L1611:
2947                     ; 362     while(getSn_SR(sn) != SOCK_CLOSED);
2949  0742 7b01          	ld	a,(OFST+1,sp)
2950  0744 97            	ld	xl,a
2951  0745 a604          	ld	a,#4
2952  0747 42            	mul	x,a
2953  0748 58            	sllw	x
2954  0749 58            	sllw	x
2955  074a 58            	sllw	x
2956  074b 1c0308        	addw	x,#776
2957  074e cd0000        	call	c_itolx
2959  0751 be02          	ldw	x,c_lreg+2
2960  0753 89            	pushw	x
2961  0754 be00          	ldw	x,c_lreg
2962  0756 89            	pushw	x
2963  0757 cd000b        	call	_WIZCHIP_READ
2965  075a 5b04          	addw	sp,#4
2966  075c 4d            	tnz	a
2967  075d 26e3          	jrne	L1611
2968                     ; 363 	return SOCK_OK;
2970  075f a601          	ld	a,#1
2973  0761 5b01          	addw	sp,#1
2974  0763 81            	ret
3011                     ; 365 int8_t listen(uint8_t sn){
3012                     	switch	.text
3013  0764               _listen:
3015  0764 88            	push	a
3016       00000000      OFST:	set	0
3019                     ; 366     CHECK_SOCKNUM();
3021  0765 7b01          	ld	a,(OFST+1,sp)
3022  0767 a108          	cp	a,#8
3023  0769 2505          	jrult	L1121
3026  076b a6ff          	ld	a,#255
3029  076d 5b01          	addw	sp,#1
3030  076f 81            	ret
3031  0770               L1121:
3032                     ; 367     CHECK_SOCKMODE(Sn_MR_TCP);
3034  0770 7b01          	ld	a,(OFST+1,sp)
3035  0772 97            	ld	xl,a
3036  0773 a604          	ld	a,#4
3037  0775 42            	mul	x,a
3038  0776 58            	sllw	x
3039  0777 58            	sllw	x
3040  0778 58            	sllw	x
3041  0779 1c0008        	addw	x,#8
3042  077c cd0000        	call	c_itolx
3044  077f be02          	ldw	x,c_lreg+2
3045  0781 89            	pushw	x
3046  0782 be00          	ldw	x,c_lreg
3047  0784 89            	pushw	x
3048  0785 cd000b        	call	_WIZCHIP_READ
3050  0788 5b04          	addw	sp,#4
3051  078a a40f          	and	a,#15
3052  078c a101          	cp	a,#1
3053  078e 2705          	jreq	L7121
3056  0790 a6fb          	ld	a,#251
3059  0792 5b01          	addw	sp,#1
3060  0794 81            	ret
3061  0795               L7121:
3062                     ; 368     CHECK_SOCKINIT();
3064  0795 7b01          	ld	a,(OFST+1,sp)
3065  0797 97            	ld	xl,a
3066  0798 a604          	ld	a,#4
3067  079a 42            	mul	x,a
3068  079b 58            	sllw	x
3069  079c 58            	sllw	x
3070  079d 58            	sllw	x
3071  079e 1c0308        	addw	x,#776
3072  07a1 cd0000        	call	c_itolx
3074  07a4 be02          	ldw	x,c_lreg+2
3075  07a6 89            	pushw	x
3076  07a7 be00          	ldw	x,c_lreg
3077  07a9 89            	pushw	x
3078  07aa cd000b        	call	_WIZCHIP_READ
3080  07ad 5b04          	addw	sp,#4
3081  07af a113          	cp	a,#19
3082  07b1 2705          	jreq	L3221
3085  07b3 a6fd          	ld	a,#253
3088  07b5 5b01          	addw	sp,#1
3089  07b7 81            	ret
3090  07b8               L3221:
3091                     ; 369     setSn_CR(sn,Sn_CR_LISTEN);
3093  07b8 4b02          	push	#2
3094  07ba 7b02          	ld	a,(OFST+2,sp)
3095  07bc 97            	ld	xl,a
3096  07bd a604          	ld	a,#4
3097  07bf 42            	mul	x,a
3098  07c0 58            	sllw	x
3099  07c1 58            	sllw	x
3100  07c2 58            	sllw	x
3101  07c3 1c0108        	addw	x,#264
3102  07c6 cd0000        	call	c_itolx
3104  07c9 be02          	ldw	x,c_lreg+2
3105  07cb 89            	pushw	x
3106  07cc be00          	ldw	x,c_lreg
3107  07ce 89            	pushw	x
3108  07cf cd0060        	call	_WIZCHIP_WRITE
3110  07d2 5b05          	addw	sp,#5
3112  07d4               L7221:
3113                     ; 370     while(getSn_CR(sn));
3115  07d4 7b01          	ld	a,(OFST+1,sp)
3116  07d6 97            	ld	xl,a
3117  07d7 a604          	ld	a,#4
3118  07d9 42            	mul	x,a
3119  07da 58            	sllw	x
3120  07db 58            	sllw	x
3121  07dc 58            	sllw	x
3122  07dd 1c0108        	addw	x,#264
3123  07e0 cd0000        	call	c_itolx
3125  07e3 be02          	ldw	x,c_lreg+2
3126  07e5 89            	pushw	x
3127  07e6 be00          	ldw	x,c_lreg
3128  07e8 89            	pushw	x
3129  07e9 cd000b        	call	_WIZCHIP_READ
3131  07ec 5b04          	addw	sp,#4
3132  07ee 4d            	tnz	a
3133  07ef 26e3          	jrne	L7221
3135  07f1 200a          	jra	L5321
3136  07f3               L3321:
3137                     ; 373         close(sn);
3139  07f3 7b01          	ld	a,(OFST+1,sp)
3140  07f5 cd06a6        	call	_close
3142                     ; 374         return SOCKERR_SOCKCLOSED;
3144  07f8 a6fc          	ld	a,#252
3147  07fa 5b01          	addw	sp,#1
3148  07fc 81            	ret
3149  07fd               L5321:
3150                     ; 371     while(getSn_SR(sn) != SOCK_LISTEN)
3152  07fd 7b01          	ld	a,(OFST+1,sp)
3153  07ff 97            	ld	xl,a
3154  0800 a604          	ld	a,#4
3155  0802 42            	mul	x,a
3156  0803 58            	sllw	x
3157  0804 58            	sllw	x
3158  0805 58            	sllw	x
3159  0806 1c0308        	addw	x,#776
3160  0809 cd0000        	call	c_itolx
3162  080c be02          	ldw	x,c_lreg+2
3163  080e 89            	pushw	x
3164  080f be00          	ldw	x,c_lreg
3165  0811 89            	pushw	x
3166  0812 cd000b        	call	_WIZCHIP_READ
3168  0815 5b04          	addw	sp,#4
3169  0817 a114          	cp	a,#20
3170  0819 26d8          	jrne	L3321
3171                     ; 376     return SOCK_OK;
3173  081b a601          	ld	a,#1
3176  081d 5b01          	addw	sp,#1
3177  081f 81            	ret
3251                     ; 378 void wiz_recv_data(uint8_t sn, uint8_t *wizdata, uint16_t len)
3251                     ; 379 {
3252                     	switch	.text
3253  0820               _wiz_recv_data:
3255  0820 88            	push	a
3256  0821 520a          	subw	sp,#10
3257       0000000a      OFST:	set	10
3260                     ; 380    uint16_t ptr = 0;
3262                     ; 381    uint32_t addrsel = 0;
3264                     ; 383    if(len == 0) return;
3266  0823 1e10          	ldw	x,(OFST+6,sp)
3267  0825 2603          	jrne	L051
3268  0827 cc08ed        	jp	L641
3269  082a               L051:
3272                     ; 384    ptr = getSn_RX_RD(sn);
3274  082a 7b0b          	ld	a,(OFST+1,sp)
3275  082c 97            	ld	xl,a
3276  082d a604          	ld	a,#4
3277  082f 42            	mul	x,a
3278  0830 58            	sllw	x
3279  0831 58            	sllw	x
3280  0832 58            	sllw	x
3281  0833 1c2908        	addw	x,#10504
3282  0836 cd0000        	call	c_itolx
3284  0839 be02          	ldw	x,c_lreg+2
3285  083b 89            	pushw	x
3286  083c be00          	ldw	x,c_lreg
3287  083e 89            	pushw	x
3288  083f cd000b        	call	_WIZCHIP_READ
3290  0842 5b04          	addw	sp,#4
3291  0844 6b04          	ld	(OFST-6,sp),a
3293  0846 7b0b          	ld	a,(OFST+1,sp)
3294  0848 97            	ld	xl,a
3295  0849 a604          	ld	a,#4
3296  084b 42            	mul	x,a
3297  084c 58            	sllw	x
3298  084d 58            	sllw	x
3299  084e 58            	sllw	x
3300  084f 1c2808        	addw	x,#10248
3301  0852 cd0000        	call	c_itolx
3303  0855 be02          	ldw	x,c_lreg+2
3304  0857 89            	pushw	x
3305  0858 be00          	ldw	x,c_lreg
3306  085a 89            	pushw	x
3307  085b cd000b        	call	_WIZCHIP_READ
3309  085e 5b04          	addw	sp,#4
3310  0860 5f            	clrw	x
3311  0861 97            	ld	xl,a
3312  0862 4f            	clr	a
3313  0863 02            	rlwa	x,a
3314  0864 01            	rrwa	x,a
3315  0865 1b04          	add	a,(OFST-6,sp)
3316  0867 2401          	jrnc	L441
3317  0869 5c            	incw	x
3318  086a               L441:
3319  086a 02            	rlwa	x,a
3320  086b 1f09          	ldw	(OFST-1,sp),x
3321  086d 01            	rrwa	x,a
3323                     ; 387    addrsel = ((uint32_t)ptr << 8) + (WIZCHIP_RXBUF_BLOCK(sn) << 3);
3325  086e 7b0b          	ld	a,(OFST+1,sp)
3326  0870 97            	ld	xl,a
3327  0871 a604          	ld	a,#4
3328  0873 42            	mul	x,a
3329  0874 58            	sllw	x
3330  0875 58            	sllw	x
3331  0876 58            	sllw	x
3332  0877 1c0018        	addw	x,#24
3333  087a cd0000        	call	c_itolx
3335  087d 96            	ldw	x,sp
3336  087e 1c0001        	addw	x,#OFST-9
3337  0881 cd0000        	call	c_rtol
3340  0884 1e09          	ldw	x,(OFST-1,sp)
3341  0886 90ae0100      	ldw	y,#256
3342  088a cd0000        	call	c_umul
3344  088d 96            	ldw	x,sp
3345  088e 1c0001        	addw	x,#OFST-9
3346  0891 cd0000        	call	c_ladd
3348  0894 96            	ldw	x,sp
3349  0895 1c0005        	addw	x,#OFST-5
3350  0898 cd0000        	call	c_rtol
3353                     ; 389    WIZCHIP_READ_BUF(addrsel, wizdata, len);
3355  089b 1e10          	ldw	x,(OFST+6,sp)
3356  089d 89            	pushw	x
3357  089e 1e10          	ldw	x,(OFST+6,sp)
3358  08a0 89            	pushw	x
3359  08a1 1e0b          	ldw	x,(OFST+1,sp)
3360  08a3 89            	pushw	x
3361  08a4 1e0b          	ldw	x,(OFST+1,sp)
3362  08a6 89            	pushw	x
3363  08a7 cd00b9        	call	_WIZCHIP_READ_BUF
3365  08aa 5b08          	addw	sp,#8
3366                     ; 390    ptr += len;
3368  08ac 1e09          	ldw	x,(OFST-1,sp)
3369  08ae 72fb10        	addw	x,(OFST+6,sp)
3370  08b1 1f09          	ldw	(OFST-1,sp),x
3372                     ; 391    setSn_RX_RD(sn,ptr);
3374  08b3 7b09          	ld	a,(OFST-1,sp)
3375  08b5 88            	push	a
3376  08b6 7b0c          	ld	a,(OFST+2,sp)
3377  08b8 97            	ld	xl,a
3378  08b9 a604          	ld	a,#4
3379  08bb 42            	mul	x,a
3380  08bc 58            	sllw	x
3381  08bd 58            	sllw	x
3382  08be 58            	sllw	x
3383  08bf 1c2808        	addw	x,#10248
3384  08c2 cd0000        	call	c_itolx
3386  08c5 be02          	ldw	x,c_lreg+2
3387  08c7 89            	pushw	x
3388  08c8 be00          	ldw	x,c_lreg
3389  08ca 89            	pushw	x
3390  08cb cd0060        	call	_WIZCHIP_WRITE
3392  08ce 5b05          	addw	sp,#5
3395  08d0 7b0a          	ld	a,(OFST+0,sp)
3396  08d2 88            	push	a
3397  08d3 7b0c          	ld	a,(OFST+2,sp)
3398  08d5 97            	ld	xl,a
3399  08d6 a604          	ld	a,#4
3400  08d8 42            	mul	x,a
3401  08d9 58            	sllw	x
3402  08da 58            	sllw	x
3403  08db 58            	sllw	x
3404  08dc 1c2908        	addw	x,#10504
3405  08df cd0000        	call	c_itolx
3407  08e2 be02          	ldw	x,c_lreg+2
3408  08e4 89            	pushw	x
3409  08e5 be00          	ldw	x,c_lreg
3410  08e7 89            	pushw	x
3411  08e8 cd0060        	call	_WIZCHIP_WRITE
3413  08eb 5b05          	addw	sp,#5
3414                     ; 392 }
3415  08ed               L641:
3419  08ed 5b0b          	addw	sp,#11
3420  08ef 81            	ret
3498                     ; 394 int32_t recv(uint8_t sn, uint8_t *buf, uint16_t len){
3499                     	switch	.text
3500  08f0               _recv:
3502  08f0 88            	push	a
3503  08f1 5205          	subw	sp,#5
3504       00000005      OFST:	set	5
3507                     ; 395     uint8_t tmp = 0;
3509                     ; 396     uint16_t recvsize = 0;
3511                     ; 397     CHECK_SOCKNUM();
3513  08f3 7b06          	ld	a,(OFST+1,sp)
3514  08f5 a108          	cp	a,#8
3515  08f7 250c          	jrult	L5431
3518  08f9 aeffff        	ldw	x,#65535
3519  08fc bf02          	ldw	c_lreg+2,x
3520  08fe aeffff        	ldw	x,#-1
3521  0901 bf00          	ldw	c_lreg,x
3523  0903 202a          	jra	L061
3524  0905               L5431:
3525                     ; 398     CHECK_SOCKMODE(Sn_MR_TCP);
3527  0905 7b06          	ld	a,(OFST+1,sp)
3528  0907 97            	ld	xl,a
3529  0908 a604          	ld	a,#4
3530  090a 42            	mul	x,a
3531  090b 58            	sllw	x
3532  090c 58            	sllw	x
3533  090d 58            	sllw	x
3534  090e 1c0008        	addw	x,#8
3535  0911 cd0000        	call	c_itolx
3537  0914 be02          	ldw	x,c_lreg+2
3538  0916 89            	pushw	x
3539  0917 be00          	ldw	x,c_lreg
3540  0919 89            	pushw	x
3541  091a cd000b        	call	_WIZCHIP_READ
3543  091d 5b04          	addw	sp,#4
3544  091f a40f          	and	a,#15
3545  0921 a101          	cp	a,#1
3546  0923 270d          	jreq	L3531
3549  0925 aefffb        	ldw	x,#65531
3550  0928 bf02          	ldw	c_lreg+2,x
3551  092a aeffff        	ldw	x,#-1
3552  092d bf00          	ldw	c_lreg,x
3554  092f               L061:
3556  092f 5b06          	addw	sp,#6
3557  0931 81            	ret
3558  0932               L3531:
3559                     ; 399     CHECK_SOCKDATA();
3561  0932 1e0b          	ldw	x,(OFST+6,sp)
3562  0934 260c          	jrne	L7531
3565  0936 aefff2        	ldw	x,#65522
3566  0939 bf02          	ldw	c_lreg+2,x
3567  093b aeffff        	ldw	x,#-1
3568  093e bf00          	ldw	c_lreg,x
3570  0940 20ed          	jra	L061
3571  0942               L7531:
3572                     ; 400     recvsize = getSn_RxMAX(sn);
3575  0942 7b06          	ld	a,(OFST+1,sp)
3576  0944 97            	ld	xl,a
3577  0945 a604          	ld	a,#4
3578  0947 42            	mul	x,a
3579  0948 58            	sllw	x
3580  0949 58            	sllw	x
3581  094a 58            	sllw	x
3582  094b 1c1e08        	addw	x,#7688
3583  094e cd0000        	call	c_itolx
3585  0951 be02          	ldw	x,c_lreg+2
3586  0953 89            	pushw	x
3587  0954 be00          	ldw	x,c_lreg
3588  0956 89            	pushw	x
3589  0957 cd000b        	call	_WIZCHIP_READ
3591  095a 5b04          	addw	sp,#4
3592  095c 5f            	clrw	x
3593  095d 97            	ld	xl,a
3594  095e 4f            	clr	a
3595  095f 02            	rlwa	x,a
3596  0960 58            	sllw	x
3597  0961 58            	sllw	x
3598  0962 1f04          	ldw	(OFST-1,sp),x
3600                     ; 401     if(recvsize < len) len = recvsize;
3602  0964 1e04          	ldw	x,(OFST-1,sp)
3603  0966 130b          	cpw	x,(OFST+6,sp)
3604  0968 2404          	jruge	L3631
3607  096a 1e04          	ldw	x,(OFST-1,sp)
3608  096c 1f0b          	ldw	(OFST+6,sp),x
3609  096e               L3631:
3610                     ; 403         recvsize = getSn_RX_RSR(sn);
3612  096e 7b06          	ld	a,(OFST+1,sp)
3613  0970 cd01d3        	call	_getSn_RX_RSR
3615  0973 1f04          	ldw	(OFST-1,sp),x
3617                     ; 404         tmp = getSn_SR(sn);
3619  0975 7b06          	ld	a,(OFST+1,sp)
3620  0977 97            	ld	xl,a
3621  0978 a604          	ld	a,#4
3622  097a 42            	mul	x,a
3623  097b 58            	sllw	x
3624  097c 58            	sllw	x
3625  097d 58            	sllw	x
3626  097e 1c0308        	addw	x,#776
3627  0981 cd0000        	call	c_itolx
3629  0984 be02          	ldw	x,c_lreg+2
3630  0986 89            	pushw	x
3631  0987 be00          	ldw	x,c_lreg
3632  0989 89            	pushw	x
3633  098a cd000b        	call	_WIZCHIP_READ
3635  098d 5b04          	addw	sp,#4
3636  098f 6b03          	ld	(OFST-2,sp),a
3638                     ; 405         if(tmp != SOCK_ESTABLISHED){
3640  0991 7b03          	ld	a,(OFST-2,sp)
3641  0993 a117          	cp	a,#23
3642  0995 275e          	jreq	L7631
3643                     ; 406             if(tmp == SOCK_CLOSE_WAIT){
3645  0997 7b03          	ld	a,(OFST-2,sp)
3646  0999 a11c          	cp	a,#28
3647  099b 2645          	jrne	L1731
3648                     ; 407                 if(recvsize != 0) break;
3650  099d 1e04          	ldw	x,(OFST-1,sp)
3651  099f 2703          	jreq	L261
3652  09a1 cc0a26        	jp	L5631
3653  09a4               L261:
3656                     ; 408                 else if(getSn_TX_FSR(sn) == getSn_TxMAX(sn))
3658  09a4 7b06          	ld	a,(OFST+1,sp)
3659  09a6 97            	ld	xl,a
3660  09a7 a604          	ld	a,#4
3661  09a9 42            	mul	x,a
3662  09aa 58            	sllw	x
3663  09ab 58            	sllw	x
3664  09ac 58            	sllw	x
3665  09ad 1c1f08        	addw	x,#7944
3666  09b0 cd0000        	call	c_itolx
3668  09b3 be02          	ldw	x,c_lreg+2
3669  09b5 89            	pushw	x
3670  09b6 be00          	ldw	x,c_lreg
3671  09b8 89            	pushw	x
3672  09b9 cd000b        	call	_WIZCHIP_READ
3674  09bc 5b04          	addw	sp,#4
3675  09be 5f            	clrw	x
3676  09bf 97            	ld	xl,a
3677  09c0 4f            	clr	a
3678  09c1 02            	rlwa	x,a
3679  09c2 58            	sllw	x
3680  09c3 58            	sllw	x
3681  09c4 1f01          	ldw	(OFST-4,sp),x
3683  09c6 7b06          	ld	a,(OFST+1,sp)
3684  09c8 cd012b        	call	_getSn_TX_FSR
3686  09cb 1301          	cpw	x,(OFST-4,sp)
3687  09cd 2626          	jrne	L7631
3688                     ; 410                     close(sn);
3690  09cf 7b06          	ld	a,(OFST+1,sp)
3691  09d1 cd06a6        	call	_close
3693                     ; 411                     return SOCKERR_SOCKSTATUS;
3695  09d4 aefff9        	ldw	x,#65529
3696  09d7 bf02          	ldw	c_lreg+2,x
3697  09d9 aeffff        	ldw	x,#-1
3698  09dc bf00          	ldw	c_lreg,x
3700  09de ac2f092f      	jpf	L061
3701  09e2               L1731:
3702                     ; 416                 close(sn);
3704  09e2 7b06          	ld	a,(OFST+1,sp)
3705  09e4 cd06a6        	call	_close
3707                     ; 417                 return SOCKERR_SOCKSTATUS;
3709  09e7 aefff9        	ldw	x,#65529
3710  09ea bf02          	ldw	c_lreg+2,x
3711  09ec aeffff        	ldw	x,#-1
3712  09ef bf00          	ldw	c_lreg,x
3714  09f1 ac2f092f      	jpf	L061
3715  09f5               L7631:
3716                     ; 420         if ((sock_io_mode & (1 << sn)) && (recvsize == 0)){
3718  09f5 ae0001        	ldw	x,#1
3719  09f8 7b06          	ld	a,(OFST+1,sp)
3720  09fa 4d            	tnz	a
3721  09fb 2704          	jreq	L451
3722  09fd               L651:
3723  09fd 58            	sllw	x
3724  09fe 4a            	dec	a
3725  09ff 26fc          	jrne	L651
3726  0a01               L451:
3727  0a01 01            	rrwa	x,a
3728  0a02 b41d          	and	a,L52_sock_io_mode+1
3729  0a04 01            	rrwa	x,a
3730  0a05 b41c          	and	a,L52_sock_io_mode
3731  0a07 01            	rrwa	x,a
3732  0a08 a30000        	cpw	x,#0
3733  0a0b 2712          	jreq	L3041
3735  0a0d 1e04          	ldw	x,(OFST-1,sp)
3736  0a0f 260e          	jrne	L3041
3737                     ; 421             return SOCK_BUSY;
3739  0a11 ae0000        	ldw	x,#0
3740  0a14 bf02          	ldw	c_lreg+2,x
3741  0a16 ae0000        	ldw	x,#0
3742  0a19 bf00          	ldw	c_lreg,x
3744  0a1b ac2f092f      	jpf	L061
3745  0a1f               L3041:
3746                     ; 423         if(recvsize != 0) break;
3748  0a1f 1e04          	ldw	x,(OFST-1,sp)
3749  0a21 2603          	jrne	L461
3750  0a23 cc096e        	jp	L3631
3751  0a26               L461:
3753  0a26               L5631:
3754                     ; 425     if(recvsize < len) len = recvsize;
3757  0a26 1e04          	ldw	x,(OFST-1,sp)
3758  0a28 130b          	cpw	x,(OFST+6,sp)
3759  0a2a 2404          	jruge	L7041
3762  0a2c 1e04          	ldw	x,(OFST-1,sp)
3763  0a2e 1f0b          	ldw	(OFST+6,sp),x
3764  0a30               L7041:
3765                     ; 426     wiz_recv_data(sn, buf, len);
3767  0a30 1e0b          	ldw	x,(OFST+6,sp)
3768  0a32 89            	pushw	x
3769  0a33 1e0b          	ldw	x,(OFST+6,sp)
3770  0a35 89            	pushw	x
3771  0a36 7b0a          	ld	a,(OFST+5,sp)
3772  0a38 cd0820        	call	_wiz_recv_data
3774  0a3b 5b04          	addw	sp,#4
3775                     ; 427     setSn_CR(sn,Sn_CR_RECV);
3777  0a3d 4b40          	push	#64
3778  0a3f 7b07          	ld	a,(OFST+2,sp)
3779  0a41 97            	ld	xl,a
3780  0a42 a604          	ld	a,#4
3781  0a44 42            	mul	x,a
3782  0a45 58            	sllw	x
3783  0a46 58            	sllw	x
3784  0a47 58            	sllw	x
3785  0a48 1c0108        	addw	x,#264
3786  0a4b cd0000        	call	c_itolx
3788  0a4e be02          	ldw	x,c_lreg+2
3789  0a50 89            	pushw	x
3790  0a51 be00          	ldw	x,c_lreg
3791  0a53 89            	pushw	x
3792  0a54 cd0060        	call	_WIZCHIP_WRITE
3794  0a57 5b05          	addw	sp,#5
3796  0a59               L3141:
3797                     ; 428     while(getSn_CR(sn));
3799  0a59 7b06          	ld	a,(OFST+1,sp)
3800  0a5b 97            	ld	xl,a
3801  0a5c a604          	ld	a,#4
3802  0a5e 42            	mul	x,a
3803  0a5f 58            	sllw	x
3804  0a60 58            	sllw	x
3805  0a61 58            	sllw	x
3806  0a62 1c0108        	addw	x,#264
3807  0a65 cd0000        	call	c_itolx
3809  0a68 be02          	ldw	x,c_lreg+2
3810  0a6a 89            	pushw	x
3811  0a6b be00          	ldw	x,c_lreg
3812  0a6d 89            	pushw	x
3813  0a6e cd000b        	call	_WIZCHIP_READ
3815  0a71 5b04          	addw	sp,#4
3816  0a73 4d            	tnz	a
3817  0a74 26e3          	jrne	L3141
3818                     ; 429 }
3820  0a76 ac2f092f      	jpf	L061
3898                     ; 431 int32_t send(uint8_t sn, uint8_t * buf, uint16_t len){
3899                     	switch	.text
3900  0a7a               _send:
3902  0a7a 88            	push	a
3903  0a7b 5203          	subw	sp,#3
3904       00000003      OFST:	set	3
3907                     ; 432     uint8_t tmp = 0;
3909                     ; 433     uint16_t freesize = 0;
3911                     ; 435     CHECK_SOCKNUM();
3913  0a7d 7b04          	ld	a,(OFST+1,sp)
3914  0a7f a108          	cp	a,#8
3915  0a81 250c          	jrult	L3641
3918  0a83 aeffff        	ldw	x,#65535
3919  0a86 bf02          	ldw	c_lreg+2,x
3920  0a88 aeffff        	ldw	x,#-1
3921  0a8b bf00          	ldw	c_lreg,x
3923  0a8d 202a          	jra	L402
3924  0a8f               L3641:
3925                     ; 436     CHECK_SOCKMODE(Sn_MR_TCP);
3927  0a8f 7b04          	ld	a,(OFST+1,sp)
3928  0a91 97            	ld	xl,a
3929  0a92 a604          	ld	a,#4
3930  0a94 42            	mul	x,a
3931  0a95 58            	sllw	x
3932  0a96 58            	sllw	x
3933  0a97 58            	sllw	x
3934  0a98 1c0008        	addw	x,#8
3935  0a9b cd0000        	call	c_itolx
3937  0a9e be02          	ldw	x,c_lreg+2
3938  0aa0 89            	pushw	x
3939  0aa1 be00          	ldw	x,c_lreg
3940  0aa3 89            	pushw	x
3941  0aa4 cd000b        	call	_WIZCHIP_READ
3943  0aa7 5b04          	addw	sp,#4
3944  0aa9 a40f          	and	a,#15
3945  0aab a101          	cp	a,#1
3946  0aad 270d          	jreq	L1741
3949  0aaf aefffb        	ldw	x,#65531
3950  0ab2 bf02          	ldw	c_lreg+2,x
3951  0ab4 aeffff        	ldw	x,#-1
3952  0ab7 bf00          	ldw	c_lreg,x
3954  0ab9               L402:
3956  0ab9 5b04          	addw	sp,#4
3957  0abb 81            	ret
3958  0abc               L1741:
3959                     ; 437     CHECK_SOCKDATA();
3961  0abc 1e09          	ldw	x,(OFST+6,sp)
3962  0abe 260c          	jrne	L5741
3965  0ac0 aefff2        	ldw	x,#65522
3966  0ac3 bf02          	ldw	c_lreg+2,x
3967  0ac5 aeffff        	ldw	x,#-1
3968  0ac8 bf00          	ldw	c_lreg,x
3970  0aca 20ed          	jra	L402
3971  0acc               L5741:
3972                     ; 438     tmp = getSn_SR(sn);
3975  0acc 7b04          	ld	a,(OFST+1,sp)
3976  0ace 97            	ld	xl,a
3977  0acf a604          	ld	a,#4
3978  0ad1 42            	mul	x,a
3979  0ad2 58            	sllw	x
3980  0ad3 58            	sllw	x
3981  0ad4 58            	sllw	x
3982  0ad5 1c0308        	addw	x,#776
3983  0ad8 cd0000        	call	c_itolx
3985  0adb be02          	ldw	x,c_lreg+2
3986  0add 89            	pushw	x
3987  0ade be00          	ldw	x,c_lreg
3988  0ae0 89            	pushw	x
3989  0ae1 cd000b        	call	_WIZCHIP_READ
3991  0ae4 5b04          	addw	sp,#4
3992  0ae6 6b03          	ld	(OFST+0,sp),a
3994                     ; 439     if(tmp != SOCK_ESTABLISHED && tmp != SOCK_CLOSE_WAIT) return SOCKERR_SOCKSTATUS;
3996  0ae8 7b03          	ld	a,(OFST+0,sp)
3997  0aea a117          	cp	a,#23
3998  0aec 2712          	jreq	L7741
4000  0aee 7b03          	ld	a,(OFST+0,sp)
4001  0af0 a11c          	cp	a,#28
4002  0af2 270c          	jreq	L7741
4005  0af4 aefff9        	ldw	x,#65529
4006  0af7 bf02          	ldw	c_lreg+2,x
4007  0af9 aeffff        	ldw	x,#-1
4008  0afc bf00          	ldw	c_lreg,x
4010  0afe 20b9          	jra	L402
4011  0b00               L7741:
4012                     ; 440     if(sock_is_sending & (1<<sn)){
4014  0b00 ae0001        	ldw	x,#1
4015  0b03 7b04          	ld	a,(OFST+1,sp)
4016  0b05 4d            	tnz	a
4017  0b06 2704          	jreq	L071
4018  0b08               L271:
4019  0b08 58            	sllw	x
4020  0b09 4a            	dec	a
4021  0b0a 26fc          	jrne	L271
4022  0b0c               L071:
4023  0b0c 01            	rrwa	x,a
4024  0b0d b41b          	and	a,L32_sock_is_sending+1
4025  0b0f 01            	rrwa	x,a
4026  0b10 b41a          	and	a,L32_sock_is_sending
4027  0b12 01            	rrwa	x,a
4028  0b13 a30000        	cpw	x,#0
4029  0b16 2603          	jrne	L602
4030  0b18 cc0b9a        	jp	L1051
4031  0b1b               L602:
4032                     ; 441         tmp = getSn_IR(sn);
4034  0b1b 7b04          	ld	a,(OFST+1,sp)
4035  0b1d 97            	ld	xl,a
4036  0b1e a604          	ld	a,#4
4037  0b20 42            	mul	x,a
4038  0b21 58            	sllw	x
4039  0b22 58            	sllw	x
4040  0b23 58            	sllw	x
4041  0b24 1c0208        	addw	x,#520
4042  0b27 cd0000        	call	c_itolx
4044  0b2a be02          	ldw	x,c_lreg+2
4045  0b2c 89            	pushw	x
4046  0b2d be00          	ldw	x,c_lreg
4047  0b2f 89            	pushw	x
4048  0b30 cd000b        	call	_WIZCHIP_READ
4050  0b33 5b04          	addw	sp,#4
4051  0b35 a41f          	and	a,#31
4052  0b37 6b03          	ld	(OFST+0,sp),a
4054                     ; 442         if(tmp & Sn_IR_SENDOK){
4056  0b39 7b03          	ld	a,(OFST+0,sp)
4057  0b3b a510          	bcp	a,#16
4058  0b3d 2734          	jreq	L3051
4059                     ; 443             setSn_IR(sn, Sn_IR_SENDOK);
4061  0b3f 4b10          	push	#16
4062  0b41 7b05          	ld	a,(OFST+2,sp)
4063  0b43 97            	ld	xl,a
4064  0b44 a604          	ld	a,#4
4065  0b46 42            	mul	x,a
4066  0b47 58            	sllw	x
4067  0b48 58            	sllw	x
4068  0b49 58            	sllw	x
4069  0b4a 1c0208        	addw	x,#520
4070  0b4d cd0000        	call	c_itolx
4072  0b50 be02          	ldw	x,c_lreg+2
4073  0b52 89            	pushw	x
4074  0b53 be00          	ldw	x,c_lreg
4075  0b55 89            	pushw	x
4076  0b56 cd0060        	call	_WIZCHIP_WRITE
4078  0b59 5b05          	addw	sp,#5
4079                     ; 444             sock_is_sending &= ~(1<<sn);
4081  0b5b ae0001        	ldw	x,#1
4082  0b5e 7b04          	ld	a,(OFST+1,sp)
4083  0b60 4d            	tnz	a
4084  0b61 2704          	jreq	L471
4085  0b63               L671:
4086  0b63 58            	sllw	x
4087  0b64 4a            	dec	a
4088  0b65 26fc          	jrne	L671
4089  0b67               L471:
4090  0b67 53            	cplw	x
4091  0b68 01            	rrwa	x,a
4092  0b69 b41b          	and	a,L32_sock_is_sending+1
4093  0b6b 01            	rrwa	x,a
4094  0b6c b41a          	and	a,L32_sock_is_sending
4095  0b6e 01            	rrwa	x,a
4096  0b6f bf1a          	ldw	L32_sock_is_sending,x
4098  0b71 2027          	jra	L1051
4099  0b73               L3051:
4100                     ; 446         else if(tmp & Sn_IR_TIMEOUT)
4102  0b73 7b03          	ld	a,(OFST+0,sp)
4103  0b75 a508          	bcp	a,#8
4104  0b77 2713          	jreq	L7051
4105                     ; 448             close(sn);
4107  0b79 7b04          	ld	a,(OFST+1,sp)
4108  0b7b cd06a6        	call	_close
4110                     ; 449             return SOCKERR_TIMEOUT;
4112  0b7e aefff3        	ldw	x,#65523
4113  0b81 bf02          	ldw	c_lreg+2,x
4114  0b83 aeffff        	ldw	x,#-1
4115  0b86 bf00          	ldw	c_lreg,x
4117  0b88 acb90ab9      	jpf	L402
4118  0b8c               L7051:
4119                     ; 451         else return SOCK_BUSY;
4121  0b8c ae0000        	ldw	x,#0
4122  0b8f bf02          	ldw	c_lreg+2,x
4123  0b91 ae0000        	ldw	x,#0
4124  0b94 bf00          	ldw	c_lreg,x
4126  0b96 acb90ab9      	jpf	L402
4127  0b9a               L1051:
4128                     ; 453     freesize = getSn_TxMAX(sn);
4130  0b9a 7b04          	ld	a,(OFST+1,sp)
4131  0b9c 97            	ld	xl,a
4132  0b9d a604          	ld	a,#4
4133  0b9f 42            	mul	x,a
4134  0ba0 58            	sllw	x
4135  0ba1 58            	sllw	x
4136  0ba2 58            	sllw	x
4137  0ba3 1c1f08        	addw	x,#7944
4138  0ba6 cd0000        	call	c_itolx
4140  0ba9 be02          	ldw	x,c_lreg+2
4141  0bab 89            	pushw	x
4142  0bac be00          	ldw	x,c_lreg
4143  0bae 89            	pushw	x
4144  0baf cd000b        	call	_WIZCHIP_READ
4146  0bb2 5b04          	addw	sp,#4
4147  0bb4 5f            	clrw	x
4148  0bb5 97            	ld	xl,a
4149  0bb6 4f            	clr	a
4150  0bb7 02            	rlwa	x,a
4151  0bb8 58            	sllw	x
4152  0bb9 58            	sllw	x
4153  0bba 1f01          	ldw	(OFST-2,sp),x
4155                     ; 454     if (len > freesize) len = freesize;
4157  0bbc 1e09          	ldw	x,(OFST+6,sp)
4158  0bbe 1301          	cpw	x,(OFST-2,sp)
4159  0bc0 2304          	jrule	L5151
4162  0bc2 1e01          	ldw	x,(OFST-2,sp)
4163  0bc4 1f09          	ldw	(OFST+6,sp),x
4164  0bc6               L5151:
4165                     ; 456         freesize = getSn_TX_FSR(sn);
4167  0bc6 7b04          	ld	a,(OFST+1,sp)
4168  0bc8 cd012b        	call	_getSn_TX_FSR
4170  0bcb 1f01          	ldw	(OFST-2,sp),x
4172                     ; 457         tmp = getSn_SR(sn);
4174  0bcd 7b04          	ld	a,(OFST+1,sp)
4175  0bcf 97            	ld	xl,a
4176  0bd0 a604          	ld	a,#4
4177  0bd2 42            	mul	x,a
4178  0bd3 58            	sllw	x
4179  0bd4 58            	sllw	x
4180  0bd5 58            	sllw	x
4181  0bd6 1c0308        	addw	x,#776
4182  0bd9 cd0000        	call	c_itolx
4184  0bdc be02          	ldw	x,c_lreg+2
4185  0bde 89            	pushw	x
4186  0bdf be00          	ldw	x,c_lreg
4187  0be1 89            	pushw	x
4188  0be2 cd000b        	call	_WIZCHIP_READ
4190  0be5 5b04          	addw	sp,#4
4191  0be7 6b03          	ld	(OFST+0,sp),a
4193                     ; 458         if((tmp != SOCK_ESTABLISHED) && (tmp != SOCK_CLOSE_WAIT)){
4195  0be9 7b03          	ld	a,(OFST+0,sp)
4196  0beb a117          	cp	a,#23
4197  0bed 2719          	jreq	L1251
4199  0bef 7b03          	ld	a,(OFST+0,sp)
4200  0bf1 a11c          	cp	a,#28
4201  0bf3 2713          	jreq	L1251
4202                     ; 459             close(sn);
4204  0bf5 7b04          	ld	a,(OFST+1,sp)
4205  0bf7 cd06a6        	call	_close
4207                     ; 460             return SOCKERR_SOCKSTATUS;
4209  0bfa aefff9        	ldw	x,#65529
4210  0bfd bf02          	ldw	c_lreg+2,x
4211  0bff aeffff        	ldw	x,#-1
4212  0c02 bf00          	ldw	c_lreg,x
4214  0c04 acb90ab9      	jpf	L402
4215  0c08               L1251:
4216                     ; 462         if((sock_io_mode & (1<<sn)) && (len > freesize)) return SOCK_BUSY;
4218  0c08 ae0001        	ldw	x,#1
4219  0c0b 7b04          	ld	a,(OFST+1,sp)
4220  0c0d 4d            	tnz	a
4221  0c0e 2704          	jreq	L002
4222  0c10               L202:
4223  0c10 58            	sllw	x
4224  0c11 4a            	dec	a
4225  0c12 26fc          	jrne	L202
4226  0c14               L002:
4227  0c14 01            	rrwa	x,a
4228  0c15 b41d          	and	a,L52_sock_io_mode+1
4229  0c17 01            	rrwa	x,a
4230  0c18 b41c          	and	a,L52_sock_io_mode
4231  0c1a 01            	rrwa	x,a
4232  0c1b a30000        	cpw	x,#0
4233  0c1e 2714          	jreq	L3251
4235  0c20 1e09          	ldw	x,(OFST+6,sp)
4236  0c22 1301          	cpw	x,(OFST-2,sp)
4237  0c24 230e          	jrule	L3251
4240  0c26 ae0000        	ldw	x,#0
4241  0c29 bf02          	ldw	c_lreg+2,x
4242  0c2b ae0000        	ldw	x,#0
4243  0c2e bf00          	ldw	c_lreg,x
4245  0c30 acb90ab9      	jpf	L402
4246  0c34               L3251:
4247                     ; 463         if(len <= freesize) break;
4249  0c34 1e09          	ldw	x,(OFST+6,sp)
4250  0c36 1301          	cpw	x,(OFST-2,sp)
4251  0c38 228c          	jrugt	L5151
4253                     ; 465     wiz_send_data(sn, buf, len);
4255  0c3a 1e09          	ldw	x,(OFST+6,sp)
4256  0c3c 89            	pushw	x
4257  0c3d 1e09          	ldw	x,(OFST+6,sp)
4258  0c3f 89            	pushw	x
4259  0c40 7b08          	ld	a,(OFST+5,sp)
4260  0c42 cd02ef        	call	_wiz_send_data
4262  0c45 5b04          	addw	sp,#4
4263                     ; 466     setSn_CR(sn,Sn_CR_SEND);
4265  0c47 4b20          	push	#32
4266  0c49 7b05          	ld	a,(OFST+2,sp)
4267  0c4b 97            	ld	xl,a
4268  0c4c a604          	ld	a,#4
4269  0c4e 42            	mul	x,a
4270  0c4f 58            	sllw	x
4271  0c50 58            	sllw	x
4272  0c51 58            	sllw	x
4273  0c52 1c0108        	addw	x,#264
4274  0c55 cd0000        	call	c_itolx
4276  0c58 be02          	ldw	x,c_lreg+2
4277  0c5a 89            	pushw	x
4278  0c5b be00          	ldw	x,c_lreg
4279  0c5d 89            	pushw	x
4280  0c5e cd0060        	call	_WIZCHIP_WRITE
4282  0c61 5b05          	addw	sp,#5
4284  0c63               L1351:
4285                     ; 467     while(getSn_CR(sn));
4287  0c63 7b04          	ld	a,(OFST+1,sp)
4288  0c65 97            	ld	xl,a
4289  0c66 a604          	ld	a,#4
4290  0c68 42            	mul	x,a
4291  0c69 58            	sllw	x
4292  0c6a 58            	sllw	x
4293  0c6b 58            	sllw	x
4294  0c6c 1c0108        	addw	x,#264
4295  0c6f cd0000        	call	c_itolx
4297  0c72 be02          	ldw	x,c_lreg+2
4298  0c74 89            	pushw	x
4299  0c75 be00          	ldw	x,c_lreg
4300  0c77 89            	pushw	x
4301  0c78 cd000b        	call	_WIZCHIP_READ
4303  0c7b 5b04          	addw	sp,#4
4304  0c7d 4d            	tnz	a
4305  0c7e 26e3          	jrne	L1351
4306                     ; 468     return (int32_t)len;
4308  0c80 1e09          	ldw	x,(OFST+6,sp)
4309  0c82 cd0000        	call	c_uitolx
4312  0c85 acb90ab9      	jpf	L402
4555                     	xdef	_sock_pack_info
4556                     	xdef	_send
4557                     	xdef	_recv
4558                     	xdef	_listen
4559                     	xdef	_close
4560                     	xdef	_socket
4561                     	xdef	_wizchip_init
4562                     	xdef	_wiz_recv_data
4563                     	xdef	_wizchip_setnetinfo
4564                     	xdef	_wiz_send_data
4565                     	xdef	_reg_wizchip_spiburst_cbfunc
4566                     	xdef	_reg_wizchip_spi_cbfunc
4567                     	xdef	_WIZCHIP_WRITE_BUF
4568                     	xdef	_getSn_RX_RSR
4569                     	xdef	_getSn_TX_FSR
4570                     	xdef	_reg_wizchip_cs_cbfunc
4571                     	xdef	_WIZCHIP_READ_BUF
4572                     	xdef	_WIZCHIP_READ
4573                     	xdef	_WIZCHIP_WRITE
4574                     	xdef	_WIZCHIP
4575                     	xref.b	c_lreg
4576                     	xref.b	c_x
4577                     	xref.b	c_y
4596                     	xref	c_uitolx
4597                     	xref	c_lzmp
4598                     	xref	c_ladd
4599                     	xref	c_rtol
4600                     	xref	c_umul
4601                     	xref	c_itolx
4602                     	end
