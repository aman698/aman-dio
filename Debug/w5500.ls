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
2521                     ; 321             if(taddr == 0) 
2523  0575 96            	ldw	x,sp
2524  0576 1c0001        	addw	x,#OFST-3
2525  0579 cd0000        	call	c_lzmp
2527  057c 2609          	jrne	L3601
2528                     ; 322                 return SOCKERR_SOCKINIT;
2530  057e a6fd          	ld	a,#253
2532  0580               L421:
2534  0580 5b06          	addw	sp,#6
2535  0582 81            	ret
2536  0583               L7001:
2537                     ; 325         default :
2537                     ; 326             return SOCKERR_SOCKMODE;
2539  0583 a6fb          	ld	a,#251
2541  0585 20f9          	jra	L421
2542  0587               L3601:
2543                     ; 328     if((flag & 0x04) != 0) return SOCKERR_SOCKFLAG;
2545  0587 7b0b          	ld	a,(OFST+7,sp)
2546  0589 a504          	bcp	a,#4
2547  058b 2704          	jreq	L1701
2550  058d a6fa          	ld	a,#250
2552  058f 20ef          	jra	L421
2553  0591               L1701:
2554                     ; 329     if(flag != 0){
2556  0591 0d0b          	tnz	(OFST+7,sp)
2557  0593 2710          	jreq	L3701
2558                     ; 330         switch(protocol){
2560  0595 7b06          	ld	a,(OFST+2,sp)
2561  0597 a101          	cp	a,#1
2562  0599 260a          	jrne	L3701
2565  059b               L1101:
2566                     ; 331             case Sn_MR_TCP:
2566                     ; 332                  if((flag & (SF_TCP_NODELAY|SF_IO_NONBLOCK))==0) return SOCKERR_SOCKFLAG;
2568  059b 7b0b          	ld	a,(OFST+7,sp)
2569  059d a521          	bcp	a,#33
2570  059f 2604          	jrne	L3701
2573  05a1 a6fa          	ld	a,#250
2575  05a3 20db          	jra	L421
2576  05a5               L3101:
2577                     ; 334             default:
2577                     ; 335                break;
2579  05a5               L3701:
2580                     ; 338     close(sn);
2582  05a5 7b05          	ld	a,(OFST+1,sp)
2583  05a7 cd06ba        	call	_close
2585                     ; 339     setSn_MR(sn, (protocol | (flag & 0xF0)));
2587  05aa 7b0b          	ld	a,(OFST+7,sp)
2588  05ac a4f0          	and	a,#240
2589  05ae 1a06          	or	a,(OFST+2,sp)
2590  05b0 88            	push	a
2591  05b1 7b06          	ld	a,(OFST+2,sp)
2592  05b3 97            	ld	xl,a
2593  05b4 a604          	ld	a,#4
2594  05b6 42            	mul	x,a
2595  05b7 58            	sllw	x
2596  05b8 58            	sllw	x
2597  05b9 58            	sllw	x
2598  05ba 1c0008        	addw	x,#8
2599  05bd cd0000        	call	c_itolx
2601  05c0 be02          	ldw	x,c_lreg+2
2602  05c2 89            	pushw	x
2603  05c3 be00          	ldw	x,c_lreg
2604  05c5 89            	pushw	x
2605  05c6 cd0060        	call	_WIZCHIP_WRITE
2607  05c9 5b05          	addw	sp,#5
2608                     ; 340     if(!port)
2610  05cb 1e09          	ldw	x,(OFST+5,sp)
2611  05cd 2618          	jrne	L3011
2612                     ; 342         port = sock_any_port++;
2614  05cf be00          	ldw	x,L3_sock_any_port
2615  05d1 1c0001        	addw	x,#1
2616  05d4 bf00          	ldw	L3_sock_any_port,x
2617  05d6 1d0001        	subw	x,#1
2618  05d9 1f09          	ldw	(OFST+5,sp),x
2619                     ; 343         if(sock_any_port == 0xFFF0) sock_any_port = SOCK_ANY_PORT_NUM;
2621  05db be00          	ldw	x,L3_sock_any_port
2622  05dd a3fff0        	cpw	x,#65520
2623  05e0 2605          	jrne	L3011
2626  05e2 aec000        	ldw	x,#49152
2627  05e5 bf00          	ldw	L3_sock_any_port,x
2628  05e7               L3011:
2629                     ; 345     setSn_PORT(sn,port);
2631  05e7 7b09          	ld	a,(OFST+5,sp)
2632  05e9 88            	push	a
2633  05ea 7b06          	ld	a,(OFST+2,sp)
2634  05ec 97            	ld	xl,a
2635  05ed a604          	ld	a,#4
2636  05ef 42            	mul	x,a
2637  05f0 58            	sllw	x
2638  05f1 58            	sllw	x
2639  05f2 58            	sllw	x
2640  05f3 1c0408        	addw	x,#1032
2641  05f6 cd0000        	call	c_itolx
2643  05f9 be02          	ldw	x,c_lreg+2
2644  05fb 89            	pushw	x
2645  05fc be00          	ldw	x,c_lreg
2646  05fe 89            	pushw	x
2647  05ff cd0060        	call	_WIZCHIP_WRITE
2649  0602 5b05          	addw	sp,#5
2652  0604 7b0a          	ld	a,(OFST+6,sp)
2653  0606 88            	push	a
2654  0607 7b06          	ld	a,(OFST+2,sp)
2655  0609 97            	ld	xl,a
2656  060a a604          	ld	a,#4
2657  060c 42            	mul	x,a
2658  060d 58            	sllw	x
2659  060e 58            	sllw	x
2660  060f 58            	sllw	x
2661  0610 1c0508        	addw	x,#1288
2662  0613 cd0000        	call	c_itolx
2664  0616 be02          	ldw	x,c_lreg+2
2665  0618 89            	pushw	x
2666  0619 be00          	ldw	x,c_lreg
2667  061b 89            	pushw	x
2668  061c cd0060        	call	_WIZCHIP_WRITE
2670  061f 5b05          	addw	sp,#5
2671                     ; 346     setSn_CR(sn,Sn_CR_OPEN);
2674  0621 4b01          	push	#1
2675  0623 7b06          	ld	a,(OFST+2,sp)
2676  0625 97            	ld	xl,a
2677  0626 a604          	ld	a,#4
2678  0628 42            	mul	x,a
2679  0629 58            	sllw	x
2680  062a 58            	sllw	x
2681  062b 58            	sllw	x
2682  062c 1c0108        	addw	x,#264
2683  062f cd0000        	call	c_itolx
2685  0632 be02          	ldw	x,c_lreg+2
2686  0634 89            	pushw	x
2687  0635 be00          	ldw	x,c_lreg
2688  0637 89            	pushw	x
2689  0638 cd0060        	call	_WIZCHIP_WRITE
2691  063b 5b05          	addw	sp,#5
2693  063d               L1111:
2694                     ; 347     while(getSn_CR(sn));
2696  063d 7b05          	ld	a,(OFST+1,sp)
2697  063f 97            	ld	xl,a
2698  0640 a604          	ld	a,#4
2699  0642 42            	mul	x,a
2700  0643 58            	sllw	x
2701  0644 58            	sllw	x
2702  0645 58            	sllw	x
2703  0646 1c0108        	addw	x,#264
2704  0649 cd0000        	call	c_itolx
2706  064c be02          	ldw	x,c_lreg+2
2707  064e 89            	pushw	x
2708  064f be00          	ldw	x,c_lreg
2709  0651 89            	pushw	x
2710  0652 cd000b        	call	_WIZCHIP_READ
2712  0655 5b04          	addw	sp,#4
2713  0657 4d            	tnz	a
2714  0658 26e3          	jrne	L1111
2715                     ; 348     sock_io_mode &= ~(1 << sn);
2717  065a ae0001        	ldw	x,#1
2718  065d 7b05          	ld	a,(OFST+1,sp)
2719  065f 4d            	tnz	a
2720  0660 2704          	jreq	L411
2721  0662               L611:
2722  0662 58            	sllw	x
2723  0663 4a            	dec	a
2724  0664 26fc          	jrne	L611
2725  0666               L411:
2726  0666 53            	cplw	x
2727  0667 01            	rrwa	x,a
2728  0668 b41d          	and	a,L52_sock_io_mode+1
2729  066a 01            	rrwa	x,a
2730  066b b41c          	and	a,L52_sock_io_mode
2731  066d 01            	rrwa	x,a
2732  066e bf1c          	ldw	L52_sock_io_mode,x
2733                     ; 349     sock_io_mode |= ((flag & SF_IO_NONBLOCK) << sn);
2735  0670 7b0b          	ld	a,(OFST+7,sp)
2736  0672 a401          	and	a,#1
2737  0674 5f            	clrw	x
2738  0675 97            	ld	xl,a
2739  0676 7b05          	ld	a,(OFST+1,sp)
2740  0678 4d            	tnz	a
2741  0679 2704          	jreq	L021
2742  067b               L221:
2743  067b 58            	sllw	x
2744  067c 4a            	dec	a
2745  067d 26fc          	jrne	L221
2746  067f               L021:
2747  067f 01            	rrwa	x,a
2748  0680 ba1d          	or	a,L52_sock_io_mode+1
2749  0682 01            	rrwa	x,a
2750  0683 ba1c          	or	a,L52_sock_io_mode
2751  0685 01            	rrwa	x,a
2752  0686 bf1c          	ldw	L52_sock_io_mode,x
2753                     ; 350     sock_remained_size[sn] = 0;
2755  0688 7b05          	ld	a,(OFST+1,sp)
2756  068a 5f            	clrw	x
2757  068b 97            	ld	xl,a
2758  068c 58            	sllw	x
2759  068d 905f          	clrw	y
2760  068f ef02          	ldw	(L12_sock_remained_size,x),y
2761                     ; 351     sock_pack_info[sn] = PACK_COMPLETED;
2763  0691 7b05          	ld	a,(OFST+1,sp)
2764  0693 5f            	clrw	x
2765  0694 97            	ld	xl,a
2766  0695 6f12          	clr	(_sock_pack_info,x)
2768  0697               L1211:
2769                     ; 352     while(getSn_SR(sn) == SOCK_CLOSED);
2771  0697 7b05          	ld	a,(OFST+1,sp)
2772  0699 97            	ld	xl,a
2773  069a a604          	ld	a,#4
2774  069c 42            	mul	x,a
2775  069d 58            	sllw	x
2776  069e 58            	sllw	x
2777  069f 58            	sllw	x
2778  06a0 1c0308        	addw	x,#776
2779  06a3 cd0000        	call	c_itolx
2781  06a6 be02          	ldw	x,c_lreg+2
2782  06a8 89            	pushw	x
2783  06a9 be00          	ldw	x,c_lreg
2784  06ab 89            	pushw	x
2785  06ac cd000b        	call	_WIZCHIP_READ
2787  06af 5b04          	addw	sp,#4
2788  06b1 4d            	tnz	a
2789  06b2 27e3          	jreq	L1211
2790                     ; 353     return (int8_t)sn;
2792  06b4 7b05          	ld	a,(OFST+1,sp)
2794  06b6 ac800580      	jpf	L421
2834                     ; 355 int8_t close(uint8_t sn){
2835                     	switch	.text
2836  06ba               _close:
2838  06ba 88            	push	a
2839       00000000      OFST:	set	0
2842                     ; 356     CHECK_SOCKNUM();
2844  06bb 7b01          	ld	a,(OFST+1,sp)
2845  06bd a108          	cp	a,#8
2846  06bf 2505          	jrult	L7411
2849  06c1 a6ff          	ld	a,#255
2852  06c3 5b01          	addw	sp,#1
2853  06c5 81            	ret
2854  06c6               L7411:
2855                     ; 357     setSn_CR(sn,Sn_CR_CLOSE);
2857  06c6 4b10          	push	#16
2858  06c8 7b02          	ld	a,(OFST+2,sp)
2859  06ca 97            	ld	xl,a
2860  06cb a604          	ld	a,#4
2861  06cd 42            	mul	x,a
2862  06ce 58            	sllw	x
2863  06cf 58            	sllw	x
2864  06d0 58            	sllw	x
2865  06d1 1c0108        	addw	x,#264
2866  06d4 cd0000        	call	c_itolx
2868  06d7 be02          	ldw	x,c_lreg+2
2869  06d9 89            	pushw	x
2870  06da be00          	ldw	x,c_lreg
2871  06dc 89            	pushw	x
2872  06dd cd0060        	call	_WIZCHIP_WRITE
2874  06e0 5b05          	addw	sp,#5
2876  06e2               L3511:
2877                     ; 358     while(getSn_CR(sn));
2879  06e2 7b01          	ld	a,(OFST+1,sp)
2880  06e4 97            	ld	xl,a
2881  06e5 a604          	ld	a,#4
2882  06e7 42            	mul	x,a
2883  06e8 58            	sllw	x
2884  06e9 58            	sllw	x
2885  06ea 58            	sllw	x
2886  06eb 1c0108        	addw	x,#264
2887  06ee cd0000        	call	c_itolx
2889  06f1 be02          	ldw	x,c_lreg+2
2890  06f3 89            	pushw	x
2891  06f4 be00          	ldw	x,c_lreg
2892  06f6 89            	pushw	x
2893  06f7 cd000b        	call	_WIZCHIP_READ
2895  06fa 5b04          	addw	sp,#4
2896  06fc 4d            	tnz	a
2897  06fd 26e3          	jrne	L3511
2898                     ; 359     setSn_IR(sn, 0xFF);
2900  06ff 4b1f          	push	#31
2901  0701 7b02          	ld	a,(OFST+2,sp)
2902  0703 97            	ld	xl,a
2903  0704 a604          	ld	a,#4
2904  0706 42            	mul	x,a
2905  0707 58            	sllw	x
2906  0708 58            	sllw	x
2907  0709 58            	sllw	x
2908  070a 1c0208        	addw	x,#520
2909  070d cd0000        	call	c_itolx
2911  0710 be02          	ldw	x,c_lreg+2
2912  0712 89            	pushw	x
2913  0713 be00          	ldw	x,c_lreg
2914  0715 89            	pushw	x
2915  0716 cd0060        	call	_WIZCHIP_WRITE
2917  0719 5b05          	addw	sp,#5
2918                     ; 360     sock_io_mode &= ~(1 << sn);
2920  071b ae0001        	ldw	x,#1
2921  071e 7b01          	ld	a,(OFST+1,sp)
2922  0720 4d            	tnz	a
2923  0721 2704          	jreq	L031
2924  0723               L231:
2925  0723 58            	sllw	x
2926  0724 4a            	dec	a
2927  0725 26fc          	jrne	L231
2928  0727               L031:
2929  0727 53            	cplw	x
2930  0728 01            	rrwa	x,a
2931  0729 b41d          	and	a,L52_sock_io_mode+1
2932  072b 01            	rrwa	x,a
2933  072c b41c          	and	a,L52_sock_io_mode
2934  072e 01            	rrwa	x,a
2935  072f bf1c          	ldw	L52_sock_io_mode,x
2936                     ; 361     sock_is_sending &= ~(1 << sn);
2938  0731 ae0001        	ldw	x,#1
2939  0734 7b01          	ld	a,(OFST+1,sp)
2940  0736 4d            	tnz	a
2941  0737 2704          	jreq	L431
2942  0739               L631:
2943  0739 58            	sllw	x
2944  073a 4a            	dec	a
2945  073b 26fc          	jrne	L631
2946  073d               L431:
2947  073d 53            	cplw	x
2948  073e 01            	rrwa	x,a
2949  073f b41b          	and	a,L32_sock_is_sending+1
2950  0741 01            	rrwa	x,a
2951  0742 b41a          	and	a,L32_sock_is_sending
2952  0744 01            	rrwa	x,a
2953  0745 bf1a          	ldw	L32_sock_is_sending,x
2954                     ; 362     sock_remained_size[sn] = 0;
2956  0747 7b01          	ld	a,(OFST+1,sp)
2957  0749 5f            	clrw	x
2958  074a 97            	ld	xl,a
2959  074b 58            	sllw	x
2960  074c 905f          	clrw	y
2961  074e ef02          	ldw	(L12_sock_remained_size,x),y
2962                     ; 363     sock_pack_info[sn] = 0;
2964  0750 7b01          	ld	a,(OFST+1,sp)
2965  0752 5f            	clrw	x
2966  0753 97            	ld	xl,a
2967  0754 6f12          	clr	(_sock_pack_info,x)
2969  0756               L3611:
2970                     ; 364     while(getSn_SR(sn) != SOCK_CLOSED);
2972  0756 7b01          	ld	a,(OFST+1,sp)
2973  0758 97            	ld	xl,a
2974  0759 a604          	ld	a,#4
2975  075b 42            	mul	x,a
2976  075c 58            	sllw	x
2977  075d 58            	sllw	x
2978  075e 58            	sllw	x
2979  075f 1c0308        	addw	x,#776
2980  0762 cd0000        	call	c_itolx
2982  0765 be02          	ldw	x,c_lreg+2
2983  0767 89            	pushw	x
2984  0768 be00          	ldw	x,c_lreg
2985  076a 89            	pushw	x
2986  076b cd000b        	call	_WIZCHIP_READ
2988  076e 5b04          	addw	sp,#4
2989  0770 4d            	tnz	a
2990  0771 26e3          	jrne	L3611
2991                     ; 365 	return SOCK_OK;
2993  0773 a601          	ld	a,#1
2996  0775 5b01          	addw	sp,#1
2997  0777 81            	ret
3034                     ; 367 int8_t listen(uint8_t sn){
3035                     	switch	.text
3036  0778               _listen:
3038  0778 88            	push	a
3039       00000000      OFST:	set	0
3042                     ; 368     CHECK_SOCKNUM();
3044  0779 7b01          	ld	a,(OFST+1,sp)
3045  077b a108          	cp	a,#8
3046  077d 2505          	jrult	L3121
3049  077f a6ff          	ld	a,#255
3052  0781 5b01          	addw	sp,#1
3053  0783 81            	ret
3054  0784               L3121:
3055                     ; 369     CHECK_SOCKMODE(Sn_MR_TCP);
3057  0784 7b01          	ld	a,(OFST+1,sp)
3058  0786 97            	ld	xl,a
3059  0787 a604          	ld	a,#4
3060  0789 42            	mul	x,a
3061  078a 58            	sllw	x
3062  078b 58            	sllw	x
3063  078c 58            	sllw	x
3064  078d 1c0008        	addw	x,#8
3065  0790 cd0000        	call	c_itolx
3067  0793 be02          	ldw	x,c_lreg+2
3068  0795 89            	pushw	x
3069  0796 be00          	ldw	x,c_lreg
3070  0798 89            	pushw	x
3071  0799 cd000b        	call	_WIZCHIP_READ
3073  079c 5b04          	addw	sp,#4
3074  079e a40f          	and	a,#15
3075  07a0 a101          	cp	a,#1
3076  07a2 2705          	jreq	L1221
3079  07a4 a6fb          	ld	a,#251
3082  07a6 5b01          	addw	sp,#1
3083  07a8 81            	ret
3084  07a9               L1221:
3085                     ; 370     CHECK_SOCKINIT();
3087  07a9 7b01          	ld	a,(OFST+1,sp)
3088  07ab 97            	ld	xl,a
3089  07ac a604          	ld	a,#4
3090  07ae 42            	mul	x,a
3091  07af 58            	sllw	x
3092  07b0 58            	sllw	x
3093  07b1 58            	sllw	x
3094  07b2 1c0308        	addw	x,#776
3095  07b5 cd0000        	call	c_itolx
3097  07b8 be02          	ldw	x,c_lreg+2
3098  07ba 89            	pushw	x
3099  07bb be00          	ldw	x,c_lreg
3100  07bd 89            	pushw	x
3101  07be cd000b        	call	_WIZCHIP_READ
3103  07c1 5b04          	addw	sp,#4
3104  07c3 a113          	cp	a,#19
3105  07c5 2705          	jreq	L5221
3108  07c7 a6fd          	ld	a,#253
3111  07c9 5b01          	addw	sp,#1
3112  07cb 81            	ret
3113  07cc               L5221:
3114                     ; 371     setSn_CR(sn,Sn_CR_LISTEN);
3116  07cc 4b02          	push	#2
3117  07ce 7b02          	ld	a,(OFST+2,sp)
3118  07d0 97            	ld	xl,a
3119  07d1 a604          	ld	a,#4
3120  07d3 42            	mul	x,a
3121  07d4 58            	sllw	x
3122  07d5 58            	sllw	x
3123  07d6 58            	sllw	x
3124  07d7 1c0108        	addw	x,#264
3125  07da cd0000        	call	c_itolx
3127  07dd be02          	ldw	x,c_lreg+2
3128  07df 89            	pushw	x
3129  07e0 be00          	ldw	x,c_lreg
3130  07e2 89            	pushw	x
3131  07e3 cd0060        	call	_WIZCHIP_WRITE
3133  07e6 5b05          	addw	sp,#5
3135  07e8               L1321:
3136                     ; 372     while(getSn_CR(sn));
3138  07e8 7b01          	ld	a,(OFST+1,sp)
3139  07ea 97            	ld	xl,a
3140  07eb a604          	ld	a,#4
3141  07ed 42            	mul	x,a
3142  07ee 58            	sllw	x
3143  07ef 58            	sllw	x
3144  07f0 58            	sllw	x
3145  07f1 1c0108        	addw	x,#264
3146  07f4 cd0000        	call	c_itolx
3148  07f7 be02          	ldw	x,c_lreg+2
3149  07f9 89            	pushw	x
3150  07fa be00          	ldw	x,c_lreg
3151  07fc 89            	pushw	x
3152  07fd cd000b        	call	_WIZCHIP_READ
3154  0800 5b04          	addw	sp,#4
3155  0802 4d            	tnz	a
3156  0803 26e3          	jrne	L1321
3158  0805 200a          	jra	L7321
3159  0807               L5321:
3160                     ; 375         close(sn);
3162  0807 7b01          	ld	a,(OFST+1,sp)
3163  0809 cd06ba        	call	_close
3165                     ; 376         return SOCKERR_SOCKCLOSED;
3167  080c a6fc          	ld	a,#252
3170  080e 5b01          	addw	sp,#1
3171  0810 81            	ret
3172  0811               L7321:
3173                     ; 373     while(getSn_SR(sn) != SOCK_LISTEN)
3175  0811 7b01          	ld	a,(OFST+1,sp)
3176  0813 97            	ld	xl,a
3177  0814 a604          	ld	a,#4
3178  0816 42            	mul	x,a
3179  0817 58            	sllw	x
3180  0818 58            	sllw	x
3181  0819 58            	sllw	x
3182  081a 1c0308        	addw	x,#776
3183  081d cd0000        	call	c_itolx
3185  0820 be02          	ldw	x,c_lreg+2
3186  0822 89            	pushw	x
3187  0823 be00          	ldw	x,c_lreg
3188  0825 89            	pushw	x
3189  0826 cd000b        	call	_WIZCHIP_READ
3191  0829 5b04          	addw	sp,#4
3192  082b a114          	cp	a,#20
3193  082d 26d8          	jrne	L5321
3194                     ; 378     return SOCK_OK;
3196  082f a601          	ld	a,#1
3199  0831 5b01          	addw	sp,#1
3200  0833 81            	ret
3274                     ; 380 void wiz_recv_data(uint8_t sn, uint8_t *wizdata, uint16_t len)
3274                     ; 381 {
3275                     	switch	.text
3276  0834               _wiz_recv_data:
3278  0834 88            	push	a
3279  0835 520a          	subw	sp,#10
3280       0000000a      OFST:	set	10
3283                     ; 382    uint16_t ptr = 0;
3285                     ; 383    uint32_t addrsel = 0;
3287                     ; 385    if(len == 0) return;
3289  0837 1e10          	ldw	x,(OFST+6,sp)
3290  0839 2603          	jrne	L051
3291  083b cc0901        	jp	L641
3292  083e               L051:
3295                     ; 386    ptr = getSn_RX_RD(sn);
3297  083e 7b0b          	ld	a,(OFST+1,sp)
3298  0840 97            	ld	xl,a
3299  0841 a604          	ld	a,#4
3300  0843 42            	mul	x,a
3301  0844 58            	sllw	x
3302  0845 58            	sllw	x
3303  0846 58            	sllw	x
3304  0847 1c2908        	addw	x,#10504
3305  084a cd0000        	call	c_itolx
3307  084d be02          	ldw	x,c_lreg+2
3308  084f 89            	pushw	x
3309  0850 be00          	ldw	x,c_lreg
3310  0852 89            	pushw	x
3311  0853 cd000b        	call	_WIZCHIP_READ
3313  0856 5b04          	addw	sp,#4
3314  0858 6b04          	ld	(OFST-6,sp),a
3316  085a 7b0b          	ld	a,(OFST+1,sp)
3317  085c 97            	ld	xl,a
3318  085d a604          	ld	a,#4
3319  085f 42            	mul	x,a
3320  0860 58            	sllw	x
3321  0861 58            	sllw	x
3322  0862 58            	sllw	x
3323  0863 1c2808        	addw	x,#10248
3324  0866 cd0000        	call	c_itolx
3326  0869 be02          	ldw	x,c_lreg+2
3327  086b 89            	pushw	x
3328  086c be00          	ldw	x,c_lreg
3329  086e 89            	pushw	x
3330  086f cd000b        	call	_WIZCHIP_READ
3332  0872 5b04          	addw	sp,#4
3333  0874 5f            	clrw	x
3334  0875 97            	ld	xl,a
3335  0876 4f            	clr	a
3336  0877 02            	rlwa	x,a
3337  0878 01            	rrwa	x,a
3338  0879 1b04          	add	a,(OFST-6,sp)
3339  087b 2401          	jrnc	L441
3340  087d 5c            	incw	x
3341  087e               L441:
3342  087e 02            	rlwa	x,a
3343  087f 1f09          	ldw	(OFST-1,sp),x
3344  0881 01            	rrwa	x,a
3346                     ; 389    addrsel = ((uint32_t)ptr << 8) + (WIZCHIP_RXBUF_BLOCK(sn) << 3);
3348  0882 7b0b          	ld	a,(OFST+1,sp)
3349  0884 97            	ld	xl,a
3350  0885 a604          	ld	a,#4
3351  0887 42            	mul	x,a
3352  0888 58            	sllw	x
3353  0889 58            	sllw	x
3354  088a 58            	sllw	x
3355  088b 1c0018        	addw	x,#24
3356  088e cd0000        	call	c_itolx
3358  0891 96            	ldw	x,sp
3359  0892 1c0001        	addw	x,#OFST-9
3360  0895 cd0000        	call	c_rtol
3363  0898 1e09          	ldw	x,(OFST-1,sp)
3364  089a 90ae0100      	ldw	y,#256
3365  089e cd0000        	call	c_umul
3367  08a1 96            	ldw	x,sp
3368  08a2 1c0001        	addw	x,#OFST-9
3369  08a5 cd0000        	call	c_ladd
3371  08a8 96            	ldw	x,sp
3372  08a9 1c0005        	addw	x,#OFST-5
3373  08ac cd0000        	call	c_rtol
3376                     ; 391    WIZCHIP_READ_BUF(addrsel, wizdata, len);
3378  08af 1e10          	ldw	x,(OFST+6,sp)
3379  08b1 89            	pushw	x
3380  08b2 1e10          	ldw	x,(OFST+6,sp)
3381  08b4 89            	pushw	x
3382  08b5 1e0b          	ldw	x,(OFST+1,sp)
3383  08b7 89            	pushw	x
3384  08b8 1e0b          	ldw	x,(OFST+1,sp)
3385  08ba 89            	pushw	x
3386  08bb cd00b9        	call	_WIZCHIP_READ_BUF
3388  08be 5b08          	addw	sp,#8
3389                     ; 392    ptr += len;
3391  08c0 1e09          	ldw	x,(OFST-1,sp)
3392  08c2 72fb10        	addw	x,(OFST+6,sp)
3393  08c5 1f09          	ldw	(OFST-1,sp),x
3395                     ; 393    setSn_RX_RD(sn,ptr);
3397  08c7 7b09          	ld	a,(OFST-1,sp)
3398  08c9 88            	push	a
3399  08ca 7b0c          	ld	a,(OFST+2,sp)
3400  08cc 97            	ld	xl,a
3401  08cd a604          	ld	a,#4
3402  08cf 42            	mul	x,a
3403  08d0 58            	sllw	x
3404  08d1 58            	sllw	x
3405  08d2 58            	sllw	x
3406  08d3 1c2808        	addw	x,#10248
3407  08d6 cd0000        	call	c_itolx
3409  08d9 be02          	ldw	x,c_lreg+2
3410  08db 89            	pushw	x
3411  08dc be00          	ldw	x,c_lreg
3412  08de 89            	pushw	x
3413  08df cd0060        	call	_WIZCHIP_WRITE
3415  08e2 5b05          	addw	sp,#5
3418  08e4 7b0a          	ld	a,(OFST+0,sp)
3419  08e6 88            	push	a
3420  08e7 7b0c          	ld	a,(OFST+2,sp)
3421  08e9 97            	ld	xl,a
3422  08ea a604          	ld	a,#4
3423  08ec 42            	mul	x,a
3424  08ed 58            	sllw	x
3425  08ee 58            	sllw	x
3426  08ef 58            	sllw	x
3427  08f0 1c2908        	addw	x,#10504
3428  08f3 cd0000        	call	c_itolx
3430  08f6 be02          	ldw	x,c_lreg+2
3431  08f8 89            	pushw	x
3432  08f9 be00          	ldw	x,c_lreg
3433  08fb 89            	pushw	x
3434  08fc cd0060        	call	_WIZCHIP_WRITE
3436  08ff 5b05          	addw	sp,#5
3437                     ; 394 }
3438  0901               L641:
3442  0901 5b0b          	addw	sp,#11
3443  0903 81            	ret
3521                     ; 396 int32_t recv(uint8_t sn, uint8_t *buf, uint16_t len){
3522                     	switch	.text
3523  0904               _recv:
3525  0904 88            	push	a
3526  0905 5205          	subw	sp,#5
3527       00000005      OFST:	set	5
3530                     ; 397     uint8_t tmp = 0;
3532                     ; 398     uint16_t recvsize = 0;
3534                     ; 399     CHECK_SOCKNUM();
3536  0907 7b06          	ld	a,(OFST+1,sp)
3537  0909 a108          	cp	a,#8
3538  090b 250c          	jrult	L7431
3541  090d aeffff        	ldw	x,#65535
3542  0910 bf02          	ldw	c_lreg+2,x
3543  0912 aeffff        	ldw	x,#-1
3544  0915 bf00          	ldw	c_lreg,x
3546  0917 202a          	jra	L061
3547  0919               L7431:
3548                     ; 400     CHECK_SOCKMODE(Sn_MR_TCP);
3550  0919 7b06          	ld	a,(OFST+1,sp)
3551  091b 97            	ld	xl,a
3552  091c a604          	ld	a,#4
3553  091e 42            	mul	x,a
3554  091f 58            	sllw	x
3555  0920 58            	sllw	x
3556  0921 58            	sllw	x
3557  0922 1c0008        	addw	x,#8
3558  0925 cd0000        	call	c_itolx
3560  0928 be02          	ldw	x,c_lreg+2
3561  092a 89            	pushw	x
3562  092b be00          	ldw	x,c_lreg
3563  092d 89            	pushw	x
3564  092e cd000b        	call	_WIZCHIP_READ
3566  0931 5b04          	addw	sp,#4
3567  0933 a40f          	and	a,#15
3568  0935 a101          	cp	a,#1
3569  0937 270d          	jreq	L5531
3572  0939 aefffb        	ldw	x,#65531
3573  093c bf02          	ldw	c_lreg+2,x
3574  093e aeffff        	ldw	x,#-1
3575  0941 bf00          	ldw	c_lreg,x
3577  0943               L061:
3579  0943 5b06          	addw	sp,#6
3580  0945 81            	ret
3581  0946               L5531:
3582                     ; 401     CHECK_SOCKDATA();
3584  0946 1e0b          	ldw	x,(OFST+6,sp)
3585  0948 260c          	jrne	L1631
3588  094a aefff2        	ldw	x,#65522
3589  094d bf02          	ldw	c_lreg+2,x
3590  094f aeffff        	ldw	x,#-1
3591  0952 bf00          	ldw	c_lreg,x
3593  0954 20ed          	jra	L061
3594  0956               L1631:
3595                     ; 402     recvsize = getSn_RxMAX(sn);
3598  0956 7b06          	ld	a,(OFST+1,sp)
3599  0958 97            	ld	xl,a
3600  0959 a604          	ld	a,#4
3601  095b 42            	mul	x,a
3602  095c 58            	sllw	x
3603  095d 58            	sllw	x
3604  095e 58            	sllw	x
3605  095f 1c1e08        	addw	x,#7688
3606  0962 cd0000        	call	c_itolx
3608  0965 be02          	ldw	x,c_lreg+2
3609  0967 89            	pushw	x
3610  0968 be00          	ldw	x,c_lreg
3611  096a 89            	pushw	x
3612  096b cd000b        	call	_WIZCHIP_READ
3614  096e 5b04          	addw	sp,#4
3615  0970 5f            	clrw	x
3616  0971 97            	ld	xl,a
3617  0972 4f            	clr	a
3618  0973 02            	rlwa	x,a
3619  0974 58            	sllw	x
3620  0975 58            	sllw	x
3621  0976 1f04          	ldw	(OFST-1,sp),x
3623                     ; 403     if(recvsize < len) len = recvsize;
3625  0978 1e04          	ldw	x,(OFST-1,sp)
3626  097a 130b          	cpw	x,(OFST+6,sp)
3627  097c 2404          	jruge	L5631
3630  097e 1e04          	ldw	x,(OFST-1,sp)
3631  0980 1f0b          	ldw	(OFST+6,sp),x
3632  0982               L5631:
3633                     ; 405         recvsize = getSn_RX_RSR(sn);
3635  0982 7b06          	ld	a,(OFST+1,sp)
3636  0984 cd01d3        	call	_getSn_RX_RSR
3638  0987 1f04          	ldw	(OFST-1,sp),x
3640                     ; 406         tmp = getSn_SR(sn);
3642  0989 7b06          	ld	a,(OFST+1,sp)
3643  098b 97            	ld	xl,a
3644  098c a604          	ld	a,#4
3645  098e 42            	mul	x,a
3646  098f 58            	sllw	x
3647  0990 58            	sllw	x
3648  0991 58            	sllw	x
3649  0992 1c0308        	addw	x,#776
3650  0995 cd0000        	call	c_itolx
3652  0998 be02          	ldw	x,c_lreg+2
3653  099a 89            	pushw	x
3654  099b be00          	ldw	x,c_lreg
3655  099d 89            	pushw	x
3656  099e cd000b        	call	_WIZCHIP_READ
3658  09a1 5b04          	addw	sp,#4
3659  09a3 6b03          	ld	(OFST-2,sp),a
3661                     ; 407         if(tmp != SOCK_ESTABLISHED){
3663  09a5 7b03          	ld	a,(OFST-2,sp)
3664  09a7 a117          	cp	a,#23
3665  09a9 275e          	jreq	L1731
3666                     ; 408             if(tmp == SOCK_CLOSE_WAIT){
3668  09ab 7b03          	ld	a,(OFST-2,sp)
3669  09ad a11c          	cp	a,#28
3670  09af 2645          	jrne	L3731
3671                     ; 409                 if(recvsize != 0) break;
3673  09b1 1e04          	ldw	x,(OFST-1,sp)
3674  09b3 2703          	jreq	L261
3675  09b5 cc0a3a        	jp	L7631
3676  09b8               L261:
3679                     ; 410                 else if(getSn_TX_FSR(sn) == getSn_TxMAX(sn))
3681  09b8 7b06          	ld	a,(OFST+1,sp)
3682  09ba 97            	ld	xl,a
3683  09bb a604          	ld	a,#4
3684  09bd 42            	mul	x,a
3685  09be 58            	sllw	x
3686  09bf 58            	sllw	x
3687  09c0 58            	sllw	x
3688  09c1 1c1f08        	addw	x,#7944
3689  09c4 cd0000        	call	c_itolx
3691  09c7 be02          	ldw	x,c_lreg+2
3692  09c9 89            	pushw	x
3693  09ca be00          	ldw	x,c_lreg
3694  09cc 89            	pushw	x
3695  09cd cd000b        	call	_WIZCHIP_READ
3697  09d0 5b04          	addw	sp,#4
3698  09d2 5f            	clrw	x
3699  09d3 97            	ld	xl,a
3700  09d4 4f            	clr	a
3701  09d5 02            	rlwa	x,a
3702  09d6 58            	sllw	x
3703  09d7 58            	sllw	x
3704  09d8 1f01          	ldw	(OFST-4,sp),x
3706  09da 7b06          	ld	a,(OFST+1,sp)
3707  09dc cd012b        	call	_getSn_TX_FSR
3709  09df 1301          	cpw	x,(OFST-4,sp)
3710  09e1 2626          	jrne	L1731
3711                     ; 412                     close(sn);
3713  09e3 7b06          	ld	a,(OFST+1,sp)
3714  09e5 cd06ba        	call	_close
3716                     ; 413                     return SOCKERR_SOCKSTATUS;
3718  09e8 aefff9        	ldw	x,#65529
3719  09eb bf02          	ldw	c_lreg+2,x
3720  09ed aeffff        	ldw	x,#-1
3721  09f0 bf00          	ldw	c_lreg,x
3723  09f2 ac430943      	jpf	L061
3724  09f6               L3731:
3725                     ; 418                 close(sn);
3727  09f6 7b06          	ld	a,(OFST+1,sp)
3728  09f8 cd06ba        	call	_close
3730                     ; 419                 return SOCKERR_SOCKSTATUS;
3732  09fb aefff9        	ldw	x,#65529
3733  09fe bf02          	ldw	c_lreg+2,x
3734  0a00 aeffff        	ldw	x,#-1
3735  0a03 bf00          	ldw	c_lreg,x
3737  0a05 ac430943      	jpf	L061
3738  0a09               L1731:
3739                     ; 422         if ((sock_io_mode & (1 << sn)) && (recvsize == 0)){
3741  0a09 ae0001        	ldw	x,#1
3742  0a0c 7b06          	ld	a,(OFST+1,sp)
3743  0a0e 4d            	tnz	a
3744  0a0f 2704          	jreq	L451
3745  0a11               L651:
3746  0a11 58            	sllw	x
3747  0a12 4a            	dec	a
3748  0a13 26fc          	jrne	L651
3749  0a15               L451:
3750  0a15 01            	rrwa	x,a
3751  0a16 b41d          	and	a,L52_sock_io_mode+1
3752  0a18 01            	rrwa	x,a
3753  0a19 b41c          	and	a,L52_sock_io_mode
3754  0a1b 01            	rrwa	x,a
3755  0a1c a30000        	cpw	x,#0
3756  0a1f 2712          	jreq	L5041
3758  0a21 1e04          	ldw	x,(OFST-1,sp)
3759  0a23 260e          	jrne	L5041
3760                     ; 423             return SOCK_BUSY;
3762  0a25 ae0000        	ldw	x,#0
3763  0a28 bf02          	ldw	c_lreg+2,x
3764  0a2a ae0000        	ldw	x,#0
3765  0a2d bf00          	ldw	c_lreg,x
3767  0a2f ac430943      	jpf	L061
3768  0a33               L5041:
3769                     ; 425         if(recvsize != 0) break;
3771  0a33 1e04          	ldw	x,(OFST-1,sp)
3772  0a35 2603          	jrne	L461
3773  0a37 cc0982        	jp	L5631
3774  0a3a               L461:
3776  0a3a               L7631:
3777                     ; 427     if(recvsize < len) len = recvsize;
3780  0a3a 1e04          	ldw	x,(OFST-1,sp)
3781  0a3c 130b          	cpw	x,(OFST+6,sp)
3782  0a3e 2404          	jruge	L1141
3785  0a40 1e04          	ldw	x,(OFST-1,sp)
3786  0a42 1f0b          	ldw	(OFST+6,sp),x
3787  0a44               L1141:
3788                     ; 428     wiz_recv_data(sn, buf, len);
3790  0a44 1e0b          	ldw	x,(OFST+6,sp)
3791  0a46 89            	pushw	x
3792  0a47 1e0b          	ldw	x,(OFST+6,sp)
3793  0a49 89            	pushw	x
3794  0a4a 7b0a          	ld	a,(OFST+5,sp)
3795  0a4c cd0834        	call	_wiz_recv_data
3797  0a4f 5b04          	addw	sp,#4
3798                     ; 429     setSn_CR(sn,Sn_CR_RECV);
3800  0a51 4b40          	push	#64
3801  0a53 7b07          	ld	a,(OFST+2,sp)
3802  0a55 97            	ld	xl,a
3803  0a56 a604          	ld	a,#4
3804  0a58 42            	mul	x,a
3805  0a59 58            	sllw	x
3806  0a5a 58            	sllw	x
3807  0a5b 58            	sllw	x
3808  0a5c 1c0108        	addw	x,#264
3809  0a5f cd0000        	call	c_itolx
3811  0a62 be02          	ldw	x,c_lreg+2
3812  0a64 89            	pushw	x
3813  0a65 be00          	ldw	x,c_lreg
3814  0a67 89            	pushw	x
3815  0a68 cd0060        	call	_WIZCHIP_WRITE
3817  0a6b 5b05          	addw	sp,#5
3819  0a6d               L5141:
3820                     ; 430     while(getSn_CR(sn));
3822  0a6d 7b06          	ld	a,(OFST+1,sp)
3823  0a6f 97            	ld	xl,a
3824  0a70 a604          	ld	a,#4
3825  0a72 42            	mul	x,a
3826  0a73 58            	sllw	x
3827  0a74 58            	sllw	x
3828  0a75 58            	sllw	x
3829  0a76 1c0108        	addw	x,#264
3830  0a79 cd0000        	call	c_itolx
3832  0a7c be02          	ldw	x,c_lreg+2
3833  0a7e 89            	pushw	x
3834  0a7f be00          	ldw	x,c_lreg
3835  0a81 89            	pushw	x
3836  0a82 cd000b        	call	_WIZCHIP_READ
3838  0a85 5b04          	addw	sp,#4
3839  0a87 4d            	tnz	a
3840  0a88 26e3          	jrne	L5141
3841                     ; 432     return len;
3843  0a8a 1e0b          	ldw	x,(OFST+6,sp)
3844  0a8c cd0000        	call	c_uitolx
3847  0a8f ac430943      	jpf	L061
3925                     ; 435 int32_t send(uint8_t sn, uint8_t * buf, uint16_t len){
3926                     	switch	.text
3927  0a93               _send:
3929  0a93 88            	push	a
3930  0a94 5203          	subw	sp,#3
3931       00000003      OFST:	set	3
3934                     ; 436     uint8_t tmp = 0;
3936                     ; 437     uint16_t freesize = 0;
3938                     ; 439     CHECK_SOCKNUM();
3940  0a96 7b04          	ld	a,(OFST+1,sp)
3941  0a98 a108          	cp	a,#8
3942  0a9a 250c          	jrult	L5641
3945  0a9c aeffff        	ldw	x,#65535
3946  0a9f bf02          	ldw	c_lreg+2,x
3947  0aa1 aeffff        	ldw	x,#-1
3948  0aa4 bf00          	ldw	c_lreg,x
3950  0aa6 202a          	jra	L402
3951  0aa8               L5641:
3952                     ; 440     CHECK_SOCKMODE(Sn_MR_TCP);
3954  0aa8 7b04          	ld	a,(OFST+1,sp)
3955  0aaa 97            	ld	xl,a
3956  0aab a604          	ld	a,#4
3957  0aad 42            	mul	x,a
3958  0aae 58            	sllw	x
3959  0aaf 58            	sllw	x
3960  0ab0 58            	sllw	x
3961  0ab1 1c0008        	addw	x,#8
3962  0ab4 cd0000        	call	c_itolx
3964  0ab7 be02          	ldw	x,c_lreg+2
3965  0ab9 89            	pushw	x
3966  0aba be00          	ldw	x,c_lreg
3967  0abc 89            	pushw	x
3968  0abd cd000b        	call	_WIZCHIP_READ
3970  0ac0 5b04          	addw	sp,#4
3971  0ac2 a40f          	and	a,#15
3972  0ac4 a101          	cp	a,#1
3973  0ac6 270d          	jreq	L3741
3976  0ac8 aefffb        	ldw	x,#65531
3977  0acb bf02          	ldw	c_lreg+2,x
3978  0acd aeffff        	ldw	x,#-1
3979  0ad0 bf00          	ldw	c_lreg,x
3981  0ad2               L402:
3983  0ad2 5b04          	addw	sp,#4
3984  0ad4 81            	ret
3985  0ad5               L3741:
3986                     ; 441     CHECK_SOCKDATA();
3988  0ad5 1e09          	ldw	x,(OFST+6,sp)
3989  0ad7 260c          	jrne	L7741
3992  0ad9 aefff2        	ldw	x,#65522
3993  0adc bf02          	ldw	c_lreg+2,x
3994  0ade aeffff        	ldw	x,#-1
3995  0ae1 bf00          	ldw	c_lreg,x
3997  0ae3 20ed          	jra	L402
3998  0ae5               L7741:
3999                     ; 442     tmp = getSn_SR(sn);
4002  0ae5 7b04          	ld	a,(OFST+1,sp)
4003  0ae7 97            	ld	xl,a
4004  0ae8 a604          	ld	a,#4
4005  0aea 42            	mul	x,a
4006  0aeb 58            	sllw	x
4007  0aec 58            	sllw	x
4008  0aed 58            	sllw	x
4009  0aee 1c0308        	addw	x,#776
4010  0af1 cd0000        	call	c_itolx
4012  0af4 be02          	ldw	x,c_lreg+2
4013  0af6 89            	pushw	x
4014  0af7 be00          	ldw	x,c_lreg
4015  0af9 89            	pushw	x
4016  0afa cd000b        	call	_WIZCHIP_READ
4018  0afd 5b04          	addw	sp,#4
4019  0aff 6b03          	ld	(OFST+0,sp),a
4021                     ; 443     if(tmp != SOCK_ESTABLISHED && tmp != SOCK_CLOSE_WAIT) return SOCKERR_SOCKSTATUS;
4023  0b01 7b03          	ld	a,(OFST+0,sp)
4024  0b03 a117          	cp	a,#23
4025  0b05 2712          	jreq	L1051
4027  0b07 7b03          	ld	a,(OFST+0,sp)
4028  0b09 a11c          	cp	a,#28
4029  0b0b 270c          	jreq	L1051
4032  0b0d aefff9        	ldw	x,#65529
4033  0b10 bf02          	ldw	c_lreg+2,x
4034  0b12 aeffff        	ldw	x,#-1
4035  0b15 bf00          	ldw	c_lreg,x
4037  0b17 20b9          	jra	L402
4038  0b19               L1051:
4039                     ; 444     if(sock_is_sending & (1<<sn)){
4041  0b19 ae0001        	ldw	x,#1
4042  0b1c 7b04          	ld	a,(OFST+1,sp)
4043  0b1e 4d            	tnz	a
4044  0b1f 2704          	jreq	L071
4045  0b21               L271:
4046  0b21 58            	sllw	x
4047  0b22 4a            	dec	a
4048  0b23 26fc          	jrne	L271
4049  0b25               L071:
4050  0b25 01            	rrwa	x,a
4051  0b26 b41b          	and	a,L32_sock_is_sending+1
4052  0b28 01            	rrwa	x,a
4053  0b29 b41a          	and	a,L32_sock_is_sending
4054  0b2b 01            	rrwa	x,a
4055  0b2c a30000        	cpw	x,#0
4056  0b2f 2603          	jrne	L602
4057  0b31 cc0bb3        	jp	L3051
4058  0b34               L602:
4059                     ; 445         tmp = getSn_IR(sn);
4061  0b34 7b04          	ld	a,(OFST+1,sp)
4062  0b36 97            	ld	xl,a
4063  0b37 a604          	ld	a,#4
4064  0b39 42            	mul	x,a
4065  0b3a 58            	sllw	x
4066  0b3b 58            	sllw	x
4067  0b3c 58            	sllw	x
4068  0b3d 1c0208        	addw	x,#520
4069  0b40 cd0000        	call	c_itolx
4071  0b43 be02          	ldw	x,c_lreg+2
4072  0b45 89            	pushw	x
4073  0b46 be00          	ldw	x,c_lreg
4074  0b48 89            	pushw	x
4075  0b49 cd000b        	call	_WIZCHIP_READ
4077  0b4c 5b04          	addw	sp,#4
4078  0b4e a41f          	and	a,#31
4079  0b50 6b03          	ld	(OFST+0,sp),a
4081                     ; 446         if(tmp & Sn_IR_SENDOK){
4083  0b52 7b03          	ld	a,(OFST+0,sp)
4084  0b54 a510          	bcp	a,#16
4085  0b56 2734          	jreq	L5051
4086                     ; 447             setSn_IR(sn, Sn_IR_SENDOK);
4088  0b58 4b10          	push	#16
4089  0b5a 7b05          	ld	a,(OFST+2,sp)
4090  0b5c 97            	ld	xl,a
4091  0b5d a604          	ld	a,#4
4092  0b5f 42            	mul	x,a
4093  0b60 58            	sllw	x
4094  0b61 58            	sllw	x
4095  0b62 58            	sllw	x
4096  0b63 1c0208        	addw	x,#520
4097  0b66 cd0000        	call	c_itolx
4099  0b69 be02          	ldw	x,c_lreg+2
4100  0b6b 89            	pushw	x
4101  0b6c be00          	ldw	x,c_lreg
4102  0b6e 89            	pushw	x
4103  0b6f cd0060        	call	_WIZCHIP_WRITE
4105  0b72 5b05          	addw	sp,#5
4106                     ; 448             sock_is_sending &= ~(1<<sn);
4108  0b74 ae0001        	ldw	x,#1
4109  0b77 7b04          	ld	a,(OFST+1,sp)
4110  0b79 4d            	tnz	a
4111  0b7a 2704          	jreq	L471
4112  0b7c               L671:
4113  0b7c 58            	sllw	x
4114  0b7d 4a            	dec	a
4115  0b7e 26fc          	jrne	L671
4116  0b80               L471:
4117  0b80 53            	cplw	x
4118  0b81 01            	rrwa	x,a
4119  0b82 b41b          	and	a,L32_sock_is_sending+1
4120  0b84 01            	rrwa	x,a
4121  0b85 b41a          	and	a,L32_sock_is_sending
4122  0b87 01            	rrwa	x,a
4123  0b88 bf1a          	ldw	L32_sock_is_sending,x
4125  0b8a 2027          	jra	L3051
4126  0b8c               L5051:
4127                     ; 450         else if(tmp & Sn_IR_TIMEOUT)
4129  0b8c 7b03          	ld	a,(OFST+0,sp)
4130  0b8e a508          	bcp	a,#8
4131  0b90 2713          	jreq	L1151
4132                     ; 452             close(sn);
4134  0b92 7b04          	ld	a,(OFST+1,sp)
4135  0b94 cd06ba        	call	_close
4137                     ; 453             return SOCKERR_TIMEOUT;
4139  0b97 aefff3        	ldw	x,#65523
4140  0b9a bf02          	ldw	c_lreg+2,x
4141  0b9c aeffff        	ldw	x,#-1
4142  0b9f bf00          	ldw	c_lreg,x
4144  0ba1 acd20ad2      	jpf	L402
4145  0ba5               L1151:
4146                     ; 455         else return SOCK_BUSY;
4148  0ba5 ae0000        	ldw	x,#0
4149  0ba8 bf02          	ldw	c_lreg+2,x
4150  0baa ae0000        	ldw	x,#0
4151  0bad bf00          	ldw	c_lreg,x
4153  0baf acd20ad2      	jpf	L402
4154  0bb3               L3051:
4155                     ; 457     freesize = getSn_TxMAX(sn);
4157  0bb3 7b04          	ld	a,(OFST+1,sp)
4158  0bb5 97            	ld	xl,a
4159  0bb6 a604          	ld	a,#4
4160  0bb8 42            	mul	x,a
4161  0bb9 58            	sllw	x
4162  0bba 58            	sllw	x
4163  0bbb 58            	sllw	x
4164  0bbc 1c1f08        	addw	x,#7944
4165  0bbf cd0000        	call	c_itolx
4167  0bc2 be02          	ldw	x,c_lreg+2
4168  0bc4 89            	pushw	x
4169  0bc5 be00          	ldw	x,c_lreg
4170  0bc7 89            	pushw	x
4171  0bc8 cd000b        	call	_WIZCHIP_READ
4173  0bcb 5b04          	addw	sp,#4
4174  0bcd 5f            	clrw	x
4175  0bce 97            	ld	xl,a
4176  0bcf 4f            	clr	a
4177  0bd0 02            	rlwa	x,a
4178  0bd1 58            	sllw	x
4179  0bd2 58            	sllw	x
4180  0bd3 1f01          	ldw	(OFST-2,sp),x
4182                     ; 458     if (len > freesize) len = freesize;
4184  0bd5 1e09          	ldw	x,(OFST+6,sp)
4185  0bd7 1301          	cpw	x,(OFST-2,sp)
4186  0bd9 2304          	jrule	L7151
4189  0bdb 1e01          	ldw	x,(OFST-2,sp)
4190  0bdd 1f09          	ldw	(OFST+6,sp),x
4191  0bdf               L7151:
4192                     ; 460         freesize = getSn_TX_FSR(sn);
4194  0bdf 7b04          	ld	a,(OFST+1,sp)
4195  0be1 cd012b        	call	_getSn_TX_FSR
4197  0be4 1f01          	ldw	(OFST-2,sp),x
4199                     ; 461         tmp = getSn_SR(sn);
4201  0be6 7b04          	ld	a,(OFST+1,sp)
4202  0be8 97            	ld	xl,a
4203  0be9 a604          	ld	a,#4
4204  0beb 42            	mul	x,a
4205  0bec 58            	sllw	x
4206  0bed 58            	sllw	x
4207  0bee 58            	sllw	x
4208  0bef 1c0308        	addw	x,#776
4209  0bf2 cd0000        	call	c_itolx
4211  0bf5 be02          	ldw	x,c_lreg+2
4212  0bf7 89            	pushw	x
4213  0bf8 be00          	ldw	x,c_lreg
4214  0bfa 89            	pushw	x
4215  0bfb cd000b        	call	_WIZCHIP_READ
4217  0bfe 5b04          	addw	sp,#4
4218  0c00 6b03          	ld	(OFST+0,sp),a
4220                     ; 462         if((tmp != SOCK_ESTABLISHED) && (tmp != SOCK_CLOSE_WAIT)){
4222  0c02 7b03          	ld	a,(OFST+0,sp)
4223  0c04 a117          	cp	a,#23
4224  0c06 2719          	jreq	L3251
4226  0c08 7b03          	ld	a,(OFST+0,sp)
4227  0c0a a11c          	cp	a,#28
4228  0c0c 2713          	jreq	L3251
4229                     ; 463             close(sn);
4231  0c0e 7b04          	ld	a,(OFST+1,sp)
4232  0c10 cd06ba        	call	_close
4234                     ; 464             return SOCKERR_SOCKSTATUS;
4236  0c13 aefff9        	ldw	x,#65529
4237  0c16 bf02          	ldw	c_lreg+2,x
4238  0c18 aeffff        	ldw	x,#-1
4239  0c1b bf00          	ldw	c_lreg,x
4241  0c1d acd20ad2      	jpf	L402
4242  0c21               L3251:
4243                     ; 466         if((sock_io_mode & (1<<sn)) && (len > freesize)) return SOCK_BUSY;
4245  0c21 ae0001        	ldw	x,#1
4246  0c24 7b04          	ld	a,(OFST+1,sp)
4247  0c26 4d            	tnz	a
4248  0c27 2704          	jreq	L002
4249  0c29               L202:
4250  0c29 58            	sllw	x
4251  0c2a 4a            	dec	a
4252  0c2b 26fc          	jrne	L202
4253  0c2d               L002:
4254  0c2d 01            	rrwa	x,a
4255  0c2e b41d          	and	a,L52_sock_io_mode+1
4256  0c30 01            	rrwa	x,a
4257  0c31 b41c          	and	a,L52_sock_io_mode
4258  0c33 01            	rrwa	x,a
4259  0c34 a30000        	cpw	x,#0
4260  0c37 2714          	jreq	L5251
4262  0c39 1e09          	ldw	x,(OFST+6,sp)
4263  0c3b 1301          	cpw	x,(OFST-2,sp)
4264  0c3d 230e          	jrule	L5251
4267  0c3f ae0000        	ldw	x,#0
4268  0c42 bf02          	ldw	c_lreg+2,x
4269  0c44 ae0000        	ldw	x,#0
4270  0c47 bf00          	ldw	c_lreg,x
4272  0c49 acd20ad2      	jpf	L402
4273  0c4d               L5251:
4274                     ; 467         if(len <= freesize) break;
4276  0c4d 1e09          	ldw	x,(OFST+6,sp)
4277  0c4f 1301          	cpw	x,(OFST-2,sp)
4278  0c51 228c          	jrugt	L7151
4280                     ; 469     wiz_send_data(sn, buf, len);
4282  0c53 1e09          	ldw	x,(OFST+6,sp)
4283  0c55 89            	pushw	x
4284  0c56 1e09          	ldw	x,(OFST+6,sp)
4285  0c58 89            	pushw	x
4286  0c59 7b08          	ld	a,(OFST+5,sp)
4287  0c5b cd02ef        	call	_wiz_send_data
4289  0c5e 5b04          	addw	sp,#4
4290                     ; 470     setSn_CR(sn,Sn_CR_SEND);
4292  0c60 4b20          	push	#32
4293  0c62 7b05          	ld	a,(OFST+2,sp)
4294  0c64 97            	ld	xl,a
4295  0c65 a604          	ld	a,#4
4296  0c67 42            	mul	x,a
4297  0c68 58            	sllw	x
4298  0c69 58            	sllw	x
4299  0c6a 58            	sllw	x
4300  0c6b 1c0108        	addw	x,#264
4301  0c6e cd0000        	call	c_itolx
4303  0c71 be02          	ldw	x,c_lreg+2
4304  0c73 89            	pushw	x
4305  0c74 be00          	ldw	x,c_lreg
4306  0c76 89            	pushw	x
4307  0c77 cd0060        	call	_WIZCHIP_WRITE
4309  0c7a 5b05          	addw	sp,#5
4311  0c7c               L3351:
4312                     ; 471     while(getSn_CR(sn));
4314  0c7c 7b04          	ld	a,(OFST+1,sp)
4315  0c7e 97            	ld	xl,a
4316  0c7f a604          	ld	a,#4
4317  0c81 42            	mul	x,a
4318  0c82 58            	sllw	x
4319  0c83 58            	sllw	x
4320  0c84 58            	sllw	x
4321  0c85 1c0108        	addw	x,#264
4322  0c88 cd0000        	call	c_itolx
4324  0c8b be02          	ldw	x,c_lreg+2
4325  0c8d 89            	pushw	x
4326  0c8e be00          	ldw	x,c_lreg
4327  0c90 89            	pushw	x
4328  0c91 cd000b        	call	_WIZCHIP_READ
4330  0c94 5b04          	addw	sp,#4
4331  0c96 4d            	tnz	a
4332  0c97 26e3          	jrne	L3351
4333                     ; 472     return (int32_t)len;
4335  0c99 1e09          	ldw	x,(OFST+6,sp)
4336  0c9b cd0000        	call	c_uitolx
4339  0c9e acd20ad2      	jpf	L402
4582                     	xdef	_sock_pack_info
4583                     	xdef	_send
4584                     	xdef	_recv
4585                     	xdef	_listen
4586                     	xdef	_close
4587                     	xdef	_socket
4588                     	xdef	_wizchip_init
4589                     	xdef	_wiz_recv_data
4590                     	xdef	_wizchip_setnetinfo
4591                     	xdef	_wiz_send_data
4592                     	xdef	_reg_wizchip_spiburst_cbfunc
4593                     	xdef	_reg_wizchip_spi_cbfunc
4594                     	xdef	_WIZCHIP_WRITE_BUF
4595                     	xdef	_getSn_RX_RSR
4596                     	xdef	_getSn_TX_FSR
4597                     	xdef	_reg_wizchip_cs_cbfunc
4598                     	xdef	_WIZCHIP_READ_BUF
4599                     	xdef	_WIZCHIP_READ
4600                     	xdef	_WIZCHIP_WRITE
4601                     	xdef	_WIZCHIP
4602                     	xref.b	c_lreg
4603                     	xref.b	c_x
4604                     	xref.b	c_y
4623                     	xref	c_uitolx
4624                     	xref	c_lzmp
4625                     	xref	c_ladd
4626                     	xref	c_rtol
4627                     	xref	c_umul
4628                     	xref	c_itolx
4629                     	end
