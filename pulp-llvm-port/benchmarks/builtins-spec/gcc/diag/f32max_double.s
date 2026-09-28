	.file	"f32max_double.c"
	.option nopic
	.globl	__truncdfsf2
	.text
	.align	1
	.globl	f
	.type	f, @function
f:
	add	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	sw	s2,4(sp)
	sw	s3,0(sp)
	mv	s2,a2
	mv	s3,a3
	call	__truncdfsf2
	mv	s0,a0
	mv	a1,s3
	mv	a0,s2
	call	__truncdfsf2
	fmax.s	a0,s0,a0
	lw	ra,12(sp)
	lw	s0,8(sp)
	lw	s2,4(sp)
	lw	s3,0(sp)
	add	sp,sp,16
	jr	ra
	.size	f, .-f
	.ident	"GCC: (GNU) 7.1.1 20170509"
