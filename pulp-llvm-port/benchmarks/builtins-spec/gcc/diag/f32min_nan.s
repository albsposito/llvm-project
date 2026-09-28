	.file	"f32min_nan.c"
	.option nopic
	.text
	.align	1
	.globl	f
	.type	f, @function
f:
	lui	a5,%hi(.LC0)
	lw	a5,%lo(.LC0)(a5)
	fmin.s	a0,a0,a5
	ret
	.size	f, .-f
	.section	.srodata.cst4,"aM",@progbits,4
	.align	2
.LC0:
	.word	2143289344
	.ident	"GCC: (GNU) 7.1.1 20170509"
