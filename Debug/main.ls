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
  71  001f 0000          	dc.w	0
  72  0021               _uart_rx_head:
  73  0021 0000          	dc.w	0
  74  0023               _uart_rx_tail:
  75  0023 0000          	dc.w	0
  76  0025               _systick_ms:
  77  0025 00000000      	dc.l	0
  78  0029               _user_callback:
  79  0029 0000          	dc.w	0
 109                     ; 74 unsigned long hal_get_millis(void)
 109                     ; 75 {
 111                     	switch	.text
 112  0000               _hal_get_millis:
 116                     ; 76     return systick_ms;
 118  0000 ae0025        	ldw	x,#_systick_ms
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
 336  0050 a30021        	cpw	x,#33
 337  0053 2505          	jrult	L151
 338                     ; 96         len = TCP_TX_BUFFER;
 340  0055 ae0020        	ldw	x,#32
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
 353  0067 e725          	ld	(_tx_buffer,x),a
 354  0069 5d            	tnzw	x
 355  006a 26f7          	jrne	L22
 356  006c               L02:
 357                     ; 103     sent = send(server_socket, tx_buffer, len);
 359  006c 1e07          	ldw	x,(OFST+5,sp)
 360  006e 89            	pushw	x
 361  006f ae0025        	ldw	x,#_tx_buffer
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
 739  00f1 a30006        	cpw	x,#6
 740  00f4 2505          	jrult	L713
 741                     ; 144         len = sizeof(uart_tx_buffer);
 743  00f6 ae0005        	ldw	x,#5
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
 756  0108 e720          	ld	(L73_uart_tx_buffer,x),a
 757  010a 5d            	tnzw	x
 758  010b 26f7          	jrne	L45
 759  010d               L25:
 760                     ; 149     hal_uart_send(uart_tx_buffer, len);
 762  010d 1e05          	ldw	x,(OFST+5,sp)
 763  010f 89            	pushw	x
 764  0110 ae0020        	ldw	x,#L73_uart_tx_buffer
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
1400                     ; 297 void hal_relay_set(uint8_t relay_num, uint8_t state){
1401                     	switch	.text
1402  01c4               _hal_relay_set:
1404  01c4 89            	pushw	x
1405  01c5 5204          	subw	sp,#4
1406       00000004      OFST:	set	4
1409                     ; 300 	BitStatus bit_state = (state == 0) ? SET : RESET;
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
1423                     ; 302 	switch (relay_num) {
1425  01d5 7b05          	ld	a,(OFST+1,sp)
1427                     ; 309         default: return;
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
1445                     ; 303         case 1: port = RELAY1_PORT; pin = RELAY1_PIN; break;
1447  01eb ae5005        	ldw	x,#20485
1448  01ee 1f02          	ldw	(OFST-2,sp),x
1452  01f0 a608          	ld	a,#8
1453  01f2 6b04          	ld	(OFST+0,sp),a
1457  01f4 2035          	jra	L336
1458  01f6               L545:
1459                     ; 304         case 2: port = RELAY2_PORT; pin = RELAY2_PIN; break;
1461  01f6 ae5005        	ldw	x,#20485
1462  01f9 1f02          	ldw	(OFST-2,sp),x
1466  01fb a604          	ld	a,#4
1467  01fd 6b04          	ld	(OFST+0,sp),a
1471  01ff 202a          	jra	L336
1472  0201               L745:
1473                     ; 305         case 3: port = RELAY3_PORT; pin = RELAY3_PIN; break;
1475  0201 ae5005        	ldw	x,#20485
1476  0204 1f02          	ldw	(OFST-2,sp),x
1480  0206 a602          	ld	a,#2
1481  0208 6b04          	ld	(OFST+0,sp),a
1485  020a 201f          	jra	L336
1486  020c               L155:
1487                     ; 306         case 4: port = RELAY4_PORT; pin = RELAY4_PIN; break;
1489  020c ae5005        	ldw	x,#20485
1490  020f 1f02          	ldw	(OFST-2,sp),x
1494  0211 a601          	ld	a,#1
1495  0213 6b04          	ld	(OFST+0,sp),a
1499  0215 2014          	jra	L336
1500  0217               L355:
1501                     ; 307         case 5: port = RELAY5_PORT; pin = RELAY5_PIN; break;
1503  0217 ae500a        	ldw	x,#20490
1504  021a 1f02          	ldw	(OFST-2,sp),x
1508  021c a608          	ld	a,#8
1509  021e 6b04          	ld	(OFST+0,sp),a
1513  0220 2009          	jra	L336
1514  0222               L555:
1515                     ; 308         case 6: port = RELAY6_PORT; pin = RELAY6_PIN; break;
1517  0222 ae500a        	ldw	x,#20490
1518  0225 1f02          	ldw	(OFST-2,sp),x
1522  0227 a610          	ld	a,#16
1523  0229 6b04          	ld	(OFST+0,sp),a
1527  022b               L336:
1528                     ; 312 	if (bit_state == SET) {
1530  022b 7b01          	ld	a,(OFST-3,sp)
1531  022d a101          	cp	a,#1
1532  022f 260b          	jrne	L536
1533                     ; 313         GPIO_WriteHigh(port, pin);  /* Set HIGH = relay off */
1535  0231 7b04          	ld	a,(OFST+0,sp)
1536  0233 88            	push	a
1537  0234 1e03          	ldw	x,(OFST-1,sp)
1538  0236 cd0000        	call	_GPIO_WriteHigh
1540  0239 84            	pop	a
1542  023a 2009          	jra	L736
1543  023c               L536:
1544                     ; 315         GPIO_WriteLow(port, pin); /* Set LOW = relay on */
1546  023c 7b04          	ld	a,(OFST+0,sp)
1547  023e 88            	push	a
1548  023f 1e03          	ldw	x,(OFST-1,sp)
1549  0241 cd0000        	call	_GPIO_WriteLow
1551  0244 84            	pop	a
1552  0245               L736:
1553                     ; 317 }
1554  0245               L421:
1557  0245 5b06          	addw	sp,#6
1558  0247 81            	ret
1602                     ; 319 void relay_control_set(uint8_t relay_num, uint8_t state)
1602                     ; 320 {
1603                     	switch	.text
1604  0248               _relay_control_set:
1606  0248 89            	pushw	x
1607       00000000      OFST:	set	0
1610                     ; 321     if (relay_num >= 1 && relay_num <= 6) {
1612  0249 9e            	ld	a,xh
1613  024a 4d            	tnz	a
1614  024b 270d          	jreq	L366
1616  024d 9e            	ld	a,xh
1617  024e a107          	cp	a,#7
1618  0250 2408          	jruge	L366
1619                     ; 322         hal_relay_set(relay_num, state);
1621  0252 9f            	ld	a,xl
1622  0253 97            	ld	xl,a
1623  0254 7b01          	ld	a,(OFST+1,sp)
1624  0256 95            	ld	xh,a
1625  0257 cd01c4        	call	_hal_relay_set
1627  025a               L366:
1628                     ; 324 }
1631  025a 85            	popw	x
1632  025b 81            	ret
1668                     ; 326 void relay_control_set_all(uint8_t state)
1668                     ; 327 {
1669                     	switch	.text
1670  025c               _relay_control_set_all:
1672  025c 88            	push	a
1673       00000000      OFST:	set	0
1676                     ; 328     relay_control_set(1, state);
1678  025d ae0100        	ldw	x,#256
1679  0260 97            	ld	xl,a
1680  0261 ade5          	call	_relay_control_set
1682                     ; 329     relay_control_set(2, state);
1684  0263 7b01          	ld	a,(OFST+1,sp)
1685  0265 ae0200        	ldw	x,#512
1686  0268 97            	ld	xl,a
1687  0269 addd          	call	_relay_control_set
1689                     ; 330     relay_control_set(3, state);
1691  026b 7b01          	ld	a,(OFST+1,sp)
1692  026d ae0300        	ldw	x,#768
1693  0270 97            	ld	xl,a
1694  0271 add5          	call	_relay_control_set
1696                     ; 331     relay_control_set(4, state);
1698  0273 7b01          	ld	a,(OFST+1,sp)
1699  0275 ae0400        	ldw	x,#1024
1700  0278 97            	ld	xl,a
1701  0279 adcd          	call	_relay_control_set
1703                     ; 332     relay_control_set(5, state);
1705  027b 7b01          	ld	a,(OFST+1,sp)
1706  027d ae0500        	ldw	x,#1280
1707  0280 97            	ld	xl,a
1708  0281 adc5          	call	_relay_control_set
1710                     ; 333     relay_control_set(6, state);
1712  0283 7b01          	ld	a,(OFST+1,sp)
1713  0285 ae0600        	ldw	x,#1536
1714  0288 97            	ld	xl,a
1715  0289 adbd          	call	_relay_control_set
1717                     ; 334 }
1720  028b 84            	pop	a
1721  028c 81            	ret
1747                     ; 336 void sensor_reader_update(void){
1748                     	switch	.text
1749  028d               _sensor_reader_update:
1753                     ; 337     current_state.di1 = hal_di_read(1);
1755  028d a601          	ld	a,#1
1756  028f cd0173        	call	_hal_di_read
1758  0292 b717          	ld	L72_current_state,a
1759                     ; 338     current_state.di2 = hal_di_read(2);
1761  0294 a602          	ld	a,#2
1762  0296 cd0173        	call	_hal_di_read
1764  0299 b718          	ld	L72_current_state+1,a
1765                     ; 339     current_state.di3 = hal_di_read(3);
1767  029b a603          	ld	a,#3
1768  029d cd0173        	call	_hal_di_read
1770  02a0 b719          	ld	L72_current_state+2,a
1771                     ; 340     current_state.di4 = hal_di_read(4);
1773  02a2 a604          	ld	a,#4
1774  02a4 cd0173        	call	_hal_di_read
1776  02a7 b71a          	ld	L72_current_state+3,a
1777                     ; 341 }
1780  02a9 81            	ret
1804                     ; 344 void hal_timer_start(void)
1804                     ; 345 {
1805                     	switch	.text
1806  02aa               _hal_timer_start:
1810                     ; 346     TIM4_Cmd(ENABLE);
1812  02aa a601          	ld	a,#1
1813  02ac cd0000        	call	_TIM4_Cmd
1815                     ; 347 }
1818  02af 81            	ret
1870                     ; 387 void process_axle_counting(void)
1870                     ; 388 {
1871                     	switch	.text
1872  02b0               _process_axle_counting:
1874  02b0 520d          	subw	sp,#13
1875       0000000d      OFST:	set	13
1878                     ; 389     sensor_state_t sensor = sensor_reader_get_state();
1880  02b2 96            	ldw	x,sp
1881  02b3 1c000a        	addw	x,#OFST-3
1882  02b6 89            	pushw	x
1883  02b7 cd011a        	call	_sensor_reader_get_state
1885  02ba 85            	popw	x
1886                     ; 393     msg_buf[0] = sensor.di1 ? '1' : '0';
1888  02bb 0d0a          	tnz	(OFST-3,sp)
1889  02bd 2704          	jreq	L041
1890  02bf a631          	ld	a,#49
1891  02c1 2002          	jra	L241
1892  02c3               L041:
1893  02c3 a630          	ld	a,#48
1894  02c5               L241:
1895  02c5 6b05          	ld	(OFST-8,sp),a
1897                     ; 394     msg_buf[1] = sensor.di2 ? '1' : '0';
1899  02c7 0d0b          	tnz	(OFST-2,sp)
1900  02c9 2704          	jreq	L441
1901  02cb a631          	ld	a,#49
1902  02cd 2002          	jra	L641
1903  02cf               L441:
1904  02cf a630          	ld	a,#48
1905  02d1               L641:
1906  02d1 6b06          	ld	(OFST-7,sp),a
1908                     ; 395     msg_buf[2] = sensor.di3 ? '1' : '0';
1910  02d3 0d0c          	tnz	(OFST-1,sp)
1911  02d5 2704          	jreq	L051
1912  02d7 a631          	ld	a,#49
1913  02d9 2002          	jra	L251
1914  02db               L051:
1915  02db a630          	ld	a,#48
1916  02dd               L251:
1917  02dd 6b07          	ld	(OFST-6,sp),a
1919                     ; 396     msg_buf[3] = sensor.di4 ? '1' : '0';
1921  02df 0d0d          	tnz	(OFST+0,sp)
1922  02e1 2704          	jreq	L451
1923  02e3 a631          	ld	a,#49
1924  02e5 2002          	jra	L651
1925  02e7               L451:
1926  02e7 a630          	ld	a,#48
1927  02e9               L651:
1928  02e9 6b08          	ld	(OFST-5,sp),a
1930                     ; 397     msg_buf[4] = '\0';
1932  02eb 0f09          	clr	(OFST-4,sp)
1934                     ; 400     if ((sensor.di1 != axle_counter.prev_di1_state) ||
1934                     ; 401         (sensor.di2 != axle_counter.prev_di2_state))
1936  02ed 7b0a          	ld	a,(OFST-3,sp)
1937  02ef b105          	cp	a,L12_axle_counter+3
1938  02f1 2606          	jrne	L747
1940  02f3 7b0b          	ld	a,(OFST-2,sp)
1941  02f5 b103          	cp	a,L12_axle_counter+1
1942  02f7 2728          	jreq	L547
1943  02f9               L747:
1944                     ; 403         if (uart_server_is_ready())
1946  02f9 cd008d        	call	_uart_server_is_ready
1948  02fc a30000        	cpw	x,#0
1949  02ff 270c          	jreq	L157
1950                     ; 405             uart_server_send((uint8_t *)msg_buf, 4);
1952  0301 ae0004        	ldw	x,#4
1953  0304 89            	pushw	x
1954  0305 96            	ldw	x,sp
1955  0306 1c0007        	addw	x,#OFST-6
1956  0309 cd00e5        	call	_uart_server_send
1958  030c 85            	popw	x
1959  030d               L157:
1960                     ; 408         if (tcp_server_is_connected())
1962  030d cd0007        	call	_tcp_server_is_connected
1964  0310 a30000        	cpw	x,#0
1965  0313 270c          	jreq	L547
1966                     ; 410             tcp_server_send((uint8_t *)msg_buf, 4);
1968  0315 ae0004        	ldw	x,#4
1969  0318 89            	pushw	x
1970  0319 96            	ldw	x,sp
1971  031a 1c0007        	addw	x,#OFST-6
1972  031d cd0041        	call	_tcp_server_send
1974  0320 85            	popw	x
1975  0321               L547:
1976                     ; 414     axle_counter.prev_di1_state = sensor.di1;
1978  0321 7b0a          	ld	a,(OFST-3,sp)
1979  0323 b705          	ld	L12_axle_counter+3,a
1980                     ; 415     axle_counter.prev_di2_state = sensor.di2;
1982  0325 7b0b          	ld	a,(OFST-2,sp)
1983  0327 b703          	ld	L12_axle_counter+1,a
1984                     ; 416 }
1987  0329 5b0d          	addw	sp,#13
1988  032b 81            	ret
2012                     ; 417 void sensor_reader_init(void)
2012                     ; 418 {
2013                     	switch	.text
2014  032c               _sensor_reader_init:
2018                     ; 420     sensor_reader_update();
2020  032c cd028d        	call	_sensor_reader_update
2022                     ; 421 }
2025  032f 81            	ret
2075                     ; 423 void send_alive_message(void)
2075                     ; 424 {
2076                     	switch	.text
2077  0330               _send_alive_message:
2079  0330 5228          	subw	sp,#40
2080       00000028      OFST:	set	40
2083                     ; 428     sensor = sensor_reader_get_state();
2085  0332 96            	ldw	x,sp
2086  0333 1c0025        	addw	x,#OFST-3
2087  0336 89            	pushw	x
2088  0337 cd011a        	call	_sensor_reader_get_state
2090  033a 85            	popw	x
2091                     ; 430     message_formatter_alive(
2091                     ; 431         msg_buf,
2091                     ; 432         sizeof(msg_buf),
2091                     ; 433         sensor.di1,
2091                     ; 434         sensor.di2,
2091                     ; 435         sensor.di3,
2091                     ; 436         sensor.di4
2091                     ; 437     );
2093  033b 7b28          	ld	a,(OFST+0,sp)
2094  033d 88            	push	a
2095  033e 7b28          	ld	a,(OFST+0,sp)
2096  0340 88            	push	a
2097  0341 7b28          	ld	a,(OFST+0,sp)
2098  0343 88            	push	a
2099  0344 7b28          	ld	a,(OFST+0,sp)
2100  0346 88            	push	a
2101  0347 ae0020        	ldw	x,#32
2102  034a 89            	pushw	x
2103  034b 96            	ldw	x,sp
2104  034c 1c000b        	addw	x,#OFST-29
2105  034f cd0126        	call	_message_formatter_alive
2107  0352 5b06          	addw	sp,#6
2108                     ; 439     if (uart_server_is_ready())
2110  0354 cd008d        	call	_uart_server_is_ready
2112  0357 a30000        	cpw	x,#0
2113  035a 2710          	jreq	L7001
2114                     ; 441         uart_server_send((uint8_t *)msg_buf, strlen(msg_buf));
2116  035c 96            	ldw	x,sp
2117  035d 1c0005        	addw	x,#OFST-35
2118  0360 cd0000        	call	_strlen
2120  0363 89            	pushw	x
2121  0364 96            	ldw	x,sp
2122  0365 1c0007        	addw	x,#OFST-33
2123  0368 cd00e5        	call	_uart_server_send
2125  036b 85            	popw	x
2126  036c               L7001:
2127                     ; 443 }
2130  036c 5b28          	addw	sp,#40
2131  036e 81            	ret
2159                     .const:	section	.text
2160  0000               L661:
2161  0000 00000032      	dc.l	50
2162  0004               L071:
2163  0004 000001f4      	dc.l	500
2164                     ; 445 void timer_callback(void){
2165                     	switch	.text
2166  036f               _timer_callback:
2170                     ; 446     task_timer.current_time = hal_get_millis();
2172  036f cd0000        	call	_hal_get_millis
2174  0372 ae0013        	ldw	x,#L52_task_timer+8
2175  0375 cd0000        	call	c_rtol
2177                     ; 447     if ((task_timer.current_time - task_timer.last_sensor_time) >= SENSOR_READ_INTERVAL){
2179  0378 ae0013        	ldw	x,#L52_task_timer+8
2180  037b cd0000        	call	c_ltor
2182  037e ae000f        	ldw	x,#L52_task_timer+4
2183  0381 cd0000        	call	c_lsub
2185  0384 ae0000        	ldw	x,#L661
2186  0387 cd0000        	call	c_lcmp
2188  038a 250e          	jrult	L1201
2189                     ; 448         sensor_reader_update();
2191  038c cd028d        	call	_sensor_reader_update
2193                     ; 449         process_axle_counting();
2195  038f cd02b0        	call	_process_axle_counting
2197                     ; 450         task_timer.last_sensor_time = task_timer.current_time;
2199  0392 be15          	ldw	x,L52_task_timer+10
2200  0394 bf11          	ldw	L52_task_timer+6,x
2201  0396 be13          	ldw	x,L52_task_timer+8
2202  0398 bf0f          	ldw	L52_task_timer+4,x
2203  039a               L1201:
2204                     ; 453     if ((task_timer.current_time - task_timer.last_alive_time) >= ALIVE_INTERVAL){
2206  039a ae0013        	ldw	x,#L52_task_timer+8
2207  039d cd0000        	call	c_ltor
2209  03a0 ae000b        	ldw	x,#L52_task_timer
2210  03a3 cd0000        	call	c_lsub
2212  03a6 ae0004        	ldw	x,#L071
2213  03a9 cd0000        	call	c_lcmp
2215  03ac 250a          	jrult	L3201
2216                     ; 454         send_alive_message();  
2218  03ae ad80          	call	_send_alive_message
2220                     ; 455         task_timer.last_alive_time = task_timer.current_time;
2222  03b0 be15          	ldw	x,L52_task_timer+10
2223  03b2 bf0d          	ldw	L52_task_timer+2,x
2224  03b4 be13          	ldw	x,L52_task_timer+8
2225  03b6 bf0b          	ldw	L52_task_timer,x
2226  03b8               L3201:
2227                     ; 457 }
2230  03b8 81            	ret
2268                     ; 459 void hal_timer_set_callback(timer_callback_t callback)
2268                     ; 460 {
2269                     	switch	.text
2270  03b9               _hal_timer_set_callback:
2274                     ; 461     user_callback = callback;
2276  03b9 bf29          	ldw	_user_callback,x
2277                     ; 462 }
2280  03bb 81            	ret
2344                     ; 464 int command_parser_execute(const char *cmd_str, int len)
2344                     ; 465 {
2345                     	switch	.text
2346  03bc               _command_parser_execute:
2348  03bc 89            	pushw	x
2349  03bd 89            	pushw	x
2350       00000002      OFST:	set	2
2353                     ; 470     if (len < 4)
2355  03be 9c            	rvf
2356  03bf 1e07          	ldw	x,(OFST+5,sp)
2357  03c1 a30004        	cpw	x,#4
2358  03c4 2e05          	jrsge	L5701
2359                     ; 471         return -1;
2361  03c6 aeffff        	ldw	x,#65535
2363  03c9 200a          	jra	L671
2364  03cb               L5701:
2365                     ; 473     if (cmd_str[0] != 'R')
2367  03cb 1e03          	ldw	x,(OFST+1,sp)
2368  03cd f6            	ld	a,(x)
2369  03ce a152          	cp	a,#82
2370  03d0 2706          	jreq	L7701
2371                     ; 474         return -1;
2373  03d2 aeffff        	ldw	x,#65535
2375  03d5               L671:
2377  03d5 5b04          	addw	sp,#4
2378  03d7 81            	ret
2379  03d8               L7701:
2380                     ; 476     if (cmd_str[1] < '1' || cmd_str[1] > '6')
2382  03d8 1e03          	ldw	x,(OFST+1,sp)
2383  03da e601          	ld	a,(1,x)
2384  03dc a131          	cp	a,#49
2385  03de 2508          	jrult	L3011
2387  03e0 1e03          	ldw	x,(OFST+1,sp)
2388  03e2 e601          	ld	a,(1,x)
2389  03e4 a137          	cp	a,#55
2390  03e6 2505          	jrult	L1011
2391  03e8               L3011:
2392                     ; 477         return -1;
2394  03e8 aeffff        	ldw	x,#65535
2396  03eb 20e8          	jra	L671
2397  03ed               L1011:
2398                     ; 479     if (cmd_str[2] != ',')
2400  03ed 1e03          	ldw	x,(OFST+1,sp)
2401  03ef e602          	ld	a,(2,x)
2402  03f1 a12c          	cp	a,#44
2403  03f3 2705          	jreq	L5011
2404                     ; 480         return -1;
2406  03f5 aeffff        	ldw	x,#65535
2408  03f8 20db          	jra	L671
2409  03fa               L5011:
2410                     ; 482     if (cmd_str[3] != '0' && cmd_str[3] != '1')
2412  03fa 1e03          	ldw	x,(OFST+1,sp)
2413  03fc e603          	ld	a,(3,x)
2414  03fe a130          	cp	a,#48
2415  0400 270d          	jreq	L7011
2417  0402 1e03          	ldw	x,(OFST+1,sp)
2418  0404 e603          	ld	a,(3,x)
2419  0406 a131          	cp	a,#49
2420  0408 2705          	jreq	L7011
2421                     ; 483         return -1;
2423  040a aeffff        	ldw	x,#65535
2425  040d 20c6          	jra	L671
2426  040f               L7011:
2427                     ; 485     relay_num = cmd_str[1] - '0';
2429  040f 1e03          	ldw	x,(OFST+1,sp)
2430  0411 e601          	ld	a,(1,x)
2431  0413 a030          	sub	a,#48
2432  0415 6b01          	ld	(OFST-1,sp),a
2434                     ; 486     relay_state = cmd_str[3] - '0';
2436  0417 1e03          	ldw	x,(OFST+1,sp)
2437  0419 e603          	ld	a,(3,x)
2438  041b a030          	sub	a,#48
2439  041d 6b02          	ld	(OFST+0,sp),a
2441                     ; 488     relay_control_set(relay_num, relay_state);
2443  041f 7b02          	ld	a,(OFST+0,sp)
2444  0421 97            	ld	xl,a
2445  0422 7b01          	ld	a,(OFST-1,sp)
2446  0424 95            	ld	xh,a
2447  0425 cd0248        	call	_relay_control_set
2449                     ; 490     return 0;
2451  0428 5f            	clrw	x
2453  0429 20aa          	jra	L671
2477                     ; 493 void relay_control_init(void)
2477                     ; 494 {
2478                     	switch	.text
2479  042b               _relay_control_init:
2483                     ; 495     relay_control_set_all(1);  /* 1 = on for active-low relays */
2485  042b a601          	ld	a,#1
2486  042d cd025c        	call	_relay_control_set_all
2488                     ; 496 }
2491  0430 81            	ret
2516                     ; 498 void hal_w5500_reset_high(void)
2516                     ; 499 {
2517                     	switch	.text
2518  0431               _hal_w5500_reset_high:
2522                     ; 500     GPIO_WriteHigh(W5500_RST_PORT, W5500_RST_PIN);
2524  0431 4b20          	push	#32
2525  0433 ae5014        	ldw	x,#20500
2526  0436 cd0000        	call	_GPIO_WriteHigh
2528  0439 84            	pop	a
2529                     ; 501 }
2532  043a 81            	ret
2558                     ; 503 void hal_gpio_init(void){
2559                     	switch	.text
2560  043b               _hal_gpio_init:
2564                     ; 505     GPIO_Init(DI1_PORT, DI1_PIN, GPIO_MODE_IN_PU_NO_IT);
2566  043b 4b40          	push	#64
2567  043d 4b04          	push	#4
2568  043f ae500f        	ldw	x,#20495
2569  0442 cd0000        	call	_GPIO_Init
2571  0445 85            	popw	x
2572                     ; 506     GPIO_Init(DI2_PORT, DI2_PIN, GPIO_MODE_IN_PU_NO_IT);
2574  0446 4b40          	push	#64
2575  0448 4b08          	push	#8
2576  044a ae500f        	ldw	x,#20495
2577  044d cd0000        	call	_GPIO_Init
2579  0450 85            	popw	x
2580                     ; 507     GPIO_Init(DI3_PORT, DI3_PIN, GPIO_MODE_IN_PU_NO_IT);
2582  0451 4b40          	push	#64
2583  0453 4b10          	push	#16
2584  0455 ae500f        	ldw	x,#20495
2585  0458 cd0000        	call	_GPIO_Init
2587  045b 85            	popw	x
2588                     ; 508     GPIO_Init(DI4_PORT, DI4_PIN, GPIO_MODE_IN_PU_NO_IT);
2590  045c 4b40          	push	#64
2591  045e 4b80          	push	#128
2592  0460 ae500f        	ldw	x,#20495
2593  0463 cd0000        	call	_GPIO_Init
2595  0466 85            	popw	x
2596                     ; 511     GPIO_Init(RELAY1_PORT, RELAY1_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
2598  0467 4bf0          	push	#240
2599  0469 4b08          	push	#8
2600  046b ae5005        	ldw	x,#20485
2601  046e cd0000        	call	_GPIO_Init
2603  0471 85            	popw	x
2604                     ; 512     GPIO_Init(RELAY2_PORT, RELAY2_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
2606  0472 4bf0          	push	#240
2607  0474 4b04          	push	#4
2608  0476 ae5005        	ldw	x,#20485
2609  0479 cd0000        	call	_GPIO_Init
2611  047c 85            	popw	x
2612                     ; 513     GPIO_Init(RELAY3_PORT, RELAY3_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
2614  047d 4bf0          	push	#240
2615  047f 4b02          	push	#2
2616  0481 ae5005        	ldw	x,#20485
2617  0484 cd0000        	call	_GPIO_Init
2619  0487 85            	popw	x
2620                     ; 514     GPIO_Init(RELAY4_PORT, RELAY4_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
2622  0488 4bf0          	push	#240
2623  048a 4b01          	push	#1
2624  048c ae5005        	ldw	x,#20485
2625  048f cd0000        	call	_GPIO_Init
2627  0492 85            	popw	x
2628                     ; 515     GPIO_Init(RELAY5_PORT, RELAY5_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
2630  0493 4bf0          	push	#240
2631  0495 4b08          	push	#8
2632  0497 ae500a        	ldw	x,#20490
2633  049a cd0000        	call	_GPIO_Init
2635  049d 85            	popw	x
2636                     ; 516     GPIO_Init(RELAY6_PORT, RELAY6_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
2638  049e 4bf0          	push	#240
2639  04a0 4b10          	push	#16
2640  04a2 ae500a        	ldw	x,#20490
2641  04a5 cd0000        	call	_GPIO_Init
2643  04a8 85            	popw	x
2644                     ; 519     hal_relay_set(1, 1);
2646  04a9 ae0101        	ldw	x,#257
2647  04ac cd01c4        	call	_hal_relay_set
2649                     ; 520     hal_relay_set(2, 1);
2651  04af ae0201        	ldw	x,#513
2652  04b2 cd01c4        	call	_hal_relay_set
2654                     ; 521     hal_relay_set(3, 1);
2656  04b5 ae0301        	ldw	x,#769
2657  04b8 cd01c4        	call	_hal_relay_set
2659                     ; 522     hal_relay_set(4, 1);
2661  04bb ae0401        	ldw	x,#1025
2662  04be cd01c4        	call	_hal_relay_set
2664                     ; 523     hal_relay_set(5, 1);
2666  04c1 ae0501        	ldw	x,#1281
2667  04c4 cd01c4        	call	_hal_relay_set
2669                     ; 524     hal_relay_set(6, 1);
2671  04c7 ae0601        	ldw	x,#1537
2672  04ca cd01c4        	call	_hal_relay_set
2674                     ; 527     GPIO_Init(HARDRST_PORT, HARDRST_PIN, GPIO_MODE_IN_PU_NO_IT);
2676  04cd 4b40          	push	#64
2677  04cf 4b80          	push	#128
2678  04d1 ae5005        	ldw	x,#20485
2679  04d4 cd0000        	call	_GPIO_Init
2681  04d7 85            	popw	x
2682                     ; 530     GPIO_Init(W5500_RST_PORT, W5500_RST_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
2684  04d8 4bf0          	push	#240
2685  04da 4b20          	push	#32
2686  04dc ae5014        	ldw	x,#20500
2687  04df cd0000        	call	_GPIO_Init
2689  04e2 85            	popw	x
2690                     ; 531 	hal_w5500_reset_high();
2692  04e3 cd0431        	call	_hal_w5500_reset_high
2694                     ; 532 }
2697  04e6 81            	ret
2721                     ; 534 uint16_t hal_uart_available(void){
2722                     	switch	.text
2723  04e7               _hal_uart_available:
2727                     ; 535 	return uart_rx_count;
2729  04e7 be1f          	ldw	x,_uart_rx_count
2732  04e9 81            	ret
2771                     ; 538 uint8_t hal_uart_read_byte(void){
2772                     	switch	.text
2773  04ea               _hal_uart_read_byte:
2775  04ea 88            	push	a
2776       00000001      OFST:	set	1
2779                     ; 539 	uint8_t byte = 0;
2781  04eb 0f01          	clr	(OFST+0,sp)
2783                     ; 540 	if (uart_rx_count > 0){
2785  04ed be1f          	ldw	x,_uart_rx_count
2786  04ef 271b          	jreq	L7611
2787                     ; 541 		disableInterrupts();
2790  04f1 9b            sim
2792                     ; 543 		byte = uart_rx_buffer[uart_rx_tail];
2795  04f2 be23          	ldw	x,_uart_rx_tail
2796  04f4 e600          	ld	a,(_uart_rx_buffer,x)
2797  04f6 6b01          	ld	(OFST+0,sp),a
2799                     ; 544 		uart_rx_tail = (uart_rx_tail + 1) % UART_RX_BUFFER_SIZE;
2801  04f8 be23          	ldw	x,_uart_rx_tail
2802  04fa 5c            	incw	x
2803  04fb 01            	rrwa	x,a
2804  04fc a407          	and	a,#7
2805  04fe 5f            	clrw	x
2806  04ff b724          	ld	_uart_rx_tail+1,a
2807  0501 9f            	ld	a,xl
2808  0502 b723          	ld	_uart_rx_tail,a
2809                     ; 545 		uart_rx_count--;
2811  0504 be1f          	ldw	x,_uart_rx_count
2812  0506 1d0001        	subw	x,#1
2813  0509 bf1f          	ldw	_uart_rx_count,x
2814                     ; 546 		enableInterrupts();
2817  050b 9a            rim
2820  050c               L7611:
2821                     ; 548 	return byte;
2823  050c 7b01          	ld	a,(OFST+0,sp)
2826  050e 5b01          	addw	sp,#1
2827  0510 81            	ret
2901                     ; 551 void uart_server_process(void){
2902                     	switch	.text
2903  0511               _uart_server_process:
2905  0511 522b          	subw	sp,#43
2906       0000002b      OFST:	set	43
2909                     ; 557 	if (uart_state == UART_STATE_IDLE){
2911  0513 3d1b          	tnz	L13_uart_state
2912  0515 2603          	jrne	L612
2913  0517 cc05d2        	jp	L412
2914  051a               L612:
2915                     ; 558 		return;
2917                     ; 560 	available_len = hal_uart_available();
2919  051a adcb          	call	_hal_uart_available
2921  051c 1f05          	ldw	(OFST-38,sp),x
2923                     ; 562 	if(available_len > 0){
2925  051e 1e05          	ldw	x,(OFST-38,sp)
2926  0520 2603          	jrne	L022
2927  0522 cc05ce        	jp	L5221
2928  0525               L022:
2929                     ; 563 		uart_state = UART_STATE_RX_PENDING;
2931  0525 3502001b      	mov	L13_uart_state,#2
2933  0529 acba05ba      	jpf	L3321
2934  052d               L7221:
2935                     ; 566 			read_byte = hal_uart_read_byte();
2937  052d adbb          	call	_hal_uart_read_byte
2939  052f 6b2b          	ld	(OFST+0,sp),a
2941                     ; 568 			if (read_byte == '\n' || read_byte == '\r'){
2943  0531 7b2b          	ld	a,(OFST+0,sp)
2944  0533 a10a          	cp	a,#10
2945  0535 2706          	jreq	L1421
2947  0537 7b2b          	ld	a,(OFST+0,sp)
2948  0539 a10d          	cp	a,#13
2949  053b 265c          	jrne	L7321
2950  053d               L1421:
2951                     ; 569 				if(uart_rx_count > 0){
2953  053d be1f          	ldw	x,_uart_rx_count
2954  053f 2772          	jreq	L3521
2955                     ; 570 					uart_rx_buffer[uart_rx_count] = '\0';
2957  0541 be1f          	ldw	x,_uart_rx_count
2958  0543 6f00          	clr	(_uart_rx_buffer,x)
2959                     ; 571 					if (command_parser_execute((const char *)uart_rx_buffer,uart_rx_count) == 0){
2961  0545 be1f          	ldw	x,_uart_rx_count
2962  0547 89            	pushw	x
2963  0548 ae0000        	ldw	x,#_uart_rx_buffer
2964  054b cd03bc        	call	_command_parser_execute
2966  054e 5b02          	addw	sp,#2
2967  0550 a30000        	cpw	x,#0
2968  0553 2634          	jrne	L5421
2969                     ; 572 						state = sensor_reader_get_state();
2971  0555 96            	ldw	x,sp
2972  0556 1c0027        	addw	x,#OFST-4
2973  0559 89            	pushw	x
2974  055a cd011a        	call	_sensor_reader_get_state
2976  055d 85            	popw	x
2977                     ; 573 						message_formatter_alive(resp_buf, sizeof(resp_buf),state.di1,state.di2,state.di3,state.di4);
2979  055e 7b2a          	ld	a,(OFST-1,sp)
2980  0560 88            	push	a
2981  0561 7b2a          	ld	a,(OFST-1,sp)
2982  0563 88            	push	a
2983  0564 7b2a          	ld	a,(OFST-1,sp)
2984  0566 88            	push	a
2985  0567 7b2a          	ld	a,(OFST-1,sp)
2986  0569 88            	push	a
2987  056a ae0020        	ldw	x,#32
2988  056d 89            	pushw	x
2989  056e 96            	ldw	x,sp
2990  056f 1c000d        	addw	x,#OFST-30
2991  0572 cd0126        	call	_message_formatter_alive
2993  0575 5b06          	addw	sp,#6
2994                     ; 574 					 	uart_server_send((uint8_t *)resp_buf,strlen(resp_buf));
2996  0577 96            	ldw	x,sp
2997  0578 1c0007        	addw	x,#OFST-36
2998  057b cd0000        	call	_strlen
3000  057e 89            	pushw	x
3001  057f 96            	ldw	x,sp
3002  0580 1c0009        	addw	x,#OFST-34
3003  0583 cd00e5        	call	_uart_server_send
3005  0586 85            	popw	x
3007  0587 200b          	jra	L7421
3008  0589               L5421:
3009                     ; 577                         uart_server_send((uint8_t *)"ERROR,INVALID_COMMAND\n",strlen("ERROR,INVALID_COMMAND\n"));
3011  0589 ae0016        	ldw	x,#22
3012  058c 89            	pushw	x
3013  058d ae0013        	ldw	x,#L1521
3014  0590 cd00e5        	call	_uart_server_send
3016  0593 85            	popw	x
3017  0594               L7421:
3018                     ; 579                     uart_rx_count = 0;
3020  0594 5f            	clrw	x
3021  0595 bf1f          	ldw	_uart_rx_count,x
3022  0597 201a          	jra	L3521
3023  0599               L7321:
3024                     ; 582             else if (read_byte >= 32 && read_byte < 127){
3026  0599 7b2b          	ld	a,(OFST+0,sp)
3027  059b a120          	cp	a,#32
3028  059d 2514          	jrult	L3521
3030  059f 7b2b          	ld	a,(OFST+0,sp)
3031  05a1 a17f          	cp	a,#127
3032  05a3 240e          	jruge	L3521
3033                     ; 583                 uart_rx_buffer[uart_rx_count++] = read_byte;
3035  05a5 7b2b          	ld	a,(OFST+0,sp)
3036  05a7 be1f          	ldw	x,_uart_rx_count
3037  05a9 1c0001        	addw	x,#1
3038  05ac bf1f          	ldw	_uart_rx_count,x
3039  05ae 1d0001        	subw	x,#1
3040  05b1 e700          	ld	(_uart_rx_buffer,x),a
3041  05b3               L3521:
3042                     ; 585             available_len--;
3044  05b3 1e05          	ldw	x,(OFST-38,sp)
3045  05b5 1d0001        	subw	x,#1
3046  05b8 1f05          	ldw	(OFST-38,sp),x
3048  05ba               L3321:
3049                     ; 565 		while (available_len > 0 && uart_rx_count < sizeof(uart_rx_buffer) - 1){
3051  05ba 1e05          	ldw	x,(OFST-38,sp)
3052  05bc 270a          	jreq	L7521
3054  05be be1f          	ldw	x,_uart_rx_count
3055  05c0 a3001f        	cpw	x,#31
3056  05c3 2403          	jruge	L222
3057  05c5 cc052d        	jp	L7221
3058  05c8               L222:
3059  05c8               L7521:
3060                     ; 587         uart_state = UART_STATE_READY;
3062  05c8 3501001b      	mov	L13_uart_state,#1
3064  05cc 2004          	jra	L1621
3065  05ce               L5221:
3066                     ; 590         uart_state = UART_STATE_READY;
3068  05ce 3501001b      	mov	L13_uart_state,#1
3069  05d2               L1621:
3070                     ; 592 }
3071  05d2               L412:
3074  05d2 5b2b          	addw	sp,#43
3075  05d4 81            	ret
3112                     ; 593 uint8_t hal_spi_byte(uint8_t data)
3112                     ; 594 {
3113                     	switch	.text
3114  05d5               _hal_spi_byte:
3116  05d5 88            	push	a
3117       00000000      OFST:	set	0
3120  05d6               L3031:
3121                     ; 595     while (SPI_GetFlagStatus(SPI_FLAG_TXE) == RESET);
3123  05d6 a602          	ld	a,#2
3124  05d8 cd0000        	call	_SPI_GetFlagStatus
3126  05db 4d            	tnz	a
3127  05dc 27f8          	jreq	L3031
3128                     ; 597     SPI_SendData(data);
3130  05de 7b01          	ld	a,(OFST+1,sp)
3131  05e0 cd0000        	call	_SPI_SendData
3134  05e3               L1131:
3135                     ; 599     while (SPI_GetFlagStatus(SPI_FLAG_RXNE) == RESET);
3137  05e3 a601          	ld	a,#1
3138  05e5 cd0000        	call	_SPI_GetFlagStatus
3140  05e8 4d            	tnz	a
3141  05e9 27f8          	jreq	L1131
3142                     ; 601     return SPI_ReceiveData();
3144  05eb cd0000        	call	_SPI_ReceiveData
3148  05ee 5b01          	addw	sp,#1
3149  05f0 81            	ret
3173                     ; 603 uint8_t hal_spi_read_byte(void)
3173                     ; 604 {
3174                     	switch	.text
3175  05f1               _hal_spi_read_byte:
3179                     ; 605     return hal_spi_byte(0xFF);
3181  05f1 a6ff          	ld	a,#255
3182  05f3 ade0          	call	_hal_spi_byte
3186  05f5 81            	ret
3221                     ; 607 void hal_spi_write_byte(uint8_t data)
3221                     ; 608 {
3222                     	switch	.text
3223  05f6               _hal_spi_write_byte:
3227                     ; 609     hal_spi_byte(data);
3229  05f6 addd          	call	_hal_spi_byte
3231                     ; 610 }
3234  05f8 81            	ret
3288                     ; 611 void hal_spi_read(uint8_t *buf, uint16_t len){
3289                     	switch	.text
3290  05f9               _hal_spi_read:
3292  05f9 89            	pushw	x
3293  05fa 89            	pushw	x
3294       00000002      OFST:	set	2
3297                     ; 613     for(i = 0; i < len; i++){
3299  05fb 5f            	clrw	x
3300  05fc 1f01          	ldw	(OFST-1,sp),x
3303  05fe 2011          	jra	L5731
3304  0600               L1731:
3305                     ; 614         buf[i] = hal_spi_byte(0xFF);
3307  0600 a6ff          	ld	a,#255
3308  0602 add1          	call	_hal_spi_byte
3310  0604 1e03          	ldw	x,(OFST+1,sp)
3311  0606 72fb01        	addw	x,(OFST-1,sp)
3312  0609 f7            	ld	(x),a
3313                     ; 613     for(i = 0; i < len; i++){
3315  060a 1e01          	ldw	x,(OFST-1,sp)
3316  060c 1c0001        	addw	x,#1
3317  060f 1f01          	ldw	(OFST-1,sp),x
3319  0611               L5731:
3322  0611 1e01          	ldw	x,(OFST-1,sp)
3323  0613 1307          	cpw	x,(OFST+5,sp)
3324  0615 25e9          	jrult	L1731
3325                     ; 616 }
3328  0617 5b04          	addw	sp,#4
3329  0619 81            	ret
3383                     ; 618 void hal_spi_write(uint8_t *buf, uint16_t len){
3384                     	switch	.text
3385  061a               _hal_spi_write:
3387  061a 89            	pushw	x
3388  061b 89            	pushw	x
3389       00000002      OFST:	set	2
3392                     ; 620     for(i = 0; i < len; i++){
3394  061c 5f            	clrw	x
3395  061d 1f01          	ldw	(OFST-1,sp),x
3398  061f 200f          	jra	L3341
3399  0621               L7241:
3400                     ; 621         hal_spi_byte(buf[i]);
3402  0621 1e03          	ldw	x,(OFST+1,sp)
3403  0623 72fb01        	addw	x,(OFST-1,sp)
3404  0626 f6            	ld	a,(x)
3405  0627 adac          	call	_hal_spi_byte
3407                     ; 620     for(i = 0; i < len; i++){
3409  0629 1e01          	ldw	x,(OFST-1,sp)
3410  062b 1c0001        	addw	x,#1
3411  062e 1f01          	ldw	(OFST-1,sp),x
3413  0630               L3341:
3416  0630 1e01          	ldw	x,(OFST-1,sp)
3417  0632 1307          	cpw	x,(OFST+5,sp)
3418  0634 25eb          	jrult	L7241
3419                     ; 623 }
3422  0636 5b04          	addw	sp,#4
3423  0638 81            	ret
3465                     ; 625 void uart_server_init(uint32_t baudrate){
3466                     	switch	.text
3467  0639               _uart_server_init:
3469       00000000      OFST:	set	0
3472                     ; 626 	uart_state = UART_STATE_IDLE;
3474  0639 3f1b          	clr	L13_uart_state
3475                     ; 627 	uart_rx_count = 0;
3477  063b 5f            	clrw	x
3478  063c bf1f          	ldw	_uart_rx_count,x
3479                     ; 628 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_UART1, ENABLE);
3481  063e ae0301        	ldw	x,#769
3482  0641 cd0000        	call	_CLK_PeripheralClockConfig
3484                     ; 629     UART1_Init(
3484                     ; 630     baudrate,
3484                     ; 631     UART1_WORDLENGTH_8D,
3484                     ; 632     UART1_STOPBITS_1,
3484                     ; 633     UART1_PARITY_NO,
3484                     ; 634     UART1_SYNCMODE_CLOCK_DISABLE,
3484                     ; 635     (UART1_Mode_TypeDef)(UART1_MODE_TX_ENABLE | UART1_MODE_RX_ENABLE)
3484                     ; 636 );
3486  0644 4b0c          	push	#12
3487  0646 4b80          	push	#128
3488  0648 4b00          	push	#0
3489  064a 4b00          	push	#0
3490  064c 4b00          	push	#0
3491  064e 1e0a          	ldw	x,(OFST+10,sp)
3492  0650 89            	pushw	x
3493  0651 1e0a          	ldw	x,(OFST+10,sp)
3494  0653 89            	pushw	x
3495  0654 cd0000        	call	_UART1_Init
3497  0657 5b09          	addw	sp,#9
3498                     ; 638     UART1_ITConfig(UART1_IT_RXNE, ENABLE);
3500  0659 4b01          	push	#1
3501  065b ae0255        	ldw	x,#597
3502  065e cd0000        	call	_UART1_ITConfig
3504  0661 84            	pop	a
3505                     ; 641     UART1_Cmd(ENABLE);
3507  0662 a601          	ld	a,#1
3508  0664 cd0000        	call	_UART1_Cmd
3510                     ; 643     uart_rx_head = 0;
3512  0667 5f            	clrw	x
3513  0668 bf21          	ldw	_uart_rx_head,x
3514                     ; 644     uart_rx_tail = 0;
3516  066a 5f            	clrw	x
3517  066b bf23          	ldw	_uart_rx_tail,x
3518                     ; 645     uart_rx_count = 0;  
3520  066d 5f            	clrw	x
3521  066e bf1f          	ldw	_uart_rx_count,x
3522                     ; 646 	uart_state = UART_STATE_READY;
3524  0670 3501001b      	mov	L13_uart_state,#1
3525                     ; 647 }
3528  0674 81            	ret
3556                     ; 649 void hal_timer_init(void){
3557                     	switch	.text
3558  0675               _hal_timer_init:
3562                     ; 650     CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER4, ENABLE);
3564  0675 ae0401        	ldw	x,#1025
3565  0678 cd0000        	call	_CLK_PeripheralClockConfig
3567                     ; 651     TIM4_TimeBaseInit(TIM4_PRESCALER_128, 125);
3569  067b ae077d        	ldw	x,#1917
3570  067e cd0000        	call	_TIM4_TimeBaseInit
3572                     ; 652     TIM4_ClearFlag(TIM4_FLAG_UPDATE);
3574  0681 a601          	ld	a,#1
3575  0683 cd0000        	call	_TIM4_ClearFlag
3577                     ; 654     TIM4_ITConfig(TIM4_IT_UPDATE, ENABLE);
3579  0686 ae0101        	ldw	x,#257
3580  0689 cd0000        	call	_TIM4_ITConfig
3582                     ; 656     enableInterrupts();
3585  068c 9a            rim
3587                     ; 657 }
3591  068d 81            	ret
3678                     ; 659 void tcp_server_process(void){
3679                     	switch	.text
3680  068e               _tcp_server_process:
3682  068e 522b          	subw	sp,#43
3683       0000002b      OFST:	set	43
3686                     ; 660     uint16_t received_len = 0;
3688                     ; 663     if(server_state == TCP_STATE_IDLE) return;
3690  0690 3d0a          	tnz	L32_server_state
3691  0692 2603          	jrne	L252
3692  0694 cc076a        	jp	L052
3693  0697               L252:
3696                     ; 664     sock_status = getSn_SR(server_socket);
3698  0697 b61c          	ld	a,L33_server_socket
3699  0699 97            	ld	xl,a
3700  069a a604          	ld	a,#4
3701  069c 42            	mul	x,a
3702  069d 58            	sllw	x
3703  069e 58            	sllw	x
3704  069f 58            	sllw	x
3705  06a0 1c0308        	addw	x,#776
3706  06a3 cd0000        	call	c_itolx
3708  06a6 be02          	ldw	x,c_lreg+2
3709  06a8 89            	pushw	x
3710  06a9 be00          	ldw	x,c_lreg
3711  06ab 89            	pushw	x
3712  06ac cd0000        	call	_WIZCHIP_READ
3714  06af 5b04          	addw	sp,#4
3715  06b1 6b29          	ld	(OFST-2,sp),a
3717                     ; 666     switch(sock_status){
3719  06b3 7b29          	ld	a,(OFST-2,sp)
3721                     ; 699             break;
3722  06b5 4d            	tnz	a
3723  06b6 2603          	jrne	L452
3724  06b8 cc074c        	jp	L1741
3725  06bb               L452:
3726  06bb a014          	sub	a,#20
3727  06bd 270c          	jreq	L5641
3728  06bf a003          	sub	a,#3
3729  06c1 2710          	jreq	L7641
3730  06c3               L3741:
3731                     ; 697         default:
3731                     ; 698             server_state = TCP_STATE_ERROR;
3733  06c3 3503000a      	mov	L32_server_state,#3
3734                     ; 699             break;
3736  06c7 ac6a076a      	jpf	L7351
3737  06cb               L5641:
3738                     ; 667         case SOCK_LISTEN:
3738                     ; 668             server_state = TCP_STATE_LISTENING;
3740  06cb 3501000a      	mov	L32_server_state,#1
3741                     ; 669             break;
3743  06cf ac6a076a      	jpf	L7351
3744  06d3               L7641:
3745                     ; 671         case SOCK_ESTABLISHED:
3745                     ; 672             server_state = TCP_STATE_CONNECTED;
3747  06d3 3502000a      	mov	L32_server_state,#2
3748                     ; 673             received_len = getSn_RX_RSR(server_socket);
3750  06d7 b61c          	ld	a,L33_server_socket
3751  06d9 cd0000        	call	_getSn_RX_RSR
3753  06dc 1f2a          	ldw	(OFST-1,sp),x
3755                     ; 674             if(received_len > 0){
3757  06de 1e2a          	ldw	x,(OFST-1,sp)
3758  06e0 27b2          	jreq	L7351
3759                     ; 675                 uint16_t read_len = (received_len > TCP_RX_BUFFER) ? TCP_RX_BUFFER : received_len;
3761  06e2 1e2a          	ldw	x,(OFST-1,sp)
3762  06e4 a30021        	cpw	x,#33
3763  06e7 2505          	jrult	L442
3764  06e9 ae0020        	ldw	x,#32
3765  06ec 2002          	jra	L642
3766  06ee               L442:
3767  06ee 1e2a          	ldw	x,(OFST-1,sp)
3768  06f0               L642:
3769  06f0 1f2a          	ldw	(OFST-1,sp),x
3771                     ; 677                 read_len = recv(server_socket, rx_buffer, read_len);
3773  06f2 1e2a          	ldw	x,(OFST-1,sp)
3774  06f4 89            	pushw	x
3775  06f5 ae0045        	ldw	x,#_rx_buffer
3776  06f8 89            	pushw	x
3777  06f9 b61c          	ld	a,L33_server_socket
3778  06fb cd0000        	call	_recv
3780  06fe 5b04          	addw	sp,#4
3781  0700 be02          	ldw	x,c_lreg+2
3782  0702 1f2a          	ldw	(OFST-1,sp),x
3784                     ; 678                 if(read_len > 0){
3786  0704 1e2a          	ldw	x,(OFST-1,sp)
3787  0706 2762          	jreq	L7351
3788                     ; 679                     if(command_parser_execute((const char *)rx_buffer, read_len) == 0){
3790  0708 1e2a          	ldw	x,(OFST-1,sp)
3791  070a 89            	pushw	x
3792  070b ae0045        	ldw	x,#_rx_buffer
3793  070e cd03bc        	call	_command_parser_execute
3795  0711 5b02          	addw	sp,#2
3796  0713 a30000        	cpw	x,#0
3797  0716 2652          	jrne	L7351
3798                     ; 682                         sensor_state_t state = sensor_reader_get_state();
3800  0718 96            	ldw	x,sp
3801  0719 1c0025        	addw	x,#OFST-6
3802  071c 89            	pushw	x
3803  071d cd011a        	call	_sensor_reader_get_state
3805  0720 85            	popw	x
3806                     ; 683                         message_formatter_alive(resp_buf,sizeof(resp_buf),state.di1,state.di2,state.di3,state.di4);
3808  0721 7b28          	ld	a,(OFST-3,sp)
3809  0723 88            	push	a
3810  0724 7b28          	ld	a,(OFST-3,sp)
3811  0726 88            	push	a
3812  0727 7b28          	ld	a,(OFST-3,sp)
3813  0729 88            	push	a
3814  072a 7b28          	ld	a,(OFST-3,sp)
3815  072c 88            	push	a
3816  072d ae0020        	ldw	x,#32
3817  0730 89            	pushw	x
3818  0731 96            	ldw	x,sp
3819  0732 1c000b        	addw	x,#OFST-32
3820  0735 cd0126        	call	_message_formatter_alive
3822  0738 5b06          	addw	sp,#6
3823                     ; 684                         tcp_server_send((uint8_t *)resp_buf, strlen(resp_buf));
3825  073a 96            	ldw	x,sp
3826  073b 1c0005        	addw	x,#OFST-38
3827  073e cd0000        	call	_strlen
3829  0741 89            	pushw	x
3830  0742 96            	ldw	x,sp
3831  0743 1c0007        	addw	x,#OFST-36
3832  0746 cd0041        	call	_tcp_server_send
3834  0749 85            	popw	x
3835  074a 201e          	jra	L7351
3836  074c               L1741:
3837                     ; 690         case SOCK_CLOSED:
3837                     ; 691             server_state = TCP_STATE_LISTENING;
3839  074c 3501000a      	mov	L32_server_state,#1
3840                     ; 692             close(server_socket);
3842  0750 b61c          	ld	a,L33_server_socket
3843  0752 cd0000        	call	_close
3845                     ; 693             socket(server_socket, Sn_MR_TCP, server_port, 0);
3847  0755 4b00          	push	#0
3848  0757 be1d          	ldw	x,L53_server_port
3849  0759 89            	pushw	x
3850  075a b61c          	ld	a,L33_server_socket
3851  075c ae0001        	ldw	x,#1
3852  075f 95            	ld	xh,a
3853  0760 cd0000        	call	_socket
3855  0763 5b03          	addw	sp,#3
3856                     ; 694             listen(server_socket);
3858  0765 b61c          	ld	a,L33_server_socket
3859  0767 cd0000        	call	_listen
3861                     ; 695             break;
3863  076a               L7351:
3864                     ; 701 }
3865  076a               L052:
3868  076a 5b2b          	addw	sp,#43
3869  076c 81            	ret
3908                     ; 703 void tcp_server_init(uint16_t port){
3909                     	switch	.text
3910  076d               _tcp_server_init:
3914                     ; 704     server_port = port;
3916  076d bf1d          	ldw	L53_server_port,x
3917                     ; 705     server_state = TCP_STATE_IDLE;
3919  076f 3f0a          	clr	L32_server_state
3920                     ; 708     if(socket(server_socket, Sn_MR_TCP, server_port, 0) == server_socket){
3922  0771 4b00          	push	#0
3923  0773 be1d          	ldw	x,L53_server_port
3924  0775 89            	pushw	x
3925  0776 b61c          	ld	a,L33_server_socket
3926  0778 ae0001        	ldw	x,#1
3927  077b 95            	ld	xh,a
3928  077c cd0000        	call	_socket
3930  077f 5b03          	addw	sp,#3
3931  0781 5f            	clrw	x
3932  0782 4d            	tnz	a
3933  0783 2a01          	jrpl	L062
3934  0785 53            	cplw	x
3935  0786               L062:
3936  0786 97            	ld	xl,a
3937  0787 b61c          	ld	a,L33_server_socket
3938  0789 905f          	clrw	y
3939  078b 9097          	ld	yl,a
3940  078d 90bf00        	ldw	c_y,y
3941  0790 b300          	cpw	x,c_y
3942  0792 260d          	jrne	L5651
3943                     ; 709         if(listen(server_socket) == SOCK_OK){
3945  0794 b61c          	ld	a,L33_server_socket
3946  0796 cd0000        	call	_listen
3948  0799 a101          	cp	a,#1
3949  079b 2604          	jrne	L5651
3950                     ; 710             server_state = TCP_STATE_LISTENING;
3952  079d 3501000a      	mov	L32_server_state,#1
3953  07a1               L5651:
3954                     ; 713 }
3957  07a1 81            	ret
4017                     ; 715 void w5500_chip_init(void)
4017                     ; 716 {
4018                     	switch	.text
4019  07a2               _w5500_chip_init:
4021  07a2 88            	push	a
4022       00000001      OFST:	set	1
4025                     ; 720     GPIO_WriteLow(W5500_RST_PORT, W5500_RST_PIN);
4027  07a3 4b20          	push	#32
4028  07a5 ae5014        	ldw	x,#20500
4029  07a8 cd0000        	call	_GPIO_WriteLow
4031  07ab 84            	pop	a
4032                     ; 721     hal_delay_ms(100);
4034  07ac ae0064        	ldw	x,#100
4035  07af cd0014        	call	_hal_delay_ms
4037                     ; 722     hal_w5500_reset_high();
4039  07b2 cd0431        	call	_hal_w5500_reset_high
4041                     ; 723     GPIO_WriteHigh(W5500_RST_PORT, W5500_RST_PIN);
4043  07b5 4b20          	push	#32
4044  07b7 ae5014        	ldw	x,#20500
4045  07ba cd0000        	call	_GPIO_WriteHigh
4047  07bd 84            	pop	a
4048                     ; 724     CLK_PeripheralClockConfig(CLK_PERIPHERAL_SPI, ENABLE);
4050  07be ae0101        	ldw	x,#257
4051  07c1 cd0000        	call	_CLK_PeripheralClockConfig
4053                     ; 725     GPIO_Init(W5500_SCK_PORT,W5500_SCK_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
4055  07c4 4bf0          	push	#240
4056  07c6 4b20          	push	#32
4057  07c8 ae500a        	ldw	x,#20490
4058  07cb cd0000        	call	_GPIO_Init
4060  07ce 85            	popw	x
4061                     ; 726     GPIO_Init(W5500_MOSI_PORT,W5500_MOSI_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
4063  07cf 4bf0          	push	#240
4064  07d1 4b40          	push	#64
4065  07d3 ae500a        	ldw	x,#20490
4066  07d6 cd0000        	call	_GPIO_Init
4068  07d9 85            	popw	x
4069                     ; 727     GPIO_Init(W5500_MISO_PORT,W5500_MISO_PIN,GPIO_MODE_IN_FL_NO_IT);
4071  07da 4b00          	push	#0
4072  07dc 4b80          	push	#128
4073  07de ae500a        	ldw	x,#20490
4074  07e1 cd0000        	call	_GPIO_Init
4076  07e4 85            	popw	x
4077                     ; 728     GPIO_Init(W5500_CS_PORT,W5500_CS_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
4079  07e5 4bf0          	push	#240
4080  07e7 4b08          	push	#8
4081  07e9 ae5000        	ldw	x,#20480
4082  07ec cd0000        	call	_GPIO_Init
4084  07ef 85            	popw	x
4085                     ; 729     GPIO_WriteHigh(W5500_CS_PORT, W5500_CS_PIN);
4087  07f0 4b08          	push	#8
4088  07f2 ae5000        	ldw	x,#20480
4089  07f5 cd0000        	call	_GPIO_WriteHigh
4091  07f8 84            	pop	a
4092                     ; 730     GPIO_Init(W5500_RST_PORT,W5500_RST_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
4094  07f9 4bf0          	push	#240
4095  07fb 4b20          	push	#32
4096  07fd ae5014        	ldw	x,#20500
4097  0800 cd0000        	call	_GPIO_Init
4099  0803 85            	popw	x
4100                     ; 731     SPI_DeInit();
4102  0804 cd0000        	call	_SPI_DeInit
4104                     ; 732         SPI_Init(
4104                     ; 733         SPI_FIRSTBIT_MSB,
4104                     ; 734         SPI_BAUDRATEPRESCALER_4,
4104                     ; 735         SPI_MODE_MASTER,
4104                     ; 736         SPI_CLOCKPOLARITY_LOW,
4104                     ; 737         SPI_CLOCKPHASE_1EDGE,
4104                     ; 738         SPI_DATADIRECTION_2LINES_FULLDUPLEX,
4104                     ; 739         SPI_NSS_SOFT,
4104                     ; 740         0x07
4104                     ; 741     );
4106  0807 4b07          	push	#7
4107  0809 4b02          	push	#2
4108  080b 4b00          	push	#0
4109  080d 4b00          	push	#0
4110  080f 4b00          	push	#0
4111  0811 4b04          	push	#4
4112  0813 ae0008        	ldw	x,#8
4113  0816 cd0000        	call	_SPI_Init
4115  0819 5b06          	addw	sp,#6
4116                     ; 743     SPI_Cmd(ENABLE);
4118  081b a601          	ld	a,#1
4119  081d cd0000        	call	_SPI_Cmd
4121                     ; 744     reg_wizchip_spi_cbfunc(hal_spi_read_byte,hal_spi_write_byte);
4123  0820 ae05f6        	ldw	x,#_hal_spi_write_byte
4124  0823 89            	pushw	x
4125  0824 ae05f1        	ldw	x,#_hal_spi_read_byte
4126  0827 cd0000        	call	_reg_wizchip_spi_cbfunc
4128  082a 85            	popw	x
4129                     ; 745     reg_wizchip_spiburst_cbfunc(hal_spi_read,hal_spi_write);
4131  082b ae061a        	ldw	x,#_hal_spi_write
4132  082e 89            	pushw	x
4133  082f ae05f9        	ldw	x,#_hal_spi_read
4134  0832 cd0000        	call	_reg_wizchip_spiburst_cbfunc
4136  0835 85            	popw	x
4137                     ; 746     reg_wizchip_cs_cbfunc(hal_spi_cs_low,hal_spi_cs_high);
4139  0836 ae00db        	ldw	x,#_hal_spi_cs_high
4140  0839 89            	pushw	x
4141  083a ae00d1        	ldw	x,#_hal_spi_cs_low
4142  083d cd0000        	call	_reg_wizchip_cs_cbfunc
4144  0840 85            	popw	x
4145                     ; 747     wizchip_init(0, 0);
4147  0841 5f            	clrw	x
4148  0842 89            	pushw	x
4149  0843 5f            	clrw	x
4150  0844 cd0000        	call	_wizchip_init
4152  0847 85            	popw	x
4153                     ; 748     version = getVERSIONR();
4155  0848 ae0039        	ldw	x,#57
4156  084b 89            	pushw	x
4157  084c ae0000        	ldw	x,#0
4158  084f 89            	pushw	x
4159  0850 cd0000        	call	_WIZCHIP_READ
4161  0853 5b04          	addw	sp,#4
4162  0855 6b01          	ld	(OFST+0,sp),a
4164                     ; 749     if(version != 0x04)
4166  0857 7b01          	ld	a,(OFST+0,sp)
4167  0859 a104          	cp	a,#4
4168  085b 2702          	jreq	L7061
4169  085d               L1161:
4170                     ; 751         while(1);
4172  085d 20fe          	jra	L1161
4173  085f               L7061:
4174                     ; 753 }
4177  085f 84            	pop	a
4178  0860 81            	ret
4214                     ; 755 void system_init(void){
4215                     	switch	.text
4216  0861               _system_init:
4220                     ; 757     CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);  /* 16MHz clock */
4222  0861 4f            	clr	a
4223  0862 cd0000        	call	_CLK_HSIPrescalerConfig
4225                     ; 759 	hal_gpio_init();
4227  0865 cd043b        	call	_hal_gpio_init
4229                     ; 760     hal_timer_init();
4231  0868 cd0675        	call	_hal_timer_init
4233                     ; 762 	relay_control_init();
4235  086b cd042b        	call	_relay_control_init
4237                     ; 763 	sensor_reader_init();
4239  086e cd032c        	call	_sensor_reader_init
4241                     ; 765     w5500_chip_init();
4243  0871 cd07a2        	call	_w5500_chip_init
4245                     ; 766     tcp_server_init(TCP_SERVER_PORT);
4247  0874 ae1388        	ldw	x,#5000
4248  0877 cd076d        	call	_tcp_server_init
4250                     ; 768     uart_server_init(UART_BAUDRATE);
4252  087a aec200        	ldw	x,#49664
4253  087d 89            	pushw	x
4254  087e ae0001        	ldw	x,#1
4255  0881 89            	pushw	x
4256  0882 cd0639        	call	_uart_server_init
4258  0885 5b04          	addw	sp,#4
4259                     ; 771     hal_timer_set_callback(timer_callback);
4261  0887 ae036f        	ldw	x,#_timer_callback
4262  088a cd03b9        	call	_hal_timer_set_callback
4264                     ; 772     hal_timer_start();
4266  088d cd02aa        	call	_hal_timer_start
4268                     ; 773 	  hal_delay_ms(500);
4270  0890 ae01f4        	ldw	x,#500
4271  0893 cd0014        	call	_hal_delay_ms
4273                     ; 774 }
4276  0896 81            	ret
4279                     	switch	.const
4280  0008               L5261_msg:
4281  0008 52455345542c  	dc.b	"RESET, OK",10,0
4321                     ; 776 void main_loop(void)
4321                     ; 777 {
4322                     	switch	.text
4323  0897               _main_loop:
4325  0897 520b          	subw	sp,#11
4326       0000000b      OFST:	set	11
4329  0899               L5461:
4330                     ; 781         tcp_server_process();
4332  0899 cd068e        	call	_tcp_server_process
4334                     ; 783 		uart_server_process();
4336  089c cd0511        	call	_uart_server_process
4338                     ; 785         if(GPIO_ReadInputPin(HARDRST_PORT, HARDRST_PIN) == RESET)
4340  089f 4b80          	push	#128
4341  08a1 ae5005        	ldw	x,#20485
4342  08a4 cd0000        	call	_GPIO_ReadInputPin
4344  08a7 5b01          	addw	sp,#1
4345  08a9 4d            	tnz	a
4346  08aa 26ed          	jrne	L5461
4347                     ; 787             hal_delay_ms(50);
4349  08ac ae0032        	ldw	x,#50
4350  08af cd0014        	call	_hal_delay_ms
4352                     ; 788 			if (GPIO_ReadInputPin(HARDRST_PORT, HARDRST_PIN) == 0){
4354  08b2 4b80          	push	#128
4355  08b4 ae5005        	ldw	x,#20485
4356  08b7 cd0000        	call	_GPIO_ReadInputPin
4358  08ba 5b01          	addw	sp,#1
4359  08bc 4d            	tnz	a
4360  08bd 26da          	jrne	L5461
4361                     ; 790 				char msg[] = "RESET, OK\n";
4363  08bf 96            	ldw	x,sp
4364  08c0 1c0001        	addw	x,#OFST-10
4365  08c3 90ae0008      	ldw	y,#L5261_msg
4366  08c7 a60b          	ld	a,#11
4367  08c9 cd0000        	call	c_xymov
4369                     ; 791                 if (uart_server_is_ready()){
4371  08cc cd008d        	call	_uart_server_is_ready
4373  08cf a30000        	cpw	x,#0
4374  08d2 2710          	jreq	L5561
4375                     ; 792                     uart_server_send((uint8_t *)msg, strlen(msg));
4377  08d4 96            	ldw	x,sp
4378  08d5 1c0001        	addw	x,#OFST-10
4379  08d8 cd0000        	call	_strlen
4381  08db 89            	pushw	x
4382  08dc 96            	ldw	x,sp
4383  08dd 1c0003        	addw	x,#OFST-8
4384  08e0 cd00e5        	call	_uart_server_send
4386  08e3 85            	popw	x
4387  08e4               L5561:
4388                     ; 794 				hal_delay_ms(100);
4390  08e4 ae0064        	ldw	x,#100
4391  08e7 cd0014        	call	_hal_delay_ms
4393  08ea 20ad          	jra	L5461
4418                     ; 801 int main(void)
4418                     ; 802 {
4419                     	switch	.text
4420  08ec               _main:
4424                     ; 803 	system_init();
4426  08ec cd0861        	call	_system_init
4428                     ; 804     main_loop();
4430  08ef ada6          	call	_main_loop
4432  08f1               L7661:
4433                     ; 805     while(1);
4435  08f1 20fe          	jra	L7661
4754                     	xdef	_main
4755                     	xdef	_main_loop
4756                     	xdef	_system_init
4757                     	xdef	_w5500_chip_init
4758                     	xdef	_tcp_server_init
4759                     	xdef	_tcp_server_process
4760                     	xdef	_hal_timer_init
4761                     	xdef	_uart_server_init
4762                     	xdef	_hal_spi_write
4763                     	xdef	_hal_spi_read
4764                     	xdef	_hal_spi_write_byte
4765                     	xdef	_hal_spi_read_byte
4766                     	xdef	_hal_spi_byte
4767                     	xdef	_uart_server_process
4768                     	xdef	_hal_uart_read_byte
4769                     	xdef	_hal_uart_available
4770                     	xdef	_hal_gpio_init
4771                     	xdef	_hal_w5500_reset_high
4772                     	xdef	_relay_control_init
4773                     	xdef	_command_parser_execute
4774                     	xdef	_hal_timer_set_callback
4775                     	xdef	_timer_callback
4776                     	xdef	_send_alive_message
4777                     	xdef	_sensor_reader_init
4778                     	xdef	_process_axle_counting
4779                     	xdef	_hal_timer_start
4780                     	xdef	_sensor_reader_update
4781                     	xdef	_relay_control_set_all
4782                     	xdef	_relay_control_set
4783                     	xdef	_hal_relay_set
4784                     	xdef	_hal_di_read
4785                     	xdef	_message_formatter_alive
4786                     	xdef	_sensor_reader_get_state
4787                     	xdef	_uart_server_send
4788                     	xdef	_hal_spi_cs_high
4789                     	xdef	_hal_spi_cs_low
4790                     	xdef	_hal_uart_send
4791                     	xdef	_hal_uart_send_byte
4792                     	xdef	_uart_server_is_ready
4793                     	xdef	_tcp_server_send
4794                     	xdef	_hal_delay_ms
4795                     	xdef	_tcp_server_is_connected
4796                     	xdef	_hal_get_millis
4797                     	xdef	_user_callback
4798                     	xdef	_systick_ms
4799                     	switch	.ubsct
4800  0000               _uart_rx_buffer:
4801  0000 000000000000  	ds.b	32
4802                     	xdef	_uart_rx_buffer
4803  0020               L73_uart_tx_buffer:
4804  0020 0000000000    	ds.b	5
4805                     	xdef	_uart_rx_tail
4806                     	xdef	_uart_rx_head
4807                     	xdef	_uart_rx_count
4808  0025               _tx_buffer:
4809  0025 000000000000  	ds.b	32
4810                     	xdef	_tx_buffer
4811  0045               _rx_buffer:
4812  0045 000000000000  	ds.b	32
4813                     	xdef	_rx_buffer
4814                     	xref	_strlen
4815                     	xref	_send
4816                     	xref	_recv
4817                     	xref	_listen
4818                     	xref	_close
4819                     	xref	_socket
4820                     	xref	_wizchip_init
4821                     	xref	_reg_wizchip_spiburst_cbfunc
4822                     	xref	_reg_wizchip_spi_cbfunc
4823                     	xref	_getSn_RX_RSR
4824                     	xref	_reg_wizchip_cs_cbfunc
4825                     	xref	_WIZCHIP_READ
4826                     	xref	_TIM4_ClearFlag
4827                     	xref	_TIM4_ITConfig
4828                     	xref	_TIM4_Cmd
4829                     	xref	_TIM4_TimeBaseInit
4830                     	xref	_SPI_GetFlagStatus
4831                     	xref	_SPI_ReceiveData
4832                     	xref	_SPI_SendData
4833                     	xref	_SPI_Cmd
4834                     	xref	_SPI_Init
4835                     	xref	_SPI_DeInit
4836                     	xref	_UART1_GetFlagStatus
4837                     	xref	_UART1_SendData8
4838                     	xref	_UART1_ITConfig
4839                     	xref	_UART1_Cmd
4840                     	xref	_UART1_Init
4841                     	xref	_GPIO_ReadInputPin
4842                     	xref	_GPIO_WriteLow
4843                     	xref	_GPIO_WriteHigh
4844                     	xref	_GPIO_Init
4845                     	xref	_CLK_HSIPrescalerConfig
4846                     	xref	_CLK_PeripheralClockConfig
4847                     	switch	.const
4848  0013               L1521:
4849  0013 4552524f522c  	dc.b	"ERROR,INVALID_COMM"
4850  0025 414e440a00    	dc.b	"AND",10,0
4851                     	xref.b	c_lreg
4852                     	xref.b	c_x
4853                     	xref.b	c_y
4873                     	xref	c_itolx
4874                     	xref	c_xymov
4875                     	xref	c_lcmp
4876                     	xref	c_lsub
4877                     	xref	c_uitolx
4878                     	xref	c_rtol
4879                     	xref	c_ltor
4880                     	end
