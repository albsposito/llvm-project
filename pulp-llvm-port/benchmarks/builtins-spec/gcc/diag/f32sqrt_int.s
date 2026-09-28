	.file	"f32sqrt_int.c"
	.option nopic
	.text
	.align	1
	.globl	f
	.type	f, @function
f:
	fcvt.s.w	a0,a0
	fsqrt.s	a0,a0
	ret
	.size	f, .-f
	.ident	"GCC: (GNU) 7.1.1 20170509"
