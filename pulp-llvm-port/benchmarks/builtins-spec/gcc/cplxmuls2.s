	.file	"cplxmuls2.c"
	.option nopic
	.text
	.align	1
	.globl	t_cplxmuls2
	.type	t_cplxmuls2, @function
t_cplxmuls2:
	pv.cplxmul.h.r 	a5,a0,a1	 # Vect/Vect Cplx signed multiply, real part
	pv.cplxmul.h.i 	a5,a0,a1	 # Vect/Vect Cplx signed multiply, imaginary part
	mv	a0,a5
	ret
	.size	t_cplxmuls2, .-t_cplxmuls2
	.ident	"GCC: (GNU) 7.1.1 20170509"
