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
  34  001a               L51_server_port:
  35  001a 1388          	dc.w	5000
  36  001c               L71_server_socket:
  37  001c 00            	dc.b	0
  38  001d               L12_uart_rx_count:
  39  001d 0000          	dc.w	0
  40  001f               L32_uart_rx_head:
  41  001f 0000          	dc.w	0
  42  0021               L52_uart_rx_tail:
  43  0021 0000          	dc.w	0
  44  0023               L33_systick_ms:
  45  0023 00000000      	dc.l	0
  46  0027               L53_user_callback:
  47  0027 0000          	dc.w	0
  77                     ; 72 unsigned long hal_get_millis(void)
  77                     ; 73 {
  79                     	switch	.text
  80  0000               _hal_get_millis:
  84                     ; 74     return systick_ms;
  86  0000 ae0023        	ldw	x,#L33_systick_ms
  87  0003 cd0000        	call	c_ltor
  91  0006 81            	ret
 116                     ; 76 int tcp_server_is_connected(void)
 116                     ; 77 {
 117                     	switch	.text
 118  0007               _tcp_server_is_connected:
 122                     ; 78     return (server_state == TCP_STATE_CONNECTED) ? 1 : 0;
 124  0007 b618          	ld	a,L11_server_state
 125  0009 a102          	cp	a,#2
 126  000b 2605          	jrne	L01
 127  000d ae0001        	ldw	x,#1
 128  0010 2001          	jra	L21
 129  0012               L01:
 130  0012 5f            	clrw	x
 131  0013               L21:
 134  0013 81            	ret
 178                     ; 80 void hal_delay_ms(unsigned int ms)
 178                     ; 81 {
 179                     	switch	.text
 180  0014               _hal_delay_ms:
 182  0014 89            	pushw	x
 183  0015 5208          	subw	sp,#8
 184       00000008      OFST:	set	8
 187                     ; 82     unsigned long start = hal_get_millis();
 189  0017 ade7          	call	_hal_get_millis
 191  0019 96            	ldw	x,sp
 192  001a 1c0005        	addw	x,#OFST-3
 193  001d cd0000        	call	c_rtol
 197  0020               L311:
 198                     ; 83     while ((hal_get_millis() - start) < ms);
 200  0020 adde          	call	_hal_get_millis
 202  0022 96            	ldw	x,sp
 203  0023 1c0005        	addw	x,#OFST-3
 204  0026 cd0000        	call	c_lsub
 206  0029 96            	ldw	x,sp
 207  002a 1c0001        	addw	x,#OFST-7
 208  002d cd0000        	call	c_rtol
 211  0030 1e09          	ldw	x,(OFST+1,sp)
 212  0032 cd0000        	call	c_uitolx
 214  0035 96            	ldw	x,sp
 215  0036 1c0001        	addw	x,#OFST-7
 216  0039 cd0000        	call	c_lcmp
 218  003c 22e2          	jrugt	L311
 219                     ; 84 }
 222  003e 5b0a          	addw	sp,#10
 223  0040 81            	ret
 248                     ; 86 int uart_server_is_ready(void){
 249                     	switch	.text
 250  0041               _uart_server_is_ready:
 254                     ; 87     return (uart_state != UART_STATE_IDLE) ? 1 : 0;
 256  0041 3d19          	tnz	L31_uart_state
 257  0043 2705          	jreq	L02
 258  0045 ae0001        	ldw	x,#1
 259  0048 2001          	jra	L22
 260  004a               L02:
 261  004a 5f            	clrw	x
 262  004b               L22:
 265  004b 81            	ret
 301                     ; 90 void hal_uart_send_byte(uint8_t byte){
 302                     	switch	.text
 303  004c               _hal_uart_send_byte:
 305  004c 88            	push	a
 306       00000000      OFST:	set	0
 309  004d               L741:
 310                     ; 91     while (UART1_GetFlagStatus(UART1_FLAG_TXE) == RESET);
 312  004d ae0080        	ldw	x,#128
 313  0050 cd0000        	call	_UART1_GetFlagStatus
 315  0053 4d            	tnz	a
 316  0054 27f7          	jreq	L741
 317                     ; 94     UART1_SendData8(byte);
 319  0056 7b01          	ld	a,(OFST+1,sp)
 320  0058 cd0000        	call	_UART1_SendData8
 323  005b               L551:
 324                     ; 97     while (UART1_GetFlagStatus(UART1_FLAG_TC) == RESET);
 326  005b ae0040        	ldw	x,#64
 327  005e cd0000        	call	_UART1_GetFlagStatus
 329  0061 4d            	tnz	a
 330  0062 27f7          	jreq	L551
 331                     ; 98 }
 334  0064 84            	pop	a
 335  0065 81            	ret
 389                     ; 100 void hal_uart_send(const uint8_t *data, uint16_t len){
 390                     	switch	.text
 391  0066               _hal_uart_send:
 393  0066 89            	pushw	x
 394  0067 89            	pushw	x
 395       00000002      OFST:	set	2
 398                     ; 102     for(i = 0; i < len; i++){
 400  0068 5f            	clrw	x
 401  0069 1f01          	ldw	(OFST-1,sp),x
 404  006b 200f          	jra	L312
 405  006d               L702:
 406                     ; 103         hal_uart_send_byte(data[i]);
 408  006d 1e03          	ldw	x,(OFST+1,sp)
 409  006f 72fb01        	addw	x,(OFST-1,sp)
 410  0072 f6            	ld	a,(x)
 411  0073 add7          	call	_hal_uart_send_byte
 413                     ; 102     for(i = 0; i < len; i++){
 415  0075 1e01          	ldw	x,(OFST-1,sp)
 416  0077 1c0001        	addw	x,#1
 417  007a 1f01          	ldw	(OFST-1,sp),x
 419  007c               L312:
 422  007c 1e01          	ldw	x,(OFST-1,sp)
 423  007e 1307          	cpw	x,(OFST+5,sp)
 424  0080 25eb          	jrult	L702
 425                     ; 105 }
 428  0082 5b04          	addw	sp,#4
 429  0084 81            	ret
 453                     ; 106 void hal_spi_cs_low(void)
 453                     ; 107 {
 454                     	switch	.text
 455  0085               _hal_spi_cs_low:
 459                     ; 108     GPIO_WriteLow(W5500_CS_PORT, W5500_CS_PIN);
 461  0085 4b08          	push	#8
 462  0087 ae5000        	ldw	x,#20480
 463  008a cd0000        	call	_GPIO_WriteLow
 465  008d 84            	pop	a
 466                     ; 109 }
 469  008e 81            	ret
 493                     ; 111 void hal_spi_cs_high(void)
 493                     ; 112 {
 494                     	switch	.text
 495  008f               _hal_spi_cs_high:
 499                     ; 113     GPIO_WriteHigh(W5500_CS_PORT, W5500_CS_PIN);
 501  008f 4b08          	push	#8
 502  0091 ae5000        	ldw	x,#20480
 503  0094 cd0000        	call	_GPIO_WriteHigh
 505  0097 84            	pop	a
 506                     ; 114 }
 509  0098 81            	ret
 570                     ; 124 sensor_state_t sensor_reader_get_state(void)
 570                     ; 125 {
 571                     	switch	.text
 572  0099               _sensor_reader_get_state:
 574       00000000      OFST:	set	0
 577                     ; 126     return current_state;
 579  0099 1e03          	ldw	x,(OFST+3,sp)
 580  009b 90ae0014      	ldw	y,#L7_current_state
 581  009f a604          	ld	a,#4
 582  00a1 cd0000        	call	c_xymov
 586  00a4 81            	ret
 778                     ; 152 uint8_t hal_di_read(uint8_t di_num)
 778                     ; 153 {
 779                     	switch	.text
 780  00a5               _hal_di_read:
 782  00a5 5203          	subw	sp,#3
 783       00000003      OFST:	set	3
 786                     ; 157     switch (di_num) {
 789                     ; 162         default: return 0;
 790  00a7 4a            	dec	a
 791  00a8 270c          	jreq	L362
 792  00aa 4a            	dec	a
 793  00ab 2714          	jreq	L562
 794  00ad 4a            	dec	a
 795  00ae 271c          	jreq	L762
 796  00b0 4a            	dec	a
 797  00b1 2724          	jreq	L172
 798  00b3               L372:
 801  00b3 4f            	clr	a
 803  00b4 203d          	jra	L44
 804  00b6               L362:
 805                     ; 158         case 1: port = DI1_PORT; pin = DI1_PIN; break;
 807  00b6 ae500f        	ldw	x,#20495
 808  00b9 1f01          	ldw	(OFST-2,sp),x
 812  00bb a604          	ld	a,#4
 813  00bd 6b03          	ld	(OFST+0,sp),a
 817  00bf 201f          	jra	L114
 818  00c1               L562:
 819                     ; 159         case 2: port = DI2_PORT; pin = DI2_PIN; break;
 821  00c1 ae500f        	ldw	x,#20495
 822  00c4 1f01          	ldw	(OFST-2,sp),x
 826  00c6 a608          	ld	a,#8
 827  00c8 6b03          	ld	(OFST+0,sp),a
 831  00ca 2014          	jra	L114
 832  00cc               L762:
 833                     ; 160         case 3: port = DI3_PORT; pin = DI3_PIN; break;
 835  00cc ae500f        	ldw	x,#20495
 836  00cf 1f01          	ldw	(OFST-2,sp),x
 840  00d1 a610          	ld	a,#16
 841  00d3 6b03          	ld	(OFST+0,sp),a
 845  00d5 2009          	jra	L114
 846  00d7               L172:
 847                     ; 161         case 4: port = DI4_PORT; pin = DI4_PIN; break;
 849  00d7 ae500f        	ldw	x,#20495
 850  00da 1f01          	ldw	(OFST-2,sp),x
 854  00dc a680          	ld	a,#128
 855  00de 6b03          	ld	(OFST+0,sp),a
 859  00e0               L114:
 860                     ; 164     return (GPIO_ReadInputPin(port, pin) == SET) ? 1 : 0;
 862  00e0 7b03          	ld	a,(OFST+0,sp)
 863  00e2 88            	push	a
 864  00e3 1e02          	ldw	x,(OFST-1,sp)
 865  00e5 cd0000        	call	_GPIO_ReadInputPin
 867  00e8 5b01          	addw	sp,#1
 868  00ea a101          	cp	a,#1
 869  00ec 2604          	jrne	L04
 870  00ee a601          	ld	a,#1
 871  00f0 2001          	jra	L24
 872  00f2               L04:
 873  00f2 4f            	clr	a
 874  00f3               L24:
 876  00f3               L44:
 878  00f3 5b03          	addw	sp,#3
 879  00f5 81            	ret
 976                     ; 169 void hal_relay_set(uint8_t relay_num, uint8_t state){
 977                     	switch	.text
 978  00f6               _hal_relay_set:
 980  00f6 89            	pushw	x
 981  00f7 5204          	subw	sp,#4
 982       00000004      OFST:	set	4
 985                     ; 172 	BitStatus bit_state = (state == 0) ? SET : RESET;
 987  00f9 9f            	ld	a,xl
 988  00fa 4d            	tnz	a
 989  00fb 2605          	jrne	L05
 990  00fd ae0001        	ldw	x,#1
 991  0100 2001          	jra	L25
 992  0102               L05:
 993  0102 5f            	clrw	x
 994  0103               L25:
 995  0103 01            	rrwa	x,a
 996  0104 6b01          	ld	(OFST-3,sp),a
 997  0106 02            	rlwa	x,a
 999                     ; 174 	switch (relay_num) {
1001  0107 7b05          	ld	a,(OFST+1,sp)
1003                     ; 181         default: return;
1004  0109 4a            	dec	a
1005  010a 2711          	jreq	L314
1006  010c 4a            	dec	a
1007  010d 2719          	jreq	L514
1008  010f 4a            	dec	a
1009  0110 2721          	jreq	L714
1010  0112 4a            	dec	a
1011  0113 2729          	jreq	L124
1012  0115 4a            	dec	a
1013  0116 2731          	jreq	L324
1014  0118 4a            	dec	a
1015  0119 2739          	jreq	L524
1016  011b               L724:
1019  011b 205a          	jra	L45
1020  011d               L314:
1021                     ; 175         case 1: port = RELAY1_PORT; pin = RELAY1_PIN; break;
1023  011d ae5005        	ldw	x,#20485
1024  0120 1f02          	ldw	(OFST-2,sp),x
1028  0122 a608          	ld	a,#8
1029  0124 6b04          	ld	(OFST+0,sp),a
1033  0126 2035          	jra	L305
1034  0128               L514:
1035                     ; 176         case 2: port = RELAY2_PORT; pin = RELAY2_PIN; break;
1037  0128 ae5005        	ldw	x,#20485
1038  012b 1f02          	ldw	(OFST-2,sp),x
1042  012d a604          	ld	a,#4
1043  012f 6b04          	ld	(OFST+0,sp),a
1047  0131 202a          	jra	L305
1048  0133               L714:
1049                     ; 177         case 3: port = RELAY3_PORT; pin = RELAY3_PIN; break;
1051  0133 ae5005        	ldw	x,#20485
1052  0136 1f02          	ldw	(OFST-2,sp),x
1056  0138 a602          	ld	a,#2
1057  013a 6b04          	ld	(OFST+0,sp),a
1061  013c 201f          	jra	L305
1062  013e               L124:
1063                     ; 178         case 4: port = RELAY4_PORT; pin = RELAY4_PIN; break;
1065  013e ae5005        	ldw	x,#20485
1066  0141 1f02          	ldw	(OFST-2,sp),x
1070  0143 a601          	ld	a,#1
1071  0145 6b04          	ld	(OFST+0,sp),a
1075  0147 2014          	jra	L305
1076  0149               L324:
1077                     ; 179         case 5: port = RELAY5_PORT; pin = RELAY5_PIN; break;
1079  0149 ae500a        	ldw	x,#20490
1080  014c 1f02          	ldw	(OFST-2,sp),x
1084  014e a608          	ld	a,#8
1085  0150 6b04          	ld	(OFST+0,sp),a
1089  0152 2009          	jra	L305
1090  0154               L524:
1091                     ; 180         case 6: port = RELAY6_PORT; pin = RELAY6_PIN; break;
1093  0154 ae500a        	ldw	x,#20490
1094  0157 1f02          	ldw	(OFST-2,sp),x
1098  0159 a610          	ld	a,#16
1099  015b 6b04          	ld	(OFST+0,sp),a
1103  015d               L305:
1104                     ; 184 	if (bit_state == SET) {
1106  015d 7b01          	ld	a,(OFST-3,sp)
1107  015f a101          	cp	a,#1
1108  0161 260b          	jrne	L505
1109                     ; 185         GPIO_WriteHigh(port, pin);  /* Set HIGH = relay off */
1111  0163 7b04          	ld	a,(OFST+0,sp)
1112  0165 88            	push	a
1113  0166 1e03          	ldw	x,(OFST-1,sp)
1114  0168 cd0000        	call	_GPIO_WriteHigh
1116  016b 84            	pop	a
1118  016c 2009          	jra	L705
1119  016e               L505:
1120                     ; 187         GPIO_WriteLow(port, pin); /* Set LOW = relay on */
1122  016e 7b04          	ld	a,(OFST+0,sp)
1123  0170 88            	push	a
1124  0171 1e03          	ldw	x,(OFST-1,sp)
1125  0173 cd0000        	call	_GPIO_WriteLow
1127  0176 84            	pop	a
1128  0177               L705:
1129                     ; 189 }
1130  0177               L45:
1133  0177 5b06          	addw	sp,#6
1134  0179 81            	ret
1178                     ; 191 void relay_control_set(uint8_t relay_num, uint8_t state)
1178                     ; 192 {
1179                     	switch	.text
1180  017a               _relay_control_set:
1182  017a 89            	pushw	x
1183       00000000      OFST:	set	0
1186                     ; 193     if (relay_num >= 1 && relay_num <= 6) {
1188  017b 9e            	ld	a,xh
1189  017c 4d            	tnz	a
1190  017d 270d          	jreq	L335
1192  017f 9e            	ld	a,xh
1193  0180 a107          	cp	a,#7
1194  0182 2408          	jruge	L335
1195                     ; 194         hal_relay_set(relay_num, state);
1197  0184 9f            	ld	a,xl
1198  0185 97            	ld	xl,a
1199  0186 7b01          	ld	a,(OFST+1,sp)
1200  0188 95            	ld	xh,a
1201  0189 cd00f6        	call	_hal_relay_set
1203  018c               L335:
1204                     ; 196 }
1207  018c 85            	popw	x
1208  018d 81            	ret
1244                     ; 198 void relay_control_set_all(uint8_t state)
1244                     ; 199 {
1245                     	switch	.text
1246  018e               _relay_control_set_all:
1248  018e 88            	push	a
1249       00000000      OFST:	set	0
1252                     ; 200     relay_control_set(1, state);
1254  018f ae0100        	ldw	x,#256
1255  0192 97            	ld	xl,a
1256  0193 ade5          	call	_relay_control_set
1258                     ; 201     relay_control_set(2, state);
1260  0195 7b01          	ld	a,(OFST+1,sp)
1261  0197 ae0200        	ldw	x,#512
1262  019a 97            	ld	xl,a
1263  019b addd          	call	_relay_control_set
1265                     ; 202     relay_control_set(3, state);
1267  019d 7b01          	ld	a,(OFST+1,sp)
1268  019f ae0300        	ldw	x,#768
1269  01a2 97            	ld	xl,a
1270  01a3 add5          	call	_relay_control_set
1272                     ; 203     relay_control_set(4, state);
1274  01a5 7b01          	ld	a,(OFST+1,sp)
1275  01a7 ae0400        	ldw	x,#1024
1276  01aa 97            	ld	xl,a
1277  01ab adcd          	call	_relay_control_set
1279                     ; 204     relay_control_set(5, state);
1281  01ad 7b01          	ld	a,(OFST+1,sp)
1282  01af ae0500        	ldw	x,#1280
1283  01b2 97            	ld	xl,a
1284  01b3 adc5          	call	_relay_control_set
1286                     ; 205     relay_control_set(6, state);
1288  01b5 7b01          	ld	a,(OFST+1,sp)
1289  01b7 ae0600        	ldw	x,#1536
1290  01ba 97            	ld	xl,a
1291  01bb adbd          	call	_relay_control_set
1293                     ; 206 }
1296  01bd 84            	pop	a
1297  01be 81            	ret
1342                     ; 208 void message_formatter_avcc(char *buf, int buf_size, uint16_t lanid, uint32_t seqn, uint16_t axle_count)
1342                     ; 209 {
1343                     	switch	.text
1344  01bf               _message_formatter_avcc:
1346  01bf 89            	pushw	x
1347       00000000      OFST:	set	0
1350                     ; 210     if(buf == 0) return;
1352  01c0 a30000        	cpw	x,#0
1353  01c3 2708          	jreq	L46
1356                     ; 211     if(buf_size < 32) return;
1358  01c5 9c            	rvf
1359  01c6 1e05          	ldw	x,(OFST+5,sp)
1360  01c8 a30020        	cpw	x,#32
1361  01cb 2e02          	jrsge	L775
1363  01cd               L46:
1366  01cd 85            	popw	x
1367  01ce 81            	ret
1368  01cf               L775:
1369                     ; 214 }
1371  01cf 20fc          	jra	L46
1395                     ; 236 void hal_timer_start(void)
1395                     ; 237 {
1396                     	switch	.text
1397  01d1               _hal_timer_start:
1401                     ; 238     TIM4_Cmd(ENABLE);
1403  01d1 a601          	ld	a,#1
1404  01d3 cd0000        	call	_TIM4_Cmd
1406                     ; 239 }
1409  01d6 81            	ret
1432                     ; 280 void sensor_reader_init(void)
1432                     ; 281 {
1433                     	switch	.text
1434  01d7               _sensor_reader_init:
1438                     ; 284 }
1441  01d7 81            	ret
1466                     .const:	section	.text
1467  0000               L47:
1468  0000 00000032      	dc.l	50
1469  0004               L67:
1470  0004 000001f4      	dc.l	500
1471                     ; 285 void timer_callback(void){
1472                     	switch	.text
1473  01d8               _timer_callback:
1477                     ; 286     task_timer.current_time = hal_get_millis();
1479  01d8 cd0000        	call	_hal_get_millis
1481  01db ae0010        	ldw	x,#L5_task_timer+8
1482  01de cd0000        	call	c_rtol
1484                     ; 288     if ((task_timer.current_time - task_timer.last_sensor_time) >= SENSOR_READ_INTERVAL){
1486  01e1 ae0010        	ldw	x,#L5_task_timer+8
1487  01e4 cd0000        	call	c_ltor
1489  01e7 ae000c        	ldw	x,#L5_task_timer+4
1490  01ea cd0000        	call	c_lsub
1492  01ed ae0000        	ldw	x,#L47
1493  01f0 cd0000        	call	c_lcmp
1495  01f3 2508          	jrult	L136
1496                     ; 291         task_timer.last_sensor_time = task_timer.current_time;
1498  01f5 be12          	ldw	x,L5_task_timer+10
1499  01f7 bf0e          	ldw	L5_task_timer+6,x
1500  01f9 be10          	ldw	x,L5_task_timer+8
1501  01fb bf0c          	ldw	L5_task_timer+4,x
1502  01fd               L136:
1503                     ; 295     if ((task_timer.current_time - task_timer.last_alive_time) >= ALIVE_INTERVAL){
1505  01fd ae0010        	ldw	x,#L5_task_timer+8
1506  0200 cd0000        	call	c_ltor
1508  0203 ae0008        	ldw	x,#L5_task_timer
1509  0206 cd0000        	call	c_lsub
1511  0209 ae0004        	ldw	x,#L67
1512  020c cd0000        	call	c_lcmp
1514  020f 2508          	jrult	L336
1515                     ; 297         task_timer.last_alive_time = task_timer.current_time;
1517  0211 be12          	ldw	x,L5_task_timer+10
1518  0213 bf0a          	ldw	L5_task_timer+2,x
1519  0215 be10          	ldw	x,L5_task_timer+8
1520  0217 bf08          	ldw	L5_task_timer,x
1521  0219               L336:
1522                     ; 299 }
1525  0219 81            	ret
1563                     ; 301 void hal_timer_set_callback(timer_callback_t callback)
1563                     ; 302 {
1564                     	switch	.text
1565  021a               _hal_timer_set_callback:
1569                     ; 303     user_callback = callback;
1571  021a bf27          	ldw	L53_user_callback,x
1572                     ; 304 }
1575  021c 81            	ret
1639                     ; 306 int command_parser_execute(const char *cmd_str, int len)
1639                     ; 307 {
1640                     	switch	.text
1641  021d               _command_parser_execute:
1643  021d 89            	pushw	x
1644  021e 89            	pushw	x
1645       00000002      OFST:	set	2
1648                     ; 312     if (len < 4)
1650  021f 9c            	rvf
1651  0220 1e07          	ldw	x,(OFST+5,sp)
1652  0222 a30004        	cpw	x,#4
1653  0225 2e05          	jrsge	L507
1654                     ; 313         return -1;
1656  0227 aeffff        	ldw	x,#65535
1658  022a 200a          	jra	L401
1659  022c               L507:
1660                     ; 315     if (cmd_str[0] != 'R')
1662  022c 1e03          	ldw	x,(OFST+1,sp)
1663  022e f6            	ld	a,(x)
1664  022f a152          	cp	a,#82
1665  0231 2706          	jreq	L707
1666                     ; 316         return -1;
1668  0233 aeffff        	ldw	x,#65535
1670  0236               L401:
1672  0236 5b04          	addw	sp,#4
1673  0238 81            	ret
1674  0239               L707:
1675                     ; 318     if (cmd_str[1] < '1' || cmd_str[1] > '6')
1677  0239 1e03          	ldw	x,(OFST+1,sp)
1678  023b e601          	ld	a,(1,x)
1679  023d a131          	cp	a,#49
1680  023f 2508          	jrult	L317
1682  0241 1e03          	ldw	x,(OFST+1,sp)
1683  0243 e601          	ld	a,(1,x)
1684  0245 a137          	cp	a,#55
1685  0247 2505          	jrult	L117
1686  0249               L317:
1687                     ; 319         return -1;
1689  0249 aeffff        	ldw	x,#65535
1691  024c 20e8          	jra	L401
1692  024e               L117:
1693                     ; 321     if (cmd_str[2] != ',')
1695  024e 1e03          	ldw	x,(OFST+1,sp)
1696  0250 e602          	ld	a,(2,x)
1697  0252 a12c          	cp	a,#44
1698  0254 2705          	jreq	L517
1699                     ; 322         return -1;
1701  0256 aeffff        	ldw	x,#65535
1703  0259 20db          	jra	L401
1704  025b               L517:
1705                     ; 324     if (cmd_str[3] != '0' && cmd_str[3] != '1')
1707  025b 1e03          	ldw	x,(OFST+1,sp)
1708  025d e603          	ld	a,(3,x)
1709  025f a130          	cp	a,#48
1710  0261 270d          	jreq	L717
1712  0263 1e03          	ldw	x,(OFST+1,sp)
1713  0265 e603          	ld	a,(3,x)
1714  0267 a131          	cp	a,#49
1715  0269 2705          	jreq	L717
1716                     ; 325         return -1;
1718  026b aeffff        	ldw	x,#65535
1720  026e 20c6          	jra	L401
1721  0270               L717:
1722                     ; 327     relay_num = cmd_str[1] - '0';
1724  0270 1e03          	ldw	x,(OFST+1,sp)
1725  0272 e601          	ld	a,(1,x)
1726  0274 a030          	sub	a,#48
1727  0276 6b01          	ld	(OFST-1,sp),a
1729                     ; 328     relay_state = cmd_str[3] - '0';
1731  0278 1e03          	ldw	x,(OFST+1,sp)
1732  027a e603          	ld	a,(3,x)
1733  027c a030          	sub	a,#48
1734  027e 6b02          	ld	(OFST+0,sp),a
1736                     ; 330     relay_control_set(relay_num, relay_state);
1738  0280 7b02          	ld	a,(OFST+0,sp)
1739  0282 97            	ld	xl,a
1740  0283 7b01          	ld	a,(OFST-1,sp)
1741  0285 95            	ld	xh,a
1742  0286 cd017a        	call	_relay_control_set
1744                     ; 332     return 0;
1746  0289 5f            	clrw	x
1748  028a 20aa          	jra	L401
1772                     ; 335 void relay_control_init(void)
1772                     ; 336 {
1773                     	switch	.text
1774  028c               _relay_control_init:
1778                     ; 337     relay_control_set_all(1);  /* 1 = on for active-low relays */
1780  028c a601          	ld	a,#1
1781  028e cd018e        	call	_relay_control_set_all
1783                     ; 338 }
1786  0291 81            	ret
1811                     ; 340 void hal_w5500_reset_high(void)
1811                     ; 341 {
1812                     	switch	.text
1813  0292               _hal_w5500_reset_high:
1817                     ; 342     GPIO_WriteHigh(W5500_RST_PORT, W5500_RST_PIN);
1819  0292 4b20          	push	#32
1820  0294 ae5014        	ldw	x,#20500
1821  0297 cd0000        	call	_GPIO_WriteHigh
1823  029a 84            	pop	a
1824                     ; 343 }
1827  029b 81            	ret
1853                     ; 345 void hal_gpio_init(void){
1854                     	switch	.text
1855  029c               _hal_gpio_init:
1859                     ; 347     GPIO_Init(DI1_PORT, DI1_PIN, GPIO_MODE_IN_PU_NO_IT);
1861  029c 4b40          	push	#64
1862  029e 4b04          	push	#4
1863  02a0 ae500f        	ldw	x,#20495
1864  02a3 cd0000        	call	_GPIO_Init
1866  02a6 85            	popw	x
1867                     ; 348     GPIO_Init(DI2_PORT, DI2_PIN, GPIO_MODE_IN_PU_NO_IT);
1869  02a7 4b40          	push	#64
1870  02a9 4b08          	push	#8
1871  02ab ae500f        	ldw	x,#20495
1872  02ae cd0000        	call	_GPIO_Init
1874  02b1 85            	popw	x
1875                     ; 349     GPIO_Init(DI3_PORT, DI3_PIN, GPIO_MODE_IN_PU_NO_IT);
1877  02b2 4b40          	push	#64
1878  02b4 4b10          	push	#16
1879  02b6 ae500f        	ldw	x,#20495
1880  02b9 cd0000        	call	_GPIO_Init
1882  02bc 85            	popw	x
1883                     ; 350     GPIO_Init(DI4_PORT, DI4_PIN, GPIO_MODE_IN_PU_NO_IT);
1885  02bd 4b40          	push	#64
1886  02bf 4b80          	push	#128
1887  02c1 ae500f        	ldw	x,#20495
1888  02c4 cd0000        	call	_GPIO_Init
1890  02c7 85            	popw	x
1891                     ; 353     GPIO_Init(RELAY1_PORT, RELAY1_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
1893  02c8 4bf0          	push	#240
1894  02ca 4b08          	push	#8
1895  02cc ae5005        	ldw	x,#20485
1896  02cf cd0000        	call	_GPIO_Init
1898  02d2 85            	popw	x
1899                     ; 354     GPIO_Init(RELAY2_PORT, RELAY2_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
1901  02d3 4bf0          	push	#240
1902  02d5 4b04          	push	#4
1903  02d7 ae5005        	ldw	x,#20485
1904  02da cd0000        	call	_GPIO_Init
1906  02dd 85            	popw	x
1907                     ; 355     GPIO_Init(RELAY3_PORT, RELAY3_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
1909  02de 4bf0          	push	#240
1910  02e0 4b02          	push	#2
1911  02e2 ae5005        	ldw	x,#20485
1912  02e5 cd0000        	call	_GPIO_Init
1914  02e8 85            	popw	x
1915                     ; 356     GPIO_Init(RELAY4_PORT, RELAY4_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
1917  02e9 4bf0          	push	#240
1918  02eb 4b01          	push	#1
1919  02ed ae5005        	ldw	x,#20485
1920  02f0 cd0000        	call	_GPIO_Init
1922  02f3 85            	popw	x
1923                     ; 357     GPIO_Init(RELAY5_PORT, RELAY5_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
1925  02f4 4bf0          	push	#240
1926  02f6 4b08          	push	#8
1927  02f8 ae500a        	ldw	x,#20490
1928  02fb cd0000        	call	_GPIO_Init
1930  02fe 85            	popw	x
1931                     ; 358     GPIO_Init(RELAY6_PORT, RELAY6_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
1933  02ff 4bf0          	push	#240
1934  0301 4b10          	push	#16
1935  0303 ae500a        	ldw	x,#20490
1936  0306 cd0000        	call	_GPIO_Init
1938  0309 85            	popw	x
1939                     ; 361     hal_relay_set(1, 1);
1941  030a ae0101        	ldw	x,#257
1942  030d cd00f6        	call	_hal_relay_set
1944                     ; 362     hal_relay_set(2, 1);
1946  0310 ae0201        	ldw	x,#513
1947  0313 cd00f6        	call	_hal_relay_set
1949                     ; 363     hal_relay_set(3, 1);
1951  0316 ae0301        	ldw	x,#769
1952  0319 cd00f6        	call	_hal_relay_set
1954                     ; 364     hal_relay_set(4, 1);
1956  031c ae0401        	ldw	x,#1025
1957  031f cd00f6        	call	_hal_relay_set
1959                     ; 365     hal_relay_set(5, 1);
1961  0322 ae0501        	ldw	x,#1281
1962  0325 cd00f6        	call	_hal_relay_set
1964                     ; 366     hal_relay_set(6, 1);
1966  0328 ae0601        	ldw	x,#1537
1967  032b cd00f6        	call	_hal_relay_set
1969                     ; 369     GPIO_Init(HARDRST_PORT, HARDRST_PIN, GPIO_MODE_IN_PU_NO_IT);
1971  032e 4b40          	push	#64
1972  0330 4b80          	push	#128
1973  0332 ae5005        	ldw	x,#20485
1974  0335 cd0000        	call	_GPIO_Init
1976  0338 85            	popw	x
1977                     ; 372     GPIO_Init(W5500_RST_PORT, W5500_RST_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
1979  0339 4bf0          	push	#240
1980  033b 4b20          	push	#32
1981  033d ae5014        	ldw	x,#20500
1982  0340 cd0000        	call	_GPIO_Init
1984  0343 85            	popw	x
1985                     ; 373 	  hal_w5500_reset_high();
1987  0344 cd0292        	call	_hal_w5500_reset_high
1989                     ; 374 }
1992  0347 81            	ret
2016                     ; 376 uint16_t hal_uart_available(void){
2017                     	switch	.text
2018  0348               _hal_uart_available:
2022                     ; 377 	return uart_rx_count;
2024  0348 be1d          	ldw	x,L12_uart_rx_count
2027  034a 81            	ret
2066                     ; 380 uint8_t hal_uart_read_byte(void){
2067                     	switch	.text
2068  034b               _hal_uart_read_byte:
2070  034b 88            	push	a
2071       00000001      OFST:	set	1
2074                     ; 381 	uint8_t byte = 0;
2076  034c 0f01          	clr	(OFST+0,sp)
2078                     ; 382 	if (uart_rx_count > 0){
2080  034e be1d          	ldw	x,L12_uart_rx_count
2081  0350 2719          	jreq	L777
2082                     ; 383 		disableInterrupts();
2085  0352 9b            sim
2087                     ; 385 		byte = uart_rx_buffer[uart_rx_tail];
2090  0353 be21          	ldw	x,L52_uart_rx_tail
2091  0355 e600          	ld	a,(L13_uart_rx_buffer,x)
2092  0357 6b01          	ld	(OFST+0,sp),a
2094                     ; 386 		uart_rx_tail = (uart_rx_tail + 1) % UART_RX_BUFFER_SIZE;
2096  0359 be21          	ldw	x,L52_uart_rx_tail
2097  035b 5c            	incw	x
2098  035c a60a          	ld	a,#10
2099  035e 62            	div	x,a
2100  035f 5f            	clrw	x
2101  0360 97            	ld	xl,a
2102  0361 bf21          	ldw	L52_uart_rx_tail,x
2103                     ; 387 		uart_rx_count--;
2105  0363 be1d          	ldw	x,L12_uart_rx_count
2106  0365 1d0001        	subw	x,#1
2107  0368 bf1d          	ldw	L12_uart_rx_count,x
2108                     ; 388 		enableInterrupts();
2111  036a 9a            rim
2114  036b               L777:
2115                     ; 390 	return byte;
2117  036b 7b01          	ld	a,(OFST+0,sp)
2120  036d 5b01          	addw	sp,#1
2121  036f 81            	ret
2158                     ; 435 uint8_t hal_spi_byte(uint8_t data)
2158                     ; 436 {
2159                     	switch	.text
2160  0370               _hal_spi_byte:
2162  0370 88            	push	a
2163       00000000      OFST:	set	0
2166  0371               L1201:
2167                     ; 437     while (SPI_GetFlagStatus(SPI_FLAG_TXE) == RESET);
2169  0371 a602          	ld	a,#2
2170  0373 cd0000        	call	_SPI_GetFlagStatus
2172  0376 4d            	tnz	a
2173  0377 27f8          	jreq	L1201
2174                     ; 439     SPI_SendData(data);
2176  0379 7b01          	ld	a,(OFST+1,sp)
2177  037b cd0000        	call	_SPI_SendData
2180  037e               L7201:
2181                     ; 441     while (SPI_GetFlagStatus(SPI_FLAG_RXNE) == RESET);
2183  037e a601          	ld	a,#1
2184  0380 cd0000        	call	_SPI_GetFlagStatus
2186  0383 4d            	tnz	a
2187  0384 27f8          	jreq	L7201
2188                     ; 443     return SPI_ReceiveData();
2190  0386 cd0000        	call	_SPI_ReceiveData
2194  0389 5b01          	addw	sp,#1
2195  038b 81            	ret
2219                     ; 445 uint8_t hal_spi_read_byte(void)
2219                     ; 446 {
2220                     	switch	.text
2221  038c               _hal_spi_read_byte:
2225                     ; 447     return hal_spi_byte(0xFF);
2227  038c a6ff          	ld	a,#255
2228  038e ade0          	call	_hal_spi_byte
2232  0390 81            	ret
2267                     ; 449 void hal_spi_write_byte(uint8_t data)
2267                     ; 450 {
2268                     	switch	.text
2269  0391               _hal_spi_write_byte:
2273                     ; 451     hal_spi_byte(data);
2275  0391 addd          	call	_hal_spi_byte
2277                     ; 452 }
2280  0393 81            	ret
2334                     ; 453 void hal_spi_read(uint8_t *buf, uint16_t len){
2335                     	switch	.text
2336  0394               _hal_spi_read:
2338  0394 89            	pushw	x
2339  0395 89            	pushw	x
2340       00000002      OFST:	set	2
2343                     ; 455     for(i = 0; i < len; i++){
2345  0396 5f            	clrw	x
2346  0397 1f01          	ldw	(OFST-1,sp),x
2349  0399 2011          	jra	L3111
2350  039b               L7011:
2351                     ; 456         buf[i] = hal_spi_byte(0xFF);
2353  039b a6ff          	ld	a,#255
2354  039d add1          	call	_hal_spi_byte
2356  039f 1e03          	ldw	x,(OFST+1,sp)
2357  03a1 72fb01        	addw	x,(OFST-1,sp)
2358  03a4 f7            	ld	(x),a
2359                     ; 455     for(i = 0; i < len; i++){
2361  03a5 1e01          	ldw	x,(OFST-1,sp)
2362  03a7 1c0001        	addw	x,#1
2363  03aa 1f01          	ldw	(OFST-1,sp),x
2365  03ac               L3111:
2368  03ac 1e01          	ldw	x,(OFST-1,sp)
2369  03ae 1307          	cpw	x,(OFST+5,sp)
2370  03b0 25e9          	jrult	L7011
2371                     ; 458 }
2374  03b2 5b04          	addw	sp,#4
2375  03b4 81            	ret
2429                     ; 460 void hal_spi_write(uint8_t *buf, uint16_t len){
2430                     	switch	.text
2431  03b5               _hal_spi_write:
2433  03b5 89            	pushw	x
2434  03b6 89            	pushw	x
2435       00000002      OFST:	set	2
2438                     ; 462     for(i = 0; i < len; i++){
2440  03b7 5f            	clrw	x
2441  03b8 1f01          	ldw	(OFST-1,sp),x
2444  03ba 200f          	jra	L1511
2445  03bc               L5411:
2446                     ; 463         hal_spi_byte(buf[i]);
2448  03bc 1e03          	ldw	x,(OFST+1,sp)
2449  03be 72fb01        	addw	x,(OFST-1,sp)
2450  03c1 f6            	ld	a,(x)
2451  03c2 adac          	call	_hal_spi_byte
2453                     ; 462     for(i = 0; i < len; i++){
2455  03c4 1e01          	ldw	x,(OFST-1,sp)
2456  03c6 1c0001        	addw	x,#1
2457  03c9 1f01          	ldw	(OFST-1,sp),x
2459  03cb               L1511:
2462  03cb 1e01          	ldw	x,(OFST-1,sp)
2463  03cd 1307          	cpw	x,(OFST+5,sp)
2464  03cf 25eb          	jrult	L5411
2465                     ; 465 }
2468  03d1 5b04          	addw	sp,#4
2469  03d3 81            	ret
2500                     ; 489 void w5500_chip_init(void){
2501                     	switch	.text
2502  03d4               _w5500_chip_init:
2506                     ; 493     GPIO_WriteLow(W5500_RST_PORT, W5500_RST_PIN);
2508  03d4 4b20          	push	#32
2509  03d6 ae5014        	ldw	x,#20500
2510  03d9 cd0000        	call	_GPIO_WriteLow
2512  03dc 84            	pop	a
2513                     ; 494     hal_delay_ms(100);
2515  03dd ae0064        	ldw	x,#100
2516  03e0 cd0014        	call	_hal_delay_ms
2518                     ; 495     GPIO_WriteHigh(W5500_RST_PORT, W5500_RST_PIN);
2520  03e3 4b20          	push	#32
2521  03e5 ae5014        	ldw	x,#20500
2522  03e8 cd0000        	call	_GPIO_WriteHigh
2524  03eb 84            	pop	a
2525                     ; 496     hal_delay_ms(100);
2527  03ec ae0064        	ldw	x,#100
2528  03ef cd0014        	call	_hal_delay_ms
2530                     ; 500     CLK_PeripheralClockConfig(CLK_PERIPHERAL_SPI, ENABLE);
2532  03f2 ae0101        	ldw	x,#257
2533  03f5 cd0000        	call	_CLK_PeripheralClockConfig
2535                     ; 501     GPIO_Init(W5500_SCK_PORT,W5500_SCK_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
2537  03f8 4bf0          	push	#240
2538  03fa 4b20          	push	#32
2539  03fc ae500a        	ldw	x,#20490
2540  03ff cd0000        	call	_GPIO_Init
2542  0402 85            	popw	x
2543                     ; 502     GPIO_Init(W5500_MOSI_PORT,W5500_MOSI_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
2545  0403 4bf0          	push	#240
2546  0405 4b40          	push	#64
2547  0407 ae500a        	ldw	x,#20490
2548  040a cd0000        	call	_GPIO_Init
2550  040d 85            	popw	x
2551                     ; 503     GPIO_Init(W5500_MISO_PORT,W5500_MISO_PIN,GPIO_MODE_IN_FL_NO_IT);
2553  040e 4b00          	push	#0
2554  0410 4b80          	push	#128
2555  0412 ae500a        	ldw	x,#20490
2556  0415 cd0000        	call	_GPIO_Init
2558  0418 85            	popw	x
2559                     ; 505     GPIO_Init(W5500_CS_PORT,W5500_CS_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
2561  0419 4bf0          	push	#240
2562  041b 4b08          	push	#8
2563  041d ae5000        	ldw	x,#20480
2564  0420 cd0000        	call	_GPIO_Init
2566  0423 85            	popw	x
2567                     ; 506     GPIO_WriteHigh(W5500_CS_PORT, W5500_CS_PIN);
2569  0424 4b08          	push	#8
2570  0426 ae5000        	ldw	x,#20480
2571  0429 cd0000        	call	_GPIO_WriteHigh
2573  042c 84            	pop	a
2574                     ; 508     GPIO_Init(W5500_RST_PORT,W5500_RST_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
2576  042d 4bf0          	push	#240
2577  042f 4b20          	push	#32
2578  0431 ae5014        	ldw	x,#20500
2579  0434 cd0000        	call	_GPIO_Init
2581  0437 85            	popw	x
2582                     ; 509     GPIO_Init(W5500_INT_PORT,W5500_INT_PIN,GPIO_MODE_IN_FL_NO_IT);
2584  0438 4b00          	push	#0
2585  043a 4b10          	push	#16
2586  043c ae5019        	ldw	x,#20505
2587  043f cd0000        	call	_GPIO_Init
2589  0442 85            	popw	x
2590                     ; 510     SPI_DeInit();
2592  0443 cd0000        	call	_SPI_DeInit
2594                     ; 511     SPI_Init(
2594                     ; 512         SPI_FIRSTBIT_MSB,
2594                     ; 513         SPI_BAUDRATEPRESCALER_4,
2594                     ; 514         SPI_MODE_MASTER,
2594                     ; 515         SPI_CLOCKPOLARITY_LOW,
2594                     ; 516         SPI_CLOCKPHASE_1EDGE,
2594                     ; 517         SPI_DATADIRECTION_2LINES_FULLDUPLEX,
2594                     ; 518         SPI_NSS_SOFT,
2594                     ; 519         0x07
2594                     ; 520     );
2596  0446 4b07          	push	#7
2597  0448 4b02          	push	#2
2598  044a 4b00          	push	#0
2599  044c 4b00          	push	#0
2600  044e 4b00          	push	#0
2601  0450 4b04          	push	#4
2602  0452 ae0008        	ldw	x,#8
2603  0455 cd0000        	call	_SPI_Init
2605  0458 5b06          	addw	sp,#6
2606                     ; 521     SPI_Cmd(ENABLE);
2608  045a a601          	ld	a,#1
2609  045c cd0000        	call	_SPI_Cmd
2611                     ; 532 }
2614  045f 81            	ret
2650                     ; 629 void tcp_server_init(uint16_t port)
2650                     ; 630 {
2651                     	switch	.text
2652  0460               _tcp_server_init:
2656                     ; 631     server_port = port;
2658  0460 bf1a          	ldw	L51_server_port,x
2659                     ; 632     server_state = TCP_STATE_IDLE;
2661  0462 3f18          	clr	L11_server_state
2662                     ; 641 }
2665  0464 81            	ret
2693                     ; 643 void hal_timer_init(void){
2694                     	switch	.text
2695  0465               _hal_timer_init:
2699                     ; 644     CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER4, ENABLE);
2701  0465 ae0401        	ldw	x,#1025
2702  0468 cd0000        	call	_CLK_PeripheralClockConfig
2704                     ; 645     TIM4_TimeBaseInit(TIM4_PRESCALER_128, 125);
2706  046b ae077d        	ldw	x,#1917
2707  046e cd0000        	call	_TIM4_TimeBaseInit
2709                     ; 646     TIM4_ClearFlag(TIM4_FLAG_UPDATE);
2711  0471 a601          	ld	a,#1
2712  0473 cd0000        	call	_TIM4_ClearFlag
2714                     ; 648     TIM4_ITConfig(TIM4_IT_UPDATE, ENABLE);
2716  0476 ae0101        	ldw	x,#257
2717  0479 cd0000        	call	_TIM4_ITConfig
2719                     ; 650     enableInterrupts();
2722  047c 9a            rim
2724                     ; 651 }
2728  047d 81            	ret
2763                     ; 653 void system_init(void){
2764                     	switch	.text
2765  047e               _system_init:
2769                     ; 655     CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);  /* 16MHz clock */
2771  047e 4f            	clr	a
2772  047f cd0000        	call	_CLK_HSIPrescalerConfig
2774                     ; 658 	hal_gpio_init();
2776  0482 cd029c        	call	_hal_gpio_init
2778                     ; 659     hal_timer_init();
2780  0485 adde          	call	_hal_timer_init
2782                     ; 662 	relay_control_init();
2784  0487 cd028c        	call	_relay_control_init
2786                     ; 663 	sensor_reader_init();
2788  048a cd01d7        	call	_sensor_reader_init
2790                     ; 665     w5500_chip_init();
2792  048d cd03d4        	call	_w5500_chip_init
2794                     ; 667     tcp_server_init(TCP_SERVER_PORT);
2796  0490 ae1388        	ldw	x,#5000
2797  0493 adcb          	call	_tcp_server_init
2799                     ; 671     hal_timer_set_callback(timer_callback);
2801  0495 ae01d8        	ldw	x,#_timer_callback
2802  0498 cd021a        	call	_hal_timer_set_callback
2804                     ; 672     hal_timer_start();
2806  049b cd01d1        	call	_hal_timer_start
2808                     ; 673 	hal_delay_ms(500);
2810  049e ae01f4        	ldw	x,#500
2811  04a1 cd0014        	call	_hal_delay_ms
2813                     ; 674 }
2816  04a4 81            	ret
2819                     	switch	.const
2820  0008               L3221_msg:
2821  0008 52455345542c  	dc.b	"RESET, OK",10,0
2858                     ; 677 void main_loop(void)
2858                     ; 678 {
2859                     	switch	.text
2860  04a5               _main_loop:
2862  04a5 520b          	subw	sp,#11
2863       0000000b      OFST:	set	11
2866  04a7               L3421:
2867                     ; 687         if(GPIO_ReadInputPin(HARDRST_PORT, HARDRST_PIN) == RESET)
2869  04a7 4b80          	push	#128
2870  04a9 ae5005        	ldw	x,#20485
2871  04ac cd0000        	call	_GPIO_ReadInputPin
2873  04af 5b01          	addw	sp,#1
2874  04b1 4d            	tnz	a
2875  04b2 26f3          	jrne	L3421
2876                     ; 689             hal_delay_ms(50);
2878  04b4 ae0032        	ldw	x,#50
2879  04b7 cd0014        	call	_hal_delay_ms
2881                     ; 690 			if (GPIO_ReadInputPin(HARDRST_PORT, HARDRST_PIN) == 0){
2883  04ba 4b80          	push	#128
2884  04bc ae5005        	ldw	x,#20485
2885  04bf cd0000        	call	_GPIO_ReadInputPin
2887  04c2 5b01          	addw	sp,#1
2888  04c4 4d            	tnz	a
2889  04c5 26e0          	jrne	L3421
2890                     ; 692 				char msg[] = "RESET, OK\n";
2892  04c7 96            	ldw	x,sp
2893  04c8 1c0001        	addw	x,#OFST-10
2894  04cb 90ae0008      	ldw	y,#L3221_msg
2895  04cf a60b          	ld	a,#11
2896  04d1 cd0000        	call	c_xymov
2898                     ; 693                 if(tcp_server_is_connected()){
2900  04d4 cd0007        	call	_tcp_server_is_connected
2902  04d7 a30000        	cpw	x,#0
2903                     ; 696                 if (uart_server_is_ready()){
2905  04da cd0041        	call	_uart_server_is_ready
2907  04dd a30000        	cpw	x,#0
2908                     ; 699 				hal_delay_ms(100);
2910  04e0 ae0064        	ldw	x,#100
2911  04e3 cd0014        	call	_hal_delay_ms
2913  04e6 20bf          	jra	L3421
2938                     ; 708 int main(void)
2938                     ; 709 {
2939                     	switch	.text
2940  04e8               _main:
2944                     ; 710 	system_init();
2946  04e8 ad94          	call	_system_init
2948                     ; 711     main_loop();
2950  04ea adb9          	call	_main_loop
2952  04ec               L7621:
2953                     ; 712     while(1);
2955  04ec 20fe          	jra	L7621
3244                     	xdef	_main
3245                     	xdef	_main_loop
3246                     	xdef	_system_init
3247                     	xdef	_hal_timer_init
3248                     	xdef	_tcp_server_init
3249                     	xdef	_w5500_chip_init
3250                     	xdef	_hal_spi_write
3251                     	xdef	_hal_spi_read
3252                     	xdef	_hal_spi_write_byte
3253                     	xdef	_hal_spi_read_byte
3254                     	xdef	_hal_spi_byte
3255                     	xdef	_hal_uart_read_byte
3256                     	xdef	_hal_uart_available
3257                     	xdef	_hal_gpio_init
3258                     	xdef	_hal_w5500_reset_high
3259                     	xdef	_relay_control_init
3260                     	xdef	_command_parser_execute
3261                     	xdef	_hal_timer_set_callback
3262                     	xdef	_timer_callback
3263                     	xdef	_sensor_reader_init
3264                     	xdef	_hal_timer_start
3265                     	xdef	_message_formatter_avcc
3266                     	xdef	_relay_control_set_all
3267                     	xdef	_relay_control_set
3268                     	xdef	_hal_relay_set
3269                     	xdef	_hal_di_read
3270                     	xdef	_sensor_reader_get_state
3271                     	xdef	_hal_spi_cs_high
3272                     	xdef	_hal_spi_cs_low
3273                     	xdef	_hal_uart_send
3274                     	xdef	_hal_uart_send_byte
3275                     	xdef	_uart_server_is_ready
3276                     	xdef	_hal_delay_ms
3277                     	xdef	_tcp_server_is_connected
3278                     	xdef	_hal_get_millis
3279                     	switch	.ubsct
3280  0000               L13_uart_rx_buffer:
3281  0000 000000000000  	ds.b	20
3282                     	xref	_TIM4_ClearFlag
3283                     	xref	_TIM4_ITConfig
3284                     	xref	_TIM4_Cmd
3285                     	xref	_TIM4_TimeBaseInit
3286                     	xref	_SPI_GetFlagStatus
3287                     	xref	_SPI_ReceiveData
3288                     	xref	_SPI_SendData
3289                     	xref	_SPI_Cmd
3290                     	xref	_SPI_Init
3291                     	xref	_SPI_DeInit
3292                     	xref	_UART1_GetFlagStatus
3293                     	xref	_UART1_SendData8
3294                     	xref	_GPIO_ReadInputPin
3295                     	xref	_GPIO_WriteLow
3296                     	xref	_GPIO_WriteHigh
3297                     	xref	_GPIO_Init
3298                     	xref	_CLK_HSIPrescalerConfig
3299                     	xref	_CLK_PeripheralClockConfig
3300                     	xref.b	c_x
3320                     	xref	c_xymov
3321                     	xref	c_lcmp
3322                     	xref	c_lsub
3323                     	xref	c_uitolx
3324                     	xref	c_rtol
3325                     	xref	c_ltor
3326                     	end
