	.file	"cplxmuls2_const.c"
	.option nopic
	.text
	.align	1
	.globl	f
	.type	f, @function
f:
	lui	a5,%hi(.LC0)
	lw	a4,%lo(.LC0)(a5)
	lui	a5,%hi(.LC1)
	lw	a5,%lo(.LC1)(a5)
	pv.cplxmul.h.r 	a0,a4,a5	 # Vect/Vect Cplx signed multiply, real part
	pv.cplxmul.h.i 	a0,a4,a5	 # Vect/Vect Cplx signed multiply, imaginary part
	ret
	.size	f, .-f
	.section	.srodata.cst4,"aM",@progbits,4
	.align	2
.LC0:
	.half	16384
	.half	0
.LC1:
	.half	16384
	.half	16384
	.ident	"GCC: (GNU) 7.1.1 20170509"
