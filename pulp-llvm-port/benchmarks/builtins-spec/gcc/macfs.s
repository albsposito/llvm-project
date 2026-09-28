	.file	"macfs.c"
	.option nopic
	.text
	.align	1
	.globl	t_macfs
	.type	t_macfs, @function
t_macfs:
	p.macs 	a0,a0,a1,a2
	ret
	.size	t_macfs, .-t_macfs
	.ident	"GCC: (GNU) 7.1.1 20170509"
