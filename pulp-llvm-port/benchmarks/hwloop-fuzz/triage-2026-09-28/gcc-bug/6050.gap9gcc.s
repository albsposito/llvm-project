	.file	"kern.c"
	.option nopic
	.text
	.align	1
	.globl	kern
	.type	kern, @function
kern:
	add	sp,sp,-48
	sw	s0,44(sp)
	sw	s1,40(sp)
	sw	s2,36(sp)
	sw	s3,32(sp)
	sw	s4,28(sp)
	sw	s5,24(sp)
	sw	s6,20(sp)
	sw	s7,16(sp)
	sw	s8,12(sp)
	sw	s9,8(sp)
	sw	s10,4(sp)
	sw	s11,0(sp)
	beqz	a3,.L2
	lw	s1,12(a1)
	p.mul	s1,a3,s1
	add	s1,s1,1
	beqz	a4,.L56
.L3:
	p.bclr 	s10,a4,29,2 # Bit clear
	add	s8,a2,188
	sll	s9,s10,2
	add	s9,s8,s9
	li	a7,3
	li	t6,2
	li	s6,0
	add	s5,a5,43
	li	s7,6
	li	s11,5
.L15:
	beqz	s10,.L12
	add	s0,s6,28
	add	t5,s6,57
	sub	t4,s9,s8
	p.bclr 	s0,s0,25,6 # Bit clear
	p.bclr 	t5,t5,25,6 # Bit clear
	add	t4,t4,-4
	sll	s0,s0,2
	sll	t5,t5,2
	srl	t4,t4,2
	add	s0,a1,s0
	add	t5,a1,t5
	add	t1,a2,68
	add	t0,a1,20
	mv	t2,s8
	add	t4,t4,1
	lp.setup  	x0,t4,(.L66)	 # loop setup, lc+le set
.L17:
	li	s2,43
	add	t3,s5,-43
	beqz	a5,.L14
	lp.setup  	x1,t3,(.L65)	 # loop setup, lc+le set
.L5:
	p.bclr 	a6,s2,25,6 # Bit clear
	sll	a6,a6,2
	p.lw	a6,a6(a1)	# load reg(reg)
	add	s2,s2,1
.L65:
	sw	a6,0(t1)
	/* loop end t3 .L5 */
.L14:
	p.lw	t3,4(t0!)	# load post inc
	xor	a6,s1,t6
	xor	a6,a6,t3
	and	a6,a6,4
	bnez	a6,.L57
.L6:
	lw	a6,0(t5)
	add	t1,t1,4
.L66:
	p.sw	a6,4(t2!)	# store post inc
	/* loop end t4 .L17 */
.L12:
	add	a6,a7,28
	p.bclr 	a6,a6,25,6 # Bit clear
	sll	a6,a6,2
	p.lw	a6,a6(a1)	# load reg(reg)
	add	s6,s6,1
	add	t6,t6,a6
	bgtu	a4,s6,.L15
	xor	a7,t6,a7
	xor	s1,s1,a7
	beqz	a3,.L1
.L20:
	add	a5,t6,22
	p.bclr 	a5,a5,25,6 # Bit clear
	sll	a5,a5,2
	add	a2,a2,a5
	li	a4,0
	beqz	a3,.L58
.L64:
	lp.setupi  	x1,1,(.L63)	 # loop setup, lc+le set
.L19:
	add	a5,a4,9
	p.bclr 	a5,a5,25,6 # Bit clear
	sll	a5,a5,2
	p.lw	a5,a5(a0)	# load reg(reg)
	add	a4,a4,1
	xor	a5,a5,a7
.L63:
	sw	a5,0(a2)
	/* loop end a3 .L19 */
.L1:
	lw	s0,44(sp)
	mv	a0,s1
	lw	s2,36(sp)
	lw	s1,40(sp)
	lw	s3,32(sp)
	lw	s4,28(sp)
	lw	s5,24(sp)
	lw	s6,20(sp)
	lw	s7,16(sp)
	lw	s8,12(sp)
	lw	s9,8(sp)
	lw	s10,4(sp)
	lw	s11,0(sp)
	add	sp,sp,48
	jr	ra
.L57:
	srl	s4,t6,31
	beqz	a3,.L7
	add	s2,s1,24
	p.bclr 	s2,s2,25,6 # Bit clear
	sll	s2,s2,2
	p.lw	s2,s2(a0)	# load reg(reg)
	mv	t3,a3
	xor	s2,s1,s2
.L9:
	xor	a6,s2,a7
	add	a7,a7,a6
	add	a6,a7,63
	p.bclr 	a6,a6,25,6 # Bit clear
	sll	a6,a6,2
	p.lw	a6,a6(a1)	# load reg(reg)
	sll	s3,a7,1
	p.bclr 	a6,a6,28,3 # Bit clear
	beqz	a6,.L8
	or	a7,s3,s4
.L8:
	add	t3,t3,-1
	bnez	t3,.L9
.L7:
	add	a6,t6,56
	p.bclr 	a6,a6,25,6 # Bit clear
	sll	a6,a6,2
	p.lw	a6,a6(a0)	# load reg(reg)
	lw	t3,0(s0)
	add	a7,a7,142
	sll	a7,a7,1
	add	a6,a6,t3
	p.mul	a6,a6,s7
	or	a7,a7,s4
	and	a6,a6,8
	beqz	a6,.L6
	add	a6,a7,21
	add	s3,t6,52
	p.bclr 	a6,a6,25,6 # Bit clear
	p.bclr 	s3,s3,25,6 # Bit clear
	sll	a6,a6,2
	sll	s3,s3,2
	p.lw	a6,a6(a0)	# load reg(reg)
	p.lw	s3,s3(a0)	# load reg(reg)
	lw	t3,92(t0)
	add	s2,t6,12
	add	a6,a6,s3
	p.mac 	t3,a6,s11	# mac 32x32 in 32 instruction
	p.bclr 	a6,s2,25,6 # Bit clear
	sll	a6,a6,2
	p.lw	a6,a6(a0)	# load reg(reg)
	add	s1,s1,a6
	p.bclr 	t3,t3,30,1 # Bit clear
	bnez	t3,.L59
	sll	a7,a7,1
	or	a7,a7,s4
	j	.L6
.L59:
	add	s3,a7,4
	add	a6,s1,57
	p.bclr 	s3,s3,25,6 # Bit clear
	p.bclr 	a6,a6,25,6 # Bit clear
	sll	s3,s3,2
	sll	a6,a6,2
	p.lw	a6,a6(a1)	# load reg(reg)
	p.lw	s3,s3(a1)	# load reg(reg)
	li	s2,0
	mv	t3,a4
	add	s3,s3,a6
	li	a6,7
	p.mul	s3,s3,a6
	beqz	a4,.L60
.L62:
	lp.setup  	x1,t3,(.L61)	 # loop setup, lc+le set
.L11:
	add	a6,s2,33
	p.bclr 	a6,a6,25,6 # Bit clear
	sll	a6,a6,2
	p.lw	a6,a6(a1)	# load reg(reg)
	add	s2,s2,1
	add	a6,s3,a6
.L61:
	add	t6,t6,a6
	/* loop end t3 .L11 */
	j	.L6
.L2:
	bnez	a4,.L21
	li	s1,0
	j	.L1
.L21:
	li	s1,1
	j	.L3
.L60:
	li	t3,1
	j	.L62
.L58:
	j	.L64
.L56:
	xor	s1,s1,1
	li	a7,1
	li	t6,2
	j	.L20
	.size	kern, .-kern
	.ident	"GCC: (GNU) 7.1.1 20170509"
