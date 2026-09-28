	.file	"rintsf2.c"
	.option nopic
	.text
	.align	1
	.globl	t_rintsf2
	.type	t_rintsf2, @function
t_rintsf2:
	fcvt.w.s a0,a0,rmm
	ret
	.size	t_rintsf2, .-t_rintsf2
	.align	1
	.globl	t_rintsf2_const
	.type	t_rintsf2_const, @function
t_rintsf2_const:
	lui	a5,%hi(.LC0)
	lw	a0,%lo(.LC0)(a5)
	fcvt.w.s a0,a0,rmm
	ret
	.size	t_rintsf2_const, .-t_rintsf2_const
	.align	1
	.globl	t_rintsf2_scale
	.type	t_rintsf2_scale, @function
t_rintsf2_scale:
	fmul.s	a0,a0,a1
	fcvt.w.s a0,a0,rmm
	ret
	.size	t_rintsf2_scale, .-t_rintsf2_scale
	.section	.srodata.cst4,"aM",@progbits,4
	.align	2
.LC0:
	.word	1075838976
	.ident	"GCC: (GNU) 7.1.1 20170509"
