	.file	"loops_f16.c"
	.option nopic
	.text
	.align	1
	.globl	win_f16
	.type	win_f16, @function
win_f16:
	blez	a2,.L1
	srl	a5,a0,1
	p.bclr 	a5,a5,30,1 # Bit clear
	add	a4,a2,-1
	add	a3,a5,1
	bltu	a4,a3,.L9
	li	t4,0
	beqz	a5,.L6
	lhu	a4,0(a0)
	lhu	a3,0(a1)
	li	t4,1
	fmul.h	a4,a4,a3
	sh	a4,0(a0)
.L6:
	sll	a3,a5,1
	sub	t3,a2,a5
	add	a6,a0,a3
	srl	a4,t3,1
	mv	a7,a6
	add	a3,a1,a3
	beqz	a4,.L15
.L18:
	lp.setup  	x1,a4,(.L17)	 # loop setup, lc+le set
.L7:
	p.lw	a5,4(a7!)	# load post inc
	p.lw	t1,4(a3!)	# load post inc
	vfmul.h 	a5,a5,t1	 # FVect Op FVect
.L17:
	p.sw	a5,4(a6!)	# store post inc
	/* loop end a4 .L7 */
	p.bclr 	a4,t3,0,0 # Bit clear
	add	a5,a4,t4
	beq	t3,a4,.L16
.L3:
	sll	a4,a5,1
	add	a6,a0,a4
	lhu	a3,0(a6)
	p.lhu	a7,a4(a1)	# load reg(reg)
	add	a5,a5,1
	fmul.h	a3,a3,a7
	sh	a3,0(a6)
	ble	a2,a5,.L1
	add	a4,a4,2
	add	a0,a0,a4
	lhu	a5,0(a0)
	p.lhu	a1,a4(a1)	# load reg(reg)
	fmul.h	a1,a5,a1
	sh	a1,0(a0)
.L1:
	ret
.L16:
	ret
.L9:
	li	a5,0
	j	.L3
.L15:
	li	a4,1
	j	.L18
	.size	win_f16, .-win_f16
	.align	1
	.globl	win_f16_o
	.type	win_f16_o, @function
win_f16_o:
	blez	a3,.L19
	srl	a5,a1,1
	p.bclr 	a5,a5,30,1 # Bit clear
	add	a4,a3,-1
	add	a6,a5,1
	bltu	a4,a6,.L27
	li	t4,0
	beqz	a5,.L24
	lhu	a4,0(a2)
	lhu	a6,0(a1)
	li	t4,1
	fmul.h	a4,a4,a6
	sh	a4,0(a0)
.L24:
	sub	t5,a3,a5
	srl	a6,t5,1
	sll	a5,a5,1
	add	t1,a0,a5
	add	a7,a1,a5
	add	a5,a2,a5
	beqz	a6,.L32
.L35:
	lp.setup  	x1,a6,(.L34)	 # loop setup, lc+le set
.L25:
	p.lw	a4,4(a7!)	# load post inc
	p.lw	t3,4(a5!)	# load post inc
	vfmul.h 	a4,a4,t3	 # FVect Op FVect
.L34:
	p.sw	a4,4(t1!)	# store post inc
	/* loop end a6 .L25 */
	p.bclr 	a4,t5,0,0 # Bit clear
	add	a5,a4,t4
	beq	t5,a4,.L33
.L21:
	sll	a4,a5,1
	p.lhu	a6,a4(a1)	# load reg(reg)
	p.lhu	a7,a4(a2)	# load reg(reg)
	add	a5,a5,1
	fmul.h	a6,a6,a7
	p.sh	a6,a4(a0)	# store reg(reg)
	ble	a3,a5,.L19
	add	a4,a4,2
	p.lhu	a1,a4(a1)	# load reg(reg)
	p.lhu	a2,a4(a2)	# load reg(reg)
	fmul.h	a1,a1,a2
	p.sh	a1,a4(a0)	# store reg(reg)
.L19:
	ret
.L33:
	ret
.L27:
	li	a5,0
	j	.L21
.L32:
	li	a6,1
	j	.L35
	.size	win_f16_o, .-win_f16_o
	.align	1
	.globl	add_f16
	.type	add_f16, @function
add_f16:
	blez	a3,.L36
	srl	a5,a1,1
	p.bclr 	a5,a5,30,1 # Bit clear
	add	a4,a3,-1
	add	a6,a5,1
	bltu	a4,a6,.L44
	li	t4,0
	beqz	a5,.L41
	lhu	a4,0(a2)
	lhu	a6,0(a1)
	li	t4,1
	fadd.h	a4,a4,a6
	sh	a4,0(a0)
.L41:
	sub	t5,a3,a5
	srl	a6,t5,1
	sll	a5,a5,1
	add	t1,a0,a5
	add	a7,a1,a5
	add	a5,a2,a5
	beqz	a6,.L49
.L52:
	lp.setup  	x1,a6,(.L51)	 # loop setup, lc+le set
.L42:
	p.lw	a4,4(a7!)	# load post inc
	p.lw	t3,4(a5!)	# load post inc
	vfadd.h 	a4,a4,t3	 # FVect Op FVect
.L51:
	p.sw	a4,4(t1!)	# store post inc
	/* loop end a6 .L42 */
	p.bclr 	a4,t5,0,0 # Bit clear
	add	a5,a4,t4
	beq	t5,a4,.L50
.L38:
	sll	a4,a5,1
	p.lhu	a6,a4(a1)	# load reg(reg)
	p.lhu	a7,a4(a2)	# load reg(reg)
	add	a5,a5,1
	fadd.h	a6,a6,a7
	p.sh	a6,a4(a0)	# store reg(reg)
	ble	a3,a5,.L36
	add	a4,a4,2
	p.lhu	a1,a4(a1)	# load reg(reg)
	p.lhu	a2,a4(a2)	# load reg(reg)
	fadd.h	a1,a1,a2
	p.sh	a1,a4(a0)	# store reg(reg)
.L36:
	ret
.L50:
	ret
.L44:
	li	a5,0
	j	.L38
.L49:
	li	a6,1
	j	.L52
	.size	add_f16, .-add_f16
	.align	1
	.globl	axpy_f16
	.type	axpy_f16, @function
axpy_f16:
	blez	a3,.L53
	srl	a5,a0,1
	p.bclr 	a5,a5,30,1 # Bit clear
	add	a4,a3,-1
	add	a6,a5,1
	bltu	a4,a6,.L61
	li	t6,0
	beqz	a5,.L58
	lhu	a6,0(a0)
	lhu	a4,0(a1)
	li	t6,1
	fmadd.h	a4,a2,a4,a6
	sh	a4,0(a0)
.L58:
	sll	a6,a5,1
	sub	t4,a3,a5
	add	a7,a0,a6
	srl	a4,t4,1
	pv.add.sc.h	t5,x0,a2 # Vector insert Scalar Reg
	mv	t1,a7
	add	a6,a1,a6
	beqz	a4,.L66
.L69:
	lp.setup  	x1,a4,(.L68)	 # loop setup, lc+le set
.L59:
	p.lw	a5,4(t1!)	# load post inc
	p.lw	t3,4(a6!)	# load post inc
	vfmac.h	a5,t3,t5
.L68:
	p.sw	a5,4(a7!)	# store post inc
	/* loop end a4 .L59 */
	p.bclr 	a4,t4,0,0 # Bit clear
	add	a5,a4,t6
	beq	t4,a4,.L67
.L55:
	sll	a4,a5,1
	add	a7,a0,a4
	lhu	t1,0(a7)
	p.lhu	a6,a4(a1)	# load reg(reg)
	add	a5,a5,1
	fmadd.h	a6,a6,a2,t1
	sh	a6,0(a7)
	ble	a3,a5,.L53
	add	a4,a4,2
	add	a0,a0,a4
	lhu	a5,0(a0)
	p.lhu	a1,a4(a1)	# load reg(reg)
	fmadd.h	a2,a2,a1,a5
	sh	a2,0(a0)
.L53:
	ret
.L67:
	ret
.L61:
	li	a5,0
	j	.L55
.L66:
	li	a4,1
	j	.L69
	.size	axpy_f16, .-axpy_f16
	.align	1
	.globl	scale_f16
	.type	scale_f16, @function
scale_f16:
	blez	a3,.L70
	srl	a5,a1,1
	add	a4,a3,-1
	li	a6,1
	p.bclr 	a5,a5,30,1 # Bit clear
	bleu	a4,a6,.L76
	li	t3,0
	beqz	a5,.L73
	lhu	a4,0(a1)
	li	t3,1
	fmul.h	a4,a4,a2
	sh	a4,0(a0)
.L73:
	sub	t4,a3,a5
	srl	a6,t4,1
	sll	a5,a5,1
	add	a7,a0,a5
	pv.add.sc.h	t1,x0,a2 # Vector insert Scalar Reg
	add	a5,a1,a5
	beqz	a6,.L81
.L84:
	lp.setup  	x1,a6,(.L83)	 # loop setup, lc+le set
.L74:
	p.lw	a4,4(a5!)	# load post inc
	vfmul.h 	a4,a4,t1	 # FVect Op FVect
.L83:
	p.sw	a4,4(a7!)	# store post inc
	/* loop end a6 .L74 */
	p.bclr 	a4,t4,0,0 # Bit clear
	add	a5,a4,t3
	beq	t4,a4,.L82
.L72:
	sll	a4,a5,1
	p.lhu	a6,a4(a1)	# load reg(reg)
	add	a5,a5,1
	fmul.h	a6,a6,a2
	p.sh	a6,a4(a0)	# store reg(reg)
	ble	a3,a5,.L70
	add	a4,a4,2
	p.lhu	a1,a4(a1)	# load reg(reg)
	fmul.h	a2,a1,a2
	p.sh	a2,a4(a0)	# store reg(reg)
.L70:
	ret
.L82:
	ret
.L76:
	li	a5,0
	j	.L72
.L81:
	li	a6,1
	j	.L84
	.size	scale_f16, .-scale_f16
	.align	1
	.globl	max_f16
	.type	max_f16, @function
max_f16:
	blez	a3,.L85
	sll	a3,a3,1
	add	a6,a1,a3
.L87:
	p.lhu	a4,2(a1!)	# load post inc
	p.lhu	a5,2(a2!)	# load post inc
	flt.h	a3,a5,a4
	beqz	a3,.L92
	p.sh	a4,2(a0!)	# store post inc
	bne	a1,a6,.L87
	ret
.L92:
	p.sh	a5,2(a0!)	# store post inc
	bne	a1,a6,.L87
.L85:
	ret
	.size	max_f16, .-max_f16
	.align	1
	.globl	magsq_f16
	.type	magsq_f16, @function
magsq_f16:
	blez	a2,.L93
	p.beqimm	a2,1,.L98
	srl	a3,a2,1
	mv	t1,a1
	add	a7,a1,4
	mv	t3,a0
	beqz	a3,.L101
.L104:
	lp.setup  	x1,a3,(.L103)	 # loop setup, lc+le set
.L96:
	p.lw	a4,8(t1!)	# load post modify imm
	p.lw	a6,8(a7!)	# load post modify imm
	pv.pack.h.h 	a5,a6,a4 	# Pack2 high
	vfmul.h 	a5,a5,a5	 # FVect Op FVect
	pv.pack.h 	a4,a6,a4 	# Vector pack of 2 shorts (perm)
	vfmac.h	a5,a4,a4
.L103:
	p.sw	a5,4(t3!)	# store post inc
	/* loop end a3 .L96 */
	p.bclr 	a4,a2,0,0 # Bit clear
	beq	a4,a2,.L102
.L95:
	sll	a5,a4,2
	add	a3,a1,a5
	p.lhu	a1,a5(a1)	# load reg(reg)
	lhu	a5,2(a3)
	sll	a4,a4,1
	fmul.h	a5,a5,a5
	fmadd.h	a1,a1,a1,a5
	p.sh	a1,a4(a0)	# store reg(reg)
.L93:
	ret
.L102:
	ret
.L98:
	li	a4,0
	j	.L95
.L101:
	li	a3,1
	j	.L104
	.size	magsq_f16, .-magsq_f16
	.align	1
	.globl	dot_f16
	.type	dot_f16, @function
dot_f16:
	mv	a4,a0
	blez	a2,.L108
	sll	a5,a2,1
	add	a5,a5,-2
	mv	a0,zero
	srl	a5,a5,1
	add	a5,a5,1
	lp.setup  	x1,a5,(.L110)	 # loop setup, lc+le set
.L107:
	p.lhu	a2,2(a4!)	# load post inc
	p.lhu	a3,2(a1!)	# load post inc
.L110:
	fmadd.h	a0,a2,a3,a0
	/* loop end a5 .L107 */
	ret
.L108:
	mv	a0,zero
	ret
	.size	dot_f16, .-dot_f16
	.align	1
	.globl	win_f16_nr
	.type	win_f16_nr, @function
win_f16_nr:
	blez	a2,.L111
	add	a5,a1,4
	add	a3,a0,4
	p.sletu	a5,a5,a0
	p.sletu	a3,a3,a1
	mv	a4,a5
	mv	a5,a3
	or	a5,a4,a5
	and	a5,a5,0xff
	beqz	a5,.L113
	sltu	a5,a2,5
	xor	a5,a5,1
	and	a5,a5,0xff
	beqz	a5,.L113
	srl	a5,a0,1
	p.bclr 	a5,a5,30,1 # Bit clear
	li	t4,0
	beqz	a5,.L114
	lhu	a4,0(a0)
	lhu	a3,0(a1)
	li	t4,1
	fmul.h	a4,a4,a3
	sh	a4,0(a0)
.L114:
	sll	a3,a5,1
	sub	t3,a2,a5
	add	a6,a0,a3
	srl	a4,t3,1
	mv	a7,a6
	add	a3,a1,a3
	beqz	a4,.L130
.L133:
	lp.setup  	x1,a4,(.L132)	 # loop setup, lc+le set
.L115:
	p.lw	a5,4(a7!)	# load post inc
	p.lw	t1,4(a3!)	# load post inc
	vfmul.h 	a5,a5,t1	 # FVect Op FVect
.L132:
	p.sw	a5,4(a6!)	# store post inc
	/* loop end a4 .L115 */
	p.bclr 	a5,t3,0,0 # Bit clear
	add	t4,a5,t4
	beq	t3,a5,.L111
	sll	a5,t4,1
	add	a3,a0,a5
	lhu	a4,0(a3)
	p.lhu	a6,a5(a1)	# load reg(reg)
	add	t4,t4,1
	fmul.h	a4,a4,a6
	sh	a4,0(a3)
	ble	a2,t4,.L111
	add	a5,a5,2
	add	a0,a0,a5
	lhu	a4,0(a0)
	p.lhu	a5,a5(a1)	# load reg(reg)
	fmul.h	a5,a4,a5
	sh	a5,0(a0)
	ret
.L113:
	sll	a5,a2,1
	add	a5,a5,-2
	srl	a5,a5,1
	add	a5,a5,1
	lp.setup  	x1,a5,(.L131)	 # loop setup, lc+le set
.L117:
	lhu	a4,0(a0)
	p.lhu	a3,2(a1!)	# load post inc
	fmul.h	a4,a4,a3
.L131:
	p.sh	a4,2(a0!)	# store post inc
	/* loop end a5 .L117 */
.L111:
	ret
.L130:
	li	a4,1
	j	.L133
	.size	win_f16_nr, .-win_f16_nr
	.align	1
	.globl	win_f16_k256
	.type	win_f16_k256, @function
win_f16_k256:
	srl	a5,a0,1
	p.bclr 	a5,a5,30,1 # Bit clear
	li	a4,0
	beqz	a5,.L135
	lhu	a3,0(a0)
	lhu	a2,0(a1)
	li	a4,1
	fmul.h	a3,a3,a2
	sh	a3,0(a0)
.L135:
	li	t3,256
	sll	a2,a5,1
	sub	t3,t3,a5
	add	a6,a0,a2
	srl	a3,t3,1
	mv	a7,a6
	add	a2,a1,a2
	beqz	a3,.L142
.L144:
	lp.setup  	x1,a3,(.L143)	 # loop setup, lc+le set
.L136:
	p.lw	a5,4(a7!)	# load post inc
	p.lw	t1,4(a2!)	# load post inc
	vfmul.h 	a5,a5,t1	 # FVect Op FVect
.L143:
	p.sw	a5,4(a6!)	# store post inc
	/* loop end a3 .L136 */
	p.bclr 	a3,t3,0,0 # Bit clear
	add	a5,a3,a4
	beq	t3,a3,.L134
	sll	a5,a5,1
	add	a0,a0,a5
	lhu	a4,0(a0)
	p.lhu	a5,a5(a1)	# load reg(reg)
	fmul.h	a5,a4,a5
	sh	a5,0(a0)
.L134:
	ret
.L142:
	li	a3,1
	j	.L144
	.size	win_f16_k256, .-win_f16_k256
	.ident	"GCC: (GNU) 7.1.1 20170509"
