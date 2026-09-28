	.file	"f16min.c"
	.option nopic
	.text
	.align	1
	.globl	t_f16min
	.type	t_f16min, @function
t_f16min:
	fmin.h	a0,a0,a1
	ret
	.size	t_f16min, .-t_f16min
	.ident	"GCC: (GNU) 7.1.1 20170509"
