	.file	"v2hitov2hf_v2h.c"
	.option nopic
	.text
	.align	1
	.globl	f
	.type	f, @function
f:
	vfcvt.h.x	a0,a0	# f16 Vect to short int vect
	ret
	.size	f, .-f
	.ident	"GCC: (GNU) 7.1.1 20170509"
