	.file	"f32max.c"
	.option nopic
	.text
	.align	1
	.globl	t_f32max
	.type	t_f32max, @function
t_f32max:
	fmax.s	a0,a0,a1
	ret
	.size	t_f32max, .-t_f32max
	.align	1
	.globl	t_f32max_const
	.type	t_f32max_const, @function
t_f32max_const:
	lui	a5,%hi(.LC0)
	lw	a0,%lo(.LC0)(a5)
	ret
	.size	t_f32max_const, .-t_f32max_const
	.section	.srodata.cst4,"aM",@progbits,4
	.align	2
.LC0:
	.word	1075838976
	.ident	"GCC: (GNU) 7.1.1 20170509"
