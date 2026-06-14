   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  14                     	bsct
  15  0000               L3_sock_any_port:
  16  0000 c000          	dc.w	-16384
 342                     ; 6 void GPIO_Init(GPIO_TypeDef* GPIOx, GPIO_Pin_TypeDef GPIO_Pin, GPIO_Mode_TypeDef GPIO_Mode)
 342                     ; 7 {
 344                     	switch	.text
 345  0000               _GPIO_Init:
 347  0000 89            	pushw	x
 348       00000000      OFST:	set	0
 351                     ; 12   assert_param(IS_GPIO_MODE_OK(GPIO_Mode));
 353                     ; 13   assert_param(IS_GPIO_PIN_OK(GPIO_Pin));
 355                     ; 16   GPIOx->CR2 &= (uint8_t)(~(GPIO_Pin));
 357  0001 7b05          	ld	a,(OFST+5,sp)
 358  0003 43            	cpl	a
 359  0004 e404          	and	a,(4,x)
 360  0006 e704          	ld	(4,x),a
 361                     ; 22   if ((((uint8_t)(GPIO_Mode)) & (uint8_t)0x80) != (uint8_t)0x00) /* Output mode */
 363  0008 7b06          	ld	a,(OFST+6,sp)
 364  000a a580          	bcp	a,#128
 365  000c 271d          	jreq	L571
 366                     ; 24     if ((((uint8_t)(GPIO_Mode)) & (uint8_t)0x10) != (uint8_t)0x00) /* High level */
 368  000e 7b06          	ld	a,(OFST+6,sp)
 369  0010 a510          	bcp	a,#16
 370  0012 2706          	jreq	L771
 371                     ; 26       GPIOx->ODR |= (uint8_t)GPIO_Pin;
 373  0014 f6            	ld	a,(x)
 374  0015 1a05          	or	a,(OFST+5,sp)
 375  0017 f7            	ld	(x),a
 377  0018 2007          	jra	L102
 378  001a               L771:
 379                     ; 30       GPIOx->ODR &= (uint8_t)(~(GPIO_Pin));
 381  001a 1e01          	ldw	x,(OFST+1,sp)
 382  001c 7b05          	ld	a,(OFST+5,sp)
 383  001e 43            	cpl	a
 384  001f f4            	and	a,(x)
 385  0020 f7            	ld	(x),a
 386  0021               L102:
 387                     ; 33     GPIOx->DDR |= (uint8_t)GPIO_Pin;
 389  0021 1e01          	ldw	x,(OFST+1,sp)
 390  0023 e602          	ld	a,(2,x)
 391  0025 1a05          	or	a,(OFST+5,sp)
 392  0027 e702          	ld	(2,x),a
 394  0029 2009          	jra	L302
 395  002b               L571:
 396                     ; 38     GPIOx->DDR &= (uint8_t)(~(GPIO_Pin));
 398  002b 1e01          	ldw	x,(OFST+1,sp)
 399  002d 7b05          	ld	a,(OFST+5,sp)
 400  002f 43            	cpl	a
 401  0030 e402          	and	a,(2,x)
 402  0032 e702          	ld	(2,x),a
 403  0034               L302:
 404                     ; 45   if ((((uint8_t)(GPIO_Mode)) & (uint8_t)0x40) != (uint8_t)0x00) /* Pull-Up or Push-Pull */
 406  0034 7b06          	ld	a,(OFST+6,sp)
 407  0036 a540          	bcp	a,#64
 408  0038 270a          	jreq	L502
 409                     ; 47     GPIOx->CR1 |= (uint8_t)GPIO_Pin;
 411  003a 1e01          	ldw	x,(OFST+1,sp)
 412  003c e603          	ld	a,(3,x)
 413  003e 1a05          	or	a,(OFST+5,sp)
 414  0040 e703          	ld	(3,x),a
 416  0042 2009          	jra	L702
 417  0044               L502:
 418                     ; 51     GPIOx->CR1 &= (uint8_t)(~(GPIO_Pin));
 420  0044 1e01          	ldw	x,(OFST+1,sp)
 421  0046 7b05          	ld	a,(OFST+5,sp)
 422  0048 43            	cpl	a
 423  0049 e403          	and	a,(3,x)
 424  004b e703          	ld	(3,x),a
 425  004d               L702:
 426                     ; 58   if ((((uint8_t)(GPIO_Mode)) & (uint8_t)0x20) != (uint8_t)0x00) /* Interrupt or Slow slope */
 428  004d 7b06          	ld	a,(OFST+6,sp)
 429  004f a520          	bcp	a,#32
 430  0051 270a          	jreq	L112
 431                     ; 60     GPIOx->CR2 |= (uint8_t)GPIO_Pin;
 433  0053 1e01          	ldw	x,(OFST+1,sp)
 434  0055 e604          	ld	a,(4,x)
 435  0057 1a05          	or	a,(OFST+5,sp)
 436  0059 e704          	ld	(4,x),a
 438  005b 2009          	jra	L312
 439  005d               L112:
 440                     ; 64     GPIOx->CR2 &= (uint8_t)(~(GPIO_Pin));
 442  005d 1e01          	ldw	x,(OFST+1,sp)
 443  005f 7b05          	ld	a,(OFST+5,sp)
 444  0061 43            	cpl	a
 445  0062 e404          	and	a,(4,x)
 446  0064 e704          	ld	(4,x),a
 447  0066               L312:
 448                     ; 66 }
 451  0066 85            	popw	x
 452  0067 81            	ret
 498                     ; 68 void GPIO_Write(GPIO_TypeDef* GPIOx, uint8_t PortVal)
 498                     ; 69 {
 499                     	switch	.text
 500  0068               _GPIO_Write:
 502  0068 89            	pushw	x
 503       00000000      OFST:	set	0
 506                     ; 70   GPIOx->ODR = PortVal;
 508  0069 7b05          	ld	a,(OFST+5,sp)
 509  006b 1e01          	ldw	x,(OFST+1,sp)
 510  006d f7            	ld	(x),a
 511                     ; 71 }
 514  006e 85            	popw	x
 515  006f 81            	ret
 562                     ; 72 void GPIO_WriteHigh(GPIO_TypeDef* GPIOx, GPIO_Pin_TypeDef PortPins)
 562                     ; 73 {
 563                     	switch	.text
 564  0070               _GPIO_WriteHigh:
 566  0070 89            	pushw	x
 567       00000000      OFST:	set	0
 570                     ; 74   GPIOx->ODR |= (uint8_t)PortPins;
 572  0071 f6            	ld	a,(x)
 573  0072 1a05          	or	a,(OFST+5,sp)
 574  0074 f7            	ld	(x),a
 575                     ; 75 }
 578  0075 85            	popw	x
 579  0076 81            	ret
 626                     ; 77 void GPIO_WriteLow(GPIO_TypeDef* GPIOx, GPIO_Pin_TypeDef PortPins)
 626                     ; 78 {
 627                     	switch	.text
 628  0077               _GPIO_WriteLow:
 630  0077 89            	pushw	x
 631       00000000      OFST:	set	0
 634                     ; 79   GPIOx->ODR &= (uint8_t)(~PortPins);
 636  0078 7b05          	ld	a,(OFST+5,sp)
 637  007a 43            	cpl	a
 638  007b f4            	and	a,(x)
 639  007c f7            	ld	(x),a
 640                     ; 80 }
 643  007d 85            	popw	x
 644  007e 81            	ret
 712                     ; 82 BitStatus GPIO_ReadInputPin(GPIO_TypeDef* GPIOx, GPIO_Pin_TypeDef GPIO_Pin)
 712                     ; 83 {
 713                     	switch	.text
 714  007f               _GPIO_ReadInputPin:
 716  007f 89            	pushw	x
 717       00000000      OFST:	set	0
 720                     ; 84   return ((BitStatus)(GPIOx->IDR & (uint8_t)GPIO_Pin));
 722  0080 e601          	ld	a,(1,x)
 723  0082 1405          	and	a,(OFST+5,sp)
 726  0084 85            	popw	x
 727  0085 81            	ret
 740                     	xdef	_GPIO_ReadInputPin
 741                     	xdef	_GPIO_WriteLow
 742                     	xdef	_GPIO_WriteHigh
 743                     	xdef	_GPIO_Write
 744                     	xdef	_GPIO_Init
 763                     	end
