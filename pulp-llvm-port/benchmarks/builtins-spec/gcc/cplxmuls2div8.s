	.file	"cplxmuls2div8.c"
	.option nopic
	.text
	.align	1
	.globl	t_cplxmuls2div8
	.type	t_cplxmuls2div8, @function
t_cplxmuls2div8:
	pv.cplxmul.h.r.div8 	a5,a0,a1	 # Vect/Vect Cplx signed multiply, div8, real part
	pv.cplxmul.h.i.div8 	a5,a0,a1	 # Vect/Vect Cplx signed multiply, div8, imaginary part
	mv	a0,a5
	ret
	.size	t_cplxmuls2div8, .-t_cplxmuls2div8
	.ident	"GCC: (GNU) 7.1.1 20170509"
