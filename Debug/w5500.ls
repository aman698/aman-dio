   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  73                     ; 11 uint8_t  WIZCHIP_READ(uint32_t AddrSel)
  73                     ; 12 {
  75                     	switch	.text
  76  0000               _WIZCHIP_READ:
  78  0000 5204          	subw	sp,#4
  79       00000004      OFST:	set	4
  82                     ; 16    WIZCHIP_CRITICAL_ENTER();
  84  0002 92cd08        	call	[_WIZCHIP+8.w]
  86                     ; 17    WIZCHIP.CS._select();
  88  0005 92cd0c        	call	[_WIZCHIP+12.w]
  90                     ; 19    AddrSel |= (_W5500_SPI_READ_ | _W5500_SPI_VDM_OP_);
  92                     ; 21    if(!WIZCHIP.IF._SPI._read_burst || !WIZCHIP.IF._SPI._write_burst) 	// byte operation
  94  0008 be14          	ldw	x,_WIZCHIP+20
  95  000a 2704          	jreq	L14
  97  000c be16          	ldw	x,_WIZCHIP+22
  98  000e 2625          	jrne	L73
  99  0010               L14:
 100                     ; 23 	   WIZCHIP.IF._SPI._write_byte((AddrSel & 0x00FF0000) >> 16);
 102  0010 7b08          	ld	a,(OFST+4,sp)
 103  0012 a4ff          	and	a,#255
 104  0014 92cd12        	call	[_WIZCHIP+18.w]
 106                     ; 24 		WIZCHIP.IF._SPI._write_byte((AddrSel & 0x0000FF00) >>  8);
 108  0017 7b09          	ld	a,(OFST+5,sp)
 109  0019 a4ff          	and	a,#255
 110  001b 92cd12        	call	[_WIZCHIP+18.w]
 112                     ; 25 		WIZCHIP.IF._SPI._write_byte((AddrSel & 0x000000FF) >>  0);
 114  001e 7b0a          	ld	a,(OFST+6,sp)
 115  0020 a4ff          	and	a,#255
 116  0022 92cd12        	call	[_WIZCHIP+18.w]
 119  0025               L34:
 120                     ; 34    ret = WIZCHIP.IF._SPI._read_byte();
 122  0025 92cd10        	call	[_WIZCHIP+16.w]
 124  0028 6b01          	ld	(OFST-3,sp),a
 126                     ; 36    WIZCHIP.CS._deselect();
 128  002a 92cd0e        	call	[_WIZCHIP+14.w]
 130                     ; 37    WIZCHIP_CRITICAL_EXIT();
 132  002d 92cd0a        	call	[_WIZCHIP+10.w]
 134                     ; 38    return ret;
 136  0030 7b01          	ld	a,(OFST-3,sp)
 139  0032 5b04          	addw	sp,#4
 140  0034 81            	ret
 141  0035               L73:
 142                     ; 29 		spi_data[0] = (AddrSel & 0x00FF0000) >> 16;
 144  0035 7b08          	ld	a,(OFST+4,sp)
 145  0037 a4ff          	and	a,#255
 146  0039 6b02          	ld	(OFST-2,sp),a
 148                     ; 30 		spi_data[1] = (AddrSel & 0x0000FF00) >> 8;
 150  003b 7b09          	ld	a,(OFST+5,sp)
 151  003d a4ff          	and	a,#255
 152  003f 6b03          	ld	(OFST-1,sp),a
 154                     ; 31 		spi_data[2] = (AddrSel & 0x000000FF) >> 0;
 156  0041 7b0a          	ld	a,(OFST+6,sp)
 157  0043 a4ff          	and	a,#255
 158  0045 6b04          	ld	(OFST+0,sp),a
 160                     ; 32 		WIZCHIP.IF._SPI._write_burst(spi_data, 3);
 162  0047 ae0003        	ldw	x,#3
 163  004a 89            	pushw	x
 164  004b 96            	ldw	x,sp
 165  004c 1c0004        	addw	x,#OFST+0
 166  004f 92cd16        	call	[_WIZCHIP+22.w]
 168  0052 85            	popw	x
 169  0053 20d0          	jra	L34
 223                     ; 41 void     WIZCHIP_WRITE(uint32_t AddrSel, uint8_t wb )
 223                     ; 42 {
 224                     	switch	.text
 225  0055               _WIZCHIP_WRITE:
 227  0055 5204          	subw	sp,#4
 228       00000004      OFST:	set	4
 231                     ; 45    WIZCHIP_CRITICAL_ENTER();
 233  0057 92cd08        	call	[_WIZCHIP+8.w]
 235                     ; 46    WIZCHIP.CS._select();
 237  005a 92cd0c        	call	[_WIZCHIP+12.w]
 239                     ; 48    AddrSel |= (_W5500_SPI_WRITE_ | _W5500_SPI_VDM_OP_);
 241  005d 7b0a          	ld	a,(OFST+6,sp)
 242  005f aa04          	or	a,#4
 243  0061 6b0a          	ld	(OFST+6,sp),a
 244                     ; 51    if(!WIZCHIP.IF._SPI._write_burst) 	// byte operation
 246  0063 be16          	ldw	x,_WIZCHIP+22
 247  0065 261c          	jrne	L37
 248                     ; 53 		WIZCHIP.IF._SPI._write_byte((AddrSel & 0x00FF0000) >> 16);
 250  0067 7b08          	ld	a,(OFST+4,sp)
 251  0069 a4ff          	and	a,#255
 252  006b 92cd12        	call	[_WIZCHIP+18.w]
 254                     ; 54 		WIZCHIP.IF._SPI._write_byte((AddrSel & 0x0000FF00) >>  8);
 256  006e 7b09          	ld	a,(OFST+5,sp)
 257  0070 a4ff          	and	a,#255
 258  0072 92cd12        	call	[_WIZCHIP+18.w]
 260                     ; 55 		WIZCHIP.IF._SPI._write_byte((AddrSel & 0x000000FF) >>  0);
 262  0075 7b0a          	ld	a,(OFST+6,sp)
 263  0077 a4ff          	and	a,#255
 264  0079 92cd12        	call	[_WIZCHIP+18.w]
 266                     ; 56 		WIZCHIP.IF._SPI._write_byte(wb);
 268  007c 7b0b          	ld	a,(OFST+7,sp)
 269  007e 92cd12        	call	[_WIZCHIP+18.w]
 272  0081 2022          	jra	L57
 273  0083               L37:
 274                     ; 60 		spi_data[0] = (AddrSel & 0x00FF0000) >> 16;
 276  0083 7b08          	ld	a,(OFST+4,sp)
 277  0085 a4ff          	and	a,#255
 278  0087 6b01          	ld	(OFST-3,sp),a
 280                     ; 61 		spi_data[1] = (AddrSel & 0x0000FF00) >> 8;
 282  0089 7b09          	ld	a,(OFST+5,sp)
 283  008b a4ff          	and	a,#255
 284  008d 6b02          	ld	(OFST-2,sp),a
 286                     ; 62 		spi_data[2] = (AddrSel & 0x000000FF) >> 0;
 288  008f 7b0a          	ld	a,(OFST+6,sp)
 289  0091 a4ff          	and	a,#255
 290  0093 6b03          	ld	(OFST-1,sp),a
 292                     ; 63 		spi_data[3] = wb;
 294  0095 7b0b          	ld	a,(OFST+7,sp)
 295  0097 6b04          	ld	(OFST+0,sp),a
 297                     ; 64 		WIZCHIP.IF._SPI._write_burst(spi_data, 4);
 299  0099 ae0004        	ldw	x,#4
 300  009c 89            	pushw	x
 301  009d 96            	ldw	x,sp
 302  009e 1c0003        	addw	x,#OFST-1
 303  00a1 92cd16        	call	[_WIZCHIP+22.w]
 305  00a4 85            	popw	x
 306  00a5               L57:
 307                     ; 67    WIZCHIP.CS._deselect();
 309  00a5 92cd0e        	call	[_WIZCHIP+14.w]
 311                     ; 68    WIZCHIP_CRITICAL_EXIT();
 313  00a8 92cd0a        	call	[_WIZCHIP+10.w]
 315                     ; 69 }
 318  00ab 5b04          	addw	sp,#4
 319  00ad 81            	ret
 392                     ; 71 void     WIZCHIP_READ_BUF (uint32_t AddrSel, uint8_t* pBuf, uint16_t len)
 392                     ; 72 {
 393                     	switch	.text
 394  00ae               _WIZCHIP_READ_BUF:
 396  00ae 5205          	subw	sp,#5
 397       00000005      OFST:	set	5
 400                     ; 76    WIZCHIP_CRITICAL_ENTER();
 402  00b0 92cd08        	call	[_WIZCHIP+8.w]
 404                     ; 77    WIZCHIP.CS._select();
 406  00b3 92cd0c        	call	[_WIZCHIP+12.w]
 408                     ; 79    AddrSel |= (_W5500_SPI_READ_ | _W5500_SPI_VDM_OP_);
 410                     ; 81    if(!WIZCHIP.IF._SPI._read_burst || !WIZCHIP.IF._SPI._write_burst) 	// byte operation
 412  00b6 be14          	ldw	x,_WIZCHIP+20
 413  00b8 2704          	jreq	L731
 415  00ba be16          	ldw	x,_WIZCHIP+22
 416  00bc 2632          	jrne	L531
 417  00be               L731:
 418                     ; 83 		WIZCHIP.IF._SPI._write_byte((AddrSel & 0x00FF0000) >> 16);
 420  00be 7b09          	ld	a,(OFST+4,sp)
 421  00c0 a4ff          	and	a,#255
 422  00c2 92cd12        	call	[_WIZCHIP+18.w]
 424                     ; 84 		WIZCHIP.IF._SPI._write_byte((AddrSel & 0x0000FF00) >>  8);
 426  00c5 7b0a          	ld	a,(OFST+5,sp)
 427  00c7 a4ff          	and	a,#255
 428  00c9 92cd12        	call	[_WIZCHIP+18.w]
 430                     ; 85 		WIZCHIP.IF._SPI._write_byte((AddrSel & 0x000000FF) >>  0);
 432  00cc 7b0b          	ld	a,(OFST+6,sp)
 433  00ce a4ff          	and	a,#255
 434  00d0 92cd12        	call	[_WIZCHIP+18.w]
 436                     ; 86 		for(i = 0; i < len; i++)
 438  00d3 5f            	clrw	x
 439  00d4 1f04          	ldw	(OFST-1,sp),x
 442  00d6 2010          	jra	L541
 443  00d8               L141:
 444                     ; 87 		   pBuf[i] = WIZCHIP.IF._SPI._read_byte();
 446  00d8 92cd10        	call	[_WIZCHIP+16.w]
 448  00db 1e0c          	ldw	x,(OFST+7,sp)
 449  00dd 72fb04        	addw	x,(OFST-1,sp)
 450  00e0 f7            	ld	(x),a
 451                     ; 86 		for(i = 0; i < len; i++)
 453  00e1 1e04          	ldw	x,(OFST-1,sp)
 454  00e3 1c0001        	addw	x,#1
 455  00e6 1f04          	ldw	(OFST-1,sp),x
 457  00e8               L541:
 460  00e8 1e04          	ldw	x,(OFST-1,sp)
 461  00ea 130e          	cpw	x,(OFST+9,sp)
 462  00ec 25ea          	jrult	L141
 464  00ee 2027          	jra	L151
 465  00f0               L531:
 466                     ; 91 		spi_data[0] = (AddrSel & 0x00FF0000) >> 16;
 468  00f0 7b09          	ld	a,(OFST+4,sp)
 469  00f2 a4ff          	and	a,#255
 470  00f4 6b01          	ld	(OFST-4,sp),a
 472                     ; 92 		spi_data[1] = (AddrSel & 0x0000FF00) >> 8;
 474  00f6 7b0a          	ld	a,(OFST+5,sp)
 475  00f8 a4ff          	and	a,#255
 476  00fa 6b02          	ld	(OFST-3,sp),a
 478                     ; 93 		spi_data[2] = (AddrSel & 0x000000FF) >> 0;
 480  00fc 7b0b          	ld	a,(OFST+6,sp)
 481  00fe a4ff          	and	a,#255
 482  0100 6b03          	ld	(OFST-2,sp),a
 484                     ; 94 		WIZCHIP.IF._SPI._write_burst(spi_data, 3);
 486  0102 ae0003        	ldw	x,#3
 487  0105 89            	pushw	x
 488  0106 96            	ldw	x,sp
 489  0107 1c0003        	addw	x,#OFST-2
 490  010a 92cd16        	call	[_WIZCHIP+22.w]
 492  010d 85            	popw	x
 493                     ; 95 		WIZCHIP.IF._SPI._read_burst(pBuf, len);
 495  010e 1e0e          	ldw	x,(OFST+9,sp)
 496  0110 89            	pushw	x
 497  0111 1e0e          	ldw	x,(OFST+9,sp)
 498  0113 92cd14        	call	[_WIZCHIP+20.w]
 500  0116 85            	popw	x
 501  0117               L151:
 502                     ; 98    WIZCHIP.CS._deselect();
 504  0117 92cd0e        	call	[_WIZCHIP+14.w]
 506                     ; 99    WIZCHIP_CRITICAL_EXIT();
 508  011a 92cd0a        	call	[_WIZCHIP+10.w]
 510                     ; 100 }
 513  011d 5b05          	addw	sp,#5
 514  011f 81            	ret
 587                     ; 102 void     WIZCHIP_WRITE_BUF(uint32_t AddrSel, uint8_t* pBuf, uint16_t len)
 587                     ; 103 {
 588                     	switch	.text
 589  0120               _WIZCHIP_WRITE_BUF:
 591  0120 5205          	subw	sp,#5
 592       00000005      OFST:	set	5
 595                     ; 107    WIZCHIP_CRITICAL_ENTER();
 597  0122 92cd08        	call	[_WIZCHIP+8.w]
 599                     ; 108    WIZCHIP.CS._select();
 601  0125 92cd0c        	call	[_WIZCHIP+12.w]
 603                     ; 110    AddrSel |= (_W5500_SPI_WRITE_ | _W5500_SPI_VDM_OP_);
 605  0128 7b0b          	ld	a,(OFST+6,sp)
 606  012a aa04          	or	a,#4
 607  012c 6b0b          	ld	(OFST+6,sp),a
 608                     ; 112    if(!WIZCHIP.IF._SPI._write_burst) 	// byte operation
 610  012e be16          	ldw	x,_WIZCHIP+22
 611  0130 2632          	jrne	L112
 612                     ; 114 		WIZCHIP.IF._SPI._write_byte((AddrSel & 0x00FF0000) >> 16);
 614  0132 7b09          	ld	a,(OFST+4,sp)
 615  0134 a4ff          	and	a,#255
 616  0136 92cd12        	call	[_WIZCHIP+18.w]
 618                     ; 115 		WIZCHIP.IF._SPI._write_byte((AddrSel & 0x0000FF00) >>  8);
 620  0139 7b0a          	ld	a,(OFST+5,sp)
 621  013b a4ff          	and	a,#255
 622  013d 92cd12        	call	[_WIZCHIP+18.w]
 624                     ; 116 		WIZCHIP.IF._SPI._write_byte((AddrSel & 0x000000FF) >>  0);
 626  0140 7b0b          	ld	a,(OFST+6,sp)
 627  0142 a4ff          	and	a,#255
 628  0144 92cd12        	call	[_WIZCHIP+18.w]
 630                     ; 117 		for(i = 0; i < len; i++)
 632  0147 5f            	clrw	x
 633  0148 1f04          	ldw	(OFST-1,sp),x
 636  014a 2010          	jra	L712
 637  014c               L312:
 638                     ; 118 			WIZCHIP.IF._SPI._write_byte(pBuf[i]);
 640  014c 1e0c          	ldw	x,(OFST+7,sp)
 641  014e 72fb04        	addw	x,(OFST-1,sp)
 642  0151 f6            	ld	a,(x)
 643  0152 92cd12        	call	[_WIZCHIP+18.w]
 645                     ; 117 		for(i = 0; i < len; i++)
 647  0155 1e04          	ldw	x,(OFST-1,sp)
 648  0157 1c0001        	addw	x,#1
 649  015a 1f04          	ldw	(OFST-1,sp),x
 651  015c               L712:
 654  015c 1e04          	ldw	x,(OFST-1,sp)
 655  015e 130e          	cpw	x,(OFST+9,sp)
 656  0160 25ea          	jrult	L312
 658  0162 2027          	jra	L322
 659  0164               L112:
 660                     ; 122 		spi_data[0] = (AddrSel & 0x00FF0000) >> 16;
 662  0164 7b09          	ld	a,(OFST+4,sp)
 663  0166 a4ff          	and	a,#255
 664  0168 6b01          	ld	(OFST-4,sp),a
 666                     ; 123 		spi_data[1] = (AddrSel & 0x0000FF00) >> 8;
 668  016a 7b0a          	ld	a,(OFST+5,sp)
 669  016c a4ff          	and	a,#255
 670  016e 6b02          	ld	(OFST-3,sp),a
 672                     ; 124 		spi_data[2] = (AddrSel & 0x000000FF) >> 0;
 674  0170 7b0b          	ld	a,(OFST+6,sp)
 675  0172 a4ff          	and	a,#255
 676  0174 6b03          	ld	(OFST-2,sp),a
 678                     ; 125 		WIZCHIP.IF._SPI._write_burst(spi_data, 3);
 680  0176 ae0003        	ldw	x,#3
 681  0179 89            	pushw	x
 682  017a 96            	ldw	x,sp
 683  017b 1c0003        	addw	x,#OFST-2
 684  017e 92cd16        	call	[_WIZCHIP+22.w]
 686  0181 85            	popw	x
 687                     ; 126 		WIZCHIP.IF._SPI._write_burst(pBuf, len);
 689  0182 1e0e          	ldw	x,(OFST+9,sp)
 690  0184 89            	pushw	x
 691  0185 1e0e          	ldw	x,(OFST+9,sp)
 692  0187 92cd16        	call	[_WIZCHIP+22.w]
 694  018a 85            	popw	x
 695  018b               L322:
 696                     ; 129    WIZCHIP.CS._deselect();
 698  018b 92cd0e        	call	[_WIZCHIP+14.w]
 700                     ; 130    WIZCHIP_CRITICAL_EXIT();
 702  018e 92cd0a        	call	[_WIZCHIP+10.w]
 704                     ; 131 }
 707  0191 5b05          	addw	sp,#5
 708  0193 81            	ret
 761                     ; 134 uint16_t getSn_TX_FSR(uint8_t sn)
 761                     ; 135 {
 762                     	switch	.text
 763  0194               _getSn_TX_FSR:
 765  0194 88            	push	a
 766  0195 5205          	subw	sp,#5
 767       00000005      OFST:	set	5
 770                     ; 136    uint16_t val=0,val1=0;
 772  0197 5f            	clrw	x
 773  0198 1f02          	ldw	(OFST-3,sp),x
 777  019a               L352:
 778                     ; 140       val1 = WIZCHIP_READ(Sn_TX_FSR(sn));
 780  019a 7b06          	ld	a,(OFST+1,sp)
 781  019c 97            	ld	xl,a
 782  019d a604          	ld	a,#4
 783  019f 42            	mul	x,a
 784  01a0 58            	sllw	x
 785  01a1 58            	sllw	x
 786  01a2 58            	sllw	x
 787  01a3 1c2008        	addw	x,#8200
 788  01a6 cd0000        	call	c_itolx
 790  01a9 be02          	ldw	x,c_lreg+2
 791  01ab 89            	pushw	x
 792  01ac be00          	ldw	x,c_lreg
 793  01ae 89            	pushw	x
 794  01af cd0000        	call	_WIZCHIP_READ
 796  01b2 5b04          	addw	sp,#4
 797  01b4 5f            	clrw	x
 798  01b5 97            	ld	xl,a
 799  01b6 1f04          	ldw	(OFST-1,sp),x
 801                     ; 141       val1 = (val1 << 8) + WIZCHIP_READ(WIZCHIP_OFFSET_INC(Sn_TX_FSR(sn),1));
 803  01b8 7b06          	ld	a,(OFST+1,sp)
 804  01ba 97            	ld	xl,a
 805  01bb a604          	ld	a,#4
 806  01bd 42            	mul	x,a
 807  01be 58            	sllw	x
 808  01bf 58            	sllw	x
 809  01c0 58            	sllw	x
 810  01c1 1c2108        	addw	x,#8456
 811  01c4 cd0000        	call	c_itolx
 813  01c7 be02          	ldw	x,c_lreg+2
 814  01c9 89            	pushw	x
 815  01ca be00          	ldw	x,c_lreg
 816  01cc 89            	pushw	x
 817  01cd cd0000        	call	_WIZCHIP_READ
 819  01d0 5b04          	addw	sp,#4
 820  01d2 6b01          	ld	(OFST-4,sp),a
 822  01d4 1e04          	ldw	x,(OFST-1,sp)
 823  01d6 4f            	clr	a
 824  01d7 02            	rlwa	x,a
 825  01d8 01            	rrwa	x,a
 826  01d9 1b01          	add	a,(OFST-4,sp)
 827  01db 2401          	jrnc	L61
 828  01dd 5c            	incw	x
 829  01de               L61:
 830  01de 02            	rlwa	x,a
 831  01df 1f04          	ldw	(OFST-1,sp),x
 832  01e1 01            	rrwa	x,a
 834                     ; 142       if (val1 != 0)
 836  01e2 1e04          	ldw	x,(OFST-1,sp)
 837  01e4 2748          	jreq	L552
 838                     ; 144         val = WIZCHIP_READ(Sn_TX_FSR(sn));
 840  01e6 7b06          	ld	a,(OFST+1,sp)
 841  01e8 97            	ld	xl,a
 842  01e9 a604          	ld	a,#4
 843  01eb 42            	mul	x,a
 844  01ec 58            	sllw	x
 845  01ed 58            	sllw	x
 846  01ee 58            	sllw	x
 847  01ef 1c2008        	addw	x,#8200
 848  01f2 cd0000        	call	c_itolx
 850  01f5 be02          	ldw	x,c_lreg+2
 851  01f7 89            	pushw	x
 852  01f8 be00          	ldw	x,c_lreg
 853  01fa 89            	pushw	x
 854  01fb cd0000        	call	_WIZCHIP_READ
 856  01fe 5b04          	addw	sp,#4
 857  0200 5f            	clrw	x
 858  0201 97            	ld	xl,a
 859  0202 1f02          	ldw	(OFST-3,sp),x
 861                     ; 145         val = (val << 8) + WIZCHIP_READ(WIZCHIP_OFFSET_INC(Sn_TX_FSR(sn),1));
 863  0204 7b06          	ld	a,(OFST+1,sp)
 864  0206 97            	ld	xl,a
 865  0207 a604          	ld	a,#4
 866  0209 42            	mul	x,a
 867  020a 58            	sllw	x
 868  020b 58            	sllw	x
 869  020c 58            	sllw	x
 870  020d 1c2108        	addw	x,#8456
 871  0210 cd0000        	call	c_itolx
 873  0213 be02          	ldw	x,c_lreg+2
 874  0215 89            	pushw	x
 875  0216 be00          	ldw	x,c_lreg
 876  0218 89            	pushw	x
 877  0219 cd0000        	call	_WIZCHIP_READ
 879  021c 5b04          	addw	sp,#4
 880  021e 6b01          	ld	(OFST-4,sp),a
 882  0220 1e02          	ldw	x,(OFST-3,sp)
 883  0222 4f            	clr	a
 884  0223 02            	rlwa	x,a
 885  0224 01            	rrwa	x,a
 886  0225 1b01          	add	a,(OFST-4,sp)
 887  0227 2401          	jrnc	L02
 888  0229 5c            	incw	x
 889  022a               L02:
 890  022a 02            	rlwa	x,a
 891  022b 1f02          	ldw	(OFST-3,sp),x
 892  022d 01            	rrwa	x,a
 894  022e               L552:
 895                     ; 147    }while (val != val1);
 897  022e 1e02          	ldw	x,(OFST-3,sp)
 898  0230 1304          	cpw	x,(OFST-1,sp)
 899  0232 2703          	jreq	L22
 900  0234 cc019a        	jp	L352
 901  0237               L22:
 902                     ; 148    return val;
 904  0237 1e02          	ldw	x,(OFST-3,sp)
 907  0239 5b06          	addw	sp,#6
 908  023b 81            	ret
 961                     ; 152 uint16_t getSn_RX_RSR(uint8_t sn)
 961                     ; 153 {
 962                     	switch	.text
 963  023c               _getSn_RX_RSR:
 965  023c 88            	push	a
 966  023d 5205          	subw	sp,#5
 967       00000005      OFST:	set	5
 970                     ; 154    uint16_t val=0,val1=0;
 972  023f 5f            	clrw	x
 973  0240 1f02          	ldw	(OFST-3,sp),x
 977  0242               L113:
 978                     ; 158       val1 = WIZCHIP_READ(Sn_RX_RSR(sn));
 980  0242 7b06          	ld	a,(OFST+1,sp)
 981  0244 97            	ld	xl,a
 982  0245 a604          	ld	a,#4
 983  0247 42            	mul	x,a
 984  0248 58            	sllw	x
 985  0249 58            	sllw	x
 986  024a 58            	sllw	x
 987  024b 1c2608        	addw	x,#9736
 988  024e cd0000        	call	c_itolx
 990  0251 be02          	ldw	x,c_lreg+2
 991  0253 89            	pushw	x
 992  0254 be00          	ldw	x,c_lreg
 993  0256 89            	pushw	x
 994  0257 cd0000        	call	_WIZCHIP_READ
 996  025a 5b04          	addw	sp,#4
 997  025c 5f            	clrw	x
 998  025d 97            	ld	xl,a
 999  025e 1f04          	ldw	(OFST-1,sp),x
1001                     ; 159       val1 = (val1 << 8) + WIZCHIP_READ(WIZCHIP_OFFSET_INC(Sn_RX_RSR(sn),1));
1003  0260 7b06          	ld	a,(OFST+1,sp)
1004  0262 97            	ld	xl,a
1005  0263 a604          	ld	a,#4
1006  0265 42            	mul	x,a
1007  0266 58            	sllw	x
1008  0267 58            	sllw	x
1009  0268 58            	sllw	x
1010  0269 1c2708        	addw	x,#9992
1011  026c cd0000        	call	c_itolx
1013  026f be02          	ldw	x,c_lreg+2
1014  0271 89            	pushw	x
1015  0272 be00          	ldw	x,c_lreg
1016  0274 89            	pushw	x
1017  0275 cd0000        	call	_WIZCHIP_READ
1019  0278 5b04          	addw	sp,#4
1020  027a 6b01          	ld	(OFST-4,sp),a
1022  027c 1e04          	ldw	x,(OFST-1,sp)
1023  027e 4f            	clr	a
1024  027f 02            	rlwa	x,a
1025  0280 01            	rrwa	x,a
1026  0281 1b01          	add	a,(OFST-4,sp)
1027  0283 2401          	jrnc	L62
1028  0285 5c            	incw	x
1029  0286               L62:
1030  0286 02            	rlwa	x,a
1031  0287 1f04          	ldw	(OFST-1,sp),x
1032  0289 01            	rrwa	x,a
1034                     ; 160       if (val1 != 0)
1036  028a 1e04          	ldw	x,(OFST-1,sp)
1037  028c 2748          	jreq	L313
1038                     ; 162         val = WIZCHIP_READ(Sn_RX_RSR(sn));
1040  028e 7b06          	ld	a,(OFST+1,sp)
1041  0290 97            	ld	xl,a
1042  0291 a604          	ld	a,#4
1043  0293 42            	mul	x,a
1044  0294 58            	sllw	x
1045  0295 58            	sllw	x
1046  0296 58            	sllw	x
1047  0297 1c2608        	addw	x,#9736
1048  029a cd0000        	call	c_itolx
1050  029d be02          	ldw	x,c_lreg+2
1051  029f 89            	pushw	x
1052  02a0 be00          	ldw	x,c_lreg
1053  02a2 89            	pushw	x
1054  02a3 cd0000        	call	_WIZCHIP_READ
1056  02a6 5b04          	addw	sp,#4
1057  02a8 5f            	clrw	x
1058  02a9 97            	ld	xl,a
1059  02aa 1f02          	ldw	(OFST-3,sp),x
1061                     ; 163         val = (val << 8) + WIZCHIP_READ(WIZCHIP_OFFSET_INC(Sn_RX_RSR(sn),1));
1063  02ac 7b06          	ld	a,(OFST+1,sp)
1064  02ae 97            	ld	xl,a
1065  02af a604          	ld	a,#4
1066  02b1 42            	mul	x,a
1067  02b2 58            	sllw	x
1068  02b3 58            	sllw	x
1069  02b4 58            	sllw	x
1070  02b5 1c2708        	addw	x,#9992
1071  02b8 cd0000        	call	c_itolx
1073  02bb be02          	ldw	x,c_lreg+2
1074  02bd 89            	pushw	x
1075  02be be00          	ldw	x,c_lreg
1076  02c0 89            	pushw	x
1077  02c1 cd0000        	call	_WIZCHIP_READ
1079  02c4 5b04          	addw	sp,#4
1080  02c6 6b01          	ld	(OFST-4,sp),a
1082  02c8 1e02          	ldw	x,(OFST-3,sp)
1083  02ca 4f            	clr	a
1084  02cb 02            	rlwa	x,a
1085  02cc 01            	rrwa	x,a
1086  02cd 1b01          	add	a,(OFST-4,sp)
1087  02cf 2401          	jrnc	L03
1088  02d1 5c            	incw	x
1089  02d2               L03:
1090  02d2 02            	rlwa	x,a
1091  02d3 1f02          	ldw	(OFST-3,sp),x
1092  02d5 01            	rrwa	x,a
1094  02d6               L313:
1095                     ; 165    }while (val != val1);
1097  02d6 1e02          	ldw	x,(OFST-3,sp)
1098  02d8 1304          	cpw	x,(OFST-1,sp)
1099  02da 2703          	jreq	L23
1100  02dc cc0242        	jp	L113
1101  02df               L23:
1102                     ; 166    return val;
1104  02df 1e02          	ldw	x,(OFST-3,sp)
1107  02e1 5b06          	addw	sp,#6
1108  02e3 81            	ret
1121                     	xdef	_getSn_RX_RSR
1122                     	xdef	_getSn_TX_FSR
1123                     	xdef	_WIZCHIP_WRITE_BUF
1124                     	xdef	_WIZCHIP_READ_BUF
1125                     	xdef	_WIZCHIP_WRITE
1126                     	xdef	_WIZCHIP_READ
1127                     	xref.b	_WIZCHIP
1128                     	xref.b	c_lreg
1147                     	xref	c_itolx
1148                     	end
