	.file	"mul64hu.c"
	.option nopic
	.text
	.align	1
	.globl	t_mul64hu
	.type	t_mul64hu, @function
t_mul64hu:
	p.mulhu	a0,a0,a1
	ret
	.size	t_mul64hu, .-t_mul64hu
	.align	1
	.globl	t_mul64hu_const
	.type	t_mul64hu_const, @function
t_mul64hu_const:
	li	a0,305418240
	add	a0,a0,1655
	ret
	.size	t_mul64hu_const, .-t_mul64hu_const
	.ident	"GCC: (GNU) 7.1.1 20170509"
