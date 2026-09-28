	.file	"cplxmuls2div4.c"
	.option nopic
	.text
	.align	1
	.globl	t_cplxmuls2div4
	.type	t_cplxmuls2div4, @function
t_cplxmuls2div4:
	pv.cplxmul.h.r.div4 	a5,a0,a1	 # Vect/Vect Cplx signed multiply, div4, real part
	pv.cplxmul.h.i.div4 	a5,a0,a1	 # Vect/Vect Cplx signed multiply, div4, imaginary part
	mv	a0,a5
	ret
	.size	t_cplxmuls2div4, .-t_cplxmuls2div4
	.ident	"GCC: (GNU) 7.1.1 20170509"
