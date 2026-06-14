   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  42                     ; 3 void SPI_DeInit(void)
  42                     ; 4 {
  44                     	switch	.text
  45  0000               _SPI_DeInit:
  49                     ; 5   SPI->CR1    = SPI_CR1_RESET_VALUE;
  51  0000 725f5200      	clr	20992
  52                     ; 6   SPI->CR2    = SPI_CR2_RESET_VALUE;
  54  0004 725f5201      	clr	20993
  55                     ; 7   SPI->ICR    = SPI_ICR_RESET_VALUE;
  57  0008 725f5202      	clr	20994
  58                     ; 8   SPI->SR     = SPI_SR_RESET_VALUE;
  60  000c 35025203      	mov	20995,#2
  61                     ; 9   SPI->CRCPR  = SPI_CRCPR_RESET_VALUE;
  63  0010 35075205      	mov	20997,#7
  64                     ; 10 }
  67  0014 81            	ret
 383                     ; 12 void SPI_Init(SPI_FirstBit_TypeDef FirstBit, SPI_BaudRatePrescaler_TypeDef BaudRatePrescaler, SPI_Mode_TypeDef Mode, SPI_ClockPolarity_TypeDef ClockPolarity, SPI_ClockPhase_TypeDef ClockPhase, SPI_DataDirection_TypeDef Data_Direction, SPI_NSS_TypeDef Slave_Management, uint8_t CRCPolynomial)
 383                     ; 13 {
 384                     	switch	.text
 385  0015               _SPI_Init:
 387  0015 89            	pushw	x
 388  0016 88            	push	a
 389       00000001      OFST:	set	1
 392                     ; 15   assert_param(IS_SPI_FIRSTBIT_OK(FirstBit));
 394                     ; 16   assert_param(IS_SPI_BAUDRATE_PRESCALER_OK(BaudRatePrescaler));
 396                     ; 17   assert_param(IS_SPI_MODE_OK(Mode));
 398                     ; 18   assert_param(IS_SPI_POLARITY_OK(ClockPolarity));
 400                     ; 19   assert_param(IS_SPI_PHASE_OK(ClockPhase));
 402                     ; 20   assert_param(IS_SPI_DATA_DIRECTION_OK(Data_Direction));
 404                     ; 21   assert_param(IS_SPI_SLAVEMANAGEMENT_OK(Slave_Management));
 406                     ; 22   assert_param(IS_SPI_CRC_POLYNOMIAL_OK(CRCPolynomial));
 408                     ; 25   SPI->CR1 = (uint8_t)((uint8_t)((uint8_t)FirstBit | BaudRatePrescaler) |
 408                     ; 26                        (uint8_t)((uint8_t)ClockPolarity | ClockPhase));
 410  0017 7b07          	ld	a,(OFST+6,sp)
 411  0019 1a08          	or	a,(OFST+7,sp)
 412  001b 6b01          	ld	(OFST+0,sp),a
 414  001d 9f            	ld	a,xl
 415  001e 1a02          	or	a,(OFST+1,sp)
 416  0020 1a01          	or	a,(OFST+0,sp)
 417  0022 c75200        	ld	20992,a
 418                     ; 29   SPI->CR2 = (uint8_t)((uint8_t)(Data_Direction) | (uint8_t)(Slave_Management));
 420  0025 7b09          	ld	a,(OFST+8,sp)
 421  0027 1a0a          	or	a,(OFST+9,sp)
 422  0029 c75201        	ld	20993,a
 423                     ; 31   if (Mode == SPI_MODE_MASTER)
 425  002c 7b06          	ld	a,(OFST+5,sp)
 426  002e a104          	cp	a,#4
 427  0030 2606          	jrne	L302
 428                     ; 33     SPI->CR2 |= (uint8_t)SPI_CR2_SSI;
 430  0032 72105201      	bset	20993,#0
 432  0036 2004          	jra	L502
 433  0038               L302:
 434                     ; 37     SPI->CR2 &= (uint8_t)~(SPI_CR2_SSI);
 436  0038 72115201      	bres	20993,#0
 437  003c               L502:
 438                     ; 41   SPI->CR1 |= (uint8_t)(Mode);
 440  003c c65200        	ld	a,20992
 441  003f 1a06          	or	a,(OFST+5,sp)
 442  0041 c75200        	ld	20992,a
 443                     ; 44   SPI->CRCPR = (uint8_t)CRCPolynomial;
 445  0044 7b0b          	ld	a,(OFST+10,sp)
 446  0046 c75205        	ld	20997,a
 447                     ; 45 }
 450  0049 5b03          	addw	sp,#3
 451  004b 81            	ret
 506                     ; 47 void SPI_Cmd(FunctionalState NewState)
 506                     ; 48 {
 507                     	switch	.text
 508  004c               _SPI_Cmd:
 512                     ; 50   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 514                     ; 52   if (NewState != DISABLE)
 516  004c 4d            	tnz	a
 517  004d 2706          	jreq	L532
 518                     ; 54     SPI->CR1 |= SPI_CR1_SPE; /* Enable the SPI peripheral*/
 520  004f 721c5200      	bset	20992,#6
 522  0053 2004          	jra	L732
 523  0055               L532:
 524                     ; 58     SPI->CR1 &= (uint8_t)(~SPI_CR1_SPE); /* Disable the SPI peripheral*/
 526  0055 721d5200      	bres	20992,#6
 527  0059               L732:
 528                     ; 60 }
 531  0059 81            	ret
 565                     ; 62 void SPI_SendData(uint8_t Data)
 565                     ; 63 {
 566                     	switch	.text
 567  005a               _SPI_SendData:
 571                     ; 64   SPI->DR = Data; /* Write in the DR register the data to be sent*/
 573  005a c75204        	ld	20996,a
 574                     ; 65 }
 577  005d 81            	ret
 600                     ; 67 uint8_t SPI_ReceiveData(void)
 600                     ; 68 {
 601                     	switch	.text
 602  005e               _SPI_ReceiveData:
 606                     ; 69   return ((uint8_t)SPI->DR); /* Return the data in the DR register*/
 608  005e c65204        	ld	a,20996
 611  0061 81            	ret
 732                     ; 72 FlagStatus SPI_GetFlagStatus(SPI_Flag_TypeDef SPI_FLAG)
 732                     ; 73 {
 733                     	switch	.text
 734  0062               _SPI_GetFlagStatus:
 736  0062 88            	push	a
 737       00000001      OFST:	set	1
 740                     ; 74   FlagStatus status = RESET;
 742                     ; 76   assert_param(IS_SPI_FLAGS_OK(SPI_FLAG));
 744                     ; 79   if ((SPI->SR & (uint8_t)SPI_FLAG) != (uint8_t)RESET)
 746  0063 c45203        	and	a,20995
 747  0066 2706          	jreq	L343
 748                     ; 81     status = SET; /* SPI_FLAG is set */
 750  0068 a601          	ld	a,#1
 751  006a 6b01          	ld	(OFST+0,sp),a
 754  006c 2002          	jra	L543
 755  006e               L343:
 756                     ; 85     status = RESET; /* SPI_FLAG is reset*/
 758  006e 0f01          	clr	(OFST+0,sp)
 760  0070               L543:
 761                     ; 89   return status;
 763  0070 7b01          	ld	a,(OFST+0,sp)
 766  0072 5b01          	addw	sp,#1
 767  0074 81            	ret
 780                     	xdef	_SPI_GetFlagStatus
 781                     	xdef	_SPI_ReceiveData
 782                     	xdef	_SPI_SendData
 783                     	xdef	_SPI_Cmd
 784                     	xdef	_SPI_Init
 785                     	xdef	_SPI_DeInit
 804                     	end
