   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  14                     	bsct
  15  0000               L3_sock_any_port:
  16  0000 c000          	dc.w	-16384
  46                     	bsct
  47  0002               L12_axle_counter:
  48  0002 00            	dc.b	0
  49  0003 00            	dc.b	0
  50  0004 00            	dc.b	0
  51  0005 00            	dc.b	0
  52  0006 00000000      	dc.l	0
  53  000a               L32_server_state:
  54  000a 00            	dc.b	0
  55  000b               L52_task_timer:
  56  000b 00000000      	dc.l	0
  57  000f 00000000      	dc.l	0
  58  0013 00000000      	dc.l	0
  59  0017               L72_current_state:
  60  0017 00            	dc.b	0
  61  0018 00            	dc.b	0
  62  0019 00            	dc.b	0
  63  001a 00            	dc.b	0
  64  001b               L13_uart_state:
  65  001b 00            	dc.b	0
  66  001c               L33_server_socket:
  67  001c 00            	dc.b	0
  68  001d               L53_server_port:
  69  001d 1388          	dc.w	5000
  70  001f               _uart_rx_count:
  71  001f 00            	dc.b	0
  72  0020               _uart_rx_head:
  73  0020 00            	dc.b	0
  74  0021               _uart_rx_tail:
  75  0021 00            	dc.b	0
  76  0022               _systick_ms:
  77  0022 00000000      	dc.l	0
  78  0026               _user_callback:
  79  0026 0000          	dc.w	0
 109                     ; 74 unsigned long hal_get_millis(void)
 109                     ; 75 {
 111                     	switch	.text
 112  0000               _hal_get_millis:
 116                     ; 76     return systick_ms;
 118  0000 ae0022        	ldw	x,#_systick_ms
 119  0003 cd0000        	call	c_ltor
 123  0006 81            	ret
 148                     ; 78 int tcp_server_is_connected(void)
 148                     ; 79 {
 149                     	switch	.text
 150  0007               _tcp_server_is_connected:
 154                     ; 80     return (server_state == TCP_STATE_CONNECTED) ? 1 : 0;
 156  0007 b60a          	ld	a,L32_server_state
 157  0009 a102          	cp	a,#2
 158  000b 2605          	jrne	L01
 159  000d ae0001        	ldw	x,#1
 160  0010 2001          	jra	L21
 161  0012               L01:
 162  0012 5f            	clrw	x
 163  0013               L21:
 166  0013 81            	ret
 210                     ; 82 void hal_delay_ms(unsigned int ms)
 210                     ; 83 {
 211                     	switch	.text
 212  0014               _hal_delay_ms:
 214  0014 89            	pushw	x
 215  0015 5208          	subw	sp,#8
 216       00000008      OFST:	set	8
 219                     ; 84     unsigned long start = hal_get_millis();
 221  0017 ade7          	call	_hal_get_millis
 223  0019 96            	ldw	x,sp
 224  001a 1c0005        	addw	x,#OFST-3
 225  001d cd0000        	call	c_rtol
 229  0020               L511:
 230                     ; 85     while ((hal_get_millis() - start) < ms);
 232  0020 adde          	call	_hal_get_millis
 234  0022 96            	ldw	x,sp
 235  0023 1c0005        	addw	x,#OFST-3
 236  0026 cd0000        	call	c_lsub
 238  0029 96            	ldw	x,sp
 239  002a 1c0001        	addw	x,#OFST-7
 240  002d cd0000        	call	c_rtol
 243  0030 1e09          	ldw	x,(OFST+1,sp)
 244  0032 cd0000        	call	c_uitolx
 246  0035 96            	ldw	x,sp
 247  0036 1c0001        	addw	x,#OFST-7
 248  0039 cd0000        	call	c_lcmp
 250  003c 22e2          	jrugt	L511
 251                     ; 86 }
 254  003e 5b0a          	addw	sp,#10
 255  0040 81            	ret
 313                     ; 87 int tcp_server_send(const uint8_t *data, uint16_t len)
 313                     ; 88 {
 314                     	switch	.text
 315  0041               _tcp_server_send:
 317  0041 89            	pushw	x
 318  0042 89            	pushw	x
 319       00000002      OFST:	set	2
 322                     ; 91     if (server_state != TCP_STATE_CONNECTED) {
 324  0043 b60a          	ld	a,L32_server_state
 325  0045 a102          	cp	a,#2
 326  0047 2705          	jreq	L741
 327                     ; 92         return -1;
 329  0049 aeffff        	ldw	x,#65535
 331  004c 203c          	jra	L03
 332  004e               L741:
 333                     ; 95     if (len > TCP_TX_BUFFER) {
 335  004e 1e07          	ldw	x,(OFST+5,sp)
 336  0050 a30011        	cpw	x,#17
 337  0053 2505          	jrult	L151
 338                     ; 96         len = TCP_TX_BUFFER;
 340  0055 ae0010        	ldw	x,#16
 341  0058 1f07          	ldw	(OFST+5,sp),x
 342  005a               L151:
 343                     ; 100     memcpy(tx_buffer, data, len);
 345  005a 1e03          	ldw	x,(OFST+1,sp)
 346  005c bf00          	ldw	c_x,x
 347  005e 1e07          	ldw	x,(OFST+5,sp)
 348  0060 5d            	tnzw	x
 349  0061 2709          	jreq	L02
 350  0063               L22:
 351  0063 5a            	decw	x
 352  0064 92d600        	ld	a,([c_x.w],x)
 353  0067 e716          	ld	(_tx_buffer,x),a
 354  0069 5d            	tnzw	x
 355  006a 26f7          	jrne	L22
 356  006c               L02:
 357                     ; 103     sent = send(server_socket, tx_buffer, len);
 359  006c 1e07          	ldw	x,(OFST+5,sp)
 360  006e 89            	pushw	x
 361  006f ae0016        	ldw	x,#_tx_buffer
 362  0072 89            	pushw	x
 363  0073 b61c          	ld	a,L33_server_socket
 364  0075 cd0000        	call	_send
 366  0078 5b04          	addw	sp,#4
 367  007a be02          	ldw	x,c_lreg+2
 368  007c 1f01          	ldw	(OFST-1,sp),x
 370                     ; 105     return (sent == len) ? 0 : -1;
 372  007e 1e01          	ldw	x,(OFST-1,sp)
 373  0080 1307          	cpw	x,(OFST+5,sp)
 374  0082 2603          	jrne	L42
 375  0084 5f            	clrw	x
 376  0085 2003          	jra	L62
 377  0087               L42:
 378  0087 aeffff        	ldw	x,#65535
 379  008a               L62:
 381  008a               L03:
 383  008a 5b04          	addw	sp,#4
 384  008c 81            	ret
 409                     ; 108 int uart_server_is_ready(void){
 410                     	switch	.text
 411  008d               _uart_server_is_ready:
 415                     ; 109     return (uart_state != UART_STATE_IDLE) ? 1 : 0;
 417  008d 3d1b          	tnz	L13_uart_state
 418  008f 2705          	jreq	L43
 419  0091 ae0001        	ldw	x,#1
 420  0094 2001          	jra	L63
 421  0096               L43:
 422  0096 5f            	clrw	x
 423  0097               L63:
 426  0097 81            	ret
 462                     ; 112 void hal_uart_send_byte(uint8_t byte){
 463                     	switch	.text
 464  0098               _hal_uart_send_byte:
 466  0098 88            	push	a
 467       00000000      OFST:	set	0
 470  0099               L302:
 471                     ; 113     while (UART1_GetFlagStatus(UART1_FLAG_TXE) == RESET);
 473  0099 ae0080        	ldw	x,#128
 474  009c cd0000        	call	_UART1_GetFlagStatus
 476  009f 4d            	tnz	a
 477  00a0 27f7          	jreq	L302
 478                     ; 116     UART1_SendData8(byte);
 480  00a2 7b01          	ld	a,(OFST+1,sp)
 481  00a4 cd0000        	call	_UART1_SendData8
 484  00a7               L112:
 485                     ; 119     while (UART1_GetFlagStatus(UART1_FLAG_TC) == RESET);
 487  00a7 ae0040        	ldw	x,#64
 488  00aa cd0000        	call	_UART1_GetFlagStatus
 490  00ad 4d            	tnz	a
 491  00ae 27f7          	jreq	L112
 492                     ; 120 }
 495  00b0 84            	pop	a
 496  00b1 81            	ret
 550                     ; 122 void hal_uart_send(const uint8_t *data, uint16_t len){
 551                     	switch	.text
 552  00b2               _hal_uart_send:
 554  00b2 89            	pushw	x
 555  00b3 89            	pushw	x
 556       00000002      OFST:	set	2
 559                     ; 124     for(i = 0; i < len; i++){
 561  00b4 5f            	clrw	x
 562  00b5 1f01          	ldw	(OFST-1,sp),x
 565  00b7 200f          	jra	L742
 566  00b9               L342:
 567                     ; 125         hal_uart_send_byte(data[i]);
 569  00b9 1e03          	ldw	x,(OFST+1,sp)
 570  00bb 72fb01        	addw	x,(OFST-1,sp)
 571  00be f6            	ld	a,(x)
 572  00bf add7          	call	_hal_uart_send_byte
 574                     ; 124     for(i = 0; i < len; i++){
 576  00c1 1e01          	ldw	x,(OFST-1,sp)
 577  00c3 1c0001        	addw	x,#1
 578  00c6 1f01          	ldw	(OFST-1,sp),x
 580  00c8               L742:
 583  00c8 1e01          	ldw	x,(OFST-1,sp)
 584  00ca 1307          	cpw	x,(OFST+5,sp)
 585  00cc 25eb          	jrult	L342
 586                     ; 127 }
 589  00ce 5b04          	addw	sp,#4
 590  00d0 81            	ret
 614                     ; 128 void hal_spi_cs_low(void)
 614                     ; 129 {
 615                     	switch	.text
 616  00d1               _hal_spi_cs_low:
 620                     ; 130     GPIO_WriteLow(W5500_CS_PORT, W5500_CS_PIN);
 622  00d1 4b08          	push	#8
 623  00d3 ae5000        	ldw	x,#20480
 624  00d6 cd0000        	call	_GPIO_WriteLow
 626  00d9 84            	pop	a
 627                     ; 131 }
 630  00da 81            	ret
 654                     ; 133 void hal_spi_cs_high(void)
 654                     ; 134 {
 655                     	switch	.text
 656  00db               _hal_spi_cs_high:
 660                     ; 135     GPIO_WriteHigh(W5500_CS_PORT, W5500_CS_PIN);
 662  00db 4b08          	push	#8
 663  00dd ae5000        	ldw	x,#20480
 664  00e0 cd0000        	call	_GPIO_WriteHigh
 666  00e3 84            	pop	a
 667                     ; 136 }
 670  00e4 81            	ret
 718                     ; 137 int uart_server_send(const uint8_t *data, uint16_t len)
 718                     ; 138 {
 719                     	switch	.text
 720  00e5               _uart_server_send:
 722  00e5 89            	pushw	x
 723       00000000      OFST:	set	0
 726                     ; 139     if (uart_state == UART_STATE_IDLE) {
 728  00e6 3d1b          	tnz	L13_uart_state
 729  00e8 2605          	jrne	L513
 730                     ; 140         return -1;
 732  00ea aeffff        	ldw	x,#65535
 734  00ed 2028          	jra	L65
 735  00ef               L513:
 736                     ; 143     if (len > sizeof(uart_tx_buffer)) {
 738  00ef 1e05          	ldw	x,(OFST+5,sp)
 739  00f1 a30011        	cpw	x,#17
 740  00f4 2505          	jrult	L713
 741                     ; 144         len = sizeof(uart_tx_buffer);
 743  00f6 ae0010        	ldw	x,#16
 744  00f9 1f05          	ldw	(OFST+5,sp),x
 745  00fb               L713:
 746                     ; 148     memcpy(uart_tx_buffer, data, len);
 748  00fb 1e01          	ldw	x,(OFST+1,sp)
 749  00fd bf00          	ldw	c_x,x
 750  00ff 1e05          	ldw	x,(OFST+5,sp)
 751  0101 5d            	tnzw	x
 752  0102 2709          	jreq	L25
 753  0104               L45:
 754  0104 5a            	decw	x
 755  0105 92d600        	ld	a,([c_x.w],x)
 756  0108 e706          	ld	(L73_uart_tx_buffer,x),a
 757  010a 5d            	tnzw	x
 758  010b 26f7          	jrne	L45
 759  010d               L25:
 760                     ; 149     hal_uart_send(uart_tx_buffer, len);
 762  010d 1e05          	ldw	x,(OFST+5,sp)
 763  010f 89            	pushw	x
 764  0110 ae0006        	ldw	x,#L73_uart_tx_buffer
 765  0113 ad9d          	call	_hal_uart_send
 767  0115 85            	popw	x
 768                     ; 151     return 0;
 770  0116 5f            	clrw	x
 772  0117               L65:
 774  0117 5b02          	addw	sp,#2
 775  0119 81            	ret
 836                     ; 153 sensor_state_t sensor_reader_get_state(void)
 836                     ; 154 {
 837                     	switch	.text
 838  011a               _sensor_reader_get_state:
 840       00000000      OFST:	set	0
 843                     ; 155     return current_state;
 845  011a 1e03          	ldw	x,(OFST+3,sp)
 846  011c 90ae0017      	ldw	y,#L72_current_state
 847  0120 a604          	ld	a,#4
 848  0122 cd0000        	call	c_xymov
 852  0125 81            	ret
 933                     ; 158 void message_formatter_alive(char *buf,
 933                     ; 159                              int buf_size,
 933                     ; 160                              uint8_t di1,
 933                     ; 161                              uint8_t di2,
 933                     ; 162                              uint8_t di3,
 933                     ; 163                              uint8_t di4)
 933                     ; 164 {
 934                     	switch	.text
 935  0126               _message_formatter_alive:
 937  0126 89            	pushw	x
 938       00000000      OFST:	set	0
 941                     ; 165     if(buf == 0)
 943  0127 a30000        	cpw	x,#0
 944  012a 2708          	jreq	L401
 945                     ; 166         return;
 947                     ; 168     if(buf_size < 5)
 949  012c 9c            	rvf
 950  012d 1e05          	ldw	x,(OFST+5,sp)
 951  012f a30005        	cpw	x,#5
 952  0132 2e02          	jrsge	L114
 953                     ; 169         return;
 954  0134               L401:
 957  0134 85            	popw	x
 958  0135 81            	ret
 959  0136               L114:
 960                     ; 171     buf[0] = di1 ? '1' : '0';
 962  0136 0d07          	tnz	(OFST+7,sp)
 963  0138 2704          	jreq	L46
 964  013a a631          	ld	a,#49
 965  013c 2002          	jra	L66
 966  013e               L46:
 967  013e a630          	ld	a,#48
 968  0140               L66:
 969  0140 1e01          	ldw	x,(OFST+1,sp)
 970  0142 f7            	ld	(x),a
 971                     ; 172     buf[1] = di2 ? '1' : '0';
 973  0143 0d08          	tnz	(OFST+8,sp)
 974  0145 2704          	jreq	L07
 975  0147 a631          	ld	a,#49
 976  0149 2002          	jra	L27
 977  014b               L07:
 978  014b a630          	ld	a,#48
 979  014d               L27:
 980  014d 1e01          	ldw	x,(OFST+1,sp)
 981  014f e701          	ld	(1,x),a
 982                     ; 173     buf[2] = di3 ? '1' : '0';
 984  0151 0d09          	tnz	(OFST+9,sp)
 985  0153 2704          	jreq	L47
 986  0155 a631          	ld	a,#49
 987  0157 2002          	jra	L67
 988  0159               L47:
 989  0159 a630          	ld	a,#48
 990  015b               L67:
 991  015b 1e01          	ldw	x,(OFST+1,sp)
 992  015d e702          	ld	(2,x),a
 993                     ; 174     buf[3] = di4 ? '1' : '0';
 995  015f 0d0a          	tnz	(OFST+10,sp)
 996  0161 2704          	jreq	L001
 997  0163 a631          	ld	a,#49
 998  0165 2002          	jra	L201
 999  0167               L001:
1000  0167 a630          	ld	a,#48
1001  0169               L201:
1002  0169 1e01          	ldw	x,(OFST+1,sp)
1003  016b e703          	ld	(3,x),a
1004                     ; 175     buf[4] = '\0';
1006  016d 1e01          	ldw	x,(OFST+1,sp)
1007  016f 6f04          	clr	(4,x)
1008                     ; 176 }
1010  0171 20c1          	jra	L401
1202                     ; 178 uint8_t hal_di_read(uint8_t di_num)
1202                     ; 179 {
1203                     	switch	.text
1204  0173               _hal_di_read:
1206  0173 5203          	subw	sp,#3
1207       00000003      OFST:	set	3
1210                     ; 183     switch (di_num) {
1213                     ; 188         default: return 0;
1214  0175 4a            	dec	a
1215  0176 270c          	jreq	L314
1216  0178 4a            	dec	a
1217  0179 2714          	jreq	L514
1218  017b 4a            	dec	a
1219  017c 271c          	jreq	L714
1220  017e 4a            	dec	a
1221  017f 2724          	jreq	L124
1222  0181               L324:
1225  0181 4f            	clr	a
1227  0182 203d          	jra	L411
1228  0184               L314:
1229                     ; 184         case 1: port = DI1_PORT; pin = DI1_PIN; break;
1231  0184 ae500f        	ldw	x,#20495
1232  0187 1f01          	ldw	(OFST-2,sp),x
1236  0189 a604          	ld	a,#4
1237  018b 6b03          	ld	(OFST+0,sp),a
1241  018d 201f          	jra	L145
1242  018f               L514:
1243                     ; 185         case 2: port = DI2_PORT; pin = DI2_PIN; break;
1245  018f ae500f        	ldw	x,#20495
1246  0192 1f01          	ldw	(OFST-2,sp),x
1250  0194 a608          	ld	a,#8
1251  0196 6b03          	ld	(OFST+0,sp),a
1255  0198 2014          	jra	L145
1256  019a               L714:
1257                     ; 186         case 3: port = DI3_PORT; pin = DI3_PIN; break;
1259  019a ae500f        	ldw	x,#20495
1260  019d 1f01          	ldw	(OFST-2,sp),x
1264  019f a610          	ld	a,#16
1265  01a1 6b03          	ld	(OFST+0,sp),a
1269  01a3 2009          	jra	L145
1270  01a5               L124:
1271                     ; 187         case 4: port = DI4_PORT; pin = DI4_PIN; break;
1273  01a5 ae500f        	ldw	x,#20495
1274  01a8 1f01          	ldw	(OFST-2,sp),x
1278  01aa a680          	ld	a,#128
1279  01ac 6b03          	ld	(OFST+0,sp),a
1283  01ae               L145:
1284                     ; 190     return (GPIO_ReadInputPin(port, pin) == SET) ? 1 : 0;
1286  01ae 7b03          	ld	a,(OFST+0,sp)
1287  01b0 88            	push	a
1288  01b1 1e02          	ldw	x,(OFST-1,sp)
1289  01b3 cd0000        	call	_GPIO_ReadInputPin
1291  01b6 5b01          	addw	sp,#1
1292  01b8 a101          	cp	a,#1
1293  01ba 2604          	jrne	L011
1294  01bc a601          	ld	a,#1
1295  01be 2001          	jra	L211
1296  01c0               L011:
1297  01c0 4f            	clr	a
1298  01c1               L211:
1300  01c1               L411:
1302  01c1 5b03          	addw	sp,#3
1303  01c3 81            	ret
1400                     ; 193 void hal_relay_set(uint8_t relay_num, uint8_t state){
1401                     	switch	.text
1402  01c4               _hal_relay_set:
1404  01c4 89            	pushw	x
1405  01c5 5204          	subw	sp,#4
1406       00000004      OFST:	set	4
1409                     ; 196 	BitStatus bit_state = (state == 0) ? SET : RESET;
1411  01c7 9f            	ld	a,xl
1412  01c8 4d            	tnz	a
1413  01c9 2605          	jrne	L021
1414  01cb ae0001        	ldw	x,#1
1415  01ce 2001          	jra	L221
1416  01d0               L021:
1417  01d0 5f            	clrw	x
1418  01d1               L221:
1419  01d1 01            	rrwa	x,a
1420  01d2 6b01          	ld	(OFST-3,sp),a
1421  01d4 02            	rlwa	x,a
1423                     ; 198 	switch (relay_num) {
1425  01d5 7b05          	ld	a,(OFST+1,sp)
1427                     ; 205         default: return;
1428  01d7 4a            	dec	a
1429  01d8 2711          	jreq	L345
1430  01da 4a            	dec	a
1431  01db 2719          	jreq	L545
1432  01dd 4a            	dec	a
1433  01de 2721          	jreq	L745
1434  01e0 4a            	dec	a
1435  01e1 2729          	jreq	L155
1436  01e3 4a            	dec	a
1437  01e4 2731          	jreq	L355
1438  01e6 4a            	dec	a
1439  01e7 2739          	jreq	L555
1440  01e9               L755:
1443  01e9 205a          	jra	L421
1444  01eb               L345:
1445                     ; 199         case 1: port = RELAY1_PORT; pin = RELAY1_PIN; break;
1447  01eb ae5005        	ldw	x,#20485
1448  01ee 1f02          	ldw	(OFST-2,sp),x
1452  01f0 a608          	ld	a,#8
1453  01f2 6b04          	ld	(OFST+0,sp),a
1457  01f4 2035          	jra	L336
1458  01f6               L545:
1459                     ; 200         case 2: port = RELAY2_PORT; pin = RELAY2_PIN; break;
1461  01f6 ae5005        	ldw	x,#20485
1462  01f9 1f02          	ldw	(OFST-2,sp),x
1466  01fb a604          	ld	a,#4
1467  01fd 6b04          	ld	(OFST+0,sp),a
1471  01ff 202a          	jra	L336
1472  0201               L745:
1473                     ; 201         case 3: port = RELAY3_PORT; pin = RELAY3_PIN; break;
1475  0201 ae5005        	ldw	x,#20485
1476  0204 1f02          	ldw	(OFST-2,sp),x
1480  0206 a602          	ld	a,#2
1481  0208 6b04          	ld	(OFST+0,sp),a
1485  020a 201f          	jra	L336
1486  020c               L155:
1487                     ; 202         case 4: port = RELAY4_PORT; pin = RELAY4_PIN; break;
1489  020c ae5005        	ldw	x,#20485
1490  020f 1f02          	ldw	(OFST-2,sp),x
1494  0211 a601          	ld	a,#1
1495  0213 6b04          	ld	(OFST+0,sp),a
1499  0215 2014          	jra	L336
1500  0217               L355:
1501                     ; 203         case 5: port = RELAY5_PORT; pin = RELAY5_PIN; break;
1503  0217 ae500a        	ldw	x,#20490
1504  021a 1f02          	ldw	(OFST-2,sp),x
1508  021c a608          	ld	a,#8
1509  021e 6b04          	ld	(OFST+0,sp),a
1513  0220 2009          	jra	L336
1514  0222               L555:
1515                     ; 204         case 6: port = RELAY6_PORT; pin = RELAY6_PIN; break;
1517  0222 ae500a        	ldw	x,#20490
1518  0225 1f02          	ldw	(OFST-2,sp),x
1522  0227 a610          	ld	a,#16
1523  0229 6b04          	ld	(OFST+0,sp),a
1527  022b               L336:
1528                     ; 208 	if (bit_state == SET) {
1530  022b 7b01          	ld	a,(OFST-3,sp)
1531  022d a101          	cp	a,#1
1532  022f 260b          	jrne	L536
1533                     ; 209         GPIO_WriteHigh(port, pin);  /* Set HIGH = relay off */
1535  0231 7b04          	ld	a,(OFST+0,sp)
1536  0233 88            	push	a
1537  0234 1e03          	ldw	x,(OFST-1,sp)
1538  0236 cd0000        	call	_GPIO_WriteHigh
1540  0239 84            	pop	a
1542  023a 2009          	jra	L736
1543  023c               L536:
1544                     ; 211         GPIO_WriteLow(port, pin); /* Set LOW = relay on */
1546  023c 7b04          	ld	a,(OFST+0,sp)
1547  023e 88            	push	a
1548  023f 1e03          	ldw	x,(OFST-1,sp)
1549  0241 cd0000        	call	_GPIO_WriteLow
1551  0244 84            	pop	a
1552  0245               L736:
1553                     ; 213 }
1554  0245               L421:
1557  0245 5b06          	addw	sp,#6
1558  0247 81            	ret
1602                     ; 215 void relay_control_set(uint8_t relay_num, uint8_t state)
1602                     ; 216 {
1603                     	switch	.text
1604  0248               _relay_control_set:
1606  0248 89            	pushw	x
1607       00000000      OFST:	set	0
1610                     ; 217     if (relay_num >= 1 && relay_num <= 6) {
1612  0249 9e            	ld	a,xh
1613  024a 4d            	tnz	a
1614  024b 270d          	jreq	L366
1616  024d 9e            	ld	a,xh
1617  024e a107          	cp	a,#7
1618  0250 2408          	jruge	L366
1619                     ; 218         hal_relay_set(relay_num, state);
1621  0252 9f            	ld	a,xl
1622  0253 97            	ld	xl,a
1623  0254 7b01          	ld	a,(OFST+1,sp)
1624  0256 95            	ld	xh,a
1625  0257 cd01c4        	call	_hal_relay_set
1627  025a               L366:
1628                     ; 220 }
1631  025a 85            	popw	x
1632  025b 81            	ret
1668                     ; 222 void relay_control_set_all(uint8_t state)
1668                     ; 223 {
1669                     	switch	.text
1670  025c               _relay_control_set_all:
1672  025c 88            	push	a
1673       00000000      OFST:	set	0
1676                     ; 224     relay_control_set(1, state);
1678  025d ae0100        	ldw	x,#256
1679  0260 97            	ld	xl,a
1680  0261 ade5          	call	_relay_control_set
1682                     ; 225     relay_control_set(2, state);
1684  0263 7b01          	ld	a,(OFST+1,sp)
1685  0265 ae0200        	ldw	x,#512
1686  0268 97            	ld	xl,a
1687  0269 addd          	call	_relay_control_set
1689                     ; 226     relay_control_set(3, state);
1691  026b 7b01          	ld	a,(OFST+1,sp)
1692  026d ae0300        	ldw	x,#768
1693  0270 97            	ld	xl,a
1694  0271 add5          	call	_relay_control_set
1696                     ; 227     relay_control_set(4, state);
1698  0273 7b01          	ld	a,(OFST+1,sp)
1699  0275 ae0400        	ldw	x,#1024
1700  0278 97            	ld	xl,a
1701  0279 adcd          	call	_relay_control_set
1703                     ; 228     relay_control_set(5, state);
1705  027b 7b01          	ld	a,(OFST+1,sp)
1706  027d ae0500        	ldw	x,#1280
1707  0280 97            	ld	xl,a
1708  0281 adc5          	call	_relay_control_set
1710                     ; 229     relay_control_set(6, state);
1712  0283 7b01          	ld	a,(OFST+1,sp)
1713  0285 ae0600        	ldw	x,#1536
1714  0288 97            	ld	xl,a
1715  0289 adbd          	call	_relay_control_set
1717                     ; 230 }
1720  028b 84            	pop	a
1721  028c 81            	ret
1747                     ; 232 void sensor_reader_update(void){
1748                     	switch	.text
1749  028d               _sensor_reader_update:
1753                     ; 233     current_state.di1 = hal_di_read(1);
1755  028d a601          	ld	a,#1
1756  028f cd0173        	call	_hal_di_read
1758  0292 b717          	ld	L72_current_state,a
1759                     ; 234     current_state.di2 = hal_di_read(2);
1761  0294 a602          	ld	a,#2
1762  0296 cd0173        	call	_hal_di_read
1764  0299 b718          	ld	L72_current_state+1,a
1765                     ; 235     current_state.di3 = hal_di_read(3);
1767  029b a603          	ld	a,#3
1768  029d cd0173        	call	_hal_di_read
1770  02a0 b719          	ld	L72_current_state+2,a
1771                     ; 236     current_state.di4 = hal_di_read(4);
1773  02a2 a604          	ld	a,#4
1774  02a4 cd0173        	call	_hal_di_read
1776  02a7 b71a          	ld	L72_current_state+3,a
1777                     ; 237 }
1780  02a9 81            	ret
1804                     ; 240 void hal_timer_start(void)
1804                     ; 241 {
1805                     	switch	.text
1806  02aa               _hal_timer_start:
1810                     ; 242     TIM4_Cmd(ENABLE);
1812  02aa a601          	ld	a,#1
1813  02ac cd0000        	call	_TIM4_Cmd
1815                     ; 243 }
1818  02af 81            	ret
1870                     ; 245 void process_axle_counting(void)
1870                     ; 246 {
1871                     	switch	.text
1872  02b0               _process_axle_counting:
1874  02b0 520d          	subw	sp,#13
1875       0000000d      OFST:	set	13
1878                     ; 247     sensor_state_t sensor = sensor_reader_get_state();
1880  02b2 96            	ldw	x,sp
1881  02b3 1c000a        	addw	x,#OFST-3
1882  02b6 89            	pushw	x
1883  02b7 cd011a        	call	_sensor_reader_get_state
1885  02ba 85            	popw	x
1886                     ; 251     msg_buf[0] = sensor.di1 ? '1' : '0';
1888  02bb 0d0a          	tnz	(OFST-3,sp)
1889  02bd 2704          	jreq	L041
1890  02bf a631          	ld	a,#49
1891  02c1 2002          	jra	L241
1892  02c3               L041:
1893  02c3 a630          	ld	a,#48
1894  02c5               L241:
1895  02c5 6b05          	ld	(OFST-8,sp),a
1897                     ; 252     msg_buf[1] = sensor.di2 ? '1' : '0';
1899  02c7 0d0b          	tnz	(OFST-2,sp)
1900  02c9 2704          	jreq	L441
1901  02cb a631          	ld	a,#49
1902  02cd 2002          	jra	L641
1903  02cf               L441:
1904  02cf a630          	ld	a,#48
1905  02d1               L641:
1906  02d1 6b06          	ld	(OFST-7,sp),a
1908                     ; 253     msg_buf[2] = sensor.di3 ? '1' : '0';
1910  02d3 0d0c          	tnz	(OFST-1,sp)
1911  02d5 2704          	jreq	L051
1912  02d7 a631          	ld	a,#49
1913  02d9 2002          	jra	L251
1914  02db               L051:
1915  02db a630          	ld	a,#48
1916  02dd               L251:
1917  02dd 6b07          	ld	(OFST-6,sp),a
1919                     ; 254     msg_buf[3] = sensor.di4 ? '1' : '0';
1921  02df 0d0d          	tnz	(OFST+0,sp)
1922  02e1 2704          	jreq	L451
1923  02e3 a631          	ld	a,#49
1924  02e5 2002          	jra	L651
1925  02e7               L451:
1926  02e7 a630          	ld	a,#48
1927  02e9               L651:
1928  02e9 6b08          	ld	(OFST-5,sp),a
1930                     ; 255     msg_buf[4] = '\0';
1932  02eb 0f09          	clr	(OFST-4,sp)
1934                     ; 258     if ((sensor.di1 != axle_counter.prev_di1_state) ||
1934                     ; 259         (sensor.di2 != axle_counter.prev_di2_state))
1936  02ed 7b0a          	ld	a,(OFST-3,sp)
1937  02ef b105          	cp	a,L12_axle_counter+3
1938  02f1 2606          	jrne	L747
1940  02f3 7b0b          	ld	a,(OFST-2,sp)
1941  02f5 b103          	cp	a,L12_axle_counter+1
1942  02f7 2728          	jreq	L547
1943  02f9               L747:
1944                     ; 261         if (uart_server_is_ready())
1946  02f9 cd008d        	call	_uart_server_is_ready
1948  02fc a30000        	cpw	x,#0
1949  02ff 270c          	jreq	L157
1950                     ; 263             uart_server_send((uint8_t *)msg_buf, 4);
1952  0301 ae0004        	ldw	x,#4
1953  0304 89            	pushw	x
1954  0305 96            	ldw	x,sp
1955  0306 1c0007        	addw	x,#OFST-6
1956  0309 cd00e5        	call	_uart_server_send
1958  030c 85            	popw	x
1959  030d               L157:
1960                     ; 266         if (tcp_server_is_connected())
1962  030d cd0007        	call	_tcp_server_is_connected
1964  0310 a30000        	cpw	x,#0
1965  0313 270c          	jreq	L547
1966                     ; 268             tcp_server_send((uint8_t *)msg_buf, 4);
1968  0315 ae0004        	ldw	x,#4
1969  0318 89            	pushw	x
1970  0319 96            	ldw	x,sp
1971  031a 1c0007        	addw	x,#OFST-6
1972  031d cd0041        	call	_tcp_server_send
1974  0320 85            	popw	x
1975  0321               L547:
1976                     ; 272     axle_counter.prev_di1_state = sensor.di1;
1978  0321 7b0a          	ld	a,(OFST-3,sp)
1979  0323 b705          	ld	L12_axle_counter+3,a
1980                     ; 273     axle_counter.prev_di2_state = sensor.di2;
1982  0325 7b0b          	ld	a,(OFST-2,sp)
1983  0327 b703          	ld	L12_axle_counter+1,a
1984                     ; 274 }
1987  0329 5b0d          	addw	sp,#13
1988  032b 81            	ret
2012                     ; 275 void sensor_reader_init(void)
2012                     ; 276 {
2013                     	switch	.text
2014  032c               _sensor_reader_init:
2018                     ; 278     sensor_reader_update();
2020  032c cd028d        	call	_sensor_reader_update
2022                     ; 279 }
2025  032f 81            	ret
2077                     ; 281 void send_alive_message(void)
2077                     ; 282 {
2078                     	switch	.text
2079  0330               _send_alive_message:
2081  0330 520d          	subw	sp,#13
2082       0000000d      OFST:	set	13
2085                     ; 286     sensor = sensor_reader_get_state();
2087  0332 96            	ldw	x,sp
2088  0333 1c0005        	addw	x,#OFST-8
2089  0336 89            	pushw	x
2090  0337 cd011a        	call	_sensor_reader_get_state
2092  033a 85            	popw	x
2093                     ; 288     message_formatter_alive(
2093                     ; 289         msg_buf,
2093                     ; 290         sizeof(msg_buf),
2093                     ; 291         sensor.di1,
2093                     ; 292         sensor.di2,
2093                     ; 293         sensor.di3,
2093                     ; 294         sensor.di4
2093                     ; 295     );
2095  033b 7b08          	ld	a,(OFST-5,sp)
2096  033d 88            	push	a
2097  033e 7b08          	ld	a,(OFST-5,sp)
2098  0340 88            	push	a
2099  0341 7b08          	ld	a,(OFST-5,sp)
2100  0343 88            	push	a
2101  0344 7b08          	ld	a,(OFST-5,sp)
2102  0346 88            	push	a
2103  0347 ae0005        	ldw	x,#5
2104  034a 89            	pushw	x
2105  034b 96            	ldw	x,sp
2106  034c 1c000f        	addw	x,#OFST+2
2107  034f cd0126        	call	_message_formatter_alive
2109  0352 5b06          	addw	sp,#6
2110                     ; 296     if (tcp_server_is_connected())
2112  0354 cd0007        	call	_tcp_server_is_connected
2114  0357 a30000        	cpw	x,#0
2115  035a 2710          	jreq	L7001
2116                     ; 298         tcp_server_send((uint8_t *)msg_buf, strlen(msg_buf));
2118  035c 96            	ldw	x,sp
2119  035d 1c0009        	addw	x,#OFST-4
2120  0360 cd0000        	call	_strlen
2122  0363 89            	pushw	x
2123  0364 96            	ldw	x,sp
2124  0365 1c000b        	addw	x,#OFST-2
2125  0368 cd0041        	call	_tcp_server_send
2127  036b 85            	popw	x
2128  036c               L7001:
2129                     ; 300     if (uart_server_is_ready())
2131  036c cd008d        	call	_uart_server_is_ready
2133  036f a30000        	cpw	x,#0
2134  0372 2710          	jreq	L1101
2135                     ; 302         uart_server_send((uint8_t *)msg_buf, strlen(msg_buf));
2137  0374 96            	ldw	x,sp
2138  0375 1c0009        	addw	x,#OFST-4
2139  0378 cd0000        	call	_strlen
2141  037b 89            	pushw	x
2142  037c 96            	ldw	x,sp
2143  037d 1c000b        	addw	x,#OFST-2
2144  0380 cd00e5        	call	_uart_server_send
2146  0383 85            	popw	x
2147  0384               L1101:
2148                     ; 304 }
2151  0384 5b0d          	addw	sp,#13
2152  0386 81            	ret
2180                     .const:	section	.text
2181  0000               L661:
2182  0000 00000032      	dc.l	50
2183  0004               L071:
2184  0004 000001f4      	dc.l	500
2185                     ; 306 void timer_callback(void){
2186                     	switch	.text
2187  0387               _timer_callback:
2191                     ; 307     task_timer.current_time = hal_get_millis();
2193  0387 cd0000        	call	_hal_get_millis
2195  038a ae0013        	ldw	x,#L52_task_timer+8
2196  038d cd0000        	call	c_rtol
2198                     ; 308     if ((task_timer.current_time - task_timer.last_sensor_time) >= SENSOR_READ_INTERVAL){
2200  0390 ae0013        	ldw	x,#L52_task_timer+8
2201  0393 cd0000        	call	c_ltor
2203  0396 ae000f        	ldw	x,#L52_task_timer+4
2204  0399 cd0000        	call	c_lsub
2206  039c ae0000        	ldw	x,#L661
2207  039f cd0000        	call	c_lcmp
2209  03a2 250e          	jrult	L3201
2210                     ; 309         sensor_reader_update();
2212  03a4 cd028d        	call	_sensor_reader_update
2214                     ; 310         process_axle_counting();
2216  03a7 cd02b0        	call	_process_axle_counting
2218                     ; 311         task_timer.last_sensor_time = task_timer.current_time;
2220  03aa be15          	ldw	x,L52_task_timer+10
2221  03ac bf11          	ldw	L52_task_timer+6,x
2222  03ae be13          	ldw	x,L52_task_timer+8
2223  03b0 bf0f          	ldw	L52_task_timer+4,x
2224  03b2               L3201:
2225                     ; 314     if ((task_timer.current_time - task_timer.last_alive_time) >= ALIVE_INTERVAL){
2227  03b2 ae0013        	ldw	x,#L52_task_timer+8
2228  03b5 cd0000        	call	c_ltor
2230  03b8 ae000b        	ldw	x,#L52_task_timer
2231  03bb cd0000        	call	c_lsub
2233  03be ae0004        	ldw	x,#L071
2234  03c1 cd0000        	call	c_lcmp
2236  03c4 250b          	jrult	L5201
2237                     ; 315         send_alive_message();  
2239  03c6 cd0330        	call	_send_alive_message
2241                     ; 316         task_timer.last_alive_time = task_timer.current_time;
2243  03c9 be15          	ldw	x,L52_task_timer+10
2244  03cb bf0d          	ldw	L52_task_timer+2,x
2245  03cd be13          	ldw	x,L52_task_timer+8
2246  03cf bf0b          	ldw	L52_task_timer,x
2247  03d1               L5201:
2248                     ; 318 }
2251  03d1 81            	ret
2289                     ; 320 void hal_timer_set_callback(timer_callback_t callback)
2289                     ; 321 {
2290                     	switch	.text
2291  03d2               _hal_timer_set_callback:
2295                     ; 322     user_callback = callback;
2297  03d2 bf26          	ldw	_user_callback,x
2298                     ; 323 }
2301  03d4 81            	ret
2365                     ; 325 int command_parser_execute(const char *cmd_str, int len)
2365                     ; 326 {
2366                     	switch	.text
2367  03d5               _command_parser_execute:
2369  03d5 89            	pushw	x
2370  03d6 89            	pushw	x
2371       00000002      OFST:	set	2
2374                     ; 331     if (len < 4)
2376  03d7 9c            	rvf
2377  03d8 1e07          	ldw	x,(OFST+5,sp)
2378  03da a30004        	cpw	x,#4
2379  03dd 2e05          	jrsge	L7701
2380                     ; 332         return -1;
2382  03df aeffff        	ldw	x,#65535
2384  03e2 200a          	jra	L671
2385  03e4               L7701:
2386                     ; 334     if (cmd_str[0] != 'R')
2388  03e4 1e03          	ldw	x,(OFST+1,sp)
2389  03e6 f6            	ld	a,(x)
2390  03e7 a152          	cp	a,#82
2391  03e9 2706          	jreq	L1011
2392                     ; 335         return -1;
2394  03eb aeffff        	ldw	x,#65535
2396  03ee               L671:
2398  03ee 5b04          	addw	sp,#4
2399  03f0 81            	ret
2400  03f1               L1011:
2401                     ; 337     if (cmd_str[1] < '1' || cmd_str[1] > '6')
2403  03f1 1e03          	ldw	x,(OFST+1,sp)
2404  03f3 e601          	ld	a,(1,x)
2405  03f5 a131          	cp	a,#49
2406  03f7 2508          	jrult	L5011
2408  03f9 1e03          	ldw	x,(OFST+1,sp)
2409  03fb e601          	ld	a,(1,x)
2410  03fd a137          	cp	a,#55
2411  03ff 2505          	jrult	L3011
2412  0401               L5011:
2413                     ; 338         return -1;
2415  0401 aeffff        	ldw	x,#65535
2417  0404 20e8          	jra	L671
2418  0406               L3011:
2419                     ; 340     if (cmd_str[2] != ',')
2421  0406 1e03          	ldw	x,(OFST+1,sp)
2422  0408 e602          	ld	a,(2,x)
2423  040a a12c          	cp	a,#44
2424  040c 2705          	jreq	L7011
2425                     ; 341         return -1;
2427  040e aeffff        	ldw	x,#65535
2429  0411 20db          	jra	L671
2430  0413               L7011:
2431                     ; 343     if (cmd_str[3] != '0' && cmd_str[3] != '1')
2433  0413 1e03          	ldw	x,(OFST+1,sp)
2434  0415 e603          	ld	a,(3,x)
2435  0417 a130          	cp	a,#48
2436  0419 270d          	jreq	L1111
2438  041b 1e03          	ldw	x,(OFST+1,sp)
2439  041d e603          	ld	a,(3,x)
2440  041f a131          	cp	a,#49
2441  0421 2705          	jreq	L1111
2442                     ; 344         return -1;
2444  0423 aeffff        	ldw	x,#65535
2446  0426 20c6          	jra	L671
2447  0428               L1111:
2448                     ; 346     relay_num = cmd_str[1] - '0';
2450  0428 1e03          	ldw	x,(OFST+1,sp)
2451  042a e601          	ld	a,(1,x)
2452  042c a030          	sub	a,#48
2453  042e 6b01          	ld	(OFST-1,sp),a
2455                     ; 347     relay_state = cmd_str[3] - '0';
2457  0430 1e03          	ldw	x,(OFST+1,sp)
2458  0432 e603          	ld	a,(3,x)
2459  0434 a030          	sub	a,#48
2460  0436 6b02          	ld	(OFST+0,sp),a
2462                     ; 349     relay_control_set(relay_num, relay_state);
2464  0438 7b02          	ld	a,(OFST+0,sp)
2465  043a 97            	ld	xl,a
2466  043b 7b01          	ld	a,(OFST-1,sp)
2467  043d 95            	ld	xh,a
2468  043e cd0248        	call	_relay_control_set
2470                     ; 351     return 0;
2472  0441 5f            	clrw	x
2474  0442 20aa          	jra	L671
2498                     ; 354 void relay_control_init(void)
2498                     ; 355 {
2499                     	switch	.text
2500  0444               _relay_control_init:
2504                     ; 356     relay_control_set_all(1);  /* 1 = on for active-low relays */
2506  0444 a601          	ld	a,#1
2507  0446 cd025c        	call	_relay_control_set_all
2509                     ; 357 }
2512  0449 81            	ret
2537                     ; 359 void hal_w5500_reset_high(void)
2537                     ; 360 {
2538                     	switch	.text
2539  044a               _hal_w5500_reset_high:
2543                     ; 361     GPIO_WriteHigh(W5500_RST_PORT, W5500_RST_PIN);
2545  044a 4b20          	push	#32
2546  044c ae5014        	ldw	x,#20500
2547  044f cd0000        	call	_GPIO_WriteHigh
2549  0452 84            	pop	a
2550                     ; 362 }
2553  0453 81            	ret
2579                     ; 364 void hal_gpio_init(void){
2580                     	switch	.text
2581  0454               _hal_gpio_init:
2585                     ; 366     GPIO_Init(DI1_PORT, DI1_PIN, GPIO_MODE_IN_PU_NO_IT);
2587  0454 4b40          	push	#64
2588  0456 4b04          	push	#4
2589  0458 ae500f        	ldw	x,#20495
2590  045b cd0000        	call	_GPIO_Init
2592  045e 85            	popw	x
2593                     ; 367     GPIO_Init(DI2_PORT, DI2_PIN, GPIO_MODE_IN_PU_NO_IT);
2595  045f 4b40          	push	#64
2596  0461 4b08          	push	#8
2597  0463 ae500f        	ldw	x,#20495
2598  0466 cd0000        	call	_GPIO_Init
2600  0469 85            	popw	x
2601                     ; 368     GPIO_Init(DI3_PORT, DI3_PIN, GPIO_MODE_IN_PU_NO_IT);
2603  046a 4b40          	push	#64
2604  046c 4b10          	push	#16
2605  046e ae500f        	ldw	x,#20495
2606  0471 cd0000        	call	_GPIO_Init
2608  0474 85            	popw	x
2609                     ; 369     GPIO_Init(DI4_PORT, DI4_PIN, GPIO_MODE_IN_PU_NO_IT);
2611  0475 4b40          	push	#64
2612  0477 4b80          	push	#128
2613  0479 ae500f        	ldw	x,#20495
2614  047c cd0000        	call	_GPIO_Init
2616  047f 85            	popw	x
2617                     ; 372     GPIO_Init(RELAY1_PORT, RELAY1_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
2619  0480 4bf0          	push	#240
2620  0482 4b08          	push	#8
2621  0484 ae5005        	ldw	x,#20485
2622  0487 cd0000        	call	_GPIO_Init
2624  048a 85            	popw	x
2625                     ; 373     GPIO_Init(RELAY2_PORT, RELAY2_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
2627  048b 4bf0          	push	#240
2628  048d 4b04          	push	#4
2629  048f ae5005        	ldw	x,#20485
2630  0492 cd0000        	call	_GPIO_Init
2632  0495 85            	popw	x
2633                     ; 374     GPIO_Init(RELAY3_PORT, RELAY3_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
2635  0496 4bf0          	push	#240
2636  0498 4b02          	push	#2
2637  049a ae5005        	ldw	x,#20485
2638  049d cd0000        	call	_GPIO_Init
2640  04a0 85            	popw	x
2641                     ; 375     GPIO_Init(RELAY4_PORT, RELAY4_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
2643  04a1 4bf0          	push	#240
2644  04a3 4b01          	push	#1
2645  04a5 ae5005        	ldw	x,#20485
2646  04a8 cd0000        	call	_GPIO_Init
2648  04ab 85            	popw	x
2649                     ; 376     GPIO_Init(RELAY5_PORT, RELAY5_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
2651  04ac 4bf0          	push	#240
2652  04ae 4b08          	push	#8
2653  04b0 ae500a        	ldw	x,#20490
2654  04b3 cd0000        	call	_GPIO_Init
2656  04b6 85            	popw	x
2657                     ; 377     GPIO_Init(RELAY6_PORT, RELAY6_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
2659  04b7 4bf0          	push	#240
2660  04b9 4b10          	push	#16
2661  04bb ae500a        	ldw	x,#20490
2662  04be cd0000        	call	_GPIO_Init
2664  04c1 85            	popw	x
2665                     ; 380     hal_relay_set(1, 1);
2667  04c2 ae0101        	ldw	x,#257
2668  04c5 cd01c4        	call	_hal_relay_set
2670                     ; 381     hal_relay_set(2, 1);
2672  04c8 ae0201        	ldw	x,#513
2673  04cb cd01c4        	call	_hal_relay_set
2675                     ; 382     hal_relay_set(3, 1);
2677  04ce ae0301        	ldw	x,#769
2678  04d1 cd01c4        	call	_hal_relay_set
2680                     ; 383     hal_relay_set(4, 1);
2682  04d4 ae0401        	ldw	x,#1025
2683  04d7 cd01c4        	call	_hal_relay_set
2685                     ; 384     hal_relay_set(5, 1);
2687  04da ae0501        	ldw	x,#1281
2688  04dd cd01c4        	call	_hal_relay_set
2690                     ; 385     hal_relay_set(6, 1);
2692  04e0 ae0601        	ldw	x,#1537
2693  04e3 cd01c4        	call	_hal_relay_set
2695                     ; 388     GPIO_Init(HARDRST_PORT, HARDRST_PIN, GPIO_MODE_IN_PU_NO_IT);
2697  04e6 4b40          	push	#64
2698  04e8 4b80          	push	#128
2699  04ea ae5005        	ldw	x,#20485
2700  04ed cd0000        	call	_GPIO_Init
2702  04f0 85            	popw	x
2703                     ; 391     GPIO_Init(W5500_RST_PORT, W5500_RST_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
2705  04f1 4bf0          	push	#240
2706  04f3 4b20          	push	#32
2707  04f5 ae5014        	ldw	x,#20500
2708  04f8 cd0000        	call	_GPIO_Init
2710  04fb 85            	popw	x
2711                     ; 392 	hal_w5500_reset_high();
2713  04fc cd044a        	call	_hal_w5500_reset_high
2715                     ; 393 }
2718  04ff 81            	ret
2742                     ; 395 uint16_t hal_uart_available(void){
2743                     	switch	.text
2744  0500               _hal_uart_available:
2748                     ; 396 	return uart_rx_count;
2750  0500 b61f          	ld	a,_uart_rx_count
2751  0502 5f            	clrw	x
2752  0503 97            	ld	xl,a
2755  0504 81            	ret
2794                     ; 399 uint8_t hal_uart_read_byte(void){
2795                     	switch	.text
2796  0505               _hal_uart_read_byte:
2798  0505 88            	push	a
2799       00000001      OFST:	set	1
2802                     ; 400 	uint8_t byte = 0;
2804  0506 0f01          	clr	(OFST+0,sp)
2806                     ; 401 	if (uart_rx_count > 0){
2808  0508 3d1f          	tnz	_uart_rx_count
2809  050a 271a          	jreq	L1711
2810                     ; 402 		disableInterrupts();
2813  050c 9b            sim
2815                     ; 404 		byte = uart_rx_buffer[uart_rx_tail];
2818  050d b621          	ld	a,_uart_rx_tail
2819  050f 5f            	clrw	x
2820  0510 97            	ld	xl,a
2821  0511 e600          	ld	a,(_uart_rx_buffer,x)
2822  0513 6b01          	ld	(OFST+0,sp),a
2824                     ; 405 		uart_rx_tail = (uart_rx_tail + 1) % UART_RX_BUFFER_SIZE;
2826  0515 b621          	ld	a,_uart_rx_tail
2827  0517 5f            	clrw	x
2828  0518 97            	ld	xl,a
2829  0519 5c            	incw	x
2830  051a a606          	ld	a,#6
2831  051c cd0000        	call	c_smodx
2833  051f 01            	rrwa	x,a
2834  0520 b721          	ld	_uart_rx_tail,a
2835  0522 02            	rlwa	x,a
2836                     ; 406 		uart_rx_count--;
2838  0523 3a1f          	dec	_uart_rx_count
2839                     ; 407 		enableInterrupts();
2842  0525 9a            rim
2845  0526               L1711:
2846                     ; 409 	return byte;
2848  0526 7b01          	ld	a,(OFST+0,sp)
2851  0528 5b01          	addw	sp,#1
2852  052a 81            	ret
2926                     ; 412 void uart_server_process(void){
2927                     	switch	.text
2928  052b               _uart_server_process:
2930  052b 5210          	subw	sp,#16
2931       00000010      OFST:	set	16
2934                     ; 418 	if (uart_state == UART_STATE_IDLE){
2936  052d 3d1b          	tnz	L13_uart_state
2937  052f 2603          	jrne	L612
2938  0531 cc05ec        	jp	L412
2939  0534               L612:
2940                     ; 419 		return;
2942                     ; 421 	available_len = hal_uart_available();
2944  0534 adca          	call	_hal_uart_available
2946  0536 1f05          	ldw	(OFST-11,sp),x
2948                     ; 423 	if(available_len > 0){
2950  0538 1e05          	ldw	x,(OFST-11,sp)
2951  053a 2603          	jrne	L022
2952  053c cc05e8        	jp	L7221
2953  053f               L022:
2954                     ; 424 		uart_state = UART_STATE_RX_PENDING;
2956  053f 3502001b      	mov	L13_uart_state,#2
2958  0543 acd505d5      	jpf	L5321
2959  0547               L1321:
2960                     ; 427 			read_byte = hal_uart_read_byte();
2962  0547 adbc          	call	_hal_uart_read_byte
2964  0549 6b10          	ld	(OFST+0,sp),a
2966                     ; 429 			if (read_byte == '\n' || read_byte == '\r'){
2968  054b 7b10          	ld	a,(OFST+0,sp)
2969  054d a10a          	cp	a,#10
2970  054f 2706          	jreq	L3421
2972  0551 7b10          	ld	a,(OFST+0,sp)
2973  0553 a10d          	cp	a,#13
2974  0555 265f          	jrne	L1421
2975  0557               L3421:
2976                     ; 430 				if(uart_rx_count > 0){
2978  0557 3d1f          	tnz	_uart_rx_count
2979  0559 2773          	jreq	L5521
2980                     ; 431 					uart_rx_buffer[uart_rx_count] = '\0';
2982  055b b61f          	ld	a,_uart_rx_count
2983  055d 5f            	clrw	x
2984  055e 97            	ld	xl,a
2985  055f 6f00          	clr	(_uart_rx_buffer,x)
2986                     ; 432 					if (command_parser_execute((const char *)uart_rx_buffer,uart_rx_count) == 0){
2988  0561 b61f          	ld	a,_uart_rx_count
2989  0563 5f            	clrw	x
2990  0564 97            	ld	xl,a
2991  0565 89            	pushw	x
2992  0566 ae0000        	ldw	x,#_uart_rx_buffer
2993  0569 cd03d5        	call	_command_parser_execute
2995  056c 5b02          	addw	sp,#2
2996  056e a30000        	cpw	x,#0
2997  0571 2634          	jrne	L7421
2998                     ; 433 						state = sensor_reader_get_state();
3000  0573 96            	ldw	x,sp
3001  0574 1c000c        	addw	x,#OFST-4
3002  0577 89            	pushw	x
3003  0578 cd011a        	call	_sensor_reader_get_state
3005  057b 85            	popw	x
3006                     ; 434 						message_formatter_alive(resp_buf, sizeof(resp_buf),state.di1,state.di2,state.di3,state.di4);
3008  057c 7b0f          	ld	a,(OFST-1,sp)
3009  057e 88            	push	a
3010  057f 7b0f          	ld	a,(OFST-1,sp)
3011  0581 88            	push	a
3012  0582 7b0f          	ld	a,(OFST-1,sp)
3013  0584 88            	push	a
3014  0585 7b0f          	ld	a,(OFST-1,sp)
3015  0587 88            	push	a
3016  0588 ae0005        	ldw	x,#5
3017  058b 89            	pushw	x
3018  058c 96            	ldw	x,sp
3019  058d 1c000d        	addw	x,#OFST-3
3020  0590 cd0126        	call	_message_formatter_alive
3022  0593 5b06          	addw	sp,#6
3023                     ; 435 					 	uart_server_send((uint8_t *)resp_buf,strlen(resp_buf));
3025  0595 96            	ldw	x,sp
3026  0596 1c0007        	addw	x,#OFST-9
3027  0599 cd0000        	call	_strlen
3029  059c 89            	pushw	x
3030  059d 96            	ldw	x,sp
3031  059e 1c0009        	addw	x,#OFST-7
3032  05a1 cd00e5        	call	_uart_server_send
3034  05a4 85            	popw	x
3036  05a5 200b          	jra	L1521
3037  05a7               L7421:
3038                     ; 438                         uart_server_send((uint8_t *)"ERR", 3);
3040  05a7 ae0003        	ldw	x,#3
3041  05aa 89            	pushw	x
3042  05ab ae0035        	ldw	x,#L3521
3043  05ae cd00e5        	call	_uart_server_send
3045  05b1 85            	popw	x
3046  05b2               L1521:
3047                     ; 440                     uart_rx_count = 0;
3049  05b2 3f1f          	clr	_uart_rx_count
3050  05b4 2018          	jra	L5521
3051  05b6               L1421:
3052                     ; 443             else if (read_byte >= 32 && read_byte < 127){
3054  05b6 7b10          	ld	a,(OFST+0,sp)
3055  05b8 a120          	cp	a,#32
3056  05ba 2512          	jrult	L5521
3058  05bc 7b10          	ld	a,(OFST+0,sp)
3059  05be a17f          	cp	a,#127
3060  05c0 240c          	jruge	L5521
3061                     ; 444                 uart_rx_buffer[uart_rx_count++] = read_byte;
3063  05c2 b61f          	ld	a,_uart_rx_count
3064  05c4 97            	ld	xl,a
3065  05c5 3c1f          	inc	_uart_rx_count
3066  05c7 9f            	ld	a,xl
3067  05c8 5f            	clrw	x
3068  05c9 97            	ld	xl,a
3069  05ca 7b10          	ld	a,(OFST+0,sp)
3070  05cc e700          	ld	(_uart_rx_buffer,x),a
3071  05ce               L5521:
3072                     ; 446             available_len--;
3074  05ce 1e05          	ldw	x,(OFST-11,sp)
3075  05d0 1d0001        	subw	x,#1
3076  05d3 1f05          	ldw	(OFST-11,sp),x
3078  05d5               L5321:
3079                     ; 426 		while (available_len > 0 && uart_rx_count < sizeof(uart_rx_buffer) - 1){
3081  05d5 1e05          	ldw	x,(OFST-11,sp)
3082  05d7 2709          	jreq	L1621
3084  05d9 b61f          	ld	a,_uart_rx_count
3085  05db a105          	cp	a,#5
3086  05dd 2403          	jruge	L222
3087  05df cc0547        	jp	L1321
3088  05e2               L222:
3089  05e2               L1621:
3090                     ; 448         uart_state = UART_STATE_READY;
3092  05e2 3501001b      	mov	L13_uart_state,#1
3094  05e6 2004          	jra	L3621
3095  05e8               L7221:
3096                     ; 451         uart_state = UART_STATE_READY;
3098  05e8 3501001b      	mov	L13_uart_state,#1
3099  05ec               L3621:
3100                     ; 453 }
3101  05ec               L412:
3104  05ec 5b10          	addw	sp,#16
3105  05ee 81            	ret
3142                     ; 454 uint8_t hal_spi_byte(uint8_t data)
3142                     ; 455 {
3143                     	switch	.text
3144  05ef               _hal_spi_byte:
3146  05ef 88            	push	a
3147       00000000      OFST:	set	0
3150  05f0               L5031:
3151                     ; 456     while (SPI_GetFlagStatus(SPI_FLAG_TXE) == RESET);
3153  05f0 a602          	ld	a,#2
3154  05f2 cd0000        	call	_SPI_GetFlagStatus
3156  05f5 4d            	tnz	a
3157  05f6 27f8          	jreq	L5031
3158                     ; 458     SPI_SendData(data);
3160  05f8 7b01          	ld	a,(OFST+1,sp)
3161  05fa cd0000        	call	_SPI_SendData
3164  05fd               L3131:
3165                     ; 460     while (SPI_GetFlagStatus(SPI_FLAG_RXNE) == RESET);
3167  05fd a601          	ld	a,#1
3168  05ff cd0000        	call	_SPI_GetFlagStatus
3170  0602 4d            	tnz	a
3171  0603 27f8          	jreq	L3131
3172                     ; 462     return SPI_ReceiveData();
3174  0605 cd0000        	call	_SPI_ReceiveData
3178  0608 5b01          	addw	sp,#1
3179  060a 81            	ret
3203                     ; 464 uint8_t hal_spi_read_byte(void)
3203                     ; 465 {
3204                     	switch	.text
3205  060b               _hal_spi_read_byte:
3209                     ; 466     return hal_spi_byte(0xFF);
3211  060b a6ff          	ld	a,#255
3212  060d ade0          	call	_hal_spi_byte
3216  060f 81            	ret
3251                     ; 468 void hal_spi_write_byte(uint8_t data)
3251                     ; 469 {
3252                     	switch	.text
3253  0610               _hal_spi_write_byte:
3257                     ; 470     hal_spi_byte(data);
3259  0610 addd          	call	_hal_spi_byte
3261                     ; 471 }
3264  0612 81            	ret
3318                     ; 472 void hal_spi_read(uint8_t *buf, uint16_t len){
3319                     	switch	.text
3320  0613               _hal_spi_read:
3322  0613 89            	pushw	x
3323  0614 89            	pushw	x
3324       00000002      OFST:	set	2
3327                     ; 474     for(i = 0; i < len; i++){
3329  0615 5f            	clrw	x
3330  0616 1f01          	ldw	(OFST-1,sp),x
3333  0618 2011          	jra	L7731
3334  061a               L3731:
3335                     ; 475         buf[i] = hal_spi_byte(0xFF);
3337  061a a6ff          	ld	a,#255
3338  061c add1          	call	_hal_spi_byte
3340  061e 1e03          	ldw	x,(OFST+1,sp)
3341  0620 72fb01        	addw	x,(OFST-1,sp)
3342  0623 f7            	ld	(x),a
3343                     ; 474     for(i = 0; i < len; i++){
3345  0624 1e01          	ldw	x,(OFST-1,sp)
3346  0626 1c0001        	addw	x,#1
3347  0629 1f01          	ldw	(OFST-1,sp),x
3349  062b               L7731:
3352  062b 1e01          	ldw	x,(OFST-1,sp)
3353  062d 1307          	cpw	x,(OFST+5,sp)
3354  062f 25e9          	jrult	L3731
3355                     ; 477 }
3358  0631 5b04          	addw	sp,#4
3359  0633 81            	ret
3413                     ; 479 void hal_spi_write(uint8_t *buf, uint16_t len){
3414                     	switch	.text
3415  0634               _hal_spi_write:
3417  0634 89            	pushw	x
3418  0635 89            	pushw	x
3419       00000002      OFST:	set	2
3422                     ; 481     for(i = 0; i < len; i++){
3424  0636 5f            	clrw	x
3425  0637 1f01          	ldw	(OFST-1,sp),x
3428  0639 200f          	jra	L5341
3429  063b               L1341:
3430                     ; 482         hal_spi_byte(buf[i]);
3432  063b 1e03          	ldw	x,(OFST+1,sp)
3433  063d 72fb01        	addw	x,(OFST-1,sp)
3434  0640 f6            	ld	a,(x)
3435  0641 adac          	call	_hal_spi_byte
3437                     ; 481     for(i = 0; i < len; i++){
3439  0643 1e01          	ldw	x,(OFST-1,sp)
3440  0645 1c0001        	addw	x,#1
3441  0648 1f01          	ldw	(OFST-1,sp),x
3443  064a               L5341:
3446  064a 1e01          	ldw	x,(OFST-1,sp)
3447  064c 1307          	cpw	x,(OFST+5,sp)
3448  064e 25eb          	jrult	L1341
3449                     ; 484 }
3452  0650 5b04          	addw	sp,#4
3453  0652 81            	ret
3495                     ; 486 void uart_server_init(uint32_t baudrate){
3496                     	switch	.text
3497  0653               _uart_server_init:
3499       00000000      OFST:	set	0
3502                     ; 487 	uart_state = UART_STATE_IDLE;
3504  0653 3f1b          	clr	L13_uart_state
3505                     ; 488 	uart_rx_count = 0;
3507  0655 3f1f          	clr	_uart_rx_count
3508                     ; 489 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_UART1, ENABLE);
3510  0657 ae0301        	ldw	x,#769
3511  065a cd0000        	call	_CLK_PeripheralClockConfig
3513                     ; 490     UART1_Init(
3513                     ; 491     baudrate,
3513                     ; 492     UART1_WORDLENGTH_8D,
3513                     ; 493     UART1_STOPBITS_1,
3513                     ; 494     UART1_PARITY_NO,
3513                     ; 495     UART1_SYNCMODE_CLOCK_DISABLE,
3513                     ; 496     (UART1_Mode_TypeDef)(UART1_MODE_TX_ENABLE | UART1_MODE_RX_ENABLE)
3513                     ; 497 );
3515  065d 4b0c          	push	#12
3516  065f 4b80          	push	#128
3517  0661 4b00          	push	#0
3518  0663 4b00          	push	#0
3519  0665 4b00          	push	#0
3520  0667 1e0a          	ldw	x,(OFST+10,sp)
3521  0669 89            	pushw	x
3522  066a 1e0a          	ldw	x,(OFST+10,sp)
3523  066c 89            	pushw	x
3524  066d cd0000        	call	_UART1_Init
3526  0670 5b09          	addw	sp,#9
3527                     ; 499     UART1_ITConfig(UART1_IT_RXNE, ENABLE);
3529  0672 4b01          	push	#1
3530  0674 ae0255        	ldw	x,#597
3531  0677 cd0000        	call	_UART1_ITConfig
3533  067a 84            	pop	a
3534                     ; 502     UART1_Cmd(ENABLE);
3536  067b a601          	ld	a,#1
3537  067d cd0000        	call	_UART1_Cmd
3539                     ; 504     uart_rx_head = 0;
3541  0680 3f20          	clr	_uart_rx_head
3542                     ; 505     uart_rx_tail = 0;
3544  0682 3f21          	clr	_uart_rx_tail
3545                     ; 506     uart_rx_count = 0;  
3547  0684 3f1f          	clr	_uart_rx_count
3548                     ; 507 	uart_state = UART_STATE_READY;
3550  0686 3501001b      	mov	L13_uart_state,#1
3551                     ; 508 }
3554  068a 81            	ret
3582                     ; 510 void hal_timer_init(void){
3583                     	switch	.text
3584  068b               _hal_timer_init:
3588                     ; 511     CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER4, ENABLE);
3590  068b ae0401        	ldw	x,#1025
3591  068e cd0000        	call	_CLK_PeripheralClockConfig
3593                     ; 512     TIM4_TimeBaseInit(TIM4_PRESCALER_128, 125);
3595  0691 ae077d        	ldw	x,#1917
3596  0694 cd0000        	call	_TIM4_TimeBaseInit
3598                     ; 513     TIM4_ClearFlag(TIM4_FLAG_UPDATE);
3600  0697 a601          	ld	a,#1
3601  0699 cd0000        	call	_TIM4_ClearFlag
3603                     ; 515     TIM4_ITConfig(TIM4_IT_UPDATE, ENABLE);
3605  069c ae0101        	ldw	x,#257
3606  069f cd0000        	call	_TIM4_ITConfig
3608                     ; 517     enableInterrupts();
3611  06a2 9a            rim
3613                     ; 518 }
3617  06a3 81            	ret
3704                     ; 520 void tcp_server_process(void){
3705                     	switch	.text
3706  06a4               _tcp_server_process:
3708  06a4 5210          	subw	sp,#16
3709       00000010      OFST:	set	16
3712                     ; 521     uint16_t received_len = 0;
3714                     ; 524     if(server_state == TCP_STATE_IDLE) return;
3716  06a6 3d0a          	tnz	L32_server_state
3717  06a8 2603          	jrne	L252
3718  06aa cc07c3        	jp	L052
3719  06ad               L252:
3722                     ; 525     sock_status = getSn_SR(server_socket);
3724  06ad b61c          	ld	a,L33_server_socket
3725  06af 97            	ld	xl,a
3726  06b0 a604          	ld	a,#4
3727  06b2 42            	mul	x,a
3728  06b3 58            	sllw	x
3729  06b4 58            	sllw	x
3730  06b5 58            	sllw	x
3731  06b6 1c0308        	addw	x,#776
3732  06b9 cd0000        	call	c_itolx
3734  06bc be02          	ldw	x,c_lreg+2
3735  06be 89            	pushw	x
3736  06bf be00          	ldw	x,c_lreg
3737  06c1 89            	pushw	x
3738  06c2 cd0000        	call	_WIZCHIP_READ
3740  06c5 5b04          	addw	sp,#4
3741  06c7 6b0e          	ld	(OFST-2,sp),a
3743                     ; 527     switch(sock_status){
3745  06c9 7b0e          	ld	a,(OFST-2,sp)
3747                     ; 572             break;
3748  06cb 4d            	tnz	a
3749  06cc 2603          	jrne	L452
3750  06ce cc0797        	jp	L3741
3751  06d1               L452:
3752  06d1 a014          	sub	a,#20
3753  06d3 272f          	jreq	L7641
3754  06d5 a003          	sub	a,#3
3755  06d7 2733          	jreq	L1741
3756  06d9               L5741:
3757                     ; 566         default:
3757                     ; 567             close(server_socket);
3759  06d9 b61c          	ld	a,L33_server_socket
3760  06db cd0000        	call	_close
3762                     ; 568             if(socket(server_socket, Sn_MR_TCP, server_port, 0) >= 0){
3764  06de 9c            	rvf
3765  06df 4b00          	push	#0
3766  06e1 be1d          	ldw	x,L53_server_port
3767  06e3 89            	pushw	x
3768  06e4 b61c          	ld	a,L33_server_socket
3769  06e6 ae0001        	ldw	x,#1
3770  06e9 95            	ld	xh,a
3771  06ea cd0000        	call	_socket
3773  06ed 9c            	rvf
3774  06ee 5b03          	addw	sp,#3
3775  06f0 a100          	cp	a,#0
3776  06f2 2e03          	jrsge	L652
3777  06f4 cc07c3        	jp	L1451
3778  06f7               L652:
3779                     ; 569                 listen(server_socket);
3781  06f7 b61c          	ld	a,L33_server_socket
3782  06f9 cd0000        	call	_listen
3784                     ; 570                 server_state = TCP_STATE_LISTENING;
3786  06fc 3501000a      	mov	L32_server_state,#1
3787  0700 acc307c3      	jpf	L1451
3788  0704               L7641:
3789                     ; 528         case SOCK_LISTEN:
3789                     ; 529             server_state = TCP_STATE_LISTENING;
3791  0704 3501000a      	mov	L32_server_state,#1
3792                     ; 530             break;
3794  0708 acc307c3      	jpf	L1451
3795  070c               L1741:
3796                     ; 532         case SOCK_ESTABLISHED:
3796                     ; 533             server_state = TCP_STATE_CONNECTED;
3798  070c 3502000a      	mov	L32_server_state,#2
3799                     ; 534             received_len = getSn_RX_RSR(server_socket);
3801  0710 b61c          	ld	a,L33_server_socket
3802  0712 cd0000        	call	_getSn_RX_RSR
3804  0715 1f0f          	ldw	(OFST-1,sp),x
3806                     ; 535             if(received_len > 0){
3808  0717 1e0f          	ldw	x,(OFST-1,sp)
3809  0719 2603          	jrne	L062
3810  071b cc07c3        	jp	L1451
3811  071e               L062:
3812                     ; 536                 uint16_t read_len = (received_len > TCP_RX_BUFFER) ? TCP_RX_BUFFER : received_len;
3814  071e 1e0f          	ldw	x,(OFST-1,sp)
3815  0720 a30007        	cpw	x,#7
3816  0723 2505          	jrult	L442
3817  0725 ae0006        	ldw	x,#6
3818  0728 2002          	jra	L642
3819  072a               L442:
3820  072a 1e0f          	ldw	x,(OFST-1,sp)
3821  072c               L642:
3822  072c 1f0f          	ldw	(OFST-1,sp),x
3824                     ; 538                 read_len = recv(server_socket, rx_buffer, read_len);
3826  072e 1e0f          	ldw	x,(OFST-1,sp)
3827  0730 89            	pushw	x
3828  0731 ae0026        	ldw	x,#_rx_buffer
3829  0734 89            	pushw	x
3830  0735 b61c          	ld	a,L33_server_socket
3831  0737 cd0000        	call	_recv
3833  073a 5b04          	addw	sp,#4
3834  073c be02          	ldw	x,c_lreg+2
3835  073e 1f0f          	ldw	(OFST-1,sp),x
3837                     ; 539                 if(read_len > 0 && read_len < TCP_RX_BUFFER){
3839  0740 1e0f          	ldw	x,(OFST-1,sp)
3840  0742 270b          	jreq	L5451
3842  0744 1e0f          	ldw	x,(OFST-1,sp)
3843  0746 a30006        	cpw	x,#6
3844  0749 2404          	jruge	L5451
3845                     ; 540                     rx_buffer[read_len] = '\0';
3847  074b 1e0f          	ldw	x,(OFST-1,sp)
3848  074d 6f26          	clr	(_rx_buffer,x)
3849  074f               L5451:
3850                     ; 542                 if(read_len > 0){
3852  074f 1e0f          	ldw	x,(OFST-1,sp)
3853  0751 2770          	jreq	L1451
3854                     ; 543                     if(command_parser_execute((const char *)rx_buffer, read_len) == 0){
3856  0753 1e0f          	ldw	x,(OFST-1,sp)
3857  0755 89            	pushw	x
3858  0756 ae0026        	ldw	x,#_rx_buffer
3859  0759 cd03d5        	call	_command_parser_execute
3861  075c 5b02          	addw	sp,#2
3862  075e a30000        	cpw	x,#0
3863  0761 2660          	jrne	L1451
3864                     ; 546                         sensor_state_t state = sensor_reader_get_state();
3866  0763 96            	ldw	x,sp
3867  0764 1c000a        	addw	x,#OFST-6
3868  0767 89            	pushw	x
3869  0768 cd011a        	call	_sensor_reader_get_state
3871  076b 85            	popw	x
3872                     ; 547                         message_formatter_alive(resp_buf,sizeof(resp_buf),state.di1,state.di2,state.di3,state.di4);
3874  076c 7b0d          	ld	a,(OFST-3,sp)
3875  076e 88            	push	a
3876  076f 7b0d          	ld	a,(OFST-3,sp)
3877  0771 88            	push	a
3878  0772 7b0d          	ld	a,(OFST-3,sp)
3879  0774 88            	push	a
3880  0775 7b0d          	ld	a,(OFST-3,sp)
3881  0777 88            	push	a
3882  0778 ae0005        	ldw	x,#5
3883  077b 89            	pushw	x
3884  077c 96            	ldw	x,sp
3885  077d 1c000b        	addw	x,#OFST-5
3886  0780 cd0126        	call	_message_formatter_alive
3888  0783 5b06          	addw	sp,#6
3889                     ; 548                         tcp_server_send((uint8_t *)resp_buf, strlen(resp_buf));
3891  0785 96            	ldw	x,sp
3892  0786 1c0005        	addw	x,#OFST-11
3893  0789 cd0000        	call	_strlen
3895  078c 89            	pushw	x
3896  078d 96            	ldw	x,sp
3897  078e 1c0007        	addw	x,#OFST-9
3898  0791 cd0041        	call	_tcp_server_send
3900  0794 85            	popw	x
3901  0795 202c          	jra	L1451
3902  0797               L3741:
3903                     ; 554         case SOCK_CLOSED:
3903                     ; 555             server_state = TCP_STATE_LISTENING;
3905  0797 3501000a      	mov	L32_server_state,#1
3906                     ; 556             close(server_socket);
3908  079b b61c          	ld	a,L33_server_socket
3909  079d cd0000        	call	_close
3911                     ; 557             if(socket(server_socket, Sn_MR_TCP, server_port, 0) >= 0)
3913  07a0 9c            	rvf
3914  07a1 4b00          	push	#0
3915  07a3 be1d          	ldw	x,L53_server_port
3916  07a5 89            	pushw	x
3917  07a6 b61c          	ld	a,L33_server_socket
3918  07a8 ae0001        	ldw	x,#1
3919  07ab 95            	ld	xh,a
3920  07ac cd0000        	call	_socket
3922  07af 9c            	rvf
3923  07b0 5b03          	addw	sp,#3
3924  07b2 a100          	cp	a,#0
3925  07b4 2f0d          	jrslt	L1451
3926                     ; 559                 if(listen(server_socket) == SOCK_OK)
3928  07b6 b61c          	ld	a,L33_server_socket
3929  07b8 cd0000        	call	_listen
3931  07bb a101          	cp	a,#1
3932  07bd 2604          	jrne	L1451
3933                     ; 561                     server_state = TCP_STATE_LISTENING;
3935  07bf 3501000a      	mov	L32_server_state,#1
3936  07c3               L1451:
3937                     ; 574 }
3938  07c3               L052:
3941  07c3 5b10          	addw	sp,#16
3942  07c5 81            	ret
3945                     	switch	.const
3946  0008               L3651_mac:
3947  0008 00            	dc.b	0
3948  0009 08            	dc.b	8
3949  000a dc            	dc.b	220
3950  000b 12            	dc.b	18
3951  000c 34            	dc.b	52
3952  000d 56            	dc.b	86
3953  000e               L5651_ip:
3954  000e c0            	dc.b	192
3955  000f a8            	dc.b	168
3956  0010 01            	dc.b	1
3957  0011 64            	dc.b	100
3958  0012               L7651_sn:
3959  0012 ff            	dc.b	255
3960  0013 ff            	dc.b	255
3961  0014 ff            	dc.b	255
3962  0015 00            	dc.b	0
3963  0016               L1751_gw:
3964  0016 c0            	dc.b	192
3965  0017 a8            	dc.b	168
3966  0018 01            	dc.b	1
3967  0019 01            	dc.b	1
4099                     ; 575 static void w5500_init_network(void)
4099                     ; 576 {
4100                     	switch	.text
4101  07c6               L1651_w5500_init_network:
4103  07c6 5228          	subw	sp,#40
4104       00000028      OFST:	set	40
4107                     ; 579     uint8_t mac[6] = MAC_ADDR;
4109  07c8 96            	ldw	x,sp
4110  07c9 1c0001        	addw	x,#OFST-39
4111  07cc 90ae0008      	ldw	y,#L3651_mac
4112  07d0 a606          	ld	a,#6
4113  07d2 cd0000        	call	c_xymov
4115                     ; 580     uint8_t ip[4]  = IP_ADDR;
4117  07d5 96            	ldw	x,sp
4118  07d6 1c0007        	addw	x,#OFST-33
4119  07d9 90ae000e      	ldw	y,#L5651_ip
4120  07dd a604          	ld	a,#4
4121  07df cd0000        	call	c_xymov
4123                     ; 581     uint8_t sn[4]  = SUBNET_MASK;
4125  07e2 96            	ldw	x,sp
4126  07e3 1c000b        	addw	x,#OFST-29
4127  07e6 90ae0012      	ldw	y,#L7651_sn
4128  07ea a604          	ld	a,#4
4129  07ec cd0000        	call	c_xymov
4131                     ; 582     uint8_t gw[4]  = GATEWAY_ADDR;
4133  07ef 96            	ldw	x,sp
4134  07f0 1c000f        	addw	x,#OFST-25
4135  07f3 90ae0016      	ldw	y,#L1751_gw
4136  07f7 a604          	ld	a,#4
4137  07f9 cd0000        	call	c_xymov
4139                     ; 584     memcpy(netinfo.mac, mac, 6);
4141  07fc 96            	ldw	x,sp
4142  07fd 1c0013        	addw	x,#OFST-21
4143  0800 bf00          	ldw	c_x,x
4144  0802 9096          	ldw	y,sp
4145  0804 72a90001      	addw	y,#OFST-39
4146  0808 90bf00        	ldw	c_y,y
4147  080b ae0006        	ldw	x,#6
4148  080e               L462:
4149  080e 5a            	decw	x
4150  080f 92d600        	ld	a,([c_y.w],x)
4151  0812 92d700        	ld	([c_x.w],x),a
4152  0815 5d            	tnzw	x
4153  0816 26f6          	jrne	L462
4154                     ; 585     memcpy(netinfo.ip,  ip, 4);
4156  0818 96            	ldw	x,sp
4157  0819 1c0019        	addw	x,#OFST-15
4158  081c bf00          	ldw	c_x,x
4159  081e 9096          	ldw	y,sp
4160  0820 72a90007      	addw	y,#OFST-33
4161  0824 90bf00        	ldw	c_y,y
4162  0827 ae0004        	ldw	x,#4
4163  082a               L662:
4164  082a 5a            	decw	x
4165  082b 92d600        	ld	a,([c_y.w],x)
4166  082e 92d700        	ld	([c_x.w],x),a
4167  0831 5d            	tnzw	x
4168  0832 26f6          	jrne	L662
4169                     ; 586     memcpy(netinfo.sn,  sn, 4);
4171  0834 96            	ldw	x,sp
4172  0835 1c001d        	addw	x,#OFST-11
4173  0838 bf00          	ldw	c_x,x
4174  083a 9096          	ldw	y,sp
4175  083c 72a9000b      	addw	y,#OFST-29
4176  0840 90bf00        	ldw	c_y,y
4177  0843 ae0004        	ldw	x,#4
4178  0846               L072:
4179  0846 5a            	decw	x
4180  0847 92d600        	ld	a,([c_y.w],x)
4181  084a 92d700        	ld	([c_x.w],x),a
4182  084d 5d            	tnzw	x
4183  084e 26f6          	jrne	L072
4184                     ; 587     memcpy(netinfo.gw,  gw, 4);
4186  0850 96            	ldw	x,sp
4187  0851 1c0021        	addw	x,#OFST-7
4188  0854 bf00          	ldw	c_x,x
4189  0856 9096          	ldw	y,sp
4190  0858 72a9000f      	addw	y,#OFST-25
4191  085c 90bf00        	ldw	c_y,y
4192  085f ae0004        	ldw	x,#4
4193  0862               L272:
4194  0862 5a            	decw	x
4195  0863 92d600        	ld	a,([c_y.w],x)
4196  0866 92d700        	ld	([c_x.w],x),a
4197  0869 5d            	tnzw	x
4198  086a 26f6          	jrne	L272
4199                     ; 589     wizchip_setnetinfo(&netinfo);
4201  086c 96            	ldw	x,sp
4202  086d 1c0013        	addw	x,#OFST-21
4203  0870 cd0000        	call	_wizchip_setnetinfo
4205                     ; 590 }
4208  0873 5b28          	addw	sp,#40
4209  0875 81            	ret
4249                     ; 591 void tcp_server_init(uint16_t port){
4250                     	switch	.text
4251  0876               _tcp_server_init:
4255                     ; 592     server_port = port;
4257  0876 bf1d          	ldw	L53_server_port,x
4258                     ; 593     server_state = TCP_STATE_IDLE;
4260  0878 3f0a          	clr	L32_server_state
4261                     ; 595     w5500_init_network();
4263  087a cd07c6        	call	L1651_w5500_init_network
4265                     ; 596     if(socket(server_socket, Sn_MR_TCP, server_port, 0) == server_socket){
4267  087d 4b00          	push	#0
4268  087f be1d          	ldw	x,L53_server_port
4269  0881 89            	pushw	x
4270  0882 b61c          	ld	a,L33_server_socket
4271  0884 ae0001        	ldw	x,#1
4272  0887 95            	ld	xh,a
4273  0888 cd0000        	call	_socket
4275  088b 5b03          	addw	sp,#3
4276  088d 5f            	clrw	x
4277  088e 4d            	tnz	a
4278  088f 2a01          	jrpl	L672
4279  0891 53            	cplw	x
4280  0892               L672:
4281  0892 97            	ld	xl,a
4282  0893 b61c          	ld	a,L33_server_socket
4283  0895 905f          	clrw	y
4284  0897 9097          	ld	yl,a
4285  0899 90bf00        	ldw	c_y,y
4286  089c b300          	cpw	x,c_y
4287  089e 260d          	jrne	L7761
4288                     ; 597         if(listen(server_socket) == SOCK_OK){
4290  08a0 b61c          	ld	a,L33_server_socket
4291  08a2 cd0000        	call	_listen
4293  08a5 a101          	cp	a,#1
4294  08a7 2604          	jrne	L7761
4295                     ; 598             server_state = TCP_STATE_LISTENING;
4297  08a9 3501000a      	mov	L32_server_state,#1
4298  08ad               L7761:
4299                     ; 601 }
4302  08ad 81            	ret
4305                     	switch	.const
4306  001a               L3071_txsize:
4307  001a 10            	dc.b	16
4308  001b 00            	dc.b	0
4309  001c 00            	dc.b	0
4310  001d 00            	dc.b	0
4311  001e 00            	dc.b	0
4312  001f 00            	dc.b	0
4313  0020 00            	dc.b	0
4314  0021 00            	dc.b	0
4315  0022               L5071_rxsize:
4316  0022 10            	dc.b	16
4317  0023 00            	dc.b	0
4318  0024 00            	dc.b	0
4319  0025 00            	dc.b	0
4320  0026 00            	dc.b	0
4321  0027 00            	dc.b	0
4322  0028 00            	dc.b	0
4323  0029 00            	dc.b	0
4401                     ; 603 void w5500_chip_init(void)
4401                     ; 604 {
4402                     	switch	.text
4403  08ae               _w5500_chip_init:
4405  08ae 5211          	subw	sp,#17
4406       00000011      OFST:	set	17
4409                     ; 606     uint8_t txsize[8] = {16,0,0,0,0,0,0,0};
4411  08b0 96            	ldw	x,sp
4412  08b1 1c0002        	addw	x,#OFST-15
4413  08b4 90ae001a      	ldw	y,#L3071_txsize
4414  08b8 a608          	ld	a,#8
4415  08ba cd0000        	call	c_xymov
4417                     ; 607     uint8_t rxsize[8] = {16,0,0,0,0,0,0,0};
4419  08bd 96            	ldw	x,sp
4420  08be 1c000a        	addw	x,#OFST-7
4421  08c1 90ae0022      	ldw	y,#L5071_rxsize
4422  08c5 a608          	ld	a,#8
4423  08c7 cd0000        	call	c_xymov
4425                     ; 609     GPIO_WriteLow(W5500_RST_PORT, W5500_RST_PIN);
4427  08ca 4b20          	push	#32
4428  08cc ae5014        	ldw	x,#20500
4429  08cf cd0000        	call	_GPIO_WriteLow
4431  08d2 84            	pop	a
4432                     ; 610     hal_delay_ms(100);
4434  08d3 ae0064        	ldw	x,#100
4435  08d6 cd0014        	call	_hal_delay_ms
4437                     ; 611     hal_w5500_reset_high();
4439  08d9 cd044a        	call	_hal_w5500_reset_high
4441                     ; 612     GPIO_WriteHigh(W5500_RST_PORT, W5500_RST_PIN);
4443  08dc 4b20          	push	#32
4444  08de ae5014        	ldw	x,#20500
4445  08e1 cd0000        	call	_GPIO_WriteHigh
4447  08e4 84            	pop	a
4448                     ; 613     CLK_PeripheralClockConfig(CLK_PERIPHERAL_SPI, ENABLE);
4450  08e5 ae0101        	ldw	x,#257
4451  08e8 cd0000        	call	_CLK_PeripheralClockConfig
4453                     ; 614     GPIO_Init(W5500_SCK_PORT,W5500_SCK_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
4455  08eb 4bf0          	push	#240
4456  08ed 4b20          	push	#32
4457  08ef ae500a        	ldw	x,#20490
4458  08f2 cd0000        	call	_GPIO_Init
4460  08f5 85            	popw	x
4461                     ; 615     GPIO_Init(W5500_MOSI_PORT,W5500_MOSI_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
4463  08f6 4bf0          	push	#240
4464  08f8 4b40          	push	#64
4465  08fa ae500a        	ldw	x,#20490
4466  08fd cd0000        	call	_GPIO_Init
4468  0900 85            	popw	x
4469                     ; 616     GPIO_Init(W5500_MISO_PORT,W5500_MISO_PIN,GPIO_MODE_IN_FL_NO_IT);
4471  0901 4b00          	push	#0
4472  0903 4b80          	push	#128
4473  0905 ae500a        	ldw	x,#20490
4474  0908 cd0000        	call	_GPIO_Init
4476  090b 85            	popw	x
4477                     ; 617     GPIO_Init(W5500_CS_PORT,W5500_CS_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
4479  090c 4bf0          	push	#240
4480  090e 4b08          	push	#8
4481  0910 ae5000        	ldw	x,#20480
4482  0913 cd0000        	call	_GPIO_Init
4484  0916 85            	popw	x
4485                     ; 618     GPIO_WriteHigh(W5500_CS_PORT, W5500_CS_PIN);
4487  0917 4b08          	push	#8
4488  0919 ae5000        	ldw	x,#20480
4489  091c cd0000        	call	_GPIO_WriteHigh
4491  091f 84            	pop	a
4492                     ; 619     GPIO_Init(W5500_RST_PORT,W5500_RST_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
4494  0920 4bf0          	push	#240
4495  0922 4b20          	push	#32
4496  0924 ae5014        	ldw	x,#20500
4497  0927 cd0000        	call	_GPIO_Init
4499  092a 85            	popw	x
4500                     ; 620     SPI_DeInit();
4502  092b cd0000        	call	_SPI_DeInit
4504                     ; 621         SPI_Init(
4504                     ; 622         SPI_FIRSTBIT_MSB,
4504                     ; 623         SPI_BAUDRATEPRESCALER_4,
4504                     ; 624         SPI_MODE_MASTER,
4504                     ; 625         SPI_CLOCKPOLARITY_LOW,
4504                     ; 626         SPI_CLOCKPHASE_1EDGE,
4504                     ; 627         SPI_DATADIRECTION_2LINES_FULLDUPLEX,
4504                     ; 628         SPI_NSS_SOFT,
4504                     ; 629         0x07
4504                     ; 630     );
4506  092e 4b07          	push	#7
4507  0930 4b02          	push	#2
4508  0932 4b00          	push	#0
4509  0934 4b00          	push	#0
4510  0936 4b00          	push	#0
4511  0938 4b04          	push	#4
4512  093a ae0008        	ldw	x,#8
4513  093d cd0000        	call	_SPI_Init
4515  0940 5b06          	addw	sp,#6
4516                     ; 632     SPI_Cmd(ENABLE);
4518  0942 a601          	ld	a,#1
4519  0944 cd0000        	call	_SPI_Cmd
4521                     ; 633     reg_wizchip_spi_cbfunc(hal_spi_read_byte,hal_spi_write_byte);
4523  0947 ae0610        	ldw	x,#_hal_spi_write_byte
4524  094a 89            	pushw	x
4525  094b ae060b        	ldw	x,#_hal_spi_read_byte
4526  094e cd0000        	call	_reg_wizchip_spi_cbfunc
4528  0951 85            	popw	x
4529                     ; 634     reg_wizchip_spiburst_cbfunc(hal_spi_read,hal_spi_write);
4531  0952 ae0634        	ldw	x,#_hal_spi_write
4532  0955 89            	pushw	x
4533  0956 ae0613        	ldw	x,#_hal_spi_read
4534  0959 cd0000        	call	_reg_wizchip_spiburst_cbfunc
4536  095c 85            	popw	x
4537                     ; 635     reg_wizchip_cs_cbfunc(hal_spi_cs_low,hal_spi_cs_high);
4539  095d ae00db        	ldw	x,#_hal_spi_cs_high
4540  0960 89            	pushw	x
4541  0961 ae00d1        	ldw	x,#_hal_spi_cs_low
4542  0964 cd0000        	call	_reg_wizchip_cs_cbfunc
4544  0967 85            	popw	x
4545                     ; 636     wizchip_init(txsize, rxsize);
4547  0968 96            	ldw	x,sp
4548  0969 1c000a        	addw	x,#OFST-7
4549  096c 89            	pushw	x
4550  096d 96            	ldw	x,sp
4551  096e 1c0004        	addw	x,#OFST-13
4552  0971 cd0000        	call	_wizchip_init
4554  0974 85            	popw	x
4555                     ; 637     version = getVERSIONR();
4557  0975 ae0039        	ldw	x,#57
4558  0978 89            	pushw	x
4559  0979 ae0000        	ldw	x,#0
4560  097c 89            	pushw	x
4561  097d cd0000        	call	_WIZCHIP_READ
4563  0980 5b04          	addw	sp,#4
4564  0982 6b01          	ld	(OFST-16,sp),a
4566                     ; 638     if(version != 0x04)
4568  0984 7b01          	ld	a,(OFST-16,sp)
4569  0986 a104          	cp	a,#4
4570  0988 2702          	jreq	L5371
4571  098a               L7371:
4572                     ; 640         while(1);
4574  098a 20fe          	jra	L7371
4575  098c               L5371:
4576                     ; 642 }
4579  098c 5b11          	addw	sp,#17
4580  098e 81            	ret
4616                     ; 644 void system_init(void){
4617                     	switch	.text
4618  098f               _system_init:
4622                     ; 646     CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);  /* 16MHz clock */
4624  098f 4f            	clr	a
4625  0990 cd0000        	call	_CLK_HSIPrescalerConfig
4627                     ; 648 	hal_gpio_init();
4629  0993 cd0454        	call	_hal_gpio_init
4631                     ; 649     hal_timer_init();
4633  0996 cd068b        	call	_hal_timer_init
4635                     ; 651 	relay_control_init();
4637  0999 cd0444        	call	_relay_control_init
4639                     ; 652 	sensor_reader_init();
4641  099c cd032c        	call	_sensor_reader_init
4643                     ; 654     w5500_chip_init();
4645  099f cd08ae        	call	_w5500_chip_init
4647                     ; 655     tcp_server_init(TCP_SERVER_PORT);
4649  09a2 ae1388        	ldw	x,#5000
4650  09a5 cd0876        	call	_tcp_server_init
4652                     ; 657     uart_server_init(UART_BAUDRATE);
4654  09a8 aec200        	ldw	x,#49664
4655  09ab 89            	pushw	x
4656  09ac ae0001        	ldw	x,#1
4657  09af 89            	pushw	x
4658  09b0 cd0653        	call	_uart_server_init
4660  09b3 5b04          	addw	sp,#4
4661                     ; 660     hal_timer_set_callback(timer_callback);
4663  09b5 ae0387        	ldw	x,#_timer_callback
4664  09b8 cd03d2        	call	_hal_timer_set_callback
4666                     ; 661     hal_timer_start();
4668  09bb cd02aa        	call	_hal_timer_start
4670                     ; 662 	hal_delay_ms(500);
4672  09be ae01f4        	ldw	x,#500
4673  09c1 cd0014        	call	_hal_delay_ms
4675                     ; 663 }
4678  09c4 81            	ret
4681                     	switch	.const
4682  002a               L3571_msg:
4683  002a 52455345542c  	dc.b	"RESET, OK",10,0
4725                     ; 665 void main_loop(void)
4725                     ; 666 {
4726                     	switch	.text
4727  09c5               _main_loop:
4729  09c5 520b          	subw	sp,#11
4730       0000000b      OFST:	set	11
4733  09c7               L3771:
4734                     ; 670         tcp_server_process();
4736  09c7 cd06a4        	call	_tcp_server_process
4738                     ; 672 		uart_server_process();
4740  09ca cd052b        	call	_uart_server_process
4742                     ; 674         if(GPIO_ReadInputPin(HARDRST_PORT, HARDRST_PIN) == RESET)
4744  09cd 4b80          	push	#128
4745  09cf ae5005        	ldw	x,#20485
4746  09d2 cd0000        	call	_GPIO_ReadInputPin
4748  09d5 5b01          	addw	sp,#1
4749  09d7 4d            	tnz	a
4750  09d8 26ed          	jrne	L3771
4751                     ; 676             hal_delay_ms(50);
4753  09da ae0032        	ldw	x,#50
4754  09dd cd0014        	call	_hal_delay_ms
4756                     ; 677 			if (GPIO_ReadInputPin(HARDRST_PORT, HARDRST_PIN) == 0){
4758  09e0 4b80          	push	#128
4759  09e2 ae5005        	ldw	x,#20485
4760  09e5 cd0000        	call	_GPIO_ReadInputPin
4762  09e8 5b01          	addw	sp,#1
4763  09ea 4d            	tnz	a
4764  09eb 26da          	jrne	L3771
4765                     ; 679 				char msg[] = "RESET, OK\n";
4767  09ed 96            	ldw	x,sp
4768  09ee 1c0001        	addw	x,#OFST-10
4769  09f1 90ae002a      	ldw	y,#L3571_msg
4770  09f5 a60b          	ld	a,#11
4771  09f7 cd0000        	call	c_xymov
4773                     ; 680                 if(tcp_server_is_connected()){
4775  09fa cd0007        	call	_tcp_server_is_connected
4777  09fd a30000        	cpw	x,#0
4778  0a00 2710          	jreq	L3002
4779                     ; 681                     tcp_server_send((uint8_t *)msg, strlen(msg));
4781  0a02 96            	ldw	x,sp
4782  0a03 1c0001        	addw	x,#OFST-10
4783  0a06 cd0000        	call	_strlen
4785  0a09 89            	pushw	x
4786  0a0a 96            	ldw	x,sp
4787  0a0b 1c0003        	addw	x,#OFST-8
4788  0a0e cd0041        	call	_tcp_server_send
4790  0a11 85            	popw	x
4791  0a12               L3002:
4792                     ; 683                 if (uart_server_is_ready()){
4794  0a12 cd008d        	call	_uart_server_is_ready
4796  0a15 a30000        	cpw	x,#0
4797  0a18 2710          	jreq	L5002
4798                     ; 684                     uart_server_send((uint8_t *)msg, strlen(msg));
4800  0a1a 96            	ldw	x,sp
4801  0a1b 1c0001        	addw	x,#OFST-10
4802  0a1e cd0000        	call	_strlen
4804  0a21 89            	pushw	x
4805  0a22 96            	ldw	x,sp
4806  0a23 1c0003        	addw	x,#OFST-8
4807  0a26 cd00e5        	call	_uart_server_send
4809  0a29 85            	popw	x
4810  0a2a               L5002:
4811                     ; 686 				hal_delay_ms(100);
4813  0a2a ae0064        	ldw	x,#100
4814  0a2d cd0014        	call	_hal_delay_ms
4816  0a30 2095          	jra	L3771
4841                     ; 693 int main(void)
4841                     ; 694 {
4842                     	switch	.text
4843  0a32               _main:
4847                     ; 695 	system_init();
4849  0a32 cd098f        	call	_system_init
4851                     ; 696     main_loop();
4853  0a35 ad8e          	call	_main_loop
4855  0a37               L7102:
4856                     ; 697     while(1);
4858  0a37 20fe          	jra	L7102
5177                     	xdef	_main
5178                     	xdef	_main_loop
5179                     	xdef	_system_init
5180                     	xdef	_w5500_chip_init
5181                     	xdef	_tcp_server_init
5182                     	xdef	_tcp_server_process
5183                     	xdef	_hal_timer_init
5184                     	xdef	_uart_server_init
5185                     	xdef	_hal_spi_write
5186                     	xdef	_hal_spi_read
5187                     	xdef	_hal_spi_write_byte
5188                     	xdef	_hal_spi_read_byte
5189                     	xdef	_hal_spi_byte
5190                     	xdef	_uart_server_process
5191                     	xdef	_hal_uart_read_byte
5192                     	xdef	_hal_uart_available
5193                     	xdef	_hal_gpio_init
5194                     	xdef	_hal_w5500_reset_high
5195                     	xdef	_relay_control_init
5196                     	xdef	_command_parser_execute
5197                     	xdef	_hal_timer_set_callback
5198                     	xdef	_timer_callback
5199                     	xdef	_send_alive_message
5200                     	xdef	_sensor_reader_init
5201                     	xdef	_process_axle_counting
5202                     	xdef	_hal_timer_start
5203                     	xdef	_sensor_reader_update
5204                     	xdef	_relay_control_set_all
5205                     	xdef	_relay_control_set
5206                     	xdef	_hal_relay_set
5207                     	xdef	_hal_di_read
5208                     	xdef	_message_formatter_alive
5209                     	xdef	_sensor_reader_get_state
5210                     	xdef	_uart_server_send
5211                     	xdef	_hal_spi_cs_high
5212                     	xdef	_hal_spi_cs_low
5213                     	xdef	_hal_uart_send
5214                     	xdef	_hal_uart_send_byte
5215                     	xdef	_uart_server_is_ready
5216                     	xdef	_tcp_server_send
5217                     	xdef	_hal_delay_ms
5218                     	xdef	_tcp_server_is_connected
5219                     	xdef	_hal_get_millis
5220                     	xdef	_user_callback
5221                     	xdef	_systick_ms
5222                     	switch	.ubsct
5223  0000               _uart_rx_buffer:
5224  0000 000000000000  	ds.b	6
5225                     	xdef	_uart_rx_buffer
5226  0006               L73_uart_tx_buffer:
5227  0006 000000000000  	ds.b	16
5228                     	xdef	_uart_rx_tail
5229                     	xdef	_uart_rx_head
5230                     	xdef	_uart_rx_count
5231  0016               _tx_buffer:
5232  0016 000000000000  	ds.b	16
5233                     	xdef	_tx_buffer
5234  0026               _rx_buffer:
5235  0026 000000000000  	ds.b	6
5236                     	xdef	_rx_buffer
5237                     	xref	_strlen
5238                     	xref	_send
5239                     	xref	_recv
5240                     	xref	_listen
5241                     	xref	_close
5242                     	xref	_socket
5243                     	xref	_wizchip_init
5244                     	xref	_wizchip_setnetinfo
5245                     	xref	_reg_wizchip_spiburst_cbfunc
5246                     	xref	_reg_wizchip_spi_cbfunc
5247                     	xref	_getSn_RX_RSR
5248                     	xref	_reg_wizchip_cs_cbfunc
5249                     	xref	_WIZCHIP_READ
5250                     	xref	_TIM4_ClearFlag
5251                     	xref	_TIM4_ITConfig
5252                     	xref	_TIM4_Cmd
5253                     	xref	_TIM4_TimeBaseInit
5254                     	xref	_SPI_GetFlagStatus
5255                     	xref	_SPI_ReceiveData
5256                     	xref	_SPI_SendData
5257                     	xref	_SPI_Cmd
5258                     	xref	_SPI_Init
5259                     	xref	_SPI_DeInit
5260                     	xref	_UART1_GetFlagStatus
5261                     	xref	_UART1_SendData8
5262                     	xref	_UART1_ITConfig
5263                     	xref	_UART1_Cmd
5264                     	xref	_UART1_Init
5265                     	xref	_GPIO_ReadInputPin
5266                     	xref	_GPIO_WriteLow
5267                     	xref	_GPIO_WriteHigh
5268                     	xref	_GPIO_Init
5269                     	xref	_CLK_HSIPrescalerConfig
5270                     	xref	_CLK_PeripheralClockConfig
5271                     	switch	.const
5272  0035               L3521:
5273  0035 45525200      	dc.b	"ERR",0
5274                     	xref.b	c_lreg
5275                     	xref.b	c_x
5276                     	xref.b	c_y
5296                     	xref	c_itolx
5297                     	xref	c_smodx
5298                     	xref	c_xymov
5299                     	xref	c_lcmp
5300                     	xref	c_lsub
5301                     	xref	c_uitolx
5302                     	xref	c_rtol
5303                     	xref	c_ltor
5304                     	end
