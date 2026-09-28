	.file	"mul64hs.c"
	.option nopic
	.text
	.align	1
	.globl	t_mul64hs
	.type	t_mul64hs, @function
t_mul64hs:
	p.mulh	a0,a0,a1
	ret
	.size	t_mul64hs, .-t_mul64hs
	.align	1
	.globl	t_mul64hs_const
	.type	t_mul64hs_const, @function
t_mul64hs_const:
	li	a0,-1
	ret
	.size	t_mul64hs_const, .-t_mul64hs_const
	.ident	"GCC: (GNU) 7.1.1 20170509"
