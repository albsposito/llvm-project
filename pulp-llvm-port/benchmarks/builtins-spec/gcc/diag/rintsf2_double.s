	.file	"rintsf2_double.c"
	.option nopic
	.globl	__truncdfsf2
	.text
	.align	1
	.globl	f
	.type	f, @function
f:
	add	sp,sp,-16
	sw	ra,12(sp)
	call	__truncdfsf2
	lw	ra,12(sp)
	fcvt.w.s a0,a0,rmm
	add	sp,sp,16
	jr	ra
	.size	f, .-f
	.ident	"GCC: (GNU) 7.1.1 20170509"
