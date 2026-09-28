	.file	"sub4div2.c"
	.option nopic
	.text
	.align	1
	.globl	t_sub4div2
	.type	t_sub4div2, @function
t_sub4div2:
	pv.sub.b.div2 	a0,a0,a1	 # Sub4>>1 Op Vect
	ret
	.size	t_sub4div2, .-t_sub4div2
	.ident	"GCC: (GNU) 7.1.1 20170509"
