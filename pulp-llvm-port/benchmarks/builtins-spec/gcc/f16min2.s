	.file	"f16min2.c"
	.option nopic
	.text
	.align	1
	.globl	t_f16min2
	.type	t_f16min2, @function
t_f16min2:
	vfmin.h 	a0,a0,a1	 # FVect Op FVect
	ret
	.size	t_f16min2, .-t_f16min2
	.ident	"GCC: (GNU) 7.1.1 20170509"
