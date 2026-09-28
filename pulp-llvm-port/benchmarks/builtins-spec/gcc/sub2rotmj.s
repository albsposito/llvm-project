	.file	"sub2rotmj.c"
	.option nopic
	.text
	.align	1
	.globl	t_sub2rotmj
	.type	t_sub2rotmj, @function
t_sub2rotmj:
	pv.subrotmj.h 	a0,a0,a1
	ret
	.size	t_sub2rotmj, .-t_sub2rotmj
	.ident	"GCC: (GNU) 7.1.1 20170509"
