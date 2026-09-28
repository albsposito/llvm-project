	.file	"f16max.c"
	.option nopic
	.text
	.align	1
	.globl	t_f16max
	.type	t_f16max, @function
t_f16max:
	fmax.h	a0,a0,a1
	ret
	.size	t_f16max, .-t_f16max
	.ident	"GCC: (GNU) 7.1.1 20170509"
