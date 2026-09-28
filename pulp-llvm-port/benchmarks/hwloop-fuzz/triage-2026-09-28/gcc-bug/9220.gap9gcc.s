	.file	"kern.c"
	.option nopic
	.text
	.align	1
	.globl	kern
	.type	kern, @function
kern:
	li	a6,3
	li	t5,0
	add	t6,a3,39
	beqz	a4,.L77
.L2:
	li	t3,39
	add	t1,t6,-39
	beqz	a3,.L10
.L7:
	lw	a7,0(a1)
	p.bclr 	a7,a7,30,1 # Bit clear
	bnez	a7,.L78
	p.bclr 	a7,t3,25,6 # Bit clear
	sll	a7,a7,2
	p.lw	a7,a7(a0)	# load reg(reg)
	add	t3,t3,1
	sw	a7,164(a2)
	add	t1,t1,-1
	bnez	t1,.L7
.L10:
	add	t5,t5,1
	bne	a4,t5,.L2
	li	t3,2
	beqz	a5,.L36
.L35:
	li	t3,2
	beqz	a5,.L79
.L89:
	lp.setupi  	x1,1,(.L88)	 # loop setup, lc+le set
.L11:
	add	a7,t3,12
	p.bclr 	a7,a7,25,6 # Bit clear
	sll	a7,a7,2
	p.lw	a7,a7(a0)	# load reg(reg)
.L88:
	add	t3,t3,a7
	/* loop end a5 .L11 */
	beqz	a4,.L75
.L36:
	p.bclr 	t2,a4,29,2 # Bit clear
	add	sp,sp,-48
	add	t0,a0,20
	sll	t5,t2,2
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
	add	t5,t0,t5
	li	t4,0
	li	t1,1
	add	t6,a3,10
	li	s0,23
	add	s1,a3,11
.L34:
	add	a5,t1,107
	p.bclr 	a5,a5,25,6 # Bit clear
	sll	a5,a5,2
	p.lw	a5,a5(a1)	# load reg(reg)
	add	s3,t1,53
	p.bclr 	a5,a5,30,1 # Bit clear
	beqz	a5,.L13
	add	a5,t1,74
	add	s4,t3,26
	add	a7,t3,58
	add	s2,t3,28
	p.bclr 	a5,a5,25,6 # Bit clear
	p.bclr 	s4,s4,25,6 # Bit clear
	add	t1,t3,30
	p.bclr 	a7,a7,25,6 # Bit clear
	p.bclr 	s2,s2,25,6 # Bit clear
	sll	a5,a5,2
	sll	s4,s4,2
	p.bclr 	t1,t1,25,6 # Bit clear
	sll	a7,a7,2
	sll	s2,s2,2
	p.lw	a5,a5(a0)	# load reg(reg)
	p.lw	s4,s4(a1)	# load reg(reg)
	sll	t1,t1,2
	p.lw	a7,a7(a1)	# load reg(reg)
	p.lw	s2,s2(a1)	# load reg(reg)
	p.lw	t1,t1(a0)	# load reg(reg)
	add	a5,a5,s4
	add	a7,a7,s2
	add	a5,a5,t1
	xor	a7,a7,s3
	add	a5,a5,a7
	p.bclr 	a5,a5,28,3 # Bit clear
	mv	t1,s3
	beqz	a5,.L14
.L15:
	mv	t1,s3
	srl	a7,t3,31
	li	s3,8
.L33:
	add	a5,t1,42
	p.bclr 	a5,a5,25,6 # Bit clear
	sll	a5,a5,2
	p.lw	a5,a5(a0)	# load reg(reg)
	xor	s2,t1,a6
	xor	a5,s2,a5
	add	t1,t1,a5
	beqz	a3,.L31
	mv	a5,a3
	lp.setup  	x1,a5,(.L87)	 # loop setup, lc+le set
.L32:
	sll	a6,a6,1
	or	a6,a6,a7
	sll	a6,a6,1
.L87:
	or	a6,a7,a6
	/* loop end a5 .L32 */
.L31:
	add	s3,s3,-1
	bnez	s3,.L33
.L14:
	add	t4,t4,1
	bgtu	a4,t4,.L34
	lw	s0,44(sp)
	xor	a0,t1,a6
	lw	s1,40(sp)
	lw	s2,36(sp)
	lw	s3,32(sp)
	lw	s4,28(sp)
	lw	s5,24(sp)
	lw	s6,20(sp)
	lw	s7,16(sp)
	lw	s8,12(sp)
	lw	s9,8(sp)
	xor	a0,a0,t3
	add	sp,sp,48
	jr	ra
.L78:
	add	t4,a6,37
	p.bclr 	t4,t4,25,6 # Bit clear
	sll	t4,t4,2
	p.lw	t4,t4(a1)	# load reg(reg)
	mv	a7,a3
	sw	t4,28(a2)
	lp.setup  	x1,a7,(.L86)	 # loop setup, lc+le set
.L5:
	sll	a6,a6,2
.L86:
	nop
	/* loop end a7 .L5 */
	add	t3,t3,1
	add	t1,t1,-1
	bnez	t1,.L7
	j	.L10
.L13:
	add	s2,t1,83
	p.bclr 	s2,s2,25,6 # Bit clear
	sll	s2,s2,2
	add	s2,a2,s2
	li	s4,6
	lp.setupi  	x0,6,(.L85)	 # loop setup, lc+le set
.L17:
	li	t1,10
	add	a7,t6,-10
	beqz	a3,.L21
	lp.setup  	x1,a7,(.L84)	 # loop setup, lc+le set
.L16:
	p.bclr 	a5,t1,25,6 # Bit clear
	sll	a5,a5,2
	p.lw	a5,a5(a1)	# load reg(reg)
	add	t1,t1,1
.L84:
	sw	a5,0(s2)
	/* loop end a7 .L16 */
.L21:
	add	s4,s4,-1
.L85:
	nop
	/* loop end s5 .L17 */
	mv	t1,t0
	beqz	t2,.L19
.L22:
	add	a5,a6,34
	p.bclr 	a5,a5,25,6 # Bit clear
	sll	a5,a5,2
	p.lw	a7,4(t1!)	# load post inc
	p.lw	a5,a5(a0)	# load reg(reg)
	sll	a6,a6,1
	add	a5,a7,a5
	add	t3,t3,a5
	srl	a5,t3,31
	or	a6,a5,a6
	bne	t5,t1,.L22
.L19:
	add	a5,t3,44
	p.bclr 	a5,a5,25,6 # Bit clear
	sll	a5,a5,2
	p.lw	a5,a5(a1)	# load reg(reg)
	p.bclr 	a5,a5,30,1 # Bit clear
	beqz	a5,.L15
	p.bclr 	a5,s3,29,2 # Bit clear
	p.bneimm	a5,1,.L80
	add	s3,s3,60
	j	.L15
.L80:
	add	s9,t4,49
	p.bclr 	s9,s9,25,6 # Bit clear
	sll	s9,s9,2
	add	a5,s4,1
	add	s9,a2,s9
	sub	s5,a4,s4
	bgtu	a5,a4,.L62
	beqz	a4,.L62
.L30:
	p.bclr 	a5,s3,30,1 # Bit clear
	beqz	a5,.L24
	add	a5,t3,27
	add	s2,s3,62
	p.bclr 	a5,a5,25,6 # Bit clear
	p.bclr 	s2,s2,25,6 # Bit clear
	add	t1,s4,44
	sll	a5,a5,2
	sll	s2,s2,2
	p.bclr 	t1,t1,25,6 # Bit clear
	add	a7,s4,3
	p.lw	a5,a5(a1)	# load reg(reg)
	p.lw	s2,s2(a1)	# load reg(reg)
	sll	t1,t1,2
	p.bclr 	a7,a7,25,6 # Bit clear
	p.lw	t1,t1(a0)	# load reg(reg)
	sll	a7,a7,2
	p.lw	a7,a7(a0)	# load reg(reg)
	add	a5,a5,s2
	add	a5,a5,t1
	add	a5,a5,a7
	p.bclr 	a5,a5,30,1 # Bit clear
	beqz	a5,.L81
	add	s2,t3,2
	p.bclr 	s2,s2,25,6 # Bit clear
	sll	s2,s2,2
	p.lw	s2,s2(a0)	# load reg(reg)
	add	t1,s3,60
	p.bclr 	t1,t1,25,6 # Bit clear
	add	a5,t3,30
	add	a7,a6,24
	sll	t1,t1,2
	p.bclr 	a5,a5,25,6 # Bit clear
	p.sw	s2,t1(a2)	# store reg(reg)
	p.bclr 	a7,a7,25,6 # Bit clear
	sll	a5,a5,2
	sll	a7,a7,2
	p.lw	a5,a5(a0)	# load reg(reg)
	p.lw	a7,a7(a0)	# load reg(reg)
	add	s4,s4,1
	sw	a5,0(s9)
	add	a6,a6,a7
	add	s5,s5,-1
	bnez	s5,.L30
.L82:
	add	s3,s3,60
	j	.L15
.L24:
	add	a5,s3,2
	p.bclr 	a5,a5,25,6 # Bit clear
	sll	a5,a5,2
	p.sw	s0,a5(a2)	# store reg(reg)
	add	s4,s4,1
	add	s5,s5,-1
	bnez	s5,.L30
	j	.L82
.L81:
	beqz	a3,.L27
	add	s8,s4,53
	add	s7,s4,42
	p.bclr 	s8,s8,25,6 # Bit clear
	p.bclr 	s7,s7,25,6 # Bit clear
	sll	s8,s8,2
	sll	s7,s7,2
	p.lw	s8,s8(a0)	# load reg(reg)
	p.lw	s7,s7(a0)	# load reg(reg)
	li	s2,11
	add	s6,s1,-11
	lp.setup  	x1,s6,(.L83)	 # loop setup, lc+le set
.L29:
	add	a5,s2,45
	add	a7,s3,18
	p.bclr 	a5,a5,25,6 # Bit clear
	p.bclr 	t1,s2,25,6 # Bit clear
	p.bclr 	a7,a7,25,6 # Bit clear
	sll	a5,a5,2
	sll	a7,a7,2
	p.lw	a5,a5(a0)	# load reg(reg)
	sll	t1,t1,2
	p.lw	a7,a7(a1)	# load reg(reg)
	p.lw	t1,t1(a1)	# load reg(reg)
	add	a5,s7,a5
	add	a5,a5,s3
	xor	t1,s3,t1
	add	a7,s8,a7
	xor	s3,a7,s3
	add	a5,a5,t1
	add	s3,a5,s3
.L83:
	add	s2,s2,1
	/* loop end s6 .L29 */
.L27:
	add	a5,s4,43
	p.bclr 	a5,a5,25,6 # Bit clear
	sll	a5,a5,2
	p.lw	a5,a5(a1)	# load reg(reg)
	add	t3,t3,38
	sll	a6,a6,1
	add	t3,t3,a5
	srl	a5,t3,31
	or	a6,a5,a6
	add	s4,s4,1
	add	s5,s5,-1
	bnez	s5,.L30
	j	.L82
.L77:
	bnez	a5,.L35
	li	t3,2
.L75:
	li	t1,1
	xor	a0,t1,a6
	xor	a0,a0,t3
	ret
.L79:
	j	.L89
.L62:
	li	s5,1
	j	.L30
	.size	kern, .-kern
	.ident	"GCC: (GNU) 7.1.1 20170509"
