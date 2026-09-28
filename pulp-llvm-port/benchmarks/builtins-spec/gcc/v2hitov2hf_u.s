	.file	"v2hitov2hf_u.c"
	.option nopic
	.text
	.align	1
	.globl	t_v2hitov2hf_u
	.type	t_v2hitov2hf_u, @function
t_v2hitov2hf_u:
	vfcvt.h.xu	a0,a0	# f16 Vect to short uint vect
	ret
	.size	t_v2hitov2hf_u, .-t_v2hitov2hf_u
	.ident	"GCC: (GNU) 7.1.1 20170509"
