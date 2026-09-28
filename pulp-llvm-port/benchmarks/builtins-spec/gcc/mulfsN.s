	.file	"mulfsN.c"
	.option nopic
	.text
	.align	1
	.globl	t_mulfsN_n1
	.type	t_mulfsN_n1, @function
t_mulfsN_n1:
	p.mulsN 	a0,a0,a1,1
	ret
	.size	t_mulfsN_n1, .-t_mulfsN_n1
	.align	1
	.globl	t_mulfsN_n5
	.type	t_mulfsN_n5, @function
t_mulfsN_n5:
	p.mulsN 	a0,a0,a1,5
	ret
	.size	t_mulfsN_n5, .-t_mulfsN_n5
	.align	1
	.globl	t_mulfsN_n11
	.type	t_mulfsN_n11, @function
t_mulfsN_n11:
	p.mulsN 	a0,a0,a1,11
	ret
	.size	t_mulfsN_n11, .-t_mulfsN_n11
	.align	1
	.globl	t_mulfsN_n15
	.type	t_mulfsN_n15, @function
t_mulfsN_n15:
	p.mulsN 	a0,a0,a1,15
	ret
	.size	t_mulfsN_n15, .-t_mulfsN_n15
	.align	1
	.globl	t_mulfsN_n16
	.type	t_mulfsN_n16, @function
t_mulfsN_n16:
	p.mulsN 	a0,a0,a1,16
	ret
	.size	t_mulfsN_n16, .-t_mulfsN_n16
	.align	1
	.globl	t_mulfsN_n31
	.type	t_mulfsN_n31, @function
t_mulfsN_n31:
	p.mulsN 	a0,a0,a1,31
	ret
	.size	t_mulfsN_n31, .-t_mulfsN_n31
	.ident	"GCC: (GNU) 7.1.1 20170509"
