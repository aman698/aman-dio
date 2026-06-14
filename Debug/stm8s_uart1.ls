   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  14                     	bsct
  15  0000               L3_sock_any_port:
  16  0000 c000          	dc.w	-16384
 353                     .const:	section	.text
 354  0000               L6:
 355  0000 00000064      	dc.l	100
 356                     ; 4 void UART1_Init(uint32_t BaudRate, UART1_WordLength_TypeDef WordLength, 
 356                     ; 5                 UART1_StopBits_TypeDef StopBits, UART1_Parity_TypeDef Parity, 
 356                     ; 6                 UART1_SyncMode_TypeDef SyncMode, UART1_Mode_TypeDef Mode)
 356                     ; 7 {
 357                     	scross	off
 358                     	switch	.text
 359  0000               _UART1_Init:
 361  0000 520c          	subw	sp,#12
 362       0000000c      OFST:	set	12
 365                     ; 8   uint32_t BaudRate_Mantissa = 0, BaudRate_Mantissa100 = 0;
 369                     ; 11   assert_param(IS_UART1_BAUDRATE_OK(BaudRate));
 371                     ; 12   assert_param(IS_UART1_WORDLENGTH_OK(WordLength));
 373                     ; 13   assert_param(IS_UART1_STOPBITS_OK(StopBits));
 375                     ; 14   assert_param(IS_UART1_PARITY_OK(Parity));
 377                     ; 15   assert_param(IS_UART1_MODE_OK((uint8_t)Mode));
 379                     ; 16   assert_param(IS_UART1_SYNCMODE_OK((uint8_t)SyncMode));
 381                     ; 19   UART1->CR1 &= (uint8_t)(~UART1_CR1_M);  
 383  0002 72195234      	bres	21044,#4
 384                     ; 22   UART1->CR1 |= (uint8_t)WordLength;
 386  0006 c65234        	ld	a,21044
 387  0009 1a13          	or	a,(OFST+7,sp)
 388  000b c75234        	ld	21044,a
 389                     ; 25   UART1->CR3 &= (uint8_t)(~UART1_CR3_STOP);  
 391  000e c65236        	ld	a,21046
 392  0011 a4cf          	and	a,#207
 393  0013 c75236        	ld	21046,a
 394                     ; 27   UART1->CR3 |= (uint8_t)StopBits;  
 396  0016 c65236        	ld	a,21046
 397  0019 1a14          	or	a,(OFST+8,sp)
 398  001b c75236        	ld	21046,a
 399                     ; 30   UART1->CR1 &= (uint8_t)(~(UART1_CR1_PCEN | UART1_CR1_PS  ));  
 401  001e c65234        	ld	a,21044
 402  0021 a4f9          	and	a,#249
 403  0023 c75234        	ld	21044,a
 404                     ; 32   UART1->CR1 |= (uint8_t)Parity;  
 406  0026 c65234        	ld	a,21044
 407  0029 1a15          	or	a,(OFST+9,sp)
 408  002b c75234        	ld	21044,a
 409                     ; 35   UART1->BRR1 &= (uint8_t)(~UART1_BRR1_DIVM);  
 411  002e 725f5232      	clr	21042
 412                     ; 37   UART1->BRR2 &= (uint8_t)(~UART1_BRR2_DIVM);  
 414  0032 c65233        	ld	a,21043
 415  0035 a40f          	and	a,#15
 416  0037 c75233        	ld	21043,a
 417                     ; 39   UART1->BRR2 &= (uint8_t)(~UART1_BRR2_DIVF);  
 419  003a c65233        	ld	a,21043
 420  003d a4f0          	and	a,#240
 421  003f c75233        	ld	21043,a
 422                     ; 42   BaudRate_Mantissa    = ((uint32_t)CLK_GetClockFreq() / (BaudRate << 4));
 424  0042 96            	ldw	x,sp
 425  0043 1c000f        	addw	x,#OFST+3
 426  0046 cd0000        	call	c_ltor
 428  0049 a604          	ld	a,#4
 429  004b cd0000        	call	c_llsh
 431  004e 96            	ldw	x,sp
 432  004f 1c0001        	addw	x,#OFST-11
 433  0052 cd0000        	call	c_rtol
 436  0055 cd0000        	call	_CLK_GetClockFreq
 438  0058 96            	ldw	x,sp
 439  0059 1c0001        	addw	x,#OFST-11
 440  005c cd0000        	call	c_ludv
 442  005f 96            	ldw	x,sp
 443  0060 1c0009        	addw	x,#OFST-3
 444  0063 cd0000        	call	c_rtol
 447                     ; 43   BaudRate_Mantissa100 = (((uint32_t)CLK_GetClockFreq() * 100) / (BaudRate << 4));
 449  0066 96            	ldw	x,sp
 450  0067 1c000f        	addw	x,#OFST+3
 451  006a cd0000        	call	c_ltor
 453  006d a604          	ld	a,#4
 454  006f cd0000        	call	c_llsh
 456  0072 96            	ldw	x,sp
 457  0073 1c0001        	addw	x,#OFST-11
 458  0076 cd0000        	call	c_rtol
 461  0079 cd0000        	call	_CLK_GetClockFreq
 463  007c a664          	ld	a,#100
 464  007e cd0000        	call	c_smul
 466  0081 96            	ldw	x,sp
 467  0082 1c0001        	addw	x,#OFST-11
 468  0085 cd0000        	call	c_ludv
 470  0088 96            	ldw	x,sp
 471  0089 1c0005        	addw	x,#OFST-7
 472  008c cd0000        	call	c_rtol
 475                     ; 45   UART1->BRR2 |= (uint8_t)((uint8_t)(((BaudRate_Mantissa100 - (BaudRate_Mantissa * 100)) << 4) / 100) & (uint8_t)0x0F); 
 477  008f 96            	ldw	x,sp
 478  0090 1c0009        	addw	x,#OFST-3
 479  0093 cd0000        	call	c_ltor
 481  0096 a664          	ld	a,#100
 482  0098 cd0000        	call	c_smul
 484  009b 96            	ldw	x,sp
 485  009c 1c0001        	addw	x,#OFST-11
 486  009f cd0000        	call	c_rtol
 489  00a2 96            	ldw	x,sp
 490  00a3 1c0005        	addw	x,#OFST-7
 491  00a6 cd0000        	call	c_ltor
 493  00a9 96            	ldw	x,sp
 494  00aa 1c0001        	addw	x,#OFST-11
 495  00ad cd0000        	call	c_lsub
 497  00b0 a604          	ld	a,#4
 498  00b2 cd0000        	call	c_llsh
 500  00b5 ae0000        	ldw	x,#L6
 501  00b8 cd0000        	call	c_ludv
 503  00bb b603          	ld	a,c_lreg+3
 504  00bd a40f          	and	a,#15
 505  00bf ca5233        	or	a,21043
 506  00c2 c75233        	ld	21043,a
 507                     ; 47   UART1->BRR2 |= (uint8_t)((BaudRate_Mantissa >> 4) & (uint8_t)0xF0); 
 509  00c5 1e0b          	ldw	x,(OFST-1,sp)
 510  00c7 54            	srlw	x
 511  00c8 54            	srlw	x
 512  00c9 54            	srlw	x
 513  00ca 54            	srlw	x
 514  00cb 01            	rrwa	x,a
 515  00cc a4f0          	and	a,#240
 516  00ce 5f            	clrw	x
 517  00cf ca5233        	or	a,21043
 518  00d2 c75233        	ld	21043,a
 519                     ; 49   UART1->BRR1 |= (uint8_t)BaudRate_Mantissa;           
 521  00d5 c65232        	ld	a,21042
 522  00d8 1a0c          	or	a,(OFST+0,sp)
 523  00da c75232        	ld	21042,a
 524                     ; 52   UART1->CR2 &= (uint8_t)~(UART1_CR2_TEN | UART1_CR2_REN); 
 526  00dd c65235        	ld	a,21045
 527  00e0 a4f3          	and	a,#243
 528  00e2 c75235        	ld	21045,a
 529                     ; 54   UART1->CR3 &= (uint8_t)~(UART1_CR3_CPOL | UART1_CR3_CPHA | UART1_CR3_LBCL); 
 531  00e5 c65236        	ld	a,21046
 532  00e8 a4f8          	and	a,#248
 533  00ea c75236        	ld	21046,a
 534                     ; 56   UART1->CR3 |= (uint8_t)((uint8_t)SyncMode & (uint8_t)(UART1_CR3_CPOL | 
 534                     ; 57                                                         UART1_CR3_CPHA | UART1_CR3_LBCL));  
 536  00ed 7b16          	ld	a,(OFST+10,sp)
 537  00ef a407          	and	a,#7
 538  00f1 ca5236        	or	a,21046
 539  00f4 c75236        	ld	21046,a
 540                     ; 59   if ((uint8_t)(Mode & UART1_MODE_TX_ENABLE))
 542  00f7 7b17          	ld	a,(OFST+11,sp)
 543  00f9 a504          	bcp	a,#4
 544  00fb 2706          	jreq	L102
 545                     ; 62     UART1->CR2 |= (uint8_t)UART1_CR2_TEN;  
 547  00fd 72165235      	bset	21045,#3
 549  0101 2004          	jra	L302
 550  0103               L102:
 551                     ; 67     UART1->CR2 &= (uint8_t)(~UART1_CR2_TEN);  
 553  0103 72175235      	bres	21045,#3
 554  0107               L302:
 555                     ; 69   if ((uint8_t)(Mode & UART1_MODE_RX_ENABLE))
 557  0107 7b17          	ld	a,(OFST+11,sp)
 558  0109 a508          	bcp	a,#8
 559  010b 2706          	jreq	L502
 560                     ; 72     UART1->CR2 |= (uint8_t)UART1_CR2_REN;  
 562  010d 72145235      	bset	21045,#2
 564  0111 2004          	jra	L702
 565  0113               L502:
 566                     ; 77     UART1->CR2 &= (uint8_t)(~UART1_CR2_REN);  
 568  0113 72155235      	bres	21045,#2
 569  0117               L702:
 570                     ; 81   if ((uint8_t)(SyncMode & UART1_SYNCMODE_CLOCK_DISABLE))
 572  0117 7b16          	ld	a,(OFST+10,sp)
 573  0119 a580          	bcp	a,#128
 574  011b 2706          	jreq	L112
 575                     ; 84     UART1->CR3 &= (uint8_t)(~UART1_CR3_CKEN); 
 577  011d 72175236      	bres	21046,#3
 579  0121 200a          	jra	L312
 580  0123               L112:
 581                     ; 88     UART1->CR3 |= (uint8_t)((uint8_t)SyncMode & UART1_CR3_CKEN);
 583  0123 7b16          	ld	a,(OFST+10,sp)
 584  0125 a408          	and	a,#8
 585  0127 ca5236        	or	a,21046
 586  012a c75236        	ld	21046,a
 587  012d               L312:
 588                     ; 90 }
 591  012d 5b0c          	addw	sp,#12
 592  012f 81            	ret
 647                     ; 92 void UART1_Cmd(FunctionalState NewState)
 647                     ; 93 {
 648                     	switch	.text
 649  0130               _UART1_Cmd:
 653                     ; 94   if (NewState != DISABLE)
 655  0130 4d            	tnz	a
 656  0131 2706          	jreq	L342
 657                     ; 97     UART1->CR1 &= (uint8_t)(~UART1_CR1_UARTD); 
 659  0133 721b5234      	bres	21044,#5
 661  0137 2004          	jra	L542
 662  0139               L342:
 663                     ; 102     UART1->CR1 |= UART1_CR1_UARTD;  
 665  0139 721a5234      	bset	21044,#5
 666  013d               L542:
 667                     ; 104 }
 670  013d 81            	ret
 795                     ; 106 void UART1_ITConfig(UART1_IT_TypeDef UART1_IT, FunctionalState NewState)
 795                     ; 107 {
 796                     	switch	.text
 797  013e               _UART1_ITConfig:
 799  013e 89            	pushw	x
 800  013f 89            	pushw	x
 801       00000002      OFST:	set	2
 804                     ; 108   uint8_t uartreg = 0, itpos = 0x00;
 808                     ; 111   assert_param(IS_UART1_CONFIG_IT_OK(UART1_IT));
 810                     ; 112   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 812                     ; 115   uartreg = (uint8_t)((uint16_t)UART1_IT >> 0x08);
 814  0140 9e            	ld	a,xh
 815  0141 6b01          	ld	(OFST-1,sp),a
 817                     ; 117   itpos = (uint8_t)((uint8_t)1 << (uint8_t)((uint8_t)UART1_IT & (uint8_t)0x0F));
 819  0143 9f            	ld	a,xl
 820  0144 a40f          	and	a,#15
 821  0146 5f            	clrw	x
 822  0147 97            	ld	xl,a
 823  0148 a601          	ld	a,#1
 824  014a 5d            	tnzw	x
 825  014b 2704          	jreq	L41
 826  014d               L61:
 827  014d 48            	sll	a
 828  014e 5a            	decw	x
 829  014f 26fc          	jrne	L61
 830  0151               L41:
 831  0151 6b02          	ld	(OFST+0,sp),a
 833                     ; 119   if (NewState != DISABLE)
 835  0153 0d07          	tnz	(OFST+5,sp)
 836  0155 272a          	jreq	L523
 837                     ; 122     if (uartreg == 0x01)
 839  0157 7b01          	ld	a,(OFST-1,sp)
 840  0159 a101          	cp	a,#1
 841  015b 260a          	jrne	L723
 842                     ; 124       UART1->CR1 |= itpos;
 844  015d c65234        	ld	a,21044
 845  0160 1a02          	or	a,(OFST+0,sp)
 846  0162 c75234        	ld	21044,a
 848  0165 2045          	jra	L733
 849  0167               L723:
 850                     ; 126     else if (uartreg == 0x02)
 852  0167 7b01          	ld	a,(OFST-1,sp)
 853  0169 a102          	cp	a,#2
 854  016b 260a          	jrne	L333
 855                     ; 128       UART1->CR2 |= itpos;
 857  016d c65235        	ld	a,21045
 858  0170 1a02          	or	a,(OFST+0,sp)
 859  0172 c75235        	ld	21045,a
 861  0175 2035          	jra	L733
 862  0177               L333:
 863                     ; 132       UART1->CR4 |= itpos;
 865  0177 c65237        	ld	a,21047
 866  017a 1a02          	or	a,(OFST+0,sp)
 867  017c c75237        	ld	21047,a
 868  017f 202b          	jra	L733
 869  0181               L523:
 870                     ; 138     if (uartreg == 0x01)
 872  0181 7b01          	ld	a,(OFST-1,sp)
 873  0183 a101          	cp	a,#1
 874  0185 260b          	jrne	L143
 875                     ; 140       UART1->CR1 &= (uint8_t)(~itpos);
 877  0187 7b02          	ld	a,(OFST+0,sp)
 878  0189 43            	cpl	a
 879  018a c45234        	and	a,21044
 880  018d c75234        	ld	21044,a
 882  0190 201a          	jra	L733
 883  0192               L143:
 884                     ; 142     else if (uartreg == 0x02)
 886  0192 7b01          	ld	a,(OFST-1,sp)
 887  0194 a102          	cp	a,#2
 888  0196 260b          	jrne	L543
 889                     ; 144       UART1->CR2 &= (uint8_t)(~itpos);
 891  0198 7b02          	ld	a,(OFST+0,sp)
 892  019a 43            	cpl	a
 893  019b c45235        	and	a,21045
 894  019e c75235        	ld	21045,a
 896  01a1 2009          	jra	L733
 897  01a3               L543:
 898                     ; 148       UART1->CR4 &= (uint8_t)(~itpos);
 900  01a3 7b02          	ld	a,(OFST+0,sp)
 901  01a5 43            	cpl	a
 902  01a6 c45237        	and	a,21047
 903  01a9 c75237        	ld	21047,a
 904  01ac               L733:
 905                     ; 152 }
 908  01ac 5b04          	addw	sp,#4
 909  01ae 81            	ret
 943                     ; 154 void UART1_SendData8(uint8_t Data)
 943                     ; 155 {
 944                     	switch	.text
 945  01af               _UART1_SendData8:
 949                     ; 157   UART1->DR = Data;
 951  01af c75231        	ld	21041,a
 952                     ; 158 }
 955  01b2 81            	ret
1098                     ; 160 FlagStatus UART1_GetFlagStatus(UART1_Flag_TypeDef UART1_FLAG)
1098                     ; 161 {
1099                     	switch	.text
1100  01b3               _UART1_GetFlagStatus:
1102  01b3 89            	pushw	x
1103  01b4 88            	push	a
1104       00000001      OFST:	set	1
1107                     ; 162   FlagStatus status = RESET;
1109                     ; 165   assert_param(IS_UART1_FLAG_OK(UART1_FLAG));
1111                     ; 169   if (UART1_FLAG == UART1_FLAG_LBDF)
1113  01b5 a30210        	cpw	x,#528
1114  01b8 2610          	jrne	L154
1115                     ; 171     if ((UART1->CR4 & (uint8_t)UART1_FLAG) != (uint8_t)0x00)
1117  01ba 9f            	ld	a,xl
1118  01bb c45237        	and	a,21047
1119  01be 2706          	jreq	L354
1120                     ; 174       status = SET;
1122  01c0 a601          	ld	a,#1
1123  01c2 6b01          	ld	(OFST+0,sp),a
1126  01c4 202b          	jra	L754
1127  01c6               L354:
1128                     ; 179       status = RESET;
1130  01c6 0f01          	clr	(OFST+0,sp)
1132  01c8 2027          	jra	L754
1133  01ca               L154:
1134                     ; 182   else if (UART1_FLAG == UART1_FLAG_SBK)
1136  01ca 1e02          	ldw	x,(OFST+1,sp)
1137  01cc a30101        	cpw	x,#257
1138  01cf 2611          	jrne	L164
1139                     ; 184     if ((UART1->CR2 & (uint8_t)UART1_FLAG) != (uint8_t)0x00)
1141  01d1 c65235        	ld	a,21045
1142  01d4 1503          	bcp	a,(OFST+2,sp)
1143  01d6 2706          	jreq	L364
1144                     ; 187       status = SET;
1146  01d8 a601          	ld	a,#1
1147  01da 6b01          	ld	(OFST+0,sp),a
1150  01dc 2013          	jra	L754
1151  01de               L364:
1152                     ; 192       status = RESET;
1154  01de 0f01          	clr	(OFST+0,sp)
1156  01e0 200f          	jra	L754
1157  01e2               L164:
1158                     ; 197     if ((UART1->SR & (uint8_t)UART1_FLAG) != (uint8_t)0x00)
1160  01e2 c65230        	ld	a,21040
1161  01e5 1503          	bcp	a,(OFST+2,sp)
1162  01e7 2706          	jreq	L174
1163                     ; 200       status = SET;
1165  01e9 a601          	ld	a,#1
1166  01eb 6b01          	ld	(OFST+0,sp),a
1169  01ed 2002          	jra	L754
1170  01ef               L174:
1171                     ; 205       status = RESET;
1173  01ef 0f01          	clr	(OFST+0,sp)
1175  01f1               L754:
1176                     ; 209   return status;
1178  01f1 7b01          	ld	a,(OFST+0,sp)
1181  01f3 5b03          	addw	sp,#3
1182  01f5 81            	ret
1195                     	xdef	_UART1_GetFlagStatus
1196                     	xdef	_UART1_SendData8
1197                     	xdef	_UART1_ITConfig
1198                     	xdef	_UART1_Cmd
1199                     	xdef	_UART1_Init
1200                     	xref	_CLK_GetClockFreq
1201                     	xref.b	c_lreg
1202                     	xref.b	c_x
1221                     	xref	c_lsub
1222                     	xref	c_smul
1223                     	xref	c_ludv
1224                     	xref	c_rtol
1225                     	xref	c_llsh
1226                     	xref	c_ltor
1227                     	end
