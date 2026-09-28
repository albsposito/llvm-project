	.file	"f32min.c"
	.option nopic
	.text
	.align	1
	.globl	t_f32min
	.type	t_f32min, @function
t_f32min:
	fmin.s	a0,a0,a1
	ret
	.size	t_f32min, .-t_f32min
	.align	1
	.globl	t_f32min_const
	.type	t_f32min_const, @function
t_f32min_const:
	lui	a5,%hi(.LC1)
	lw	a0,%lo(.LC1)(a5)
	ret
	.size	t_f32min_const, .-t_f32min_const
	.section	.srodata.cst4,"aM",@progbits,4
	.align	2
.LC1:
	.word	3227516928
	.ident	"GCC: (GNU) 7.1.1 20170509"
