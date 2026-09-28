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
	add	s8,a3,22
	li	s0,22
	li	t1,3
	li	t4,2
	li	a6,1
	add	s4,a4,51
	li	s5,7
	add	s9,a3,27
	li	s7,3
.L19:
	add	a5,t1,5
	p.bclr 	a5,a5,25,6 # Bit clear
	sll	a5,a5,2
	p.lw	a5,a5(a1)	# load reg(reg)
	p.bclr 	a5,a5,28,3 # Bit clear
	beqz	a5,.L3
	beqz	a4,.L3
	add	s2,s0,-14
	add	t2,s0,30
	add	s1,s0,19
	p.bclr 	s3,s0,25,6 # Bit clear
	p.bclr 	s2,s2,25,6 # Bit clear
	p.bclr 	t2,t2,25,6 # Bit clear
	p.bclr 	s1,s1,25,6 # Bit clear
	sll	t2,t2,2
	sll	s3,s3,2
	sll	s2,s2,2
	sll	s1,s1,2
	add	s6,a0,t2
	add	s3,a1,s3
	add	s2,a1,s2
	add	s1,a0,s1
	add	t2,a2,t2
	li	t3,51
	j	.L18
.L68:
	add	a5,t3,-14
	p.bclr 	a5,a5,25,6 # Bit clear
	sll	a5,a5,2
	p.lw	a5,a5(a1)	# load reg(reg)
	add	a6,a6,a5
	p.bclr 	a5,t3,25,6 # Bit clear
	sll	a5,a5,2
	p.lw	a5,a5(a0)	# load reg(reg)
	xor	a5,a6,a5
	p.bclr 	a5,a5,30,1 # Bit clear
	beqz	a5,.L16
.L69:
	add	t5,a6,11
	add	t6,t1,31
	p.bclr 	t5,t5,25,6 # Bit clear
	add	a7,t3,1
	p.bclr 	t6,t6,25,6 # Bit clear
	sll	t3,t5,2
	sll	t6,t6,2
	p.bclr 	t0,a7,25,6 # Bit clear
	add	a5,a6,46
	p.lw	t5,t3(a0)	# load reg(reg)
	p.bclr 	a5,a5,25,6 # Bit clear
	p.lw	t3,t6(a0)	# load reg(reg)
	sll	t6,t0,2
	p.lw	t6,t6(a0)	# load reg(reg)
	sll	a5,a5,2
	p.lw	a5,a5(a0)	# load reg(reg)
	add	t3,t5,t3
	add	t3,t3,t6
	add	a5,t3,a5
	sw	a5,0(t2)
	add	t4,t4,5
.L17:
	add	a5,t4,37
	p.bclr 	a5,a5,25,6 # Bit clear
	sll	a5,a5,2
	p.lw	a5,a5(a1)	# load reg(reg)
	add	a5,a5,11
	xor	a5,a5,a6
	add	t1,t1,a5
.L6:
	mv	t3,a7
	beq	s4,a7,.L3
.L18:
	add	a5,t4,52
	p.bclr 	a5,a5,25,6 # Bit clear
	sll	a5,a5,2
	p.lw	a5,a5(a0)	# load reg(reg)
	p.bclr 	a5,a5,30,1 # Bit clear
	bnez	a5,.L68
	add	a5,t1,54
	add	t5,t1,29
	add	t6,t1,44
	p.bclr 	a5,a5,25,6 # Bit clear
	add	a7,t3,12
	p.bclr 	t5,t5,25,6 # Bit clear
	p.bclr 	t6,t6,25,6 # Bit clear
	sll	a5,a5,2
	p.bclr 	a7,a7,25,6 # Bit clear
	sll	t5,t5,2
	sll	t6,t6,2
	p.lw	a5,a5(a0)	# load reg(reg)
	sll	a7,a7,2
	p.lw	a7,a7(a1)	# load reg(reg)
	p.lw	t5,t5(a0)	# load reg(reg)
	p.lw	t6,t6(a1)	# load reg(reg)
	sll	a5,a5,1
	add	a5,a5,a7
	add	t5,t5,t6
	p.mac 	a5,t5,s5	# mac 32x32 in 32 instruction
	add	a7,t3,1
	p.bclr 	a5,a5,28,3 # Bit clear
	beqz	a5,.L6
	add	t0,t3,-15
	add	t6,t3,9
	p.bclr 	t0,t0,25,6 # Bit clear
	p.bclr 	t6,t6,25,6 # Bit clear
	sll	t0,t0,2
	sll	t6,t6,2
	add	t0,a0,t0
	add	t6,a0,t6
	li	a7,27
	add	t5,s9,-27
	lp.setup  	x1,t5,(.L81)	 # loop setup, lc+le set
.L15:
	p.bclr 	a5,a7,25,6 # Bit clear
	sll	a5,a5,2
	p.lw	a5,a5(a0)	# load reg(reg)
	p.bclr 	a5,a5,30,1 # Bit clear
	beqz	a5,.L7
	add	a5,a7,8
	p.bclr 	a5,a5,25,6 # Bit clear
	sll	a5,a5,2
	p.lw	a5,a5(a0)	# load reg(reg)
	p.bclr 	a5,a5,30,1 # Bit clear
	beqz	a5,.L8
	add	a5,t1,56
	p.bclr 	a5,a5,25,6 # Bit clear
	sll	a5,a5,2
	xor	s10,a6,343
	p.sw	s10,a5(a2)	# store reg(reg)
.L9:
	add	a5,a7,-9
	p.bclr 	a5,a5,25,6 # Bit clear
	sll	a5,a5,2
	p.lw	a5,a5(a0)	# load reg(reg)
	srl	s10,t4,31
	and	a5,a5,4
	beqz	a5,.L12
	add	a5,t4,16
	p.bclr 	a5,a5,25,6 # Bit clear
	sll	a5,a5,2
	p.lw	a5,a5(a1)	# load reg(reg)
	add	t1,t1,a5
.L12:
	add	a5,a7,24
	p.bclr 	a5,a5,25,6 # Bit clear
	sll	a5,a5,2
	sll	t1,t1,1
	or	t1,t1,s10
	p.lw	a5,a5(a1)	# load reg(reg)
	lw	s10,0(t6)
	xor	a5,t1,a5
	add	a6,a6,s10
	add	a6,a5,a6
.L14:
	add	a7,a7,1
.L81:
	nop
	/* loop end t5 .L15 */
	add	a5,t3,8
	p.bclr 	a5,a5,25,6 # Bit clear
	sll	a5,a5,2
	p.lw	a5,a5(a0)	# load reg(reg)
	add	t4,t4,a5
	p.bclr 	a5,t3,25,6 # Bit clear
	sll	a5,a5,2
	p.lw	a5,a5(a0)	# load reg(reg)
	xor	a5,a6,a5
	p.bclr 	a5,a5,30,1 # Bit clear
	bnez	a5,.L69
.L16:
	sll	t1,t1,1
	srl	a5,t4,31
	or	t1,a5,t1
	add	a7,t3,1
	j	.L17
.L7:
	lw	a5,0(t0)
	xor	a5,t4,a5
	p.bclr 	a5,a5,30,1 # Bit clear
	beqz	a5,.L13
	add	a5,t1,27
	p.bclr 	a5,a5,25,6 # Bit clear
	sll	a5,a5,2
	p.lw	a5,a5(a0)	# load reg(reg)
	p.mul	a5,s7,a5
	xor	a5,a5,a6
	p.bclr 	a5,a5,28,3 # Bit clear
	beqz	a5,.L14
	add	a5,t1,1
	p.bclr 	a5,a5,25,6 # Bit clear
	sll	a5,a5,2
	p.lw	a5,a5(a1)	# load reg(reg)
	lw	s11,0(s3)
	add	s10,a7,6
	p.bclr 	s10,s10,25,6 # Bit clear
	sll	s10,s10,2
	add	a5,a5,s11
	p.sw	a5,s10(a2)	# store reg(reg)
	srl	s10,t4,31
	j	.L12
.L8:
	add	a5,a7,-1
	p.bclr 	a5,a5,25,6 # Bit clear
	sll	a5,a5,2
	p.lw	a5,a5(a0)	# load reg(reg)
	xor	a5,t4,a5
	p.bclr 	a5,a5,30,1 # Bit clear
	beqz	a5,.L10
	add	a5,t1,3
	p.bclr 	a5,a5,25,6 # Bit clear
	sll	a5,a5,2
	p.lw	a5,a5(a1)	# load reg(reg)
	add	t1,t1,a5
.L11:
	add	t4,t4,51
	lw	a5,0(s6)
	lw	s11,0(s1)
	p.bclr 	s10,t4,25,6 # Bit clear
	sll	s10,s10,2
	add	a5,a5,s11
	p.lw	s10,s10(a0)	# load reg(reg)
	add	a5,a5,208
	add	a6,a5,a6
	add	a6,a6,s10
	j	.L9
.L13:
	add	a5,t1,33
	p.bclr 	a5,a5,25,6 # Bit clear
	sll	a5,a5,2
	p.lw	a5,a5(a1)	# load reg(reg)
	sll	t1,t1,1
	add	a6,a6,82
	add	t4,t4,a5
	srl	s10,t4,31
	or	t1,t1,s10
	j	.L12
.L3:
	add	s0,s0,1
	bne	s8,s0,.L19
	beqz	a4,.L70
.L31:
	add	t5,t4,30
	p.bclr 	t5,t5,25,6 # Bit clear
	sll	t5,t5,2
	p.lw	t5,t5(a1)	# load reg(reg)
	add	s0,a3,1
	srl	t0,t4,31
	xor	t5,t4,t5
	li	t2,0
	li	s1,3
.L25:
	mv	a5,s0
	beqz	s0,.L27
	lp.setup  	x1,a5,(.L80)	 # loop setup, lc+le set
.L21:
	sll	t1,t1,1
.L80:
	or	t1,t1,t0
	/* loop end a5 .L21 */
.L27:
	add	t3,t2,42
	p.bclr 	t3,t3,25,6 # Bit clear
	sll	t3,t3,2
	p.lw	t3,t3(a0)	# load reg(reg)
	mv	t6,a4
	p.mul	t3,s1,t3
	beqz	a4,.L71
.L79:
	lp.setup  	x0,t6,(.L78)	 # loop setup, lc+le set
.L22:
	mv	a7,a4
	beqz	a4,.L72
.L77:
	lp.setup  	x1,a7,(.L76)	 # loop setup, lc+le set
.L23:
	xor	a5,t3,a6
	add	a5,a5,t5
.L76:
	add	a6,a6,a5
	/* loop end a7 .L23 */
.L78:
	nop
	/* loop end t6 .L22 */
	add	t2,t2,1
	bgtu	a4,t2,.L25
	xor	t4,t4,a6
	xor	a0,t1,t4
	beqz	a3,.L1
.L32:
	add	a0,a6,55
	p.bclr 	a0,a0,25,6 # Bit clear
	sll	a0,a0,2
	add	a0,a1,a0
	li	a7,6
	beqz	a3,.L73
.L75:
	lp.setupi  	x1,1,(.L74)	 # loop setup, lc+le set
.L29:
	add	a4,t1,40
	lw	a6,0(a0)
	add	a5,t1,62
	p.bclr 	a4,a4,25,6 # Bit clear
	sll	a4,a4,2
	p.bclr 	a5,a5,25,6 # Bit clear
	p.sw	a6,a4(a2)	# store reg(reg)
	sll	a5,a5,2
	p.lw	a5,a5(a1)	# load reg(reg)
.L74:
	p.mac 	t1,a7,a5	# mac 32x32 in 32 instruction
	/* loop end a3 .L29 */
	xor	a0,t1,t4
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
	lw	s11,0(sp)
	add	sp,sp,48
	jr	ra
.L10:
	lw	a5,0(s2)
	add	a5,a5,58
	add	t1,t1,a5
	j	.L11
.L2:
	bnez	a4,.L34
	li	a0,0
	j	.L1
.L34:
	li	t4,2
	li	t1,3
	li	a6,1
	j	.L31
.L73:
	j	.L75
.L72:
	li	a7,1
	j	.L77
.L71:
	li	t6,1
	j	.L79
.L70:
	xor	t4,a6,t4
	j	.L32
	.size	kern, .-kern
	.ident	"GCC: (GNU) 7.1.1 20170509"
