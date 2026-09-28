	.file	"truncb_sign.c"
	.option nopic
	.text
	.align	1
	.globl	f
	.type	f, @function
f:
	and	a0,a0,0xff
	ret
	.size	f, .-f
	.ident	"GCC: (GNU) 7.1.1 20170509"
