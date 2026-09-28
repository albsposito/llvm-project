	.file	"cplx_conj.c"
	.option nopic
	.text
	.align	1
	.globl	t_cplx_conj
	.type	t_cplx_conj, @function
t_cplx_conj:
	pv.cplxconj.h 	a0,a0	 # Complex conjugate
	ret
	.size	t_cplx_conj, .-t_cplx_conj
	.align	1
	.globl	t_cplx_conj_const
	.type	t_cplx_conj_const, @function
t_cplx_conj_const:
	lui	a5,%hi(.LC0)
	lw	a0,%lo(.LC0)(a5)
	pv.cplxconj.h 	a0,a0	 # Complex conjugate
	ret
	.size	t_cplx_conj_const, .-t_cplx_conj_const
	.section	.srodata.cst4,"aM",@progbits,4
	.align	2
.LC0:
	.half	1
	.half	-2
	.ident	"GCC: (GNU) 7.1.1 20170509"
