	.file	"rintsf2_int.c"
	.option nopic
	.text
	.align	1
	.globl	f
	.type	f, @function
f:
	fcvt.s.w	a0,a0
	fcvt.w.s a0,a0,rmm
	ret
	.size	f, .-f
	.ident	"GCC: (GNU) 7.1.1 20170509"
