	.file	"add2div2.c"
	.option nopic
	.text
	.align	1
	.globl	t_add2div2
	.type	t_add2div2, @function
t_add2div2:
	pv.add.h.div2 	a0,a0,a1	 # Add2>>1 Op Vect
	ret
	.size	t_add2div2, .-t_add2div2
	.ident	"GCC: (GNU) 7.1.1 20170509"
