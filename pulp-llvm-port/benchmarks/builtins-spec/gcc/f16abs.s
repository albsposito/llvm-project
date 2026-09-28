	.file	"f16abs.c"
	.option nopic
	.text
	.align	1
	.globl	t_f16abs
	.type	t_f16abs, @function
t_f16abs:
	fabs.h	a0,a0
	ret
	.size	t_f16abs, .-t_f16abs
	.ident	"GCC: (GNU) 7.1.1 20170509"
