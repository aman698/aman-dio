   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  42                     ; 4 void 	  wizchip_cris_enter(void)           {}
  44                     	switch	.text
  45  0000               _wizchip_cris_enter:
  52  0000 81            	ret
  75                     ; 5 void 	  wizchip_cris_exit(void)          {}
  76                     	switch	.text
  77  0001               _wizchip_cris_exit:
  84  0001 81            	ret
 107                     ; 6 void 	wizchip_cs_select(void)            {}
 108                     	switch	.text
 109  0002               _wizchip_cs_select:
 116  0002 81            	ret
 140                     ; 7 void 	wizchip_cs_deselect(void)          {}
 141                     	switch	.text
 142  0003               _wizchip_cs_deselect:
 149  0003 81            	ret
 184                     ; 8 iodata_t wizchip_bus_readdata(uint32_t AddrSel) { return * ((volatile iodata_t *)((ptrdiff_t) AddrSel)); }
 185                     	switch	.text
 186  0004               _wizchip_bus_readdata:
 188       00000000      OFST:	set	0
 193  0004 1e05          	ldw	x,(OFST+5,sp)
 194  0006 f6            	ld	a,(x)
 197  0007 81            	ret
 241                     ; 9 void 	wizchip_bus_writedata(uint32_t AddrSel, iodata_t wb)  { *((volatile iodata_t*)((ptrdiff_t)AddrSel)) = wb; }
 242                     	switch	.text
 243  0008               _wizchip_bus_writedata:
 245       00000000      OFST:	set	0
 250  0008 7b07          	ld	a,(OFST+7,sp)
 251  000a 1e05          	ldw	x,(OFST+5,sp)
 252  000c f7            	ld	(x),a
 256  000d 81            	ret
 280                     ; 10 uint8_t wizchip_spi_readbyte(void)        {return 0;}
 281                     	switch	.text
 282  000e               _wizchip_spi_readbyte:
 288  000e 4f            	clr	a
 291  000f 81            	ret
 326                     ; 11 void 	wizchip_spi_writebyte(uint8_t wb) {}
 327                     	switch	.text
 328  0010               _wizchip_spi_writebyte:
 335  0010 81            	ret
 371                     ; 12 void 	wizchip_spi_readburst(uint8_t* pBuf, uint16_t len) 	{}
 372                     	switch	.text
 373  0011               _wizchip_spi_readburst:
 380  0011 81            	ret
 416                     ; 13 void 	wizchip_spi_writeburst(uint8_t* pBuf, uint16_t len) {}
 417                     	switch	.text
 418  0012               _wizchip_spi_writeburst:
 425  0012 81            	ret
 428                     	bsct
 429  0000               _WIZCHIP:
 430  0000 0201          	dc.w	513
 431  0002 57            	dc.b	87
 432  0003 35            	dc.b	53
 433  0004 35            	dc.b	53
 434  0005 30            	dc.b	48
 435  0006 30            	dc.b	48
 436  0007 00            	dc.b	0
 438  0008 0000          	dc.w	_wizchip_cris_enter
 440  000a 0001          	dc.w	_wizchip_cris_exit
 442  000c 0002          	dc.w	_wizchip_cs_select
 444  000e 0003          	dc.w	_wizchip_cs_deselect
 446  0010 0004          	dc.w	_wizchip_bus_readdata
 448  0012 0008          	dc.w	_wizchip_bus_writedata
 449  0014 00000000      	ds.b	4
 500                     ; 28 void reg_wizchip_cs_cbfunc(void(*cs_sel)(void), void(*cs_desel)(void))
 500                     ; 29 {
 501                     	switch	.text
 502  0013               _reg_wizchip_cs_cbfunc:
 504  0013 89            	pushw	x
 505       00000000      OFST:	set	0
 508                     ; 30    if(!cs_sel || !cs_desel)
 510  0014 a30000        	cpw	x,#0
 511  0017 2704          	jreq	L712
 513  0019 1e05          	ldw	x,(OFST+5,sp)
 514  001b 260c          	jrne	L512
 515  001d               L712:
 516                     ; 32       WIZCHIP.CS._select   = wizchip_cs_select;
 518  001d ae0002        	ldw	x,#_wizchip_cs_select
 519  0020 bf0c          	ldw	_WIZCHIP+12,x
 520                     ; 33       WIZCHIP.CS._deselect = wizchip_cs_deselect;
 522  0022 ae0003        	ldw	x,#_wizchip_cs_deselect
 523  0025 bf0e          	ldw	_WIZCHIP+14,x
 525  0027               L122:
 526                     ; 40 }
 529  0027 85            	popw	x
 530  0028 81            	ret
 531  0029               L512:
 532                     ; 37       WIZCHIP.CS._select   = cs_sel;
 534  0029 1e01          	ldw	x,(OFST+1,sp)
 535  002b bf0c          	ldw	_WIZCHIP+12,x
 536                     ; 38       WIZCHIP.CS._deselect = cs_desel;
 538  002d 1e05          	ldw	x,(OFST+5,sp)
 539  002f bf0e          	ldw	_WIZCHIP+14,x
 540  0031 20f4          	jra	L122
 593                     ; 45 void reg_wizchip_spi_cbfunc(uint8_t (*spi_rb)(void), void (*spi_wb)(uint8_t wb))
 593                     ; 46 {
 594                     	switch	.text
 595  0033               _reg_wizchip_spi_cbfunc:
 597  0033 89            	pushw	x
 598       00000000      OFST:	set	0
 601  0034               L352:
 602                     ; 47    while(!(WIZCHIP.if_mode & _WIZCHIP_IO_MODE_SPI_));
 604  0034 b600          	ld	a,_WIZCHIP
 605  0036 a502          	bcp	a,#2
 606  0038 27fa          	jreq	L352
 607                     ; 49    if(!spi_rb || !spi_wb)
 609  003a 1e01          	ldw	x,(OFST+1,sp)
 610  003c 2704          	jreq	L162
 612  003e 1e05          	ldw	x,(OFST+5,sp)
 613  0040 260c          	jrne	L752
 614  0042               L162:
 615                     ; 51       WIZCHIP.IF._SPI._read_byte   = wizchip_spi_readbyte;
 617  0042 ae000e        	ldw	x,#_wizchip_spi_readbyte
 618  0045 bf10          	ldw	_WIZCHIP+16,x
 619                     ; 52       WIZCHIP.IF._SPI._write_byte  = wizchip_spi_writebyte;
 621  0047 ae0010        	ldw	x,#_wizchip_spi_writebyte
 622  004a bf12          	ldw	_WIZCHIP+18,x
 624  004c               L362:
 625                     ; 59 }
 628  004c 85            	popw	x
 629  004d 81            	ret
 630  004e               L752:
 631                     ; 56       WIZCHIP.IF._SPI._read_byte   = spi_rb;
 633  004e 1e01          	ldw	x,(OFST+1,sp)
 634  0050 bf10          	ldw	_WIZCHIP+16,x
 635                     ; 57       WIZCHIP.IF._SPI._write_byte  = spi_wb;
 637  0052 1e05          	ldw	x,(OFST+5,sp)
 638  0054 bf12          	ldw	_WIZCHIP+18,x
 639  0056 20f4          	jra	L362
 692                     ; 62 void reg_wizchip_spiburst_cbfunc(void (*spi_rb)(uint8_t* pBuf, uint16_t len), void (*spi_wb)(uint8_t* pBuf, uint16_t len))
 692                     ; 63 {
 693                     	switch	.text
 694  0058               _reg_wizchip_spiburst_cbfunc:
 696  0058 89            	pushw	x
 697       00000000      OFST:	set	0
 700  0059               L113:
 701                     ; 64    while(!(WIZCHIP.if_mode & _WIZCHIP_IO_MODE_SPI_));
 703  0059 b600          	ld	a,_WIZCHIP
 704  005b a502          	bcp	a,#2
 705  005d 27fa          	jreq	L113
 706                     ; 66    if(!spi_rb || !spi_wb)
 708  005f 1e01          	ldw	x,(OFST+1,sp)
 709  0061 2704          	jreq	L713
 711  0063 1e05          	ldw	x,(OFST+5,sp)
 712  0065 260c          	jrne	L513
 713  0067               L713:
 714                     ; 68       WIZCHIP.IF._SPI._read_burst   = wizchip_spi_readburst;
 716  0067 ae0011        	ldw	x,#_wizchip_spi_readburst
 717  006a bf14          	ldw	_WIZCHIP+20,x
 718                     ; 69       WIZCHIP.IF._SPI._write_burst  = wizchip_spi_writeburst;
 720  006c ae0012        	ldw	x,#_wizchip_spi_writeburst
 721  006f bf16          	ldw	_WIZCHIP+22,x
 723  0071               L123:
 724                     ; 76 }
 727  0071 85            	popw	x
 728  0072 81            	ret
 729  0073               L513:
 730                     ; 73       WIZCHIP.IF._SPI._read_burst   = spi_rb;
 732  0073 1e01          	ldw	x,(OFST+1,sp)
 733  0075 bf14          	ldw	_WIZCHIP+20,x
 734                     ; 74       WIZCHIP.IF._SPI._write_burst  = spi_wb;
 736  0077 1e05          	ldw	x,(OFST+5,sp)
 737  0079 bf16          	ldw	_WIZCHIP+22,x
 738  007b 20f4          	jra	L123
 807                     ; 78 void wizchip_sw_reset(void)
 807                     ; 79 {
 808                     	switch	.text
 809  007d               _wizchip_sw_reset:
 811  007d 5212          	subw	sp,#18
 812       00000012      OFST:	set	18
 815                     ; 88    getSHAR(mac);
 817  007f ae0006        	ldw	x,#6
 818  0082 89            	pushw	x
 819  0083 96            	ldw	x,sp
 820  0084 1c000f        	addw	x,#OFST-3
 821  0087 89            	pushw	x
 822  0088 ae0900        	ldw	x,#2304
 823  008b 89            	pushw	x
 824  008c ae0000        	ldw	x,#0
 825  008f 89            	pushw	x
 826  0090 cd0000        	call	_WIZCHIP_READ_BUF
 828  0093 5b08          	addw	sp,#8
 829                     ; 89    getGAR(gw);  getSUBR(sn);  getSIPR(sip);
 831  0095 ae0004        	ldw	x,#4
 832  0098 89            	pushw	x
 833  0099 96            	ldw	x,sp
 834  009a 1c0003        	addw	x,#OFST-15
 835  009d 89            	pushw	x
 836  009e ae0100        	ldw	x,#256
 837  00a1 89            	pushw	x
 838  00a2 ae0000        	ldw	x,#0
 839  00a5 89            	pushw	x
 840  00a6 cd0000        	call	_WIZCHIP_READ_BUF
 842  00a9 5b08          	addw	sp,#8
 845  00ab ae0004        	ldw	x,#4
 846  00ae 89            	pushw	x
 847  00af 96            	ldw	x,sp
 848  00b0 1c0007        	addw	x,#OFST-11
 849  00b3 89            	pushw	x
 850  00b4 ae0500        	ldw	x,#1280
 851  00b7 89            	pushw	x
 852  00b8 ae0000        	ldw	x,#0
 853  00bb 89            	pushw	x
 854  00bc cd0000        	call	_WIZCHIP_READ_BUF
 856  00bf 5b08          	addw	sp,#8
 859  00c1 ae0004        	ldw	x,#4
 860  00c4 89            	pushw	x
 861  00c5 96            	ldw	x,sp
 862  00c6 1c000b        	addw	x,#OFST-7
 863  00c9 89            	pushw	x
 864  00ca ae0f00        	ldw	x,#3840
 865  00cd 89            	pushw	x
 866  00ce ae0000        	ldw	x,#0
 867  00d1 89            	pushw	x
 868  00d2 cd0000        	call	_WIZCHIP_READ_BUF
 870  00d5 5b08          	addw	sp,#8
 871                     ; 90    setMR(MR_RST);
 873  00d7 4b80          	push	#128
 874  00d9 ae0000        	ldw	x,#0
 875  00dc 89            	pushw	x
 876  00dd ae0000        	ldw	x,#0
 877  00e0 89            	pushw	x
 878  00e1 cd0000        	call	_WIZCHIP_WRITE
 880  00e4 5b05          	addw	sp,#5
 881                     ; 91    getMR(); // for delay
 883  00e6 ae0000        	ldw	x,#0
 884  00e9 89            	pushw	x
 885  00ea ae0000        	ldw	x,#0
 886  00ed 89            	pushw	x
 887  00ee cd0000        	call	_WIZCHIP_READ
 889  00f1 5b04          	addw	sp,#4
 890                     ; 97    setSHAR(mac);
 892  00f3 ae0006        	ldw	x,#6
 893  00f6 89            	pushw	x
 894  00f7 96            	ldw	x,sp
 895  00f8 1c000f        	addw	x,#OFST-3
 896  00fb 89            	pushw	x
 897  00fc ae0900        	ldw	x,#2304
 898  00ff 89            	pushw	x
 899  0100 ae0000        	ldw	x,#0
 900  0103 89            	pushw	x
 901  0104 cd0000        	call	_WIZCHIP_WRITE_BUF
 903  0107 5b08          	addw	sp,#8
 904                     ; 98    setGAR(gw);
 906  0109 ae0004        	ldw	x,#4
 907  010c 89            	pushw	x
 908  010d 96            	ldw	x,sp
 909  010e 1c0003        	addw	x,#OFST-15
 910  0111 89            	pushw	x
 911  0112 ae0100        	ldw	x,#256
 912  0115 89            	pushw	x
 913  0116 ae0000        	ldw	x,#0
 914  0119 89            	pushw	x
 915  011a cd0000        	call	_WIZCHIP_WRITE_BUF
 917  011d 5b08          	addw	sp,#8
 918                     ; 99    setSUBR(sn);
 920  011f ae0004        	ldw	x,#4
 921  0122 89            	pushw	x
 922  0123 96            	ldw	x,sp
 923  0124 1c0007        	addw	x,#OFST-11
 924  0127 89            	pushw	x
 925  0128 ae0500        	ldw	x,#1280
 926  012b 89            	pushw	x
 927  012c ae0000        	ldw	x,#0
 928  012f 89            	pushw	x
 929  0130 cd0000        	call	_WIZCHIP_WRITE_BUF
 931  0133 5b08          	addw	sp,#8
 932                     ; 100    setSIPR(sip);
 934  0135 ae0004        	ldw	x,#4
 935  0138 89            	pushw	x
 936  0139 96            	ldw	x,sp
 937  013a 1c000b        	addw	x,#OFST-7
 938  013d 89            	pushw	x
 939  013e ae0f00        	ldw	x,#3840
 940  0141 89            	pushw	x
 941  0142 ae0000        	ldw	x,#0
 942  0145 89            	pushw	x
 943  0146 cd0000        	call	_WIZCHIP_WRITE_BUF
 945  0149 5b08          	addw	sp,#8
 946                     ; 101 }
 949  014b 5b12          	addw	sp,#18
 950  014d 81            	ret
1015                     ; 103 int8_t wizchip_init(uint8_t* txsize, uint8_t* rxsize)
1015                     ; 104 {
1016                     	switch	.text
1017  014e               _wizchip_init:
1019  014e 89            	pushw	x
1020  014f 89            	pushw	x
1021       00000002      OFST:	set	2
1024                     ; 106    int8_t tmp = 0;
1026                     ; 107    wizchip_sw_reset();
1028  0150 cd007d        	call	_wizchip_sw_reset
1030                     ; 108    if(txsize)
1032  0153 1e03          	ldw	x,(OFST+1,sp)
1033  0155 275e          	jreq	L704
1034                     ; 110       tmp = 0;
1036  0157 0f01          	clr	(OFST-1,sp)
1038                     ; 112       for(i = 0 ; i < _WIZCHIP_SOCK_NUM_; i++)
1040  0159 0f02          	clr	(OFST+0,sp)
1042  015b               L114:
1043                     ; 114          tmp += txsize[i];
1045  015b 7b02          	ld	a,(OFST+0,sp)
1046  015d 5f            	clrw	x
1047  015e 4d            	tnz	a
1048  015f 2a01          	jrpl	L24
1049  0161 53            	cplw	x
1050  0162               L24:
1051  0162 97            	ld	xl,a
1052  0163 72fb03        	addw	x,(OFST+1,sp)
1053  0166 7b01          	ld	a,(OFST-1,sp)
1054  0168 fb            	add	a,(x)
1055  0169 6b01          	ld	(OFST-1,sp),a
1057                     ; 115          if(tmp > 16) return -1;
1059  016b 9c            	rvf
1060  016c 7b01          	ld	a,(OFST-1,sp)
1061  016e a111          	cp	a,#17
1062  0170 2f04          	jrslt	L714
1065  0172 a6ff          	ld	a,#255
1067  0174 2060          	jra	L65
1068  0176               L714:
1069                     ; 112       for(i = 0 ; i < _WIZCHIP_SOCK_NUM_; i++)
1071  0176 0c02          	inc	(OFST+0,sp)
1075  0178 9c            	rvf
1076  0179 7b02          	ld	a,(OFST+0,sp)
1077  017b a108          	cp	a,#8
1078  017d 2fdc          	jrslt	L114
1079                     ; 117       for(i = 0 ; i < _WIZCHIP_SOCK_NUM_; i++)
1081  017f 0f02          	clr	(OFST+0,sp)
1083  0181               L124:
1084                     ; 118          setSn_TXBUF_SIZE(i, txsize[i]);
1086  0181 7b02          	ld	a,(OFST+0,sp)
1087  0183 5f            	clrw	x
1088  0184 4d            	tnz	a
1089  0185 2a01          	jrpl	L44
1090  0187 53            	cplw	x
1091  0188               L44:
1092  0188 97            	ld	xl,a
1093  0189 72fb03        	addw	x,(OFST+1,sp)
1094  018c f6            	ld	a,(x)
1095  018d 88            	push	a
1096  018e 7b03          	ld	a,(OFST+1,sp)
1097  0190 5f            	clrw	x
1098  0191 4d            	tnz	a
1099  0192 2a01          	jrpl	L64
1100  0194 53            	cplw	x
1101  0195               L64:
1102  0195 97            	ld	xl,a
1103  0196 58            	sllw	x
1104  0197 58            	sllw	x
1105  0198 58            	sllw	x
1106  0199 58            	sllw	x
1107  019a 58            	sllw	x
1108  019b 1c1f08        	addw	x,#7944
1109  019e cd0000        	call	c_itolx
1111  01a1 be02          	ldw	x,c_lreg+2
1112  01a3 89            	pushw	x
1113  01a4 be00          	ldw	x,c_lreg
1114  01a6 89            	pushw	x
1115  01a7 cd0000        	call	_WIZCHIP_WRITE
1117  01aa 5b05          	addw	sp,#5
1118                     ; 117       for(i = 0 ; i < _WIZCHIP_SOCK_NUM_; i++)
1120  01ac 0c02          	inc	(OFST+0,sp)
1124  01ae 9c            	rvf
1125  01af 7b02          	ld	a,(OFST+0,sp)
1126  01b1 a108          	cp	a,#8
1127  01b3 2fcc          	jrslt	L124
1128  01b5               L704:
1129                     ; 120    if(rxsize)
1131  01b5 1e07          	ldw	x,(OFST+5,sp)
1132  01b7 275f          	jreq	L724
1133                     ; 122       tmp = 0;        
1135  01b9 0f01          	clr	(OFST-1,sp)
1137                     ; 123       for(i = 0 ; i < _WIZCHIP_SOCK_NUM_; i++)
1139  01bb 0f02          	clr	(OFST+0,sp)
1141  01bd               L134:
1142                     ; 125          tmp += rxsize[i];
1144  01bd 7b02          	ld	a,(OFST+0,sp)
1145  01bf 5f            	clrw	x
1146  01c0 4d            	tnz	a
1147  01c1 2a01          	jrpl	L05
1148  01c3 53            	cplw	x
1149  01c4               L05:
1150  01c4 97            	ld	xl,a
1151  01c5 72fb07        	addw	x,(OFST+5,sp)
1152  01c8 7b01          	ld	a,(OFST-1,sp)
1153  01ca fb            	add	a,(x)
1154  01cb 6b01          	ld	(OFST-1,sp),a
1156                     ; 126          if(tmp > 16) return -1;
1158  01cd 9c            	rvf
1159  01ce 7b01          	ld	a,(OFST-1,sp)
1160  01d0 a111          	cp	a,#17
1161  01d2 2f05          	jrslt	L734
1164  01d4 a6ff          	ld	a,#255
1166  01d6               L65:
1168  01d6 5b04          	addw	sp,#4
1169  01d8 81            	ret
1170  01d9               L734:
1171                     ; 123       for(i = 0 ; i < _WIZCHIP_SOCK_NUM_; i++)
1173  01d9 0c02          	inc	(OFST+0,sp)
1177  01db 9c            	rvf
1178  01dc 7b02          	ld	a,(OFST+0,sp)
1179  01de a108          	cp	a,#8
1180  01e0 2fdb          	jrslt	L134
1181                     ; 128       for(i = 0 ; i < _WIZCHIP_SOCK_NUM_; i++)
1183  01e2 0f02          	clr	(OFST+0,sp)
1185  01e4               L144:
1186                     ; 129          setSn_RXBUF_SIZE(i, rxsize[i]);
1188  01e4 7b02          	ld	a,(OFST+0,sp)
1189  01e6 5f            	clrw	x
1190  01e7 4d            	tnz	a
1191  01e8 2a01          	jrpl	L25
1192  01ea 53            	cplw	x
1193  01eb               L25:
1194  01eb 97            	ld	xl,a
1195  01ec 72fb07        	addw	x,(OFST+5,sp)
1196  01ef f6            	ld	a,(x)
1197  01f0 88            	push	a
1198  01f1 7b03          	ld	a,(OFST+1,sp)
1199  01f3 5f            	clrw	x
1200  01f4 4d            	tnz	a
1201  01f5 2a01          	jrpl	L45
1202  01f7 53            	cplw	x
1203  01f8               L45:
1204  01f8 97            	ld	xl,a
1205  01f9 58            	sllw	x
1206  01fa 58            	sllw	x
1207  01fb 58            	sllw	x
1208  01fc 58            	sllw	x
1209  01fd 58            	sllw	x
1210  01fe 1c1e08        	addw	x,#7688
1211  0201 cd0000        	call	c_itolx
1213  0204 be02          	ldw	x,c_lreg+2
1214  0206 89            	pushw	x
1215  0207 be00          	ldw	x,c_lreg
1216  0209 89            	pushw	x
1217  020a cd0000        	call	_WIZCHIP_WRITE
1219  020d 5b05          	addw	sp,#5
1220                     ; 128       for(i = 0 ; i < _WIZCHIP_SOCK_NUM_; i++)
1222  020f 0c02          	inc	(OFST+0,sp)
1226  0211 9c            	rvf
1227  0212 7b02          	ld	a,(OFST+0,sp)
1228  0214 a108          	cp	a,#8
1229  0216 2fcc          	jrslt	L144
1230  0218               L724:
1231                     ; 131    return 0;
1233  0218 4f            	clr	a
1235  0219 20bb          	jra	L65
1479                     	xdef	_wizchip_spi_writeburst
1480                     	xdef	_wizchip_spi_readburst
1481                     	xdef	_wizchip_spi_writebyte
1482                     	xdef	_wizchip_spi_readbyte
1483                     	xdef	_wizchip_bus_writedata
1484                     	xdef	_wizchip_bus_readdata
1485                     	xdef	_wizchip_cs_deselect
1486                     	xdef	_wizchip_cs_select
1487                     	xdef	_wizchip_cris_exit
1488                     	xdef	_wizchip_cris_enter
1489                     	xdef	_wizchip_init
1490                     	xdef	_wizchip_sw_reset
1491                     	xdef	_reg_wizchip_spiburst_cbfunc
1492                     	xdef	_reg_wizchip_cs_cbfunc
1493                     	xdef	_reg_wizchip_spi_cbfunc
1494                     	xdef	_WIZCHIP
1495                     	xref	_WIZCHIP_WRITE_BUF
1496                     	xref	_WIZCHIP_READ_BUF
1497                     	xref	_WIZCHIP_WRITE
1498                     	xref	_WIZCHIP_READ
1499                     	xref.b	c_lreg
1518                     	xref	c_itolx
1519                     	end
