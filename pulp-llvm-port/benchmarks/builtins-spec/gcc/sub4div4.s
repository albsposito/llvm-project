	.file	"sub4div4.c"
	.option nopic
	.text
	.align	1
	.globl	t_sub4div4
	.type	t_sub4div4, @function
t_sub4div4:
	pv.sub.b.div4 	a0,a0,a1	 # Sub4>>2 Op Vect
	ret
	.size	t_sub4div4, .-t_sub4div4
	.ident	"GCC: (GNU) 7.1.1 20170509"
