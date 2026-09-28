	.file	"trunch.c"
	.option nopic
	.text
	.align	1
	.globl	t_trunch
	.type	t_trunch, @function
t_trunch:
	p.exths	a0,a0
	ret
	.size	t_trunch, .-t_trunch
	.align	1
	.globl	t_trunch_const
	.type	t_trunch_const, @function
t_trunch_const:
	li	a0,305418240
	add	a0,a0,1656
	p.exths	a0,a0
	ret
	.size	t_trunch_const, .-t_trunch_const
	.align	1
	.globl	t_trunch_store
	.type	t_trunch_store, @function
t_trunch_store:
	add	a5,a1,a2
	sub	a1,a1,a2
	sh	a5,0(a0)
	sh	a1,8(a0)
	ret
	.size	t_trunch_store, .-t_trunch_store
	.ident	"GCC: (GNU) 7.1.1 20170509"
