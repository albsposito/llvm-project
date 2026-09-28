	.file	"f16altabs2.c"
	.option nopic
	.text
	.align	1
	.globl	t_f16altabs2
	.type	t_f16altabs2, @function
t_f16altabs2:
	vfabs.ah	a0,a0
	ret
	.size	t_f16altabs2, .-t_f16altabs2
	.ident	"GCC: (GNU) 7.1.1 20170509"
