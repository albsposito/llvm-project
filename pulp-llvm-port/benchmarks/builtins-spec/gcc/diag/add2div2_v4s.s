	.file	"add2div2_v4s.c"
	.option nopic
	.text
	.align	1
	.globl	f
	.type	f, @function
f:
	pv.add.h.div2 	a0,a0,a1	 # Add2>>1 Op Vect
	ret
	.size	f, .-f
	.ident	"GCC: (GNU) 7.1.1 20170509"
