	.file	"f16max2_v2ah.c"
	.option nopic
	.text
	.align	1
	.globl	f
	.type	f, @function
f:
	vfmax.h 	a0,a0,a1	 # FVect Op FVect
	ret
	.size	f, .-f
	.ident	"GCC: (GNU) 7.1.1 20170509"
