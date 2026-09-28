	.file	"v2hftov2ohf_v2s.c"
	.option nopic
	.text
	.align	1
	.globl	f
	.type	f, @function
f:
	vfcvt.ah.h	a0,a0
	ret
	.size	f, .-f
	.ident	"GCC: (GNU) 7.1.1 20170509"
