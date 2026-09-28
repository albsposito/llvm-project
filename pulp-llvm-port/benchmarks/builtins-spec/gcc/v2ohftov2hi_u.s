	.file	"v2ohftov2hi_u.c"
	.option nopic
	.text
	.align	1
	.globl	t_v2ohftov2hi_u
	.type	t_v2ohftov2hi_u, @function
t_v2ohftov2hi_u:
	vfcvt.xu.ah	a0,a0	# f16 Vect to short uint vect, trunc
	ret
	.size	t_v2ohftov2hi_u, .-t_v2ohftov2hi_u
	.ident	"GCC: (GNU) 7.1.1 20170509"
