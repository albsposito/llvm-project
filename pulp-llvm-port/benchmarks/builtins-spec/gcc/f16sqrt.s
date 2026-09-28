	.file	"f16sqrt.c"
	.option nopic
	.text
	.align	1
	.globl	t_f16sqrt
	.type	t_f16sqrt, @function
t_f16sqrt:
	fsqrt.h	a0,a0
	ret
	.size	t_f16sqrt, .-t_f16sqrt
	.ident	"GCC: (GNU) 7.1.1 20170509"
