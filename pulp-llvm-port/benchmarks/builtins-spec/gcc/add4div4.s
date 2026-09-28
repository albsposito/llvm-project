	.file	"add4div4.c"
	.option nopic
	.text
	.align	1
	.globl	t_add4div4
	.type	t_add4div4, @function
t_add4div4:
	pv.add.b.div4 	a0,a0,a1	 # Add4>>2 Op Vect
	ret
	.size	t_add4div4, .-t_add4div4
	.ident	"GCC: (GNU) 7.1.1 20170509"
