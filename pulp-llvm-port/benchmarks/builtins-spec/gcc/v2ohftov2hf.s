	.file	"v2ohftov2hf.c"
	.option nopic
	.text
	.align	1
	.globl	t_v2ohftov2hf
	.type	t_v2ohftov2hf, @function
t_v2ohftov2hf:
	vfcvt.h.ah	a0,a0
	ret
	.size	t_v2ohftov2hf, .-t_v2ohftov2hf
	.ident	"GCC: (GNU) 7.1.1 20170509"
