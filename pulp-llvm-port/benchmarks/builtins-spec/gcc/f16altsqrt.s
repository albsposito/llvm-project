	.file	"f16altsqrt.c"
	.option nopic
	.text
	.align	1
	.globl	t_f16altsqrt
	.type	t_f16altsqrt, @function
t_f16altsqrt:
	fsqrt.ah	a0,a0
	ret
	.size	t_f16altsqrt, .-t_f16altsqrt
	.ident	"GCC: (GNU) 7.1.1 20170509"
