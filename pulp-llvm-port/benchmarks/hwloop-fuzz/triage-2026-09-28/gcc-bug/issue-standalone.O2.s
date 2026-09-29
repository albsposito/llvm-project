	.file	"issue-standalone.c"
	.option nopic
	.text
	.align	1
	.globl	checksum
	.type	checksum, @function
checksum:
	beqz	a1,.L21
	li	a5,5
	beqz	a2,.L8
	beqz	a2,.L22
.L28:
	lp.setup  	x1,a2,(.L27)	 # loop setup, lc+le set
.L4:
	xor	a5,a5,79
.L27:
	nop
	/* loop end a2 .L4 */
.L24:
	beqz	a1,.L1
.L8:
	li	a4,0
	beqz	a1,.L23
.L26:
	lp.setupi  	x1,1,(.L25)	 # loop setup, lc+le set
.L6:
	p.lbu	a3,1(a0!)	# load post inc, ext
.L25:
	add	a4,a4,a3
	/* loop end a1 .L6 */
	xor	a5,a5,a4
.L1:
	mv	a0,a5
	ret
.L21:
	li	a5,0
	beqz	a2,.L1
	bnez	a2,.L28
.L22:
	li	a2,1
	xor	a5,a5,79
	add	a2,a2,-1
	bnez	a2,.L28
	j	.L24
.L23:
	j	.L26
	.size	checksum, .-checksum
	.section	.text.startup,"ax",@progbits
	.align	1
	.globl	main
	.type	main, @function
main:
	lui	a5,%hi(vlen)
	lw	a1,%lo(vlen)(a5)
	lui	a5,%hi(vrounds)
	lw	a2,%lo(vrounds)(a5)
	lui	a0,%hi(data)
	add	sp,sp,-16
	addi	a0,a0,%lo(data)
	sw	ra,12(sp)
	call	checksum
	mv	a1,a0
	lui	a0,%hi(.LC0)
	addi	a0,a0,%lo(.LC0)
	call	printf
	lw	ra,12(sp)
	li	a0,0
	add	sp,sp,16
	jr	ra
	.size	main, .-main
	.globl	vrounds
	.globl	vlen
	.globl	data
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align	2
.LC0:
	.string	"checksum = 0x%x\n"
	.section	.sdata,"aw",@progbits
	.align	2
	.type	vrounds, @object
	.size	vrounds, 4
vrounds:
	.word	3
	.type	vlen, @object
	.size	vlen, 4
vlen:
	.word	4
	.type	data, @object
	.size	data, 4
data:
	.byte	1
	.byte	2
	.byte	3
	.byte	4
	.ident	"GCC: (GNU) 7.1.1 20170509"
