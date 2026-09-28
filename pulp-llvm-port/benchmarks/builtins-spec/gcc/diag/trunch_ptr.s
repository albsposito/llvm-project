	.file	"trunch_ptr.c"
	.option nopic
	.text
	.align	1
	.globl	f
	.type	f, @function
f:
	p.exths	a0,a0
	ret
	.size	f, .-f
	.ident	"GCC: (GNU) 7.1.1 20170509"
