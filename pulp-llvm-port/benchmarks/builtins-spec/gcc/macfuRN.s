	.file	"macfuRN.c"
	.option nopic
	.text
	.align	1
	.globl	t_macfuRN_n1
	.type	t_macfuRN_n1, @function
t_macfuRN_n1:
	p.macuRN 	a2,a0,a1,1
	mv	a0,a2
	ret
	.size	t_macfuRN_n1, .-t_macfuRN_n1
	.align	1
	.globl	t_macfuRN_n5
	.type	t_macfuRN_n5, @function
t_macfuRN_n5:
	p.macuRN 	a2,a0,a1,5
	mv	a0,a2
	ret
	.size	t_macfuRN_n5, .-t_macfuRN_n5
	.align	1
	.globl	t_macfuRN_n11
	.type	t_macfuRN_n11, @function
t_macfuRN_n11:
	p.macuRN 	a2,a0,a1,11
	mv	a0,a2
	ret
	.size	t_macfuRN_n11, .-t_macfuRN_n11
	.align	1
	.globl	t_macfuRN_n15
	.type	t_macfuRN_n15, @function
t_macfuRN_n15:
	p.macuRN 	a2,a0,a1,15
	mv	a0,a2
	ret
	.size	t_macfuRN_n15, .-t_macfuRN_n15
	.align	1
	.globl	t_macfuRN_n16
	.type	t_macfuRN_n16, @function
t_macfuRN_n16:
	p.macuRN 	a2,a0,a1,16
	mv	a0,a2
	ret
	.size	t_macfuRN_n16, .-t_macfuRN_n16
	.align	1
	.globl	t_macfuRN_n31
	.type	t_macfuRN_n31, @function
t_macfuRN_n31:
	p.macuRN 	a2,a0,a1,31
	mv	a0,a2
	ret
	.size	t_macfuRN_n31, .-t_macfuRN_n31
	.ident	"GCC: (GNU) 7.1.1 20170509"
