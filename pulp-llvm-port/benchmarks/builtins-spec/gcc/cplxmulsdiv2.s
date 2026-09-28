	.file	"cplxmulsdiv2.c"
	.option nopic
	.text
	.align	1
	.globl	t_cplxmulsdiv2
	.type	t_cplxmulsdiv2, @function
t_cplxmulsdiv2:
	pv.cplxmul.s.div2 	a0,a0,a1	 # Q15 Vect/Vect Cplx signed multiply >> 1
	ret
	.size	t_cplxmulsdiv2, .-t_cplxmulsdiv2
	.ident	"GCC: (GNU) 7.1.1 20170509"
