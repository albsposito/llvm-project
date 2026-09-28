	.file	"f16abs2.c"
	.option nopic
	.text
	.align	1
	.globl	t_f16abs2
	.type	t_f16abs2, @function
t_f16abs2:
	vfabs.h	a0,a0
	ret
	.size	t_f16abs2, .-t_f16abs2
	.ident	"GCC: (GNU) 7.1.1 20170509"
