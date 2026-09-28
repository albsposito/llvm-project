	.file	"cplxmuls2div2.c"
	.option nopic
	.text
	.align	1
	.globl	t_cplxmuls2div2
	.type	t_cplxmuls2div2, @function
t_cplxmuls2div2:
	pv.cplxmul.h.r.div2 	a5,a0,a1	 # Vect/Vect Cplx signed multiply, div2, real part
	pv.cplxmul.h.i.div2 	a5,a0,a1	 # Vect/Vect Cplx signed multiply, div2, imaginary part
	mv	a0,a5
	ret
	.size	t_cplxmuls2div2, .-t_cplxmuls2div2
	.ident	"GCC: (GNU) 7.1.1 20170509"
