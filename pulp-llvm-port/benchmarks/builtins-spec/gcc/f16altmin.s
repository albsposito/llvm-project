	.file	"f16altmin.c"
	.option nopic
	.text
	.align	1
	.globl	t_f16altmin
	.type	t_f16altmin, @function
t_f16altmin:
	fmin.ah	a0,a0,a1
	ret
	.size	t_f16altmin, .-t_f16altmin
	.ident	"GCC: (GNU) 7.1.1 20170509"
