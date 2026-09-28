	.file	"mul64hu_ptr.c"
	.option nopic
	.text
	.align	1
	.globl	f
	.type	f, @function
f:
	p.mulhu	a0,a0,a1
	ret
	.size	f, .-f
	.ident	"GCC: (GNU) 7.1.1 20170509"
