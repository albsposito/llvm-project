	.file	"mulfu.c"
	.option nopic
	.text
	.align	1
	.globl	t_mulfu
	.type	t_mulfu, @function
t_mulfu:
	p.mulu 	a0,a0,a1
	ret
	.size	t_mulfu, .-t_mulfu
	.ident	"GCC: (GNU) 7.1.1 20170509"
