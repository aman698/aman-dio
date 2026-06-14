   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  14                     	bsct
  15  0000               L3_sock_any_port:
  16  0000 c000          	dc.w	-16384
  17  0002               L5_sock_io_mode:
  18  0002 0000          	dc.w	0
  19  0004               L7_sock_is_sending:
  20  0004 0000          	dc.w	0
  21  0006               L11_sock_remained_size:
  22  0006 0000          	dc.w	0
  23  0008 0000          	dc.w	0
  24  000a 000000000000  	ds.b	12
  25  0016               _sock_pack_info:
  26  0016 00            	dc.b	0
  27  0017 000000000000  	ds.b	7
 112                     ; 35 int8_t socket(uint8_t sn, uint8_t protocol, uint16_t port, uint8_t flag)
 112                     ; 36 {
 114                     	switch	.text
 115  0000               _socket:
 117  0000 89            	pushw	x
 118  0001 5204          	subw	sp,#4
 119       00000004      OFST:	set	4
 122                     ; 37 	CHECK_SOCKNUM();
 124  0003 7b05          	ld	a,(OFST+1,sp)
 125  0005 a109          	cp	a,#9
 126  0007 2504          	jrult	L101
 129  0009 a6ff          	ld	a,#255
 131  000b 2010          	jra	L22
 132  000d               L101:
 133                     ; 38 	switch(protocol)
 136  000d 7b06          	ld	a,(OFST+2,sp)
 138                     ; 51       default :
 138                     ; 52          return SOCKERR_SOCKMODE;
 139  000f 4a            	dec	a
 140  0010 270e          	jreq	L31
 141  0012 4a            	dec	a
 142  0013 272e          	jreq	L501
 143  0015 4a            	dec	a
 144  0016 272b          	jreq	L501
 145  0018 4a            	dec	a
 146  0019 2728          	jreq	L501
 147  001b               L12:
 150  001b a6fb          	ld	a,#251
 152  001d               L22:
 154  001d 5b06          	addw	sp,#6
 155  001f 81            	ret
 156  0020               L31:
 157                     ; 43             getSIPR((uint8_t*)&taddr);
 159  0020 ae0004        	ldw	x,#4
 160  0023 89            	pushw	x
 161  0024 96            	ldw	x,sp
 162  0025 1c0003        	addw	x,#OFST-1
 163  0028 89            	pushw	x
 164  0029 ae0f00        	ldw	x,#3840
 165  002c 89            	pushw	x
 166  002d ae0000        	ldw	x,#0
 167  0030 89            	pushw	x
 168  0031 cd0000        	call	_WIZCHIP_READ_BUF
 170  0034 5b08          	addw	sp,#8
 171                     ; 44             if(taddr == 0) return SOCKERR_SOCKINIT;
 173  0036 96            	ldw	x,sp
 174  0037 1c0001        	addw	x,#OFST-3
 175  003a cd0000        	call	c_lzmp
 177  003d 2604          	jrne	L501
 180  003f a6fd          	ld	a,#253
 182  0041 20da          	jra	L22
 183  0043               L51:
 184                     ; 46       case Sn_MR_UDP :
 184                     ; 47       case Sn_MR_MACRAW :
 184                     ; 48          break;
 186  0043               L501:
 187                     ; 54 	if((flag & 0x04) != 0) return SOCKERR_SOCKFLAG;
 189  0043 7b0b          	ld	a,(OFST+7,sp)
 190  0045 a504          	bcp	a,#4
 191  0047 2704          	jreq	L111
 194  0049 a6fa          	ld	a,#250
 196  004b 20d0          	jra	L22
 197  004d               L111:
 198                     ; 56 	if(flag != 0)
 200  004d 0d0b          	tnz	(OFST+7,sp)
 201  004f 2734          	jreq	L311
 202                     ; 58    	switch(protocol)
 204  0051 7b06          	ld	a,(OFST+2,sp)
 206                     ; 79    	   default:
 206                     ; 80    	      break;
 207  0053 4a            	dec	a
 208  0054 2705          	jreq	L32
 209  0056 4a            	dec	a
 210  0057 270c          	jreq	L52
 211  0059 202a          	jra	L311
 212  005b               L32:
 213                     ; 60    	   case Sn_MR_TCP:
 213                     ; 61    		  //M20150601 :  For SF_TCP_ALIGN & W5300
 213                     ; 62           #if _WIZCHIP_ == 5500
 213                     ; 63    		     if((flag & (SF_TCP_NODELAY|SF_IO_NONBLOCK))==0) return SOCKERR_SOCKFLAG;
 215  005b 7b0b          	ld	a,(OFST+7,sp)
 216  005d a521          	bcp	a,#33
 217  005f 2624          	jrne	L311
 220  0061 a6fa          	ld	a,#250
 222  0063 20b8          	jra	L22
 223  0065               L52:
 224                     ; 67    	   case Sn_MR_UDP:
 224                     ; 68    	      if(flag & SF_IGMP_VER2)
 226  0065 7b0b          	ld	a,(OFST+7,sp)
 227  0067 a520          	bcp	a,#32
 228  0069 270a          	jreq	L321
 229                     ; 70    	         if((flag & SF_MULTI_ENABLE)==0) return SOCKERR_SOCKFLAG;
 231  006b 7b0b          	ld	a,(OFST+7,sp)
 232  006d a580          	bcp	a,#128
 233  006f 2604          	jrne	L321
 236  0071 a6fa          	ld	a,#250
 238  0073 20a8          	jra	L22
 239  0075               L321:
 240                     ; 73       	      if(flag & SF_UNI_BLOCK)
 242  0075 7b0b          	ld	a,(OFST+7,sp)
 243  0077 a510          	bcp	a,#16
 244  0079 270a          	jreq	L311
 245                     ; 75       	         if((flag & SF_MULTI_ENABLE) == 0) return SOCKERR_SOCKFLAG;
 247  007b 7b0b          	ld	a,(OFST+7,sp)
 248  007d a580          	bcp	a,#128
 249  007f 2604          	jrne	L311
 252  0081 a6fa          	ld	a,#250
 254  0083 2098          	jra	L22
 255  0085               L72:
 256                     ; 79    	   default:
 256                     ; 80    	      break;
 258  0085               L711:
 259  0085               L311:
 260                     ; 83 	close(sn);
 262  0085 7b05          	ld	a,(OFST+1,sp)
 263  0087 cd01b0        	call	_close
 265                     ; 86 	   setSn_MR(sn, (protocol | (flag & 0xF0)));
 267  008a 7b0b          	ld	a,(OFST+7,sp)
 268  008c a4f0          	and	a,#240
 269  008e 1a06          	or	a,(OFST+2,sp)
 270  0090 88            	push	a
 271  0091 7b06          	ld	a,(OFST+2,sp)
 272  0093 97            	ld	xl,a
 273  0094 a604          	ld	a,#4
 274  0096 42            	mul	x,a
 275  0097 58            	sllw	x
 276  0098 58            	sllw	x
 277  0099 58            	sllw	x
 278  009a 1c0008        	addw	x,#8
 279  009d cd0000        	call	c_itolx
 281  00a0 be02          	ldw	x,c_lreg+2
 282  00a2 89            	pushw	x
 283  00a3 be00          	ldw	x,c_lreg
 284  00a5 89            	pushw	x
 285  00a6 cd0000        	call	_WIZCHIP_WRITE
 287  00a9 5b05          	addw	sp,#5
 288                     ; 88 	if(!port)
 290  00ab 1e09          	ldw	x,(OFST+5,sp)
 291  00ad 2618          	jrne	L331
 292                     ; 90 	   port = sock_any_port++;
 294  00af be00          	ldw	x,L3_sock_any_port
 295  00b1 1c0001        	addw	x,#1
 296  00b4 bf00          	ldw	L3_sock_any_port,x
 297  00b6 1d0001        	subw	x,#1
 298  00b9 1f09          	ldw	(OFST+5,sp),x
 299                     ; 91 	   if(sock_any_port == 0xFFF0) sock_any_port = SOCK_ANY_PORT_NUM;
 301  00bb be00          	ldw	x,L3_sock_any_port
 302  00bd a3fff0        	cpw	x,#65520
 303  00c0 2605          	jrne	L331
 306  00c2 aec000        	ldw	x,#49152
 307  00c5 bf00          	ldw	L3_sock_any_port,x
 308  00c7               L331:
 309                     ; 93    setSn_PORT(sn,port);	
 311  00c7 7b09          	ld	a,(OFST+5,sp)
 312  00c9 88            	push	a
 313  00ca 7b06          	ld	a,(OFST+2,sp)
 314  00cc 97            	ld	xl,a
 315  00cd a604          	ld	a,#4
 316  00cf 42            	mul	x,a
 317  00d0 58            	sllw	x
 318  00d1 58            	sllw	x
 319  00d2 58            	sllw	x
 320  00d3 1c0408        	addw	x,#1032
 321  00d6 cd0000        	call	c_itolx
 323  00d9 be02          	ldw	x,c_lreg+2
 324  00db 89            	pushw	x
 325  00dc be00          	ldw	x,c_lreg
 326  00de 89            	pushw	x
 327  00df cd0000        	call	_WIZCHIP_WRITE
 329  00e2 5b05          	addw	sp,#5
 332  00e4 7b0a          	ld	a,(OFST+6,sp)
 333  00e6 88            	push	a
 334  00e7 7b06          	ld	a,(OFST+2,sp)
 335  00e9 97            	ld	xl,a
 336  00ea a604          	ld	a,#4
 337  00ec 42            	mul	x,a
 338  00ed 58            	sllw	x
 339  00ee 58            	sllw	x
 340  00ef 58            	sllw	x
 341  00f0 1c0508        	addw	x,#1288
 342  00f3 cd0000        	call	c_itolx
 344  00f6 be02          	ldw	x,c_lreg+2
 345  00f8 89            	pushw	x
 346  00f9 be00          	ldw	x,c_lreg
 347  00fb 89            	pushw	x
 348  00fc cd0000        	call	_WIZCHIP_WRITE
 350  00ff 5b05          	addw	sp,#5
 351                     ; 94    setSn_CR(sn,Sn_CR_OPEN);
 354  0101 4b01          	push	#1
 355  0103 7b06          	ld	a,(OFST+2,sp)
 356  0105 97            	ld	xl,a
 357  0106 a604          	ld	a,#4
 358  0108 42            	mul	x,a
 359  0109 58            	sllw	x
 360  010a 58            	sllw	x
 361  010b 58            	sllw	x
 362  010c 1c0108        	addw	x,#264
 363  010f cd0000        	call	c_itolx
 365  0112 be02          	ldw	x,c_lreg+2
 366  0114 89            	pushw	x
 367  0115 be00          	ldw	x,c_lreg
 368  0117 89            	pushw	x
 369  0118 cd0000        	call	_WIZCHIP_WRITE
 371  011b 5b05          	addw	sp,#5
 373  011d               L141:
 374                     ; 95    while(getSn_CR(sn));
 376  011d 7b05          	ld	a,(OFST+1,sp)
 377  011f 97            	ld	xl,a
 378  0120 a604          	ld	a,#4
 379  0122 42            	mul	x,a
 380  0123 58            	sllw	x
 381  0124 58            	sllw	x
 382  0125 58            	sllw	x
 383  0126 1c0108        	addw	x,#264
 384  0129 cd0000        	call	c_itolx
 386  012c be02          	ldw	x,c_lreg+2
 387  012e 89            	pushw	x
 388  012f be00          	ldw	x,c_lreg
 389  0131 89            	pushw	x
 390  0132 cd0000        	call	_WIZCHIP_READ
 392  0135 5b04          	addw	sp,#4
 393  0137 4d            	tnz	a
 394  0138 26e3          	jrne	L141
 395                     ; 96    sock_io_mode &= ~(1 <<sn);
 397  013a ae0001        	ldw	x,#1
 398  013d 7b05          	ld	a,(OFST+1,sp)
 399  013f 4d            	tnz	a
 400  0140 2704          	jreq	L6
 401  0142               L01:
 402  0142 58            	sllw	x
 403  0143 4a            	dec	a
 404  0144 26fc          	jrne	L01
 405  0146               L6:
 406  0146 53            	cplw	x
 407  0147 01            	rrwa	x,a
 408  0148 b403          	and	a,L5_sock_io_mode+1
 409  014a 01            	rrwa	x,a
 410  014b b402          	and	a,L5_sock_io_mode
 411  014d 01            	rrwa	x,a
 412  014e bf02          	ldw	L5_sock_io_mode,x
 413                     ; 97 	sock_io_mode |= ((flag & SF_IO_NONBLOCK) << sn);   
 415  0150 7b0b          	ld	a,(OFST+7,sp)
 416  0152 a401          	and	a,#1
 417  0154 5f            	clrw	x
 418  0155 97            	ld	xl,a
 419  0156 7b05          	ld	a,(OFST+1,sp)
 420  0158 4d            	tnz	a
 421  0159 2704          	jreq	L21
 422  015b               L41:
 423  015b 58            	sllw	x
 424  015c 4a            	dec	a
 425  015d 26fc          	jrne	L41
 426  015f               L21:
 427  015f 01            	rrwa	x,a
 428  0160 ba03          	or	a,L5_sock_io_mode+1
 429  0162 01            	rrwa	x,a
 430  0163 ba02          	or	a,L5_sock_io_mode
 431  0165 01            	rrwa	x,a
 432  0166 bf02          	ldw	L5_sock_io_mode,x
 433                     ; 98    sock_is_sending &= ~(1<<sn);
 435  0168 ae0001        	ldw	x,#1
 436  016b 7b05          	ld	a,(OFST+1,sp)
 437  016d 4d            	tnz	a
 438  016e 2704          	jreq	L61
 439  0170               L02:
 440  0170 58            	sllw	x
 441  0171 4a            	dec	a
 442  0172 26fc          	jrne	L02
 443  0174               L61:
 444  0174 53            	cplw	x
 445  0175 01            	rrwa	x,a
 446  0176 b405          	and	a,L7_sock_is_sending+1
 447  0178 01            	rrwa	x,a
 448  0179 b404          	and	a,L7_sock_is_sending
 449  017b 01            	rrwa	x,a
 450  017c bf04          	ldw	L7_sock_is_sending,x
 451                     ; 99    sock_remained_size[sn] = 0;
 453  017e 7b05          	ld	a,(OFST+1,sp)
 454  0180 5f            	clrw	x
 455  0181 97            	ld	xl,a
 456  0182 58            	sllw	x
 457  0183 905f          	clrw	y
 458  0185 ef06          	ldw	(L11_sock_remained_size,x),y
 459                     ; 100    sock_pack_info[sn] = PACK_COMPLETED;
 461  0187 7b05          	ld	a,(OFST+1,sp)
 462  0189 5f            	clrw	x
 463  018a 97            	ld	xl,a
 464  018b 6f16          	clr	(_sock_pack_info,x)
 466  018d               L151:
 467                     ; 101    while(getSn_SR(sn) == SOCK_CLOSED);
 469  018d 7b05          	ld	a,(OFST+1,sp)
 470  018f 97            	ld	xl,a
 471  0190 a604          	ld	a,#4
 472  0192 42            	mul	x,a
 473  0193 58            	sllw	x
 474  0194 58            	sllw	x
 475  0195 58            	sllw	x
 476  0196 1c0308        	addw	x,#776
 477  0199 cd0000        	call	c_itolx
 479  019c be02          	ldw	x,c_lreg+2
 480  019e 89            	pushw	x
 481  019f be00          	ldw	x,c_lreg
 482  01a1 89            	pushw	x
 483  01a2 cd0000        	call	_WIZCHIP_READ
 485  01a5 5b04          	addw	sp,#4
 486  01a7 4d            	tnz	a
 487  01a8 27e3          	jreq	L151
 488                     ; 102    return (int8_t)sn;
 490  01aa 7b05          	ld	a,(OFST+1,sp)
 492  01ac ac1d001d      	jpf	L22
 532                     ; 105 int8_t close(uint8_t sn)
 532                     ; 106 {
 533                     	switch	.text
 534  01b0               _close:
 536  01b0 88            	push	a
 537       00000000      OFST:	set	0
 540                     ; 107 	CHECK_SOCKNUM();
 542  01b1 7b01          	ld	a,(OFST+1,sp)
 543  01b3 a109          	cp	a,#9
 544  01b5 2505          	jrult	L771
 547  01b7 a6ff          	ld	a,#255
 550  01b9 5b01          	addw	sp,#1
 551  01bb 81            	ret
 552  01bc               L771:
 553                     ; 108 	setSn_CR(sn,Sn_CR_CLOSE);
 556  01bc 4b10          	push	#16
 557  01be 7b02          	ld	a,(OFST+2,sp)
 558  01c0 97            	ld	xl,a
 559  01c1 a604          	ld	a,#4
 560  01c3 42            	mul	x,a
 561  01c4 58            	sllw	x
 562  01c5 58            	sllw	x
 563  01c6 58            	sllw	x
 564  01c7 1c0108        	addw	x,#264
 565  01ca cd0000        	call	c_itolx
 567  01cd be02          	ldw	x,c_lreg+2
 568  01cf 89            	pushw	x
 569  01d0 be00          	ldw	x,c_lreg
 570  01d2 89            	pushw	x
 571  01d3 cd0000        	call	_WIZCHIP_WRITE
 573  01d6 5b05          	addw	sp,#5
 575  01d8               L302:
 576                     ; 109 	while( getSn_CR(sn) );
 578  01d8 7b01          	ld	a,(OFST+1,sp)
 579  01da 97            	ld	xl,a
 580  01db a604          	ld	a,#4
 581  01dd 42            	mul	x,a
 582  01de 58            	sllw	x
 583  01df 58            	sllw	x
 584  01e0 58            	sllw	x
 585  01e1 1c0108        	addw	x,#264
 586  01e4 cd0000        	call	c_itolx
 588  01e7 be02          	ldw	x,c_lreg+2
 589  01e9 89            	pushw	x
 590  01ea be00          	ldw	x,c_lreg
 591  01ec 89            	pushw	x
 592  01ed cd0000        	call	_WIZCHIP_READ
 594  01f0 5b04          	addw	sp,#4
 595  01f2 4d            	tnz	a
 596  01f3 26e3          	jrne	L302
 597                     ; 110 	setSn_IR(sn, 0xFF);
 599  01f5 4b1f          	push	#31
 600  01f7 7b02          	ld	a,(OFST+2,sp)
 601  01f9 97            	ld	xl,a
 602  01fa a604          	ld	a,#4
 603  01fc 42            	mul	x,a
 604  01fd 58            	sllw	x
 605  01fe 58            	sllw	x
 606  01ff 58            	sllw	x
 607  0200 1c0208        	addw	x,#520
 608  0203 cd0000        	call	c_itolx
 610  0206 be02          	ldw	x,c_lreg+2
 611  0208 89            	pushw	x
 612  0209 be00          	ldw	x,c_lreg
 613  020b 89            	pushw	x
 614  020c cd0000        	call	_WIZCHIP_WRITE
 616  020f 5b05          	addw	sp,#5
 617                     ; 111 	sock_io_mode &= ~(1<<sn);
 619  0211 ae0001        	ldw	x,#1
 620  0214 7b01          	ld	a,(OFST+1,sp)
 621  0216 4d            	tnz	a
 622  0217 2704          	jreq	L62
 623  0219               L03:
 624  0219 58            	sllw	x
 625  021a 4a            	dec	a
 626  021b 26fc          	jrne	L03
 627  021d               L62:
 628  021d 53            	cplw	x
 629  021e 01            	rrwa	x,a
 630  021f b403          	and	a,L5_sock_io_mode+1
 631  0221 01            	rrwa	x,a
 632  0222 b402          	and	a,L5_sock_io_mode
 633  0224 01            	rrwa	x,a
 634  0225 bf02          	ldw	L5_sock_io_mode,x
 635                     ; 112 	sock_is_sending &= ~(1<<sn);
 637  0227 ae0001        	ldw	x,#1
 638  022a 7b01          	ld	a,(OFST+1,sp)
 639  022c 4d            	tnz	a
 640  022d 2704          	jreq	L23
 641  022f               L43:
 642  022f 58            	sllw	x
 643  0230 4a            	dec	a
 644  0231 26fc          	jrne	L43
 645  0233               L23:
 646  0233 53            	cplw	x
 647  0234 01            	rrwa	x,a
 648  0235 b405          	and	a,L7_sock_is_sending+1
 649  0237 01            	rrwa	x,a
 650  0238 b404          	and	a,L7_sock_is_sending
 651  023a 01            	rrwa	x,a
 652  023b bf04          	ldw	L7_sock_is_sending,x
 653                     ; 113 	sock_remained_size[sn] = 0;
 655  023d 7b01          	ld	a,(OFST+1,sp)
 656  023f 5f            	clrw	x
 657  0240 97            	ld	xl,a
 658  0241 58            	sllw	x
 659  0242 905f          	clrw	y
 660  0244 ef06          	ldw	(L11_sock_remained_size,x),y
 661                     ; 114 	sock_pack_info[sn] = 0;
 663  0246 7b01          	ld	a,(OFST+1,sp)
 664  0248 5f            	clrw	x
 665  0249 97            	ld	xl,a
 666  024a 6f16          	clr	(_sock_pack_info,x)
 668  024c               L312:
 669                     ; 115 	while(getSn_SR(sn) != SOCK_CLOSED);
 671  024c 7b01          	ld	a,(OFST+1,sp)
 672  024e 97            	ld	xl,a
 673  024f a604          	ld	a,#4
 674  0251 42            	mul	x,a
 675  0252 58            	sllw	x
 676  0253 58            	sllw	x
 677  0254 58            	sllw	x
 678  0255 1c0308        	addw	x,#776
 679  0258 cd0000        	call	c_itolx
 681  025b be02          	ldw	x,c_lreg+2
 682  025d 89            	pushw	x
 683  025e be00          	ldw	x,c_lreg
 684  0260 89            	pushw	x
 685  0261 cd0000        	call	_WIZCHIP_READ
 687  0264 5b04          	addw	sp,#4
 688  0266 4d            	tnz	a
 689  0267 26e3          	jrne	L312
 690                     ; 116 	return SOCK_OK;
 692  0269 a601          	ld	a,#1
 695  026b 5b01          	addw	sp,#1
 696  026d 81            	ret
 733                     ; 119 int8_t listen(uint8_t sn)
 733                     ; 120 {
 734                     	switch	.text
 735  026e               _listen:
 737  026e 88            	push	a
 738       00000000      OFST:	set	0
 741                     ; 121 	CHECK_SOCKNUM();
 743  026f 7b01          	ld	a,(OFST+1,sp)
 744  0271 a109          	cp	a,#9
 745  0273 2505          	jrult	L342
 748  0275 a6ff          	ld	a,#255
 751  0277 5b01          	addw	sp,#1
 752  0279 81            	ret
 753  027a               L342:
 754                     ; 122    CHECK_SOCKMODE(Sn_MR_TCP);
 756  027a 7b01          	ld	a,(OFST+1,sp)
 757  027c 97            	ld	xl,a
 758  027d a604          	ld	a,#4
 759  027f 42            	mul	x,a
 760  0280 58            	sllw	x
 761  0281 58            	sllw	x
 762  0282 58            	sllw	x
 763  0283 1c0008        	addw	x,#8
 764  0286 cd0000        	call	c_itolx
 766  0289 be02          	ldw	x,c_lreg+2
 767  028b 89            	pushw	x
 768  028c be00          	ldw	x,c_lreg
 769  028e 89            	pushw	x
 770  028f cd0000        	call	_WIZCHIP_READ
 772  0292 5b04          	addw	sp,#4
 773  0294 a40f          	and	a,#15
 774  0296 a101          	cp	a,#1
 775  0298 2705          	jreq	L152
 778  029a a6fb          	ld	a,#251
 781  029c 5b01          	addw	sp,#1
 782  029e 81            	ret
 783  029f               L152:
 784                     ; 123 	CHECK_SOCKINIT();
 786  029f 7b01          	ld	a,(OFST+1,sp)
 787  02a1 97            	ld	xl,a
 788  02a2 a604          	ld	a,#4
 789  02a4 42            	mul	x,a
 790  02a5 58            	sllw	x
 791  02a6 58            	sllw	x
 792  02a7 58            	sllw	x
 793  02a8 1c0308        	addw	x,#776
 794  02ab cd0000        	call	c_itolx
 796  02ae be02          	ldw	x,c_lreg+2
 797  02b0 89            	pushw	x
 798  02b1 be00          	ldw	x,c_lreg
 799  02b3 89            	pushw	x
 800  02b4 cd0000        	call	_WIZCHIP_READ
 802  02b7 5b04          	addw	sp,#4
 803  02b9 a113          	cp	a,#19
 804  02bb 2705          	jreq	L552
 807  02bd a6fd          	ld	a,#253
 810  02bf 5b01          	addw	sp,#1
 811  02c1 81            	ret
 812  02c2               L552:
 813                     ; 124 	setSn_CR(sn,Sn_CR_LISTEN);
 816  02c2 4b02          	push	#2
 817  02c4 7b02          	ld	a,(OFST+2,sp)
 818  02c6 97            	ld	xl,a
 819  02c7 a604          	ld	a,#4
 820  02c9 42            	mul	x,a
 821  02ca 58            	sllw	x
 822  02cb 58            	sllw	x
 823  02cc 58            	sllw	x
 824  02cd 1c0108        	addw	x,#264
 825  02d0 cd0000        	call	c_itolx
 827  02d3 be02          	ldw	x,c_lreg+2
 828  02d5 89            	pushw	x
 829  02d6 be00          	ldw	x,c_lreg
 830  02d8 89            	pushw	x
 831  02d9 cd0000        	call	_WIZCHIP_WRITE
 833  02dc 5b05          	addw	sp,#5
 835  02de               L162:
 836                     ; 125 	while(getSn_CR(sn));
 838  02de 7b01          	ld	a,(OFST+1,sp)
 839  02e0 97            	ld	xl,a
 840  02e1 a604          	ld	a,#4
 841  02e3 42            	mul	x,a
 842  02e4 58            	sllw	x
 843  02e5 58            	sllw	x
 844  02e6 58            	sllw	x
 845  02e7 1c0108        	addw	x,#264
 846  02ea cd0000        	call	c_itolx
 848  02ed be02          	ldw	x,c_lreg+2
 849  02ef 89            	pushw	x
 850  02f0 be00          	ldw	x,c_lreg
 851  02f2 89            	pushw	x
 852  02f3 cd0000        	call	_WIZCHIP_READ
 854  02f6 5b04          	addw	sp,#4
 855  02f8 4d            	tnz	a
 856  02f9 26e3          	jrne	L162
 858  02fb 200a          	jra	L762
 859  02fd               L562:
 860                     ; 128          close(sn);
 862  02fd 7b01          	ld	a,(OFST+1,sp)
 863  02ff cd01b0        	call	_close
 865                     ; 129          return SOCKERR_SOCKCLOSED;
 867  0302 a6fc          	ld	a,#252
 870  0304 5b01          	addw	sp,#1
 871  0306 81            	ret
 872  0307               L762:
 873                     ; 126    while(getSn_SR(sn) != SOCK_LISTEN)
 875  0307 7b01          	ld	a,(OFST+1,sp)
 876  0309 97            	ld	xl,a
 877  030a a604          	ld	a,#4
 878  030c 42            	mul	x,a
 879  030d 58            	sllw	x
 880  030e 58            	sllw	x
 881  030f 58            	sllw	x
 882  0310 1c0308        	addw	x,#776
 883  0313 cd0000        	call	c_itolx
 885  0316 be02          	ldw	x,c_lreg+2
 886  0318 89            	pushw	x
 887  0319 be00          	ldw	x,c_lreg
 888  031b 89            	pushw	x
 889  031c cd0000        	call	_WIZCHIP_READ
 891  031f 5b04          	addw	sp,#4
 892  0321 a114          	cp	a,#20
 893  0323 26d8          	jrne	L562
 894                     ; 131    return SOCK_OK;
 896  0325 a601          	ld	a,#1
 899  0327 5b01          	addw	sp,#1
 900  0329 81            	ret
 962                     	xdef	_sock_pack_info
 963                     	xdef	_listen
 964                     	xdef	_close
 965                     	xdef	_socket
 966                     	xref	_WIZCHIP_READ_BUF
 967                     	xref	_WIZCHIP_WRITE
 968                     	xref	_WIZCHIP_READ
 969                     	xref.b	c_lreg
 988                     	xref	c_itolx
 989                     	xref	c_lzmp
 990                     	end
