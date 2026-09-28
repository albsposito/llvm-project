	.file	"sub2div4.c"
	.option nopic
	.text
	.align	1
	.globl	t_sub2div4
	.type	t_sub2div4, @function
t_sub2div4:
	pv.sub.h.div4 	a0,a0,a1	 # Sub2>>2 Op Vect
	ret
	.size	t_sub2div4, .-t_sub2div4
	.ident	"GCC: (GNU) 7.1.1 20170509"
