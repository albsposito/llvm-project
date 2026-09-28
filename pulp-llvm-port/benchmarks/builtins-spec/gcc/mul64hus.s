	.file	"mul64hus.c"
	.option nopic
	.text
	.align	1
	.globl	t_mul64hus
	.type	t_mul64hus, @function
t_mul64hus:
	p.mulhsu	a0,a1,a0
	ret
	.size	t_mul64hus, .-t_mul64hus
	.align	1
	.globl	t_mul64hus_const
	.type	t_mul64hus_const, @function
t_mul64hus_const:
	li	a0,-1
	ret
	.size	t_mul64hus_const, .-t_mul64hus_const
	.ident	"GCC: (GNU) 7.1.1 20170509"
