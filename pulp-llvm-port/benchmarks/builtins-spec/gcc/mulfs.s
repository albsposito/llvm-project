	.file	"mulfs.c"
	.option nopic
	.text
	.align	1
	.globl	t_mulfs
	.type	t_mulfs, @function
t_mulfs:
	p.muls 	a0,a0,a1
	ret
	.size	t_mulfs, .-t_mulfs
	.ident	"GCC: (GNU) 7.1.1 20170509"
