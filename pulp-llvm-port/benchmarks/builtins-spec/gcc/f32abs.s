	.file	"f32abs.c"
	.option nopic
	.text
	.align	1
	.globl	t_f32abs
	.type	t_f32abs, @function
t_f32abs:
	fabs.s	a0,a0
	ret
	.size	t_f32abs, .-t_f32abs
	.align	1
	.globl	t_f32abs_const
	.type	t_f32abs_const, @function
t_f32abs_const:
	lui	a5,%hi(.LC0)
	lw	a0,%lo(.LC0)(a5)
	ret
	.size	t_f32abs_const, .-t_f32abs_const
	.section	.srodata.cst4,"aM",@progbits,4
	.align	2
.LC0:
	.word	1075838976
	.ident	"GCC: (GNU) 7.1.1 20170509"
