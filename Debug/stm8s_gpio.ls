   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
 311                     ; 6 void GPIO_Init(GPIO_TypeDef* GPIOx, GPIO_Pin_TypeDef GPIO_Pin, GPIO_Mode_TypeDef GPIO_Mode)
 311                     ; 7 {
 313                     	switch	.text
 314  0000               _GPIO_Init:
 316  0000 89            	pushw	x
 317       00000000      OFST:	set	0
 320                     ; 12   assert_param(IS_GPIO_MODE_OK(GPIO_Mode));
 322                     ; 13   assert_param(IS_GPIO_PIN_OK(GPIO_Pin));
 324                     ; 16   GPIOx->CR2 &= (uint8_t)(~(GPIO_Pin));
 326  0001 7b05          	ld	a,(OFST+5,sp)
 327  0003 43            	cpl	a
 328  0004 e404          	and	a,(4,x)
 329  0006 e704          	ld	(4,x),a
 330                     ; 22   if ((((uint8_t)(GPIO_Mode)) & (uint8_t)0x80) != (uint8_t)0x00) /* Output mode */
 332  0008 7b06          	ld	a,(OFST+6,sp)
 333  000a a580          	bcp	a,#128
 334  000c 271d          	jreq	L751
 335                     ; 24     if ((((uint8_t)(GPIO_Mode)) & (uint8_t)0x10) != (uint8_t)0x00) /* High level */
 337  000e 7b06          	ld	a,(OFST+6,sp)
 338  0010 a510          	bcp	a,#16
 339  0012 2706          	jreq	L161
 340                     ; 26       GPIOx->ODR |= (uint8_t)GPIO_Pin;
 342  0014 f6            	ld	a,(x)
 343  0015 1a05          	or	a,(OFST+5,sp)
 344  0017 f7            	ld	(x),a
 346  0018 2007          	jra	L361
 347  001a               L161:
 348                     ; 30       GPIOx->ODR &= (uint8_t)(~(GPIO_Pin));
 350  001a 1e01          	ldw	x,(OFST+1,sp)
 351  001c 7b05          	ld	a,(OFST+5,sp)
 352  001e 43            	cpl	a
 353  001f f4            	and	a,(x)
 354  0020 f7            	ld	(x),a
 355  0021               L361:
 356                     ; 33     GPIOx->DDR |= (uint8_t)GPIO_Pin;
 358  0021 1e01          	ldw	x,(OFST+1,sp)
 359  0023 e602          	ld	a,(2,x)
 360  0025 1a05          	or	a,(OFST+5,sp)
 361  0027 e702          	ld	(2,x),a
 363  0029 2009          	jra	L561
 364  002b               L751:
 365                     ; 38     GPIOx->DDR &= (uint8_t)(~(GPIO_Pin));
 367  002b 1e01          	ldw	x,(OFST+1,sp)
 368  002d 7b05          	ld	a,(OFST+5,sp)
 369  002f 43            	cpl	a
 370  0030 e402          	and	a,(2,x)
 371  0032 e702          	ld	(2,x),a
 372  0034               L561:
 373                     ; 45   if ((((uint8_t)(GPIO_Mode)) & (uint8_t)0x40) != (uint8_t)0x00) /* Pull-Up or Push-Pull */
 375  0034 7b06          	ld	a,(OFST+6,sp)
 376  0036 a540          	bcp	a,#64
 377  0038 270a          	jreq	L761
 378                     ; 47     GPIOx->CR1 |= (uint8_t)GPIO_Pin;
 380  003a 1e01          	ldw	x,(OFST+1,sp)
 381  003c e603          	ld	a,(3,x)
 382  003e 1a05          	or	a,(OFST+5,sp)
 383  0040 e703          	ld	(3,x),a
 385  0042 2009          	jra	L171
 386  0044               L761:
 387                     ; 51     GPIOx->CR1 &= (uint8_t)(~(GPIO_Pin));
 389  0044 1e01          	ldw	x,(OFST+1,sp)
 390  0046 7b05          	ld	a,(OFST+5,sp)
 391  0048 43            	cpl	a
 392  0049 e403          	and	a,(3,x)
 393  004b e703          	ld	(3,x),a
 394  004d               L171:
 395                     ; 58   if ((((uint8_t)(GPIO_Mode)) & (uint8_t)0x20) != (uint8_t)0x00) /* Interrupt or Slow slope */
 397  004d 7b06          	ld	a,(OFST+6,sp)
 398  004f a520          	bcp	a,#32
 399  0051 270a          	jreq	L371
 400                     ; 60     GPIOx->CR2 |= (uint8_t)GPIO_Pin;
 402  0053 1e01          	ldw	x,(OFST+1,sp)
 403  0055 e604          	ld	a,(4,x)
 404  0057 1a05          	or	a,(OFST+5,sp)
 405  0059 e704          	ld	(4,x),a
 407  005b 2009          	jra	L571
 408  005d               L371:
 409                     ; 64     GPIOx->CR2 &= (uint8_t)(~(GPIO_Pin));
 411  005d 1e01          	ldw	x,(OFST+1,sp)
 412  005f 7b05          	ld	a,(OFST+5,sp)
 413  0061 43            	cpl	a
 414  0062 e404          	and	a,(4,x)
 415  0064 e704          	ld	(4,x),a
 416  0066               L571:
 417                     ; 66 }
 420  0066 85            	popw	x
 421  0067 81            	ret
 467                     ; 68 void GPIO_Write(GPIO_TypeDef* GPIOx, uint8_t PortVal)
 467                     ; 69 {
 468                     	switch	.text
 469  0068               _GPIO_Write:
 471  0068 89            	pushw	x
 472       00000000      OFST:	set	0
 475                     ; 70   GPIOx->ODR = PortVal;
 477  0069 7b05          	ld	a,(OFST+5,sp)
 478  006b 1e01          	ldw	x,(OFST+1,sp)
 479  006d f7            	ld	(x),a
 480                     ; 71 }
 483  006e 85            	popw	x
 484  006f 81            	ret
 531                     ; 72 void GPIO_WriteHigh(GPIO_TypeDef* GPIOx, GPIO_Pin_TypeDef PortPins)
 531                     ; 73 {
 532                     	switch	.text
 533  0070               _GPIO_WriteHigh:
 535  0070 89            	pushw	x
 536       00000000      OFST:	set	0
 539                     ; 74   GPIOx->ODR |= (uint8_t)PortPins;
 541  0071 f6            	ld	a,(x)
 542  0072 1a05          	or	a,(OFST+5,sp)
 543  0074 f7            	ld	(x),a
 544                     ; 75 }
 547  0075 85            	popw	x
 548  0076 81            	ret
 595                     ; 77 void GPIO_WriteLow(GPIO_TypeDef* GPIOx, GPIO_Pin_TypeDef PortPins)
 595                     ; 78 {
 596                     	switch	.text
 597  0077               _GPIO_WriteLow:
 599  0077 89            	pushw	x
 600       00000000      OFST:	set	0
 603                     ; 79   GPIOx->ODR &= (uint8_t)(~PortPins);
 605  0078 7b05          	ld	a,(OFST+5,sp)
 606  007a 43            	cpl	a
 607  007b f4            	and	a,(x)
 608  007c f7            	ld	(x),a
 609                     ; 80 }
 612  007d 85            	popw	x
 613  007e 81            	ret
 681                     ; 82 BitStatus GPIO_ReadInputPin(GPIO_TypeDef* GPIOx, GPIO_Pin_TypeDef GPIO_Pin)
 681                     ; 83 {
 682                     	switch	.text
 683  007f               _GPIO_ReadInputPin:
 685  007f 89            	pushw	x
 686       00000000      OFST:	set	0
 689                     ; 84   return ((BitStatus)(GPIOx->IDR & (uint8_t)GPIO_Pin));
 691  0080 e601          	ld	a,(1,x)
 692  0082 1405          	and	a,(OFST+5,sp)
 695  0084 85            	popw	x
 696  0085 81            	ret
 709                     	xdef	_GPIO_ReadInputPin
 710                     	xdef	_GPIO_WriteLow
 711                     	xdef	_GPIO_WriteHigh
 712                     	xdef	_GPIO_Write
 713                     	xdef	_GPIO_Init
 732                     	end
