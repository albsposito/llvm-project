	.file	"f32max_int.c"
	.option nopic
	.text
	.align	1
	.globl	f
	.type	f, @function
f:
	fcvt.s.w	a1,a1
	fcvt.s.w	a0,a0
	fmax.s	a0,a0,a1
	ret
	.size	f, .-f
	.ident	"GCC: (GNU) 7.1.1 20170509"
