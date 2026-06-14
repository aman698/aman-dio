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
2016                     ; 268 int8_t wizchip_init(uint8_t* txsize, uint8_t* rxsize)
2016                     ; 269 {
2017                     	switch	.text
2018  041f               _wizchip_init:
2020  041f 89            	pushw	x
2021  0420 89            	pushw	x
2022       00000002      OFST:	set	2
2025                     ; 271     int8_t tmp = 0;
2027  0421 0f01          	clr	(OFST-1,sp)
2029                     ; 273     if(txsize)
2031  0423 a30000        	cpw	x,#0
2032  0426 2603          	jrne	L601
2033  0428 cc04ed        	jp	L576
2034  042b               L601:
2035                     ; 275         for(i = 0; i < _WIZCHIP_SOCK_NUM_; i++)
2037  042b 0f02          	clr	(OFST+0,sp)
2039  042d               L776:
2040                     ; 277             tmp += txsize[i];
2042  042d 7b02          	ld	a,(OFST+0,sp)
2043  042f 5f            	clrw	x
2044  0430 4d            	tnz	a
2045  0431 2a01          	jrpl	L07
2046  0433 53            	cplw	x
2047  0434               L07:
2048  0434 97            	ld	xl,a
2049  0435 72fb03        	addw	x,(OFST+1,sp)
2050  0438 7b01          	ld	a,(OFST-1,sp)
2051  043a fb            	add	a,(x)
2052  043b 6b01          	ld	(OFST-1,sp),a
2054                     ; 279             if(tmp > 16)
2056  043d 9c            	rvf
2057  043e 7b01          	ld	a,(OFST-1,sp)
2058  0440 a111          	cp	a,#17
2059  0442 2f04          	jrslt	L507
2060                     ; 280                 return -1;
2062  0444 a6ff          	ld	a,#255
2064  0446 2060          	jra	L401
2065  0448               L507:
2066                     ; 275         for(i = 0; i < _WIZCHIP_SOCK_NUM_; i++)
2068  0448 0c02          	inc	(OFST+0,sp)
2072  044a 9c            	rvf
2073  044b 7b02          	ld	a,(OFST+0,sp)
2074  044d a108          	cp	a,#8
2075  044f 2fdc          	jrslt	L776
2076                     ; 283         for(i = 0; i < _WIZCHIP_SOCK_NUM_; i++)
2078  0451 0f02          	clr	(OFST+0,sp)
2080  0453               L707:
2081                     ; 285             setSn_TXBUF_SIZE(i, txsize[i]);
2083  0453 7b02          	ld	a,(OFST+0,sp)
2084  0455 5f            	clrw	x
2085  0456 4d            	tnz	a
2086  0457 2a01          	jrpl	L27
2087  0459 53            	cplw	x
2088  045a               L27:
2089  045a 97            	ld	xl,a
2090  045b 72fb03        	addw	x,(OFST+1,sp)
2091  045e f6            	ld	a,(x)
2092  045f 88            	push	a
2093  0460 7b03          	ld	a,(OFST+1,sp)
2094  0462 5f            	clrw	x
2095  0463 4d            	tnz	a
2096  0464 2a01          	jrpl	L47
2097  0466 53            	cplw	x
2098  0467               L47:
2099  0467 97            	ld	xl,a
2100  0468 58            	sllw	x
2101  0469 58            	sllw	x
2102  046a 58            	sllw	x
2103  046b 58            	sllw	x
2104  046c 58            	sllw	x
2105  046d 1c1f08        	addw	x,#7944
2106  0470 cd0000        	call	c_itolx
2108  0473 be02          	ldw	x,c_lreg+2
2109  0475 89            	pushw	x
2110  0476 be00          	ldw	x,c_lreg
2111  0478 89            	pushw	x
2112  0479 cd0060        	call	_WIZCHIP_WRITE
2114  047c 5b05          	addw	sp,#5
2115                     ; 283         for(i = 0; i < _WIZCHIP_SOCK_NUM_; i++)
2117  047e 0c02          	inc	(OFST+0,sp)
2121  0480 9c            	rvf
2122  0481 7b02          	ld	a,(OFST+0,sp)
2123  0483 a108          	cp	a,#8
2124  0485 2fcc          	jrslt	L707
2125                     ; 287         if(rxsize){
2127  0487 1e07          	ldw	x,(OFST+5,sp)
2128  0489 275f          	jreq	L517
2129                     ; 288             tmp = 0;
2131  048b 0f01          	clr	(OFST-1,sp)
2133                     ; 289             for(i = 0; i < _WIZCHIP_SOCK_NUM_; i++){
2135  048d 0f02          	clr	(OFST+0,sp)
2137  048f               L717:
2138                     ; 290                 tmp += rxsize[i];
2140  048f 7b02          	ld	a,(OFST+0,sp)
2141  0491 5f            	clrw	x
2142  0492 4d            	tnz	a
2143  0493 2a01          	jrpl	L67
2144  0495 53            	cplw	x
2145  0496               L67:
2146  0496 97            	ld	xl,a
2147  0497 72fb07        	addw	x,(OFST+5,sp)
2148  049a 7b01          	ld	a,(OFST-1,sp)
2149  049c fb            	add	a,(x)
2150  049d 6b01          	ld	(OFST-1,sp),a
2152                     ; 291                 if(tmp > 16) return -1;
2154  049f 9c            	rvf
2155  04a0 7b01          	ld	a,(OFST-1,sp)
2156  04a2 a111          	cp	a,#17
2157  04a4 2f05          	jrslt	L527
2160  04a6 a6ff          	ld	a,#255
2162  04a8               L401:
2164  04a8 5b04          	addw	sp,#4
2165  04aa 81            	ret
2166  04ab               L527:
2167                     ; 289             for(i = 0; i < _WIZCHIP_SOCK_NUM_; i++){
2169  04ab 0c02          	inc	(OFST+0,sp)
2173  04ad 9c            	rvf
2174  04ae 7b02          	ld	a,(OFST+0,sp)
2175  04b0 a108          	cp	a,#8
2176  04b2 2fdb          	jrslt	L717
2177                     ; 293             for(i = 0; i < _WIZCHIP_SOCK_NUM_; i++){
2179  04b4 0f02          	clr	(OFST+0,sp)
2181  04b6               L727:
2182                     ; 294                 setSn_RXBUF_SIZE(i, rxsize[i]);
2184  04b6 7b02          	ld	a,(OFST+0,sp)
2185  04b8 5f            	clrw	x
2186  04b9 4d            	tnz	a
2187  04ba 2a01          	jrpl	L001
2188  04bc 53            	cplw	x
2189  04bd               L001:
2190  04bd 97            	ld	xl,a
2191  04be 72fb07        	addw	x,(OFST+5,sp)
2192  04c1 f6            	ld	a,(x)
2193  04c2 88            	push	a
2194  04c3 7b03          	ld	a,(OFST+1,sp)
2195  04c5 5f            	clrw	x
2196  04c6 4d            	tnz	a
2197  04c7 2a01          	jrpl	L201
2198  04c9 53            	cplw	x
2199  04ca               L201:
2200  04ca 97            	ld	xl,a
2201  04cb 58            	sllw	x
2202  04cc 58            	sllw	x
2203  04cd 58            	sllw	x
2204  04ce 58            	sllw	x
2205  04cf 58            	sllw	x
2206  04d0 1c1e08        	addw	x,#7688
2207  04d3 cd0000        	call	c_itolx
2209  04d6 be02          	ldw	x,c_lreg+2
2210  04d8 89            	pushw	x
2211  04d9 be00          	ldw	x,c_lreg
2212  04db 89            	pushw	x
2213  04dc cd0060        	call	_WIZCHIP_WRITE
2215  04df 5b05          	addw	sp,#5
2216                     ; 293             for(i = 0; i < _WIZCHIP_SOCK_NUM_; i++){
2218  04e1 0c02          	inc	(OFST+0,sp)
2222  04e3 9c            	rvf
2223  04e4 7b02          	ld	a,(OFST+0,sp)
2224  04e6 a108          	cp	a,#8
2225  04e8 2fcc          	jrslt	L727
2226  04ea               L517:
2227                     ; 297         return 0;
2229  04ea 4f            	clr	a
2231  04eb 20bb          	jra	L401
2232  04ed               L576:
2233                     ; 300     (void)rxsize;
2235                     ; 302     return 0;
2237  04ed 4f            	clr	a
2239  04ee 20b8          	jra	L401
2317                     ; 305 int8_t socket(uint8_t sn, uint8_t protocol, uint16_t port, uint8_t flag){
2318                     	switch	.text
2319  04f0               _socket:
2321  04f0 89            	pushw	x
2322  04f1 5204          	subw	sp,#4
2323       00000004      OFST:	set	4
2326                     ; 306     CHECK_SOCKNUM();
2328  04f3 7b05          	ld	a,(OFST+1,sp)
2329  04f5 a108          	cp	a,#8
2330  04f7 2504          	jrult	L7001
2333  04f9 a6ff          	ld	a,#255
2335  04fb 2027          	jra	L221
2336  04fd               L7001:
2337                     ; 307     switch(protocol)
2339  04fd 7b06          	ld	a,(OFST+2,sp)
2340  04ff a101          	cp	a,#1
2341  0501 2624          	jrne	L737
2344  0503               L537:
2345                     ; 312             getSIPR((uint8_t*)&taddr);
2347  0503 ae0004        	ldw	x,#4
2348  0506 89            	pushw	x
2349  0507 96            	ldw	x,sp
2350  0508 1c0003        	addw	x,#OFST-1
2351  050b 89            	pushw	x
2352  050c ae000f        	ldw	x,#15
2353  050f 89            	pushw	x
2354  0510 ae0000        	ldw	x,#0
2355  0513 89            	pushw	x
2356  0514 cd00b9        	call	_WIZCHIP_READ_BUF
2358  0517 5b08          	addw	sp,#8
2359                     ; 313             if(taddr == 0) return SOCKERR_SOCKINIT;
2361  0519 96            	ldw	x,sp
2362  051a 1c0001        	addw	x,#OFST-3
2363  051d cd0000        	call	c_lzmp
2365  0520 2605          	jrne	L737
2368  0522 a6fd          	ld	a,#253
2370  0524               L221:
2372  0524 5b06          	addw	sp,#6
2373  0526 81            	ret
2374  0527               L737:
2375                     ; 315         default :
2375                     ; 316             return SOCKERR_SOCKMODE;
2377  0527 a6fb          	ld	a,#251
2379  0529 20f9          	jra	L221
2380  052b               L147:
2381                     ; 321             case Sn_MR_TCP:
2381                     ; 322                  if((flag & (SF_TCP_NODELAY|SF_IO_NONBLOCK))==0) return SOCKERR_SOCKFLAG;
2383  052b 7b0b          	ld	a,(OFST+7,sp)
2384  052d a521          	bcp	a,#33
2385  052f 2604          	jrne	L1201
2388  0531 a6fa          	ld	a,#250
2390  0533 20ef          	jra	L221
2391  0535               L347:
2392                     ; 324             default:
2392                     ; 325                break;
2394  0535               L1201:
2395                     ; 328     close(sn);
2397  0535 7b05          	ld	a,(OFST+1,sp)
2398  0537 cd064a        	call	_close
2400                     ; 329     setSn_MR(sn, (protocol | (flag & 0xF0)));
2402  053a 7b0b          	ld	a,(OFST+7,sp)
2403  053c a4f0          	and	a,#240
2404  053e 1a06          	or	a,(OFST+2,sp)
2405  0540 88            	push	a
2406  0541 7b06          	ld	a,(OFST+2,sp)
2407  0543 97            	ld	xl,a
2408  0544 a604          	ld	a,#4
2409  0546 42            	mul	x,a
2410  0547 58            	sllw	x
2411  0548 58            	sllw	x
2412  0549 58            	sllw	x
2413  054a 1c0008        	addw	x,#8
2414  054d cd0000        	call	c_itolx
2416  0550 be02          	ldw	x,c_lreg+2
2417  0552 89            	pushw	x
2418  0553 be00          	ldw	x,c_lreg
2419  0555 89            	pushw	x
2420  0556 cd0060        	call	_WIZCHIP_WRITE
2422  0559 5b05          	addw	sp,#5
2423                     ; 330     if(!port)
2425  055b 1e09          	ldw	x,(OFST+5,sp)
2426  055d 2618          	jrne	L1301
2427                     ; 332         port = sock_any_port++;
2429  055f be00          	ldw	x,L3_sock_any_port
2430  0561 1c0001        	addw	x,#1
2431  0564 bf00          	ldw	L3_sock_any_port,x
2432  0566 1d0001        	subw	x,#1
2433  0569 1f09          	ldw	(OFST+5,sp),x
2434                     ; 333         if(sock_any_port == 0xFFF0) sock_any_port = SOCK_ANY_PORT_NUM;
2436  056b be00          	ldw	x,L3_sock_any_port
2437  056d a3fff0        	cpw	x,#65520
2438  0570 2605          	jrne	L1301
2441  0572 aec000        	ldw	x,#49152
2442  0575 bf00          	ldw	L3_sock_any_port,x
2443  0577               L1301:
2444                     ; 335     setSn_PORT(sn,port);
2446  0577 7b09          	ld	a,(OFST+5,sp)
2447  0579 88            	push	a
2448  057a 7b06          	ld	a,(OFST+2,sp)
2449  057c 97            	ld	xl,a
2450  057d a604          	ld	a,#4
2451  057f 42            	mul	x,a
2452  0580 58            	sllw	x
2453  0581 58            	sllw	x
2454  0582 58            	sllw	x
2455  0583 1c0408        	addw	x,#1032
2456  0586 cd0000        	call	c_itolx
2458  0589 be02          	ldw	x,c_lreg+2
2459  058b 89            	pushw	x
2460  058c be00          	ldw	x,c_lreg
2461  058e 89            	pushw	x
2462  058f cd0060        	call	_WIZCHIP_WRITE
2464  0592 5b05          	addw	sp,#5
2467  0594 7b0a          	ld	a,(OFST+6,sp)
2468  0596 88            	push	a
2469  0597 7b06          	ld	a,(OFST+2,sp)
2470  0599 97            	ld	xl,a
2471  059a a604          	ld	a,#4
2472  059c 42            	mul	x,a
2473  059d 58            	sllw	x
2474  059e 58            	sllw	x
2475  059f 58            	sllw	x
2476  05a0 1c0508        	addw	x,#1288
2477  05a3 cd0000        	call	c_itolx
2479  05a6 be02          	ldw	x,c_lreg+2
2480  05a8 89            	pushw	x
2481  05a9 be00          	ldw	x,c_lreg
2482  05ab 89            	pushw	x
2483  05ac cd0060        	call	_WIZCHIP_WRITE
2485  05af 5b05          	addw	sp,#5
2486                     ; 336     setSn_CR(sn,Sn_CR_OPEN);
2489  05b1 4b01          	push	#1
2490  05b3 7b06          	ld	a,(OFST+2,sp)
2491  05b5 97            	ld	xl,a
2492  05b6 a604          	ld	a,#4
2493  05b8 42            	mul	x,a
2494  05b9 58            	sllw	x
2495  05ba 58            	sllw	x
2496  05bb 58            	sllw	x
2497  05bc 1c0108        	addw	x,#264
2498  05bf cd0000        	call	c_itolx
2500  05c2 be02          	ldw	x,c_lreg+2
2501  05c4 89            	pushw	x
2502  05c5 be00          	ldw	x,c_lreg
2503  05c7 89            	pushw	x
2504  05c8 cd0060        	call	_WIZCHIP_WRITE
2506  05cb 5b05          	addw	sp,#5
2508  05cd               L7301:
2509                     ; 337     while(getSn_CR(sn));
2511  05cd 7b05          	ld	a,(OFST+1,sp)
2512  05cf 97            	ld	xl,a
2513  05d0 a604          	ld	a,#4
2514  05d2 42            	mul	x,a
2515  05d3 58            	sllw	x
2516  05d4 58            	sllw	x
2517  05d5 58            	sllw	x
2518  05d6 1c0108        	addw	x,#264
2519  05d9 cd0000        	call	c_itolx
2521  05dc be02          	ldw	x,c_lreg+2
2522  05de 89            	pushw	x
2523  05df be00          	ldw	x,c_lreg
2524  05e1 89            	pushw	x
2525  05e2 cd000b        	call	_WIZCHIP_READ
2527  05e5 5b04          	addw	sp,#4
2528  05e7 4d            	tnz	a
2529  05e8 26e3          	jrne	L7301
2530                     ; 338     sock_io_mode &= ~(1 << sn);
2532  05ea ae0001        	ldw	x,#1
2533  05ed 7b05          	ld	a,(OFST+1,sp)
2534  05ef 4d            	tnz	a
2535  05f0 2704          	jreq	L211
2536  05f2               L411:
2537  05f2 58            	sllw	x
2538  05f3 4a            	dec	a
2539  05f4 26fc          	jrne	L411
2540  05f6               L211:
2541  05f6 53            	cplw	x
2542  05f7 01            	rrwa	x,a
2543  05f8 b41d          	and	a,L52_sock_io_mode+1
2544  05fa 01            	rrwa	x,a
2545  05fb b41c          	and	a,L52_sock_io_mode
2546  05fd 01            	rrwa	x,a
2547  05fe bf1c          	ldw	L52_sock_io_mode,x
2548                     ; 339     sock_io_mode |= ((flag & SF_IO_NONBLOCK) << sn);
2550  0600 7b0b          	ld	a,(OFST+7,sp)
2551  0602 a401          	and	a,#1
2552  0604 5f            	clrw	x
2553  0605 97            	ld	xl,a
2554  0606 7b05          	ld	a,(OFST+1,sp)
2555  0608 4d            	tnz	a
2556  0609 2704          	jreq	L611
2557  060b               L021:
2558  060b 58            	sllw	x
2559  060c 4a            	dec	a
2560  060d 26fc          	jrne	L021
2561  060f               L611:
2562  060f 01            	rrwa	x,a
2563  0610 ba1d          	or	a,L52_sock_io_mode+1
2564  0612 01            	rrwa	x,a
2565  0613 ba1c          	or	a,L52_sock_io_mode
2566  0615 01            	rrwa	x,a
2567  0616 bf1c          	ldw	L52_sock_io_mode,x
2568                     ; 340     sock_remained_size[sn] = 0;
2570  0618 7b05          	ld	a,(OFST+1,sp)
2571  061a 5f            	clrw	x
2572  061b 97            	ld	xl,a
2573  061c 58            	sllw	x
2574  061d 905f          	clrw	y
2575  061f ef02          	ldw	(L12_sock_remained_size,x),y
2576                     ; 341     sock_pack_info[sn] = PACK_COMPLETED;
2578  0621 7b05          	ld	a,(OFST+1,sp)
2579  0623 5f            	clrw	x
2580  0624 97            	ld	xl,a
2581  0625 6f12          	clr	(_sock_pack_info,x)
2583  0627               L7401:
2584                     ; 342     while(getSn_SR(sn) == SOCK_CLOSED);
2586  0627 7b05          	ld	a,(OFST+1,sp)
2587  0629 97            	ld	xl,a
2588  062a a604          	ld	a,#4
2589  062c 42            	mul	x,a
2590  062d 58            	sllw	x
2591  062e 58            	sllw	x
2592  062f 58            	sllw	x
2593  0630 1c0308        	addw	x,#776
2594  0633 cd0000        	call	c_itolx
2596  0636 be02          	ldw	x,c_lreg+2
2597  0638 89            	pushw	x
2598  0639 be00          	ldw	x,c_lreg
2599  063b 89            	pushw	x
2600  063c cd000b        	call	_WIZCHIP_READ
2602  063f 5b04          	addw	sp,#4
2603  0641 4d            	tnz	a
2604  0642 27e3          	jreq	L7401
2605                     ; 343     return (int8_t)sn;
2607  0644 7b05          	ld	a,(OFST+1,sp)
2609  0646 ac240524      	jpf	L221
2649                     ; 345 int8_t close(uint8_t sn){
2650                     	switch	.text
2651  064a               _close:
2653  064a 88            	push	a
2654       00000000      OFST:	set	0
2657                     ; 346     CHECK_SOCKNUM();
2659  064b 7b01          	ld	a,(OFST+1,sp)
2660  064d a108          	cp	a,#8
2661  064f 2505          	jrult	L5701
2664  0651 a6ff          	ld	a,#255
2667  0653 5b01          	addw	sp,#1
2668  0655 81            	ret
2669  0656               L5701:
2670                     ; 347     setSn_CR(sn,Sn_CR_CLOSE);
2672  0656 4b10          	push	#16
2673  0658 7b02          	ld	a,(OFST+2,sp)
2674  065a 97            	ld	xl,a
2675  065b a604          	ld	a,#4
2676  065d 42            	mul	x,a
2677  065e 58            	sllw	x
2678  065f 58            	sllw	x
2679  0660 58            	sllw	x
2680  0661 1c0108        	addw	x,#264
2681  0664 cd0000        	call	c_itolx
2683  0667 be02          	ldw	x,c_lreg+2
2684  0669 89            	pushw	x
2685  066a be00          	ldw	x,c_lreg
2686  066c 89            	pushw	x
2687  066d cd0060        	call	_WIZCHIP_WRITE
2689  0670 5b05          	addw	sp,#5
2691  0672               L1011:
2692                     ; 348     while(getSn_CR(sn));
2694  0672 7b01          	ld	a,(OFST+1,sp)
2695  0674 97            	ld	xl,a
2696  0675 a604          	ld	a,#4
2697  0677 42            	mul	x,a
2698  0678 58            	sllw	x
2699  0679 58            	sllw	x
2700  067a 58            	sllw	x
2701  067b 1c0108        	addw	x,#264
2702  067e cd0000        	call	c_itolx
2704  0681 be02          	ldw	x,c_lreg+2
2705  0683 89            	pushw	x
2706  0684 be00          	ldw	x,c_lreg
2707  0686 89            	pushw	x
2708  0687 cd000b        	call	_WIZCHIP_READ
2710  068a 5b04          	addw	sp,#4
2711  068c 4d            	tnz	a
2712  068d 26e3          	jrne	L1011
2713                     ; 349     setSn_IR(sn, 0xFF);
2715  068f 4b1f          	push	#31
2716  0691 7b02          	ld	a,(OFST+2,sp)
2717  0693 97            	ld	xl,a
2718  0694 a604          	ld	a,#4
2719  0696 42            	mul	x,a
2720  0697 58            	sllw	x
2721  0698 58            	sllw	x
2722  0699 58            	sllw	x
2723  069a 1c0208        	addw	x,#520
2724  069d cd0000        	call	c_itolx
2726  06a0 be02          	ldw	x,c_lreg+2
2727  06a2 89            	pushw	x
2728  06a3 be00          	ldw	x,c_lreg
2729  06a5 89            	pushw	x
2730  06a6 cd0060        	call	_WIZCHIP_WRITE
2732  06a9 5b05          	addw	sp,#5
2733                     ; 350     sock_io_mode &= ~(1 << sn);
2735  06ab ae0001        	ldw	x,#1
2736  06ae 7b01          	ld	a,(OFST+1,sp)
2737  06b0 4d            	tnz	a
2738  06b1 2704          	jreq	L621
2739  06b3               L031:
2740  06b3 58            	sllw	x
2741  06b4 4a            	dec	a
2742  06b5 26fc          	jrne	L031
2743  06b7               L621:
2744  06b7 53            	cplw	x
2745  06b8 01            	rrwa	x,a
2746  06b9 b41d          	and	a,L52_sock_io_mode+1
2747  06bb 01            	rrwa	x,a
2748  06bc b41c          	and	a,L52_sock_io_mode
2749  06be 01            	rrwa	x,a
2750  06bf bf1c          	ldw	L52_sock_io_mode,x
2751                     ; 351     sock_is_sending &= ~(1 << sn);
2753  06c1 ae0001        	ldw	x,#1
2754  06c4 7b01          	ld	a,(OFST+1,sp)
2755  06c6 4d            	tnz	a
2756  06c7 2704          	jreq	L231
2757  06c9               L431:
2758  06c9 58            	sllw	x
2759  06ca 4a            	dec	a
2760  06cb 26fc          	jrne	L431
2761  06cd               L231:
2762  06cd 53            	cplw	x
2763  06ce 01            	rrwa	x,a
2764  06cf b41b          	and	a,L32_sock_is_sending+1
2765  06d1 01            	rrwa	x,a
2766  06d2 b41a          	and	a,L32_sock_is_sending
2767  06d4 01            	rrwa	x,a
2768  06d5 bf1a          	ldw	L32_sock_is_sending,x
2769                     ; 352     sock_remained_size[sn] = 0;
2771  06d7 7b01          	ld	a,(OFST+1,sp)
2772  06d9 5f            	clrw	x
2773  06da 97            	ld	xl,a
2774  06db 58            	sllw	x
2775  06dc 905f          	clrw	y
2776  06de ef02          	ldw	(L12_sock_remained_size,x),y
2777                     ; 353     sock_pack_info[sn] = 0;
2779  06e0 7b01          	ld	a,(OFST+1,sp)
2780  06e2 5f            	clrw	x
2781  06e3 97            	ld	xl,a
2782  06e4 6f12          	clr	(_sock_pack_info,x)
2784  06e6               L1111:
2785                     ; 354     while(getSn_SR(sn) != SOCK_CLOSED);
2787  06e6 7b01          	ld	a,(OFST+1,sp)
2788  06e8 97            	ld	xl,a
2789  06e9 a604          	ld	a,#4
2790  06eb 42            	mul	x,a
2791  06ec 58            	sllw	x
2792  06ed 58            	sllw	x
2793  06ee 58            	sllw	x
2794  06ef 1c0308        	addw	x,#776
2795  06f2 cd0000        	call	c_itolx
2797  06f5 be02          	ldw	x,c_lreg+2
2798  06f7 89            	pushw	x
2799  06f8 be00          	ldw	x,c_lreg
2800  06fa 89            	pushw	x
2801  06fb cd000b        	call	_WIZCHIP_READ
2803  06fe 5b04          	addw	sp,#4
2804  0700 4d            	tnz	a
2805  0701 26e3          	jrne	L1111
2806                     ; 355 	return SOCK_OK;
2808  0703 a601          	ld	a,#1
2811  0705 5b01          	addw	sp,#1
2812  0707 81            	ret
2849                     ; 357 int8_t listen(uint8_t sn){
2850                     	switch	.text
2851  0708               _listen:
2853  0708 88            	push	a
2854       00000000      OFST:	set	0
2857                     ; 358     CHECK_SOCKNUM();
2859  0709 7b01          	ld	a,(OFST+1,sp)
2860  070b a108          	cp	a,#8
2861  070d 2505          	jrult	L1411
2864  070f a6ff          	ld	a,#255
2867  0711 5b01          	addw	sp,#1
2868  0713 81            	ret
2869  0714               L1411:
2870                     ; 359     CHECK_SOCKMODE(Sn_MR_TCP);
2872  0714 7b01          	ld	a,(OFST+1,sp)
2873  0716 97            	ld	xl,a
2874  0717 a604          	ld	a,#4
2875  0719 42            	mul	x,a
2876  071a 58            	sllw	x
2877  071b 58            	sllw	x
2878  071c 58            	sllw	x
2879  071d 1c0008        	addw	x,#8
2880  0720 cd0000        	call	c_itolx
2882  0723 be02          	ldw	x,c_lreg+2
2883  0725 89            	pushw	x
2884  0726 be00          	ldw	x,c_lreg
2885  0728 89            	pushw	x
2886  0729 cd000b        	call	_WIZCHIP_READ
2888  072c 5b04          	addw	sp,#4
2889  072e a40f          	and	a,#15
2890  0730 a101          	cp	a,#1
2891  0732 2705          	jreq	L7411
2894  0734 a6fb          	ld	a,#251
2897  0736 5b01          	addw	sp,#1
2898  0738 81            	ret
2899  0739               L7411:
2900                     ; 360     CHECK_SOCKINIT();
2902  0739 7b01          	ld	a,(OFST+1,sp)
2903  073b 97            	ld	xl,a
2904  073c a604          	ld	a,#4
2905  073e 42            	mul	x,a
2906  073f 58            	sllw	x
2907  0740 58            	sllw	x
2908  0741 58            	sllw	x
2909  0742 1c0308        	addw	x,#776
2910  0745 cd0000        	call	c_itolx
2912  0748 be02          	ldw	x,c_lreg+2
2913  074a 89            	pushw	x
2914  074b be00          	ldw	x,c_lreg
2915  074d 89            	pushw	x
2916  074e cd000b        	call	_WIZCHIP_READ
2918  0751 5b04          	addw	sp,#4
2919  0753 a113          	cp	a,#19
2920  0755 2705          	jreq	L3511
2923  0757 a6fd          	ld	a,#253
2926  0759 5b01          	addw	sp,#1
2927  075b 81            	ret
2928  075c               L3511:
2929                     ; 361     setSn_CR(sn,Sn_CR_LISTEN);
2931  075c 4b02          	push	#2
2932  075e 7b02          	ld	a,(OFST+2,sp)
2933  0760 97            	ld	xl,a
2934  0761 a604          	ld	a,#4
2935  0763 42            	mul	x,a
2936  0764 58            	sllw	x
2937  0765 58            	sllw	x
2938  0766 58            	sllw	x
2939  0767 1c0108        	addw	x,#264
2940  076a cd0000        	call	c_itolx
2942  076d be02          	ldw	x,c_lreg+2
2943  076f 89            	pushw	x
2944  0770 be00          	ldw	x,c_lreg
2945  0772 89            	pushw	x
2946  0773 cd0060        	call	_WIZCHIP_WRITE
2948  0776 5b05          	addw	sp,#5
2950  0778               L7511:
2951                     ; 362     while(getSn_CR(sn));
2953  0778 7b01          	ld	a,(OFST+1,sp)
2954  077a 97            	ld	xl,a
2955  077b a604          	ld	a,#4
2956  077d 42            	mul	x,a
2957  077e 58            	sllw	x
2958  077f 58            	sllw	x
2959  0780 58            	sllw	x
2960  0781 1c0108        	addw	x,#264
2961  0784 cd0000        	call	c_itolx
2963  0787 be02          	ldw	x,c_lreg+2
2964  0789 89            	pushw	x
2965  078a be00          	ldw	x,c_lreg
2966  078c 89            	pushw	x
2967  078d cd000b        	call	_WIZCHIP_READ
2969  0790 5b04          	addw	sp,#4
2970  0792 4d            	tnz	a
2971  0793 26e3          	jrne	L7511
2973  0795 200a          	jra	L5611
2974  0797               L3611:
2975                     ; 365         close(sn);
2977  0797 7b01          	ld	a,(OFST+1,sp)
2978  0799 cd064a        	call	_close
2980                     ; 366         return SOCKERR_SOCKCLOSED;
2982  079c a6fc          	ld	a,#252
2985  079e 5b01          	addw	sp,#1
2986  07a0 81            	ret
2987  07a1               L5611:
2988                     ; 363     while(getSn_SR(sn) != SOCK_LISTEN)
2990  07a1 7b01          	ld	a,(OFST+1,sp)
2991  07a3 97            	ld	xl,a
2992  07a4 a604          	ld	a,#4
2993  07a6 42            	mul	x,a
2994  07a7 58            	sllw	x
2995  07a8 58            	sllw	x
2996  07a9 58            	sllw	x
2997  07aa 1c0308        	addw	x,#776
2998  07ad cd0000        	call	c_itolx
3000  07b0 be02          	ldw	x,c_lreg+2
3001  07b2 89            	pushw	x
3002  07b3 be00          	ldw	x,c_lreg
3003  07b5 89            	pushw	x
3004  07b6 cd000b        	call	_WIZCHIP_READ
3006  07b9 5b04          	addw	sp,#4
3007  07bb a114          	cp	a,#20
3008  07bd 26d8          	jrne	L3611
3009                     ; 368     return SOCK_OK;
3011  07bf a601          	ld	a,#1
3014  07c1 5b01          	addw	sp,#1
3015  07c3 81            	ret
3089                     ; 370 void wiz_recv_data(uint8_t sn, uint8_t *wizdata, uint16_t len)
3089                     ; 371 {
3090                     	switch	.text
3091  07c4               _wiz_recv_data:
3093  07c4 88            	push	a
3094  07c5 520a          	subw	sp,#10
3095       0000000a      OFST:	set	10
3098                     ; 372    uint16_t ptr = 0;
3100                     ; 373    uint32_t addrsel = 0;
3102                     ; 375    if(len == 0) return;
3104  07c7 1e10          	ldw	x,(OFST+6,sp)
3105  07c9 2603          	jrne	L641
3106  07cb cc0891        	jp	L441
3107  07ce               L641:
3110                     ; 376    ptr = getSn_RX_RD(sn);
3112  07ce 7b0b          	ld	a,(OFST+1,sp)
3113  07d0 97            	ld	xl,a
3114  07d1 a604          	ld	a,#4
3115  07d3 42            	mul	x,a
3116  07d4 58            	sllw	x
3117  07d5 58            	sllw	x
3118  07d6 58            	sllw	x
3119  07d7 1c2908        	addw	x,#10504
3120  07da cd0000        	call	c_itolx
3122  07dd be02          	ldw	x,c_lreg+2
3123  07df 89            	pushw	x
3124  07e0 be00          	ldw	x,c_lreg
3125  07e2 89            	pushw	x
3126  07e3 cd000b        	call	_WIZCHIP_READ
3128  07e6 5b04          	addw	sp,#4
3129  07e8 6b04          	ld	(OFST-6,sp),a
3131  07ea 7b0b          	ld	a,(OFST+1,sp)
3132  07ec 97            	ld	xl,a
3133  07ed a604          	ld	a,#4
3134  07ef 42            	mul	x,a
3135  07f0 58            	sllw	x
3136  07f1 58            	sllw	x
3137  07f2 58            	sllw	x
3138  07f3 1c2808        	addw	x,#10248
3139  07f6 cd0000        	call	c_itolx
3141  07f9 be02          	ldw	x,c_lreg+2
3142  07fb 89            	pushw	x
3143  07fc be00          	ldw	x,c_lreg
3144  07fe 89            	pushw	x
3145  07ff cd000b        	call	_WIZCHIP_READ
3147  0802 5b04          	addw	sp,#4
3148  0804 5f            	clrw	x
3149  0805 97            	ld	xl,a
3150  0806 4f            	clr	a
3151  0807 02            	rlwa	x,a
3152  0808 01            	rrwa	x,a
3153  0809 1b04          	add	a,(OFST-6,sp)
3154  080b 2401          	jrnc	L241
3155  080d 5c            	incw	x
3156  080e               L241:
3157  080e 02            	rlwa	x,a
3158  080f 1f09          	ldw	(OFST-1,sp),x
3159  0811 01            	rrwa	x,a
3161                     ; 379    addrsel = ((uint32_t)ptr << 8) + (WIZCHIP_RXBUF_BLOCK(sn) << 3);
3163  0812 7b0b          	ld	a,(OFST+1,sp)
3164  0814 97            	ld	xl,a
3165  0815 a604          	ld	a,#4
3166  0817 42            	mul	x,a
3167  0818 58            	sllw	x
3168  0819 58            	sllw	x
3169  081a 58            	sllw	x
3170  081b 1c0018        	addw	x,#24
3171  081e cd0000        	call	c_itolx
3173  0821 96            	ldw	x,sp
3174  0822 1c0001        	addw	x,#OFST-9
3175  0825 cd0000        	call	c_rtol
3178  0828 1e09          	ldw	x,(OFST-1,sp)
3179  082a 90ae0100      	ldw	y,#256
3180  082e cd0000        	call	c_umul
3182  0831 96            	ldw	x,sp
3183  0832 1c0001        	addw	x,#OFST-9
3184  0835 cd0000        	call	c_ladd
3186  0838 96            	ldw	x,sp
3187  0839 1c0005        	addw	x,#OFST-5
3188  083c cd0000        	call	c_rtol
3191                     ; 381    WIZCHIP_READ_BUF(addrsel, wizdata, len);
3193  083f 1e10          	ldw	x,(OFST+6,sp)
3194  0841 89            	pushw	x
3195  0842 1e10          	ldw	x,(OFST+6,sp)
3196  0844 89            	pushw	x
3197  0845 1e0b          	ldw	x,(OFST+1,sp)
3198  0847 89            	pushw	x
3199  0848 1e0b          	ldw	x,(OFST+1,sp)
3200  084a 89            	pushw	x
3201  084b cd00b9        	call	_WIZCHIP_READ_BUF
3203  084e 5b08          	addw	sp,#8
3204                     ; 382    ptr += len;
3206  0850 1e09          	ldw	x,(OFST-1,sp)
3207  0852 72fb10        	addw	x,(OFST+6,sp)
3208  0855 1f09          	ldw	(OFST-1,sp),x
3210                     ; 383    setSn_RX_RD(sn,ptr);
3212  0857 7b09          	ld	a,(OFST-1,sp)
3213  0859 88            	push	a
3214  085a 7b0c          	ld	a,(OFST+2,sp)
3215  085c 97            	ld	xl,a
3216  085d a604          	ld	a,#4
3217  085f 42            	mul	x,a
3218  0860 58            	sllw	x
3219  0861 58            	sllw	x
3220  0862 58            	sllw	x
3221  0863 1c2808        	addw	x,#10248
3222  0866 cd0000        	call	c_itolx
3224  0869 be02          	ldw	x,c_lreg+2
3225  086b 89            	pushw	x
3226  086c be00          	ldw	x,c_lreg
3227  086e 89            	pushw	x
3228  086f cd0060        	call	_WIZCHIP_WRITE
3230  0872 5b05          	addw	sp,#5
3233  0874 7b0a          	ld	a,(OFST+0,sp)
3234  0876 88            	push	a
3235  0877 7b0c          	ld	a,(OFST+2,sp)
3236  0879 97            	ld	xl,a
3237  087a a604          	ld	a,#4
3238  087c 42            	mul	x,a
3239  087d 58            	sllw	x
3240  087e 58            	sllw	x
3241  087f 58            	sllw	x
3242  0880 1c2908        	addw	x,#10504
3243  0883 cd0000        	call	c_itolx
3245  0886 be02          	ldw	x,c_lreg+2
3246  0888 89            	pushw	x
3247  0889 be00          	ldw	x,c_lreg
3248  088b 89            	pushw	x
3249  088c cd0060        	call	_WIZCHIP_WRITE
3251  088f 5b05          	addw	sp,#5
3252                     ; 384 }
3253  0891               L441:
3257  0891 5b0b          	addw	sp,#11
3258  0893 81            	ret
3336                     ; 386 int32_t recv(uint8_t sn, uint8_t *buf, uint16_t len){
3337                     	switch	.text
3338  0894               _recv:
3340  0894 88            	push	a
3341  0895 5205          	subw	sp,#5
3342       00000005      OFST:	set	5
3345                     ; 387     uint8_t tmp = 0;
3347                     ; 388     uint16_t recvsize = 0;
3349                     ; 389     CHECK_SOCKNUM();
3351  0897 7b06          	ld	a,(OFST+1,sp)
3352  0899 a108          	cp	a,#8
3353  089b 250c          	jrult	L5721
3356  089d aeffff        	ldw	x,#65535
3357  08a0 bf02          	ldw	c_lreg+2,x
3358  08a2 aeffff        	ldw	x,#-1
3359  08a5 bf00          	ldw	c_lreg,x
3361  08a7 202a          	jra	L651
3362  08a9               L5721:
3363                     ; 390     CHECK_SOCKMODE(Sn_MR_TCP);
3365  08a9 7b06          	ld	a,(OFST+1,sp)
3366  08ab 97            	ld	xl,a
3367  08ac a604          	ld	a,#4
3368  08ae 42            	mul	x,a
3369  08af 58            	sllw	x
3370  08b0 58            	sllw	x
3371  08b1 58            	sllw	x
3372  08b2 1c0008        	addw	x,#8
3373  08b5 cd0000        	call	c_itolx
3375  08b8 be02          	ldw	x,c_lreg+2
3376  08ba 89            	pushw	x
3377  08bb be00          	ldw	x,c_lreg
3378  08bd 89            	pushw	x
3379  08be cd000b        	call	_WIZCHIP_READ
3381  08c1 5b04          	addw	sp,#4
3382  08c3 a40f          	and	a,#15
3383  08c5 a101          	cp	a,#1
3384  08c7 270d          	jreq	L3031
3387  08c9 aefffb        	ldw	x,#65531
3388  08cc bf02          	ldw	c_lreg+2,x
3389  08ce aeffff        	ldw	x,#-1
3390  08d1 bf00          	ldw	c_lreg,x
3392  08d3               L651:
3394  08d3 5b06          	addw	sp,#6
3395  08d5 81            	ret
3396  08d6               L3031:
3397                     ; 391     CHECK_SOCKDATA();
3399  08d6 1e0b          	ldw	x,(OFST+6,sp)
3400  08d8 260c          	jrne	L7031
3403  08da aefff2        	ldw	x,#65522
3404  08dd bf02          	ldw	c_lreg+2,x
3405  08df aeffff        	ldw	x,#-1
3406  08e2 bf00          	ldw	c_lreg,x
3408  08e4 20ed          	jra	L651
3409  08e6               L7031:
3410                     ; 392     recvsize = getSn_RxMAX(sn);
3413  08e6 7b06          	ld	a,(OFST+1,sp)
3414  08e8 97            	ld	xl,a
3415  08e9 a604          	ld	a,#4
3416  08eb 42            	mul	x,a
3417  08ec 58            	sllw	x
3418  08ed 58            	sllw	x
3419  08ee 58            	sllw	x
3420  08ef 1c1e08        	addw	x,#7688
3421  08f2 cd0000        	call	c_itolx
3423  08f5 be02          	ldw	x,c_lreg+2
3424  08f7 89            	pushw	x
3425  08f8 be00          	ldw	x,c_lreg
3426  08fa 89            	pushw	x
3427  08fb cd000b        	call	_WIZCHIP_READ
3429  08fe 5b04          	addw	sp,#4
3430  0900 5f            	clrw	x
3431  0901 97            	ld	xl,a
3432  0902 4f            	clr	a
3433  0903 02            	rlwa	x,a
3434  0904 58            	sllw	x
3435  0905 58            	sllw	x
3436  0906 1f04          	ldw	(OFST-1,sp),x
3438                     ; 393     if(recvsize < len) len = recvsize;
3440  0908 1e04          	ldw	x,(OFST-1,sp)
3441  090a 130b          	cpw	x,(OFST+6,sp)
3442  090c 2404          	jruge	L3131
3445  090e 1e04          	ldw	x,(OFST-1,sp)
3446  0910 1f0b          	ldw	(OFST+6,sp),x
3447  0912               L3131:
3448                     ; 395         recvsize = getSn_RX_RSR(sn);
3450  0912 7b06          	ld	a,(OFST+1,sp)
3451  0914 cd01d3        	call	_getSn_RX_RSR
3453  0917 1f04          	ldw	(OFST-1,sp),x
3455                     ; 396         tmp = getSn_SR(sn);
3457  0919 7b06          	ld	a,(OFST+1,sp)
3458  091b 97            	ld	xl,a
3459  091c a604          	ld	a,#4
3460  091e 42            	mul	x,a
3461  091f 58            	sllw	x
3462  0920 58            	sllw	x
3463  0921 58            	sllw	x
3464  0922 1c0308        	addw	x,#776
3465  0925 cd0000        	call	c_itolx
3467  0928 be02          	ldw	x,c_lreg+2
3468  092a 89            	pushw	x
3469  092b be00          	ldw	x,c_lreg
3470  092d 89            	pushw	x
3471  092e cd000b        	call	_WIZCHIP_READ
3473  0931 5b04          	addw	sp,#4
3474  0933 6b03          	ld	(OFST-2,sp),a
3476                     ; 397         if(tmp != SOCK_ESTABLISHED){
3478  0935 7b03          	ld	a,(OFST-2,sp)
3479  0937 a117          	cp	a,#23
3480  0939 275e          	jreq	L7131
3481                     ; 398             if(tmp == SOCK_CLOSE_WAIT){
3483  093b 7b03          	ld	a,(OFST-2,sp)
3484  093d a11c          	cp	a,#28
3485  093f 2645          	jrne	L1231
3486                     ; 399                 if(recvsize != 0) break;
3488  0941 1e04          	ldw	x,(OFST-1,sp)
3489  0943 2703          	jreq	L061
3490  0945 cc09ca        	jp	L5131
3491  0948               L061:
3494                     ; 400                 else if(getSn_TX_FSR(sn) == getSn_TxMAX(sn))
3496  0948 7b06          	ld	a,(OFST+1,sp)
3497  094a 97            	ld	xl,a
3498  094b a604          	ld	a,#4
3499  094d 42            	mul	x,a
3500  094e 58            	sllw	x
3501  094f 58            	sllw	x
3502  0950 58            	sllw	x
3503  0951 1c1f08        	addw	x,#7944
3504  0954 cd0000        	call	c_itolx
3506  0957 be02          	ldw	x,c_lreg+2
3507  0959 89            	pushw	x
3508  095a be00          	ldw	x,c_lreg
3509  095c 89            	pushw	x
3510  095d cd000b        	call	_WIZCHIP_READ
3512  0960 5b04          	addw	sp,#4
3513  0962 5f            	clrw	x
3514  0963 97            	ld	xl,a
3515  0964 4f            	clr	a
3516  0965 02            	rlwa	x,a
3517  0966 58            	sllw	x
3518  0967 58            	sllw	x
3519  0968 1f01          	ldw	(OFST-4,sp),x
3521  096a 7b06          	ld	a,(OFST+1,sp)
3522  096c cd012b        	call	_getSn_TX_FSR
3524  096f 1301          	cpw	x,(OFST-4,sp)
3525  0971 2626          	jrne	L7131
3526                     ; 402                     close(sn);
3528  0973 7b06          	ld	a,(OFST+1,sp)
3529  0975 cd064a        	call	_close
3531                     ; 403                     return SOCKERR_SOCKSTATUS;
3533  0978 aefff9        	ldw	x,#65529
3534  097b bf02          	ldw	c_lreg+2,x
3535  097d aeffff        	ldw	x,#-1
3536  0980 bf00          	ldw	c_lreg,x
3538  0982 acd308d3      	jpf	L651
3539  0986               L1231:
3540                     ; 408                 close(sn);
3542  0986 7b06          	ld	a,(OFST+1,sp)
3543  0988 cd064a        	call	_close
3545                     ; 409                 return SOCKERR_SOCKSTATUS;
3547  098b aefff9        	ldw	x,#65529
3548  098e bf02          	ldw	c_lreg+2,x
3549  0990 aeffff        	ldw	x,#-1
3550  0993 bf00          	ldw	c_lreg,x
3552  0995 acd308d3      	jpf	L651
3553  0999               L7131:
3554                     ; 412         if ((sock_io_mode & (1 << sn)) && (recvsize == 0)){
3556  0999 ae0001        	ldw	x,#1
3557  099c 7b06          	ld	a,(OFST+1,sp)
3558  099e 4d            	tnz	a
3559  099f 2704          	jreq	L251
3560  09a1               L451:
3561  09a1 58            	sllw	x
3562  09a2 4a            	dec	a
3563  09a3 26fc          	jrne	L451
3564  09a5               L251:
3565  09a5 01            	rrwa	x,a
3566  09a6 b41d          	and	a,L52_sock_io_mode+1
3567  09a8 01            	rrwa	x,a
3568  09a9 b41c          	and	a,L52_sock_io_mode
3569  09ab 01            	rrwa	x,a
3570  09ac a30000        	cpw	x,#0
3571  09af 2712          	jreq	L3331
3573  09b1 1e04          	ldw	x,(OFST-1,sp)
3574  09b3 260e          	jrne	L3331
3575                     ; 413             return SOCK_BUSY;
3577  09b5 ae0000        	ldw	x,#0
3578  09b8 bf02          	ldw	c_lreg+2,x
3579  09ba ae0000        	ldw	x,#0
3580  09bd bf00          	ldw	c_lreg,x
3582  09bf acd308d3      	jpf	L651
3583  09c3               L3331:
3584                     ; 415         if(recvsize != 0) break;
3586  09c3 1e04          	ldw	x,(OFST-1,sp)
3587  09c5 2603          	jrne	L261
3588  09c7 cc0912        	jp	L3131
3589  09ca               L261:
3591  09ca               L5131:
3592                     ; 417     if(recvsize < len) len = recvsize;
3595  09ca 1e04          	ldw	x,(OFST-1,sp)
3596  09cc 130b          	cpw	x,(OFST+6,sp)
3597  09ce 2404          	jruge	L7331
3600  09d0 1e04          	ldw	x,(OFST-1,sp)
3601  09d2 1f0b          	ldw	(OFST+6,sp),x
3602  09d4               L7331:
3603                     ; 418     wiz_recv_data(sn, buf, len);
3605  09d4 1e0b          	ldw	x,(OFST+6,sp)
3606  09d6 89            	pushw	x
3607  09d7 1e0b          	ldw	x,(OFST+6,sp)
3608  09d9 89            	pushw	x
3609  09da 7b0a          	ld	a,(OFST+5,sp)
3610  09dc cd07c4        	call	_wiz_recv_data
3612  09df 5b04          	addw	sp,#4
3613                     ; 419     setSn_CR(sn,Sn_CR_RECV);
3615  09e1 4b40          	push	#64
3616  09e3 7b07          	ld	a,(OFST+2,sp)
3617  09e5 97            	ld	xl,a
3618  09e6 a604          	ld	a,#4
3619  09e8 42            	mul	x,a
3620  09e9 58            	sllw	x
3621  09ea 58            	sllw	x
3622  09eb 58            	sllw	x
3623  09ec 1c0108        	addw	x,#264
3624  09ef cd0000        	call	c_itolx
3626  09f2 be02          	ldw	x,c_lreg+2
3627  09f4 89            	pushw	x
3628  09f5 be00          	ldw	x,c_lreg
3629  09f7 89            	pushw	x
3630  09f8 cd0060        	call	_WIZCHIP_WRITE
3632  09fb 5b05          	addw	sp,#5
3634  09fd               L3431:
3635                     ; 420     while(getSn_CR(sn));
3637  09fd 7b06          	ld	a,(OFST+1,sp)
3638  09ff 97            	ld	xl,a
3639  0a00 a604          	ld	a,#4
3640  0a02 42            	mul	x,a
3641  0a03 58            	sllw	x
3642  0a04 58            	sllw	x
3643  0a05 58            	sllw	x
3644  0a06 1c0108        	addw	x,#264
3645  0a09 cd0000        	call	c_itolx
3647  0a0c be02          	ldw	x,c_lreg+2
3648  0a0e 89            	pushw	x
3649  0a0f be00          	ldw	x,c_lreg
3650  0a11 89            	pushw	x
3651  0a12 cd000b        	call	_WIZCHIP_READ
3653  0a15 5b04          	addw	sp,#4
3654  0a17 4d            	tnz	a
3655  0a18 26e3          	jrne	L3431
3656                     ; 421 }
3658  0a1a acd308d3      	jpf	L651
3736                     ; 423 int32_t send(uint8_t sn, uint8_t * buf, uint16_t len){
3737                     	switch	.text
3738  0a1e               _send:
3740  0a1e 88            	push	a
3741  0a1f 5203          	subw	sp,#3
3742       00000003      OFST:	set	3
3745                     ; 424     uint8_t tmp = 0;
3747                     ; 425     uint16_t freesize = 0;
3749                     ; 427     CHECK_SOCKNUM();
3751  0a21 7b04          	ld	a,(OFST+1,sp)
3752  0a23 a108          	cp	a,#8
3753  0a25 250c          	jrult	L3141
3756  0a27 aeffff        	ldw	x,#65535
3757  0a2a bf02          	ldw	c_lreg+2,x
3758  0a2c aeffff        	ldw	x,#-1
3759  0a2f bf00          	ldw	c_lreg,x
3761  0a31 202a          	jra	L202
3762  0a33               L3141:
3763                     ; 428     CHECK_SOCKMODE(Sn_MR_TCP);
3765  0a33 7b04          	ld	a,(OFST+1,sp)
3766  0a35 97            	ld	xl,a
3767  0a36 a604          	ld	a,#4
3768  0a38 42            	mul	x,a
3769  0a39 58            	sllw	x
3770  0a3a 58            	sllw	x
3771  0a3b 58            	sllw	x
3772  0a3c 1c0008        	addw	x,#8
3773  0a3f cd0000        	call	c_itolx
3775  0a42 be02          	ldw	x,c_lreg+2
3776  0a44 89            	pushw	x
3777  0a45 be00          	ldw	x,c_lreg
3778  0a47 89            	pushw	x
3779  0a48 cd000b        	call	_WIZCHIP_READ
3781  0a4b 5b04          	addw	sp,#4
3782  0a4d a40f          	and	a,#15
3783  0a4f a101          	cp	a,#1
3784  0a51 270d          	jreq	L1241
3787  0a53 aefffb        	ldw	x,#65531
3788  0a56 bf02          	ldw	c_lreg+2,x
3789  0a58 aeffff        	ldw	x,#-1
3790  0a5b bf00          	ldw	c_lreg,x
3792  0a5d               L202:
3794  0a5d 5b04          	addw	sp,#4
3795  0a5f 81            	ret
3796  0a60               L1241:
3797                     ; 429     CHECK_SOCKDATA();
3799  0a60 1e09          	ldw	x,(OFST+6,sp)
3800  0a62 260c          	jrne	L5241
3803  0a64 aefff2        	ldw	x,#65522
3804  0a67 bf02          	ldw	c_lreg+2,x
3805  0a69 aeffff        	ldw	x,#-1
3806  0a6c bf00          	ldw	c_lreg,x
3808  0a6e 20ed          	jra	L202
3809  0a70               L5241:
3810                     ; 430     tmp = getSn_SR(sn);
3813  0a70 7b04          	ld	a,(OFST+1,sp)
3814  0a72 97            	ld	xl,a
3815  0a73 a604          	ld	a,#4
3816  0a75 42            	mul	x,a
3817  0a76 58            	sllw	x
3818  0a77 58            	sllw	x
3819  0a78 58            	sllw	x
3820  0a79 1c0308        	addw	x,#776
3821  0a7c cd0000        	call	c_itolx
3823  0a7f be02          	ldw	x,c_lreg+2
3824  0a81 89            	pushw	x
3825  0a82 be00          	ldw	x,c_lreg
3826  0a84 89            	pushw	x
3827  0a85 cd000b        	call	_WIZCHIP_READ
3829  0a88 5b04          	addw	sp,#4
3830  0a8a 6b03          	ld	(OFST+0,sp),a
3832                     ; 431     if(tmp != SOCK_ESTABLISHED && tmp != SOCK_CLOSE_WAIT) return SOCKERR_SOCKSTATUS;
3834  0a8c 7b03          	ld	a,(OFST+0,sp)
3835  0a8e a117          	cp	a,#23
3836  0a90 2712          	jreq	L7241
3838  0a92 7b03          	ld	a,(OFST+0,sp)
3839  0a94 a11c          	cp	a,#28
3840  0a96 270c          	jreq	L7241
3843  0a98 aefff9        	ldw	x,#65529
3844  0a9b bf02          	ldw	c_lreg+2,x
3845  0a9d aeffff        	ldw	x,#-1
3846  0aa0 bf00          	ldw	c_lreg,x
3848  0aa2 20b9          	jra	L202
3849  0aa4               L7241:
3850                     ; 432     if(sock_is_sending & (1<<sn)){
3852  0aa4 ae0001        	ldw	x,#1
3853  0aa7 7b04          	ld	a,(OFST+1,sp)
3854  0aa9 4d            	tnz	a
3855  0aaa 2704          	jreq	L661
3856  0aac               L071:
3857  0aac 58            	sllw	x
3858  0aad 4a            	dec	a
3859  0aae 26fc          	jrne	L071
3860  0ab0               L661:
3861  0ab0 01            	rrwa	x,a
3862  0ab1 b41b          	and	a,L32_sock_is_sending+1
3863  0ab3 01            	rrwa	x,a
3864  0ab4 b41a          	and	a,L32_sock_is_sending
3865  0ab6 01            	rrwa	x,a
3866  0ab7 a30000        	cpw	x,#0
3867  0aba 2603          	jrne	L402
3868  0abc cc0b3e        	jp	L1341
3869  0abf               L402:
3870                     ; 433         tmp = getSn_IR(sn);
3872  0abf 7b04          	ld	a,(OFST+1,sp)
3873  0ac1 97            	ld	xl,a
3874  0ac2 a604          	ld	a,#4
3875  0ac4 42            	mul	x,a
3876  0ac5 58            	sllw	x
3877  0ac6 58            	sllw	x
3878  0ac7 58            	sllw	x
3879  0ac8 1c0208        	addw	x,#520
3880  0acb cd0000        	call	c_itolx
3882  0ace be02          	ldw	x,c_lreg+2
3883  0ad0 89            	pushw	x
3884  0ad1 be00          	ldw	x,c_lreg
3885  0ad3 89            	pushw	x
3886  0ad4 cd000b        	call	_WIZCHIP_READ
3888  0ad7 5b04          	addw	sp,#4
3889  0ad9 a41f          	and	a,#31
3890  0adb 6b03          	ld	(OFST+0,sp),a
3892                     ; 434         if(tmp & Sn_IR_SENDOK){
3894  0add 7b03          	ld	a,(OFST+0,sp)
3895  0adf a510          	bcp	a,#16
3896  0ae1 2734          	jreq	L3341
3897                     ; 435             setSn_IR(sn, Sn_IR_SENDOK);
3899  0ae3 4b10          	push	#16
3900  0ae5 7b05          	ld	a,(OFST+2,sp)
3901  0ae7 97            	ld	xl,a
3902  0ae8 a604          	ld	a,#4
3903  0aea 42            	mul	x,a
3904  0aeb 58            	sllw	x
3905  0aec 58            	sllw	x
3906  0aed 58            	sllw	x
3907  0aee 1c0208        	addw	x,#520
3908  0af1 cd0000        	call	c_itolx
3910  0af4 be02          	ldw	x,c_lreg+2
3911  0af6 89            	pushw	x
3912  0af7 be00          	ldw	x,c_lreg
3913  0af9 89            	pushw	x
3914  0afa cd0060        	call	_WIZCHIP_WRITE
3916  0afd 5b05          	addw	sp,#5
3917                     ; 436             sock_is_sending &= ~(1<<sn);
3919  0aff ae0001        	ldw	x,#1
3920  0b02 7b04          	ld	a,(OFST+1,sp)
3921  0b04 4d            	tnz	a
3922  0b05 2704          	jreq	L271
3923  0b07               L471:
3924  0b07 58            	sllw	x
3925  0b08 4a            	dec	a
3926  0b09 26fc          	jrne	L471
3927  0b0b               L271:
3928  0b0b 53            	cplw	x
3929  0b0c 01            	rrwa	x,a
3930  0b0d b41b          	and	a,L32_sock_is_sending+1
3931  0b0f 01            	rrwa	x,a
3932  0b10 b41a          	and	a,L32_sock_is_sending
3933  0b12 01            	rrwa	x,a
3934  0b13 bf1a          	ldw	L32_sock_is_sending,x
3936  0b15 2027          	jra	L1341
3937  0b17               L3341:
3938                     ; 438         else if(tmp & Sn_IR_TIMEOUT)
3940  0b17 7b03          	ld	a,(OFST+0,sp)
3941  0b19 a508          	bcp	a,#8
3942  0b1b 2713          	jreq	L7341
3943                     ; 440             close(sn);
3945  0b1d 7b04          	ld	a,(OFST+1,sp)
3946  0b1f cd064a        	call	_close
3948                     ; 441             return SOCKERR_TIMEOUT;
3950  0b22 aefff3        	ldw	x,#65523
3951  0b25 bf02          	ldw	c_lreg+2,x
3952  0b27 aeffff        	ldw	x,#-1
3953  0b2a bf00          	ldw	c_lreg,x
3955  0b2c ac5d0a5d      	jpf	L202
3956  0b30               L7341:
3957                     ; 443         else return SOCK_BUSY;
3959  0b30 ae0000        	ldw	x,#0
3960  0b33 bf02          	ldw	c_lreg+2,x
3961  0b35 ae0000        	ldw	x,#0
3962  0b38 bf00          	ldw	c_lreg,x
3964  0b3a ac5d0a5d      	jpf	L202
3965  0b3e               L1341:
3966                     ; 445     freesize = getSn_TxMAX(sn);
3968  0b3e 7b04          	ld	a,(OFST+1,sp)
3969  0b40 97            	ld	xl,a
3970  0b41 a604          	ld	a,#4
3971  0b43 42            	mul	x,a
3972  0b44 58            	sllw	x
3973  0b45 58            	sllw	x
3974  0b46 58            	sllw	x
3975  0b47 1c1f08        	addw	x,#7944
3976  0b4a cd0000        	call	c_itolx
3978  0b4d be02          	ldw	x,c_lreg+2
3979  0b4f 89            	pushw	x
3980  0b50 be00          	ldw	x,c_lreg
3981  0b52 89            	pushw	x
3982  0b53 cd000b        	call	_WIZCHIP_READ
3984  0b56 5b04          	addw	sp,#4
3985  0b58 5f            	clrw	x
3986  0b59 97            	ld	xl,a
3987  0b5a 4f            	clr	a
3988  0b5b 02            	rlwa	x,a
3989  0b5c 58            	sllw	x
3990  0b5d 58            	sllw	x
3991  0b5e 1f01          	ldw	(OFST-2,sp),x
3993                     ; 446     if (len > freesize) len = freesize;
3995  0b60 1e09          	ldw	x,(OFST+6,sp)
3996  0b62 1301          	cpw	x,(OFST-2,sp)
3997  0b64 2304          	jrule	L5441
4000  0b66 1e01          	ldw	x,(OFST-2,sp)
4001  0b68 1f09          	ldw	(OFST+6,sp),x
4002  0b6a               L5441:
4003                     ; 448         freesize = getSn_TX_FSR(sn);
4005  0b6a 7b04          	ld	a,(OFST+1,sp)
4006  0b6c cd012b        	call	_getSn_TX_FSR
4008  0b6f 1f01          	ldw	(OFST-2,sp),x
4010                     ; 449         tmp = getSn_SR(sn);
4012  0b71 7b04          	ld	a,(OFST+1,sp)
4013  0b73 97            	ld	xl,a
4014  0b74 a604          	ld	a,#4
4015  0b76 42            	mul	x,a
4016  0b77 58            	sllw	x
4017  0b78 58            	sllw	x
4018  0b79 58            	sllw	x
4019  0b7a 1c0308        	addw	x,#776
4020  0b7d cd0000        	call	c_itolx
4022  0b80 be02          	ldw	x,c_lreg+2
4023  0b82 89            	pushw	x
4024  0b83 be00          	ldw	x,c_lreg
4025  0b85 89            	pushw	x
4026  0b86 cd000b        	call	_WIZCHIP_READ
4028  0b89 5b04          	addw	sp,#4
4029  0b8b 6b03          	ld	(OFST+0,sp),a
4031                     ; 450         if((tmp != SOCK_ESTABLISHED) && (tmp != SOCK_CLOSE_WAIT)){
4033  0b8d 7b03          	ld	a,(OFST+0,sp)
4034  0b8f a117          	cp	a,#23
4035  0b91 2719          	jreq	L1541
4037  0b93 7b03          	ld	a,(OFST+0,sp)
4038  0b95 a11c          	cp	a,#28
4039  0b97 2713          	jreq	L1541
4040                     ; 451             close(sn);
4042  0b99 7b04          	ld	a,(OFST+1,sp)
4043  0b9b cd064a        	call	_close
4045                     ; 452             return SOCKERR_SOCKSTATUS;
4047  0b9e aefff9        	ldw	x,#65529
4048  0ba1 bf02          	ldw	c_lreg+2,x
4049  0ba3 aeffff        	ldw	x,#-1
4050  0ba6 bf00          	ldw	c_lreg,x
4052  0ba8 ac5d0a5d      	jpf	L202
4053  0bac               L1541:
4054                     ; 454         if((sock_io_mode & (1<<sn)) && (len > freesize)) return SOCK_BUSY;
4056  0bac ae0001        	ldw	x,#1
4057  0baf 7b04          	ld	a,(OFST+1,sp)
4058  0bb1 4d            	tnz	a
4059  0bb2 2704          	jreq	L671
4060  0bb4               L002:
4061  0bb4 58            	sllw	x
4062  0bb5 4a            	dec	a
4063  0bb6 26fc          	jrne	L002
4064  0bb8               L671:
4065  0bb8 01            	rrwa	x,a
4066  0bb9 b41d          	and	a,L52_sock_io_mode+1
4067  0bbb 01            	rrwa	x,a
4068  0bbc b41c          	and	a,L52_sock_io_mode
4069  0bbe 01            	rrwa	x,a
4070  0bbf a30000        	cpw	x,#0
4071  0bc2 2714          	jreq	L3541
4073  0bc4 1e09          	ldw	x,(OFST+6,sp)
4074  0bc6 1301          	cpw	x,(OFST-2,sp)
4075  0bc8 230e          	jrule	L3541
4078  0bca ae0000        	ldw	x,#0
4079  0bcd bf02          	ldw	c_lreg+2,x
4080  0bcf ae0000        	ldw	x,#0
4081  0bd2 bf00          	ldw	c_lreg,x
4083  0bd4 ac5d0a5d      	jpf	L202
4084  0bd8               L3541:
4085                     ; 455         if(len <= freesize) break;
4087  0bd8 1e09          	ldw	x,(OFST+6,sp)
4088  0bda 1301          	cpw	x,(OFST-2,sp)
4089  0bdc 228c          	jrugt	L5441
4091                     ; 457     wiz_send_data(sn, buf, len);
4093  0bde 1e09          	ldw	x,(OFST+6,sp)
4094  0be0 89            	pushw	x
4095  0be1 1e09          	ldw	x,(OFST+6,sp)
4096  0be3 89            	pushw	x
4097  0be4 7b08          	ld	a,(OFST+5,sp)
4098  0be6 cd02ef        	call	_wiz_send_data
4100  0be9 5b04          	addw	sp,#4
4101                     ; 458     setSn_CR(sn,Sn_CR_SEND);
4103  0beb 4b20          	push	#32
4104  0bed 7b05          	ld	a,(OFST+2,sp)
4105  0bef 97            	ld	xl,a
4106  0bf0 a604          	ld	a,#4
4107  0bf2 42            	mul	x,a
4108  0bf3 58            	sllw	x
4109  0bf4 58            	sllw	x
4110  0bf5 58            	sllw	x
4111  0bf6 1c0108        	addw	x,#264
4112  0bf9 cd0000        	call	c_itolx
4114  0bfc be02          	ldw	x,c_lreg+2
4115  0bfe 89            	pushw	x
4116  0bff be00          	ldw	x,c_lreg
4117  0c01 89            	pushw	x
4118  0c02 cd0060        	call	_WIZCHIP_WRITE
4120  0c05 5b05          	addw	sp,#5
4122  0c07               L1641:
4123                     ; 459     while(getSn_CR(sn));
4125  0c07 7b04          	ld	a,(OFST+1,sp)
4126  0c09 97            	ld	xl,a
4127  0c0a a604          	ld	a,#4
4128  0c0c 42            	mul	x,a
4129  0c0d 58            	sllw	x
4130  0c0e 58            	sllw	x
4131  0c0f 58            	sllw	x
4132  0c10 1c0108        	addw	x,#264
4133  0c13 cd0000        	call	c_itolx
4135  0c16 be02          	ldw	x,c_lreg+2
4136  0c18 89            	pushw	x
4137  0c19 be00          	ldw	x,c_lreg
4138  0c1b 89            	pushw	x
4139  0c1c cd000b        	call	_WIZCHIP_READ
4141  0c1f 5b04          	addw	sp,#4
4142  0c21 4d            	tnz	a
4143  0c22 26e3          	jrne	L1641
4144                     ; 460     return (int32_t)len;
4146  0c24 1e09          	ldw	x,(OFST+6,sp)
4147  0c26 cd0000        	call	c_uitolx
4150  0c29 ac5d0a5d      	jpf	L202
4393                     	xdef	_sock_pack_info
4394                     	xdef	_send
4395                     	xdef	_recv
4396                     	xdef	_listen
4397                     	xdef	_close
4398                     	xdef	_socket
4399                     	xdef	_wizchip_init
4400                     	xdef	_wiz_recv_data
4401                     	xdef	_wiz_send_data
4402                     	xdef	_reg_wizchip_spiburst_cbfunc
4403                     	xdef	_reg_wizchip_spi_cbfunc
4404                     	xdef	_WIZCHIP_WRITE_BUF
4405                     	xdef	_getSn_RX_RSR
4406                     	xdef	_getSn_TX_FSR
4407                     	xdef	_reg_wizchip_cs_cbfunc
4408                     	xdef	_WIZCHIP_READ_BUF
4409                     	xdef	_WIZCHIP_READ
4410                     	xdef	_WIZCHIP_WRITE
4411                     	xdef	_WIZCHIP
4412                     	xref.b	c_lreg
4413                     	xref.b	c_x
4414                     	xref.b	c_y
4433                     	xref	c_uitolx
4434                     	xref	c_lzmp
4435                     	xref	c_ladd
4436                     	xref	c_rtol
4437                     	xref	c_umul
4438                     	xref	c_itolx
4439                     	end
