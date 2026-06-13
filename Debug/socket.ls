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
 112                     ; 50 int8_t socket(uint8_t sn, uint8_t protocol, uint16_t port, uint8_t flag)
 112                     ; 51 {
 114                     	switch	.text
 115  0000               _socket:
 117  0000 89            	pushw	x
 118  0001 5204          	subw	sp,#4
 119       00000004      OFST:	set	4
 122                     ; 52 	CHECK_SOCKNUM();
 124  0003 7b05          	ld	a,(OFST+1,sp)
 125  0005 a109          	cp	a,#9
 126  0007 2504          	jrult	L101
 129  0009 a6ff          	ld	a,#255
 131  000b 2010          	jra	L22
 132  000d               L101:
 133                     ; 53 	switch(protocol)
 136  000d 7b06          	ld	a,(OFST+2,sp)
 138                     ; 76       default :
 138                     ; 77          return SOCKERR_SOCKMODE;
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
 157                     ; 63             getSIPR((uint8_t*)&taddr);
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
 171                     ; 64             if(taddr == 0) return SOCKERR_SOCKINIT;
 173  0036 96            	ldw	x,sp
 174  0037 1c0001        	addw	x,#OFST-3
 175  003a cd0000        	call	c_lzmp
 177  003d 2604          	jrne	L501
 180  003f a6fd          	ld	a,#253
 182  0041 20da          	jra	L22
 183  0043               L51:
 184                     ; 66       case Sn_MR_UDP :
 184                     ; 67       case Sn_MR_MACRAW :
 184                     ; 68          break;
 186  0043               L501:
 187                     ; 81 	if((flag & 0x04) != 0) return SOCKERR_SOCKFLAG;
 189  0043 7b0b          	ld	a,(OFST+7,sp)
 190  0045 a504          	bcp	a,#4
 191  0047 2704          	jreq	L111
 194  0049 a6fa          	ld	a,#250
 196  004b 20d0          	jra	L22
 197  004d               L111:
 198                     ; 86 	if(flag != 0)
 200  004d 0d0b          	tnz	(OFST+7,sp)
 201  004f 2734          	jreq	L311
 202                     ; 88    	switch(protocol)
 204  0051 7b06          	ld	a,(OFST+2,sp)
 206                     ; 111    	   default:
 206                     ; 112    	      break;
 207  0053 4a            	dec	a
 208  0054 2705          	jreq	L32
 209  0056 4a            	dec	a
 210  0057 270c          	jreq	L52
 211  0059 202a          	jra	L311
 212  005b               L32:
 213                     ; 90    	   case Sn_MR_TCP:
 213                     ; 91    		  //M20150601 :  For SF_TCP_ALIGN & W5300
 213                     ; 92           #if _WIZCHIP_ == 5300
 213                     ; 93    		     if((flag & (SF_TCP_NODELAY|SF_IO_NONBLOCK|SF_TCP_ALIGN))==0) return SOCKERR_SOCKFLAG;
 213                     ; 94           #else
 213                     ; 95    		     if((flag & (SF_TCP_NODELAY|SF_IO_NONBLOCK))==0) return SOCKERR_SOCKFLAG;
 215  005b 7b0b          	ld	a,(OFST+7,sp)
 216  005d a521          	bcp	a,#33
 217  005f 2624          	jrne	L311
 220  0061 a6fa          	ld	a,#250
 222  0063 20b8          	jra	L22
 223  0065               L52:
 224                     ; 99    	   case Sn_MR_UDP:
 224                     ; 100    	      if(flag & SF_IGMP_VER2)
 226  0065 7b0b          	ld	a,(OFST+7,sp)
 227  0067 a520          	bcp	a,#32
 228  0069 270a          	jreq	L321
 229                     ; 102    	         if((flag & SF_MULTI_ENABLE)==0) return SOCKERR_SOCKFLAG;
 231  006b 7b0b          	ld	a,(OFST+7,sp)
 232  006d a580          	bcp	a,#128
 233  006f 2604          	jrne	L321
 236  0071 a6fa          	ld	a,#250
 238  0073 20a8          	jra	L22
 239  0075               L321:
 240                     ; 105       	      if(flag & SF_UNI_BLOCK)
 242  0075 7b0b          	ld	a,(OFST+7,sp)
 243  0077 a510          	bcp	a,#16
 244  0079 270a          	jreq	L311
 245                     ; 107       	         if((flag & SF_MULTI_ENABLE) == 0) return SOCKERR_SOCKFLAG;
 247  007b 7b0b          	ld	a,(OFST+7,sp)
 248  007d a580          	bcp	a,#128
 249  007f 2604          	jrne	L311
 252  0081 a6fa          	ld	a,#250
 254  0083 2098          	jra	L22
 255  0085               L72:
 256                     ; 111    	   default:
 256                     ; 112    	      break;
 258  0085               L711:
 259  0085               L311:
 260                     ; 115 	close(sn);
 262  0085 7b05          	ld	a,(OFST+1,sp)
 263  0087 cd01b0        	call	_close
 265                     ; 120 	   setSn_MR(sn, (protocol | (flag & 0xF0)));
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
 288                     ; 122 	if(!port)
 290  00ab 1e09          	ldw	x,(OFST+5,sp)
 291  00ad 2618          	jrne	L331
 292                     ; 124 	   port = sock_any_port++;
 294  00af be00          	ldw	x,L3_sock_any_port
 295  00b1 1c0001        	addw	x,#1
 296  00b4 bf00          	ldw	L3_sock_any_port,x
 297  00b6 1d0001        	subw	x,#1
 298  00b9 1f09          	ldw	(OFST+5,sp),x
 299                     ; 125 	   if(sock_any_port == 0xFFF0) sock_any_port = SOCK_ANY_PORT_NUM;
 301  00bb be00          	ldw	x,L3_sock_any_port
 302  00bd a3fff0        	cpw	x,#65520
 303  00c0 2605          	jrne	L331
 306  00c2 aec000        	ldw	x,#49152
 307  00c5 bf00          	ldw	L3_sock_any_port,x
 308  00c7               L331:
 309                     ; 127    setSn_PORT(sn,port);	
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
 351                     ; 128    setSn_CR(sn,Sn_CR_OPEN);
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
 374                     ; 129    while(getSn_CR(sn));
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
 395                     ; 131    sock_io_mode &= ~(1 <<sn);
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
 413                     ; 133 	sock_io_mode |= ((flag & SF_IO_NONBLOCK) << sn);   
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
 433                     ; 134    sock_is_sending &= ~(1<<sn);
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
 451                     ; 135    sock_remained_size[sn] = 0;
 453  017e 7b05          	ld	a,(OFST+1,sp)
 454  0180 5f            	clrw	x
 455  0181 97            	ld	xl,a
 456  0182 58            	sllw	x
 457  0183 905f          	clrw	y
 458  0185 ef06          	ldw	(L11_sock_remained_size,x),y
 459                     ; 138    sock_pack_info[sn] = PACK_COMPLETED;
 461  0187 7b05          	ld	a,(OFST+1,sp)
 462  0189 5f            	clrw	x
 463  018a 97            	ld	xl,a
 464  018b 6f16          	clr	(_sock_pack_info,x)
 466  018d               L151:
 467                     ; 140    while(getSn_SR(sn) == SOCK_CLOSED);
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
 488                     ; 141    return (int8_t)sn;
 490  01aa 7b05          	ld	a,(OFST+1,sp)
 492  01ac ac1d001d      	jpf	L22
 532                     ; 144 int8_t close(uint8_t sn)
 532                     ; 145 {
 533                     	switch	.text
 534  01b0               _close:
 536  01b0 88            	push	a
 537       00000000      OFST:	set	0
 540                     ; 146 	CHECK_SOCKNUM();
 542  01b1 7b01          	ld	a,(OFST+1,sp)
 543  01b3 a109          	cp	a,#9
 544  01b5 2505          	jrult	L771
 547  01b7 a6ff          	ld	a,#255
 550  01b9 5b01          	addw	sp,#1
 551  01bb 81            	ret
 552  01bc               L771:
 553                     ; 172 	setSn_CR(sn,Sn_CR_CLOSE);
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
 576                     ; 174 	while( getSn_CR(sn) );
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
 597                     ; 176 	setSn_IR(sn, 0xFF);
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
 617                     ; 178 	sock_io_mode &= ~(1<<sn);
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
 635                     ; 180 	sock_is_sending &= ~(1<<sn);
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
 653                     ; 181 	sock_remained_size[sn] = 0;
 655  023d 7b01          	ld	a,(OFST+1,sp)
 656  023f 5f            	clrw	x
 657  0240 97            	ld	xl,a
 658  0241 58            	sllw	x
 659  0242 905f          	clrw	y
 660  0244 ef06          	ldw	(L11_sock_remained_size,x),y
 661                     ; 182 	sock_pack_info[sn] = 0;
 663  0246 7b01          	ld	a,(OFST+1,sp)
 664  0248 5f            	clrw	x
 665  0249 97            	ld	xl,a
 666  024a 6f16          	clr	(_sock_pack_info,x)
 668  024c               L312:
 669                     ; 183 	while(getSn_SR(sn) != SOCK_CLOSED);
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
 690                     ; 184 	return SOCK_OK;
 692  0269 a601          	ld	a,#1
 695  026b 5b01          	addw	sp,#1
 696  026d 81            	ret
 733                     ; 187 int8_t listen(uint8_t sn)
 733                     ; 188 {
 734                     	switch	.text
 735  026e               _listen:
 737  026e 88            	push	a
 738       00000000      OFST:	set	0
 741                     ; 189 	CHECK_SOCKNUM();
 743  026f 7b01          	ld	a,(OFST+1,sp)
 744  0271 a109          	cp	a,#9
 745  0273 2505          	jrult	L342
 748  0275 a6ff          	ld	a,#255
 751  0277 5b01          	addw	sp,#1
 752  0279 81            	ret
 753  027a               L342:
 754                     ; 190    CHECK_SOCKMODE(Sn_MR_TCP);
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
 784                     ; 191 	CHECK_SOCKINIT();
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
 813                     ; 192 	setSn_CR(sn,Sn_CR_LISTEN);
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
 836                     ; 193 	while(getSn_CR(sn));
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
 860                     ; 196          close(sn);
 862  02fd 7b01          	ld	a,(OFST+1,sp)
 863  02ff cd01b0        	call	_close
 865                     ; 197          return SOCKERR_SOCKCLOSED;
 867  0302 a6fc          	ld	a,#252
 870  0304 5b01          	addw	sp,#1
 871  0306 81            	ret
 872  0307               L762:
 873                     ; 194    while(getSn_SR(sn) != SOCK_LISTEN)
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
 894                     ; 199    return SOCK_OK;
 896  0325 a601          	ld	a,#1
 899  0327 5b01          	addw	sp,#1
 900  0329 81            	ret
 966                     .const:	section	.text
 967  0000               L24:
 968  0000 ffffffff      	dc.l	-1
 969                     ; 203 int8_t connect(uint8_t sn, uint8_t * addr, uint16_t port)
 969                     ; 204 {
 970                     	switch	.text
 971  032a               _connect:
 973  032a 88            	push	a
 974  032b 5204          	subw	sp,#4
 975       00000004      OFST:	set	4
 978                     ; 205    CHECK_SOCKNUM();
 980  032d 7b05          	ld	a,(OFST+1,sp)
 981  032f a109          	cp	a,#9
 982  0331 2504          	jrult	L333
 985  0333 a6ff          	ld	a,#255
 987  0335 2022          	jra	L05
 988  0337               L333:
 989                     ; 206    CHECK_SOCKMODE(Sn_MR_TCP);
 991  0337 7b05          	ld	a,(OFST+1,sp)
 992  0339 97            	ld	xl,a
 993  033a a604          	ld	a,#4
 994  033c 42            	mul	x,a
 995  033d 58            	sllw	x
 996  033e 58            	sllw	x
 997  033f 58            	sllw	x
 998  0340 1c0008        	addw	x,#8
 999  0343 cd0000        	call	c_itolx
1001  0346 be02          	ldw	x,c_lreg+2
1002  0348 89            	pushw	x
1003  0349 be00          	ldw	x,c_lreg
1004  034b 89            	pushw	x
1005  034c cd0000        	call	_WIZCHIP_READ
1007  034f 5b04          	addw	sp,#4
1008  0351 a40f          	and	a,#15
1009  0353 a101          	cp	a,#1
1010  0355 2705          	jreq	L143
1013  0357 a6fb          	ld	a,#251
1015  0359               L05:
1017  0359 5b05          	addw	sp,#5
1018  035b 81            	ret
1019  035c               L143:
1020                     ; 207    CHECK_SOCKINIT();
1022  035c 7b05          	ld	a,(OFST+1,sp)
1023  035e 97            	ld	xl,a
1024  035f a604          	ld	a,#4
1025  0361 42            	mul	x,a
1026  0362 58            	sllw	x
1027  0363 58            	sllw	x
1028  0364 58            	sllw	x
1029  0365 1c0308        	addw	x,#776
1030  0368 cd0000        	call	c_itolx
1032  036b be02          	ldw	x,c_lreg+2
1033  036d 89            	pushw	x
1034  036e be00          	ldw	x,c_lreg
1035  0370 89            	pushw	x
1036  0371 cd0000        	call	_WIZCHIP_READ
1038  0374 5b04          	addw	sp,#4
1039  0376 a113          	cp	a,#19
1040  0378 2704          	jreq	L543
1043  037a a6fd          	ld	a,#253
1045  037c 20db          	jra	L05
1046  037e               L543:
1047                     ; 212       taddr = ((uint32_t)addr[0] & 0x000000FF);
1050  037e 1e08          	ldw	x,(OFST+4,sp)
1051  0380 f6            	ld	a,(x)
1052  0381 a4ff          	and	a,#255
1053  0383 6b04          	ld	(OFST+0,sp),a
1054  0385 4f            	clr	a
1055  0386 6b03          	ld	(OFST-1,sp),a
1056  0388 6b02          	ld	(OFST-2,sp),a
1057  038a 6b01          	ld	(OFST-3,sp),a
1059                     ; 213       taddr = (taddr << 8) + ((uint32_t)addr[1] & 0x000000FF);
1061  038c 96            	ldw	x,sp
1062  038d 1c0001        	addw	x,#OFST-3
1063  0390 cd0000        	call	c_ltor
1065  0393 a608          	ld	a,#8
1066  0395 cd0000        	call	c_llsh
1068  0398 1e08          	ldw	x,(OFST+4,sp)
1069  039a e601          	ld	a,(1,x)
1070  039c a4ff          	and	a,#255
1071  039e cd0000        	call	c_ladc
1073  03a1 96            	ldw	x,sp
1074  03a2 1c0001        	addw	x,#OFST-3
1075  03a5 cd0000        	call	c_rtol
1078                     ; 214       taddr = (taddr << 8) + ((uint32_t)addr[2] & 0x000000FF);
1080  03a8 96            	ldw	x,sp
1081  03a9 1c0001        	addw	x,#OFST-3
1082  03ac cd0000        	call	c_ltor
1084  03af a608          	ld	a,#8
1085  03b1 cd0000        	call	c_llsh
1087  03b4 1e08          	ldw	x,(OFST+4,sp)
1088  03b6 e602          	ld	a,(2,x)
1089  03b8 a4ff          	and	a,#255
1090  03ba cd0000        	call	c_ladc
1092  03bd 96            	ldw	x,sp
1093  03be 1c0001        	addw	x,#OFST-3
1094  03c1 cd0000        	call	c_rtol
1097                     ; 215       taddr = (taddr << 8) + ((uint32_t)addr[3] & 0x000000FF);
1099  03c4 96            	ldw	x,sp
1100  03c5 1c0001        	addw	x,#OFST-3
1101  03c8 cd0000        	call	c_ltor
1103  03cb a608          	ld	a,#8
1104  03cd cd0000        	call	c_llsh
1106  03d0 1e08          	ldw	x,(OFST+4,sp)
1107  03d2 e603          	ld	a,(3,x)
1108  03d4 a4ff          	and	a,#255
1109  03d6 cd0000        	call	c_ladc
1111  03d9 96            	ldw	x,sp
1112  03da 1c0001        	addw	x,#OFST-3
1113  03dd cd0000        	call	c_rtol
1116                     ; 216       if( taddr == 0xFFFFFFFF || taddr == 0) return SOCKERR_IPINVALID;
1118  03e0 96            	ldw	x,sp
1119  03e1 1c0001        	addw	x,#OFST-3
1120  03e4 cd0000        	call	c_ltor
1122  03e7 ae0000        	ldw	x,#L24
1123  03ea cd0000        	call	c_lcmp
1125  03ed 2709          	jreq	L153
1127  03ef 96            	ldw	x,sp
1128  03f0 1c0001        	addw	x,#OFST-3
1129  03f3 cd0000        	call	c_lzmp
1131  03f6 2606          	jrne	L743
1132  03f8               L153:
1135  03f8 a6f4          	ld	a,#244
1137  03fa ac590359      	jpf	L05
1138  03fe               L743:
1139                     ; 220 	if(port == 0) return SOCKERR_PORTZERO;
1141  03fe 1e0a          	ldw	x,(OFST+6,sp)
1142  0400 2606          	jrne	L353
1145  0402 a6f5          	ld	a,#245
1147  0404 ac590359      	jpf	L05
1148  0408               L353:
1149                     ; 221 	setSn_DIPR(sn,addr);
1151  0408 ae0004        	ldw	x,#4
1152  040b 89            	pushw	x
1153  040c 1e0a          	ldw	x,(OFST+6,sp)
1154  040e 89            	pushw	x
1155  040f 7b09          	ld	a,(OFST+5,sp)
1156  0411 97            	ld	xl,a
1157  0412 a604          	ld	a,#4
1158  0414 42            	mul	x,a
1159  0415 58            	sllw	x
1160  0416 58            	sllw	x
1161  0417 58            	sllw	x
1162  0418 1c0c08        	addw	x,#3080
1163  041b cd0000        	call	c_itolx
1165  041e be02          	ldw	x,c_lreg+2
1166  0420 89            	pushw	x
1167  0421 be00          	ldw	x,c_lreg
1168  0423 89            	pushw	x
1169  0424 cd0000        	call	_WIZCHIP_WRITE_BUF
1171  0427 5b08          	addw	sp,#8
1172                     ; 222 	setSn_DPORT(sn,port);
1174  0429 7b0a          	ld	a,(OFST+6,sp)
1175  042b 88            	push	a
1176  042c 7b06          	ld	a,(OFST+2,sp)
1177  042e 97            	ld	xl,a
1178  042f a604          	ld	a,#4
1179  0431 42            	mul	x,a
1180  0432 58            	sllw	x
1181  0433 58            	sllw	x
1182  0434 58            	sllw	x
1183  0435 1c1008        	addw	x,#4104
1184  0438 cd0000        	call	c_itolx
1186  043b be02          	ldw	x,c_lreg+2
1187  043d 89            	pushw	x
1188  043e be00          	ldw	x,c_lreg
1189  0440 89            	pushw	x
1190  0441 cd0000        	call	_WIZCHIP_WRITE
1192  0444 5b05          	addw	sp,#5
1195  0446 7b0b          	ld	a,(OFST+7,sp)
1196  0448 88            	push	a
1197  0449 7b06          	ld	a,(OFST+2,sp)
1198  044b 97            	ld	xl,a
1199  044c a604          	ld	a,#4
1200  044e 42            	mul	x,a
1201  044f 58            	sllw	x
1202  0450 58            	sllw	x
1203  0451 58            	sllw	x
1204  0452 1c1108        	addw	x,#4360
1205  0455 cd0000        	call	c_itolx
1207  0458 be02          	ldw	x,c_lreg+2
1208  045a 89            	pushw	x
1209  045b be00          	ldw	x,c_lreg
1210  045d 89            	pushw	x
1211  045e cd0000        	call	_WIZCHIP_WRITE
1213  0461 5b05          	addw	sp,#5
1214                     ; 223 	setSn_CR(sn,Sn_CR_CONNECT);
1217  0463 4b04          	push	#4
1218  0465 7b06          	ld	a,(OFST+2,sp)
1219  0467 97            	ld	xl,a
1220  0468 a604          	ld	a,#4
1221  046a 42            	mul	x,a
1222  046b 58            	sllw	x
1223  046c 58            	sllw	x
1224  046d 58            	sllw	x
1225  046e 1c0108        	addw	x,#264
1226  0471 cd0000        	call	c_itolx
1228  0474 be02          	ldw	x,c_lreg+2
1229  0476 89            	pushw	x
1230  0477 be00          	ldw	x,c_lreg
1231  0479 89            	pushw	x
1232  047a cd0000        	call	_WIZCHIP_WRITE
1234  047d 5b05          	addw	sp,#5
1236  047f               L753:
1237                     ; 224    while(getSn_CR(sn));
1239  047f 7b05          	ld	a,(OFST+1,sp)
1240  0481 97            	ld	xl,a
1241  0482 a604          	ld	a,#4
1242  0484 42            	mul	x,a
1243  0485 58            	sllw	x
1244  0486 58            	sllw	x
1245  0487 58            	sllw	x
1246  0488 1c0108        	addw	x,#264
1247  048b cd0000        	call	c_itolx
1249  048e be02          	ldw	x,c_lreg+2
1250  0490 89            	pushw	x
1251  0491 be00          	ldw	x,c_lreg
1252  0493 89            	pushw	x
1253  0494 cd0000        	call	_WIZCHIP_READ
1255  0497 5b04          	addw	sp,#4
1256  0499 4d            	tnz	a
1257  049a 26e3          	jrne	L753
1258                     ; 225    if(sock_io_mode & (1<<sn)) return SOCK_BUSY;
1260  049c ae0001        	ldw	x,#1
1261  049f 7b05          	ld	a,(OFST+1,sp)
1262  04a1 4d            	tnz	a
1263  04a2 2704          	jreq	L44
1264  04a4               L64:
1265  04a4 58            	sllw	x
1266  04a5 4a            	dec	a
1267  04a6 26fc          	jrne	L64
1268  04a8               L44:
1269  04a8 01            	rrwa	x,a
1270  04a9 b403          	and	a,L5_sock_io_mode+1
1271  04ab 01            	rrwa	x,a
1272  04ac b402          	and	a,L5_sock_io_mode
1273  04ae 01            	rrwa	x,a
1274  04af a30000        	cpw	x,#0
1275  04b2 276a          	jreq	L763
1278  04b4 4f            	clr	a
1280  04b5 ac590359      	jpf	L05
1281  04b9               L563:
1282                     ; 228 		if (getSn_IR(sn) & Sn_IR_TIMEOUT)
1284  04b9 7b05          	ld	a,(OFST+1,sp)
1285  04bb 97            	ld	xl,a
1286  04bc a604          	ld	a,#4
1287  04be 42            	mul	x,a
1288  04bf 58            	sllw	x
1289  04c0 58            	sllw	x
1290  04c1 58            	sllw	x
1291  04c2 1c0208        	addw	x,#520
1292  04c5 cd0000        	call	c_itolx
1294  04c8 be02          	ldw	x,c_lreg+2
1295  04ca 89            	pushw	x
1296  04cb be00          	ldw	x,c_lreg
1297  04cd 89            	pushw	x
1298  04ce cd0000        	call	_WIZCHIP_READ
1300  04d1 5b04          	addw	sp,#4
1301  04d3 a41f          	and	a,#31
1302  04d5 a508          	bcp	a,#8
1303  04d7 2722          	jreq	L373
1304                     ; 230 			setSn_IR(sn, Sn_IR_TIMEOUT);
1306  04d9 4b08          	push	#8
1307  04db 7b06          	ld	a,(OFST+2,sp)
1308  04dd 97            	ld	xl,a
1309  04de a604          	ld	a,#4
1310  04e0 42            	mul	x,a
1311  04e1 58            	sllw	x
1312  04e2 58            	sllw	x
1313  04e3 58            	sllw	x
1314  04e4 1c0208        	addw	x,#520
1315  04e7 cd0000        	call	c_itolx
1317  04ea be02          	ldw	x,c_lreg+2
1318  04ec 89            	pushw	x
1319  04ed be00          	ldw	x,c_lreg
1320  04ef 89            	pushw	x
1321  04f0 cd0000        	call	_WIZCHIP_WRITE
1323  04f3 5b05          	addw	sp,#5
1324                     ; 231             return SOCKERR_TIMEOUT;
1326  04f5 a6f3          	ld	a,#243
1328  04f7 ac590359      	jpf	L05
1329  04fb               L373:
1330                     ; 234 		if (getSn_SR(sn) == SOCK_CLOSED)
1332  04fb 7b05          	ld	a,(OFST+1,sp)
1333  04fd 97            	ld	xl,a
1334  04fe a604          	ld	a,#4
1335  0500 42            	mul	x,a
1336  0501 58            	sllw	x
1337  0502 58            	sllw	x
1338  0503 58            	sllw	x
1339  0504 1c0308        	addw	x,#776
1340  0507 cd0000        	call	c_itolx
1342  050a be02          	ldw	x,c_lreg+2
1343  050c 89            	pushw	x
1344  050d be00          	ldw	x,c_lreg
1345  050f 89            	pushw	x
1346  0510 cd0000        	call	_WIZCHIP_READ
1348  0513 5b04          	addw	sp,#4
1349  0515 4d            	tnz	a
1350  0516 2606          	jrne	L763
1351                     ; 236 			return SOCKERR_SOCKCLOSED;
1353  0518 a6fc          	ld	a,#252
1355  051a ac590359      	jpf	L05
1356  051e               L763:
1357                     ; 226    while(getSn_SR(sn) != SOCK_ESTABLISHED)
1359  051e 7b05          	ld	a,(OFST+1,sp)
1360  0520 97            	ld	xl,a
1361  0521 a604          	ld	a,#4
1362  0523 42            	mul	x,a
1363  0524 58            	sllw	x
1364  0525 58            	sllw	x
1365  0526 58            	sllw	x
1366  0527 1c0308        	addw	x,#776
1367  052a cd0000        	call	c_itolx
1369  052d be02          	ldw	x,c_lreg+2
1370  052f 89            	pushw	x
1371  0530 be00          	ldw	x,c_lreg
1372  0532 89            	pushw	x
1373  0533 cd0000        	call	_WIZCHIP_READ
1375  0536 5b04          	addw	sp,#4
1376  0538 a117          	cp	a,#23
1377  053a 2703          	jreq	L25
1378  053c cc04b9        	jp	L563
1379  053f               L25:
1380                     ; 240    return SOCK_OK;
1382  053f a601          	ld	a,#1
1384  0541 ac590359      	jpf	L05
1423                     ; 243 int8_t disconnect(uint8_t sn)
1423                     ; 244 {
1424                     	switch	.text
1425  0545               _disconnect:
1427  0545 88            	push	a
1428       00000000      OFST:	set	0
1431                     ; 245    CHECK_SOCKNUM();
1433  0546 7b01          	ld	a,(OFST+1,sp)
1434  0548 a109          	cp	a,#9
1435  054a 2505          	jrult	L324
1438  054c a6ff          	ld	a,#255
1441  054e 5b01          	addw	sp,#1
1442  0550 81            	ret
1443  0551               L324:
1444                     ; 246    CHECK_SOCKMODE(Sn_MR_TCP);
1446  0551 7b01          	ld	a,(OFST+1,sp)
1447  0553 97            	ld	xl,a
1448  0554 a604          	ld	a,#4
1449  0556 42            	mul	x,a
1450  0557 58            	sllw	x
1451  0558 58            	sllw	x
1452  0559 58            	sllw	x
1453  055a 1c0008        	addw	x,#8
1454  055d cd0000        	call	c_itolx
1456  0560 be02          	ldw	x,c_lreg+2
1457  0562 89            	pushw	x
1458  0563 be00          	ldw	x,c_lreg
1459  0565 89            	pushw	x
1460  0566 cd0000        	call	_WIZCHIP_READ
1462  0569 5b04          	addw	sp,#4
1463  056b a40f          	and	a,#15
1464  056d a101          	cp	a,#1
1465  056f 2705          	jreq	L724
1468  0571 a6fb          	ld	a,#251
1471  0573 5b01          	addw	sp,#1
1472  0575 81            	ret
1473  0576               L724:
1474                     ; 247 	setSn_CR(sn,Sn_CR_DISCON);
1477  0576 4b08          	push	#8
1478  0578 7b02          	ld	a,(OFST+2,sp)
1479  057a 97            	ld	xl,a
1480  057b a604          	ld	a,#4
1481  057d 42            	mul	x,a
1482  057e 58            	sllw	x
1483  057f 58            	sllw	x
1484  0580 58            	sllw	x
1485  0581 1c0108        	addw	x,#264
1486  0584 cd0000        	call	c_itolx
1488  0587 be02          	ldw	x,c_lreg+2
1489  0589 89            	pushw	x
1490  058a be00          	ldw	x,c_lreg
1491  058c 89            	pushw	x
1492  058d cd0000        	call	_WIZCHIP_WRITE
1494  0590 5b05          	addw	sp,#5
1496  0592               L334:
1497                     ; 249 	while(getSn_CR(sn));
1499  0592 7b01          	ld	a,(OFST+1,sp)
1500  0594 97            	ld	xl,a
1501  0595 a604          	ld	a,#4
1502  0597 42            	mul	x,a
1503  0598 58            	sllw	x
1504  0599 58            	sllw	x
1505  059a 58            	sllw	x
1506  059b 1c0108        	addw	x,#264
1507  059e cd0000        	call	c_itolx
1509  05a1 be02          	ldw	x,c_lreg+2
1510  05a3 89            	pushw	x
1511  05a4 be00          	ldw	x,c_lreg
1512  05a6 89            	pushw	x
1513  05a7 cd0000        	call	_WIZCHIP_READ
1515  05aa 5b04          	addw	sp,#4
1516  05ac 4d            	tnz	a
1517  05ad 26e3          	jrne	L334
1518                     ; 250 	sock_is_sending &= ~(1<<sn);
1520  05af ae0001        	ldw	x,#1
1521  05b2 7b01          	ld	a,(OFST+1,sp)
1522  05b4 4d            	tnz	a
1523  05b5 2704          	jreq	L65
1524  05b7               L06:
1525  05b7 58            	sllw	x
1526  05b8 4a            	dec	a
1527  05b9 26fc          	jrne	L06
1528  05bb               L65:
1529  05bb 53            	cplw	x
1530  05bc 01            	rrwa	x,a
1531  05bd b405          	and	a,L7_sock_is_sending+1
1532  05bf 01            	rrwa	x,a
1533  05c0 b404          	and	a,L7_sock_is_sending
1534  05c2 01            	rrwa	x,a
1535  05c3 bf04          	ldw	L7_sock_is_sending,x
1536                     ; 251    if(sock_io_mode & (1<<sn)) return SOCK_BUSY;
1538  05c5 ae0001        	ldw	x,#1
1539  05c8 7b01          	ld	a,(OFST+1,sp)
1540  05ca 4d            	tnz	a
1541  05cb 2704          	jreq	L26
1542  05cd               L46:
1543  05cd 58            	sllw	x
1544  05ce 4a            	dec	a
1545  05cf 26fc          	jrne	L46
1546  05d1               L26:
1547  05d1 01            	rrwa	x,a
1548  05d2 b403          	and	a,L5_sock_io_mode+1
1549  05d4 01            	rrwa	x,a
1550  05d5 b402          	and	a,L5_sock_io_mode
1551  05d7 01            	rrwa	x,a
1552  05d8 a30000        	cpw	x,#0
1553  05db 272e          	jreq	L344
1556  05dd 4f            	clr	a
1559  05de 5b01          	addw	sp,#1
1560  05e0 81            	ret
1561  05e1               L144:
1562                     ; 254 	   if(getSn_IR(sn) & Sn_IR_TIMEOUT)
1564  05e1 7b01          	ld	a,(OFST+1,sp)
1565  05e3 97            	ld	xl,a
1566  05e4 a604          	ld	a,#4
1567  05e6 42            	mul	x,a
1568  05e7 58            	sllw	x
1569  05e8 58            	sllw	x
1570  05e9 58            	sllw	x
1571  05ea 1c0208        	addw	x,#520
1572  05ed cd0000        	call	c_itolx
1574  05f0 be02          	ldw	x,c_lreg+2
1575  05f2 89            	pushw	x
1576  05f3 be00          	ldw	x,c_lreg
1577  05f5 89            	pushw	x
1578  05f6 cd0000        	call	_WIZCHIP_READ
1580  05f9 5b04          	addw	sp,#4
1581  05fb a41f          	and	a,#31
1582  05fd a508          	bcp	a,#8
1583  05ff 270a          	jreq	L344
1584                     ; 256 	      close(sn);
1586  0601 7b01          	ld	a,(OFST+1,sp)
1587  0603 cd01b0        	call	_close
1589                     ; 257 	      return SOCKERR_TIMEOUT;
1591  0606 a6f3          	ld	a,#243
1594  0608 5b01          	addw	sp,#1
1595  060a 81            	ret
1596  060b               L344:
1597                     ; 252 	while(getSn_SR(sn) != SOCK_CLOSED)
1599  060b 7b01          	ld	a,(OFST+1,sp)
1600  060d 97            	ld	xl,a
1601  060e a604          	ld	a,#4
1602  0610 42            	mul	x,a
1603  0611 58            	sllw	x
1604  0612 58            	sllw	x
1605  0613 58            	sllw	x
1606  0614 1c0308        	addw	x,#776
1607  0617 cd0000        	call	c_itolx
1609  061a be02          	ldw	x,c_lreg+2
1610  061c 89            	pushw	x
1611  061d be00          	ldw	x,c_lreg
1612  061f 89            	pushw	x
1613  0620 cd0000        	call	_WIZCHIP_READ
1615  0623 5b04          	addw	sp,#4
1616  0625 4d            	tnz	a
1617  0626 26b9          	jrne	L144
1618                     ; 260 	return SOCK_OK;
1620  0628 a601          	ld	a,#1
1623  062a 5b01          	addw	sp,#1
1624  062c 81            	ret
1702                     ; 263 int32_t send(uint8_t sn, uint8_t * buf, uint16_t len)
1702                     ; 264 {
1703                     	switch	.text
1704  062d               _send:
1706  062d 88            	push	a
1707  062e 5203          	subw	sp,#3
1708       00000003      OFST:	set	3
1711                     ; 265    uint8_t tmp=0;
1713                     ; 266    uint16_t freesize=0;
1715                     ; 268    CHECK_SOCKNUM();
1717  0630 7b04          	ld	a,(OFST+1,sp)
1718  0632 a109          	cp	a,#9
1719  0634 250c          	jrult	L515
1722  0636 aeffff        	ldw	x,#65535
1723  0639 bf02          	ldw	c_lreg+2,x
1724  063b aeffff        	ldw	x,#-1
1725  063e bf00          	ldw	c_lreg,x
1727  0640 202a          	jra	L011
1728  0642               L515:
1729                     ; 269    CHECK_SOCKMODE(Sn_MR_TCP);
1731  0642 7b04          	ld	a,(OFST+1,sp)
1732  0644 97            	ld	xl,a
1733  0645 a604          	ld	a,#4
1734  0647 42            	mul	x,a
1735  0648 58            	sllw	x
1736  0649 58            	sllw	x
1737  064a 58            	sllw	x
1738  064b 1c0008        	addw	x,#8
1739  064e cd0000        	call	c_itolx
1741  0651 be02          	ldw	x,c_lreg+2
1742  0653 89            	pushw	x
1743  0654 be00          	ldw	x,c_lreg
1744  0656 89            	pushw	x
1745  0657 cd0000        	call	_WIZCHIP_READ
1747  065a 5b04          	addw	sp,#4
1748  065c a40f          	and	a,#15
1749  065e a101          	cp	a,#1
1750  0660 270d          	jreq	L325
1753  0662 aefffb        	ldw	x,#65531
1754  0665 bf02          	ldw	c_lreg+2,x
1755  0667 aeffff        	ldw	x,#-1
1756  066a bf00          	ldw	c_lreg,x
1758  066c               L011:
1760  066c 5b04          	addw	sp,#4
1761  066e 81            	ret
1762  066f               L325:
1763                     ; 270    CHECK_SOCKDATA();
1765  066f 1e09          	ldw	x,(OFST+6,sp)
1766  0671 260c          	jrne	L725
1769  0673 aefff2        	ldw	x,#65522
1770  0676 bf02          	ldw	c_lreg+2,x
1771  0678 aeffff        	ldw	x,#-1
1772  067b bf00          	ldw	c_lreg,x
1774  067d 20ed          	jra	L011
1775  067f               L725:
1776                     ; 271    tmp = getSn_SR(sn);
1779  067f 7b04          	ld	a,(OFST+1,sp)
1780  0681 97            	ld	xl,a
1781  0682 a604          	ld	a,#4
1782  0684 42            	mul	x,a
1783  0685 58            	sllw	x
1784  0686 58            	sllw	x
1785  0687 58            	sllw	x
1786  0688 1c0308        	addw	x,#776
1787  068b cd0000        	call	c_itolx
1789  068e be02          	ldw	x,c_lreg+2
1790  0690 89            	pushw	x
1791  0691 be00          	ldw	x,c_lreg
1792  0693 89            	pushw	x
1793  0694 cd0000        	call	_WIZCHIP_READ
1795  0697 5b04          	addw	sp,#4
1796  0699 6b03          	ld	(OFST+0,sp),a
1798                     ; 272    if(tmp != SOCK_ESTABLISHED && tmp != SOCK_CLOSE_WAIT) return SOCKERR_SOCKSTATUS;
1800  069b 7b03          	ld	a,(OFST+0,sp)
1801  069d a117          	cp	a,#23
1802  069f 2712          	jreq	L135
1804  06a1 7b03          	ld	a,(OFST+0,sp)
1805  06a3 a11c          	cp	a,#28
1806  06a5 270c          	jreq	L135
1809  06a7 aefff9        	ldw	x,#65529
1810  06aa bf02          	ldw	c_lreg+2,x
1811  06ac aeffff        	ldw	x,#-1
1812  06af bf00          	ldw	c_lreg,x
1814  06b1 20b9          	jra	L011
1815  06b3               L135:
1816                     ; 273    if( sock_is_sending & (1<<sn) )
1818  06b3 ae0001        	ldw	x,#1
1819  06b6 7b04          	ld	a,(OFST+1,sp)
1820  06b8 4d            	tnz	a
1821  06b9 2704          	jreq	L07
1822  06bb               L27:
1823  06bb 58            	sllw	x
1824  06bc 4a            	dec	a
1825  06bd 26fc          	jrne	L27
1826  06bf               L07:
1827  06bf 01            	rrwa	x,a
1828  06c0 b405          	and	a,L7_sock_is_sending+1
1829  06c2 01            	rrwa	x,a
1830  06c3 b404          	and	a,L7_sock_is_sending
1831  06c5 01            	rrwa	x,a
1832  06c6 a30000        	cpw	x,#0
1833  06c9 2603          	jrne	L211
1834  06cb cc074d        	jp	L335
1835  06ce               L211:
1836                     ; 275       tmp = getSn_IR(sn);
1838  06ce 7b04          	ld	a,(OFST+1,sp)
1839  06d0 97            	ld	xl,a
1840  06d1 a604          	ld	a,#4
1841  06d3 42            	mul	x,a
1842  06d4 58            	sllw	x
1843  06d5 58            	sllw	x
1844  06d6 58            	sllw	x
1845  06d7 1c0208        	addw	x,#520
1846  06da cd0000        	call	c_itolx
1848  06dd be02          	ldw	x,c_lreg+2
1849  06df 89            	pushw	x
1850  06e0 be00          	ldw	x,c_lreg
1851  06e2 89            	pushw	x
1852  06e3 cd0000        	call	_WIZCHIP_READ
1854  06e6 5b04          	addw	sp,#4
1855  06e8 a41f          	and	a,#31
1856  06ea 6b03          	ld	(OFST+0,sp),a
1858                     ; 276       if(tmp & Sn_IR_SENDOK)
1860  06ec 7b03          	ld	a,(OFST+0,sp)
1861  06ee a510          	bcp	a,#16
1862  06f0 2734          	jreq	L535
1863                     ; 278          setSn_IR(sn, Sn_IR_SENDOK);
1865  06f2 4b10          	push	#16
1866  06f4 7b05          	ld	a,(OFST+2,sp)
1867  06f6 97            	ld	xl,a
1868  06f7 a604          	ld	a,#4
1869  06f9 42            	mul	x,a
1870  06fa 58            	sllw	x
1871  06fb 58            	sllw	x
1872  06fc 58            	sllw	x
1873  06fd 1c0208        	addw	x,#520
1874  0700 cd0000        	call	c_itolx
1876  0703 be02          	ldw	x,c_lreg+2
1877  0705 89            	pushw	x
1878  0706 be00          	ldw	x,c_lreg
1879  0708 89            	pushw	x
1880  0709 cd0000        	call	_WIZCHIP_WRITE
1882  070c 5b05          	addw	sp,#5
1883                     ; 289          sock_is_sending &= ~(1<<sn);         
1885  070e ae0001        	ldw	x,#1
1886  0711 7b04          	ld	a,(OFST+1,sp)
1887  0713 4d            	tnz	a
1888  0714 2704          	jreq	L47
1889  0716               L67:
1890  0716 58            	sllw	x
1891  0717 4a            	dec	a
1892  0718 26fc          	jrne	L67
1893  071a               L47:
1894  071a 53            	cplw	x
1895  071b 01            	rrwa	x,a
1896  071c b405          	and	a,L7_sock_is_sending+1
1897  071e 01            	rrwa	x,a
1898  071f b404          	and	a,L7_sock_is_sending
1899  0721 01            	rrwa	x,a
1900  0722 bf04          	ldw	L7_sock_is_sending,x
1902  0724 2027          	jra	L335
1903  0726               L535:
1904                     ; 291       else if(tmp & Sn_IR_TIMEOUT)
1906  0726 7b03          	ld	a,(OFST+0,sp)
1907  0728 a508          	bcp	a,#8
1908  072a 2713          	jreq	L145
1909                     ; 293          close(sn);
1911  072c 7b04          	ld	a,(OFST+1,sp)
1912  072e cd01b0        	call	_close
1914                     ; 294          return SOCKERR_TIMEOUT;
1916  0731 aefff3        	ldw	x,#65523
1917  0734 bf02          	ldw	c_lreg+2,x
1918  0736 aeffff        	ldw	x,#-1
1919  0739 bf00          	ldw	c_lreg,x
1921  073b ac6c066c      	jpf	L011
1922  073f               L145:
1923                     ; 296       else return SOCK_BUSY;
1925  073f ae0000        	ldw	x,#0
1926  0742 bf02          	ldw	c_lreg+2,x
1927  0744 ae0000        	ldw	x,#0
1928  0747 bf00          	ldw	c_lreg,x
1930  0749 ac6c066c      	jpf	L011
1931  074d               L335:
1932                     ; 298    freesize = getSn_TxMAX(sn);
1934  074d 7b04          	ld	a,(OFST+1,sp)
1935  074f 97            	ld	xl,a
1936  0750 a604          	ld	a,#4
1937  0752 42            	mul	x,a
1938  0753 58            	sllw	x
1939  0754 58            	sllw	x
1940  0755 58            	sllw	x
1941  0756 1c1f08        	addw	x,#7944
1942  0759 cd0000        	call	c_itolx
1944  075c be02          	ldw	x,c_lreg+2
1945  075e 89            	pushw	x
1946  075f be00          	ldw	x,c_lreg
1947  0761 89            	pushw	x
1948  0762 cd0000        	call	_WIZCHIP_READ
1950  0765 5b04          	addw	sp,#4
1951  0767 5f            	clrw	x
1952  0768 97            	ld	xl,a
1953  0769 4f            	clr	a
1954  076a 02            	rlwa	x,a
1955  076b 58            	sllw	x
1956  076c 58            	sllw	x
1957  076d 1f01          	ldw	(OFST-2,sp),x
1959                     ; 299    if (len > freesize) len = freesize; // check size not to exceed MAX size.
1961  076f 1e09          	ldw	x,(OFST+6,sp)
1962  0771 1301          	cpw	x,(OFST-2,sp)
1963  0773 2304          	jrule	L745
1966  0775 1e01          	ldw	x,(OFST-2,sp)
1967  0777 1f09          	ldw	(OFST+6,sp),x
1968  0779               L745:
1969                     ; 302       freesize = getSn_TX_FSR(sn);
1971  0779 7b04          	ld	a,(OFST+1,sp)
1972  077b cd0000        	call	_getSn_TX_FSR
1974  077e 1f01          	ldw	(OFST-2,sp),x
1976                     ; 303       tmp = getSn_SR(sn);
1978  0780 7b04          	ld	a,(OFST+1,sp)
1979  0782 97            	ld	xl,a
1980  0783 a604          	ld	a,#4
1981  0785 42            	mul	x,a
1982  0786 58            	sllw	x
1983  0787 58            	sllw	x
1984  0788 58            	sllw	x
1985  0789 1c0308        	addw	x,#776
1986  078c cd0000        	call	c_itolx
1988  078f be02          	ldw	x,c_lreg+2
1989  0791 89            	pushw	x
1990  0792 be00          	ldw	x,c_lreg
1991  0794 89            	pushw	x
1992  0795 cd0000        	call	_WIZCHIP_READ
1994  0798 5b04          	addw	sp,#4
1995  079a 6b03          	ld	(OFST+0,sp),a
1997                     ; 304       if ((tmp != SOCK_ESTABLISHED) && (tmp != SOCK_CLOSE_WAIT))
1999  079c 7b03          	ld	a,(OFST+0,sp)
2000  079e a117          	cp	a,#23
2001  07a0 2719          	jreq	L355
2003  07a2 7b03          	ld	a,(OFST+0,sp)
2004  07a4 a11c          	cp	a,#28
2005  07a6 2713          	jreq	L355
2006                     ; 306          close(sn);
2008  07a8 7b04          	ld	a,(OFST+1,sp)
2009  07aa cd01b0        	call	_close
2011                     ; 307          return SOCKERR_SOCKSTATUS;
2013  07ad aefff9        	ldw	x,#65529
2014  07b0 bf02          	ldw	c_lreg+2,x
2015  07b2 aeffff        	ldw	x,#-1
2016  07b5 bf00          	ldw	c_lreg,x
2018  07b7 ac6c066c      	jpf	L011
2019  07bb               L355:
2020                     ; 309       if( (sock_io_mode & (1<<sn)) && (len > freesize) ) return SOCK_BUSY;
2022  07bb ae0001        	ldw	x,#1
2023  07be 7b04          	ld	a,(OFST+1,sp)
2024  07c0 4d            	tnz	a
2025  07c1 2704          	jreq	L001
2026  07c3               L201:
2027  07c3 58            	sllw	x
2028  07c4 4a            	dec	a
2029  07c5 26fc          	jrne	L201
2030  07c7               L001:
2031  07c7 01            	rrwa	x,a
2032  07c8 b403          	and	a,L5_sock_io_mode+1
2033  07ca 01            	rrwa	x,a
2034  07cb b402          	and	a,L5_sock_io_mode
2035  07cd 01            	rrwa	x,a
2036  07ce a30000        	cpw	x,#0
2037  07d1 2714          	jreq	L555
2039  07d3 1e09          	ldw	x,(OFST+6,sp)
2040  07d5 1301          	cpw	x,(OFST-2,sp)
2041  07d7 230e          	jrule	L555
2044  07d9 ae0000        	ldw	x,#0
2045  07dc bf02          	ldw	c_lreg+2,x
2046  07de ae0000        	ldw	x,#0
2047  07e1 bf00          	ldw	c_lreg,x
2049  07e3 ac6c066c      	jpf	L011
2050  07e7               L555:
2051                     ; 310       if(len <= freesize) break;
2053  07e7 1e09          	ldw	x,(OFST+6,sp)
2054  07e9 1301          	cpw	x,(OFST-2,sp)
2055  07eb 228c          	jrugt	L745
2057                     ; 312    wiz_send_data(sn, buf, len);
2059  07ed 1e09          	ldw	x,(OFST+6,sp)
2060  07ef 89            	pushw	x
2061  07f0 1e09          	ldw	x,(OFST+6,sp)
2062  07f2 89            	pushw	x
2063  07f3 7b08          	ld	a,(OFST+5,sp)
2064  07f5 cd0000        	call	_wiz_send_data
2066  07f8 5b04          	addw	sp,#4
2067                     ; 321    setSn_CR(sn,Sn_CR_SEND);
2069  07fa 4b20          	push	#32
2070  07fc 7b05          	ld	a,(OFST+2,sp)
2071  07fe 97            	ld	xl,a
2072  07ff a604          	ld	a,#4
2073  0801 42            	mul	x,a
2074  0802 58            	sllw	x
2075  0803 58            	sllw	x
2076  0804 58            	sllw	x
2077  0805 1c0108        	addw	x,#264
2078  0808 cd0000        	call	c_itolx
2080  080b be02          	ldw	x,c_lreg+2
2081  080d 89            	pushw	x
2082  080e be00          	ldw	x,c_lreg
2083  0810 89            	pushw	x
2084  0811 cd0000        	call	_WIZCHIP_WRITE
2086  0814 5b05          	addw	sp,#5
2088  0816               L365:
2089                     ; 323    while(getSn_CR(sn));
2091  0816 7b04          	ld	a,(OFST+1,sp)
2092  0818 97            	ld	xl,a
2093  0819 a604          	ld	a,#4
2094  081b 42            	mul	x,a
2095  081c 58            	sllw	x
2096  081d 58            	sllw	x
2097  081e 58            	sllw	x
2098  081f 1c0108        	addw	x,#264
2099  0822 cd0000        	call	c_itolx
2101  0825 be02          	ldw	x,c_lreg+2
2102  0827 89            	pushw	x
2103  0828 be00          	ldw	x,c_lreg
2104  082a 89            	pushw	x
2105  082b cd0000        	call	_WIZCHIP_READ
2107  082e 5b04          	addw	sp,#4
2108  0830 4d            	tnz	a
2109  0831 26e3          	jrne	L365
2110                     ; 324    sock_is_sending |= (1 << sn);
2112  0833 ae0001        	ldw	x,#1
2113  0836 7b04          	ld	a,(OFST+1,sp)
2114  0838 4d            	tnz	a
2115  0839 2704          	jreq	L401
2116  083b               L601:
2117  083b 58            	sllw	x
2118  083c 4a            	dec	a
2119  083d 26fc          	jrne	L601
2120  083f               L401:
2121  083f 01            	rrwa	x,a
2122  0840 ba05          	or	a,L7_sock_is_sending+1
2123  0842 01            	rrwa	x,a
2124  0843 ba04          	or	a,L7_sock_is_sending
2125  0845 01            	rrwa	x,a
2126  0846 bf04          	ldw	L7_sock_is_sending,x
2127                     ; 327    return (int32_t)len;
2129  0848 1e09          	ldw	x,(OFST+6,sp)
2130  084a cd0000        	call	c_uitolx
2133  084d ac6c066c      	jpf	L011
2211                     ; 331 int32_t recv(uint8_t sn, uint8_t * buf, uint16_t len)
2211                     ; 332 {
2212                     	switch	.text
2213  0851               _recv:
2215  0851 88            	push	a
2216  0852 5205          	subw	sp,#5
2217       00000005      OFST:	set	5
2220                     ; 333    uint8_t  tmp = 0;
2222                     ; 334    uint16_t recvsize = 0;
2224                     ; 341    CHECK_SOCKNUM();
2226  0854 7b06          	ld	a,(OFST+1,sp)
2227  0856 a109          	cp	a,#9
2228  0858 250c          	jrult	L336
2231  085a aeffff        	ldw	x,#65535
2232  085d bf02          	ldw	c_lreg+2,x
2233  085f aeffff        	ldw	x,#-1
2234  0862 bf00          	ldw	c_lreg,x
2236  0864 202a          	jra	L221
2237  0866               L336:
2238                     ; 342    CHECK_SOCKMODE(Sn_MR_TCP);
2240  0866 7b06          	ld	a,(OFST+1,sp)
2241  0868 97            	ld	xl,a
2242  0869 a604          	ld	a,#4
2243  086b 42            	mul	x,a
2244  086c 58            	sllw	x
2245  086d 58            	sllw	x
2246  086e 58            	sllw	x
2247  086f 1c0008        	addw	x,#8
2248  0872 cd0000        	call	c_itolx
2250  0875 be02          	ldw	x,c_lreg+2
2251  0877 89            	pushw	x
2252  0878 be00          	ldw	x,c_lreg
2253  087a 89            	pushw	x
2254  087b cd0000        	call	_WIZCHIP_READ
2256  087e 5b04          	addw	sp,#4
2257  0880 a40f          	and	a,#15
2258  0882 a101          	cp	a,#1
2259  0884 270d          	jreq	L146
2262  0886 aefffb        	ldw	x,#65531
2263  0889 bf02          	ldw	c_lreg+2,x
2264  088b aeffff        	ldw	x,#-1
2265  088e bf00          	ldw	c_lreg,x
2267  0890               L221:
2269  0890 5b06          	addw	sp,#6
2270  0892 81            	ret
2271  0893               L146:
2272                     ; 343    CHECK_SOCKDATA();
2274  0893 1e0b          	ldw	x,(OFST+6,sp)
2275  0895 260c          	jrne	L546
2278  0897 aefff2        	ldw	x,#65522
2279  089a bf02          	ldw	c_lreg+2,x
2280  089c aeffff        	ldw	x,#-1
2281  089f bf00          	ldw	c_lreg,x
2283  08a1 20ed          	jra	L221
2284  08a3               L546:
2285                     ; 345    recvsize = getSn_RxMAX(sn);
2288  08a3 7b06          	ld	a,(OFST+1,sp)
2289  08a5 97            	ld	xl,a
2290  08a6 a604          	ld	a,#4
2291  08a8 42            	mul	x,a
2292  08a9 58            	sllw	x
2293  08aa 58            	sllw	x
2294  08ab 58            	sllw	x
2295  08ac 1c1e08        	addw	x,#7688
2296  08af cd0000        	call	c_itolx
2298  08b2 be02          	ldw	x,c_lreg+2
2299  08b4 89            	pushw	x
2300  08b5 be00          	ldw	x,c_lreg
2301  08b7 89            	pushw	x
2302  08b8 cd0000        	call	_WIZCHIP_READ
2304  08bb 5b04          	addw	sp,#4
2305  08bd 5f            	clrw	x
2306  08be 97            	ld	xl,a
2307  08bf 4f            	clr	a
2308  08c0 02            	rlwa	x,a
2309  08c1 58            	sllw	x
2310  08c2 58            	sllw	x
2311  08c3 1f04          	ldw	(OFST-1,sp),x
2313                     ; 346    if(recvsize < len) len = recvsize;
2315  08c5 1e04          	ldw	x,(OFST-1,sp)
2316  08c7 130b          	cpw	x,(OFST+6,sp)
2317  08c9 2404          	jruge	L156
2320  08cb 1e04          	ldw	x,(OFST-1,sp)
2321  08cd 1f0b          	ldw	(OFST+6,sp),x
2322  08cf               L156:
2323                     ; 357          recvsize = getSn_RX_RSR(sn);
2325  08cf 7b06          	ld	a,(OFST+1,sp)
2326  08d1 cd0000        	call	_getSn_RX_RSR
2328  08d4 1f04          	ldw	(OFST-1,sp),x
2330                     ; 358          tmp = getSn_SR(sn);
2332  08d6 7b06          	ld	a,(OFST+1,sp)
2333  08d8 97            	ld	xl,a
2334  08d9 a604          	ld	a,#4
2335  08db 42            	mul	x,a
2336  08dc 58            	sllw	x
2337  08dd 58            	sllw	x
2338  08de 58            	sllw	x
2339  08df 1c0308        	addw	x,#776
2340  08e2 cd0000        	call	c_itolx
2342  08e5 be02          	ldw	x,c_lreg+2
2343  08e7 89            	pushw	x
2344  08e8 be00          	ldw	x,c_lreg
2345  08ea 89            	pushw	x
2346  08eb cd0000        	call	_WIZCHIP_READ
2348  08ee 5b04          	addw	sp,#4
2349  08f0 6b03          	ld	(OFST-2,sp),a
2351                     ; 359          if (tmp != SOCK_ESTABLISHED)
2353  08f2 7b03          	ld	a,(OFST-2,sp)
2354  08f4 a117          	cp	a,#23
2355  08f6 275e          	jreq	L556
2356                     ; 361             if(tmp == SOCK_CLOSE_WAIT)
2358  08f8 7b03          	ld	a,(OFST-2,sp)
2359  08fa a11c          	cp	a,#28
2360  08fc 2645          	jrne	L756
2361                     ; 363                if(recvsize != 0) break;
2363  08fe 1e04          	ldw	x,(OFST-1,sp)
2364  0900 2703          	jreq	L421
2365  0902 cc0987        	jp	L356
2366  0905               L421:
2369                     ; 364                else if(getSn_TX_FSR(sn) == getSn_TxMAX(sn))
2371  0905 7b06          	ld	a,(OFST+1,sp)
2372  0907 97            	ld	xl,a
2373  0908 a604          	ld	a,#4
2374  090a 42            	mul	x,a
2375  090b 58            	sllw	x
2376  090c 58            	sllw	x
2377  090d 58            	sllw	x
2378  090e 1c1f08        	addw	x,#7944
2379  0911 cd0000        	call	c_itolx
2381  0914 be02          	ldw	x,c_lreg+2
2382  0916 89            	pushw	x
2383  0917 be00          	ldw	x,c_lreg
2384  0919 89            	pushw	x
2385  091a cd0000        	call	_WIZCHIP_READ
2387  091d 5b04          	addw	sp,#4
2388  091f 5f            	clrw	x
2389  0920 97            	ld	xl,a
2390  0921 4f            	clr	a
2391  0922 02            	rlwa	x,a
2392  0923 58            	sllw	x
2393  0924 58            	sllw	x
2394  0925 1f01          	ldw	(OFST-4,sp),x
2396  0927 7b06          	ld	a,(OFST+1,sp)
2397  0929 cd0000        	call	_getSn_TX_FSR
2399  092c 1301          	cpw	x,(OFST-4,sp)
2400  092e 2626          	jrne	L556
2401                     ; 366                   close(sn);
2403  0930 7b06          	ld	a,(OFST+1,sp)
2404  0932 cd01b0        	call	_close
2406                     ; 367                   return SOCKERR_SOCKSTATUS;
2408  0935 aefff9        	ldw	x,#65529
2409  0938 bf02          	ldw	c_lreg+2,x
2410  093a aeffff        	ldw	x,#-1
2411  093d bf00          	ldw	c_lreg,x
2413  093f ac900890      	jpf	L221
2414  0943               L756:
2415                     ; 372                close(sn);
2417  0943 7b06          	ld	a,(OFST+1,sp)
2418  0945 cd01b0        	call	_close
2420                     ; 373                return SOCKERR_SOCKSTATUS;
2422  0948 aefff9        	ldw	x,#65529
2423  094b bf02          	ldw	c_lreg+2,x
2424  094d aeffff        	ldw	x,#-1
2425  0950 bf00          	ldw	c_lreg,x
2427  0952 ac900890      	jpf	L221
2428  0956               L556:
2429                     ; 376          if((sock_io_mode & (1<<sn)) && (recvsize == 0)) return SOCK_BUSY;
2431  0956 ae0001        	ldw	x,#1
2432  0959 7b06          	ld	a,(OFST+1,sp)
2433  095b 4d            	tnz	a
2434  095c 2704          	jreq	L611
2435  095e               L021:
2436  095e 58            	sllw	x
2437  095f 4a            	dec	a
2438  0960 26fc          	jrne	L021
2439  0962               L611:
2440  0962 01            	rrwa	x,a
2441  0963 b403          	and	a,L5_sock_io_mode+1
2442  0965 01            	rrwa	x,a
2443  0966 b402          	and	a,L5_sock_io_mode
2444  0968 01            	rrwa	x,a
2445  0969 a30000        	cpw	x,#0
2446  096c 2712          	jreq	L176
2448  096e 1e04          	ldw	x,(OFST-1,sp)
2449  0970 260e          	jrne	L176
2452  0972 ae0000        	ldw	x,#0
2453  0975 bf02          	ldw	c_lreg+2,x
2454  0977 ae0000        	ldw	x,#0
2455  097a bf00          	ldw	c_lreg,x
2457  097c ac900890      	jpf	L221
2458  0980               L176:
2459                     ; 377          if(recvsize != 0) break;
2461  0980 1e04          	ldw	x,(OFST-1,sp)
2462  0982 2603          	jrne	L621
2463  0984 cc08cf        	jp	L156
2464  0987               L621:
2466  0987               L356:
2467                     ; 425    if(recvsize < len) len = recvsize;   
2470  0987 1e04          	ldw	x,(OFST-1,sp)
2471  0989 130b          	cpw	x,(OFST+6,sp)
2472  098b 2404          	jruge	L576
2475  098d 1e04          	ldw	x,(OFST-1,sp)
2476  098f 1f0b          	ldw	(OFST+6,sp),x
2477  0991               L576:
2478                     ; 426    wiz_recv_data(sn, buf, len);
2480  0991 1e0b          	ldw	x,(OFST+6,sp)
2481  0993 89            	pushw	x
2482  0994 1e0b          	ldw	x,(OFST+6,sp)
2483  0996 89            	pushw	x
2484  0997 7b0a          	ld	a,(OFST+5,sp)
2485  0999 cd0000        	call	_wiz_recv_data
2487  099c 5b04          	addw	sp,#4
2488                     ; 427    setSn_CR(sn,Sn_CR_RECV);
2490  099e 4b40          	push	#64
2491  09a0 7b07          	ld	a,(OFST+2,sp)
2492  09a2 97            	ld	xl,a
2493  09a3 a604          	ld	a,#4
2494  09a5 42            	mul	x,a
2495  09a6 58            	sllw	x
2496  09a7 58            	sllw	x
2497  09a8 58            	sllw	x
2498  09a9 1c0108        	addw	x,#264
2499  09ac cd0000        	call	c_itolx
2501  09af be02          	ldw	x,c_lreg+2
2502  09b1 89            	pushw	x
2503  09b2 be00          	ldw	x,c_lreg
2504  09b4 89            	pushw	x
2505  09b5 cd0000        	call	_WIZCHIP_WRITE
2507  09b8 5b05          	addw	sp,#5
2509  09ba               L107:
2510                     ; 428    while(getSn_CR(sn));
2512  09ba 7b06          	ld	a,(OFST+1,sp)
2513  09bc 97            	ld	xl,a
2514  09bd a604          	ld	a,#4
2515  09bf 42            	mul	x,a
2516  09c0 58            	sllw	x
2517  09c1 58            	sllw	x
2518  09c2 58            	sllw	x
2519  09c3 1c0108        	addw	x,#264
2520  09c6 cd0000        	call	c_itolx
2522  09c9 be02          	ldw	x,c_lreg+2
2523  09cb 89            	pushw	x
2524  09cc be00          	ldw	x,c_lreg
2525  09ce 89            	pushw	x
2526  09cf cd0000        	call	_WIZCHIP_READ
2528  09d2 5b04          	addw	sp,#4
2529  09d4 4d            	tnz	a
2530  09d5 26e3          	jrne	L107
2531                     ; 433    return (int32_t)len;
2533  09d7 1e0b          	ldw	x,(OFST+6,sp)
2534  09d9 cd0000        	call	c_uitolx
2537  09dc ac900890      	jpf	L221
2642                     ; 436 int32_t sendto(uint8_t sn, uint8_t * buf, uint16_t len, uint8_t * addr, uint16_t port)
2642                     ; 437 {
2643                     	switch	.text
2644  09e0               _sendto:
2646  09e0 88            	push	a
2647  09e1 5207          	subw	sp,#7
2648       00000007      OFST:	set	7
2651                     ; 438    uint8_t tmp = 0;
2653                     ; 439    uint16_t freesize = 0;
2655                     ; 442    CHECK_SOCKNUM();
2657  09e3 7b08          	ld	a,(OFST+1,sp)
2658  09e5 a109          	cp	a,#9
2659  09e7 250c          	jrult	L767
2662  09e9 aeffff        	ldw	x,#65535
2663  09ec bf02          	ldw	c_lreg+2,x
2664  09ee aeffff        	ldw	x,#-1
2665  09f1 bf00          	ldw	c_lreg,x
2667  09f3 2030          	jra	L631
2668  09f5               L767:
2669                     ; 443    switch(getSn_MR(sn) & 0x0F)
2672  09f5 7b08          	ld	a,(OFST+1,sp)
2673  09f7 97            	ld	xl,a
2674  09f8 a604          	ld	a,#4
2675  09fa 42            	mul	x,a
2676  09fb 58            	sllw	x
2677  09fc 58            	sllw	x
2678  09fd 58            	sllw	x
2679  09fe 1c0008        	addw	x,#8
2680  0a01 cd0000        	call	c_itolx
2682  0a04 be02          	ldw	x,c_lreg+2
2683  0a06 89            	pushw	x
2684  0a07 be00          	ldw	x,c_lreg
2685  0a09 89            	pushw	x
2686  0a0a cd0000        	call	_WIZCHIP_READ
2688  0a0d 5b04          	addw	sp,#4
2689  0a0f a40f          	and	a,#15
2691                     ; 449       default:
2691                     ; 450          return SOCKERR_SOCKMODE;
2692  0a11 a002          	sub	a,#2
2693  0a13 2713          	jreq	L577
2694  0a15 4a            	dec	a
2695  0a16 2710          	jreq	L577
2696  0a18 4a            	dec	a
2697  0a19 270d          	jreq	L577
2698  0a1b               L707:
2701  0a1b aefffb        	ldw	x,#65531
2702  0a1e bf02          	ldw	c_lreg+2,x
2703  0a20 aeffff        	ldw	x,#-1
2704  0a23 bf00          	ldw	c_lreg,x
2706  0a25               L631:
2708  0a25 5b08          	addw	sp,#8
2709  0a27 81            	ret
2710                     ; 445       case Sn_MR_UDP:
2710                     ; 446       case Sn_MR_MACRAW:
2710                     ; 447       case Sn_MR_IPRAW:
2710                     ; 448          break;
2712  0a28               L377:
2713  0a28               L577:
2714                     ; 452    CHECK_SOCKDATA();
2716  0a28 1e0d          	ldw	x,(OFST+6,sp)
2717  0a2a 260c          	jrne	L1001
2720  0a2c aefff2        	ldw	x,#65522
2721  0a2f bf02          	ldw	c_lreg+2,x
2722  0a31 aeffff        	ldw	x,#-1
2723  0a34 bf00          	ldw	c_lreg,x
2725  0a36 20ed          	jra	L631
2726  0a38               L1001:
2727                     ; 457       taddr = ((uint32_t)addr[0]) & 0x000000FF;
2730  0a38 1e0f          	ldw	x,(OFST+8,sp)
2731  0a3a f6            	ld	a,(x)
2732  0a3b a4ff          	and	a,#255
2733  0a3d 6b04          	ld	(OFST-3,sp),a
2734  0a3f 4f            	clr	a
2735  0a40 6b03          	ld	(OFST-4,sp),a
2736  0a42 6b02          	ld	(OFST-5,sp),a
2737  0a44 6b01          	ld	(OFST-6,sp),a
2739                     ; 458       taddr = (taddr << 8) + ((uint32_t)addr[1] & 0x000000FF);
2741  0a46 96            	ldw	x,sp
2742  0a47 1c0001        	addw	x,#OFST-6
2743  0a4a cd0000        	call	c_ltor
2745  0a4d a608          	ld	a,#8
2746  0a4f cd0000        	call	c_llsh
2748  0a52 1e0f          	ldw	x,(OFST+8,sp)
2749  0a54 e601          	ld	a,(1,x)
2750  0a56 a4ff          	and	a,#255
2751  0a58 cd0000        	call	c_ladc
2753  0a5b 96            	ldw	x,sp
2754  0a5c 1c0001        	addw	x,#OFST-6
2755  0a5f cd0000        	call	c_rtol
2758                     ; 459       taddr = (taddr << 8) + ((uint32_t)addr[2] & 0x000000FF);
2760  0a62 96            	ldw	x,sp
2761  0a63 1c0001        	addw	x,#OFST-6
2762  0a66 cd0000        	call	c_ltor
2764  0a69 a608          	ld	a,#8
2765  0a6b cd0000        	call	c_llsh
2767  0a6e 1e0f          	ldw	x,(OFST+8,sp)
2768  0a70 e602          	ld	a,(2,x)
2769  0a72 a4ff          	and	a,#255
2770  0a74 cd0000        	call	c_ladc
2772  0a77 96            	ldw	x,sp
2773  0a78 1c0001        	addw	x,#OFST-6
2774  0a7b cd0000        	call	c_rtol
2777                     ; 460       taddr = (taddr << 8) + ((uint32_t)addr[3] & 0x000000FF);
2779  0a7e 96            	ldw	x,sp
2780  0a7f 1c0001        	addw	x,#OFST-6
2781  0a82 cd0000        	call	c_ltor
2783  0a85 a608          	ld	a,#8
2784  0a87 cd0000        	call	c_llsh
2786  0a8a 1e0f          	ldw	x,(OFST+8,sp)
2787  0a8c e603          	ld	a,(3,x)
2788  0a8e a4ff          	and	a,#255
2789  0a90 cd0000        	call	c_ladc
2791  0a93 96            	ldw	x,sp
2792  0a94 1c0001        	addw	x,#OFST-6
2793  0a97 cd0000        	call	c_rtol
2796                     ; 464    if(taddr == 0) 				return SOCKERR_IPINVALID;
2798  0a9a 96            	ldw	x,sp
2799  0a9b 1c0001        	addw	x,#OFST-6
2800  0a9e cd0000        	call	c_lzmp
2802  0aa1 260e          	jrne	L3001
2805  0aa3 aefff4        	ldw	x,#65524
2806  0aa6 bf02          	ldw	c_lreg+2,x
2807  0aa8 aeffff        	ldw	x,#-1
2808  0aab bf00          	ldw	c_lreg,x
2810  0aad ac250a25      	jpf	L631
2811  0ab1               L3001:
2812                     ; 465    if(port == 0)              return SOCKERR_PORTZERO;
2814  0ab1 1e11          	ldw	x,(OFST+10,sp)
2815  0ab3 260e          	jrne	L5001
2818  0ab5 aefff5        	ldw	x,#65525
2819  0ab8 bf02          	ldw	c_lreg+2,x
2820  0aba aeffff        	ldw	x,#-1
2821  0abd bf00          	ldw	c_lreg,x
2823  0abf ac250a25      	jpf	L631
2824  0ac3               L5001:
2825                     ; 466    tmp = getSn_SR(sn);
2827  0ac3 7b08          	ld	a,(OFST+1,sp)
2828  0ac5 97            	ld	xl,a
2829  0ac6 a604          	ld	a,#4
2830  0ac8 42            	mul	x,a
2831  0ac9 58            	sllw	x
2832  0aca 58            	sllw	x
2833  0acb 58            	sllw	x
2834  0acc 1c0308        	addw	x,#776
2835  0acf cd0000        	call	c_itolx
2837  0ad2 be02          	ldw	x,c_lreg+2
2838  0ad4 89            	pushw	x
2839  0ad5 be00          	ldw	x,c_lreg
2840  0ad7 89            	pushw	x
2841  0ad8 cd0000        	call	_WIZCHIP_READ
2843  0adb 5b04          	addw	sp,#4
2844  0add 6b07          	ld	(OFST+0,sp),a
2846                     ; 467    if(tmp != SOCK_MACRAW && tmp != SOCK_UDP && tmp != SOCK_IPRAW ) return SOCKERR_SOCKSTATUS;
2848  0adf 7b07          	ld	a,(OFST+0,sp)
2849  0ae1 a142          	cp	a,#66
2850  0ae3 271a          	jreq	L7001
2852  0ae5 7b07          	ld	a,(OFST+0,sp)
2853  0ae7 a122          	cp	a,#34
2854  0ae9 2714          	jreq	L7001
2856  0aeb 7b07          	ld	a,(OFST+0,sp)
2857  0aed a132          	cp	a,#50
2858  0aef 270e          	jreq	L7001
2861  0af1 aefff9        	ldw	x,#65529
2862  0af4 bf02          	ldw	c_lreg+2,x
2863  0af6 aeffff        	ldw	x,#-1
2864  0af9 bf00          	ldw	c_lreg,x
2866  0afb ac250a25      	jpf	L631
2867  0aff               L7001:
2868                     ; 469    setSn_DIPR(sn,addr);
2870  0aff ae0004        	ldw	x,#4
2871  0b02 89            	pushw	x
2872  0b03 1e11          	ldw	x,(OFST+10,sp)
2873  0b05 89            	pushw	x
2874  0b06 7b0c          	ld	a,(OFST+5,sp)
2875  0b08 97            	ld	xl,a
2876  0b09 a604          	ld	a,#4
2877  0b0b 42            	mul	x,a
2878  0b0c 58            	sllw	x
2879  0b0d 58            	sllw	x
2880  0b0e 58            	sllw	x
2881  0b0f 1c0c08        	addw	x,#3080
2882  0b12 cd0000        	call	c_itolx
2884  0b15 be02          	ldw	x,c_lreg+2
2885  0b17 89            	pushw	x
2886  0b18 be00          	ldw	x,c_lreg
2887  0b1a 89            	pushw	x
2888  0b1b cd0000        	call	_WIZCHIP_WRITE_BUF
2890  0b1e 5b08          	addw	sp,#8
2891                     ; 470    setSn_DPORT(sn,port);      
2893  0b20 7b11          	ld	a,(OFST+10,sp)
2894  0b22 88            	push	a
2895  0b23 7b09          	ld	a,(OFST+2,sp)
2896  0b25 97            	ld	xl,a
2897  0b26 a604          	ld	a,#4
2898  0b28 42            	mul	x,a
2899  0b29 58            	sllw	x
2900  0b2a 58            	sllw	x
2901  0b2b 58            	sllw	x
2902  0b2c 1c1008        	addw	x,#4104
2903  0b2f cd0000        	call	c_itolx
2905  0b32 be02          	ldw	x,c_lreg+2
2906  0b34 89            	pushw	x
2907  0b35 be00          	ldw	x,c_lreg
2908  0b37 89            	pushw	x
2909  0b38 cd0000        	call	_WIZCHIP_WRITE
2911  0b3b 5b05          	addw	sp,#5
2914  0b3d 7b12          	ld	a,(OFST+11,sp)
2915  0b3f 88            	push	a
2916  0b40 7b09          	ld	a,(OFST+2,sp)
2917  0b42 97            	ld	xl,a
2918  0b43 a604          	ld	a,#4
2919  0b45 42            	mul	x,a
2920  0b46 58            	sllw	x
2921  0b47 58            	sllw	x
2922  0b48 58            	sllw	x
2923  0b49 1c1108        	addw	x,#4360
2924  0b4c cd0000        	call	c_itolx
2926  0b4f be02          	ldw	x,c_lreg+2
2927  0b51 89            	pushw	x
2928  0b52 be00          	ldw	x,c_lreg
2929  0b54 89            	pushw	x
2930  0b55 cd0000        	call	_WIZCHIP_WRITE
2932  0b58 5b05          	addw	sp,#5
2933                     ; 471    freesize = getSn_TxMAX(sn);
2936  0b5a 7b08          	ld	a,(OFST+1,sp)
2937  0b5c 97            	ld	xl,a
2938  0b5d a604          	ld	a,#4
2939  0b5f 42            	mul	x,a
2940  0b60 58            	sllw	x
2941  0b61 58            	sllw	x
2942  0b62 58            	sllw	x
2943  0b63 1c1f08        	addw	x,#7944
2944  0b66 cd0000        	call	c_itolx
2946  0b69 be02          	ldw	x,c_lreg+2
2947  0b6b 89            	pushw	x
2948  0b6c be00          	ldw	x,c_lreg
2949  0b6e 89            	pushw	x
2950  0b6f cd0000        	call	_WIZCHIP_READ
2952  0b72 5b04          	addw	sp,#4
2953  0b74 5f            	clrw	x
2954  0b75 97            	ld	xl,a
2955  0b76 4f            	clr	a
2956  0b77 02            	rlwa	x,a
2957  0b78 58            	sllw	x
2958  0b79 58            	sllw	x
2959  0b7a 1f05          	ldw	(OFST-2,sp),x
2961                     ; 472    if (len > freesize) len = freesize; // check size not to exceed MAX size.
2963  0b7c 1e0d          	ldw	x,(OFST+6,sp)
2964  0b7e 1305          	cpw	x,(OFST-2,sp)
2965  0b80 2304          	jrule	L3101
2968  0b82 1e05          	ldw	x,(OFST-2,sp)
2969  0b84 1f0d          	ldw	(OFST+6,sp),x
2970  0b86               L3101:
2971                     ; 475       freesize = getSn_TX_FSR(sn);
2973  0b86 7b08          	ld	a,(OFST+1,sp)
2974  0b88 cd0000        	call	_getSn_TX_FSR
2976  0b8b 1f05          	ldw	(OFST-2,sp),x
2978                     ; 476       if(getSn_SR(sn) == SOCK_CLOSED) return SOCKERR_SOCKCLOSED;
2980  0b8d 7b08          	ld	a,(OFST+1,sp)
2981  0b8f 97            	ld	xl,a
2982  0b90 a604          	ld	a,#4
2983  0b92 42            	mul	x,a
2984  0b93 58            	sllw	x
2985  0b94 58            	sllw	x
2986  0b95 58            	sllw	x
2987  0b96 1c0308        	addw	x,#776
2988  0b99 cd0000        	call	c_itolx
2990  0b9c be02          	ldw	x,c_lreg+2
2991  0b9e 89            	pushw	x
2992  0b9f be00          	ldw	x,c_lreg
2993  0ba1 89            	pushw	x
2994  0ba2 cd0000        	call	_WIZCHIP_READ
2996  0ba5 5b04          	addw	sp,#4
2997  0ba7 4d            	tnz	a
2998  0ba8 260e          	jrne	L7101
3001  0baa aefffc        	ldw	x,#65532
3002  0bad bf02          	ldw	c_lreg+2,x
3003  0baf aeffff        	ldw	x,#-1
3004  0bb2 bf00          	ldw	c_lreg,x
3006  0bb4 ac250a25      	jpf	L631
3007  0bb8               L7101:
3008                     ; 477       if( (sock_io_mode & (1<<sn)) && (len > freesize) ) return SOCK_BUSY;
3010  0bb8 ae0001        	ldw	x,#1
3011  0bbb 7b08          	ld	a,(OFST+1,sp)
3012  0bbd 4d            	tnz	a
3013  0bbe 2704          	jreq	L231
3014  0bc0               L431:
3015  0bc0 58            	sllw	x
3016  0bc1 4a            	dec	a
3017  0bc2 26fc          	jrne	L431
3018  0bc4               L231:
3019  0bc4 01            	rrwa	x,a
3020  0bc5 b403          	and	a,L5_sock_io_mode+1
3021  0bc7 01            	rrwa	x,a
3022  0bc8 b402          	and	a,L5_sock_io_mode
3023  0bca 01            	rrwa	x,a
3024  0bcb a30000        	cpw	x,#0
3025  0bce 2714          	jreq	L1201
3027  0bd0 1e0d          	ldw	x,(OFST+6,sp)
3028  0bd2 1305          	cpw	x,(OFST-2,sp)
3029  0bd4 230e          	jrule	L1201
3032  0bd6 ae0000        	ldw	x,#0
3033  0bd9 bf02          	ldw	c_lreg+2,x
3034  0bdb ae0000        	ldw	x,#0
3035  0bde bf00          	ldw	c_lreg,x
3037  0be0 ac250a25      	jpf	L631
3038  0be4               L1201:
3039                     ; 478       if(len <= freesize) break;
3041  0be4 1e0d          	ldw	x,(OFST+6,sp)
3042  0be6 1305          	cpw	x,(OFST-2,sp)
3043  0be8 229c          	jrugt	L3101
3045                     ; 480 	wiz_send_data(sn, buf, len);
3048  0bea 1e0d          	ldw	x,(OFST+6,sp)
3049  0bec 89            	pushw	x
3050  0bed 1e0d          	ldw	x,(OFST+6,sp)
3051  0bef 89            	pushw	x
3052  0bf0 7b0c          	ld	a,(OFST+5,sp)
3053  0bf2 cd0000        	call	_wiz_send_data
3055  0bf5 5b04          	addw	sp,#4
3056                     ; 497 	setSn_CR(sn,Sn_CR_SEND);
3058  0bf7 4b20          	push	#32
3059  0bf9 7b09          	ld	a,(OFST+2,sp)
3060  0bfb 97            	ld	xl,a
3061  0bfc a604          	ld	a,#4
3062  0bfe 42            	mul	x,a
3063  0bff 58            	sllw	x
3064  0c00 58            	sllw	x
3065  0c01 58            	sllw	x
3066  0c02 1c0108        	addw	x,#264
3067  0c05 cd0000        	call	c_itolx
3069  0c08 be02          	ldw	x,c_lreg+2
3070  0c0a 89            	pushw	x
3071  0c0b be00          	ldw	x,c_lreg
3072  0c0d 89            	pushw	x
3073  0c0e cd0000        	call	_WIZCHIP_WRITE
3075  0c11 5b05          	addw	sp,#5
3077  0c13               L7201:
3078                     ; 499 	while(getSn_CR(sn));
3080  0c13 7b08          	ld	a,(OFST+1,sp)
3081  0c15 97            	ld	xl,a
3082  0c16 a604          	ld	a,#4
3083  0c18 42            	mul	x,a
3084  0c19 58            	sllw	x
3085  0c1a 58            	sllw	x
3086  0c1b 58            	sllw	x
3087  0c1c 1c0108        	addw	x,#264
3088  0c1f cd0000        	call	c_itolx
3090  0c22 be02          	ldw	x,c_lreg+2
3091  0c24 89            	pushw	x
3092  0c25 be00          	ldw	x,c_lreg
3093  0c27 89            	pushw	x
3094  0c28 cd0000        	call	_WIZCHIP_READ
3096  0c2b 5b04          	addw	sp,#4
3097  0c2d 4d            	tnz	a
3098  0c2e 26e3          	jrne	L7201
3099  0c30               L3301:
3100                     ; 502       tmp = getSn_IR(sn);
3102  0c30 7b08          	ld	a,(OFST+1,sp)
3103  0c32 97            	ld	xl,a
3104  0c33 a604          	ld	a,#4
3105  0c35 42            	mul	x,a
3106  0c36 58            	sllw	x
3107  0c37 58            	sllw	x
3108  0c38 58            	sllw	x
3109  0c39 1c0208        	addw	x,#520
3110  0c3c cd0000        	call	c_itolx
3112  0c3f be02          	ldw	x,c_lreg+2
3113  0c41 89            	pushw	x
3114  0c42 be00          	ldw	x,c_lreg
3115  0c44 89            	pushw	x
3116  0c45 cd0000        	call	_WIZCHIP_READ
3118  0c48 5b04          	addw	sp,#4
3119  0c4a a41f          	and	a,#31
3120  0c4c 6b07          	ld	(OFST+0,sp),a
3122                     ; 503       if(tmp & Sn_IR_SENDOK)
3124  0c4e 7b07          	ld	a,(OFST+0,sp)
3125  0c50 a510          	bcp	a,#16
3126  0c52 2725          	jreq	L7301
3127                     ; 505          setSn_IR(sn, Sn_IR_SENDOK);
3129  0c54 4b10          	push	#16
3130  0c56 7b09          	ld	a,(OFST+2,sp)
3131  0c58 97            	ld	xl,a
3132  0c59 a604          	ld	a,#4
3133  0c5b 42            	mul	x,a
3134  0c5c 58            	sllw	x
3135  0c5d 58            	sllw	x
3136  0c5e 58            	sllw	x
3137  0c5f 1c0208        	addw	x,#520
3138  0c62 cd0000        	call	c_itolx
3140  0c65 be02          	ldw	x,c_lreg+2
3141  0c67 89            	pushw	x
3142  0c68 be00          	ldw	x,c_lreg
3143  0c6a 89            	pushw	x
3144  0c6b cd0000        	call	_WIZCHIP_WRITE
3146  0c6e 5b05          	addw	sp,#5
3147                     ; 506          break;
3148                     ; 528    return (int32_t)len;
3150  0c70 1e0d          	ldw	x,(OFST+6,sp)
3151  0c72 cd0000        	call	c_uitolx
3154  0c75 ac250a25      	jpf	L631
3155  0c79               L7301:
3156                     ; 510       else if(tmp & Sn_IR_TIMEOUT)
3158  0c79 7b07          	ld	a,(OFST+0,sp)
3159  0c7b a508          	bcp	a,#8
3160  0c7d 27b1          	jreq	L3301
3161                     ; 512          setSn_IR(sn, Sn_IR_TIMEOUT);
3163  0c7f 4b08          	push	#8
3164  0c81 7b09          	ld	a,(OFST+2,sp)
3165  0c83 97            	ld	xl,a
3166  0c84 a604          	ld	a,#4
3167  0c86 42            	mul	x,a
3168  0c87 58            	sllw	x
3169  0c88 58            	sllw	x
3170  0c89 58            	sllw	x
3171  0c8a 1c0208        	addw	x,#520
3172  0c8d cd0000        	call	c_itolx
3174  0c90 be02          	ldw	x,c_lreg+2
3175  0c92 89            	pushw	x
3176  0c93 be00          	ldw	x,c_lreg
3177  0c95 89            	pushw	x
3178  0c96 cd0000        	call	_WIZCHIP_WRITE
3180  0c99 5b05          	addw	sp,#5
3181                     ; 519          return SOCKERR_TIMEOUT;
3183  0c9b aefff3        	ldw	x,#65523
3184  0c9e bf02          	ldw	c_lreg+2,x
3185  0ca0 aeffff        	ldw	x,#-1
3186  0ca3 bf00          	ldw	c_lreg,x
3188  0ca5 ac250a25      	jpf	L631
3298                     ; 533 int32_t recvfrom(uint8_t sn, uint8_t * buf, uint16_t len, uint8_t * addr, uint16_t *port)
3298                     ; 534 {
3299                     	switch	.text
3300  0ca9               _recvfrom:
3302  0ca9 88            	push	a
3303  0caa 520d          	subw	sp,#13
3304       0000000d      OFST:	set	13
3307                     ; 544 	uint16_t pack_len=0;
3309  0cac 5f            	clrw	x
3310  0cad 1f0c          	ldw	(OFST-1,sp),x
3312                     ; 546    CHECK_SOCKNUM();
3314  0caf 7b0e          	ld	a,(OFST+1,sp)
3315  0cb1 a109          	cp	a,#9
3316  0cb3 250c          	jrult	L7311
3319  0cb5 aeffff        	ldw	x,#65535
3320  0cb8 bf02          	ldw	c_lreg+2,x
3321  0cba aeffff        	ldw	x,#-1
3322  0cbd bf00          	ldw	c_lreg,x
3324  0cbf 2034          	jra	L651
3325  0cc1               L7311:
3326                     ; 553    switch((mr=getSn_MR(sn)) & 0x0F)
3329  0cc1 7b0e          	ld	a,(OFST+1,sp)
3330  0cc3 97            	ld	xl,a
3331  0cc4 a604          	ld	a,#4
3332  0cc6 42            	mul	x,a
3333  0cc7 58            	sllw	x
3334  0cc8 58            	sllw	x
3335  0cc9 58            	sllw	x
3336  0cca 1c0008        	addw	x,#8
3337  0ccd cd0000        	call	c_itolx
3339  0cd0 be02          	ldw	x,c_lreg+2
3340  0cd2 89            	pushw	x
3341  0cd3 be00          	ldw	x,c_lreg
3342  0cd5 89            	pushw	x
3343  0cd6 cd0000        	call	_WIZCHIP_READ
3345  0cd9 5b04          	addw	sp,#4
3346  0cdb 6b03          	ld	(OFST-10,sp),a
3348  0cdd 7b03          	ld	a,(OFST-10,sp)
3349  0cdf a40f          	and	a,#15
3351                     ; 564       default:
3351                     ; 565          return SOCKERR_SOCKMODE;
3352  0ce1 a002          	sub	a,#2
3353  0ce3 2713          	jreq	L5411
3354  0ce5 4a            	dec	a
3355  0ce6 2710          	jreq	L5411
3356  0ce8 4a            	dec	a
3357  0ce9 270d          	jreq	L5411
3358  0ceb               L7401:
3361  0ceb aefffb        	ldw	x,#65531
3362  0cee bf02          	ldw	c_lreg+2,x
3363  0cf0 aeffff        	ldw	x,#-1
3364  0cf3 bf00          	ldw	c_lreg,x
3366  0cf5               L651:
3368  0cf5 5b0e          	addw	sp,#14
3369  0cf7 81            	ret
3370                     ; 555       case Sn_MR_UDP:
3370                     ; 556       case Sn_MR_MACRAW:
3370                     ; 557       case Sn_MR_IPRAW:
3370                     ; 558          break;         
3372  0cf8               L3411:
3373  0cf8               L5411:
3374                     ; 567    CHECK_SOCKDATA();
3376  0cf8 1e13          	ldw	x,(OFST+6,sp)
3377  0cfa 260c          	jrne	L1511
3380  0cfc aefff2        	ldw	x,#65522
3381  0cff bf02          	ldw	c_lreg+2,x
3382  0d01 aeffff        	ldw	x,#-1
3383  0d04 bf00          	ldw	c_lreg,x
3385  0d06 20ed          	jra	L651
3386  0d08               L1511:
3387                     ; 568    if(sock_remained_size[sn] == 0)
3390  0d08 7b0e          	ld	a,(OFST+1,sp)
3391  0d0a 5f            	clrw	x
3392  0d0b 97            	ld	xl,a
3393  0d0c 58            	sllw	x
3394  0d0d e607          	ld	a,(L11_sock_remained_size+1,x)
3395  0d0f ea06          	or	a,(L11_sock_remained_size,x)
3396  0d11 265c          	jrne	L3511
3397  0d13               L5511:
3398                     ; 572          pack_len = getSn_RX_RSR(sn);
3400  0d13 7b0e          	ld	a,(OFST+1,sp)
3401  0d15 cd0000        	call	_getSn_RX_RSR
3403  0d18 1f0c          	ldw	(OFST-1,sp),x
3405                     ; 573          if(getSn_SR(sn) == SOCK_CLOSED) return SOCKERR_SOCKCLOSED;
3407  0d1a 7b0e          	ld	a,(OFST+1,sp)
3408  0d1c 97            	ld	xl,a
3409  0d1d a604          	ld	a,#4
3410  0d1f 42            	mul	x,a
3411  0d20 58            	sllw	x
3412  0d21 58            	sllw	x
3413  0d22 58            	sllw	x
3414  0d23 1c0308        	addw	x,#776
3415  0d26 cd0000        	call	c_itolx
3417  0d29 be02          	ldw	x,c_lreg+2
3418  0d2b 89            	pushw	x
3419  0d2c be00          	ldw	x,c_lreg
3420  0d2e 89            	pushw	x
3421  0d2f cd0000        	call	_WIZCHIP_READ
3423  0d32 5b04          	addw	sp,#4
3424  0d34 4d            	tnz	a
3425  0d35 260c          	jrne	L1611
3428  0d37 aefffc        	ldw	x,#65532
3429  0d3a bf02          	ldw	c_lreg+2,x
3430  0d3c aeffff        	ldw	x,#-1
3431  0d3f bf00          	ldw	c_lreg,x
3433  0d41 20b2          	jra	L651
3434  0d43               L1611:
3435                     ; 574          if( (sock_io_mode & (1<<sn)) && (pack_len == 0) ) return SOCK_BUSY;
3437  0d43 ae0001        	ldw	x,#1
3438  0d46 7b0e          	ld	a,(OFST+1,sp)
3439  0d48 4d            	tnz	a
3440  0d49 2704          	jreq	L241
3441  0d4b               L441:
3442  0d4b 58            	sllw	x
3443  0d4c 4a            	dec	a
3444  0d4d 26fc          	jrne	L441
3445  0d4f               L241:
3446  0d4f 01            	rrwa	x,a
3447  0d50 b403          	and	a,L5_sock_io_mode+1
3448  0d52 01            	rrwa	x,a
3449  0d53 b402          	and	a,L5_sock_io_mode
3450  0d55 01            	rrwa	x,a
3451  0d56 a30000        	cpw	x,#0
3452  0d59 2710          	jreq	L3611
3454  0d5b 1e0c          	ldw	x,(OFST-1,sp)
3455  0d5d 260c          	jrne	L3611
3458  0d5f ae0000        	ldw	x,#0
3459  0d62 bf02          	ldw	c_lreg+2,x
3460  0d64 ae0000        	ldw	x,#0
3461  0d67 bf00          	ldw	c_lreg,x
3463  0d69 208a          	jra	L651
3464  0d6b               L3611:
3465                     ; 575          if(pack_len != 0) break;
3467  0d6b 1e0c          	ldw	x,(OFST-1,sp)
3468  0d6d 27a4          	jreq	L5511
3471  0d6f               L3511:
3472                     ; 580 	switch (mr & 0x07)
3474  0d6f 7b03          	ld	a,(OFST-10,sp)
3475  0d71 a407          	and	a,#7
3477                     ; 684          break;
3478  0d73 a002          	sub	a,#2
3479  0d75 2722          	jreq	L1501
3480  0d77 4a            	dec	a
3481  0d78 2603          	jrne	L061
3482  0d7a cc0f62        	jp	L5501
3483  0d7d               L061:
3484  0d7d 4a            	dec	a
3485  0d7e 2603          	jrne	L261
3486  0d80 cc0e86        	jp	L3501
3487  0d83               L261:
3488  0d83               L7501:
3489                     ; 681       default:
3489                     ; 682          wiz_recv_ignore(sn, pack_len); // data copy.
3491  0d83 1e0c          	ldw	x,(OFST-1,sp)
3492  0d85 89            	pushw	x
3493  0d86 7b10          	ld	a,(OFST+3,sp)
3494  0d88 cd0000        	call	_wiz_recv_ignore
3496  0d8b 85            	popw	x
3497                     ; 683          sock_remained_size[sn] = pack_len;
3499  0d8c 7b0e          	ld	a,(OFST+1,sp)
3500  0d8e 5f            	clrw	x
3501  0d8f 97            	ld	xl,a
3502  0d90 58            	sllw	x
3503  0d91 160c          	ldw	y,(OFST-1,sp)
3504  0d93 ef06          	ldw	(L11_sock_remained_size,x),y
3505                     ; 684          break;
3507  0d95 ac2e102e      	jpf	L1711
3508  0d99               L1501:
3509                     ; 582 	   case Sn_MR_UDP :
3509                     ; 583 	      if(sock_remained_size[sn] == 0)
3511  0d99 7b0e          	ld	a,(OFST+1,sp)
3512  0d9b 5f            	clrw	x
3513  0d9c 97            	ld	xl,a
3514  0d9d 58            	sllw	x
3515  0d9e e607          	ld	a,(L11_sock_remained_size+1,x)
3516  0da0 ea06          	or	a,(L11_sock_remained_size,x)
3517  0da2 2703          	jreq	L461
3518  0da4 cc0e53        	jp	L3711
3519  0da7               L461:
3520                     ; 585    			wiz_recv_data(sn, head, 8);
3522  0da7 ae0008        	ldw	x,#8
3523  0daa 89            	pushw	x
3524  0dab 96            	ldw	x,sp
3525  0dac 1c0006        	addw	x,#OFST-7
3526  0daf 89            	pushw	x
3527  0db0 7b12          	ld	a,(OFST+5,sp)
3528  0db2 cd0000        	call	_wiz_recv_data
3530  0db5 5b04          	addw	sp,#4
3531                     ; 586    			setSn_CR(sn,Sn_CR_RECV);
3533  0db7 4b40          	push	#64
3534  0db9 7b0f          	ld	a,(OFST+2,sp)
3535  0dbb 97            	ld	xl,a
3536  0dbc a604          	ld	a,#4
3537  0dbe 42            	mul	x,a
3538  0dbf 58            	sllw	x
3539  0dc0 58            	sllw	x
3540  0dc1 58            	sllw	x
3541  0dc2 1c0108        	addw	x,#264
3542  0dc5 cd0000        	call	c_itolx
3544  0dc8 be02          	ldw	x,c_lreg+2
3545  0dca 89            	pushw	x
3546  0dcb be00          	ldw	x,c_lreg
3547  0dcd 89            	pushw	x
3548  0dce cd0000        	call	_WIZCHIP_WRITE
3550  0dd1 5b05          	addw	sp,#5
3552  0dd3               L7711:
3553                     ; 587    			while(getSn_CR(sn));
3555  0dd3 7b0e          	ld	a,(OFST+1,sp)
3556  0dd5 97            	ld	xl,a
3557  0dd6 a604          	ld	a,#4
3558  0dd8 42            	mul	x,a
3559  0dd9 58            	sllw	x
3560  0dda 58            	sllw	x
3561  0ddb 58            	sllw	x
3562  0ddc 1c0108        	addw	x,#264
3563  0ddf cd0000        	call	c_itolx
3565  0de2 be02          	ldw	x,c_lreg+2
3566  0de4 89            	pushw	x
3567  0de5 be00          	ldw	x,c_lreg
3568  0de7 89            	pushw	x
3569  0de8 cd0000        	call	_WIZCHIP_READ
3571  0deb 5b04          	addw	sp,#4
3572  0ded 4d            	tnz	a
3573  0dee 26e3          	jrne	L7711
3574                     ; 605                addr[0] = head[0];
3576  0df0 7b04          	ld	a,(OFST-9,sp)
3577  0df2 1e15          	ldw	x,(OFST+8,sp)
3578  0df4 f7            	ld	(x),a
3579                     ; 606       			addr[1] = head[1];
3581  0df5 7b05          	ld	a,(OFST-8,sp)
3582  0df7 1e15          	ldw	x,(OFST+8,sp)
3583  0df9 e701          	ld	(1,x),a
3584                     ; 607       			addr[2] = head[2];
3586  0dfb 7b06          	ld	a,(OFST-7,sp)
3587  0dfd 1e15          	ldw	x,(OFST+8,sp)
3588  0dff e702          	ld	(2,x),a
3589                     ; 608       			addr[3] = head[3];
3591  0e01 7b07          	ld	a,(OFST-6,sp)
3592  0e03 1e15          	ldw	x,(OFST+8,sp)
3593  0e05 e703          	ld	(3,x),a
3594                     ; 609       			*port = head[4];
3596  0e07 7b08          	ld	a,(OFST-5,sp)
3597  0e09 5f            	clrw	x
3598  0e0a 97            	ld	xl,a
3599  0e0b 1617          	ldw	y,(OFST+10,sp)
3600  0e0d 90ff          	ldw	(y),x
3601                     ; 610       			*port = (*port << 8) + head[5];
3603  0e0f 1e17          	ldw	x,(OFST+10,sp)
3604  0e11 fe            	ldw	x,(x)
3605  0e12 4f            	clr	a
3606  0e13 02            	rlwa	x,a
3607  0e14 01            	rrwa	x,a
3608  0e15 1b09          	add	a,(OFST-4,sp)
3609  0e17 2401          	jrnc	L641
3610  0e19 5c            	incw	x
3611  0e1a               L641:
3612  0e1a 1617          	ldw	y,(OFST+10,sp)
3613  0e1c 02            	rlwa	x,a
3614  0e1d 90ff          	ldw	(y),x
3615  0e1f 01            	rrwa	x,a
3616                     ; 611       			sock_remained_size[sn] = head[6];
3618  0e20 7b0a          	ld	a,(OFST-3,sp)
3619  0e22 5f            	clrw	x
3620  0e23 97            	ld	xl,a
3621  0e24 7b0e          	ld	a,(OFST+1,sp)
3622  0e26 905f          	clrw	y
3623  0e28 9097          	ld	yl,a
3624  0e2a 9058          	sllw	y
3625  0e2c 90ef06        	ldw	(L11_sock_remained_size,y),x
3626                     ; 612       			sock_remained_size[sn] = (sock_remained_size[sn] << 8) + head[7];
3628  0e2f 7b0e          	ld	a,(OFST+1,sp)
3629  0e31 5f            	clrw	x
3630  0e32 97            	ld	xl,a
3631  0e33 58            	sllw	x
3632  0e34 ee06          	ldw	x,(L11_sock_remained_size,x)
3633  0e36 4f            	clr	a
3634  0e37 02            	rlwa	x,a
3635  0e38 01            	rrwa	x,a
3636  0e39 1b0b          	add	a,(OFST-2,sp)
3637  0e3b 2401          	jrnc	L051
3638  0e3d 5c            	incw	x
3639  0e3e               L051:
3640  0e3e 02            	rlwa	x,a
3641  0e3f 1f01          	ldw	(OFST-12,sp),x
3642  0e41 01            	rrwa	x,a
3644  0e42 7b0e          	ld	a,(OFST+1,sp)
3645  0e44 5f            	clrw	x
3646  0e45 97            	ld	xl,a
3647  0e46 58            	sllw	x
3648  0e47 1601          	ldw	y,(OFST-12,sp)
3649  0e49 ef06          	ldw	(L11_sock_remained_size,x),y
3650                     ; 616    			sock_pack_info[sn] = PACK_FIRST;
3652  0e4b 7b0e          	ld	a,(OFST+1,sp)
3653  0e4d 5f            	clrw	x
3654  0e4e 97            	ld	xl,a
3655  0e4f a680          	ld	a,#128
3656  0e51 e716          	ld	(_sock_pack_info,x),a
3657  0e53               L3711:
3658                     ; 618 			if(len < sock_remained_size[sn]) pack_len = len;
3660  0e53 7b0e          	ld	a,(OFST+1,sp)
3661  0e55 5f            	clrw	x
3662  0e56 97            	ld	xl,a
3663  0e57 58            	sllw	x
3664  0e58 9093          	ldw	y,x
3665  0e5a 51            	exgw	x,y
3666  0e5b ee06          	ldw	x,(L11_sock_remained_size,x)
3667  0e5d 1313          	cpw	x,(OFST+6,sp)
3668  0e5f 51            	exgw	x,y
3669  0e60 2306          	jrule	L3021
3672  0e62 1e13          	ldw	x,(OFST+6,sp)
3673  0e64 1f0c          	ldw	(OFST-1,sp),x
3676  0e66 2009          	jra	L5021
3677  0e68               L3021:
3678                     ; 619 			else pack_len = sock_remained_size[sn];
3680  0e68 7b0e          	ld	a,(OFST+1,sp)
3681  0e6a 5f            	clrw	x
3682  0e6b 97            	ld	xl,a
3683  0e6c 58            	sllw	x
3684  0e6d ee06          	ldw	x,(L11_sock_remained_size,x)
3685  0e6f 1f0c          	ldw	(OFST-1,sp),x
3687  0e71               L5021:
3688                     ; 621 			len = pack_len;
3690  0e71 1e0c          	ldw	x,(OFST-1,sp)
3691  0e73 1f13          	ldw	(OFST+6,sp),x
3692                     ; 634    		wiz_recv_data(sn, buf, pack_len); // data copy.
3694  0e75 1e0c          	ldw	x,(OFST-1,sp)
3695  0e77 89            	pushw	x
3696  0e78 1e13          	ldw	x,(OFST+6,sp)
3697  0e7a 89            	pushw	x
3698  0e7b 7b12          	ld	a,(OFST+5,sp)
3699  0e7d cd0000        	call	_wiz_recv_data
3701  0e80 5b04          	addw	sp,#4
3702                     ; 635 			break;
3704  0e82 ac2e102e      	jpf	L1711
3705  0e86               L3501:
3706                     ; 636 	   case Sn_MR_MACRAW :
3706                     ; 637 	      if(sock_remained_size[sn] == 0)
3708  0e86 7b0e          	ld	a,(OFST+1,sp)
3709  0e88 5f            	clrw	x
3710  0e89 97            	ld	xl,a
3711  0e8a 58            	sllw	x
3712  0e8b e607          	ld	a,(L11_sock_remained_size+1,x)
3713  0e8d ea06          	or	a,(L11_sock_remained_size,x)
3714  0e8f 2703          	jreq	L661
3715  0e91 cc0f33        	jp	L7021
3716  0e94               L661:
3717                     ; 639    			wiz_recv_data(sn, head, 2);
3719  0e94 ae0002        	ldw	x,#2
3720  0e97 89            	pushw	x
3721  0e98 96            	ldw	x,sp
3722  0e99 1c0006        	addw	x,#OFST-7
3723  0e9c 89            	pushw	x
3724  0e9d 7b12          	ld	a,(OFST+5,sp)
3725  0e9f cd0000        	call	_wiz_recv_data
3727  0ea2 5b04          	addw	sp,#4
3728                     ; 640    			setSn_CR(sn,Sn_CR_RECV);
3730  0ea4 4b40          	push	#64
3731  0ea6 7b0f          	ld	a,(OFST+2,sp)
3732  0ea8 97            	ld	xl,a
3733  0ea9 a604          	ld	a,#4
3734  0eab 42            	mul	x,a
3735  0eac 58            	sllw	x
3736  0ead 58            	sllw	x
3737  0eae 58            	sllw	x
3738  0eaf 1c0108        	addw	x,#264
3739  0eb2 cd0000        	call	c_itolx
3741  0eb5 be02          	ldw	x,c_lreg+2
3742  0eb7 89            	pushw	x
3743  0eb8 be00          	ldw	x,c_lreg
3744  0eba 89            	pushw	x
3745  0ebb cd0000        	call	_WIZCHIP_WRITE
3747  0ebe 5b05          	addw	sp,#5
3749  0ec0               L3121:
3750                     ; 641    			while(getSn_CR(sn));
3752  0ec0 7b0e          	ld	a,(OFST+1,sp)
3753  0ec2 97            	ld	xl,a
3754  0ec3 a604          	ld	a,#4
3755  0ec5 42            	mul	x,a
3756  0ec6 58            	sllw	x
3757  0ec7 58            	sllw	x
3758  0ec8 58            	sllw	x
3759  0ec9 1c0108        	addw	x,#264
3760  0ecc cd0000        	call	c_itolx
3762  0ecf be02          	ldw	x,c_lreg+2
3763  0ed1 89            	pushw	x
3764  0ed2 be00          	ldw	x,c_lreg
3765  0ed4 89            	pushw	x
3766  0ed5 cd0000        	call	_WIZCHIP_READ
3768  0ed8 5b04          	addw	sp,#4
3769  0eda 4d            	tnz	a
3770  0edb 26e3          	jrne	L3121
3771                     ; 643     			sock_remained_size[sn] = head[0];
3773  0edd 7b04          	ld	a,(OFST-9,sp)
3774  0edf 5f            	clrw	x
3775  0ee0 97            	ld	xl,a
3776  0ee1 7b0e          	ld	a,(OFST+1,sp)
3777  0ee3 905f          	clrw	y
3778  0ee5 9097          	ld	yl,a
3779  0ee7 9058          	sllw	y
3780  0ee9 90ef06        	ldw	(L11_sock_remained_size,y),x
3781                     ; 644    			sock_remained_size[sn] = (sock_remained_size[sn] <<8) + head[1];
3783  0eec 7b0e          	ld	a,(OFST+1,sp)
3784  0eee 5f            	clrw	x
3785  0eef 97            	ld	xl,a
3786  0ef0 58            	sllw	x
3787  0ef1 ee06          	ldw	x,(L11_sock_remained_size,x)
3788  0ef3 4f            	clr	a
3789  0ef4 02            	rlwa	x,a
3790  0ef5 01            	rrwa	x,a
3791  0ef6 1b05          	add	a,(OFST-8,sp)
3792  0ef8 2401          	jrnc	L251
3793  0efa 5c            	incw	x
3794  0efb               L251:
3795  0efb 02            	rlwa	x,a
3796  0efc 1f01          	ldw	(OFST-12,sp),x
3797  0efe 01            	rrwa	x,a
3799  0eff 7b0e          	ld	a,(OFST+1,sp)
3800  0f01 5f            	clrw	x
3801  0f02 97            	ld	xl,a
3802  0f03 58            	sllw	x
3803  0f04 1601          	ldw	y,(OFST-12,sp)
3804  0f06 ef06          	ldw	(L11_sock_remained_size,x),y
3805                     ; 645    			if(sock_remained_size[sn] > 1514) 
3807  0f08 7b0e          	ld	a,(OFST+1,sp)
3808  0f0a 5f            	clrw	x
3809  0f0b 97            	ld	xl,a
3810  0f0c 58            	sllw	x
3811  0f0d 9093          	ldw	y,x
3812  0f0f 90ee06        	ldw	y,(L11_sock_remained_size,y)
3813  0f12 90a305eb      	cpw	y,#1515
3814  0f16 2513          	jrult	L7121
3815                     ; 647    			   close(sn);
3817  0f18 7b0e          	ld	a,(OFST+1,sp)
3818  0f1a cd01b0        	call	_close
3820                     ; 648    			   return SOCKFATAL_PACKLEN;
3822  0f1d aefc17        	ldw	x,#64535
3823  0f20 bf02          	ldw	c_lreg+2,x
3824  0f22 aeffff        	ldw	x,#-1
3825  0f25 bf00          	ldw	c_lreg,x
3827  0f27 acf50cf5      	jpf	L651
3828  0f2b               L7121:
3829                     ; 650    			sock_pack_info[sn] = PACK_FIRST;
3831  0f2b 7b0e          	ld	a,(OFST+1,sp)
3832  0f2d 5f            	clrw	x
3833  0f2e 97            	ld	xl,a
3834  0f2f a680          	ld	a,#128
3835  0f31 e716          	ld	(_sock_pack_info,x),a
3836  0f33               L7021:
3837                     ; 652 			if(len < sock_remained_size[sn]) pack_len = len;
3839  0f33 7b0e          	ld	a,(OFST+1,sp)
3840  0f35 5f            	clrw	x
3841  0f36 97            	ld	xl,a
3842  0f37 58            	sllw	x
3843  0f38 9093          	ldw	y,x
3844  0f3a 51            	exgw	x,y
3845  0f3b ee06          	ldw	x,(L11_sock_remained_size,x)
3846  0f3d 1313          	cpw	x,(OFST+6,sp)
3847  0f3f 51            	exgw	x,y
3848  0f40 2306          	jrule	L1221
3851  0f42 1e13          	ldw	x,(OFST+6,sp)
3852  0f44 1f0c          	ldw	(OFST-1,sp),x
3855  0f46 2009          	jra	L3221
3856  0f48               L1221:
3857                     ; 653 			else pack_len = sock_remained_size[sn];
3859  0f48 7b0e          	ld	a,(OFST+1,sp)
3860  0f4a 5f            	clrw	x
3861  0f4b 97            	ld	xl,a
3862  0f4c 58            	sllw	x
3863  0f4d ee06          	ldw	x,(L11_sock_remained_size,x)
3864  0f4f 1f0c          	ldw	(OFST-1,sp),x
3866  0f51               L3221:
3867                     ; 654 			wiz_recv_data(sn,buf,pack_len);
3869  0f51 1e0c          	ldw	x,(OFST-1,sp)
3870  0f53 89            	pushw	x
3871  0f54 1e13          	ldw	x,(OFST+6,sp)
3872  0f56 89            	pushw	x
3873  0f57 7b12          	ld	a,(OFST+5,sp)
3874  0f59 cd0000        	call	_wiz_recv_data
3876  0f5c 5b04          	addw	sp,#4
3877                     ; 655 		   break;
3879  0f5e ac2e102e      	jpf	L1711
3880  0f62               L5501:
3881                     ; 657 		case Sn_MR_IPRAW:
3881                     ; 658 		   if(sock_remained_size[sn] == 0)
3883  0f62 7b0e          	ld	a,(OFST+1,sp)
3884  0f64 5f            	clrw	x
3885  0f65 97            	ld	xl,a
3886  0f66 58            	sllw	x
3887  0f67 e607          	ld	a,(L11_sock_remained_size+1,x)
3888  0f69 ea06          	or	a,(L11_sock_remained_size,x)
3889  0f6b 2703          	jreq	L071
3890  0f6d cc1003        	jp	L5221
3891  0f70               L071:
3892                     ; 660    			wiz_recv_data(sn, head, 6);
3894  0f70 ae0006        	ldw	x,#6
3895  0f73 89            	pushw	x
3896  0f74 96            	ldw	x,sp
3897  0f75 1c0006        	addw	x,#OFST-7
3898  0f78 89            	pushw	x
3899  0f79 7b12          	ld	a,(OFST+5,sp)
3900  0f7b cd0000        	call	_wiz_recv_data
3902  0f7e 5b04          	addw	sp,#4
3903                     ; 661    			setSn_CR(sn,Sn_CR_RECV);
3905  0f80 4b40          	push	#64
3906  0f82 7b0f          	ld	a,(OFST+2,sp)
3907  0f84 97            	ld	xl,a
3908  0f85 a604          	ld	a,#4
3909  0f87 42            	mul	x,a
3910  0f88 58            	sllw	x
3911  0f89 58            	sllw	x
3912  0f8a 58            	sllw	x
3913  0f8b 1c0108        	addw	x,#264
3914  0f8e cd0000        	call	c_itolx
3916  0f91 be02          	ldw	x,c_lreg+2
3917  0f93 89            	pushw	x
3918  0f94 be00          	ldw	x,c_lreg
3919  0f96 89            	pushw	x
3920  0f97 cd0000        	call	_WIZCHIP_WRITE
3922  0f9a 5b05          	addw	sp,#5
3924  0f9c               L1321:
3925                     ; 662    			while(getSn_CR(sn));
3927  0f9c 7b0e          	ld	a,(OFST+1,sp)
3928  0f9e 97            	ld	xl,a
3929  0f9f a604          	ld	a,#4
3930  0fa1 42            	mul	x,a
3931  0fa2 58            	sllw	x
3932  0fa3 58            	sllw	x
3933  0fa4 58            	sllw	x
3934  0fa5 1c0108        	addw	x,#264
3935  0fa8 cd0000        	call	c_itolx
3937  0fab be02          	ldw	x,c_lreg+2
3938  0fad 89            	pushw	x
3939  0fae be00          	ldw	x,c_lreg
3940  0fb0 89            	pushw	x
3941  0fb1 cd0000        	call	_WIZCHIP_READ
3943  0fb4 5b04          	addw	sp,#4
3944  0fb6 4d            	tnz	a
3945  0fb7 26e3          	jrne	L1321
3946                     ; 663    			addr[0] = head[0];
3948  0fb9 7b04          	ld	a,(OFST-9,sp)
3949  0fbb 1e15          	ldw	x,(OFST+8,sp)
3950  0fbd f7            	ld	(x),a
3951                     ; 664    			addr[1] = head[1];
3953  0fbe 7b05          	ld	a,(OFST-8,sp)
3954  0fc0 1e15          	ldw	x,(OFST+8,sp)
3955  0fc2 e701          	ld	(1,x),a
3956                     ; 665    			addr[2] = head[2];
3958  0fc4 7b06          	ld	a,(OFST-7,sp)
3959  0fc6 1e15          	ldw	x,(OFST+8,sp)
3960  0fc8 e702          	ld	(2,x),a
3961                     ; 666    			addr[3] = head[3];
3963  0fca 7b07          	ld	a,(OFST-6,sp)
3964  0fcc 1e15          	ldw	x,(OFST+8,sp)
3965  0fce e703          	ld	(3,x),a
3966                     ; 667    			sock_remained_size[sn] = head[4];
3968  0fd0 7b08          	ld	a,(OFST-5,sp)
3969  0fd2 5f            	clrw	x
3970  0fd3 97            	ld	xl,a
3971  0fd4 7b0e          	ld	a,(OFST+1,sp)
3972  0fd6 905f          	clrw	y
3973  0fd8 9097          	ld	yl,a
3974  0fda 9058          	sllw	y
3975  0fdc 90ef06        	ldw	(L11_sock_remained_size,y),x
3976                     ; 670    			sock_remained_size[sn] = (sock_remained_size[sn] << 8) + head[5];
3978  0fdf 7b0e          	ld	a,(OFST+1,sp)
3979  0fe1 5f            	clrw	x
3980  0fe2 97            	ld	xl,a
3981  0fe3 58            	sllw	x
3982  0fe4 ee06          	ldw	x,(L11_sock_remained_size,x)
3983  0fe6 4f            	clr	a
3984  0fe7 02            	rlwa	x,a
3985  0fe8 01            	rrwa	x,a
3986  0fe9 1b09          	add	a,(OFST-4,sp)
3987  0feb 2401          	jrnc	L451
3988  0fed 5c            	incw	x
3989  0fee               L451:
3990  0fee 02            	rlwa	x,a
3991  0fef 1f01          	ldw	(OFST-12,sp),x
3992  0ff1 01            	rrwa	x,a
3994  0ff2 7b0e          	ld	a,(OFST+1,sp)
3995  0ff4 5f            	clrw	x
3996  0ff5 97            	ld	xl,a
3997  0ff6 58            	sllw	x
3998  0ff7 1601          	ldw	y,(OFST-12,sp)
3999  0ff9 ef06          	ldw	(L11_sock_remained_size,x),y
4000                     ; 671    			sock_pack_info[sn] = PACK_FIRST;
4002  0ffb 7b0e          	ld	a,(OFST+1,sp)
4003  0ffd 5f            	clrw	x
4004  0ffe 97            	ld	xl,a
4005  0fff a680          	ld	a,#128
4006  1001 e716          	ld	(_sock_pack_info,x),a
4007  1003               L5221:
4008                     ; 676 			if(len < sock_remained_size[sn]) pack_len = len;
4010  1003 7b0e          	ld	a,(OFST+1,sp)
4011  1005 5f            	clrw	x
4012  1006 97            	ld	xl,a
4013  1007 58            	sllw	x
4014  1008 9093          	ldw	y,x
4015  100a 51            	exgw	x,y
4016  100b ee06          	ldw	x,(L11_sock_remained_size,x)
4017  100d 1313          	cpw	x,(OFST+6,sp)
4018  100f 51            	exgw	x,y
4019  1010 2306          	jrule	L5321
4022  1012 1e13          	ldw	x,(OFST+6,sp)
4023  1014 1f0c          	ldw	(OFST-1,sp),x
4026  1016 2009          	jra	L7321
4027  1018               L5321:
4028                     ; 677 			else pack_len = sock_remained_size[sn];
4030  1018 7b0e          	ld	a,(OFST+1,sp)
4031  101a 5f            	clrw	x
4032  101b 97            	ld	xl,a
4033  101c 58            	sllw	x
4034  101d ee06          	ldw	x,(L11_sock_remained_size,x)
4035  101f 1f0c          	ldw	(OFST-1,sp),x
4037  1021               L7321:
4038                     ; 678    		wiz_recv_data(sn, buf, pack_len); // data copy.
4040  1021 1e0c          	ldw	x,(OFST-1,sp)
4041  1023 89            	pushw	x
4042  1024 1e13          	ldw	x,(OFST+6,sp)
4043  1026 89            	pushw	x
4044  1027 7b12          	ld	a,(OFST+5,sp)
4045  1029 cd0000        	call	_wiz_recv_data
4047  102c 5b04          	addw	sp,#4
4048                     ; 679 			break;
4050  102e               L1711:
4051                     ; 686 	setSn_CR(sn,Sn_CR_RECV);
4053  102e 4b40          	push	#64
4054  1030 7b0f          	ld	a,(OFST+2,sp)
4055  1032 97            	ld	xl,a
4056  1033 a604          	ld	a,#4
4057  1035 42            	mul	x,a
4058  1036 58            	sllw	x
4059  1037 58            	sllw	x
4060  1038 58            	sllw	x
4061  1039 1c0108        	addw	x,#264
4062  103c cd0000        	call	c_itolx
4064  103f be02          	ldw	x,c_lreg+2
4065  1041 89            	pushw	x
4066  1042 be00          	ldw	x,c_lreg
4067  1044 89            	pushw	x
4068  1045 cd0000        	call	_WIZCHIP_WRITE
4070  1048 5b05          	addw	sp,#5
4072  104a               L3421:
4073                     ; 688 	while(getSn_CR(sn)) ;
4075  104a 7b0e          	ld	a,(OFST+1,sp)
4076  104c 97            	ld	xl,a
4077  104d a604          	ld	a,#4
4078  104f 42            	mul	x,a
4079  1050 58            	sllw	x
4080  1051 58            	sllw	x
4081  1052 58            	sllw	x
4082  1053 1c0108        	addw	x,#264
4083  1056 cd0000        	call	c_itolx
4085  1059 be02          	ldw	x,c_lreg+2
4086  105b 89            	pushw	x
4087  105c be00          	ldw	x,c_lreg
4088  105e 89            	pushw	x
4089  105f cd0000        	call	_WIZCHIP_READ
4091  1062 5b04          	addw	sp,#4
4092  1064 4d            	tnz	a
4093  1065 26e3          	jrne	L3421
4094                     ; 689 	sock_remained_size[sn] -= pack_len;
4096  1067 7b0e          	ld	a,(OFST+1,sp)
4097  1069 5f            	clrw	x
4098  106a 97            	ld	xl,a
4099  106b 58            	sllw	x
4100  106c 9093          	ldw	y,x
4101  106e ee06          	ldw	x,(L11_sock_remained_size,x)
4102  1070 72f00c        	subw	x,(OFST-1,sp)
4103  1073 90ef06        	ldw	(L11_sock_remained_size,y),x
4104                     ; 692 	if(sock_remained_size[sn] != 0)
4106  1076 7b0e          	ld	a,(OFST+1,sp)
4107  1078 5f            	clrw	x
4108  1079 97            	ld	xl,a
4109  107a 58            	sllw	x
4110  107b e607          	ld	a,(L11_sock_remained_size+1,x)
4111  107d ea06          	or	a,(L11_sock_remained_size,x)
4112  107f 270c          	jreq	L7421
4113                     ; 694 	   sock_pack_info[sn] |= PACK_REMAINED;
4115  1081 7b0e          	ld	a,(OFST+1,sp)
4116  1083 5f            	clrw	x
4117  1084 97            	ld	xl,a
4118  1085 e616          	ld	a,(_sock_pack_info,x)
4119  1087 aa01          	or	a,#1
4120  1089 e716          	ld	(_sock_pack_info,x),a
4122  108b 2006          	jra	L1521
4123  108d               L7421:
4124                     ; 699 	else sock_pack_info[sn] = PACK_COMPLETED;
4126  108d 7b0e          	ld	a,(OFST+1,sp)
4127  108f 5f            	clrw	x
4128  1090 97            	ld	xl,a
4129  1091 6f16          	clr	(_sock_pack_info,x)
4130  1093               L1521:
4131                     ; 706    return (int32_t)pack_len;
4133  1093 1e0c          	ldw	x,(OFST-1,sp)
4134  1095 cd0000        	call	c_uitolx
4137  1098 acf50cf5      	jpf	L651
4265                     ; 710 int8_t  ctlsocket(uint8_t sn, ctlsock_type cstype, void* arg)
4265                     ; 711 {
4266                     	switch	.text
4267  109c               _ctlsocket:
4269  109c 89            	pushw	x
4270  109d 88            	push	a
4271       00000001      OFST:	set	1
4274                     ; 712    uint8_t tmp = 0;
4276                     ; 713    CHECK_SOCKNUM();
4278  109e 7b02          	ld	a,(OFST+1,sp)
4279  10a0 a109          	cp	a,#9
4280  10a2 2504          	jrult	L7531
4283  10a4 a6ff          	ld	a,#255
4285  10a6 202e          	jra	L012
4286  10a8               L7531:
4287                     ; 714    switch(cstype)
4290  10a8 7b03          	ld	a,(OFST+2,sp)
4292                     ; 750       default:
4292                     ; 751          return SOCKERR_ARG;
4293  10aa 4d            	tnz	a
4294  10ab 272c          	jreq	L3521
4295  10ad 4a            	dec	a
4296  10ae 276f          	jreq	L5521
4297  10b0 4a            	dec	a
4298  10b1 2603          	jrne	L212
4299  10b3 cc1135        	jp	L7521
4300  10b6               L212:
4301  10b6 4a            	dec	a
4302  10b7 2603          	jrne	L412
4303  10b9 cc115d        	jp	L1621
4304  10bc               L412:
4305  10bc 4a            	dec	a
4306  10bd 2603          	jrne	L612
4307  10bf cc1185        	jp	L3621
4308  10c2               L612:
4309  10c2 4a            	dec	a
4310  10c3 2603          	jrne	L022
4311  10c5 cc11b4        	jp	L5621
4312  10c8               L022:
4313  10c8 4a            	dec	a
4314  10c9 2603          	jrne	L222
4315  10cb cc11d5        	jp	L7621
4316  10ce               L222:
4317  10ce 4a            	dec	a
4318  10cf 2603          	jrne	L422
4319  10d1 cc1204        	jp	L1721
4320  10d4               L422:
4321  10d4               L3721:
4324  10d4 a6f6          	ld	a,#246
4326  10d6               L012:
4328  10d6 5b03          	addw	sp,#3
4329  10d8 81            	ret
4330  10d9               L3521:
4331                     ; 716       case CS_SET_IOMODE:
4331                     ; 717          tmp = *((uint8_t*)arg);
4333  10d9 1e06          	ldw	x,(OFST+5,sp)
4334  10db f6            	ld	a,(x)
4335  10dc 6b01          	ld	(OFST+0,sp),a
4337                     ; 718          if(tmp == SOCK_IO_NONBLOCK)  sock_io_mode |= (1<<sn);
4339  10de 7b01          	ld	a,(OFST+0,sp)
4340  10e0 a101          	cp	a,#1
4341  10e2 2619          	jrne	L5631
4344  10e4 ae0001        	ldw	x,#1
4345  10e7 7b02          	ld	a,(OFST+1,sp)
4346  10e9 4d            	tnz	a
4347  10ea 2704          	jreq	L471
4348  10ec               L671:
4349  10ec 58            	sllw	x
4350  10ed 4a            	dec	a
4351  10ee 26fc          	jrne	L671
4352  10f0               L471:
4353  10f0 01            	rrwa	x,a
4354  10f1 ba03          	or	a,L5_sock_io_mode+1
4355  10f3 01            	rrwa	x,a
4356  10f4 ba02          	or	a,L5_sock_io_mode
4357  10f6 01            	rrwa	x,a
4358  10f7 bf02          	ldw	L5_sock_io_mode,x
4360  10f9 ac231223      	jpf	L3631
4361  10fd               L5631:
4362                     ; 719          else if(tmp == SOCK_IO_BLOCK) sock_io_mode &= ~(1<<sn);
4364  10fd 0d01          	tnz	(OFST+0,sp)
4365  10ff 261a          	jrne	L1731
4368  1101 ae0001        	ldw	x,#1
4369  1104 7b02          	ld	a,(OFST+1,sp)
4370  1106 4d            	tnz	a
4371  1107 2704          	jreq	L002
4372  1109               L202:
4373  1109 58            	sllw	x
4374  110a 4a            	dec	a
4375  110b 26fc          	jrne	L202
4376  110d               L002:
4377  110d 53            	cplw	x
4378  110e 01            	rrwa	x,a
4379  110f b403          	and	a,L5_sock_io_mode+1
4380  1111 01            	rrwa	x,a
4381  1112 b402          	and	a,L5_sock_io_mode
4382  1114 01            	rrwa	x,a
4383  1115 bf02          	ldw	L5_sock_io_mode,x
4385  1117 ac231223      	jpf	L3631
4386  111b               L1731:
4387                     ; 720          else return SOCKERR_ARG;
4389  111b a6f6          	ld	a,#246
4391  111d 20b7          	jra	L012
4392  111f               L5521:
4393                     ; 722       case CS_GET_IOMODE:   
4393                     ; 723          //M20140501 : implict type casting -> explict type casting
4393                     ; 724          //*((uint8_t*)arg) = (sock_io_mode >> sn) & 0x0001;
4393                     ; 725          *((uint8_t*)arg) = (uint8_t)((sock_io_mode >> sn) & 0x0001);
4395  111f be02          	ldw	x,L5_sock_io_mode
4396  1121 7b02          	ld	a,(OFST+1,sp)
4397  1123 4d            	tnz	a
4398  1124 2704          	jreq	L402
4399  1126               L602:
4400  1126 54            	srlw	x
4401  1127 4a            	dec	a
4402  1128 26fc          	jrne	L602
4403  112a               L402:
4404  112a 01            	rrwa	x,a
4405  112b a401          	and	a,#1
4406  112d 5f            	clrw	x
4407  112e 1e06          	ldw	x,(OFST+5,sp)
4408  1130 f7            	ld	(x),a
4409                     ; 727          break;
4411  1131 ac231223      	jpf	L3631
4412  1135               L7521:
4413                     ; 728       case CS_GET_MAXTXBUF:
4413                     ; 729          *((uint16_t*)arg) = getSn_TxMAX(sn);
4415  1135 7b02          	ld	a,(OFST+1,sp)
4416  1137 97            	ld	xl,a
4417  1138 a604          	ld	a,#4
4418  113a 42            	mul	x,a
4419  113b 58            	sllw	x
4420  113c 58            	sllw	x
4421  113d 58            	sllw	x
4422  113e 1c1f08        	addw	x,#7944
4423  1141 cd0000        	call	c_itolx
4425  1144 be02          	ldw	x,c_lreg+2
4426  1146 89            	pushw	x
4427  1147 be00          	ldw	x,c_lreg
4428  1149 89            	pushw	x
4429  114a cd0000        	call	_WIZCHIP_READ
4431  114d 5b04          	addw	sp,#4
4432  114f 5f            	clrw	x
4433  1150 97            	ld	xl,a
4434  1151 4f            	clr	a
4435  1152 02            	rlwa	x,a
4436  1153 58            	sllw	x
4437  1154 58            	sllw	x
4438  1155 1606          	ldw	y,(OFST+5,sp)
4439  1157 90ff          	ldw	(y),x
4440                     ; 730          break;
4442  1159 ac231223      	jpf	L3631
4443  115d               L1621:
4444                     ; 731       case CS_GET_MAXRXBUF:    
4444                     ; 732          *((uint16_t*)arg) = getSn_RxMAX(sn);
4446  115d 7b02          	ld	a,(OFST+1,sp)
4447  115f 97            	ld	xl,a
4448  1160 a604          	ld	a,#4
4449  1162 42            	mul	x,a
4450  1163 58            	sllw	x
4451  1164 58            	sllw	x
4452  1165 58            	sllw	x
4453  1166 1c1e08        	addw	x,#7688
4454  1169 cd0000        	call	c_itolx
4456  116c be02          	ldw	x,c_lreg+2
4457  116e 89            	pushw	x
4458  116f be00          	ldw	x,c_lreg
4459  1171 89            	pushw	x
4460  1172 cd0000        	call	_WIZCHIP_READ
4462  1175 5b04          	addw	sp,#4
4463  1177 5f            	clrw	x
4464  1178 97            	ld	xl,a
4465  1179 4f            	clr	a
4466  117a 02            	rlwa	x,a
4467  117b 58            	sllw	x
4468  117c 58            	sllw	x
4469  117d 1606          	ldw	y,(OFST+5,sp)
4470  117f 90ff          	ldw	(y),x
4471                     ; 733          break;
4473  1181 ac231223      	jpf	L3631
4474  1185               L3621:
4475                     ; 734       case CS_CLR_INTERRUPT:
4475                     ; 735          if( (*(uint8_t*)arg) > SIK_ALL) return SOCKERR_ARG;
4477  1185 1e06          	ldw	x,(OFST+5,sp)
4478  1187 f6            	ld	a,(x)
4479  1188 a120          	cp	a,#32
4480  118a 2506          	jrult	L5731
4483  118c a6f6          	ld	a,#246
4485  118e acd610d6      	jpf	L012
4486  1192               L5731:
4487                     ; 736          setSn_IR(sn,*(uint8_t*)arg);
4489  1192 1e06          	ldw	x,(OFST+5,sp)
4490  1194 f6            	ld	a,(x)
4491  1195 a41f          	and	a,#31
4492  1197 88            	push	a
4493  1198 7b03          	ld	a,(OFST+2,sp)
4494  119a 97            	ld	xl,a
4495  119b a604          	ld	a,#4
4496  119d 42            	mul	x,a
4497  119e 58            	sllw	x
4498  119f 58            	sllw	x
4499  11a0 58            	sllw	x
4500  11a1 1c0208        	addw	x,#520
4501  11a4 cd0000        	call	c_itolx
4503  11a7 be02          	ldw	x,c_lreg+2
4504  11a9 89            	pushw	x
4505  11aa be00          	ldw	x,c_lreg
4506  11ac 89            	pushw	x
4507  11ad cd0000        	call	_WIZCHIP_WRITE
4509  11b0 5b05          	addw	sp,#5
4510                     ; 737          break;
4512  11b2 206f          	jra	L3631
4513  11b4               L5621:
4514                     ; 738       case CS_GET_INTERRUPT:
4514                     ; 739          *((uint8_t*)arg) = getSn_IR(sn);
4516  11b4 7b02          	ld	a,(OFST+1,sp)
4517  11b6 97            	ld	xl,a
4518  11b7 a604          	ld	a,#4
4519  11b9 42            	mul	x,a
4520  11ba 58            	sllw	x
4521  11bb 58            	sllw	x
4522  11bc 58            	sllw	x
4523  11bd 1c0208        	addw	x,#520
4524  11c0 cd0000        	call	c_itolx
4526  11c3 be02          	ldw	x,c_lreg+2
4527  11c5 89            	pushw	x
4528  11c6 be00          	ldw	x,c_lreg
4529  11c8 89            	pushw	x
4530  11c9 cd0000        	call	_WIZCHIP_READ
4532  11cc 5b04          	addw	sp,#4
4533  11ce a41f          	and	a,#31
4534  11d0 1e06          	ldw	x,(OFST+5,sp)
4535  11d2 f7            	ld	(x),a
4536                     ; 740          break;
4538  11d3 204e          	jra	L3631
4539  11d5               L7621:
4540                     ; 742       case CS_SET_INTMASK:  
4540                     ; 743          if( (*(uint8_t*)arg) > SIK_ALL) return SOCKERR_ARG;
4542  11d5 1e06          	ldw	x,(OFST+5,sp)
4543  11d7 f6            	ld	a,(x)
4544  11d8 a120          	cp	a,#32
4545  11da 2506          	jrult	L7731
4548  11dc a6f6          	ld	a,#246
4550  11de acd610d6      	jpf	L012
4551  11e2               L7731:
4552                     ; 744          setSn_IMR(sn,*(uint8_t*)arg);
4554  11e2 1e06          	ldw	x,(OFST+5,sp)
4555  11e4 f6            	ld	a,(x)
4556  11e5 a41f          	and	a,#31
4557  11e7 88            	push	a
4558  11e8 7b03          	ld	a,(OFST+2,sp)
4559  11ea 97            	ld	xl,a
4560  11eb a604          	ld	a,#4
4561  11ed 42            	mul	x,a
4562  11ee 58            	sllw	x
4563  11ef 58            	sllw	x
4564  11f0 58            	sllw	x
4565  11f1 1c2c08        	addw	x,#11272
4566  11f4 cd0000        	call	c_itolx
4568  11f7 be02          	ldw	x,c_lreg+2
4569  11f9 89            	pushw	x
4570  11fa be00          	ldw	x,c_lreg
4571  11fc 89            	pushw	x
4572  11fd cd0000        	call	_WIZCHIP_WRITE
4574  1200 5b05          	addw	sp,#5
4575                     ; 745          break;
4577  1202 201f          	jra	L3631
4578  1204               L1721:
4579                     ; 746       case CS_GET_INTMASK:   
4579                     ; 747          *((uint8_t*)arg) = getSn_IMR(sn);
4581  1204 7b02          	ld	a,(OFST+1,sp)
4582  1206 97            	ld	xl,a
4583  1207 a604          	ld	a,#4
4584  1209 42            	mul	x,a
4585  120a 58            	sllw	x
4586  120b 58            	sllw	x
4587  120c 58            	sllw	x
4588  120d 1c2c08        	addw	x,#11272
4589  1210 cd0000        	call	c_itolx
4591  1213 be02          	ldw	x,c_lreg+2
4592  1215 89            	pushw	x
4593  1216 be00          	ldw	x,c_lreg
4594  1218 89            	pushw	x
4595  1219 cd0000        	call	_WIZCHIP_READ
4597  121c 5b04          	addw	sp,#4
4598  121e a41f          	and	a,#31
4599  1220 1e06          	ldw	x,(OFST+5,sp)
4600  1222 f7            	ld	(x),a
4601                     ; 748          break;
4603  1223               L3631:
4604                     ; 753    return SOCK_OK;
4606  1223 a601          	ld	a,#1
4608  1225 acd610d6      	jpf	L012
4762                     ; 756 int8_t  setsockopt(uint8_t sn, sockopt_type sotype, void* arg)
4762                     ; 757 {
4763                     	switch	.text
4764  1229               _setsockopt:
4766  1229 89            	pushw	x
4767       00000000      OFST:	set	0
4770                     ; 760    CHECK_SOCKNUM();
4772  122a 7b01          	ld	a,(OFST+1,sp)
4773  122c a109          	cp	a,#9
4774  122e 2504          	jrult	L1151
4777  1230 a6ff          	ld	a,#255
4779  1232 2025          	jra	L032
4780  1234               L1151:
4781                     ; 761    switch(sotype)
4784  1234 7b02          	ld	a,(OFST+2,sp)
4786                     ; 803       default:
4786                     ; 804          return SOCKERR_ARG;
4787  1236 4a            	dec	a
4788  1237 2722          	jreq	L1041
4789  1239 4a            	dec	a
4790  123a 2741          	jreq	L3041
4791  123c 4a            	dec	a
4792  123d 2760          	jreq	L5041
4793  123f 4a            	dec	a
4794  1240 2603          	jrne	L632
4795  1242 cc12e3        	jp	L7041
4796  1245               L632:
4797  1245 4a            	dec	a
4798  1246 2603          	jrne	L042
4799  1248 cc1308        	jp	L1141
4800  124b               L042:
4801  124b 4a            	dec	a
4802  124c 2603          	jrne	L242
4803  124e cc134c        	jp	L7151
4804  1251               L242:
4805  1251 4a            	dec	a
4806  1252 2603          	jrne	L442
4807  1254 cc140e        	jp	L7351
4808  1257               L442:
4809  1257               L7141:
4812  1257 a6f6          	ld	a,#246
4814  1259               L032:
4816  1259 85            	popw	x
4817  125a 81            	ret
4818  125b               L1041:
4819                     ; 763       case SO_TTL:
4819                     ; 764          setSn_TTL(sn,*(uint8_t*)arg);
4821  125b 1e05          	ldw	x,(OFST+5,sp)
4822  125d f6            	ld	a,(x)
4823  125e 88            	push	a
4824  125f 7b02          	ld	a,(OFST+2,sp)
4825  1261 97            	ld	xl,a
4826  1262 a604          	ld	a,#4
4827  1264 42            	mul	x,a
4828  1265 58            	sllw	x
4829  1266 58            	sllw	x
4830  1267 58            	sllw	x
4831  1268 1c1608        	addw	x,#5640
4832  126b cd0000        	call	c_itolx
4834  126e be02          	ldw	x,c_lreg+2
4835  1270 89            	pushw	x
4836  1271 be00          	ldw	x,c_lreg
4837  1273 89            	pushw	x
4838  1274 cd0000        	call	_WIZCHIP_WRITE
4840  1277 5b05          	addw	sp,#5
4841                     ; 765          break;
4843  1279 ac501450      	jpf	L5151
4844  127d               L3041:
4845                     ; 766       case SO_TOS:
4845                     ; 767          setSn_TOS(sn,*(uint8_t*)arg);
4847  127d 1e05          	ldw	x,(OFST+5,sp)
4848  127f f6            	ld	a,(x)
4849  1280 88            	push	a
4850  1281 7b02          	ld	a,(OFST+2,sp)
4851  1283 97            	ld	xl,a
4852  1284 a604          	ld	a,#4
4853  1286 42            	mul	x,a
4854  1287 58            	sllw	x
4855  1288 58            	sllw	x
4856  1289 58            	sllw	x
4857  128a 1c1508        	addw	x,#5384
4858  128d cd0000        	call	c_itolx
4860  1290 be02          	ldw	x,c_lreg+2
4861  1292 89            	pushw	x
4862  1293 be00          	ldw	x,c_lreg
4863  1295 89            	pushw	x
4864  1296 cd0000        	call	_WIZCHIP_WRITE
4866  1299 5b05          	addw	sp,#5
4867                     ; 768          break;
4869  129b ac501450      	jpf	L5151
4870  129f               L5041:
4871                     ; 770          setSn_MSSR(sn,*(uint16_t*)arg);
4873  129f 1e05          	ldw	x,(OFST+5,sp)
4874  12a1 fe            	ldw	x,(x)
4875  12a2 4f            	clr	a
4876  12a3 01            	rrwa	x,a
4877  12a4 9f            	ld	a,xl
4878  12a5 88            	push	a
4879  12a6 7b02          	ld	a,(OFST+2,sp)
4880  12a8 97            	ld	xl,a
4881  12a9 a604          	ld	a,#4
4882  12ab 42            	mul	x,a
4883  12ac 58            	sllw	x
4884  12ad 58            	sllw	x
4885  12ae 58            	sllw	x
4886  12af 1c1208        	addw	x,#4616
4887  12b2 cd0000        	call	c_itolx
4889  12b5 be02          	ldw	x,c_lreg+2
4890  12b7 89            	pushw	x
4891  12b8 be00          	ldw	x,c_lreg
4892  12ba 89            	pushw	x
4893  12bb cd0000        	call	_WIZCHIP_WRITE
4895  12be 5b05          	addw	sp,#5
4898  12c0 1e05          	ldw	x,(OFST+5,sp)
4899  12c2 e601          	ld	a,(1,x)
4900  12c4 88            	push	a
4901  12c5 7b02          	ld	a,(OFST+2,sp)
4902  12c7 97            	ld	xl,a
4903  12c8 a604          	ld	a,#4
4904  12ca 42            	mul	x,a
4905  12cb 58            	sllw	x
4906  12cc 58            	sllw	x
4907  12cd 58            	sllw	x
4908  12ce 1c1308        	addw	x,#4872
4909  12d1 cd0000        	call	c_itolx
4911  12d4 be02          	ldw	x,c_lreg+2
4912  12d6 89            	pushw	x
4913  12d7 be00          	ldw	x,c_lreg
4914  12d9 89            	pushw	x
4915  12da cd0000        	call	_WIZCHIP_WRITE
4917  12dd 5b05          	addw	sp,#5
4918                     ; 771          break;
4921  12df ac501450      	jpf	L5151
4922  12e3               L7041:
4923                     ; 772       case SO_DESTIP:
4923                     ; 773          setSn_DIPR(sn, (uint8_t*)arg);
4925  12e3 ae0004        	ldw	x,#4
4926  12e6 89            	pushw	x
4927  12e7 1e07          	ldw	x,(OFST+7,sp)
4928  12e9 89            	pushw	x
4929  12ea 7b05          	ld	a,(OFST+5,sp)
4930  12ec 97            	ld	xl,a
4931  12ed a604          	ld	a,#4
4932  12ef 42            	mul	x,a
4933  12f0 58            	sllw	x
4934  12f1 58            	sllw	x
4935  12f2 58            	sllw	x
4936  12f3 1c0c08        	addw	x,#3080
4937  12f6 cd0000        	call	c_itolx
4939  12f9 be02          	ldw	x,c_lreg+2
4940  12fb 89            	pushw	x
4941  12fc be00          	ldw	x,c_lreg
4942  12fe 89            	pushw	x
4943  12ff cd0000        	call	_WIZCHIP_WRITE_BUF
4945  1302 5b08          	addw	sp,#8
4946                     ; 774          break;
4948  1304 ac501450      	jpf	L5151
4949  1308               L1141:
4950                     ; 776          setSn_DPORT(sn, *(uint16_t*)arg);
4952  1308 1e05          	ldw	x,(OFST+5,sp)
4953  130a fe            	ldw	x,(x)
4954  130b 4f            	clr	a
4955  130c 01            	rrwa	x,a
4956  130d 9f            	ld	a,xl
4957  130e 88            	push	a
4958  130f 7b02          	ld	a,(OFST+2,sp)
4959  1311 97            	ld	xl,a
4960  1312 a604          	ld	a,#4
4961  1314 42            	mul	x,a
4962  1315 58            	sllw	x
4963  1316 58            	sllw	x
4964  1317 58            	sllw	x
4965  1318 1c1008        	addw	x,#4104
4966  131b cd0000        	call	c_itolx
4968  131e be02          	ldw	x,c_lreg+2
4969  1320 89            	pushw	x
4970  1321 be00          	ldw	x,c_lreg
4971  1323 89            	pushw	x
4972  1324 cd0000        	call	_WIZCHIP_WRITE
4974  1327 5b05          	addw	sp,#5
4977  1329 1e05          	ldw	x,(OFST+5,sp)
4978  132b e601          	ld	a,(1,x)
4979  132d 88            	push	a
4980  132e 7b02          	ld	a,(OFST+2,sp)
4981  1330 97            	ld	xl,a
4982  1331 a604          	ld	a,#4
4983  1333 42            	mul	x,a
4984  1334 58            	sllw	x
4985  1335 58            	sllw	x
4986  1336 58            	sllw	x
4987  1337 1c1108        	addw	x,#4360
4988  133a cd0000        	call	c_itolx
4990  133d be02          	ldw	x,c_lreg+2
4991  133f 89            	pushw	x
4992  1340 be00          	ldw	x,c_lreg
4993  1342 89            	pushw	x
4994  1343 cd0000        	call	_WIZCHIP_WRITE
4996  1346 5b05          	addw	sp,#5
4997                     ; 777          break;
5000  1348 ac501450      	jpf	L5151
5001  134c               L7151:
5002                     ; 780          CHECK_SOCKMODE(Sn_MR_TCP);
5004  134c 7b01          	ld	a,(OFST+1,sp)
5005  134e 97            	ld	xl,a
5006  134f a604          	ld	a,#4
5007  1351 42            	mul	x,a
5008  1352 58            	sllw	x
5009  1353 58            	sllw	x
5010  1354 58            	sllw	x
5011  1355 1c0008        	addw	x,#8
5012  1358 cd0000        	call	c_itolx
5014  135b be02          	ldw	x,c_lreg+2
5015  135d 89            	pushw	x
5016  135e be00          	ldw	x,c_lreg
5017  1360 89            	pushw	x
5018  1361 cd0000        	call	_WIZCHIP_READ
5020  1364 5b04          	addw	sp,#4
5021  1366 a40f          	and	a,#15
5022  1368 a101          	cp	a,#1
5023  136a 2704          	jreq	L3251
5026  136c a6fb          	ld	a,#251
5028  136e 201f          	jra	L232
5029  1370               L3251:
5030                     ; 782             if(getSn_KPALVTR(sn) != 0) return SOCKERR_SOCKOPT;
5033  1370 7b01          	ld	a,(OFST+1,sp)
5034  1372 97            	ld	xl,a
5035  1373 a604          	ld	a,#4
5036  1375 42            	mul	x,a
5037  1376 58            	sllw	x
5038  1377 58            	sllw	x
5039  1378 58            	sllw	x
5040  1379 1c2f08        	addw	x,#12040
5041  137c cd0000        	call	c_itolx
5043  137f be02          	ldw	x,c_lreg+2
5044  1381 89            	pushw	x
5045  1382 be00          	ldw	x,c_lreg
5046  1384 89            	pushw	x
5047  1385 cd0000        	call	_WIZCHIP_READ
5049  1388 5b04          	addw	sp,#4
5050  138a 4d            	tnz	a
5051  138b 2704          	jreq	L5251
5054  138d a6fe          	ld	a,#254
5056  138f               L232:
5058  138f 85            	popw	x
5059  1390 81            	ret
5060  1391               L5251:
5061                     ; 784             setSn_CR(sn,Sn_CR_SEND_KEEP);
5063  1391 4b22          	push	#34
5064  1393 7b02          	ld	a,(OFST+2,sp)
5065  1395 97            	ld	xl,a
5066  1396 a604          	ld	a,#4
5067  1398 42            	mul	x,a
5068  1399 58            	sllw	x
5069  139a 58            	sllw	x
5070  139b 58            	sllw	x
5071  139c 1c0108        	addw	x,#264
5072  139f cd0000        	call	c_itolx
5074  13a2 be02          	ldw	x,c_lreg+2
5075  13a4 89            	pushw	x
5076  13a5 be00          	ldw	x,c_lreg
5077  13a7 89            	pushw	x
5078  13a8 cd0000        	call	_WIZCHIP_WRITE
5080  13ab 5b05          	addw	sp,#5
5082  13ad 2040          	jra	L1351
5083  13af               L7251:
5084                     ; 789                if (getSn_IR(sn) & Sn_IR_TIMEOUT)
5086  13af 7b01          	ld	a,(OFST+1,sp)
5087  13b1 97            	ld	xl,a
5088  13b2 a604          	ld	a,#4
5089  13b4 42            	mul	x,a
5090  13b5 58            	sllw	x
5091  13b6 58            	sllw	x
5092  13b7 58            	sllw	x
5093  13b8 1c0208        	addw	x,#520
5094  13bb cd0000        	call	c_itolx
5096  13be be02          	ldw	x,c_lreg+2
5097  13c0 89            	pushw	x
5098  13c1 be00          	ldw	x,c_lreg
5099  13c3 89            	pushw	x
5100  13c4 cd0000        	call	_WIZCHIP_READ
5102  13c7 5b04          	addw	sp,#4
5103  13c9 a41f          	and	a,#31
5104  13cb a508          	bcp	a,#8
5105  13cd 2720          	jreq	L1351
5106                     ; 791          			setSn_IR(sn, Sn_IR_TIMEOUT);
5108  13cf 4b08          	push	#8
5109  13d1 7b02          	ld	a,(OFST+2,sp)
5110  13d3 97            	ld	xl,a
5111  13d4 a604          	ld	a,#4
5112  13d6 42            	mul	x,a
5113  13d7 58            	sllw	x
5114  13d8 58            	sllw	x
5115  13d9 58            	sllw	x
5116  13da 1c0208        	addw	x,#520
5117  13dd cd0000        	call	c_itolx
5119  13e0 be02          	ldw	x,c_lreg+2
5120  13e2 89            	pushw	x
5121  13e3 be00          	ldw	x,c_lreg
5122  13e5 89            	pushw	x
5123  13e6 cd0000        	call	_WIZCHIP_WRITE
5125  13e9 5b05          	addw	sp,#5
5126                     ; 792                   return SOCKERR_TIMEOUT;
5128  13eb a6f3          	ld	a,#243
5130  13ed 20a0          	jra	L232
5131  13ef               L1351:
5132                     ; 785             while(getSn_CR(sn) != 0)
5134  13ef 7b01          	ld	a,(OFST+1,sp)
5135  13f1 97            	ld	xl,a
5136  13f2 a604          	ld	a,#4
5137  13f4 42            	mul	x,a
5138  13f5 58            	sllw	x
5139  13f6 58            	sllw	x
5140  13f7 58            	sllw	x
5141  13f8 1c0108        	addw	x,#264
5142  13fb cd0000        	call	c_itolx
5144  13fe be02          	ldw	x,c_lreg+2
5145  1400 89            	pushw	x
5146  1401 be00          	ldw	x,c_lreg
5147  1403 89            	pushw	x
5148  1404 cd0000        	call	_WIZCHIP_READ
5150  1407 5b04          	addw	sp,#4
5151  1409 4d            	tnz	a
5152  140a 26a3          	jrne	L7251
5153                     ; 795          break;
5155  140c 2042          	jra	L5151
5156  140e               L7351:
5157                     ; 798          CHECK_SOCKMODE(Sn_MR_TCP);
5159  140e 7b01          	ld	a,(OFST+1,sp)
5160  1410 97            	ld	xl,a
5161  1411 a604          	ld	a,#4
5162  1413 42            	mul	x,a
5163  1414 58            	sllw	x
5164  1415 58            	sllw	x
5165  1416 58            	sllw	x
5166  1417 1c0008        	addw	x,#8
5167  141a cd0000        	call	c_itolx
5169  141d be02          	ldw	x,c_lreg+2
5170  141f 89            	pushw	x
5171  1420 be00          	ldw	x,c_lreg
5172  1422 89            	pushw	x
5173  1423 cd0000        	call	_WIZCHIP_READ
5175  1426 5b04          	addw	sp,#4
5176  1428 a40f          	and	a,#15
5177  142a a101          	cp	a,#1
5178  142c 2704          	jreq	L3451
5181  142e a6fb          	ld	a,#251
5183  1430 2020          	jra	L432
5184  1432               L3451:
5185                     ; 799          setSn_KPALVTR(sn,*(uint8_t*)arg);
5188  1432 1e05          	ldw	x,(OFST+5,sp)
5189  1434 f6            	ld	a,(x)
5190  1435 88            	push	a
5191  1436 7b02          	ld	a,(OFST+2,sp)
5192  1438 97            	ld	xl,a
5193  1439 a604          	ld	a,#4
5194  143b 42            	mul	x,a
5195  143c 58            	sllw	x
5196  143d 58            	sllw	x
5197  143e 58            	sllw	x
5198  143f 1c2f08        	addw	x,#12040
5199  1442 cd0000        	call	c_itolx
5201  1445 be02          	ldw	x,c_lreg+2
5202  1447 89            	pushw	x
5203  1448 be00          	ldw	x,c_lreg
5204  144a 89            	pushw	x
5205  144b cd0000        	call	_WIZCHIP_WRITE
5207  144e 5b05          	addw	sp,#5
5208                     ; 800          break;
5210  1450               L5151:
5211                     ; 806    return SOCK_OK;
5213  1450 a601          	ld	a,#1
5215  1452               L432:
5217  1452 85            	popw	x
5218  1453 81            	ret
5278                     	switch	.const
5279  0004               L652:
5280  0004 1473          	dc.w	L5451
5281  0006 1496          	dc.w	L7451
5282  0008 14b7          	dc.w	L1551
5283  000a 14d8          	dc.w	L3551
5284  000c 151e          	dc.w	L5551
5285  000e 1543          	dc.w	L7551
5286  0010 1678          	dc.w	L5751
5287  0012 158d          	dc.w	L1651
5288  0014 15d6          	dc.w	L3651
5289  0016 15e3          	dc.w	L5651
5290  0018 15f0          	dc.w	L7651
5291  001a 160f          	dc.w	L1751
5292  001c 1647          	dc.w	L3751
5293                     ; 809 int8_t  getsockopt(uint8_t sn, sockopt_type sotype, void* arg)
5293                     ; 810 {
5294                     	switch	.text
5295  1454               _getsockopt:
5297  1454 89            	pushw	x
5298  1455 88            	push	a
5299       00000001      OFST:	set	1
5302                     ; 811    CHECK_SOCKNUM();
5304  1456 7b02          	ld	a,(OFST+1,sp)
5305  1458 a109          	cp	a,#9
5306  145a 2506          	jrult	L1361
5309  145c a6ff          	ld	a,#255
5311  145e acaf15af      	jpf	L062
5312  1462               L1361:
5313                     ; 812    switch(sotype)
5316  1462 7b03          	ld	a,(OFST+2,sp)
5318                     ; 857       default:
5318                     ; 858          return SOCKERR_SOCKOPT;
5319  1464 a10d          	cp	a,#13
5320  1466 2407          	jruge	L452
5321  1468 5f            	clrw	x
5322  1469 97            	ld	xl,a
5323  146a 58            	sllw	x
5324  146b de0004        	ldw	x,(L652,x)
5325  146e fc            	jp	(x)
5326  146f               L452:
5327  146f ac781678      	jpf	L5751
5328  1473               L5451:
5329                     ; 814       case SO_FLAG:
5329                     ; 815          *(uint8_t*)arg = getSn_MR(sn) & 0xF0;
5331  1473 7b02          	ld	a,(OFST+1,sp)
5332  1475 97            	ld	xl,a
5333  1476 a604          	ld	a,#4
5334  1478 42            	mul	x,a
5335  1479 58            	sllw	x
5336  147a 58            	sllw	x
5337  147b 58            	sllw	x
5338  147c 1c0008        	addw	x,#8
5339  147f cd0000        	call	c_itolx
5341  1482 be02          	ldw	x,c_lreg+2
5342  1484 89            	pushw	x
5343  1485 be00          	ldw	x,c_lreg
5344  1487 89            	pushw	x
5345  1488 cd0000        	call	_WIZCHIP_READ
5347  148b 5b04          	addw	sp,#4
5348  148d a4f0          	and	a,#240
5349  148f 1e06          	ldw	x,(OFST+5,sp)
5350  1491 f7            	ld	(x),a
5351                     ; 816          break;
5353  1492 ac7e167e      	jpf	L5361
5354  1496               L7451:
5355                     ; 817       case SO_TTL:
5355                     ; 818          *(uint8_t*) arg = getSn_TTL(sn);
5357  1496 7b02          	ld	a,(OFST+1,sp)
5358  1498 97            	ld	xl,a
5359  1499 a604          	ld	a,#4
5360  149b 42            	mul	x,a
5361  149c 58            	sllw	x
5362  149d 58            	sllw	x
5363  149e 58            	sllw	x
5364  149f 1c1608        	addw	x,#5640
5365  14a2 cd0000        	call	c_itolx
5367  14a5 be02          	ldw	x,c_lreg+2
5368  14a7 89            	pushw	x
5369  14a8 be00          	ldw	x,c_lreg
5370  14aa 89            	pushw	x
5371  14ab cd0000        	call	_WIZCHIP_READ
5373  14ae 5b04          	addw	sp,#4
5374  14b0 1e06          	ldw	x,(OFST+5,sp)
5375  14b2 f7            	ld	(x),a
5376                     ; 819          break;
5378  14b3 ac7e167e      	jpf	L5361
5379  14b7               L1551:
5380                     ; 820       case SO_TOS:
5380                     ; 821          *(uint8_t*) arg = getSn_TOS(sn);
5382  14b7 7b02          	ld	a,(OFST+1,sp)
5383  14b9 97            	ld	xl,a
5384  14ba a604          	ld	a,#4
5385  14bc 42            	mul	x,a
5386  14bd 58            	sllw	x
5387  14be 58            	sllw	x
5388  14bf 58            	sllw	x
5389  14c0 1c1508        	addw	x,#5384
5390  14c3 cd0000        	call	c_itolx
5392  14c6 be02          	ldw	x,c_lreg+2
5393  14c8 89            	pushw	x
5394  14c9 be00          	ldw	x,c_lreg
5395  14cb 89            	pushw	x
5396  14cc cd0000        	call	_WIZCHIP_READ
5398  14cf 5b04          	addw	sp,#4
5399  14d1 1e06          	ldw	x,(OFST+5,sp)
5400  14d3 f7            	ld	(x),a
5401                     ; 822          break;
5403  14d4 ac7e167e      	jpf	L5361
5404  14d8               L3551:
5405                     ; 823       case SO_MSS:   
5405                     ; 824          *(uint8_t*) arg = getSn_MSSR(sn);
5407  14d8 7b02          	ld	a,(OFST+1,sp)
5408  14da 97            	ld	xl,a
5409  14db a604          	ld	a,#4
5410  14dd 42            	mul	x,a
5411  14de 58            	sllw	x
5412  14df 58            	sllw	x
5413  14e0 58            	sllw	x
5414  14e1 1c1308        	addw	x,#4872
5415  14e4 cd0000        	call	c_itolx
5417  14e7 be02          	ldw	x,c_lreg+2
5418  14e9 89            	pushw	x
5419  14ea be00          	ldw	x,c_lreg
5420  14ec 89            	pushw	x
5421  14ed cd0000        	call	_WIZCHIP_READ
5423  14f0 5b04          	addw	sp,#4
5424  14f2 6b01          	ld	(OFST+0,sp),a
5426  14f4 7b02          	ld	a,(OFST+1,sp)
5427  14f6 97            	ld	xl,a
5428  14f7 a604          	ld	a,#4
5429  14f9 42            	mul	x,a
5430  14fa 58            	sllw	x
5431  14fb 58            	sllw	x
5432  14fc 58            	sllw	x
5433  14fd 1c1208        	addw	x,#4616
5434  1500 cd0000        	call	c_itolx
5436  1503 be02          	ldw	x,c_lreg+2
5437  1505 89            	pushw	x
5438  1506 be00          	ldw	x,c_lreg
5439  1508 89            	pushw	x
5440  1509 cd0000        	call	_WIZCHIP_READ
5442  150c 5b04          	addw	sp,#4
5443  150e ae0008        	ldw	x,#8
5444  1511               L052:
5445  1511 48            	sll	a
5446  1512 5a            	decw	x
5447  1513 26fc          	jrne	L052
5448  1515 1b01          	add	a,(OFST+0,sp)
5449  1517 1e06          	ldw	x,(OFST+5,sp)
5450  1519 f7            	ld	(x),a
5451                     ; 825          break;
5453  151a ac7e167e      	jpf	L5361
5454  151e               L5551:
5455                     ; 826       case SO_DESTIP:
5455                     ; 827          getSn_DIPR(sn, (uint8_t*)arg);
5457  151e ae0004        	ldw	x,#4
5458  1521 89            	pushw	x
5459  1522 1e08          	ldw	x,(OFST+7,sp)
5460  1524 89            	pushw	x
5461  1525 7b06          	ld	a,(OFST+5,sp)
5462  1527 97            	ld	xl,a
5463  1528 a604          	ld	a,#4
5464  152a 42            	mul	x,a
5465  152b 58            	sllw	x
5466  152c 58            	sllw	x
5467  152d 58            	sllw	x
5468  152e 1c0c08        	addw	x,#3080
5469  1531 cd0000        	call	c_itolx
5471  1534 be02          	ldw	x,c_lreg+2
5472  1536 89            	pushw	x
5473  1537 be00          	ldw	x,c_lreg
5474  1539 89            	pushw	x
5475  153a cd0000        	call	_WIZCHIP_READ_BUF
5477  153d 5b08          	addw	sp,#8
5478                     ; 828          break;
5480  153f ac7e167e      	jpf	L5361
5481  1543               L7551:
5482                     ; 829       case SO_DESTPORT:  
5482                     ; 830          *(uint16_t*) arg = getSn_DPORT(sn);
5484  1543 7b02          	ld	a,(OFST+1,sp)
5485  1545 97            	ld	xl,a
5486  1546 a604          	ld	a,#4
5487  1548 42            	mul	x,a
5488  1549 58            	sllw	x
5489  154a 58            	sllw	x
5490  154b 58            	sllw	x
5491  154c 1c1108        	addw	x,#4360
5492  154f cd0000        	call	c_itolx
5494  1552 be02          	ldw	x,c_lreg+2
5495  1554 89            	pushw	x
5496  1555 be00          	ldw	x,c_lreg
5497  1557 89            	pushw	x
5498  1558 cd0000        	call	_WIZCHIP_READ
5500  155b 5b04          	addw	sp,#4
5501  155d 6b01          	ld	(OFST+0,sp),a
5503  155f 7b02          	ld	a,(OFST+1,sp)
5504  1561 97            	ld	xl,a
5505  1562 a604          	ld	a,#4
5506  1564 42            	mul	x,a
5507  1565 58            	sllw	x
5508  1566 58            	sllw	x
5509  1567 58            	sllw	x
5510  1568 1c1008        	addw	x,#4104
5511  156b cd0000        	call	c_itolx
5513  156e be02          	ldw	x,c_lreg+2
5514  1570 89            	pushw	x
5515  1571 be00          	ldw	x,c_lreg
5516  1573 89            	pushw	x
5517  1574 cd0000        	call	_WIZCHIP_READ
5519  1577 5b04          	addw	sp,#4
5520  1579 5f            	clrw	x
5521  157a 97            	ld	xl,a
5522  157b 4f            	clr	a
5523  157c 02            	rlwa	x,a
5524  157d 01            	rrwa	x,a
5525  157e 1b01          	add	a,(OFST+0,sp)
5526  1580 2401          	jrnc	L252
5527  1582 5c            	incw	x
5528  1583               L252:
5529  1583 1606          	ldw	y,(OFST+5,sp)
5530  1585 02            	rlwa	x,a
5531  1586 90ff          	ldw	(y),x
5532  1588 01            	rrwa	x,a
5533                     ; 831          break;
5535  1589 ac7e167e      	jpf	L5361
5536  158d               L1651:
5537                     ; 834          CHECK_SOCKMODE(Sn_MR_TCP);
5539  158d 7b02          	ld	a,(OFST+1,sp)
5540  158f 97            	ld	xl,a
5541  1590 a604          	ld	a,#4
5542  1592 42            	mul	x,a
5543  1593 58            	sllw	x
5544  1594 58            	sllw	x
5545  1595 58            	sllw	x
5546  1596 1c0008        	addw	x,#8
5547  1599 cd0000        	call	c_itolx
5549  159c be02          	ldw	x,c_lreg+2
5550  159e 89            	pushw	x
5551  159f be00          	ldw	x,c_lreg
5552  15a1 89            	pushw	x
5553  15a2 cd0000        	call	_WIZCHIP_READ
5555  15a5 5b04          	addw	sp,#4
5556  15a7 a40f          	and	a,#15
5557  15a9 a101          	cp	a,#1
5558  15ab 2705          	jreq	L3461
5561  15ad a6fb          	ld	a,#251
5563  15af               L062:
5565  15af 5b03          	addw	sp,#3
5566  15b1 81            	ret
5567  15b2               L3461:
5568                     ; 835          *(uint16_t*) arg = getSn_KPALVTR(sn);
5571  15b2 7b02          	ld	a,(OFST+1,sp)
5572  15b4 97            	ld	xl,a
5573  15b5 a604          	ld	a,#4
5574  15b7 42            	mul	x,a
5575  15b8 58            	sllw	x
5576  15b9 58            	sllw	x
5577  15ba 58            	sllw	x
5578  15bb 1c2f08        	addw	x,#12040
5579  15be cd0000        	call	c_itolx
5581  15c1 be02          	ldw	x,c_lreg+2
5582  15c3 89            	pushw	x
5583  15c4 be00          	ldw	x,c_lreg
5584  15c6 89            	pushw	x
5585  15c7 cd0000        	call	_WIZCHIP_READ
5587  15ca 5b04          	addw	sp,#4
5588  15cc 5f            	clrw	x
5589  15cd 97            	ld	xl,a
5590  15ce 1606          	ldw	y,(OFST+5,sp)
5591  15d0 90ff          	ldw	(y),x
5592                     ; 836          break;
5594  15d2 ac7e167e      	jpf	L5361
5595  15d6               L3651:
5596                     ; 838       case SO_SENDBUF:
5596                     ; 839          *(uint16_t*) arg = getSn_TX_FSR(sn);
5598  15d6 7b02          	ld	a,(OFST+1,sp)
5599  15d8 cd0000        	call	_getSn_TX_FSR
5601  15db 1606          	ldw	y,(OFST+5,sp)
5602  15dd 90ff          	ldw	(y),x
5603                     ; 840          break;
5605  15df ac7e167e      	jpf	L5361
5606  15e3               L5651:
5607                     ; 841       case SO_RECVBUF:
5607                     ; 842          *(uint16_t*) arg = getSn_RX_RSR(sn);
5609  15e3 7b02          	ld	a,(OFST+1,sp)
5610  15e5 cd0000        	call	_getSn_RX_RSR
5612  15e8 1606          	ldw	y,(OFST+5,sp)
5613  15ea 90ff          	ldw	(y),x
5614                     ; 843          break;
5616  15ec ac7e167e      	jpf	L5361
5617  15f0               L7651:
5618                     ; 844       case SO_STATUS:
5618                     ; 845          *(uint8_t*) arg = getSn_SR(sn);
5620  15f0 7b02          	ld	a,(OFST+1,sp)
5621  15f2 97            	ld	xl,a
5622  15f3 a604          	ld	a,#4
5623  15f5 42            	mul	x,a
5624  15f6 58            	sllw	x
5625  15f7 58            	sllw	x
5626  15f8 58            	sllw	x
5627  15f9 1c0308        	addw	x,#776
5628  15fc cd0000        	call	c_itolx
5630  15ff be02          	ldw	x,c_lreg+2
5631  1601 89            	pushw	x
5632  1602 be00          	ldw	x,c_lreg
5633  1604 89            	pushw	x
5634  1605 cd0000        	call	_WIZCHIP_READ
5636  1608 5b04          	addw	sp,#4
5637  160a 1e06          	ldw	x,(OFST+5,sp)
5638  160c f7            	ld	(x),a
5639                     ; 846          break;
5641  160d 206f          	jra	L5361
5642  160f               L1751:
5643                     ; 847       case SO_REMAINSIZE:
5643                     ; 848          if(getSn_MR(sn) == Sn_MR_TCP)
5645  160f 7b02          	ld	a,(OFST+1,sp)
5646  1611 97            	ld	xl,a
5647  1612 a604          	ld	a,#4
5648  1614 42            	mul	x,a
5649  1615 58            	sllw	x
5650  1616 58            	sllw	x
5651  1617 58            	sllw	x
5652  1618 1c0008        	addw	x,#8
5653  161b cd0000        	call	c_itolx
5655  161e be02          	ldw	x,c_lreg+2
5656  1620 89            	pushw	x
5657  1621 be00          	ldw	x,c_lreg
5658  1623 89            	pushw	x
5659  1624 cd0000        	call	_WIZCHIP_READ
5661  1627 5b04          	addw	sp,#4
5662  1629 a101          	cp	a,#1
5663  162b 260b          	jrne	L5461
5664                     ; 849             *(uint16_t*)arg = getSn_RX_RSR(sn);
5666  162d 7b02          	ld	a,(OFST+1,sp)
5667  162f cd0000        	call	_getSn_RX_RSR
5669  1632 1606          	ldw	y,(OFST+5,sp)
5670  1634 90ff          	ldw	(y),x
5672  1636 2046          	jra	L5361
5673  1638               L5461:
5674                     ; 851             *(uint16_t*)arg = sock_remained_size[sn];
5676  1638 7b02          	ld	a,(OFST+1,sp)
5677  163a 5f            	clrw	x
5678  163b 97            	ld	xl,a
5679  163c 58            	sllw	x
5680  163d 1606          	ldw	y,(OFST+5,sp)
5681  163f 89            	pushw	x
5682  1640 ee06          	ldw	x,(L11_sock_remained_size,x)
5683  1642 90ff          	ldw	(y),x
5684  1644 85            	popw	x
5685  1645 2037          	jra	L5361
5686  1647               L3751:
5687                     ; 854          CHECK_SOCKMODE(Sn_MR_TCP);
5689  1647 7b02          	ld	a,(OFST+1,sp)
5690  1649 97            	ld	xl,a
5691  164a a604          	ld	a,#4
5692  164c 42            	mul	x,a
5693  164d 58            	sllw	x
5694  164e 58            	sllw	x
5695  164f 58            	sllw	x
5696  1650 1c0008        	addw	x,#8
5697  1653 cd0000        	call	c_itolx
5699  1656 be02          	ldw	x,c_lreg+2
5700  1658 89            	pushw	x
5701  1659 be00          	ldw	x,c_lreg
5702  165b 89            	pushw	x
5703  165c cd0000        	call	_WIZCHIP_READ
5705  165f 5b04          	addw	sp,#4
5706  1661 a40f          	and	a,#15
5707  1663 a101          	cp	a,#1
5708  1665 2706          	jreq	L5561
5711  1667 a6fb          	ld	a,#251
5713  1669 acaf15af      	jpf	L062
5714  166d               L5561:
5715                     ; 855          *(uint8_t*)arg = sock_pack_info[sn];
5718  166d 7b02          	ld	a,(OFST+1,sp)
5719  166f 5f            	clrw	x
5720  1670 97            	ld	xl,a
5721  1671 e616          	ld	a,(_sock_pack_info,x)
5722  1673 1e06          	ldw	x,(OFST+5,sp)
5723  1675 f7            	ld	(x),a
5724                     ; 856          break;
5726  1676 2006          	jra	L5361
5727  1678               L5751:
5728                     ; 857       default:
5728                     ; 858          return SOCKERR_SOCKOPT;
5730  1678 a6fe          	ld	a,#254
5732  167a acaf15af      	jpf	L062
5733  167e               L5361:
5734                     ; 860    return SOCK_OK;
5736  167e a601          	ld	a,#1
5738  1680 acaf15af      	jpf	L062
5800                     	xdef	_sock_pack_info
5801                     	xdef	_getsockopt
5802                     	xdef	_setsockopt
5803                     	xdef	_ctlsocket
5804                     	xdef	_recvfrom
5805                     	xdef	_sendto
5806                     	xdef	_recv
5807                     	xdef	_send
5808                     	xdef	_disconnect
5809                     	xdef	_connect
5810                     	xdef	_listen
5811                     	xdef	_close
5812                     	xdef	_socket
5813                     	xref	_wiz_recv_ignore
5814                     	xref	_wiz_recv_data
5815                     	xref	_wiz_send_data
5816                     	xref	_getSn_RX_RSR
5817                     	xref	_getSn_TX_FSR
5818                     	xref	_WIZCHIP_WRITE_BUF
5819                     	xref	_WIZCHIP_READ_BUF
5820                     	xref	_WIZCHIP_WRITE
5821                     	xref	_WIZCHIP_READ
5822                     	xref.b	c_lreg
5841                     	xref	c_uitolx
5842                     	xref	c_lcmp
5843                     	xref	c_rtol
5844                     	xref	c_ladc
5845                     	xref	c_llsh
5846                     	xref	c_ltor
5847                     	xref	c_itolx
5848                     	xref	c_lzmp
5849                     	end
