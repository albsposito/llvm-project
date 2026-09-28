	.file	"f16altmax_f16.c"
	.option nopic
	.text
	.align	1
	.globl	f
	.type	f, @function
f:
	fcvt.ah.h	a1,a1
	fcvt.ah.h	a0,a0
	fmax.ah	a0,a0,a1
	ret
	.size	f, .-f
	.ident	"GCC: (GNU) 7.1.1 20170509"
