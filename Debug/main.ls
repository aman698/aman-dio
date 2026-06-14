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
  30  0018               L11_uart_state:
  31  0018 00            	dc.b	0
  32  0019               L31_server_socket:
  33  0019 00            	dc.b	0
  34  001a               L51_uart_rx_count:
  35  001a 0000          	dc.w	0
  36  001c               L71_uart_rx_head:
  37  001c 0000          	dc.w	0
  38  001e               L12_uart_rx_tail:
  39  001e 0000          	dc.w	0
  40  0020               L72_systick_ms:
  41  0020 00000000      	dc.l	0
  42  0024               L13_user_callback:
  43  0024 0000          	dc.w	0
  73                     ; 61 unsigned long hal_get_millis(void)
  73                     ; 62 {
  75                     	switch	.text
  76  0000               _hal_get_millis:
  80                     ; 63     return systick_ms;
  82  0000 ae0020        	ldw	x,#L72_systick_ms
  83  0003 cd0000        	call	c_ltor
  87  0006 81            	ret
 131                     ; 66 void hal_delay_ms(unsigned int ms)
 131                     ; 67 {
 132                     	switch	.text
 133  0007               _hal_delay_ms:
 135  0007 89            	pushw	x
 136  0008 5208          	subw	sp,#8
 137       00000008      OFST:	set	8
 140                     ; 68     unsigned long start = hal_get_millis();
 142  000a adf4          	call	_hal_get_millis
 144  000c 96            	ldw	x,sp
 145  000d 1c0005        	addw	x,#OFST-3
 146  0010 cd0000        	call	c_rtol
 150  0013               L77:
 151                     ; 69     while ((hal_get_millis() - start) < ms);
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
 172                     ; 70 }
 175  0031 5b0a          	addw	sp,#10
 176  0033 81            	ret
 201                     ; 72 int uart_server_is_ready(void){
 202                     	switch	.text
 203  0034               _uart_server_is_ready:
 207                     ; 73     return (uart_state != UART_STATE_IDLE) ? 1 : 0;
 209  0034 3d18          	tnz	L11_uart_state
 210  0036 2705          	jreq	L21
 211  0038 ae0001        	ldw	x,#1
 212  003b 2001          	jra	L41
 213  003d               L21:
 214  003d 5f            	clrw	x
 215  003e               L41:
 218  003e 81            	ret
 254                     ; 76 void hal_uart_send_byte(uint8_t byte){
 255                     	switch	.text
 256  003f               _hal_uart_send_byte:
 258  003f 88            	push	a
 259       00000000      OFST:	set	0
 262  0040               L331:
 263                     ; 77     while (UART1_GetFlagStatus(UART1_FLAG_TXE) == RESET);
 265  0040 ae0080        	ldw	x,#128
 266  0043 cd0000        	call	_UART1_GetFlagStatus
 268  0046 4d            	tnz	a
 269  0047 27f7          	jreq	L331
 270                     ; 80     UART1_SendData8(byte);
 272  0049 7b01          	ld	a,(OFST+1,sp)
 273  004b cd0000        	call	_UART1_SendData8
 276  004e               L141:
 277                     ; 83     while (UART1_GetFlagStatus(UART1_FLAG_TC) == RESET);
 279  004e ae0040        	ldw	x,#64
 280  0051 cd0000        	call	_UART1_GetFlagStatus
 282  0054 4d            	tnz	a
 283  0055 27f7          	jreq	L141
 284                     ; 84 }
 287  0057 84            	pop	a
 288  0058 81            	ret
 342                     ; 86 void hal_uart_send(const uint8_t *data, uint16_t len){
 343                     	switch	.text
 344  0059               _hal_uart_send:
 346  0059 89            	pushw	x
 347  005a 89            	pushw	x
 348       00000002      OFST:	set	2
 351                     ; 88     for(i = 0; i < len; i++){
 353  005b 5f            	clrw	x
 354  005c 1f01          	ldw	(OFST-1,sp),x
 357  005e 200f          	jra	L771
 358  0060               L371:
 359                     ; 89         hal_uart_send_byte(data[i]);
 361  0060 1e03          	ldw	x,(OFST+1,sp)
 362  0062 72fb01        	addw	x,(OFST-1,sp)
 363  0065 f6            	ld	a,(x)
 364  0066 add7          	call	_hal_uart_send_byte
 366                     ; 88     for(i = 0; i < len; i++){
 368  0068 1e01          	ldw	x,(OFST-1,sp)
 369  006a 1c0001        	addw	x,#1
 370  006d 1f01          	ldw	(OFST-1,sp),x
 372  006f               L771:
 375  006f 1e01          	ldw	x,(OFST-1,sp)
 376  0071 1307          	cpw	x,(OFST+5,sp)
 377  0073 25eb          	jrult	L371
 378                     ; 91 }
 381  0075 5b04          	addw	sp,#4
 382  0077 81            	ret
 406                     ; 92 void hal_spi_cs_low(void)
 406                     ; 93 {
 407                     	switch	.text
 408  0078               _hal_spi_cs_low:
 412                     ; 94     GPIO_WriteLow(W5500_CS_PORT, W5500_CS_PIN);
 414  0078 4b08          	push	#8
 415  007a ae5000        	ldw	x,#20480
 416  007d cd0000        	call	_GPIO_WriteLow
 418  0080 84            	pop	a
 419                     ; 95 }
 422  0081 81            	ret
 446                     ; 97 void hal_spi_cs_high(void)
 446                     ; 98 {
 447                     	switch	.text
 448  0082               _hal_spi_cs_high:
 452                     ; 99     GPIO_WriteHigh(W5500_CS_PORT, W5500_CS_PIN);
 454  0082 4b08          	push	#8
 455  0084 ae5000        	ldw	x,#20480
 456  0087 cd0000        	call	_GPIO_WriteHigh
 458  008a 84            	pop	a
 459                     ; 100 }
 462  008b 81            	ret
 510                     ; 102 int uart_server_send(const uint8_t *data, uint16_t len)
 510                     ; 103 {
 511                     	switch	.text
 512  008c               _uart_server_send:
 514  008c 89            	pushw	x
 515       00000000      OFST:	set	0
 518                     ; 104     if (uart_state == UART_STATE_IDLE) {
 520  008d 3d18          	tnz	L11_uart_state
 521  008f 2605          	jrne	L542
 522                     ; 105         return -1;
 524  0091 aeffff        	ldw	x,#65535
 526  0094 2028          	jra	L43
 527  0096               L542:
 528                     ; 108     if (len > sizeof(uart_tx_buffer)) {
 530  0096 1e05          	ldw	x,(OFST+5,sp)
 531  0098 a30021        	cpw	x,#33
 532  009b 2505          	jrult	L742
 533                     ; 109         len = sizeof(uart_tx_buffer);
 535  009d ae0020        	ldw	x,#32
 536  00a0 1f05          	ldw	(OFST+5,sp),x
 537  00a2               L742:
 538                     ; 113     memcpy(uart_tx_buffer, data, len);
 540  00a2 1e01          	ldw	x,(OFST+1,sp)
 541  00a4 bf00          	ldw	c_x,x
 542  00a6 1e05          	ldw	x,(OFST+5,sp)
 543  00a8 5d            	tnzw	x
 544  00a9 2709          	jreq	L03
 545  00ab               L23:
 546  00ab 5a            	decw	x
 547  00ac 92d600        	ld	a,([c_x.w],x)
 548  00af e720          	ld	(L32_uart_tx_buffer,x),a
 549  00b1 5d            	tnzw	x
 550  00b2 26f7          	jrne	L23
 551  00b4               L03:
 552                     ; 114     hal_uart_send(uart_tx_buffer, len);
 554  00b4 1e05          	ldw	x,(OFST+5,sp)
 555  00b6 89            	pushw	x
 556  00b7 ae0020        	ldw	x,#L32_uart_tx_buffer
 557  00ba ad9d          	call	_hal_uart_send
 559  00bc 85            	popw	x
 560                     ; 116     return 0;
 562  00bd 5f            	clrw	x
 564  00be               L43:
 566  00be 5b02          	addw	sp,#2
 567  00c0 81            	ret
 628                     ; 118 sensor_state_t sensor_reader_get_state(void)
 628                     ; 119 {
 629                     	switch	.text
 630  00c1               _sensor_reader_get_state:
 632       00000000      OFST:	set	0
 635                     ; 120     return current_state;
 637  00c1 1e03          	ldw	x,(OFST+3,sp)
 638  00c3 90ae0014      	ldw	y,#L7_current_state
 639  00c7 a604          	ld	a,#4
 640  00c9 cd0000        	call	c_xymov
 644  00cc 81            	ret
 725                     ; 123 void message_formatter_alive(char *buf,
 725                     ; 124                              int buf_size,
 725                     ; 125                              uint8_t di1,
 725                     ; 126                              uint8_t di2,
 725                     ; 127                              uint8_t di3,
 725                     ; 128                              uint8_t di4)
 725                     ; 129 {
 726                     	switch	.text
 727  00cd               _message_formatter_alive:
 729  00cd 89            	pushw	x
 730       00000000      OFST:	set	0
 733                     ; 130     if(buf == 0)
 735  00ce a30000        	cpw	x,#0
 736  00d1 2708          	jreq	L26
 737                     ; 131         return;
 739                     ; 133     if(buf_size < 21)
 741  00d3 9c            	rvf
 742  00d4 1e05          	ldw	x,(OFST+5,sp)
 743  00d6 a30015        	cpw	x,#21
 744  00d9 2e02          	jrsge	L143
 745                     ; 134         return;
 746  00db               L26:
 749  00db 85            	popw	x
 750  00dc 81            	ret
 751  00dd               L143:
 752                     ; 136     buf[0]  = 'S';
 754  00dd 1e01          	ldw	x,(OFST+1,sp)
 755  00df a653          	ld	a,#83
 756  00e1 f7            	ld	(x),a
 757                     ; 137     buf[1]  = 'T';
 759  00e2 1e01          	ldw	x,(OFST+1,sp)
 760  00e4 a654          	ld	a,#84
 761  00e6 e701          	ld	(1,x),a
 762                     ; 138     buf[2]  = 'A';
 764  00e8 1e01          	ldw	x,(OFST+1,sp)
 765  00ea a641          	ld	a,#65
 766  00ec e702          	ld	(2,x),a
 767                     ; 139     buf[3]  = 'R';
 769  00ee 1e01          	ldw	x,(OFST+1,sp)
 770  00f0 a652          	ld	a,#82
 771  00f2 e703          	ld	(3,x),a
 772                     ; 140     buf[4]  = 'T';
 774  00f4 1e01          	ldw	x,(OFST+1,sp)
 775  00f6 a654          	ld	a,#84
 776  00f8 e704          	ld	(4,x),a
 777                     ; 141     buf[5]  = ',';
 779  00fa 1e01          	ldw	x,(OFST+1,sp)
 780  00fc a62c          	ld	a,#44
 781  00fe e705          	ld	(5,x),a
 782                     ; 142     buf[6]  = 'A';
 784  0100 1e01          	ldw	x,(OFST+1,sp)
 785  0102 a641          	ld	a,#65
 786  0104 e706          	ld	(6,x),a
 787                     ; 143     buf[7]  = 'L';
 789  0106 1e01          	ldw	x,(OFST+1,sp)
 790  0108 a64c          	ld	a,#76
 791  010a e707          	ld	(7,x),a
 792                     ; 144     buf[8]  = 'I';
 794  010c 1e01          	ldw	x,(OFST+1,sp)
 795  010e a649          	ld	a,#73
 796  0110 e708          	ld	(8,x),a
 797                     ; 145     buf[9]  = 'V';
 799  0112 1e01          	ldw	x,(OFST+1,sp)
 800  0114 a656          	ld	a,#86
 801  0116 e709          	ld	(9,x),a
 802                     ; 146     buf[10] = 'E';
 804  0118 1e01          	ldw	x,(OFST+1,sp)
 805  011a a645          	ld	a,#69
 806  011c e70a          	ld	(10,x),a
 807                     ; 147     buf[11] = ',';
 809  011e 1e01          	ldw	x,(OFST+1,sp)
 810  0120 a62c          	ld	a,#44
 811  0122 e70b          	ld	(11,x),a
 812                     ; 149     buf[12] = di1 ? '1' : '0';
 814  0124 0d07          	tnz	(OFST+7,sp)
 815  0126 2704          	jreq	L24
 816  0128 a631          	ld	a,#49
 817  012a 2002          	jra	L44
 818  012c               L24:
 819  012c a630          	ld	a,#48
 820  012e               L44:
 821  012e 1e01          	ldw	x,(OFST+1,sp)
 822  0130 e70c          	ld	(12,x),a
 823                     ; 150     buf[13] = di2 ? '1' : '0';
 825  0132 0d08          	tnz	(OFST+8,sp)
 826  0134 2704          	jreq	L64
 827  0136 a631          	ld	a,#49
 828  0138 2002          	jra	L05
 829  013a               L64:
 830  013a a630          	ld	a,#48
 831  013c               L05:
 832  013c 1e01          	ldw	x,(OFST+1,sp)
 833  013e e70d          	ld	(13,x),a
 834                     ; 151     buf[14] = di3 ? '1' : '0';
 836  0140 0d09          	tnz	(OFST+9,sp)
 837  0142 2704          	jreq	L25
 838  0144 a631          	ld	a,#49
 839  0146 2002          	jra	L45
 840  0148               L25:
 841  0148 a630          	ld	a,#48
 842  014a               L45:
 843  014a 1e01          	ldw	x,(OFST+1,sp)
 844  014c e70e          	ld	(14,x),a
 845                     ; 152     buf[15] = di4 ? '1' : '0';
 847  014e 0d0a          	tnz	(OFST+10,sp)
 848  0150 2704          	jreq	L65
 849  0152 a631          	ld	a,#49
 850  0154 2002          	jra	L06
 851  0156               L65:
 852  0156 a630          	ld	a,#48
 853  0158               L06:
 854  0158 1e01          	ldw	x,(OFST+1,sp)
 855  015a e70f          	ld	(15,x),a
 856                     ; 154     buf[16] = ',';
 858  015c 1e01          	ldw	x,(OFST+1,sp)
 859  015e a62c          	ld	a,#44
 860  0160 e710          	ld	(16,x),a
 861                     ; 155     buf[17] = 'E';
 863  0162 1e01          	ldw	x,(OFST+1,sp)
 864  0164 a645          	ld	a,#69
 865  0166 e711          	ld	(17,x),a
 866                     ; 156     buf[18] = 'N';
 868  0168 1e01          	ldw	x,(OFST+1,sp)
 869  016a a64e          	ld	a,#78
 870  016c e712          	ld	(18,x),a
 871                     ; 157     buf[19] = 'D';
 873  016e 1e01          	ldw	x,(OFST+1,sp)
 874  0170 a644          	ld	a,#68
 875  0172 e713          	ld	(19,x),a
 876                     ; 158     buf[20] = '\0';
 878  0174 1e01          	ldw	x,(OFST+1,sp)
 879  0176 6f14          	clr	(20,x)
 880                     ; 159 }
 883  0178 85            	popw	x
 884  0179 81            	ret
1076                     ; 161 uint8_t hal_di_read(uint8_t di_num)
1076                     ; 162 {
1077                     	switch	.text
1078  017a               _hal_di_read:
1080  017a 5203          	subw	sp,#3
1081       00000003      OFST:	set	3
1084                     ; 166     switch (di_num) {
1087                     ; 171         default: return 0;
1088  017c 4a            	dec	a
1089  017d 270c          	jreq	L343
1090  017f 4a            	dec	a
1091  0180 2714          	jreq	L543
1092  0182 4a            	dec	a
1093  0183 271c          	jreq	L743
1094  0185 4a            	dec	a
1095  0186 2724          	jreq	L153
1096  0188               L353:
1099  0188 4f            	clr	a
1101  0189 203d          	jra	L27
1102  018b               L343:
1103                     ; 167         case 1: port = DI1_PORT; pin = DI1_PIN; break;
1105  018b ae500f        	ldw	x,#20495
1106  018e 1f01          	ldw	(OFST-2,sp),x
1110  0190 a604          	ld	a,#4
1111  0192 6b03          	ld	(OFST+0,sp),a
1115  0194 201f          	jra	L174
1116  0196               L543:
1117                     ; 168         case 2: port = DI2_PORT; pin = DI2_PIN; break;
1119  0196 ae500f        	ldw	x,#20495
1120  0199 1f01          	ldw	(OFST-2,sp),x
1124  019b a608          	ld	a,#8
1125  019d 6b03          	ld	(OFST+0,sp),a
1129  019f 2014          	jra	L174
1130  01a1               L743:
1131                     ; 169         case 3: port = DI3_PORT; pin = DI3_PIN; break;
1133  01a1 ae500f        	ldw	x,#20495
1134  01a4 1f01          	ldw	(OFST-2,sp),x
1138  01a6 a610          	ld	a,#16
1139  01a8 6b03          	ld	(OFST+0,sp),a
1143  01aa 2009          	jra	L174
1144  01ac               L153:
1145                     ; 170         case 4: port = DI4_PORT; pin = DI4_PIN; break;
1147  01ac ae500f        	ldw	x,#20495
1148  01af 1f01          	ldw	(OFST-2,sp),x
1152  01b1 a680          	ld	a,#128
1153  01b3 6b03          	ld	(OFST+0,sp),a
1157  01b5               L174:
1158                     ; 173     return (GPIO_ReadInputPin(port, pin) == SET) ? 1 : 0;
1160  01b5 7b03          	ld	a,(OFST+0,sp)
1161  01b7 88            	push	a
1162  01b8 1e02          	ldw	x,(OFST-1,sp)
1163  01ba cd0000        	call	_GPIO_ReadInputPin
1165  01bd 5b01          	addw	sp,#1
1166  01bf a101          	cp	a,#1
1167  01c1 2604          	jrne	L66
1168  01c3 a601          	ld	a,#1
1169  01c5 2001          	jra	L07
1170  01c7               L66:
1171  01c7 4f            	clr	a
1172  01c8               L07:
1174  01c8               L27:
1176  01c8 5b03          	addw	sp,#3
1177  01ca 81            	ret
1250                     ; 176 static char* u16_to_str(char *p, uint16_t value)
1250                     ; 177 {
1251                     	switch	.text
1252  01cb               L374_u16_to_str:
1254  01cb 89            	pushw	x
1255  01cc 5209          	subw	sp,#9
1256       00000009      OFST:	set	9
1259                     ; 179     uint8_t i = 0;
1261  01ce 0f09          	clr	(OFST+0,sp)
1263                     ; 182     if(value == 0)
1265  01d0 1e0e          	ldw	x,(OFST+5,sp)
1266  01d2 263d          	jrne	L735
1267                     ; 184         *p++ = '0';
1269  01d4 1e0a          	ldw	x,(OFST+1,sp)
1270  01d6 1c0001        	addw	x,#1
1271  01d9 1f0a          	ldw	(OFST+1,sp),x
1272  01db 1d0001        	subw	x,#1
1273  01de a630          	ld	a,#48
1274  01e0 f7            	ld	(x),a
1275                     ; 185         return p;
1277  01e1 1e0a          	ldw	x,(OFST+1,sp)
1279  01e3 2058          	jra	L67
1280  01e5               L535:
1281                     ; 190         temp[i++] = (value % 10) + '0';
1283  01e5 1e0e          	ldw	x,(OFST+5,sp)
1284  01e7 a60a          	ld	a,#10
1285  01e9 62            	div	x,a
1286  01ea 5f            	clrw	x
1287  01eb 97            	ld	xl,a
1288  01ec 1c0030        	addw	x,#48
1289  01ef 9096          	ldw	y,sp
1290  01f1 72a90003      	addw	y,#OFST-6
1291  01f5 1701          	ldw	(OFST-8,sp),y
1293  01f7 7b09          	ld	a,(OFST+0,sp)
1294  01f9 9097          	ld	yl,a
1295  01fb 0c09          	inc	(OFST+0,sp)
1297  01fd 909f          	ld	a,yl
1298  01ff 905f          	clrw	y
1299  0201 9097          	ld	yl,a
1300  0203 72f901        	addw	y,(OFST-8,sp)
1301  0206 01            	rrwa	x,a
1302  0207 90f7          	ld	(y),a
1303  0209 02            	rlwa	x,a
1304                     ; 191         value /= 10;
1306  020a 1e0e          	ldw	x,(OFST+5,sp)
1307  020c a60a          	ld	a,#10
1308  020e 62            	div	x,a
1309  020f 1f0e          	ldw	(OFST+5,sp),x
1310  0211               L735:
1311                     ; 188     while(value)
1313  0211 1e0e          	ldw	x,(OFST+5,sp)
1314  0213 26d0          	jrne	L535
1315                     ; 194     for(j = i; j > 0; j--)
1317  0215 7b09          	ld	a,(OFST+0,sp)
1318  0217 6b09          	ld	(OFST+0,sp),a
1321  0219 201c          	jra	L745
1322  021b               L345:
1323                     ; 196         *p++ = temp[j - 1];
1325  021b 96            	ldw	x,sp
1326  021c 1c0003        	addw	x,#OFST-6
1327  021f 1f01          	ldw	(OFST-8,sp),x
1329  0221 7b09          	ld	a,(OFST+0,sp)
1330  0223 5f            	clrw	x
1331  0224 97            	ld	xl,a
1332  0225 5a            	decw	x
1333  0226 72fb01        	addw	x,(OFST-8,sp)
1334  0229 f6            	ld	a,(x)
1335  022a 1e0a          	ldw	x,(OFST+1,sp)
1336  022c 1c0001        	addw	x,#1
1337  022f 1f0a          	ldw	(OFST+1,sp),x
1338  0231 1d0001        	subw	x,#1
1339  0234 f7            	ld	(x),a
1340                     ; 194     for(j = i; j > 0; j--)
1342  0235 0a09          	dec	(OFST+0,sp)
1344  0237               L745:
1347  0237 0d09          	tnz	(OFST+0,sp)
1348  0239 26e0          	jrne	L345
1349                     ; 199     return p;
1351  023b 1e0a          	ldw	x,(OFST+1,sp)
1353  023d               L67:
1355  023d 5b0b          	addw	sp,#11
1356  023f 81            	ret
1429                     .const:	section	.text
1430  0000               L201:
1431  0000 0000000a      	dc.l	10
1432                     ; 202 static char* u32_to_str(char *p, uint32_t value)
1432                     ; 203 {
1433                     	switch	.text
1434  0240               L355_u32_to_str:
1436  0240 89            	pushw	x
1437  0241 520d          	subw	sp,#13
1438       0000000d      OFST:	set	13
1441                     ; 205     uint8_t i = 0;
1443  0243 0f0d          	clr	(OFST+0,sp)
1445                     ; 208     if(value == 0)
1447  0245 96            	ldw	x,sp
1448  0246 1c0012        	addw	x,#OFST+5
1449  0249 cd0000        	call	c_lzmp
1451  024c 264b          	jrne	L716
1452                     ; 210         *p++ = '0';
1454  024e 1e0e          	ldw	x,(OFST+1,sp)
1455  0250 1c0001        	addw	x,#1
1456  0253 1f0e          	ldw	(OFST+1,sp),x
1457  0255 1d0001        	subw	x,#1
1458  0258 a630          	ld	a,#48
1459  025a f7            	ld	(x),a
1460                     ; 211         return p;
1462  025b 1e0e          	ldw	x,(OFST+1,sp)
1464  025d 206b          	jra	L401
1465  025f               L516:
1466                     ; 216         temp[i++] = (value % 10) + '0';
1468  025f 96            	ldw	x,sp
1469  0260 1c0012        	addw	x,#OFST+5
1470  0263 cd0000        	call	c_ltor
1472  0266 ae0000        	ldw	x,#L201
1473  0269 cd0000        	call	c_lumd
1475  026c a630          	ld	a,#48
1476  026e cd0000        	call	c_ladc
1478  0271 96            	ldw	x,sp
1479  0272 1c0003        	addw	x,#OFST-10
1480  0275 1f01          	ldw	(OFST-12,sp),x
1482  0277 7b0d          	ld	a,(OFST+0,sp)
1483  0279 97            	ld	xl,a
1484  027a 0c0d          	inc	(OFST+0,sp)
1486  027c 9f            	ld	a,xl
1487  027d 5f            	clrw	x
1488  027e 97            	ld	xl,a
1489  027f 72fb01        	addw	x,(OFST-12,sp)
1490  0282 b603          	ld	a,c_lreg+3
1491  0284 f7            	ld	(x),a
1492                     ; 217         value /= 10;
1494  0285 96            	ldw	x,sp
1495  0286 1c0012        	addw	x,#OFST+5
1496  0289 cd0000        	call	c_ltor
1498  028c ae0000        	ldw	x,#L201
1499  028f cd0000        	call	c_ludv
1501  0292 96            	ldw	x,sp
1502  0293 1c0012        	addw	x,#OFST+5
1503  0296 cd0000        	call	c_rtol
1505  0299               L716:
1506                     ; 214     while(value)
1508  0299 96            	ldw	x,sp
1509  029a 1c0012        	addw	x,#OFST+5
1510  029d cd0000        	call	c_lzmp
1512  02a0 26bd          	jrne	L516
1513                     ; 220     for(j = i; j > 0; j--)
1515  02a2 7b0d          	ld	a,(OFST+0,sp)
1516  02a4 6b0d          	ld	(OFST+0,sp),a
1519  02a6 201c          	jra	L726
1520  02a8               L326:
1521                     ; 222         *p++ = temp[j - 1];
1523  02a8 96            	ldw	x,sp
1524  02a9 1c0003        	addw	x,#OFST-10
1525  02ac 1f01          	ldw	(OFST-12,sp),x
1527  02ae 7b0d          	ld	a,(OFST+0,sp)
1528  02b0 5f            	clrw	x
1529  02b1 97            	ld	xl,a
1530  02b2 5a            	decw	x
1531  02b3 72fb01        	addw	x,(OFST-12,sp)
1532  02b6 f6            	ld	a,(x)
1533  02b7 1e0e          	ldw	x,(OFST+1,sp)
1534  02b9 1c0001        	addw	x,#1
1535  02bc 1f0e          	ldw	(OFST+1,sp),x
1536  02be 1d0001        	subw	x,#1
1537  02c1 f7            	ld	(x),a
1538                     ; 220     for(j = i; j > 0; j--)
1540  02c2 0a0d          	dec	(OFST+0,sp)
1542  02c4               L726:
1545  02c4 0d0d          	tnz	(OFST+0,sp)
1546  02c6 26e0          	jrne	L326
1547                     ; 225     return p;
1549  02c8 1e0e          	ldw	x,(OFST+1,sp)
1551  02ca               L401:
1553  02ca 5b0f          	addw	sp,#15
1554  02cc 81            	ret
1638                     ; 228 void message_formatter_avcc(char *buf,
1638                     ; 229                             int buf_size,
1638                     ; 230                             uint16_t lanid,
1638                     ; 231                             uint32_t seqn,
1638                     ; 232                             uint16_t axle_count)
1638                     ; 233 {
1639                     	switch	.text
1640  02cd               _message_formatter_avcc:
1642  02cd 89            	pushw	x
1643  02ce 89            	pushw	x
1644       00000002      OFST:	set	2
1647                     ; 236     if(buf == 0)
1649  02cf a30000        	cpw	x,#0
1650  02d2 2708          	jreq	L011
1651                     ; 237         return;
1653                     ; 239     if(buf_size < 40)
1655  02d4 9c            	rvf
1656  02d5 1e07          	ldw	x,(OFST+5,sp)
1657  02d7 a30028        	cpw	x,#40
1658  02da 2e03          	jrsge	L776
1659                     ; 240         return;
1660  02dc               L011:
1663  02dc 5b04          	addw	sp,#4
1664  02de 81            	ret
1665  02df               L776:
1666                     ; 242     p = buf;
1668  02df 1e03          	ldw	x,(OFST+1,sp)
1669  02e1 1f01          	ldw	(OFST-1,sp),x
1671                     ; 245     *p++ = 'S';
1673  02e3 1e01          	ldw	x,(OFST-1,sp)
1674  02e5 1c0001        	addw	x,#1
1675  02e8 1f01          	ldw	(OFST-1,sp),x
1676  02ea 1d0001        	subw	x,#1
1678  02ed a653          	ld	a,#83
1679  02ef f7            	ld	(x),a
1680                     ; 246     *p++ = 'T';
1682  02f0 1e01          	ldw	x,(OFST-1,sp)
1683  02f2 1c0001        	addw	x,#1
1684  02f5 1f01          	ldw	(OFST-1,sp),x
1685  02f7 1d0001        	subw	x,#1
1687  02fa a654          	ld	a,#84
1688  02fc f7            	ld	(x),a
1689                     ; 247     *p++ = 'A';
1691  02fd 1e01          	ldw	x,(OFST-1,sp)
1692  02ff 1c0001        	addw	x,#1
1693  0302 1f01          	ldw	(OFST-1,sp),x
1694  0304 1d0001        	subw	x,#1
1696  0307 a641          	ld	a,#65
1697  0309 f7            	ld	(x),a
1698                     ; 248     *p++ = 'R';
1700  030a 1e01          	ldw	x,(OFST-1,sp)
1701  030c 1c0001        	addw	x,#1
1702  030f 1f01          	ldw	(OFST-1,sp),x
1703  0311 1d0001        	subw	x,#1
1705  0314 a652          	ld	a,#82
1706  0316 f7            	ld	(x),a
1707                     ; 249     *p++ = 'T';
1709  0317 1e01          	ldw	x,(OFST-1,sp)
1710  0319 1c0001        	addw	x,#1
1711  031c 1f01          	ldw	(OFST-1,sp),x
1712  031e 1d0001        	subw	x,#1
1714  0321 a654          	ld	a,#84
1715  0323 f7            	ld	(x),a
1716                     ; 250     *p++ = ',';
1718  0324 1e01          	ldw	x,(OFST-1,sp)
1719  0326 1c0001        	addw	x,#1
1720  0329 1f01          	ldw	(OFST-1,sp),x
1721  032b 1d0001        	subw	x,#1
1723  032e a62c          	ld	a,#44
1724  0330 f7            	ld	(x),a
1725                     ; 251     *p++ = 'A';
1727  0331 1e01          	ldw	x,(OFST-1,sp)
1728  0333 1c0001        	addw	x,#1
1729  0336 1f01          	ldw	(OFST-1,sp),x
1730  0338 1d0001        	subw	x,#1
1732  033b a641          	ld	a,#65
1733  033d f7            	ld	(x),a
1734                     ; 252     *p++ = 'V';
1736  033e 1e01          	ldw	x,(OFST-1,sp)
1737  0340 1c0001        	addw	x,#1
1738  0343 1f01          	ldw	(OFST-1,sp),x
1739  0345 1d0001        	subw	x,#1
1741  0348 a656          	ld	a,#86
1742  034a f7            	ld	(x),a
1743                     ; 253     *p++ = 'C';
1745  034b 1e01          	ldw	x,(OFST-1,sp)
1746  034d 1c0001        	addw	x,#1
1747  0350 1f01          	ldw	(OFST-1,sp),x
1748  0352 1d0001        	subw	x,#1
1750  0355 a643          	ld	a,#67
1751  0357 f7            	ld	(x),a
1752                     ; 254     *p++ = 'C';
1754  0358 1e01          	ldw	x,(OFST-1,sp)
1755  035a 1c0001        	addw	x,#1
1756  035d 1f01          	ldw	(OFST-1,sp),x
1757  035f 1d0001        	subw	x,#1
1759  0362 a643          	ld	a,#67
1760  0364 f7            	ld	(x),a
1761                     ; 255     *p++ = ',';
1763  0365 1e01          	ldw	x,(OFST-1,sp)
1764  0367 1c0001        	addw	x,#1
1765  036a 1f01          	ldw	(OFST-1,sp),x
1766  036c 1d0001        	subw	x,#1
1768  036f a62c          	ld	a,#44
1769  0371 f7            	ld	(x),a
1770                     ; 257     p = u16_to_str(p, lanid);
1772  0372 1e09          	ldw	x,(OFST+7,sp)
1773  0374 89            	pushw	x
1774  0375 1e03          	ldw	x,(OFST+1,sp)
1775  0377 cd01cb        	call	L374_u16_to_str
1777  037a 5b02          	addw	sp,#2
1778  037c 1f01          	ldw	(OFST-1,sp),x
1780                     ; 259     *p++ = ',';
1782  037e 1e01          	ldw	x,(OFST-1,sp)
1783  0380 1c0001        	addw	x,#1
1784  0383 1f01          	ldw	(OFST-1,sp),x
1785  0385 1d0001        	subw	x,#1
1787  0388 a62c          	ld	a,#44
1788  038a f7            	ld	(x),a
1789                     ; 261     p = u32_to_str(p, seqn);
1791  038b 1e0d          	ldw	x,(OFST+11,sp)
1792  038d 89            	pushw	x
1793  038e 1e0d          	ldw	x,(OFST+11,sp)
1794  0390 89            	pushw	x
1795  0391 1e05          	ldw	x,(OFST+3,sp)
1796  0393 cd0240        	call	L355_u32_to_str
1798  0396 5b04          	addw	sp,#4
1799  0398 1f01          	ldw	(OFST-1,sp),x
1801                     ; 263     *p++ = ',';
1803  039a 1e01          	ldw	x,(OFST-1,sp)
1804  039c 1c0001        	addw	x,#1
1805  039f 1f01          	ldw	(OFST-1,sp),x
1806  03a1 1d0001        	subw	x,#1
1808  03a4 a62c          	ld	a,#44
1809  03a6 f7            	ld	(x),a
1810                     ; 264     *p++ = 'A';
1812  03a7 1e01          	ldw	x,(OFST-1,sp)
1813  03a9 1c0001        	addw	x,#1
1814  03ac 1f01          	ldw	(OFST-1,sp),x
1815  03ae 1d0001        	subw	x,#1
1817  03b1 a641          	ld	a,#65
1818  03b3 f7            	ld	(x),a
1819                     ; 265     *p++ = 'X';
1821  03b4 1e01          	ldw	x,(OFST-1,sp)
1822  03b6 1c0001        	addw	x,#1
1823  03b9 1f01          	ldw	(OFST-1,sp),x
1824  03bb 1d0001        	subw	x,#1
1826  03be a658          	ld	a,#88
1827  03c0 f7            	ld	(x),a
1828                     ; 266     *p++ = 'L';
1830  03c1 1e01          	ldw	x,(OFST-1,sp)
1831  03c3 1c0001        	addw	x,#1
1832  03c6 1f01          	ldw	(OFST-1,sp),x
1833  03c8 1d0001        	subw	x,#1
1835  03cb a64c          	ld	a,#76
1836  03cd f7            	ld	(x),a
1837                     ; 267     *p++ = 'E';
1839  03ce 1e01          	ldw	x,(OFST-1,sp)
1840  03d0 1c0001        	addw	x,#1
1841  03d3 1f01          	ldw	(OFST-1,sp),x
1842  03d5 1d0001        	subw	x,#1
1844  03d8 a645          	ld	a,#69
1845  03da f7            	ld	(x),a
1846                     ; 268     *p++ = ',';
1848  03db 1e01          	ldw	x,(OFST-1,sp)
1849  03dd 1c0001        	addw	x,#1
1850  03e0 1f01          	ldw	(OFST-1,sp),x
1851  03e2 1d0001        	subw	x,#1
1853  03e5 a62c          	ld	a,#44
1854  03e7 f7            	ld	(x),a
1855                     ; 270     p = u16_to_str(p, axle_count);
1857  03e8 1e0f          	ldw	x,(OFST+13,sp)
1858  03ea 89            	pushw	x
1859  03eb 1e03          	ldw	x,(OFST+1,sp)
1860  03ed cd01cb        	call	L374_u16_to_str
1862  03f0 5b02          	addw	sp,#2
1863  03f2 1f01          	ldw	(OFST-1,sp),x
1865                     ; 272     *p++ = ',';
1867  03f4 1e01          	ldw	x,(OFST-1,sp)
1868  03f6 1c0001        	addw	x,#1
1869  03f9 1f01          	ldw	(OFST-1,sp),x
1870  03fb 1d0001        	subw	x,#1
1872  03fe a62c          	ld	a,#44
1873  0400 f7            	ld	(x),a
1874                     ; 273     *p++ = 'E';
1876  0401 1e01          	ldw	x,(OFST-1,sp)
1877  0403 1c0001        	addw	x,#1
1878  0406 1f01          	ldw	(OFST-1,sp),x
1879  0408 1d0001        	subw	x,#1
1881  040b a645          	ld	a,#69
1882  040d f7            	ld	(x),a
1883                     ; 274     *p++ = 'N';
1885  040e 1e01          	ldw	x,(OFST-1,sp)
1886  0410 1c0001        	addw	x,#1
1887  0413 1f01          	ldw	(OFST-1,sp),x
1888  0415 1d0001        	subw	x,#1
1890  0418 a64e          	ld	a,#78
1891  041a f7            	ld	(x),a
1892                     ; 275     *p++ = 'D';
1894  041b 1e01          	ldw	x,(OFST-1,sp)
1895  041d 1c0001        	addw	x,#1
1896  0420 1f01          	ldw	(OFST-1,sp),x
1897  0422 1d0001        	subw	x,#1
1899  0425 a644          	ld	a,#68
1900  0427 f7            	ld	(x),a
1901                     ; 277     *p = '\0';
1903  0428 1e01          	ldw	x,(OFST-1,sp)
1904  042a 7f            	clr	(x)
1905                     ; 278 }
1907  042b acdc02dc      	jpf	L011
2004                     ; 280 void hal_relay_set(uint8_t relay_num, uint8_t state){
2005                     	switch	.text
2006  042f               _hal_relay_set:
2008  042f 89            	pushw	x
2009  0430 5204          	subw	sp,#4
2010       00000004      OFST:	set	4
2013                     ; 283 	BitStatus bit_state = (state == 0) ? SET : RESET;
2015  0432 9f            	ld	a,xl
2016  0433 4d            	tnz	a
2017  0434 2605          	jrne	L411
2018  0436 ae0001        	ldw	x,#1
2019  0439 2001          	jra	L611
2020  043b               L411:
2021  043b 5f            	clrw	x
2022  043c               L611:
2023  043c 01            	rrwa	x,a
2024  043d 6b01          	ld	(OFST-3,sp),a
2025  043f 02            	rlwa	x,a
2027                     ; 285 	switch (relay_num) {
2029  0440 7b05          	ld	a,(OFST+1,sp)
2031                     ; 292         default: return;
2032  0442 4a            	dec	a
2033  0443 2711          	jreq	L107
2034  0445 4a            	dec	a
2035  0446 2719          	jreq	L307
2036  0448 4a            	dec	a
2037  0449 2721          	jreq	L507
2038  044b 4a            	dec	a
2039  044c 2729          	jreq	L707
2040  044e 4a            	dec	a
2041  044f 2731          	jreq	L117
2042  0451 4a            	dec	a
2043  0452 2739          	jreq	L317
2044  0454               L517:
2047  0454 205a          	jra	L021
2048  0456               L107:
2049                     ; 286         case 1: port = RELAY1_PORT; pin = RELAY1_PIN; break;
2051  0456 ae5005        	ldw	x,#20485
2052  0459 1f02          	ldw	(OFST-2,sp),x
2056  045b a608          	ld	a,#8
2057  045d 6b04          	ld	(OFST+0,sp),a
2061  045f 2035          	jra	L177
2062  0461               L307:
2063                     ; 287         case 2: port = RELAY2_PORT; pin = RELAY2_PIN; break;
2065  0461 ae5005        	ldw	x,#20485
2066  0464 1f02          	ldw	(OFST-2,sp),x
2070  0466 a604          	ld	a,#4
2071  0468 6b04          	ld	(OFST+0,sp),a
2075  046a 202a          	jra	L177
2076  046c               L507:
2077                     ; 288         case 3: port = RELAY3_PORT; pin = RELAY3_PIN; break;
2079  046c ae5005        	ldw	x,#20485
2080  046f 1f02          	ldw	(OFST-2,sp),x
2084  0471 a602          	ld	a,#2
2085  0473 6b04          	ld	(OFST+0,sp),a
2089  0475 201f          	jra	L177
2090  0477               L707:
2091                     ; 289         case 4: port = RELAY4_PORT; pin = RELAY4_PIN; break;
2093  0477 ae5005        	ldw	x,#20485
2094  047a 1f02          	ldw	(OFST-2,sp),x
2098  047c a601          	ld	a,#1
2099  047e 6b04          	ld	(OFST+0,sp),a
2103  0480 2014          	jra	L177
2104  0482               L117:
2105                     ; 290         case 5: port = RELAY5_PORT; pin = RELAY5_PIN; break;
2107  0482 ae500a        	ldw	x,#20490
2108  0485 1f02          	ldw	(OFST-2,sp),x
2112  0487 a608          	ld	a,#8
2113  0489 6b04          	ld	(OFST+0,sp),a
2117  048b 2009          	jra	L177
2118  048d               L317:
2119                     ; 291         case 6: port = RELAY6_PORT; pin = RELAY6_PIN; break;
2121  048d ae500a        	ldw	x,#20490
2122  0490 1f02          	ldw	(OFST-2,sp),x
2126  0492 a610          	ld	a,#16
2127  0494 6b04          	ld	(OFST+0,sp),a
2131  0496               L177:
2132                     ; 295 	if (bit_state == SET) {
2134  0496 7b01          	ld	a,(OFST-3,sp)
2135  0498 a101          	cp	a,#1
2136  049a 260b          	jrne	L377
2137                     ; 296         GPIO_WriteHigh(port, pin);  /* Set HIGH = relay off */
2139  049c 7b04          	ld	a,(OFST+0,sp)
2140  049e 88            	push	a
2141  049f 1e03          	ldw	x,(OFST-1,sp)
2142  04a1 cd0000        	call	_GPIO_WriteHigh
2144  04a4 84            	pop	a
2146  04a5 2009          	jra	L577
2147  04a7               L377:
2148                     ; 298         GPIO_WriteLow(port, pin); /* Set LOW = relay on */
2150  04a7 7b04          	ld	a,(OFST+0,sp)
2151  04a9 88            	push	a
2152  04aa 1e03          	ldw	x,(OFST-1,sp)
2153  04ac cd0000        	call	_GPIO_WriteLow
2155  04af 84            	pop	a
2156  04b0               L577:
2157                     ; 300 }
2158  04b0               L021:
2161  04b0 5b06          	addw	sp,#6
2162  04b2 81            	ret
2206                     ; 302 void relay_control_set(uint8_t relay_num, uint8_t state)
2206                     ; 303 {
2207                     	switch	.text
2208  04b3               _relay_control_set:
2210  04b3 89            	pushw	x
2211       00000000      OFST:	set	0
2214                     ; 304     if (relay_num >= 1 && relay_num <= 6) {
2216  04b4 9e            	ld	a,xh
2217  04b5 4d            	tnz	a
2218  04b6 270d          	jreq	L1201
2220  04b8 9e            	ld	a,xh
2221  04b9 a107          	cp	a,#7
2222  04bb 2408          	jruge	L1201
2223                     ; 305         hal_relay_set(relay_num, state);
2225  04bd 9f            	ld	a,xl
2226  04be 97            	ld	xl,a
2227  04bf 7b01          	ld	a,(OFST+1,sp)
2228  04c1 95            	ld	xh,a
2229  04c2 cd042f        	call	_hal_relay_set
2231  04c5               L1201:
2232                     ; 307 }
2235  04c5 85            	popw	x
2236  04c6 81            	ret
2272                     ; 309 void relay_control_set_all(uint8_t state)
2272                     ; 310 {
2273                     	switch	.text
2274  04c7               _relay_control_set_all:
2276  04c7 88            	push	a
2277       00000000      OFST:	set	0
2280                     ; 311     relay_control_set(1, state);
2282  04c8 ae0100        	ldw	x,#256
2283  04cb 97            	ld	xl,a
2284  04cc ade5          	call	_relay_control_set
2286                     ; 312     relay_control_set(2, state);
2288  04ce 7b01          	ld	a,(OFST+1,sp)
2289  04d0 ae0200        	ldw	x,#512
2290  04d3 97            	ld	xl,a
2291  04d4 addd          	call	_relay_control_set
2293                     ; 313     relay_control_set(3, state);
2295  04d6 7b01          	ld	a,(OFST+1,sp)
2296  04d8 ae0300        	ldw	x,#768
2297  04db 97            	ld	xl,a
2298  04dc add5          	call	_relay_control_set
2300                     ; 314     relay_control_set(4, state);
2302  04de 7b01          	ld	a,(OFST+1,sp)
2303  04e0 ae0400        	ldw	x,#1024
2304  04e3 97            	ld	xl,a
2305  04e4 adcd          	call	_relay_control_set
2307                     ; 315     relay_control_set(5, state);
2309  04e6 7b01          	ld	a,(OFST+1,sp)
2310  04e8 ae0500        	ldw	x,#1280
2311  04eb 97            	ld	xl,a
2312  04ec adc5          	call	_relay_control_set
2314                     ; 316     relay_control_set(6, state);
2316  04ee 7b01          	ld	a,(OFST+1,sp)
2317  04f0 ae0600        	ldw	x,#1536
2318  04f3 97            	ld	xl,a
2319  04f4 adbd          	call	_relay_control_set
2321                     ; 317 }
2324  04f6 84            	pop	a
2325  04f7 81            	ret
2351                     ; 319 void sensor_reader_update(void){
2352                     	switch	.text
2353  04f8               _sensor_reader_update:
2357                     ; 320     current_state.di1 = hal_di_read(1);
2359  04f8 a601          	ld	a,#1
2360  04fa cd017a        	call	_hal_di_read
2362  04fd b714          	ld	L7_current_state,a
2363                     ; 321     current_state.di2 = hal_di_read(2);
2365  04ff a602          	ld	a,#2
2366  0501 cd017a        	call	_hal_di_read
2368  0504 b715          	ld	L7_current_state+1,a
2369                     ; 322     current_state.di3 = hal_di_read(3);
2371  0506 a603          	ld	a,#3
2372  0508 cd017a        	call	_hal_di_read
2374  050b b716          	ld	L7_current_state+2,a
2375                     ; 323     current_state.di4 = hal_di_read(4);
2377  050d a604          	ld	a,#4
2378  050f cd017a        	call	_hal_di_read
2380  0512 b717          	ld	L7_current_state+3,a
2381                     ; 324 }
2384  0514 81            	ret
2408                     ; 327 void hal_timer_start(void)
2408                     ; 328 {
2409                     	switch	.text
2410  0515               _hal_timer_start:
2414                     ; 329     TIM4_Cmd(ENABLE);
2416  0515 a601          	ld	a,#1
2417  0517 cd0000        	call	_TIM4_Cmd
2419                     ; 330 }
2422  051a 81            	ret
2483                     ; 335 void process_axle_counting(void){
2484                     	switch	.text
2485  051b               _process_axle_counting:
2487  051b 5232          	subw	sp,#50
2488       00000032      OFST:	set	50
2491                     ; 336     sensor_state_t sensor = sensor_reader_get_state();
2493  051d 96            	ldw	x,sp
2494  051e 1c002f        	addw	x,#OFST-3
2495  0521 89            	pushw	x
2496  0522 cd00c1        	call	_sensor_reader_get_state
2498  0525 85            	popw	x
2499                     ; 339     if(sensor.di1 == 1 && axle_counter.prev_di1_state == 0){
2501  0526 7b2f          	ld	a,(OFST-3,sp)
2502  0528 a101          	cp	a,#1
2503  052a 260a          	jrne	L7011
2505  052c 3d03          	tnz	L3_axle_counter+3
2506  052e 2606          	jrne	L7011
2507                     ; 340         axle_counter.loop_active = 1;
2509  0530 35010000      	mov	L3_axle_counter,#1
2510                     ; 341         axle_counter.axle_count = 0;
2512  0534 3f02          	clr	L3_axle_counter+2
2513  0536               L7011:
2514                     ; 344     if(axle_counter.loop_active){
2516  0536 3d00          	tnz	L3_axle_counter
2517  0538 2710          	jreq	L1111
2518                     ; 345         if(sensor.di2 == 1 && axle_counter.prev_di2_state == 0){
2520  053a 7b30          	ld	a,(OFST-2,sp)
2521  053c a101          	cp	a,#1
2522  053e 2606          	jrne	L3111
2524  0540 3d01          	tnz	L3_axle_counter+1
2525  0542 2602          	jrne	L3111
2526                     ; 346             axle_counter.axle_count++;
2528  0544 3c02          	inc	L3_axle_counter+2
2529  0546               L3111:
2530                     ; 348         axle_counter.prev_di2_state = sensor.di2;
2532  0546 7b30          	ld	a,(OFST-2,sp)
2533  0548 b701          	ld	L3_axle_counter+1,a
2534  054a               L1111:
2535                     ; 352     if (sensor.di1 == 0 && axle_counter.prev_di1_state == 1 && axle_counter.loop_active){
2537  054a 0d2f          	tnz	(OFST-3,sp)
2538  054c 264f          	jrne	L5111
2540  054e b603          	ld	a,L3_axle_counter+3
2541  0550 a101          	cp	a,#1
2542  0552 2649          	jrne	L5111
2544  0554 3d00          	tnz	L3_axle_counter
2545  0556 2745          	jreq	L5111
2546                     ; 353         uint16_t axle_final_count = axle_counter.axle_count / 2;
2548  0558 b602          	ld	a,L3_axle_counter+2
2549  055a 5f            	clrw	x
2550  055b 97            	ld	xl,a
2551  055c 57            	sraw	x
2552  055d 1f05          	ldw	(OFST-45,sp),x
2554                     ; 356         message_formatter_avcc(msg_buf, sizeof(msg_buf),DEVICE_LANID,axle_counter.embedded_seq_num,axle_final_count);
2556  055f 1e05          	ldw	x,(OFST-45,sp)
2557  0561 89            	pushw	x
2558  0562 be06          	ldw	x,L3_axle_counter+6
2559  0564 89            	pushw	x
2560  0565 be04          	ldw	x,L3_axle_counter+4
2561  0567 89            	pushw	x
2562  0568 ae007d        	ldw	x,#125
2563  056b 89            	pushw	x
2564  056c ae0028        	ldw	x,#40
2565  056f 89            	pushw	x
2566  0570 96            	ldw	x,sp
2567  0571 1c0011        	addw	x,#OFST-33
2568  0574 cd02cd        	call	_message_formatter_avcc
2570  0577 5b0a          	addw	sp,#10
2571                     ; 358         if(uart_server_is_ready()){
2573  0579 cd0034        	call	_uart_server_is_ready
2575  057c a30000        	cpw	x,#0
2576  057f 2710          	jreq	L7111
2577                     ; 359             uart_server_send((uint8_t *)msg_buf, strlen(msg_buf));
2579  0581 96            	ldw	x,sp
2580  0582 1c0007        	addw	x,#OFST-43
2581  0585 cd0000        	call	_strlen
2583  0588 89            	pushw	x
2584  0589 96            	ldw	x,sp
2585  058a 1c0009        	addw	x,#OFST-41
2586  058d cd008c        	call	_uart_server_send
2588  0590 85            	popw	x
2589  0591               L7111:
2590                     ; 362         axle_counter.embedded_seq_num++;
2592  0591 ae0004        	ldw	x,#L3_axle_counter+4
2593  0594 a601          	ld	a,#1
2594  0596 cd0000        	call	c_lgadc
2596                     ; 363         axle_counter.loop_active = 0;
2598  0599 3f00          	clr	L3_axle_counter
2599                     ; 364         axle_counter.axle_count = 0;
2601  059b 3f02          	clr	L3_axle_counter+2
2602  059d               L5111:
2603                     ; 366     axle_counter.prev_di1_state = sensor.di1;
2605  059d 7b2f          	ld	a,(OFST-3,sp)
2606  059f b703          	ld	L3_axle_counter+3,a
2607                     ; 367 }
2610  05a1 5b32          	addw	sp,#50
2611  05a3 81            	ret
2635                     ; 368 void sensor_reader_init(void)
2635                     ; 369 {
2636                     	switch	.text
2637  05a4               _sensor_reader_init:
2641                     ; 371     sensor_reader_update();
2643  05a4 cd04f8        	call	_sensor_reader_update
2645                     ; 372 }
2648  05a7 81            	ret
2698                     ; 374 void send_alive_message(void)
2698                     ; 375 {
2699                     	switch	.text
2700  05a8               _send_alive_message:
2702  05a8 5228          	subw	sp,#40
2703       00000028      OFST:	set	40
2706                     ; 379     sensor = sensor_reader_get_state();
2708  05aa 96            	ldw	x,sp
2709  05ab 1c0025        	addw	x,#OFST-3
2710  05ae 89            	pushw	x
2711  05af cd00c1        	call	_sensor_reader_get_state
2713  05b2 85            	popw	x
2714                     ; 381     message_formatter_alive(
2714                     ; 382         msg_buf,
2714                     ; 383         sizeof(msg_buf),
2714                     ; 384         sensor.di1,
2714                     ; 385         sensor.di2,
2714                     ; 386         sensor.di3,
2714                     ; 387         sensor.di4
2714                     ; 388     );
2716  05b3 7b28          	ld	a,(OFST+0,sp)
2717  05b5 88            	push	a
2718  05b6 7b28          	ld	a,(OFST+0,sp)
2719  05b8 88            	push	a
2720  05b9 7b28          	ld	a,(OFST+0,sp)
2721  05bb 88            	push	a
2722  05bc 7b28          	ld	a,(OFST+0,sp)
2723  05be 88            	push	a
2724  05bf ae0020        	ldw	x,#32
2725  05c2 89            	pushw	x
2726  05c3 96            	ldw	x,sp
2727  05c4 1c000b        	addw	x,#OFST-29
2728  05c7 cd00cd        	call	_message_formatter_alive
2730  05ca 5b06          	addw	sp,#6
2731                     ; 390     if (uart_server_is_ready())
2733  05cc cd0034        	call	_uart_server_is_ready
2735  05cf a30000        	cpw	x,#0
2736  05d2 2710          	jreq	L3511
2737                     ; 392         uart_server_send((uint8_t *)msg_buf, strlen(msg_buf));
2739  05d4 96            	ldw	x,sp
2740  05d5 1c0005        	addw	x,#OFST-35
2741  05d8 cd0000        	call	_strlen
2743  05db 89            	pushw	x
2744  05dc 96            	ldw	x,sp
2745  05dd 1c0007        	addw	x,#OFST-33
2746  05e0 cd008c        	call	_uart_server_send
2748  05e3 85            	popw	x
2749  05e4               L3511:
2750                     ; 394 }
2753  05e4 5b28          	addw	sp,#40
2754  05e6 81            	ret
2782                     	switch	.const
2783  0004               L241:
2784  0004 00000032      	dc.l	50
2785  0008               L441:
2786  0008 000001f4      	dc.l	500
2787                     ; 396 void timer_callback(void){
2788                     	switch	.text
2789  05e7               _timer_callback:
2793                     ; 397     task_timer.current_time = hal_get_millis();
2795  05e7 cd0000        	call	_hal_get_millis
2797  05ea ae0010        	ldw	x,#L5_task_timer+8
2798  05ed cd0000        	call	c_rtol
2800                     ; 398     if ((task_timer.current_time - task_timer.last_sensor_time) >= SENSOR_READ_INTERVAL){
2802  05f0 ae0010        	ldw	x,#L5_task_timer+8
2803  05f3 cd0000        	call	c_ltor
2805  05f6 ae000c        	ldw	x,#L5_task_timer+4
2806  05f9 cd0000        	call	c_lsub
2808  05fc ae0004        	ldw	x,#L241
2809  05ff cd0000        	call	c_lcmp
2811  0602 250e          	jrult	L5611
2812                     ; 399         sensor_reader_update();
2814  0604 cd04f8        	call	_sensor_reader_update
2816                     ; 400         process_axle_counting();
2818  0607 cd051b        	call	_process_axle_counting
2820                     ; 401         task_timer.last_sensor_time = task_timer.current_time;
2822  060a be12          	ldw	x,L5_task_timer+10
2823  060c bf0e          	ldw	L5_task_timer+6,x
2824  060e be10          	ldw	x,L5_task_timer+8
2825  0610 bf0c          	ldw	L5_task_timer+4,x
2826  0612               L5611:
2827                     ; 404     if ((task_timer.current_time - task_timer.last_alive_time) >= ALIVE_INTERVAL){
2829  0612 ae0010        	ldw	x,#L5_task_timer+8
2830  0615 cd0000        	call	c_ltor
2832  0618 ae0008        	ldw	x,#L5_task_timer
2833  061b cd0000        	call	c_lsub
2835  061e ae0008        	ldw	x,#L441
2836  0621 cd0000        	call	c_lcmp
2838  0624 250a          	jrult	L7611
2839                     ; 405         send_alive_message();  
2841  0626 ad80          	call	_send_alive_message
2843                     ; 406         task_timer.last_alive_time = task_timer.current_time;
2845  0628 be12          	ldw	x,L5_task_timer+10
2846  062a bf0a          	ldw	L5_task_timer+2,x
2847  062c be10          	ldw	x,L5_task_timer+8
2848  062e bf08          	ldw	L5_task_timer,x
2849  0630               L7611:
2850                     ; 408 }
2853  0630 81            	ret
2891                     ; 410 void hal_timer_set_callback(timer_callback_t callback)
2891                     ; 411 {
2892                     	switch	.text
2893  0631               _hal_timer_set_callback:
2897                     ; 412     user_callback = callback;
2899  0631 bf24          	ldw	L13_user_callback,x
2900                     ; 413 }
2903  0633 81            	ret
2967                     ; 415 int command_parser_execute(const char *cmd_str, int len)
2967                     ; 416 {
2968                     	switch	.text
2969  0634               _command_parser_execute:
2971  0634 89            	pushw	x
2972  0635 89            	pushw	x
2973       00000002      OFST:	set	2
2976                     ; 421     if (len < 4)
2978  0636 9c            	rvf
2979  0637 1e07          	ldw	x,(OFST+5,sp)
2980  0639 a30004        	cpw	x,#4
2981  063c 2e05          	jrsge	L1421
2982                     ; 422         return -1;
2984  063e aeffff        	ldw	x,#65535
2986  0641 200a          	jra	L251
2987  0643               L1421:
2988                     ; 424     if (cmd_str[0] != 'R')
2990  0643 1e03          	ldw	x,(OFST+1,sp)
2991  0645 f6            	ld	a,(x)
2992  0646 a152          	cp	a,#82
2993  0648 2706          	jreq	L3421
2994                     ; 425         return -1;
2996  064a aeffff        	ldw	x,#65535
2998  064d               L251:
3000  064d 5b04          	addw	sp,#4
3001  064f 81            	ret
3002  0650               L3421:
3003                     ; 427     if (cmd_str[1] < '1' || cmd_str[1] > '6')
3005  0650 1e03          	ldw	x,(OFST+1,sp)
3006  0652 e601          	ld	a,(1,x)
3007  0654 a131          	cp	a,#49
3008  0656 2508          	jrult	L7421
3010  0658 1e03          	ldw	x,(OFST+1,sp)
3011  065a e601          	ld	a,(1,x)
3012  065c a137          	cp	a,#55
3013  065e 2505          	jrult	L5421
3014  0660               L7421:
3015                     ; 428         return -1;
3017  0660 aeffff        	ldw	x,#65535
3019  0663 20e8          	jra	L251
3020  0665               L5421:
3021                     ; 430     if (cmd_str[2] != ',')
3023  0665 1e03          	ldw	x,(OFST+1,sp)
3024  0667 e602          	ld	a,(2,x)
3025  0669 a12c          	cp	a,#44
3026  066b 2705          	jreq	L1521
3027                     ; 431         return -1;
3029  066d aeffff        	ldw	x,#65535
3031  0670 20db          	jra	L251
3032  0672               L1521:
3033                     ; 433     if (cmd_str[3] != '0' && cmd_str[3] != '1')
3035  0672 1e03          	ldw	x,(OFST+1,sp)
3036  0674 e603          	ld	a,(3,x)
3037  0676 a130          	cp	a,#48
3038  0678 270d          	jreq	L3521
3040  067a 1e03          	ldw	x,(OFST+1,sp)
3041  067c e603          	ld	a,(3,x)
3042  067e a131          	cp	a,#49
3043  0680 2705          	jreq	L3521
3044                     ; 434         return -1;
3046  0682 aeffff        	ldw	x,#65535
3048  0685 20c6          	jra	L251
3049  0687               L3521:
3050                     ; 436     relay_num = cmd_str[1] - '0';
3052  0687 1e03          	ldw	x,(OFST+1,sp)
3053  0689 e601          	ld	a,(1,x)
3054  068b a030          	sub	a,#48
3055  068d 6b01          	ld	(OFST-1,sp),a
3057                     ; 437     relay_state = cmd_str[3] - '0';
3059  068f 1e03          	ldw	x,(OFST+1,sp)
3060  0691 e603          	ld	a,(3,x)
3061  0693 a030          	sub	a,#48
3062  0695 6b02          	ld	(OFST+0,sp),a
3064                     ; 439     relay_control_set(relay_num, relay_state);
3066  0697 7b02          	ld	a,(OFST+0,sp)
3067  0699 97            	ld	xl,a
3068  069a 7b01          	ld	a,(OFST-1,sp)
3069  069c 95            	ld	xh,a
3070  069d cd04b3        	call	_relay_control_set
3072                     ; 441     return 0;
3074  06a0 5f            	clrw	x
3076  06a1 20aa          	jra	L251
3100                     ; 444 void relay_control_init(void)
3100                     ; 445 {
3101                     	switch	.text
3102  06a3               _relay_control_init:
3106                     ; 446     relay_control_set_all(1);  /* 1 = on for active-low relays */
3108  06a3 a601          	ld	a,#1
3109  06a5 cd04c7        	call	_relay_control_set_all
3111                     ; 447 }
3114  06a8 81            	ret
3139                     ; 449 void hal_w5500_reset_high(void)
3139                     ; 450 {
3140                     	switch	.text
3141  06a9               _hal_w5500_reset_high:
3145                     ; 451     GPIO_WriteHigh(W5500_RST_PORT, W5500_RST_PIN);
3147  06a9 4b20          	push	#32
3148  06ab ae5014        	ldw	x,#20500
3149  06ae cd0000        	call	_GPIO_WriteHigh
3151  06b1 84            	pop	a
3152                     ; 452 }
3155  06b2 81            	ret
3181                     ; 454 void hal_gpio_init(void){
3182                     	switch	.text
3183  06b3               _hal_gpio_init:
3187                     ; 456     GPIO_Init(DI1_PORT, DI1_PIN, GPIO_MODE_IN_PU_NO_IT);
3189  06b3 4b40          	push	#64
3190  06b5 4b04          	push	#4
3191  06b7 ae500f        	ldw	x,#20495
3192  06ba cd0000        	call	_GPIO_Init
3194  06bd 85            	popw	x
3195                     ; 457     GPIO_Init(DI2_PORT, DI2_PIN, GPIO_MODE_IN_PU_NO_IT);
3197  06be 4b40          	push	#64
3198  06c0 4b08          	push	#8
3199  06c2 ae500f        	ldw	x,#20495
3200  06c5 cd0000        	call	_GPIO_Init
3202  06c8 85            	popw	x
3203                     ; 458     GPIO_Init(DI3_PORT, DI3_PIN, GPIO_MODE_IN_PU_NO_IT);
3205  06c9 4b40          	push	#64
3206  06cb 4b10          	push	#16
3207  06cd ae500f        	ldw	x,#20495
3208  06d0 cd0000        	call	_GPIO_Init
3210  06d3 85            	popw	x
3211                     ; 459     GPIO_Init(DI4_PORT, DI4_PIN, GPIO_MODE_IN_PU_NO_IT);
3213  06d4 4b40          	push	#64
3214  06d6 4b80          	push	#128
3215  06d8 ae500f        	ldw	x,#20495
3216  06db cd0000        	call	_GPIO_Init
3218  06de 85            	popw	x
3219                     ; 462     GPIO_Init(RELAY1_PORT, RELAY1_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
3221  06df 4bf0          	push	#240
3222  06e1 4b08          	push	#8
3223  06e3 ae5005        	ldw	x,#20485
3224  06e6 cd0000        	call	_GPIO_Init
3226  06e9 85            	popw	x
3227                     ; 463     GPIO_Init(RELAY2_PORT, RELAY2_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
3229  06ea 4bf0          	push	#240
3230  06ec 4b04          	push	#4
3231  06ee ae5005        	ldw	x,#20485
3232  06f1 cd0000        	call	_GPIO_Init
3234  06f4 85            	popw	x
3235                     ; 464     GPIO_Init(RELAY3_PORT, RELAY3_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
3237  06f5 4bf0          	push	#240
3238  06f7 4b02          	push	#2
3239  06f9 ae5005        	ldw	x,#20485
3240  06fc cd0000        	call	_GPIO_Init
3242  06ff 85            	popw	x
3243                     ; 465     GPIO_Init(RELAY4_PORT, RELAY4_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
3245  0700 4bf0          	push	#240
3246  0702 4b01          	push	#1
3247  0704 ae5005        	ldw	x,#20485
3248  0707 cd0000        	call	_GPIO_Init
3250  070a 85            	popw	x
3251                     ; 466     GPIO_Init(RELAY5_PORT, RELAY5_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
3253  070b 4bf0          	push	#240
3254  070d 4b08          	push	#8
3255  070f ae500a        	ldw	x,#20490
3256  0712 cd0000        	call	_GPIO_Init
3258  0715 85            	popw	x
3259                     ; 467     GPIO_Init(RELAY6_PORT, RELAY6_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
3261  0716 4bf0          	push	#240
3262  0718 4b10          	push	#16
3263  071a ae500a        	ldw	x,#20490
3264  071d cd0000        	call	_GPIO_Init
3266  0720 85            	popw	x
3267                     ; 470     hal_relay_set(1, 1);
3269  0721 ae0101        	ldw	x,#257
3270  0724 cd042f        	call	_hal_relay_set
3272                     ; 471     hal_relay_set(2, 1);
3274  0727 ae0201        	ldw	x,#513
3275  072a cd042f        	call	_hal_relay_set
3277                     ; 472     hal_relay_set(3, 1);
3279  072d ae0301        	ldw	x,#769
3280  0730 cd042f        	call	_hal_relay_set
3282                     ; 473     hal_relay_set(4, 1);
3284  0733 ae0401        	ldw	x,#1025
3285  0736 cd042f        	call	_hal_relay_set
3287                     ; 474     hal_relay_set(5, 1);
3289  0739 ae0501        	ldw	x,#1281
3290  073c cd042f        	call	_hal_relay_set
3292                     ; 475     hal_relay_set(6, 1);
3294  073f ae0601        	ldw	x,#1537
3295  0742 cd042f        	call	_hal_relay_set
3297                     ; 478     GPIO_Init(HARDRST_PORT, HARDRST_PIN, GPIO_MODE_IN_PU_NO_IT);
3299  0745 4b40          	push	#64
3300  0747 4b80          	push	#128
3301  0749 ae5005        	ldw	x,#20485
3302  074c cd0000        	call	_GPIO_Init
3304  074f 85            	popw	x
3305                     ; 481     GPIO_Init(W5500_RST_PORT, W5500_RST_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
3307  0750 4bf0          	push	#240
3308  0752 4b20          	push	#32
3309  0754 ae5014        	ldw	x,#20500
3310  0757 cd0000        	call	_GPIO_Init
3312  075a 85            	popw	x
3313                     ; 482 	hal_w5500_reset_high();
3315  075b cd06a9        	call	_hal_w5500_reset_high
3317                     ; 483 }
3320  075e 81            	ret
3344                     ; 485 uint16_t hal_uart_available(void){
3345                     	switch	.text
3346  075f               _hal_uart_available:
3350                     ; 486 	return uart_rx_count;
3352  075f be1a          	ldw	x,L51_uart_rx_count
3355  0761 81            	ret
3394                     ; 489 uint8_t hal_uart_read_byte(void){
3395                     	switch	.text
3396  0762               _hal_uart_read_byte:
3398  0762 88            	push	a
3399       00000001      OFST:	set	1
3402                     ; 490 	uint8_t byte = 0;
3404  0763 0f01          	clr	(OFST+0,sp)
3406                     ; 491 	if (uart_rx_count > 0){
3408  0765 be1a          	ldw	x,L51_uart_rx_count
3409  0767 271b          	jreq	L3331
3410                     ; 492 		disableInterrupts();
3413  0769 9b            sim
3415                     ; 494 		byte = uart_rx_buffer[uart_rx_tail];
3418  076a be1e          	ldw	x,L12_uart_rx_tail
3419  076c e600          	ld	a,(L52_uart_rx_buffer,x)
3420  076e 6b01          	ld	(OFST+0,sp),a
3422                     ; 495 		uart_rx_tail = (uart_rx_tail + 1) % UART_RX_BUFFER_SIZE;
3424  0770 be1e          	ldw	x,L12_uart_rx_tail
3425  0772 5c            	incw	x
3426  0773 01            	rrwa	x,a
3427  0774 a41f          	and	a,#31
3428  0776 5f            	clrw	x
3429  0777 b71f          	ld	L12_uart_rx_tail+1,a
3430  0779 9f            	ld	a,xl
3431  077a b71e          	ld	L12_uart_rx_tail,a
3432                     ; 496 		uart_rx_count--;
3434  077c be1a          	ldw	x,L51_uart_rx_count
3435  077e 1d0001        	subw	x,#1
3436  0781 bf1a          	ldw	L51_uart_rx_count,x
3437                     ; 497 		enableInterrupts();
3440  0783 9a            rim
3443  0784               L3331:
3444                     ; 499 	return byte;
3446  0784 7b01          	ld	a,(OFST+0,sp)
3449  0786 5b01          	addw	sp,#1
3450  0788 81            	ret
3524                     ; 502 void uart_server_process(void){
3525                     	switch	.text
3526  0789               _uart_server_process:
3528  0789 521f          	subw	sp,#31
3529       0000001f      OFST:	set	31
3532                     ; 508 	if (uart_state == UART_STATE_IDLE){
3534  078b 3d18          	tnz	L11_uart_state
3535  078d 2603          	jrne	L271
3536  078f cc084a        	jp	L071
3537  0792               L271:
3538                     ; 509 		return;
3540                     ; 511 	available_len = hal_uart_available();
3542  0792 adcb          	call	_hal_uart_available
3544  0794 1f05          	ldw	(OFST-26,sp),x
3546                     ; 513 	if(available_len > 0){
3548  0796 1e05          	ldw	x,(OFST-26,sp)
3549  0798 2603          	jrne	L471
3550  079a cc0846        	jp	L1731
3551  079d               L471:
3552                     ; 514 		uart_state = UART_STATE_RX_PENDING;
3554  079d 35020018      	mov	L11_uart_state,#2
3556  07a1 ac320832      	jpf	L7731
3557  07a5               L3731:
3558                     ; 517 			read_byte = hal_uart_read_byte();
3560  07a5 adbb          	call	_hal_uart_read_byte
3562  07a7 6b1f          	ld	(OFST+0,sp),a
3564                     ; 519 			if (read_byte == '\n' || read_byte == '\r'){
3566  07a9 7b1f          	ld	a,(OFST+0,sp)
3567  07ab a10a          	cp	a,#10
3568  07ad 2706          	jreq	L5041
3570  07af 7b1f          	ld	a,(OFST+0,sp)
3571  07b1 a10d          	cp	a,#13
3572  07b3 265c          	jrne	L3041
3573  07b5               L5041:
3574                     ; 520 				if(uart_rx_count > 0){
3576  07b5 be1a          	ldw	x,L51_uart_rx_count
3577  07b7 2772          	jreq	L7141
3578                     ; 521 					uart_rx_buffer[uart_rx_count] = '\0';
3580  07b9 be1a          	ldw	x,L51_uart_rx_count
3581  07bb 6f00          	clr	(L52_uart_rx_buffer,x)
3582                     ; 522 					if (command_parser_execute((const char *)uart_rx_buffer,uart_rx_count) == 0){
3584  07bd be1a          	ldw	x,L51_uart_rx_count
3585  07bf 89            	pushw	x
3586  07c0 ae0000        	ldw	x,#L52_uart_rx_buffer
3587  07c3 cd0634        	call	_command_parser_execute
3589  07c6 5b02          	addw	sp,#2
3590  07c8 a30000        	cpw	x,#0
3591  07cb 2634          	jrne	L1141
3592                     ; 523 						state = sensor_reader_get_state();
3594  07cd 96            	ldw	x,sp
3595  07ce 1c001b        	addw	x,#OFST-4
3596  07d1 89            	pushw	x
3597  07d2 cd00c1        	call	_sensor_reader_get_state
3599  07d5 85            	popw	x
3600                     ; 524 						message_formatter_alive(resp_buf, sizeof(resp_buf),state.di1,state.di2,state.di3,state.di4);
3602  07d6 7b1e          	ld	a,(OFST-1,sp)
3603  07d8 88            	push	a
3604  07d9 7b1e          	ld	a,(OFST-1,sp)
3605  07db 88            	push	a
3606  07dc 7b1e          	ld	a,(OFST-1,sp)
3607  07de 88            	push	a
3608  07df 7b1e          	ld	a,(OFST-1,sp)
3609  07e1 88            	push	a
3610  07e2 ae0014        	ldw	x,#20
3611  07e5 89            	pushw	x
3612  07e6 96            	ldw	x,sp
3613  07e7 1c000d        	addw	x,#OFST-18
3614  07ea cd00cd        	call	_message_formatter_alive
3616  07ed 5b06          	addw	sp,#6
3617                     ; 525 					 	uart_server_send((uint8_t *)resp_buf,strlen(resp_buf));
3619  07ef 96            	ldw	x,sp
3620  07f0 1c0007        	addw	x,#OFST-24
3621  07f3 cd0000        	call	_strlen
3623  07f6 89            	pushw	x
3624  07f7 96            	ldw	x,sp
3625  07f8 1c0009        	addw	x,#OFST-22
3626  07fb cd008c        	call	_uart_server_send
3628  07fe 85            	popw	x
3630  07ff 200b          	jra	L3141
3631  0801               L1141:
3632                     ; 528                         uart_server_send((uint8_t *)"ERROR,INVALID_COMMAND\n",strlen("ERROR,INVALID_COMMAND\n"));
3634  0801 ae0016        	ldw	x,#22
3635  0804 89            	pushw	x
3636  0805 ae0017        	ldw	x,#L5141
3637  0808 cd008c        	call	_uart_server_send
3639  080b 85            	popw	x
3640  080c               L3141:
3641                     ; 530                     uart_rx_count = 0;
3643  080c 5f            	clrw	x
3644  080d bf1a          	ldw	L51_uart_rx_count,x
3645  080f 201a          	jra	L7141
3646  0811               L3041:
3647                     ; 533             else if (read_byte >= 32 && read_byte < 127){
3649  0811 7b1f          	ld	a,(OFST+0,sp)
3650  0813 a120          	cp	a,#32
3651  0815 2514          	jrult	L7141
3653  0817 7b1f          	ld	a,(OFST+0,sp)
3654  0819 a17f          	cp	a,#127
3655  081b 240e          	jruge	L7141
3656                     ; 534                 uart_rx_buffer[uart_rx_count++] = read_byte;
3658  081d 7b1f          	ld	a,(OFST+0,sp)
3659  081f be1a          	ldw	x,L51_uart_rx_count
3660  0821 1c0001        	addw	x,#1
3661  0824 bf1a          	ldw	L51_uart_rx_count,x
3662  0826 1d0001        	subw	x,#1
3663  0829 e700          	ld	(L52_uart_rx_buffer,x),a
3664  082b               L7141:
3665                     ; 536             available_len--;
3667  082b 1e05          	ldw	x,(OFST-26,sp)
3668  082d 1d0001        	subw	x,#1
3669  0830 1f05          	ldw	(OFST-26,sp),x
3671  0832               L7731:
3672                     ; 516 		while (available_len > 0 && uart_rx_count < sizeof(uart_rx_buffer) - 1){
3674  0832 1e05          	ldw	x,(OFST-26,sp)
3675  0834 270a          	jreq	L3241
3677  0836 be1a          	ldw	x,L51_uart_rx_count
3678  0838 a3001f        	cpw	x,#31
3679  083b 2403          	jruge	L671
3680  083d cc07a5        	jp	L3731
3681  0840               L671:
3682  0840               L3241:
3683                     ; 538         uart_state = UART_STATE_READY;
3685  0840 35010018      	mov	L11_uart_state,#1
3687  0844 2004          	jra	L5241
3688  0846               L1731:
3689                     ; 541         uart_state = UART_STATE_READY;
3691  0846 35010018      	mov	L11_uart_state,#1
3692  084a               L5241:
3693                     ; 543 }
3694  084a               L071:
3697  084a 5b1f          	addw	sp,#31
3698  084c 81            	ret
3735                     ; 544 uint8_t hal_spi_byte(uint8_t data)
3735                     ; 545 {
3736                     	switch	.text
3737  084d               _hal_spi_byte:
3739  084d 88            	push	a
3740       00000000      OFST:	set	0
3743  084e               L7441:
3744                     ; 546     while (SPI_GetFlagStatus(SPI_FLAG_TXE) == RESET);
3746  084e a602          	ld	a,#2
3747  0850 cd0000        	call	_SPI_GetFlagStatus
3749  0853 4d            	tnz	a
3750  0854 27f8          	jreq	L7441
3751                     ; 548     SPI_SendData(data);
3753  0856 7b01          	ld	a,(OFST+1,sp)
3754  0858 cd0000        	call	_SPI_SendData
3757  085b               L5541:
3758                     ; 550     while (SPI_GetFlagStatus(SPI_FLAG_RXNE) == RESET);
3760  085b a601          	ld	a,#1
3761  085d cd0000        	call	_SPI_GetFlagStatus
3763  0860 4d            	tnz	a
3764  0861 27f8          	jreq	L5541
3765                     ; 552     return SPI_ReceiveData();
3767  0863 cd0000        	call	_SPI_ReceiveData
3771  0866 5b01          	addw	sp,#1
3772  0868 81            	ret
3796                     ; 554 uint8_t hal_spi_read_byte(void)
3796                     ; 555 {
3797                     	switch	.text
3798  0869               _hal_spi_read_byte:
3802                     ; 556     return hal_spi_byte(0xFF);
3804  0869 a6ff          	ld	a,#255
3805  086b ade0          	call	_hal_spi_byte
3809  086d 81            	ret
3844                     ; 558 void hal_spi_write_byte(uint8_t data)
3844                     ; 559 {
3845                     	switch	.text
3846  086e               _hal_spi_write_byte:
3850                     ; 560     hal_spi_byte(data);
3852  086e addd          	call	_hal_spi_byte
3854                     ; 561 }
3857  0870 81            	ret
3911                     ; 562 void hal_spi_read(uint8_t *buf, uint16_t len){
3912                     	switch	.text
3913  0871               _hal_spi_read:
3915  0871 89            	pushw	x
3916  0872 89            	pushw	x
3917       00000002      OFST:	set	2
3920                     ; 564     for(i = 0; i < len; i++){
3922  0873 5f            	clrw	x
3923  0874 1f01          	ldw	(OFST-1,sp),x
3926  0876 2011          	jra	L1451
3927  0878               L5351:
3928                     ; 565         buf[i] = hal_spi_byte(0xFF);
3930  0878 a6ff          	ld	a,#255
3931  087a add1          	call	_hal_spi_byte
3933  087c 1e03          	ldw	x,(OFST+1,sp)
3934  087e 72fb01        	addw	x,(OFST-1,sp)
3935  0881 f7            	ld	(x),a
3936                     ; 564     for(i = 0; i < len; i++){
3938  0882 1e01          	ldw	x,(OFST-1,sp)
3939  0884 1c0001        	addw	x,#1
3940  0887 1f01          	ldw	(OFST-1,sp),x
3942  0889               L1451:
3945  0889 1e01          	ldw	x,(OFST-1,sp)
3946  088b 1307          	cpw	x,(OFST+5,sp)
3947  088d 25e9          	jrult	L5351
3948                     ; 567 }
3951  088f 5b04          	addw	sp,#4
3952  0891 81            	ret
4006                     ; 569 void hal_spi_write(uint8_t *buf, uint16_t len){
4007                     	switch	.text
4008  0892               _hal_spi_write:
4010  0892 89            	pushw	x
4011  0893 89            	pushw	x
4012       00000002      OFST:	set	2
4015                     ; 571     for(i = 0; i < len; i++){
4017  0894 5f            	clrw	x
4018  0895 1f01          	ldw	(OFST-1,sp),x
4021  0897 200f          	jra	L7751
4022  0899               L3751:
4023                     ; 572         hal_spi_byte(buf[i]);
4025  0899 1e03          	ldw	x,(OFST+1,sp)
4026  089b 72fb01        	addw	x,(OFST-1,sp)
4027  089e f6            	ld	a,(x)
4028  089f adac          	call	_hal_spi_byte
4030                     ; 571     for(i = 0; i < len; i++){
4032  08a1 1e01          	ldw	x,(OFST-1,sp)
4033  08a3 1c0001        	addw	x,#1
4034  08a6 1f01          	ldw	(OFST-1,sp),x
4036  08a8               L7751:
4039  08a8 1e01          	ldw	x,(OFST-1,sp)
4040  08aa 1307          	cpw	x,(OFST+5,sp)
4041  08ac 25eb          	jrult	L3751
4042                     ; 574 }
4045  08ae 5b04          	addw	sp,#4
4046  08b0 81            	ret
4088                     ; 576 void uart_server_init(uint32_t baudrate){
4089                     	switch	.text
4090  08b1               _uart_server_init:
4092       00000000      OFST:	set	0
4095                     ; 577 	uart_state = UART_STATE_IDLE;
4097  08b1 3f18          	clr	L11_uart_state
4098                     ; 578 	uart_rx_count = 0;
4100  08b3 5f            	clrw	x
4101  08b4 bf1a          	ldw	L51_uart_rx_count,x
4102                     ; 579 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_UART1, ENABLE);
4104  08b6 ae0301        	ldw	x,#769
4105  08b9 cd0000        	call	_CLK_PeripheralClockConfig
4107                     ; 580     UART1_Init(
4107                     ; 581     baudrate,
4107                     ; 582     UART1_WORDLENGTH_8D,
4107                     ; 583     UART1_STOPBITS_1,
4107                     ; 584     UART1_PARITY_NO,
4107                     ; 585     UART1_SYNCMODE_CLOCK_DISABLE,
4107                     ; 586     (UART1_Mode_TypeDef)(UART1_MODE_TX_ENABLE | UART1_MODE_RX_ENABLE)
4107                     ; 587 );
4109  08bc 4b0c          	push	#12
4110  08be 4b80          	push	#128
4111  08c0 4b00          	push	#0
4112  08c2 4b00          	push	#0
4113  08c4 4b00          	push	#0
4114  08c6 1e0a          	ldw	x,(OFST+10,sp)
4115  08c8 89            	pushw	x
4116  08c9 1e0a          	ldw	x,(OFST+10,sp)
4117  08cb 89            	pushw	x
4118  08cc cd0000        	call	_UART1_Init
4120  08cf 5b09          	addw	sp,#9
4121                     ; 589     UART1_ITConfig(UART1_IT_RXNE, ENABLE);
4123  08d1 4b01          	push	#1
4124  08d3 ae0255        	ldw	x,#597
4125  08d6 cd0000        	call	_UART1_ITConfig
4127  08d9 84            	pop	a
4128                     ; 592     UART1_Cmd(ENABLE);
4130  08da a601          	ld	a,#1
4131  08dc cd0000        	call	_UART1_Cmd
4133                     ; 594     uart_rx_head = 0;
4135  08df 5f            	clrw	x
4136  08e0 bf1c          	ldw	L71_uart_rx_head,x
4137                     ; 595     uart_rx_tail = 0;
4139  08e2 5f            	clrw	x
4140  08e3 bf1e          	ldw	L12_uart_rx_tail,x
4141                     ; 596     uart_rx_count = 0;  
4143  08e5 5f            	clrw	x
4144  08e6 bf1a          	ldw	L51_uart_rx_count,x
4145                     ; 597 	uart_state = UART_STATE_READY;
4147  08e8 35010018      	mov	L11_uart_state,#1
4148                     ; 598 }
4151  08ec 81            	ret
4179                     ; 600 void hal_timer_init(void){
4180                     	switch	.text
4181  08ed               _hal_timer_init:
4185                     ; 601     CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER4, ENABLE);
4187  08ed ae0401        	ldw	x,#1025
4188  08f0 cd0000        	call	_CLK_PeripheralClockConfig
4190                     ; 602     TIM4_TimeBaseInit(TIM4_PRESCALER_128, 125);
4192  08f3 ae077d        	ldw	x,#1917
4193  08f6 cd0000        	call	_TIM4_TimeBaseInit
4195                     ; 603     TIM4_ClearFlag(TIM4_FLAG_UPDATE);
4197  08f9 a601          	ld	a,#1
4198  08fb cd0000        	call	_TIM4_ClearFlag
4200                     ; 605     TIM4_ITConfig(TIM4_IT_UPDATE, ENABLE);
4202  08fe ae0101        	ldw	x,#257
4203  0901 cd0000        	call	_TIM4_ITConfig
4205                     ; 607     enableInterrupts();
4208  0904 9a            rim
4210                     ; 608 }
4214  0905 81            	ret
4262                     ; 610 void w5500_chip_init(void)
4262                     ; 611 {
4263                     	switch	.text
4264  0906               _w5500_chip_init:
4268                     ; 615     GPIO_WriteLow(W5500_RST_PORT, W5500_RST_PIN);
4270  0906 4b20          	push	#32
4271  0908 ae5014        	ldw	x,#20500
4272  090b cd0000        	call	_GPIO_WriteLow
4274  090e 84            	pop	a
4275                     ; 616     hal_delay_ms(100);
4277  090f ae0064        	ldw	x,#100
4278  0912 cd0007        	call	_hal_delay_ms
4280                     ; 617     hal_w5500_reset_high();
4282  0915 cd06a9        	call	_hal_w5500_reset_high
4284                     ; 618     GPIO_WriteHigh(W5500_RST_PORT, W5500_RST_PIN);
4286  0918 4b20          	push	#32
4287  091a ae5014        	ldw	x,#20500
4288  091d cd0000        	call	_GPIO_WriteHigh
4290  0920 84            	pop	a
4291                     ; 619     CLK_PeripheralClockConfig(CLK_PERIPHERAL_SPI, ENABLE);
4293  0921 ae0101        	ldw	x,#257
4294  0924 cd0000        	call	_CLK_PeripheralClockConfig
4296                     ; 620     GPIO_Init(W5500_SCK_PORT,W5500_SCK_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
4298  0927 4bf0          	push	#240
4299  0929 4b20          	push	#32
4300  092b ae500a        	ldw	x,#20490
4301  092e cd0000        	call	_GPIO_Init
4303  0931 85            	popw	x
4304                     ; 621     GPIO_Init(W5500_MOSI_PORT,W5500_MOSI_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
4306  0932 4bf0          	push	#240
4307  0934 4b40          	push	#64
4308  0936 ae500a        	ldw	x,#20490
4309  0939 cd0000        	call	_GPIO_Init
4311  093c 85            	popw	x
4312                     ; 622     GPIO_Init(W5500_MISO_PORT,W5500_MISO_PIN,GPIO_MODE_IN_FL_NO_IT);
4314  093d 4b00          	push	#0
4315  093f 4b80          	push	#128
4316  0941 ae500a        	ldw	x,#20490
4317  0944 cd0000        	call	_GPIO_Init
4319  0947 85            	popw	x
4320                     ; 623     GPIO_Init(W5500_CS_PORT,W5500_CS_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
4322  0948 4bf0          	push	#240
4323  094a 4b08          	push	#8
4324  094c ae5000        	ldw	x,#20480
4325  094f cd0000        	call	_GPIO_Init
4327  0952 85            	popw	x
4328                     ; 624     GPIO_WriteHigh(W5500_CS_PORT, W5500_CS_PIN);
4330  0953 4b08          	push	#8
4331  0955 ae5000        	ldw	x,#20480
4332  0958 cd0000        	call	_GPIO_WriteHigh
4334  095b 84            	pop	a
4335                     ; 625     GPIO_Init(W5500_RST_PORT,W5500_RST_PIN,GPIO_MODE_OUT_PP_HIGH_FAST);
4337  095c 4bf0          	push	#240
4338  095e 4b20          	push	#32
4339  0960 ae5014        	ldw	x,#20500
4340  0963 cd0000        	call	_GPIO_Init
4342  0966 85            	popw	x
4343                     ; 626     SPI_DeInit();
4345  0967 cd0000        	call	_SPI_DeInit
4347                     ; 627         SPI_Init(
4347                     ; 628         SPI_FIRSTBIT_MSB,
4347                     ; 629         SPI_BAUDRATEPRESCALER_4,
4347                     ; 630         SPI_MODE_MASTER,
4347                     ; 631         SPI_CLOCKPOLARITY_LOW,
4347                     ; 632         SPI_CLOCKPHASE_1EDGE,
4347                     ; 633         SPI_DATADIRECTION_2LINES_FULLDUPLEX,
4347                     ; 634         SPI_NSS_SOFT,
4347                     ; 635         0x07
4347                     ; 636     );
4349  096a 4b07          	push	#7
4350  096c 4b02          	push	#2
4351  096e 4b00          	push	#0
4352  0970 4b00          	push	#0
4353  0972 4b00          	push	#0
4354  0974 4b04          	push	#4
4355  0976 ae0008        	ldw	x,#8
4356  0979 cd0000        	call	_SPI_Init
4358  097c 5b06          	addw	sp,#6
4359                     ; 638     SPI_Cmd(ENABLE);
4361  097e a601          	ld	a,#1
4362  0980 cd0000        	call	_SPI_Cmd
4364                     ; 639     reg_wizchip_spi_cbfunc(hal_spi_read_byte,hal_spi_write_byte);
4366  0983 ae086e        	ldw	x,#_hal_spi_write_byte
4367  0986 89            	pushw	x
4368  0987 ae0869        	ldw	x,#_hal_spi_read_byte
4369  098a cd0000        	call	_reg_wizchip_spi_cbfunc
4371  098d 85            	popw	x
4372                     ; 640     reg_wizchip_spiburst_cbfunc(hal_spi_read,hal_spi_write);
4374  098e ae0892        	ldw	x,#_hal_spi_write
4375  0991 89            	pushw	x
4376  0992 ae0871        	ldw	x,#_hal_spi_read
4377  0995 cd0000        	call	_reg_wizchip_spiburst_cbfunc
4379  0998 85            	popw	x
4380                     ; 641     reg_wizchip_cs_cbfunc(hal_spi_cs_low,hal_spi_cs_high);
4382  0999 ae0082        	ldw	x,#_hal_spi_cs_high
4383  099c 89            	pushw	x
4384  099d ae0078        	ldw	x,#_hal_spi_cs_low
4385  09a0 cd0000        	call	_reg_wizchip_cs_cbfunc
4387  09a3 85            	popw	x
4388                     ; 642     wizchip_init(0, 0);
4390  09a4 5f            	clrw	x
4391  09a5 89            	pushw	x
4392  09a6 5f            	clrw	x
4393  09a7 cd0000        	call	_wizchip_init
4395  09aa 85            	popw	x
4396                     ; 643 }
4399  09ab 81            	ret
4434                     ; 645 void system_init(void){
4435                     	switch	.text
4436  09ac               _system_init:
4440                     ; 647     CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);  /* 16MHz clock */
4442  09ac 4f            	clr	a
4443  09ad cd0000        	call	_CLK_HSIPrescalerConfig
4445                     ; 649 	hal_gpio_init();
4447  09b0 cd06b3        	call	_hal_gpio_init
4449                     ; 650     hal_timer_init();
4451  09b3 cd08ed        	call	_hal_timer_init
4453                     ; 652 	relay_control_init();
4455  09b6 cd06a3        	call	_relay_control_init
4457                     ; 653 	sensor_reader_init();
4459  09b9 cd05a4        	call	_sensor_reader_init
4461                     ; 655     w5500_chip_init();
4463  09bc cd0906        	call	_w5500_chip_init
4465                     ; 657     uart_server_init(UART_BAUDRATE);
4467  09bf aec200        	ldw	x,#49664
4468  09c2 89            	pushw	x
4469  09c3 ae0001        	ldw	x,#1
4470  09c6 89            	pushw	x
4471  09c7 cd08b1        	call	_uart_server_init
4473  09ca 5b04          	addw	sp,#4
4474                     ; 660     hal_timer_set_callback(timer_callback);
4476  09cc ae05e7        	ldw	x,#_timer_callback
4477  09cf cd0631        	call	_hal_timer_set_callback
4479                     ; 661     hal_timer_start();
4481  09d2 cd0515        	call	_hal_timer_start
4483                     ; 662 	hal_delay_ms(500);
4485  09d5 ae01f4        	ldw	x,#500
4486  09d8 cd0007        	call	_hal_delay_ms
4488                     ; 663 }
4491  09db 81            	ret
4494                     	switch	.const
4495  000c               L1561_msg:
4496  000c 52455345542c  	dc.b	"RESET, OK",10,0
4535                     ; 665 void main_loop(void)
4535                     ; 666 {
4536                     	switch	.text
4537  09dc               _main_loop:
4539  09dc 520b          	subw	sp,#11
4540       0000000b      OFST:	set	11
4543  09de               L1761:
4544                     ; 670 		uart_server_process();
4546  09de cd0789        	call	_uart_server_process
4548                     ; 672         if(GPIO_ReadInputPin(HARDRST_PORT, HARDRST_PIN) == RESET)
4550  09e1 4b80          	push	#128
4551  09e3 ae5005        	ldw	x,#20485
4552  09e6 cd0000        	call	_GPIO_ReadInputPin
4554  09e9 5b01          	addw	sp,#1
4555  09eb 4d            	tnz	a
4556  09ec 26f0          	jrne	L1761
4557                     ; 674             hal_delay_ms(50);
4559  09ee ae0032        	ldw	x,#50
4560  09f1 cd0007        	call	_hal_delay_ms
4562                     ; 675 			if (GPIO_ReadInputPin(HARDRST_PORT, HARDRST_PIN) == 0){
4564  09f4 4b80          	push	#128
4565  09f6 ae5005        	ldw	x,#20485
4566  09f9 cd0000        	call	_GPIO_ReadInputPin
4568  09fc 5b01          	addw	sp,#1
4569  09fe 4d            	tnz	a
4570  09ff 26dd          	jrne	L1761
4571                     ; 677 				char msg[] = "RESET, OK\n";
4573  0a01 96            	ldw	x,sp
4574  0a02 1c0001        	addw	x,#OFST-10
4575  0a05 90ae000c      	ldw	y,#L1561_msg
4576  0a09 a60b          	ld	a,#11
4577  0a0b cd0000        	call	c_xymov
4579                     ; 678                 if (uart_server_is_ready()){
4581  0a0e cd0034        	call	_uart_server_is_ready
4583  0a11 a30000        	cpw	x,#0
4584  0a14 2710          	jreq	L1071
4585                     ; 679                     uart_server_send((uint8_t *)msg, strlen(msg));
4587  0a16 96            	ldw	x,sp
4588  0a17 1c0001        	addw	x,#OFST-10
4589  0a1a cd0000        	call	_strlen
4591  0a1d 89            	pushw	x
4592  0a1e 96            	ldw	x,sp
4593  0a1f 1c0003        	addw	x,#OFST-8
4594  0a22 cd008c        	call	_uart_server_send
4596  0a25 85            	popw	x
4597  0a26               L1071:
4598                     ; 681 				hal_delay_ms(100);
4600  0a26 ae0064        	ldw	x,#100
4601  0a29 cd0007        	call	_hal_delay_ms
4603  0a2c 20b0          	jra	L1761
4628                     ; 688 int main(void)
4628                     ; 689 {
4629                     	switch	.text
4630  0a2e               _main:
4634                     ; 690 	system_init();
4636  0a2e cd09ac        	call	_system_init
4638                     ; 691     main_loop();
4640  0a31 ada9          	call	_main_loop
4642  0a33               L3171:
4643                     ; 692     while(1);
4645  0a33 20fe          	jra	L3171
4889                     	xdef	_main
4890                     	xdef	_main_loop
4891                     	xdef	_system_init
4892                     	xdef	_w5500_chip_init
4893                     	xdef	_hal_timer_init
4894                     	xdef	_uart_server_init
4895                     	xdef	_hal_spi_write
4896                     	xdef	_hal_spi_read
4897                     	xdef	_hal_spi_write_byte
4898                     	xdef	_hal_spi_read_byte
4899                     	xdef	_hal_spi_byte
4900                     	xdef	_uart_server_process
4901                     	xdef	_hal_uart_read_byte
4902                     	xdef	_hal_uart_available
4903                     	xdef	_hal_gpio_init
4904                     	xdef	_hal_w5500_reset_high
4905                     	xdef	_relay_control_init
4906                     	xdef	_command_parser_execute
4907                     	xdef	_hal_timer_set_callback
4908                     	xdef	_timer_callback
4909                     	xdef	_send_alive_message
4910                     	xdef	_sensor_reader_init
4911                     	xdef	_process_axle_counting
4912                     	xdef	_hal_timer_start
4913                     	xdef	_sensor_reader_update
4914                     	xdef	_relay_control_set_all
4915                     	xdef	_relay_control_set
4916                     	xdef	_hal_relay_set
4917                     	xdef	_message_formatter_avcc
4918                     	xdef	_hal_di_read
4919                     	xdef	_message_formatter_alive
4920                     	xdef	_sensor_reader_get_state
4921                     	xdef	_uart_server_send
4922                     	xdef	_hal_spi_cs_high
4923                     	xdef	_hal_spi_cs_low
4924                     	xdef	_hal_uart_send
4925                     	xdef	_hal_uart_send_byte
4926                     	xdef	_uart_server_is_ready
4927                     	xdef	_hal_delay_ms
4928                     	xdef	_hal_get_millis
4929                     	switch	.ubsct
4930  0000               L52_uart_rx_buffer:
4931  0000 000000000000  	ds.b	32
4932  0020               L32_uart_tx_buffer:
4933  0020 000000000000  	ds.b	32
4934                     	xref	_strlen
4935                     	xref	_wizchip_init
4936                     	xref	_reg_wizchip_spiburst_cbfunc
4937                     	xref	_reg_wizchip_spi_cbfunc
4938                     	xref	_reg_wizchip_cs_cbfunc
4939                     	xref	_TIM4_ClearFlag
4940                     	xref	_TIM4_ITConfig
4941                     	xref	_TIM4_Cmd
4942                     	xref	_TIM4_TimeBaseInit
4943                     	xref	_SPI_GetFlagStatus
4944                     	xref	_SPI_ReceiveData
4945                     	xref	_SPI_SendData
4946                     	xref	_SPI_Cmd
4947                     	xref	_SPI_Init
4948                     	xref	_SPI_DeInit
4949                     	xref	_UART1_GetFlagStatus
4950                     	xref	_UART1_SendData8
4951                     	xref	_UART1_ITConfig
4952                     	xref	_UART1_Cmd
4953                     	xref	_UART1_Init
4954                     	xref	_GPIO_ReadInputPin
4955                     	xref	_GPIO_WriteLow
4956                     	xref	_GPIO_WriteHigh
4957                     	xref	_GPIO_Init
4958                     	xref	_CLK_HSIPrescalerConfig
4959                     	xref	_CLK_PeripheralClockConfig
4960                     	switch	.const
4961  0017               L5141:
4962  0017 4552524f522c  	dc.b	"ERROR,INVALID_COMM"
4963  0029 414e440a00    	dc.b	"AND",10,0
4964                     	xref.b	c_lreg
4965                     	xref.b	c_x
4985                     	xref	c_lgadc
4986                     	xref	c_ludv
4987                     	xref	c_ladc
4988                     	xref	c_lumd
4989                     	xref	c_lzmp
4990                     	xref	c_xymov
4991                     	xref	c_lcmp
4992                     	xref	c_lsub
4993                     	xref	c_uitolx
4994                     	xref	c_rtol
4995                     	xref	c_ltor
4996                     	end
