   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  42                     ; 67 void 	  wizchip_cris_enter(void)           {}
  44                     	switch	.text
  45  0000               _wizchip_cris_enter:
  52  0000 81            	ret
  75                     ; 75 void 	  wizchip_cris_exit(void)          {}
  76                     	switch	.text
  77  0001               _wizchip_cris_exit:
  84  0001 81            	ret
 107                     ; 83 void 	wizchip_cs_select(void)            {}
 108                     	switch	.text
 109  0002               _wizchip_cs_select:
 116  0002 81            	ret
 140                     ; 91 void 	wizchip_cs_deselect(void)          {}
 141                     	switch	.text
 142  0003               _wizchip_cs_deselect:
 149  0003 81            	ret
 184                     ; 100 iodata_t wizchip_bus_readdata(uint32_t AddrSel) { return * ((volatile iodata_t *)((ptrdiff_t) AddrSel)); }
 185                     	switch	.text
 186  0004               _wizchip_bus_readdata:
 188       00000000      OFST:	set	0
 193  0004 1e05          	ldw	x,(OFST+5,sp)
 194  0006 f6            	ld	a,(x)
 197  0007 81            	ret
 241                     ; 109 void 	wizchip_bus_writedata(uint32_t AddrSel, iodata_t wb)  { *((volatile iodata_t*)((ptrdiff_t)AddrSel)) = wb; }
 242                     	switch	.text
 243  0008               _wizchip_bus_writedata:
 245       00000000      OFST:	set	0
 250  0008 7b07          	ld	a,(OFST+7,sp)
 251  000a 1e05          	ldw	x,(OFST+5,sp)
 252  000c f7            	ld	(x),a
 256  000d 81            	ret
 280                     ; 117 uint8_t wizchip_spi_readbyte(void)        {return 0;}
 281                     	switch	.text
 282  000e               _wizchip_spi_readbyte:
 288  000e 4f            	clr	a
 291  000f 81            	ret
 326                     ; 125 void 	wizchip_spi_writebyte(uint8_t wb) {}
 327                     	switch	.text
 328  0010               _wizchip_spi_writebyte:
 335  0010 81            	ret
 371                     ; 133 void 	wizchip_spi_readburst(uint8_t* pBuf, uint16_t len) 	{}
 372                     	switch	.text
 373  0011               _wizchip_spi_readburst:
 380  0011 81            	ret
 416                     ; 141 void 	wizchip_spi_writeburst(uint8_t* pBuf, uint16_t len) {}
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
 500                     ; 186 void reg_wizchip_cris_cbfunc(void(*cris_en)(void), void(*cris_ex)(void))
 500                     ; 187 {
 501                     	switch	.text
 502  0013               _reg_wizchip_cris_cbfunc:
 504  0013 89            	pushw	x
 505       00000000      OFST:	set	0
 508                     ; 188    if(!cris_en || !cris_ex)
 510  0014 a30000        	cpw	x,#0
 511  0017 2704          	jreq	L322
 513  0019 1e05          	ldw	x,(OFST+5,sp)
 514  001b 260c          	jrne	L122
 515  001d               L322:
 516                     ; 190       WIZCHIP.CRIS._enter = wizchip_cris_enter;
 518  001d ae0000        	ldw	x,#_wizchip_cris_enter
 519  0020 bf08          	ldw	_WIZCHIP+8,x
 520                     ; 191       WIZCHIP.CRIS._exit  = wizchip_cris_exit;
 522  0022 ae0001        	ldw	x,#_wizchip_cris_exit
 523  0025 bf0a          	ldw	_WIZCHIP+10,x
 525  0027               L522:
 526                     ; 198 }
 529  0027 85            	popw	x
 530  0028 81            	ret
 531  0029               L122:
 532                     ; 195       WIZCHIP.CRIS._enter = cris_en;
 534  0029 1e01          	ldw	x,(OFST+1,sp)
 535  002b bf08          	ldw	_WIZCHIP+8,x
 536                     ; 196       WIZCHIP.CRIS._exit  = cris_ex;
 538  002d 1e05          	ldw	x,(OFST+5,sp)
 539  002f bf0a          	ldw	_WIZCHIP+10,x
 540  0031 20f4          	jra	L522
 593                     ; 200 void reg_wizchip_cs_cbfunc(void(*cs_sel)(void), void(*cs_desel)(void))
 593                     ; 201 {
 594                     	switch	.text
 595  0033               _reg_wizchip_cs_cbfunc:
 597  0033 89            	pushw	x
 598       00000000      OFST:	set	0
 601                     ; 202    if(!cs_sel || !cs_desel)
 603  0034 a30000        	cpw	x,#0
 604  0037 2704          	jreq	L352
 606  0039 1e05          	ldw	x,(OFST+5,sp)
 607  003b 260c          	jrne	L152
 608  003d               L352:
 609                     ; 204       WIZCHIP.CS._select   = wizchip_cs_select;
 611  003d ae0002        	ldw	x,#_wizchip_cs_select
 612  0040 bf0c          	ldw	_WIZCHIP+12,x
 613                     ; 205       WIZCHIP.CS._deselect = wizchip_cs_deselect;
 615  0042 ae0003        	ldw	x,#_wizchip_cs_deselect
 616  0045 bf0e          	ldw	_WIZCHIP+14,x
 618  0047               L552:
 619                     ; 212 }
 622  0047 85            	popw	x
 623  0048 81            	ret
 624  0049               L152:
 625                     ; 209       WIZCHIP.CS._select   = cs_sel;
 627  0049 1e01          	ldw	x,(OFST+1,sp)
 628  004b bf0c          	ldw	_WIZCHIP+12,x
 629                     ; 210       WIZCHIP.CS._deselect = cs_desel;
 631  004d 1e05          	ldw	x,(OFST+5,sp)
 632  004f bf0e          	ldw	_WIZCHIP+14,x
 633  0051 20f4          	jra	L552
 686                     ; 216 void reg_wizchip_bus_cbfunc(iodata_t(*bus_rb)(uint32_t addr), void (*bus_wb)(uint32_t addr, iodata_t wb))
 686                     ; 217 {
 687                     	switch	.text
 688  0053               _reg_wizchip_bus_cbfunc:
 690  0053 89            	pushw	x
 691       00000000      OFST:	set	0
 694  0054               L303:
 695                     ; 218    while(!(WIZCHIP.if_mode & _WIZCHIP_IO_MODE_BUS_));
 697  0054 b600          	ld	a,_WIZCHIP
 698  0056 a501          	bcp	a,#1
 699  0058 27fa          	jreq	L303
 700                     ; 232    if(!bus_rb || !bus_wb)
 702  005a 1e01          	ldw	x,(OFST+1,sp)
 703  005c 2704          	jreq	L113
 705  005e 1e05          	ldw	x,(OFST+5,sp)
 706  0060 260c          	jrne	L703
 707  0062               L113:
 708                     ; 234       WIZCHIP.IF.BUS._read_data   = wizchip_bus_readdata;
 710  0062 ae0004        	ldw	x,#_wizchip_bus_readdata
 711  0065 bf10          	ldw	_WIZCHIP+16,x
 712                     ; 235       WIZCHIP.IF.BUS._write_data  = wizchip_bus_writedata;
 714  0067 ae0008        	ldw	x,#_wizchip_bus_writedata
 715  006a bf12          	ldw	_WIZCHIP+18,x
 717  006c               L313:
 718                     ; 242 }
 721  006c 85            	popw	x
 722  006d 81            	ret
 723  006e               L703:
 724                     ; 239       WIZCHIP.IF.BUS._read_data   = bus_rb;
 726  006e 1e01          	ldw	x,(OFST+1,sp)
 727  0070 bf10          	ldw	_WIZCHIP+16,x
 728                     ; 240       WIZCHIP.IF.BUS._write_data  = bus_wb;
 730  0072 1e05          	ldw	x,(OFST+5,sp)
 731  0074 bf12          	ldw	_WIZCHIP+18,x
 732  0076 20f4          	jra	L313
 785                     ; 244 void reg_wizchip_spi_cbfunc(uint8_t (*spi_rb)(void), void (*spi_wb)(uint8_t wb))
 785                     ; 245 {
 786                     	switch	.text
 787  0078               _reg_wizchip_spi_cbfunc:
 789  0078 89            	pushw	x
 790       00000000      OFST:	set	0
 793  0079               L143:
 794                     ; 246    while(!(WIZCHIP.if_mode & _WIZCHIP_IO_MODE_SPI_));
 796  0079 b600          	ld	a,_WIZCHIP
 797  007b a502          	bcp	a,#2
 798  007d 27fa          	jreq	L143
 799                     ; 248    if(!spi_rb || !spi_wb)
 801  007f 1e01          	ldw	x,(OFST+1,sp)
 802  0081 2704          	jreq	L743
 804  0083 1e05          	ldw	x,(OFST+5,sp)
 805  0085 260c          	jrne	L543
 806  0087               L743:
 807                     ; 250       WIZCHIP.IF._SPI._read_byte   = wizchip_spi_readbyte;
 809  0087 ae000e        	ldw	x,#_wizchip_spi_readbyte
 810  008a bf10          	ldw	_WIZCHIP+16,x
 811                     ; 251       WIZCHIP.IF._SPI._write_byte  = wizchip_spi_writebyte;
 813  008c ae0010        	ldw	x,#_wizchip_spi_writebyte
 814  008f bf12          	ldw	_WIZCHIP+18,x
 816  0091               L153:
 817                     ; 258 }
 820  0091 85            	popw	x
 821  0092 81            	ret
 822  0093               L543:
 823                     ; 255       WIZCHIP.IF._SPI._read_byte   = spi_rb;
 825  0093 1e01          	ldw	x,(OFST+1,sp)
 826  0095 bf10          	ldw	_WIZCHIP+16,x
 827                     ; 256       WIZCHIP.IF._SPI._write_byte  = spi_wb;
 829  0097 1e05          	ldw	x,(OFST+5,sp)
 830  0099 bf12          	ldw	_WIZCHIP+18,x
 831  009b 20f4          	jra	L153
 884                     ; 261 void reg_wizchip_spiburst_cbfunc(void (*spi_rb)(uint8_t* pBuf, uint16_t len), void (*spi_wb)(uint8_t* pBuf, uint16_t len))
 884                     ; 262 {
 885                     	switch	.text
 886  009d               _reg_wizchip_spiburst_cbfunc:
 888  009d 89            	pushw	x
 889       00000000      OFST:	set	0
 892  009e               L773:
 893                     ; 263    while(!(WIZCHIP.if_mode & _WIZCHIP_IO_MODE_SPI_));
 895  009e b600          	ld	a,_WIZCHIP
 896  00a0 a502          	bcp	a,#2
 897  00a2 27fa          	jreq	L773
 898                     ; 265    if(!spi_rb || !spi_wb)
 900  00a4 1e01          	ldw	x,(OFST+1,sp)
 901  00a6 2704          	jreq	L504
 903  00a8 1e05          	ldw	x,(OFST+5,sp)
 904  00aa 260c          	jrne	L304
 905  00ac               L504:
 906                     ; 267       WIZCHIP.IF._SPI._read_burst   = wizchip_spi_readburst;
 908  00ac ae0011        	ldw	x,#_wizchip_spi_readburst
 909  00af bf14          	ldw	_WIZCHIP+20,x
 910                     ; 268       WIZCHIP.IF._SPI._write_burst  = wizchip_spi_writeburst;
 912  00b1 ae0012        	ldw	x,#_wizchip_spi_writeburst
 913  00b4 bf16          	ldw	_WIZCHIP+22,x
 915  00b6               L704:
 916                     ; 275 }
 919  00b6 85            	popw	x
 920  00b7 81            	ret
 921  00b8               L304:
 922                     ; 272       WIZCHIP.IF._SPI._read_burst   = spi_rb;
 924  00b8 1e01          	ldw	x,(OFST+1,sp)
 925  00ba bf14          	ldw	_WIZCHIP+20,x
 926                     ; 273       WIZCHIP.IF._SPI._write_burst  = spi_wb;
 928  00bc 1e05          	ldw	x,(OFST+5,sp)
 929  00be bf16          	ldw	_WIZCHIP+22,x
 930  00c0 20f4          	jra	L704
 933                     .const:	section	.text
 934  0000               L114_ptmp:
 935  0000 0000          	dc.w	0
 936  0002 0000          	dc.w	0
1132                     	switch	.const
1133  0004               L05:
1134  0004 00e3          	dc.w	L314
1135  0006 00ea          	dc.w	L514
1136  0008 0110          	dc.w	L124
1137  000a 0106          	dc.w	L714
1138  000c 011b          	dc.w	L324
1139  000e 0125          	dc.w	L524
1140  0010 0130          	dc.w	L724
1141  0012 015a          	dc.w	L134
1142  0014 0188          	dc.w	L334
1143  0016 01ab          	dc.w	L534
1144  0018 01b0          	dc.w	L734
1145  001a 01b7          	dc.w	L144
1146  001c 01be          	dc.w	L344
1147  001e 01c0          	dc.w	L544
1148  0020 01c9          	dc.w	L744
1149  0022 01df          	dc.w	L154
1150                     ; 277 int8_t ctlwizchip(ctlwizchip_type cwtype, void* arg)
1150                     ; 278 {
1151                     	switch	.text
1152  00c2               _ctlwizchip:
1154  00c2 88            	push	a
1155  00c3 5206          	subw	sp,#6
1156       00000006      OFST:	set	6
1159                     ; 280    uint8_t tmp = 0;
1161                     ; 282    uint8_t* ptmp[2] = {0,0};
1163  00c5 96            	ldw	x,sp
1164  00c6 1c0002        	addw	x,#OFST-4
1165  00c9 90ae0000      	ldw	y,#L114_ptmp
1166  00cd a604          	ld	a,#4
1167  00cf cd0000        	call	c_xymov
1169                     ; 283    switch(cwtype)
1171  00d2 7b07          	ld	a,(OFST+1,sp)
1173                     ; 352       default:
1173                     ; 353          return -1;
1174  00d4 a110          	cp	a,#16
1175  00d6 2407          	jruge	L64
1176  00d8 5f            	clrw	x
1177  00d9 97            	ld	xl,a
1178  00da 58            	sllw	x
1179  00db de0004        	ldw	x,(L05,x)
1180  00de fc            	jp	(x)
1181  00df               L64:
1182  00df acf501f5      	jpf	L354
1183  00e3               L314:
1184                     ; 285       case CW_RESET_WIZCHIP:
1184                     ; 286          wizchip_sw_reset();
1186  00e3 cd0243        	call	_wizchip_sw_reset
1188                     ; 287          break;
1190  00e6 acf901f9      	jpf	L555
1191  00ea               L514:
1192                     ; 288       case CW_INIT_WIZCHIP:
1192                     ; 289          if(arg != 0) 
1194  00ea 1e0a          	ldw	x,(OFST+4,sp)
1195  00ec 270b          	jreq	L755
1196                     ; 291             ptmp[0] = (uint8_t*)arg;
1198  00ee 1e0a          	ldw	x,(OFST+4,sp)
1199  00f0 1f02          	ldw	(OFST-4,sp),x
1201                     ; 292             ptmp[1] = ptmp[0] + _WIZCHIP_SOCK_NUM_;
1203  00f2 1e02          	ldw	x,(OFST-4,sp)
1204  00f4 1c0008        	addw	x,#8
1205  00f7 1f04          	ldw	(OFST-2,sp),x
1207  00f9               L755:
1208                     ; 294          return wizchip_init(ptmp[0], ptmp[1]);
1210  00f9 1e04          	ldw	x,(OFST-2,sp)
1211  00fb 89            	pushw	x
1212  00fc 1e04          	ldw	x,(OFST-2,sp)
1213  00fe cd0314        	call	_wizchip_init
1215  0101 85            	popw	x
1217  0102 acc601c6      	jpf	L25
1218  0106               L714:
1219                     ; 295       case CW_CLR_INTERRUPT:
1219                     ; 296          wizchip_clrinterrupt(*((intr_kind*)arg));
1221  0106 1e0a          	ldw	x,(OFST+4,sp)
1222  0108 fe            	ldw	x,(x)
1223  0109 cd03e1        	call	_wizchip_clrinterrupt
1225                     ; 297          break;
1227  010c acf901f9      	jpf	L555
1228  0110               L124:
1229                     ; 298       case CW_GET_INTERRUPT:
1229                     ; 299         *((intr_kind*)arg) = wizchip_getinterrupt();
1231  0110 cd040e        	call	_wizchip_getinterrupt
1233  0113 160a          	ldw	y,(OFST+4,sp)
1234  0115 90ff          	ldw	(y),x
1235                     ; 300          break;
1237  0117 acf901f9      	jpf	L555
1238  011b               L324:
1239                     ; 301       case CW_SET_INTRMASK:
1239                     ; 302          wizchip_setinterruptmask(*((intr_kind*)arg));
1241  011b 1e0a          	ldw	x,(OFST+4,sp)
1242  011d fe            	ldw	x,(x)
1243  011e cd0449        	call	_wizchip_setinterruptmask
1245                     ; 303          break;         
1247  0121 acf901f9      	jpf	L555
1248  0125               L524:
1249                     ; 304       case CW_GET_INTRMASK:
1249                     ; 305          *((intr_kind*)arg) = wizchip_getinterruptmask();
1251  0125 cd0474        	call	_wizchip_getinterruptmask
1253  0128 160a          	ldw	y,(OFST+4,sp)
1254  012a 90ff          	ldw	(y),x
1255                     ; 306          break;
1257  012c acf901f9      	jpf	L555
1258  0130               L724:
1259                     ; 311          setINTLEVEL(*(uint16_t*)arg);
1261  0130 1e0a          	ldw	x,(OFST+4,sp)
1262  0132 fe            	ldw	x,(x)
1263  0133 4f            	clr	a
1264  0134 01            	rrwa	x,a
1265  0135 9f            	ld	a,xl
1266  0136 88            	push	a
1267  0137 ae1300        	ldw	x,#4864
1268  013a 89            	pushw	x
1269  013b ae0000        	ldw	x,#0
1270  013e 89            	pushw	x
1271  013f cd0000        	call	_WIZCHIP_WRITE
1273  0142 5b05          	addw	sp,#5
1276  0144 1e0a          	ldw	x,(OFST+4,sp)
1277  0146 e601          	ld	a,(1,x)
1278  0148 88            	push	a
1279  0149 ae1400        	ldw	x,#5120
1280  014c 89            	pushw	x
1281  014d ae0000        	ldw	x,#0
1282  0150 89            	pushw	x
1283  0151 cd0000        	call	_WIZCHIP_WRITE
1285  0154 5b05          	addw	sp,#5
1286                     ; 312          break;
1289  0156 acf901f9      	jpf	L555
1290  015a               L134:
1291                     ; 313       case CW_GET_INTRTIME:
1291                     ; 314          *(uint16_t*)arg = getINTLEVEL();
1293  015a ae1400        	ldw	x,#5120
1294  015d 89            	pushw	x
1295  015e ae0000        	ldw	x,#0
1296  0161 89            	pushw	x
1297  0162 cd0000        	call	_WIZCHIP_READ
1299  0165 5b04          	addw	sp,#4
1300  0167 6b01          	ld	(OFST-5,sp),a
1302  0169 ae1300        	ldw	x,#4864
1303  016c 89            	pushw	x
1304  016d ae0000        	ldw	x,#0
1305  0170 89            	pushw	x
1306  0171 cd0000        	call	_WIZCHIP_READ
1308  0174 5b04          	addw	sp,#4
1309  0176 5f            	clrw	x
1310  0177 97            	ld	xl,a
1311  0178 4f            	clr	a
1312  0179 02            	rlwa	x,a
1313  017a 01            	rrwa	x,a
1314  017b 1b01          	add	a,(OFST-5,sp)
1315  017d 2401          	jrnc	L44
1316  017f 5c            	incw	x
1317  0180               L44:
1318  0180 160a          	ldw	y,(OFST+4,sp)
1319  0182 02            	rlwa	x,a
1320  0183 90ff          	ldw	(y),x
1321  0185 01            	rrwa	x,a
1322                     ; 315          break;
1324  0186 2071          	jra	L555
1325  0188               L334:
1326                     ; 317       case CW_GET_ID:
1326                     ; 318          ((uint8_t*)arg)[0] = WIZCHIP.id[0];
1328  0188 1e0a          	ldw	x,(OFST+4,sp)
1329  018a b602          	ld	a,_WIZCHIP+2
1330  018c f7            	ld	(x),a
1331                     ; 319          ((uint8_t*)arg)[1] = WIZCHIP.id[1];
1333  018d 1e0a          	ldw	x,(OFST+4,sp)
1334  018f b603          	ld	a,_WIZCHIP+3
1335  0191 e701          	ld	(1,x),a
1336                     ; 320          ((uint8_t*)arg)[2] = WIZCHIP.id[2];
1338  0193 1e0a          	ldw	x,(OFST+4,sp)
1339  0195 b604          	ld	a,_WIZCHIP+4
1340  0197 e702          	ld	(2,x),a
1341                     ; 321          ((uint8_t*)arg)[3] = WIZCHIP.id[3];
1343  0199 1e0a          	ldw	x,(OFST+4,sp)
1344  019b b605          	ld	a,_WIZCHIP+5
1345  019d e703          	ld	(3,x),a
1346                     ; 322          ((uint8_t*)arg)[4] = WIZCHIP.id[4];
1348  019f 1e0a          	ldw	x,(OFST+4,sp)
1349  01a1 b606          	ld	a,_WIZCHIP+6
1350  01a3 e704          	ld	(4,x),a
1351                     ; 323          ((uint8_t*)arg)[5] = 0;
1353  01a5 1e0a          	ldw	x,(OFST+4,sp)
1354  01a7 6f05          	clr	(5,x)
1355                     ; 324          break;
1357  01a9 204e          	jra	L555
1358  01ab               L534:
1359                     ; 326       case CW_RESET_PHY:
1359                     ; 327          wizphy_reset();
1361  01ab cd04eb        	call	_wizphy_reset
1363                     ; 328          break;
1365  01ae 2049          	jra	L555
1366  01b0               L734:
1367                     ; 329       case CW_SET_PHYCONF:
1367                     ; 330          wizphy_setphyconf((wiz_PhyConf*)arg);
1369  01b0 1e0a          	ldw	x,(OFST+4,sp)
1370  01b2 cd0538        	call	_wizphy_setphyconf
1372                     ; 331          break;
1374  01b5 2042          	jra	L555
1375  01b7               L144:
1376                     ; 332       case CW_GET_PHYCONF:
1376                     ; 333          wizphy_getphyconf((wiz_PhyConf*)arg);
1378  01b7 1e0a          	ldw	x,(OFST+4,sp)
1379  01b9 cd05a3        	call	_wizphy_getphyconf
1381                     ; 334          break;
1383  01bc 203b          	jra	L555
1384  01be               L344:
1385                     ; 335       case CW_GET_PHYSTATUS:
1385                     ; 336          break;
1387  01be 2039          	jra	L555
1388  01c0               L544:
1389                     ; 337       case CW_SET_PHYPOWMODE:
1389                     ; 338          return wizphy_setphypmode(*(uint8_t*)arg);
1391  01c0 1e0a          	ldw	x,(OFST+4,sp)
1392  01c2 f6            	ld	a,(x)
1393  01c3 cd0647        	call	_wizphy_setphypmode
1396  01c6               L25:
1398  01c6 5b07          	addw	sp,#7
1399  01c8 81            	ret
1400  01c9               L744:
1401                     ; 341       case CW_GET_PHYPOWMODE:
1401                     ; 342          tmp = wizphy_getphypmode();
1403  01c9 cd04cc        	call	_wizphy_getphypmode
1405  01cc 6b06          	ld	(OFST+0,sp),a
1407                     ; 343          if((int8_t)tmp == -1) return -1;
1409  01ce 7b06          	ld	a,(OFST+0,sp)
1410  01d0 a1ff          	cp	a,#255
1411  01d2 2604          	jrne	L165
1414  01d4 a6ff          	ld	a,#255
1416  01d6 20ee          	jra	L25
1417  01d8               L165:
1418                     ; 344          *(uint8_t*)arg = tmp;
1420  01d8 7b06          	ld	a,(OFST+0,sp)
1421  01da 1e0a          	ldw	x,(OFST+4,sp)
1422  01dc f7            	ld	(x),a
1423                     ; 345          break;
1425  01dd 201a          	jra	L555
1426  01df               L154:
1427                     ; 346       case CW_GET_PHYLINK:
1427                     ; 347          tmp = wizphy_getphylink();
1429  01df cd04ad        	call	_wizphy_getphylink
1431  01e2 6b06          	ld	(OFST+0,sp),a
1433                     ; 348          if((int8_t)tmp == -1) return -1;
1435  01e4 7b06          	ld	a,(OFST+0,sp)
1436  01e6 a1ff          	cp	a,#255
1437  01e8 2604          	jrne	L365
1440  01ea a6ff          	ld	a,#255
1442  01ec 20d8          	jra	L25
1443  01ee               L365:
1444                     ; 349          *(uint8_t*)arg = tmp;
1446  01ee 7b06          	ld	a,(OFST+0,sp)
1447  01f0 1e0a          	ldw	x,(OFST+4,sp)
1448  01f2 f7            	ld	(x),a
1449                     ; 350          break;
1451  01f3 2004          	jra	L555
1452  01f5               L354:
1453                     ; 352       default:
1453                     ; 353          return -1;
1455  01f5 a6ff          	ld	a,#255
1457  01f7 20cd          	jra	L25
1458  01f9               L555:
1459                     ; 355    return 0;
1461  01f9 4f            	clr	a
1463  01fa 20ca          	jra	L25
1562                     ; 359 int8_t ctlnetwork(ctlnetwork_type cntype, void* arg)
1562                     ; 360 {
1563                     	switch	.text
1564  01fc               _ctlnetwork:
1566  01fc 88            	push	a
1567       00000000      OFST:	set	0
1570                     ; 362    switch(cntype)
1573                     ; 381       default:
1573                     ; 382          return -1;
1574  01fd 4d            	tnz	a
1575  01fe 2714          	jreq	L565
1576  0200 4a            	dec	a
1577  0201 2718          	jreq	L765
1578  0203 4a            	dec	a
1579  0204 271c          	jreq	L175
1580  0206 4a            	dec	a
1581  0207 2722          	jreq	L375
1582  0209 4a            	dec	a
1583  020a 2727          	jreq	L575
1584  020c 4a            	dec	a
1585  020d 272b          	jreq	L775
1586  020f               L106:
1589  020f a6ff          	ld	a,#255
1592  0211 5b01          	addw	sp,#1
1593  0213 81            	ret
1594  0214               L565:
1595                     ; 364       case CN_SET_NETINFO:
1595                     ; 365          wizchip_setnetinfo((wiz_NetInfo*)arg);
1597  0214 1e04          	ldw	x,(OFST+4,sp)
1598  0216 cd06ba        	call	_wizchip_setnetinfo
1600                     ; 366          break;
1602  0219 2024          	jra	L746
1603  021b               L765:
1604                     ; 367       case CN_GET_NETINFO:
1604                     ; 368          wizchip_getnetinfo((wiz_NetInfo*)arg);
1606  021b 1e04          	ldw	x,(OFST+4,sp)
1607  021d cd0734        	call	_wizchip_getnetinfo
1609                     ; 369          break;
1611  0220 201d          	jra	L746
1612  0222               L175:
1613                     ; 370       case CN_SET_NETMODE:
1613                     ; 371          return wizchip_setnetmode(*(netmode_type*)arg);
1615  0222 1e04          	ldw	x,(OFST+4,sp)
1616  0224 f6            	ld	a,(x)
1617  0225 cd07ae        	call	_wizchip_setnetmode
1621  0228 5b01          	addw	sp,#1
1622  022a 81            	ret
1623  022b               L375:
1624                     ; 372       case CN_GET_NETMODE:
1624                     ; 373          *(netmode_type*)arg = wizchip_getnetmode();
1626  022b cd07ea        	call	_wizchip_getnetmode
1628  022e 1e04          	ldw	x,(OFST+4,sp)
1629  0230 f7            	ld	(x),a
1630                     ; 374          break;
1632  0231 200c          	jra	L746
1633  0233               L575:
1634                     ; 375       case CN_SET_TIMEOUT:
1634                     ; 376          wizchip_settimeout((wiz_NetTimeout*)arg);
1636  0233 1e04          	ldw	x,(OFST+4,sp)
1637  0235 cd07f8        	call	_wizchip_settimeout
1639                     ; 377          break;
1641  0238 2005          	jra	L746
1642  023a               L775:
1643                     ; 378       case CN_GET_TIMEOUT:
1643                     ; 379          wizchip_gettimeout((wiz_NetTimeout*)arg);
1645  023a 1e04          	ldw	x,(OFST+4,sp)
1646  023c cd0831        	call	_wizchip_gettimeout
1648                     ; 380          break;
1650  023f               L746:
1651                     ; 384    return 0;
1653  023f 4f            	clr	a
1656  0240 5b01          	addw	sp,#1
1657  0242 81            	ret
1726                     ; 387 void wizchip_sw_reset(void)
1726                     ; 388 {
1727                     	switch	.text
1728  0243               _wizchip_sw_reset:
1730  0243 5212          	subw	sp,#18
1731       00000012      OFST:	set	18
1734                     ; 397    getSHAR(mac);
1736  0245 ae0006        	ldw	x,#6
1737  0248 89            	pushw	x
1738  0249 96            	ldw	x,sp
1739  024a 1c000f        	addw	x,#OFST-3
1740  024d 89            	pushw	x
1741  024e ae0900        	ldw	x,#2304
1742  0251 89            	pushw	x
1743  0252 ae0000        	ldw	x,#0
1744  0255 89            	pushw	x
1745  0256 cd0000        	call	_WIZCHIP_READ_BUF
1747  0259 5b08          	addw	sp,#8
1748                     ; 398    getGAR(gw);  getSUBR(sn);  getSIPR(sip);
1750  025b ae0004        	ldw	x,#4
1751  025e 89            	pushw	x
1752  025f 96            	ldw	x,sp
1753  0260 1c0003        	addw	x,#OFST-15
1754  0263 89            	pushw	x
1755  0264 ae0100        	ldw	x,#256
1756  0267 89            	pushw	x
1757  0268 ae0000        	ldw	x,#0
1758  026b 89            	pushw	x
1759  026c cd0000        	call	_WIZCHIP_READ_BUF
1761  026f 5b08          	addw	sp,#8
1764  0271 ae0004        	ldw	x,#4
1765  0274 89            	pushw	x
1766  0275 96            	ldw	x,sp
1767  0276 1c0007        	addw	x,#OFST-11
1768  0279 89            	pushw	x
1769  027a ae0500        	ldw	x,#1280
1770  027d 89            	pushw	x
1771  027e ae0000        	ldw	x,#0
1772  0281 89            	pushw	x
1773  0282 cd0000        	call	_WIZCHIP_READ_BUF
1775  0285 5b08          	addw	sp,#8
1778  0287 ae0004        	ldw	x,#4
1779  028a 89            	pushw	x
1780  028b 96            	ldw	x,sp
1781  028c 1c000b        	addw	x,#OFST-7
1782  028f 89            	pushw	x
1783  0290 ae0f00        	ldw	x,#3840
1784  0293 89            	pushw	x
1785  0294 ae0000        	ldw	x,#0
1786  0297 89            	pushw	x
1787  0298 cd0000        	call	_WIZCHIP_READ_BUF
1789  029b 5b08          	addw	sp,#8
1790                     ; 399    setMR(MR_RST);
1792  029d 4b80          	push	#128
1793  029f ae0000        	ldw	x,#0
1794  02a2 89            	pushw	x
1795  02a3 ae0000        	ldw	x,#0
1796  02a6 89            	pushw	x
1797  02a7 cd0000        	call	_WIZCHIP_WRITE
1799  02aa 5b05          	addw	sp,#5
1800                     ; 400    getMR(); // for delay
1802  02ac ae0000        	ldw	x,#0
1803  02af 89            	pushw	x
1804  02b0 ae0000        	ldw	x,#0
1805  02b3 89            	pushw	x
1806  02b4 cd0000        	call	_WIZCHIP_READ
1808  02b7 5b04          	addw	sp,#4
1809                     ; 406    setSHAR(mac);
1811  02b9 ae0006        	ldw	x,#6
1812  02bc 89            	pushw	x
1813  02bd 96            	ldw	x,sp
1814  02be 1c000f        	addw	x,#OFST-3
1815  02c1 89            	pushw	x
1816  02c2 ae0900        	ldw	x,#2304
1817  02c5 89            	pushw	x
1818  02c6 ae0000        	ldw	x,#0
1819  02c9 89            	pushw	x
1820  02ca cd0000        	call	_WIZCHIP_WRITE_BUF
1822  02cd 5b08          	addw	sp,#8
1823                     ; 407    setGAR(gw);
1825  02cf ae0004        	ldw	x,#4
1826  02d2 89            	pushw	x
1827  02d3 96            	ldw	x,sp
1828  02d4 1c0003        	addw	x,#OFST-15
1829  02d7 89            	pushw	x
1830  02d8 ae0100        	ldw	x,#256
1831  02db 89            	pushw	x
1832  02dc ae0000        	ldw	x,#0
1833  02df 89            	pushw	x
1834  02e0 cd0000        	call	_WIZCHIP_WRITE_BUF
1836  02e3 5b08          	addw	sp,#8
1837                     ; 408    setSUBR(sn);
1839  02e5 ae0004        	ldw	x,#4
1840  02e8 89            	pushw	x
1841  02e9 96            	ldw	x,sp
1842  02ea 1c0007        	addw	x,#OFST-11
1843  02ed 89            	pushw	x
1844  02ee ae0500        	ldw	x,#1280
1845  02f1 89            	pushw	x
1846  02f2 ae0000        	ldw	x,#0
1847  02f5 89            	pushw	x
1848  02f6 cd0000        	call	_WIZCHIP_WRITE_BUF
1850  02f9 5b08          	addw	sp,#8
1851                     ; 409    setSIPR(sip);
1853  02fb ae0004        	ldw	x,#4
1854  02fe 89            	pushw	x
1855  02ff 96            	ldw	x,sp
1856  0300 1c000b        	addw	x,#OFST-7
1857  0303 89            	pushw	x
1858  0304 ae0f00        	ldw	x,#3840
1859  0307 89            	pushw	x
1860  0308 ae0000        	ldw	x,#0
1861  030b 89            	pushw	x
1862  030c cd0000        	call	_WIZCHIP_WRITE_BUF
1864  030f 5b08          	addw	sp,#8
1865                     ; 410 }
1868  0311 5b12          	addw	sp,#18
1869  0313 81            	ret
1934                     ; 412 int8_t wizchip_init(uint8_t* txsize, uint8_t* rxsize)
1934                     ; 413 {
1935                     	switch	.text
1936  0314               _wizchip_init:
1938  0314 89            	pushw	x
1939  0315 89            	pushw	x
1940       00000002      OFST:	set	2
1943                     ; 415    int8_t tmp = 0;
1945                     ; 416    wizchip_sw_reset();
1947  0316 cd0243        	call	_wizchip_sw_reset
1949                     ; 417    if(txsize)
1951  0319 1e03          	ldw	x,(OFST+1,sp)
1952  031b 275e          	jreq	L537
1953                     ; 419       tmp = 0;
1955  031d 0f01          	clr	(OFST-1,sp)
1957                     ; 430       for(i = 0 ; i < _WIZCHIP_SOCK_NUM_; i++)
1959  031f 0f02          	clr	(OFST+0,sp)
1961  0321               L737:
1962                     ; 432          tmp += txsize[i];
1964  0321 7b02          	ld	a,(OFST+0,sp)
1965  0323 5f            	clrw	x
1966  0324 4d            	tnz	a
1967  0325 2a01          	jrpl	L26
1968  0327 53            	cplw	x
1969  0328               L26:
1970  0328 97            	ld	xl,a
1971  0329 72fb03        	addw	x,(OFST+1,sp)
1972  032c 7b01          	ld	a,(OFST-1,sp)
1973  032e fb            	add	a,(x)
1974  032f 6b01          	ld	(OFST-1,sp),a
1976                     ; 433          if(tmp > 16) return -1;
1978  0331 9c            	rvf
1979  0332 7b01          	ld	a,(OFST-1,sp)
1980  0334 a111          	cp	a,#17
1981  0336 2f04          	jrslt	L547
1984  0338 a6ff          	ld	a,#255
1986  033a 2060          	jra	L67
1987  033c               L547:
1988                     ; 430       for(i = 0 ; i < _WIZCHIP_SOCK_NUM_; i++)
1990  033c 0c02          	inc	(OFST+0,sp)
1994  033e 9c            	rvf
1995  033f 7b02          	ld	a,(OFST+0,sp)
1996  0341 a108          	cp	a,#8
1997  0343 2fdc          	jrslt	L737
1998                     ; 436       for(i = 0 ; i < _WIZCHIP_SOCK_NUM_; i++)
2000  0345 0f02          	clr	(OFST+0,sp)
2002  0347               L747:
2003                     ; 437          setSn_TXBUF_SIZE(i, txsize[i]);
2005  0347 7b02          	ld	a,(OFST+0,sp)
2006  0349 5f            	clrw	x
2007  034a 4d            	tnz	a
2008  034b 2a01          	jrpl	L46
2009  034d 53            	cplw	x
2010  034e               L46:
2011  034e 97            	ld	xl,a
2012  034f 72fb03        	addw	x,(OFST+1,sp)
2013  0352 f6            	ld	a,(x)
2014  0353 88            	push	a
2015  0354 7b03          	ld	a,(OFST+1,sp)
2016  0356 5f            	clrw	x
2017  0357 4d            	tnz	a
2018  0358 2a01          	jrpl	L66
2019  035a 53            	cplw	x
2020  035b               L66:
2021  035b 97            	ld	xl,a
2022  035c 58            	sllw	x
2023  035d 58            	sllw	x
2024  035e 58            	sllw	x
2025  035f 58            	sllw	x
2026  0360 58            	sllw	x
2027  0361 1c1f08        	addw	x,#7944
2028  0364 cd0000        	call	c_itolx
2030  0367 be02          	ldw	x,c_lreg+2
2031  0369 89            	pushw	x
2032  036a be00          	ldw	x,c_lreg
2033  036c 89            	pushw	x
2034  036d cd0000        	call	_WIZCHIP_WRITE
2036  0370 5b05          	addw	sp,#5
2037                     ; 436       for(i = 0 ; i < _WIZCHIP_SOCK_NUM_; i++)
2039  0372 0c02          	inc	(OFST+0,sp)
2043  0374 9c            	rvf
2044  0375 7b02          	ld	a,(OFST+0,sp)
2045  0377 a108          	cp	a,#8
2046  0379 2fcc          	jrslt	L747
2047  037b               L537:
2048                     ; 439    if(rxsize)
2050  037b 1e07          	ldw	x,(OFST+5,sp)
2051  037d 275f          	jreq	L557
2052                     ; 441       tmp = 0;
2054  037f 0f01          	clr	(OFST-1,sp)
2056                     ; 451       for(i = 0 ; i < _WIZCHIP_SOCK_NUM_; i++)
2058  0381 0f02          	clr	(OFST+0,sp)
2060  0383               L757:
2061                     ; 453          tmp += rxsize[i];
2063  0383 7b02          	ld	a,(OFST+0,sp)
2064  0385 5f            	clrw	x
2065  0386 4d            	tnz	a
2066  0387 2a01          	jrpl	L07
2067  0389 53            	cplw	x
2068  038a               L07:
2069  038a 97            	ld	xl,a
2070  038b 72fb07        	addw	x,(OFST+5,sp)
2071  038e 7b01          	ld	a,(OFST-1,sp)
2072  0390 fb            	add	a,(x)
2073  0391 6b01          	ld	(OFST-1,sp),a
2075                     ; 454          if(tmp > 16) return -1;
2077  0393 9c            	rvf
2078  0394 7b01          	ld	a,(OFST-1,sp)
2079  0396 a111          	cp	a,#17
2080  0398 2f05          	jrslt	L567
2083  039a a6ff          	ld	a,#255
2085  039c               L67:
2087  039c 5b04          	addw	sp,#4
2088  039e 81            	ret
2089  039f               L567:
2090                     ; 451       for(i = 0 ; i < _WIZCHIP_SOCK_NUM_; i++)
2092  039f 0c02          	inc	(OFST+0,sp)
2096  03a1 9c            	rvf
2097  03a2 7b02          	ld	a,(OFST+0,sp)
2098  03a4 a108          	cp	a,#8
2099  03a6 2fdb          	jrslt	L757
2100                     ; 458       for(i = 0 ; i < _WIZCHIP_SOCK_NUM_; i++)
2102  03a8 0f02          	clr	(OFST+0,sp)
2104  03aa               L767:
2105                     ; 459          setSn_RXBUF_SIZE(i, rxsize[i]);
2107  03aa 7b02          	ld	a,(OFST+0,sp)
2108  03ac 5f            	clrw	x
2109  03ad 4d            	tnz	a
2110  03ae 2a01          	jrpl	L27
2111  03b0 53            	cplw	x
2112  03b1               L27:
2113  03b1 97            	ld	xl,a
2114  03b2 72fb07        	addw	x,(OFST+5,sp)
2115  03b5 f6            	ld	a,(x)
2116  03b6 88            	push	a
2117  03b7 7b03          	ld	a,(OFST+1,sp)
2118  03b9 5f            	clrw	x
2119  03ba 4d            	tnz	a
2120  03bb 2a01          	jrpl	L47
2121  03bd 53            	cplw	x
2122  03be               L47:
2123  03be 97            	ld	xl,a
2124  03bf 58            	sllw	x
2125  03c0 58            	sllw	x
2126  03c1 58            	sllw	x
2127  03c2 58            	sllw	x
2128  03c3 58            	sllw	x
2129  03c4 1c1e08        	addw	x,#7688
2130  03c7 cd0000        	call	c_itolx
2132  03ca be02          	ldw	x,c_lreg+2
2133  03cc 89            	pushw	x
2134  03cd be00          	ldw	x,c_lreg
2135  03cf 89            	pushw	x
2136  03d0 cd0000        	call	_WIZCHIP_WRITE
2138  03d3 5b05          	addw	sp,#5
2139                     ; 458       for(i = 0 ; i < _WIZCHIP_SOCK_NUM_; i++)
2141  03d5 0c02          	inc	(OFST+0,sp)
2145  03d7 9c            	rvf
2146  03d8 7b02          	ld	a,(OFST+0,sp)
2147  03da a108          	cp	a,#8
2148  03dc 2fcc          	jrslt	L767
2149  03de               L557:
2150                     ; 461    return 0;
2152  03de 4f            	clr	a
2154  03df 20bb          	jra	L67
2307                     ; 464 void wizchip_clrinterrupt(intr_kind intr)
2307                     ; 465 {
2308                     	switch	.text
2309  03e1               _wizchip_clrinterrupt:
2311  03e1 89            	pushw	x
2312       00000002      OFST:	set	2
2315                     ; 466    uint8_t ir  = (uint8_t)intr;
2317  03e2 9f            	ld	a,xl
2318  03e3 6b01          	ld	(OFST-1,sp),a
2320                     ; 467    uint8_t sir = (uint8_t)((uint16_t)intr >> 8);
2322  03e5 4f            	clr	a
2323  03e6 01            	rrwa	x,a
2324  03e7 9f            	ld	a,xl
2325  03e8 6b02          	ld	(OFST+0,sp),a
2327                     ; 486    setIR(ir);
2329  03ea 7b01          	ld	a,(OFST-1,sp)
2330  03ec a4f0          	and	a,#240
2331  03ee 88            	push	a
2332  03ef ae1500        	ldw	x,#5376
2333  03f2 89            	pushw	x
2334  03f3 ae0000        	ldw	x,#0
2335  03f6 89            	pushw	x
2336  03f7 cd0000        	call	_WIZCHIP_WRITE
2338  03fa 5b05          	addw	sp,#5
2339                     ; 487    setSIR(sir);
2341  03fc 7b02          	ld	a,(OFST+0,sp)
2342  03fe 88            	push	a
2343  03ff ae1700        	ldw	x,#5888
2344  0402 89            	pushw	x
2345  0403 ae0000        	ldw	x,#0
2346  0406 89            	pushw	x
2347  0407 cd0000        	call	_WIZCHIP_WRITE
2349  040a 5b05          	addw	sp,#5
2350                     ; 489 }
2353  040c 85            	popw	x
2354  040d 81            	ret
2409                     ; 491 intr_kind wizchip_getinterrupt(void)
2409                     ; 492 {
2410                     	switch	.text
2411  040e               _wizchip_getinterrupt:
2413  040e 5204          	subw	sp,#4
2414       00000004      OFST:	set	4
2417                     ; 493    uint8_t ir  = 0;
2419                     ; 494    uint8_t sir = 0;
2421                     ; 495    uint16_t ret = 0;
2423                     ; 505    ir  = getIR();
2425  0410 ae1500        	ldw	x,#5376
2426  0413 89            	pushw	x
2427  0414 ae0000        	ldw	x,#0
2428  0417 89            	pushw	x
2429  0418 cd0000        	call	_WIZCHIP_READ
2431  041b 5b04          	addw	sp,#4
2432  041d a4f0          	and	a,#240
2433  041f 6b01          	ld	(OFST-3,sp),a
2435                     ; 506    sir = getSIR();
2437  0421 ae1700        	ldw	x,#5888
2438  0424 89            	pushw	x
2439  0425 ae0000        	ldw	x,#0
2440  0428 89            	pushw	x
2441  0429 cd0000        	call	_WIZCHIP_READ
2443  042c 5b04          	addw	sp,#4
2444  042e 6b02          	ld	(OFST-2,sp),a
2446                     ; 517   ret = sir;
2448  0430 7b02          	ld	a,(OFST-2,sp)
2449  0432 5f            	clrw	x
2450  0433 97            	ld	xl,a
2451  0434 1f03          	ldw	(OFST-1,sp),x
2453                     ; 518   ret = (ret << 8) + ir;
2455  0436 1e03          	ldw	x,(OFST-1,sp)
2456  0438 4f            	clr	a
2457  0439 02            	rlwa	x,a
2458  043a 01            	rrwa	x,a
2459  043b 1b01          	add	a,(OFST-3,sp)
2460  043d 2401          	jrnc	L401
2461  043f 5c            	incw	x
2462  0440               L401:
2463  0440 02            	rlwa	x,a
2464  0441 1f03          	ldw	(OFST-1,sp),x
2465  0443 01            	rrwa	x,a
2467                     ; 519   return (intr_kind)ret;
2469  0444 1e03          	ldw	x,(OFST-1,sp)
2472  0446 5b04          	addw	sp,#4
2473  0448 81            	ret
2528                     ; 522 void wizchip_setinterruptmask(intr_kind intr)
2528                     ; 523 {
2529                     	switch	.text
2530  0449               _wizchip_setinterruptmask:
2532  0449 89            	pushw	x
2533       00000002      OFST:	set	2
2536                     ; 524    uint8_t imr  = (uint8_t)intr;
2538  044a 9f            	ld	a,xl
2539  044b 6b01          	ld	(OFST-1,sp),a
2541                     ; 525    uint8_t simr = (uint8_t)((uint16_t)intr >> 8);
2543  044d 4f            	clr	a
2544  044e 01            	rrwa	x,a
2545  044f 9f            	ld	a,xl
2546  0450 6b02          	ld	(OFST+0,sp),a
2548                     ; 541    setIMR(imr);
2550  0452 7b01          	ld	a,(OFST-1,sp)
2551  0454 88            	push	a
2552  0455 ae1600        	ldw	x,#5632
2553  0458 89            	pushw	x
2554  0459 ae0000        	ldw	x,#0
2555  045c 89            	pushw	x
2556  045d cd0000        	call	_WIZCHIP_WRITE
2558  0460 5b05          	addw	sp,#5
2559                     ; 542    setSIMR(simr);
2561  0462 7b02          	ld	a,(OFST+0,sp)
2562  0464 88            	push	a
2563  0465 ae1800        	ldw	x,#6144
2564  0468 89            	pushw	x
2565  0469 ae0000        	ldw	x,#0
2566  046c 89            	pushw	x
2567  046d cd0000        	call	_WIZCHIP_WRITE
2569  0470 5b05          	addw	sp,#5
2570                     ; 544 }
2573  0472 85            	popw	x
2574  0473 81            	ret
2629                     ; 546 intr_kind wizchip_getinterruptmask(void)
2629                     ; 547 {
2630                     	switch	.text
2631  0474               _wizchip_getinterruptmask:
2633  0474 5204          	subw	sp,#4
2634       00000004      OFST:	set	4
2637                     ; 548    uint8_t imr  = 0;
2639                     ; 549    uint8_t simr = 0;
2641                     ; 550    uint16_t ret = 0;
2643                     ; 560    imr  = getIMR();
2645  0476 ae1600        	ldw	x,#5632
2646  0479 89            	pushw	x
2647  047a ae0000        	ldw	x,#0
2648  047d 89            	pushw	x
2649  047e cd0000        	call	_WIZCHIP_READ
2651  0481 5b04          	addw	sp,#4
2652  0483 6b01          	ld	(OFST-3,sp),a
2654                     ; 561    simr = getSIMR();
2656  0485 ae1800        	ldw	x,#6144
2657  0488 89            	pushw	x
2658  0489 ae0000        	ldw	x,#0
2659  048c 89            	pushw	x
2660  048d cd0000        	call	_WIZCHIP_READ
2662  0490 5b04          	addw	sp,#4
2663  0492 6b02          	ld	(OFST-2,sp),a
2665                     ; 570   ret = simr;
2667  0494 7b02          	ld	a,(OFST-2,sp)
2668  0496 5f            	clrw	x
2669  0497 97            	ld	xl,a
2670  0498 1f03          	ldw	(OFST-1,sp),x
2672                     ; 571   ret = (ret << 8) + imr;
2674  049a 1e03          	ldw	x,(OFST-1,sp)
2675  049c 4f            	clr	a
2676  049d 02            	rlwa	x,a
2677  049e 01            	rrwa	x,a
2678  049f 1b01          	add	a,(OFST-3,sp)
2679  04a1 2401          	jrnc	L211
2680  04a3 5c            	incw	x
2681  04a4               L211:
2682  04a4 02            	rlwa	x,a
2683  04a5 1f03          	ldw	(OFST-1,sp),x
2684  04a7 01            	rrwa	x,a
2686                     ; 572   return (intr_kind)ret;
2688  04a8 1e03          	ldw	x,(OFST-1,sp)
2691  04aa 5b04          	addw	sp,#4
2692  04ac 81            	ret
2727                     ; 575 int8_t wizphy_getphylink(void)
2727                     ; 576 {
2728                     	switch	.text
2729  04ad               _wizphy_getphylink:
2731  04ad 88            	push	a
2732       00000001      OFST:	set	1
2735                     ; 584    if(getPHYCFGR() & PHYCFGR_LNK_ON)
2737  04ae ae2e00        	ldw	x,#11776
2738  04b1 89            	pushw	x
2739  04b2 ae0000        	ldw	x,#0
2740  04b5 89            	pushw	x
2741  04b6 cd0000        	call	_WIZCHIP_READ
2743  04b9 5b04          	addw	sp,#4
2744  04bb a501          	bcp	a,#1
2745  04bd 2706          	jreq	L1021
2746                     ; 585       tmp = PHY_LINK_ON;
2748  04bf a601          	ld	a,#1
2749  04c1 6b01          	ld	(OFST+0,sp),a
2752  04c3 2002          	jra	L3021
2753  04c5               L1021:
2754                     ; 587       tmp = PHY_LINK_OFF;
2756  04c5 0f01          	clr	(OFST+0,sp)
2758  04c7               L3021:
2759                     ; 591    return tmp;
2761  04c7 7b01          	ld	a,(OFST+0,sp)
2764  04c9 5b01          	addw	sp,#1
2765  04cb 81            	ret
2800                     ; 596 int8_t wizphy_getphypmode(void)
2800                     ; 597 {
2801                     	switch	.text
2802  04cc               _wizphy_getphypmode:
2804  04cc 88            	push	a
2805       00000001      OFST:	set	1
2808                     ; 598    int8_t tmp = 0;
2810                     ; 605       if(getPHYCFGR() & PHYCFGR_OPMDC_PDOWN)
2812  04cd ae2e00        	ldw	x,#11776
2813  04d0 89            	pushw	x
2814  04d1 ae0000        	ldw	x,#0
2815  04d4 89            	pushw	x
2816  04d5 cd0000        	call	_WIZCHIP_READ
2818  04d8 5b04          	addw	sp,#4
2819  04da a530          	bcp	a,#48
2820  04dc 2706          	jreq	L3221
2821                     ; 606          tmp = PHY_POWER_DOWN;
2823  04de a601          	ld	a,#1
2824  04e0 6b01          	ld	(OFST+0,sp),a
2827  04e2 2002          	jra	L5221
2828  04e4               L3221:
2829                     ; 608          tmp = PHY_POWER_NORM;
2831  04e4 0f01          	clr	(OFST+0,sp)
2833  04e6               L5221:
2834                     ; 612    return tmp;
2836  04e6 7b01          	ld	a,(OFST+0,sp)
2839  04e8 5b01          	addw	sp,#1
2840  04ea 81            	ret
2876                     ; 617 void wizphy_reset(void)
2876                     ; 618 {
2877                     	switch	.text
2878  04eb               _wizphy_reset:
2880  04eb 88            	push	a
2881       00000001      OFST:	set	1
2884                     ; 619    uint8_t tmp = getPHYCFGR();
2886  04ec ae2e00        	ldw	x,#11776
2887  04ef 89            	pushw	x
2888  04f0 ae0000        	ldw	x,#0
2889  04f3 89            	pushw	x
2890  04f4 cd0000        	call	_WIZCHIP_READ
2892  04f7 5b04          	addw	sp,#4
2893  04f9 6b01          	ld	(OFST+0,sp),a
2895                     ; 620    tmp &= PHYCFGR_RST;
2897  04fb 7b01          	ld	a,(OFST+0,sp)
2898  04fd a47f          	and	a,#127
2899  04ff 6b01          	ld	(OFST+0,sp),a
2901                     ; 621    setPHYCFGR(tmp);
2903  0501 7b01          	ld	a,(OFST+0,sp)
2904  0503 88            	push	a
2905  0504 ae2e00        	ldw	x,#11776
2906  0507 89            	pushw	x
2907  0508 ae0000        	ldw	x,#0
2908  050b 89            	pushw	x
2909  050c cd0000        	call	_WIZCHIP_WRITE
2911  050f 5b05          	addw	sp,#5
2912                     ; 622    tmp = getPHYCFGR(); 
2914  0511 ae2e00        	ldw	x,#11776
2915  0514 89            	pushw	x
2916  0515 ae0000        	ldw	x,#0
2917  0518 89            	pushw	x
2918  0519 cd0000        	call	_WIZCHIP_READ
2920  051c 5b04          	addw	sp,#4
2921  051e 6b01          	ld	(OFST+0,sp),a
2923                     ; 623    tmp |= ~PHYCFGR_RST;
2925  0520 7b01          	ld	a,(OFST+0,sp)
2926  0522 aa80          	or	a,#128
2927  0524 6b01          	ld	(OFST+0,sp),a
2929                     ; 624    setPHYCFGR(tmp);
2931  0526 7b01          	ld	a,(OFST+0,sp)
2932  0528 88            	push	a
2933  0529 ae2e00        	ldw	x,#11776
2934  052c 89            	pushw	x
2935  052d ae0000        	ldw	x,#0
2936  0530 89            	pushw	x
2937  0531 cd0000        	call	_WIZCHIP_WRITE
2939  0534 5b05          	addw	sp,#5
2940                     ; 625 }
2943  0536 84            	pop	a
2944  0537 81            	ret
3027                     ; 627 void wizphy_setphyconf(wiz_PhyConf* phyconf)
3027                     ; 628 {
3028                     	switch	.text
3029  0538               _wizphy_setphyconf:
3031  0538 89            	pushw	x
3032  0539 88            	push	a
3033       00000001      OFST:	set	1
3036                     ; 629    uint8_t tmp = 0;
3038  053a 0f01          	clr	(OFST+0,sp)
3040                     ; 630    if(phyconf->by == PHY_CONFBY_SW)
3042  053c f6            	ld	a,(x)
3043  053d a101          	cp	a,#1
3044  053f 2608          	jrne	L5031
3045                     ; 631       tmp |= PHYCFGR_OPMD;
3047  0541 7b01          	ld	a,(OFST+0,sp)
3048  0543 aa40          	or	a,#64
3049  0545 6b01          	ld	(OFST+0,sp),a
3052  0547 2006          	jra	L7031
3053  0549               L5031:
3054                     ; 633       tmp &= ~PHYCFGR_OPMD;
3056  0549 7b01          	ld	a,(OFST+0,sp)
3057  054b a4bf          	and	a,#191
3058  054d 6b01          	ld	(OFST+0,sp),a
3060  054f               L7031:
3061                     ; 634    if(phyconf->mode == PHY_MODE_AUTONEGO)
3063  054f 1e02          	ldw	x,(OFST+1,sp)
3064  0551 e601          	ld	a,(1,x)
3065  0553 a101          	cp	a,#1
3066  0555 2608          	jrne	L1131
3067                     ; 635       tmp |= PHYCFGR_OPMDC_ALLA;
3069  0557 7b01          	ld	a,(OFST+0,sp)
3070  0559 aa38          	or	a,#56
3071  055b 6b01          	ld	(OFST+0,sp),a
3074  055d 202e          	jra	L3131
3075  055f               L1131:
3076                     ; 638       if(phyconf->duplex == PHY_DUPLEX_FULL)
3078  055f 1e02          	ldw	x,(OFST+1,sp)
3079  0561 e603          	ld	a,(3,x)
3080  0563 a101          	cp	a,#1
3081  0565 2618          	jrne	L5131
3082                     ; 640          if(phyconf->speed == PHY_SPEED_100)
3084  0567 1e02          	ldw	x,(OFST+1,sp)
3085  0569 e602          	ld	a,(2,x)
3086  056b a101          	cp	a,#1
3087  056d 2608          	jrne	L7131
3088                     ; 641             tmp |= PHYCFGR_OPMDC_100F;
3090  056f 7b01          	ld	a,(OFST+0,sp)
3091  0571 aa18          	or	a,#24
3092  0573 6b01          	ld	(OFST+0,sp),a
3095  0575 2016          	jra	L3131
3096  0577               L7131:
3097                     ; 643             tmp |= PHYCFGR_OPMDC_10F;
3099  0577 7b01          	ld	a,(OFST+0,sp)
3100  0579 aa08          	or	a,#8
3101  057b 6b01          	ld	(OFST+0,sp),a
3103  057d 200e          	jra	L3131
3104  057f               L5131:
3105                     ; 647          if(phyconf->speed == PHY_SPEED_100)
3107  057f 1e02          	ldw	x,(OFST+1,sp)
3108  0581 e602          	ld	a,(2,x)
3109  0583 a101          	cp	a,#1
3110  0585 2606          	jrne	L5231
3111                     ; 648             tmp |= PHYCFGR_OPMDC_100H;
3113  0587 7b01          	ld	a,(OFST+0,sp)
3114  0589 aa10          	or	a,#16
3115  058b 6b01          	ld	(OFST+0,sp),a
3118  058d               L5231:
3119                     ; 650             tmp |= PHYCFGR_OPMDC_10H;
3121  058d               L3131:
3122                     ; 653    setPHYCFGR(tmp);
3124  058d 7b01          	ld	a,(OFST+0,sp)
3125  058f 88            	push	a
3126  0590 ae2e00        	ldw	x,#11776
3127  0593 89            	pushw	x
3128  0594 ae0000        	ldw	x,#0
3129  0597 89            	pushw	x
3130  0598 cd0000        	call	_WIZCHIP_WRITE
3132  059b 5b05          	addw	sp,#5
3133                     ; 654    wizphy_reset();
3135  059d cd04eb        	call	_wizphy_reset
3137                     ; 655 }
3140  05a0 5b03          	addw	sp,#3
3141  05a2 81            	ret
3188                     ; 657 void wizphy_getphyconf(wiz_PhyConf* phyconf)
3188                     ; 658 {
3189                     	switch	.text
3190  05a3               _wizphy_getphyconf:
3192  05a3 89            	pushw	x
3193  05a4 88            	push	a
3194       00000001      OFST:	set	1
3197                     ; 659    uint8_t tmp = 0;
3199                     ; 660    tmp = getPHYCFGR();
3201  05a5 ae2e00        	ldw	x,#11776
3202  05a8 89            	pushw	x
3203  05a9 ae0000        	ldw	x,#0
3204  05ac 89            	pushw	x
3205  05ad cd0000        	call	_WIZCHIP_READ
3207  05b0 5b04          	addw	sp,#4
3208  05b2 6b01          	ld	(OFST+0,sp),a
3210                     ; 661    phyconf->by   = (tmp & PHYCFGR_OPMD) ? PHY_CONFBY_SW : PHY_CONFBY_HW;
3212  05b4 7b01          	ld	a,(OFST+0,sp)
3213  05b6 a540          	bcp	a,#64
3214  05b8 2704          	jreq	L621
3215  05ba a601          	ld	a,#1
3216  05bc 2001          	jra	L031
3217  05be               L621:
3218  05be 4f            	clr	a
3219  05bf               L031:
3220  05bf 1e02          	ldw	x,(OFST+1,sp)
3221  05c1 f7            	ld	(x),a
3222                     ; 662    switch(tmp & PHYCFGR_OPMDC_ALLA)
3224  05c2 7b01          	ld	a,(OFST+0,sp)
3225  05c4 a438          	and	a,#56
3227                     ; 670          break;
3228  05c6 a020          	sub	a,#32
3229  05c8 270a          	jreq	L1331
3230  05ca a018          	sub	a,#24
3231  05cc 2706          	jreq	L1331
3232  05ce               L3331:
3233                     ; 668       default:
3233                     ; 669          phyconf->mode = PHY_MODE_MANUAL;
3235  05ce 1e02          	ldw	x,(OFST+1,sp)
3236  05d0 6f01          	clr	(1,x)
3237                     ; 670          break;
3239  05d2 2006          	jra	L3731
3240  05d4               L1331:
3241                     ; 664       case PHYCFGR_OPMDC_ALLA:
3241                     ; 665       case PHYCFGR_OPMDC_100FA: 
3241                     ; 666          phyconf->mode = PHY_MODE_AUTONEGO;
3243  05d4 1e02          	ldw	x,(OFST+1,sp)
3244  05d6 a601          	ld	a,#1
3245  05d8 e701          	ld	(1,x),a
3246                     ; 667          break;
3248  05da               L3731:
3249                     ; 672    switch(tmp & PHYCFGR_OPMDC_ALLA)
3251  05da 7b01          	ld	a,(OFST+0,sp)
3252  05dc a438          	and	a,#56
3254                     ; 681          break;
3255  05de a010          	sub	a,#16
3256  05e0 270e          	jreq	L5331
3257  05e2 a008          	sub	a,#8
3258  05e4 270a          	jreq	L5331
3259  05e6 a008          	sub	a,#8
3260  05e8 2706          	jreq	L5331
3261  05ea               L7331:
3262                     ; 679       default:
3262                     ; 680          phyconf->speed = PHY_SPEED_10;
3264  05ea 1e02          	ldw	x,(OFST+1,sp)
3265  05ec 6f02          	clr	(2,x)
3266                     ; 681          break;
3268  05ee 2006          	jra	L7731
3269  05f0               L5331:
3270                     ; 674       case PHYCFGR_OPMDC_100FA:
3270                     ; 675       case PHYCFGR_OPMDC_100F:
3270                     ; 676       case PHYCFGR_OPMDC_100H:
3270                     ; 677          phyconf->speed = PHY_SPEED_100;
3272  05f0 1e02          	ldw	x,(OFST+1,sp)
3273  05f2 a601          	ld	a,#1
3274  05f4 e702          	ld	(2,x),a
3275                     ; 678          break;
3277  05f6               L7731:
3278                     ; 683    switch(tmp & PHYCFGR_OPMDC_ALLA)
3280  05f6 7b01          	ld	a,(OFST+0,sp)
3281  05f8 a438          	and	a,#56
3283                     ; 692          break;
3284  05fa a008          	sub	a,#8
3285  05fc 270e          	jreq	L1431
3286  05fe a010          	sub	a,#16
3287  0600 270a          	jreq	L1431
3288  0602 a008          	sub	a,#8
3289  0604 2706          	jreq	L1431
3290  0606               L3431:
3291                     ; 690       default:
3291                     ; 691          phyconf->duplex = PHY_DUPLEX_HALF;
3293  0606 1e02          	ldw	x,(OFST+1,sp)
3294  0608 6f03          	clr	(3,x)
3295                     ; 692          break;
3297  060a 2006          	jra	L3041
3298  060c               L1431:
3299                     ; 685       case PHYCFGR_OPMDC_100FA:
3299                     ; 686       case PHYCFGR_OPMDC_100F:
3299                     ; 687       case PHYCFGR_OPMDC_10F:
3299                     ; 688          phyconf->duplex = PHY_DUPLEX_FULL;
3301  060c 1e02          	ldw	x,(OFST+1,sp)
3302  060e a601          	ld	a,#1
3303  0610 e703          	ld	(3,x),a
3304                     ; 689          break;
3306  0612               L3041:
3307                     ; 694 }
3310  0612 5b03          	addw	sp,#3
3311  0614 81            	ret
3358                     ; 696 void wizphy_getphystat(wiz_PhyConf* phyconf)
3358                     ; 697 {
3359                     	switch	.text
3360  0615               _wizphy_getphystat:
3362  0615 89            	pushw	x
3363  0616 88            	push	a
3364       00000001      OFST:	set	1
3367                     ; 698    uint8_t tmp = getPHYCFGR();
3369  0617 ae2e00        	ldw	x,#11776
3370  061a 89            	pushw	x
3371  061b ae0000        	ldw	x,#0
3372  061e 89            	pushw	x
3373  061f cd0000        	call	_WIZCHIP_READ
3375  0622 5b04          	addw	sp,#4
3376  0624 6b01          	ld	(OFST+0,sp),a
3378                     ; 699    phyconf->duplex = (tmp & PHYCFGR_DPX_FULL) ? PHY_DUPLEX_FULL : PHY_DUPLEX_HALF;
3380  0626 7b01          	ld	a,(OFST+0,sp)
3381  0628 a504          	bcp	a,#4
3382  062a 2704          	jreq	L431
3383  062c a601          	ld	a,#1
3384  062e 2001          	jra	L631
3385  0630               L431:
3386  0630 4f            	clr	a
3387  0631               L631:
3388  0631 1e02          	ldw	x,(OFST+1,sp)
3389  0633 e703          	ld	(3,x),a
3390                     ; 700    phyconf->speed  = (tmp & PHYCFGR_SPD_100) ? PHY_SPEED_100 : PHY_SPEED_10;
3392  0635 7b01          	ld	a,(OFST+0,sp)
3393  0637 a502          	bcp	a,#2
3394  0639 2704          	jreq	L041
3395  063b a601          	ld	a,#1
3396  063d 2001          	jra	L241
3397  063f               L041:
3398  063f 4f            	clr	a
3399  0640               L241:
3400  0640 1e02          	ldw	x,(OFST+1,sp)
3401  0642 e702          	ld	(2,x),a
3402                     ; 701 }
3405  0644 5b03          	addw	sp,#3
3406  0646 81            	ret
3452                     ; 703 int8_t wizphy_setphypmode(uint8_t pmode)
3452                     ; 704 {
3453                     	switch	.text
3454  0647               _wizphy_setphypmode:
3456  0647 88            	push	a
3457  0648 88            	push	a
3458       00000001      OFST:	set	1
3461                     ; 705    uint8_t tmp = 0;
3463                     ; 706    tmp = getPHYCFGR();
3465  0649 ae2e00        	ldw	x,#11776
3466  064c 89            	pushw	x
3467  064d ae0000        	ldw	x,#0
3468  0650 89            	pushw	x
3469  0651 cd0000        	call	_WIZCHIP_READ
3471  0654 5b04          	addw	sp,#4
3472  0656 6b01          	ld	(OFST+0,sp),a
3474                     ; 707    if((tmp & PHYCFGR_OPMD)== 0) return -1;
3476  0658 7b01          	ld	a,(OFST+0,sp)
3477  065a a540          	bcp	a,#64
3478  065c 2604          	jrne	L3541
3481  065e a6ff          	ld	a,#255
3483  0660 2049          	jra	L641
3484  0662               L3541:
3485                     ; 708    tmp &= ~PHYCFGR_OPMDC_ALLA;         
3487  0662 7b01          	ld	a,(OFST+0,sp)
3488  0664 a4c7          	and	a,#199
3489  0666 6b01          	ld	(OFST+0,sp),a
3491                     ; 709    if( pmode == PHY_POWER_DOWN)
3493  0668 7b02          	ld	a,(OFST+1,sp)
3494  066a a101          	cp	a,#1
3495  066c 2608          	jrne	L5541
3496                     ; 710       tmp |= PHYCFGR_OPMDC_PDOWN;
3498  066e 7b01          	ld	a,(OFST+0,sp)
3499  0670 aa30          	or	a,#48
3500  0672 6b01          	ld	(OFST+0,sp),a
3503  0674 2006          	jra	L7541
3504  0676               L5541:
3505                     ; 712       tmp |= PHYCFGR_OPMDC_ALLA;
3507  0676 7b01          	ld	a,(OFST+0,sp)
3508  0678 aa38          	or	a,#56
3509  067a 6b01          	ld	(OFST+0,sp),a
3511  067c               L7541:
3512                     ; 713    setPHYCFGR(tmp);
3514  067c 7b01          	ld	a,(OFST+0,sp)
3515  067e 88            	push	a
3516  067f ae2e00        	ldw	x,#11776
3517  0682 89            	pushw	x
3518  0683 ae0000        	ldw	x,#0
3519  0686 89            	pushw	x
3520  0687 cd0000        	call	_WIZCHIP_WRITE
3522  068a 5b05          	addw	sp,#5
3523                     ; 714    wizphy_reset();
3525  068c cd04eb        	call	_wizphy_reset
3527                     ; 715    tmp = getPHYCFGR();
3529  068f ae2e00        	ldw	x,#11776
3530  0692 89            	pushw	x
3531  0693 ae0000        	ldw	x,#0
3532  0696 89            	pushw	x
3533  0697 cd0000        	call	_WIZCHIP_READ
3535  069a 5b04          	addw	sp,#4
3536  069c 6b01          	ld	(OFST+0,sp),a
3538                     ; 716    if( pmode == PHY_POWER_DOWN)
3540  069e 7b02          	ld	a,(OFST+1,sp)
3541  06a0 a101          	cp	a,#1
3542  06a2 2609          	jrne	L1641
3543                     ; 718       if(tmp & PHYCFGR_OPMDC_PDOWN) return 0;
3545  06a4 7b01          	ld	a,(OFST+0,sp)
3546  06a6 a530          	bcp	a,#48
3547  06a8 270c          	jreq	L5641
3550  06aa 4f            	clr	a
3552  06ab               L641:
3554  06ab 85            	popw	x
3555  06ac 81            	ret
3556  06ad               L1641:
3557                     ; 722       if(tmp & PHYCFGR_OPMDC_ALLA) return 0;
3559  06ad 7b01          	ld	a,(OFST+0,sp)
3560  06af a538          	bcp	a,#56
3561  06b1 2703          	jreq	L5641
3564  06b3 4f            	clr	a
3566  06b4 20f5          	jra	L641
3567  06b6               L5641:
3568                     ; 724    return -1;
3570  06b6 a6ff          	ld	a,#255
3572  06b8 20f1          	jra	L641
3699                     ; 729 void wizchip_setnetinfo(wiz_NetInfo* pnetinfo)
3699                     ; 730 {
3700                     	switch	.text
3701  06ba               _wizchip_setnetinfo:
3703  06ba 89            	pushw	x
3704       00000000      OFST:	set	0
3707                     ; 731    setSHAR(pnetinfo->mac);
3709  06bb ae0006        	ldw	x,#6
3710  06be 89            	pushw	x
3711  06bf 1e03          	ldw	x,(OFST+3,sp)
3712  06c1 89            	pushw	x
3713  06c2 ae0900        	ldw	x,#2304
3714  06c5 89            	pushw	x
3715  06c6 ae0000        	ldw	x,#0
3716  06c9 89            	pushw	x
3717  06ca cd0000        	call	_WIZCHIP_WRITE_BUF
3719  06cd 5b08          	addw	sp,#8
3720                     ; 732    setGAR(pnetinfo->gw);
3722  06cf ae0004        	ldw	x,#4
3723  06d2 89            	pushw	x
3724  06d3 1e03          	ldw	x,(OFST+3,sp)
3725  06d5 1c000e        	addw	x,#14
3726  06d8 89            	pushw	x
3727  06d9 ae0100        	ldw	x,#256
3728  06dc 89            	pushw	x
3729  06dd ae0000        	ldw	x,#0
3730  06e0 89            	pushw	x
3731  06e1 cd0000        	call	_WIZCHIP_WRITE_BUF
3733  06e4 5b08          	addw	sp,#8
3734                     ; 733    setSUBR(pnetinfo->sn);
3736  06e6 ae0004        	ldw	x,#4
3737  06e9 89            	pushw	x
3738  06ea 1e03          	ldw	x,(OFST+3,sp)
3739  06ec 1c000a        	addw	x,#10
3740  06ef 89            	pushw	x
3741  06f0 ae0500        	ldw	x,#1280
3742  06f3 89            	pushw	x
3743  06f4 ae0000        	ldw	x,#0
3744  06f7 89            	pushw	x
3745  06f8 cd0000        	call	_WIZCHIP_WRITE_BUF
3747  06fb 5b08          	addw	sp,#8
3748                     ; 734    setSIPR(pnetinfo->ip);
3750  06fd ae0004        	ldw	x,#4
3751  0700 89            	pushw	x
3752  0701 1e03          	ldw	x,(OFST+3,sp)
3753  0703 1c0006        	addw	x,#6
3754  0706 89            	pushw	x
3755  0707 ae0f00        	ldw	x,#3840
3756  070a 89            	pushw	x
3757  070b ae0000        	ldw	x,#0
3758  070e 89            	pushw	x
3759  070f cd0000        	call	_WIZCHIP_WRITE_BUF
3761  0712 5b08          	addw	sp,#8
3762                     ; 735    _DNS_[0] = pnetinfo->dns[0];
3764  0714 1e01          	ldw	x,(OFST+1,sp)
3765  0716 e612          	ld	a,(18,x)
3766  0718 b701          	ld	L371__DNS_,a
3767                     ; 736    _DNS_[1] = pnetinfo->dns[1];
3769  071a 1e01          	ldw	x,(OFST+1,sp)
3770  071c e613          	ld	a,(19,x)
3771  071e b702          	ld	L371__DNS_+1,a
3772                     ; 737    _DNS_[2] = pnetinfo->dns[2];
3774  0720 1e01          	ldw	x,(OFST+1,sp)
3775  0722 e614          	ld	a,(20,x)
3776  0724 b703          	ld	L371__DNS_+2,a
3777                     ; 738    _DNS_[3] = pnetinfo->dns[3];
3779  0726 1e01          	ldw	x,(OFST+1,sp)
3780  0728 e615          	ld	a,(21,x)
3781  072a b704          	ld	L371__DNS_+3,a
3782                     ; 739    _DHCP_   = pnetinfo->dhcp;
3784  072c 1e01          	ldw	x,(OFST+1,sp)
3785  072e e616          	ld	a,(22,x)
3786  0730 b700          	ld	L571__DHCP_,a
3787                     ; 740 }
3790  0732 85            	popw	x
3791  0733 81            	ret
3831                     ; 742 void wizchip_getnetinfo(wiz_NetInfo* pnetinfo)
3831                     ; 743 {
3832                     	switch	.text
3833  0734               _wizchip_getnetinfo:
3835  0734 89            	pushw	x
3836       00000000      OFST:	set	0
3839                     ; 744    getSHAR(pnetinfo->mac);
3841  0735 ae0006        	ldw	x,#6
3842  0738 89            	pushw	x
3843  0739 1e03          	ldw	x,(OFST+3,sp)
3844  073b 89            	pushw	x
3845  073c ae0900        	ldw	x,#2304
3846  073f 89            	pushw	x
3847  0740 ae0000        	ldw	x,#0
3848  0743 89            	pushw	x
3849  0744 cd0000        	call	_WIZCHIP_READ_BUF
3851  0747 5b08          	addw	sp,#8
3852                     ; 745    getGAR(pnetinfo->gw);
3854  0749 ae0004        	ldw	x,#4
3855  074c 89            	pushw	x
3856  074d 1e03          	ldw	x,(OFST+3,sp)
3857  074f 1c000e        	addw	x,#14
3858  0752 89            	pushw	x
3859  0753 ae0100        	ldw	x,#256
3860  0756 89            	pushw	x
3861  0757 ae0000        	ldw	x,#0
3862  075a 89            	pushw	x
3863  075b cd0000        	call	_WIZCHIP_READ_BUF
3865  075e 5b08          	addw	sp,#8
3866                     ; 746    getSUBR(pnetinfo->sn);
3868  0760 ae0004        	ldw	x,#4
3869  0763 89            	pushw	x
3870  0764 1e03          	ldw	x,(OFST+3,sp)
3871  0766 1c000a        	addw	x,#10
3872  0769 89            	pushw	x
3873  076a ae0500        	ldw	x,#1280
3874  076d 89            	pushw	x
3875  076e ae0000        	ldw	x,#0
3876  0771 89            	pushw	x
3877  0772 cd0000        	call	_WIZCHIP_READ_BUF
3879  0775 5b08          	addw	sp,#8
3880                     ; 747    getSIPR(pnetinfo->ip);
3882  0777 ae0004        	ldw	x,#4
3883  077a 89            	pushw	x
3884  077b 1e03          	ldw	x,(OFST+3,sp)
3885  077d 1c0006        	addw	x,#6
3886  0780 89            	pushw	x
3887  0781 ae0f00        	ldw	x,#3840
3888  0784 89            	pushw	x
3889  0785 ae0000        	ldw	x,#0
3890  0788 89            	pushw	x
3891  0789 cd0000        	call	_WIZCHIP_READ_BUF
3893  078c 5b08          	addw	sp,#8
3894                     ; 748    pnetinfo->dns[0]= _DNS_[0];
3896  078e 1e01          	ldw	x,(OFST+1,sp)
3897  0790 b601          	ld	a,L371__DNS_
3898  0792 e712          	ld	(18,x),a
3899                     ; 749    pnetinfo->dns[1]= _DNS_[1];
3901  0794 1e01          	ldw	x,(OFST+1,sp)
3902  0796 b602          	ld	a,L371__DNS_+1
3903  0798 e713          	ld	(19,x),a
3904                     ; 750    pnetinfo->dns[2]= _DNS_[2];
3906  079a 1e01          	ldw	x,(OFST+1,sp)
3907  079c b603          	ld	a,L371__DNS_+2
3908  079e e714          	ld	(20,x),a
3909                     ; 751    pnetinfo->dns[3]= _DNS_[3];
3911  07a0 1e01          	ldw	x,(OFST+1,sp)
3912  07a2 b604          	ld	a,L371__DNS_+3
3913  07a4 e715          	ld	(21,x),a
3914                     ; 752    pnetinfo->dhcp  = _DHCP_;
3916  07a6 1e01          	ldw	x,(OFST+1,sp)
3917  07a8 b600          	ld	a,L571__DHCP_
3918  07aa e716          	ld	(22,x),a
3919                     ; 753 }
3922  07ac 85            	popw	x
3923  07ad 81            	ret
4003                     ; 755 int8_t wizchip_setnetmode(netmode_type netmode)
4003                     ; 756 {
4004                     	switch	.text
4005  07ae               _wizchip_setnetmode:
4007  07ae 88            	push	a
4008  07af 88            	push	a
4009       00000001      OFST:	set	1
4012                     ; 757    uint8_t tmp = 0;
4014                     ; 761    if(netmode & ~(NM_WAKEONLAN | NM_PPPOE | NM_PINGBLOCK | NM_FORCEARP)) return -1;
4016  07b0 5f            	clrw	x
4017  07b1 97            	ld	xl,a
4018  07b2 01            	rrwa	x,a
4019  07b3 a4c5          	and	a,#197
4020  07b5 01            	rrwa	x,a
4021  07b6 a4ff          	and	a,#255
4022  07b8 01            	rrwa	x,a
4023  07b9 a30000        	cpw	x,#0
4024  07bc 2704          	jreq	L3361
4027  07be a6ff          	ld	a,#255
4029  07c0 2026          	jra	L651
4030  07c2               L3361:
4031                     ; 763    tmp = getMR();
4033  07c2 ae0000        	ldw	x,#0
4034  07c5 89            	pushw	x
4035  07c6 ae0000        	ldw	x,#0
4036  07c9 89            	pushw	x
4037  07ca cd0000        	call	_WIZCHIP_READ
4039  07cd 5b04          	addw	sp,#4
4040  07cf 6b01          	ld	(OFST+0,sp),a
4042                     ; 764    tmp |= (uint8_t)netmode;
4044  07d1 7b01          	ld	a,(OFST+0,sp)
4045  07d3 1a02          	or	a,(OFST+1,sp)
4046  07d5 6b01          	ld	(OFST+0,sp),a
4048                     ; 765    setMR(tmp);
4050  07d7 7b01          	ld	a,(OFST+0,sp)
4051  07d9 88            	push	a
4052  07da ae0000        	ldw	x,#0
4053  07dd 89            	pushw	x
4054  07de ae0000        	ldw	x,#0
4055  07e1 89            	pushw	x
4056  07e2 cd0000        	call	_WIZCHIP_WRITE
4058  07e5 5b05          	addw	sp,#5
4059                     ; 766    return 0;
4061  07e7 4f            	clr	a
4063  07e8               L651:
4065  07e8 85            	popw	x
4066  07e9 81            	ret
4091                     ; 769 netmode_type wizchip_getnetmode(void)
4091                     ; 770 {
4092                     	switch	.text
4093  07ea               _wizchip_getnetmode:
4097                     ; 771    return (netmode_type) getMR();
4099  07ea ae0000        	ldw	x,#0
4100  07ed 89            	pushw	x
4101  07ee ae0000        	ldw	x,#0
4102  07f1 89            	pushw	x
4103  07f2 cd0000        	call	_WIZCHIP_READ
4105  07f5 5b04          	addw	sp,#4
4108  07f7 81            	ret
4167                     ; 774 void wizchip_settimeout(wiz_NetTimeout* nettime)
4167                     ; 775 {
4168                     	switch	.text
4169  07f8               _wizchip_settimeout:
4171  07f8 89            	pushw	x
4172       00000000      OFST:	set	0
4175                     ; 776    setRCR(nettime->retry_cnt);
4177  07f9 f6            	ld	a,(x)
4178  07fa 88            	push	a
4179  07fb ae1b00        	ldw	x,#6912
4180  07fe 89            	pushw	x
4181  07ff ae0000        	ldw	x,#0
4182  0802 89            	pushw	x
4183  0803 cd0000        	call	_WIZCHIP_WRITE
4185  0806 5b05          	addw	sp,#5
4186                     ; 777    setRTR(nettime->time_100us);
4188  0808 1e01          	ldw	x,(OFST+1,sp)
4189  080a ee01          	ldw	x,(1,x)
4190  080c 4f            	clr	a
4191  080d 01            	rrwa	x,a
4192  080e 9f            	ld	a,xl
4193  080f 88            	push	a
4194  0810 ae1900        	ldw	x,#6400
4195  0813 89            	pushw	x
4196  0814 ae0000        	ldw	x,#0
4197  0817 89            	pushw	x
4198  0818 cd0000        	call	_WIZCHIP_WRITE
4200  081b 5b05          	addw	sp,#5
4203  081d 1e01          	ldw	x,(OFST+1,sp)
4204  081f e602          	ld	a,(2,x)
4205  0821 88            	push	a
4206  0822 ae1a00        	ldw	x,#6656
4207  0825 89            	pushw	x
4208  0826 ae0000        	ldw	x,#0
4209  0829 89            	pushw	x
4210  082a cd0000        	call	_WIZCHIP_WRITE
4212  082d 5b05          	addw	sp,#5
4213                     ; 778 }
4217  082f 85            	popw	x
4218  0830 81            	ret
4256                     ; 780 void wizchip_gettimeout(wiz_NetTimeout* nettime)
4256                     ; 781 {
4257                     	switch	.text
4258  0831               _wizchip_gettimeout:
4260  0831 89            	pushw	x
4261  0832 88            	push	a
4262       00000001      OFST:	set	1
4265                     ; 782    nettime->retry_cnt = getRCR();
4267  0833 ae1b00        	ldw	x,#6912
4268  0836 89            	pushw	x
4269  0837 ae0000        	ldw	x,#0
4270  083a 89            	pushw	x
4271  083b cd0000        	call	_WIZCHIP_READ
4273  083e 5b04          	addw	sp,#4
4274  0840 1e02          	ldw	x,(OFST+1,sp)
4275  0842 f7            	ld	(x),a
4276                     ; 783    nettime->time_100us = getRTR();
4278  0843 ae1a00        	ldw	x,#6656
4279  0846 89            	pushw	x
4280  0847 ae0000        	ldw	x,#0
4281  084a 89            	pushw	x
4282  084b cd0000        	call	_WIZCHIP_READ
4284  084e 5b04          	addw	sp,#4
4285  0850 6b01          	ld	(OFST+0,sp),a
4287  0852 ae1900        	ldw	x,#6400
4288  0855 89            	pushw	x
4289  0856 ae0000        	ldw	x,#0
4290  0859 89            	pushw	x
4291  085a cd0000        	call	_WIZCHIP_READ
4293  085d 5b04          	addw	sp,#4
4294  085f 5f            	clrw	x
4295  0860 97            	ld	xl,a
4296  0861 4f            	clr	a
4297  0862 02            	rlwa	x,a
4298  0863 01            	rrwa	x,a
4299  0864 1b01          	add	a,(OFST+0,sp)
4300  0866 2401          	jrnc	L661
4301  0868 5c            	incw	x
4302  0869               L661:
4303  0869 1602          	ldw	y,(OFST+1,sp)
4304  086b 02            	rlwa	x,a
4305  086c 90ef01        	ldw	(1,y),x
4306  086f 01            	rrwa	x,a
4307                     ; 784 }
4310  0870 5b03          	addw	sp,#3
4311  0872 81            	ret
4575                     	switch	.ubsct
4576  0000               L571__DHCP_:
4577  0000 00            	ds.b	1
4578  0001               L371__DNS_:
4579  0001 00000000      	ds.b	4
4580                     	xdef	_wizchip_spi_writeburst
4581                     	xdef	_wizchip_spi_readburst
4582                     	xdef	_wizchip_spi_writebyte
4583                     	xdef	_wizchip_spi_readbyte
4584                     	xdef	_wizchip_bus_writedata
4585                     	xdef	_wizchip_bus_readdata
4586                     	xdef	_wizchip_cs_deselect
4587                     	xdef	_wizchip_cs_select
4588                     	xdef	_wizchip_cris_exit
4589                     	xdef	_wizchip_cris_enter
4590                     	xdef	_wizchip_gettimeout
4591                     	xdef	_wizchip_settimeout
4592                     	xdef	_wizchip_getnetmode
4593                     	xdef	_wizchip_setnetmode
4594                     	xdef	_wizchip_getnetinfo
4595                     	xdef	_wizchip_setnetinfo
4596                     	xdef	_wizphy_setphypmode
4597                     	xdef	_wizphy_getphystat
4598                     	xdef	_wizphy_getphyconf
4599                     	xdef	_wizphy_setphyconf
4600                     	xdef	_wizphy_reset
4601                     	xdef	_wizphy_getphypmode
4602                     	xdef	_wizphy_getphylink
4603                     	xdef	_wizchip_getinterruptmask
4604                     	xdef	_wizchip_setinterruptmask
4605                     	xdef	_wizchip_getinterrupt
4606                     	xdef	_wizchip_clrinterrupt
4607                     	xdef	_wizchip_init
4608                     	xdef	_wizchip_sw_reset
4609                     	xdef	_ctlnetwork
4610                     	xdef	_ctlwizchip
4611                     	xdef	_reg_wizchip_spiburst_cbfunc
4612                     	xdef	_reg_wizchip_spi_cbfunc
4613                     	xdef	_reg_wizchip_bus_cbfunc
4614                     	xdef	_reg_wizchip_cs_cbfunc
4615                     	xdef	_reg_wizchip_cris_cbfunc
4616                     	xdef	_WIZCHIP
4617                     	xref	_WIZCHIP_WRITE_BUF
4618                     	xref	_WIZCHIP_READ_BUF
4619                     	xref	_WIZCHIP_WRITE
4620                     	xref	_WIZCHIP_READ
4621                     	xref.b	c_lreg
4622                     	xref.b	c_x
4642                     	xref	c_itolx
4643                     	xref	c_xymov
4644                     	end
