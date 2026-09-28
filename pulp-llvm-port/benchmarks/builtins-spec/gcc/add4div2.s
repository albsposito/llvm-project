	.file	"add4div2.c"
	.option nopic
	.text
	.align	1
	.globl	t_add4div2
	.type	t_add4div2, @function
t_add4div2:
	pv.add.b.div2 	a0,a0,a1	 # Add4>>1 Op Vect
	ret
	.size	t_add4div2, .-t_add4div2
	.ident	"GCC: (GNU) 7.1.1 20170509"
