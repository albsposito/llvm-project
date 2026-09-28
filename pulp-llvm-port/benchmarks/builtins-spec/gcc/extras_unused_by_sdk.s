	.file	"extras_unused_by_sdk.c"
	.option nopic
	.text
	.align	1
	.globl	t_add2div8
	.type	t_add2div8, @function
t_add2div8:
	pv.add.h.div8 	a0,a0,a1	 # Add2>>3 Op Vect
	ret
	.size	t_add2div8, .-t_add2div8
	.align	1
	.globl	t_sub2div8
	.type	t_sub2div8, @function
t_sub2div8:
	pv.sub.h.div8 	a0,a0,a1	 # Sub2>>3 Op Vect
	ret
	.size	t_sub2div8, .-t_sub2div8
	.align	1
	.globl	t_mulfuRN
	.type	t_mulfuRN, @function
t_mulfuRN:
	p.muluRN 	a0,a0,a1,5
	ret
	.size	t_mulfuRN, .-t_mulfuRN
	.ident	"GCC: (GNU) 7.1.1 20170509"
