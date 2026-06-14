   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
 322                     .const:	section	.text
 323  0000               L6:
 324  0000 00000064      	dc.l	100
 325                     ; 4 void UART1_Init(uint32_t BaudRate, UART1_WordLength_TypeDef WordLength, 
 325                     ; 5                 UART1_StopBits_TypeDef StopBits, UART1_Parity_TypeDef Parity, 
 325                     ; 6                 UART1_SyncMode_TypeDef SyncMode, UART1_Mode_TypeDef Mode)
 325                     ; 7 {
 326                     	scross	off
 327                     	switch	.text
 328  0000               _UART1_Init:
 330  0000 520c          	subw	sp,#12
 331       0000000c      OFST:	set	12
 334                     ; 8   uint32_t BaudRate_Mantissa = 0, BaudRate_Mantissa100 = 0;
 338                     ; 11   assert_param(IS_UART1_BAUDRATE_OK(BaudRate));
 340                     ; 12   assert_param(IS_UART1_WORDLENGTH_OK(WordLength));
 342                     ; 13   assert_param(IS_UART1_STOPBITS_OK(StopBits));
 344                     ; 14   assert_param(IS_UART1_PARITY_OK(Parity));
 346                     ; 15   assert_param(IS_UART1_MODE_OK((uint8_t)Mode));
 348                     ; 16   assert_param(IS_UART1_SYNCMODE_OK((uint8_t)SyncMode));
 350                     ; 19   UART1->CR1 &= (uint8_t)(~UART1_CR1_M);  
 352  0002 72195234      	bres	21044,#4
 353                     ; 22   UART1->CR1 |= (uint8_t)WordLength;
 355  0006 c65234        	ld	a,21044
 356  0009 1a13          	or	a,(OFST+7,sp)
 357  000b c75234        	ld	21044,a
 358                     ; 25   UART1->CR3 &= (uint8_t)(~UART1_CR3_STOP);  
 360  000e c65236        	ld	a,21046
 361  0011 a4cf          	and	a,#207
 362  0013 c75236        	ld	21046,a
 363                     ; 27   UART1->CR3 |= (uint8_t)StopBits;  
 365  0016 c65236        	ld	a,21046
 366  0019 1a14          	or	a,(OFST+8,sp)
 367  001b c75236        	ld	21046,a
 368                     ; 30   UART1->CR1 &= (uint8_t)(~(UART1_CR1_PCEN | UART1_CR1_PS  ));  
 370  001e c65234        	ld	a,21044
 371  0021 a4f9          	and	a,#249
 372  0023 c75234        	ld	21044,a
 373                     ; 32   UART1->CR1 |= (uint8_t)Parity;  
 375  0026 c65234        	ld	a,21044
 376  0029 1a15          	or	a,(OFST+9,sp)
 377  002b c75234        	ld	21044,a
 378                     ; 35   UART1->BRR1 &= (uint8_t)(~UART1_BRR1_DIVM);  
 380  002e 725f5232      	clr	21042
 381                     ; 37   UART1->BRR2 &= (uint8_t)(~UART1_BRR2_DIVM);  
 383  0032 c65233        	ld	a,21043
 384  0035 a40f          	and	a,#15
 385  0037 c75233        	ld	21043,a
 386                     ; 39   UART1->BRR2 &= (uint8_t)(~UART1_BRR2_DIVF);  
 388  003a c65233        	ld	a,21043
 389  003d a4f0          	and	a,#240
 390  003f c75233        	ld	21043,a
 391                     ; 42   BaudRate_Mantissa    = ((uint32_t)CLK_GetClockFreq() / (BaudRate << 4));
 393  0042 96            	ldw	x,sp
 394  0043 1c000f        	addw	x,#OFST+3
 395  0046 cd0000        	call	c_ltor
 397  0049 a604          	ld	a,#4
 398  004b cd0000        	call	c_llsh
 400  004e 96            	ldw	x,sp
 401  004f 1c0001        	addw	x,#OFST-11
 402  0052 cd0000        	call	c_rtol
 405  0055 cd0000        	call	_CLK_GetClockFreq
 407  0058 96            	ldw	x,sp
 408  0059 1c0001        	addw	x,#OFST-11
 409  005c cd0000        	call	c_ludv
 411  005f 96            	ldw	x,sp
 412  0060 1c0009        	addw	x,#OFST-3
 413  0063 cd0000        	call	c_rtol
 416                     ; 43   BaudRate_Mantissa100 = (((uint32_t)CLK_GetClockFreq() * 100) / (BaudRate << 4));
 418  0066 96            	ldw	x,sp
 419  0067 1c000f        	addw	x,#OFST+3
 420  006a cd0000        	call	c_ltor
 422  006d a604          	ld	a,#4
 423  006f cd0000        	call	c_llsh
 425  0072 96            	ldw	x,sp
 426  0073 1c0001        	addw	x,#OFST-11
 427  0076 cd0000        	call	c_rtol
 430  0079 cd0000        	call	_CLK_GetClockFreq
 432  007c a664          	ld	a,#100
 433  007e cd0000        	call	c_smul
 435  0081 96            	ldw	x,sp
 436  0082 1c0001        	addw	x,#OFST-11
 437  0085 cd0000        	call	c_ludv
 439  0088 96            	ldw	x,sp
 440  0089 1c0005        	addw	x,#OFST-7
 441  008c cd0000        	call	c_rtol
 444                     ; 45   UART1->BRR2 |= (uint8_t)((uint8_t)(((BaudRate_Mantissa100 - (BaudRate_Mantissa * 100)) << 4) / 100) & (uint8_t)0x0F); 
 446  008f 96            	ldw	x,sp
 447  0090 1c0009        	addw	x,#OFST-3
 448  0093 cd0000        	call	c_ltor
 450  0096 a664          	ld	a,#100
 451  0098 cd0000        	call	c_smul
 453  009b 96            	ldw	x,sp
 454  009c 1c0001        	addw	x,#OFST-11
 455  009f cd0000        	call	c_rtol
 458  00a2 96            	ldw	x,sp
 459  00a3 1c0005        	addw	x,#OFST-7
 460  00a6 cd0000        	call	c_ltor
 462  00a9 96            	ldw	x,sp
 463  00aa 1c0001        	addw	x,#OFST-11
 464  00ad cd0000        	call	c_lsub
 466  00b0 a604          	ld	a,#4
 467  00b2 cd0000        	call	c_llsh
 469  00b5 ae0000        	ldw	x,#L6
 470  00b8 cd0000        	call	c_ludv
 472  00bb b603          	ld	a,c_lreg+3
 473  00bd a40f          	and	a,#15
 474  00bf ca5233        	or	a,21043
 475  00c2 c75233        	ld	21043,a
 476                     ; 47   UART1->BRR2 |= (uint8_t)((BaudRate_Mantissa >> 4) & (uint8_t)0xF0); 
 478  00c5 1e0b          	ldw	x,(OFST-1,sp)
 479  00c7 54            	srlw	x
 480  00c8 54            	srlw	x
 481  00c9 54            	srlw	x
 482  00ca 54            	srlw	x
 483  00cb 01            	rrwa	x,a
 484  00cc a4f0          	and	a,#240
 485  00ce 5f            	clrw	x
 486  00cf ca5233        	or	a,21043
 487  00d2 c75233        	ld	21043,a
 488                     ; 49   UART1->BRR1 |= (uint8_t)BaudRate_Mantissa;           
 490  00d5 c65232        	ld	a,21042
 491  00d8 1a0c          	or	a,(OFST+0,sp)
 492  00da c75232        	ld	21042,a
 493                     ; 52   UART1->CR2 &= (uint8_t)~(UART1_CR2_TEN | UART1_CR2_REN); 
 495  00dd c65235        	ld	a,21045
 496  00e0 a4f3          	and	a,#243
 497  00e2 c75235        	ld	21045,a
 498                     ; 54   UART1->CR3 &= (uint8_t)~(UART1_CR3_CPOL | UART1_CR3_CPHA | UART1_CR3_LBCL); 
 500  00e5 c65236        	ld	a,21046
 501  00e8 a4f8          	and	a,#248
 502  00ea c75236        	ld	21046,a
 503                     ; 56   UART1->CR3 |= (uint8_t)((uint8_t)SyncMode & (uint8_t)(UART1_CR3_CPOL | 
 503                     ; 57                                                         UART1_CR3_CPHA | UART1_CR3_LBCL));  
 505  00ed 7b16          	ld	a,(OFST+10,sp)
 506  00ef a407          	and	a,#7
 507  00f1 ca5236        	or	a,21046
 508  00f4 c75236        	ld	21046,a
 509                     ; 59   if ((uint8_t)(Mode & UART1_MODE_TX_ENABLE))
 511  00f7 7b17          	ld	a,(OFST+11,sp)
 512  00f9 a504          	bcp	a,#4
 513  00fb 2706          	jreq	L361
 514                     ; 62     UART1->CR2 |= (uint8_t)UART1_CR2_TEN;  
 516  00fd 72165235      	bset	21045,#3
 518  0101 2004          	jra	L561
 519  0103               L361:
 520                     ; 67     UART1->CR2 &= (uint8_t)(~UART1_CR2_TEN);  
 522  0103 72175235      	bres	21045,#3
 523  0107               L561:
 524                     ; 69   if ((uint8_t)(Mode & UART1_MODE_RX_ENABLE))
 526  0107 7b17          	ld	a,(OFST+11,sp)
 527  0109 a508          	bcp	a,#8
 528  010b 2706          	jreq	L761
 529                     ; 72     UART1->CR2 |= (uint8_t)UART1_CR2_REN;  
 531  010d 72145235      	bset	21045,#2
 533  0111 2004          	jra	L171
 534  0113               L761:
 535                     ; 77     UART1->CR2 &= (uint8_t)(~UART1_CR2_REN);  
 537  0113 72155235      	bres	21045,#2
 538  0117               L171:
 539                     ; 81   if ((uint8_t)(SyncMode & UART1_SYNCMODE_CLOCK_DISABLE))
 541  0117 7b16          	ld	a,(OFST+10,sp)
 542  0119 a580          	bcp	a,#128
 543  011b 2706          	jreq	L371
 544                     ; 84     UART1->CR3 &= (uint8_t)(~UART1_CR3_CKEN); 
 546  011d 72175236      	bres	21046,#3
 548  0121 200a          	jra	L571
 549  0123               L371:
 550                     ; 88     UART1->CR3 |= (uint8_t)((uint8_t)SyncMode & UART1_CR3_CKEN);
 552  0123 7b16          	ld	a,(OFST+10,sp)
 553  0125 a408          	and	a,#8
 554  0127 ca5236        	or	a,21046
 555  012a c75236        	ld	21046,a
 556  012d               L571:
 557                     ; 90 }
 560  012d 5b0c          	addw	sp,#12
 561  012f 81            	ret
 616                     ; 92 void UART1_Cmd(FunctionalState NewState)
 616                     ; 93 {
 617                     	switch	.text
 618  0130               _UART1_Cmd:
 622                     ; 94   if (NewState != DISABLE)
 624  0130 4d            	tnz	a
 625  0131 2706          	jreq	L522
 626                     ; 97     UART1->CR1 &= (uint8_t)(~UART1_CR1_UARTD); 
 628  0133 721b5234      	bres	21044,#5
 630  0137 2004          	jra	L722
 631  0139               L522:
 632                     ; 102     UART1->CR1 |= UART1_CR1_UARTD;  
 634  0139 721a5234      	bset	21044,#5
 635  013d               L722:
 636                     ; 104 }
 639  013d 81            	ret
 764                     ; 106 void UART1_ITConfig(UART1_IT_TypeDef UART1_IT, FunctionalState NewState)
 764                     ; 107 {
 765                     	switch	.text
 766  013e               _UART1_ITConfig:
 768  013e 89            	pushw	x
 769  013f 89            	pushw	x
 770       00000002      OFST:	set	2
 773                     ; 108   uint8_t uartreg = 0, itpos = 0x00;
 777                     ; 111   assert_param(IS_UART1_CONFIG_IT_OK(UART1_IT));
 779                     ; 112   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 781                     ; 115   uartreg = (uint8_t)((uint16_t)UART1_IT >> 0x08);
 783  0140 9e            	ld	a,xh
 784  0141 6b01          	ld	(OFST-1,sp),a
 786                     ; 117   itpos = (uint8_t)((uint8_t)1 << (uint8_t)((uint8_t)UART1_IT & (uint8_t)0x0F));
 788  0143 9f            	ld	a,xl
 789  0144 a40f          	and	a,#15
 790  0146 5f            	clrw	x
 791  0147 97            	ld	xl,a
 792  0148 a601          	ld	a,#1
 793  014a 5d            	tnzw	x
 794  014b 2704          	jreq	L41
 795  014d               L61:
 796  014d 48            	sll	a
 797  014e 5a            	decw	x
 798  014f 26fc          	jrne	L61
 799  0151               L41:
 800  0151 6b02          	ld	(OFST+0,sp),a
 802                     ; 119   if (NewState != DISABLE)
 804  0153 0d07          	tnz	(OFST+5,sp)
 805  0155 272a          	jreq	L703
 806                     ; 122     if (uartreg == 0x01)
 808  0157 7b01          	ld	a,(OFST-1,sp)
 809  0159 a101          	cp	a,#1
 810  015b 260a          	jrne	L113
 811                     ; 124       UART1->CR1 |= itpos;
 813  015d c65234        	ld	a,21044
 814  0160 1a02          	or	a,(OFST+0,sp)
 815  0162 c75234        	ld	21044,a
 817  0165 2045          	jra	L123
 818  0167               L113:
 819                     ; 126     else if (uartreg == 0x02)
 821  0167 7b01          	ld	a,(OFST-1,sp)
 822  0169 a102          	cp	a,#2
 823  016b 260a          	jrne	L513
 824                     ; 128       UART1->CR2 |= itpos;
 826  016d c65235        	ld	a,21045
 827  0170 1a02          	or	a,(OFST+0,sp)
 828  0172 c75235        	ld	21045,a
 830  0175 2035          	jra	L123
 831  0177               L513:
 832                     ; 132       UART1->CR4 |= itpos;
 834  0177 c65237        	ld	a,21047
 835  017a 1a02          	or	a,(OFST+0,sp)
 836  017c c75237        	ld	21047,a
 837  017f 202b          	jra	L123
 838  0181               L703:
 839                     ; 138     if (uartreg == 0x01)
 841  0181 7b01          	ld	a,(OFST-1,sp)
 842  0183 a101          	cp	a,#1
 843  0185 260b          	jrne	L323
 844                     ; 140       UART1->CR1 &= (uint8_t)(~itpos);
 846  0187 7b02          	ld	a,(OFST+0,sp)
 847  0189 43            	cpl	a
 848  018a c45234        	and	a,21044
 849  018d c75234        	ld	21044,a
 851  0190 201a          	jra	L123
 852  0192               L323:
 853                     ; 142     else if (uartreg == 0x02)
 855  0192 7b01          	ld	a,(OFST-1,sp)
 856  0194 a102          	cp	a,#2
 857  0196 260b          	jrne	L723
 858                     ; 144       UART1->CR2 &= (uint8_t)(~itpos);
 860  0198 7b02          	ld	a,(OFST+0,sp)
 861  019a 43            	cpl	a
 862  019b c45235        	and	a,21045
 863  019e c75235        	ld	21045,a
 865  01a1 2009          	jra	L123
 866  01a3               L723:
 867                     ; 148       UART1->CR4 &= (uint8_t)(~itpos);
 869  01a3 7b02          	ld	a,(OFST+0,sp)
 870  01a5 43            	cpl	a
 871  01a6 c45237        	and	a,21047
 872  01a9 c75237        	ld	21047,a
 873  01ac               L123:
 874                     ; 152 }
 877  01ac 5b04          	addw	sp,#4
 878  01ae 81            	ret
 912                     ; 154 void UART1_SendData8(uint8_t Data)
 912                     ; 155 {
 913                     	switch	.text
 914  01af               _UART1_SendData8:
 918                     ; 157   UART1->DR = Data;
 920  01af c75231        	ld	21041,a
 921                     ; 158 }
 924  01b2 81            	ret
1067                     ; 160 FlagStatus UART1_GetFlagStatus(UART1_Flag_TypeDef UART1_FLAG)
1067                     ; 161 {
1068                     	switch	.text
1069  01b3               _UART1_GetFlagStatus:
1071  01b3 89            	pushw	x
1072  01b4 88            	push	a
1073       00000001      OFST:	set	1
1076                     ; 162   FlagStatus status = RESET;
1078                     ; 165   assert_param(IS_UART1_FLAG_OK(UART1_FLAG));
1080                     ; 169   if (UART1_FLAG == UART1_FLAG_LBDF)
1082  01b5 a30210        	cpw	x,#528
1083  01b8 2610          	jrne	L334
1084                     ; 171     if ((UART1->CR4 & (uint8_t)UART1_FLAG) != (uint8_t)0x00)
1086  01ba 9f            	ld	a,xl
1087  01bb c45237        	and	a,21047
1088  01be 2706          	jreq	L534
1089                     ; 174       status = SET;
1091  01c0 a601          	ld	a,#1
1092  01c2 6b01          	ld	(OFST+0,sp),a
1095  01c4 202b          	jra	L144
1096  01c6               L534:
1097                     ; 179       status = RESET;
1099  01c6 0f01          	clr	(OFST+0,sp)
1101  01c8 2027          	jra	L144
1102  01ca               L334:
1103                     ; 182   else if (UART1_FLAG == UART1_FLAG_SBK)
1105  01ca 1e02          	ldw	x,(OFST+1,sp)
1106  01cc a30101        	cpw	x,#257
1107  01cf 2611          	jrne	L344
1108                     ; 184     if ((UART1->CR2 & (uint8_t)UART1_FLAG) != (uint8_t)0x00)
1110  01d1 c65235        	ld	a,21045
1111  01d4 1503          	bcp	a,(OFST+2,sp)
1112  01d6 2706          	jreq	L544
1113                     ; 187       status = SET;
1115  01d8 a601          	ld	a,#1
1116  01da 6b01          	ld	(OFST+0,sp),a
1119  01dc 2013          	jra	L144
1120  01de               L544:
1121                     ; 192       status = RESET;
1123  01de 0f01          	clr	(OFST+0,sp)
1125  01e0 200f          	jra	L144
1126  01e2               L344:
1127                     ; 197     if ((UART1->SR & (uint8_t)UART1_FLAG) != (uint8_t)0x00)
1129  01e2 c65230        	ld	a,21040
1130  01e5 1503          	bcp	a,(OFST+2,sp)
1131  01e7 2706          	jreq	L354
1132                     ; 200       status = SET;
1134  01e9 a601          	ld	a,#1
1135  01eb 6b01          	ld	(OFST+0,sp),a
1138  01ed 2002          	jra	L144
1139  01ef               L354:
1140                     ; 205       status = RESET;
1142  01ef 0f01          	clr	(OFST+0,sp)
1144  01f1               L144:
1145                     ; 209   return status;
1147  01f1 7b01          	ld	a,(OFST+0,sp)
1150  01f3 5b03          	addw	sp,#3
1151  01f5 81            	ret
1164                     	xdef	_UART1_GetFlagStatus
1165                     	xdef	_UART1_SendData8
1166                     	xdef	_UART1_ITConfig
1167                     	xdef	_UART1_Cmd
1168                     	xdef	_UART1_Init
1169                     	xref	_CLK_GetClockFreq
1170                     	xref.b	c_lreg
1171                     	xref.b	c_x
1190                     	xref	c_lsub
1191                     	xref	c_smul
1192                     	xref	c_ludv
1193                     	xref	c_rtol
1194                     	xref	c_llsh
1195                     	xref	c_ltor
1196                     	end
