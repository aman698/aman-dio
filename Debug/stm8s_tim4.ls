   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
 125                     ; 5 void TIM4_TimeBaseInit(TIM4_Prescaler_TypeDef TIM4_Prescaler, uint8_t TIM4_Period)
 125                     ; 6 {
 127                     	switch	.text
 128  0000               _TIM4_TimeBaseInit:
 132                     ; 8     assert_param(IS_TIM4_PRESCALER_OK(TIM4_Prescaler));
 134                     ; 10     TIM4->PSCR = (uint8_t)(TIM4_Prescaler);
 136  0000 9e            	ld	a,xh
 137  0001 c75347        	ld	21319,a
 138                     ; 12     TIM4->ARR = (uint8_t)(TIM4_Period);
 140  0004 9f            	ld	a,xl
 141  0005 c75348        	ld	21320,a
 142                     ; 13 }
 145  0008 81            	ret
 200                     ; 15 void TIM4_Cmd(FunctionalState NewState)
 200                     ; 16 {
 201                     	switch	.text
 202  0009               _TIM4_Cmd:
 206                     ; 18     assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 208                     ; 21     if (NewState != DISABLE)
 210  0009 4d            	tnz	a
 211  000a 2706          	jreq	L501
 212                     ; 23         TIM4->CR1 |= TIM4_CR1_CEN;
 214  000c 72105340      	bset	21312,#0
 216  0010 2004          	jra	L701
 217  0012               L501:
 218                     ; 27         TIM4->CR1 &= (uint8_t)(~TIM4_CR1_CEN);
 220  0012 72115340      	bres	21312,#0
 221  0016               L701:
 222                     ; 29 }
 225  0016 81            	ret
 283                     ; 31 void TIM4_ITConfig(TIM4_IT_TypeDef TIM4_IT, FunctionalState NewState)
 283                     ; 32 {
 284                     	switch	.text
 285  0017               _TIM4_ITConfig:
 287  0017 89            	pushw	x
 288       00000000      OFST:	set	0
 291                     ; 34     assert_param(IS_TIM4_IT_OK(TIM4_IT));
 293                     ; 35     assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 295                     ; 37     if (NewState != DISABLE)
 297  0018 9f            	ld	a,xl
 298  0019 4d            	tnz	a
 299  001a 2709          	jreq	L141
 300                     ; 40         TIM4->IER |= (uint8_t)TIM4_IT;
 302  001c 9e            	ld	a,xh
 303  001d ca5343        	or	a,21315
 304  0020 c75343        	ld	21315,a
 306  0023 2009          	jra	L341
 307  0025               L141:
 308                     ; 45         TIM4->IER &= (uint8_t)(~TIM4_IT);
 310  0025 7b01          	ld	a,(OFST+1,sp)
 311  0027 43            	cpl	a
 312  0028 c45343        	and	a,21315
 313  002b c75343        	ld	21315,a
 314  002e               L341:
 315                     ; 47 }
 318  002e 85            	popw	x
 319  002f 81            	ret
 367                     ; 49 void TIM4_ClearFlag(TIM4_FLAG_TypeDef TIM4_FLAG)
 367                     ; 50 {
 368                     	switch	.text
 369  0030               _TIM4_ClearFlag:
 373                     ; 52     assert_param(IS_TIM4_GET_FLAG_OK(TIM4_FLAG));
 375                     ; 55     TIM4->SR1 = (uint8_t)(~TIM4_FLAG);
 377  0030 43            	cpl	a
 378  0031 c75344        	ld	21316,a
 379                     ; 57 }
 382  0034 81            	ret
 395                     	xdef	_TIM4_ClearFlag
 396                     	xdef	_TIM4_ITConfig
 397                     	xdef	_TIM4_Cmd
 398                     	xdef	_TIM4_TimeBaseInit
 417                     	end
