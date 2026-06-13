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
  44  0025               L33_user_callback:
  45  0025 0000          	dc.w	0
  75                     ; 75 unsigned long hal_get_millis(void)
  75                     ; 76 {
  77                     	switch	.text
  78  0000               _hal_get_millis:
  82                     ; 77     return systick_ms;
  84  0000 ae0021        	ldw	x,#L13_systick_ms
  85  0003 cd0000        	call	c_ltor
  89  0006 81            	ret
 133                     ; 80 void hal_delay_ms(unsigned int ms)
 133                     ; 81 {
 134                     	switch	.text
 135  0007               _hal_delay_ms:
 137  0007 89            	pushw	x
 138  0008 5208          	subw	sp,#8
 139       00000008      OFST:	set	8
 142                     ; 82     unsigned long start = hal_get_millis();
 144  000a adf4          	call	_hal_get_millis
 146  000c 96            	ldw	x,sp
 147  000d 1c0005        	addw	x,#OFST-3
 148  0010 cd0000        	call	c_rtol
 152  0013               L101:
 153                     ; 83     while ((hal_get_millis() - start) < ms);
 155  0013 adeb          	call	_hal_get_millis
 157  0015 96            	ldw	x,sp
 158  0016 1c0005        	addw	x,#OFST-3
 159  0019 cd0000        	call	c_lsub
 161  001c 96            	ldw	x,sp
 162  001d 1c0001        	addw	x,#OFST-7
 163  0020 cd0000        	call	c_rtol
 166  0023 1e09          	ldw	x,(OFST+1,sp)
 167  0025 cd0000        	call	c_uitolx
 169  0028 96            	ldw	x,sp
 170  0029 1c0001        	addw	x,#OFST-7
 171  002c cd0000        	call	c_lcmp
 173  002f 22e2          	jrugt	L101
 174                     ; 84 }
 177  0031 5b0a          	addw	sp,#10
 178  0033 81            	ret
 203                     ; 86 int uart_server_is_ready(void){
 204                     	switch	.text
 205  0034               _uart_server_is_ready:
 209                     ; 87     return (uart_state != UART_STATE_IDLE) ? 1 : 0;
 211  0034 3d19          	tnz	L31_uart_state
 212  0036 2705          	jreq	L21
 213  0038 ae0001        	ldw	x,#1
 214  003b 2001          	jra	L41
 215  003d               L21:
 216  003d 5f            	clrw	x
 217  003e               L41:
 220  003e 81            	ret
 256                     ; 90 void hal_uart_send_byte(uint8_t byte){
 257                     	switch	.text
 258  003f               _hal_uart_send_byte:
 260  003f 88            	push	a
 261       00000000      OFST:	set	0
 264  0040               L531:
 265                     ; 91     while (UART1_GetFlagStatus(UART1_FLAG_TXE) == RESET);
 267  0040 ae0080        	ldw	x,#128
 268  0043 cd0000        	call	_UART1_GetFlagStatus
 270  0046 4d            	tnz	a
 271  0047 27f7          	jreq	L531
 272                     ; 94     UART1_SendData8(byte);
 274  0049 7b01          	ld	a,(OFST+1,sp)
 275  004b cd0000        	call	_UART1_SendData8
 278  004e               L341:
 279                     ; 97     while (UART1_GetFlagStatus(UART1_FLAG_TC) == RESET);
 281  004e ae0040        	ldw	x,#64
 282  0051 cd0000        	call	_UART1_GetFlagStatus
 284  0054 4d            	tnz	a
 285  0055 27f7          	jreq	L341
 286                     ; 98 }
 289  0057 84            	pop	a
 290  0058 81            	ret
 344                     ; 100 void hal_uart_send(const uint8_t *data, uint16_t len){
 345                     	switch	.text
 346  0059               _hal_uart_send:
 348  0059 89            	pushw	x
 349  005a 89            	pushw	x
 350       00000002      OFST:	set	2
 353                     ; 102     for(i = 0; i < len; i++){
 355  005b 5f            	clrw	x
 356  005c 1f01          	ldw	(OFST-1,sp),x
 359  005e 200f          	jra	L102
 360  0060               L571:
 361                     ; 103         hal_uart_send_byte(data[i]);
 363  0060 1e03          	ldw	x,(OFST+1,sp)
 364  0062 72fb01        	addw	x,(OFST-1,sp)
 365  0065 f6            	ld	a,(x)
 366  0066 add7          	call	_hal_uart_send_byte
 368                     ; 102     for(i = 0; i < len; i++){
 370  0068 1e01          	ldw	x,(OFST-1,sp)
 371  006a 1c0001        	addw	x,#1
 372  006d 1f01          	ldw	(OFST-1,sp),x
 374  006f               L102:
 377  006f 1e01          	ldw	x,(OFST-1,sp)
 378  0071 1307          	cpw	x,(OFST+5,sp)
 379  0073 25eb          	jrult	L571
 380                     ; 105 }
 383  0075 5b04          	addw	sp,#4
 384  0077 81            	ret
 432                     ; 107 int uart_server_send(uint8_t *data, uint16_t len)
 432                     ; 108 {
 433                     	switch	.text
 434  0078               _uart_server_send:
 436  0078 89            	pushw	x
 437       00000000      OFST:	set	0
 440                     ; 109     if(uart_state == UART_STATE_IDLE) return -1;
 442  0079 3d19          	tnz	L31_uart_state
 443  007b 2605          	jrne	L722
 446  007d aeffff        	ldw	x,#65535
 448  0080 2028          	jra	L03
 449  0082               L722:
 450                     ; 110     if(len > sizeof(uart_tx_buffer)) len = sizeof(uart_tx_buffer);
 452  0082 1e05          	ldw	x,(OFST+5,sp)
 453  0084 a30015        	cpw	x,#21
 454  0087 2505          	jrult	L132
 457  0089 ae0014        	ldw	x,#20
 458  008c 1f05          	ldw	(OFST+5,sp),x
 459  008e               L132:
 460                     ; 111     memcpy(uart_tx_buffer, data, len);
 462  008e 1e01          	ldw	x,(OFST+1,sp)
 463  0090 bf00          	ldw	c_x,x
 464  0092 1e05          	ldw	x,(OFST+5,sp)
 465  0094 5d            	tnzw	x
 466  0095 2709          	jreq	L42
 467  0097               L62:
 468  0097 5a            	decw	x
 469  0098 92d600        	ld	a,([c_x.w],x)
 470  009b e700          	ld	(L72_uart_tx_buffer,x),a
 471  009d 5d            	tnzw	x
 472  009e 26f7          	jrne	L62
 473  00a0               L42:
 474                     ; 112     hal_uart_send(uart_tx_buffer, len);
 476  00a0 1e05          	ldw	x,(OFST+5,sp)
 477  00a2 89            	pushw	x
 478  00a3 ae0000        	ldw	x,#L72_uart_tx_buffer
 479  00a6 adb1          	call	_hal_uart_send
 481  00a8 85            	popw	x
 482                     ; 113     return 0;
 484  00a9 5f            	clrw	x
 486  00aa               L03:
 488  00aa 5b02          	addw	sp,#2
 489  00ac 81            	ret
 550                     ; 115 sensor_state_t sensor_reader_get_state(void)
 550                     ; 116 {
 551                     	switch	.text
 552  00ad               _sensor_reader_get_state:
 554       00000000      OFST:	set	0
 557                     ; 117     return current_state;
 559  00ad 1e03          	ldw	x,(OFST+3,sp)
 560  00af 90ae0014      	ldw	y,#L7_current_state
 561  00b3 a604          	ld	a,#4
 562  00b5 cd0000        	call	c_xymov
 566  00b8 81            	ret
 648                     ; 120 void message_formatter_alive(char *buf,
 648                     ; 121                              int buf_size,
 648                     ; 122                              uint8_t di1,
 648                     ; 123                              uint8_t di2,
 648                     ; 124                              uint8_t di3,
 648                     ; 125                              uint8_t di4)
 648                     ; 126 {
 649                     	switch	.text
 650  00b9               _message_formatter_alive:
 652  00b9 89            	pushw	x
 653       00000000      OFST:	set	0
 656                     ; 127     if (buf == 0)
 658  00ba a30000        	cpw	x,#0
 659  00bd 2708          	jreq	L63
 660                     ; 128         return;
 662                     ; 130     if (buf_size < 32)
 664  00bf 9c            	rvf
 665  00c0 1e05          	ldw	x,(OFST+5,sp)
 666  00c2 a30020        	cpw	x,#32
 667  00c5 2e02          	jrsge	L323
 668                     ; 131         return;
 669  00c7               L63:
 672  00c7 85            	popw	x
 673  00c8 81            	ret
 674  00c9               L323:
 675                     ; 133     sprintf(buf,
 675                     ; 134             "START,ALIVE,%d%d%d%d,END",
 675                     ; 135             di1,
 675                     ; 136             di2,
 675                     ; 137             di3,
 675                     ; 138             di4);
 677  00c9 7b0a          	ld	a,(OFST+10,sp)
 678  00cb 88            	push	a
 679  00cc 7b0a          	ld	a,(OFST+10,sp)
 680  00ce 88            	push	a
 681  00cf 7b0a          	ld	a,(OFST+10,sp)
 682  00d1 88            	push	a
 683  00d2 7b0a          	ld	a,(OFST+10,sp)
 684  00d4 88            	push	a
 685  00d5 ae0048        	ldw	x,#L523
 686  00d8 89            	pushw	x
 687  00d9 1e07          	ldw	x,(OFST+7,sp)
 688  00db cd0000        	call	_sprintf
 690  00de 5b06          	addw	sp,#6
 691                     ; 139 }
 693  00e0 20e5          	jra	L63
 885                     ; 141 uint8_t hal_di_read(uint8_t di_num)
 885                     ; 142 {
 886                     	switch	.text
 887  00e2               _hal_di_read:
 889  00e2 5203          	subw	sp,#3
 890       00000003      OFST:	set	3
 893                     ; 146     switch (di_num) {
 896                     ; 151         default: return 0;
 897  00e4 4a            	dec	a
 898  00e5 270c          	jreq	L723
 899  00e7 4a            	dec	a
 900  00e8 2714          	jreq	L133
 901  00ea 4a            	dec	a
 902  00eb 271c          	jreq	L333
 903  00ed 4a            	dec	a
 904  00ee 2724          	jreq	L533
 905  00f0               L733:
 908  00f0 4f            	clr	a
 910  00f1 203d          	jra	L64
 911  00f3               L723:
 912                     ; 147         case 1: port = DI1_PORT; pin = DI1_PIN; break;
 914  00f3 ae500f        	ldw	x,#20495
 915  00f6 1f01          	ldw	(OFST-2,sp),x
 919  00f8 a604          	ld	a,#4
 920  00fa 6b03          	ld	(OFST+0,sp),a
 924  00fc 201f          	jra	L554
 925  00fe               L133:
 926                     ; 148         case 2: port = DI2_PORT; pin = DI2_PIN; break;
 928  00fe ae500f        	ldw	x,#20495
 929  0101 1f01          	ldw	(OFST-2,sp),x
 933  0103 a608          	ld	a,#8
 934  0105 6b03          	ld	(OFST+0,sp),a
 938  0107 2014          	jra	L554
 939  0109               L333:
 940                     ; 149         case 3: port = DI3_PORT; pin = DI3_PIN; break;
 942  0109 ae500f        	ldw	x,#20495
 943  010c 1f01          	ldw	(OFST-2,sp),x
 947  010e a610          	ld	a,#16
 948  0110 6b03          	ld	(OFST+0,sp),a
 952  0112 2009          	jra	L554
 953  0114               L533:
 954                     ; 150         case 4: port = DI4_PORT; pin = DI4_PIN; break;
 956  0114 ae500f        	ldw	x,#20495
 957  0117 1f01          	ldw	(OFST-2,sp),x
 961  0119 a680          	ld	a,#128
 962  011b 6b03          	ld	(OFST+0,sp),a
 966  011d               L554:
 967                     ; 153     return (GPIO_ReadInputPin(port, pin) == SET) ? 1 : 0;
 969  011d 7b03          	ld	a,(OFST+0,sp)
 970  011f 88            	push	a
 971  0120 1e02          	ldw	x,(OFST-1,sp)
 972  0122 cd0000        	call	_GPIO_ReadInputPin
 974  0125 5b01          	addw	sp,#1
 975  0127 a101          	cp	a,#1
 976  0129 2604          	jrne	L24
 977  012b a601          	ld	a,#1
 978  012d 2001          	jra	L44
 979  012f               L24:
 980  012f 4f            	clr	a
 981  0130               L44:
 983  0130               L64:
 985  0130 5b03          	addw	sp,#3
 986  0132 81            	ret
1083                     ; 158 void hal_relay_set(uint8_t relay_num, uint8_t state){
1084                     	switch	.text
1085  0133               _hal_relay_set:
1087  0133 89            	pushw	x
1088  0134 5204          	subw	sp,#4
1089       00000004      OFST:	set	4
1092                     ; 161 	BitStatus bit_state = (state == 0) ? SET : RESET;
1094  0136 9f            	ld	a,xl
1095  0137 4d            	tnz	a
1096  0138 2605          	jrne	L25
1097  013a ae0001        	ldw	x,#1
1098  013d 2001          	jra	L45
1099  013f               L25:
1100  013f 5f            	clrw	x
1101  0140               L45:
1102  0140 01            	rrwa	x,a
1103  0141 6b01          	ld	(OFST-3,sp),a
1104  0143 02            	rlwa	x,a
1106                     ; 163 	switch (relay_num) {
1108  0144 7b05          	ld	a,(OFST+1,sp)
1110                     ; 170         default: return;
1111  0146 4a            	dec	a
1112  0147 2711          	jreq	L754
1113  0149 4a            	dec	a
1114  014a 2719          	jreq	L164
1115  014c 4a            	dec	a
1116  014d 2721          	jreq	L364
1117  014f 4a            	dec	a
1118  0150 2729          	jreq	L564
1119  0152 4a            	dec	a
1120  0153 2731          	jreq	L764
1121  0155 4a            	dec	a
1122  0156 2739          	jreq	L174
1123  0158               L374:
1126  0158 205a          	jra	L65
1127  015a               L754:
1128                     ; 164         case 1: port = RELAY1_PORT; pin = RELAY1_PIN; break;
1130  015a ae5005        	ldw	x,#20485
1131  015d 1f02          	ldw	(OFST-2,sp),x
1135  015f a608          	ld	a,#8
1136  0161 6b04          	ld	(OFST+0,sp),a
1140  0163 2035          	jra	L745
1141  0165               L164:
1142                     ; 165         case 2: port = RELAY2_PORT; pin = RELAY2_PIN; break;
1144  0165 ae5005        	ldw	x,#20485
1145  0168 1f02          	ldw	(OFST-2,sp),x
1149  016a a604          	ld	a,#4
1150  016c 6b04          	ld	(OFST+0,sp),a
1154  016e 202a          	jra	L745
1155  0170               L364:
1156                     ; 166         case 3: port = RELAY3_PORT; pin = RELAY3_PIN; break;
1158  0170 ae5005        	ldw	x,#20485
1159  0173 1f02          	ldw	(OFST-2,sp),x
1163  0175 a602          	ld	a,#2
1164  0177 6b04          	ld	(OFST+0,sp),a
1168  0179 201f          	jra	L745
1169  017b               L564:
1170                     ; 167         case 4: port = RELAY4_PORT; pin = RELAY4_PIN; break;
1172  017b ae5005        	ldw	x,#20485
1173  017e 1f02          	ldw	(OFST-2,sp),x
1177  0180 a601          	ld	a,#1
1178  0182 6b04          	ld	(OFST+0,sp),a
1182  0184 2014          	jra	L745
1183  0186               L764:
1184                     ; 168         case 5: port = RELAY5_PORT; pin = RELAY5_PIN; break;
1186  0186 ae500a        	ldw	x,#20490
1187  0189 1f02          	ldw	(OFST-2,sp),x
1191  018b a608          	ld	a,#8
1192  018d 6b04          	ld	(OFST+0,sp),a
1196  018f 2009          	jra	L745
1197  0191               L174:
1198                     ; 169         case 6: port = RELAY6_PORT; pin = RELAY6_PIN; break;
1200  0191 ae500a        	ldw	x,#20490
1201  0194 1f02          	ldw	(OFST-2,sp),x
1205  0196 a610          	ld	a,#16
1206  0198 6b04          	ld	(OFST+0,sp),a
1210  019a               L745:
1211                     ; 173 	if (bit_state == SET) {
1213  019a 7b01          	ld	a,(OFST-3,sp)
1214  019c a101          	cp	a,#1
1215  019e 260b          	jrne	L155
1216                     ; 174         GPIO_WriteHigh(port, pin);  /* Set HIGH = relay off */
1218  01a0 7b04          	ld	a,(OFST+0,sp)
1219  01a2 88            	push	a
1220  01a3 1e03          	ldw	x,(OFST-1,sp)
1221  01a5 cd0000        	call	_GPIO_WriteHigh
1223  01a8 84            	pop	a
1225  01a9 2009          	jra	L355
1226  01ab               L155:
1227                     ; 176         GPIO_WriteLow(port, pin); /* Set LOW = relay on */
1229  01ab 7b04          	ld	a,(OFST+0,sp)
1230  01ad 88            	push	a
1231  01ae 1e03          	ldw	x,(OFST-1,sp)
1232  01b0 cd0000        	call	_GPIO_WriteLow
1234  01b3 84            	pop	a
1235  01b4               L355:
1236                     ; 178 }
1237  01b4               L65:
1240  01b4 5b06          	addw	sp,#6
1241  01b6 81            	ret
1285                     ; 180 void relay_control_set(uint8_t relay_num, uint8_t state)
1285                     ; 181 {
1286                     	switch	.text
1287  01b7               _relay_control_set:
1289  01b7 89            	pushw	x
1290       00000000      OFST:	set	0
1293                     ; 182     if (relay_num >= 1 && relay_num <= 6) {
1295  01b8 9e            	ld	a,xh
1296  01b9 4d            	tnz	a
1297  01ba 270d          	jreq	L775
1299  01bc 9e            	ld	a,xh
1300  01bd a107          	cp	a,#7
1301  01bf 2408          	jruge	L775
1302                     ; 183         hal_relay_set(relay_num, state);
1304  01c1 9f            	ld	a,xl
1305  01c2 97            	ld	xl,a
1306  01c3 7b01          	ld	a,(OFST+1,sp)
1307  01c5 95            	ld	xh,a
1308  01c6 cd0133        	call	_hal_relay_set
1310  01c9               L775:
1311                     ; 185 }
1314  01c9 85            	popw	x
1315  01ca 81            	ret
1351                     ; 187 void relay_control_set_all(uint8_t state)
1351                     ; 188 {
1352                     	switch	.text
1353  01cb               _relay_control_set_all:
1355  01cb 88            	push	a
1356       00000000      OFST:	set	0
1359                     ; 189     relay_control_set(1, state);
1361  01cc ae0100        	ldw	x,#256
1362  01cf 97            	ld	xl,a
1363  01d0 ade5          	call	_relay_control_set
1365                     ; 190     relay_control_set(2, state);
1367  01d2 7b01          	ld	a,(OFST+1,sp)
1368  01d4 ae0200        	ldw	x,#512
1369  01d7 97            	ld	xl,a
1370  01d8 addd          	call	_relay_control_set
1372                     ; 191     relay_control_set(3, state);
1374  01da 7b01          	ld	a,(OFST+1,sp)
1375  01dc ae0300        	ldw	x,#768
1376  01df 97            	ld	xl,a
1377  01e0 add5          	call	_relay_control_set
1379                     ; 192     relay_control_set(4, state);
1381  01e2 7b01          	ld	a,(OFST+1,sp)
1382  01e4 ae0400        	ldw	x,#1024
1383  01e7 97            	ld	xl,a
1384  01e8 adcd          	call	_relay_control_set
1386                     ; 193     relay_control_set(5, state);
1388  01ea 7b01          	ld	a,(OFST+1,sp)
1389  01ec ae0500        	ldw	x,#1280
1390  01ef 97            	ld	xl,a
1391  01f0 adc5          	call	_relay_control_set
1393                     ; 194     relay_control_set(6, state);
1395  01f2 7b01          	ld	a,(OFST+1,sp)
1396  01f4 ae0600        	ldw	x,#1536
1397  01f7 97            	ld	xl,a
1398  01f8 adbd          	call	_relay_control_set
1400                     ; 195 }
1403  01fa 84            	pop	a
1404  01fb 81            	ret
1477                     ; 197 void message_formatter_avcc(char *buf, int buf_size, uint16_t lanid, uint32_t seqn, uint16_t axle_count){
1478                     	switch	.text
1479  01fc               _message_formatter_avcc:
1481  01fc 89            	pushw	x
1482       00000000      OFST:	set	0
1485                     ; 198     if(buf == 0) return;
1487  01fd a30000        	cpw	x,#0
1488  0200 2708          	jreq	L66
1491                     ; 199     if(buf_size < 64) return;
1493  0202 9c            	rvf
1494  0203 1e05          	ldw	x,(OFST+5,sp)
1495  0205 a30040        	cpw	x,#64
1496  0208 2e02          	jrsge	L756
1498  020a               L66:
1501  020a 85            	popw	x
1502  020b 81            	ret
1503  020c               L756:
1504                     ; 200     sprintf(buf,"START,AVCC,%u,%lu,AXLE,%u,END",(unsigned int)lanid,(unsigned long)seqn,(unsigned int)axle_count);
1506  020c 1e0d          	ldw	x,(OFST+13,sp)
1507  020e 89            	pushw	x
1508  020f 1e0d          	ldw	x,(OFST+13,sp)
1509  0211 89            	pushw	x
1510  0212 1e0d          	ldw	x,(OFST+13,sp)
1511  0214 89            	pushw	x
1512  0215 1e0d          	ldw	x,(OFST+13,sp)
1513  0217 89            	pushw	x
1514  0218 ae002a        	ldw	x,#L166
1515  021b 89            	pushw	x
1516  021c 1e0b          	ldw	x,(OFST+11,sp)
1517  021e cd0000        	call	_sprintf
1519  0221 5b0a          	addw	sp,#10
1520                     ; 201 }
1522  0223 20e5          	jra	L66
1548                     ; 203 void sensor_reader_update(void){
1549                     	switch	.text
1550  0225               _sensor_reader_update:
1554                     ; 204     current_state.di1 = hal_di_read(1);
1556  0225 a601          	ld	a,#1
1557  0227 cd00e2        	call	_hal_di_read
1559  022a b714          	ld	L7_current_state,a
1560                     ; 205     current_state.di2 = hal_di_read(2);
1562  022c a602          	ld	a,#2
1563  022e cd00e2        	call	_hal_di_read
1565  0231 b715          	ld	L7_current_state+1,a
1566                     ; 206     current_state.di3 = hal_di_read(3);
1568  0233 a603          	ld	a,#3
1569  0235 cd00e2        	call	_hal_di_read
1571  0238 b716          	ld	L7_current_state+2,a
1572                     ; 207     current_state.di4 = hal_di_read(4);
1574  023a a604          	ld	a,#4
1575  023c cd00e2        	call	_hal_di_read
1577  023f b717          	ld	L7_current_state+3,a
1578                     ; 208 }
1581  0241 81            	ret
1631                     ; 210 void send_alive_message(void){
1632                     	switch	.text
1633  0242               _send_alive_message:
1635  0242 5258          	subw	sp,#88
1636       00000058      OFST:	set	88
1639                     ; 214     sensor = sensor_reader_get_state();
1641  0244 96            	ldw	x,sp
1642  0245 1c0055        	addw	x,#OFST-3
1643  0248 89            	pushw	x
1644  0249 cd00ad        	call	_sensor_reader_get_state
1646  024c 85            	popw	x
1647                     ; 215     message_formatter_alive(msg_buf,sizeof(msg_buf),sensor.di1,sensor.di2,sensor.di3,sensor.di4);
1649  024d 7b58          	ld	a,(OFST+0,sp)
1650  024f 88            	push	a
1651  0250 7b58          	ld	a,(OFST+0,sp)
1652  0252 88            	push	a
1653  0253 7b58          	ld	a,(OFST+0,sp)
1654  0255 88            	push	a
1655  0256 7b58          	ld	a,(OFST+0,sp)
1656  0258 88            	push	a
1657  0259 ae0050        	ldw	x,#80
1658  025c 89            	pushw	x
1659  025d 96            	ldw	x,sp
1660  025e 1c000b        	addw	x,#OFST-77
1661  0261 cd00b9        	call	_message_formatter_alive
1663  0264 5b06          	addw	sp,#6
1664                     ; 216     if(uart_server_is_ready()){
1666  0266 cd0034        	call	_uart_server_is_ready
1668  0269 a30000        	cpw	x,#0
1669  026c 2710          	jreq	L517
1670                     ; 217         uart_server_send((uint8_t *)msg_buf, strlen(msg_buf));
1672  026e 96            	ldw	x,sp
1673  026f 1c0005        	addw	x,#OFST-83
1674  0272 cd0000        	call	_strlen
1676  0275 89            	pushw	x
1677  0276 96            	ldw	x,sp
1678  0277 1c0007        	addw	x,#OFST-81
1679  027a cd0078        	call	_uart_server_send
1681  027d 85            	popw	x
1682  027e               L517:
1683                     ; 219 }
1686  027e 5b58          	addw	sp,#88
1687  0280 81            	ret
1711                     ; 221 void hal_timer_start(void)
1711                     ; 222 {
1712                     	switch	.text
1713  0281               _hal_timer_start:
1717                     ; 223     TIM4_Cmd(ENABLE);
1719  0281 a601          	ld	a,#1
1720  0283 cd0000        	call	_TIM4_Cmd
1722                     ; 224 }
1725  0286 81            	ret
1786                     ; 229 void process_axle_counting(void){
1787                     	switch	.text
1788  0287               _process_axle_counting:
1790  0287 525a          	subw	sp,#90
1791       0000005a      OFST:	set	90
1794                     ; 230     sensor_state_t sensor = sensor_reader_get_state();
1796  0289 96            	ldw	x,sp
1797  028a 1c0057        	addw	x,#OFST-3
1798  028d 89            	pushw	x
1799  028e cd00ad        	call	_sensor_reader_get_state
1801  0291 85            	popw	x
1802                     ; 233     if(sensor.di1 == 1 && axle_counter.prev_di1_state == 0){
1804  0292 7b57          	ld	a,(OFST-3,sp)
1805  0294 a101          	cp	a,#1
1806  0296 260a          	jrne	L557
1808  0298 3d03          	tnz	L3_axle_counter+3
1809  029a 2606          	jrne	L557
1810                     ; 234         axle_counter.loop_active = 1;
1812  029c 35010000      	mov	L3_axle_counter,#1
1813                     ; 235         axle_counter.axle_count = 0;
1815  02a0 3f02          	clr	L3_axle_counter+2
1816  02a2               L557:
1817                     ; 238     if(axle_counter.loop_active){
1819  02a2 3d00          	tnz	L3_axle_counter
1820  02a4 2710          	jreq	L757
1821                     ; 239         if(sensor.di2 == 1 && axle_counter.prev_di2_state == 0){
1823  02a6 7b58          	ld	a,(OFST-2,sp)
1824  02a8 a101          	cp	a,#1
1825  02aa 2606          	jrne	L167
1827  02ac 3d01          	tnz	L3_axle_counter+1
1828  02ae 2602          	jrne	L167
1829                     ; 240             axle_counter.axle_count++;
1831  02b0 3c02          	inc	L3_axle_counter+2
1832  02b2               L167:
1833                     ; 242         axle_counter.prev_di2_state = sensor.di2;
1835  02b2 7b58          	ld	a,(OFST-2,sp)
1836  02b4 b701          	ld	L3_axle_counter+1,a
1837  02b6               L757:
1838                     ; 246     if (sensor.di1 == 0 && axle_counter.prev_di1_state == 1 && axle_counter.loop_active){
1840  02b6 0d57          	tnz	(OFST-3,sp)
1841  02b8 264f          	jrne	L367
1843  02ba b603          	ld	a,L3_axle_counter+3
1844  02bc a101          	cp	a,#1
1845  02be 2649          	jrne	L367
1847  02c0 3d00          	tnz	L3_axle_counter
1848  02c2 2745          	jreq	L367
1849                     ; 248         uint16_t axle_final_count = axle_counter.axle_count / 2;
1851  02c4 b602          	ld	a,L3_axle_counter+2
1852  02c6 5f            	clrw	x
1853  02c7 97            	ld	xl,a
1854  02c8 57            	sraw	x
1855  02c9 1f05          	ldw	(OFST-85,sp),x
1857                     ; 252         message_formatter_avcc(msg_buf, sizeof(msg_buf),DEVICE_LANID,axle_counter.embedded_seq_num,axle_final_count);
1859  02cb 1e05          	ldw	x,(OFST-85,sp)
1860  02cd 89            	pushw	x
1861  02ce be06          	ldw	x,L3_axle_counter+6
1862  02d0 89            	pushw	x
1863  02d1 be04          	ldw	x,L3_axle_counter+4
1864  02d3 89            	pushw	x
1865  02d4 ae007d        	ldw	x,#125
1866  02d7 89            	pushw	x
1867  02d8 ae0050        	ldw	x,#80
1868  02db 89            	pushw	x
1869  02dc 96            	ldw	x,sp
1870  02dd 1c0011        	addw	x,#OFST-73
1871  02e0 cd01fc        	call	_message_formatter_avcc
1873  02e3 5b0a          	addw	sp,#10
1874                     ; 254         if(uart_server_is_ready()){
1876  02e5 cd0034        	call	_uart_server_is_ready
1878  02e8 a30000        	cpw	x,#0
1879  02eb 2710          	jreq	L567
1880                     ; 255             uart_server_send((uint8_t *)msg_buf, strlen(msg_buf));
1882  02ed 96            	ldw	x,sp
1883  02ee 1c0007        	addw	x,#OFST-83
1884  02f1 cd0000        	call	_strlen
1886  02f4 89            	pushw	x
1887  02f5 96            	ldw	x,sp
1888  02f6 1c0009        	addw	x,#OFST-81
1889  02f9 cd0078        	call	_uart_server_send
1891  02fc 85            	popw	x
1892  02fd               L567:
1893                     ; 258         axle_counter.embedded_seq_num++;
1895  02fd ae0004        	ldw	x,#L3_axle_counter+4
1896  0300 a601          	ld	a,#1
1897  0302 cd0000        	call	c_lgadc
1899                     ; 259         axle_counter.loop_active = 0;
1901  0305 3f00          	clr	L3_axle_counter
1902                     ; 260         axle_counter.axle_count = 0;
1904  0307 3f02          	clr	L3_axle_counter+2
1905  0309               L367:
1906                     ; 263     axle_counter.prev_di1_state = sensor.di1;
1908  0309 7b57          	ld	a,(OFST-3,sp)
1909  030b b703          	ld	L3_axle_counter+3,a
1910                     ; 264 }
1913  030d 5b5a          	addw	sp,#90
1914  030f 81            	ret
1938                     ; 265 void sensor_reader_init(void)
1938                     ; 266 {
1939                     	switch	.text
1940  0310               _sensor_reader_init:
1944                     ; 268     sensor_reader_update();
1946  0310 cd0225        	call	_sensor_reader_update
1948                     ; 269 }
1951  0313 81            	ret
1979                     .const:	section	.text
1980  0000               L401:
1981  0000 00000032      	dc.l	50
1982  0004               L601:
1983  0004 000001f4      	dc.l	500
1984                     ; 270 void timer_callback(void){
1985                     	switch	.text
1986  0314               _timer_callback:
1990                     ; 271     task_timer.current_time = hal_get_millis();
1992  0314 cd0000        	call	_hal_get_millis
1994  0317 ae0010        	ldw	x,#L5_task_timer+8
1995  031a cd0000        	call	c_rtol
1997                     ; 273     if ((task_timer.current_time - task_timer.last_sensor_time) >= SENSOR_READ_INTERVAL){
1999  031d ae0010        	ldw	x,#L5_task_timer+8
2000  0320 cd0000        	call	c_ltor
2002  0323 ae000c        	ldw	x,#L5_task_timer+4
2003  0326 cd0000        	call	c_lsub
2005  0329 ae0000        	ldw	x,#L401
2006  032c cd0000        	call	c_lcmp
2008  032f 250e          	jrult	L7001
2009                     ; 274         sensor_reader_update();
2011  0331 cd0225        	call	_sensor_reader_update
2013                     ; 275         process_axle_counting();
2015  0334 cd0287        	call	_process_axle_counting
2017                     ; 276         task_timer.last_sensor_time = task_timer.current_time;
2019  0337 be12          	ldw	x,L5_task_timer+10
2020  0339 bf0e          	ldw	L5_task_timer+6,x
2021  033b be10          	ldw	x,L5_task_timer+8
2022  033d bf0c          	ldw	L5_task_timer+4,x
2023  033f               L7001:
2024                     ; 280     if ((task_timer.current_time - task_timer.last_alive_time) >= ALIVE_INTERVAL){
2026  033f ae0010        	ldw	x,#L5_task_timer+8
2027  0342 cd0000        	call	c_ltor
2029  0345 ae0008        	ldw	x,#L5_task_timer
2030  0348 cd0000        	call	c_lsub
2032  034b ae0004        	ldw	x,#L601
2033  034e cd0000        	call	c_lcmp
2035  0351 250b          	jrult	L1101
2036                     ; 281         send_alive_message();  
2038  0353 cd0242        	call	_send_alive_message
2040                     ; 282         task_timer.last_alive_time = task_timer.current_time;
2042  0356 be12          	ldw	x,L5_task_timer+10
2043  0358 bf0a          	ldw	L5_task_timer+2,x
2044  035a be10          	ldw	x,L5_task_timer+8
2045  035c bf08          	ldw	L5_task_timer,x
2046  035e               L1101:
2047                     ; 284 }
2050  035e 81            	ret
2088                     ; 286 void hal_timer_set_callback(timer_callback_t callback)
2088                     ; 287 {
2089                     	switch	.text
2090  035f               _hal_timer_set_callback:
2094                     ; 288     user_callback = callback;
2096  035f bf25          	ldw	L33_user_callback,x
2097                     ; 289 }
2100  0361 81            	ret
2207                     ; 292 int command_parser_execute(const char *cmd_str, int len)
2207                     ; 293 {
2208                     	switch	.text
2209  0362               _command_parser_execute:
2211  0362 89            	pushw	x
2212  0363 5246          	subw	sp,#70
2213       00000046      OFST:	set	70
2216                     ; 295     char *cmd = NULL;
2218                     ; 296     char *value_str = NULL;
2220                     ; 298     int relay_num = 0;
2222                     ; 299     int relay_state = 0;
2224                     ; 301     if (len == 0 || len >= 64) return -1;
2226  0365 1e4b          	ldw	x,(OFST+5,sp)
2227  0367 2708          	jreq	L5011
2229  0369 9c            	rvf
2230  036a 1e4b          	ldw	x,(OFST+5,sp)
2231  036c a30040        	cpw	x,#64
2232  036f 2f05          	jrslt	L3011
2233  0371               L5011:
2236  0371 aeffff        	ldw	x,#65535
2238  0374 202e          	jra	L411
2239  0376               L3011:
2240                     ; 304     strncpy(cmd_copy, cmd_str, len);
2242  0376 1e4b          	ldw	x,(OFST+5,sp)
2243  0378 89            	pushw	x
2244  0379 1e49          	ldw	x,(OFST+3,sp)
2245  037b 89            	pushw	x
2246  037c 96            	ldw	x,sp
2247  037d 1c0007        	addw	x,#OFST-63
2248  0380 cd0000        	call	_strncpy
2250  0383 5b04          	addw	sp,#4
2251                     ; 305     cmd_copy[len] = '\0';
2253  0385 96            	ldw	x,sp
2254  0386 1c0003        	addw	x,#OFST-67
2255  0389 1f01          	ldw	(OFST-69,sp),x
2257  038b 1e4b          	ldw	x,(OFST+5,sp)
2258  038d 72fb01        	addw	x,(OFST-69,sp)
2259  0390 7f            	clr	(x)
2260                     ; 308     comma_pos = strchr(cmd_copy, ',');
2262  0391 4b2c          	push	#44
2263  0393 96            	ldw	x,sp
2264  0394 1c0004        	addw	x,#OFST-66
2265  0397 cd0000        	call	_strchr
2267  039a 84            	pop	a
2268  039b 1f45          	ldw	(OFST-1,sp),x
2270                     ; 309     if (!comma_pos) return -1;
2272  039d 1e45          	ldw	x,(OFST-1,sp)
2273  039f 2606          	jrne	L7011
2276  03a1 aeffff        	ldw	x,#65535
2278  03a4               L411:
2280  03a4 5b48          	addw	sp,#72
2281  03a6 81            	ret
2282  03a7               L7011:
2283                     ; 312     *comma_pos = '\0';
2285  03a7 1e45          	ldw	x,(OFST-1,sp)
2286  03a9 7f            	clr	(x)
2287                     ; 313     cmd = cmd_copy;
2289  03aa 96            	ldw	x,sp
2290  03ab 1c0003        	addw	x,#OFST-67
2291  03ae 1f43          	ldw	(OFST-3,sp),x
2293                     ; 314     value_str = comma_pos + 1;
2295  03b0 1e45          	ldw	x,(OFST-1,sp)
2296  03b2 5c            	incw	x
2297  03b3 1f45          	ldw	(OFST-1,sp),x
2299                     ; 317     if (cmd[0] == 'R' && cmd[1] >= '1' && cmd[1] <= '6' && cmd[2] == '\0') {
2301  03b5 1e43          	ldw	x,(OFST-3,sp)
2302  03b7 f6            	ld	a,(x)
2303  03b8 a152          	cp	a,#82
2304  03ba 2634          	jrne	L1111
2306  03bc 1e43          	ldw	x,(OFST-3,sp)
2307  03be e601          	ld	a,(1,x)
2308  03c0 a131          	cp	a,#49
2309  03c2 252c          	jrult	L1111
2311  03c4 1e43          	ldw	x,(OFST-3,sp)
2312  03c6 e601          	ld	a,(1,x)
2313  03c8 a137          	cp	a,#55
2314  03ca 2424          	jruge	L1111
2316  03cc 1e43          	ldw	x,(OFST-3,sp)
2317  03ce 6d02          	tnz	(2,x)
2318  03d0 261e          	jrne	L1111
2319                     ; 318         relay_num = cmd[1] - '0';
2321  03d2 1e43          	ldw	x,(OFST-3,sp)
2322  03d4 e601          	ld	a,(1,x)
2323  03d6 5f            	clrw	x
2324  03d7 97            	ld	xl,a
2325  03d8 1d0030        	subw	x,#48
2326  03db 1f43          	ldw	(OFST-3,sp),x
2328                     ; 319         relay_state = atoi(value_str);
2330  03dd 1e45          	ldw	x,(OFST-1,sp)
2331  03df cd0000        	call	_atoi
2333  03e2 1f45          	ldw	(OFST-1,sp),x
2335                     ; 322         relay_control_set(relay_num, relay_state);
2337  03e4 7b46          	ld	a,(OFST+0,sp)
2338  03e6 97            	ld	xl,a
2339  03e7 7b44          	ld	a,(OFST-2,sp)
2340  03e9 95            	ld	xh,a
2341  03ea cd01b7        	call	_relay_control_set
2343                     ; 323         return 0;
2345  03ed 5f            	clrw	x
2347  03ee 20b4          	jra	L411
2348  03f0               L1111:
2349                     ; 326     return -1;
2351  03f0 aeffff        	ldw	x,#65535
2353  03f3 20af          	jra	L411
2377                     ; 329 void relay_control_init(void)
2377                     ; 330 {
2378                     	switch	.text
2379  03f5               _relay_control_init:
2383                     ; 331     relay_control_set_all(1);  /* 1 = on for active-low relays */
2385  03f5 a601          	ld	a,#1
2386  03f7 cd01cb        	call	_relay_control_set_all
2388                     ; 332 }
2391  03fa 81            	ret
2416                     ; 334 void hal_w5500_reset_high(void)
2416                     ; 335 {
2417                     	switch	.text
2418  03fb               _hal_w5500_reset_high:
2422                     ; 336     GPIO_WriteHigh(W5500_RST_PORT, W5500_RST_PIN);
2424  03fb 4b20          	push	#32
2425  03fd ae5014        	ldw	x,#20500
2426  0400 cd0000        	call	_GPIO_WriteHigh
2428  0403 84            	pop	a
2429                     ; 337 }
2432  0404 81            	ret
2458                     ; 339 void hal_gpio_init(void){
2459                     	switch	.text
2460  0405               _hal_gpio_init:
2464                     ; 341     GPIO_Init(DI1_PORT, DI1_PIN, GPIO_MODE_IN_PU_NO_IT);
2466  0405 4b40          	push	#64
2467  0407 4b04          	push	#4
2468  0409 ae500f        	ldw	x,#20495
2469  040c cd0000        	call	_GPIO_Init
2471  040f 85            	popw	x
2472                     ; 342     GPIO_Init(DI2_PORT, DI2_PIN, GPIO_MODE_IN_PU_NO_IT);
2474  0410 4b40          	push	#64
2475  0412 4b08          	push	#8
2476  0414 ae500f        	ldw	x,#20495
2477  0417 cd0000        	call	_GPIO_Init
2479  041a 85            	popw	x
2480                     ; 343     GPIO_Init(DI3_PORT, DI3_PIN, GPIO_MODE_IN_PU_NO_IT);
2482  041b 4b40          	push	#64
2483  041d 4b10          	push	#16
2484  041f ae500f        	ldw	x,#20495
2485  0422 cd0000        	call	_GPIO_Init
2487  0425 85            	popw	x
2488                     ; 344     GPIO_Init(DI4_PORT, DI4_PIN, GPIO_MODE_IN_PU_NO_IT);
2490  0426 4b40          	push	#64
2491  0428 4b80          	push	#128
2492  042a ae500f        	ldw	x,#20495
2493  042d cd0000        	call	_GPIO_Init
2495  0430 85            	popw	x
2496                     ; 347     GPIO_Init(RELAY1_PORT, RELAY1_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
2498  0431 4bf0          	push	#240
2499  0433 4b08          	push	#8
2500  0435 ae5005        	ldw	x,#20485
2501  0438 cd0000        	call	_GPIO_Init
2503  043b 85            	popw	x
2504                     ; 348     GPIO_Init(RELAY2_PORT, RELAY2_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
2506  043c 4bf0          	push	#240
2507  043e 4b04          	push	#4
2508  0440 ae5005        	ldw	x,#20485
2509  0443 cd0000        	call	_GPIO_Init
2511  0446 85            	popw	x
2512                     ; 349     GPIO_Init(RELAY3_PORT, RELAY3_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
2514  0447 4bf0          	push	#240
2515  0449 4b02          	push	#2
2516  044b ae5005        	ldw	x,#20485
2517  044e cd0000        	call	_GPIO_Init
2519  0451 85            	popw	x
2520                     ; 350     GPIO_Init(RELAY4_PORT, RELAY4_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
2522  0452 4bf0          	push	#240
2523  0454 4b01          	push	#1
2524  0456 ae5005        	ldw	x,#20485
2525  0459 cd0000        	call	_GPIO_Init
2527  045c 85            	popw	x
2528                     ; 351     GPIO_Init(RELAY5_PORT, RELAY5_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
2530  045d 4bf0          	push	#240
2531  045f 4b08          	push	#8
2532  0461 ae500a        	ldw	x,#20490
2533  0464 cd0000        	call	_GPIO_Init
2535  0467 85            	popw	x
2536                     ; 352     GPIO_Init(RELAY6_PORT, RELAY6_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
2538  0468 4bf0          	push	#240
2539  046a 4b10          	push	#16
2540  046c ae500a        	ldw	x,#20490
2541  046f cd0000        	call	_GPIO_Init
2543  0472 85            	popw	x
2544                     ; 355     hal_relay_set(1, 1);
2546  0473 ae0101        	ldw	x,#257
2547  0476 cd0133        	call	_hal_relay_set
2549                     ; 356     hal_relay_set(2, 1);
2551  0479 ae0201        	ldw	x,#513
2552  047c cd0133        	call	_hal_relay_set
2554                     ; 357     hal_relay_set(3, 1);
2556  047f ae0301        	ldw	x,#769
2557  0482 cd0133        	call	_hal_relay_set
2559                     ; 358     hal_relay_set(4, 1);
2561  0485 ae0401        	ldw	x,#1025
2562  0488 cd0133        	call	_hal_relay_set
2564                     ; 359     hal_relay_set(5, 1);
2566  048b ae0501        	ldw	x,#1281
2567  048e cd0133        	call	_hal_relay_set
2569                     ; 360     hal_relay_set(6, 1);
2571  0491 ae0601        	ldw	x,#1537
2572  0494 cd0133        	call	_hal_relay_set
2574                     ; 363     GPIO_Init(HARDRST_PORT, HARDRST_PIN, GPIO_MODE_IN_PU_NO_IT);
2576  0497 4b40          	push	#64
2577  0499 4b80          	push	#128
2578  049b ae5005        	ldw	x,#20485
2579  049e cd0000        	call	_GPIO_Init
2581  04a1 85            	popw	x
2582                     ; 366     GPIO_Init(W5500_RST_PORT, W5500_RST_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
2584  04a2 4bf0          	push	#240
2585  04a4 4b20          	push	#32
2586  04a6 ae5014        	ldw	x,#20500
2587  04a9 cd0000        	call	_GPIO_Init
2589  04ac 85            	popw	x
2590                     ; 367 	hal_w5500_reset_high();
2592  04ad cd03fb        	call	_hal_w5500_reset_high
2594                     ; 368 }
2597  04b0 81            	ret
2621                     ; 370 uint16_t hal_uart_available(void){
2622                     	switch	.text
2623  04b1               _hal_uart_available:
2627                     ; 371 	return uart_rx_count;
2629  04b1 be1b          	ldw	x,L12_uart_rx_count
2632  04b3 81            	ret
2671                     ; 374 uint8_t hal_uart_read_byte(void){
2672                     	switch	.text
2673  04b4               _hal_uart_read_byte:
2675  04b4 88            	push	a
2676       00000001      OFST:	set	1
2679                     ; 375 	uint8_t byte = 0;
2681  04b5 0f01          	clr	(OFST+0,sp)
2683                     ; 376 	if (uart_rx_count > 0){
2685  04b7 be1b          	ldw	x,L12_uart_rx_count
2686  04b9 2719          	jreq	L1711
2687                     ; 377 		disableInterrupts();
2690  04bb 9b            sim
2692                     ; 379 		byte = uart_rx_buffer[uart_rx_tail];
2695  04bc be1f          	ldw	x,L52_uart_rx_tail
2696  04be e614          	ld	a,(L71_uart_rx_buffer,x)
2697  04c0 6b01          	ld	(OFST+0,sp),a
2699                     ; 380 		uart_rx_tail = (uart_rx_tail + 1) % UART_RX_BUFFER_SIZE;
2701  04c2 be1f          	ldw	x,L52_uart_rx_tail
2702  04c4 5c            	incw	x
2703  04c5 a614          	ld	a,#20
2704  04c7 62            	div	x,a
2705  04c8 5f            	clrw	x
2706  04c9 97            	ld	xl,a
2707  04ca bf1f          	ldw	L52_uart_rx_tail,x
2708                     ; 381 		uart_rx_count--;
2710  04cc be1b          	ldw	x,L12_uart_rx_count
2711  04ce 1d0001        	subw	x,#1
2712  04d1 bf1b          	ldw	L12_uart_rx_count,x
2713                     ; 382 		enableInterrupts();
2716  04d3 9a            rim
2719  04d4               L1711:
2720                     ; 384 	return byte;
2722  04d4 7b01          	ld	a,(OFST+0,sp)
2725  04d6 5b01          	addw	sp,#1
2726  04d8 81            	ret
2800                     ; 387 void uart_server_process(void){
2801                     	switch	.text
2802  04d9               _uart_server_process:
2804  04d9 521f          	subw	sp,#31
2805       0000001f      OFST:	set	31
2808                     ; 393 	if (uart_state == UART_STATE_IDLE){
2810  04db 3d19          	tnz	L31_uart_state
2811  04dd 2603          	jrne	L431
2812  04df cc059a        	jp	L231
2813  04e2               L431:
2814                     ; 394 		return;
2816                     ; 396 	available_len = hal_uart_available();
2818  04e2 adcd          	call	_hal_uart_available
2820  04e4 1f05          	ldw	(OFST-26,sp),x
2822                     ; 398 	if(available_len > 0){
2824  04e6 1e05          	ldw	x,(OFST-26,sp)
2825  04e8 2603          	jrne	L631
2826  04ea cc0596        	jp	L7221
2827  04ed               L631:
2828                     ; 399 		uart_state = UART_STATE_RX_PENDING;
2830  04ed 35020019      	mov	L31_uart_state,#2
2832  04f1 ac820582      	jpf	L5321
2833  04f5               L1321:
2834                     ; 402 			read_byte = hal_uart_read_byte();
2836  04f5 adbd          	call	_hal_uart_read_byte
2838  04f7 6b1f          	ld	(OFST+0,sp),a
2840                     ; 404 			if (read_byte == '\n' || read_byte == '\r'){
2842  04f9 7b1f          	ld	a,(OFST+0,sp)
2843  04fb a10a          	cp	a,#10
2844  04fd 2706          	jreq	L3421
2846  04ff 7b1f          	ld	a,(OFST+0,sp)
2847  0501 a10d          	cp	a,#13
2848  0503 265c          	jrne	L1421
2849  0505               L3421:
2850                     ; 405 				if(uart_rx_count > 0){
2852  0505 be1b          	ldw	x,L12_uart_rx_count
2853  0507 2772          	jreq	L5521
2854                     ; 406 					uart_rx_buffer[uart_rx_count] = '\0';
2856  0509 be1b          	ldw	x,L12_uart_rx_count
2857  050b 6f14          	clr	(L71_uart_rx_buffer,x)
2858                     ; 407 					if (command_parser_execute((const char *)uart_rx_buffer,uart_rx_count) == 0){
2860  050d be1b          	ldw	x,L12_uart_rx_count
2861  050f 89            	pushw	x
2862  0510 ae0014        	ldw	x,#L71_uart_rx_buffer
2863  0513 cd0362        	call	_command_parser_execute
2865  0516 5b02          	addw	sp,#2
2866  0518 a30000        	cpw	x,#0
2867  051b 2634          	jrne	L7421
2868                     ; 408 						state = sensor_reader_get_state();
2870  051d 96            	ldw	x,sp
2871  051e 1c001b        	addw	x,#OFST-4
2872  0521 89            	pushw	x
2873  0522 cd00ad        	call	_sensor_reader_get_state
2875  0525 85            	popw	x
2876                     ; 409 						message_formatter_alive(resp_buf, sizeof(resp_buf),state.di1,state.di2,state.di3,state.di4);
2878  0526 7b1e          	ld	a,(OFST-1,sp)
2879  0528 88            	push	a
2880  0529 7b1e          	ld	a,(OFST-1,sp)
2881  052b 88            	push	a
2882  052c 7b1e          	ld	a,(OFST-1,sp)
2883  052e 88            	push	a
2884  052f 7b1e          	ld	a,(OFST-1,sp)
2885  0531 88            	push	a
2886  0532 ae0014        	ldw	x,#20
2887  0535 89            	pushw	x
2888  0536 96            	ldw	x,sp
2889  0537 1c000d        	addw	x,#OFST-18
2890  053a cd00b9        	call	_message_formatter_alive
2892  053d 5b06          	addw	sp,#6
2893                     ; 410 					 	uart_server_send((uint8_t *)resp_buf,strlen(resp_buf));
2895  053f 96            	ldw	x,sp
2896  0540 1c0007        	addw	x,#OFST-24
2897  0543 cd0000        	call	_strlen
2899  0546 89            	pushw	x
2900  0547 96            	ldw	x,sp
2901  0548 1c0009        	addw	x,#OFST-22
2902  054b cd0078        	call	_uart_server_send
2904  054e 85            	popw	x
2906  054f 200b          	jra	L1521
2907  0551               L7421:
2908                     ; 413                         uart_server_send((uint8_t *)"ERROR,INVALID_COMMAND\n",strlen("ERROR,INVALID_COMMAND\n"));
2910  0551 ae0016        	ldw	x,#22
2911  0554 89            	pushw	x
2912  0555 ae0013        	ldw	x,#L3521
2913  0558 cd0078        	call	_uart_server_send
2915  055b 85            	popw	x
2916  055c               L1521:
2917                     ; 415                     uart_rx_count = 0;
2919  055c 5f            	clrw	x
2920  055d bf1b          	ldw	L12_uart_rx_count,x
2921  055f 201a          	jra	L5521
2922  0561               L1421:
2923                     ; 418             else if (read_byte >= 32 && read_byte < 127){
2925  0561 7b1f          	ld	a,(OFST+0,sp)
2926  0563 a120          	cp	a,#32
2927  0565 2514          	jrult	L5521
2929  0567 7b1f          	ld	a,(OFST+0,sp)
2930  0569 a17f          	cp	a,#127
2931  056b 240e          	jruge	L5521
2932                     ; 419                 uart_rx_buffer[uart_rx_count++] = read_byte;
2934  056d 7b1f          	ld	a,(OFST+0,sp)
2935  056f be1b          	ldw	x,L12_uart_rx_count
2936  0571 1c0001        	addw	x,#1
2937  0574 bf1b          	ldw	L12_uart_rx_count,x
2938  0576 1d0001        	subw	x,#1
2939  0579 e714          	ld	(L71_uart_rx_buffer,x),a
2940  057b               L5521:
2941                     ; 421             available_len--;
2943  057b 1e05          	ldw	x,(OFST-26,sp)
2944  057d 1d0001        	subw	x,#1
2945  0580 1f05          	ldw	(OFST-26,sp),x
2947  0582               L5321:
2948                     ; 401 		while (available_len > 0 && uart_rx_count < sizeof(uart_rx_buffer) - 1){
2950  0582 1e05          	ldw	x,(OFST-26,sp)
2951  0584 270a          	jreq	L1621
2953  0586 be1b          	ldw	x,L12_uart_rx_count
2954  0588 a30013        	cpw	x,#19
2955  058b 2403          	jruge	L041
2956  058d cc04f5        	jp	L1321
2957  0590               L041:
2958  0590               L1621:
2959                     ; 423         uart_state = UART_STATE_READY;
2961  0590 35010019      	mov	L31_uart_state,#1
2963  0594 2004          	jra	L3621
2964  0596               L7221:
2965                     ; 426         uart_state = UART_STATE_READY;
2967  0596 35010019      	mov	L31_uart_state,#1
2968  059a               L3621:
2969                     ; 428 }
2970  059a               L231:
2973  059a 5b1f          	addw	sp,#31
2974  059c 81            	ret
3018                     ; 430 void tcp_server_process(void){
3019                     	switch	.text
3020  059d               _tcp_server_process:
3022  059d 5203          	subw	sp,#3
3023       00000003      OFST:	set	3
3026                     ; 431 	uint16_t received_len = 0;
3028                     ; 432 	uint8_t sock_status = 0;
3030                     ; 434 	if(server_state ==  TCP_STATE_IDLE)return;
3032  059f 3d18          	tnz	L11_server_state
3033  05a1 2700          	jreq	L441
3036                     ; 436 }
3037  05a3               L441:
3040  05a3 5b03          	addw	sp,#3
3041  05a5 81            	ret
3082                     ; 438 void hal_uart_init(uint32_t baudrate)
3082                     ; 439 {
3083                     	switch	.text
3084  05a6               _hal_uart_init:
3086       00000000      OFST:	set	0
3089                     ; 441     CLK_PeripheralClockConfig(CLK_PERIPHERAL_UART1, ENABLE);
3091  05a6 ae0301        	ldw	x,#769
3092  05a9 cd0000        	call	_CLK_PeripheralClockConfig
3094                     ; 450     UART1_Init(
3094                     ; 451     baudrate,
3094                     ; 452     UART1_WORDLENGTH_8D,
3094                     ; 453     UART1_STOPBITS_1,
3094                     ; 454     UART1_PARITY_NO,
3094                     ; 455     UART1_SYNCMODE_CLOCK_DISABLE,
3094                     ; 456     (UART1_Mode_TypeDef)(UART1_MODE_TX_ENABLE | UART1_MODE_RX_ENABLE)
3094                     ; 457 );
3096  05ac 4b0c          	push	#12
3097  05ae 4b80          	push	#128
3098  05b0 4b00          	push	#0
3099  05b2 4b00          	push	#0
3100  05b4 4b00          	push	#0
3101  05b6 1e0a          	ldw	x,(OFST+10,sp)
3102  05b8 89            	pushw	x
3103  05b9 1e0a          	ldw	x,(OFST+10,sp)
3104  05bb 89            	pushw	x
3105  05bc cd0000        	call	_UART1_Init
3107  05bf 5b09          	addw	sp,#9
3108                     ; 459     UART1_ITConfig(UART1_IT_RXNE, ENABLE);
3110  05c1 4b01          	push	#1
3111  05c3 ae0255        	ldw	x,#597
3112  05c6 cd0000        	call	_UART1_ITConfig
3114  05c9 84            	pop	a
3115                     ; 462     UART1_Cmd(ENABLE);
3117  05ca a601          	ld	a,#1
3118  05cc cd0000        	call	_UART1_Cmd
3120                     ; 464     uart_rx_head = 0;
3122  05cf 5f            	clrw	x
3123  05d0 bf1d          	ldw	L32_uart_rx_head,x
3124                     ; 465     uart_rx_tail = 0;
3126  05d2 5f            	clrw	x
3127  05d3 bf1f          	ldw	L52_uart_rx_tail,x
3128                     ; 466     uart_rx_count = 0;   
3130  05d5 5f            	clrw	x
3131  05d6 bf1b          	ldw	L12_uart_rx_count,x
3132                     ; 467 }
3135  05d8 81            	ret
3172                     ; 469 void uart_server_init(uint32_t baudrate){
3173                     	switch	.text
3174  05d9               _uart_server_init:
3176       00000000      OFST:	set	0
3179                     ; 470 	uart_state = UART_STATE_IDLE;
3181  05d9 3f19          	clr	L31_uart_state
3182                     ; 471 	uart_rx_count = 0;
3184  05db 5f            	clrw	x
3185  05dc bf1b          	ldw	L12_uart_rx_count,x
3186                     ; 472 	hal_uart_init(baudrate);
3188  05de 1e05          	ldw	x,(OFST+5,sp)
3189  05e0 89            	pushw	x
3190  05e1 1e05          	ldw	x,(OFST+5,sp)
3191  05e3 89            	pushw	x
3192  05e4 adc0          	call	_hal_uart_init
3194  05e6 5b04          	addw	sp,#4
3195                     ; 473 	uart_state = UART_STATE_READY;
3197  05e8 35010019      	mov	L31_uart_state,#1
3198                     ; 474 }
3201  05ec 81            	ret
3229                     ; 476 void hal_timer_init(void){
3230                     	switch	.text
3231  05ed               _hal_timer_init:
3235                     ; 477     CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER4, ENABLE);
3237  05ed ae0401        	ldw	x,#1025
3238  05f0 cd0000        	call	_CLK_PeripheralClockConfig
3240                     ; 478     TIM4_TimeBaseInit(TIM4_PRESCALER_128, 125);
3242  05f3 ae077d        	ldw	x,#1917
3243  05f6 cd0000        	call	_TIM4_TimeBaseInit
3245                     ; 479     TIM4_ClearFlag(TIM4_FLAG_UPDATE);
3247  05f9 a601          	ld	a,#1
3248  05fb cd0000        	call	_TIM4_ClearFlag
3250                     ; 481     TIM4_ITConfig(TIM4_IT_UPDATE, ENABLE);
3252  05fe ae0101        	ldw	x,#257
3253  0601 cd0000        	call	_TIM4_ITConfig
3255                     ; 483     enableInterrupts();
3258  0604 9a            rim
3260                     ; 484 }
3264  0605 81            	ret
3298                     ; 486 void system_init(void){
3299                     	switch	.text
3300  0606               _system_init:
3304                     ; 488     CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);  /* 16MHz clock */
3306  0606 4f            	clr	a
3307  0607 cd0000        	call	_CLK_HSIPrescalerConfig
3309                     ; 491 	hal_gpio_init();
3311  060a cd0405        	call	_hal_gpio_init
3313                     ; 492     hal_timer_init();
3315  060d adde          	call	_hal_timer_init
3317                     ; 495 	relay_control_init();
3319  060f cd03f5        	call	_relay_control_init
3321                     ; 496 	sensor_reader_init();
3323  0612 cd0310        	call	_sensor_reader_init
3325                     ; 498     uart_server_init(UART_BAUDRATE);
3327  0615 aec200        	ldw	x,#49664
3328  0618 89            	pushw	x
3329  0619 ae0001        	ldw	x,#1
3330  061c 89            	pushw	x
3331  061d adba          	call	_uart_server_init
3333  061f 5b04          	addw	sp,#4
3334                     ; 501     hal_timer_set_callback(timer_callback);
3336  0621 ae0314        	ldw	x,#_timer_callback
3337  0624 cd035f        	call	_hal_timer_set_callback
3339                     ; 502     hal_timer_start();
3341  0627 cd0281        	call	_hal_timer_start
3343                     ; 503 	hal_delay_ms(500);
3345  062a ae01f4        	ldw	x,#500
3346  062d cd0007        	call	_hal_delay_ms
3348                     ; 504 }
3351  0630 81            	ret
3354                     	switch	.const
3355  0008               L5631_msg:
3356  0008 52455345542c  	dc.b	"RESET, OK",10,0
3396                     ; 507 void main_loop(void)
3396                     ; 508 {
3397                     	switch	.text
3398  0631               _main_loop:
3400  0631 520b          	subw	sp,#11
3401       0000000b      OFST:	set	11
3404  0633               L5041:
3405                     ; 512 		tcp_server_process();
3407  0633 cd059d        	call	_tcp_server_process
3409                     ; 515 		uart_server_process();
3411  0636 cd04d9        	call	_uart_server_process
3413                     ; 517         if(GPIO_ReadInputPin(HARDRST_PORT, HARDRST_PIN) == RESET)
3415  0639 4b80          	push	#128
3416  063b ae5005        	ldw	x,#20485
3417  063e cd0000        	call	_GPIO_ReadInputPin
3419  0641 5b01          	addw	sp,#1
3420  0643 4d            	tnz	a
3421  0644 26ed          	jrne	L5041
3422                     ; 519             hal_delay_ms(50);
3424  0646 ae0032        	ldw	x,#50
3425  0649 cd0007        	call	_hal_delay_ms
3427                     ; 520 			if (GPIO_ReadInputPin(HARDRST_PORT, HARDRST_PIN) == 0){
3429  064c 4b80          	push	#128
3430  064e ae5005        	ldw	x,#20485
3431  0651 cd0000        	call	_GPIO_ReadInputPin
3433  0654 5b01          	addw	sp,#1
3434  0656 4d            	tnz	a
3435  0657 26da          	jrne	L5041
3436                     ; 522 				char msg[] = "RESET, OK\n";
3438  0659 96            	ldw	x,sp
3439  065a 1c0001        	addw	x,#OFST-10
3440  065d 90ae0008      	ldw	y,#L5631_msg
3441  0661 a60b          	ld	a,#11
3442  0663 cd0000        	call	c_xymov
3444                     ; 523                 if (uart_server_is_ready()){
3446  0666 cd0034        	call	_uart_server_is_ready
3448  0669 a30000        	cpw	x,#0
3449  066c 2710          	jreq	L5141
3450                     ; 524                     uart_server_send((uint8_t *)msg, strlen(msg));
3452  066e 96            	ldw	x,sp
3453  066f 1c0001        	addw	x,#OFST-10
3454  0672 cd0000        	call	_strlen
3456  0675 89            	pushw	x
3457  0676 96            	ldw	x,sp
3458  0677 1c0003        	addw	x,#OFST-8
3459  067a cd0078        	call	_uart_server_send
3461  067d 85            	popw	x
3462  067e               L5141:
3463                     ; 526 				hal_delay_ms(100);
3465  067e ae0064        	ldw	x,#100
3466  0681 cd0007        	call	_hal_delay_ms
3468  0684 20ad          	jra	L5041
3493                     ; 535 int main(void)
3493                     ; 536 {
3494                     	switch	.text
3495  0686               _main:
3499                     ; 537 	system_init();
3501  0686 cd0606        	call	_system_init
3503                     ; 538     main_loop();
3505  0689 ada6          	call	_main_loop
3507  068b               L7241:
3508                     ; 540     while(1);
3510  068b 20fe          	jra	L7241
3800                     	xdef	_main
3801                     	xdef	_main_loop
3802                     	xdef	_system_init
3803                     	xdef	_hal_timer_init
3804                     	xdef	_uart_server_init
3805                     	xdef	_hal_uart_init
3806                     	xdef	_tcp_server_process
3807                     	xdef	_uart_server_process
3808                     	xdef	_hal_uart_read_byte
3809                     	xdef	_hal_uart_available
3810                     	xdef	_hal_gpio_init
3811                     	xdef	_hal_w5500_reset_high
3812                     	xdef	_relay_control_init
3813                     	xdef	_command_parser_execute
3814                     	xdef	_hal_timer_set_callback
3815                     	xdef	_timer_callback
3816                     	xdef	_sensor_reader_init
3817                     	xdef	_process_axle_counting
3818                     	xdef	_hal_timer_start
3819                     	xdef	_send_alive_message
3820                     	xdef	_sensor_reader_update
3821                     	xdef	_message_formatter_avcc
3822                     	xdef	_relay_control_set_all
3823                     	xdef	_relay_control_set
3824                     	xdef	_hal_relay_set
3825                     	xdef	_hal_di_read
3826                     	xdef	_message_formatter_alive
3827                     	xdef	_sensor_reader_get_state
3828                     	xdef	_uart_server_send
3829                     	xdef	_hal_uart_send
3830                     	xdef	_hal_uart_send_byte
3831                     	xdef	_uart_server_is_ready
3832                     	xdef	_hal_delay_ms
3833                     	xdef	_hal_get_millis
3834                     	switch	.ubsct
3835  0000               L72_uart_tx_buffer:
3836  0000 000000000000  	ds.b	20
3837  0014               L71_uart_rx_buffer:
3838  0014 000000000000  	ds.b	20
3839                     	xref	_sprintf
3840                     	xref	_atoi
3841                     	xref	_strlen
3842                     	xref	_strncpy
3843                     	xref	_strchr
3844                     	xref	_TIM4_ClearFlag
3845                     	xref	_TIM4_ITConfig
3846                     	xref	_TIM4_Cmd
3847                     	xref	_TIM4_TimeBaseInit
3848                     	xref	_UART1_GetFlagStatus
3849                     	xref	_UART1_SendData8
3850                     	xref	_UART1_ITConfig
3851                     	xref	_UART1_Cmd
3852                     	xref	_UART1_Init
3853                     	xref	_GPIO_ReadInputPin
3854                     	xref	_GPIO_WriteLow
3855                     	xref	_GPIO_WriteHigh
3856                     	xref	_GPIO_Init
3857                     	xref	_CLK_HSIPrescalerConfig
3858                     	xref	_CLK_PeripheralClockConfig
3859                     	switch	.const
3860  0013               L3521:
3861  0013 4552524f522c  	dc.b	"ERROR,INVALID_COMM"
3862  0025 414e440a00    	dc.b	"AND",10,0
3863  002a               L166:
3864  002a 53544152542c  	dc.b	"START,AVCC,%u,%lu,"
3865  003c 41584c452c25  	dc.b	"AXLE,%u,END",0
3866  0048               L523:
3867  0048 53544152542c  	dc.b	"START,ALIVE,%d%d%d"
3868  005a 25642c454e44  	dc.b	"%d,END",0
3869                     	xref.b	c_x
3889                     	xref	c_lgadc
3890                     	xref	c_xymov
3891                     	xref	c_lcmp
3892                     	xref	c_lsub
3893                     	xref	c_uitolx
3894                     	xref	c_rtol
3895                     	xref	c_ltor
3896                     	end
