	.file	"v2hitov2ohf.c"
	.option nopic
	.text
	.align	1
	.globl	t_v2hitov2ohf
	.type	t_v2hitov2ohf, @function
t_v2hitov2ohf:
	vfcvt.ah.x	a0,a0	# f16 Vect to short int vect
	ret
	.size	t_v2hitov2ohf, .-t_v2hitov2ohf
	.ident	"GCC: (GNU) 7.1.1 20170509"
