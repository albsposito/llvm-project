	.file	"truncb.c"
	.option nopic
	.text
	.align	1
	.globl	t_truncb
	.type	t_truncb, @function
t_truncb:
	and	a0,a0,0xff
	ret
	.size	t_truncb, .-t_truncb
	.align	1
	.globl	t_truncb_const
	.type	t_truncb_const, @function
t_truncb_const:
	li	a0,305418240
	add	a0,a0,1656
	and	a0,a0,0xff
	ret
	.size	t_truncb_const, .-t_truncb_const
	.ident	"GCC: (GNU) 7.1.1 20170509"
