	.file	"sub2div2.c"
	.option nopic
	.text
	.align	1
	.globl	t_sub2div2
	.type	t_sub2div2, @function
t_sub2div2:
	pv.sub.h.div2 	a0,a0,a1	 # Sub2>>1 Op Vect
	ret
	.size	t_sub2div2, .-t_sub2div2
	.ident	"GCC: (GNU) 7.1.1 20170509"
