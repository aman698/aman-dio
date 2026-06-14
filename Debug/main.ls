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
  77                     ; 71 unsigned long hal_get_millis(void)
  77                     ; 72 {
  79                     	switch	.text
  80  0000               _hal_get_millis:
  84                     ; 73     return systick_ms;
  86  0000 ae0023        	ldw	x,#L33_systick_ms
  87  0003 cd0000        	call	c_ltor
  91  0006 81            	ret
 116                     ; 75 int tcp_server_is_connected(void)
 116                     ; 76 {
 117                     	switch	.text
 118  0007               _tcp_server_is_connected:
 122                     ; 77     return (server_state == TCP_STATE_CONNECTED) ? 1 : 0;
 124  0007 b618          	ld	a,L11_server_state
 125  0009 a102          	cp	a,#2
 126  000b 2605          	jrne	L01
 127  000d ae0001        	ldw	x,#1
 128  0010 2001          	jra	L21
 129  0012               L01:
 130  0012 5f            	clrw	x
 131  0013               L21:
 134  0013 81            	ret
 178                     ; 79 void hal_delay_ms(unsigned int ms)
 178                     ; 80 {
 179                     	switch	.text
 180  0014               _hal_delay_ms:
 182  0014 89            	pushw	x
 183  0015 5208          	subw	sp,#8
 184       00000008      OFST:	set	8
 187                     ; 81     unsigned long start = hal_get_millis();
 189  0017 ade7          	call	_hal_get_millis
 191  0019 96            	ldw	x,sp
 192  001a 1c0005        	addw	x,#OFST-3
 193  001d cd0000        	call	c_rtol
 197  0020               L311:
 198                     ; 82     while ((hal_get_millis() - start) < ms);
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
 219                     ; 83 }
 222  003e 5b0a          	addw	sp,#10
 223  0040 81            	ret
 248                     ; 85 int uart_server_is_ready(void){
 249                     	switch	.text
 250  0041               _uart_server_is_ready:
 254                     ; 86     return (uart_state != UART_STATE_IDLE) ? 1 : 0;
 256  0041 3d19          	tnz	L31_uart_state
 257  0043 2705          	jreq	L02
 258  0045 ae0001        	ldw	x,#1
 259  0048 2001          	jra	L22
 260  004a               L02:
 261  004a 5f            	clrw	x
 262  004b               L22:
 265  004b 81            	ret
 301                     ; 89 void hal_uart_send_byte(uint8_t byte){
 302                     	switch	.text
 303  004c               _hal_uart_send_byte:
 305  004c 88            	push	a
 306       00000000      OFST:	set	0
 309  004d               L741:
 310                     ; 90     while (UART1_GetFlagStatus(UART1_FLAG_TXE) == RESET);
 312  004d ae0080        	ldw	x,#128
 313  0050 cd0000        	call	_UART1_GetFlagStatus
 315  0053 4d            	tnz	a
 316  0054 27f7          	jreq	L741
 317                     ; 93     UART1_SendData8(byte);
 319  0056 7b01          	ld	a,(OFST+1,sp)
 320  0058 cd0000        	call	_UART1_SendData8
 323  005b               L551:
 324                     ; 96     while (UART1_GetFlagStatus(UART1_FLAG_TC) == RESET);
 326  005b ae0040        	ldw	x,#64
 327  005e cd0000        	call	_UART1_GetFlagStatus
 329  0061 4d            	tnz	a
 330  0062 27f7          	jreq	L551
 331                     ; 97 }
 334  0064 84            	pop	a
 335  0065 81            	ret
 389                     ; 99 void hal_uart_send(const uint8_t *data, uint16_t len){
 390                     	switch	.text
 391  0066               _hal_uart_send:
 393  0066 89            	pushw	x
 394  0067 89            	pushw	x
 395       00000002      OFST:	set	2
 398                     ; 101     for(i = 0; i < len; i++){
 400  0068 5f            	clrw	x
 401  0069 1f01          	ldw	(OFST-1,sp),x
 404  006b 200f          	jra	L312
 405  006d               L702:
 406                     ; 102         hal_uart_send_byte(data[i]);
 408  006d 1e03          	ldw	x,(OFST+1,sp)
 409  006f 72fb01        	addw	x,(OFST-1,sp)
 410  0072 f6            	ld	a,(x)
 411  0073 add7          	call	_hal_uart_send_byte
 413                     ; 101     for(i = 0; i < len; i++){
 415  0075 1e01          	ldw	x,(OFST-1,sp)
 416  0077 1c0001        	addw	x,#1
 417  007a 1f01          	ldw	(OFST-1,sp),x
 419  007c               L312:
 422  007c 1e01          	ldw	x,(OFST-1,sp)
 423  007e 1307          	cpw	x,(OFST+5,sp)
 424  0080 25eb          	jrult	L702
 425                     ; 104 }
 428  0082 5b04          	addw	sp,#4
 429  0084 81            	ret
 453                     ; 105 void hal_spi_cs_low(void)
 453                     ; 106 {
 454                     	switch	.text
 455  0085               _hal_spi_cs_low:
 459                     ; 107     GPIO_WriteLow(W5500_CS_PORT, W5500_CS_PIN);
 461  0085 4b08          	push	#8
 462  0087 ae5000        	ldw	x,#20480
 463  008a cd0000        	call	_GPIO_WriteLow
 465  008d 84            	pop	a
 466                     ; 108 }
 469  008e 81            	ret
 493                     ; 110 void hal_spi_cs_high(void)
 493                     ; 111 {
 494                     	switch	.text
 495  008f               _hal_spi_cs_high:
 499                     ; 112     GPIO_WriteHigh(W5500_CS_PORT, W5500_CS_PIN);
 501  008f 4b08          	push	#8
 502  0091 ae5000        	ldw	x,#20480
 503  0094 cd0000        	call	_GPIO_WriteHigh
 505  0097 84            	pop	a
 506                     ; 113 }
 509  0098 81            	ret
 570                     ; 123 sensor_state_t sensor_reader_get_state(void)
 570                     ; 124 {
 571                     	switch	.text
 572  0099               _sensor_reader_get_state:
 574       00000000      OFST:	set	0
 577                     ; 125     return current_state;
 579  0099 1e03          	ldw	x,(OFST+3,sp)
 580  009b 90ae0014      	ldw	y,#L7_current_state
 581  009f a604          	ld	a,#4
 582  00a1 cd0000        	call	c_xymov
 586  00a4 81            	ret
 778                     ; 151 uint8_t hal_di_read(uint8_t di_num)
 778                     ; 152 {
 779                     	switch	.text
 780  00a5               _hal_di_read:
 782  00a5 5203          	subw	sp,#3
 783       00000003      OFST:	set	3
 786                     ; 156     switch (di_num) {
 789                     ; 161         default: return 0;
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
 805                     ; 157         case 1: port = DI1_PORT; pin = DI1_PIN; break;
 807  00b6 ae500f        	ldw	x,#20495
 808  00b9 1f01          	ldw	(OFST-2,sp),x
 812  00bb a604          	ld	a,#4
 813  00bd 6b03          	ld	(OFST+0,sp),a
 817  00bf 201f          	jra	L114
 818  00c1               L562:
 819                     ; 158         case 2: port = DI2_PORT; pin = DI2_PIN; break;
 821  00c1 ae500f        	ldw	x,#20495
 822  00c4 1f01          	ldw	(OFST-2,sp),x
 826  00c6 a608          	ld	a,#8
 827  00c8 6b03          	ld	(OFST+0,sp),a
 831  00ca 2014          	jra	L114
 832  00cc               L762:
 833                     ; 159         case 3: port = DI3_PORT; pin = DI3_PIN; break;
 835  00cc ae500f        	ldw	x,#20495
 836  00cf 1f01          	ldw	(OFST-2,sp),x
 840  00d1 a610          	ld	a,#16
 841  00d3 6b03          	ld	(OFST+0,sp),a
 845  00d5 2009          	jra	L114
 846  00d7               L172:
 847                     ; 160         case 4: port = DI4_PORT; pin = DI4_PIN; break;
 849  00d7 ae500f        	ldw	x,#20495
 850  00da 1f01          	ldw	(OFST-2,sp),x
 854  00dc a680          	ld	a,#128
 855  00de 6b03          	ld	(OFST+0,sp),a
 859  00e0               L114:
 860                     ; 163     return (GPIO_ReadInputPin(port, pin) == SET) ? 1 : 0;
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
 976                     ; 168 void hal_relay_set(uint8_t relay_num, uint8_t state){
 977                     	switch	.text
 978  00f6               _hal_relay_set:
 980  00f6 89            	pushw	x
 981  00f7 5204          	subw	sp,#4
 982       00000004      OFST:	set	4
 985                     ; 171 	BitStatus bit_state = (state == 0) ? SET : RESET;
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
 999                     ; 173 	switch (relay_num) {
1001  0107 7b05          	ld	a,(OFST+1,sp)
1003                     ; 180         default: return;
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
1021                     ; 174         case 1: port = RELAY1_PORT; pin = RELAY1_PIN; break;
1023  011d ae5005        	ldw	x,#20485
1024  0120 1f02          	ldw	(OFST-2,sp),x
1028  0122 a608          	ld	a,#8
1029  0124 6b04          	ld	(OFST+0,sp),a
1033  0126 2035          	jra	L305
1034  0128               L514:
1035                     ; 175         case 2: port = RELAY2_PORT; pin = RELAY2_PIN; break;
1037  0128 ae5005        	ldw	x,#20485
1038  012b 1f02          	ldw	(OFST-2,sp),x
1042  012d a604          	ld	a,#4
1043  012f 6b04          	ld	(OFST+0,sp),a
1047  0131 202a          	jra	L305
1048  0133               L714:
1049                     ; 176         case 3: port = RELAY3_PORT; pin = RELAY3_PIN; break;
1051  0133 ae5005        	ldw	x,#20485
1052  0136 1f02          	ldw	(OFST-2,sp),x
1056  0138 a602          	ld	a,#2
1057  013a 6b04          	ld	(OFST+0,sp),a
1061  013c 201f          	jra	L305
1062  013e               L124:
1063                     ; 177         case 4: port = RELAY4_PORT; pin = RELAY4_PIN; break;
1065  013e ae5005        	ldw	x,#20485
1066  0141 1f02          	ldw	(OFST-2,sp),x
1070  0143 a601          	ld	a,#1
1071  0145 6b04          	ld	(OFST+0,sp),a
1075  0147 2014          	jra	L305
1076  0149               L324:
1077                     ; 178         case 5: port = RELAY5_PORT; pin = RELAY5_PIN; break;
1079  0149 ae500a        	ldw	x,#20490
1080  014c 1f02          	ldw	(OFST-2,sp),x
1084  014e a608          	ld	a,#8
1085  0150 6b04          	ld	(OFST+0,sp),a
1089  0152 2009          	jra	L305
1090  0154               L524:
1091                     ; 179         case 6: port = RELAY6_PORT; pin = RELAY6_PIN; break;
1093  0154 ae500a        	ldw	x,#20490
1094  0157 1f02          	ldw	(OFST-2,sp),x
1098  0159 a610          	ld	a,#16
1099  015b 6b04          	ld	(OFST+0,sp),a
1103  015d               L305:
1104                     ; 183 	if (bit_state == SET) {
1106  015d 7b01          	ld	a,(OFST-3,sp)
1107  015f a101          	cp	a,#1
1108  0161 260b          	jrne	L505
1109                     ; 184         GPIO_WriteHigh(port, pin);  /* Set HIGH = relay off */
1111  0163 7b04          	ld	a,(OFST+0,sp)
1112  0165 88            	push	a
1113  0166 1e03          	ldw	x,(OFST-1,sp)
1114  0168 cd0000        	call	_GPIO_WriteHigh
1116  016b 84            	pop	a
1118  016c 2009          	jra	L705
1119  016e               L505:
1120                     ; 186         GPIO_WriteLow(port, pin); /* Set LOW = relay on */
1122  016e 7b04          	ld	a,(OFST+0,sp)
1123  0170 88            	push	a
1124  0171 1e03          	ldw	x,(OFST-1,sp)
1125  0173 cd0000        	call	_GPIO_WriteLow
1127  0176 84            	pop	a
1128  0177               L705:
1129                     ; 188 }
1130  0177               L45:
1133  0177 5b06          	addw	sp,#6
1134  0179 81            	ret
1178                     ; 190 void relay_control_set(uint8_t relay_num, uint8_t state)
1178                     ; 191 {
1179                     	switch	.text
1180  017a               _relay_control_set:
1182  017a 89            	pushw	x
1183       00000000      OFST:	set	0
1186                     ; 192     if (relay_num >= 1 && relay_num <= 6) {
1188  017b 9e            	ld	a,xh
1189  017c 4d            	tnz	a
1190  017d 270d          	jreq	L335
1192  017f 9e            	ld	a,xh
1193  0180 a107          	cp	a,#7
1194  0182 2408          	jruge	L335
1195                     ; 193         hal_relay_set(relay_num, state);
1197  0184 9f            	ld	a,xl
1198  0185 97            	ld	xl,a
1199  0186 7b01          	ld	a,(OFST+1,sp)
1200  0188 95            	ld	xh,a
1201  0189 cd00f6        	call	_hal_relay_set
1203  018c               L335:
1204                     ; 195 }
1207  018c 85            	popw	x
1208  018d 81            	ret
1244                     ; 197 void relay_control_set_all(uint8_t state)
1244                     ; 198 {
1245                     	switch	.text
1246  018e               _relay_control_set_all:
1248  018e 88            	push	a
1249       00000000      OFST:	set	0
1252                     ; 199     relay_control_set(1, state);
1254  018f ae0100        	ldw	x,#256
1255  0192 97            	ld	xl,a
1256  0193 ade5          	call	_relay_control_set
1258                     ; 200     relay_control_set(2, state);
1260  0195 7b01          	ld	a,(OFST+1,sp)
1261  0197 ae0200        	ldw	x,#512
1262  019a 97            	ld	xl,a
1263  019b addd          	call	_relay_control_set
1265                     ; 201     relay_control_set(3, state);
1267  019d 7b01          	ld	a,(OFST+1,sp)
1268  019f ae0300        	ldw	x,#768
1269  01a2 97            	ld	xl,a
1270  01a3 add5          	call	_relay_control_set
1272                     ; 202     relay_control_set(4, state);
1274  01a5 7b01          	ld	a,(OFST+1,sp)
1275  01a7 ae0400        	ldw	x,#1024
1276  01aa 97            	ld	xl,a
1277  01ab adcd          	call	_relay_control_set
1279                     ; 203     relay_control_set(5, state);
1281  01ad 7b01          	ld	a,(OFST+1,sp)
1282  01af ae0500        	ldw	x,#1280
1283  01b2 97            	ld	xl,a
1284  01b3 adc5          	call	_relay_control_set
1286                     ; 204     relay_control_set(6, state);
1288  01b5 7b01          	ld	a,(OFST+1,sp)
1289  01b7 ae0600        	ldw	x,#1536
1290  01ba 97            	ld	xl,a
1291  01bb adbd          	call	_relay_control_set
1293                     ; 205 }
1296  01bd 84            	pop	a
1297  01be 81            	ret
1342                     ; 207 void message_formatter_avcc(char *buf, int buf_size, uint16_t lanid, uint32_t seqn, uint16_t axle_count)
1342                     ; 208 {
1343                     	switch	.text
1344  01bf               _message_formatter_avcc:
1346  01bf 89            	pushw	x
1347       00000000      OFST:	set	0
1350                     ; 209     if(buf == 0) return;
1352  01c0 a30000        	cpw	x,#0
1353  01c3 2708          	jreq	L46
1356                     ; 210     if(buf_size < 32) return;
1358  01c5 9c            	rvf
1359  01c6 1e05          	ldw	x,(OFST+5,sp)
1360  01c8 a30020        	cpw	x,#32
1361  01cb 2e02          	jrsge	L775
1363  01cd               L46:
1366  01cd 85            	popw	x
1367  01ce 81            	ret
1368  01cf               L775:
1369                     ; 213 }
1371  01cf 20fc          	jra	L46
1395                     ; 235 void hal_timer_start(void)
1395                     ; 236 {
1396                     	switch	.text
1397  01d1               _hal_timer_start:
1401                     ; 237     TIM4_Cmd(ENABLE);
1403  01d1 a601          	ld	a,#1
1404  01d3 cd0000        	call	_TIM4_Cmd
1406                     ; 238 }
1409  01d6 81            	ret
1432                     ; 279 void sensor_reader_init(void)
1432                     ; 280 {
1433                     	switch	.text
1434  01d7               _sensor_reader_init:
1438                     ; 283 }
1441  01d7 81            	ret
1466                     .const:	section	.text
1467  0000               L47:
1468  0000 00000032      	dc.l	50
1469  0004               L67:
1470  0004 000001f4      	dc.l	500
1471                     ; 284 void timer_callback(void){
1472                     	switch	.text
1473  01d8               _timer_callback:
1477                     ; 285     task_timer.current_time = hal_get_millis();
1479  01d8 cd0000        	call	_hal_get_millis
1481  01db ae0010        	ldw	x,#L5_task_timer+8
1482  01de cd0000        	call	c_rtol
1484                     ; 287     if ((task_timer.current_time - task_timer.last_sensor_time) >= SENSOR_READ_INTERVAL){
1486  01e1 ae0010        	ldw	x,#L5_task_timer+8
1487  01e4 cd0000        	call	c_ltor
1489  01e7 ae000c        	ldw	x,#L5_task_timer+4
1490  01ea cd0000        	call	c_lsub
1492  01ed ae0000        	ldw	x,#L47
1493  01f0 cd0000        	call	c_lcmp
1495  01f3 2508          	jrult	L136
1496                     ; 290         task_timer.last_sensor_time = task_timer.current_time;
1498  01f5 be12          	ldw	x,L5_task_timer+10
1499  01f7 bf0e          	ldw	L5_task_timer+6,x
1500  01f9 be10          	ldw	x,L5_task_timer+8
1501  01fb bf0c          	ldw	L5_task_timer+4,x
1502  01fd               L136:
1503                     ; 294     if ((task_timer.current_time - task_timer.last_alive_time) >= ALIVE_INTERVAL){
1505  01fd ae0010        	ldw	x,#L5_task_timer+8
1506  0200 cd0000        	call	c_ltor
1508  0203 ae0008        	ldw	x,#L5_task_timer
1509  0206 cd0000        	call	c_lsub
1511  0209 ae0004        	ldw	x,#L67
1512  020c cd0000        	call	c_lcmp
1514  020f 2508          	jrult	L336
1515                     ; 296         task_timer.last_alive_time = task_timer.current_time;
1517  0211 be12          	ldw	x,L5_task_timer+10
1518  0213 bf0a          	ldw	L5_task_timer+2,x
1519  0215 be10          	ldw	x,L5_task_timer+8
1520  0217 bf08          	ldw	L5_task_timer,x
1521  0219               L336:
1522                     ; 298 }
1525  0219 81            	ret
1563                     ; 300 void hal_timer_set_callback(timer_callback_t callback)
1563                     ; 301 {
1564                     	switch	.text
1565  021a               _hal_timer_set_callback:
1569                     ; 302     user_callback = callback;
1571  021a bf27          	ldw	L53_user_callback,x
1572                     ; 303 }
1575  021c 81            	ret
1639                     ; 305 int command_parser_execute(const char *cmd_str, int len)
1639                     ; 306 {
1640                     	switch	.text
1641  021d               _command_parser_execute:
1643  021d 89            	pushw	x
1644  021e 89            	pushw	x
1645       00000002      OFST:	set	2
1648                     ; 311     if (len < 4)
1650  021f 9c            	rvf
1651  0220 1e07          	ldw	x,(OFST+5,sp)
1652  0222 a30004        	cpw	x,#4
1653  0225 2e05          	jrsge	L507
1654                     ; 312         return -1;
1656  0227 aeffff        	ldw	x,#65535
1658  022a 200a          	jra	L401
1659  022c               L507:
1660                     ; 314     if (cmd_str[0] != 'R')
1662  022c 1e03          	ldw	x,(OFST+1,sp)
1663  022e f6            	ld	a,(x)
1664  022f a152          	cp	a,#82
1665  0231 2706          	jreq	L707
1666                     ; 315         return -1;
1668  0233 aeffff        	ldw	x,#65535
1670  0236               L401:
1672  0236 5b04          	addw	sp,#4
1673  0238 81            	ret
1674  0239               L707:
1675                     ; 317     if (cmd_str[1] < '1' || cmd_str[1] > '6')
1677  0239 1e03          	ldw	x,(OFST+1,sp)
1678  023b e601          	ld	a,(1,x)
1679  023d a131          	cp	a,#49
1680  023f 2508          	jrult	L317
1682  0241 1e03          	ldw	x,(OFST+1,sp)
1683  0243 e601          	ld	a,(1,x)
1684  0245 a137          	cp	a,#55
1685  0247 2505          	jrult	L117
1686  0249               L317:
1687                     ; 318         return -1;
1689  0249 aeffff        	ldw	x,#65535
1691  024c 20e8          	jra	L401
1692  024e               L117:
1693                     ; 320     if (cmd_str[2] != ',')
1695  024e 1e03          	ldw	x,(OFST+1,sp)
1696  0250 e602          	ld	a,(2,x)
1697  0252 a12c          	cp	a,#44
1698  0254 2705          	jreq	L517
1699                     ; 321         return -1;
1701  0256 aeffff        	ldw	x,#65535
1703  0259 20db          	jra	L401
1704  025b               L517:
1705                     ; 323     if (cmd_str[3] != '0' && cmd_str[3] != '1')
1707  025b 1e03          	ldw	x,(OFST+1,sp)
1708  025d e603          	ld	a,(3,x)
1709  025f a130          	cp	a,#48
1710  0261 270d          	jreq	L717
1712  0263 1e03          	ldw	x,(OFST+1,sp)
1713  0265 e603          	ld	a,(3,x)
1714  0267 a131          	cp	a,#49
1715  0269 2705          	jreq	L717
1716                     ; 324         return -1;
1718  026b aeffff        	ldw	x,#65535
1720  026e 20c6          	jra	L401
1721  0270               L717:
1722                     ; 326     relay_num = cmd_str[1] - '0';
1724  0270 1e03          	ldw	x,(OFST+1,sp)
1725  0272 e601          	ld	a,(1,x)
1726  0274 a030          	sub	a,#48
1727  0276 6b01          	ld	(OFST-1,sp),a
1729                     ; 327     relay_state = cmd_str[3] - '0';
1731  0278 1e03          	ldw	x,(OFST+1,sp)
1732  027a e603          	ld	a,(3,x)
1733  027c a030          	sub	a,#48
1734  027e 6b02          	ld	(OFST+0,sp),a
1736                     ; 329     relay_control_set(relay_num, relay_state);
1738  0280 7b02          	ld	a,(OFST+0,sp)
1739  0282 97            	ld	xl,a
1740  0283 7b01          	ld	a,(OFST-1,sp)
1741  0285 95            	ld	xh,a
1742  0286 cd017a        	call	_relay_control_set
1744                     ; 331     return 0;
1746  0289 5f            	clrw	x
1748  028a 20aa          	jra	L401
1772                     ; 334 void relay_control_init(void)
1772                     ; 335 {
1773                     	switch	.text
1774  028c               _relay_control_init:
1778                     ; 336     relay_control_set_all(1);  /* 1 = on for active-low relays */
1780  028c a601          	ld	a,#1
1781  028e cd018e        	call	_relay_control_set_all
1783                     ; 337 }
1786  0291 81            	ret
1811                     ; 339 void hal_w5500_reset_high(void)
1811                     ; 340 {
1812                     	switch	.text
1813  0292               _hal_w5500_reset_high:
1817                     ; 341     GPIO_WriteHigh(W5500_RST_PORT, W5500_RST_PIN);
1819  0292 4b20          	push	#32
1820  0294 ae5014        	ldw	x,#20500
1821  0297 cd0000        	call	_GPIO_WriteHigh
1823  029a 84            	pop	a
1824                     ; 342 }
1827  029b 81            	ret
1853                     ; 344 void hal_gpio_init(void){
1854                     	switch	.text
1855  029c               _hal_gpio_init:
1859                     ; 346     GPIO_Init(DI1_PORT, DI1_PIN, GPIO_MODE_IN_PU_NO_IT);
1861  029c 4b40          	push	#64
1862  029e 4b04          	push	#4
1863  02a0 ae500f        	ldw	x,#20495
1864  02a3 cd0000        	call	_GPIO_Init
1866  02a6 85            	popw	x
1867                     ; 347     GPIO_Init(DI2_PORT, DI2_PIN, GPIO_MODE_IN_PU_NO_IT);
1869  02a7 4b40          	push	#64
1870  02a9 4b08          	push	#8
1871  02ab ae500f        	ldw	x,#20495
1872  02ae cd0000        	call	_GPIO_Init
1874  02b1 85            	popw	x
1875                     ; 348     GPIO_Init(DI3_PORT, DI3_PIN, GPIO_MODE_IN_PU_NO_IT);
1877  02b2 4b40          	push	#64
1878  02b4 4b10          	push	#16
1879  02b6 ae500f        	ldw	x,#20495
1880  02b9 cd0000        	call	_GPIO_Init
1882  02bc 85            	popw	x
1883                     ; 349     GPIO_Init(DI4_PORT, DI4_PIN, GPIO_MODE_IN_PU_NO_IT);
1885  02bd 4b40          	push	#64
1886  02bf 4b80          	push	#128
1887  02c1 ae500f        	ldw	x,#20495
1888  02c4 cd0000        	call	_GPIO_Init
1890  02c7 85            	popw	x
1891                     ; 352     GPIO_Init(RELAY1_PORT, RELAY1_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
1893  02c8 4bf0          	push	#240
1894  02ca 4b08          	push	#8
1895  02cc ae5005        	ldw	x,#20485
1896  02cf cd0000        	call	_GPIO_Init
1898  02d2 85            	popw	x
1899                     ; 353     GPIO_Init(RELAY2_PORT, RELAY2_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
1901  02d3 4bf0          	push	#240
1902  02d5 4b04          	push	#4
1903  02d7 ae5005        	ldw	x,#20485
1904  02da cd0000        	call	_GPIO_Init
1906  02dd 85            	popw	x
1907                     ; 354     GPIO_Init(RELAY3_PORT, RELAY3_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
1909  02de 4bf0          	push	#240
1910  02e0 4b02          	push	#2
1911  02e2 ae5005        	ldw	x,#20485
1912  02e5 cd0000        	call	_GPIO_Init
1914  02e8 85            	popw	x
1915                     ; 355     GPIO_Init(RELAY4_PORT, RELAY4_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
1917  02e9 4bf0          	push	#240
1918  02eb 4b01          	push	#1
1919  02ed ae5005        	ldw	x,#20485
1920  02f0 cd0000        	call	_GPIO_Init
1922  02f3 85            	popw	x
1923                     ; 356     GPIO_Init(RELAY5_PORT, RELAY5_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
1925  02f4 4bf0          	push	#240
1926  02f6 4b08          	push	#8
1927  02f8 ae500a        	ldw	x,#20490
1928  02fb cd0000        	call	_GPIO_Init
1930  02fe 85            	popw	x
1931                     ; 357     GPIO_Init(RELAY6_PORT, RELAY6_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
1933  02ff 4bf0          	push	#240
1934  0301 4b10          	push	#16
1935  0303 ae500a        	ldw	x,#20490
1936  0306 cd0000        	call	_GPIO_Init
1938  0309 85            	popw	x
1939                     ; 360     hal_relay_set(1, 1);
1941  030a ae0101        	ldw	x,#257
1942  030d cd00f6        	call	_hal_relay_set
1944                     ; 361     hal_relay_set(2, 1);
1946  0310 ae0201        	ldw	x,#513
1947  0313 cd00f6        	call	_hal_relay_set
1949                     ; 362     hal_relay_set(3, 1);
1951  0316 ae0301        	ldw	x,#769
1952  0319 cd00f6        	call	_hal_relay_set
1954                     ; 363     hal_relay_set(4, 1);
1956  031c ae0401        	ldw	x,#1025
1957  031f cd00f6        	call	_hal_relay_set
1959                     ; 364     hal_relay_set(5, 1);
1961  0322 ae0501        	ldw	x,#1281
1962  0325 cd00f6        	call	_hal_relay_set
1964                     ; 365     hal_relay_set(6, 1);
1966  0328 ae0601        	ldw	x,#1537
1967  032b cd00f6        	call	_hal_relay_set
1969                     ; 368     GPIO_Init(HARDRST_PORT, HARDRST_PIN, GPIO_MODE_IN_PU_NO_IT);
1971  032e 4b40          	push	#64
1972  0330 4b80          	push	#128
1973  0332 ae5005        	ldw	x,#20485
1974  0335 cd0000        	call	_GPIO_Init
1976  0338 85            	popw	x
1977                     ; 371     GPIO_Init(W5500_RST_PORT, W5500_RST_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
1979  0339 4bf0          	push	#240
1980  033b 4b20          	push	#32
1981  033d ae5014        	ldw	x,#20500
1982  0340 cd0000        	call	_GPIO_Init
1984  0343 85            	popw	x
1985                     ; 372 	  hal_w5500_reset_high();
1987  0344 cd0292        	call	_hal_w5500_reset_high
1989                     ; 373 }
1992  0347 81            	ret
2016                     ; 375 uint16_t hal_uart_available(void){
2017                     	switch	.text
2018  0348               _hal_uart_available:
2022                     ; 376 	return uart_rx_count;
2024  0348 be1d          	ldw	x,L12_uart_rx_count
2027  034a 81            	ret
2066                     ; 379 uint8_t hal_uart_read_byte(void){
2067                     	switch	.text
2068  034b               _hal_uart_read_byte:
2070  034b 88            	push	a
2071       00000001      OFST:	set	1
2074                     ; 380 	uint8_t byte = 0;
2076  034c 0f01          	clr	(OFST+0,sp)
2078                     ; 381 	if (uart_rx_count > 0){
2080  034e be1d          	ldw	x,L12_uart_rx_count
2081  0350 2719          	jreq	L777
2082                     ; 382 		disableInterrupts();
2085  0352 9b            sim
2087                     ; 384 		byte = uart_rx_buffer[uart_rx_tail];
2090  0353 be21          	ldw	x,L52_uart_rx_tail
2091  0355 e600          	ld	a,(L13_uart_rx_buffer,x)
2092  0357 6b01          	ld	(OFST+0,sp),a
2094                     ; 385 		uart_rx_tail = (uart_rx_tail + 1) % UART_RX_BUFFER_SIZE;
2096  0359 be21          	ldw	x,L52_uart_rx_tail
2097  035b 5c            	incw	x
2098  035c a60a          	ld	a,#10
2099  035e 62            	div	x,a
2100  035f 5f            	clrw	x
2101  0360 97            	ld	xl,a
2102  0361 bf21          	ldw	L52_uart_rx_tail,x
2103                     ; 386 		uart_rx_count--;
2105  0363 be1d          	ldw	x,L12_uart_rx_count
2106  0365 1d0001        	subw	x,#1
2107  0368 bf1d          	ldw	L12_uart_rx_count,x
2108                     ; 387 		enableInterrupts();
2111  036a 9a            rim
2114  036b               L777:
2115                     ; 389 	return byte;
2117  036b 7b01          	ld	a,(OFST+0,sp)
2120  036d 5b01          	addw	sp,#1
2121  036f 81            	ret
2158                     ; 434 uint8_t hal_spi_byte(uint8_t data)
2158                     ; 435 {
2159                     	switch	.text
2160  0370               _hal_spi_byte:
2162  0370 88            	push	a
2163       00000000      OFST:	set	0
2166  0371               L1201:
2167                     ; 436     while (SPI_GetFlagStatus(SPI_FLAG_TXE) == RESET);
2169  0371 a602          	ld	a,#2
2170  0373 cd0000        	call	_SPI_GetFlagStatus
2172  0376 4d            	tnz	a
2173  0377 27f8          	jreq	L1201
2174                     ; 438     SPI_SendData(data);
2176  0379 7b01          	ld	a,(OFST+1,sp)
2177  037b cd0000        	call	_SPI_SendData
2180  037e               L7201:
2181                     ; 440     while (SPI_GetFlagStatus(SPI_FLAG_RXNE) == RESET);
2183  037e a601          	ld	a,#1
2184  0380 cd0000        	call	_SPI_GetFlagStatus
2186  0383 4d            	tnz	a
2187  0384 27f8          	jreq	L7201
2188                     ; 442     return SPI_ReceiveData();
2190  0386 cd0000        	call	_SPI_ReceiveData
2194  0389 5b01          	addw	sp,#1
2195  038b 81            	ret
2219                     ; 444 uint8_t hal_spi_read_byte(void)
2219                     ; 445 {
2220                     	switch	.text
2221  038c               _hal_spi_read_byte:
2225                     ; 446     return hal_spi_byte(0xFF);
2227  038c a6ff          	ld	a,#255
2228  038e ade0          	call	_hal_spi_byte
2232  0390 81            	ret
2267                     ; 448 void hal_spi_write_byte(uint8_t data)
2267                     ; 449 {
2268                     	switch	.text
2269  0391               _hal_spi_write_byte:
2273                     ; 450     hal_spi_byte(data);
2275  0391 addd          	call	_hal_spi_byte
2277                     ; 451 }
2280  0393 81            	ret
2334                     ; 452 void hal_spi_read(uint8_t *buf, uint16_t len){
2335                     	switch	.text
2336  0394               _hal_spi_read:
2338  0394 89            	pushw	x
2339  0395 89            	pushw	x
2340       00000002      OFST:	set	2
2343                     ; 454     for(i = 0; i < len; i++){
2345  0396 5f            	clrw	x
2346  0397 1f01          	ldw	(OFST-1,sp),x
2349  0399 2011          	jra	L3111
2350  039b               L7011:
2351                     ; 455         buf[i] = hal_spi_byte(0xFF);
2353  039b a6ff          	ld	a,#255
2354  039d add1          	call	_hal_spi_byte
2356  039f 1e03          	ldw	x,(OFST+1,sp)
2357  03a1 72fb01        	addw	x,(OFST-1,sp)
2358  03a4 f7            	ld	(x),a
2359                     ; 454     for(i = 0; i < len; i++){
2361  03a5 1e01          	ldw	x,(OFST-1,sp)
2362  03a7 1c0001        	addw	x,#1
2363  03aa 1f01          	ldw	(OFST-1,sp),x
2365  03ac               L3111:
2368  03ac 1e01          	ldw	x,(OFST-1,sp)
2369  03ae 1307          	cpw	x,(OFST+5,sp)
2370  03b0 25e9          	jrult	L7011
2371                     ; 457 }
2374  03b2 5b04          	addw	sp,#4
2375  03b4 81            	ret
2429                     ; 459 void hal_spi_write(uint8_t *buf, uint16_t len){
2430                     	switch	.text
2431  03b5               _hal_spi_write:
2433  03b5 89            	pushw	x
2434  03b6 89            	pushw	x
2435       00000002      OFST:	set	2
2438                     ; 461     for(i = 0; i < len; i++){
2440  03b7 5f            	clrw	x
2441  03b8 1f01          	ldw	(OFST-1,sp),x
2444  03ba 200f          	jra	L1511
2445  03bc               L5411:
2446                     ; 462         hal_spi_byte(buf[i]);
2448  03bc 1e03          	ldw	x,(OFST+1,sp)
2449  03be 72fb01        	addw	x,(OFST-1,sp)
2450  03c1 f6            	ld	a,(x)
2451  03c2 adac          	call	_hal_spi_byte
2453                     ; 461     for(i = 0; i < len; i++){
2455  03c4 1e01          	ldw	x,(OFST-1,sp)
2456  03c6 1c0001        	addw	x,#1
2457  03c9 1f01          	ldw	(OFST-1,sp),x
2459  03cb               L1511:
2462  03cb 1e01          	ldw	x,(OFST-1,sp)
2463  03cd 1307          	cpw	x,(OFST+5,sp)
2464  03cf 25eb          	jrult	L5411
2465                     ; 464 }
2468  03d1 5b04          	addw	sp,#4
2469  03d3 81            	ret
2528                     ; 488 void w5500_chip_init(void){
2529                     	switch	.text
2530  03d4               _w5500_chip_init:
2532  03d4 88            	push	a
2533       00000001      OFST:	set	1
2536                     ; 492     GPIO_WriteLow(W5500_RST_PORT, W5500_RST_PIN);
2538  03d5 4b20          	push	#32
2539  03d7 ae5014        	ldw	x,#20500
2540  03da cd0000        	call	_GPIO_WriteLow
2542  03dd 84            	pop	a
2543                     ; 493     hal_delay_ms(100);
2545  03de ae0064        	ldw	x,#100
2546  03e1 cd0014        	call	_hal_delay_ms
2548                     ; 494     GPIO_WriteHigh(W5500_RST_PORT, W5500_RST_PIN);
2550  03e4 4b20          	push	#32
2551  03e6 ae5014        	ldw	x,#20500
2552  03e9 cd0000        	call	_GPIO_WriteHigh
2554  03ec 84            	pop	a
2555                     ; 495     hal_delay_ms(100);
2557  03ed ae0064        	ldw	x,#100
2558  03f0 cd0014        	call	_hal_delay_ms
2560                     ; 499     CLK_PeripheralClockConfig(CLK_PERIPHERAL_SPI, ENABLE);
2562  03f3 ae0101        	ldw	x,#257
2563  03f6 cd0000        	call	_CLK_PeripheralClockConfig
2565                     ; 500     GPIO_Init(W5500_SCK_PORT,W5500_SCK_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
2567  03f9 4bf0          	push	#240
2568  03fb 4b20          	push	#32
2569  03fd ae500a        	ldw	x,#20490
2570  0400 cd0000        	call	_GPIO_Init
2572  0403 85            	popw	x
2573                     ; 501     GPIO_Init(W5500_MOSI_PORT,W5500_MOSI_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
2575  0404 4bf0          	push	#240
2576  0406 4b40          	push	#64
2577  0408 ae500a        	ldw	x,#20490
2578  040b cd0000        	call	_GPIO_Init
2580  040e 85            	popw	x
2581                     ; 502     GPIO_Init(W5500_MISO_PORT,W5500_MISO_PIN,GPIO_MODE_IN_FL_NO_IT);
2583  040f 4b00          	push	#0
2584  0411 4b80          	push	#128
2585  0413 ae500a        	ldw	x,#20490
2586  0416 cd0000        	call	_GPIO_Init
2588  0419 85            	popw	x
2589                     ; 504     GPIO_Init(W5500_CS_PORT,W5500_CS_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
2591  041a 4bf0          	push	#240
2592  041c 4b08          	push	#8
2593  041e ae5000        	ldw	x,#20480
2594  0421 cd0000        	call	_GPIO_Init
2596  0424 85            	popw	x
2597                     ; 505     GPIO_WriteHigh(W5500_CS_PORT, W5500_CS_PIN);
2599  0425 4b08          	push	#8
2600  0427 ae5000        	ldw	x,#20480
2601  042a cd0000        	call	_GPIO_WriteHigh
2603  042d 84            	pop	a
2604                     ; 507     GPIO_Init(W5500_RST_PORT,W5500_RST_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
2606  042e 4bf0          	push	#240
2607  0430 4b20          	push	#32
2608  0432 ae5014        	ldw	x,#20500
2609  0435 cd0000        	call	_GPIO_Init
2611  0438 85            	popw	x
2612                     ; 508     GPIO_Init(W5500_INT_PORT,W5500_INT_PIN,GPIO_MODE_IN_FL_NO_IT);
2614  0439 4b00          	push	#0
2615  043b 4b10          	push	#16
2616  043d ae5019        	ldw	x,#20505
2617  0440 cd0000        	call	_GPIO_Init
2619  0443 85            	popw	x
2620                     ; 509     SPI_DeInit();
2622  0444 cd0000        	call	_SPI_DeInit
2624                     ; 510     SPI_Init(
2624                     ; 511         SPI_FIRSTBIT_MSB,
2624                     ; 512         SPI_BAUDRATEPRESCALER_4,
2624                     ; 513         SPI_MODE_MASTER,
2624                     ; 514         SPI_CLOCKPOLARITY_LOW,
2624                     ; 515         SPI_CLOCKPHASE_1EDGE,
2624                     ; 516         SPI_DATADIRECTION_2LINES_FULLDUPLEX,
2624                     ; 517         SPI_NSS_SOFT,
2624                     ; 518         0x07
2624                     ; 519     );
2626  0447 4b07          	push	#7
2627  0449 4b02          	push	#2
2628  044b 4b00          	push	#0
2629  044d 4b00          	push	#0
2630  044f 4b00          	push	#0
2631  0451 4b04          	push	#4
2632  0453 ae0008        	ldw	x,#8
2633  0456 cd0000        	call	_SPI_Init
2635  0459 5b06          	addw	sp,#6
2636                     ; 520     SPI_Cmd(ENABLE);
2638  045b a601          	ld	a,#1
2639  045d cd0000        	call	_SPI_Cmd
2641                     ; 522    reg_wizchip_spi_cbfunc(hal_spi_read_byte,hal_spi_write_byte);
2643  0460 ae0391        	ldw	x,#_hal_spi_write_byte
2644  0463 89            	pushw	x
2645  0464 ae038c        	ldw	x,#_hal_spi_read_byte
2646  0467 cd0000        	call	_reg_wizchip_spi_cbfunc
2648  046a 85            	popw	x
2649                     ; 523    reg_wizchip_spiburst_cbfunc(hal_spi_read,hal_spi_write);
2651  046b ae03b5        	ldw	x,#_hal_spi_write
2652  046e 89            	pushw	x
2653  046f ae0394        	ldw	x,#_hal_spi_read
2654  0472 cd0000        	call	_reg_wizchip_spiburst_cbfunc
2656  0475 85            	popw	x
2657                     ; 524    reg_wizchip_cs_cbfunc(hal_spi_cs_low,hal_spi_cs_high);
2659  0476 ae008f        	ldw	x,#_hal_spi_cs_high
2660  0479 89            	pushw	x
2661  047a ae0085        	ldw	x,#_hal_spi_cs_low
2662  047d cd0000        	call	_reg_wizchip_cs_cbfunc
2664  0480 85            	popw	x
2665                     ; 525    wizchip_init(0, 0); 
2667  0481 5f            	clrw	x
2668  0482 89            	pushw	x
2669  0483 5f            	clrw	x
2670  0484 cd0000        	call	_wizchip_init
2672  0487 85            	popw	x
2673                     ; 526    version = getVERSIONR();
2675  0488 ae3900        	ldw	x,#14592
2676  048b 89            	pushw	x
2677  048c ae0000        	ldw	x,#0
2678  048f 89            	pushw	x
2679  0490 cd0000        	call	_WIZCHIP_READ
2681  0493 5b04          	addw	sp,#4
2682  0495 6b01          	ld	(OFST+0,sp),a
2684                     ; 527    if(version != 0x04)
2686  0497 7b01          	ld	a,(OFST+0,sp)
2687  0499 a104          	cp	a,#4
2688  049b 2702          	jreq	L3711
2689  049d               L5711:
2690                     ; 529         while(1);
2692  049d 20fe          	jra	L5711
2693  049f               L3711:
2694                     ; 531 }
2697  049f 84            	pop	a
2698  04a0 81            	ret
2744                     ; 533 void tcp_server_process(void){
2745                     	switch	.text
2746  04a1               _tcp_server_process:
2748  04a1 5203          	subw	sp,#3
2749       00000003      OFST:	set	3
2752                     ; 534     uint16_t received_len = 0;
2754                     ; 537     if(server_state == TCP_STATE_IDLE){
2756  04a3 3d18          	tnz	L11_server_state
2757  04a5 271a          	jreq	L631
2758                     ; 538         return;
2760                     ; 540     sock_status = getSn_SR(server_socket);
2762  04a7 b61c          	ld	a,L71_server_socket
2763  04a9 97            	ld	xl,a
2764  04aa a604          	ld	a,#4
2765  04ac 42            	mul	x,a
2766  04ad 58            	sllw	x
2767  04ae 58            	sllw	x
2768  04af 58            	sllw	x
2769  04b0 1c0308        	addw	x,#776
2770  04b3 cd0000        	call	c_itolx
2772  04b6 be02          	ldw	x,c_lreg+2
2773  04b8 89            	pushw	x
2774  04b9 be00          	ldw	x,c_lreg
2775  04bb 89            	pushw	x
2776  04bc cd0000        	call	_WIZCHIP_READ
2778  04bf 5b04          	addw	sp,#4
2779                     ; 541 }
2780  04c1               L631:
2783  04c1 5b03          	addw	sp,#3
2784  04c3 81            	ret
2787                     	switch	.const
2788  0008               L7221_mac:
2789  0008 00            	dc.b	0
2790  0009 08            	dc.b	8
2791  000a dc            	dc.b	220
2792  000b 12            	dc.b	18
2793  000c 34            	dc.b	52
2794  000d 56            	dc.b	86
2795  000e               L1321_gw:
2796  000e c0            	dc.b	192
2797  000f a8            	dc.b	168
2798  0010 01            	dc.b	1
2799  0011 01            	dc.b	1
2800  0012               L3321_sn:
2801  0012 ff            	dc.b	255
2802  0013 ff            	dc.b	255
2803  0014 ff            	dc.b	255
2804  0015 00            	dc.b	0
2805  0016               L5321_ip:
2806  0016 c0            	dc.b	192
2807  0017 a8            	dc.b	168
2808  0018 01            	dc.b	1
2809  0019 64            	dc.b	100
2873                     ; 584 static void w5500_init_network(void)
2873                     ; 585 {
2874                     	switch	.text
2875  04c4               L5221_w5500_init_network:
2877  04c4 5212          	subw	sp,#18
2878       00000012      OFST:	set	18
2881                     ; 586     uint8_t mac[6] = {0x00,0x08,0xDC,0x12,0x34,0x56};
2883  04c6 96            	ldw	x,sp
2884  04c7 1c0001        	addw	x,#OFST-17
2885  04ca 90ae0008      	ldw	y,#L7221_mac
2886  04ce a606          	ld	a,#6
2887  04d0 cd0000        	call	c_xymov
2889                     ; 587     uint8_t gw[4]  = {192,168,1,1};
2891  04d3 96            	ldw	x,sp
2892  04d4 1c0007        	addw	x,#OFST-11
2893  04d7 90ae000e      	ldw	y,#L1321_gw
2894  04db a604          	ld	a,#4
2895  04dd cd0000        	call	c_xymov
2897                     ; 588     uint8_t sn[4]  = {255,255,255,0};
2899  04e0 96            	ldw	x,sp
2900  04e1 1c000b        	addw	x,#OFST-7
2901  04e4 90ae0012      	ldw	y,#L3321_sn
2902  04e8 a604          	ld	a,#4
2903  04ea cd0000        	call	c_xymov
2905                     ; 589     uint8_t ip[4]  = {192,168,1,100};
2907  04ed 96            	ldw	x,sp
2908  04ee 1c000f        	addw	x,#OFST-3
2909  04f1 90ae0016      	ldw	y,#L5321_ip
2910  04f5 a604          	ld	a,#4
2911  04f7 cd0000        	call	c_xymov
2913                     ; 591     setSHAR(mac);
2915  04fa ae0006        	ldw	x,#6
2916  04fd 89            	pushw	x
2917  04fe 96            	ldw	x,sp
2918  04ff 1c0003        	addw	x,#OFST-15
2919  0502 89            	pushw	x
2920  0503 ae0900        	ldw	x,#2304
2921  0506 89            	pushw	x
2922  0507 ae0000        	ldw	x,#0
2923  050a 89            	pushw	x
2924  050b cd0000        	call	_WIZCHIP_WRITE_BUF
2926  050e 5b08          	addw	sp,#8
2927                     ; 592     setGAR(gw);
2929  0510 ae0004        	ldw	x,#4
2930  0513 89            	pushw	x
2931  0514 96            	ldw	x,sp
2932  0515 1c0009        	addw	x,#OFST-9
2933  0518 89            	pushw	x
2934  0519 ae0100        	ldw	x,#256
2935  051c 89            	pushw	x
2936  051d ae0000        	ldw	x,#0
2937  0520 89            	pushw	x
2938  0521 cd0000        	call	_WIZCHIP_WRITE_BUF
2940  0524 5b08          	addw	sp,#8
2941                     ; 593     setSUBR(sn);
2943  0526 ae0004        	ldw	x,#4
2944  0529 89            	pushw	x
2945  052a 96            	ldw	x,sp
2946  052b 1c000d        	addw	x,#OFST-5
2947  052e 89            	pushw	x
2948  052f ae0500        	ldw	x,#1280
2949  0532 89            	pushw	x
2950  0533 ae0000        	ldw	x,#0
2951  0536 89            	pushw	x
2952  0537 cd0000        	call	_WIZCHIP_WRITE_BUF
2954  053a 5b08          	addw	sp,#8
2955                     ; 594     setSIPR(ip);
2957  053c ae0004        	ldw	x,#4
2958  053f 89            	pushw	x
2959  0540 96            	ldw	x,sp
2960  0541 1c0011        	addw	x,#OFST-1
2961  0544 89            	pushw	x
2962  0545 ae0f00        	ldw	x,#3840
2963  0548 89            	pushw	x
2964  0549 ae0000        	ldw	x,#0
2965  054c 89            	pushw	x
2966  054d cd0000        	call	_WIZCHIP_WRITE_BUF
2968  0550 5b08          	addw	sp,#8
2969                     ; 595 }
2972  0552 5b12          	addw	sp,#18
2973  0554 81            	ret
3013                     ; 597 void tcp_server_init(uint16_t port)
3013                     ; 598 {
3014                     	switch	.text
3015  0555               _tcp_server_init:
3019                     ; 599     server_port = port;
3021  0555 bf1a          	ldw	L51_server_port,x
3022                     ; 600     server_state = TCP_STATE_IDLE;
3024  0557 3f18          	clr	L11_server_state
3025                     ; 603     w5500_init_network();
3027  0559 cd04c4        	call	L5221_w5500_init_network
3029                     ; 604     if (socket(server_socket, Sn_MR_TCP, server_port, 0) == server_socket){
3031  055c 4b00          	push	#0
3032  055e be1a          	ldw	x,L51_server_port
3033  0560 89            	pushw	x
3034  0561 b61c          	ld	a,L71_server_socket
3035  0563 ae0001        	ldw	x,#1
3036  0566 95            	ld	xh,a
3037  0567 cd0000        	call	_socket
3039  056a 5b03          	addw	sp,#3
3040  056c 5f            	clrw	x
3041  056d 4d            	tnz	a
3042  056e 2a01          	jrpl	L441
3043  0570 53            	cplw	x
3044  0571               L441:
3045  0571 97            	ld	xl,a
3046  0572 b61c          	ld	a,L71_server_socket
3047  0574 905f          	clrw	y
3048  0576 9097          	ld	yl,a
3049  0578 90bf00        	ldw	c_y,y
3050  057b b300          	cpw	x,c_y
3051  057d 260d          	jrne	L7031
3052                     ; 605         if (listen(server_socket) == SOCK_OK){
3054  057f b61c          	ld	a,L71_server_socket
3055  0581 cd0000        	call	_listen
3057  0584 a101          	cp	a,#1
3058  0586 2604          	jrne	L7031
3059                     ; 606             server_state = TCP_STATE_LISTENING;
3061  0588 35010018      	mov	L11_server_state,#1
3062  058c               L7031:
3063                     ; 609 }
3066  058c 81            	ret
3094                     ; 611 void hal_timer_init(void){
3095                     	switch	.text
3096  058d               _hal_timer_init:
3100                     ; 612     CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER4, ENABLE);
3102  058d ae0401        	ldw	x,#1025
3103  0590 cd0000        	call	_CLK_PeripheralClockConfig
3105                     ; 613     TIM4_TimeBaseInit(TIM4_PRESCALER_128, 125);
3107  0593 ae077d        	ldw	x,#1917
3108  0596 cd0000        	call	_TIM4_TimeBaseInit
3110                     ; 614     TIM4_ClearFlag(TIM4_FLAG_UPDATE);
3112  0599 a601          	ld	a,#1
3113  059b cd0000        	call	_TIM4_ClearFlag
3115                     ; 616     TIM4_ITConfig(TIM4_IT_UPDATE, ENABLE);
3117  059e ae0101        	ldw	x,#257
3118  05a1 cd0000        	call	_TIM4_ITConfig
3120                     ; 618     enableInterrupts();
3123  05a4 9a            rim
3125                     ; 619 }
3129  05a5 81            	ret
3164                     ; 621 void system_init(void){
3165                     	switch	.text
3166  05a6               _system_init:
3170                     ; 623     CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);  /* 16MHz clock */
3172  05a6 4f            	clr	a
3173  05a7 cd0000        	call	_CLK_HSIPrescalerConfig
3175                     ; 626 	hal_gpio_init();
3177  05aa cd029c        	call	_hal_gpio_init
3179                     ; 627     hal_timer_init();
3181  05ad adde          	call	_hal_timer_init
3183                     ; 630 	relay_control_init();
3185  05af cd028c        	call	_relay_control_init
3187                     ; 631 	sensor_reader_init();
3189  05b2 cd01d7        	call	_sensor_reader_init
3191                     ; 633     w5500_chip_init();
3193  05b5 cd03d4        	call	_w5500_chip_init
3195                     ; 635     tcp_server_init(TCP_SERVER_PORT);
3197  05b8 ae1388        	ldw	x,#5000
3198  05bb ad98          	call	_tcp_server_init
3200                     ; 639     hal_timer_set_callback(timer_callback);
3202  05bd ae01d8        	ldw	x,#_timer_callback
3203  05c0 cd021a        	call	_hal_timer_set_callback
3205                     ; 640     hal_timer_start();
3207  05c3 cd01d1        	call	_hal_timer_start
3209                     ; 641 	hal_delay_ms(500);
3211  05c6 ae01f4        	ldw	x,#500
3212  05c9 cd0014        	call	_hal_delay_ms
3214                     ; 642 }
3217  05cc 81            	ret
3220                     	switch	.const
3221  001a               L3331_msg:
3222  001a 52455345542c  	dc.b	"RESET, OK",10,0
3260                     ; 645 void main_loop(void)
3260                     ; 646 {
3261                     	switch	.text
3262  05cd               _main_loop:
3264  05cd 520b          	subw	sp,#11
3265       0000000b      OFST:	set	11
3268  05cf               L3531:
3269                     ; 650 		tcp_server_process();
3271  05cf cd04a1        	call	_tcp_server_process
3273                     ; 655         if(GPIO_ReadInputPin(HARDRST_PORT, HARDRST_PIN) == RESET)
3275  05d2 4b80          	push	#128
3276  05d4 ae5005        	ldw	x,#20485
3277  05d7 cd0000        	call	_GPIO_ReadInputPin
3279  05da 5b01          	addw	sp,#1
3280  05dc 4d            	tnz	a
3281  05dd 26f0          	jrne	L3531
3282                     ; 657             hal_delay_ms(50);
3284  05df ae0032        	ldw	x,#50
3285  05e2 cd0014        	call	_hal_delay_ms
3287                     ; 658 			if (GPIO_ReadInputPin(HARDRST_PORT, HARDRST_PIN) == 0){
3289  05e5 4b80          	push	#128
3290  05e7 ae5005        	ldw	x,#20485
3291  05ea cd0000        	call	_GPIO_ReadInputPin
3293  05ed 5b01          	addw	sp,#1
3294  05ef 4d            	tnz	a
3295  05f0 26dd          	jrne	L3531
3296                     ; 660 				char msg[] = "RESET, OK\n";
3298  05f2 96            	ldw	x,sp
3299  05f3 1c0001        	addw	x,#OFST-10
3300  05f6 90ae001a      	ldw	y,#L3331_msg
3301  05fa a60b          	ld	a,#11
3302  05fc cd0000        	call	c_xymov
3304                     ; 661                 if(tcp_server_is_connected()){
3306  05ff cd0007        	call	_tcp_server_is_connected
3308  0602 a30000        	cpw	x,#0
3309                     ; 664                 if (uart_server_is_ready()){
3311  0605 cd0041        	call	_uart_server_is_ready
3313  0608 a30000        	cpw	x,#0
3314                     ; 667 				hal_delay_ms(100);
3316  060b ae0064        	ldw	x,#100
3317  060e cd0014        	call	_hal_delay_ms
3319  0611 20bc          	jra	L3531
3344                     ; 676 int main(void)
3344                     ; 677 {
3345                     	switch	.text
3346  0613               _main:
3350                     ; 678 	system_init();
3352  0613 ad91          	call	_system_init
3354                     ; 679     main_loop();
3356  0615 adb6          	call	_main_loop
3358  0617               L7731:
3359                     ; 680     while(1);
3361  0617 20fe          	jra	L7731
3650                     	xdef	_main
3651                     	xdef	_main_loop
3652                     	xdef	_system_init
3653                     	xdef	_hal_timer_init
3654                     	xdef	_tcp_server_init
3655                     	xdef	_tcp_server_process
3656                     	xdef	_w5500_chip_init
3657                     	xdef	_hal_spi_write
3658                     	xdef	_hal_spi_read
3659                     	xdef	_hal_spi_write_byte
3660                     	xdef	_hal_spi_read_byte
3661                     	xdef	_hal_spi_byte
3662                     	xdef	_hal_uart_read_byte
3663                     	xdef	_hal_uart_available
3664                     	xdef	_hal_gpio_init
3665                     	xdef	_hal_w5500_reset_high
3666                     	xdef	_relay_control_init
3667                     	xdef	_command_parser_execute
3668                     	xdef	_hal_timer_set_callback
3669                     	xdef	_timer_callback
3670                     	xdef	_sensor_reader_init
3671                     	xdef	_hal_timer_start
3672                     	xdef	_message_formatter_avcc
3673                     	xdef	_relay_control_set_all
3674                     	xdef	_relay_control_set
3675                     	xdef	_hal_relay_set
3676                     	xdef	_hal_di_read
3677                     	xdef	_sensor_reader_get_state
3678                     	xdef	_hal_spi_cs_high
3679                     	xdef	_hal_spi_cs_low
3680                     	xdef	_hal_uart_send
3681                     	xdef	_hal_uart_send_byte
3682                     	xdef	_uart_server_is_ready
3683                     	xdef	_hal_delay_ms
3684                     	xdef	_tcp_server_is_connected
3685                     	xdef	_hal_get_millis
3686                     	switch	.ubsct
3687  0000               L13_uart_rx_buffer:
3688  0000 000000000000  	ds.b	20
3689                     	xref	_listen
3690                     	xref	_socket
3691                     	xref	_wizchip_init
3692                     	xref	_reg_wizchip_spiburst_cbfunc
3693                     	xref	_reg_wizchip_cs_cbfunc
3694                     	xref	_reg_wizchip_spi_cbfunc
3695                     	xref	_WIZCHIP_WRITE_BUF
3696                     	xref	_WIZCHIP_READ
3697                     	xref	_TIM4_ClearFlag
3698                     	xref	_TIM4_ITConfig
3699                     	xref	_TIM4_Cmd
3700                     	xref	_TIM4_TimeBaseInit
3701                     	xref	_SPI_GetFlagStatus
3702                     	xref	_SPI_ReceiveData
3703                     	xref	_SPI_SendData
3704                     	xref	_SPI_Cmd
3705                     	xref	_SPI_Init
3706                     	xref	_SPI_DeInit
3707                     	xref	_UART1_GetFlagStatus
3708                     	xref	_UART1_SendData8
3709                     	xref	_GPIO_ReadInputPin
3710                     	xref	_GPIO_WriteLow
3711                     	xref	_GPIO_WriteHigh
3712                     	xref	_GPIO_Init
3713                     	xref	_CLK_HSIPrescalerConfig
3714                     	xref	_CLK_PeripheralClockConfig
3715                     	xref.b	c_lreg
3716                     	xref.b	c_x
3717                     	xref.b	c_y
3737                     	xref	c_itolx
3738                     	xref	c_xymov
3739                     	xref	c_lcmp
3740                     	xref	c_lsub
3741                     	xref	c_uitolx
3742                     	xref	c_rtol
3743                     	xref	c_ltor
3744                     	end
