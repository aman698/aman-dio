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
 353  0067 e740          	ld	(_tx_buffer,x),a
 354  0069 5d            	tnzw	x
 355  006a 26f7          	jrne	L22
 356  006c               L02:
 357                     ; 103     sent = send(server_socket, tx_buffer, len);
 359  006c 1e07          	ldw	x,(OFST+5,sp)
 360  006e 89            	pushw	x
 361  006f ae0040        	ldw	x,#_tx_buffer
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
 739  00f1 a30021        	cpw	x,#33
 740  00f4 2505          	jrult	L713
 741                     ; 144         len = sizeof(uart_tx_buffer);
 743  00f6 ae0020        	ldw	x,#32
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
 947                     ; 168     if(buf_size < 21)
 949  012c 9c            	rvf
 950  012d 1e05          	ldw	x,(OFST+5,sp)
 951  012f a30015        	cpw	x,#21
 952  0132 2e02          	jrsge	L114
 953                     ; 169         return;
 954  0134               L401:
 957  0134 85            	popw	x
 958  0135 81            	ret
 959  0136               L114:
 960                     ; 171     buf[0]  = 'S';
 962  0136 1e01          	ldw	x,(OFST+1,sp)
 963  0138 a653          	ld	a,#83
 964  013a f7            	ld	(x),a
 965                     ; 172     buf[1]  = 'T';
 967  013b 1e01          	ldw	x,(OFST+1,sp)
 968  013d a654          	ld	a,#84
 969  013f e701          	ld	(1,x),a
 970                     ; 173     buf[2]  = 'A';
 972  0141 1e01          	ldw	x,(OFST+1,sp)
 973  0143 a641          	ld	a,#65
 974  0145 e702          	ld	(2,x),a
 975                     ; 174     buf[3]  = 'R';
 977  0147 1e01          	ldw	x,(OFST+1,sp)
 978  0149 a652          	ld	a,#82
 979  014b e703          	ld	(3,x),a
 980                     ; 175     buf[4]  = 'T';
 982  014d 1e01          	ldw	x,(OFST+1,sp)
 983  014f a654          	ld	a,#84
 984  0151 e704          	ld	(4,x),a
 985                     ; 176     buf[5]  = ',';
 987  0153 1e01          	ldw	x,(OFST+1,sp)
 988  0155 a62c          	ld	a,#44
 989  0157 e705          	ld	(5,x),a
 990                     ; 177     buf[6]  = 'A';
 992  0159 1e01          	ldw	x,(OFST+1,sp)
 993  015b a641          	ld	a,#65
 994  015d e706          	ld	(6,x),a
 995                     ; 178     buf[7]  = 'L';
 997  015f 1e01          	ldw	x,(OFST+1,sp)
 998  0161 a64c          	ld	a,#76
 999  0163 e707          	ld	(7,x),a
1000                     ; 179     buf[8]  = 'I';
1002  0165 1e01          	ldw	x,(OFST+1,sp)
1003  0167 a649          	ld	a,#73
1004  0169 e708          	ld	(8,x),a
1005                     ; 180     buf[9]  = 'V';
1007  016b 1e01          	ldw	x,(OFST+1,sp)
1008  016d a656          	ld	a,#86
1009  016f e709          	ld	(9,x),a
1010                     ; 181     buf[10] = 'E';
1012  0171 1e01          	ldw	x,(OFST+1,sp)
1013  0173 a645          	ld	a,#69
1014  0175 e70a          	ld	(10,x),a
1015                     ; 182     buf[11] = ',';
1017  0177 1e01          	ldw	x,(OFST+1,sp)
1018  0179 a62c          	ld	a,#44
1019  017b e70b          	ld	(11,x),a
1020                     ; 184     buf[12] = di1 ? '1' : '0';
1022  017d 0d07          	tnz	(OFST+7,sp)
1023  017f 2704          	jreq	L46
1024  0181 a631          	ld	a,#49
1025  0183 2002          	jra	L66
1026  0185               L46:
1027  0185 a630          	ld	a,#48
1028  0187               L66:
1029  0187 1e01          	ldw	x,(OFST+1,sp)
1030  0189 e70c          	ld	(12,x),a
1031                     ; 185     buf[13] = di2 ? '1' : '0';
1033  018b 0d08          	tnz	(OFST+8,sp)
1034  018d 2704          	jreq	L07
1035  018f a631          	ld	a,#49
1036  0191 2002          	jra	L27
1037  0193               L07:
1038  0193 a630          	ld	a,#48
1039  0195               L27:
1040  0195 1e01          	ldw	x,(OFST+1,sp)
1041  0197 e70d          	ld	(13,x),a
1042                     ; 186     buf[14] = di3 ? '1' : '0';
1044  0199 0d09          	tnz	(OFST+9,sp)
1045  019b 2704          	jreq	L47
1046  019d a631          	ld	a,#49
1047  019f 2002          	jra	L67
1048  01a1               L47:
1049  01a1 a630          	ld	a,#48
1050  01a3               L67:
1051  01a3 1e01          	ldw	x,(OFST+1,sp)
1052  01a5 e70e          	ld	(14,x),a
1053                     ; 187     buf[15] = di4 ? '1' : '0';
1055  01a7 0d0a          	tnz	(OFST+10,sp)
1056  01a9 2704          	jreq	L001
1057  01ab a631          	ld	a,#49
1058  01ad 2002          	jra	L201
1059  01af               L001:
1060  01af a630          	ld	a,#48
1061  01b1               L201:
1062  01b1 1e01          	ldw	x,(OFST+1,sp)
1063  01b3 e70f          	ld	(15,x),a
1064                     ; 189     buf[16] = ',';
1066  01b5 1e01          	ldw	x,(OFST+1,sp)
1067  01b7 a62c          	ld	a,#44
1068  01b9 e710          	ld	(16,x),a
1069                     ; 190     buf[17] = 'E';
1071  01bb 1e01          	ldw	x,(OFST+1,sp)
1072  01bd a645          	ld	a,#69
1073  01bf e711          	ld	(17,x),a
1074                     ; 191     buf[18] = 'N';
1076  01c1 1e01          	ldw	x,(OFST+1,sp)
1077  01c3 a64e          	ld	a,#78
1078  01c5 e712          	ld	(18,x),a
1079                     ; 192     buf[19] = 'D';
1081  01c7 1e01          	ldw	x,(OFST+1,sp)
1082  01c9 a644          	ld	a,#68
1083  01cb e713          	ld	(19,x),a
1084                     ; 193     buf[20] = '\0';
1086  01cd 1e01          	ldw	x,(OFST+1,sp)
1087  01cf 6f14          	clr	(20,x)
1088                     ; 194 }
1091  01d1 85            	popw	x
1092  01d2 81            	ret
1284                     ; 196 uint8_t hal_di_read(uint8_t di_num)
1284                     ; 197 {
1285                     	switch	.text
1286  01d3               _hal_di_read:
1288  01d3 5203          	subw	sp,#3
1289       00000003      OFST:	set	3
1292                     ; 201     switch (di_num) {
1295                     ; 206         default: return 0;
1296  01d5 4a            	dec	a
1297  01d6 270c          	jreq	L314
1298  01d8 4a            	dec	a
1299  01d9 2714          	jreq	L514
1300  01db 4a            	dec	a
1301  01dc 271c          	jreq	L714
1302  01de 4a            	dec	a
1303  01df 2724          	jreq	L124
1304  01e1               L324:
1307  01e1 4f            	clr	a
1309  01e2 203d          	jra	L411
1310  01e4               L314:
1311                     ; 202         case 1: port = DI1_PORT; pin = DI1_PIN; break;
1313  01e4 ae500f        	ldw	x,#20495
1314  01e7 1f01          	ldw	(OFST-2,sp),x
1318  01e9 a604          	ld	a,#4
1319  01eb 6b03          	ld	(OFST+0,sp),a
1323  01ed 201f          	jra	L145
1324  01ef               L514:
1325                     ; 203         case 2: port = DI2_PORT; pin = DI2_PIN; break;
1327  01ef ae500f        	ldw	x,#20495
1328  01f2 1f01          	ldw	(OFST-2,sp),x
1332  01f4 a608          	ld	a,#8
1333  01f6 6b03          	ld	(OFST+0,sp),a
1337  01f8 2014          	jra	L145
1338  01fa               L714:
1339                     ; 204         case 3: port = DI3_PORT; pin = DI3_PIN; break;
1341  01fa ae500f        	ldw	x,#20495
1342  01fd 1f01          	ldw	(OFST-2,sp),x
1346  01ff a610          	ld	a,#16
1347  0201 6b03          	ld	(OFST+0,sp),a
1351  0203 2009          	jra	L145
1352  0205               L124:
1353                     ; 205         case 4: port = DI4_PORT; pin = DI4_PIN; break;
1355  0205 ae500f        	ldw	x,#20495
1356  0208 1f01          	ldw	(OFST-2,sp),x
1360  020a a680          	ld	a,#128
1361  020c 6b03          	ld	(OFST+0,sp),a
1365  020e               L145:
1366                     ; 208     return (GPIO_ReadInputPin(port, pin) == SET) ? 1 : 0;
1368  020e 7b03          	ld	a,(OFST+0,sp)
1369  0210 88            	push	a
1370  0211 1e02          	ldw	x,(OFST-1,sp)
1371  0213 cd0000        	call	_GPIO_ReadInputPin
1373  0216 5b01          	addw	sp,#1
1374  0218 a101          	cp	a,#1
1375  021a 2604          	jrne	L011
1376  021c a601          	ld	a,#1
1377  021e 2001          	jra	L211
1378  0220               L011:
1379  0220 4f            	clr	a
1380  0221               L211:
1382  0221               L411:
1384  0221 5b03          	addw	sp,#3
1385  0223 81            	ret
1458                     ; 211 char* u16_to_str(char *p, uint16_t value)
1458                     ; 212 {
1459                     	switch	.text
1460  0224               _u16_to_str:
1462  0224 89            	pushw	x
1463  0225 5209          	subw	sp,#9
1464       00000009      OFST:	set	9
1467                     ; 214     uint8_t i = 0;
1469  0227 0f09          	clr	(OFST+0,sp)
1471                     ; 217     if(value == 0)
1473  0229 1e0e          	ldw	x,(OFST+5,sp)
1474  022b 263d          	jrne	L506
1475                     ; 219         *p++ = '0';
1477  022d 1e0a          	ldw	x,(OFST+1,sp)
1478  022f 1c0001        	addw	x,#1
1479  0232 1f0a          	ldw	(OFST+1,sp),x
1480  0234 1d0001        	subw	x,#1
1481  0237 a630          	ld	a,#48
1482  0239 f7            	ld	(x),a
1483                     ; 220         return p;
1485  023a 1e0a          	ldw	x,(OFST+1,sp)
1487  023c 2058          	jra	L021
1488  023e               L306:
1489                     ; 225         temp[i++] = (value % 10) + '0';
1491  023e 1e0e          	ldw	x,(OFST+5,sp)
1492  0240 a60a          	ld	a,#10
1493  0242 62            	div	x,a
1494  0243 5f            	clrw	x
1495  0244 97            	ld	xl,a
1496  0245 1c0030        	addw	x,#48
1497  0248 9096          	ldw	y,sp
1498  024a 72a90003      	addw	y,#OFST-6
1499  024e 1701          	ldw	(OFST-8,sp),y
1501  0250 7b09          	ld	a,(OFST+0,sp)
1502  0252 9097          	ld	yl,a
1503  0254 0c09          	inc	(OFST+0,sp)
1505  0256 909f          	ld	a,yl
1506  0258 905f          	clrw	y
1507  025a 9097          	ld	yl,a
1508  025c 72f901        	addw	y,(OFST-8,sp)
1509  025f 01            	rrwa	x,a
1510  0260 90f7          	ld	(y),a
1511  0262 02            	rlwa	x,a
1512                     ; 226         value /= 10;
1514  0263 1e0e          	ldw	x,(OFST+5,sp)
1515  0265 a60a          	ld	a,#10
1516  0267 62            	div	x,a
1517  0268 1f0e          	ldw	(OFST+5,sp),x
1518  026a               L506:
1519                     ; 223     while(value)
1521  026a 1e0e          	ldw	x,(OFST+5,sp)
1522  026c 26d0          	jrne	L306
1523                     ; 229     for(j = i; j > 0; j--)
1525  026e 7b09          	ld	a,(OFST+0,sp)
1526  0270 6b09          	ld	(OFST+0,sp),a
1529  0272 201c          	jra	L516
1530  0274               L116:
1531                     ; 231         *p++ = temp[j - 1];
1533  0274 96            	ldw	x,sp
1534  0275 1c0003        	addw	x,#OFST-6
1535  0278 1f01          	ldw	(OFST-8,sp),x
1537  027a 7b09          	ld	a,(OFST+0,sp)
1538  027c 5f            	clrw	x
1539  027d 97            	ld	xl,a
1540  027e 5a            	decw	x
1541  027f 72fb01        	addw	x,(OFST-8,sp)
1542  0282 f6            	ld	a,(x)
1543  0283 1e0a          	ldw	x,(OFST+1,sp)
1544  0285 1c0001        	addw	x,#1
1545  0288 1f0a          	ldw	(OFST+1,sp),x
1546  028a 1d0001        	subw	x,#1
1547  028d f7            	ld	(x),a
1548                     ; 229     for(j = i; j > 0; j--)
1550  028e 0a09          	dec	(OFST+0,sp)
1552  0290               L516:
1555  0290 0d09          	tnz	(OFST+0,sp)
1556  0292 26e0          	jrne	L116
1557                     ; 234     return p;
1559  0294 1e0a          	ldw	x,(OFST+1,sp)
1561  0296               L021:
1563  0296 5b0b          	addw	sp,#11
1564  0298 81            	ret
1637                     .const:	section	.text
1638  0000               L421:
1639  0000 0000000a      	dc.l	10
1640                     ; 237 char* u32_to_str(char *p, uint32_t value)
1640                     ; 238 {
1641                     	switch	.text
1642  0299               _u32_to_str:
1644  0299 89            	pushw	x
1645  029a 520d          	subw	sp,#13
1646       0000000d      OFST:	set	13
1649                     ; 240     uint8_t i = 0;
1651  029c 0f0d          	clr	(OFST+0,sp)
1653                     ; 243     if(value == 0)
1655  029e 96            	ldw	x,sp
1656  029f 1c0012        	addw	x,#OFST+5
1657  02a2 cd0000        	call	c_lzmp
1659  02a5 264b          	jrne	L366
1660                     ; 245         *p++ = '0';
1662  02a7 1e0e          	ldw	x,(OFST+1,sp)
1663  02a9 1c0001        	addw	x,#1
1664  02ac 1f0e          	ldw	(OFST+1,sp),x
1665  02ae 1d0001        	subw	x,#1
1666  02b1 a630          	ld	a,#48
1667  02b3 f7            	ld	(x),a
1668                     ; 246         return p;
1670  02b4 1e0e          	ldw	x,(OFST+1,sp)
1672  02b6 206b          	jra	L621
1673  02b8               L166:
1674                     ; 251         temp[i++] = (value % 10) + '0';
1676  02b8 96            	ldw	x,sp
1677  02b9 1c0012        	addw	x,#OFST+5
1678  02bc cd0000        	call	c_ltor
1680  02bf ae0000        	ldw	x,#L421
1681  02c2 cd0000        	call	c_lumd
1683  02c5 a630          	ld	a,#48
1684  02c7 cd0000        	call	c_ladc
1686  02ca 96            	ldw	x,sp
1687  02cb 1c0003        	addw	x,#OFST-10
1688  02ce 1f01          	ldw	(OFST-12,sp),x
1690  02d0 7b0d          	ld	a,(OFST+0,sp)
1691  02d2 97            	ld	xl,a
1692  02d3 0c0d          	inc	(OFST+0,sp)
1694  02d5 9f            	ld	a,xl
1695  02d6 5f            	clrw	x
1696  02d7 97            	ld	xl,a
1697  02d8 72fb01        	addw	x,(OFST-12,sp)
1698  02db b603          	ld	a,c_lreg+3
1699  02dd f7            	ld	(x),a
1700                     ; 252         value /= 10;
1702  02de 96            	ldw	x,sp
1703  02df 1c0012        	addw	x,#OFST+5
1704  02e2 cd0000        	call	c_ltor
1706  02e5 ae0000        	ldw	x,#L421
1707  02e8 cd0000        	call	c_ludv
1709  02eb 96            	ldw	x,sp
1710  02ec 1c0012        	addw	x,#OFST+5
1711  02ef cd0000        	call	c_rtol
1713  02f2               L366:
1714                     ; 249     while(value)
1716  02f2 96            	ldw	x,sp
1717  02f3 1c0012        	addw	x,#OFST+5
1718  02f6 cd0000        	call	c_lzmp
1720  02f9 26bd          	jrne	L166
1721                     ; 255     for(j = i; j > 0; j--)
1723  02fb 7b0d          	ld	a,(OFST+0,sp)
1724  02fd 6b0d          	ld	(OFST+0,sp),a
1727  02ff 201c          	jra	L376
1728  0301               L766:
1729                     ; 257         *p++ = temp[j - 1];
1731  0301 96            	ldw	x,sp
1732  0302 1c0003        	addw	x,#OFST-10
1733  0305 1f01          	ldw	(OFST-12,sp),x
1735  0307 7b0d          	ld	a,(OFST+0,sp)
1736  0309 5f            	clrw	x
1737  030a 97            	ld	xl,a
1738  030b 5a            	decw	x
1739  030c 72fb01        	addw	x,(OFST-12,sp)
1740  030f f6            	ld	a,(x)
1741  0310 1e0e          	ldw	x,(OFST+1,sp)
1742  0312 1c0001        	addw	x,#1
1743  0315 1f0e          	ldw	(OFST+1,sp),x
1744  0317 1d0001        	subw	x,#1
1745  031a f7            	ld	(x),a
1746                     ; 255     for(j = i; j > 0; j--)
1748  031b 0a0d          	dec	(OFST+0,sp)
1750  031d               L376:
1753  031d 0d0d          	tnz	(OFST+0,sp)
1754  031f 26e0          	jrne	L766
1755                     ; 260     return p;
1757  0321 1e0e          	ldw	x,(OFST+1,sp)
1759  0323               L621:
1761  0323 5b0f          	addw	sp,#15
1762  0325 81            	ret
1846                     ; 263 void message_formatter_avcc(char *buf,
1846                     ; 264                             int buf_size,
1846                     ; 265                             uint16_t lanid,
1846                     ; 266                             uint32_t seqn,
1846                     ; 267                             uint16_t axle_count)
1846                     ; 268 {
1847                     	switch	.text
1848  0326               _message_formatter_avcc:
1850  0326 89            	pushw	x
1851  0327 89            	pushw	x
1852       00000002      OFST:	set	2
1855                     ; 271     if(buf == 0)
1857  0328 a30000        	cpw	x,#0
1858  032b 2708          	jreq	L231
1859                     ; 272         return;
1861                     ; 274     if(buf_size < 40)
1863  032d 9c            	rvf
1864  032e 1e07          	ldw	x,(OFST+5,sp)
1865  0330 a30028        	cpw	x,#40
1866  0333 2e03          	jrsge	L347
1867                     ; 275         return;
1868  0335               L231:
1871  0335 5b04          	addw	sp,#4
1872  0337 81            	ret
1873  0338               L347:
1874                     ; 277     p = buf;
1876  0338 1e03          	ldw	x,(OFST+1,sp)
1877  033a 1f01          	ldw	(OFST-1,sp),x
1879                     ; 280     *p++ = 'S';
1881  033c 1e01          	ldw	x,(OFST-1,sp)
1882  033e 1c0001        	addw	x,#1
1883  0341 1f01          	ldw	(OFST-1,sp),x
1884  0343 1d0001        	subw	x,#1
1886  0346 a653          	ld	a,#83
1887  0348 f7            	ld	(x),a
1888                     ; 281     *p++ = 'T';
1890  0349 1e01          	ldw	x,(OFST-1,sp)
1891  034b 1c0001        	addw	x,#1
1892  034e 1f01          	ldw	(OFST-1,sp),x
1893  0350 1d0001        	subw	x,#1
1895  0353 a654          	ld	a,#84
1896  0355 f7            	ld	(x),a
1897                     ; 282     *p++ = 'A';
1899  0356 1e01          	ldw	x,(OFST-1,sp)
1900  0358 1c0001        	addw	x,#1
1901  035b 1f01          	ldw	(OFST-1,sp),x
1902  035d 1d0001        	subw	x,#1
1904  0360 a641          	ld	a,#65
1905  0362 f7            	ld	(x),a
1906                     ; 283     *p++ = 'R';
1908  0363 1e01          	ldw	x,(OFST-1,sp)
1909  0365 1c0001        	addw	x,#1
1910  0368 1f01          	ldw	(OFST-1,sp),x
1911  036a 1d0001        	subw	x,#1
1913  036d a652          	ld	a,#82
1914  036f f7            	ld	(x),a
1915                     ; 284     *p++ = 'T';
1917  0370 1e01          	ldw	x,(OFST-1,sp)
1918  0372 1c0001        	addw	x,#1
1919  0375 1f01          	ldw	(OFST-1,sp),x
1920  0377 1d0001        	subw	x,#1
1922  037a a654          	ld	a,#84
1923  037c f7            	ld	(x),a
1924                     ; 285     *p++ = ',';
1926  037d 1e01          	ldw	x,(OFST-1,sp)
1927  037f 1c0001        	addw	x,#1
1928  0382 1f01          	ldw	(OFST-1,sp),x
1929  0384 1d0001        	subw	x,#1
1931  0387 a62c          	ld	a,#44
1932  0389 f7            	ld	(x),a
1933                     ; 286     *p++ = 'A';
1935  038a 1e01          	ldw	x,(OFST-1,sp)
1936  038c 1c0001        	addw	x,#1
1937  038f 1f01          	ldw	(OFST-1,sp),x
1938  0391 1d0001        	subw	x,#1
1940  0394 a641          	ld	a,#65
1941  0396 f7            	ld	(x),a
1942                     ; 287     *p++ = 'V';
1944  0397 1e01          	ldw	x,(OFST-1,sp)
1945  0399 1c0001        	addw	x,#1
1946  039c 1f01          	ldw	(OFST-1,sp),x
1947  039e 1d0001        	subw	x,#1
1949  03a1 a656          	ld	a,#86
1950  03a3 f7            	ld	(x),a
1951                     ; 288     *p++ = 'C';
1953  03a4 1e01          	ldw	x,(OFST-1,sp)
1954  03a6 1c0001        	addw	x,#1
1955  03a9 1f01          	ldw	(OFST-1,sp),x
1956  03ab 1d0001        	subw	x,#1
1958  03ae a643          	ld	a,#67
1959  03b0 f7            	ld	(x),a
1960                     ; 289     *p++ = 'C';
1962  03b1 1e01          	ldw	x,(OFST-1,sp)
1963  03b3 1c0001        	addw	x,#1
1964  03b6 1f01          	ldw	(OFST-1,sp),x
1965  03b8 1d0001        	subw	x,#1
1967  03bb a643          	ld	a,#67
1968  03bd f7            	ld	(x),a
1969                     ; 290     *p++ = ',';
1971  03be 1e01          	ldw	x,(OFST-1,sp)
1972  03c0 1c0001        	addw	x,#1
1973  03c3 1f01          	ldw	(OFST-1,sp),x
1974  03c5 1d0001        	subw	x,#1
1976  03c8 a62c          	ld	a,#44
1977  03ca f7            	ld	(x),a
1978                     ; 292     p = u16_to_str(p, lanid);
1980  03cb 1e09          	ldw	x,(OFST+7,sp)
1981  03cd 89            	pushw	x
1982  03ce 1e03          	ldw	x,(OFST+1,sp)
1983  03d0 cd0224        	call	_u16_to_str
1985  03d3 5b02          	addw	sp,#2
1986  03d5 1f01          	ldw	(OFST-1,sp),x
1988                     ; 294     *p++ = ',';
1990  03d7 1e01          	ldw	x,(OFST-1,sp)
1991  03d9 1c0001        	addw	x,#1
1992  03dc 1f01          	ldw	(OFST-1,sp),x
1993  03de 1d0001        	subw	x,#1
1995  03e1 a62c          	ld	a,#44
1996  03e3 f7            	ld	(x),a
1997                     ; 296     p = u32_to_str(p, seqn);
1999  03e4 1e0d          	ldw	x,(OFST+11,sp)
2000  03e6 89            	pushw	x
2001  03e7 1e0d          	ldw	x,(OFST+11,sp)
2002  03e9 89            	pushw	x
2003  03ea 1e05          	ldw	x,(OFST+3,sp)
2004  03ec cd0299        	call	_u32_to_str
2006  03ef 5b04          	addw	sp,#4
2007  03f1 1f01          	ldw	(OFST-1,sp),x
2009                     ; 298     *p++ = ',';
2011  03f3 1e01          	ldw	x,(OFST-1,sp)
2012  03f5 1c0001        	addw	x,#1
2013  03f8 1f01          	ldw	(OFST-1,sp),x
2014  03fa 1d0001        	subw	x,#1
2016  03fd a62c          	ld	a,#44
2017  03ff f7            	ld	(x),a
2018                     ; 299     *p++ = 'A';
2020  0400 1e01          	ldw	x,(OFST-1,sp)
2021  0402 1c0001        	addw	x,#1
2022  0405 1f01          	ldw	(OFST-1,sp),x
2023  0407 1d0001        	subw	x,#1
2025  040a a641          	ld	a,#65
2026  040c f7            	ld	(x),a
2027                     ; 300     *p++ = 'X';
2029  040d 1e01          	ldw	x,(OFST-1,sp)
2030  040f 1c0001        	addw	x,#1
2031  0412 1f01          	ldw	(OFST-1,sp),x
2032  0414 1d0001        	subw	x,#1
2034  0417 a658          	ld	a,#88
2035  0419 f7            	ld	(x),a
2036                     ; 301     *p++ = 'L';
2038  041a 1e01          	ldw	x,(OFST-1,sp)
2039  041c 1c0001        	addw	x,#1
2040  041f 1f01          	ldw	(OFST-1,sp),x
2041  0421 1d0001        	subw	x,#1
2043  0424 a64c          	ld	a,#76
2044  0426 f7            	ld	(x),a
2045                     ; 302     *p++ = 'E';
2047  0427 1e01          	ldw	x,(OFST-1,sp)
2048  0429 1c0001        	addw	x,#1
2049  042c 1f01          	ldw	(OFST-1,sp),x
2050  042e 1d0001        	subw	x,#1
2052  0431 a645          	ld	a,#69
2053  0433 f7            	ld	(x),a
2054                     ; 303     *p++ = ',';
2056  0434 1e01          	ldw	x,(OFST-1,sp)
2057  0436 1c0001        	addw	x,#1
2058  0439 1f01          	ldw	(OFST-1,sp),x
2059  043b 1d0001        	subw	x,#1
2061  043e a62c          	ld	a,#44
2062  0440 f7            	ld	(x),a
2063                     ; 305     p = u16_to_str(p, axle_count);
2065  0441 1e0f          	ldw	x,(OFST+13,sp)
2066  0443 89            	pushw	x
2067  0444 1e03          	ldw	x,(OFST+1,sp)
2068  0446 cd0224        	call	_u16_to_str
2070  0449 5b02          	addw	sp,#2
2071  044b 1f01          	ldw	(OFST-1,sp),x
2073                     ; 307     *p++ = ',';
2075  044d 1e01          	ldw	x,(OFST-1,sp)
2076  044f 1c0001        	addw	x,#1
2077  0452 1f01          	ldw	(OFST-1,sp),x
2078  0454 1d0001        	subw	x,#1
2080  0457 a62c          	ld	a,#44
2081  0459 f7            	ld	(x),a
2082                     ; 308     *p++ = 'E';
2084  045a 1e01          	ldw	x,(OFST-1,sp)
2085  045c 1c0001        	addw	x,#1
2086  045f 1f01          	ldw	(OFST-1,sp),x
2087  0461 1d0001        	subw	x,#1
2089  0464 a645          	ld	a,#69
2090  0466 f7            	ld	(x),a
2091                     ; 309     *p++ = 'N';
2093  0467 1e01          	ldw	x,(OFST-1,sp)
2094  0469 1c0001        	addw	x,#1
2095  046c 1f01          	ldw	(OFST-1,sp),x
2096  046e 1d0001        	subw	x,#1
2098  0471 a64e          	ld	a,#78
2099  0473 f7            	ld	(x),a
2100                     ; 310     *p++ = 'D';
2102  0474 1e01          	ldw	x,(OFST-1,sp)
2103  0476 1c0001        	addw	x,#1
2104  0479 1f01          	ldw	(OFST-1,sp),x
2105  047b 1d0001        	subw	x,#1
2107  047e a644          	ld	a,#68
2108  0480 f7            	ld	(x),a
2109                     ; 312     *p = '\0';
2111  0481 1e01          	ldw	x,(OFST-1,sp)
2112  0483 7f            	clr	(x)
2113                     ; 313 }
2115  0484 ac350335      	jpf	L231
2212                     ; 315 void hal_relay_set(uint8_t relay_num, uint8_t state){
2213                     	switch	.text
2214  0488               _hal_relay_set:
2216  0488 89            	pushw	x
2217  0489 5204          	subw	sp,#4
2218       00000004      OFST:	set	4
2221                     ; 318 	BitStatus bit_state = (state == 0) ? SET : RESET;
2223  048b 9f            	ld	a,xl
2224  048c 4d            	tnz	a
2225  048d 2605          	jrne	L631
2226  048f ae0001        	ldw	x,#1
2227  0492 2001          	jra	L041
2228  0494               L631:
2229  0494 5f            	clrw	x
2230  0495               L041:
2231  0495 01            	rrwa	x,a
2232  0496 6b01          	ld	(OFST-3,sp),a
2233  0498 02            	rlwa	x,a
2235                     ; 320 	switch (relay_num) {
2237  0499 7b05          	ld	a,(OFST+1,sp)
2239                     ; 327         default: return;
2240  049b 4a            	dec	a
2241  049c 2711          	jreq	L547
2242  049e 4a            	dec	a
2243  049f 2719          	jreq	L747
2244  04a1 4a            	dec	a
2245  04a2 2721          	jreq	L157
2246  04a4 4a            	dec	a
2247  04a5 2729          	jreq	L357
2248  04a7 4a            	dec	a
2249  04a8 2731          	jreq	L557
2250  04aa 4a            	dec	a
2251  04ab 2739          	jreq	L757
2252  04ad               L167:
2255  04ad 205a          	jra	L241
2256  04af               L547:
2257                     ; 321         case 1: port = RELAY1_PORT; pin = RELAY1_PIN; break;
2259  04af ae5005        	ldw	x,#20485
2260  04b2 1f02          	ldw	(OFST-2,sp),x
2264  04b4 a608          	ld	a,#8
2265  04b6 6b04          	ld	(OFST+0,sp),a
2269  04b8 2035          	jra	L5301
2270  04ba               L747:
2271                     ; 322         case 2: port = RELAY2_PORT; pin = RELAY2_PIN; break;
2273  04ba ae5005        	ldw	x,#20485
2274  04bd 1f02          	ldw	(OFST-2,sp),x
2278  04bf a604          	ld	a,#4
2279  04c1 6b04          	ld	(OFST+0,sp),a
2283  04c3 202a          	jra	L5301
2284  04c5               L157:
2285                     ; 323         case 3: port = RELAY3_PORT; pin = RELAY3_PIN; break;
2287  04c5 ae5005        	ldw	x,#20485
2288  04c8 1f02          	ldw	(OFST-2,sp),x
2292  04ca a602          	ld	a,#2
2293  04cc 6b04          	ld	(OFST+0,sp),a
2297  04ce 201f          	jra	L5301
2298  04d0               L357:
2299                     ; 324         case 4: port = RELAY4_PORT; pin = RELAY4_PIN; break;
2301  04d0 ae5005        	ldw	x,#20485
2302  04d3 1f02          	ldw	(OFST-2,sp),x
2306  04d5 a601          	ld	a,#1
2307  04d7 6b04          	ld	(OFST+0,sp),a
2311  04d9 2014          	jra	L5301
2312  04db               L557:
2313                     ; 325         case 5: port = RELAY5_PORT; pin = RELAY5_PIN; break;
2315  04db ae500a        	ldw	x,#20490
2316  04de 1f02          	ldw	(OFST-2,sp),x
2320  04e0 a608          	ld	a,#8
2321  04e2 6b04          	ld	(OFST+0,sp),a
2325  04e4 2009          	jra	L5301
2326  04e6               L757:
2327                     ; 326         case 6: port = RELAY6_PORT; pin = RELAY6_PIN; break;
2329  04e6 ae500a        	ldw	x,#20490
2330  04e9 1f02          	ldw	(OFST-2,sp),x
2334  04eb a610          	ld	a,#16
2335  04ed 6b04          	ld	(OFST+0,sp),a
2339  04ef               L5301:
2340                     ; 330 	if (bit_state == SET) {
2342  04ef 7b01          	ld	a,(OFST-3,sp)
2343  04f1 a101          	cp	a,#1
2344  04f3 260b          	jrne	L7301
2345                     ; 331         GPIO_WriteHigh(port, pin);  /* Set HIGH = relay off */
2347  04f5 7b04          	ld	a,(OFST+0,sp)
2348  04f7 88            	push	a
2349  04f8 1e03          	ldw	x,(OFST-1,sp)
2350  04fa cd0000        	call	_GPIO_WriteHigh
2352  04fd 84            	pop	a
2354  04fe 2009          	jra	L1401
2355  0500               L7301:
2356                     ; 333         GPIO_WriteLow(port, pin); /* Set LOW = relay on */
2358  0500 7b04          	ld	a,(OFST+0,sp)
2359  0502 88            	push	a
2360  0503 1e03          	ldw	x,(OFST-1,sp)
2361  0505 cd0000        	call	_GPIO_WriteLow
2363  0508 84            	pop	a
2364  0509               L1401:
2365                     ; 335 }
2366  0509               L241:
2369  0509 5b06          	addw	sp,#6
2370  050b 81            	ret
2414                     ; 337 void relay_control_set(uint8_t relay_num, uint8_t state)
2414                     ; 338 {
2415                     	switch	.text
2416  050c               _relay_control_set:
2418  050c 89            	pushw	x
2419       00000000      OFST:	set	0
2422                     ; 339     if (relay_num >= 1 && relay_num <= 6) {
2424  050d 9e            	ld	a,xh
2425  050e 4d            	tnz	a
2426  050f 270d          	jreq	L5601
2428  0511 9e            	ld	a,xh
2429  0512 a107          	cp	a,#7
2430  0514 2408          	jruge	L5601
2431                     ; 340         hal_relay_set(relay_num, state);
2433  0516 9f            	ld	a,xl
2434  0517 97            	ld	xl,a
2435  0518 7b01          	ld	a,(OFST+1,sp)
2436  051a 95            	ld	xh,a
2437  051b cd0488        	call	_hal_relay_set
2439  051e               L5601:
2440                     ; 342 }
2443  051e 85            	popw	x
2444  051f 81            	ret
2480                     ; 344 void relay_control_set_all(uint8_t state)
2480                     ; 345 {
2481                     	switch	.text
2482  0520               _relay_control_set_all:
2484  0520 88            	push	a
2485       00000000      OFST:	set	0
2488                     ; 346     relay_control_set(1, state);
2490  0521 ae0100        	ldw	x,#256
2491  0524 97            	ld	xl,a
2492  0525 ade5          	call	_relay_control_set
2494                     ; 347     relay_control_set(2, state);
2496  0527 7b01          	ld	a,(OFST+1,sp)
2497  0529 ae0200        	ldw	x,#512
2498  052c 97            	ld	xl,a
2499  052d addd          	call	_relay_control_set
2501                     ; 348     relay_control_set(3, state);
2503  052f 7b01          	ld	a,(OFST+1,sp)
2504  0531 ae0300        	ldw	x,#768
2505  0534 97            	ld	xl,a
2506  0535 add5          	call	_relay_control_set
2508                     ; 349     relay_control_set(4, state);
2510  0537 7b01          	ld	a,(OFST+1,sp)
2511  0539 ae0400        	ldw	x,#1024
2512  053c 97            	ld	xl,a
2513  053d adcd          	call	_relay_control_set
2515                     ; 350     relay_control_set(5, state);
2517  053f 7b01          	ld	a,(OFST+1,sp)
2518  0541 ae0500        	ldw	x,#1280
2519  0544 97            	ld	xl,a
2520  0545 adc5          	call	_relay_control_set
2522                     ; 351     relay_control_set(6, state);
2524  0547 7b01          	ld	a,(OFST+1,sp)
2525  0549 ae0600        	ldw	x,#1536
2526  054c 97            	ld	xl,a
2527  054d adbd          	call	_relay_control_set
2529                     ; 352 }
2532  054f 84            	pop	a
2533  0550 81            	ret
2559                     ; 354 void sensor_reader_update(void){
2560                     	switch	.text
2561  0551               _sensor_reader_update:
2565                     ; 355     current_state.di1 = hal_di_read(1);
2567  0551 a601          	ld	a,#1
2568  0553 cd01d3        	call	_hal_di_read
2570  0556 b717          	ld	L72_current_state,a
2571                     ; 356     current_state.di2 = hal_di_read(2);
2573  0558 a602          	ld	a,#2
2574  055a cd01d3        	call	_hal_di_read
2576  055d b718          	ld	L72_current_state+1,a
2577                     ; 357     current_state.di3 = hal_di_read(3);
2579  055f a603          	ld	a,#3
2580  0561 cd01d3        	call	_hal_di_read
2582  0564 b719          	ld	L72_current_state+2,a
2583                     ; 358     current_state.di4 = hal_di_read(4);
2585  0566 a604          	ld	a,#4
2586  0568 cd01d3        	call	_hal_di_read
2588  056b b71a          	ld	L72_current_state+3,a
2589                     ; 359 }
2592  056d 81            	ret
2616                     ; 362 void hal_timer_start(void)
2616                     ; 363 {
2617                     	switch	.text
2618  056e               _hal_timer_start:
2622                     ; 364     TIM4_Cmd(ENABLE);
2624  056e a601          	ld	a,#1
2625  0570 cd0000        	call	_TIM4_Cmd
2627                     ; 365 }
2630  0573 81            	ret
2691                     ; 370 void process_axle_counting(void){
2692                     	switch	.text
2693  0574               _process_axle_counting:
2695  0574 5232          	subw	sp,#50
2696       00000032      OFST:	set	50
2699                     ; 371     sensor_state_t sensor = sensor_reader_get_state();
2701  0576 96            	ldw	x,sp
2702  0577 1c002f        	addw	x,#OFST-3
2703  057a 89            	pushw	x
2704  057b cd011a        	call	_sensor_reader_get_state
2706  057e 85            	popw	x
2707                     ; 374     if(sensor.di1 == 1 && axle_counter.prev_di1_state == 0){
2709  057f 7b2f          	ld	a,(OFST-3,sp)
2710  0581 a101          	cp	a,#1
2711  0583 260a          	jrne	L3511
2713  0585 3d05          	tnz	L12_axle_counter+3
2714  0587 2606          	jrne	L3511
2715                     ; 375         axle_counter.loop_active = 1;
2717  0589 35010002      	mov	L12_axle_counter,#1
2718                     ; 376         axle_counter.axle_count = 0;
2720  058d 3f04          	clr	L12_axle_counter+2
2721  058f               L3511:
2722                     ; 379     if(axle_counter.loop_active){
2724  058f 3d02          	tnz	L12_axle_counter
2725  0591 2710          	jreq	L5511
2726                     ; 380         if(sensor.di2 == 1 && axle_counter.prev_di2_state == 0){
2728  0593 7b30          	ld	a,(OFST-2,sp)
2729  0595 a101          	cp	a,#1
2730  0597 2606          	jrne	L7511
2732  0599 3d03          	tnz	L12_axle_counter+1
2733  059b 2602          	jrne	L7511
2734                     ; 381             axle_counter.axle_count++;
2736  059d 3c04          	inc	L12_axle_counter+2
2737  059f               L7511:
2738                     ; 383         axle_counter.prev_di2_state = sensor.di2;
2740  059f 7b30          	ld	a,(OFST-2,sp)
2741  05a1 b703          	ld	L12_axle_counter+1,a
2742  05a3               L5511:
2743                     ; 387     if (sensor.di1 == 0 && axle_counter.prev_di1_state == 1 && axle_counter.loop_active){
2745  05a3 0d2f          	tnz	(OFST-3,sp)
2746  05a5 264f          	jrne	L1611
2748  05a7 b605          	ld	a,L12_axle_counter+3
2749  05a9 a101          	cp	a,#1
2750  05ab 2649          	jrne	L1611
2752  05ad 3d02          	tnz	L12_axle_counter
2753  05af 2745          	jreq	L1611
2754                     ; 388         uint16_t axle_final_count = axle_counter.axle_count / 2;
2756  05b1 b604          	ld	a,L12_axle_counter+2
2757  05b3 5f            	clrw	x
2758  05b4 97            	ld	xl,a
2759  05b5 57            	sraw	x
2760  05b6 1f05          	ldw	(OFST-45,sp),x
2762                     ; 391         message_formatter_avcc(msg_buf, sizeof(msg_buf),DEVICE_LANID,axle_counter.embedded_seq_num,axle_final_count);
2764  05b8 1e05          	ldw	x,(OFST-45,sp)
2765  05ba 89            	pushw	x
2766  05bb be08          	ldw	x,L12_axle_counter+6
2767  05bd 89            	pushw	x
2768  05be be06          	ldw	x,L12_axle_counter+4
2769  05c0 89            	pushw	x
2770  05c1 ae007d        	ldw	x,#125
2771  05c4 89            	pushw	x
2772  05c5 ae0028        	ldw	x,#40
2773  05c8 89            	pushw	x
2774  05c9 96            	ldw	x,sp
2775  05ca 1c0011        	addw	x,#OFST-33
2776  05cd cd0326        	call	_message_formatter_avcc
2778  05d0 5b0a          	addw	sp,#10
2779                     ; 393         if(uart_server_is_ready()){
2781  05d2 cd008d        	call	_uart_server_is_ready
2783  05d5 a30000        	cpw	x,#0
2784  05d8 2710          	jreq	L3611
2785                     ; 394             uart_server_send((uint8_t *)msg_buf, strlen(msg_buf));
2787  05da 96            	ldw	x,sp
2788  05db 1c0007        	addw	x,#OFST-43
2789  05de cd0000        	call	_strlen
2791  05e1 89            	pushw	x
2792  05e2 96            	ldw	x,sp
2793  05e3 1c0009        	addw	x,#OFST-41
2794  05e6 cd00e5        	call	_uart_server_send
2796  05e9 85            	popw	x
2797  05ea               L3611:
2798                     ; 397         axle_counter.embedded_seq_num++;
2800  05ea ae0006        	ldw	x,#L12_axle_counter+4
2801  05ed a601          	ld	a,#1
2802  05ef cd0000        	call	c_lgadc
2804                     ; 398         axle_counter.loop_active = 0;
2806  05f2 3f02          	clr	L12_axle_counter
2807                     ; 399         axle_counter.axle_count = 0;
2809  05f4 3f04          	clr	L12_axle_counter+2
2810  05f6               L1611:
2811                     ; 401     axle_counter.prev_di1_state = sensor.di1;
2813  05f6 7b2f          	ld	a,(OFST-3,sp)
2814  05f8 b705          	ld	L12_axle_counter+3,a
2815                     ; 402 }
2818  05fa 5b32          	addw	sp,#50
2819  05fc 81            	ret
2843                     ; 403 void sensor_reader_init(void)
2843                     ; 404 {
2844                     	switch	.text
2845  05fd               _sensor_reader_init:
2849                     ; 406     sensor_reader_update();
2851  05fd cd0551        	call	_sensor_reader_update
2853                     ; 407 }
2856  0600 81            	ret
2906                     ; 409 void send_alive_message(void)
2906                     ; 410 {
2907                     	switch	.text
2908  0601               _send_alive_message:
2910  0601 5228          	subw	sp,#40
2911       00000028      OFST:	set	40
2914                     ; 414     sensor = sensor_reader_get_state();
2916  0603 96            	ldw	x,sp
2917  0604 1c0025        	addw	x,#OFST-3
2918  0607 89            	pushw	x
2919  0608 cd011a        	call	_sensor_reader_get_state
2921  060b 85            	popw	x
2922                     ; 416     message_formatter_alive(
2922                     ; 417         msg_buf,
2922                     ; 418         sizeof(msg_buf),
2922                     ; 419         sensor.di1,
2922                     ; 420         sensor.di2,
2922                     ; 421         sensor.di3,
2922                     ; 422         sensor.di4
2922                     ; 423     );
2924  060c 7b28          	ld	a,(OFST+0,sp)
2925  060e 88            	push	a
2926  060f 7b28          	ld	a,(OFST+0,sp)
2927  0611 88            	push	a
2928  0612 7b28          	ld	a,(OFST+0,sp)
2929  0614 88            	push	a
2930  0615 7b28          	ld	a,(OFST+0,sp)
2931  0617 88            	push	a
2932  0618 ae0020        	ldw	x,#32
2933  061b 89            	pushw	x
2934  061c 96            	ldw	x,sp
2935  061d 1c000b        	addw	x,#OFST-29
2936  0620 cd0126        	call	_message_formatter_alive
2938  0623 5b06          	addw	sp,#6
2939                     ; 425     if (uart_server_is_ready())
2941  0625 cd008d        	call	_uart_server_is_ready
2943  0628 a30000        	cpw	x,#0
2944  062b 2710          	jreq	L7121
2945                     ; 427         uart_server_send((uint8_t *)msg_buf, strlen(msg_buf));
2947  062d 96            	ldw	x,sp
2948  062e 1c0005        	addw	x,#OFST-35
2949  0631 cd0000        	call	_strlen
2951  0634 89            	pushw	x
2952  0635 96            	ldw	x,sp
2953  0636 1c0007        	addw	x,#OFST-33
2954  0639 cd00e5        	call	_uart_server_send
2956  063c 85            	popw	x
2957  063d               L7121:
2958                     ; 429 }
2961  063d 5b28          	addw	sp,#40
2962  063f 81            	ret
2990                     	switch	.const
2991  0004               L461:
2992  0004 00000032      	dc.l	50
2993  0008               L661:
2994  0008 000001f4      	dc.l	500
2995                     ; 431 void timer_callback(void){
2996                     	switch	.text
2997  0640               _timer_callback:
3001                     ; 432     task_timer.current_time = hal_get_millis();
3003  0640 cd0000        	call	_hal_get_millis
3005  0643 ae0013        	ldw	x,#L52_task_timer+8
3006  0646 cd0000        	call	c_rtol
3008                     ; 433     if ((task_timer.current_time - task_timer.last_sensor_time) >= SENSOR_READ_INTERVAL){
3010  0649 ae0013        	ldw	x,#L52_task_timer+8
3011  064c cd0000        	call	c_ltor
3013  064f ae000f        	ldw	x,#L52_task_timer+4
3014  0652 cd0000        	call	c_lsub
3016  0655 ae0004        	ldw	x,#L461
3017  0658 cd0000        	call	c_lcmp
3019  065b 250e          	jrult	L1321
3020                     ; 434         sensor_reader_update();
3022  065d cd0551        	call	_sensor_reader_update
3024                     ; 435         process_axle_counting();
3026  0660 cd0574        	call	_process_axle_counting
3028                     ; 436         task_timer.last_sensor_time = task_timer.current_time;
3030  0663 be15          	ldw	x,L52_task_timer+10
3031  0665 bf11          	ldw	L52_task_timer+6,x
3032  0667 be13          	ldw	x,L52_task_timer+8
3033  0669 bf0f          	ldw	L52_task_timer+4,x
3034  066b               L1321:
3035                     ; 439     if ((task_timer.current_time - task_timer.last_alive_time) >= ALIVE_INTERVAL){
3037  066b ae0013        	ldw	x,#L52_task_timer+8
3038  066e cd0000        	call	c_ltor
3040  0671 ae000b        	ldw	x,#L52_task_timer
3041  0674 cd0000        	call	c_lsub
3043  0677 ae0008        	ldw	x,#L661
3044  067a cd0000        	call	c_lcmp
3046  067d 250a          	jrult	L3321
3047                     ; 440         send_alive_message();  
3049  067f ad80          	call	_send_alive_message
3051                     ; 441         task_timer.last_alive_time = task_timer.current_time;
3053  0681 be15          	ldw	x,L52_task_timer+10
3054  0683 bf0d          	ldw	L52_task_timer+2,x
3055  0685 be13          	ldw	x,L52_task_timer+8
3056  0687 bf0b          	ldw	L52_task_timer,x
3057  0689               L3321:
3058                     ; 443 }
3061  0689 81            	ret
3099                     ; 445 void hal_timer_set_callback(timer_callback_t callback)
3099                     ; 446 {
3100                     	switch	.text
3101  068a               _hal_timer_set_callback:
3105                     ; 447     user_callback = callback;
3107  068a bf29          	ldw	_user_callback,x
3108                     ; 448 }
3111  068c 81            	ret
3175                     ; 450 int command_parser_execute(const char *cmd_str, int len)
3175                     ; 451 {
3176                     	switch	.text
3177  068d               _command_parser_execute:
3179  068d 89            	pushw	x
3180  068e 89            	pushw	x
3181       00000002      OFST:	set	2
3184                     ; 456     if (len < 4)
3186  068f 9c            	rvf
3187  0690 1e07          	ldw	x,(OFST+5,sp)
3188  0692 a30004        	cpw	x,#4
3189  0695 2e05          	jrsge	L5031
3190                     ; 457         return -1;
3192  0697 aeffff        	ldw	x,#65535
3194  069a 200a          	jra	L471
3195  069c               L5031:
3196                     ; 459     if (cmd_str[0] != 'R')
3198  069c 1e03          	ldw	x,(OFST+1,sp)
3199  069e f6            	ld	a,(x)
3200  069f a152          	cp	a,#82
3201  06a1 2706          	jreq	L7031
3202                     ; 460         return -1;
3204  06a3 aeffff        	ldw	x,#65535
3206  06a6               L471:
3208  06a6 5b04          	addw	sp,#4
3209  06a8 81            	ret
3210  06a9               L7031:
3211                     ; 462     if (cmd_str[1] < '1' || cmd_str[1] > '6')
3213  06a9 1e03          	ldw	x,(OFST+1,sp)
3214  06ab e601          	ld	a,(1,x)
3215  06ad a131          	cp	a,#49
3216  06af 2508          	jrult	L3131
3218  06b1 1e03          	ldw	x,(OFST+1,sp)
3219  06b3 e601          	ld	a,(1,x)
3220  06b5 a137          	cp	a,#55
3221  06b7 2505          	jrult	L1131
3222  06b9               L3131:
3223                     ; 463         return -1;
3225  06b9 aeffff        	ldw	x,#65535
3227  06bc 20e8          	jra	L471
3228  06be               L1131:
3229                     ; 465     if (cmd_str[2] != ',')
3231  06be 1e03          	ldw	x,(OFST+1,sp)
3232  06c0 e602          	ld	a,(2,x)
3233  06c2 a12c          	cp	a,#44
3234  06c4 2705          	jreq	L5131
3235                     ; 466         return -1;
3237  06c6 aeffff        	ldw	x,#65535
3239  06c9 20db          	jra	L471
3240  06cb               L5131:
3241                     ; 468     if (cmd_str[3] != '0' && cmd_str[3] != '1')
3243  06cb 1e03          	ldw	x,(OFST+1,sp)
3244  06cd e603          	ld	a,(3,x)
3245  06cf a130          	cp	a,#48
3246  06d1 270d          	jreq	L7131
3248  06d3 1e03          	ldw	x,(OFST+1,sp)
3249  06d5 e603          	ld	a,(3,x)
3250  06d7 a131          	cp	a,#49
3251  06d9 2705          	jreq	L7131
3252                     ; 469         return -1;
3254  06db aeffff        	ldw	x,#65535
3256  06de 20c6          	jra	L471
3257  06e0               L7131:
3258                     ; 471     relay_num = cmd_str[1] - '0';
3260  06e0 1e03          	ldw	x,(OFST+1,sp)
3261  06e2 e601          	ld	a,(1,x)
3262  06e4 a030          	sub	a,#48
3263  06e6 6b01          	ld	(OFST-1,sp),a
3265                     ; 472     relay_state = cmd_str[3] - '0';
3267  06e8 1e03          	ldw	x,(OFST+1,sp)
3268  06ea e603          	ld	a,(3,x)
3269  06ec a030          	sub	a,#48
3270  06ee 6b02          	ld	(OFST+0,sp),a
3272                     ; 474     relay_control_set(relay_num, relay_state);
3274  06f0 7b02          	ld	a,(OFST+0,sp)
3275  06f2 97            	ld	xl,a
3276  06f3 7b01          	ld	a,(OFST-1,sp)
3277  06f5 95            	ld	xh,a
3278  06f6 cd050c        	call	_relay_control_set
3280                     ; 476     return 0;
3282  06f9 5f            	clrw	x
3284  06fa 20aa          	jra	L471
3308                     ; 479 void relay_control_init(void)
3308                     ; 480 {
3309                     	switch	.text
3310  06fc               _relay_control_init:
3314                     ; 481     relay_control_set_all(1);  /* 1 = on for active-low relays */
3316  06fc a601          	ld	a,#1
3317  06fe cd0520        	call	_relay_control_set_all
3319                     ; 482 }
3322  0701 81            	ret
3347                     ; 484 void hal_w5500_reset_high(void)
3347                     ; 485 {
3348                     	switch	.text
3349  0702               _hal_w5500_reset_high:
3353                     ; 486     GPIO_WriteHigh(W5500_RST_PORT, W5500_RST_PIN);
3355  0702 4b20          	push	#32
3356  0704 ae5014        	ldw	x,#20500
3357  0707 cd0000        	call	_GPIO_WriteHigh
3359  070a 84            	pop	a
3360                     ; 487 }
3363  070b 81            	ret
3389                     ; 489 void hal_gpio_init(void){
3390                     	switch	.text
3391  070c               _hal_gpio_init:
3395                     ; 491     GPIO_Init(DI1_PORT, DI1_PIN, GPIO_MODE_IN_PU_NO_IT);
3397  070c 4b40          	push	#64
3398  070e 4b04          	push	#4
3399  0710 ae500f        	ldw	x,#20495
3400  0713 cd0000        	call	_GPIO_Init
3402  0716 85            	popw	x
3403                     ; 492     GPIO_Init(DI2_PORT, DI2_PIN, GPIO_MODE_IN_PU_NO_IT);
3405  0717 4b40          	push	#64
3406  0719 4b08          	push	#8
3407  071b ae500f        	ldw	x,#20495
3408  071e cd0000        	call	_GPIO_Init
3410  0721 85            	popw	x
3411                     ; 493     GPIO_Init(DI3_PORT, DI3_PIN, GPIO_MODE_IN_PU_NO_IT);
3413  0722 4b40          	push	#64
3414  0724 4b10          	push	#16
3415  0726 ae500f        	ldw	x,#20495
3416  0729 cd0000        	call	_GPIO_Init
3418  072c 85            	popw	x
3419                     ; 494     GPIO_Init(DI4_PORT, DI4_PIN, GPIO_MODE_IN_PU_NO_IT);
3421  072d 4b40          	push	#64
3422  072f 4b80          	push	#128
3423  0731 ae500f        	ldw	x,#20495
3424  0734 cd0000        	call	_GPIO_Init
3426  0737 85            	popw	x
3427                     ; 497     GPIO_Init(RELAY1_PORT, RELAY1_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
3429  0738 4bf0          	push	#240
3430  073a 4b08          	push	#8
3431  073c ae5005        	ldw	x,#20485
3432  073f cd0000        	call	_GPIO_Init
3434  0742 85            	popw	x
3435                     ; 498     GPIO_Init(RELAY2_PORT, RELAY2_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
3437  0743 4bf0          	push	#240
3438  0745 4b04          	push	#4
3439  0747 ae5005        	ldw	x,#20485
3440  074a cd0000        	call	_GPIO_Init
3442  074d 85            	popw	x
3443                     ; 499     GPIO_Init(RELAY3_PORT, RELAY3_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
3445  074e 4bf0          	push	#240
3446  0750 4b02          	push	#2
3447  0752 ae5005        	ldw	x,#20485
3448  0755 cd0000        	call	_GPIO_Init
3450  0758 85            	popw	x
3451                     ; 500     GPIO_Init(RELAY4_PORT, RELAY4_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
3453  0759 4bf0          	push	#240
3454  075b 4b01          	push	#1
3455  075d ae5005        	ldw	x,#20485
3456  0760 cd0000        	call	_GPIO_Init
3458  0763 85            	popw	x
3459                     ; 501     GPIO_Init(RELAY5_PORT, RELAY5_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
3461  0764 4bf0          	push	#240
3462  0766 4b08          	push	#8
3463  0768 ae500a        	ldw	x,#20490
3464  076b cd0000        	call	_GPIO_Init
3466  076e 85            	popw	x
3467                     ; 502     GPIO_Init(RELAY6_PORT, RELAY6_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
3469  076f 4bf0          	push	#240
3470  0771 4b10          	push	#16
3471  0773 ae500a        	ldw	x,#20490
3472  0776 cd0000        	call	_GPIO_Init
3474  0779 85            	popw	x
3475                     ; 505     hal_relay_set(1, 1);
3477  077a ae0101        	ldw	x,#257
3478  077d cd0488        	call	_hal_relay_set
3480                     ; 506     hal_relay_set(2, 1);
3482  0780 ae0201        	ldw	x,#513
3483  0783 cd0488        	call	_hal_relay_set
3485                     ; 507     hal_relay_set(3, 1);
3487  0786 ae0301        	ldw	x,#769
3488  0789 cd0488        	call	_hal_relay_set
3490                     ; 508     hal_relay_set(4, 1);
3492  078c ae0401        	ldw	x,#1025
3493  078f cd0488        	call	_hal_relay_set
3495                     ; 509     hal_relay_set(5, 1);
3497  0792 ae0501        	ldw	x,#1281
3498  0795 cd0488        	call	_hal_relay_set
3500                     ; 510     hal_relay_set(6, 1);
3502  0798 ae0601        	ldw	x,#1537
3503  079b cd0488        	call	_hal_relay_set
3505                     ; 513     GPIO_Init(HARDRST_PORT, HARDRST_PIN, GPIO_MODE_IN_PU_NO_IT);
3507  079e 4b40          	push	#64
3508  07a0 4b80          	push	#128
3509  07a2 ae5005        	ldw	x,#20485
3510  07a5 cd0000        	call	_GPIO_Init
3512  07a8 85            	popw	x
3513                     ; 516     GPIO_Init(W5500_RST_PORT, W5500_RST_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
3515  07a9 4bf0          	push	#240
3516  07ab 4b20          	push	#32
3517  07ad ae5014        	ldw	x,#20500
3518  07b0 cd0000        	call	_GPIO_Init
3520  07b3 85            	popw	x
3521                     ; 517 	hal_w5500_reset_high();
3523  07b4 cd0702        	call	_hal_w5500_reset_high
3525                     ; 518 }
3528  07b7 81            	ret
3552                     ; 520 uint16_t hal_uart_available(void){
3553                     	switch	.text
3554  07b8               _hal_uart_available:
3558                     ; 521 	return uart_rx_count;
3560  07b8 be1f          	ldw	x,_uart_rx_count
3563  07ba 81            	ret
3602                     ; 524 uint8_t hal_uart_read_byte(void){
3603                     	switch	.text
3604  07bb               _hal_uart_read_byte:
3606  07bb 88            	push	a
3607       00000001      OFST:	set	1
3610                     ; 525 	uint8_t byte = 0;
3612  07bc 0f01          	clr	(OFST+0,sp)
3614                     ; 526 	if (uart_rx_count > 0){
3616  07be be1f          	ldw	x,_uart_rx_count
3617  07c0 271b          	jreq	L7731
3618                     ; 527 		disableInterrupts();
3621  07c2 9b            sim
3623                     ; 529 		byte = uart_rx_buffer[uart_rx_tail];
3626  07c3 be23          	ldw	x,_uart_rx_tail
3627  07c5 e600          	ld	a,(_uart_rx_buffer,x)
3628  07c7 6b01          	ld	(OFST+0,sp),a
3630                     ; 530 		uart_rx_tail = (uart_rx_tail + 1) % UART_RX_BUFFER_SIZE;
3632  07c9 be23          	ldw	x,_uart_rx_tail
3633  07cb 5c            	incw	x
3634  07cc 01            	rrwa	x,a
3635  07cd a41f          	and	a,#31
3636  07cf 5f            	clrw	x
3637  07d0 b724          	ld	_uart_rx_tail+1,a
3638  07d2 9f            	ld	a,xl
3639  07d3 b723          	ld	_uart_rx_tail,a
3640                     ; 531 		uart_rx_count--;
3642  07d5 be1f          	ldw	x,_uart_rx_count
3643  07d7 1d0001        	subw	x,#1
3644  07da bf1f          	ldw	_uart_rx_count,x
3645                     ; 532 		enableInterrupts();
3648  07dc 9a            rim
3651  07dd               L7731:
3652                     ; 534 	return byte;
3654  07dd 7b01          	ld	a,(OFST+0,sp)
3657  07df 5b01          	addw	sp,#1
3658  07e1 81            	ret
3732                     ; 537 void uart_server_process(void){
3733                     	switch	.text
3734  07e2               _uart_server_process:
3736  07e2 522b          	subw	sp,#43
3737       0000002b      OFST:	set	43
3740                     ; 543 	if (uart_state == UART_STATE_IDLE){
3742  07e4 3d1b          	tnz	L13_uart_state
3743  07e6 2603          	jrne	L412
3744  07e8 cc08a3        	jp	L212
3745  07eb               L412:
3746                     ; 544 		return;
3748                     ; 546 	available_len = hal_uart_available();
3750  07eb adcb          	call	_hal_uart_available
3752  07ed 1f05          	ldw	(OFST-38,sp),x
3754                     ; 548 	if(available_len > 0){
3756  07ef 1e05          	ldw	x,(OFST-38,sp)
3757  07f1 2603          	jrne	L612
3758  07f3 cc089f        	jp	L5341
3759  07f6               L612:
3760                     ; 549 		uart_state = UART_STATE_RX_PENDING;
3762  07f6 3502001b      	mov	L13_uart_state,#2
3764  07fa ac8b088b      	jpf	L3441
3765  07fe               L7341:
3766                     ; 552 			read_byte = hal_uart_read_byte();
3768  07fe adbb          	call	_hal_uart_read_byte
3770  0800 6b2b          	ld	(OFST+0,sp),a
3772                     ; 554 			if (read_byte == '\n' || read_byte == '\r'){
3774  0802 7b2b          	ld	a,(OFST+0,sp)
3775  0804 a10a          	cp	a,#10
3776  0806 2706          	jreq	L1541
3778  0808 7b2b          	ld	a,(OFST+0,sp)
3779  080a a10d          	cp	a,#13
3780  080c 265c          	jrne	L7441
3781  080e               L1541:
3782                     ; 555 				if(uart_rx_count > 0){
3784  080e be1f          	ldw	x,_uart_rx_count
3785  0810 2772          	jreq	L3641
3786                     ; 556 					uart_rx_buffer[uart_rx_count] = '\0';
3788  0812 be1f          	ldw	x,_uart_rx_count
3789  0814 6f00          	clr	(_uart_rx_buffer,x)
3790                     ; 557 					if (command_parser_execute((const char *)uart_rx_buffer,uart_rx_count) == 0){
3792  0816 be1f          	ldw	x,_uart_rx_count
3793  0818 89            	pushw	x
3794  0819 ae0000        	ldw	x,#_uart_rx_buffer
3795  081c cd068d        	call	_command_parser_execute
3797  081f 5b02          	addw	sp,#2
3798  0821 a30000        	cpw	x,#0
3799  0824 2634          	jrne	L5541
3800                     ; 558 						state = sensor_reader_get_state();
3802  0826 96            	ldw	x,sp
3803  0827 1c0027        	addw	x,#OFST-4
3804  082a 89            	pushw	x
3805  082b cd011a        	call	_sensor_reader_get_state
3807  082e 85            	popw	x
3808                     ; 559 						message_formatter_alive(resp_buf, sizeof(resp_buf),state.di1,state.di2,state.di3,state.di4);
3810  082f 7b2a          	ld	a,(OFST-1,sp)
3811  0831 88            	push	a
3812  0832 7b2a          	ld	a,(OFST-1,sp)
3813  0834 88            	push	a
3814  0835 7b2a          	ld	a,(OFST-1,sp)
3815  0837 88            	push	a
3816  0838 7b2a          	ld	a,(OFST-1,sp)
3817  083a 88            	push	a
3818  083b ae0020        	ldw	x,#32
3819  083e 89            	pushw	x
3820  083f 96            	ldw	x,sp
3821  0840 1c000d        	addw	x,#OFST-30
3822  0843 cd0126        	call	_message_formatter_alive
3824  0846 5b06          	addw	sp,#6
3825                     ; 560 					 	uart_server_send((uint8_t *)resp_buf,strlen(resp_buf));
3827  0848 96            	ldw	x,sp
3828  0849 1c0007        	addw	x,#OFST-36
3829  084c cd0000        	call	_strlen
3831  084f 89            	pushw	x
3832  0850 96            	ldw	x,sp
3833  0851 1c0009        	addw	x,#OFST-34
3834  0854 cd00e5        	call	_uart_server_send
3836  0857 85            	popw	x
3838  0858 200b          	jra	L7541
3839  085a               L5541:
3840                     ; 563                         uart_server_send((uint8_t *)"ERROR,INVALID_COMMAND\n",strlen("ERROR,INVALID_COMMAND\n"));
3842  085a ae0016        	ldw	x,#22
3843  085d 89            	pushw	x
3844  085e ae0017        	ldw	x,#L1641
3845  0861 cd00e5        	call	_uart_server_send
3847  0864 85            	popw	x
3848  0865               L7541:
3849                     ; 565                     uart_rx_count = 0;
3851  0865 5f            	clrw	x
3852  0866 bf1f          	ldw	_uart_rx_count,x
3853  0868 201a          	jra	L3641
3854  086a               L7441:
3855                     ; 568             else if (read_byte >= 32 && read_byte < 127){
3857  086a 7b2b          	ld	a,(OFST+0,sp)
3858  086c a120          	cp	a,#32
3859  086e 2514          	jrult	L3641
3861  0870 7b2b          	ld	a,(OFST+0,sp)
3862  0872 a17f          	cp	a,#127
3863  0874 240e          	jruge	L3641
3864                     ; 569                 uart_rx_buffer[uart_rx_count++] = read_byte;
3866  0876 7b2b          	ld	a,(OFST+0,sp)
3867  0878 be1f          	ldw	x,_uart_rx_count
3868  087a 1c0001        	addw	x,#1
3869  087d bf1f          	ldw	_uart_rx_count,x
3870  087f 1d0001        	subw	x,#1
3871  0882 e700          	ld	(_uart_rx_buffer,x),a
3872  0884               L3641:
3873                     ; 571             available_len--;
3875  0884 1e05          	ldw	x,(OFST-38,sp)
3876  0886 1d0001        	subw	x,#1
3877  0889 1f05          	ldw	(OFST-38,sp),x
3879  088b               L3441:
3880                     ; 551 		while (available_len > 0 && uart_rx_count < sizeof(uart_rx_buffer) - 1){
3882  088b 1e05          	ldw	x,(OFST-38,sp)
3883  088d 270a          	jreq	L7641
3885  088f be1f          	ldw	x,_uart_rx_count
3886  0891 a3001f        	cpw	x,#31
3887  0894 2403          	jruge	L022
3888  0896 cc07fe        	jp	L7341
3889  0899               L022:
3890  0899               L7641:
3891                     ; 573         uart_state = UART_STATE_READY;
3893  0899 3501001b      	mov	L13_uart_state,#1
3895  089d 2004          	jra	L1741
3896  089f               L5341:
3897                     ; 576         uart_state = UART_STATE_READY;
3899  089f 3501001b      	mov	L13_uart_state,#1
3900  08a3               L1741:
3901                     ; 578 }
3902  08a3               L212:
3905  08a3 5b2b          	addw	sp,#43
3906  08a5 81            	ret
3943                     ; 579 uint8_t hal_spi_byte(uint8_t data)
3943                     ; 580 {
3944                     	switch	.text
3945  08a6               _hal_spi_byte:
3947  08a6 88            	push	a
3948       00000000      OFST:	set	0
3951  08a7               L3151:
3952                     ; 581     while (SPI_GetFlagStatus(SPI_FLAG_TXE) == RESET);
3954  08a7 a602          	ld	a,#2
3955  08a9 cd0000        	call	_SPI_GetFlagStatus
3957  08ac 4d            	tnz	a
3958  08ad 27f8          	jreq	L3151
3959                     ; 583     SPI_SendData(data);
3961  08af 7b01          	ld	a,(OFST+1,sp)
3962  08b1 cd0000        	call	_SPI_SendData
3965  08b4               L1251:
3966                     ; 585     while (SPI_GetFlagStatus(SPI_FLAG_RXNE) == RESET);
3968  08b4 a601          	ld	a,#1
3969  08b6 cd0000        	call	_SPI_GetFlagStatus
3971  08b9 4d            	tnz	a
3972  08ba 27f8          	jreq	L1251
3973                     ; 587     return SPI_ReceiveData();
3975  08bc cd0000        	call	_SPI_ReceiveData
3979  08bf 5b01          	addw	sp,#1
3980  08c1 81            	ret
4004                     ; 589 uint8_t hal_spi_read_byte(void)
4004                     ; 590 {
4005                     	switch	.text
4006  08c2               _hal_spi_read_byte:
4010                     ; 591     return hal_spi_byte(0xFF);
4012  08c2 a6ff          	ld	a,#255
4013  08c4 ade0          	call	_hal_spi_byte
4017  08c6 81            	ret
4052                     ; 593 void hal_spi_write_byte(uint8_t data)
4052                     ; 594 {
4053                     	switch	.text
4054  08c7               _hal_spi_write_byte:
4058                     ; 595     hal_spi_byte(data);
4060  08c7 addd          	call	_hal_spi_byte
4062                     ; 596 }
4065  08c9 81            	ret
4119                     ; 597 void hal_spi_read(uint8_t *buf, uint16_t len){
4120                     	switch	.text
4121  08ca               _hal_spi_read:
4123  08ca 89            	pushw	x
4124  08cb 89            	pushw	x
4125       00000002      OFST:	set	2
4128                     ; 599     for(i = 0; i < len; i++){
4130  08cc 5f            	clrw	x
4131  08cd 1f01          	ldw	(OFST-1,sp),x
4134  08cf 2011          	jra	L5061
4135  08d1               L1061:
4136                     ; 600         buf[i] = hal_spi_byte(0xFF);
4138  08d1 a6ff          	ld	a,#255
4139  08d3 add1          	call	_hal_spi_byte
4141  08d5 1e03          	ldw	x,(OFST+1,sp)
4142  08d7 72fb01        	addw	x,(OFST-1,sp)
4143  08da f7            	ld	(x),a
4144                     ; 599     for(i = 0; i < len; i++){
4146  08db 1e01          	ldw	x,(OFST-1,sp)
4147  08dd 1c0001        	addw	x,#1
4148  08e0 1f01          	ldw	(OFST-1,sp),x
4150  08e2               L5061:
4153  08e2 1e01          	ldw	x,(OFST-1,sp)
4154  08e4 1307          	cpw	x,(OFST+5,sp)
4155  08e6 25e9          	jrult	L1061
4156                     ; 602 }
4159  08e8 5b04          	addw	sp,#4
4160  08ea 81            	ret
4214                     ; 604 void hal_spi_write(uint8_t *buf, uint16_t len){
4215                     	switch	.text
4216  08eb               _hal_spi_write:
4218  08eb 89            	pushw	x
4219  08ec 89            	pushw	x
4220       00000002      OFST:	set	2
4223                     ; 606     for(i = 0; i < len; i++){
4225  08ed 5f            	clrw	x
4226  08ee 1f01          	ldw	(OFST-1,sp),x
4229  08f0 200f          	jra	L3461
4230  08f2               L7361:
4231                     ; 607         hal_spi_byte(buf[i]);
4233  08f2 1e03          	ldw	x,(OFST+1,sp)
4234  08f4 72fb01        	addw	x,(OFST-1,sp)
4235  08f7 f6            	ld	a,(x)
4236  08f8 adac          	call	_hal_spi_byte
4238                     ; 606     for(i = 0; i < len; i++){
4240  08fa 1e01          	ldw	x,(OFST-1,sp)
4241  08fc 1c0001        	addw	x,#1
4242  08ff 1f01          	ldw	(OFST-1,sp),x
4244  0901               L3461:
4247  0901 1e01          	ldw	x,(OFST-1,sp)
4248  0903 1307          	cpw	x,(OFST+5,sp)
4249  0905 25eb          	jrult	L7361
4250                     ; 609 }
4253  0907 5b04          	addw	sp,#4
4254  0909 81            	ret
4296                     ; 611 void uart_server_init(uint32_t baudrate){
4297                     	switch	.text
4298  090a               _uart_server_init:
4300       00000000      OFST:	set	0
4303                     ; 612 	uart_state = UART_STATE_IDLE;
4305  090a 3f1b          	clr	L13_uart_state
4306                     ; 613 	uart_rx_count = 0;
4308  090c 5f            	clrw	x
4309  090d bf1f          	ldw	_uart_rx_count,x
4310                     ; 614 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_UART1, ENABLE);
4312  090f ae0301        	ldw	x,#769
4313  0912 cd0000        	call	_CLK_PeripheralClockConfig
4315                     ; 615     UART1_Init(
4315                     ; 616     baudrate,
4315                     ; 617     UART1_WORDLENGTH_8D,
4315                     ; 618     UART1_STOPBITS_1,
4315                     ; 619     UART1_PARITY_NO,
4315                     ; 620     UART1_SYNCMODE_CLOCK_DISABLE,
4315                     ; 621     (UART1_Mode_TypeDef)(UART1_MODE_TX_ENABLE | UART1_MODE_RX_ENABLE)
4315                     ; 622 );
4317  0915 4b0c          	push	#12
4318  0917 4b80          	push	#128
4319  0919 4b00          	push	#0
4320  091b 4b00          	push	#0
4321  091d 4b00          	push	#0
4322  091f 1e0a          	ldw	x,(OFST+10,sp)
4323  0921 89            	pushw	x
4324  0922 1e0a          	ldw	x,(OFST+10,sp)
4325  0924 89            	pushw	x
4326  0925 cd0000        	call	_UART1_Init
4328  0928 5b09          	addw	sp,#9
4329                     ; 624     UART1_ITConfig(UART1_IT_RXNE, ENABLE);
4331  092a 4b01          	push	#1
4332  092c ae0255        	ldw	x,#597
4333  092f cd0000        	call	_UART1_ITConfig
4335  0932 84            	pop	a
4336                     ; 627     UART1_Cmd(ENABLE);
4338  0933 a601          	ld	a,#1
4339  0935 cd0000        	call	_UART1_Cmd
4341                     ; 629     uart_rx_head = 0;
4343  0938 5f            	clrw	x
4344  0939 bf21          	ldw	_uart_rx_head,x
4345                     ; 630     uart_rx_tail = 0;
4347  093b 5f            	clrw	x
4348  093c bf23          	ldw	_uart_rx_tail,x
4349                     ; 631     uart_rx_count = 0;  
4351  093e 5f            	clrw	x
4352  093f bf1f          	ldw	_uart_rx_count,x
4353                     ; 632 	uart_state = UART_STATE_READY;
4355  0941 3501001b      	mov	L13_uart_state,#1
4356                     ; 633 }
4359  0945 81            	ret
4387                     ; 635 void hal_timer_init(void){
4388                     	switch	.text
4389  0946               _hal_timer_init:
4393                     ; 636     CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER4, ENABLE);
4395  0946 ae0401        	ldw	x,#1025
4396  0949 cd0000        	call	_CLK_PeripheralClockConfig
4398                     ; 637     TIM4_TimeBaseInit(TIM4_PRESCALER_128, 125);
4400  094c ae077d        	ldw	x,#1917
4401  094f cd0000        	call	_TIM4_TimeBaseInit
4403                     ; 638     TIM4_ClearFlag(TIM4_FLAG_UPDATE);
4405  0952 a601          	ld	a,#1
4406  0954 cd0000        	call	_TIM4_ClearFlag
4408                     ; 640     TIM4_ITConfig(TIM4_IT_UPDATE, ENABLE);
4410  0957 ae0101        	ldw	x,#257
4411  095a cd0000        	call	_TIM4_ITConfig
4413                     ; 642     enableInterrupts();
4416  095d 9a            rim
4418                     ; 643 }
4422  095e 81            	ret
4509                     ; 645 void tcp_server_process(void){
4510                     	switch	.text
4511  095f               _tcp_server_process:
4513  095f 522b          	subw	sp,#43
4514       0000002b      OFST:	set	43
4517                     ; 646     uint16_t received_len = 0;
4519                     ; 649     if(server_state == TCP_STATE_IDLE) return;
4521  0961 3d0a          	tnz	L32_server_state
4522  0963 2603          	jrne	L052
4523  0965 cc0a3b        	jp	L642
4524  0968               L052:
4527                     ; 650     sock_status = getSn_SR(server_socket);
4529  0968 b61c          	ld	a,L33_server_socket
4530  096a 97            	ld	xl,a
4531  096b a604          	ld	a,#4
4532  096d 42            	mul	x,a
4533  096e 58            	sllw	x
4534  096f 58            	sllw	x
4535  0970 58            	sllw	x
4536  0971 1c0308        	addw	x,#776
4537  0974 cd0000        	call	c_itolx
4539  0977 be02          	ldw	x,c_lreg+2
4540  0979 89            	pushw	x
4541  097a be00          	ldw	x,c_lreg
4542  097c 89            	pushw	x
4543  097d cd0000        	call	_WIZCHIP_READ
4545  0980 5b04          	addw	sp,#4
4546  0982 6b29          	ld	(OFST-2,sp),a
4548                     ; 652     switch(sock_status){
4550  0984 7b29          	ld	a,(OFST-2,sp)
4552                     ; 685             break;
4553  0986 4d            	tnz	a
4554  0987 2603          	jrne	L252
4555  0989 cc0a1d        	jp	L1071
4556  098c               L252:
4557  098c a014          	sub	a,#20
4558  098e 270c          	jreq	L5761
4559  0990 a003          	sub	a,#3
4560  0992 2710          	jreq	L7761
4561  0994               L3071:
4562                     ; 683         default:
4562                     ; 684             server_state = TCP_STATE_ERROR;
4564  0994 3503000a      	mov	L32_server_state,#3
4565                     ; 685             break;
4567  0998 ac3b0a3b      	jpf	L7471
4568  099c               L5761:
4569                     ; 653         case SOCK_LISTEN:
4569                     ; 654             server_state = TCP_STATE_LISTENING;
4571  099c 3501000a      	mov	L32_server_state,#1
4572                     ; 655             break;
4574  09a0 ac3b0a3b      	jpf	L7471
4575  09a4               L7761:
4576                     ; 657         case SOCK_ESTABLISHED:
4576                     ; 658             server_state = TCP_STATE_CONNECTED;
4578  09a4 3502000a      	mov	L32_server_state,#2
4579                     ; 659             received_len = getSn_RX_RSR(server_socket);
4581  09a8 b61c          	ld	a,L33_server_socket
4582  09aa cd0000        	call	_getSn_RX_RSR
4584  09ad 1f2a          	ldw	(OFST-1,sp),x
4586                     ; 660             if(received_len > 0){
4588  09af 1e2a          	ldw	x,(OFST-1,sp)
4589  09b1 27b2          	jreq	L7471
4590                     ; 661                 uint16_t read_len = (received_len > TCP_RX_BUFFER) ? TCP_RX_BUFFER : received_len;
4592  09b3 1e2a          	ldw	x,(OFST-1,sp)
4593  09b5 a30021        	cpw	x,#33
4594  09b8 2505          	jrult	L242
4595  09ba ae0020        	ldw	x,#32
4596  09bd 2002          	jra	L442
4597  09bf               L242:
4598  09bf 1e2a          	ldw	x,(OFST-1,sp)
4599  09c1               L442:
4600  09c1 1f2a          	ldw	(OFST-1,sp),x
4602                     ; 663                 read_len = recv(server_socket, rx_buffer, read_len);
4604  09c3 1e2a          	ldw	x,(OFST-1,sp)
4605  09c5 89            	pushw	x
4606  09c6 ae0060        	ldw	x,#_rx_buffer
4607  09c9 89            	pushw	x
4608  09ca b61c          	ld	a,L33_server_socket
4609  09cc cd0000        	call	_recv
4611  09cf 5b04          	addw	sp,#4
4612  09d1 be02          	ldw	x,c_lreg+2
4613  09d3 1f2a          	ldw	(OFST-1,sp),x
4615                     ; 664                 if(read_len > 0){
4617  09d5 1e2a          	ldw	x,(OFST-1,sp)
4618  09d7 2762          	jreq	L7471
4619                     ; 665                     if(command_parser_execute((const char *)rx_buffer, read_len) == 0){
4621  09d9 1e2a          	ldw	x,(OFST-1,sp)
4622  09db 89            	pushw	x
4623  09dc ae0060        	ldw	x,#_rx_buffer
4624  09df cd068d        	call	_command_parser_execute
4626  09e2 5b02          	addw	sp,#2
4627  09e4 a30000        	cpw	x,#0
4628  09e7 2652          	jrne	L7471
4629                     ; 668                         sensor_state_t state = sensor_reader_get_state();
4631  09e9 96            	ldw	x,sp
4632  09ea 1c0025        	addw	x,#OFST-6
4633  09ed 89            	pushw	x
4634  09ee cd011a        	call	_sensor_reader_get_state
4636  09f1 85            	popw	x
4637                     ; 669                         message_formatter_alive(resp_buf,sizeof(resp_buf),state.di1,state.di2,state.di3,state.di4);
4639  09f2 7b28          	ld	a,(OFST-3,sp)
4640  09f4 88            	push	a
4641  09f5 7b28          	ld	a,(OFST-3,sp)
4642  09f7 88            	push	a
4643  09f8 7b28          	ld	a,(OFST-3,sp)
4644  09fa 88            	push	a
4645  09fb 7b28          	ld	a,(OFST-3,sp)
4646  09fd 88            	push	a
4647  09fe ae0020        	ldw	x,#32
4648  0a01 89            	pushw	x
4649  0a02 96            	ldw	x,sp
4650  0a03 1c000b        	addw	x,#OFST-32
4651  0a06 cd0126        	call	_message_formatter_alive
4653  0a09 5b06          	addw	sp,#6
4654                     ; 670                         tcp_server_send((uint8_t *)resp_buf, strlen(resp_buf));
4656  0a0b 96            	ldw	x,sp
4657  0a0c 1c0005        	addw	x,#OFST-38
4658  0a0f cd0000        	call	_strlen
4660  0a12 89            	pushw	x
4661  0a13 96            	ldw	x,sp
4662  0a14 1c0007        	addw	x,#OFST-36
4663  0a17 cd0041        	call	_tcp_server_send
4665  0a1a 85            	popw	x
4666  0a1b 201e          	jra	L7471
4667  0a1d               L1071:
4668                     ; 676         case SOCK_CLOSED:
4668                     ; 677             server_state = TCP_STATE_LISTENING;
4670  0a1d 3501000a      	mov	L32_server_state,#1
4671                     ; 678             close(server_socket);
4673  0a21 b61c          	ld	a,L33_server_socket
4674  0a23 cd0000        	call	_close
4676                     ; 679             socket(server_socket, Sn_MR_TCP, server_port, 0);
4678  0a26 4b00          	push	#0
4679  0a28 be1d          	ldw	x,L53_server_port
4680  0a2a 89            	pushw	x
4681  0a2b b61c          	ld	a,L33_server_socket
4682  0a2d ae0001        	ldw	x,#1
4683  0a30 95            	ld	xh,a
4684  0a31 cd0000        	call	_socket
4686  0a34 5b03          	addw	sp,#3
4687                     ; 680             listen(server_socket);
4689  0a36 b61c          	ld	a,L33_server_socket
4690  0a38 cd0000        	call	_listen
4692                     ; 681             break;
4694  0a3b               L7471:
4695                     ; 687 }
4696  0a3b               L642:
4699  0a3b 5b2b          	addw	sp,#43
4700  0a3d 81            	ret
4739                     ; 689 void tcp_server_init(uint16_t port){
4740                     	switch	.text
4741  0a3e               _tcp_server_init:
4745                     ; 690     server_port = port;
4747  0a3e bf1d          	ldw	L53_server_port,x
4748                     ; 691     server_state = TCP_STATE_IDLE;
4750  0a40 3f0a          	clr	L32_server_state
4751                     ; 694     if(socket(server_socket, Sn_MR_TCP, server_port, 0) == server_socket){
4753  0a42 4b00          	push	#0
4754  0a44 be1d          	ldw	x,L53_server_port
4755  0a46 89            	pushw	x
4756  0a47 b61c          	ld	a,L33_server_socket
4757  0a49 ae0001        	ldw	x,#1
4758  0a4c 95            	ld	xh,a
4759  0a4d cd0000        	call	_socket
4761  0a50 5b03          	addw	sp,#3
4762  0a52 5f            	clrw	x
4763  0a53 4d            	tnz	a
4764  0a54 2a01          	jrpl	L652
4765  0a56 53            	cplw	x
4766  0a57               L652:
4767  0a57 97            	ld	xl,a
4768  0a58 b61c          	ld	a,L33_server_socket
4769  0a5a 905f          	clrw	y
4770  0a5c 9097          	ld	yl,a
4771  0a5e 90bf00        	ldw	c_y,y
4772  0a61 b300          	cpw	x,c_y
4773  0a63 260d          	jrne	L5771
4774                     ; 695         if(listen(server_socket) == SOCK_OK){
4776  0a65 b61c          	ld	a,L33_server_socket
4777  0a67 cd0000        	call	_listen
4779  0a6a a101          	cp	a,#1
4780  0a6c 2604          	jrne	L5771
4781                     ; 696             server_state = TCP_STATE_LISTENING;
4783  0a6e 3501000a      	mov	L32_server_state,#1
4784  0a72               L5771:
4785                     ; 699 }
4788  0a72 81            	ret
4848                     ; 701 void w5500_chip_init(void)
4848                     ; 702 {
4849                     	switch	.text
4850  0a73               _w5500_chip_init:
4852  0a73 88            	push	a
4853       00000001      OFST:	set	1
4856                     ; 706     GPIO_WriteLow(W5500_RST_PORT, W5500_RST_PIN);
4858  0a74 4b20          	push	#32
4859  0a76 ae5014        	ldw	x,#20500
4860  0a79 cd0000        	call	_GPIO_WriteLow
4862  0a7c 84            	pop	a
4863                     ; 707     hal_delay_ms(100);
4865  0a7d ae0064        	ldw	x,#100
4866  0a80 cd0014        	call	_hal_delay_ms
4868                     ; 708     hal_w5500_reset_high();
4870  0a83 cd0702        	call	_hal_w5500_reset_high
4872                     ; 709     GPIO_WriteHigh(W5500_RST_PORT, W5500_RST_PIN);
4874  0a86 4b20          	push	#32
4875  0a88 ae5014        	ldw	x,#20500
4876  0a8b cd0000        	call	_GPIO_WriteHigh
4878  0a8e 84            	pop	a
4879                     ; 710     CLK_PeripheralClockConfig(CLK_PERIPHERAL_SPI, ENABLE);
4881  0a8f ae0101        	ldw	x,#257
4882  0a92 cd0000        	call	_CLK_PeripheralClockConfig
4884                     ; 711     GPIO_Init(W5500_SCK_PORT,W5500_SCK_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
4886  0a95 4bf0          	push	#240
4887  0a97 4b20          	push	#32
4888  0a99 ae500a        	ldw	x,#20490
4889  0a9c cd0000        	call	_GPIO_Init
4891  0a9f 85            	popw	x
4892                     ; 712     GPIO_Init(W5500_MOSI_PORT,W5500_MOSI_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
4894  0aa0 4bf0          	push	#240
4895  0aa2 4b40          	push	#64
4896  0aa4 ae500a        	ldw	x,#20490
4897  0aa7 cd0000        	call	_GPIO_Init
4899  0aaa 85            	popw	x
4900                     ; 713     GPIO_Init(W5500_MISO_PORT,W5500_MISO_PIN,GPIO_MODE_IN_FL_NO_IT);
4902  0aab 4b00          	push	#0
4903  0aad 4b80          	push	#128
4904  0aaf ae500a        	ldw	x,#20490
4905  0ab2 cd0000        	call	_GPIO_Init
4907  0ab5 85            	popw	x
4908                     ; 714     GPIO_Init(W5500_CS_PORT,W5500_CS_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
4910  0ab6 4bf0          	push	#240
4911  0ab8 4b08          	push	#8
4912  0aba ae5000        	ldw	x,#20480
4913  0abd cd0000        	call	_GPIO_Init
4915  0ac0 85            	popw	x
4916                     ; 715     GPIO_WriteHigh(W5500_CS_PORT, W5500_CS_PIN);
4918  0ac1 4b08          	push	#8
4919  0ac3 ae5000        	ldw	x,#20480
4920  0ac6 cd0000        	call	_GPIO_WriteHigh
4922  0ac9 84            	pop	a
4923                     ; 716     GPIO_Init(W5500_RST_PORT,W5500_RST_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
4925  0aca 4bf0          	push	#240
4926  0acc 4b20          	push	#32
4927  0ace ae5014        	ldw	x,#20500
4928  0ad1 cd0000        	call	_GPIO_Init
4930  0ad4 85            	popw	x
4931                     ; 717     SPI_DeInit();
4933  0ad5 cd0000        	call	_SPI_DeInit
4935                     ; 718         SPI_Init(
4935                     ; 719         SPI_FIRSTBIT_MSB,
4935                     ; 720         SPI_BAUDRATEPRESCALER_4,
4935                     ; 721         SPI_MODE_MASTER,
4935                     ; 722         SPI_CLOCKPOLARITY_LOW,
4935                     ; 723         SPI_CLOCKPHASE_1EDGE,
4935                     ; 724         SPI_DATADIRECTION_2LINES_FULLDUPLEX,
4935                     ; 725         SPI_NSS_SOFT,
4935                     ; 726         0x07
4935                     ; 727     );
4937  0ad8 4b07          	push	#7
4938  0ada 4b02          	push	#2
4939  0adc 4b00          	push	#0
4940  0ade 4b00          	push	#0
4941  0ae0 4b00          	push	#0
4942  0ae2 4b04          	push	#4
4943  0ae4 ae0008        	ldw	x,#8
4944  0ae7 cd0000        	call	_SPI_Init
4946  0aea 5b06          	addw	sp,#6
4947                     ; 729     SPI_Cmd(ENABLE);
4949  0aec a601          	ld	a,#1
4950  0aee cd0000        	call	_SPI_Cmd
4952                     ; 730     reg_wizchip_spi_cbfunc(hal_spi_read_byte,hal_spi_write_byte);
4954  0af1 ae08c7        	ldw	x,#_hal_spi_write_byte
4955  0af4 89            	pushw	x
4956  0af5 ae08c2        	ldw	x,#_hal_spi_read_byte
4957  0af8 cd0000        	call	_reg_wizchip_spi_cbfunc
4959  0afb 85            	popw	x
4960                     ; 731     reg_wizchip_spiburst_cbfunc(hal_spi_read,hal_spi_write);
4962  0afc ae08eb        	ldw	x,#_hal_spi_write
4963  0aff 89            	pushw	x
4964  0b00 ae08ca        	ldw	x,#_hal_spi_read
4965  0b03 cd0000        	call	_reg_wizchip_spiburst_cbfunc
4967  0b06 85            	popw	x
4968                     ; 732     reg_wizchip_cs_cbfunc(hal_spi_cs_low,hal_spi_cs_high);
4970  0b07 ae00db        	ldw	x,#_hal_spi_cs_high
4971  0b0a 89            	pushw	x
4972  0b0b ae00d1        	ldw	x,#_hal_spi_cs_low
4973  0b0e cd0000        	call	_reg_wizchip_cs_cbfunc
4975  0b11 85            	popw	x
4976                     ; 733     wizchip_init(0, 0);
4978  0b12 5f            	clrw	x
4979  0b13 89            	pushw	x
4980  0b14 5f            	clrw	x
4981  0b15 cd0000        	call	_wizchip_init
4983  0b18 85            	popw	x
4984                     ; 734     version = getVERSIONR();
4986  0b19 ae0039        	ldw	x,#57
4987  0b1c 89            	pushw	x
4988  0b1d ae0000        	ldw	x,#0
4989  0b20 89            	pushw	x
4990  0b21 cd0000        	call	_WIZCHIP_READ
4992  0b24 5b04          	addw	sp,#4
4993  0b26 6b01          	ld	(OFST+0,sp),a
4995                     ; 735     if(version != 0x04)
4997  0b28 7b01          	ld	a,(OFST+0,sp)
4998  0b2a a104          	cp	a,#4
4999  0b2c 2702          	jreq	L7102
5000  0b2e               L1202:
5001                     ; 737         while(1);
5003  0b2e 20fe          	jra	L1202
5004  0b30               L7102:
5005                     ; 739 }
5008  0b30 84            	pop	a
5009  0b31 81            	ret
5045                     ; 741 void system_init(void){
5046                     	switch	.text
5047  0b32               _system_init:
5051                     ; 743     CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);  /* 16MHz clock */
5053  0b32 4f            	clr	a
5054  0b33 cd0000        	call	_CLK_HSIPrescalerConfig
5056                     ; 745 	hal_gpio_init();
5058  0b36 cd070c        	call	_hal_gpio_init
5060                     ; 746     hal_timer_init();
5062  0b39 cd0946        	call	_hal_timer_init
5064                     ; 748 	relay_control_init();
5066  0b3c cd06fc        	call	_relay_control_init
5068                     ; 749 	sensor_reader_init();
5070  0b3f cd05fd        	call	_sensor_reader_init
5072                     ; 751     w5500_chip_init();
5074  0b42 cd0a73        	call	_w5500_chip_init
5076                     ; 752     tcp_server_init(TCP_SERVER_PORT);
5078  0b45 ae1388        	ldw	x,#5000
5079  0b48 cd0a3e        	call	_tcp_server_init
5081                     ; 754     uart_server_init(UART_BAUDRATE);
5083  0b4b aec200        	ldw	x,#49664
5084  0b4e 89            	pushw	x
5085  0b4f ae0001        	ldw	x,#1
5086  0b52 89            	pushw	x
5087  0b53 cd090a        	call	_uart_server_init
5089  0b56 5b04          	addw	sp,#4
5090                     ; 757     hal_timer_set_callback(timer_callback);
5092  0b58 ae0640        	ldw	x,#_timer_callback
5093  0b5b cd068a        	call	_hal_timer_set_callback
5095                     ; 758     hal_timer_start();
5097  0b5e cd056e        	call	_hal_timer_start
5099                     ; 759 	hal_delay_ms(500);
5101  0b61 ae01f4        	ldw	x,#500
5102  0b64 cd0014        	call	_hal_delay_ms
5104                     ; 760 }
5107  0b67 81            	ret
5110                     	switch	.const
5111  000c               L5302_msg:
5112  000c 52455345542c  	dc.b	"RESET, OK",10,0
5152                     ; 762 void main_loop(void)
5152                     ; 763 {
5153                     	switch	.text
5154  0b68               _main_loop:
5156  0b68 520b          	subw	sp,#11
5157       0000000b      OFST:	set	11
5160  0b6a               L5502:
5161                     ; 767         tcp_server_process();
5163  0b6a cd095f        	call	_tcp_server_process
5165                     ; 769 		uart_server_process();
5167  0b6d cd07e2        	call	_uart_server_process
5169                     ; 771         if(GPIO_ReadInputPin(HARDRST_PORT, HARDRST_PIN) == RESET)
5171  0b70 4b80          	push	#128
5172  0b72 ae5005        	ldw	x,#20485
5173  0b75 cd0000        	call	_GPIO_ReadInputPin
5175  0b78 5b01          	addw	sp,#1
5176  0b7a 4d            	tnz	a
5177  0b7b 26ed          	jrne	L5502
5178                     ; 773             hal_delay_ms(50);
5180  0b7d ae0032        	ldw	x,#50
5181  0b80 cd0014        	call	_hal_delay_ms
5183                     ; 774 			if (GPIO_ReadInputPin(HARDRST_PORT, HARDRST_PIN) == 0){
5185  0b83 4b80          	push	#128
5186  0b85 ae5005        	ldw	x,#20485
5187  0b88 cd0000        	call	_GPIO_ReadInputPin
5189  0b8b 5b01          	addw	sp,#1
5190  0b8d 4d            	tnz	a
5191  0b8e 26da          	jrne	L5502
5192                     ; 776 				char msg[] = "RESET, OK\n";
5194  0b90 96            	ldw	x,sp
5195  0b91 1c0001        	addw	x,#OFST-10
5196  0b94 90ae000c      	ldw	y,#L5302_msg
5197  0b98 a60b          	ld	a,#11
5198  0b9a cd0000        	call	c_xymov
5200                     ; 777                 if (uart_server_is_ready()){
5202  0b9d cd008d        	call	_uart_server_is_ready
5204  0ba0 a30000        	cpw	x,#0
5205  0ba3 2710          	jreq	L5602
5206                     ; 778                     uart_server_send((uint8_t *)msg, strlen(msg));
5208  0ba5 96            	ldw	x,sp
5209  0ba6 1c0001        	addw	x,#OFST-10
5210  0ba9 cd0000        	call	_strlen
5212  0bac 89            	pushw	x
5213  0bad 96            	ldw	x,sp
5214  0bae 1c0003        	addw	x,#OFST-8
5215  0bb1 cd00e5        	call	_uart_server_send
5217  0bb4 85            	popw	x
5218  0bb5               L5602:
5219                     ; 780 				hal_delay_ms(100);
5221  0bb5 ae0064        	ldw	x,#100
5222  0bb8 cd0014        	call	_hal_delay_ms
5224  0bbb 20ad          	jra	L5502
5249                     ; 787 int main(void)
5249                     ; 788 {
5250                     	switch	.text
5251  0bbd               _main:
5255                     ; 789 	system_init();
5257  0bbd cd0b32        	call	_system_init
5259                     ; 790     main_loop();
5261  0bc0 ada6          	call	_main_loop
5263  0bc2               L7702:
5264                     ; 791     while(1);
5266  0bc2 20fe          	jra	L7702
5585                     	xdef	_main
5586                     	xdef	_main_loop
5587                     	xdef	_system_init
5588                     	xdef	_w5500_chip_init
5589                     	xdef	_tcp_server_init
5590                     	xdef	_tcp_server_process
5591                     	xdef	_hal_timer_init
5592                     	xdef	_uart_server_init
5593                     	xdef	_hal_spi_write
5594                     	xdef	_hal_spi_read
5595                     	xdef	_hal_spi_write_byte
5596                     	xdef	_hal_spi_read_byte
5597                     	xdef	_hal_spi_byte
5598                     	xdef	_uart_server_process
5599                     	xdef	_hal_uart_read_byte
5600                     	xdef	_hal_uart_available
5601                     	xdef	_hal_gpio_init
5602                     	xdef	_hal_w5500_reset_high
5603                     	xdef	_relay_control_init
5604                     	xdef	_command_parser_execute
5605                     	xdef	_hal_timer_set_callback
5606                     	xdef	_timer_callback
5607                     	xdef	_send_alive_message
5608                     	xdef	_sensor_reader_init
5609                     	xdef	_process_axle_counting
5610                     	xdef	_hal_timer_start
5611                     	xdef	_sensor_reader_update
5612                     	xdef	_relay_control_set_all
5613                     	xdef	_relay_control_set
5614                     	xdef	_hal_relay_set
5615                     	xdef	_message_formatter_avcc
5616                     	xdef	_u32_to_str
5617                     	xdef	_u16_to_str
5618                     	xdef	_hal_di_read
5619                     	xdef	_message_formatter_alive
5620                     	xdef	_sensor_reader_get_state
5621                     	xdef	_uart_server_send
5622                     	xdef	_hal_spi_cs_high
5623                     	xdef	_hal_spi_cs_low
5624                     	xdef	_hal_uart_send
5625                     	xdef	_hal_uart_send_byte
5626                     	xdef	_uart_server_is_ready
5627                     	xdef	_tcp_server_send
5628                     	xdef	_hal_delay_ms
5629                     	xdef	_tcp_server_is_connected
5630                     	xdef	_hal_get_millis
5631                     	xdef	_user_callback
5632                     	xdef	_systick_ms
5633                     	switch	.ubsct
5634  0000               _uart_rx_buffer:
5635  0000 000000000000  	ds.b	32
5636                     	xdef	_uart_rx_buffer
5637  0020               L73_uart_tx_buffer:
5638  0020 000000000000  	ds.b	32
5639                     	xdef	_uart_rx_tail
5640                     	xdef	_uart_rx_head
5641                     	xdef	_uart_rx_count
5642  0040               _tx_buffer:
5643  0040 000000000000  	ds.b	32
5644                     	xdef	_tx_buffer
5645  0060               _rx_buffer:
5646  0060 000000000000  	ds.b	32
5647                     	xdef	_rx_buffer
5648                     	xref	_strlen
5649                     	xref	_send
5650                     	xref	_recv
5651                     	xref	_listen
5652                     	xref	_close
5653                     	xref	_socket
5654                     	xref	_wizchip_init
5655                     	xref	_reg_wizchip_spiburst_cbfunc
5656                     	xref	_reg_wizchip_spi_cbfunc
5657                     	xref	_getSn_RX_RSR
5658                     	xref	_reg_wizchip_cs_cbfunc
5659                     	xref	_WIZCHIP_READ
5660                     	xref	_TIM4_ClearFlag
5661                     	xref	_TIM4_ITConfig
5662                     	xref	_TIM4_Cmd
5663                     	xref	_TIM4_TimeBaseInit
5664                     	xref	_SPI_GetFlagStatus
5665                     	xref	_SPI_ReceiveData
5666                     	xref	_SPI_SendData
5667                     	xref	_SPI_Cmd
5668                     	xref	_SPI_Init
5669                     	xref	_SPI_DeInit
5670                     	xref	_UART1_GetFlagStatus
5671                     	xref	_UART1_SendData8
5672                     	xref	_UART1_ITConfig
5673                     	xref	_UART1_Cmd
5674                     	xref	_UART1_Init
5675                     	xref	_GPIO_ReadInputPin
5676                     	xref	_GPIO_WriteLow
5677                     	xref	_GPIO_WriteHigh
5678                     	xref	_GPIO_Init
5679                     	xref	_CLK_HSIPrescalerConfig
5680                     	xref	_CLK_PeripheralClockConfig
5681                     	switch	.const
5682  0017               L1641:
5683  0017 4552524f522c  	dc.b	"ERROR,INVALID_COMM"
5684  0029 414e440a00    	dc.b	"AND",10,0
5685                     	xref.b	c_lreg
5686                     	xref.b	c_x
5687                     	xref.b	c_y
5707                     	xref	c_itolx
5708                     	xref	c_lgadc
5709                     	xref	c_ludv
5710                     	xref	c_ladc
5711                     	xref	c_lumd
5712                     	xref	c_lzmp
5713                     	xref	c_xymov
5714                     	xref	c_lcmp
5715                     	xref	c_lsub
5716                     	xref	c_uitolx
5717                     	xref	c_rtol
5718                     	xref	c_ltor
5719                     	end
