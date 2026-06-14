   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  14                     .const:	section	.text
  15  0000               _HSIDivFactor:
  16  0000 01            	dc.b	1
  17  0001 02            	dc.b	2
  18  0002 04            	dc.b	4
  19  0003 08            	dc.b	8
  20  0004               _CLKPrescTable:
  21  0004 01            	dc.b	1
  22  0005 02            	dc.b	2
  23  0006 04            	dc.b	4
  24  0007 08            	dc.b	8
  25  0008 0a            	dc.b	10
  26  0009 10            	dc.b	16
  27  000a 14            	dc.b	20
  28  000b 28            	dc.b	40
 213                     ; 7 void CLK_PeripheralClockConfig(CLK_Peripheral_TypeDef CLK_Peripheral, FunctionalState NewState)
 213                     ; 8 {
 215                     	switch	.text
 216  0000               _CLK_PeripheralClockConfig:
 218  0000 89            	pushw	x
 219       00000000      OFST:	set	0
 222                     ; 10   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 224                     ; 11   assert_param(IS_CLK_PERIPHERAL_OK(CLK_Peripheral));
 226                     ; 13   if (((uint8_t)CLK_Peripheral & (uint8_t)0x10) == 0x00)
 228  0001 9e            	ld	a,xh
 229  0002 a510          	bcp	a,#16
 230  0004 2633          	jrne	L301
 231                     ; 15     if (NewState != DISABLE)
 233  0006 0d02          	tnz	(OFST+2,sp)
 234  0008 2717          	jreq	L501
 235                     ; 18       CLK->PCKENR1 |= (uint8_t)((uint8_t)1 << ((uint8_t)CLK_Peripheral & (uint8_t)0x0F));
 237  000a 7b01          	ld	a,(OFST+1,sp)
 238  000c a40f          	and	a,#15
 239  000e 5f            	clrw	x
 240  000f 97            	ld	xl,a
 241  0010 a601          	ld	a,#1
 242  0012 5d            	tnzw	x
 243  0013 2704          	jreq	L6
 244  0015               L01:
 245  0015 48            	sll	a
 246  0016 5a            	decw	x
 247  0017 26fc          	jrne	L01
 248  0019               L6:
 249  0019 ca50c7        	or	a,20679
 250  001c c750c7        	ld	20679,a
 252  001f 2049          	jra	L111
 253  0021               L501:
 254                     ; 23       CLK->PCKENR1 &= (uint8_t)(~(uint8_t)(((uint8_t)1 << ((uint8_t)CLK_Peripheral & (uint8_t)0x0F))));
 256  0021 7b01          	ld	a,(OFST+1,sp)
 257  0023 a40f          	and	a,#15
 258  0025 5f            	clrw	x
 259  0026 97            	ld	xl,a
 260  0027 a601          	ld	a,#1
 261  0029 5d            	tnzw	x
 262  002a 2704          	jreq	L21
 263  002c               L41:
 264  002c 48            	sll	a
 265  002d 5a            	decw	x
 266  002e 26fc          	jrne	L41
 267  0030               L21:
 268  0030 43            	cpl	a
 269  0031 c450c7        	and	a,20679
 270  0034 c750c7        	ld	20679,a
 271  0037 2031          	jra	L111
 272  0039               L301:
 273                     ; 28     if (NewState != DISABLE)
 275  0039 0d02          	tnz	(OFST+2,sp)
 276  003b 2717          	jreq	L311
 277                     ; 31       CLK->PCKENR2 |= (uint8_t)((uint8_t)1 << ((uint8_t)CLK_Peripheral & (uint8_t)0x0F));
 279  003d 7b01          	ld	a,(OFST+1,sp)
 280  003f a40f          	and	a,#15
 281  0041 5f            	clrw	x
 282  0042 97            	ld	xl,a
 283  0043 a601          	ld	a,#1
 284  0045 5d            	tnzw	x
 285  0046 2704          	jreq	L61
 286  0048               L02:
 287  0048 48            	sll	a
 288  0049 5a            	decw	x
 289  004a 26fc          	jrne	L02
 290  004c               L61:
 291  004c ca50ca        	or	a,20682
 292  004f c750ca        	ld	20682,a
 294  0052 2016          	jra	L111
 295  0054               L311:
 296                     ; 36       CLK->PCKENR2 &= (uint8_t)(~(uint8_t)(((uint8_t)1 << ((uint8_t)CLK_Peripheral & (uint8_t)0x0F))));
 298  0054 7b01          	ld	a,(OFST+1,sp)
 299  0056 a40f          	and	a,#15
 300  0058 5f            	clrw	x
 301  0059 97            	ld	xl,a
 302  005a a601          	ld	a,#1
 303  005c 5d            	tnzw	x
 304  005d 2704          	jreq	L22
 305  005f               L42:
 306  005f 48            	sll	a
 307  0060 5a            	decw	x
 308  0061 26fc          	jrne	L42
 309  0063               L22:
 310  0063 43            	cpl	a
 311  0064 c450ca        	and	a,20682
 312  0067 c750ca        	ld	20682,a
 313  006a               L111:
 314                     ; 39 }
 317  006a 85            	popw	x
 318  006b 81            	ret
 456                     ; 41 void CLK_HSIPrescalerConfig(CLK_Prescaler_TypeDef HSIPrescaler)
 456                     ; 42 {
 457                     	switch	.text
 458  006c               _CLK_HSIPrescalerConfig:
 460  006c 88            	push	a
 461       00000000      OFST:	set	0
 464                     ; 44   assert_param(IS_CLK_HSIPRESCALER_OK(HSIPrescaler));
 466                     ; 47   CLK->CKDIVR &= (uint8_t)(~CLK_CKDIVR_HSIDIV);
 468  006d c650c6        	ld	a,20678
 469  0070 a4e7          	and	a,#231
 470  0072 c750c6        	ld	20678,a
 471                     ; 50   CLK->CKDIVR |= (uint8_t)HSIPrescaler;
 473  0075 c650c6        	ld	a,20678
 474  0078 1a01          	or	a,(OFST+1,sp)
 475  007a c750c6        	ld	20678,a
 476                     ; 51 }
 479  007d 84            	pop	a
 480  007e 81            	ret
 570                     ; 53 uint32_t CLK_GetClockFreq(void)
 570                     ; 54 {
 571                     	switch	.text
 572  007f               _CLK_GetClockFreq:
 574  007f 5209          	subw	sp,#9
 575       00000009      OFST:	set	9
 578                     ; 55   uint32_t clockfrequency = 0;
 580                     ; 56   CLK_Source_TypeDef clocksource = CLK_SOURCE_HSI;
 582                     ; 57   uint8_t tmp = 0, presc = 0;
 586                     ; 60   clocksource = (CLK_Source_TypeDef)CLK->CMSR;
 588  0081 c650c3        	ld	a,20675
 589  0084 6b09          	ld	(OFST+0,sp),a
 591                     ; 62   if (clocksource == CLK_SOURCE_HSI)
 593  0086 7b09          	ld	a,(OFST+0,sp)
 594  0088 a1e1          	cp	a,#225
 595  008a 2641          	jrne	L532
 596                     ; 64     tmp = (uint8_t)(CLK->CKDIVR & CLK_CKDIVR_HSIDIV);
 598  008c c650c6        	ld	a,20678
 599  008f a418          	and	a,#24
 600  0091 6b09          	ld	(OFST+0,sp),a
 602                     ; 65     tmp = (uint8_t)(tmp >> 3);
 604  0093 0409          	srl	(OFST+0,sp)
 605  0095 0409          	srl	(OFST+0,sp)
 606  0097 0409          	srl	(OFST+0,sp)
 608                     ; 66     presc = HSIDivFactor[tmp];
 610  0099 7b09          	ld	a,(OFST+0,sp)
 611  009b 5f            	clrw	x
 612  009c 97            	ld	xl,a
 613  009d d60000        	ld	a,(_HSIDivFactor,x)
 614  00a0 6b09          	ld	(OFST+0,sp),a
 616                     ; 67     clockfrequency = HSI_VALUE / presc;
 618  00a2 7b09          	ld	a,(OFST+0,sp)
 619  00a4 b703          	ld	c_lreg+3,a
 620  00a6 3f02          	clr	c_lreg+2
 621  00a8 3f01          	clr	c_lreg+1
 622  00aa 3f00          	clr	c_lreg
 623  00ac 96            	ldw	x,sp
 624  00ad 1c0001        	addw	x,#OFST-8
 625  00b0 cd0000        	call	c_rtol
 628  00b3 ae2400        	ldw	x,#9216
 629  00b6 bf02          	ldw	c_lreg+2,x
 630  00b8 ae00f4        	ldw	x,#244
 631  00bb bf00          	ldw	c_lreg,x
 632  00bd 96            	ldw	x,sp
 633  00be 1c0001        	addw	x,#OFST-8
 634  00c1 cd0000        	call	c_ludv
 636  00c4 96            	ldw	x,sp
 637  00c5 1c0005        	addw	x,#OFST-4
 638  00c8 cd0000        	call	c_rtol
 642  00cb 201c          	jra	L732
 643  00cd               L532:
 644                     ; 69   else if ( clocksource == CLK_SOURCE_LSI)
 646  00cd 7b09          	ld	a,(OFST+0,sp)
 647  00cf a1d2          	cp	a,#210
 648  00d1 260c          	jrne	L142
 649                     ; 71     clockfrequency = LSI_VALUE;
 651  00d3 aef400        	ldw	x,#62464
 652  00d6 1f07          	ldw	(OFST-2,sp),x
 653  00d8 ae0001        	ldw	x,#1
 654  00db 1f05          	ldw	(OFST-4,sp),x
 657  00dd 200a          	jra	L732
 658  00df               L142:
 659                     ; 75     clockfrequency = HSE_VALUE;
 661  00df ae2400        	ldw	x,#9216
 662  00e2 1f07          	ldw	(OFST-2,sp),x
 663  00e4 ae00f4        	ldw	x,#244
 664  00e7 1f05          	ldw	(OFST-4,sp),x
 666  00e9               L732:
 667                     ; 78   return((uint32_t)clockfrequency);
 669  00e9 96            	ldw	x,sp
 670  00ea 1c0005        	addw	x,#OFST-4
 671  00ed cd0000        	call	c_ltor
 675  00f0 5b09          	addw	sp,#9
 676  00f2 81            	ret
 711                     	xdef	_CLKPrescTable
 712                     	xdef	_HSIDivFactor
 713                     	xdef	_CLK_GetClockFreq
 714                     	xdef	_CLK_HSIPrescalerConfig
 715                     	xdef	_CLK_PeripheralClockConfig
 716                     	xref.b	c_lreg
 717                     	xref.b	c_x
 736                     	xref	c_ltor
 737                     	xref	c_ludv
 738                     	xref	c_rtol
 739                     	end
