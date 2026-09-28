	.file	"v2hftov2ohf.c"
	.option nopic
	.text
	.align	1
	.globl	t_v2hftov2ohf
	.type	t_v2hftov2ohf, @function
t_v2hftov2ohf:
	vfcvt.ah.h	a0,a0
	ret
	.size	t_v2hftov2ohf, .-t_v2hftov2ohf
	.ident	"GCC: (GNU) 7.1.1 20170509"
