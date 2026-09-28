	.file	"v2hftov2hi.c"
	.option nopic
	.text
	.align	1
	.globl	t_v2hftov2hi
	.type	t_v2hftov2hi, @function
t_v2hftov2hi:
	vfcvt.x.h	a0,a0	# f16 Vect to short int vect, trunc
	ret
	.size	t_v2hftov2hi, .-t_v2hftov2hi
	.ident	"GCC: (GNU) 7.1.1 20170509"
