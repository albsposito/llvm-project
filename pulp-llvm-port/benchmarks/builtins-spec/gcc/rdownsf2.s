	.file	"rdownsf2.c"
	.option nopic
	.text
	.align	1
	.globl	t_rdownsf2
	.type	t_rdownsf2, @function
t_rdownsf2:
	fcvt.w.s a0,a0,rdn
	ret
	.size	t_rdownsf2, .-t_rdownsf2
	.align	1
	.globl	t_rdownsf2_const
	.type	t_rdownsf2_const, @function
t_rdownsf2_const:
	lui	a5,%hi(.LC0)
	lw	a0,%lo(.LC0)(a5)
	fcvt.w.s a0,a0,rdn
	ret
	.size	t_rdownsf2_const, .-t_rdownsf2_const
	.section	.srodata.cst4,"aM",@progbits,4
	.align	2
.LC0:
	.word	1075838976
	.ident	"GCC: (GNU) 7.1.1 20170509"
