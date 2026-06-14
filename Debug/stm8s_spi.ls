   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  14                     	bsct
  15  0000               L3_sock_any_port:
  16  0000 c000          	dc.w	-16384
  73                     ; 3 void SPI_DeInit(void)
  73                     ; 4 {
  75                     	switch	.text
  76  0000               _SPI_DeInit:
  80                     ; 5   SPI->CR1    = SPI_CR1_RESET_VALUE;
  82  0000 725f5200      	clr	20992
  83                     ; 6   SPI->CR2    = SPI_CR2_RESET_VALUE;
  85  0004 725f5201      	clr	20993
  86                     ; 7   SPI->ICR    = SPI_ICR_RESET_VALUE;
  88  0008 725f5202      	clr	20994
  89                     ; 8   SPI->SR     = SPI_SR_RESET_VALUE;
  91  000c 35025203      	mov	20995,#2
  92                     ; 9   SPI->CRCPR  = SPI_CRCPR_RESET_VALUE;
  94  0010 35075205      	mov	20997,#7
  95                     ; 10 }
  98  0014 81            	ret
 414                     ; 12 void SPI_Init(SPI_FirstBit_TypeDef FirstBit, SPI_BaudRatePrescaler_TypeDef BaudRatePrescaler, SPI_Mode_TypeDef Mode, SPI_ClockPolarity_TypeDef ClockPolarity, SPI_ClockPhase_TypeDef ClockPhase, SPI_DataDirection_TypeDef Data_Direction, SPI_NSS_TypeDef Slave_Management, uint8_t CRCPolynomial)
 414                     ; 13 {
 415                     	switch	.text
 416  0015               _SPI_Init:
 418  0015 89            	pushw	x
 419  0016 88            	push	a
 420       00000001      OFST:	set	1
 423                     ; 15   assert_param(IS_SPI_FIRSTBIT_OK(FirstBit));
 425                     ; 16   assert_param(IS_SPI_BAUDRATE_PRESCALER_OK(BaudRatePrescaler));
 427                     ; 17   assert_param(IS_SPI_MODE_OK(Mode));
 429                     ; 18   assert_param(IS_SPI_POLARITY_OK(ClockPolarity));
 431                     ; 19   assert_param(IS_SPI_PHASE_OK(ClockPhase));
 433                     ; 20   assert_param(IS_SPI_DATA_DIRECTION_OK(Data_Direction));
 435                     ; 21   assert_param(IS_SPI_SLAVEMANAGEMENT_OK(Slave_Management));
 437                     ; 22   assert_param(IS_SPI_CRC_POLYNOMIAL_OK(CRCPolynomial));
 439                     ; 25   SPI->CR1 = (uint8_t)((uint8_t)((uint8_t)FirstBit | BaudRatePrescaler) |
 439                     ; 26                        (uint8_t)((uint8_t)ClockPolarity | ClockPhase));
 441  0017 7b07          	ld	a,(OFST+6,sp)
 442  0019 1a08          	or	a,(OFST+7,sp)
 443  001b 6b01          	ld	(OFST+0,sp),a
 445  001d 9f            	ld	a,xl
 446  001e 1a02          	or	a,(OFST+1,sp)
 447  0020 1a01          	or	a,(OFST+0,sp)
 448  0022 c75200        	ld	20992,a
 449                     ; 29   SPI->CR2 = (uint8_t)((uint8_t)(Data_Direction) | (uint8_t)(Slave_Management));
 451  0025 7b09          	ld	a,(OFST+8,sp)
 452  0027 1a0a          	or	a,(OFST+9,sp)
 453  0029 c75201        	ld	20993,a
 454                     ; 31   if (Mode == SPI_MODE_MASTER)
 456  002c 7b06          	ld	a,(OFST+5,sp)
 457  002e a104          	cp	a,#4
 458  0030 2606          	jrne	L122
 459                     ; 33     SPI->CR2 |= (uint8_t)SPI_CR2_SSI;
 461  0032 72105201      	bset	20993,#0
 463  0036 2004          	jra	L322
 464  0038               L122:
 465                     ; 37     SPI->CR2 &= (uint8_t)~(SPI_CR2_SSI);
 467  0038 72115201      	bres	20993,#0
 468  003c               L322:
 469                     ; 41   SPI->CR1 |= (uint8_t)(Mode);
 471  003c c65200        	ld	a,20992
 472  003f 1a06          	or	a,(OFST+5,sp)
 473  0041 c75200        	ld	20992,a
 474                     ; 44   SPI->CRCPR = (uint8_t)CRCPolynomial;
 476  0044 7b0b          	ld	a,(OFST+10,sp)
 477  0046 c75205        	ld	20997,a
 478                     ; 45 }
 481  0049 5b03          	addw	sp,#3
 482  004b 81            	ret
 537                     ; 47 void SPI_Cmd(FunctionalState NewState)
 537                     ; 48 {
 538                     	switch	.text
 539  004c               _SPI_Cmd:
 543                     ; 50   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 545                     ; 52   if (NewState != DISABLE)
 547  004c 4d            	tnz	a
 548  004d 2706          	jreq	L352
 549                     ; 54     SPI->CR1 |= SPI_CR1_SPE; /* Enable the SPI peripheral*/
 551  004f 721c5200      	bset	20992,#6
 553  0053 2004          	jra	L552
 554  0055               L352:
 555                     ; 58     SPI->CR1 &= (uint8_t)(~SPI_CR1_SPE); /* Disable the SPI peripheral*/
 557  0055 721d5200      	bres	20992,#6
 558  0059               L552:
 559                     ; 60 }
 562  0059 81            	ret
 596                     ; 62 void SPI_SendData(uint8_t Data)
 596                     ; 63 {
 597                     	switch	.text
 598  005a               _SPI_SendData:
 602                     ; 64   SPI->DR = Data; /* Write in the DR register the data to be sent*/
 604  005a c75204        	ld	20996,a
 605                     ; 65 }
 608  005d 81            	ret
 631                     ; 67 uint8_t SPI_ReceiveData(void)
 631                     ; 68 {
 632                     	switch	.text
 633  005e               _SPI_ReceiveData:
 637                     ; 69   return ((uint8_t)SPI->DR); /* Return the data in the DR register*/
 639  005e c65204        	ld	a,20996
 642  0061 81            	ret
 763                     ; 72 FlagStatus SPI_GetFlagStatus(SPI_Flag_TypeDef SPI_FLAG)
 763                     ; 73 {
 764                     	switch	.text
 765  0062               _SPI_GetFlagStatus:
 767  0062 88            	push	a
 768       00000001      OFST:	set	1
 771                     ; 74   FlagStatus status = RESET;
 773                     ; 76   assert_param(IS_SPI_FLAGS_OK(SPI_FLAG));
 775                     ; 79   if ((SPI->SR & (uint8_t)SPI_FLAG) != (uint8_t)RESET)
 777  0063 c45203        	and	a,20995
 778  0066 2706          	jreq	L163
 779                     ; 81     status = SET; /* SPI_FLAG is set */
 781  0068 a601          	ld	a,#1
 782  006a 6b01          	ld	(OFST+0,sp),a
 785  006c 2002          	jra	L363
 786  006e               L163:
 787                     ; 85     status = RESET; /* SPI_FLAG is reset*/
 789  006e 0f01          	clr	(OFST+0,sp)
 791  0070               L363:
 792                     ; 89   return status;
 794  0070 7b01          	ld	a,(OFST+0,sp)
 797  0072 5b01          	addw	sp,#1
 798  0074 81            	ret
 811                     	xdef	_SPI_GetFlagStatus
 812                     	xdef	_SPI_ReceiveData
 813                     	xdef	_SPI_SendData
 814                     	xdef	_SPI_Cmd
 815                     	xdef	_SPI_Init
 816                     	xdef	_SPI_DeInit
 835                     	end
