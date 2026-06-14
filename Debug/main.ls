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
  44  0023               L53_systick_ms:
  45  0023 00000000      	dc.l	0
  46  0027               L73_user_callback:
  47  0027 0000          	dc.w	0
  77                     ; 72 unsigned long hal_get_millis(void)
  77                     ; 73 {
  79                     	switch	.text
  80  0000               _hal_get_millis:
  84                     ; 74     return systick_ms;
  86  0000 ae0023        	ldw	x,#L53_systick_ms
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
 197  0020               L511:
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
 218  003c 22e2          	jrugt	L511
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
 309  004d               L151:
 310                     ; 91     while (UART1_GetFlagStatus(UART1_FLAG_TXE) == RESET);
 312  004d ae0080        	ldw	x,#128
 313  0050 cd0000        	call	_UART1_GetFlagStatus
 315  0053 4d            	tnz	a
 316  0054 27f7          	jreq	L151
 317                     ; 94     UART1_SendData8(byte);
 319  0056 7b01          	ld	a,(OFST+1,sp)
 320  0058 cd0000        	call	_UART1_SendData8
 323  005b               L751:
 324                     ; 97     while (UART1_GetFlagStatus(UART1_FLAG_TC) == RESET);
 326  005b ae0040        	ldw	x,#64
 327  005e cd0000        	call	_UART1_GetFlagStatus
 329  0061 4d            	tnz	a
 330  0062 27f7          	jreq	L751
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
 404  006b 200f          	jra	L512
 405  006d               L112:
 406                     ; 103         hal_uart_send_byte(data[i]);
 408  006d 1e03          	ldw	x,(OFST+1,sp)
 409  006f 72fb01        	addw	x,(OFST-1,sp)
 410  0072 f6            	ld	a,(x)
 411  0073 add7          	call	_hal_uart_send_byte
 413                     ; 102     for(i = 0; i < len; i++){
 415  0075 1e01          	ldw	x,(OFST-1,sp)
 416  0077 1c0001        	addw	x,#1
 417  007a 1f01          	ldw	(OFST-1,sp),x
 419  007c               L512:
 422  007c 1e01          	ldw	x,(OFST-1,sp)
 423  007e 1307          	cpw	x,(OFST+5,sp)
 424  0080 25eb          	jrult	L112
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
 557                     ; 116 int uart_server_send(const uint8_t *data, uint16_t len)
 557                     ; 117 {
 558                     	switch	.text
 559  0099               _uart_server_send:
 561  0099 89            	pushw	x
 562       00000000      OFST:	set	0
 565                     ; 118     if (uart_state == UART_STATE_IDLE) {
 567  009a 3d19          	tnz	L31_uart_state
 568  009c 2605          	jrne	L362
 569                     ; 119         return -1;
 571  009e aeffff        	ldw	x,#65535
 573  00a1 2028          	jra	L24
 574  00a3               L362:
 575                     ; 122     if (len > sizeof(uart_tx_buffer)) {
 577  00a3 1e05          	ldw	x,(OFST+5,sp)
 578  00a5 a30051        	cpw	x,#81
 579  00a8 2505          	jrult	L562
 580                     ; 123         len = sizeof(uart_tx_buffer);
 582  00aa ae0050        	ldw	x,#80
 583  00ad 1f05          	ldw	(OFST+5,sp),x
 584  00af               L562:
 585                     ; 127     memcpy(uart_tx_buffer, data, len);
 587  00af 1e01          	ldw	x,(OFST+1,sp)
 588  00b1 bf00          	ldw	c_x,x
 589  00b3 1e05          	ldw	x,(OFST+5,sp)
 590  00b5 5d            	tnzw	x
 591  00b6 2709          	jreq	L63
 592  00b8               L04:
 593  00b8 5a            	decw	x
 594  00b9 92d600        	ld	a,([c_x.w],x)
 595  00bc e714          	ld	(L72_uart_tx_buffer,x),a
 596  00be 5d            	tnzw	x
 597  00bf 26f7          	jrne	L04
 598  00c1               L63:
 599                     ; 128     hal_uart_send(uart_tx_buffer, len);
 601  00c1 1e05          	ldw	x,(OFST+5,sp)
 602  00c3 89            	pushw	x
 603  00c4 ae0014        	ldw	x,#L72_uart_tx_buffer
 604  00c7 ad9d          	call	_hal_uart_send
 606  00c9 85            	popw	x
 607                     ; 130     return 0;
 609  00ca 5f            	clrw	x
 611  00cb               L24:
 613  00cb 5b02          	addw	sp,#2
 614  00cd 81            	ret
 675                     ; 132 sensor_state_t sensor_reader_get_state(void)
 675                     ; 133 {
 676                     	switch	.text
 677  00ce               _sensor_reader_get_state:
 679       00000000      OFST:	set	0
 682                     ; 134     return current_state;
 684  00ce 1e03          	ldw	x,(OFST+3,sp)
 685  00d0 90ae0014      	ldw	y,#L7_current_state
 686  00d4 a604          	ld	a,#4
 687  00d6 cd0000        	call	c_xymov
 691  00d9 81            	ret
 772                     ; 137 void message_formatter_alive(char *buf,
 772                     ; 138                              int buf_size,
 772                     ; 139                              uint8_t di1,
 772                     ; 140                              uint8_t di2,
 772                     ; 141                              uint8_t di3,
 772                     ; 142                              uint8_t di4)
 772                     ; 143 {
 773                     	switch	.text
 774  00da               _message_formatter_alive:
 776  00da 89            	pushw	x
 777       00000000      OFST:	set	0
 780                     ; 144     if(buf == 0)
 782  00db a30000        	cpw	x,#0
 783  00de 2708          	jreq	L07
 784                     ; 145         return;
 786                     ; 147     if(buf_size < 21)
 788  00e0 9c            	rvf
 789  00e1 1e05          	ldw	x,(OFST+5,sp)
 790  00e3 a30015        	cpw	x,#21
 791  00e6 2e02          	jrsge	L753
 792                     ; 148         return;
 793  00e8               L07:
 796  00e8 85            	popw	x
 797  00e9 81            	ret
 798  00ea               L753:
 799                     ; 150     buf[0]  = 'S';
 801  00ea 1e01          	ldw	x,(OFST+1,sp)
 802  00ec a653          	ld	a,#83
 803  00ee f7            	ld	(x),a
 804                     ; 151     buf[1]  = 'T';
 806  00ef 1e01          	ldw	x,(OFST+1,sp)
 807  00f1 a654          	ld	a,#84
 808  00f3 e701          	ld	(1,x),a
 809                     ; 152     buf[2]  = 'A';
 811  00f5 1e01          	ldw	x,(OFST+1,sp)
 812  00f7 a641          	ld	a,#65
 813  00f9 e702          	ld	(2,x),a
 814                     ; 153     buf[3]  = 'R';
 816  00fb 1e01          	ldw	x,(OFST+1,sp)
 817  00fd a652          	ld	a,#82
 818  00ff e703          	ld	(3,x),a
 819                     ; 154     buf[4]  = 'T';
 821  0101 1e01          	ldw	x,(OFST+1,sp)
 822  0103 a654          	ld	a,#84
 823  0105 e704          	ld	(4,x),a
 824                     ; 155     buf[5]  = ',';
 826  0107 1e01          	ldw	x,(OFST+1,sp)
 827  0109 a62c          	ld	a,#44
 828  010b e705          	ld	(5,x),a
 829                     ; 156     buf[6]  = 'A';
 831  010d 1e01          	ldw	x,(OFST+1,sp)
 832  010f a641          	ld	a,#65
 833  0111 e706          	ld	(6,x),a
 834                     ; 157     buf[7]  = 'L';
 836  0113 1e01          	ldw	x,(OFST+1,sp)
 837  0115 a64c          	ld	a,#76
 838  0117 e707          	ld	(7,x),a
 839                     ; 158     buf[8]  = 'I';
 841  0119 1e01          	ldw	x,(OFST+1,sp)
 842  011b a649          	ld	a,#73
 843  011d e708          	ld	(8,x),a
 844                     ; 159     buf[9]  = 'V';
 846  011f 1e01          	ldw	x,(OFST+1,sp)
 847  0121 a656          	ld	a,#86
 848  0123 e709          	ld	(9,x),a
 849                     ; 160     buf[10] = 'E';
 851  0125 1e01          	ldw	x,(OFST+1,sp)
 852  0127 a645          	ld	a,#69
 853  0129 e70a          	ld	(10,x),a
 854                     ; 161     buf[11] = ',';
 856  012b 1e01          	ldw	x,(OFST+1,sp)
 857  012d a62c          	ld	a,#44
 858  012f e70b          	ld	(11,x),a
 859                     ; 163     buf[12] = di1 ? '1' : '0';
 861  0131 0d07          	tnz	(OFST+7,sp)
 862  0133 2704          	jreq	L05
 863  0135 a631          	ld	a,#49
 864  0137 2002          	jra	L25
 865  0139               L05:
 866  0139 a630          	ld	a,#48
 867  013b               L25:
 868  013b 1e01          	ldw	x,(OFST+1,sp)
 869  013d e70c          	ld	(12,x),a
 870                     ; 164     buf[13] = di2 ? '1' : '0';
 872  013f 0d08          	tnz	(OFST+8,sp)
 873  0141 2704          	jreq	L45
 874  0143 a631          	ld	a,#49
 875  0145 2002          	jra	L65
 876  0147               L45:
 877  0147 a630          	ld	a,#48
 878  0149               L65:
 879  0149 1e01          	ldw	x,(OFST+1,sp)
 880  014b e70d          	ld	(13,x),a
 881                     ; 165     buf[14] = di3 ? '1' : '0';
 883  014d 0d09          	tnz	(OFST+9,sp)
 884  014f 2704          	jreq	L06
 885  0151 a631          	ld	a,#49
 886  0153 2002          	jra	L26
 887  0155               L06:
 888  0155 a630          	ld	a,#48
 889  0157               L26:
 890  0157 1e01          	ldw	x,(OFST+1,sp)
 891  0159 e70e          	ld	(14,x),a
 892                     ; 166     buf[15] = di4 ? '1' : '0';
 894  015b 0d0a          	tnz	(OFST+10,sp)
 895  015d 2704          	jreq	L46
 896  015f a631          	ld	a,#49
 897  0161 2002          	jra	L66
 898  0163               L46:
 899  0163 a630          	ld	a,#48
 900  0165               L66:
 901  0165 1e01          	ldw	x,(OFST+1,sp)
 902  0167 e70f          	ld	(15,x),a
 903                     ; 168     buf[16] = ',';
 905  0169 1e01          	ldw	x,(OFST+1,sp)
 906  016b a62c          	ld	a,#44
 907  016d e710          	ld	(16,x),a
 908                     ; 169     buf[17] = 'E';
 910  016f 1e01          	ldw	x,(OFST+1,sp)
 911  0171 a645          	ld	a,#69
 912  0173 e711          	ld	(17,x),a
 913                     ; 170     buf[18] = 'N';
 915  0175 1e01          	ldw	x,(OFST+1,sp)
 916  0177 a64e          	ld	a,#78
 917  0179 e712          	ld	(18,x),a
 918                     ; 171     buf[19] = 'D';
 920  017b 1e01          	ldw	x,(OFST+1,sp)
 921  017d a644          	ld	a,#68
 922  017f e713          	ld	(19,x),a
 923                     ; 172     buf[20] = '\0';
 925  0181 1e01          	ldw	x,(OFST+1,sp)
 926  0183 6f14          	clr	(20,x)
 927                     ; 173 }
 930  0185 85            	popw	x
 931  0186 81            	ret
1123                     ; 175 uint8_t hal_di_read(uint8_t di_num)
1123                     ; 176 {
1124                     	switch	.text
1125  0187               _hal_di_read:
1127  0187 5203          	subw	sp,#3
1128       00000003      OFST:	set	3
1131                     ; 180     switch (di_num) {
1134                     ; 185         default: return 0;
1135  0189 4a            	dec	a
1136  018a 270c          	jreq	L163
1137  018c 4a            	dec	a
1138  018d 2714          	jreq	L363
1139  018f 4a            	dec	a
1140  0190 271c          	jreq	L563
1141  0192 4a            	dec	a
1142  0193 2724          	jreq	L763
1143  0195               L173:
1146  0195 4f            	clr	a
1148  0196 203d          	jra	L001
1149  0198               L163:
1150                     ; 181         case 1: port = DI1_PORT; pin = DI1_PIN; break;
1152  0198 ae500f        	ldw	x,#20495
1153  019b 1f01          	ldw	(OFST-2,sp),x
1157  019d a604          	ld	a,#4
1158  019f 6b03          	ld	(OFST+0,sp),a
1162  01a1 201f          	jra	L705
1163  01a3               L363:
1164                     ; 182         case 2: port = DI2_PORT; pin = DI2_PIN; break;
1166  01a3 ae500f        	ldw	x,#20495
1167  01a6 1f01          	ldw	(OFST-2,sp),x
1171  01a8 a608          	ld	a,#8
1172  01aa 6b03          	ld	(OFST+0,sp),a
1176  01ac 2014          	jra	L705
1177  01ae               L563:
1178                     ; 183         case 3: port = DI3_PORT; pin = DI3_PIN; break;
1180  01ae ae500f        	ldw	x,#20495
1181  01b1 1f01          	ldw	(OFST-2,sp),x
1185  01b3 a610          	ld	a,#16
1186  01b5 6b03          	ld	(OFST+0,sp),a
1190  01b7 2009          	jra	L705
1191  01b9               L763:
1192                     ; 184         case 4: port = DI4_PORT; pin = DI4_PIN; break;
1194  01b9 ae500f        	ldw	x,#20495
1195  01bc 1f01          	ldw	(OFST-2,sp),x
1199  01be a680          	ld	a,#128
1200  01c0 6b03          	ld	(OFST+0,sp),a
1204  01c2               L705:
1205                     ; 187     return (GPIO_ReadInputPin(port, pin) == SET) ? 1 : 0;
1207  01c2 7b03          	ld	a,(OFST+0,sp)
1208  01c4 88            	push	a
1209  01c5 1e02          	ldw	x,(OFST-1,sp)
1210  01c7 cd0000        	call	_GPIO_ReadInputPin
1212  01ca 5b01          	addw	sp,#1
1213  01cc a101          	cp	a,#1
1214  01ce 2604          	jrne	L47
1215  01d0 a601          	ld	a,#1
1216  01d2 2001          	jra	L67
1217  01d4               L47:
1218  01d4 4f            	clr	a
1219  01d5               L67:
1221  01d5               L001:
1223  01d5 5b03          	addw	sp,#3
1224  01d7 81            	ret
1297                     ; 190 static char* u16_to_str(char *p, uint16_t value)
1297                     ; 191 {
1298                     	switch	.text
1299  01d8               L115_u16_to_str:
1301  01d8 89            	pushw	x
1302  01d9 5209          	subw	sp,#9
1303       00000009      OFST:	set	9
1306                     ; 193     uint8_t i = 0;
1308  01db 0f09          	clr	(OFST+0,sp)
1310                     ; 196     if(value == 0)
1312  01dd 1e0e          	ldw	x,(OFST+5,sp)
1313  01df 263d          	jrne	L555
1314                     ; 198         *p++ = '0';
1316  01e1 1e0a          	ldw	x,(OFST+1,sp)
1317  01e3 1c0001        	addw	x,#1
1318  01e6 1f0a          	ldw	(OFST+1,sp),x
1319  01e8 1d0001        	subw	x,#1
1320  01eb a630          	ld	a,#48
1321  01ed f7            	ld	(x),a
1322                     ; 199         return p;
1324  01ee 1e0a          	ldw	x,(OFST+1,sp)
1326  01f0 2058          	jra	L401
1327  01f2               L355:
1328                     ; 204         temp[i++] = (value % 10) + '0';
1330  01f2 1e0e          	ldw	x,(OFST+5,sp)
1331  01f4 a60a          	ld	a,#10
1332  01f6 62            	div	x,a
1333  01f7 5f            	clrw	x
1334  01f8 97            	ld	xl,a
1335  01f9 1c0030        	addw	x,#48
1336  01fc 9096          	ldw	y,sp
1337  01fe 72a90003      	addw	y,#OFST-6
1338  0202 1701          	ldw	(OFST-8,sp),y
1340  0204 7b09          	ld	a,(OFST+0,sp)
1341  0206 9097          	ld	yl,a
1342  0208 0c09          	inc	(OFST+0,sp)
1344  020a 909f          	ld	a,yl
1345  020c 905f          	clrw	y
1346  020e 9097          	ld	yl,a
1347  0210 72f901        	addw	y,(OFST-8,sp)
1348  0213 01            	rrwa	x,a
1349  0214 90f7          	ld	(y),a
1350  0216 02            	rlwa	x,a
1351                     ; 205         value /= 10;
1353  0217 1e0e          	ldw	x,(OFST+5,sp)
1354  0219 a60a          	ld	a,#10
1355  021b 62            	div	x,a
1356  021c 1f0e          	ldw	(OFST+5,sp),x
1357  021e               L555:
1358                     ; 202     while(value)
1360  021e 1e0e          	ldw	x,(OFST+5,sp)
1361  0220 26d0          	jrne	L355
1362                     ; 208     for(j = i; j > 0; j--)
1364  0222 7b09          	ld	a,(OFST+0,sp)
1365  0224 6b09          	ld	(OFST+0,sp),a
1368  0226 201c          	jra	L565
1369  0228               L165:
1370                     ; 210         *p++ = temp[j - 1];
1372  0228 96            	ldw	x,sp
1373  0229 1c0003        	addw	x,#OFST-6
1374  022c 1f01          	ldw	(OFST-8,sp),x
1376  022e 7b09          	ld	a,(OFST+0,sp)
1377  0230 5f            	clrw	x
1378  0231 97            	ld	xl,a
1379  0232 5a            	decw	x
1380  0233 72fb01        	addw	x,(OFST-8,sp)
1381  0236 f6            	ld	a,(x)
1382  0237 1e0a          	ldw	x,(OFST+1,sp)
1383  0239 1c0001        	addw	x,#1
1384  023c 1f0a          	ldw	(OFST+1,sp),x
1385  023e 1d0001        	subw	x,#1
1386  0241 f7            	ld	(x),a
1387                     ; 208     for(j = i; j > 0; j--)
1389  0242 0a09          	dec	(OFST+0,sp)
1391  0244               L565:
1394  0244 0d09          	tnz	(OFST+0,sp)
1395  0246 26e0          	jrne	L165
1396                     ; 213     return p;
1398  0248 1e0a          	ldw	x,(OFST+1,sp)
1400  024a               L401:
1402  024a 5b0b          	addw	sp,#11
1403  024c 81            	ret
1476                     .const:	section	.text
1477  0000               L011:
1478  0000 0000000a      	dc.l	10
1479                     ; 216 static char* u32_to_str(char *p, uint32_t value)
1479                     ; 217 {
1480                     	switch	.text
1481  024d               L175_u32_to_str:
1483  024d 89            	pushw	x
1484  024e 520d          	subw	sp,#13
1485       0000000d      OFST:	set	13
1488                     ; 219     uint8_t i = 0;
1490  0250 0f0d          	clr	(OFST+0,sp)
1492                     ; 222     if(value == 0)
1494  0252 96            	ldw	x,sp
1495  0253 1c0012        	addw	x,#OFST+5
1496  0256 cd0000        	call	c_lzmp
1498  0259 264b          	jrne	L536
1499                     ; 224         *p++ = '0';
1501  025b 1e0e          	ldw	x,(OFST+1,sp)
1502  025d 1c0001        	addw	x,#1
1503  0260 1f0e          	ldw	(OFST+1,sp),x
1504  0262 1d0001        	subw	x,#1
1505  0265 a630          	ld	a,#48
1506  0267 f7            	ld	(x),a
1507                     ; 225         return p;
1509  0268 1e0e          	ldw	x,(OFST+1,sp)
1511  026a 206b          	jra	L211
1512  026c               L336:
1513                     ; 230         temp[i++] = (value % 10) + '0';
1515  026c 96            	ldw	x,sp
1516  026d 1c0012        	addw	x,#OFST+5
1517  0270 cd0000        	call	c_ltor
1519  0273 ae0000        	ldw	x,#L011
1520  0276 cd0000        	call	c_lumd
1522  0279 a630          	ld	a,#48
1523  027b cd0000        	call	c_ladc
1525  027e 96            	ldw	x,sp
1526  027f 1c0003        	addw	x,#OFST-10
1527  0282 1f01          	ldw	(OFST-12,sp),x
1529  0284 7b0d          	ld	a,(OFST+0,sp)
1530  0286 97            	ld	xl,a
1531  0287 0c0d          	inc	(OFST+0,sp)
1533  0289 9f            	ld	a,xl
1534  028a 5f            	clrw	x
1535  028b 97            	ld	xl,a
1536  028c 72fb01        	addw	x,(OFST-12,sp)
1537  028f b603          	ld	a,c_lreg+3
1538  0291 f7            	ld	(x),a
1539                     ; 231         value /= 10;
1541  0292 96            	ldw	x,sp
1542  0293 1c0012        	addw	x,#OFST+5
1543  0296 cd0000        	call	c_ltor
1545  0299 ae0000        	ldw	x,#L011
1546  029c cd0000        	call	c_ludv
1548  029f 96            	ldw	x,sp
1549  02a0 1c0012        	addw	x,#OFST+5
1550  02a3 cd0000        	call	c_rtol
1552  02a6               L536:
1553                     ; 228     while(value)
1555  02a6 96            	ldw	x,sp
1556  02a7 1c0012        	addw	x,#OFST+5
1557  02aa cd0000        	call	c_lzmp
1559  02ad 26bd          	jrne	L336
1560                     ; 234     for(j = i; j > 0; j--)
1562  02af 7b0d          	ld	a,(OFST+0,sp)
1563  02b1 6b0d          	ld	(OFST+0,sp),a
1566  02b3 201c          	jra	L546
1567  02b5               L146:
1568                     ; 236         *p++ = temp[j - 1];
1570  02b5 96            	ldw	x,sp
1571  02b6 1c0003        	addw	x,#OFST-10
1572  02b9 1f01          	ldw	(OFST-12,sp),x
1574  02bb 7b0d          	ld	a,(OFST+0,sp)
1575  02bd 5f            	clrw	x
1576  02be 97            	ld	xl,a
1577  02bf 5a            	decw	x
1578  02c0 72fb01        	addw	x,(OFST-12,sp)
1579  02c3 f6            	ld	a,(x)
1580  02c4 1e0e          	ldw	x,(OFST+1,sp)
1581  02c6 1c0001        	addw	x,#1
1582  02c9 1f0e          	ldw	(OFST+1,sp),x
1583  02cb 1d0001        	subw	x,#1
1584  02ce f7            	ld	(x),a
1585                     ; 234     for(j = i; j > 0; j--)
1587  02cf 0a0d          	dec	(OFST+0,sp)
1589  02d1               L546:
1592  02d1 0d0d          	tnz	(OFST+0,sp)
1593  02d3 26e0          	jrne	L146
1594                     ; 239     return p;
1596  02d5 1e0e          	ldw	x,(OFST+1,sp)
1598  02d7               L211:
1600  02d7 5b0f          	addw	sp,#15
1601  02d9 81            	ret
1685                     ; 242 void message_formatter_avcc(char *buf,
1685                     ; 243                             int buf_size,
1685                     ; 244                             uint16_t lanid,
1685                     ; 245                             uint32_t seqn,
1685                     ; 246                             uint16_t axle_count)
1685                     ; 247 {
1686                     	switch	.text
1687  02da               _message_formatter_avcc:
1689  02da 89            	pushw	x
1690  02db 89            	pushw	x
1691       00000002      OFST:	set	2
1694                     ; 250     if(buf == 0)
1696  02dc a30000        	cpw	x,#0
1697  02df 2708          	jreq	L611
1698                     ; 251         return;
1700                     ; 253     if(buf_size < 40)
1702  02e1 9c            	rvf
1703  02e2 1e07          	ldw	x,(OFST+5,sp)
1704  02e4 a30028        	cpw	x,#40
1705  02e7 2e03          	jrsge	L517
1706                     ; 254         return;
1707  02e9               L611:
1710  02e9 5b04          	addw	sp,#4
1711  02eb 81            	ret
1712  02ec               L517:
1713                     ; 256     p = buf;
1715  02ec 1e03          	ldw	x,(OFST+1,sp)
1716  02ee 1f01          	ldw	(OFST-1,sp),x
1718                     ; 259     *p++ = 'S';
1720  02f0 1e01          	ldw	x,(OFST-1,sp)
1721  02f2 1c0001        	addw	x,#1
1722  02f5 1f01          	ldw	(OFST-1,sp),x
1723  02f7 1d0001        	subw	x,#1
1725  02fa a653          	ld	a,#83
1726  02fc f7            	ld	(x),a
1727                     ; 260     *p++ = 'T';
1729  02fd 1e01          	ldw	x,(OFST-1,sp)
1730  02ff 1c0001        	addw	x,#1
1731  0302 1f01          	ldw	(OFST-1,sp),x
1732  0304 1d0001        	subw	x,#1
1734  0307 a654          	ld	a,#84
1735  0309 f7            	ld	(x),a
1736                     ; 261     *p++ = 'A';
1738  030a 1e01          	ldw	x,(OFST-1,sp)
1739  030c 1c0001        	addw	x,#1
1740  030f 1f01          	ldw	(OFST-1,sp),x
1741  0311 1d0001        	subw	x,#1
1743  0314 a641          	ld	a,#65
1744  0316 f7            	ld	(x),a
1745                     ; 262     *p++ = 'R';
1747  0317 1e01          	ldw	x,(OFST-1,sp)
1748  0319 1c0001        	addw	x,#1
1749  031c 1f01          	ldw	(OFST-1,sp),x
1750  031e 1d0001        	subw	x,#1
1752  0321 a652          	ld	a,#82
1753  0323 f7            	ld	(x),a
1754                     ; 263     *p++ = 'T';
1756  0324 1e01          	ldw	x,(OFST-1,sp)
1757  0326 1c0001        	addw	x,#1
1758  0329 1f01          	ldw	(OFST-1,sp),x
1759  032b 1d0001        	subw	x,#1
1761  032e a654          	ld	a,#84
1762  0330 f7            	ld	(x),a
1763                     ; 264     *p++ = ',';
1765  0331 1e01          	ldw	x,(OFST-1,sp)
1766  0333 1c0001        	addw	x,#1
1767  0336 1f01          	ldw	(OFST-1,sp),x
1768  0338 1d0001        	subw	x,#1
1770  033b a62c          	ld	a,#44
1771  033d f7            	ld	(x),a
1772                     ; 265     *p++ = 'A';
1774  033e 1e01          	ldw	x,(OFST-1,sp)
1775  0340 1c0001        	addw	x,#1
1776  0343 1f01          	ldw	(OFST-1,sp),x
1777  0345 1d0001        	subw	x,#1
1779  0348 a641          	ld	a,#65
1780  034a f7            	ld	(x),a
1781                     ; 266     *p++ = 'V';
1783  034b 1e01          	ldw	x,(OFST-1,sp)
1784  034d 1c0001        	addw	x,#1
1785  0350 1f01          	ldw	(OFST-1,sp),x
1786  0352 1d0001        	subw	x,#1
1788  0355 a656          	ld	a,#86
1789  0357 f7            	ld	(x),a
1790                     ; 267     *p++ = 'C';
1792  0358 1e01          	ldw	x,(OFST-1,sp)
1793  035a 1c0001        	addw	x,#1
1794  035d 1f01          	ldw	(OFST-1,sp),x
1795  035f 1d0001        	subw	x,#1
1797  0362 a643          	ld	a,#67
1798  0364 f7            	ld	(x),a
1799                     ; 268     *p++ = 'C';
1801  0365 1e01          	ldw	x,(OFST-1,sp)
1802  0367 1c0001        	addw	x,#1
1803  036a 1f01          	ldw	(OFST-1,sp),x
1804  036c 1d0001        	subw	x,#1
1806  036f a643          	ld	a,#67
1807  0371 f7            	ld	(x),a
1808                     ; 269     *p++ = ',';
1810  0372 1e01          	ldw	x,(OFST-1,sp)
1811  0374 1c0001        	addw	x,#1
1812  0377 1f01          	ldw	(OFST-1,sp),x
1813  0379 1d0001        	subw	x,#1
1815  037c a62c          	ld	a,#44
1816  037e f7            	ld	(x),a
1817                     ; 271     p = u16_to_str(p, lanid);
1819  037f 1e09          	ldw	x,(OFST+7,sp)
1820  0381 89            	pushw	x
1821  0382 1e03          	ldw	x,(OFST+1,sp)
1822  0384 cd01d8        	call	L115_u16_to_str
1824  0387 5b02          	addw	sp,#2
1825  0389 1f01          	ldw	(OFST-1,sp),x
1827                     ; 273     *p++ = ',';
1829  038b 1e01          	ldw	x,(OFST-1,sp)
1830  038d 1c0001        	addw	x,#1
1831  0390 1f01          	ldw	(OFST-1,sp),x
1832  0392 1d0001        	subw	x,#1
1834  0395 a62c          	ld	a,#44
1835  0397 f7            	ld	(x),a
1836                     ; 275     p = u32_to_str(p, seqn);
1838  0398 1e0d          	ldw	x,(OFST+11,sp)
1839  039a 89            	pushw	x
1840  039b 1e0d          	ldw	x,(OFST+11,sp)
1841  039d 89            	pushw	x
1842  039e 1e05          	ldw	x,(OFST+3,sp)
1843  03a0 cd024d        	call	L175_u32_to_str
1845  03a3 5b04          	addw	sp,#4
1846  03a5 1f01          	ldw	(OFST-1,sp),x
1848                     ; 277     *p++ = ',';
1850  03a7 1e01          	ldw	x,(OFST-1,sp)
1851  03a9 1c0001        	addw	x,#1
1852  03ac 1f01          	ldw	(OFST-1,sp),x
1853  03ae 1d0001        	subw	x,#1
1855  03b1 a62c          	ld	a,#44
1856  03b3 f7            	ld	(x),a
1857                     ; 278     *p++ = 'A';
1859  03b4 1e01          	ldw	x,(OFST-1,sp)
1860  03b6 1c0001        	addw	x,#1
1861  03b9 1f01          	ldw	(OFST-1,sp),x
1862  03bb 1d0001        	subw	x,#1
1864  03be a641          	ld	a,#65
1865  03c0 f7            	ld	(x),a
1866                     ; 279     *p++ = 'X';
1868  03c1 1e01          	ldw	x,(OFST-1,sp)
1869  03c3 1c0001        	addw	x,#1
1870  03c6 1f01          	ldw	(OFST-1,sp),x
1871  03c8 1d0001        	subw	x,#1
1873  03cb a658          	ld	a,#88
1874  03cd f7            	ld	(x),a
1875                     ; 280     *p++ = 'L';
1877  03ce 1e01          	ldw	x,(OFST-1,sp)
1878  03d0 1c0001        	addw	x,#1
1879  03d3 1f01          	ldw	(OFST-1,sp),x
1880  03d5 1d0001        	subw	x,#1
1882  03d8 a64c          	ld	a,#76
1883  03da f7            	ld	(x),a
1884                     ; 281     *p++ = 'E';
1886  03db 1e01          	ldw	x,(OFST-1,sp)
1887  03dd 1c0001        	addw	x,#1
1888  03e0 1f01          	ldw	(OFST-1,sp),x
1889  03e2 1d0001        	subw	x,#1
1891  03e5 a645          	ld	a,#69
1892  03e7 f7            	ld	(x),a
1893                     ; 282     *p++ = ',';
1895  03e8 1e01          	ldw	x,(OFST-1,sp)
1896  03ea 1c0001        	addw	x,#1
1897  03ed 1f01          	ldw	(OFST-1,sp),x
1898  03ef 1d0001        	subw	x,#1
1900  03f2 a62c          	ld	a,#44
1901  03f4 f7            	ld	(x),a
1902                     ; 284     p = u16_to_str(p, axle_count);
1904  03f5 1e0f          	ldw	x,(OFST+13,sp)
1905  03f7 89            	pushw	x
1906  03f8 1e03          	ldw	x,(OFST+1,sp)
1907  03fa cd01d8        	call	L115_u16_to_str
1909  03fd 5b02          	addw	sp,#2
1910  03ff 1f01          	ldw	(OFST-1,sp),x
1912                     ; 286     *p++ = ',';
1914  0401 1e01          	ldw	x,(OFST-1,sp)
1915  0403 1c0001        	addw	x,#1
1916  0406 1f01          	ldw	(OFST-1,sp),x
1917  0408 1d0001        	subw	x,#1
1919  040b a62c          	ld	a,#44
1920  040d f7            	ld	(x),a
1921                     ; 287     *p++ = 'E';
1923  040e 1e01          	ldw	x,(OFST-1,sp)
1924  0410 1c0001        	addw	x,#1
1925  0413 1f01          	ldw	(OFST-1,sp),x
1926  0415 1d0001        	subw	x,#1
1928  0418 a645          	ld	a,#69
1929  041a f7            	ld	(x),a
1930                     ; 288     *p++ = 'N';
1932  041b 1e01          	ldw	x,(OFST-1,sp)
1933  041d 1c0001        	addw	x,#1
1934  0420 1f01          	ldw	(OFST-1,sp),x
1935  0422 1d0001        	subw	x,#1
1937  0425 a64e          	ld	a,#78
1938  0427 f7            	ld	(x),a
1939                     ; 289     *p++ = 'D';
1941  0428 1e01          	ldw	x,(OFST-1,sp)
1942  042a 1c0001        	addw	x,#1
1943  042d 1f01          	ldw	(OFST-1,sp),x
1944  042f 1d0001        	subw	x,#1
1946  0432 a644          	ld	a,#68
1947  0434 f7            	ld	(x),a
1948                     ; 291     *p = '\0';
1950  0435 1e01          	ldw	x,(OFST-1,sp)
1951  0437 7f            	clr	(x)
1952                     ; 292 }
1954  0438 ace902e9      	jpf	L611
2051                     ; 294 void hal_relay_set(uint8_t relay_num, uint8_t state){
2052                     	switch	.text
2053  043c               _hal_relay_set:
2055  043c 89            	pushw	x
2056  043d 5204          	subw	sp,#4
2057       00000004      OFST:	set	4
2060                     ; 297 	BitStatus bit_state = (state == 0) ? SET : RESET;
2062  043f 9f            	ld	a,xl
2063  0440 4d            	tnz	a
2064  0441 2605          	jrne	L221
2065  0443 ae0001        	ldw	x,#1
2066  0446 2001          	jra	L421
2067  0448               L221:
2068  0448 5f            	clrw	x
2069  0449               L421:
2070  0449 01            	rrwa	x,a
2071  044a 6b01          	ld	(OFST-3,sp),a
2072  044c 02            	rlwa	x,a
2074                     ; 299 	switch (relay_num) {
2076  044d 7b05          	ld	a,(OFST+1,sp)
2078                     ; 306         default: return;
2079  044f 4a            	dec	a
2080  0450 2711          	jreq	L717
2081  0452 4a            	dec	a
2082  0453 2719          	jreq	L127
2083  0455 4a            	dec	a
2084  0456 2721          	jreq	L327
2085  0458 4a            	dec	a
2086  0459 2729          	jreq	L527
2087  045b 4a            	dec	a
2088  045c 2731          	jreq	L727
2089  045e 4a            	dec	a
2090  045f 2739          	jreq	L137
2091  0461               L337:
2094  0461 205a          	jra	L621
2095  0463               L717:
2096                     ; 300         case 1: port = RELAY1_PORT; pin = RELAY1_PIN; break;
2098  0463 ae5005        	ldw	x,#20485
2099  0466 1f02          	ldw	(OFST-2,sp),x
2103  0468 a608          	ld	a,#8
2104  046a 6b04          	ld	(OFST+0,sp),a
2108  046c 2035          	jra	L7001
2109  046e               L127:
2110                     ; 301         case 2: port = RELAY2_PORT; pin = RELAY2_PIN; break;
2112  046e ae5005        	ldw	x,#20485
2113  0471 1f02          	ldw	(OFST-2,sp),x
2117  0473 a604          	ld	a,#4
2118  0475 6b04          	ld	(OFST+0,sp),a
2122  0477 202a          	jra	L7001
2123  0479               L327:
2124                     ; 302         case 3: port = RELAY3_PORT; pin = RELAY3_PIN; break;
2126  0479 ae5005        	ldw	x,#20485
2127  047c 1f02          	ldw	(OFST-2,sp),x
2131  047e a602          	ld	a,#2
2132  0480 6b04          	ld	(OFST+0,sp),a
2136  0482 201f          	jra	L7001
2137  0484               L527:
2138                     ; 303         case 4: port = RELAY4_PORT; pin = RELAY4_PIN; break;
2140  0484 ae5005        	ldw	x,#20485
2141  0487 1f02          	ldw	(OFST-2,sp),x
2145  0489 a601          	ld	a,#1
2146  048b 6b04          	ld	(OFST+0,sp),a
2150  048d 2014          	jra	L7001
2151  048f               L727:
2152                     ; 304         case 5: port = RELAY5_PORT; pin = RELAY5_PIN; break;
2154  048f ae500a        	ldw	x,#20490
2155  0492 1f02          	ldw	(OFST-2,sp),x
2159  0494 a608          	ld	a,#8
2160  0496 6b04          	ld	(OFST+0,sp),a
2164  0498 2009          	jra	L7001
2165  049a               L137:
2166                     ; 305         case 6: port = RELAY6_PORT; pin = RELAY6_PIN; break;
2168  049a ae500a        	ldw	x,#20490
2169  049d 1f02          	ldw	(OFST-2,sp),x
2173  049f a610          	ld	a,#16
2174  04a1 6b04          	ld	(OFST+0,sp),a
2178  04a3               L7001:
2179                     ; 309 	if (bit_state == SET) {
2181  04a3 7b01          	ld	a,(OFST-3,sp)
2182  04a5 a101          	cp	a,#1
2183  04a7 260b          	jrne	L1101
2184                     ; 310         GPIO_WriteHigh(port, pin);  /* Set HIGH = relay off */
2186  04a9 7b04          	ld	a,(OFST+0,sp)
2187  04ab 88            	push	a
2188  04ac 1e03          	ldw	x,(OFST-1,sp)
2189  04ae cd0000        	call	_GPIO_WriteHigh
2191  04b1 84            	pop	a
2193  04b2 2009          	jra	L3101
2194  04b4               L1101:
2195                     ; 312         GPIO_WriteLow(port, pin); /* Set LOW = relay on */
2197  04b4 7b04          	ld	a,(OFST+0,sp)
2198  04b6 88            	push	a
2199  04b7 1e03          	ldw	x,(OFST-1,sp)
2200  04b9 cd0000        	call	_GPIO_WriteLow
2202  04bc 84            	pop	a
2203  04bd               L3101:
2204                     ; 314 }
2205  04bd               L621:
2208  04bd 5b06          	addw	sp,#6
2209  04bf 81            	ret
2253                     ; 316 void relay_control_set(uint8_t relay_num, uint8_t state)
2253                     ; 317 {
2254                     	switch	.text
2255  04c0               _relay_control_set:
2257  04c0 89            	pushw	x
2258       00000000      OFST:	set	0
2261                     ; 318     if (relay_num >= 1 && relay_num <= 6) {
2263  04c1 9e            	ld	a,xh
2264  04c2 4d            	tnz	a
2265  04c3 270d          	jreq	L7301
2267  04c5 9e            	ld	a,xh
2268  04c6 a107          	cp	a,#7
2269  04c8 2408          	jruge	L7301
2270                     ; 319         hal_relay_set(relay_num, state);
2272  04ca 9f            	ld	a,xl
2273  04cb 97            	ld	xl,a
2274  04cc 7b01          	ld	a,(OFST+1,sp)
2275  04ce 95            	ld	xh,a
2276  04cf cd043c        	call	_hal_relay_set
2278  04d2               L7301:
2279                     ; 321 }
2282  04d2 85            	popw	x
2283  04d3 81            	ret
2319                     ; 323 void relay_control_set_all(uint8_t state)
2319                     ; 324 {
2320                     	switch	.text
2321  04d4               _relay_control_set_all:
2323  04d4 88            	push	a
2324       00000000      OFST:	set	0
2327                     ; 325     relay_control_set(1, state);
2329  04d5 ae0100        	ldw	x,#256
2330  04d8 97            	ld	xl,a
2331  04d9 ade5          	call	_relay_control_set
2333                     ; 326     relay_control_set(2, state);
2335  04db 7b01          	ld	a,(OFST+1,sp)
2336  04dd ae0200        	ldw	x,#512
2337  04e0 97            	ld	xl,a
2338  04e1 addd          	call	_relay_control_set
2340                     ; 327     relay_control_set(3, state);
2342  04e3 7b01          	ld	a,(OFST+1,sp)
2343  04e5 ae0300        	ldw	x,#768
2344  04e8 97            	ld	xl,a
2345  04e9 add5          	call	_relay_control_set
2347                     ; 328     relay_control_set(4, state);
2349  04eb 7b01          	ld	a,(OFST+1,sp)
2350  04ed ae0400        	ldw	x,#1024
2351  04f0 97            	ld	xl,a
2352  04f1 adcd          	call	_relay_control_set
2354                     ; 329     relay_control_set(5, state);
2356  04f3 7b01          	ld	a,(OFST+1,sp)
2357  04f5 ae0500        	ldw	x,#1280
2358  04f8 97            	ld	xl,a
2359  04f9 adc5          	call	_relay_control_set
2361                     ; 330     relay_control_set(6, state);
2363  04fb 7b01          	ld	a,(OFST+1,sp)
2364  04fd ae0600        	ldw	x,#1536
2365  0500 97            	ld	xl,a
2366  0501 adbd          	call	_relay_control_set
2368                     ; 331 }
2371  0503 84            	pop	a
2372  0504 81            	ret
2398                     ; 333 void sensor_reader_update(void){
2399                     	switch	.text
2400  0505               _sensor_reader_update:
2404                     ; 334     current_state.di1 = hal_di_read(1);
2406  0505 a601          	ld	a,#1
2407  0507 cd0187        	call	_hal_di_read
2409  050a b714          	ld	L7_current_state,a
2410                     ; 335     current_state.di2 = hal_di_read(2);
2412  050c a602          	ld	a,#2
2413  050e cd0187        	call	_hal_di_read
2415  0511 b715          	ld	L7_current_state+1,a
2416                     ; 336     current_state.di3 = hal_di_read(3);
2418  0513 a603          	ld	a,#3
2419  0515 cd0187        	call	_hal_di_read
2421  0518 b716          	ld	L7_current_state+2,a
2422                     ; 337     current_state.di4 = hal_di_read(4);
2424  051a a604          	ld	a,#4
2425  051c cd0187        	call	_hal_di_read
2427  051f b717          	ld	L7_current_state+3,a
2428                     ; 338 }
2431  0521 81            	ret
2455                     ; 341 void hal_timer_start(void)
2455                     ; 342 {
2456                     	switch	.text
2457  0522               _hal_timer_start:
2461                     ; 343     TIM4_Cmd(ENABLE);
2463  0522 a601          	ld	a,#1
2464  0524 cd0000        	call	_TIM4_Cmd
2466                     ; 344 }
2469  0527 81            	ret
2530                     ; 349 void process_axle_counting(void){
2531                     	switch	.text
2532  0528               _process_axle_counting:
2534  0528 525a          	subw	sp,#90
2535       0000005a      OFST:	set	90
2538                     ; 350     sensor_state_t sensor = sensor_reader_get_state();
2540  052a 96            	ldw	x,sp
2541  052b 1c0057        	addw	x,#OFST-3
2542  052e 89            	pushw	x
2543  052f cd00ce        	call	_sensor_reader_get_state
2545  0532 85            	popw	x
2546                     ; 353     if(sensor.di1 == 1 && axle_counter.prev_di1_state == 0){
2548  0533 7b57          	ld	a,(OFST-3,sp)
2549  0535 a101          	cp	a,#1
2550  0537 260a          	jrne	L5211
2552  0539 3d03          	tnz	L3_axle_counter+3
2553  053b 2606          	jrne	L5211
2554                     ; 354         axle_counter.loop_active = 1;
2556  053d 35010000      	mov	L3_axle_counter,#1
2557                     ; 355         axle_counter.axle_count = 0;
2559  0541 3f02          	clr	L3_axle_counter+2
2560  0543               L5211:
2561                     ; 358     if(axle_counter.loop_active){
2563  0543 3d00          	tnz	L3_axle_counter
2564  0545 2710          	jreq	L7211
2565                     ; 359         if(sensor.di2 == 1 && axle_counter.prev_di2_state == 0){
2567  0547 7b58          	ld	a,(OFST-2,sp)
2568  0549 a101          	cp	a,#1
2569  054b 2606          	jrne	L1311
2571  054d 3d01          	tnz	L3_axle_counter+1
2572  054f 2602          	jrne	L1311
2573                     ; 360             axle_counter.axle_count++;
2575  0551 3c02          	inc	L3_axle_counter+2
2576  0553               L1311:
2577                     ; 362         axle_counter.prev_di2_state = sensor.di2;
2579  0553 7b58          	ld	a,(OFST-2,sp)
2580  0555 b701          	ld	L3_axle_counter+1,a
2581  0557               L7211:
2582                     ; 366     if (sensor.di1 == 0 && axle_counter.prev_di1_state == 1 && axle_counter.loop_active){
2584  0557 0d57          	tnz	(OFST-3,sp)
2585  0559 264f          	jrne	L3311
2587  055b b603          	ld	a,L3_axle_counter+3
2588  055d a101          	cp	a,#1
2589  055f 2649          	jrne	L3311
2591  0561 3d00          	tnz	L3_axle_counter
2592  0563 2745          	jreq	L3311
2593                     ; 367         uint16_t axle_final_count = axle_counter.axle_count / 2;
2595  0565 b602          	ld	a,L3_axle_counter+2
2596  0567 5f            	clrw	x
2597  0568 97            	ld	xl,a
2598  0569 57            	sraw	x
2599  056a 1f05          	ldw	(OFST-85,sp),x
2601                     ; 370         message_formatter_avcc(msg_buf, sizeof(msg_buf),DEVICE_LANID,axle_counter.embedded_seq_num,axle_final_count);
2603  056c 1e05          	ldw	x,(OFST-85,sp)
2604  056e 89            	pushw	x
2605  056f be06          	ldw	x,L3_axle_counter+6
2606  0571 89            	pushw	x
2607  0572 be04          	ldw	x,L3_axle_counter+4
2608  0574 89            	pushw	x
2609  0575 ae007d        	ldw	x,#125
2610  0578 89            	pushw	x
2611  0579 ae0050        	ldw	x,#80
2612  057c 89            	pushw	x
2613  057d 96            	ldw	x,sp
2614  057e 1c0011        	addw	x,#OFST-73
2615  0581 cd02da        	call	_message_formatter_avcc
2617  0584 5b0a          	addw	sp,#10
2618                     ; 372         if(uart_server_is_ready()){
2620  0586 cd0041        	call	_uart_server_is_ready
2622  0589 a30000        	cpw	x,#0
2623  058c 2710          	jreq	L5311
2624                     ; 373             uart_server_send((uint8_t *)msg_buf, strlen(msg_buf));
2626  058e 96            	ldw	x,sp
2627  058f 1c0007        	addw	x,#OFST-83
2628  0592 cd0000        	call	_strlen
2630  0595 89            	pushw	x
2631  0596 96            	ldw	x,sp
2632  0597 1c0009        	addw	x,#OFST-81
2633  059a cd0099        	call	_uart_server_send
2635  059d 85            	popw	x
2636  059e               L5311:
2637                     ; 376         axle_counter.embedded_seq_num++;
2639  059e ae0004        	ldw	x,#L3_axle_counter+4
2640  05a1 a601          	ld	a,#1
2641  05a3 cd0000        	call	c_lgadc
2643                     ; 377         axle_counter.loop_active = 0;
2645  05a6 3f00          	clr	L3_axle_counter
2646                     ; 378         axle_counter.axle_count = 0;
2648  05a8 3f02          	clr	L3_axle_counter+2
2649  05aa               L3311:
2650                     ; 380     axle_counter.prev_di1_state = sensor.di1;
2652  05aa 7b57          	ld	a,(OFST-3,sp)
2653  05ac b703          	ld	L3_axle_counter+3,a
2654                     ; 381 }
2657  05ae 5b5a          	addw	sp,#90
2658  05b0 81            	ret
2682                     ; 382 void sensor_reader_init(void)
2682                     ; 383 {
2683                     	switch	.text
2684  05b1               _sensor_reader_init:
2688                     ; 385     sensor_reader_update();
2690  05b1 cd0505        	call	_sensor_reader_update
2692                     ; 386 }
2695  05b4 81            	ret
2745                     ; 388 void send_alive_message(void)
2745                     ; 389 {
2746                     	switch	.text
2747  05b5               _send_alive_message:
2749  05b5 52ff          	subw	sp,#255
2750  05b7 5215          	subw	sp,#21
2751       00000114      OFST:	set	276
2754                     ; 393     sensor = sensor_reader_get_state();
2756  05b9 96            	ldw	x,sp
2757  05ba 1c0111        	addw	x,#OFST-3
2758  05bd 89            	pushw	x
2759  05be cd00ce        	call	_sensor_reader_get_state
2761  05c1 85            	popw	x
2762                     ; 395     message_formatter_alive(
2762                     ; 396         msg_buf,
2762                     ; 397         sizeof(msg_buf),
2762                     ; 398         sensor.di1,
2762                     ; 399         sensor.di2,
2762                     ; 400         sensor.di3,
2762                     ; 401         sensor.di4
2762                     ; 402     );
2764  05c2 96            	ldw	x,sp
2765  05c3 d60114        	ld	a,(OFST+0,x)
2766  05c6 88            	push	a
2767  05c7 96            	ldw	x,sp
2768  05c8 d60114        	ld	a,(OFST+0,x)
2769  05cb 88            	push	a
2770  05cc 96            	ldw	x,sp
2771  05cd d60114        	ld	a,(OFST+0,x)
2772  05d0 88            	push	a
2773  05d1 96            	ldw	x,sp
2774  05d2 d60114        	ld	a,(OFST+0,x)
2775  05d5 88            	push	a
2776  05d6 ae0100        	ldw	x,#256
2777  05d9 89            	pushw	x
2778  05da 96            	ldw	x,sp
2779  05db 1c0017        	addw	x,#OFST-253
2780  05de cd00da        	call	_message_formatter_alive
2782  05e1 5b06          	addw	sp,#6
2783                     ; 404     if (uart_server_is_ready())
2785  05e3 cd0041        	call	_uart_server_is_ready
2787  05e6 a30000        	cpw	x,#0
2788  05e9 2710          	jreq	L1711
2789                     ; 406         uart_server_send((uint8_t *)msg_buf, strlen(msg_buf));
2791  05eb 96            	ldw	x,sp
2792  05ec 1c0011        	addw	x,#OFST-259
2793  05ef cd0000        	call	_strlen
2795  05f2 89            	pushw	x
2796  05f3 96            	ldw	x,sp
2797  05f4 1c0013        	addw	x,#OFST-257
2798  05f7 cd0099        	call	_uart_server_send
2800  05fa 85            	popw	x
2801  05fb               L1711:
2802                     ; 408 }
2805  05fb 5bff          	addw	sp,#255
2806  05fd 5b15          	addw	sp,#21
2807  05ff 81            	ret
2835                     	switch	.const
2836  0004               L051:
2837  0004 00000032      	dc.l	50
2838  0008               L251:
2839  0008 000001f4      	dc.l	500
2840                     ; 410 void timer_callback(void){
2841                     	switch	.text
2842  0600               _timer_callback:
2846                     ; 411     task_timer.current_time = hal_get_millis();
2848  0600 cd0000        	call	_hal_get_millis
2850  0603 ae0010        	ldw	x,#L5_task_timer+8
2851  0606 cd0000        	call	c_rtol
2853                     ; 412     if ((task_timer.current_time - task_timer.last_sensor_time) >= SENSOR_READ_INTERVAL){
2855  0609 ae0010        	ldw	x,#L5_task_timer+8
2856  060c cd0000        	call	c_ltor
2858  060f ae000c        	ldw	x,#L5_task_timer+4
2859  0612 cd0000        	call	c_lsub
2861  0615 ae0004        	ldw	x,#L051
2862  0618 cd0000        	call	c_lcmp
2864  061b 250e          	jrult	L3021
2865                     ; 413         sensor_reader_update();
2867  061d cd0505        	call	_sensor_reader_update
2869                     ; 414         process_axle_counting();
2871  0620 cd0528        	call	_process_axle_counting
2873                     ; 415         task_timer.last_sensor_time = task_timer.current_time;
2875  0623 be12          	ldw	x,L5_task_timer+10
2876  0625 bf0e          	ldw	L5_task_timer+6,x
2877  0627 be10          	ldw	x,L5_task_timer+8
2878  0629 bf0c          	ldw	L5_task_timer+4,x
2879  062b               L3021:
2880                     ; 418     if ((task_timer.current_time - task_timer.last_alive_time) >= ALIVE_INTERVAL){
2882  062b ae0010        	ldw	x,#L5_task_timer+8
2883  062e cd0000        	call	c_ltor
2885  0631 ae0008        	ldw	x,#L5_task_timer
2886  0634 cd0000        	call	c_lsub
2888  0637 ae0008        	ldw	x,#L251
2889  063a cd0000        	call	c_lcmp
2891  063d 250b          	jrult	L5021
2892                     ; 419         send_alive_message();  
2894  063f cd05b5        	call	_send_alive_message
2896                     ; 420         task_timer.last_alive_time = task_timer.current_time;
2898  0642 be12          	ldw	x,L5_task_timer+10
2899  0644 bf0a          	ldw	L5_task_timer+2,x
2900  0646 be10          	ldw	x,L5_task_timer+8
2901  0648 bf08          	ldw	L5_task_timer,x
2902  064a               L5021:
2903                     ; 422 }
2906  064a 81            	ret
2944                     ; 424 void hal_timer_set_callback(timer_callback_t callback)
2944                     ; 425 {
2945                     	switch	.text
2946  064b               _hal_timer_set_callback:
2950                     ; 426     user_callback = callback;
2952  064b bf27          	ldw	L73_user_callback,x
2953                     ; 427 }
2956  064d 81            	ret
3020                     ; 429 int command_parser_execute(const char *cmd_str, int len)
3020                     ; 430 {
3021                     	switch	.text
3022  064e               _command_parser_execute:
3024  064e 89            	pushw	x
3025  064f 89            	pushw	x
3026       00000002      OFST:	set	2
3029                     ; 435     if (len < 4)
3031  0650 9c            	rvf
3032  0651 1e07          	ldw	x,(OFST+5,sp)
3033  0653 a30004        	cpw	x,#4
3034  0656 2e05          	jrsge	L7521
3035                     ; 436         return -1;
3037  0658 aeffff        	ldw	x,#65535
3039  065b 200a          	jra	L061
3040  065d               L7521:
3041                     ; 438     if (cmd_str[0] != 'R')
3043  065d 1e03          	ldw	x,(OFST+1,sp)
3044  065f f6            	ld	a,(x)
3045  0660 a152          	cp	a,#82
3046  0662 2706          	jreq	L1621
3047                     ; 439         return -1;
3049  0664 aeffff        	ldw	x,#65535
3051  0667               L061:
3053  0667 5b04          	addw	sp,#4
3054  0669 81            	ret
3055  066a               L1621:
3056                     ; 441     if (cmd_str[1] < '1' || cmd_str[1] > '6')
3058  066a 1e03          	ldw	x,(OFST+1,sp)
3059  066c e601          	ld	a,(1,x)
3060  066e a131          	cp	a,#49
3061  0670 2508          	jrult	L5621
3063  0672 1e03          	ldw	x,(OFST+1,sp)
3064  0674 e601          	ld	a,(1,x)
3065  0676 a137          	cp	a,#55
3066  0678 2505          	jrult	L3621
3067  067a               L5621:
3068                     ; 442         return -1;
3070  067a aeffff        	ldw	x,#65535
3072  067d 20e8          	jra	L061
3073  067f               L3621:
3074                     ; 444     if (cmd_str[2] != ',')
3076  067f 1e03          	ldw	x,(OFST+1,sp)
3077  0681 e602          	ld	a,(2,x)
3078  0683 a12c          	cp	a,#44
3079  0685 2705          	jreq	L7621
3080                     ; 445         return -1;
3082  0687 aeffff        	ldw	x,#65535
3084  068a 20db          	jra	L061
3085  068c               L7621:
3086                     ; 447     if (cmd_str[3] != '0' && cmd_str[3] != '1')
3088  068c 1e03          	ldw	x,(OFST+1,sp)
3089  068e e603          	ld	a,(3,x)
3090  0690 a130          	cp	a,#48
3091  0692 270d          	jreq	L1721
3093  0694 1e03          	ldw	x,(OFST+1,sp)
3094  0696 e603          	ld	a,(3,x)
3095  0698 a131          	cp	a,#49
3096  069a 2705          	jreq	L1721
3097                     ; 448         return -1;
3099  069c aeffff        	ldw	x,#65535
3101  069f 20c6          	jra	L061
3102  06a1               L1721:
3103                     ; 450     relay_num = cmd_str[1] - '0';
3105  06a1 1e03          	ldw	x,(OFST+1,sp)
3106  06a3 e601          	ld	a,(1,x)
3107  06a5 a030          	sub	a,#48
3108  06a7 6b01          	ld	(OFST-1,sp),a
3110                     ; 451     relay_state = cmd_str[3] - '0';
3112  06a9 1e03          	ldw	x,(OFST+1,sp)
3113  06ab e603          	ld	a,(3,x)
3114  06ad a030          	sub	a,#48
3115  06af 6b02          	ld	(OFST+0,sp),a
3117                     ; 453     relay_control_set(relay_num, relay_state);
3119  06b1 7b02          	ld	a,(OFST+0,sp)
3120  06b3 97            	ld	xl,a
3121  06b4 7b01          	ld	a,(OFST-1,sp)
3122  06b6 95            	ld	xh,a
3123  06b7 cd04c0        	call	_relay_control_set
3125                     ; 455     return 0;
3127  06ba 5f            	clrw	x
3129  06bb 20aa          	jra	L061
3153                     ; 458 void relay_control_init(void)
3153                     ; 459 {
3154                     	switch	.text
3155  06bd               _relay_control_init:
3159                     ; 460     relay_control_set_all(1);  /* 1 = on for active-low relays */
3161  06bd a601          	ld	a,#1
3162  06bf cd04d4        	call	_relay_control_set_all
3164                     ; 461 }
3167  06c2 81            	ret
3192                     ; 463 void hal_w5500_reset_high(void)
3192                     ; 464 {
3193                     	switch	.text
3194  06c3               _hal_w5500_reset_high:
3198                     ; 465     GPIO_WriteHigh(W5500_RST_PORT, W5500_RST_PIN);
3200  06c3 4b20          	push	#32
3201  06c5 ae5014        	ldw	x,#20500
3202  06c8 cd0000        	call	_GPIO_WriteHigh
3204  06cb 84            	pop	a
3205                     ; 466 }
3208  06cc 81            	ret
3234                     ; 468 void hal_gpio_init(void){
3235                     	switch	.text
3236  06cd               _hal_gpio_init:
3240                     ; 470     GPIO_Init(DI1_PORT, DI1_PIN, GPIO_MODE_IN_PU_NO_IT);
3242  06cd 4b40          	push	#64
3243  06cf 4b04          	push	#4
3244  06d1 ae500f        	ldw	x,#20495
3245  06d4 cd0000        	call	_GPIO_Init
3247  06d7 85            	popw	x
3248                     ; 471     GPIO_Init(DI2_PORT, DI2_PIN, GPIO_MODE_IN_PU_NO_IT);
3250  06d8 4b40          	push	#64
3251  06da 4b08          	push	#8
3252  06dc ae500f        	ldw	x,#20495
3253  06df cd0000        	call	_GPIO_Init
3255  06e2 85            	popw	x
3256                     ; 472     GPIO_Init(DI3_PORT, DI3_PIN, GPIO_MODE_IN_PU_NO_IT);
3258  06e3 4b40          	push	#64
3259  06e5 4b10          	push	#16
3260  06e7 ae500f        	ldw	x,#20495
3261  06ea cd0000        	call	_GPIO_Init
3263  06ed 85            	popw	x
3264                     ; 473     GPIO_Init(DI4_PORT, DI4_PIN, GPIO_MODE_IN_PU_NO_IT);
3266  06ee 4b40          	push	#64
3267  06f0 4b80          	push	#128
3268  06f2 ae500f        	ldw	x,#20495
3269  06f5 cd0000        	call	_GPIO_Init
3271  06f8 85            	popw	x
3272                     ; 476     GPIO_Init(RELAY1_PORT, RELAY1_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
3274  06f9 4bf0          	push	#240
3275  06fb 4b08          	push	#8
3276  06fd ae5005        	ldw	x,#20485
3277  0700 cd0000        	call	_GPIO_Init
3279  0703 85            	popw	x
3280                     ; 477     GPIO_Init(RELAY2_PORT, RELAY2_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
3282  0704 4bf0          	push	#240
3283  0706 4b04          	push	#4
3284  0708 ae5005        	ldw	x,#20485
3285  070b cd0000        	call	_GPIO_Init
3287  070e 85            	popw	x
3288                     ; 478     GPIO_Init(RELAY3_PORT, RELAY3_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
3290  070f 4bf0          	push	#240
3291  0711 4b02          	push	#2
3292  0713 ae5005        	ldw	x,#20485
3293  0716 cd0000        	call	_GPIO_Init
3295  0719 85            	popw	x
3296                     ; 479     GPIO_Init(RELAY4_PORT, RELAY4_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
3298  071a 4bf0          	push	#240
3299  071c 4b01          	push	#1
3300  071e ae5005        	ldw	x,#20485
3301  0721 cd0000        	call	_GPIO_Init
3303  0724 85            	popw	x
3304                     ; 480     GPIO_Init(RELAY5_PORT, RELAY5_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
3306  0725 4bf0          	push	#240
3307  0727 4b08          	push	#8
3308  0729 ae500a        	ldw	x,#20490
3309  072c cd0000        	call	_GPIO_Init
3311  072f 85            	popw	x
3312                     ; 481     GPIO_Init(RELAY6_PORT, RELAY6_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
3314  0730 4bf0          	push	#240
3315  0732 4b10          	push	#16
3316  0734 ae500a        	ldw	x,#20490
3317  0737 cd0000        	call	_GPIO_Init
3319  073a 85            	popw	x
3320                     ; 484     hal_relay_set(1, 1);
3322  073b ae0101        	ldw	x,#257
3323  073e cd043c        	call	_hal_relay_set
3325                     ; 485     hal_relay_set(2, 1);
3327  0741 ae0201        	ldw	x,#513
3328  0744 cd043c        	call	_hal_relay_set
3330                     ; 486     hal_relay_set(3, 1);
3332  0747 ae0301        	ldw	x,#769
3333  074a cd043c        	call	_hal_relay_set
3335                     ; 487     hal_relay_set(4, 1);
3337  074d ae0401        	ldw	x,#1025
3338  0750 cd043c        	call	_hal_relay_set
3340                     ; 488     hal_relay_set(5, 1);
3342  0753 ae0501        	ldw	x,#1281
3343  0756 cd043c        	call	_hal_relay_set
3345                     ; 489     hal_relay_set(6, 1);
3347  0759 ae0601        	ldw	x,#1537
3348  075c cd043c        	call	_hal_relay_set
3350                     ; 492     GPIO_Init(HARDRST_PORT, HARDRST_PIN, GPIO_MODE_IN_PU_NO_IT);
3352  075f 4b40          	push	#64
3353  0761 4b80          	push	#128
3354  0763 ae5005        	ldw	x,#20485
3355  0766 cd0000        	call	_GPIO_Init
3357  0769 85            	popw	x
3358                     ; 495     GPIO_Init(W5500_RST_PORT, W5500_RST_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
3360  076a 4bf0          	push	#240
3361  076c 4b20          	push	#32
3362  076e ae5014        	ldw	x,#20500
3363  0771 cd0000        	call	_GPIO_Init
3365  0774 85            	popw	x
3366                     ; 496 	  hal_w5500_reset_high();
3368  0775 cd06c3        	call	_hal_w5500_reset_high
3370                     ; 497 }
3373  0778 81            	ret
3397                     ; 499 uint16_t hal_uart_available(void){
3398                     	switch	.text
3399  0779               _hal_uart_available:
3403                     ; 500 	return uart_rx_count;
3405  0779 be1d          	ldw	x,L12_uart_rx_count
3408  077b 81            	ret
3447                     ; 503 uint8_t hal_uart_read_byte(void){
3448                     	switch	.text
3449  077c               _hal_uart_read_byte:
3451  077c 88            	push	a
3452       00000001      OFST:	set	1
3455                     ; 504 	uint8_t byte = 0;
3457  077d 0f01          	clr	(OFST+0,sp)
3459                     ; 505 	if (uart_rx_count > 0){
3461  077f be1d          	ldw	x,L12_uart_rx_count
3462  0781 2719          	jreq	L1531
3463                     ; 506 		disableInterrupts();
3466  0783 9b            sim
3468                     ; 508 		byte = uart_rx_buffer[uart_rx_tail];
3471  0784 be21          	ldw	x,L52_uart_rx_tail
3472  0786 e600          	ld	a,(L13_uart_rx_buffer,x)
3473  0788 6b01          	ld	(OFST+0,sp),a
3475                     ; 509 		uart_rx_tail = (uart_rx_tail + 1) % UART_RX_BUFFER_SIZE;
3477  078a be21          	ldw	x,L52_uart_rx_tail
3478  078c 5c            	incw	x
3479  078d a650          	ld	a,#80
3480  078f 62            	div	x,a
3481  0790 5f            	clrw	x
3482  0791 97            	ld	xl,a
3483  0792 bf21          	ldw	L52_uart_rx_tail,x
3484                     ; 510 		uart_rx_count--;
3486  0794 be1d          	ldw	x,L12_uart_rx_count
3487  0796 1d0001        	subw	x,#1
3488  0799 bf1d          	ldw	L12_uart_rx_count,x
3489                     ; 511 		enableInterrupts();
3492  079b 9a            rim
3495  079c               L1531:
3496                     ; 513 	return byte;
3498  079c 7b01          	ld	a,(OFST+0,sp)
3501  079e 5b01          	addw	sp,#1
3502  07a0 81            	ret
3576                     ; 516 void uart_server_process(void){
3577                     	switch	.text
3578  07a1               _uart_server_process:
3580  07a1 521f          	subw	sp,#31
3581       0000001f      OFST:	set	31
3584                     ; 522 	if (uart_state == UART_STATE_IDLE){
3586  07a3 3d19          	tnz	L31_uart_state
3587  07a5 2603          	jrne	L002
3588  07a7 cc0862        	jp	L671
3589  07aa               L002:
3590                     ; 523 		return;
3592                     ; 525 	available_len = hal_uart_available();
3594  07aa adcd          	call	_hal_uart_available
3596  07ac 1f05          	ldw	(OFST-26,sp),x
3598                     ; 527 	if(available_len > 0){
3600  07ae 1e05          	ldw	x,(OFST-26,sp)
3601  07b0 2603          	jrne	L202
3602  07b2 cc085e        	jp	L7041
3603  07b5               L202:
3604                     ; 528 		uart_state = UART_STATE_RX_PENDING;
3606  07b5 35020019      	mov	L31_uart_state,#2
3608  07b9 ac4a084a      	jpf	L5141
3609  07bd               L1141:
3610                     ; 531 			read_byte = hal_uart_read_byte();
3612  07bd adbd          	call	_hal_uart_read_byte
3614  07bf 6b1f          	ld	(OFST+0,sp),a
3616                     ; 533 			if (read_byte == '\n' || read_byte == '\r'){
3618  07c1 7b1f          	ld	a,(OFST+0,sp)
3619  07c3 a10a          	cp	a,#10
3620  07c5 2706          	jreq	L3241
3622  07c7 7b1f          	ld	a,(OFST+0,sp)
3623  07c9 a10d          	cp	a,#13
3624  07cb 265c          	jrne	L1241
3625  07cd               L3241:
3626                     ; 534 				if(uart_rx_count > 0){
3628  07cd be1d          	ldw	x,L12_uart_rx_count
3629  07cf 2772          	jreq	L5341
3630                     ; 535 					uart_rx_buffer[uart_rx_count] = '\0';
3632  07d1 be1d          	ldw	x,L12_uart_rx_count
3633  07d3 6f00          	clr	(L13_uart_rx_buffer,x)
3634                     ; 536 					if (command_parser_execute((const char *)uart_rx_buffer,uart_rx_count) == 0){
3636  07d5 be1d          	ldw	x,L12_uart_rx_count
3637  07d7 89            	pushw	x
3638  07d8 ae0000        	ldw	x,#L13_uart_rx_buffer
3639  07db cd064e        	call	_command_parser_execute
3641  07de 5b02          	addw	sp,#2
3642  07e0 a30000        	cpw	x,#0
3643  07e3 2634          	jrne	L7241
3644                     ; 537 						state = sensor_reader_get_state();
3646  07e5 96            	ldw	x,sp
3647  07e6 1c001b        	addw	x,#OFST-4
3648  07e9 89            	pushw	x
3649  07ea cd00ce        	call	_sensor_reader_get_state
3651  07ed 85            	popw	x
3652                     ; 538 						message_formatter_alive(resp_buf, sizeof(resp_buf),state.di1,state.di2,state.di3,state.di4);
3654  07ee 7b1e          	ld	a,(OFST-1,sp)
3655  07f0 88            	push	a
3656  07f1 7b1e          	ld	a,(OFST-1,sp)
3657  07f3 88            	push	a
3658  07f4 7b1e          	ld	a,(OFST-1,sp)
3659  07f6 88            	push	a
3660  07f7 7b1e          	ld	a,(OFST-1,sp)
3661  07f9 88            	push	a
3662  07fa ae0014        	ldw	x,#20
3663  07fd 89            	pushw	x
3664  07fe 96            	ldw	x,sp
3665  07ff 1c000d        	addw	x,#OFST-18
3666  0802 cd00da        	call	_message_formatter_alive
3668  0805 5b06          	addw	sp,#6
3669                     ; 539 					 	uart_server_send((uint8_t *)resp_buf,strlen(resp_buf));
3671  0807 96            	ldw	x,sp
3672  0808 1c0007        	addw	x,#OFST-24
3673  080b cd0000        	call	_strlen
3675  080e 89            	pushw	x
3676  080f 96            	ldw	x,sp
3677  0810 1c0009        	addw	x,#OFST-22
3678  0813 cd0099        	call	_uart_server_send
3680  0816 85            	popw	x
3682  0817 200b          	jra	L1341
3683  0819               L7241:
3684                     ; 542                         uart_server_send((uint8_t *)"ERROR,INVALID_COMMAND\n",strlen("ERROR,INVALID_COMMAND\n"));
3686  0819 ae0016        	ldw	x,#22
3687  081c 89            	pushw	x
3688  081d ae0017        	ldw	x,#L3341
3689  0820 cd0099        	call	_uart_server_send
3691  0823 85            	popw	x
3692  0824               L1341:
3693                     ; 544                     uart_rx_count = 0;
3695  0824 5f            	clrw	x
3696  0825 bf1d          	ldw	L12_uart_rx_count,x
3697  0827 201a          	jra	L5341
3698  0829               L1241:
3699                     ; 547             else if (read_byte >= 32 && read_byte < 127){
3701  0829 7b1f          	ld	a,(OFST+0,sp)
3702  082b a120          	cp	a,#32
3703  082d 2514          	jrult	L5341
3705  082f 7b1f          	ld	a,(OFST+0,sp)
3706  0831 a17f          	cp	a,#127
3707  0833 240e          	jruge	L5341
3708                     ; 548                 uart_rx_buffer[uart_rx_count++] = read_byte;
3710  0835 7b1f          	ld	a,(OFST+0,sp)
3711  0837 be1d          	ldw	x,L12_uart_rx_count
3712  0839 1c0001        	addw	x,#1
3713  083c bf1d          	ldw	L12_uart_rx_count,x
3714  083e 1d0001        	subw	x,#1
3715  0841 e700          	ld	(L13_uart_rx_buffer,x),a
3716  0843               L5341:
3717                     ; 550             available_len--;
3719  0843 1e05          	ldw	x,(OFST-26,sp)
3720  0845 1d0001        	subw	x,#1
3721  0848 1f05          	ldw	(OFST-26,sp),x
3723  084a               L5141:
3724                     ; 530 		while (available_len > 0 && uart_rx_count < sizeof(uart_rx_buffer) - 1){
3726  084a 1e05          	ldw	x,(OFST-26,sp)
3727  084c 270a          	jreq	L1441
3729  084e be1d          	ldw	x,L12_uart_rx_count
3730  0850 a30013        	cpw	x,#19
3731  0853 2403          	jruge	L402
3732  0855 cc07bd        	jp	L1141
3733  0858               L402:
3734  0858               L1441:
3735                     ; 552         uart_state = UART_STATE_READY;
3737  0858 35010019      	mov	L31_uart_state,#1
3739  085c 2004          	jra	L3441
3740  085e               L7041:
3741                     ; 555         uart_state = UART_STATE_READY;
3743  085e 35010019      	mov	L31_uart_state,#1
3744  0862               L3441:
3745                     ; 557 }
3746  0862               L671:
3749  0862 5b1f          	addw	sp,#31
3750  0864 81            	ret
3787                     ; 558 uint8_t hal_spi_byte(uint8_t data)
3787                     ; 559 {
3788                     	switch	.text
3789  0865               _hal_spi_byte:
3791  0865 88            	push	a
3792       00000000      OFST:	set	0
3795  0866               L5641:
3796                     ; 560     while (SPI_GetFlagStatus(SPI_FLAG_TXE) == RESET);
3798  0866 a602          	ld	a,#2
3799  0868 cd0000        	call	_SPI_GetFlagStatus
3801  086b 4d            	tnz	a
3802  086c 27f8          	jreq	L5641
3803                     ; 562     SPI_SendData(data);
3805  086e 7b01          	ld	a,(OFST+1,sp)
3806  0870 cd0000        	call	_SPI_SendData
3809  0873               L3741:
3810                     ; 564     while (SPI_GetFlagStatus(SPI_FLAG_RXNE) == RESET);
3812  0873 a601          	ld	a,#1
3813  0875 cd0000        	call	_SPI_GetFlagStatus
3815  0878 4d            	tnz	a
3816  0879 27f8          	jreq	L3741
3817                     ; 566     return SPI_ReceiveData();
3819  087b cd0000        	call	_SPI_ReceiveData
3823  087e 5b01          	addw	sp,#1
3824  0880 81            	ret
3848                     ; 568 uint8_t hal_spi_read_byte(void)
3848                     ; 569 {
3849                     	switch	.text
3850  0881               _hal_spi_read_byte:
3854                     ; 570     return hal_spi_byte(0xFF);
3856  0881 a6ff          	ld	a,#255
3857  0883 ade0          	call	_hal_spi_byte
3861  0885 81            	ret
3896                     ; 572 void hal_spi_write_byte(uint8_t data)
3896                     ; 573 {
3897                     	switch	.text
3898  0886               _hal_spi_write_byte:
3902                     ; 574     hal_spi_byte(data);
3904  0886 addd          	call	_hal_spi_byte
3906                     ; 575 }
3909  0888 81            	ret
3963                     ; 576 void hal_spi_read(uint8_t *buf, uint16_t len){
3964                     	switch	.text
3965  0889               _hal_spi_read:
3967  0889 89            	pushw	x
3968  088a 89            	pushw	x
3969       00000002      OFST:	set	2
3972                     ; 578     for(i = 0; i < len; i++){
3974  088b 5f            	clrw	x
3975  088c 1f01          	ldw	(OFST-1,sp),x
3978  088e 2011          	jra	L7551
3979  0890               L3551:
3980                     ; 579         buf[i] = hal_spi_byte(0xFF);
3982  0890 a6ff          	ld	a,#255
3983  0892 add1          	call	_hal_spi_byte
3985  0894 1e03          	ldw	x,(OFST+1,sp)
3986  0896 72fb01        	addw	x,(OFST-1,sp)
3987  0899 f7            	ld	(x),a
3988                     ; 578     for(i = 0; i < len; i++){
3990  089a 1e01          	ldw	x,(OFST-1,sp)
3991  089c 1c0001        	addw	x,#1
3992  089f 1f01          	ldw	(OFST-1,sp),x
3994  08a1               L7551:
3997  08a1 1e01          	ldw	x,(OFST-1,sp)
3998  08a3 1307          	cpw	x,(OFST+5,sp)
3999  08a5 25e9          	jrult	L3551
4000                     ; 581 }
4003  08a7 5b04          	addw	sp,#4
4004  08a9 81            	ret
4058                     ; 583 void hal_spi_write(uint8_t *buf, uint16_t len){
4059                     	switch	.text
4060  08aa               _hal_spi_write:
4062  08aa 89            	pushw	x
4063  08ab 89            	pushw	x
4064       00000002      OFST:	set	2
4067                     ; 585     for(i = 0; i < len; i++){
4069  08ac 5f            	clrw	x
4070  08ad 1f01          	ldw	(OFST-1,sp),x
4073  08af 200f          	jra	L5161
4074  08b1               L1161:
4075                     ; 586         hal_spi_byte(buf[i]);
4077  08b1 1e03          	ldw	x,(OFST+1,sp)
4078  08b3 72fb01        	addw	x,(OFST-1,sp)
4079  08b6 f6            	ld	a,(x)
4080  08b7 adac          	call	_hal_spi_byte
4082                     ; 585     for(i = 0; i < len; i++){
4084  08b9 1e01          	ldw	x,(OFST-1,sp)
4085  08bb 1c0001        	addw	x,#1
4086  08be 1f01          	ldw	(OFST-1,sp),x
4088  08c0               L5161:
4091  08c0 1e01          	ldw	x,(OFST-1,sp)
4092  08c2 1307          	cpw	x,(OFST+5,sp)
4093  08c4 25eb          	jrult	L1161
4094                     ; 588 }
4097  08c6 5b04          	addw	sp,#4
4098  08c8 81            	ret
4140                     ; 590 void uart_server_init(uint32_t baudrate){
4141                     	switch	.text
4142  08c9               _uart_server_init:
4144       00000000      OFST:	set	0
4147                     ; 591 	uart_state = UART_STATE_IDLE;
4149  08c9 3f19          	clr	L31_uart_state
4150                     ; 592 	uart_rx_count = 0;
4152  08cb 5f            	clrw	x
4153  08cc bf1d          	ldw	L12_uart_rx_count,x
4154                     ; 593 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_UART1, ENABLE);
4156  08ce ae0301        	ldw	x,#769
4157  08d1 cd0000        	call	_CLK_PeripheralClockConfig
4159                     ; 594     UART1_Init(
4159                     ; 595     baudrate,
4159                     ; 596     UART1_WORDLENGTH_8D,
4159                     ; 597     UART1_STOPBITS_1,
4159                     ; 598     UART1_PARITY_NO,
4159                     ; 599     UART1_SYNCMODE_CLOCK_DISABLE,
4159                     ; 600     (UART1_Mode_TypeDef)(UART1_MODE_TX_ENABLE | UART1_MODE_RX_ENABLE)
4159                     ; 601 );
4161  08d4 4b0c          	push	#12
4162  08d6 4b80          	push	#128
4163  08d8 4b00          	push	#0
4164  08da 4b00          	push	#0
4165  08dc 4b00          	push	#0
4166  08de 1e0a          	ldw	x,(OFST+10,sp)
4167  08e0 89            	pushw	x
4168  08e1 1e0a          	ldw	x,(OFST+10,sp)
4169  08e3 89            	pushw	x
4170  08e4 cd0000        	call	_UART1_Init
4172  08e7 5b09          	addw	sp,#9
4173                     ; 603     UART1_ITConfig(UART1_IT_RXNE, ENABLE);
4175  08e9 4b01          	push	#1
4176  08eb ae0255        	ldw	x,#597
4177  08ee cd0000        	call	_UART1_ITConfig
4179  08f1 84            	pop	a
4180                     ; 606     UART1_Cmd(ENABLE);
4182  08f2 a601          	ld	a,#1
4183  08f4 cd0000        	call	_UART1_Cmd
4185                     ; 608     uart_rx_head = 0;
4187  08f7 5f            	clrw	x
4188  08f8 bf1f          	ldw	L32_uart_rx_head,x
4189                     ; 609     uart_rx_tail = 0;
4191  08fa 5f            	clrw	x
4192  08fb bf21          	ldw	L52_uart_rx_tail,x
4193                     ; 610     uart_rx_count = 0;  
4195  08fd 5f            	clrw	x
4196  08fe bf1d          	ldw	L12_uart_rx_count,x
4197                     ; 611 	uart_state = UART_STATE_READY;
4199  0900 35010019      	mov	L31_uart_state,#1
4200                     ; 612 }
4203  0904 81            	ret
4231                     ; 614 void hal_timer_init(void){
4232                     	switch	.text
4233  0905               _hal_timer_init:
4237                     ; 615     CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER4, ENABLE);
4239  0905 ae0401        	ldw	x,#1025
4240  0908 cd0000        	call	_CLK_PeripheralClockConfig
4242                     ; 616     TIM4_TimeBaseInit(TIM4_PRESCALER_128, 125);
4244  090b ae077d        	ldw	x,#1917
4245  090e cd0000        	call	_TIM4_TimeBaseInit
4247                     ; 617     TIM4_ClearFlag(TIM4_FLAG_UPDATE);
4249  0911 a601          	ld	a,#1
4250  0913 cd0000        	call	_TIM4_ClearFlag
4252                     ; 619     TIM4_ITConfig(TIM4_IT_UPDATE, ENABLE);
4254  0916 ae0101        	ldw	x,#257
4255  0919 cd0000        	call	_TIM4_ITConfig
4257                     ; 621     enableInterrupts();
4260  091c 9a            rim
4262                     ; 622 }
4266  091d 81            	ret
4300                     ; 624 void system_init(void){
4301                     	switch	.text
4302  091e               _system_init:
4306                     ; 626     CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);  /* 16MHz clock */
4308  091e 4f            	clr	a
4309  091f cd0000        	call	_CLK_HSIPrescalerConfig
4311                     ; 629 	hal_gpio_init();
4313  0922 cd06cd        	call	_hal_gpio_init
4315                     ; 630     hal_timer_init();
4317  0925 adde          	call	_hal_timer_init
4319                     ; 633 	relay_control_init();
4321  0927 cd06bd        	call	_relay_control_init
4323                     ; 634 	sensor_reader_init();
4325  092a cd05b1        	call	_sensor_reader_init
4327                     ; 639     uart_server_init(UART_BAUDRATE);
4329  092d aec200        	ldw	x,#49664
4330  0930 89            	pushw	x
4331  0931 ae0001        	ldw	x,#1
4332  0934 89            	pushw	x
4333  0935 ad92          	call	_uart_server_init
4335  0937 5b04          	addw	sp,#4
4336                     ; 642     hal_timer_set_callback(timer_callback);
4338  0939 ae0600        	ldw	x,#_timer_callback
4339  093c cd064b        	call	_hal_timer_set_callback
4341                     ; 643     hal_timer_start();
4343  093f cd0522        	call	_hal_timer_start
4345                     ; 644 	hal_delay_ms(500);
4347  0942 ae01f4        	ldw	x,#500
4348  0945 cd0014        	call	_hal_delay_ms
4350                     ; 645 }
4353  0948 81            	ret
4356                     	switch	.const
4357  000c               L7561_msg:
4358  000c 52455345542c  	dc.b	"RESET, OK",10,0
4398                     ; 648 void main_loop(void)
4398                     ; 649 {
4399                     	switch	.text
4400  0949               _main_loop:
4402  0949 520b          	subw	sp,#11
4403       0000000b      OFST:	set	11
4406  094b               L7761:
4407                     ; 656 		uart_server_process();
4409  094b cd07a1        	call	_uart_server_process
4411                     ; 658         if(GPIO_ReadInputPin(HARDRST_PORT, HARDRST_PIN) == RESET)
4413  094e 4b80          	push	#128
4414  0950 ae5005        	ldw	x,#20485
4415  0953 cd0000        	call	_GPIO_ReadInputPin
4417  0956 5b01          	addw	sp,#1
4418  0958 4d            	tnz	a
4419  0959 26f0          	jrne	L7761
4420                     ; 660             hal_delay_ms(50);
4422  095b ae0032        	ldw	x,#50
4423  095e cd0014        	call	_hal_delay_ms
4425                     ; 661 			if (GPIO_ReadInputPin(HARDRST_PORT, HARDRST_PIN) == 0){
4427  0961 4b80          	push	#128
4428  0963 ae5005        	ldw	x,#20485
4429  0966 cd0000        	call	_GPIO_ReadInputPin
4431  0969 5b01          	addw	sp,#1
4432  096b 4d            	tnz	a
4433  096c 26dd          	jrne	L7761
4434                     ; 663 				char msg[] = "RESET, OK\n";
4436  096e 96            	ldw	x,sp
4437  096f 1c0001        	addw	x,#OFST-10
4438  0972 90ae000c      	ldw	y,#L7561_msg
4439  0976 a60b          	ld	a,#11
4440  0978 cd0000        	call	c_xymov
4442                     ; 664                 if(tcp_server_is_connected()){
4444  097b cd0007        	call	_tcp_server_is_connected
4446  097e a30000        	cpw	x,#0
4447                     ; 667                 if (uart_server_is_ready()){
4449  0981 cd0041        	call	_uart_server_is_ready
4451  0984 a30000        	cpw	x,#0
4452  0987 2710          	jreq	L1171
4453                     ; 668                     uart_server_send((uint8_t *)msg, strlen(msg));
4455  0989 96            	ldw	x,sp
4456  098a 1c0001        	addw	x,#OFST-10
4457  098d cd0000        	call	_strlen
4459  0990 89            	pushw	x
4460  0991 96            	ldw	x,sp
4461  0992 1c0003        	addw	x,#OFST-8
4462  0995 cd0099        	call	_uart_server_send
4464  0998 85            	popw	x
4465  0999               L1171:
4466                     ; 670 				hal_delay_ms(100);
4468  0999 ae0064        	ldw	x,#100
4469  099c cd0014        	call	_hal_delay_ms
4471  099f 20aa          	jra	L7761
4496                     ; 679 int main(void)
4496                     ; 680 {
4497                     	switch	.text
4498  09a1               _main:
4502                     ; 681 	system_init();
4504  09a1 cd091e        	call	_system_init
4506                     ; 682     main_loop();
4508  09a4 ada3          	call	_main_loop
4510  09a6               L3271:
4511                     ; 683     while(1);
4513  09a6 20fe          	jra	L3271
4812                     	xdef	_main
4813                     	xdef	_main_loop
4814                     	xdef	_system_init
4815                     	xdef	_hal_timer_init
4816                     	xdef	_uart_server_init
4817                     	xdef	_hal_spi_write
4818                     	xdef	_hal_spi_read
4819                     	xdef	_hal_spi_write_byte
4820                     	xdef	_hal_spi_read_byte
4821                     	xdef	_hal_spi_byte
4822                     	xdef	_uart_server_process
4823                     	xdef	_hal_uart_read_byte
4824                     	xdef	_hal_uart_available
4825                     	xdef	_hal_gpio_init
4826                     	xdef	_hal_w5500_reset_high
4827                     	xdef	_relay_control_init
4828                     	xdef	_command_parser_execute
4829                     	xdef	_hal_timer_set_callback
4830                     	xdef	_timer_callback
4831                     	xdef	_send_alive_message
4832                     	xdef	_sensor_reader_init
4833                     	xdef	_process_axle_counting
4834                     	xdef	_hal_timer_start
4835                     	xdef	_sensor_reader_update
4836                     	xdef	_relay_control_set_all
4837                     	xdef	_relay_control_set
4838                     	xdef	_hal_relay_set
4839                     	xdef	_message_formatter_avcc
4840                     	xdef	_hal_di_read
4841                     	xdef	_message_formatter_alive
4842                     	xdef	_sensor_reader_get_state
4843                     	xdef	_uart_server_send
4844                     	xdef	_hal_spi_cs_high
4845                     	xdef	_hal_spi_cs_low
4846                     	xdef	_hal_uart_send
4847                     	xdef	_hal_uart_send_byte
4848                     	xdef	_uart_server_is_ready
4849                     	xdef	_hal_delay_ms
4850                     	xdef	_tcp_server_is_connected
4851                     	xdef	_hal_get_millis
4852                     	switch	.ubsct
4853  0000               L13_uart_rx_buffer:
4854  0000 000000000000  	ds.b	20
4855  0014               L72_uart_tx_buffer:
4856  0014 000000000000  	ds.b	80
4857                     	xref	_strlen
4858                     	xref	_TIM4_ClearFlag
4859                     	xref	_TIM4_ITConfig
4860                     	xref	_TIM4_Cmd
4861                     	xref	_TIM4_TimeBaseInit
4862                     	xref	_SPI_GetFlagStatus
4863                     	xref	_SPI_ReceiveData
4864                     	xref	_SPI_SendData
4865                     	xref	_UART1_GetFlagStatus
4866                     	xref	_UART1_SendData8
4867                     	xref	_UART1_ITConfig
4868                     	xref	_UART1_Cmd
4869                     	xref	_UART1_Init
4870                     	xref	_GPIO_ReadInputPin
4871                     	xref	_GPIO_WriteLow
4872                     	xref	_GPIO_WriteHigh
4873                     	xref	_GPIO_Init
4874                     	xref	_CLK_HSIPrescalerConfig
4875                     	xref	_CLK_PeripheralClockConfig
4876                     	switch	.const
4877  0017               L3341:
4878  0017 4552524f522c  	dc.b	"ERROR,INVALID_COMM"
4879  0029 414e440a00    	dc.b	"AND",10,0
4880                     	xref.b	c_lreg
4881                     	xref.b	c_x
4901                     	xref	c_lgadc
4902                     	xref	c_ludv
4903                     	xref	c_ladc
4904                     	xref	c_lumd
4905                     	xref	c_lzmp
4906                     	xref	c_xymov
4907                     	xref	c_lcmp
4908                     	xref	c_lsub
4909                     	xref	c_uitolx
4910                     	xref	c_rtol
4911                     	xref	c_ltor
4912                     	end
