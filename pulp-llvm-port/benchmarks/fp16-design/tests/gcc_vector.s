	.file	"gcc_vector.c"
	.option nopic
	.text
	.align	1
	.globl	vh_add
	.type	vh_add, @function
vh_add:
	vfadd.h 	a0,a0,a1	 # FVect Op FVect
	ret
	.size	vh_add, .-vh_add
	.align	1
	.globl	vh_sub
	.type	vh_sub, @function
vh_sub:
	vfsub.h 	a0,a0,a1	 # FVect Op FVect
	ret
	.size	vh_sub, .-vh_sub
	.align	1
	.globl	vh_mul
	.type	vh_mul, @function
vh_mul:
	vfmul.h 	a0,a0,a1	 # FVect Op FVect
	ret
	.size	vh_mul, .-vh_mul
	.align	1
	.globl	vh_div
	.type	vh_div, @function
vh_div:
	pv.extract.h	a4,a1,0	 # vect extract
	pv.extract.h	a5,a0,0	 # vect extract
	pv.extract.h	a1,a1,1	 # vect extract
	pv.extract.h	a0,a0,1	 # vect extract
	fdiv.h	a5,a5,a4
	fdiv.h	a0,a0,a1
	pv.pack.h 	a0,a0,a5 	# Vector pack of 2 shorts
	ret
	.size	vh_div, .-vh_div
	.align	1
	.globl	vh_mac
	.type	vh_mac, @function
vh_mac:
	vfmac.h	a2,a0,a1
	mv	a0,a2
	ret
	.size	vh_mac, .-vh_mac
	.align	1
	.globl	vh_scal
	.type	vh_scal, @function
vh_scal:
	vfmul.r.h 	a0,a0,a1	 # FVect Op Scalar (swap)
	ret
	.size	vh_scal, .-vh_scal
	.align	1
	.globl	vh_scal2
	.type	vh_scal2, @function
vh_scal2:
	vfmul.r.h 	a0,a0,a1	 # FVect Op Scalar (swap)
	ret
	.size	vh_scal2, .-vh_scal2
	.align	1
	.globl	va_add
	.type	va_add, @function
va_add:
	vfadd.ah 	a0,a0,a1	 # FVect Op FVect
	ret
	.size	va_add, .-va_add
	.align	1
	.globl	va_mul
	.type	va_mul, @function
va_mul:
	vfmul.ah 	a0,a0,a1	 # FVect Op FVect
	ret
	.size	va_mul, .-va_mul
	.align	1
	.globl	va_mac
	.type	va_mac, @function
va_mac:
	vfmac.ah	a2,a0,a1
	mv	a0,a2
	ret
	.size	va_mac, .-va_mac
	.align	1
	.globl	vh_pack
	.type	vh_pack, @function
vh_pack:
	pv.pack.h 	a0,a1,a0 	# Vector pack of 2 shorts
	ret
	.size	vh_pack, .-vh_pack
	.align	1
	.globl	vh_packf
	.type	vh_packf, @function
vh_packf:
	vfcpka.h.s 	a0,a0,a1 	
	ret
	.size	vh_packf, .-vh_packf
	.align	1
	.globl	vh_ext0
	.type	vh_ext0, @function
vh_ext0:
	ret
	.size	vh_ext0, .-vh_ext0
	.align	1
	.globl	vh_ext1
	.type	vh_ext1, @function
vh_ext1:
	pv.extract.h	a0,a0,1	 # vect extract
	ret
	.size	vh_ext1, .-vh_ext1
	.align	1
	.globl	vh_hsum
	.type	vh_hsum, @function
vh_hsum:
	pv.extract.h	a5,a0,0	 # vect extract
	pv.extract.h	a0,a0,1	 # vect extract
	fadd.h	a0,a5,a0
	ret
	.size	vh_hsum, .-vh_hsum
	.align	1
	.globl	vh_ins
	.type	vh_ins, @function
vh_ins:
	pv.insert.h	a0,a1,1	 # Vect insert
	ret
	.size	vh_ins, .-vh_ins
	.align	1
	.globl	vh_lt
	.type	vh_lt, @function
vh_lt:
	vflt.h	a0,a0,a1
	ret
	.size	vh_lt, .-vh_lt
	.align	1
	.globl	vh_neg
	.type	vh_neg, @function
vh_neg:
	vfneg.h	a0,a0
	ret
	.size	vh_neg, .-vh_neg
	.align	1
	.globl	vh_max
	.type	vh_max, @function
vh_max:
	vfmax.h 	a0,a0,a1	 # FVect Op FVect
	ret
	.size	vh_max, .-vh_max
	.align	1
	.globl	va_max
	.type	va_max, @function
va_max:
	vfmax.ah 	a0,a0,a1	 # FVect Op FVect
	ret
	.size	va_max, .-va_max
	.align	1
	.globl	h_max
	.type	h_max, @function
h_max:
	fmax.h	a0,a0,a1
	ret
	.size	h_max, .-h_max
	.align	1
	.globl	a_abs
	.type	a_abs, @function
a_abs:
	fabs.ah	a0,a0
	ret
	.size	a_abs, .-a_abs
	.align	1
	.globl	h_sqrt
	.type	h_sqrt, @function
h_sqrt:
	fsqrt.h	a0,a0
	ret
	.size	h_sqrt, .-h_sqrt
	.align	1
	.globl	cvt_v2h_v2s
	.type	cvt_v2h_v2s, @function
cvt_v2h_v2s:
	vfcvt.x.h	a0,a0	# f16 Vect to short int vect, trunc
	ret
	.size	cvt_v2h_v2s, .-cvt_v2h_v2s
	.align	1
	.globl	cvt_v2s_v2h
	.type	cvt_v2s_v2h, @function
cvt_v2s_v2h:
	vfcvt.h.x	a0,a0	# f16 Vect to short int vect
	ret
	.size	cvt_v2s_v2h, .-cvt_v2s_v2h
	.align	1
	.globl	cvt_v2h_v2ah
	.type	cvt_v2h_v2ah, @function
cvt_v2h_v2ah:
	vfcvt.ah.h	a0,a0
	ret
	.size	cvt_v2h_v2ah, .-cvt_v2h_v2ah
	.align	1
	.globl	shuf
	.type	shuf, @function
shuf:
	lui	a5,%hi(.LC0)
	lw	a5,%lo(.LC0)(a5)
	pv.shuffle2.h	a0,a1,a5 	# Shuffle2, word
	ret
	.size	shuf, .-shuf
	.align	1
	.globl	shuf1
	.type	shuf1, @function
shuf1:
	pv.shuffle.sci.h	a0,a0,1
	ret
	.size	shuf1, .-shuf1
	.align	1
	.globl	vdot
	.type	vdot, @function
vdot:
	blez	a3,.L33
	sll	a5,a3,2
	add	a5,a5,-4
	pv.add.sci.h	a4,x0,0
	srl	a5,a5,2
	add	a5,a5,1
	lp.setup  	x1,a5,(.L35)	 # loop setup, lc+le set
.L32:
	p.lw	a6,4(a1!)	# load post inc
	p.lw	a3,4(a2!)	# load post inc
.L35:
	vfmac.h	a4,a6,a3
	/* loop end a5 .L32 */
	sw	a4,0(a0)
	ret
.L33:
	pv.add.sci.h	a4,x0,0
	sw	a4,0(a0)
	ret
	.size	vdot, .-vdot
	.align	1
	.globl	vcopy
	.type	vcopy, @function
vcopy:
	lw	a5,0(a1)
	sw	a5,0(a0)
	lw	a5,4(a1)
	sw	a5,4(a0)
	ret
	.size	vcopy, .-vcopy
	.align	1
	.globl	call_v
	.type	call_v, @function
call_v:
	li	a2,2
	tail	ext_v
	.size	call_v, .-call_v
	.section	.srodata.cst4,"aM",@progbits,4
	.align	2
.LC0:
	.half	1
	.half	2
	.ident	"GCC: (GNU) 7.1.1 20170509"
