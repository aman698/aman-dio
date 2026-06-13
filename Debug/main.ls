   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  14                     	bsct
  15  0000               L3_axle_counter:
  16  0000 00            	dc.b	0
  17  0001 00            	dc.b	0
  18  0002 00            	dc.b	0
  19  0003 00            	dc.b	0
  20  0004 00000000      	dc.l	0
  21  0008               L5_task_timer:
  22  0008 00000000      	dc.l	0
  23  000c 00000000      	dc.l	0
  24  0010 00000000      	dc.l	0
  25  0014               L7_current_state:
  26  0014 00            	dc.b	0
  27  0015 00            	dc.b	0
  28  0016 00            	dc.b	0
  29  0017 00            	dc.b	0
  30  0018               L11_server_state:
  31  0018 00            	dc.b	0
  32  0019               L31_uart_state:
  33  0019 00            	dc.b	0
  34  001a               L51_server_socket:
  35  001a 00            	dc.b	0
  36  001b               L12_uart_rx_count:
  37  001b 0000          	dc.w	0
  38  001d               L32_uart_rx_head:
  39  001d 0000          	dc.w	0
  40  001f               L52_uart_rx_tail:
  41  001f 0000          	dc.w	0
  42  0021               L13_systick_ms:
  43  0021 00000000      	dc.l	0
  73                     ; 74 unsigned long hal_get_millis(void)
  73                     ; 75 {
  75                     	switch	.text
  76  0000               _hal_get_millis:
  80                     ; 76     return systick_ms;
  82  0000 ae0021        	ldw	x,#L13_systick_ms
  83  0003 cd0000        	call	c_ltor
  87  0006 81            	ret
 131                     ; 79 void hal_delay_ms(unsigned int ms)
 131                     ; 80 {
 132                     	switch	.text
 133  0007               _hal_delay_ms:
 135  0007 89            	pushw	x
 136  0008 5208          	subw	sp,#8
 137       00000008      OFST:	set	8
 140                     ; 81     unsigned long start = hal_get_millis();
 142  000a adf4          	call	_hal_get_millis
 144  000c 96            	ldw	x,sp
 145  000d 1c0005        	addw	x,#OFST-3
 146  0010 cd0000        	call	c_rtol
 150  0013               L77:
 151                     ; 82     while ((hal_get_millis() - start) < ms);
 153  0013 adeb          	call	_hal_get_millis
 155  0015 96            	ldw	x,sp
 156  0016 1c0005        	addw	x,#OFST-3
 157  0019 cd0000        	call	c_lsub
 159  001c 96            	ldw	x,sp
 160  001d 1c0001        	addw	x,#OFST-7
 161  0020 cd0000        	call	c_rtol
 164  0023 1e09          	ldw	x,(OFST+1,sp)
 165  0025 cd0000        	call	c_uitolx
 167  0028 96            	ldw	x,sp
 168  0029 1c0001        	addw	x,#OFST-7
 169  002c cd0000        	call	c_lcmp
 171  002f 22e2          	jrugt	L77
 172                     ; 83 }
 175  0031 5b0a          	addw	sp,#10
 176  0033 81            	ret
 201                     ; 85 int uart_server_is_ready(void){
 202                     	switch	.text
 203  0034               _uart_server_is_ready:
 207                     ; 86     return (uart_state != UART_STATE_IDLE) ? 1 : 0;
 209  0034 3d19          	tnz	L31_uart_state
 210  0036 2705          	jreq	L21
 211  0038 ae0001        	ldw	x,#1
 212  003b 2001          	jra	L41
 213  003d               L21:
 214  003d 5f            	clrw	x
 215  003e               L41:
 218  003e 81            	ret
 254                     ; 89 void hal_uart_send_byte(uint8_t byte){
 255                     	switch	.text
 256  003f               _hal_uart_send_byte:
 258  003f 88            	push	a
 259       00000000      OFST:	set	0
 262  0040               L331:
 263                     ; 90     while (UART1_GetFlagStatus(UART1_FLAG_TXE) == RESET);
 265  0040 ae0080        	ldw	x,#128
 266  0043 cd0000        	call	_UART1_GetFlagStatus
 268  0046 4d            	tnz	a
 269  0047 27f7          	jreq	L331
 270                     ; 93     UART1_SendData8(byte);
 272  0049 7b01          	ld	a,(OFST+1,sp)
 273  004b cd0000        	call	_UART1_SendData8
 276  004e               L141:
 277                     ; 96     while (UART1_GetFlagStatus(UART1_FLAG_TC) == RESET);
 279  004e ae0040        	ldw	x,#64
 280  0051 cd0000        	call	_UART1_GetFlagStatus
 282  0054 4d            	tnz	a
 283  0055 27f7          	jreq	L141
 284                     ; 97 }
 287  0057 84            	pop	a
 288  0058 81            	ret
 342                     ; 99 void hal_uart_send(const uint8_t *data, uint16_t len){
 343                     	switch	.text
 344  0059               _hal_uart_send:
 346  0059 89            	pushw	x
 347  005a 89            	pushw	x
 348       00000002      OFST:	set	2
 351                     ; 101     for(i = 0; i < len; i++){
 353  005b 5f            	clrw	x
 354  005c 1f01          	ldw	(OFST-1,sp),x
 357  005e 200f          	jra	L771
 358  0060               L371:
 359                     ; 102         hal_uart_send_byte(data[i]);
 361  0060 1e03          	ldw	x,(OFST+1,sp)
 362  0062 72fb01        	addw	x,(OFST-1,sp)
 363  0065 f6            	ld	a,(x)
 364  0066 add7          	call	_hal_uart_send_byte
 366                     ; 101     for(i = 0; i < len; i++){
 368  0068 1e01          	ldw	x,(OFST-1,sp)
 369  006a 1c0001        	addw	x,#1
 370  006d 1f01          	ldw	(OFST-1,sp),x
 372  006f               L771:
 375  006f 1e01          	ldw	x,(OFST-1,sp)
 376  0071 1307          	cpw	x,(OFST+5,sp)
 377  0073 25eb          	jrult	L371
 378                     ; 104 }
 381  0075 5b04          	addw	sp,#4
 382  0077 81            	ret
 430                     ; 106 int uart_server_send(uint8_t *data, uint16_t len)
 430                     ; 107 {
 431                     	switch	.text
 432  0078               _uart_server_send:
 434  0078 89            	pushw	x
 435       00000000      OFST:	set	0
 438                     ; 108     if(uart_state == UART_STATE_IDLE) return -1;
 440  0079 3d19          	tnz	L31_uart_state
 441  007b 2605          	jrne	L522
 444  007d aeffff        	ldw	x,#65535
 446  0080 2028          	jra	L03
 447  0082               L522:
 448                     ; 109     if(len > sizeof(uart_tx_buffer)) len = sizeof(uart_tx_buffer);
 450  0082 1e05          	ldw	x,(OFST+5,sp)
 451  0084 a30015        	cpw	x,#21
 452  0087 2505          	jrult	L722
 455  0089 ae0014        	ldw	x,#20
 456  008c 1f05          	ldw	(OFST+5,sp),x
 457  008e               L722:
 458                     ; 110     memcpy(uart_tx_buffer, data, len);
 460  008e 1e01          	ldw	x,(OFST+1,sp)
 461  0090 bf00          	ldw	c_x,x
 462  0092 1e05          	ldw	x,(OFST+5,sp)
 463  0094 5d            	tnzw	x
 464  0095 2709          	jreq	L42
 465  0097               L62:
 466  0097 5a            	decw	x
 467  0098 92d600        	ld	a,([c_x.w],x)
 468  009b e700          	ld	(L72_uart_tx_buffer,x),a
 469  009d 5d            	tnzw	x
 470  009e 26f7          	jrne	L62
 471  00a0               L42:
 472                     ; 111     hal_uart_send(uart_tx_buffer, len);
 474  00a0 1e05          	ldw	x,(OFST+5,sp)
 475  00a2 89            	pushw	x
 476  00a3 ae0000        	ldw	x,#L72_uart_tx_buffer
 477  00a6 adb1          	call	_hal_uart_send
 479  00a8 85            	popw	x
 480                     ; 112     return 0;
 482  00a9 5f            	clrw	x
 484  00aa               L03:
 486  00aa 5b02          	addw	sp,#2
 487  00ac 81            	ret
 548                     ; 114 sensor_state_t sensor_reader_get_state(void)
 548                     ; 115 {
 549                     	switch	.text
 550  00ad               _sensor_reader_get_state:
 552       00000000      OFST:	set	0
 555                     ; 116     return current_state;
 557  00ad 1e03          	ldw	x,(OFST+3,sp)
 558  00af 90ae0014      	ldw	y,#L7_current_state
 559  00b3 a604          	ld	a,#4
 560  00b5 cd0000        	call	c_xymov
 564  00b8 81            	ret
 646                     ; 119 void message_formatter_alive(char *buf,
 646                     ; 120                              int buf_size,
 646                     ; 121                              uint8_t di1,
 646                     ; 122                              uint8_t di2,
 646                     ; 123                              uint8_t di3,
 646                     ; 124                              uint8_t di4)
 646                     ; 125 {
 647                     	switch	.text
 648  00b9               _message_formatter_alive:
 650  00b9 89            	pushw	x
 651       00000000      OFST:	set	0
 654                     ; 126     if (buf == 0)
 656  00ba a30000        	cpw	x,#0
 657  00bd 2708          	jreq	L63
 658                     ; 127         return;
 660                     ; 129     if (buf_size < 32)
 662  00bf 9c            	rvf
 663  00c0 1e05          	ldw	x,(OFST+5,sp)
 664  00c2 a30020        	cpw	x,#32
 665  00c5 2e02          	jrsge	L123
 666                     ; 130         return;
 667  00c7               L63:
 670  00c7 85            	popw	x
 671  00c8 81            	ret
 672  00c9               L123:
 673                     ; 132     sprintf(buf,
 673                     ; 133             "START,ALIVE,%d%d%d%d,END",
 673                     ; 134             di1,
 673                     ; 135             di2,
 673                     ; 136             di3,
 673                     ; 137             di4);
 675  00c9 7b0a          	ld	a,(OFST+10,sp)
 676  00cb 88            	push	a
 677  00cc 7b0a          	ld	a,(OFST+10,sp)
 678  00ce 88            	push	a
 679  00cf 7b0a          	ld	a,(OFST+10,sp)
 680  00d1 88            	push	a
 681  00d2 7b0a          	ld	a,(OFST+10,sp)
 682  00d4 88            	push	a
 683  00d5 ae0026        	ldw	x,#L323
 684  00d8 89            	pushw	x
 685  00d9 1e07          	ldw	x,(OFST+7,sp)
 686  00db cd0000        	call	_sprintf
 688  00de 5b06          	addw	sp,#6
 689                     ; 138 }
 691  00e0 20e5          	jra	L63
 883                     ; 140 uint8_t hal_di_read(uint8_t di_num)
 883                     ; 141 {
 884                     	switch	.text
 885  00e2               _hal_di_read:
 887  00e2 5203          	subw	sp,#3
 888       00000003      OFST:	set	3
 891                     ; 145     switch (di_num) {
 894                     ; 150         default: return 0;
 895  00e4 4a            	dec	a
 896  00e5 270c          	jreq	L523
 897  00e7 4a            	dec	a
 898  00e8 2714          	jreq	L723
 899  00ea 4a            	dec	a
 900  00eb 271c          	jreq	L133
 901  00ed 4a            	dec	a
 902  00ee 2724          	jreq	L333
 903  00f0               L533:
 906  00f0 4f            	clr	a
 908  00f1 203d          	jra	L64
 909  00f3               L523:
 910                     ; 146         case 1: port = DI1_PORT; pin = DI1_PIN; break;
 912  00f3 ae500f        	ldw	x,#20495
 913  00f6 1f01          	ldw	(OFST-2,sp),x
 917  00f8 a604          	ld	a,#4
 918  00fa 6b03          	ld	(OFST+0,sp),a
 922  00fc 201f          	jra	L354
 923  00fe               L723:
 924                     ; 147         case 2: port = DI2_PORT; pin = DI2_PIN; break;
 926  00fe ae500f        	ldw	x,#20495
 927  0101 1f01          	ldw	(OFST-2,sp),x
 931  0103 a608          	ld	a,#8
 932  0105 6b03          	ld	(OFST+0,sp),a
 936  0107 2014          	jra	L354
 937  0109               L133:
 938                     ; 148         case 3: port = DI3_PORT; pin = DI3_PIN; break;
 940  0109 ae500f        	ldw	x,#20495
 941  010c 1f01          	ldw	(OFST-2,sp),x
 945  010e a610          	ld	a,#16
 946  0110 6b03          	ld	(OFST+0,sp),a
 950  0112 2009          	jra	L354
 951  0114               L333:
 952                     ; 149         case 4: port = DI4_PORT; pin = DI4_PIN; break;
 954  0114 ae500f        	ldw	x,#20495
 955  0117 1f01          	ldw	(OFST-2,sp),x
 959  0119 a680          	ld	a,#128
 960  011b 6b03          	ld	(OFST+0,sp),a
 964  011d               L354:
 965                     ; 152     return (GPIO_ReadInputPin(port, pin) == SET) ? 1 : 0;
 967  011d 7b03          	ld	a,(OFST+0,sp)
 968  011f 88            	push	a
 969  0120 1e02          	ldw	x,(OFST-1,sp)
 970  0122 cd0000        	call	_GPIO_ReadInputPin
 972  0125 5b01          	addw	sp,#1
 973  0127 a101          	cp	a,#1
 974  0129 2604          	jrne	L24
 975  012b a601          	ld	a,#1
 976  012d 2001          	jra	L44
 977  012f               L24:
 978  012f 4f            	clr	a
 979  0130               L44:
 981  0130               L64:
 983  0130 5b03          	addw	sp,#3
 984  0132 81            	ret
1081                     ; 157 void hal_relay_set(uint8_t relay_num, uint8_t state){
1082                     	switch	.text
1083  0133               _hal_relay_set:
1085  0133 89            	pushw	x
1086  0134 5204          	subw	sp,#4
1087       00000004      OFST:	set	4
1090                     ; 160 	BitStatus bit_state = (state == 0) ? SET : RESET;
1092  0136 9f            	ld	a,xl
1093  0137 4d            	tnz	a
1094  0138 2605          	jrne	L25
1095  013a ae0001        	ldw	x,#1
1096  013d 2001          	jra	L45
1097  013f               L25:
1098  013f 5f            	clrw	x
1099  0140               L45:
1100  0140 01            	rrwa	x,a
1101  0141 6b01          	ld	(OFST-3,sp),a
1102  0143 02            	rlwa	x,a
1104                     ; 162 	switch (relay_num) {
1106  0144 7b05          	ld	a,(OFST+1,sp)
1108                     ; 169         default: return;
1109  0146 4a            	dec	a
1110  0147 2711          	jreq	L554
1111  0149 4a            	dec	a
1112  014a 2719          	jreq	L754
1113  014c 4a            	dec	a
1114  014d 2721          	jreq	L164
1115  014f 4a            	dec	a
1116  0150 2729          	jreq	L364
1117  0152 4a            	dec	a
1118  0153 2731          	jreq	L564
1119  0155 4a            	dec	a
1120  0156 2739          	jreq	L764
1121  0158               L174:
1124  0158 205a          	jra	L65
1125  015a               L554:
1126                     ; 163         case 1: port = RELAY1_PORT; pin = RELAY1_PIN; break;
1128  015a ae5005        	ldw	x,#20485
1129  015d 1f02          	ldw	(OFST-2,sp),x
1133  015f a608          	ld	a,#8
1134  0161 6b04          	ld	(OFST+0,sp),a
1138  0163 2035          	jra	L545
1139  0165               L754:
1140                     ; 164         case 2: port = RELAY2_PORT; pin = RELAY2_PIN; break;
1142  0165 ae5005        	ldw	x,#20485
1143  0168 1f02          	ldw	(OFST-2,sp),x
1147  016a a604          	ld	a,#4
1148  016c 6b04          	ld	(OFST+0,sp),a
1152  016e 202a          	jra	L545
1153  0170               L164:
1154                     ; 165         case 3: port = RELAY3_PORT; pin = RELAY3_PIN; break;
1156  0170 ae5005        	ldw	x,#20485
1157  0173 1f02          	ldw	(OFST-2,sp),x
1161  0175 a602          	ld	a,#2
1162  0177 6b04          	ld	(OFST+0,sp),a
1166  0179 201f          	jra	L545
1167  017b               L364:
1168                     ; 166         case 4: port = RELAY4_PORT; pin = RELAY4_PIN; break;
1170  017b ae5005        	ldw	x,#20485
1171  017e 1f02          	ldw	(OFST-2,sp),x
1175  0180 a601          	ld	a,#1
1176  0182 6b04          	ld	(OFST+0,sp),a
1180  0184 2014          	jra	L545
1181  0186               L564:
1182                     ; 167         case 5: port = RELAY5_PORT; pin = RELAY5_PIN; break;
1184  0186 ae500a        	ldw	x,#20490
1185  0189 1f02          	ldw	(OFST-2,sp),x
1189  018b a608          	ld	a,#8
1190  018d 6b04          	ld	(OFST+0,sp),a
1194  018f 2009          	jra	L545
1195  0191               L764:
1196                     ; 168         case 6: port = RELAY6_PORT; pin = RELAY6_PIN; break;
1198  0191 ae500a        	ldw	x,#20490
1199  0194 1f02          	ldw	(OFST-2,sp),x
1203  0196 a610          	ld	a,#16
1204  0198 6b04          	ld	(OFST+0,sp),a
1208  019a               L545:
1209                     ; 172 	if (bit_state == SET) {
1211  019a 7b01          	ld	a,(OFST-3,sp)
1212  019c a101          	cp	a,#1
1213  019e 260b          	jrne	L745
1214                     ; 173         GPIO_WriteHigh(port, pin);  /* Set HIGH = relay off */
1216  01a0 7b04          	ld	a,(OFST+0,sp)
1217  01a2 88            	push	a
1218  01a3 1e03          	ldw	x,(OFST-1,sp)
1219  01a5 cd0000        	call	_GPIO_WriteHigh
1221  01a8 84            	pop	a
1223  01a9 2009          	jra	L155
1224  01ab               L745:
1225                     ; 175         GPIO_WriteLow(port, pin); /* Set LOW = relay on */
1227  01ab 7b04          	ld	a,(OFST+0,sp)
1228  01ad 88            	push	a
1229  01ae 1e03          	ldw	x,(OFST-1,sp)
1230  01b0 cd0000        	call	_GPIO_WriteLow
1232  01b3 84            	pop	a
1233  01b4               L155:
1234                     ; 177 }
1235  01b4               L65:
1238  01b4 5b06          	addw	sp,#6
1239  01b6 81            	ret
1283                     ; 179 void relay_control_set(uint8_t relay_num, uint8_t state)
1283                     ; 180 {
1284                     	switch	.text
1285  01b7               _relay_control_set:
1287  01b7 89            	pushw	x
1288       00000000      OFST:	set	0
1291                     ; 181     if (relay_num >= 1 && relay_num <= 6) {
1293  01b8 9e            	ld	a,xh
1294  01b9 4d            	tnz	a
1295  01ba 270d          	jreq	L575
1297  01bc 9e            	ld	a,xh
1298  01bd a107          	cp	a,#7
1299  01bf 2408          	jruge	L575
1300                     ; 182         hal_relay_set(relay_num, state);
1302  01c1 9f            	ld	a,xl
1303  01c2 97            	ld	xl,a
1304  01c3 7b01          	ld	a,(OFST+1,sp)
1305  01c5 95            	ld	xh,a
1306  01c6 cd0133        	call	_hal_relay_set
1308  01c9               L575:
1309                     ; 184 }
1312  01c9 85            	popw	x
1313  01ca 81            	ret
1349                     ; 186 void relay_control_set_all(uint8_t state)
1349                     ; 187 {
1350                     	switch	.text
1351  01cb               _relay_control_set_all:
1353  01cb 88            	push	a
1354       00000000      OFST:	set	0
1357                     ; 188     relay_control_set(1, state);
1359  01cc ae0100        	ldw	x,#256
1360  01cf 97            	ld	xl,a
1361  01d0 ade5          	call	_relay_control_set
1363                     ; 189     relay_control_set(2, state);
1365  01d2 7b01          	ld	a,(OFST+1,sp)
1366  01d4 ae0200        	ldw	x,#512
1367  01d7 97            	ld	xl,a
1368  01d8 addd          	call	_relay_control_set
1370                     ; 190     relay_control_set(3, state);
1372  01da 7b01          	ld	a,(OFST+1,sp)
1373  01dc ae0300        	ldw	x,#768
1374  01df 97            	ld	xl,a
1375  01e0 add5          	call	_relay_control_set
1377                     ; 191     relay_control_set(4, state);
1379  01e2 7b01          	ld	a,(OFST+1,sp)
1380  01e4 ae0400        	ldw	x,#1024
1381  01e7 97            	ld	xl,a
1382  01e8 adcd          	call	_relay_control_set
1384                     ; 192     relay_control_set(5, state);
1386  01ea 7b01          	ld	a,(OFST+1,sp)
1387  01ec ae0500        	ldw	x,#1280
1388  01ef 97            	ld	xl,a
1389  01f0 adc5          	call	_relay_control_set
1391                     ; 193     relay_control_set(6, state);
1393  01f2 7b01          	ld	a,(OFST+1,sp)
1394  01f4 ae0600        	ldw	x,#1536
1395  01f7 97            	ld	xl,a
1396  01f8 adbd          	call	_relay_control_set
1398                     ; 194 }
1401  01fa 84            	pop	a
1402  01fb 81            	ret
1428                     ; 196 void sensor_reader_update(void){
1429                     	switch	.text
1430  01fc               _sensor_reader_update:
1434                     ; 197     current_state.di1 = hal_di_read(1);
1436  01fc a601          	ld	a,#1
1437  01fe cd00e2        	call	_hal_di_read
1439  0201 b714          	ld	L7_current_state,a
1440                     ; 198     current_state.di2 = hal_di_read(2);
1442  0203 a602          	ld	a,#2
1443  0205 cd00e2        	call	_hal_di_read
1445  0208 b715          	ld	L7_current_state+1,a
1446                     ; 199     current_state.di3 = hal_di_read(3);
1448  020a a603          	ld	a,#3
1449  020c cd00e2        	call	_hal_di_read
1451  020f b716          	ld	L7_current_state+2,a
1452                     ; 200     current_state.di4 = hal_di_read(4);
1454  0211 a604          	ld	a,#4
1455  0213 cd00e2        	call	_hal_di_read
1457  0216 b717          	ld	L7_current_state+3,a
1458                     ; 201 }
1461  0218 81            	ret
1499                     ; 206 void process_axle_counting(void){
1500                     	switch	.text
1501  0219               _process_axle_counting:
1503  0219 5208          	subw	sp,#8
1504       00000008      OFST:	set	8
1507                     ; 207     sensor_state_t sensor = sensor_reader_get_state();
1509  021b 96            	ldw	x,sp
1510  021c 1c0005        	addw	x,#OFST-3
1511  021f 89            	pushw	x
1512  0220 cd00ad        	call	_sensor_reader_get_state
1514  0223 85            	popw	x
1515                     ; 210     if(sensor.di1 == 1 && axle_counter.prev_di1_state == 0){
1517  0224 7b05          	ld	a,(OFST-3,sp)
1518  0226 a101          	cp	a,#1
1519  0228 260a          	jrne	L346
1521  022a 3d03          	tnz	L3_axle_counter+3
1522  022c 2606          	jrne	L346
1523                     ; 211         axle_counter.loop_active = 1;
1525  022e 35010000      	mov	L3_axle_counter,#1
1526                     ; 212         axle_counter.axle_count = 0;
1528  0232 3f02          	clr	L3_axle_counter+2
1529  0234               L346:
1530                     ; 215     if(axle_counter.loop_active){
1532  0234 3d00          	tnz	L3_axle_counter
1533  0236 2710          	jreq	L546
1534                     ; 216         if(sensor.di2 == 1 && axle_counter.prev_di2_state == 0){
1536  0238 7b06          	ld	a,(OFST-2,sp)
1537  023a a101          	cp	a,#1
1538  023c 2606          	jrne	L746
1540  023e 3d01          	tnz	L3_axle_counter+1
1541  0240 2602          	jrne	L746
1542                     ; 217             axle_counter.axle_count++;
1544  0242 3c02          	inc	L3_axle_counter+2
1545  0244               L746:
1546                     ; 219         axle_counter.prev_di2_state = sensor.di2;
1548  0244 7b06          	ld	a,(OFST-2,sp)
1549  0246 b701          	ld	L3_axle_counter+1,a
1550  0248               L546:
1551                     ; 222 }
1554  0248 5b08          	addw	sp,#8
1555  024a 81            	ret
1579                     ; 223 void sensor_reader_init(void)
1579                     ; 224 {
1580                     	switch	.text
1581  024b               _sensor_reader_init:
1585                     ; 226     sensor_reader_update();
1587  024b adaf          	call	_sensor_reader_update
1589                     ; 227 }
1592  024d 81            	ret
1619                     .const:	section	.text
1620  0000               L47:
1621  0000 00000032      	dc.l	50
1622                     ; 228 void timer_callback(void){
1623                     	switch	.text
1624  024e               _timer_callback:
1628                     ; 229     task_timer.current_time = hal_get_millis();
1630  024e cd0000        	call	_hal_get_millis
1632  0251 ae0010        	ldw	x,#L5_task_timer+8
1633  0254 cd0000        	call	c_rtol
1635                     ; 231     if ((task_timer.current_time - task_timer.last_sensor_time) >= SENSOR_READ_INTERVAL){
1637  0257 ae0010        	ldw	x,#L5_task_timer+8
1638  025a cd0000        	call	c_ltor
1640  025d ae000c        	ldw	x,#L5_task_timer+4
1641  0260 cd0000        	call	c_lsub
1643  0263 ae0000        	ldw	x,#L47
1644  0266 cd0000        	call	c_lcmp
1646  0269 2504          	jrult	L176
1647                     ; 232         sensor_reader_update();
1649  026b ad8f          	call	_sensor_reader_update
1651                     ; 233         process_axle_counting();
1653  026d adaa          	call	_process_axle_counting
1655  026f               L176:
1656                     ; 235 }
1659  026f 81            	ret
1766                     ; 237 int command_parser_execute(const char *cmd_str, int len)
1766                     ; 238 {
1767                     	switch	.text
1768  0270               _command_parser_execute:
1770  0270 89            	pushw	x
1771  0271 5246          	subw	sp,#70
1772       00000046      OFST:	set	70
1775                     ; 240     char *cmd = NULL;
1777                     ; 241     char *value_str = NULL;
1779                     ; 243     int relay_num = 0;
1781                     ; 244     int relay_state = 0;
1783                     ; 246     if (len == 0 || len >= 64) return -1;
1785  0273 1e4b          	ldw	x,(OFST+5,sp)
1786  0275 2708          	jreq	L747
1788  0277 9c            	rvf
1789  0278 1e4b          	ldw	x,(OFST+5,sp)
1790  027a a30040        	cpw	x,#64
1791  027d 2f05          	jrslt	L547
1792  027f               L747:
1795  027f aeffff        	ldw	x,#65535
1797  0282 202e          	jra	L001
1798  0284               L547:
1799                     ; 249     strncpy(cmd_copy, cmd_str, len);
1801  0284 1e4b          	ldw	x,(OFST+5,sp)
1802  0286 89            	pushw	x
1803  0287 1e49          	ldw	x,(OFST+3,sp)
1804  0289 89            	pushw	x
1805  028a 96            	ldw	x,sp
1806  028b 1c0007        	addw	x,#OFST-63
1807  028e cd0000        	call	_strncpy
1809  0291 5b04          	addw	sp,#4
1810                     ; 250     cmd_copy[len] = '\0';
1812  0293 96            	ldw	x,sp
1813  0294 1c0003        	addw	x,#OFST-67
1814  0297 1f01          	ldw	(OFST-69,sp),x
1816  0299 1e4b          	ldw	x,(OFST+5,sp)
1817  029b 72fb01        	addw	x,(OFST-69,sp)
1818  029e 7f            	clr	(x)
1819                     ; 253     comma_pos = strchr(cmd_copy, ',');
1821  029f 4b2c          	push	#44
1822  02a1 96            	ldw	x,sp
1823  02a2 1c0004        	addw	x,#OFST-66
1824  02a5 cd0000        	call	_strchr
1826  02a8 84            	pop	a
1827  02a9 1f45          	ldw	(OFST-1,sp),x
1829                     ; 254     if (!comma_pos) return -1;
1831  02ab 1e45          	ldw	x,(OFST-1,sp)
1832  02ad 2606          	jrne	L157
1835  02af aeffff        	ldw	x,#65535
1837  02b2               L001:
1839  02b2 5b48          	addw	sp,#72
1840  02b4 81            	ret
1841  02b5               L157:
1842                     ; 257     *comma_pos = '\0';
1844  02b5 1e45          	ldw	x,(OFST-1,sp)
1845  02b7 7f            	clr	(x)
1846                     ; 258     cmd = cmd_copy;
1848  02b8 96            	ldw	x,sp
1849  02b9 1c0003        	addw	x,#OFST-67
1850  02bc 1f43          	ldw	(OFST-3,sp),x
1852                     ; 259     value_str = comma_pos + 1;
1854  02be 1e45          	ldw	x,(OFST-1,sp)
1855  02c0 5c            	incw	x
1856  02c1 1f45          	ldw	(OFST-1,sp),x
1858                     ; 262     if (cmd[0] == 'R' && cmd[1] >= '1' && cmd[1] <= '6' && cmd[2] == '\0') {
1860  02c3 1e43          	ldw	x,(OFST-3,sp)
1861  02c5 f6            	ld	a,(x)
1862  02c6 a152          	cp	a,#82
1863  02c8 2634          	jrne	L357
1865  02ca 1e43          	ldw	x,(OFST-3,sp)
1866  02cc e601          	ld	a,(1,x)
1867  02ce a131          	cp	a,#49
1868  02d0 252c          	jrult	L357
1870  02d2 1e43          	ldw	x,(OFST-3,sp)
1871  02d4 e601          	ld	a,(1,x)
1872  02d6 a137          	cp	a,#55
1873  02d8 2424          	jruge	L357
1875  02da 1e43          	ldw	x,(OFST-3,sp)
1876  02dc 6d02          	tnz	(2,x)
1877  02de 261e          	jrne	L357
1878                     ; 263         relay_num = cmd[1] - '0';
1880  02e0 1e43          	ldw	x,(OFST-3,sp)
1881  02e2 e601          	ld	a,(1,x)
1882  02e4 5f            	clrw	x
1883  02e5 97            	ld	xl,a
1884  02e6 1d0030        	subw	x,#48
1885  02e9 1f43          	ldw	(OFST-3,sp),x
1887                     ; 264         relay_state = atoi(value_str);
1889  02eb 1e45          	ldw	x,(OFST-1,sp)
1890  02ed cd0000        	call	_atoi
1892  02f0 1f45          	ldw	(OFST-1,sp),x
1894                     ; 267         relay_control_set(relay_num, relay_state);
1896  02f2 7b46          	ld	a,(OFST+0,sp)
1897  02f4 97            	ld	xl,a
1898  02f5 7b44          	ld	a,(OFST-2,sp)
1899  02f7 95            	ld	xh,a
1900  02f8 cd01b7        	call	_relay_control_set
1902                     ; 268         return 0;
1904  02fb 5f            	clrw	x
1906  02fc 20b4          	jra	L001
1907  02fe               L357:
1908                     ; 271     return -1;
1910  02fe aeffff        	ldw	x,#65535
1912  0301 20af          	jra	L001
1936                     ; 274 void relay_control_init(void)
1936                     ; 275 {
1937                     	switch	.text
1938  0303               _relay_control_init:
1942                     ; 276     relay_control_set_all(1);  /* 1 = on for active-low relays */
1944  0303 a601          	ld	a,#1
1945  0305 cd01cb        	call	_relay_control_set_all
1947                     ; 277 }
1950  0308 81            	ret
1975                     ; 279 void hal_w5500_reset_high(void)
1975                     ; 280 {
1976                     	switch	.text
1977  0309               _hal_w5500_reset_high:
1981                     ; 281     GPIO_WriteHigh(W5500_RST_PORT, W5500_RST_PIN);
1983  0309 4b20          	push	#32
1984  030b ae5014        	ldw	x,#20500
1985  030e cd0000        	call	_GPIO_WriteHigh
1987  0311 84            	pop	a
1988                     ; 282 }
1991  0312 81            	ret
2017                     ; 284 void hal_gpio_init(void){
2018                     	switch	.text
2019  0313               _hal_gpio_init:
2023                     ; 286     GPIO_Init(DI1_PORT, DI1_PIN, GPIO_MODE_IN_PU_NO_IT);
2025  0313 4b40          	push	#64
2026  0315 4b04          	push	#4
2027  0317 ae500f        	ldw	x,#20495
2028  031a cd0000        	call	_GPIO_Init
2030  031d 85            	popw	x
2031                     ; 287     GPIO_Init(DI2_PORT, DI2_PIN, GPIO_MODE_IN_PU_NO_IT);
2033  031e 4b40          	push	#64
2034  0320 4b08          	push	#8
2035  0322 ae500f        	ldw	x,#20495
2036  0325 cd0000        	call	_GPIO_Init
2038  0328 85            	popw	x
2039                     ; 288     GPIO_Init(DI3_PORT, DI3_PIN, GPIO_MODE_IN_PU_NO_IT);
2041  0329 4b40          	push	#64
2042  032b 4b10          	push	#16
2043  032d ae500f        	ldw	x,#20495
2044  0330 cd0000        	call	_GPIO_Init
2046  0333 85            	popw	x
2047                     ; 289     GPIO_Init(DI4_PORT, DI4_PIN, GPIO_MODE_IN_PU_NO_IT);
2049  0334 4b40          	push	#64
2050  0336 4b80          	push	#128
2051  0338 ae500f        	ldw	x,#20495
2052  033b cd0000        	call	_GPIO_Init
2054  033e 85            	popw	x
2055                     ; 292     GPIO_Init(RELAY1_PORT, RELAY1_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
2057  033f 4bf0          	push	#240
2058  0341 4b08          	push	#8
2059  0343 ae5005        	ldw	x,#20485
2060  0346 cd0000        	call	_GPIO_Init
2062  0349 85            	popw	x
2063                     ; 293     GPIO_Init(RELAY2_PORT, RELAY2_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
2065  034a 4bf0          	push	#240
2066  034c 4b04          	push	#4
2067  034e ae5005        	ldw	x,#20485
2068  0351 cd0000        	call	_GPIO_Init
2070  0354 85            	popw	x
2071                     ; 294     GPIO_Init(RELAY3_PORT, RELAY3_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
2073  0355 4bf0          	push	#240
2074  0357 4b02          	push	#2
2075  0359 ae5005        	ldw	x,#20485
2076  035c cd0000        	call	_GPIO_Init
2078  035f 85            	popw	x
2079                     ; 295     GPIO_Init(RELAY4_PORT, RELAY4_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
2081  0360 4bf0          	push	#240
2082  0362 4b01          	push	#1
2083  0364 ae5005        	ldw	x,#20485
2084  0367 cd0000        	call	_GPIO_Init
2086  036a 85            	popw	x
2087                     ; 296     GPIO_Init(RELAY5_PORT, RELAY5_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
2089  036b 4bf0          	push	#240
2090  036d 4b08          	push	#8
2091  036f ae500a        	ldw	x,#20490
2092  0372 cd0000        	call	_GPIO_Init
2094  0375 85            	popw	x
2095                     ; 297     GPIO_Init(RELAY6_PORT, RELAY6_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
2097  0376 4bf0          	push	#240
2098  0378 4b10          	push	#16
2099  037a ae500a        	ldw	x,#20490
2100  037d cd0000        	call	_GPIO_Init
2102  0380 85            	popw	x
2103                     ; 300     hal_relay_set(1, 1);
2105  0381 ae0101        	ldw	x,#257
2106  0384 cd0133        	call	_hal_relay_set
2108                     ; 301     hal_relay_set(2, 1);
2110  0387 ae0201        	ldw	x,#513
2111  038a cd0133        	call	_hal_relay_set
2113                     ; 302     hal_relay_set(3, 1);
2115  038d ae0301        	ldw	x,#769
2116  0390 cd0133        	call	_hal_relay_set
2118                     ; 303     hal_relay_set(4, 1);
2120  0393 ae0401        	ldw	x,#1025
2121  0396 cd0133        	call	_hal_relay_set
2123                     ; 304     hal_relay_set(5, 1);
2125  0399 ae0501        	ldw	x,#1281
2126  039c cd0133        	call	_hal_relay_set
2128                     ; 305     hal_relay_set(6, 1);
2130  039f ae0601        	ldw	x,#1537
2131  03a2 cd0133        	call	_hal_relay_set
2133                     ; 308     GPIO_Init(HARDRST_PORT, HARDRST_PIN, GPIO_MODE_IN_PU_NO_IT);
2135  03a5 4b40          	push	#64
2136  03a7 4b80          	push	#128
2137  03a9 ae5005        	ldw	x,#20485
2138  03ac cd0000        	call	_GPIO_Init
2140  03af 85            	popw	x
2141                     ; 311     GPIO_Init(W5500_RST_PORT, W5500_RST_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
2143  03b0 4bf0          	push	#240
2144  03b2 4b20          	push	#32
2145  03b4 ae5014        	ldw	x,#20500
2146  03b7 cd0000        	call	_GPIO_Init
2148  03ba 85            	popw	x
2149                     ; 312 	hal_w5500_reset_high();
2151  03bb cd0309        	call	_hal_w5500_reset_high
2153                     ; 313 }
2156  03be 81            	ret
2180                     ; 315 uint16_t hal_uart_available(void){
2181                     	switch	.text
2182  03bf               _hal_uart_available:
2186                     ; 316 	return uart_rx_count;
2188  03bf be1b          	ldw	x,L12_uart_rx_count
2191  03c1 81            	ret
2230                     ; 319 uint8_t hal_uart_read_byte(void){
2231                     	switch	.text
2232  03c2               _hal_uart_read_byte:
2234  03c2 88            	push	a
2235       00000001      OFST:	set	1
2238                     ; 320 	uint8_t byte = 0;
2240  03c3 0f01          	clr	(OFST+0,sp)
2242                     ; 321 	if (uart_rx_count > 0){
2244  03c5 be1b          	ldw	x,L12_uart_rx_count
2245  03c7 2719          	jreq	L3301
2246                     ; 322 		disableInterrupts();
2249  03c9 9b            sim
2251                     ; 324 		byte = uart_rx_buffer[uart_rx_tail];
2254  03ca be1f          	ldw	x,L52_uart_rx_tail
2255  03cc e614          	ld	a,(L71_uart_rx_buffer,x)
2256  03ce 6b01          	ld	(OFST+0,sp),a
2258                     ; 325 		uart_rx_tail = (uart_rx_tail + 1) % UART_RX_BUFFER_SIZE;
2260  03d0 be1f          	ldw	x,L52_uart_rx_tail
2261  03d2 5c            	incw	x
2262  03d3 a614          	ld	a,#20
2263  03d5 62            	div	x,a
2264  03d6 5f            	clrw	x
2265  03d7 97            	ld	xl,a
2266  03d8 bf1f          	ldw	L52_uart_rx_tail,x
2267                     ; 326 		uart_rx_count--;
2269  03da be1b          	ldw	x,L12_uart_rx_count
2270  03dc 1d0001        	subw	x,#1
2271  03df bf1b          	ldw	L12_uart_rx_count,x
2272                     ; 327 		enableInterrupts();
2275  03e1 9a            rim
2278  03e2               L3301:
2279                     ; 329 	return byte;
2281  03e2 7b01          	ld	a,(OFST+0,sp)
2284  03e4 5b01          	addw	sp,#1
2285  03e6 81            	ret
2359                     ; 332 void uart_server_process(void){
2360                     	switch	.text
2361  03e7               _uart_server_process:
2363  03e7 521f          	subw	sp,#31
2364       0000001f      OFST:	set	31
2367                     ; 338 	if (uart_state == UART_STATE_IDLE){
2369  03e9 3d19          	tnz	L31_uart_state
2370  03eb 2603          	jrne	L021
2371  03ed cc04a8        	jp	L611
2372  03f0               L021:
2373                     ; 339 		return;
2375                     ; 341 	available_len = hal_uart_available();
2377  03f0 adcd          	call	_hal_uart_available
2379  03f2 1f05          	ldw	(OFST-26,sp),x
2381                     ; 343 	if(available_len > 0){
2383  03f4 1e05          	ldw	x,(OFST-26,sp)
2384  03f6 2603          	jrne	L221
2385  03f8 cc04a4        	jp	L1701
2386  03fb               L221:
2387                     ; 344 		uart_state = UART_STATE_RX_PENDING;
2389  03fb 35020019      	mov	L31_uart_state,#2
2391  03ff ac900490      	jpf	L7701
2392  0403               L3701:
2393                     ; 347 			read_byte = hal_uart_read_byte();
2395  0403 adbd          	call	_hal_uart_read_byte
2397  0405 6b1f          	ld	(OFST+0,sp),a
2399                     ; 349 			if (read_byte == '\n' || read_byte == '\r'){
2401  0407 7b1f          	ld	a,(OFST+0,sp)
2402  0409 a10a          	cp	a,#10
2403  040b 2706          	jreq	L5011
2405  040d 7b1f          	ld	a,(OFST+0,sp)
2406  040f a10d          	cp	a,#13
2407  0411 265c          	jrne	L3011
2408  0413               L5011:
2409                     ; 350 				if(uart_rx_count > 0){
2411  0413 be1b          	ldw	x,L12_uart_rx_count
2412  0415 2772          	jreq	L7111
2413                     ; 351 					uart_rx_buffer[uart_rx_count] = '\0';
2415  0417 be1b          	ldw	x,L12_uart_rx_count
2416  0419 6f14          	clr	(L71_uart_rx_buffer,x)
2417                     ; 352 					if (command_parser_execute((const char *)uart_rx_buffer,uart_rx_count) == 0){
2419  041b be1b          	ldw	x,L12_uart_rx_count
2420  041d 89            	pushw	x
2421  041e ae0014        	ldw	x,#L71_uart_rx_buffer
2422  0421 cd0270        	call	_command_parser_execute
2424  0424 5b02          	addw	sp,#2
2425  0426 a30000        	cpw	x,#0
2426  0429 2634          	jrne	L1111
2427                     ; 353 						state = sensor_reader_get_state();
2429  042b 96            	ldw	x,sp
2430  042c 1c001b        	addw	x,#OFST-4
2431  042f 89            	pushw	x
2432  0430 cd00ad        	call	_sensor_reader_get_state
2434  0433 85            	popw	x
2435                     ; 354 						message_formatter_alive(resp_buf, sizeof(resp_buf),state.di1,state.di2,state.di3,state.di4);
2437  0434 7b1e          	ld	a,(OFST-1,sp)
2438  0436 88            	push	a
2439  0437 7b1e          	ld	a,(OFST-1,sp)
2440  0439 88            	push	a
2441  043a 7b1e          	ld	a,(OFST-1,sp)
2442  043c 88            	push	a
2443  043d 7b1e          	ld	a,(OFST-1,sp)
2444  043f 88            	push	a
2445  0440 ae0014        	ldw	x,#20
2446  0443 89            	pushw	x
2447  0444 96            	ldw	x,sp
2448  0445 1c000d        	addw	x,#OFST-18
2449  0448 cd00b9        	call	_message_formatter_alive
2451  044b 5b06          	addw	sp,#6
2452                     ; 355 					 	uart_server_send((uint8_t *)resp_buf,strlen(resp_buf));
2454  044d 96            	ldw	x,sp
2455  044e 1c0007        	addw	x,#OFST-24
2456  0451 cd0000        	call	_strlen
2458  0454 89            	pushw	x
2459  0455 96            	ldw	x,sp
2460  0456 1c0009        	addw	x,#OFST-22
2461  0459 cd0078        	call	_uart_server_send
2463  045c 85            	popw	x
2465  045d 200b          	jra	L3111
2466  045f               L1111:
2467                     ; 358                         uart_server_send((uint8_t *)"ERROR,INVALID_COMMAND\n",strlen("ERROR,INVALID_COMMAND\n"));
2469  045f ae0016        	ldw	x,#22
2470  0462 89            	pushw	x
2471  0463 ae000f        	ldw	x,#L5111
2472  0466 cd0078        	call	_uart_server_send
2474  0469 85            	popw	x
2475  046a               L3111:
2476                     ; 360                     uart_rx_count = 0;
2478  046a 5f            	clrw	x
2479  046b bf1b          	ldw	L12_uart_rx_count,x
2480  046d 201a          	jra	L7111
2481  046f               L3011:
2482                     ; 363             else if (read_byte >= 32 && read_byte < 127){
2484  046f 7b1f          	ld	a,(OFST+0,sp)
2485  0471 a120          	cp	a,#32
2486  0473 2514          	jrult	L7111
2488  0475 7b1f          	ld	a,(OFST+0,sp)
2489  0477 a17f          	cp	a,#127
2490  0479 240e          	jruge	L7111
2491                     ; 364                 uart_rx_buffer[uart_rx_count++] = read_byte;
2493  047b 7b1f          	ld	a,(OFST+0,sp)
2494  047d be1b          	ldw	x,L12_uart_rx_count
2495  047f 1c0001        	addw	x,#1
2496  0482 bf1b          	ldw	L12_uart_rx_count,x
2497  0484 1d0001        	subw	x,#1
2498  0487 e714          	ld	(L71_uart_rx_buffer,x),a
2499  0489               L7111:
2500                     ; 366             available_len--;
2502  0489 1e05          	ldw	x,(OFST-26,sp)
2503  048b 1d0001        	subw	x,#1
2504  048e 1f05          	ldw	(OFST-26,sp),x
2506  0490               L7701:
2507                     ; 346 		while (available_len > 0 && uart_rx_count < sizeof(uart_rx_buffer) - 1){
2509  0490 1e05          	ldw	x,(OFST-26,sp)
2510  0492 270a          	jreq	L3211
2512  0494 be1b          	ldw	x,L12_uart_rx_count
2513  0496 a30013        	cpw	x,#19
2514  0499 2403          	jruge	L421
2515  049b cc0403        	jp	L3701
2516  049e               L421:
2517  049e               L3211:
2518                     ; 368         uart_state = UART_STATE_READY;
2520  049e 35010019      	mov	L31_uart_state,#1
2522  04a2 2004          	jra	L5211
2523  04a4               L1701:
2524                     ; 371         uart_state = UART_STATE_READY;
2526  04a4 35010019      	mov	L31_uart_state,#1
2527  04a8               L5211:
2528                     ; 373 }
2529  04a8               L611:
2532  04a8 5b1f          	addw	sp,#31
2533  04aa 81            	ret
2577                     ; 377 void tcp_server_process(void){
2578                     	switch	.text
2579  04ab               _tcp_server_process:
2581  04ab 5203          	subw	sp,#3
2582       00000003      OFST:	set	3
2585                     ; 378 	uint16_t received_len = 0;
2587                     ; 379 	uint8_t sock_status = 0;
2589                     ; 381 	if(server_state ==  TCP_STATE_IDLE)return;
2591  04ad 3d18          	tnz	L11_server_state
2592  04af 2700          	jreq	L031
2595                     ; 383 }
2596  04b1               L031:
2599  04b1 5b03          	addw	sp,#3
2600  04b3 81            	ret
2641                     ; 385 void hal_uart_init(uint32_t baudrate)
2641                     ; 386 {
2642                     	switch	.text
2643  04b4               _hal_uart_init:
2645       00000000      OFST:	set	0
2648                     ; 388     CLK_PeripheralClockConfig(CLK_PERIPHERAL_UART1, ENABLE);
2650  04b4 ae0301        	ldw	x,#769
2651  04b7 cd0000        	call	_CLK_PeripheralClockConfig
2653                     ; 397     UART1_Init(
2653                     ; 398     baudrate,
2653                     ; 399     UART1_WORDLENGTH_8D,
2653                     ; 400     UART1_STOPBITS_1,
2653                     ; 401     UART1_PARITY_NO,
2653                     ; 402     UART1_SYNCMODE_CLOCK_DISABLE,
2653                     ; 403     (UART1_Mode_TypeDef)(UART1_MODE_TX_ENABLE | UART1_MODE_RX_ENABLE)
2653                     ; 404 );
2655  04ba 4b0c          	push	#12
2656  04bc 4b80          	push	#128
2657  04be 4b00          	push	#0
2658  04c0 4b00          	push	#0
2659  04c2 4b00          	push	#0
2660  04c4 1e0a          	ldw	x,(OFST+10,sp)
2661  04c6 89            	pushw	x
2662  04c7 1e0a          	ldw	x,(OFST+10,sp)
2663  04c9 89            	pushw	x
2664  04ca cd0000        	call	_UART1_Init
2666  04cd 5b09          	addw	sp,#9
2667                     ; 406     UART1_ITConfig(UART1_IT_RXNE, ENABLE);
2669  04cf 4b01          	push	#1
2670  04d1 ae0255        	ldw	x,#597
2671  04d4 cd0000        	call	_UART1_ITConfig
2673  04d7 84            	pop	a
2674                     ; 409     UART1_Cmd(ENABLE);
2676  04d8 a601          	ld	a,#1
2677  04da cd0000        	call	_UART1_Cmd
2679                     ; 411     uart_rx_head = 0;
2681  04dd 5f            	clrw	x
2682  04de bf1d          	ldw	L32_uart_rx_head,x
2683                     ; 412     uart_rx_tail = 0;
2685  04e0 5f            	clrw	x
2686  04e1 bf1f          	ldw	L52_uart_rx_tail,x
2687                     ; 413     uart_rx_count = 0;   
2689  04e3 5f            	clrw	x
2690  04e4 bf1b          	ldw	L12_uart_rx_count,x
2691                     ; 414 }
2694  04e6 81            	ret
2731                     ; 416 void uart_server_init(uint32_t baudrate){
2732                     	switch	.text
2733  04e7               _uart_server_init:
2735       00000000      OFST:	set	0
2738                     ; 417 	uart_state = UART_STATE_IDLE;
2740  04e7 3f19          	clr	L31_uart_state
2741                     ; 418 	uart_rx_count = 0;
2743  04e9 5f            	clrw	x
2744  04ea bf1b          	ldw	L12_uart_rx_count,x
2745                     ; 420 	hal_uart_init(baudrate);
2747  04ec 1e05          	ldw	x,(OFST+5,sp)
2748  04ee 89            	pushw	x
2749  04ef 1e05          	ldw	x,(OFST+5,sp)
2750  04f1 89            	pushw	x
2751  04f2 adc0          	call	_hal_uart_init
2753  04f4 5b04          	addw	sp,#4
2754                     ; 422 	uart_state = UART_STATE_READY;
2756  04f6 35010019      	mov	L31_uart_state,#1
2757                     ; 423 }
2760  04fa 81            	ret
2788                     ; 425 void hal_timer_init(void){
2789                     	switch	.text
2790  04fb               _hal_timer_init:
2794                     ; 426     CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER4, ENABLE);
2796  04fb ae0401        	ldw	x,#1025
2797  04fe cd0000        	call	_CLK_PeripheralClockConfig
2799                     ; 427     TIM4_TimeBaseInit(TIM4_PRESCALER_128, 125);
2801  0501 ae077d        	ldw	x,#1917
2802  0504 cd0000        	call	_TIM4_TimeBaseInit
2804                     ; 428     TIM4_ClearFlag(TIM4_FLAG_UPDATE);
2806  0507 a601          	ld	a,#1
2807  0509 cd0000        	call	_TIM4_ClearFlag
2809                     ; 430     TIM4_ITConfig(TIM4_IT_UPDATE, ENABLE);
2811  050c ae0101        	ldw	x,#257
2812  050f cd0000        	call	_TIM4_ITConfig
2814                     ; 432     enableInterrupts();
2817  0512 9a            rim
2819                     ; 433 }
2823  0513 81            	ret
2826                     	switch	.const
2827  0004               L7121_msg:
2828  0004 52455345542c  	dc.b	"RESET, OK",10,0
2868                     ; 436 void main_loop(void)
2868                     ; 437 {
2869                     	switch	.text
2870  0514               _main_loop:
2872  0514 520b          	subw	sp,#11
2873       0000000b      OFST:	set	11
2876  0516               L7321:
2877                     ; 441 		tcp_server_process();
2879  0516 ad93          	call	_tcp_server_process
2881                     ; 444 		uart_server_process();
2883  0518 cd03e7        	call	_uart_server_process
2885                     ; 446         if(GPIO_ReadInputPin(HARDRST_PORT, HARDRST_PIN) == RESET)
2887  051b 4b80          	push	#128
2888  051d ae5005        	ldw	x,#20485
2889  0520 cd0000        	call	_GPIO_ReadInputPin
2891  0523 5b01          	addw	sp,#1
2892  0525 4d            	tnz	a
2893  0526 26ee          	jrne	L7321
2894                     ; 448             hal_delay_ms(50);
2896  0528 ae0032        	ldw	x,#50
2897  052b cd0007        	call	_hal_delay_ms
2899                     ; 449 			if (GPIO_ReadInputPin(HARDRST_PORT, HARDRST_PIN) == 0){
2901  052e 4b80          	push	#128
2902  0530 ae5005        	ldw	x,#20485
2903  0533 cd0000        	call	_GPIO_ReadInputPin
2905  0536 5b01          	addw	sp,#1
2906  0538 4d            	tnz	a
2907  0539 26db          	jrne	L7321
2908                     ; 451 				char msg[] = "RESET, OK\n";
2910  053b 96            	ldw	x,sp
2911  053c 1c0001        	addw	x,#OFST-10
2912  053f 90ae0004      	ldw	y,#L7121_msg
2913  0543 a60b          	ld	a,#11
2914  0545 cd0000        	call	c_xymov
2916                     ; 452                 if (uart_server_is_ready()){
2918  0548 cd0034        	call	_uart_server_is_ready
2920  054b a30000        	cpw	x,#0
2921  054e 2710          	jreq	L7421
2922                     ; 453                     uart_server_send((uint8_t *)msg, strlen(msg));
2924  0550 96            	ldw	x,sp
2925  0551 1c0001        	addw	x,#OFST-10
2926  0554 cd0000        	call	_strlen
2928  0557 89            	pushw	x
2929  0558 96            	ldw	x,sp
2930  0559 1c0003        	addw	x,#OFST-8
2931  055c cd0078        	call	_uart_server_send
2933  055f 85            	popw	x
2934  0560               L7421:
2935                     ; 455 				hal_delay_ms(100);
2937  0560 ae0064        	ldw	x,#100
2938  0563 cd0007        	call	_hal_delay_ms
2940  0566 20ae          	jra	L7321
2971                     ; 461 void system_init(void){
2972                     	switch	.text
2973  0568               _system_init:
2977                     ; 463     CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);  /* 16MHz clock */
2979  0568 4f            	clr	a
2980  0569 cd0000        	call	_CLK_HSIPrescalerConfig
2982                     ; 466 	hal_gpio_init();
2984  056c cd0313        	call	_hal_gpio_init
2986                     ; 467     hal_timer_init();
2988  056f ad8a          	call	_hal_timer_init
2990                     ; 470 	relay_control_init();
2992  0571 cd0303        	call	_relay_control_init
2994                     ; 471 	sensor_reader_init();
2996  0574 cd024b        	call	_sensor_reader_init
2998                     ; 473     uart_server_init(UART_BAUDRATE);
3000  0577 aec200        	ldw	x,#49664
3001  057a 89            	pushw	x
3002  057b ae0001        	ldw	x,#1
3003  057e 89            	pushw	x
3004  057f cd04e7        	call	_uart_server_init
3006  0582 5b04          	addw	sp,#4
3007                     ; 476     timer_callback();
3009  0584 cd024e        	call	_timer_callback
3011                     ; 477 	hal_delay_ms(500);
3013  0587 ae01f4        	ldw	x,#500
3014  058a cd0007        	call	_hal_delay_ms
3016                     ; 478 }
3019  058d 81            	ret
3044                     ; 481 int main(void)
3044                     ; 482 {
3045                     	switch	.text
3046  058e               _main:
3050                     ; 483 	system_init();
3052  058e add8          	call	_system_init
3054                     ; 484     main_loop();
3056  0590 ad82          	call	_main_loop
3058  0592               L1721:
3059                     ; 486     while(1);
3061  0592 20fe          	jra	L1721
3340                     	xdef	_main
3341                     	xdef	_hal_timer_init
3342                     	xdef	_uart_server_init
3343                     	xdef	_hal_uart_init
3344                     	xdef	_tcp_server_process
3345                     	xdef	_system_init
3346                     	xdef	_main_loop
3347                     	xdef	_uart_server_process
3348                     	xdef	_hal_uart_read_byte
3349                     	xdef	_hal_uart_available
3350                     	xdef	_hal_gpio_init
3351                     	xdef	_hal_w5500_reset_high
3352                     	xdef	_relay_control_init
3353                     	xdef	_command_parser_execute
3354                     	xdef	_timer_callback
3355                     	xdef	_sensor_reader_init
3356                     	xdef	_process_axle_counting
3357                     	xdef	_sensor_reader_update
3358                     	xdef	_relay_control_set_all
3359                     	xdef	_relay_control_set
3360                     	xdef	_hal_relay_set
3361                     	xdef	_hal_di_read
3362                     	xdef	_message_formatter_alive
3363                     	xdef	_sensor_reader_get_state
3364                     	xdef	_uart_server_send
3365                     	xdef	_hal_uart_send
3366                     	xdef	_hal_uart_send_byte
3367                     	xdef	_uart_server_is_ready
3368                     	xdef	_hal_delay_ms
3369                     	xdef	_hal_get_millis
3370                     	switch	.ubsct
3371  0000               L72_uart_tx_buffer:
3372  0000 000000000000  	ds.b	20
3373  0014               L71_uart_rx_buffer:
3374  0014 000000000000  	ds.b	20
3375                     	xref	_sprintf
3376                     	xref	_atoi
3377                     	xref	_strlen
3378                     	xref	_strncpy
3379                     	xref	_strchr
3380                     	xref	_TIM4_ClearFlag
3381                     	xref	_TIM4_ITConfig
3382                     	xref	_TIM4_TimeBaseInit
3383                     	xref	_UART1_GetFlagStatus
3384                     	xref	_UART1_SendData8
3385                     	xref	_UART1_ITConfig
3386                     	xref	_UART1_Cmd
3387                     	xref	_UART1_Init
3388                     	xref	_GPIO_ReadInputPin
3389                     	xref	_GPIO_WriteLow
3390                     	xref	_GPIO_WriteHigh
3391                     	xref	_GPIO_Init
3392                     	xref	_CLK_HSIPrescalerConfig
3393                     	xref	_CLK_PeripheralClockConfig
3394                     	switch	.const
3395  000f               L5111:
3396  000f 4552524f522c  	dc.b	"ERROR,INVALID_COMM"
3397  0021 414e440a00    	dc.b	"AND",10,0
3398  0026               L323:
3399  0026 53544152542c  	dc.b	"START,ALIVE,%d%d%d"
3400  0038 25642c454e44  	dc.b	"%d,END",0
3401                     	xref.b	c_x
3421                     	xref	c_xymov
3422                     	xref	c_lcmp
3423                     	xref	c_lsub
3424                     	xref	c_uitolx
3425                     	xref	c_rtol
3426                     	xref	c_ltor
3427                     	end
