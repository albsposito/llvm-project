	.file	"loops3.c"
	.option nopic
	.text
	.align	1
	.globl	deint16
	.type	deint16, @function
deint16:
	blez	a2,.L1
	p.beqimm	a2,1,.L6
	srl	a3,a2,1
	mv	t1,a1
	add	a7,a1,4
	mv	t3,a0
	beqz	a3,.L10
.L13:
	lp.setup  	x1,a3,(.L12)	 # loop setup, lc+le set
.L4:
	p.lw	a5,8(t1!)	# load post modify imm
	p.lw	a6,8(a7!)	# load post modify imm
	pv.pack.h.h 	a4,a6,a5 	# Pack2 high
	pv.pack.h 	a5,a6,a5 	# Vector pack of 2 shorts (perm)
	pv.add.h 	a5,a4,a5	 # Vect Op Vect
.L12:
	p.sw	a5,4(t3!)	# store post inc
	/* loop end a3 .L4 */
	p.bclr 	a5,a2,0,0 # Bit clear
	beq	a5,a2,.L11
.L3:
	sll	a3,a5,2
	add	a4,a1,a3
	lhu	a4,2(a4)
	p.lhu	a3,a3(a1)
	sll	a5,a5,1
	add	a4,a4,a3
	p.sh	a4,a5(a0)	# store reg(reg)
.L1:
	ret
.L11:
	ret
.L6:
	li	a5,0
	j	.L3
.L10:
	li	a3,1
	j	.L13
	.size	deint16, .-deint16
	.align	1
	.globl	int16
	.type	int16, @function
int16:
	blez	a3,.L14
	p.beqimm	a3,1,.L19
	srl	a4,a3,1
	mv	t4,a0
	mv	a7,a1
	mv	t1,a2
	add	t3,a0,4
	beqz	a4,.L22
.L25:
	lp.setup  	x1,a4,(.L24)	 # loop setup, lc+le set
.L17:
	p.lw	a5,4(a7!)	# load post inc
	p.lw	a6,4(t1!)	# load post inc
	pv.pack.h 	t5,a6,a5 	# Vector pack of 2 shorts (perm)
	p.sw	t5,8(t4!)	# store post modify imm
	pv.pack.h.h 	a5,a6,a5 	# Pack2 high
.L24:
	p.sw	a5,8(t3!)	# store post modify imm
	/* loop end a4 .L17 */
	p.bclr 	a5,a3,0,0 # Bit clear
	beq	a3,a5,.L23
.L16:
	sll	a4,a5,1
	p.lhu	a3,a4(a1)
	p.lhu	a4,a4(a2)
	sll	a5,a5,2
	p.sh	a3,a5(a0)	# store reg(reg)
	add	a0,a0,a5
	sh	a4,2(a0)
.L14:
	ret
.L23:
	ret
.L19:
	li	a5,0
	j	.L16
.L22:
	li	a4,1
	j	.L25
	.size	int16, .-int16
	.align	1
	.globl	rev16
	.type	rev16, @function
rev16:
	blez	a3,.L26
	li	a6,-2147483648
	xor	a6,a6,-2
	add	a6,a3,a6
	sll	a4,a6,1
	p.adduN 	a4,a1,a4,1
	p.bclr 	a4,a4,30,1 # Bit clear
	add	t5,a3,-1
	add	a5,a4,1
	bltu	t5,a5,.L34
	li	t4,0
	beqz	a4,.L31
	sll	a5,t5,1
	p.lhu	a5,a5(a1)
	lhu	a7,0(a2)
	li	t4,1
	add	a5,a5,a7
	sh	a5,0(a0)
.L31:
	li	a5,-2147483648
	xor	a5,a5,-1
	p.mac 	a6,a4,a5	# mac 32x32 in 32 instruction
	sub	t6,a3,a4
	srl	a7,t6,1
	sll	a4,a4,1
	add	t1,a0,a4
	add	a4,a2,a4
	sll	a6,a6,1
	add	a6,a1,a6
	beqz	a7,.L39
.L42:
	lp.setup  	x1,a7,(.L41)	 # loop setup, lc+le set
.L32:
	p.lw	a5,-4(a6!)	# load post dec
	p.lw	t3,4(a4!)	# load post inc
	pv.shuffle.sci.h	a5,a5,1
	pv.add.h 	a5,a5,t3	 # Vect Op Vect
.L41:
	p.sw	a5,4(t1!)	# store post inc
	/* loop end a7 .L32 */
	p.bclr 	a4,t6,0,0 # Bit clear
	add	a5,a4,t4
	beq	t6,a4,.L40
.L28:
	sub	a6,t5,a5
	sll	a4,a5,1
	sll	a6,a6,1
	p.lhu	a6,a6(a1)
	p.lhu	a7,a4(a2)
	add	a5,a5,1
	add	a6,a6,a7
	p.sh	a6,a4(a0)	# store reg(reg)
	ble	a3,a5,.L26
	sub	a5,t5,a5
	add	a4,a4,2
	sll	a5,a5,1
	p.lhu	a5,a5(a1)
	p.lhu	a3,a4(a2)
	add	a5,a5,a3
	p.sh	a5,a4(a0)	# store reg(reg)
.L26:
	ret
.L40:
	ret
.L34:
	li	a5,0
	j	.L28
.L39:
	li	a7,1
	j	.L42
	.size	rev16, .-rev16
	.align	1
	.globl	rev8
	.type	rev8, @function
rev8:
	blez	a2,.L43
	add	a6,a2,-4
	add	a4,a1,a6
	p.bclr 	a4,a4,29,2 # Bit clear
	add	t1,a2,-1
	add	a5,a4,3
	bltu	t1,a5,.L50
	li	a7,0
	beqz	a4,.L46
	p.lbu	a5,t1(a1)
	li	a7,1
	sb	a5,0(a0)
	p.beqimm	a4,1,.L46
	add	a5,a1,a2
	lbu	a3,-2(a5)
	li	a7,2
	sb	a3,1(a0)
	p.bneimm	a4,3,.L46
	lbu	a5,-3(a5)
	li	a7,3
	sb	a5,2(a0)
.L46:
	sub	t3,a2,a4
	sub	a6,a6,a4
	srl	a3,t3,2
	add	a4,a0,a4
	add	a6,a1,a6
	beqz	a3,.L58
.L61:
	lp.setup  	x1,a3,(.L60)	 # loop setup, lc+le set
.L48:
	p.lw	a5,-4(a6!)	# load post dec
	pv.shuffleI0.sci.b	a5,a5,27
.L60:
	p.sw	a5,4(a4!)	# store post inc
	/* loop end a3 .L48 */
	p.bclr 	a4,t3,1,0 # Bit clear
	add	a5,a4,a7
	beq	t3,a4,.L59
.L45:
	sub	a4,t1,a5
	p.lbu	a3,a4(a1)
	add	a4,a5,1
	p.sb	a3,a5(a0)	# store reg(reg)
	ble	a2,a4,.L43
	sub	a3,t1,a4
	p.lbu	a6,a3(a1)
	add	a3,a5,2
	p.sb	a6,a4(a0)	# store reg(reg)
	ble	a2,a3,.L43
	sub	a4,t1,a3
	p.lbu	a6,a4(a1)
	add	a4,a5,3
	p.sb	a6,a3(a0)	# store reg(reg)
	ble	a2,a4,.L43
	sub	a3,t1,a4
	p.lbu	a6,a3(a1)
	add	a3,a5,4
	p.sb	a6,a4(a0)	# store reg(reg)
	ble	a2,a3,.L43
	sub	a4,t1,a3
	p.lbu	a4,a4(a1)
	add	a5,a5,5
	p.sb	a4,a3(a0)	# store reg(reg)
	ble	a2,a5,.L43
	sub	t1,t1,a5
	p.lbu	a4,t1(a1)
	p.sb	a4,a5(a0)	# store reg(reg)
.L43:
	ret
.L59:
	ret
.L50:
	li	a5,0
	j	.L45
.L58:
	li	a3,1
	j	.L61
	.size	rev8, .-rev8
	.align	1
	.globl	cond16
	.type	cond16, @function
cond16:
	blez	a2,.L62
	sll	a5,a2,1
	add	a5,a5,-2
	srl	a5,a5,1
	add	a5,a5,1
	lp.setup  	x1,a5,(.L67)	 # loop setup, lc+le set
.L65:
	p.lh	a4,2(a1!)	# load post inc, ext
	blez	a4,.L64
	sh	a4,0(a0)
.L64:
	add	a0,a0,2
.L67:
	nop
	/* loop end a5 .L65 */
.L62:
	ret
	.size	cond16, .-cond16
	.align	1
	.globl	widen8to16
	.type	widen8to16, @function
widen8to16:
	blez	a2,.L68
	lp.setup  	x1,a2,(.L72)	 # loop setup, lc+le set
.L70:
	p.lb	a5,1(a1!)	# load post inc, ext
.L72:
	p.sh	a5,2(a0!)	# store post inc
	/* loop end a2 .L70 */
.L68:
	ret
	.size	widen8to16, .-widen8to16
	.align	1
	.globl	narrow16to8
	.type	narrow16to8, @function
narrow16to8:
	blez	a2,.L73
	sll	a5,a2,1
	add	a5,a5,-2
	srl	a5,a5,1
	add	a5,a5,1
	lp.setup  	x1,a5,(.L77)	 # loop setup, lc+le set
.L75:
	p.lh	a4,2(a1!)	# load post inc, ext
	sra	a4,a4,8
.L77:
	p.sb	a4,1(a0!)	# store post inc
	/* loop end a5 .L75 */
.L73:
	ret
	.size	narrow16to8, .-narrow16to8
	.align	1
	.globl	mulhi16
	.type	mulhi16, @function
mulhi16:
	blez	a3,.L78
	sll	a4,a3,1
	add	a4,a4,-2
	srl	a4,a4,1
	add	a4,a4,1
	lp.setup  	x1,a4,(.L82)	 # loop setup, lc+le set
.L80:
	p.lh	a5,2(a1!)	# load post inc, ext
	p.lh	a3,2(a2!)	# load post inc, ext
	p.mul	a5,a5,a3
	sra	a5,a5,15
.L82:
	p.sh	a5,2(a0!)	# store post inc
	/* loop end a4 .L80 */
.L78:
	ret
	.size	mulhi16, .-mulhi16
	.align	1
	.globl	stride2
	.type	stride2, @function
stride2:
	blez	a2,.L83
	sll	a5,a2,1
	add	a5,a5,-2
	srl	a5,a5,1
	add	a5,a5,1
	lp.setup  	x1,a5,(.L87)	 # loop setup, lc+le set
.L85:
	p.lhu	a4,4(a1!)	# load post modify imm, ext
.L87:
	p.sh	a4,2(a0!)	# store post inc
	/* loop end a5 .L85 */
.L83:
	ret
	.size	stride2, .-stride2
	.align	1
	.globl	idx16
	.type	idx16, @function
idx16:
	blez	a3,.L88
	lp.setup  	x1,a3,(.L92)	 # loop setup, lc+le set
.L90:
	p.lbu	a5,1(a2!)	# load post inc, ext
	sll	a5,a5,1
	p.lhu	a5,a5(a1)
.L92:
	p.sh	a5,2(a0!)	# store post inc
	/* loop end a3 .L90 */
.L88:
	ret
	.size	idx16, .-idx16
	.align	1
	.globl	find16
	.type	find16, @function
find16:
	blez	a2,.L97
	lh	a5,0(a0)
	beq	a5,a1,.L98
	add	a5,a0,2
	li	a0,0
	j	.L95
.L96:
	p.lh	a4,2(a5!)	# load post inc, ext
	beq	a4,a1,.L93
.L95:
	add	a0,a0,1
	bne	a2,a0,.L96
.L97:
	li	a0,-1
	ret
.L98:
	li	a0,0
.L93:
	ret
	.size	find16, .-find16
	.align	1
	.globl	iota8
	.type	iota8, @function
iota8:
	blez	a1,.L99
	li	a5,0
	lp.setup  	x1,a1,(.L103)	 # loop setup, lc+le set
.L101:
	mv	a4,a5
	p.sb	a4,1(a0!)	# store post inc
.L103:
	add	a5,a5,1
	/* loop end a1 .L101 */
.L99:
	ret
	.size	iota8, .-iota8
	.align	1
	.globl	cadd
	.type	cadd, @function
cadd:
	blez	a3,.L104
	sll	a5,a3,2
	add	a5,a5,-4
	srl	a5,a5,2
	add	a5,a5,1
	lp.setup  	x1,a5,(.L108)	 # loop setup, lc+le set
.L106:
	p.lw	a3,4(a1!)	# load post inc
	p.lw	a4,4(a2!)	# load post inc
	pv.add.h 	a4,a4,a3	 # Vect Op Vect
.L108:
	p.sw	a4,4(a0!)	# store post inc
	/* loop end a5 .L106 */
.L104:
	ret
	.size	cadd, .-cadd
	.ident	"GCC: (GNU) 7.1.1 20170509"
