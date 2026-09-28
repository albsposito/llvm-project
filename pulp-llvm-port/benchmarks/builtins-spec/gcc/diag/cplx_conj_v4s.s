	.file	"cplx_conj_v4s.c"
	.option nopic
	.text
	.align	1
	.globl	f
	.type	f, @function
f:
	pv.cplxconj.h 	a0,a0	 # Complex conjugate
	ret
	.size	f, .-f
	.ident	"GCC: (GNU) 7.1.1 20170509"
