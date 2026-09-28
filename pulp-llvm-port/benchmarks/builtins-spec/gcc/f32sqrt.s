	.file	"f32sqrt.c"
	.option nopic
	.text
	.align	1
	.globl	t_f32sqrt
	.type	t_f32sqrt, @function
t_f32sqrt:
	fsqrt.s	a0,a0
	ret
	.size	t_f32sqrt, .-t_f32sqrt
	.align	1
	.globl	t_f32sqrt_const
	.type	t_f32sqrt_const, @function
t_f32sqrt_const:
	lui	a5,%hi(.LC0)
	lw	a0,%lo(.LC0)(a5)
	fsqrt.s	a0,a0
	ret
	.size	t_f32sqrt_const, .-t_f32sqrt_const
	.section	.srodata.cst4,"aM",@progbits,4
	.align	2
.LC0:
	.word	1075838976
	.ident	"GCC: (GNU) 7.1.1 20170509"
