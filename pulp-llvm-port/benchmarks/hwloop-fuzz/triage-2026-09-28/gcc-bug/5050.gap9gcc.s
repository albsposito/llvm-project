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
	beqz	a4,.L2
	li	s0,330
	p.mul	s0,a4,s0
	p.bclr 	t4,a4,29,2 # Bit clear
	sll	t6,t4,2
	add	t6,t6,176
	add	t2,a4,48
	add	t6,a0,t6
	li	t5,48
	li	a6,3
	li	t1,2
	li	t3,1
	add	t0,a3,25
	add	s1,a4,32
.L20:
	add	s4,t1,46
	p.bclr 	s4,s4,25,6 # Bit clear
	sll	s4,s4,2
	p.lw	s4,s4(a1)	# load reg(reg)
	sll	a6,a6,1
	srl	s3,t1,31
	p.bclr 	s4,s4,30,1 # Bit clear
	or	a6,a6,s3
	bnez	s4,.L28
	p.bclr 	s7,t5,25,6 # Bit clear
	sll	s7,s7,2
	add	s7,a1,s7
	add	s6,t3,374
	li	s5,32
	add	s4,s1,-32
	lp.setup  	x1,s4,(.L68)	 # loop setup, lc+le set
.L4:
	beqz	a3,.L19
	lw	s3,0(s7)
	li	s2,0
	mv	a7,t1
.L16:
	add	a5,a6,3
	p.bclr 	a5,a5,25,6 # Bit clear
	sll	a5,a5,2
	p.lw	a5,a5(a0)	# load reg(reg)
	add	a7,a7,s3
	add	s8,s2,1
	p.bclr 	a5,a5,28,3 # Bit clear
	sll	s9,a6,1
	srl	s10,a7,31
	beqz	a5,.L15
	or	a6,s10,s9
.L15:
	beq	s8,a3,.L61
	mv	s2,s8
	j	.L16
.L61:
	p.mac 	s3,s3,s2	# mac 32x32 in 32 instruction
	add	t1,t1,s3
.L19:
	p.bclr 	a5,s5,25,6 # Bit clear
	sll	a5,a5,2
	p.lw	a5,a5(a0)	# load reg(reg)
	p.bclr 	a7,s6,25,6 # Bit clear
	sll	a7,a7,2
	p.sw	a5,a7(a2)	# store reg(reg)
	add	s5,s5,1
.L68:
	add	s6,s6,330
	/* loop end s4 .L4 */
	add	t3,t3,s0
.L14:
	add	t5,t5,1
	bne	t2,t5,.L20
	beqz	a3,.L21
	srl	a4,t1,31
.L27:
	li	a7,0
	beqz	a3,.L62
.L67:
	lp.setupi  	x1,1,(.L66)	 # loop setup, lc+le set
.L22:
	add	a5,a7,52
	p.bclr 	a5,a5,25,6 # Bit clear
	sll	a5,a5,2
	p.lw	a5,a5(a0)	# load reg(reg)
	sll	a6,a6,1
	or	a6,a6,a4
	xor	a2,a5,t3
	add	a2,t3,a2
	xor	t3,a5,a2
	add	t3,t3,a2
	xor	a5,a5,t3
	add	t3,a5,t3
.L66:
	add	a7,a7,1
	/* loop end a3 .L22 */
.L21:
	xor	a7,t3,a6
	beqz	t4,.L23
	add	a5,a6,49
	p.bclr 	a5,a5,25,6 # Bit clear
	sll	a5,a5,2
	p.lw	a5,a5(a0)	# load reg(reg)
	li	a2,0
	xor	t3,t3,37
.L25:
	add	a4,t1,46
	p.bclr 	a4,a4,25,6 # Bit clear
	sll	a4,a4,2
	p.lw	a4,a4(a0)	# load reg(reg)
	add	a3,t1,1
	p.bclr 	a3,a3,25,6 # Bit clear
	add	a4,a5,a4
	xor	a4,a4,t1
	p.bclr 	a4,a4,28,3 # Bit clear
	sll	a3,a3,2
	add	a2,a2,1
	beqz	a4,.L24
	p.lw	a3,a3(a1)	# load reg(reg)
	p.bclr 	a3,a3,30,1 # Bit clear
	beqz	a3,.L24
	add	t1,t1,t3
.L24:
	bne	a2,t4,.L25
.L23:
	xor	a0,t1,a7
.L1:
	lw	s0,44(sp)
	lw	s1,40(sp)
	lw	s2,36(sp)
	lw	s3,32(sp)
	lw	s4,28(sp)
	lw	s5,24(sp)
	lw	s6,20(sp)
	lw	s7,16(sp)
	lw	s8,12(sp)
	lw	s9,8(sp)
	lw	s10,4(sp)
	add	sp,sp,48
	jr	ra
.L28:
	li	s6,2
.L3:
	li	s2,24
	add	a7,t0,-24
	p.beqimm	a3,-1,.L9
	lp.setup  	x1,a7,(.L65)	 # loop setup, lc+le set
.L6:
	p.bclr 	a5,s2,25,6 # Bit clear
	sll	a5,a5,2
	p.lw	a5,a5(a1)	# load reg(reg)
	sll	a6,a6,1
	or	a6,s3,a6
	p.bclr 	a5,a5,28,3 # Bit clear
	sll	s5,a6,1
	beqz	a5,.L5
	or	a6,s3,s5
.L5:
	add	s2,s2,1
.L65:
	nop
	/* loop end a7 .L6 */
.L9:
	p.bneimm	s6,1,.L29
	add	s5,t1,43
	add	s4,t5,-46
	p.bclr 	s5,s5,25,6 # Bit clear
	p.bclr 	s4,s4,25,6 # Bit clear
	sll	s5,s5,2
	sll	s4,s4,2
	add	s5,a2,s5
	add	s4,a0,s4
	mv	s6,a4
.L7:
	add	s2,a0,176
	beqz	t4,.L13
	sub	a7,t6,s2
	add	a7,a7,-4
	srl	a7,a7,2
	add	a7,a7,1
	lp.setup  	x1,a7,(.L64)	 # loop setup, lc+le set
.L10:
	p.lw	a5,4(s2!)	# load post inc
	sw	a5,0(s5)
	lw	a5,0(s4)
	xor	a5,a6,a5
	add	a6,a5,a6
	sll	a6,a6,1
.L64:
	or	a6,s3,a6
	/* loop end a7 .L10 */
.L13:
	add	s6,s6,-1
	bnez	s6,.L7
	add	a5,t3,19
	p.bclr 	a5,a5,25,6 # Bit clear
	sll	a5,a5,2
	p.lw	a5,a5(a1)	# load reg(reg)
	add	a7,t3,12
	p.bclr 	a7,a7,25,6 # Bit clear
	sll	a7,a7,2
	p.sw	a5,a7(a2)	# store reg(reg)
	j	.L14
.L29:
	mv	s6,s4
	j	.L3
.L2:
	beqz	a3,.L63
	li	t4,0
	li	t1,2
	li	a6,3
	li	t3,1
	j	.L27
.L63:
	li	a0,0
	j	.L1
.L62:
	j	.L67
	.size	kern, .-kern
	.ident	"GCC: (GNU) 7.1.1 20170509"
