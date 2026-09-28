	.file	"add2div4.c"
	.option nopic
	.text
	.align	1
	.globl	t_add2div4
	.type	t_add2div4, @function
t_add2div4:
	pv.add.h.div4 	a0,a0,a1	 # Add2>>2 Op Vect
	ret
	.size	t_add2div4, .-t_add2div4
	.ident	"GCC: (GNU) 7.1.1 20170509"
