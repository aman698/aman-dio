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
 353  0067 e70a          	ld	(_tx_buffer,x),a
 354  0069 5d            	tnzw	x
 355  006a 26f7          	jrne	L22
 356  006c               L02:
 357                     ; 103     sent = send(server_socket, tx_buffer, len);
 359  006c 1e07          	ldw	x,(OFST+5,sp)
 360  006e 89            	pushw	x
 361  006f ae000a        	ldw	x,#_tx_buffer
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
 756  0108 e705          	ld	(L73_uart_tx_buffer,x),a
 757  010a 5d            	tnzw	x
 758  010b 26f7          	jrne	L45
 759  010d               L25:
 760                     ; 149     hal_uart_send(uart_tx_buffer, len);
 762  010d 1e05          	ldw	x,(OFST+5,sp)
 763  010f 89            	pushw	x
 764  0110 ae0005        	ldw	x,#L73_uart_tx_buffer
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
2081  0330 5228          	subw	sp,#40
2082       00000028      OFST:	set	40
2085                     ; 286     sensor = sensor_reader_get_state();
2087  0332 96            	ldw	x,sp
2088  0333 1c0005        	addw	x,#OFST-35
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
2095  033b 7b08          	ld	a,(OFST-32,sp)
2096  033d 88            	push	a
2097  033e 7b08          	ld	a,(OFST-32,sp)
2098  0340 88            	push	a
2099  0341 7b08          	ld	a,(OFST-32,sp)
2100  0343 88            	push	a
2101  0344 7b08          	ld	a,(OFST-32,sp)
2102  0346 88            	push	a
2103  0347 ae0020        	ldw	x,#32
2104  034a 89            	pushw	x
2105  034b 96            	ldw	x,sp
2106  034c 1c000f        	addw	x,#OFST-25
2107  034f cd0126        	call	_message_formatter_alive
2109  0352 5b06          	addw	sp,#6
2110                     ; 296     if (tcp_server_is_connected())
2112  0354 cd0007        	call	_tcp_server_is_connected
2114  0357 a30000        	cpw	x,#0
2115  035a 2710          	jreq	L7001
2116                     ; 298         tcp_server_send((uint8_t *)msg_buf, strlen(msg_buf));
2118  035c 96            	ldw	x,sp
2119  035d 1c0009        	addw	x,#OFST-31
2120  0360 cd0000        	call	_strlen
2122  0363 89            	pushw	x
2123  0364 96            	ldw	x,sp
2124  0365 1c000b        	addw	x,#OFST-29
2125  0368 cd0041        	call	_tcp_server_send
2127  036b 85            	popw	x
2128  036c               L7001:
2129                     ; 300     if (uart_server_is_ready())
2131  036c cd008d        	call	_uart_server_is_ready
2133  036f a30000        	cpw	x,#0
2134  0372 2710          	jreq	L1101
2135                     ; 302         uart_server_send((uint8_t *)msg_buf, strlen(msg_buf));
2137  0374 96            	ldw	x,sp
2138  0375 1c0009        	addw	x,#OFST-31
2139  0378 cd0000        	call	_strlen
2141  037b 89            	pushw	x
2142  037c 96            	ldw	x,sp
2143  037d 1c000b        	addw	x,#OFST-29
2144  0380 cd00e5        	call	_uart_server_send
2146  0383 85            	popw	x
2147  0384               L1101:
2148                     ; 304 }
2151  0384 5b28          	addw	sp,#40
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
2297  03d2 bf29          	ldw	_user_callback,x
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
2750  0500 be1f          	ldw	x,_uart_rx_count
2753  0502 81            	ret
2792                     ; 399 uint8_t hal_uart_read_byte(void){
2793                     	switch	.text
2794  0503               _hal_uart_read_byte:
2796  0503 88            	push	a
2797       00000001      OFST:	set	1
2800                     ; 400 	uint8_t byte = 0;
2802  0504 0f01          	clr	(OFST+0,sp)
2804                     ; 401 	if (uart_rx_count > 0){
2806  0506 be1f          	ldw	x,_uart_rx_count
2807  0508 2719          	jreq	L1711
2808                     ; 402 		disableInterrupts();
2811  050a 9b            sim
2813                     ; 404 		byte = uart_rx_buffer[uart_rx_tail];
2816  050b be23          	ldw	x,_uart_rx_tail
2817  050d e600          	ld	a,(_uart_rx_buffer,x)
2818  050f 6b01          	ld	(OFST+0,sp),a
2820                     ; 405 		uart_rx_tail = (uart_rx_tail + 1) % UART_RX_BUFFER_SIZE;
2822  0511 be23          	ldw	x,_uart_rx_tail
2823  0513 5c            	incw	x
2824  0514 a605          	ld	a,#5
2825  0516 62            	div	x,a
2826  0517 5f            	clrw	x
2827  0518 97            	ld	xl,a
2828  0519 bf23          	ldw	_uart_rx_tail,x
2829                     ; 406 		uart_rx_count--;
2831  051b be1f          	ldw	x,_uart_rx_count
2832  051d 1d0001        	subw	x,#1
2833  0520 bf1f          	ldw	_uart_rx_count,x
2834                     ; 407 		enableInterrupts();
2837  0522 9a            rim
2840  0523               L1711:
2841                     ; 409 	return byte;
2843  0523 7b01          	ld	a,(OFST+0,sp)
2846  0525 5b01          	addw	sp,#1
2847  0527 81            	ret
2921                     ; 412 void uart_server_process(void){
2922                     	switch	.text
2923  0528               _uart_server_process:
2925  0528 522b          	subw	sp,#43
2926       0000002b      OFST:	set	43
2929                     ; 418 	if (uart_state == UART_STATE_IDLE){
2931  052a 3d1b          	tnz	L13_uart_state
2932  052c 2603          	jrne	L612
2933  052e cc05e9        	jp	L412
2934  0531               L612:
2935                     ; 419 		return;
2937                     ; 421 	available_len = hal_uart_available();
2939  0531 adcd          	call	_hal_uart_available
2941  0533 1f05          	ldw	(OFST-38,sp),x
2943                     ; 423 	if(available_len > 0){
2945  0535 1e05          	ldw	x,(OFST-38,sp)
2946  0537 2603          	jrne	L022
2947  0539 cc05e5        	jp	L7221
2948  053c               L022:
2949                     ; 424 		uart_state = UART_STATE_RX_PENDING;
2951  053c 3502001b      	mov	L13_uart_state,#2
2953  0540 acd105d1      	jpf	L5321
2954  0544               L1321:
2955                     ; 427 			read_byte = hal_uart_read_byte();
2957  0544 adbd          	call	_hal_uart_read_byte
2959  0546 6b2b          	ld	(OFST+0,sp),a
2961                     ; 429 			if (read_byte == '\n' || read_byte == '\r'){
2963  0548 7b2b          	ld	a,(OFST+0,sp)
2964  054a a10a          	cp	a,#10
2965  054c 2706          	jreq	L3421
2967  054e 7b2b          	ld	a,(OFST+0,sp)
2968  0550 a10d          	cp	a,#13
2969  0552 265c          	jrne	L1421
2970  0554               L3421:
2971                     ; 430 				if(uart_rx_count > 0){
2973  0554 be1f          	ldw	x,_uart_rx_count
2974  0556 2772          	jreq	L5521
2975                     ; 431 					uart_rx_buffer[uart_rx_count] = '\0';
2977  0558 be1f          	ldw	x,_uart_rx_count
2978  055a 6f00          	clr	(_uart_rx_buffer,x)
2979                     ; 432 					if (command_parser_execute((const char *)uart_rx_buffer,uart_rx_count) == 0){
2981  055c be1f          	ldw	x,_uart_rx_count
2982  055e 89            	pushw	x
2983  055f ae0000        	ldw	x,#_uart_rx_buffer
2984  0562 cd03d5        	call	_command_parser_execute
2986  0565 5b02          	addw	sp,#2
2987  0567 a30000        	cpw	x,#0
2988  056a 2634          	jrne	L7421
2989                     ; 433 						state = sensor_reader_get_state();
2991  056c 96            	ldw	x,sp
2992  056d 1c0027        	addw	x,#OFST-4
2993  0570 89            	pushw	x
2994  0571 cd011a        	call	_sensor_reader_get_state
2996  0574 85            	popw	x
2997                     ; 434 						message_formatter_alive(resp_buf, sizeof(resp_buf),state.di1,state.di2,state.di3,state.di4);
2999  0575 7b2a          	ld	a,(OFST-1,sp)
3000  0577 88            	push	a
3001  0578 7b2a          	ld	a,(OFST-1,sp)
3002  057a 88            	push	a
3003  057b 7b2a          	ld	a,(OFST-1,sp)
3004  057d 88            	push	a
3005  057e 7b2a          	ld	a,(OFST-1,sp)
3006  0580 88            	push	a
3007  0581 ae0020        	ldw	x,#32
3008  0584 89            	pushw	x
3009  0585 96            	ldw	x,sp
3010  0586 1c000d        	addw	x,#OFST-30
3011  0589 cd0126        	call	_message_formatter_alive
3013  058c 5b06          	addw	sp,#6
3014                     ; 435 					 	uart_server_send((uint8_t *)resp_buf,strlen(resp_buf));
3016  058e 96            	ldw	x,sp
3017  058f 1c0007        	addw	x,#OFST-36
3018  0592 cd0000        	call	_strlen
3020  0595 89            	pushw	x
3021  0596 96            	ldw	x,sp
3022  0597 1c0009        	addw	x,#OFST-34
3023  059a cd00e5        	call	_uart_server_send
3025  059d 85            	popw	x
3027  059e 200b          	jra	L1521
3028  05a0               L7421:
3029                     ; 438                         uart_server_send((uint8_t *)"ERROR,INVALID_COMMAND\n",strlen("ERROR,INVALID_COMMAND\n"));
3031  05a0 ae0016        	ldw	x,#22
3032  05a3 89            	pushw	x
3033  05a4 ae0025        	ldw	x,#L3521
3034  05a7 cd00e5        	call	_uart_server_send
3036  05aa 85            	popw	x
3037  05ab               L1521:
3038                     ; 440                     uart_rx_count = 0;
3040  05ab 5f            	clrw	x
3041  05ac bf1f          	ldw	_uart_rx_count,x
3042  05ae 201a          	jra	L5521
3043  05b0               L1421:
3044                     ; 443             else if (read_byte >= 32 && read_byte < 127){
3046  05b0 7b2b          	ld	a,(OFST+0,sp)
3047  05b2 a120          	cp	a,#32
3048  05b4 2514          	jrult	L5521
3050  05b6 7b2b          	ld	a,(OFST+0,sp)
3051  05b8 a17f          	cp	a,#127
3052  05ba 240e          	jruge	L5521
3053                     ; 444                 uart_rx_buffer[uart_rx_count++] = read_byte;
3055  05bc 7b2b          	ld	a,(OFST+0,sp)
3056  05be be1f          	ldw	x,_uart_rx_count
3057  05c0 1c0001        	addw	x,#1
3058  05c3 bf1f          	ldw	_uart_rx_count,x
3059  05c5 1d0001        	subw	x,#1
3060  05c8 e700          	ld	(_uart_rx_buffer,x),a
3061  05ca               L5521:
3062                     ; 446             available_len--;
3064  05ca 1e05          	ldw	x,(OFST-38,sp)
3065  05cc 1d0001        	subw	x,#1
3066  05cf 1f05          	ldw	(OFST-38,sp),x
3068  05d1               L5321:
3069                     ; 426 		while (available_len > 0 && uart_rx_count < sizeof(uart_rx_buffer) - 1){
3071  05d1 1e05          	ldw	x,(OFST-38,sp)
3072  05d3 270a          	jreq	L1621
3074  05d5 be1f          	ldw	x,_uart_rx_count
3075  05d7 a30004        	cpw	x,#4
3076  05da 2403          	jruge	L222
3077  05dc cc0544        	jp	L1321
3078  05df               L222:
3079  05df               L1621:
3080                     ; 448         uart_state = UART_STATE_READY;
3082  05df 3501001b      	mov	L13_uart_state,#1
3084  05e3 2004          	jra	L3621
3085  05e5               L7221:
3086                     ; 451         uart_state = UART_STATE_READY;
3088  05e5 3501001b      	mov	L13_uart_state,#1
3089  05e9               L3621:
3090                     ; 453 }
3091  05e9               L412:
3094  05e9 5b2b          	addw	sp,#43
3095  05eb 81            	ret
3132                     ; 454 uint8_t hal_spi_byte(uint8_t data)
3132                     ; 455 {
3133                     	switch	.text
3134  05ec               _hal_spi_byte:
3136  05ec 88            	push	a
3137       00000000      OFST:	set	0
3140  05ed               L5031:
3141                     ; 456     while (SPI_GetFlagStatus(SPI_FLAG_TXE) == RESET);
3143  05ed a602          	ld	a,#2
3144  05ef cd0000        	call	_SPI_GetFlagStatus
3146  05f2 4d            	tnz	a
3147  05f3 27f8          	jreq	L5031
3148                     ; 458     SPI_SendData(data);
3150  05f5 7b01          	ld	a,(OFST+1,sp)
3151  05f7 cd0000        	call	_SPI_SendData
3154  05fa               L3131:
3155                     ; 460     while (SPI_GetFlagStatus(SPI_FLAG_RXNE) == RESET);
3157  05fa a601          	ld	a,#1
3158  05fc cd0000        	call	_SPI_GetFlagStatus
3160  05ff 4d            	tnz	a
3161  0600 27f8          	jreq	L3131
3162                     ; 462     return SPI_ReceiveData();
3164  0602 cd0000        	call	_SPI_ReceiveData
3168  0605 5b01          	addw	sp,#1
3169  0607 81            	ret
3193                     ; 464 uint8_t hal_spi_read_byte(void)
3193                     ; 465 {
3194                     	switch	.text
3195  0608               _hal_spi_read_byte:
3199                     ; 466     return hal_spi_byte(0xFF);
3201  0608 a6ff          	ld	a,#255
3202  060a ade0          	call	_hal_spi_byte
3206  060c 81            	ret
3241                     ; 468 void hal_spi_write_byte(uint8_t data)
3241                     ; 469 {
3242                     	switch	.text
3243  060d               _hal_spi_write_byte:
3247                     ; 470     hal_spi_byte(data);
3249  060d addd          	call	_hal_spi_byte
3251                     ; 471 }
3254  060f 81            	ret
3308                     ; 472 void hal_spi_read(uint8_t *buf, uint16_t len){
3309                     	switch	.text
3310  0610               _hal_spi_read:
3312  0610 89            	pushw	x
3313  0611 89            	pushw	x
3314       00000002      OFST:	set	2
3317                     ; 474     for(i = 0; i < len; i++){
3319  0612 5f            	clrw	x
3320  0613 1f01          	ldw	(OFST-1,sp),x
3323  0615 2011          	jra	L7731
3324  0617               L3731:
3325                     ; 475         buf[i] = hal_spi_byte(0xFF);
3327  0617 a6ff          	ld	a,#255
3328  0619 add1          	call	_hal_spi_byte
3330  061b 1e03          	ldw	x,(OFST+1,sp)
3331  061d 72fb01        	addw	x,(OFST-1,sp)
3332  0620 f7            	ld	(x),a
3333                     ; 474     for(i = 0; i < len; i++){
3335  0621 1e01          	ldw	x,(OFST-1,sp)
3336  0623 1c0001        	addw	x,#1
3337  0626 1f01          	ldw	(OFST-1,sp),x
3339  0628               L7731:
3342  0628 1e01          	ldw	x,(OFST-1,sp)
3343  062a 1307          	cpw	x,(OFST+5,sp)
3344  062c 25e9          	jrult	L3731
3345                     ; 477 }
3348  062e 5b04          	addw	sp,#4
3349  0630 81            	ret
3403                     ; 479 void hal_spi_write(uint8_t *buf, uint16_t len){
3404                     	switch	.text
3405  0631               _hal_spi_write:
3407  0631 89            	pushw	x
3408  0632 89            	pushw	x
3409       00000002      OFST:	set	2
3412                     ; 481     for(i = 0; i < len; i++){
3414  0633 5f            	clrw	x
3415  0634 1f01          	ldw	(OFST-1,sp),x
3418  0636 200f          	jra	L5341
3419  0638               L1341:
3420                     ; 482         hal_spi_byte(buf[i]);
3422  0638 1e03          	ldw	x,(OFST+1,sp)
3423  063a 72fb01        	addw	x,(OFST-1,sp)
3424  063d f6            	ld	a,(x)
3425  063e adac          	call	_hal_spi_byte
3427                     ; 481     for(i = 0; i < len; i++){
3429  0640 1e01          	ldw	x,(OFST-1,sp)
3430  0642 1c0001        	addw	x,#1
3431  0645 1f01          	ldw	(OFST-1,sp),x
3433  0647               L5341:
3436  0647 1e01          	ldw	x,(OFST-1,sp)
3437  0649 1307          	cpw	x,(OFST+5,sp)
3438  064b 25eb          	jrult	L1341
3439                     ; 484 }
3442  064d 5b04          	addw	sp,#4
3443  064f 81            	ret
3485                     ; 486 void uart_server_init(uint32_t baudrate){
3486                     	switch	.text
3487  0650               _uart_server_init:
3489       00000000      OFST:	set	0
3492                     ; 487 	uart_state = UART_STATE_IDLE;
3494  0650 3f1b          	clr	L13_uart_state
3495                     ; 488 	uart_rx_count = 0;
3497  0652 5f            	clrw	x
3498  0653 bf1f          	ldw	_uart_rx_count,x
3499                     ; 489 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_UART1, ENABLE);
3501  0655 ae0301        	ldw	x,#769
3502  0658 cd0000        	call	_CLK_PeripheralClockConfig
3504                     ; 490     UART1_Init(
3504                     ; 491     baudrate,
3504                     ; 492     UART1_WORDLENGTH_8D,
3504                     ; 493     UART1_STOPBITS_1,
3504                     ; 494     UART1_PARITY_NO,
3504                     ; 495     UART1_SYNCMODE_CLOCK_DISABLE,
3504                     ; 496     (UART1_Mode_TypeDef)(UART1_MODE_TX_ENABLE | UART1_MODE_RX_ENABLE)
3504                     ; 497 );
3506  065b 4b0c          	push	#12
3507  065d 4b80          	push	#128
3508  065f 4b00          	push	#0
3509  0661 4b00          	push	#0
3510  0663 4b00          	push	#0
3511  0665 1e0a          	ldw	x,(OFST+10,sp)
3512  0667 89            	pushw	x
3513  0668 1e0a          	ldw	x,(OFST+10,sp)
3514  066a 89            	pushw	x
3515  066b cd0000        	call	_UART1_Init
3517  066e 5b09          	addw	sp,#9
3518                     ; 499     UART1_ITConfig(UART1_IT_RXNE, ENABLE);
3520  0670 4b01          	push	#1
3521  0672 ae0255        	ldw	x,#597
3522  0675 cd0000        	call	_UART1_ITConfig
3524  0678 84            	pop	a
3525                     ; 502     UART1_Cmd(ENABLE);
3527  0679 a601          	ld	a,#1
3528  067b cd0000        	call	_UART1_Cmd
3530                     ; 504     uart_rx_head = 0;
3532  067e 5f            	clrw	x
3533  067f bf21          	ldw	_uart_rx_head,x
3534                     ; 505     uart_rx_tail = 0;
3536  0681 5f            	clrw	x
3537  0682 bf23          	ldw	_uart_rx_tail,x
3538                     ; 506     uart_rx_count = 0;  
3540  0684 5f            	clrw	x
3541  0685 bf1f          	ldw	_uart_rx_count,x
3542                     ; 507 	uart_state = UART_STATE_READY;
3544  0687 3501001b      	mov	L13_uart_state,#1
3545                     ; 508 }
3548  068b 81            	ret
3576                     ; 510 void hal_timer_init(void){
3577                     	switch	.text
3578  068c               _hal_timer_init:
3582                     ; 511     CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER4, ENABLE);
3584  068c ae0401        	ldw	x,#1025
3585  068f cd0000        	call	_CLK_PeripheralClockConfig
3587                     ; 512     TIM4_TimeBaseInit(TIM4_PRESCALER_128, 125);
3589  0692 ae077d        	ldw	x,#1917
3590  0695 cd0000        	call	_TIM4_TimeBaseInit
3592                     ; 513     TIM4_ClearFlag(TIM4_FLAG_UPDATE);
3594  0698 a601          	ld	a,#1
3595  069a cd0000        	call	_TIM4_ClearFlag
3597                     ; 515     TIM4_ITConfig(TIM4_IT_UPDATE, ENABLE);
3599  069d ae0101        	ldw	x,#257
3600  06a0 cd0000        	call	_TIM4_ITConfig
3602                     ; 517     enableInterrupts();
3605  06a3 9a            rim
3607                     ; 518 }
3611  06a4 81            	ret
3698                     ; 520 void tcp_server_process(void){
3699                     	switch	.text
3700  06a5               _tcp_server_process:
3702  06a5 522b          	subw	sp,#43
3703       0000002b      OFST:	set	43
3706                     ; 521     uint16_t received_len = 0;
3708                     ; 524     if(server_state == TCP_STATE_IDLE) return;
3710  06a7 3d0a          	tnz	L32_server_state
3711  06a9 2603          	jrne	L252
3712  06ab cc0781        	jp	L052
3713  06ae               L252:
3716                     ; 525     sock_status = getSn_SR(server_socket);
3718  06ae b61c          	ld	a,L33_server_socket
3719  06b0 97            	ld	xl,a
3720  06b1 a604          	ld	a,#4
3721  06b3 42            	mul	x,a
3722  06b4 58            	sllw	x
3723  06b5 58            	sllw	x
3724  06b6 58            	sllw	x
3725  06b7 1c0308        	addw	x,#776
3726  06ba cd0000        	call	c_itolx
3728  06bd be02          	ldw	x,c_lreg+2
3729  06bf 89            	pushw	x
3730  06c0 be00          	ldw	x,c_lreg
3731  06c2 89            	pushw	x
3732  06c3 cd0000        	call	_WIZCHIP_READ
3734  06c6 5b04          	addw	sp,#4
3735  06c8 6b29          	ld	(OFST-2,sp),a
3737                     ; 527     switch(sock_status){
3739  06ca 7b29          	ld	a,(OFST-2,sp)
3741                     ; 560             break;
3742  06cc 4d            	tnz	a
3743  06cd 2603          	jrne	L452
3744  06cf cc0763        	jp	L3741
3745  06d2               L452:
3746  06d2 a014          	sub	a,#20
3747  06d4 270c          	jreq	L7641
3748  06d6 a003          	sub	a,#3
3749  06d8 2710          	jreq	L1741
3750  06da               L5741:
3751                     ; 558         default:
3751                     ; 559             server_state = TCP_STATE_ERROR;
3753  06da 3503000a      	mov	L32_server_state,#3
3754                     ; 560             break;
3756  06de ac810781      	jpf	L1451
3757  06e2               L7641:
3758                     ; 528         case SOCK_LISTEN:
3758                     ; 529             server_state = TCP_STATE_LISTENING;
3760  06e2 3501000a      	mov	L32_server_state,#1
3761                     ; 530             break;
3763  06e6 ac810781      	jpf	L1451
3764  06ea               L1741:
3765                     ; 532         case SOCK_ESTABLISHED:
3765                     ; 533             server_state = TCP_STATE_CONNECTED;
3767  06ea 3502000a      	mov	L32_server_state,#2
3768                     ; 534             received_len = getSn_RX_RSR(server_socket);
3770  06ee b61c          	ld	a,L33_server_socket
3771  06f0 cd0000        	call	_getSn_RX_RSR
3773  06f3 1f2a          	ldw	(OFST-1,sp),x
3775                     ; 535             if(received_len > 0){
3777  06f5 1e2a          	ldw	x,(OFST-1,sp)
3778  06f7 27b2          	jreq	L1451
3779                     ; 536                 uint16_t read_len = (received_len > TCP_RX_BUFFER) ? TCP_RX_BUFFER : received_len;
3781  06f9 1e2a          	ldw	x,(OFST-1,sp)
3782  06fb a30021        	cpw	x,#33
3783  06fe 2505          	jrult	L442
3784  0700 ae0020        	ldw	x,#32
3785  0703 2002          	jra	L642
3786  0705               L442:
3787  0705 1e2a          	ldw	x,(OFST-1,sp)
3788  0707               L642:
3789  0707 1f2a          	ldw	(OFST-1,sp),x
3791                     ; 538                 read_len = recv(server_socket, rx_buffer, read_len);
3793  0709 1e2a          	ldw	x,(OFST-1,sp)
3794  070b 89            	pushw	x
3795  070c ae002a        	ldw	x,#_rx_buffer
3796  070f 89            	pushw	x
3797  0710 b61c          	ld	a,L33_server_socket
3798  0712 cd0000        	call	_recv
3800  0715 5b04          	addw	sp,#4
3801  0717 be02          	ldw	x,c_lreg+2
3802  0719 1f2a          	ldw	(OFST-1,sp),x
3804                     ; 539                 if(read_len > 0){
3806  071b 1e2a          	ldw	x,(OFST-1,sp)
3807  071d 2762          	jreq	L1451
3808                     ; 540                     if(command_parser_execute((const char *)rx_buffer, read_len) == 0){
3810  071f 1e2a          	ldw	x,(OFST-1,sp)
3811  0721 89            	pushw	x
3812  0722 ae002a        	ldw	x,#_rx_buffer
3813  0725 cd03d5        	call	_command_parser_execute
3815  0728 5b02          	addw	sp,#2
3816  072a a30000        	cpw	x,#0
3817  072d 2652          	jrne	L1451
3818                     ; 543                         sensor_state_t state = sensor_reader_get_state();
3820  072f 96            	ldw	x,sp
3821  0730 1c0025        	addw	x,#OFST-6
3822  0733 89            	pushw	x
3823  0734 cd011a        	call	_sensor_reader_get_state
3825  0737 85            	popw	x
3826                     ; 544                         message_formatter_alive(resp_buf,sizeof(resp_buf),state.di1,state.di2,state.di3,state.di4);
3828  0738 7b28          	ld	a,(OFST-3,sp)
3829  073a 88            	push	a
3830  073b 7b28          	ld	a,(OFST-3,sp)
3831  073d 88            	push	a
3832  073e 7b28          	ld	a,(OFST-3,sp)
3833  0740 88            	push	a
3834  0741 7b28          	ld	a,(OFST-3,sp)
3835  0743 88            	push	a
3836  0744 ae0020        	ldw	x,#32
3837  0747 89            	pushw	x
3838  0748 96            	ldw	x,sp
3839  0749 1c000b        	addw	x,#OFST-32
3840  074c cd0126        	call	_message_formatter_alive
3842  074f 5b06          	addw	sp,#6
3843                     ; 545                         tcp_server_send((uint8_t *)resp_buf, strlen(resp_buf));
3845  0751 96            	ldw	x,sp
3846  0752 1c0005        	addw	x,#OFST-38
3847  0755 cd0000        	call	_strlen
3849  0758 89            	pushw	x
3850  0759 96            	ldw	x,sp
3851  075a 1c0007        	addw	x,#OFST-36
3852  075d cd0041        	call	_tcp_server_send
3854  0760 85            	popw	x
3855  0761 201e          	jra	L1451
3856  0763               L3741:
3857                     ; 551         case SOCK_CLOSED:
3857                     ; 552             server_state = TCP_STATE_LISTENING;
3859  0763 3501000a      	mov	L32_server_state,#1
3860                     ; 553             close(server_socket);
3862  0767 b61c          	ld	a,L33_server_socket
3863  0769 cd0000        	call	_close
3865                     ; 554             socket(server_socket, Sn_MR_TCP, server_port, 0);
3867  076c 4b00          	push	#0
3868  076e be1d          	ldw	x,L53_server_port
3869  0770 89            	pushw	x
3870  0771 b61c          	ld	a,L33_server_socket
3871  0773 ae0001        	ldw	x,#1
3872  0776 95            	ld	xh,a
3873  0777 cd0000        	call	_socket
3875  077a 5b03          	addw	sp,#3
3876                     ; 555             listen(server_socket);
3878  077c b61c          	ld	a,L33_server_socket
3879  077e cd0000        	call	_listen
3881                     ; 556             break;
3883  0781               L1451:
3884                     ; 562 }
3885  0781               L052:
3888  0781 5b2b          	addw	sp,#43
3889  0783 81            	ret
3892                     	switch	.const
3893  0008               L3551_mac:
3894  0008 00            	dc.b	0
3895  0009 08            	dc.b	8
3896  000a dc            	dc.b	220
3897  000b 12            	dc.b	18
3898  000c 34            	dc.b	52
3899  000d 56            	dc.b	86
3900  000e               L5551_ip:
3901  000e c0            	dc.b	192
3902  000f a8            	dc.b	168
3903  0010 01            	dc.b	1
3904  0011 64            	dc.b	100
3905  0012               L7551_sn:
3906  0012 ff            	dc.b	255
3907  0013 ff            	dc.b	255
3908  0014 ff            	dc.b	255
3909  0015 00            	dc.b	0
3910  0016               L1651_gw:
3911  0016 c0            	dc.b	192
3912  0017 a8            	dc.b	168
3913  0018 01            	dc.b	1
3914  0019 01            	dc.b	1
4046                     ; 563 static void w5500_init_network(void)
4046                     ; 564 {
4047                     	switch	.text
4048  0784               L1551_w5500_init_network:
4050  0784 5228          	subw	sp,#40
4051       00000028      OFST:	set	40
4054                     ; 567     uint8_t mac[6] = MAC_ADDR;
4056  0786 96            	ldw	x,sp
4057  0787 1c0001        	addw	x,#OFST-39
4058  078a 90ae0008      	ldw	y,#L3551_mac
4059  078e a606          	ld	a,#6
4060  0790 cd0000        	call	c_xymov
4062                     ; 568     uint8_t ip[4]  = IP_ADDR;
4064  0793 96            	ldw	x,sp
4065  0794 1c0007        	addw	x,#OFST-33
4066  0797 90ae000e      	ldw	y,#L5551_ip
4067  079b a604          	ld	a,#4
4068  079d cd0000        	call	c_xymov
4070                     ; 569     uint8_t sn[4]  = SUBNET_MASK;
4072  07a0 96            	ldw	x,sp
4073  07a1 1c000b        	addw	x,#OFST-29
4074  07a4 90ae0012      	ldw	y,#L7551_sn
4075  07a8 a604          	ld	a,#4
4076  07aa cd0000        	call	c_xymov
4078                     ; 570     uint8_t gw[4]  = GATEWAY_ADDR;
4080  07ad 96            	ldw	x,sp
4081  07ae 1c000f        	addw	x,#OFST-25
4082  07b1 90ae0016      	ldw	y,#L1651_gw
4083  07b5 a604          	ld	a,#4
4084  07b7 cd0000        	call	c_xymov
4086                     ; 572     memcpy(netinfo.mac, mac, 6);
4088  07ba 96            	ldw	x,sp
4089  07bb 1c0013        	addw	x,#OFST-21
4090  07be bf00          	ldw	c_x,x
4091  07c0 9096          	ldw	y,sp
4092  07c2 72a90001      	addw	y,#OFST-39
4093  07c6 90bf00        	ldw	c_y,y
4094  07c9 ae0006        	ldw	x,#6
4095  07cc               L062:
4096  07cc 5a            	decw	x
4097  07cd 92d600        	ld	a,([c_y.w],x)
4098  07d0 92d700        	ld	([c_x.w],x),a
4099  07d3 5d            	tnzw	x
4100  07d4 26f6          	jrne	L062
4101                     ; 573     memcpy(netinfo.ip,  ip, 4);
4103  07d6 96            	ldw	x,sp
4104  07d7 1c0019        	addw	x,#OFST-15
4105  07da bf00          	ldw	c_x,x
4106  07dc 9096          	ldw	y,sp
4107  07de 72a90007      	addw	y,#OFST-33
4108  07e2 90bf00        	ldw	c_y,y
4109  07e5 ae0004        	ldw	x,#4
4110  07e8               L262:
4111  07e8 5a            	decw	x
4112  07e9 92d600        	ld	a,([c_y.w],x)
4113  07ec 92d700        	ld	([c_x.w],x),a
4114  07ef 5d            	tnzw	x
4115  07f0 26f6          	jrne	L262
4116                     ; 574     memcpy(netinfo.sn,  sn, 4);
4118  07f2 96            	ldw	x,sp
4119  07f3 1c001d        	addw	x,#OFST-11
4120  07f6 bf00          	ldw	c_x,x
4121  07f8 9096          	ldw	y,sp
4122  07fa 72a9000b      	addw	y,#OFST-29
4123  07fe 90bf00        	ldw	c_y,y
4124  0801 ae0004        	ldw	x,#4
4125  0804               L462:
4126  0804 5a            	decw	x
4127  0805 92d600        	ld	a,([c_y.w],x)
4128  0808 92d700        	ld	([c_x.w],x),a
4129  080b 5d            	tnzw	x
4130  080c 26f6          	jrne	L462
4131                     ; 575     memcpy(netinfo.gw,  gw, 4);
4133  080e 96            	ldw	x,sp
4134  080f 1c0021        	addw	x,#OFST-7
4135  0812 bf00          	ldw	c_x,x
4136  0814 9096          	ldw	y,sp
4137  0816 72a9000f      	addw	y,#OFST-25
4138  081a 90bf00        	ldw	c_y,y
4139  081d ae0004        	ldw	x,#4
4140  0820               L662:
4141  0820 5a            	decw	x
4142  0821 92d600        	ld	a,([c_y.w],x)
4143  0824 92d700        	ld	([c_x.w],x),a
4144  0827 5d            	tnzw	x
4145  0828 26f6          	jrne	L662
4146                     ; 577     wizchip_setnetinfo(&netinfo);
4148  082a 96            	ldw	x,sp
4149  082b 1c0013        	addw	x,#OFST-21
4150  082e cd0000        	call	_wizchip_setnetinfo
4152                     ; 578 }
4155  0831 5b28          	addw	sp,#40
4156  0833 81            	ret
4196                     ; 579 void tcp_server_init(uint16_t port){
4197                     	switch	.text
4198  0834               _tcp_server_init:
4202                     ; 580     server_port = port;
4204  0834 bf1d          	ldw	L53_server_port,x
4205                     ; 581     server_state = TCP_STATE_IDLE;
4207  0836 3f0a          	clr	L32_server_state
4208                     ; 583     w5500_init_network();
4210  0838 cd0784        	call	L1551_w5500_init_network
4212                     ; 584     if(socket(server_socket, Sn_MR_TCP, server_port, 0) == server_socket){
4214  083b 4b00          	push	#0
4215  083d be1d          	ldw	x,L53_server_port
4216  083f 89            	pushw	x
4217  0840 b61c          	ld	a,L33_server_socket
4218  0842 ae0001        	ldw	x,#1
4219  0845 95            	ld	xh,a
4220  0846 cd0000        	call	_socket
4222  0849 5b03          	addw	sp,#3
4223  084b 5f            	clrw	x
4224  084c 4d            	tnz	a
4225  084d 2a01          	jrpl	L272
4226  084f 53            	cplw	x
4227  0850               L272:
4228  0850 97            	ld	xl,a
4229  0851 b61c          	ld	a,L33_server_socket
4230  0853 905f          	clrw	y
4231  0855 9097          	ld	yl,a
4232  0857 90bf00        	ldw	c_y,y
4233  085a b300          	cpw	x,c_y
4234  085c 260d          	jrne	L7661
4235                     ; 585         if(listen(server_socket) == SOCK_OK){
4237  085e b61c          	ld	a,L33_server_socket
4238  0860 cd0000        	call	_listen
4240  0863 a101          	cp	a,#1
4241  0865 2604          	jrne	L7661
4242                     ; 586             server_state = TCP_STATE_LISTENING;
4244  0867 3501000a      	mov	L32_server_state,#1
4245  086b               L7661:
4246                     ; 589 }
4249  086b 81            	ret
4309                     ; 591 void w5500_chip_init(void)
4309                     ; 592 {
4310                     	switch	.text
4311  086c               _w5500_chip_init:
4313  086c 88            	push	a
4314       00000001      OFST:	set	1
4317                     ; 596     GPIO_WriteLow(W5500_RST_PORT, W5500_RST_PIN);
4319  086d 4b20          	push	#32
4320  086f ae5014        	ldw	x,#20500
4321  0872 cd0000        	call	_GPIO_WriteLow
4323  0875 84            	pop	a
4324                     ; 597     hal_delay_ms(100);
4326  0876 ae0064        	ldw	x,#100
4327  0879 cd0014        	call	_hal_delay_ms
4329                     ; 598     hal_w5500_reset_high();
4331  087c cd044a        	call	_hal_w5500_reset_high
4333                     ; 599     GPIO_WriteHigh(W5500_RST_PORT, W5500_RST_PIN);
4335  087f 4b20          	push	#32
4336  0881 ae5014        	ldw	x,#20500
4337  0884 cd0000        	call	_GPIO_WriteHigh
4339  0887 84            	pop	a
4340                     ; 600     CLK_PeripheralClockConfig(CLK_PERIPHERAL_SPI, ENABLE);
4342  0888 ae0101        	ldw	x,#257
4343  088b cd0000        	call	_CLK_PeripheralClockConfig
4345                     ; 601     GPIO_Init(W5500_SCK_PORT,W5500_SCK_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
4347  088e 4bf0          	push	#240
4348  0890 4b20          	push	#32
4349  0892 ae500a        	ldw	x,#20490
4350  0895 cd0000        	call	_GPIO_Init
4352  0898 85            	popw	x
4353                     ; 602     GPIO_Init(W5500_MOSI_PORT,W5500_MOSI_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
4355  0899 4bf0          	push	#240
4356  089b 4b40          	push	#64
4357  089d ae500a        	ldw	x,#20490
4358  08a0 cd0000        	call	_GPIO_Init
4360  08a3 85            	popw	x
4361                     ; 603     GPIO_Init(W5500_MISO_PORT,W5500_MISO_PIN,GPIO_MODE_IN_FL_NO_IT);
4363  08a4 4b00          	push	#0
4364  08a6 4b80          	push	#128
4365  08a8 ae500a        	ldw	x,#20490
4366  08ab cd0000        	call	_GPIO_Init
4368  08ae 85            	popw	x
4369                     ; 604     GPIO_Init(W5500_CS_PORT,W5500_CS_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
4371  08af 4bf0          	push	#240
4372  08b1 4b08          	push	#8
4373  08b3 ae5000        	ldw	x,#20480
4374  08b6 cd0000        	call	_GPIO_Init
4376  08b9 85            	popw	x
4377                     ; 605     GPIO_WriteHigh(W5500_CS_PORT, W5500_CS_PIN);
4379  08ba 4b08          	push	#8
4380  08bc ae5000        	ldw	x,#20480
4381  08bf cd0000        	call	_GPIO_WriteHigh
4383  08c2 84            	pop	a
4384                     ; 606     GPIO_Init(W5500_RST_PORT,W5500_RST_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
4386  08c3 4bf0          	push	#240
4387  08c5 4b20          	push	#32
4388  08c7 ae5014        	ldw	x,#20500
4389  08ca cd0000        	call	_GPIO_Init
4391  08cd 85            	popw	x
4392                     ; 607     SPI_DeInit();
4394  08ce cd0000        	call	_SPI_DeInit
4396                     ; 608         SPI_Init(
4396                     ; 609         SPI_FIRSTBIT_MSB,
4396                     ; 610         SPI_BAUDRATEPRESCALER_4,
4396                     ; 611         SPI_MODE_MASTER,
4396                     ; 612         SPI_CLOCKPOLARITY_LOW,
4396                     ; 613         SPI_CLOCKPHASE_1EDGE,
4396                     ; 614         SPI_DATADIRECTION_2LINES_FULLDUPLEX,
4396                     ; 615         SPI_NSS_SOFT,
4396                     ; 616         0x07
4396                     ; 617     );
4398  08d1 4b07          	push	#7
4399  08d3 4b02          	push	#2
4400  08d5 4b00          	push	#0
4401  08d7 4b00          	push	#0
4402  08d9 4b00          	push	#0
4403  08db 4b04          	push	#4
4404  08dd ae0008        	ldw	x,#8
4405  08e0 cd0000        	call	_SPI_Init
4407  08e3 5b06          	addw	sp,#6
4408                     ; 619     SPI_Cmd(ENABLE);
4410  08e5 a601          	ld	a,#1
4411  08e7 cd0000        	call	_SPI_Cmd
4413                     ; 620     reg_wizchip_spi_cbfunc(hal_spi_read_byte,hal_spi_write_byte);
4415  08ea ae060d        	ldw	x,#_hal_spi_write_byte
4416  08ed 89            	pushw	x
4417  08ee ae0608        	ldw	x,#_hal_spi_read_byte
4418  08f1 cd0000        	call	_reg_wizchip_spi_cbfunc
4420  08f4 85            	popw	x
4421                     ; 621     reg_wizchip_spiburst_cbfunc(hal_spi_read,hal_spi_write);
4423  08f5 ae0631        	ldw	x,#_hal_spi_write
4424  08f8 89            	pushw	x
4425  08f9 ae0610        	ldw	x,#_hal_spi_read
4426  08fc cd0000        	call	_reg_wizchip_spiburst_cbfunc
4428  08ff 85            	popw	x
4429                     ; 622     reg_wizchip_cs_cbfunc(hal_spi_cs_low,hal_spi_cs_high);
4431  0900 ae00db        	ldw	x,#_hal_spi_cs_high
4432  0903 89            	pushw	x
4433  0904 ae00d1        	ldw	x,#_hal_spi_cs_low
4434  0907 cd0000        	call	_reg_wizchip_cs_cbfunc
4436  090a 85            	popw	x
4437                     ; 623     wizchip_init(0, 0);
4439  090b 5f            	clrw	x
4440  090c 89            	pushw	x
4441  090d 5f            	clrw	x
4442  090e cd0000        	call	_wizchip_init
4444  0911 85            	popw	x
4445                     ; 624     version = getVERSIONR();
4447  0912 ae0039        	ldw	x,#57
4448  0915 89            	pushw	x
4449  0916 ae0000        	ldw	x,#0
4450  0919 89            	pushw	x
4451  091a cd0000        	call	_WIZCHIP_READ
4453  091d 5b04          	addw	sp,#4
4454  091f 6b01          	ld	(OFST+0,sp),a
4456                     ; 625     if(version != 0x04)
4458  0921 7b01          	ld	a,(OFST+0,sp)
4459  0923 a104          	cp	a,#4
4460  0925 2702          	jreq	L1171
4461  0927               L3171:
4462                     ; 627         while(1);
4464  0927 20fe          	jra	L3171
4465  0929               L1171:
4466                     ; 629 }
4469  0929 84            	pop	a
4470  092a 81            	ret
4506                     ; 631 void system_init(void){
4507                     	switch	.text
4508  092b               _system_init:
4512                     ; 633     CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);  /* 16MHz clock */
4514  092b 4f            	clr	a
4515  092c cd0000        	call	_CLK_HSIPrescalerConfig
4517                     ; 635 	hal_gpio_init();
4519  092f cd0454        	call	_hal_gpio_init
4521                     ; 636     hal_timer_init();
4523  0932 cd068c        	call	_hal_timer_init
4525                     ; 638 	relay_control_init();
4527  0935 cd0444        	call	_relay_control_init
4529                     ; 639 	sensor_reader_init();
4531  0938 cd032c        	call	_sensor_reader_init
4533                     ; 641     w5500_chip_init();
4535  093b cd086c        	call	_w5500_chip_init
4537                     ; 642     tcp_server_init(TCP_SERVER_PORT);
4539  093e ae1388        	ldw	x,#5000
4540  0941 cd0834        	call	_tcp_server_init
4542                     ; 644     uart_server_init(UART_BAUDRATE);
4544  0944 aec200        	ldw	x,#49664
4545  0947 89            	pushw	x
4546  0948 ae0001        	ldw	x,#1
4547  094b 89            	pushw	x
4548  094c cd0650        	call	_uart_server_init
4550  094f 5b04          	addw	sp,#4
4551                     ; 647     hal_timer_set_callback(timer_callback);
4553  0951 ae0387        	ldw	x,#_timer_callback
4554  0954 cd03d2        	call	_hal_timer_set_callback
4556                     ; 648     hal_timer_start();
4558  0957 cd02aa        	call	_hal_timer_start
4560                     ; 649 	hal_delay_ms(500);
4562  095a ae01f4        	ldw	x,#500
4563  095d cd0014        	call	_hal_delay_ms
4565                     ; 650 }
4568  0960 81            	ret
4571                     	switch	.const
4572  001a               L7271_msg:
4573  001a 52455345542c  	dc.b	"RESET, OK",10,0
4615                     ; 652 void main_loop(void)
4615                     ; 653 {
4616                     	switch	.text
4617  0961               _main_loop:
4619  0961 520b          	subw	sp,#11
4620       0000000b      OFST:	set	11
4623  0963               L7471:
4624                     ; 657         tcp_server_process();
4626  0963 cd06a5        	call	_tcp_server_process
4628                     ; 659 		uart_server_process();
4630  0966 cd0528        	call	_uart_server_process
4632                     ; 661         if(GPIO_ReadInputPin(HARDRST_PORT, HARDRST_PIN) == RESET)
4634  0969 4b80          	push	#128
4635  096b ae5005        	ldw	x,#20485
4636  096e cd0000        	call	_GPIO_ReadInputPin
4638  0971 5b01          	addw	sp,#1
4639  0973 4d            	tnz	a
4640  0974 26ed          	jrne	L7471
4641                     ; 663             hal_delay_ms(50);
4643  0976 ae0032        	ldw	x,#50
4644  0979 cd0014        	call	_hal_delay_ms
4646                     ; 664 			if (GPIO_ReadInputPin(HARDRST_PORT, HARDRST_PIN) == 0){
4648  097c 4b80          	push	#128
4649  097e ae5005        	ldw	x,#20485
4650  0981 cd0000        	call	_GPIO_ReadInputPin
4652  0984 5b01          	addw	sp,#1
4653  0986 4d            	tnz	a
4654  0987 26da          	jrne	L7471
4655                     ; 666 				char msg[] = "RESET, OK\n";
4657  0989 96            	ldw	x,sp
4658  098a 1c0001        	addw	x,#OFST-10
4659  098d 90ae001a      	ldw	y,#L7271_msg
4660  0991 a60b          	ld	a,#11
4661  0993 cd0000        	call	c_xymov
4663                     ; 667                 if(tcp_server_is_connected()){
4665  0996 cd0007        	call	_tcp_server_is_connected
4667  0999 a30000        	cpw	x,#0
4668  099c 2710          	jreq	L7571
4669                     ; 668                     tcp_server_send((uint8_t *)msg, strlen(msg));
4671  099e 96            	ldw	x,sp
4672  099f 1c0001        	addw	x,#OFST-10
4673  09a2 cd0000        	call	_strlen
4675  09a5 89            	pushw	x
4676  09a6 96            	ldw	x,sp
4677  09a7 1c0003        	addw	x,#OFST-8
4678  09aa cd0041        	call	_tcp_server_send
4680  09ad 85            	popw	x
4681  09ae               L7571:
4682                     ; 670                 if (uart_server_is_ready()){
4684  09ae cd008d        	call	_uart_server_is_ready
4686  09b1 a30000        	cpw	x,#0
4687  09b4 2710          	jreq	L1671
4688                     ; 671                     uart_server_send((uint8_t *)msg, strlen(msg));
4690  09b6 96            	ldw	x,sp
4691  09b7 1c0001        	addw	x,#OFST-10
4692  09ba cd0000        	call	_strlen
4694  09bd 89            	pushw	x
4695  09be 96            	ldw	x,sp
4696  09bf 1c0003        	addw	x,#OFST-8
4697  09c2 cd00e5        	call	_uart_server_send
4699  09c5 85            	popw	x
4700  09c6               L1671:
4701                     ; 673 				hal_delay_ms(100);
4703  09c6 ae0064        	ldw	x,#100
4704  09c9 cd0014        	call	_hal_delay_ms
4706  09cc 2095          	jra	L7471
4731                     ; 680 int main(void)
4731                     ; 681 {
4732                     	switch	.text
4733  09ce               _main:
4737                     ; 682 	system_init();
4739  09ce cd092b        	call	_system_init
4741                     ; 683     main_loop();
4743  09d1 ad8e          	call	_main_loop
4745  09d3               L3771:
4746                     ; 684     while(1);
4748  09d3 20fe          	jra	L3771
5067                     	xdef	_main
5068                     	xdef	_main_loop
5069                     	xdef	_system_init
5070                     	xdef	_w5500_chip_init
5071                     	xdef	_tcp_server_init
5072                     	xdef	_tcp_server_process
5073                     	xdef	_hal_timer_init
5074                     	xdef	_uart_server_init
5075                     	xdef	_hal_spi_write
5076                     	xdef	_hal_spi_read
5077                     	xdef	_hal_spi_write_byte
5078                     	xdef	_hal_spi_read_byte
5079                     	xdef	_hal_spi_byte
5080                     	xdef	_uart_server_process
5081                     	xdef	_hal_uart_read_byte
5082                     	xdef	_hal_uart_available
5083                     	xdef	_hal_gpio_init
5084                     	xdef	_hal_w5500_reset_high
5085                     	xdef	_relay_control_init
5086                     	xdef	_command_parser_execute
5087                     	xdef	_hal_timer_set_callback
5088                     	xdef	_timer_callback
5089                     	xdef	_send_alive_message
5090                     	xdef	_sensor_reader_init
5091                     	xdef	_process_axle_counting
5092                     	xdef	_hal_timer_start
5093                     	xdef	_sensor_reader_update
5094                     	xdef	_relay_control_set_all
5095                     	xdef	_relay_control_set
5096                     	xdef	_hal_relay_set
5097                     	xdef	_hal_di_read
5098                     	xdef	_message_formatter_alive
5099                     	xdef	_sensor_reader_get_state
5100                     	xdef	_uart_server_send
5101                     	xdef	_hal_spi_cs_high
5102                     	xdef	_hal_spi_cs_low
5103                     	xdef	_hal_uart_send
5104                     	xdef	_hal_uart_send_byte
5105                     	xdef	_uart_server_is_ready
5106                     	xdef	_tcp_server_send
5107                     	xdef	_hal_delay_ms
5108                     	xdef	_tcp_server_is_connected
5109                     	xdef	_hal_get_millis
5110                     	xdef	_user_callback
5111                     	xdef	_systick_ms
5112                     	switch	.ubsct
5113  0000               _uart_rx_buffer:
5114  0000 0000000000    	ds.b	5
5115                     	xdef	_uart_rx_buffer
5116  0005               L73_uart_tx_buffer:
5117  0005 0000000000    	ds.b	5
5118                     	xdef	_uart_rx_tail
5119                     	xdef	_uart_rx_head
5120                     	xdef	_uart_rx_count
5121  000a               _tx_buffer:
5122  000a 000000000000  	ds.b	32
5123                     	xdef	_tx_buffer
5124  002a               _rx_buffer:
5125  002a 000000000000  	ds.b	32
5126                     	xdef	_rx_buffer
5127                     	xref	_strlen
5128                     	xref	_send
5129                     	xref	_recv
5130                     	xref	_listen
5131                     	xref	_close
5132                     	xref	_socket
5133                     	xref	_wizchip_init
5134                     	xref	_wizchip_setnetinfo
5135                     	xref	_reg_wizchip_spiburst_cbfunc
5136                     	xref	_reg_wizchip_spi_cbfunc
5137                     	xref	_getSn_RX_RSR
5138                     	xref	_reg_wizchip_cs_cbfunc
5139                     	xref	_WIZCHIP_READ
5140                     	xref	_TIM4_ClearFlag
5141                     	xref	_TIM4_ITConfig
5142                     	xref	_TIM4_Cmd
5143                     	xref	_TIM4_TimeBaseInit
5144                     	xref	_SPI_GetFlagStatus
5145                     	xref	_SPI_ReceiveData
5146                     	xref	_SPI_SendData
5147                     	xref	_SPI_Cmd
5148                     	xref	_SPI_Init
5149                     	xref	_SPI_DeInit
5150                     	xref	_UART1_GetFlagStatus
5151                     	xref	_UART1_SendData8
5152                     	xref	_UART1_ITConfig
5153                     	xref	_UART1_Cmd
5154                     	xref	_UART1_Init
5155                     	xref	_GPIO_ReadInputPin
5156                     	xref	_GPIO_WriteLow
5157                     	xref	_GPIO_WriteHigh
5158                     	xref	_GPIO_Init
5159                     	xref	_CLK_HSIPrescalerConfig
5160                     	xref	_CLK_PeripheralClockConfig
5161                     	switch	.const
5162  0025               L3521:
5163  0025 4552524f522c  	dc.b	"ERROR,INVALID_COMM"
5164  0037 414e440a00    	dc.b	"AND",10,0
5165                     	xref.b	c_lreg
5166                     	xref.b	c_x
5167                     	xref.b	c_y
5187                     	xref	c_itolx
5188                     	xref	c_xymov
5189                     	xref	c_lcmp
5190                     	xref	c_lsub
5191                     	xref	c_uitolx
5192                     	xref	c_rtol
5193                     	xref	c_ltor
5194                     	end
