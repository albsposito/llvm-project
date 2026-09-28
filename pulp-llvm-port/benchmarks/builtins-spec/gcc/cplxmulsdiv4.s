	.file	"cplxmulsdiv4.c"
	.option nopic
	.text
	.align	1
	.globl	t_cplxmulsdiv4
	.type	t_cplxmulsdiv4, @function
t_cplxmulsdiv4:
	pv.cplxmul.s.div4 	a0,a0,a1	 # Q15 Vect/Vect Cplx signed multiply >> 2
	ret
	.size	t_cplxmulsdiv4, .-t_cplxmulsdiv4
	.ident	"GCC: (GNU) 7.1.1 20170509"
