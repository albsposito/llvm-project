	.file	"gcc_promotions.c"
	.option nopic
	.globl	__extendohfdf2
	.text
	.align	1
	.globl	g
	.type	g, @function
g:
	add	sp,sp,-16
	sw	ra,12(sp)
	call	__extendohfdf2
	lw	ra,12(sp)
	mv	a2,a0
	mv	a3,a1
	li	a0,1
	add	sp,sp,16
	tail	vf
	.size	g, .-g
	.align	1
	.globl	s
	.type	s, @function
s:
	li	a0,2
	ret
	.size	s, .-s
	.align	1
	.globl	t
	.type	t, @function
t:
	li	a0,1
	ret
	.size	t, .-t
	.globl	__adddf3
	.globl	__truncdfohf2
	.align	1
	.globl	k
	.type	k, @function
k:
	add	sp,sp,-16
	sw	ra,12(sp)
	call	__extendohfdf2
	mv	a2,a0
	mv	a3,a1
	call	__adddf3
	call	__truncdfohf2
	lw	ra,12(sp)
	add	sp,sp,16
	jr	ra
	.size	k, .-k
	.globl	__extendhfdf2
	.globl	__muldf3
	.globl	__truncdfhf2
	.align	1
	.globl	k2
	.type	k2, @function
k2:
	add	sp,sp,-16
	sw	ra,12(sp)
	call	__extendhfdf2
	lui	a5,%hi(.LC0)
	addi	a5,a5,%lo(.LC0)
	lw	a2,0(a5)
	lw	a3,4(a5)
	call	__muldf3
	call	__truncdfhf2
	lw	ra,12(sp)
	add	sp,sp,16
	jr	ra
	.size	k2, .-k2
	.align	1
	.globl	k3
	.type	k3, @function
k3:
	lui	a5,%hi(.LC1)
	lhu	a5,%lo(.LC1)(a5)
	fmul.h	a0,a0,a5
	ret
	.size	k3, .-k3
	.align	1
	.globl	k4
	.type	k4, @function
k4:
	fcvt.s.h	a0,a0
	fmul.s	a0,a0,a1
	fcvt.h.s	a0,a0
	ret
	.size	k4, .-k4
	.section	.srodata.cst2,"aM",@progbits,2
	.align	1
.LC1:
	.half	16640
	.section	.srodata.cst8,"aM",@progbits,8
	.align	3
.LC0:
	.word	0
	.word	1074003968
	.ident	"GCC: (GNU) 7.1.1 20170509"
