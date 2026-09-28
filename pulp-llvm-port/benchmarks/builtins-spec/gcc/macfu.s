	.file	"macfu.c"
	.option nopic
	.text
	.align	1
	.globl	t_macfu
	.type	t_macfu, @function
t_macfu:
	p.macu 	a0,a0,a1,a2
	ret
	.size	t_macfu, .-t_macfu
	.ident	"GCC: (GNU) 7.1.1 20170509"
