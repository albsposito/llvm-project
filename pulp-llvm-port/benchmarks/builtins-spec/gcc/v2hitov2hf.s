	.file	"v2hitov2hf.c"
	.option nopic
	.text
	.align	1
	.globl	t_v2hitov2hf
	.type	t_v2hitov2hf, @function
t_v2hitov2hf:
	vfcvt.h.x	a0,a0	# f16 Vect to short int vect
	ret
	.size	t_v2hitov2hf, .-t_v2hitov2hf
	.ident	"GCC: (GNU) 7.1.1 20170509"
