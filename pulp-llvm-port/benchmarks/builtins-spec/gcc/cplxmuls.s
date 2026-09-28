	.file	"cplxmuls.c"
	.option nopic
	.text
	.align	1
	.globl	t_cplxmuls
	.type	t_cplxmuls, @function
t_cplxmuls:
	pv.cplxmul.s 	a0,a0,a1	 # Vect/Vect Cplx signed multiply
	ret
	.size	t_cplxmuls, .-t_cplxmuls
	.ident	"GCC: (GNU) 7.1.1 20170509"
