   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  14                     	bsct
  15  0000               L3_sock_any_port:
  16  0000 c000          	dc.w	-16384
  46                     	bsct
  47  0002               L12_current_state:
  48  0002 00            	dc.b	0
  49  0003 00            	dc.b	0
  50  0004 00            	dc.b	0
  51  0005 00            	dc.b	0
  82                     ; 13 void hal_w5500_reset_high(void)
  82                     ; 14 {
  84                     	switch	.text
  85  0000               _hal_w5500_reset_high:
  89                     ; 15     GPIO_WriteHigh(W5500_RST_PORT, W5500_RST_PIN);
  91  0000 4b20          	push	#32
  92  0002 ae5014        	ldw	x,#20500
  93  0005 cd0000        	call	_GPIO_WriteHigh
  95  0008 84            	pop	a
  96                     ; 16 }
  99  0009 81            	ret
 152                     ; 18 void delay_ms(uint16_t ms)
 152                     ; 19 {
 153                     	switch	.text
 154  000a               _delay_ms:
 156  000a 89            	pushw	x
 157  000b 5204          	subw	sp,#4
 158       00000004      OFST:	set	4
 161                     ; 22     for(i=0;i<ms;i++)
 163  000d 5f            	clrw	x
 164  000e 1f01          	ldw	(OFST-3,sp),x
 167  0010 2019          	jra	L37
 168  0012               L76:
 169                     ; 24         for(j=0;j<1600;j++)
 171  0012 5f            	clrw	x
 172  0013 1f03          	ldw	(OFST-1,sp),x
 174  0015               L77:
 175                     ; 26             nop();
 178  0015 9d            nop
 180                     ; 24         for(j=0;j<1600;j++)
 183  0016 1e03          	ldw	x,(OFST-1,sp)
 184  0018 1c0001        	addw	x,#1
 185  001b 1f03          	ldw	(OFST-1,sp),x
 189  001d 1e03          	ldw	x,(OFST-1,sp)
 190  001f a30640        	cpw	x,#1600
 191  0022 25f1          	jrult	L77
 192                     ; 22     for(i=0;i<ms;i++)
 194  0024 1e01          	ldw	x,(OFST-3,sp)
 195  0026 1c0001        	addw	x,#1
 196  0029 1f01          	ldw	(OFST-3,sp),x
 198  002b               L37:
 201  002b 1e01          	ldw	x,(OFST-3,sp)
 202  002d 1305          	cpw	x,(OFST+1,sp)
 203  002f 25e1          	jrult	L76
 204                     ; 29 }
 207  0031 5b06          	addw	sp,#6
 208  0033 81            	ret
 245                     ; 30 uint8_t hal_spi_byte(uint8_t data)
 245                     ; 31 {
 246                     	switch	.text
 247  0034               _hal_spi_byte:
 249  0034 88            	push	a
 250       00000000      OFST:	set	0
 253  0035               L521:
 254                     ; 32     while (SPI_GetFlagStatus(SPI_FLAG_TXE) == RESET);
 256  0035 a602          	ld	a,#2
 257  0037 cd0000        	call	_SPI_GetFlagStatus
 259  003a 4d            	tnz	a
 260  003b 27f8          	jreq	L521
 261                     ; 34     SPI_SendData(data);
 263  003d 7b01          	ld	a,(OFST+1,sp)
 264  003f cd0000        	call	_SPI_SendData
 267  0042               L331:
 268                     ; 36     while (SPI_GetFlagStatus(SPI_FLAG_RXNE) == RESET);
 270  0042 a601          	ld	a,#1
 271  0044 cd0000        	call	_SPI_GetFlagStatus
 273  0047 4d            	tnz	a
 274  0048 27f8          	jreq	L331
 275                     ; 38     return SPI_ReceiveData();
 277  004a cd0000        	call	_SPI_ReceiveData
 281  004d 5b01          	addw	sp,#1
 282  004f 81            	ret
 306                     ; 40 void hal_spi_cs_low(void)
 306                     ; 41 {
 307                     	switch	.text
 308  0050               _hal_spi_cs_low:
 312                     ; 42     GPIO_WriteLow(W5500_CS_PORT, W5500_CS_PIN);
 314  0050 4b08          	push	#8
 315  0052 ae5000        	ldw	x,#20480
 316  0055 cd0000        	call	_GPIO_WriteLow
 318  0058 84            	pop	a
 319                     ; 43 }
 322  0059 81            	ret
 346                     ; 45 void hal_spi_cs_high(void)
 346                     ; 46 {
 347                     	switch	.text
 348  005a               _hal_spi_cs_high:
 352                     ; 47     GPIO_WriteHigh(W5500_CS_PORT, W5500_CS_PIN);
 354  005a 4b08          	push	#8
 355  005c ae5000        	ldw	x,#20480
 356  005f cd0000        	call	_GPIO_WriteHigh
 358  0062 84            	pop	a
 359                     ; 48 }
 362  0063 81            	ret
 416                     ; 50 void hal_spi_read(uint8_t *buf, uint16_t len){
 417                     	switch	.text
 418  0064               _hal_spi_read:
 420  0064 89            	pushw	x
 421  0065 89            	pushw	x
 422       00000002      OFST:	set	2
 425                     ; 52     for(i = 0; i < len; i++){
 427  0066 5f            	clrw	x
 428  0067 1f01          	ldw	(OFST-1,sp),x
 431  0069 2011          	jra	L112
 432  006b               L502:
 433                     ; 53         buf[i] = hal_spi_byte(0xFF);
 435  006b a6ff          	ld	a,#255
 436  006d adc5          	call	_hal_spi_byte
 438  006f 1e03          	ldw	x,(OFST+1,sp)
 439  0071 72fb01        	addw	x,(OFST-1,sp)
 440  0074 f7            	ld	(x),a
 441                     ; 52     for(i = 0; i < len; i++){
 443  0075 1e01          	ldw	x,(OFST-1,sp)
 444  0077 1c0001        	addw	x,#1
 445  007a 1f01          	ldw	(OFST-1,sp),x
 447  007c               L112:
 450  007c 1e01          	ldw	x,(OFST-1,sp)
 451  007e 1307          	cpw	x,(OFST+5,sp)
 452  0080 25e9          	jrult	L502
 453                     ; 55 }
 456  0082 5b04          	addw	sp,#4
 457  0084 81            	ret
 511                     ; 57 void hal_spi_write(uint8_t *buf, uint16_t len){
 512                     	switch	.text
 513  0085               _hal_spi_write:
 515  0085 89            	pushw	x
 516  0086 89            	pushw	x
 517       00000002      OFST:	set	2
 520                     ; 59     for(i = 0; i < len; i++){
 522  0087 5f            	clrw	x
 523  0088 1f01          	ldw	(OFST-1,sp),x
 526  008a 200f          	jra	L742
 527  008c               L342:
 528                     ; 60         hal_spi_byte(buf[i]);
 530  008c 1e03          	ldw	x,(OFST+1,sp)
 531  008e 72fb01        	addw	x,(OFST-1,sp)
 532  0091 f6            	ld	a,(x)
 533  0092 ada0          	call	_hal_spi_byte
 535                     ; 59     for(i = 0; i < len; i++){
 537  0094 1e01          	ldw	x,(OFST-1,sp)
 538  0096 1c0001        	addw	x,#1
 539  0099 1f01          	ldw	(OFST-1,sp),x
 541  009b               L742:
 544  009b 1e01          	ldw	x,(OFST-1,sp)
 545  009d 1307          	cpw	x,(OFST+5,sp)
 546  009f 25eb          	jrult	L342
 547                     ; 62 }
 550  00a1 5b04          	addw	sp,#4
 551  00a3 81            	ret
 575                     ; 63 uint8_t hal_spi_read_byte(void)
 575                     ; 64 {
 576                     	switch	.text
 577  00a4               _hal_spi_read_byte:
 581                     ; 65     return hal_spi_byte(0xFF);
 583  00a4 a6ff          	ld	a,#255
 584  00a6 ad8c          	call	_hal_spi_byte
 588  00a8 81            	ret
 623                     ; 67 void hal_spi_write_byte(uint8_t data)
 623                     ; 68 {
 624                     	switch	.text
 625  00a9               _hal_spi_write_byte:
 629                     ; 69     hal_spi_byte(data);
 631  00a9 ad89          	call	_hal_spi_byte
 633                     ; 70 }
 636  00ab 81            	ret
 828                     ; 71 uint8_t hal_di_read(uint8_t di_num)
 828                     ; 72 {
 829                     	switch	.text
 830  00ac               _hal_di_read:
 832  00ac 5203          	subw	sp,#3
 833       00000003      OFST:	set	3
 836                     ; 76     switch (di_num) {
 839                     ; 81         default: return 0;
 840  00ae 4a            	dec	a
 841  00af 270c          	jreq	L103
 842  00b1 4a            	dec	a
 843  00b2 2714          	jreq	L303
 844  00b4 4a            	dec	a
 845  00b5 271c          	jreq	L503
 846  00b7 4a            	dec	a
 847  00b8 2724          	jreq	L703
 848  00ba               L113:
 851  00ba 4f            	clr	a
 853  00bb 203d          	jra	L43
 854  00bd               L103:
 855                     ; 77         case 1: port = DI1_PORT; pin = DI1_PIN; break;
 857  00bd ae500f        	ldw	x,#20495
 858  00c0 1f01          	ldw	(OFST-2,sp),x
 862  00c2 a604          	ld	a,#4
 863  00c4 6b03          	ld	(OFST+0,sp),a
 867  00c6 201f          	jra	L724
 868  00c8               L303:
 869                     ; 78         case 2: port = DI2_PORT; pin = DI2_PIN; break;
 871  00c8 ae500f        	ldw	x,#20495
 872  00cb 1f01          	ldw	(OFST-2,sp),x
 876  00cd a608          	ld	a,#8
 877  00cf 6b03          	ld	(OFST+0,sp),a
 881  00d1 2014          	jra	L724
 882  00d3               L503:
 883                     ; 79         case 3: port = DI3_PORT; pin = DI3_PIN; break;
 885  00d3 ae500f        	ldw	x,#20495
 886  00d6 1f01          	ldw	(OFST-2,sp),x
 890  00d8 a610          	ld	a,#16
 891  00da 6b03          	ld	(OFST+0,sp),a
 895  00dc 2009          	jra	L724
 896  00de               L703:
 897                     ; 80         case 4: port = DI4_PORT; pin = DI4_PIN; break;
 899  00de ae500f        	ldw	x,#20495
 900  00e1 1f01          	ldw	(OFST-2,sp),x
 904  00e3 a680          	ld	a,#128
 905  00e5 6b03          	ld	(OFST+0,sp),a
 909  00e7               L724:
 910                     ; 83     return (GPIO_ReadInputPin(port, pin) == SET) ? 0 : 1;
 912  00e7 7b03          	ld	a,(OFST+0,sp)
 913  00e9 88            	push	a
 914  00ea 1e02          	ldw	x,(OFST-1,sp)
 915  00ec cd0000        	call	_GPIO_ReadInputPin
 917  00ef 5b01          	addw	sp,#1
 918  00f1 a101          	cp	a,#1
 919  00f3 2603          	jrne	L03
 920  00f5 4f            	clr	a
 921  00f6 2002          	jra	L23
 922  00f8               L03:
 923  00f8 a601          	ld	a,#1
 924  00fa               L23:
 926  00fa               L43:
 928  00fa 5b03          	addw	sp,#3
 929  00fc 81            	ret
 996                     ; 85 void hal_relay_set(uint8_t relay_num, uint8_t state)
 996                     ; 86 {
 997                     	switch	.text
 998  00fd               _hal_relay_set:
1000  00fd 89            	pushw	x
1001  00fe 5203          	subw	sp,#3
1002       00000003      OFST:	set	3
1005                     ; 90     switch(relay_num)
1007  0100 9e            	ld	a,xh
1009                     ; 98         default: return;
1010  0101 4a            	dec	a
1011  0102 2711          	jreq	L134
1012  0104 4a            	dec	a
1013  0105 2719          	jreq	L334
1014  0107 4a            	dec	a
1015  0108 2721          	jreq	L534
1016  010a 4a            	dec	a
1017  010b 2729          	jreq	L734
1018  010d 4a            	dec	a
1019  010e 2731          	jreq	L144
1020  0110 4a            	dec	a
1021  0111 2739          	jreq	L344
1022  0113               L544:
1025  0113 2058          	jra	L04
1026  0115               L134:
1027                     ; 92         case 1: port = RELAY1_PORT; pin = RELAY1_PIN; break;
1029  0115 ae5005        	ldw	x,#20485
1030  0118 1f01          	ldw	(OFST-2,sp),x
1034  011a a608          	ld	a,#8
1035  011c 6b03          	ld	(OFST+0,sp),a
1039  011e 2035          	jra	L505
1040  0120               L334:
1041                     ; 93         case 2: port = RELAY2_PORT; pin = RELAY2_PIN; break;
1043  0120 ae5005        	ldw	x,#20485
1044  0123 1f01          	ldw	(OFST-2,sp),x
1048  0125 a604          	ld	a,#4
1049  0127 6b03          	ld	(OFST+0,sp),a
1053  0129 202a          	jra	L505
1054  012b               L534:
1055                     ; 94         case 3: port = RELAY3_PORT; pin = RELAY3_PIN; break;
1057  012b ae5005        	ldw	x,#20485
1058  012e 1f01          	ldw	(OFST-2,sp),x
1062  0130 a602          	ld	a,#2
1063  0132 6b03          	ld	(OFST+0,sp),a
1067  0134 201f          	jra	L505
1068  0136               L734:
1069                     ; 95         case 4: port = RELAY4_PORT; pin = RELAY4_PIN; break;
1071  0136 ae5005        	ldw	x,#20485
1072  0139 1f01          	ldw	(OFST-2,sp),x
1076  013b a601          	ld	a,#1
1077  013d 6b03          	ld	(OFST+0,sp),a
1081  013f 2014          	jra	L505
1082  0141               L144:
1083                     ; 96         case 5: port = RELAY5_PORT; pin = RELAY5_PIN; break;
1085  0141 ae500a        	ldw	x,#20490
1086  0144 1f01          	ldw	(OFST-2,sp),x
1090  0146 a608          	ld	a,#8
1091  0148 6b03          	ld	(OFST+0,sp),a
1095  014a 2009          	jra	L505
1096  014c               L344:
1097                     ; 97         case 6: port = RELAY6_PORT; pin = RELAY6_PIN; break;
1099  014c ae500a        	ldw	x,#20490
1100  014f 1f01          	ldw	(OFST-2,sp),x
1104  0151 a610          	ld	a,#16
1105  0153 6b03          	ld	(OFST+0,sp),a
1109  0155               L505:
1110                     ; 102     if(state)
1112  0155 0d05          	tnz	(OFST+2,sp)
1113  0157 270b          	jreq	L705
1114                     ; 104         GPIO_WriteLow(port, pin);   // ON
1116  0159 7b03          	ld	a,(OFST+0,sp)
1117  015b 88            	push	a
1118  015c 1e02          	ldw	x,(OFST-1,sp)
1119  015e cd0000        	call	_GPIO_WriteLow
1121  0161 84            	pop	a
1123  0162 2009          	jra	L115
1124  0164               L705:
1125                     ; 108         GPIO_WriteHigh(port, pin);  // OFF
1127  0164 7b03          	ld	a,(OFST+0,sp)
1128  0166 88            	push	a
1129  0167 1e02          	ldw	x,(OFST-1,sp)
1130  0169 cd0000        	call	_GPIO_WriteHigh
1132  016c 84            	pop	a
1133  016d               L115:
1134                     ; 110 }
1135  016d               L04:
1138  016d 5b05          	addw	sp,#5
1139  016f 81            	ret
1165                     ; 111 void sensor_reader_update(void){
1166                     	switch	.text
1167  0170               _sensor_reader_update:
1171                     ; 112     current_state.di1 = hal_di_read(1);
1173  0170 a601          	ld	a,#1
1174  0172 cd00ac        	call	_hal_di_read
1176  0175 b702          	ld	L12_current_state,a
1177                     ; 113     current_state.di2 = hal_di_read(2);
1179  0177 a602          	ld	a,#2
1180  0179 cd00ac        	call	_hal_di_read
1182  017c b703          	ld	L12_current_state+1,a
1183                     ; 114     current_state.di3 = hal_di_read(3);
1185  017e a603          	ld	a,#3
1186  0180 cd00ac        	call	_hal_di_read
1188  0183 b704          	ld	L12_current_state+2,a
1189                     ; 115     current_state.di4 = hal_di_read(4);
1191  0185 a604          	ld	a,#4
1192  0187 cd00ac        	call	_hal_di_read
1194  018a b705          	ld	L12_current_state+3,a
1195                     ; 116 }
1198  018c 81            	ret
1222                     ; 117 void relay_off(void){
1223                     	switch	.text
1224  018d               _relay_off:
1228                     ; 118     hal_relay_set(1,1);
1230  018d ae0101        	ldw	x,#257
1231  0190 cd00fd        	call	_hal_relay_set
1233                     ; 119     hal_relay_set(2,1);
1235  0193 ae0201        	ldw	x,#513
1236  0196 cd00fd        	call	_hal_relay_set
1238                     ; 120     hal_relay_set(3,1);
1240  0199 ae0301        	ldw	x,#769
1241  019c cd00fd        	call	_hal_relay_set
1243                     ; 121     hal_relay_set(4,1);
1245  019f ae0401        	ldw	x,#1025
1246  01a2 cd00fd        	call	_hal_relay_set
1248                     ; 122     hal_relay_set(5,1);
1250  01a5 ae0501        	ldw	x,#1281
1251  01a8 cd00fd        	call	_hal_relay_set
1253                     ; 123     hal_relay_set(6,1);
1255  01ab ae0601        	ldw	x,#1537
1256  01ae cd00fd        	call	_hal_relay_set
1258                     ; 124 }
1261  01b1 81            	ret
1285                     ; 125 void sensor_reader_init(void)
1285                     ; 126 {
1286                     	switch	.text
1287  01b2               _sensor_reader_init:
1291                     ; 128     sensor_reader_update();
1293  01b2 adbc          	call	_sensor_reader_update
1295                     ; 129 }
1298  01b4 81            	ret
1301                     .const:	section	.text
1302  0000               L345_txsize:
1303  0000 10            	dc.b	16
1304  0001 00            	dc.b	0
1305  0002 00            	dc.b	0
1306  0003 00            	dc.b	0
1307  0004 00            	dc.b	0
1308  0005 00            	dc.b	0
1309  0006 00            	dc.b	0
1310  0007 00            	dc.b	0
1311  0008               L545_rxsize:
1312  0008 10            	dc.b	16
1313  0009 00            	dc.b	0
1314  000a 00            	dc.b	0
1315  000b 00            	dc.b	0
1316  000c 00            	dc.b	0
1317  000d 00            	dc.b	0
1318  000e 00            	dc.b	0
1319  000f 00            	dc.b	0
1397                     ; 130 void w5500_chip_init(void)
1397                     ; 131 {
1398                     	switch	.text
1399  01b5               _w5500_chip_init:
1401  01b5 5211          	subw	sp,#17
1402       00000011      OFST:	set	17
1405                     ; 133     uint8_t txsize[8] = {16,0,0,0,0,0,0,0};
1407  01b7 96            	ldw	x,sp
1408  01b8 1c0002        	addw	x,#OFST-15
1409  01bb 90ae0000      	ldw	y,#L345_txsize
1410  01bf a608          	ld	a,#8
1411  01c1 cd0000        	call	c_xymov
1413                     ; 134     uint8_t rxsize[8] = {16,0,0,0,0,0,0,0};
1415  01c4 96            	ldw	x,sp
1416  01c5 1c000a        	addw	x,#OFST-7
1417  01c8 90ae0008      	ldw	y,#L545_rxsize
1418  01cc a608          	ld	a,#8
1419  01ce cd0000        	call	c_xymov
1421                     ; 136     GPIO_WriteLow(W5500_RST_PORT, W5500_RST_PIN);
1423  01d1 4b20          	push	#32
1424  01d3 ae5014        	ldw	x,#20500
1425  01d6 cd0000        	call	_GPIO_WriteLow
1427  01d9 84            	pop	a
1428                     ; 137     delay_ms(100);
1430  01da ae0064        	ldw	x,#100
1431  01dd cd000a        	call	_delay_ms
1433                     ; 138     hal_w5500_reset_high();
1435  01e0 cd0000        	call	_hal_w5500_reset_high
1437                     ; 139     GPIO_WriteHigh(W5500_RST_PORT, W5500_RST_PIN);
1439  01e3 4b20          	push	#32
1440  01e5 ae5014        	ldw	x,#20500
1441  01e8 cd0000        	call	_GPIO_WriteHigh
1443  01eb 84            	pop	a
1444                     ; 140     CLK_PeripheralClockConfig(CLK_PERIPHERAL_SPI, ENABLE);
1446  01ec ae0101        	ldw	x,#257
1447  01ef cd0000        	call	_CLK_PeripheralClockConfig
1449                     ; 141     GPIO_Init(W5500_SCK_PORT,W5500_SCK_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
1451  01f2 4bf0          	push	#240
1452  01f4 4b20          	push	#32
1453  01f6 ae500a        	ldw	x,#20490
1454  01f9 cd0000        	call	_GPIO_Init
1456  01fc 85            	popw	x
1457                     ; 142     GPIO_Init(W5500_MOSI_PORT,W5500_MOSI_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
1459  01fd 4bf0          	push	#240
1460  01ff 4b40          	push	#64
1461  0201 ae500a        	ldw	x,#20490
1462  0204 cd0000        	call	_GPIO_Init
1464  0207 85            	popw	x
1465                     ; 143     GPIO_Init(W5500_MISO_PORT,W5500_MISO_PIN,GPIO_MODE_IN_FL_NO_IT);
1467  0208 4b00          	push	#0
1468  020a 4b80          	push	#128
1469  020c ae500a        	ldw	x,#20490
1470  020f cd0000        	call	_GPIO_Init
1472  0212 85            	popw	x
1473                     ; 144     GPIO_Init(W5500_CS_PORT,W5500_CS_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
1475  0213 4bf0          	push	#240
1476  0215 4b08          	push	#8
1477  0217 ae5000        	ldw	x,#20480
1478  021a cd0000        	call	_GPIO_Init
1480  021d 85            	popw	x
1481                     ; 145     GPIO_WriteHigh(W5500_CS_PORT, W5500_CS_PIN);
1483  021e 4b08          	push	#8
1484  0220 ae5000        	ldw	x,#20480
1485  0223 cd0000        	call	_GPIO_WriteHigh
1487  0226 84            	pop	a
1488                     ; 146     GPIO_Init(W5500_RST_PORT,W5500_RST_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
1490  0227 4bf0          	push	#240
1491  0229 4b20          	push	#32
1492  022b ae5014        	ldw	x,#20500
1493  022e cd0000        	call	_GPIO_Init
1495  0231 85            	popw	x
1496                     ; 147     SPI_DeInit();
1498  0232 cd0000        	call	_SPI_DeInit
1500                     ; 148         SPI_Init(
1500                     ; 149         SPI_FIRSTBIT_MSB,
1500                     ; 150         SPI_BAUDRATEPRESCALER_4,
1500                     ; 151         SPI_MODE_MASTER,
1500                     ; 152         SPI_CLOCKPOLARITY_LOW,
1500                     ; 153         SPI_CLOCKPHASE_1EDGE,
1500                     ; 154         SPI_DATADIRECTION_2LINES_FULLDUPLEX,
1500                     ; 155         SPI_NSS_SOFT,
1500                     ; 156         0x07
1500                     ; 157     );
1502  0235 4b07          	push	#7
1503  0237 4b02          	push	#2
1504  0239 4b00          	push	#0
1505  023b 4b00          	push	#0
1506  023d 4b00          	push	#0
1507  023f 4b04          	push	#4
1508  0241 ae0008        	ldw	x,#8
1509  0244 cd0000        	call	_SPI_Init
1511  0247 5b06          	addw	sp,#6
1512                     ; 159     SPI_Cmd(ENABLE);
1514  0249 a601          	ld	a,#1
1515  024b cd0000        	call	_SPI_Cmd
1517                     ; 160     reg_wizchip_spi_cbfunc(hal_spi_read_byte,hal_spi_write_byte);
1519  024e ae00a9        	ldw	x,#_hal_spi_write_byte
1520  0251 89            	pushw	x
1521  0252 ae00a4        	ldw	x,#_hal_spi_read_byte
1522  0255 cd0000        	call	_reg_wizchip_spi_cbfunc
1524  0258 85            	popw	x
1525                     ; 161     reg_wizchip_spiburst_cbfunc(hal_spi_read,hal_spi_write);
1527  0259 ae0085        	ldw	x,#_hal_spi_write
1528  025c 89            	pushw	x
1529  025d ae0064        	ldw	x,#_hal_spi_read
1530  0260 cd0000        	call	_reg_wizchip_spiburst_cbfunc
1532  0263 85            	popw	x
1533                     ; 162     reg_wizchip_cs_cbfunc(hal_spi_cs_low,hal_spi_cs_high);
1535  0264 ae005a        	ldw	x,#_hal_spi_cs_high
1536  0267 89            	pushw	x
1537  0268 ae0050        	ldw	x,#_hal_spi_cs_low
1538  026b cd0000        	call	_reg_wizchip_cs_cbfunc
1540  026e 85            	popw	x
1541                     ; 163     wizchip_init(txsize, rxsize);
1543  026f 96            	ldw	x,sp
1544  0270 1c000a        	addw	x,#OFST-7
1545  0273 89            	pushw	x
1546  0274 96            	ldw	x,sp
1547  0275 1c0004        	addw	x,#OFST-13
1548  0278 cd0000        	call	_wizchip_init
1550  027b 85            	popw	x
1551                     ; 164     version = getVERSIONR();
1553  027c ae0039        	ldw	x,#57
1554  027f 89            	pushw	x
1555  0280 ae0000        	ldw	x,#0
1556  0283 89            	pushw	x
1557  0284 cd0000        	call	_WIZCHIP_READ
1559  0287 5b04          	addw	sp,#4
1560  0289 6b01          	ld	(OFST-16,sp),a
1562                     ; 165     if(version != 0x04)
1564  028b 7b01          	ld	a,(OFST-16,sp)
1565  028d a104          	cp	a,#4
1566  028f 2702          	jreq	L575
1567  0291               L775:
1568                     ; 167         while(1);
1570  0291 20fe          	jra	L775
1571  0293               L575:
1572                     ; 169 }
1575  0293 5b11          	addw	sp,#17
1576  0295 81            	ret
1603                     ; 170 void hal_gpio_init(void)
1603                     ; 171 {
1604                     	switch	.text
1605  0296               _hal_gpio_init:
1609                     ; 173     GPIO_Init(DI1_PORT, DI1_PIN, GPIO_MODE_IN_PU_NO_IT);
1611  0296 4b40          	push	#64
1612  0298 4b04          	push	#4
1613  029a ae500f        	ldw	x,#20495
1614  029d cd0000        	call	_GPIO_Init
1616  02a0 85            	popw	x
1617                     ; 174     GPIO_Init(DI2_PORT, DI2_PIN, GPIO_MODE_IN_PU_NO_IT);
1619  02a1 4b40          	push	#64
1620  02a3 4b08          	push	#8
1621  02a5 ae500f        	ldw	x,#20495
1622  02a8 cd0000        	call	_GPIO_Init
1624  02ab 85            	popw	x
1625                     ; 175     GPIO_Init(DI3_PORT, DI3_PIN, GPIO_MODE_IN_PU_NO_IT);
1627  02ac 4b40          	push	#64
1628  02ae 4b10          	push	#16
1629  02b0 ae500f        	ldw	x,#20495
1630  02b3 cd0000        	call	_GPIO_Init
1632  02b6 85            	popw	x
1633                     ; 176     GPIO_Init(DI4_PORT, DI4_PIN, GPIO_MODE_IN_PU_NO_IT);
1635  02b7 4b40          	push	#64
1636  02b9 4b80          	push	#128
1637  02bb ae500f        	ldw	x,#20495
1638  02be cd0000        	call	_GPIO_Init
1640  02c1 85            	popw	x
1641                     ; 178     GPIO_Init(RELAY1_PORT, RELAY1_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
1643  02c2 4bf0          	push	#240
1644  02c4 4b08          	push	#8
1645  02c6 ae5005        	ldw	x,#20485
1646  02c9 cd0000        	call	_GPIO_Init
1648  02cc 85            	popw	x
1649                     ; 179     GPIO_Init(RELAY2_PORT, RELAY2_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
1651  02cd 4bf0          	push	#240
1652  02cf 4b04          	push	#4
1653  02d1 ae5005        	ldw	x,#20485
1654  02d4 cd0000        	call	_GPIO_Init
1656  02d7 85            	popw	x
1657                     ; 180     GPIO_Init(RELAY3_PORT, RELAY3_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
1659  02d8 4bf0          	push	#240
1660  02da 4b02          	push	#2
1661  02dc ae5005        	ldw	x,#20485
1662  02df cd0000        	call	_GPIO_Init
1664  02e2 85            	popw	x
1665                     ; 181     GPIO_Init(RELAY4_PORT, RELAY4_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
1667  02e3 4bf0          	push	#240
1668  02e5 4b01          	push	#1
1669  02e7 ae5005        	ldw	x,#20485
1670  02ea cd0000        	call	_GPIO_Init
1672  02ed 85            	popw	x
1673                     ; 182     GPIO_Init(RELAY5_PORT, RELAY5_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
1675  02ee 4bf0          	push	#240
1676  02f0 4b08          	push	#8
1677  02f2 ae500a        	ldw	x,#20490
1678  02f5 cd0000        	call	_GPIO_Init
1680  02f8 85            	popw	x
1681                     ; 183     GPIO_Init(RELAY6_PORT, RELAY6_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
1683  02f9 4bf0          	push	#240
1684  02fb 4b10          	push	#16
1685  02fd ae500a        	ldw	x,#20490
1686  0300 cd0000        	call	_GPIO_Init
1688  0303 85            	popw	x
1689                     ; 186     hal_relay_set(1,0);
1691  0304 ae0100        	ldw	x,#256
1692  0307 cd00fd        	call	_hal_relay_set
1694                     ; 187     hal_relay_set(2,0);
1696  030a ae0200        	ldw	x,#512
1697  030d cd00fd        	call	_hal_relay_set
1699                     ; 188     hal_relay_set(3,0);
1701  0310 ae0300        	ldw	x,#768
1702  0313 cd00fd        	call	_hal_relay_set
1704                     ; 189     hal_relay_set(4,0);
1706  0316 ae0400        	ldw	x,#1024
1707  0319 cd00fd        	call	_hal_relay_set
1709                     ; 190     hal_relay_set(5,0);
1711  031c ae0500        	ldw	x,#1280
1712  031f cd00fd        	call	_hal_relay_set
1714                     ; 191     hal_relay_set(6,0);
1716  0322 ae0600        	ldw	x,#1536
1717  0325 cd00fd        	call	_hal_relay_set
1719                     ; 192     delay_ms(3000);
1721  0328 ae0bb8        	ldw	x,#3000
1722  032b cd000a        	call	_delay_ms
1724                     ; 193     GPIO_Init(W5500_RST_PORT, W5500_RST_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
1726  032e 4bf0          	push	#240
1727  0330 4b20          	push	#32
1728  0332 ae5014        	ldw	x,#20500
1729  0335 cd0000        	call	_GPIO_Init
1731  0338 85            	popw	x
1732                     ; 194     GPIO_Init(HARDRST_PORT, HARDRST_PIN, GPIO_MODE_IN_PU_NO_IT);
1734  0339 4b40          	push	#64
1735  033b 4b80          	push	#128
1736  033d ae5005        	ldw	x,#20485
1737  0340 cd0000        	call	_GPIO_Init
1739  0343 85            	popw	x
1740                     ; 195     hal_w5500_reset_high();
1742  0344 cd0000        	call	_hal_w5500_reset_high
1744                     ; 196 }
1747  0347 81            	ret
1775                     ; 198 void system_init(void)
1775                     ; 199 {
1776                     	switch	.text
1777  0348               _system_init:
1781                     ; 200     CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);
1783  0348 4f            	clr	a
1784  0349 cd0000        	call	_CLK_HSIPrescalerConfig
1786                     ; 201     hal_gpio_init();
1788  034c cd0296        	call	_hal_gpio_init
1790                     ; 202     relay_off();
1792  034f cd018d        	call	_relay_off
1794                     ; 203     sensor_reader_init();
1796  0352 cd01b2        	call	_sensor_reader_init
1798                     ; 204     w5500_chip_init();
1800  0355 cd01b5        	call	_w5500_chip_init
1802                     ; 205 }
1805  0358 81            	ret
1828                     ; 207 void main_loop(void)
1828                     ; 208 {
1829                     	switch	.text
1830  0359               _main_loop:
1834  0359               L336:
1835  0359 20fe          	jra	L336
1860                     ; 213 int main(void)
1860                     ; 214 {
1861                     	switch	.text
1862  035b               _main:
1866                     ; 215     system_init();
1868  035b adeb          	call	_system_init
1870                     ; 216     main_loop();
1872  035d adfa          	call	_main_loop
1874  035f               L746:
1875                     ; 218     while(1);
1877  035f 20fe          	jra	L746
1937                     	xdef	_main
1938                     	xdef	_main_loop
1939                     	xdef	_system_init
1940                     	xdef	_hal_gpio_init
1941                     	xdef	_w5500_chip_init
1942                     	xdef	_sensor_reader_init
1943                     	xdef	_relay_off
1944                     	xdef	_sensor_reader_update
1945                     	xdef	_hal_relay_set
1946                     	xdef	_hal_di_read
1947                     	xdef	_hal_spi_write_byte
1948                     	xdef	_hal_spi_read_byte
1949                     	xdef	_hal_spi_write
1950                     	xdef	_hal_spi_read
1951                     	xdef	_hal_spi_cs_high
1952                     	xdef	_hal_spi_cs_low
1953                     	xdef	_hal_spi_byte
1954                     	xdef	_delay_ms
1955                     	xdef	_hal_w5500_reset_high
1956                     	xref	_wizchip_init
1957                     	xref	_reg_wizchip_spiburst_cbfunc
1958                     	xref	_reg_wizchip_spi_cbfunc
1959                     	xref	_reg_wizchip_cs_cbfunc
1960                     	xref	_WIZCHIP_READ
1961                     	xref	_SPI_GetFlagStatus
1962                     	xref	_SPI_ReceiveData
1963                     	xref	_SPI_SendData
1964                     	xref	_SPI_Cmd
1965                     	xref	_SPI_Init
1966                     	xref	_SPI_DeInit
1967                     	xref	_GPIO_ReadInputPin
1968                     	xref	_GPIO_WriteLow
1969                     	xref	_GPIO_WriteHigh
1970                     	xref	_GPIO_Init
1971                     	xref	_CLK_HSIPrescalerConfig
1972                     	xref	_CLK_PeripheralClockConfig
1973                     	xref.b	c_x
1992                     	xref	c_xymov
1993                     	end
