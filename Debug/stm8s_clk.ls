   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  14                     	bsct
  15  0000               L3_sock_any_port:
  16  0000 c000          	dc.w	-16384
  46                     .const:	section	.text
  47  0000               _HSIDivFactor:
  48  0000 01            	dc.b	1
  49  0001 02            	dc.b	2
  50  0002 04            	dc.b	4
  51  0003 08            	dc.b	8
  52  0004               _CLKPrescTable:
  53  0004 01            	dc.b	1
  54  0005 02            	dc.b	2
  55  0006 04            	dc.b	4
  56  0007 08            	dc.b	8
  57  0008 0a            	dc.b	10
  58  0009 10            	dc.b	16
  59  000a 14            	dc.b	20
  60  000b 28            	dc.b	40
 245                     ; 7 void CLK_PeripheralClockConfig(CLK_Peripheral_TypeDef CLK_Peripheral, FunctionalState NewState)
 245                     ; 8 {
 247                     	switch	.text
 248  0000               _CLK_PeripheralClockConfig:
 250  0000 89            	pushw	x
 251       00000000      OFST:	set	0
 254                     ; 10   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 256                     ; 11   assert_param(IS_CLK_PERIPHERAL_OK(CLK_Peripheral));
 258                     ; 13   if (((uint8_t)CLK_Peripheral & (uint8_t)0x10) == 0x00)
 260  0001 9e            	ld	a,xh
 261  0002 a510          	bcp	a,#16
 262  0004 2633          	jrne	L121
 263                     ; 15     if (NewState != DISABLE)
 265  0006 0d02          	tnz	(OFST+2,sp)
 266  0008 2717          	jreq	L321
 267                     ; 18       CLK->PCKENR1 |= (uint8_t)((uint8_t)1 << ((uint8_t)CLK_Peripheral & (uint8_t)0x0F));
 269  000a 7b01          	ld	a,(OFST+1,sp)
 270  000c a40f          	and	a,#15
 271  000e 5f            	clrw	x
 272  000f 97            	ld	xl,a
 273  0010 a601          	ld	a,#1
 274  0012 5d            	tnzw	x
 275  0013 2704          	jreq	L6
 276  0015               L01:
 277  0015 48            	sll	a
 278  0016 5a            	decw	x
 279  0017 26fc          	jrne	L01
 280  0019               L6:
 281  0019 ca50c7        	or	a,20679
 282  001c c750c7        	ld	20679,a
 284  001f 2049          	jra	L721
 285  0021               L321:
 286                     ; 23       CLK->PCKENR1 &= (uint8_t)(~(uint8_t)(((uint8_t)1 << ((uint8_t)CLK_Peripheral & (uint8_t)0x0F))));
 288  0021 7b01          	ld	a,(OFST+1,sp)
 289  0023 a40f          	and	a,#15
 290  0025 5f            	clrw	x
 291  0026 97            	ld	xl,a
 292  0027 a601          	ld	a,#1
 293  0029 5d            	tnzw	x
 294  002a 2704          	jreq	L21
 295  002c               L41:
 296  002c 48            	sll	a
 297  002d 5a            	decw	x
 298  002e 26fc          	jrne	L41
 299  0030               L21:
 300  0030 43            	cpl	a
 301  0031 c450c7        	and	a,20679
 302  0034 c750c7        	ld	20679,a
 303  0037 2031          	jra	L721
 304  0039               L121:
 305                     ; 28     if (NewState != DISABLE)
 307  0039 0d02          	tnz	(OFST+2,sp)
 308  003b 2717          	jreq	L131
 309                     ; 31       CLK->PCKENR2 |= (uint8_t)((uint8_t)1 << ((uint8_t)CLK_Peripheral & (uint8_t)0x0F));
 311  003d 7b01          	ld	a,(OFST+1,sp)
 312  003f a40f          	and	a,#15
 313  0041 5f            	clrw	x
 314  0042 97            	ld	xl,a
 315  0043 a601          	ld	a,#1
 316  0045 5d            	tnzw	x
 317  0046 2704          	jreq	L61
 318  0048               L02:
 319  0048 48            	sll	a
 320  0049 5a            	decw	x
 321  004a 26fc          	jrne	L02
 322  004c               L61:
 323  004c ca50ca        	or	a,20682
 324  004f c750ca        	ld	20682,a
 326  0052 2016          	jra	L721
 327  0054               L131:
 328                     ; 36       CLK->PCKENR2 &= (uint8_t)(~(uint8_t)(((uint8_t)1 << ((uint8_t)CLK_Peripheral & (uint8_t)0x0F))));
 330  0054 7b01          	ld	a,(OFST+1,sp)
 331  0056 a40f          	and	a,#15
 332  0058 5f            	clrw	x
 333  0059 97            	ld	xl,a
 334  005a a601          	ld	a,#1
 335  005c 5d            	tnzw	x
 336  005d 2704          	jreq	L22
 337  005f               L42:
 338  005f 48            	sll	a
 339  0060 5a            	decw	x
 340  0061 26fc          	jrne	L42
 341  0063               L22:
 342  0063 43            	cpl	a
 343  0064 c450ca        	and	a,20682
 344  0067 c750ca        	ld	20682,a
 345  006a               L721:
 346                     ; 39 }
 349  006a 85            	popw	x
 350  006b 81            	ret
 488                     ; 41 void CLK_HSIPrescalerConfig(CLK_Prescaler_TypeDef HSIPrescaler)
 488                     ; 42 {
 489                     	switch	.text
 490  006c               _CLK_HSIPrescalerConfig:
 492  006c 88            	push	a
 493       00000000      OFST:	set	0
 496                     ; 44   assert_param(IS_CLK_HSIPRESCALER_OK(HSIPrescaler));
 498                     ; 47   CLK->CKDIVR &= (uint8_t)(~CLK_CKDIVR_HSIDIV);
 500  006d c650c6        	ld	a,20678
 501  0070 a4e7          	and	a,#231
 502  0072 c750c6        	ld	20678,a
 503                     ; 50   CLK->CKDIVR |= (uint8_t)HSIPrescaler;
 505  0075 c650c6        	ld	a,20678
 506  0078 1a01          	or	a,(OFST+1,sp)
 507  007a c750c6        	ld	20678,a
 508                     ; 51 }
 511  007d 84            	pop	a
 512  007e 81            	ret
 602                     ; 53 uint32_t CLK_GetClockFreq(void)
 602                     ; 54 {
 603                     	switch	.text
 604  007f               _CLK_GetClockFreq:
 606  007f 5209          	subw	sp,#9
 607       00000009      OFST:	set	9
 610                     ; 55   uint32_t clockfrequency = 0;
 612                     ; 56   CLK_Source_TypeDef clocksource = CLK_SOURCE_HSI;
 614                     ; 57   uint8_t tmp = 0, presc = 0;
 618                     ; 60   clocksource = (CLK_Source_TypeDef)CLK->CMSR;
 620  0081 c650c3        	ld	a,20675
 621  0084 6b09          	ld	(OFST+0,sp),a
 623                     ; 62   if (clocksource == CLK_SOURCE_HSI)
 625  0086 7b09          	ld	a,(OFST+0,sp)
 626  0088 a1e1          	cp	a,#225
 627  008a 2641          	jrne	L352
 628                     ; 64     tmp = (uint8_t)(CLK->CKDIVR & CLK_CKDIVR_HSIDIV);
 630  008c c650c6        	ld	a,20678
 631  008f a418          	and	a,#24
 632  0091 6b09          	ld	(OFST+0,sp),a
 634                     ; 65     tmp = (uint8_t)(tmp >> 3);
 636  0093 0409          	srl	(OFST+0,sp)
 637  0095 0409          	srl	(OFST+0,sp)
 638  0097 0409          	srl	(OFST+0,sp)
 640                     ; 66     presc = HSIDivFactor[tmp];
 642  0099 7b09          	ld	a,(OFST+0,sp)
 643  009b 5f            	clrw	x
 644  009c 97            	ld	xl,a
 645  009d d60000        	ld	a,(_HSIDivFactor,x)
 646  00a0 6b09          	ld	(OFST+0,sp),a
 648                     ; 67     clockfrequency = HSI_VALUE / presc;
 650  00a2 7b09          	ld	a,(OFST+0,sp)
 651  00a4 b703          	ld	c_lreg+3,a
 652  00a6 3f02          	clr	c_lreg+2
 653  00a8 3f01          	clr	c_lreg+1
 654  00aa 3f00          	clr	c_lreg
 655  00ac 96            	ldw	x,sp
 656  00ad 1c0001        	addw	x,#OFST-8
 657  00b0 cd0000        	call	c_rtol
 660  00b3 ae2400        	ldw	x,#9216
 661  00b6 bf02          	ldw	c_lreg+2,x
 662  00b8 ae00f4        	ldw	x,#244
 663  00bb bf00          	ldw	c_lreg,x
 664  00bd 96            	ldw	x,sp
 665  00be 1c0001        	addw	x,#OFST-8
 666  00c1 cd0000        	call	c_ludv
 668  00c4 96            	ldw	x,sp
 669  00c5 1c0005        	addw	x,#OFST-4
 670  00c8 cd0000        	call	c_rtol
 674  00cb 201c          	jra	L552
 675  00cd               L352:
 676                     ; 69   else if ( clocksource == CLK_SOURCE_LSI)
 678  00cd 7b09          	ld	a,(OFST+0,sp)
 679  00cf a1d2          	cp	a,#210
 680  00d1 260c          	jrne	L752
 681                     ; 71     clockfrequency = LSI_VALUE;
 683  00d3 aef400        	ldw	x,#62464
 684  00d6 1f07          	ldw	(OFST-2,sp),x
 685  00d8 ae0001        	ldw	x,#1
 686  00db 1f05          	ldw	(OFST-4,sp),x
 689  00dd 200a          	jra	L552
 690  00df               L752:
 691                     ; 75     clockfrequency = HSE_VALUE;
 693  00df ae2400        	ldw	x,#9216
 694  00e2 1f07          	ldw	(OFST-2,sp),x
 695  00e4 ae00f4        	ldw	x,#244
 696  00e7 1f05          	ldw	(OFST-4,sp),x
 698  00e9               L552:
 699                     ; 78   return((uint32_t)clockfrequency);
 701  00e9 96            	ldw	x,sp
 702  00ea 1c0005        	addw	x,#OFST-4
 703  00ed cd0000        	call	c_ltor
 707  00f0 5b09          	addw	sp,#9
 708  00f2 81            	ret
 743                     	xdef	_CLKPrescTable
 744                     	xdef	_HSIDivFactor
 745                     	xdef	_CLK_GetClockFreq
 746                     	xdef	_CLK_HSIPrescalerConfig
 747                     	xdef	_CLK_PeripheralClockConfig
 748                     	xref.b	c_lreg
 749                     	xref.b	c_x
 768                     	xref	c_ltor
 769                     	xref	c_ludv
 770                     	xref	c_rtol
 771                     	end
