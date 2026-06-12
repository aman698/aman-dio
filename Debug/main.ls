   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  14                     	bsct
  15  0000               L3_current_state:
  16  0000 00            	dc.b	0
  17  0001 00            	dc.b	0
  18  0002 00            	dc.b	0
  19  0003 00            	dc.b	0
  20  0004               L5_server_state:
  21  0004 00            	dc.b	0
  22  0005               L7_uart_state:
  23  0005 00            	dc.b	0
  24  0006               L11_server_socket:
  25  0006 00            	dc.b	0
  26  0007               L51_uart_rx_count:
  27  0007 0000          	dc.w	0
  28  0009               L71_uart_rx_head:
  29  0009 0000          	dc.w	0
  30  000b               L12_uart_rx_tail:
  31  000b 0000          	dc.w	0
  98                     ; 48 sensor_state_t sensor_reader_get_state(void)
  98                     ; 49 {
 100                     	switch	.text
 101  0000               _sensor_reader_get_state:
 103       00000000      OFST:	set	0
 106                     ; 50     return current_state;
 108  0000 1e03          	ldw	x,(OFST+3,sp)
 109  0002 90ae0000      	ldw	y,#L3_current_state
 110  0006 a604          	ld	a,#4
 111  0008 cd0000        	call	c_xymov
 115  000b 81            	ret
 197                     ; 53 void message_formatter_alive(char *buf,
 197                     ; 54                              int buf_size,
 197                     ; 55                              uint8_t di1,
 197                     ; 56                              uint8_t di2,
 197                     ; 57                              uint8_t di3,
 197                     ; 58                              uint8_t di4)
 197                     ; 59 {
 198                     	switch	.text
 199  000c               _message_formatter_alive:
 201  000c 89            	pushw	x
 202       00000000      OFST:	set	0
 205                     ; 60     if (buf == 0)
 207  000d a30000        	cpw	x,#0
 208  0010 2708          	jreq	L01
 209                     ; 61         return;
 211                     ; 63     if (buf_size < 32)
 213  0012 9c            	rvf
 214  0013 1e05          	ldw	x,(OFST+5,sp)
 215  0015 a30020        	cpw	x,#32
 216  0018 2e02          	jrsge	L321
 217                     ; 64         return;
 218  001a               L01:
 221  001a 85            	popw	x
 222  001b 81            	ret
 223  001c               L321:
 224                     ; 66     sprintf(buf,
 224                     ; 67             "START,ALIVE,%d%d%d%d,END",
 224                     ; 68             di1,
 224                     ; 69             di2,
 224                     ; 70             di3,
 224                     ; 71             di4);
 226  001c 7b0a          	ld	a,(OFST+10,sp)
 227  001e 88            	push	a
 228  001f 7b0a          	ld	a,(OFST+10,sp)
 229  0021 88            	push	a
 230  0022 7b0a          	ld	a,(OFST+10,sp)
 231  0024 88            	push	a
 232  0025 7b0a          	ld	a,(OFST+10,sp)
 233  0027 88            	push	a
 234  0028 ae000b        	ldw	x,#L521
 235  002b 89            	pushw	x
 236  002c 1e07          	ldw	x,(OFST+7,sp)
 237  002e cd0000        	call	_sprintf
 239  0031 5b06          	addw	sp,#6
 240                     ; 72 }
 242  0033 20e5          	jra	L01
 434                     ; 74 uint8_t hal_di_read(uint8_t di_num)
 434                     ; 75 {
 435                     	switch	.text
 436  0035               _hal_di_read:
 438  0035 5203          	subw	sp,#3
 439       00000003      OFST:	set	3
 442                     ; 79     switch (di_num) {
 445                     ; 84         default: return 0;
 446  0037 4a            	dec	a
 447  0038 270c          	jreq	L721
 448  003a 4a            	dec	a
 449  003b 2714          	jreq	L131
 450  003d 4a            	dec	a
 451  003e 271c          	jreq	L331
 452  0040 4a            	dec	a
 453  0041 2724          	jreq	L531
 454  0043               L731:
 457  0043 4f            	clr	a
 459  0044 203d          	jra	L02
 460  0046               L721:
 461                     ; 80         case 1: port = DI1_PORT; pin = DI1_PIN; break;
 463  0046 ae500f        	ldw	x,#20495
 464  0049 1f01          	ldw	(OFST-2,sp),x
 468  004b a604          	ld	a,#4
 469  004d 6b03          	ld	(OFST+0,sp),a
 473  004f 201f          	jra	L552
 474  0051               L131:
 475                     ; 81         case 2: port = DI2_PORT; pin = DI2_PIN; break;
 477  0051 ae500f        	ldw	x,#20495
 478  0054 1f01          	ldw	(OFST-2,sp),x
 482  0056 a608          	ld	a,#8
 483  0058 6b03          	ld	(OFST+0,sp),a
 487  005a 2014          	jra	L552
 488  005c               L331:
 489                     ; 82         case 3: port = DI3_PORT; pin = DI3_PIN; break;
 491  005c ae500f        	ldw	x,#20495
 492  005f 1f01          	ldw	(OFST-2,sp),x
 496  0061 a610          	ld	a,#16
 497  0063 6b03          	ld	(OFST+0,sp),a
 501  0065 2009          	jra	L552
 502  0067               L531:
 503                     ; 83         case 4: port = DI4_PORT; pin = DI4_PIN; break;
 505  0067 ae500f        	ldw	x,#20495
 506  006a 1f01          	ldw	(OFST-2,sp),x
 510  006c a680          	ld	a,#128
 511  006e 6b03          	ld	(OFST+0,sp),a
 515  0070               L552:
 516                     ; 86     return (GPIO_ReadInputPin(port, pin) == SET) ? 1 : 0;
 518  0070 7b03          	ld	a,(OFST+0,sp)
 519  0072 88            	push	a
 520  0073 1e02          	ldw	x,(OFST-1,sp)
 521  0075 cd0000        	call	_GPIO_ReadInputPin
 523  0078 5b01          	addw	sp,#1
 524  007a a101          	cp	a,#1
 525  007c 2604          	jrne	L41
 526  007e a601          	ld	a,#1
 527  0080 2001          	jra	L61
 528  0082               L41:
 529  0082 4f            	clr	a
 530  0083               L61:
 532  0083               L02:
 534  0083 5b03          	addw	sp,#3
 535  0085 81            	ret
 561                     ; 89 void sensor_reader_update(void)
 561                     ; 90 {
 562                     	switch	.text
 563  0086               _sensor_reader_update:
 567                     ; 91     current_state.di1 = hal_di_read(1);
 569  0086 a601          	ld	a,#1
 570  0088 adab          	call	_hal_di_read
 572  008a b700          	ld	L3_current_state,a
 573                     ; 92     current_state.di2 = hal_di_read(2);
 575  008c a602          	ld	a,#2
 576  008e ada5          	call	_hal_di_read
 578  0090 b701          	ld	L3_current_state+1,a
 579                     ; 93     current_state.di3 = hal_di_read(3);
 581  0092 a603          	ld	a,#3
 582  0094 ad9f          	call	_hal_di_read
 584  0096 b702          	ld	L3_current_state+2,a
 585                     ; 94     current_state.di4 = hal_di_read(4);
 587  0098 a604          	ld	a,#4
 588  009a ad99          	call	_hal_di_read
 590  009c b703          	ld	L3_current_state+3,a
 591                     ; 95 }
 594  009e 81            	ret
 618                     ; 97 void sensor_reader_init(void)
 618                     ; 98 {
 619                     	switch	.text
 620  009f               _sensor_reader_init:
 624                     ; 100     sensor_reader_update();
 626  009f ade5          	call	_sensor_reader_update
 628                     ; 101 }
 631  00a1 81            	ret
 728                     ; 103 void hal_relay_set(uint8_t relay_num, uint8_t state){
 729                     	switch	.text
 730  00a2               _hal_relay_set:
 732  00a2 89            	pushw	x
 733  00a3 5204          	subw	sp,#4
 734       00000004      OFST:	set	4
 737                     ; 106 	BitStatus bit_state = (state == 0) ? SET : RESET;
 739  00a5 9f            	ld	a,xl
 740  00a6 4d            	tnz	a
 741  00a7 2605          	jrne	L03
 742  00a9 ae0001        	ldw	x,#1
 743  00ac 2001          	jra	L23
 744  00ae               L03:
 745  00ae 5f            	clrw	x
 746  00af               L23:
 747  00af 01            	rrwa	x,a
 748  00b0 6b01          	ld	(OFST-3,sp),a
 749  00b2 02            	rlwa	x,a
 751                     ; 108 	switch (relay_num) {
 753  00b3 7b05          	ld	a,(OFST+1,sp)
 755                     ; 115         default: return;
 756  00b5 4a            	dec	a
 757  00b6 2711          	jreq	L772
 758  00b8 4a            	dec	a
 759  00b9 2719          	jreq	L103
 760  00bb 4a            	dec	a
 761  00bc 2721          	jreq	L303
 762  00be 4a            	dec	a
 763  00bf 2729          	jreq	L503
 764  00c1 4a            	dec	a
 765  00c2 2731          	jreq	L703
 766  00c4 4a            	dec	a
 767  00c5 2739          	jreq	L113
 768  00c7               L313:
 771  00c7 205a          	jra	L43
 772  00c9               L772:
 773                     ; 109         case 1: port = RELAY1_PORT; pin = RELAY1_PIN; break;
 775  00c9 ae5005        	ldw	x,#20485
 776  00cc 1f02          	ldw	(OFST-2,sp),x
 780  00ce a608          	ld	a,#8
 781  00d0 6b04          	ld	(OFST+0,sp),a
 785  00d2 2035          	jra	L763
 786  00d4               L103:
 787                     ; 110         case 2: port = RELAY2_PORT; pin = RELAY2_PIN; break;
 789  00d4 ae5005        	ldw	x,#20485
 790  00d7 1f02          	ldw	(OFST-2,sp),x
 794  00d9 a604          	ld	a,#4
 795  00db 6b04          	ld	(OFST+0,sp),a
 799  00dd 202a          	jra	L763
 800  00df               L303:
 801                     ; 111         case 3: port = RELAY3_PORT; pin = RELAY3_PIN; break;
 803  00df ae5005        	ldw	x,#20485
 804  00e2 1f02          	ldw	(OFST-2,sp),x
 808  00e4 a602          	ld	a,#2
 809  00e6 6b04          	ld	(OFST+0,sp),a
 813  00e8 201f          	jra	L763
 814  00ea               L503:
 815                     ; 112         case 4: port = RELAY4_PORT; pin = RELAY4_PIN; break;
 817  00ea ae5005        	ldw	x,#20485
 818  00ed 1f02          	ldw	(OFST-2,sp),x
 822  00ef a601          	ld	a,#1
 823  00f1 6b04          	ld	(OFST+0,sp),a
 827  00f3 2014          	jra	L763
 828  00f5               L703:
 829                     ; 113         case 5: port = RELAY5_PORT; pin = RELAY5_PIN; break;
 831  00f5 ae500a        	ldw	x,#20490
 832  00f8 1f02          	ldw	(OFST-2,sp),x
 836  00fa a608          	ld	a,#8
 837  00fc 6b04          	ld	(OFST+0,sp),a
 841  00fe 2009          	jra	L763
 842  0100               L113:
 843                     ; 114         case 6: port = RELAY6_PORT; pin = RELAY6_PIN; break;
 845  0100 ae500a        	ldw	x,#20490
 846  0103 1f02          	ldw	(OFST-2,sp),x
 850  0105 a610          	ld	a,#16
 851  0107 6b04          	ld	(OFST+0,sp),a
 855  0109               L763:
 856                     ; 118 	if (bit_state == SET) {
 858  0109 7b01          	ld	a,(OFST-3,sp)
 859  010b a101          	cp	a,#1
 860  010d 260b          	jrne	L173
 861                     ; 119         GPIO_WriteHigh(port, pin);  /* Set HIGH = relay off */
 863  010f 7b04          	ld	a,(OFST+0,sp)
 864  0111 88            	push	a
 865  0112 1e03          	ldw	x,(OFST-1,sp)
 866  0114 cd0000        	call	_GPIO_WriteHigh
 868  0117 84            	pop	a
 870  0118 2009          	jra	L373
 871  011a               L173:
 872                     ; 121         GPIO_WriteLow(port, pin); /* Set LOW = relay on */
 874  011a 7b04          	ld	a,(OFST+0,sp)
 875  011c 88            	push	a
 876  011d 1e03          	ldw	x,(OFST-1,sp)
 877  011f cd0000        	call	_GPIO_WriteLow
 879  0122 84            	pop	a
 880  0123               L373:
 881                     ; 123 }
 882  0123               L43:
 885  0123 5b06          	addw	sp,#6
 886  0125 81            	ret
 930                     ; 125 void relay_control_set(uint8_t relay_num, uint8_t state)
 930                     ; 126 {
 931                     	switch	.text
 932  0126               _relay_control_set:
 934  0126 89            	pushw	x
 935       00000000      OFST:	set	0
 938                     ; 127     if (relay_num >= 1 && relay_num <= 6) {
 940  0127 9e            	ld	a,xh
 941  0128 4d            	tnz	a
 942  0129 270d          	jreq	L714
 944  012b 9e            	ld	a,xh
 945  012c a107          	cp	a,#7
 946  012e 2408          	jruge	L714
 947                     ; 128         hal_relay_set(relay_num, state);
 949  0130 9f            	ld	a,xl
 950  0131 97            	ld	xl,a
 951  0132 7b01          	ld	a,(OFST+1,sp)
 952  0134 95            	ld	xh,a
 953  0135 cd00a2        	call	_hal_relay_set
 955  0138               L714:
 956                     ; 130 }
 959  0138 85            	popw	x
 960  0139 81            	ret
 996                     ; 132 void relay_control_set_all(uint8_t state)
 996                     ; 133 {
 997                     	switch	.text
 998  013a               _relay_control_set_all:
1000  013a 88            	push	a
1001       00000000      OFST:	set	0
1004                     ; 134     relay_control_set(1, state);
1006  013b ae0100        	ldw	x,#256
1007  013e 97            	ld	xl,a
1008  013f ade5          	call	_relay_control_set
1010                     ; 135     relay_control_set(2, state);
1012  0141 7b01          	ld	a,(OFST+1,sp)
1013  0143 ae0200        	ldw	x,#512
1014  0146 97            	ld	xl,a
1015  0147 addd          	call	_relay_control_set
1017                     ; 136     relay_control_set(3, state);
1019  0149 7b01          	ld	a,(OFST+1,sp)
1020  014b ae0300        	ldw	x,#768
1021  014e 97            	ld	xl,a
1022  014f add5          	call	_relay_control_set
1024                     ; 137     relay_control_set(4, state);
1026  0151 7b01          	ld	a,(OFST+1,sp)
1027  0153 ae0400        	ldw	x,#1024
1028  0156 97            	ld	xl,a
1029  0157 adcd          	call	_relay_control_set
1031                     ; 138     relay_control_set(5, state);
1033  0159 7b01          	ld	a,(OFST+1,sp)
1034  015b ae0500        	ldw	x,#1280
1035  015e 97            	ld	xl,a
1036  015f adc5          	call	_relay_control_set
1038                     ; 139     relay_control_set(6, state);
1040  0161 7b01          	ld	a,(OFST+1,sp)
1041  0163 ae0600        	ldw	x,#1536
1042  0166 97            	ld	xl,a
1043  0167 adbd          	call	_relay_control_set
1045                     ; 140 }
1048  0169 84            	pop	a
1049  016a 81            	ret
1156                     ; 142 int command_parser_execute(const char *cmd_str, int len)
1156                     ; 143 {
1157                     	switch	.text
1158  016b               _command_parser_execute:
1160  016b 89            	pushw	x
1161  016c 5246          	subw	sp,#70
1162       00000046      OFST:	set	70
1165                     ; 145     char *cmd = NULL;
1167                     ; 146     char *value_str = NULL;
1169                     ; 148     int relay_num = 0;
1171                     ; 149     int relay_state = 0;
1173                     ; 151     if (len == 0 || len >= 64) return -1;
1175  016e 1e4b          	ldw	x,(OFST+5,sp)
1176  0170 2708          	jreq	L315
1178  0172 9c            	rvf
1179  0173 1e4b          	ldw	x,(OFST+5,sp)
1180  0175 a30040        	cpw	x,#64
1181  0178 2f05          	jrslt	L115
1182  017a               L315:
1185  017a aeffff        	ldw	x,#65535
1187  017d 202e          	jra	L44
1188  017f               L115:
1189                     ; 154     strncpy(cmd_copy, cmd_str, len);
1191  017f 1e4b          	ldw	x,(OFST+5,sp)
1192  0181 89            	pushw	x
1193  0182 1e49          	ldw	x,(OFST+3,sp)
1194  0184 89            	pushw	x
1195  0185 96            	ldw	x,sp
1196  0186 1c0007        	addw	x,#OFST-63
1197  0189 cd0000        	call	_strncpy
1199  018c 5b04          	addw	sp,#4
1200                     ; 155     cmd_copy[len] = '\0';
1202  018e 96            	ldw	x,sp
1203  018f 1c0003        	addw	x,#OFST-67
1204  0192 1f01          	ldw	(OFST-69,sp),x
1206  0194 1e4b          	ldw	x,(OFST+5,sp)
1207  0196 72fb01        	addw	x,(OFST-69,sp)
1208  0199 7f            	clr	(x)
1209                     ; 158     comma_pos = strchr(cmd_copy, ',');
1211  019a 4b2c          	push	#44
1212  019c 96            	ldw	x,sp
1213  019d 1c0004        	addw	x,#OFST-66
1214  01a0 cd0000        	call	_strchr
1216  01a3 84            	pop	a
1217  01a4 1f45          	ldw	(OFST-1,sp),x
1219                     ; 159     if (!comma_pos) return -1;
1221  01a6 1e45          	ldw	x,(OFST-1,sp)
1222  01a8 2606          	jrne	L515
1225  01aa aeffff        	ldw	x,#65535
1227  01ad               L44:
1229  01ad 5b48          	addw	sp,#72
1230  01af 81            	ret
1231  01b0               L515:
1232                     ; 162     *comma_pos = '\0';
1234  01b0 1e45          	ldw	x,(OFST-1,sp)
1235  01b2 7f            	clr	(x)
1236                     ; 163     cmd = cmd_copy;
1238  01b3 96            	ldw	x,sp
1239  01b4 1c0003        	addw	x,#OFST-67
1240  01b7 1f43          	ldw	(OFST-3,sp),x
1242                     ; 164     value_str = comma_pos + 1;
1244  01b9 1e45          	ldw	x,(OFST-1,sp)
1245  01bb 5c            	incw	x
1246  01bc 1f45          	ldw	(OFST-1,sp),x
1248                     ; 167     if (cmd[0] == 'R' && cmd[1] >= '1' && cmd[1] <= '6' && cmd[2] == '\0') {
1250  01be 1e43          	ldw	x,(OFST-3,sp)
1251  01c0 f6            	ld	a,(x)
1252  01c1 a152          	cp	a,#82
1253  01c3 2634          	jrne	L715
1255  01c5 1e43          	ldw	x,(OFST-3,sp)
1256  01c7 e601          	ld	a,(1,x)
1257  01c9 a131          	cp	a,#49
1258  01cb 252c          	jrult	L715
1260  01cd 1e43          	ldw	x,(OFST-3,sp)
1261  01cf e601          	ld	a,(1,x)
1262  01d1 a137          	cp	a,#55
1263  01d3 2424          	jruge	L715
1265  01d5 1e43          	ldw	x,(OFST-3,sp)
1266  01d7 6d02          	tnz	(2,x)
1267  01d9 261e          	jrne	L715
1268                     ; 168         relay_num = cmd[1] - '0';
1270  01db 1e43          	ldw	x,(OFST-3,sp)
1271  01dd e601          	ld	a,(1,x)
1272  01df 5f            	clrw	x
1273  01e0 97            	ld	xl,a
1274  01e1 1d0030        	subw	x,#48
1275  01e4 1f43          	ldw	(OFST-3,sp),x
1277                     ; 169         relay_state = atoi(value_str);
1279  01e6 1e45          	ldw	x,(OFST-1,sp)
1280  01e8 cd0000        	call	_atoi
1282  01eb 1f45          	ldw	(OFST-1,sp),x
1284                     ; 172         relay_control_set(relay_num, relay_state);
1286  01ed 7b46          	ld	a,(OFST+0,sp)
1287  01ef 97            	ld	xl,a
1288  01f0 7b44          	ld	a,(OFST-2,sp)
1289  01f2 95            	ld	xh,a
1290  01f3 cd0126        	call	_relay_control_set
1292                     ; 173         return 0;
1294  01f6 5f            	clrw	x
1296  01f7 20b4          	jra	L44
1297  01f9               L715:
1298                     ; 176     return -1;
1300  01f9 aeffff        	ldw	x,#65535
1302  01fc 20af          	jra	L44
1326                     ; 179 void relay_control_init(void)
1326                     ; 180 {
1327                     	switch	.text
1328  01fe               _relay_control_init:
1332                     ; 181     relay_control_set_all(1);  /* 1 = on for active-low relays */
1334  01fe a601          	ld	a,#1
1335  0200 cd013a        	call	_relay_control_set_all
1337                     ; 182 }
1340  0203 81            	ret
1365                     ; 184 void hal_w5500_reset_high(void)
1365                     ; 185 {
1366                     	switch	.text
1367  0204               _hal_w5500_reset_high:
1371                     ; 186     GPIO_WriteHigh(W5500_RST_PORT, W5500_RST_PIN);
1373  0204 4b20          	push	#32
1374  0206 ae5014        	ldw	x,#20500
1375  0209 cd0000        	call	_GPIO_WriteHigh
1377  020c 84            	pop	a
1378                     ; 187 }
1381  020d 81            	ret
1407                     ; 189 void hal_gpio_init(void){
1408                     	switch	.text
1409  020e               _hal_gpio_init:
1413                     ; 191     GPIO_Init(DI1_PORT, DI1_PIN, GPIO_MODE_IN_PU_NO_IT);
1415  020e 4b40          	push	#64
1416  0210 4b04          	push	#4
1417  0212 ae500f        	ldw	x,#20495
1418  0215 cd0000        	call	_GPIO_Init
1420  0218 85            	popw	x
1421                     ; 192     GPIO_Init(DI2_PORT, DI2_PIN, GPIO_MODE_IN_PU_NO_IT);
1423  0219 4b40          	push	#64
1424  021b 4b08          	push	#8
1425  021d ae500f        	ldw	x,#20495
1426  0220 cd0000        	call	_GPIO_Init
1428  0223 85            	popw	x
1429                     ; 193     GPIO_Init(DI3_PORT, DI3_PIN, GPIO_MODE_IN_PU_NO_IT);
1431  0224 4b40          	push	#64
1432  0226 4b10          	push	#16
1433  0228 ae500f        	ldw	x,#20495
1434  022b cd0000        	call	_GPIO_Init
1436  022e 85            	popw	x
1437                     ; 194     GPIO_Init(DI4_PORT, DI4_PIN, GPIO_MODE_IN_PU_NO_IT);
1439  022f 4b40          	push	#64
1440  0231 4b80          	push	#128
1441  0233 ae500f        	ldw	x,#20495
1442  0236 cd0000        	call	_GPIO_Init
1444  0239 85            	popw	x
1445                     ; 197     GPIO_Init(RELAY1_PORT, RELAY1_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
1447  023a 4bf0          	push	#240
1448  023c 4b08          	push	#8
1449  023e ae5005        	ldw	x,#20485
1450  0241 cd0000        	call	_GPIO_Init
1452  0244 85            	popw	x
1453                     ; 198     GPIO_Init(RELAY2_PORT, RELAY2_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
1455  0245 4bf0          	push	#240
1456  0247 4b04          	push	#4
1457  0249 ae5005        	ldw	x,#20485
1458  024c cd0000        	call	_GPIO_Init
1460  024f 85            	popw	x
1461                     ; 199     GPIO_Init(RELAY3_PORT, RELAY3_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
1463  0250 4bf0          	push	#240
1464  0252 4b02          	push	#2
1465  0254 ae5005        	ldw	x,#20485
1466  0257 cd0000        	call	_GPIO_Init
1468  025a 85            	popw	x
1469                     ; 200     GPIO_Init(RELAY4_PORT, RELAY4_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
1471  025b 4bf0          	push	#240
1472  025d 4b01          	push	#1
1473  025f ae5005        	ldw	x,#20485
1474  0262 cd0000        	call	_GPIO_Init
1476  0265 85            	popw	x
1477                     ; 201     GPIO_Init(RELAY5_PORT, RELAY5_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
1479  0266 4bf0          	push	#240
1480  0268 4b08          	push	#8
1481  026a ae500a        	ldw	x,#20490
1482  026d cd0000        	call	_GPIO_Init
1484  0270 85            	popw	x
1485                     ; 202     GPIO_Init(RELAY6_PORT, RELAY6_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
1487  0271 4bf0          	push	#240
1488  0273 4b10          	push	#16
1489  0275 ae500a        	ldw	x,#20490
1490  0278 cd0000        	call	_GPIO_Init
1492  027b 85            	popw	x
1493                     ; 205     hal_relay_set(1, 1);
1495  027c ae0101        	ldw	x,#257
1496  027f cd00a2        	call	_hal_relay_set
1498                     ; 206     hal_relay_set(2, 1);
1500  0282 ae0201        	ldw	x,#513
1501  0285 cd00a2        	call	_hal_relay_set
1503                     ; 207     hal_relay_set(3, 1);
1505  0288 ae0301        	ldw	x,#769
1506  028b cd00a2        	call	_hal_relay_set
1508                     ; 208     hal_relay_set(4, 1);
1510  028e ae0401        	ldw	x,#1025
1511  0291 cd00a2        	call	_hal_relay_set
1513                     ; 209     hal_relay_set(5, 1);
1515  0294 ae0501        	ldw	x,#1281
1516  0297 cd00a2        	call	_hal_relay_set
1518                     ; 210     hal_relay_set(6, 1);
1520  029a ae0601        	ldw	x,#1537
1521  029d cd00a2        	call	_hal_relay_set
1523                     ; 213     GPIO_Init(HARDRST_PORT, HARDRST_PIN, GPIO_MODE_IN_PU_NO_IT);
1525  02a0 4b40          	push	#64
1526  02a2 4b80          	push	#128
1527  02a4 ae5005        	ldw	x,#20485
1528  02a7 cd0000        	call	_GPIO_Init
1530  02aa 85            	popw	x
1531                     ; 216     GPIO_Init(W5500_RST_PORT, W5500_RST_PIN, GPIO_MODE_OUT_PP_HIGH_FAST);
1533  02ab 4bf0          	push	#240
1534  02ad 4b20          	push	#32
1535  02af ae5014        	ldw	x,#20500
1536  02b2 cd0000        	call	_GPIO_Init
1538  02b5 85            	popw	x
1539                     ; 217 	hal_w5500_reset_high();
1541  02b6 cd0204        	call	_hal_w5500_reset_high
1543                     ; 218 }
1546  02b9 81            	ret
1570                     ; 220 uint16_t hal_uart_available(void){
1571                     	switch	.text
1572  02ba               _hal_uart_available:
1576                     ; 221 	return uart_rx_count;
1578  02ba be07          	ldw	x,L51_uart_rx_count
1581  02bc 81            	ret
1620                     ; 224 uint8_t hal_uart_read_byte(void){
1621                     	switch	.text
1622  02bd               _hal_uart_read_byte:
1624  02bd 88            	push	a
1625       00000001      OFST:	set	1
1628                     ; 225 	uint8_t byte = 0;
1630  02be 0f01          	clr	(OFST+0,sp)
1632                     ; 226 	if (uart_rx_count > 0){
1634  02c0 be07          	ldw	x,L51_uart_rx_count
1635  02c2 2719          	jreq	L775
1636                     ; 227 		disableInterrupts();
1639  02c4 9b            sim
1641                     ; 229 		byte = uart_rx_buffer[uart_rx_tail];
1644  02c5 be0b          	ldw	x,L12_uart_rx_tail
1645  02c7 e600          	ld	a,(L31_uart_rx_buffer,x)
1646  02c9 6b01          	ld	(OFST+0,sp),a
1648                     ; 230 		uart_rx_tail = (uart_rx_tail + 1) % UART_RX_BUFFER_SIZE;
1650  02cb be0b          	ldw	x,L12_uart_rx_tail
1651  02cd 5c            	incw	x
1652  02ce a614          	ld	a,#20
1653  02d0 62            	div	x,a
1654  02d1 5f            	clrw	x
1655  02d2 97            	ld	xl,a
1656  02d3 bf0b          	ldw	L12_uart_rx_tail,x
1657                     ; 231 		uart_rx_count--;
1659  02d5 be07          	ldw	x,L51_uart_rx_count
1660  02d7 1d0001        	subw	x,#1
1661  02da bf07          	ldw	L51_uart_rx_count,x
1662                     ; 232 		enableInterrupts();
1665  02dc 9a            rim
1668  02dd               L775:
1669                     ; 234 	return byte;
1671  02dd 7b01          	ld	a,(OFST+0,sp)
1674  02df 5b01          	addw	sp,#1
1675  02e1 81            	ret
1747                     ; 237 void uart_server_process(void){
1748                     	switch	.text
1749  02e2               _uart_server_process:
1751  02e2 521f          	subw	sp,#31
1752       0000001f      OFST:	set	31
1755                     ; 243 	if (uart_state == UART_STATE_IDLE){
1757  02e4 3d05          	tnz	L7_uart_state
1758  02e6 2763          	jreq	L26
1759                     ; 244 		return;
1761                     ; 246 	available_len = hal_uart_available();
1763  02e8 add0          	call	_hal_uart_available
1765  02ea 1f05          	ldw	(OFST-26,sp),x
1767                     ; 248 	if(available_len > 0){
1769  02ec 1e05          	ldw	x,(OFST-26,sp)
1770  02ee 275b          	jreq	L536
1771                     ; 249 		uart_state = UART_STATE_RX_PENDING;
1773  02f0 35020005      	mov	L7_uart_state,#2
1775  02f4 204a          	jra	L346
1776  02f6               L736:
1777                     ; 252 			read_byte = hal_uart_read_byte();
1779  02f6 adc5          	call	_hal_uart_read_byte
1781  02f8 6b1b          	ld	(OFST-4,sp),a
1783                     ; 254 			if (read_byte == '\n' || read_byte == '\r'){
1785  02fa 7b1b          	ld	a,(OFST-4,sp)
1786  02fc a10a          	cp	a,#10
1787  02fe 2706          	jreq	L156
1789  0300 7b1b          	ld	a,(OFST-4,sp)
1790  0302 a10d          	cp	a,#13
1791  0304 263a          	jrne	L346
1792  0306               L156:
1793                     ; 255 				if(uart_rx_count > 0){
1795  0306 be07          	ldw	x,L51_uart_rx_count
1796  0308 2736          	jreq	L346
1797                     ; 256 					uart_rx_buffer[uart_rx_count] = '\0';
1799  030a be07          	ldw	x,L51_uart_rx_count
1800  030c 6f00          	clr	(L31_uart_rx_buffer,x)
1801                     ; 257 					if (command_parser_execute((const char *)uart_rx_buffer,uart_rx_count) == 0){
1803  030e be07          	ldw	x,L51_uart_rx_count
1804  0310 89            	pushw	x
1805  0311 ae0000        	ldw	x,#L31_uart_rx_buffer
1806  0314 cd016b        	call	_command_parser_execute
1808  0317 5b02          	addw	sp,#2
1809  0319 a30000        	cpw	x,#0
1810  031c 2622          	jrne	L346
1811                     ; 258 						state = sensor_reader_get_state();
1813  031e 96            	ldw	x,sp
1814  031f 1c001c        	addw	x,#OFST-3
1815  0322 89            	pushw	x
1816  0323 cd0000        	call	_sensor_reader_get_state
1818  0326 85            	popw	x
1819                     ; 259 						message_formatter_alive(resp_buf, sizeof(resp_buf),state.di1,state.di2,state.di3,state.di4);
1821  0327 7b1f          	ld	a,(OFST+0,sp)
1822  0329 88            	push	a
1823  032a 7b1f          	ld	a,(OFST+0,sp)
1824  032c 88            	push	a
1825  032d 7b1f          	ld	a,(OFST+0,sp)
1826  032f 88            	push	a
1827  0330 7b1f          	ld	a,(OFST+0,sp)
1828  0332 88            	push	a
1829  0333 ae0014        	ldw	x,#20
1830  0336 89            	pushw	x
1831  0337 96            	ldw	x,sp
1832  0338 1c000d        	addw	x,#OFST-18
1833  033b cd000c        	call	_message_formatter_alive
1835  033e 5b06          	addw	sp,#6
1836  0340               L346:
1837                     ; 251 		while (available_len > 0 && uart_rx_count < sizeof(uart_rx_buffer) - 1){
1839  0340 1e05          	ldw	x,(OFST-26,sp)
1840  0342 2707          	jreq	L536
1842  0344 be07          	ldw	x,L51_uart_rx_count
1843  0346 a30013        	cpw	x,#19
1844  0349 25ab          	jrult	L736
1845  034b               L536:
1846                     ; 266 }
1847  034b               L26:
1850  034b 5b1f          	addw	sp,#31
1851  034d 81            	ret
1904                     ; 274 void delay_ms(uint16_t ms)
1904                     ; 275 {
1905                     	switch	.text
1906  034e               _delay_ms:
1908  034e 89            	pushw	x
1909  034f 5204          	subw	sp,#4
1910       00000004      OFST:	set	4
1913                     ; 279     for(i = 0; i < ms; i++)
1915  0351 5f            	clrw	x
1916  0352 1f01          	ldw	(OFST-3,sp),x
1919  0354 2019          	jra	L317
1920  0356               L707:
1921                     ; 281         for(j = 0; j < 4000; j++)
1923  0356 5f            	clrw	x
1924  0357 1f03          	ldw	(OFST-1,sp),x
1926  0359               L717:
1927                     ; 283             _asm("nop");
1930  0359 9d            nop
1932                     ; 281         for(j = 0; j < 4000; j++)
1934  035a 1e03          	ldw	x,(OFST-1,sp)
1935  035c 1c0001        	addw	x,#1
1936  035f 1f03          	ldw	(OFST-1,sp),x
1940  0361 1e03          	ldw	x,(OFST-1,sp)
1941  0363 a30fa0        	cpw	x,#4000
1942  0366 25f1          	jrult	L717
1943                     ; 279     for(i = 0; i < ms; i++)
1945  0368 1e01          	ldw	x,(OFST-3,sp)
1946  036a 1c0001        	addw	x,#1
1947  036d 1f01          	ldw	(OFST-3,sp),x
1949  036f               L317:
1952  036f 1e01          	ldw	x,(OFST-3,sp)
1953  0371 1305          	cpw	x,(OFST+1,sp)
1954  0373 25e1          	jrult	L707
1955                     ; 286 }
1958  0375 5b06          	addw	sp,#6
1959  0377 81            	ret
2003                     ; 288 void tcp_server_process(void){
2004                     	switch	.text
2005  0378               _tcp_server_process:
2007  0378 5203          	subw	sp,#3
2008       00000003      OFST:	set	3
2011                     ; 289 	uint16_t received_len = 0;
2013                     ; 290 	uint8_t sock_status = 0;
2015                     ; 292 	if(server_state ==  TCP_STATE_IDLE)return;
2017  037a 3d04          	tnz	L5_server_state
2018  037c 2700          	jreq	L07
2021                     ; 294 }
2022  037e               L07:
2025  037e 5b03          	addw	sp,#3
2026  0380 81            	ret
2064                     ; 296 void hal_uart_init(uint32_t baudrate)
2064                     ; 297 {
2065                     	switch	.text
2066  0381               _hal_uart_init:
2070                     ; 299     CLK_PeripheralClockConfig(CLK_PERIPHERAL_UART1, ENABLE);
2072  0381 ae0301        	ldw	x,#769
2073  0384 cd0000        	call	_CLK_PeripheralClockConfig
2075                     ; 320 	uart_rx_head = 0;
2077  0387 5f            	clrw	x
2078  0388 bf09          	ldw	L71_uart_rx_head,x
2079                     ; 321 	uart_rx_tail = 0;
2081  038a 5f            	clrw	x
2082  038b bf0b          	ldw	L12_uart_rx_tail,x
2083                     ; 322     uart_rx_count = 0;
2085  038d 5f            	clrw	x
2086  038e bf07          	ldw	L51_uart_rx_count,x
2087                     ; 323 }
2090  0390 81            	ret
2127                     ; 325 void uart_server_init(uint32_t baudrate){
2128                     	switch	.text
2129  0391               _uart_server_init:
2131       00000000      OFST:	set	0
2134                     ; 326 	uart_state = UART_STATE_IDLE;
2136  0391 3f05          	clr	L7_uart_state
2137                     ; 327 	uart_rx_count = 0;
2139  0393 5f            	clrw	x
2140  0394 bf07          	ldw	L51_uart_rx_count,x
2141                     ; 329 	hal_uart_init(baudrate);
2143  0396 1e05          	ldw	x,(OFST+5,sp)
2144  0398 89            	pushw	x
2145  0399 1e05          	ldw	x,(OFST+5,sp)
2146  039b 89            	pushw	x
2147  039c ade3          	call	_hal_uart_init
2149  039e 5b04          	addw	sp,#4
2150                     ; 331 	uart_state = UART_STATE_READY;
2152  03a0 35010005      	mov	L7_uart_state,#1
2153                     ; 332 }
2156  03a4 81            	ret
2159                     .const:	section	.text
2160  0000               L5001_mssg:
2161  0000 52455345542c  	dc.b	"RESET, OK",10,0
2198                     ; 335 void main_loop(void)
2198                     ; 336 {
2199                     	switch	.text
2200  03a5               _main_loop:
2202  03a5 520b          	subw	sp,#11
2203       0000000b      OFST:	set	11
2206  03a7               L5201:
2207                     ; 340 		tcp_server_process();
2209  03a7 adcf          	call	_tcp_server_process
2211                     ; 343 		uart_server_process();
2213  03a9 cd02e2        	call	_uart_server_process
2215                     ; 345         if(GPIO_ReadInputPin(HARDRST_PORT, HARDRST_PIN) == RESET)
2217  03ac 4b80          	push	#128
2218  03ae ae5005        	ldw	x,#20485
2219  03b1 cd0000        	call	_GPIO_ReadInputPin
2221  03b4 5b01          	addw	sp,#1
2222  03b6 4d            	tnz	a
2223  03b7 26ee          	jrne	L5201
2224                     ; 347             delay_ms(50);
2226  03b9 ae0032        	ldw	x,#50
2227  03bc ad90          	call	_delay_ms
2229                     ; 348 			if (GPIO_ReadInputPin(HARDRST_PORT, HARDRST_PIN) == 0){
2231  03be 4b80          	push	#128
2232  03c0 ae5005        	ldw	x,#20485
2233  03c3 cd0000        	call	_GPIO_ReadInputPin
2235  03c6 5b01          	addw	sp,#1
2236  03c8 4d            	tnz	a
2237  03c9 26dc          	jrne	L5201
2238                     ; 350 				char mssg[] = "RESET, OK\n";
2240  03cb 96            	ldw	x,sp
2241  03cc 1c0001        	addw	x,#OFST-10
2242  03cf 90ae0000      	ldw	y,#L5001_mssg
2243  03d3 a60b          	ld	a,#11
2244  03d5 cd0000        	call	c_xymov
2246                     ; 351 				delay_ms(100);
2248  03d8 ae0064        	ldw	x,#100
2249  03db cd034e        	call	_delay_ms
2251  03de 20c7          	jra	L5201
2279                     ; 357 void system_init(void){
2280                     	switch	.text
2281  03e0               _system_init:
2285                     ; 359     CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);  /* 16MHz clock */
2287  03e0 4f            	clr	a
2288  03e1 cd0000        	call	_CLK_HSIPrescalerConfig
2290                     ; 362 	hal_gpio_init();
2292  03e4 cd020e        	call	_hal_gpio_init
2294                     ; 365 	relay_control_init();
2296  03e7 cd01fe        	call	_relay_control_init
2298                     ; 366 	sensor_reader_init();
2300  03ea cd009f        	call	_sensor_reader_init
2302                     ; 368 	delay_ms(500);
2304  03ed ae01f4        	ldw	x,#500
2305  03f0 cd034e        	call	_delay_ms
2307                     ; 369 }
2310  03f3 81            	ret
2335                     ; 372 int main(void)
2335                     ; 373 {
2336                     	switch	.text
2337  03f4               _main:
2341                     ; 374 	system_init();
2343  03f4 adea          	call	_system_init
2345                     ; 375     main_loop();
2347  03f6 adad          	call	_main_loop
2349  03f8               L5501:
2350                     ; 377     while(1);
2352  03f8 20fe          	jra	L5501
2522                     	xdef	_main
2523                     	xdef	_uart_server_init
2524                     	xdef	_hal_uart_init
2525                     	xdef	_tcp_server_process
2526                     	xdef	_system_init
2527                     	xdef	_main_loop
2528                     	xdef	_delay_ms
2529                     	xdef	_uart_server_process
2530                     	xdef	_hal_uart_read_byte
2531                     	xdef	_hal_uart_available
2532                     	xdef	_hal_gpio_init
2533                     	xdef	_hal_w5500_reset_high
2534                     	xdef	_relay_control_init
2535                     	xdef	_command_parser_execute
2536                     	xdef	_relay_control_set_all
2537                     	xdef	_relay_control_set
2538                     	xdef	_hal_relay_set
2539                     	xdef	_sensor_reader_init
2540                     	xdef	_sensor_reader_update
2541                     	xdef	_hal_di_read
2542                     	xdef	_message_formatter_alive
2543                     	xdef	_sensor_reader_get_state
2544                     	switch	.ubsct
2545  0000               L31_uart_rx_buffer:
2546  0000 000000000000  	ds.b	20
2547                     	xref	_sprintf
2548                     	xref	_atoi
2549                     	xref	_strncpy
2550                     	xref	_strchr
2551                     	xref	_GPIO_ReadInputPin
2552                     	xref	_GPIO_WriteLow
2553                     	xref	_GPIO_WriteHigh
2554                     	xref	_GPIO_Init
2555                     	xref	_CLK_HSIPrescalerConfig
2556                     	xref	_CLK_PeripheralClockConfig
2557                     	switch	.const
2558  000b               L521:
2559  000b 53544152542c  	dc.b	"START,ALIVE,%d%d%d"
2560  001d 25642c454e44  	dc.b	"%d,END",0
2561                     	xref.b	c_x
2581                     	xref	c_xymov
2582                     	end
