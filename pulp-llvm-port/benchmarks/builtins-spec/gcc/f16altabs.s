	.file	"f16altabs.c"
	.option nopic
	.text
	.align	1
	.globl	t_f16altabs
	.type	t_f16altabs, @function
t_f16altabs:
	fabs.ah	a0,a0
	ret
	.size	t_f16altabs, .-t_f16altabs
	.ident	"GCC: (GNU) 7.1.1 20170509"
