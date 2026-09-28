	.file	"sub2rotmj_unsigned.c"
	.option nopic
	.text
	.align	1
	.globl	f
	.type	f, @function
f:
	pv.subrotmj.h 	a0,a0,a1
	ret
	.size	f, .-f
	.ident	"GCC: (GNU) 7.1.1 20170509"
