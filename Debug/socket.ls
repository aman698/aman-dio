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
 774                     ; 118 int32_t recv(uint8_t sn, uint8_t * buf, uint16_t len)
 774                     ; 119 {
 775                     	switch	.text
 776  026e               _recv:
 778  026e 88            	push	a
 779  026f 5205          	subw	sp,#5
 780       00000005      OFST:	set	5
 783                     ; 120    uint8_t  tmp = 0;
 785                     ; 121    uint16_t recvsize = 0;
 787                     ; 128    CHECK_SOCKNUM();
 789  0271 7b06          	ld	a,(OFST+1,sp)
 790  0273 a109          	cp	a,#9
 791  0275 250c          	jrult	L362
 794  0277 aeffff        	ldw	x,#65535
 795  027a bf02          	ldw	c_lreg+2,x
 796  027c aeffff        	ldw	x,#-1
 797  027f bf00          	ldw	c_lreg,x
 799  0281 202a          	jra	L44
 800  0283               L362:
 801                     ; 129    CHECK_SOCKMODE(Sn_MR_TCP);
 803  0283 7b06          	ld	a,(OFST+1,sp)
 804  0285 97            	ld	xl,a
 805  0286 a604          	ld	a,#4
 806  0288 42            	mul	x,a
 807  0289 58            	sllw	x
 808  028a 58            	sllw	x
 809  028b 58            	sllw	x
 810  028c 1c0008        	addw	x,#8
 811  028f cd0000        	call	c_itolx
 813  0292 be02          	ldw	x,c_lreg+2
 814  0294 89            	pushw	x
 815  0295 be00          	ldw	x,c_lreg
 816  0297 89            	pushw	x
 817  0298 cd0000        	call	_WIZCHIP_READ
 819  029b 5b04          	addw	sp,#4
 820  029d a40f          	and	a,#15
 821  029f a101          	cp	a,#1
 822  02a1 270d          	jreq	L172
 825  02a3 aefffb        	ldw	x,#65531
 826  02a6 bf02          	ldw	c_lreg+2,x
 827  02a8 aeffff        	ldw	x,#-1
 828  02ab bf00          	ldw	c_lreg,x
 830  02ad               L44:
 832  02ad 5b06          	addw	sp,#6
 833  02af 81            	ret
 834  02b0               L172:
 835                     ; 130    CHECK_SOCKDATA();
 837  02b0 1e0b          	ldw	x,(OFST+6,sp)
 838  02b2 260c          	jrne	L572
 841  02b4 aefff2        	ldw	x,#65522
 842  02b7 bf02          	ldw	c_lreg+2,x
 843  02b9 aeffff        	ldw	x,#-1
 844  02bc bf00          	ldw	c_lreg,x
 846  02be 20ed          	jra	L44
 847  02c0               L572:
 848                     ; 132    recvsize = getSn_RxMAX(sn);
 851  02c0 7b06          	ld	a,(OFST+1,sp)
 852  02c2 97            	ld	xl,a
 853  02c3 a604          	ld	a,#4
 854  02c5 42            	mul	x,a
 855  02c6 58            	sllw	x
 856  02c7 58            	sllw	x
 857  02c8 58            	sllw	x
 858  02c9 1c1e08        	addw	x,#7688
 859  02cc cd0000        	call	c_itolx
 861  02cf be02          	ldw	x,c_lreg+2
 862  02d1 89            	pushw	x
 863  02d2 be00          	ldw	x,c_lreg
 864  02d4 89            	pushw	x
 865  02d5 cd0000        	call	_WIZCHIP_READ
 867  02d8 5b04          	addw	sp,#4
 868  02da 5f            	clrw	x
 869  02db 97            	ld	xl,a
 870  02dc 4f            	clr	a
 871  02dd 02            	rlwa	x,a
 872  02de 58            	sllw	x
 873  02df 58            	sllw	x
 874  02e0 1f04          	ldw	(OFST-1,sp),x
 876                     ; 133    if(recvsize < len) len = recvsize;
 878  02e2 1e04          	ldw	x,(OFST-1,sp)
 879  02e4 130b          	cpw	x,(OFST+6,sp)
 880  02e6 2404          	jruge	L103
 883  02e8 1e04          	ldw	x,(OFST-1,sp)
 884  02ea 1f0b          	ldw	(OFST+6,sp),x
 885  02ec               L103:
 886                     ; 144          recvsize = getSn_RX_RSR(sn);
 888  02ec 7b06          	ld	a,(OFST+1,sp)
 889  02ee cd0000        	call	_getSn_RX_RSR
 891  02f1 1f04          	ldw	(OFST-1,sp),x
 893                     ; 145          tmp = getSn_SR(sn);
 895  02f3 7b06          	ld	a,(OFST+1,sp)
 896  02f5 97            	ld	xl,a
 897  02f6 a604          	ld	a,#4
 898  02f8 42            	mul	x,a
 899  02f9 58            	sllw	x
 900  02fa 58            	sllw	x
 901  02fb 58            	sllw	x
 902  02fc 1c0308        	addw	x,#776
 903  02ff cd0000        	call	c_itolx
 905  0302 be02          	ldw	x,c_lreg+2
 906  0304 89            	pushw	x
 907  0305 be00          	ldw	x,c_lreg
 908  0307 89            	pushw	x
 909  0308 cd0000        	call	_WIZCHIP_READ
 911  030b 5b04          	addw	sp,#4
 912  030d 6b03          	ld	(OFST-2,sp),a
 914                     ; 146          if (tmp != SOCK_ESTABLISHED)
 916  030f 7b03          	ld	a,(OFST-2,sp)
 917  0311 a117          	cp	a,#23
 918  0313 275e          	jreq	L503
 919                     ; 148             if(tmp == SOCK_CLOSE_WAIT)
 921  0315 7b03          	ld	a,(OFST-2,sp)
 922  0317 a11c          	cp	a,#28
 923  0319 2645          	jrne	L703
 924                     ; 150                if(recvsize != 0) break;
 926  031b 1e04          	ldw	x,(OFST-1,sp)
 927  031d 2703          	jreq	L64
 928  031f cc03a4        	jp	L303
 929  0322               L64:
 932                     ; 151                else if(getSn_TX_FSR(sn) == getSn_TxMAX(sn))
 934  0322 7b06          	ld	a,(OFST+1,sp)
 935  0324 97            	ld	xl,a
 936  0325 a604          	ld	a,#4
 937  0327 42            	mul	x,a
 938  0328 58            	sllw	x
 939  0329 58            	sllw	x
 940  032a 58            	sllw	x
 941  032b 1c1f08        	addw	x,#7944
 942  032e cd0000        	call	c_itolx
 944  0331 be02          	ldw	x,c_lreg+2
 945  0333 89            	pushw	x
 946  0334 be00          	ldw	x,c_lreg
 947  0336 89            	pushw	x
 948  0337 cd0000        	call	_WIZCHIP_READ
 950  033a 5b04          	addw	sp,#4
 951  033c 5f            	clrw	x
 952  033d 97            	ld	xl,a
 953  033e 4f            	clr	a
 954  033f 02            	rlwa	x,a
 955  0340 58            	sllw	x
 956  0341 58            	sllw	x
 957  0342 1f01          	ldw	(OFST-4,sp),x
 959  0344 7b06          	ld	a,(OFST+1,sp)
 960  0346 cd0000        	call	_getSn_TX_FSR
 962  0349 1301          	cpw	x,(OFST-4,sp)
 963  034b 2626          	jrne	L503
 964                     ; 153                   close(sn);
 966  034d 7b06          	ld	a,(OFST+1,sp)
 967  034f cd01b0        	call	_close
 969                     ; 154                   return SOCKERR_SOCKSTATUS;
 971  0352 aefff9        	ldw	x,#65529
 972  0355 bf02          	ldw	c_lreg+2,x
 973  0357 aeffff        	ldw	x,#-1
 974  035a bf00          	ldw	c_lreg,x
 976  035c acad02ad      	jpf	L44
 977  0360               L703:
 978                     ; 159                close(sn);
 980  0360 7b06          	ld	a,(OFST+1,sp)
 981  0362 cd01b0        	call	_close
 983                     ; 160                return SOCKERR_SOCKSTATUS;
 985  0365 aefff9        	ldw	x,#65529
 986  0368 bf02          	ldw	c_lreg+2,x
 987  036a aeffff        	ldw	x,#-1
 988  036d bf00          	ldw	c_lreg,x
 990  036f acad02ad      	jpf	L44
 991  0373               L503:
 992                     ; 163          if((sock_io_mode & (1<<sn)) && (recvsize == 0)) return SOCK_BUSY;
 994  0373 ae0001        	ldw	x,#1
 995  0376 7b06          	ld	a,(OFST+1,sp)
 996  0378 4d            	tnz	a
 997  0379 2704          	jreq	L04
 998  037b               L24:
 999  037b 58            	sllw	x
1000  037c 4a            	dec	a
1001  037d 26fc          	jrne	L24
1002  037f               L04:
1003  037f 01            	rrwa	x,a
1004  0380 b403          	and	a,L5_sock_io_mode+1
1005  0382 01            	rrwa	x,a
1006  0383 b402          	and	a,L5_sock_io_mode
1007  0385 01            	rrwa	x,a
1008  0386 a30000        	cpw	x,#0
1009  0389 2712          	jreq	L123
1011  038b 1e04          	ldw	x,(OFST-1,sp)
1012  038d 260e          	jrne	L123
1015  038f ae0000        	ldw	x,#0
1016  0392 bf02          	ldw	c_lreg+2,x
1017  0394 ae0000        	ldw	x,#0
1018  0397 bf00          	ldw	c_lreg,x
1020  0399 acad02ad      	jpf	L44
1021  039d               L123:
1022                     ; 164          if(recvsize != 0) break;
1024  039d 1e04          	ldw	x,(OFST-1,sp)
1025  039f 2603          	jrne	L05
1026  03a1 cc02ec        	jp	L103
1027  03a4               L05:
1029  03a4               L303:
1030                     ; 166    if(recvsize < len) len = recvsize;   
1033  03a4 1e04          	ldw	x,(OFST-1,sp)
1034  03a6 130b          	cpw	x,(OFST+6,sp)
1035  03a8 2404          	jruge	L523
1038  03aa 1e04          	ldw	x,(OFST-1,sp)
1039  03ac 1f0b          	ldw	(OFST+6,sp),x
1040  03ae               L523:
1041                     ; 167    wiz_recv_data(sn, buf, len);
1043  03ae 1e0b          	ldw	x,(OFST+6,sp)
1044  03b0 89            	pushw	x
1045  03b1 1e0b          	ldw	x,(OFST+6,sp)
1046  03b3 89            	pushw	x
1047  03b4 7b0a          	ld	a,(OFST+5,sp)
1048  03b6 cd0000        	call	_wiz_recv_data
1050  03b9 5b04          	addw	sp,#4
1051                     ; 168    setSn_CR(sn,Sn_CR_RECV);
1053  03bb 4b40          	push	#64
1054  03bd 7b07          	ld	a,(OFST+2,sp)
1055  03bf 97            	ld	xl,a
1056  03c0 a604          	ld	a,#4
1057  03c2 42            	mul	x,a
1058  03c3 58            	sllw	x
1059  03c4 58            	sllw	x
1060  03c5 58            	sllw	x
1061  03c6 1c0108        	addw	x,#264
1062  03c9 cd0000        	call	c_itolx
1064  03cc be02          	ldw	x,c_lreg+2
1065  03ce 89            	pushw	x
1066  03cf be00          	ldw	x,c_lreg
1067  03d1 89            	pushw	x
1068  03d2 cd0000        	call	_WIZCHIP_WRITE
1070  03d5 5b05          	addw	sp,#5
1072  03d7               L133:
1073                     ; 169    while(getSn_CR(sn));
1075  03d7 7b06          	ld	a,(OFST+1,sp)
1076  03d9 97            	ld	xl,a
1077  03da a604          	ld	a,#4
1078  03dc 42            	mul	x,a
1079  03dd 58            	sllw	x
1080  03de 58            	sllw	x
1081  03df 58            	sllw	x
1082  03e0 1c0108        	addw	x,#264
1083  03e3 cd0000        	call	c_itolx
1085  03e6 be02          	ldw	x,c_lreg+2
1086  03e8 89            	pushw	x
1087  03e9 be00          	ldw	x,c_lreg
1088  03eb 89            	pushw	x
1089  03ec cd0000        	call	_WIZCHIP_READ
1091  03ef 5b04          	addw	sp,#4
1092  03f1 4d            	tnz	a
1093  03f2 26e3          	jrne	L133
1094                     ; 173    return (int32_t)len;
1096  03f4 1e0b          	ldw	x,(OFST+6,sp)
1097  03f6 cd0000        	call	c_uitolx
1100  03f9 acad02ad      	jpf	L44
1137                     ; 175 int8_t listen(uint8_t sn)
1137                     ; 176 {
1138                     	switch	.text
1139  03fd               _listen:
1141  03fd 88            	push	a
1142       00000000      OFST:	set	0
1145                     ; 177 	CHECK_SOCKNUM();
1147  03fe 7b01          	ld	a,(OFST+1,sp)
1148  0400 a109          	cp	a,#9
1149  0402 2505          	jrult	L163
1152  0404 a6ff          	ld	a,#255
1155  0406 5b01          	addw	sp,#1
1156  0408 81            	ret
1157  0409               L163:
1158                     ; 178    CHECK_SOCKMODE(Sn_MR_TCP);
1160  0409 7b01          	ld	a,(OFST+1,sp)
1161  040b 97            	ld	xl,a
1162  040c a604          	ld	a,#4
1163  040e 42            	mul	x,a
1164  040f 58            	sllw	x
1165  0410 58            	sllw	x
1166  0411 58            	sllw	x
1167  0412 1c0008        	addw	x,#8
1168  0415 cd0000        	call	c_itolx
1170  0418 be02          	ldw	x,c_lreg+2
1171  041a 89            	pushw	x
1172  041b be00          	ldw	x,c_lreg
1173  041d 89            	pushw	x
1174  041e cd0000        	call	_WIZCHIP_READ
1176  0421 5b04          	addw	sp,#4
1177  0423 a40f          	and	a,#15
1178  0425 a101          	cp	a,#1
1179  0427 2705          	jreq	L763
1182  0429 a6fb          	ld	a,#251
1185  042b 5b01          	addw	sp,#1
1186  042d 81            	ret
1187  042e               L763:
1188                     ; 179 	CHECK_SOCKINIT();
1190  042e 7b01          	ld	a,(OFST+1,sp)
1191  0430 97            	ld	xl,a
1192  0431 a604          	ld	a,#4
1193  0433 42            	mul	x,a
1194  0434 58            	sllw	x
1195  0435 58            	sllw	x
1196  0436 58            	sllw	x
1197  0437 1c0308        	addw	x,#776
1198  043a cd0000        	call	c_itolx
1200  043d be02          	ldw	x,c_lreg+2
1201  043f 89            	pushw	x
1202  0440 be00          	ldw	x,c_lreg
1203  0442 89            	pushw	x
1204  0443 cd0000        	call	_WIZCHIP_READ
1206  0446 5b04          	addw	sp,#4
1207  0448 a113          	cp	a,#19
1208  044a 2705          	jreq	L373
1211  044c a6fd          	ld	a,#253
1214  044e 5b01          	addw	sp,#1
1215  0450 81            	ret
1216  0451               L373:
1217                     ; 180 	setSn_CR(sn,Sn_CR_LISTEN);
1220  0451 4b02          	push	#2
1221  0453 7b02          	ld	a,(OFST+2,sp)
1222  0455 97            	ld	xl,a
1223  0456 a604          	ld	a,#4
1224  0458 42            	mul	x,a
1225  0459 58            	sllw	x
1226  045a 58            	sllw	x
1227  045b 58            	sllw	x
1228  045c 1c0108        	addw	x,#264
1229  045f cd0000        	call	c_itolx
1231  0462 be02          	ldw	x,c_lreg+2
1232  0464 89            	pushw	x
1233  0465 be00          	ldw	x,c_lreg
1234  0467 89            	pushw	x
1235  0468 cd0000        	call	_WIZCHIP_WRITE
1237  046b 5b05          	addw	sp,#5
1239  046d               L773:
1240                     ; 181 	while(getSn_CR(sn));
1242  046d 7b01          	ld	a,(OFST+1,sp)
1243  046f 97            	ld	xl,a
1244  0470 a604          	ld	a,#4
1245  0472 42            	mul	x,a
1246  0473 58            	sllw	x
1247  0474 58            	sllw	x
1248  0475 58            	sllw	x
1249  0476 1c0108        	addw	x,#264
1250  0479 cd0000        	call	c_itolx
1252  047c be02          	ldw	x,c_lreg+2
1253  047e 89            	pushw	x
1254  047f be00          	ldw	x,c_lreg
1255  0481 89            	pushw	x
1256  0482 cd0000        	call	_WIZCHIP_READ
1258  0485 5b04          	addw	sp,#4
1259  0487 4d            	tnz	a
1260  0488 26e3          	jrne	L773
1262  048a 200a          	jra	L504
1263  048c               L304:
1264                     ; 184          close(sn);
1266  048c 7b01          	ld	a,(OFST+1,sp)
1267  048e cd01b0        	call	_close
1269                     ; 185          return SOCKERR_SOCKCLOSED;
1271  0491 a6fc          	ld	a,#252
1274  0493 5b01          	addw	sp,#1
1275  0495 81            	ret
1276  0496               L504:
1277                     ; 182    while(getSn_SR(sn) != SOCK_LISTEN)
1279  0496 7b01          	ld	a,(OFST+1,sp)
1280  0498 97            	ld	xl,a
1281  0499 a604          	ld	a,#4
1282  049b 42            	mul	x,a
1283  049c 58            	sllw	x
1284  049d 58            	sllw	x
1285  049e 58            	sllw	x
1286  049f 1c0308        	addw	x,#776
1287  04a2 cd0000        	call	c_itolx
1289  04a5 be02          	ldw	x,c_lreg+2
1290  04a7 89            	pushw	x
1291  04a8 be00          	ldw	x,c_lreg
1292  04aa 89            	pushw	x
1293  04ab cd0000        	call	_WIZCHIP_READ
1295  04ae 5b04          	addw	sp,#4
1296  04b0 a114          	cp	a,#20
1297  04b2 26d8          	jrne	L304
1298                     ; 187    return SOCK_OK;
1300  04b4 a601          	ld	a,#1
1303  04b6 5b01          	addw	sp,#1
1304  04b8 81            	ret
1366                     	xdef	_sock_pack_info
1367                     	xdef	_recv
1368                     	xdef	_listen
1369                     	xdef	_close
1370                     	xdef	_socket
1371                     	xref	_wiz_recv_data
1372                     	xref	_getSn_RX_RSR
1373                     	xref	_getSn_TX_FSR
1374                     	xref	_WIZCHIP_READ_BUF
1375                     	xref	_WIZCHIP_WRITE
1376                     	xref	_WIZCHIP_READ
1377                     	xref.b	c_lreg
1396                     	xref	c_uitolx
1397                     	xref	c_itolx
1398                     	xref	c_lzmp
1399                     	end
