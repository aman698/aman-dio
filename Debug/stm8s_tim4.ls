   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  14                     	bsct
  15  0000               L3_sock_any_port:
  16  0000 c000          	dc.w	-16384
 156                     ; 5 void TIM4_TimeBaseInit(TIM4_Prescaler_TypeDef TIM4_Prescaler, uint8_t TIM4_Period)
 156                     ; 6 {
 158                     	switch	.text
 159  0000               _TIM4_TimeBaseInit:
 163                     ; 8     assert_param(IS_TIM4_PRESCALER_OK(TIM4_Prescaler));
 165                     ; 10     TIM4->PSCR = (uint8_t)(TIM4_Prescaler);
 167  0000 9e            	ld	a,xh
 168  0001 c75347        	ld	21319,a
 169                     ; 12     TIM4->ARR = (uint8_t)(TIM4_Period);
 171  0004 9f            	ld	a,xl
 172  0005 c75348        	ld	21320,a
 173                     ; 13 }
 176  0008 81            	ret
 231                     ; 15 void TIM4_Cmd(FunctionalState NewState)
 231                     ; 16 {
 232                     	switch	.text
 233  0009               _TIM4_Cmd:
 237                     ; 18     assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 239                     ; 21     if (NewState != DISABLE)
 241  0009 4d            	tnz	a
 242  000a 2706          	jreq	L321
 243                     ; 23         TIM4->CR1 |= TIM4_CR1_CEN;
 245  000c 72105340      	bset	21312,#0
 247  0010 2004          	jra	L521
 248  0012               L321:
 249                     ; 27         TIM4->CR1 &= (uint8_t)(~TIM4_CR1_CEN);
 251  0012 72115340      	bres	21312,#0
 252  0016               L521:
 253                     ; 29 }
 256  0016 81            	ret
 314                     ; 31 void TIM4_ITConfig(TIM4_IT_TypeDef TIM4_IT, FunctionalState NewState)
 314                     ; 32 {
 315                     	switch	.text
 316  0017               _TIM4_ITConfig:
 318  0017 89            	pushw	x
 319       00000000      OFST:	set	0
 322                     ; 34     assert_param(IS_TIM4_IT_OK(TIM4_IT));
 324                     ; 35     assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 326                     ; 37     if (NewState != DISABLE)
 328  0018 9f            	ld	a,xl
 329  0019 4d            	tnz	a
 330  001a 2709          	jreq	L751
 331                     ; 40         TIM4->IER |= (uint8_t)TIM4_IT;
 333  001c 9e            	ld	a,xh
 334  001d ca5343        	or	a,21315
 335  0020 c75343        	ld	21315,a
 337  0023 2009          	jra	L161
 338  0025               L751:
 339                     ; 45         TIM4->IER &= (uint8_t)(~TIM4_IT);
 341  0025 7b01          	ld	a,(OFST+1,sp)
 342  0027 43            	cpl	a
 343  0028 c45343        	and	a,21315
 344  002b c75343        	ld	21315,a
 345  002e               L161:
 346                     ; 47 }
 349  002e 85            	popw	x
 350  002f 81            	ret
 398                     ; 49 void TIM4_ClearFlag(TIM4_FLAG_TypeDef TIM4_FLAG)
 398                     ; 50 {
 399                     	switch	.text
 400  0030               _TIM4_ClearFlag:
 404                     ; 52     assert_param(IS_TIM4_GET_FLAG_OK(TIM4_FLAG));
 406                     ; 55     TIM4->SR1 = (uint8_t)(~TIM4_FLAG);
 408  0030 43            	cpl	a
 409  0031 c75344        	ld	21316,a
 410                     ; 57 }
 413  0034 81            	ret
 426                     	xdef	_TIM4_ClearFlag
 427                     	xdef	_TIM4_ITConfig
 428                     	xdef	_TIM4_Cmd
 429                     	xdef	_TIM4_TimeBaseInit
 448                     	end
