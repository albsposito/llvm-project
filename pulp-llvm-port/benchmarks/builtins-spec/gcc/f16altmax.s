	.file	"f16altmax.c"
	.option nopic
	.text
	.align	1
	.globl	t_f16altmax
	.type	t_f16altmax, @function
t_f16altmax:
	fmax.ah	a0,a0,a1
	ret
	.size	t_f16altmax, .-t_f16altmax
	.ident	"GCC: (GNU) 7.1.1 20170509"
