	.file	"loops2.c"
	.option nopic
	.text
	.align	1
	.globl	add16
	.type	add16, @function
add16:
	blez	a3,.L1
	srl	a5,a1,1
	p.bclr 	a5,a5,30,1 # Bit clear
	add	a4,a3,-1
	add	a6,a5,1
	bltu	a4,a6,.L9
	li	t4,0
	beqz	a5,.L6
	lhu	a4,0(a2)
	lhu	a6,0(a1)
	li	t4,1
	add	a4,a4,a6
	sh	a4,0(a0)
.L6:
	sub	t5,a3,a5
	srl	a6,t5,1
	sll	a5,a5,1
	add	t1,a0,a5
	add	a7,a1,a5
	add	a5,a2,a5
	beqz	a6,.L15
.L18:
	lp.setup  	x1,a6,(.L17)	 # loop setup, lc+le set
.L7:
	p.lw	a4,4(a7!)	# load post inc
	p.lw	t3,4(a5!)	# load post inc
	pv.add.h 	a4,a4,t3	 # Vect Op Vect
.L17:
	p.sw	a4,4(t1!)	# store post inc
	/* loop end a6 .L7 */
	p.bclr 	a4,t5,0,0 # Bit clear
	add	a5,a4,t4
	beq	t5,a4,.L16
.L3:
	sll	a4,a5,1
	p.lhu	a6,a4(a1)
	p.lhu	a7,a4(a2)
	add	a5,a5,1
	add	a6,a6,a7
	p.sh	a6,a4(a0)	# store reg(reg)
	ble	a3,a5,.L1
	add	a4,a4,2
	p.lhu	a5,a4(a1)
	p.lhu	a3,a4(a2)
	add	a5,a5,a3
	p.sh	a5,a4(a0)	# store reg(reg)
.L1:
	ret
.L16:
	ret
.L9:
	li	a5,0
	j	.L3
.L15:
	li	a6,1
	j	.L18
	.size	add16, .-add16
	.align	1
	.globl	add8
	.type	add8, @function
add8:
	blez	a3,.L19
	sub	a4,zero,a1
	p.bclr 	a4,a4,29,2 # Bit clear
	add	a5,a3,-1
	add	a6,a4,3
	bltu	a5,a6,.L26
	li	t3,0
	beqz	a4,.L22
	lbu	a5,0(a1)
	lbu	a6,0(a2)
	li	t3,1
	add	a5,a5,a6
	sb	a5,0(a0)
	p.beqimm	a4,1,.L22
	lbu	a5,1(a1)
	lbu	a6,1(a2)
	li	t3,2
	add	a5,a5,a6
	sb	a5,1(a0)
	p.bneimm	a4,3,.L22
	lbu	a5,2(a2)
	lbu	a6,2(a1)
	li	t3,3
	add	a5,a5,a6
	sb	a5,2(a0)
.L22:
	sub	t5,a3,a4
	srl	a6,t5,2
	add	a7,a0,a4
	add	t1,a1,a4
	add	a4,a2,a4
	beqz	a6,.L34
.L37:
	lp.setup  	x1,a6,(.L36)	 # loop setup, lc+le set
.L24:
	p.lw	a5,4(t1!)	# load post inc
	p.lw	t4,4(a4!)	# load post inc
	pv.add.b 	a5,a5,t4	 # Vect Op Vect
.L36:
	p.sw	a5,4(a7!)	# store post inc
	/* loop end a6 .L24 */
	p.bclr 	a4,t5,1,0 # Bit clear
	add	a5,a4,t3
	beq	t5,a4,.L35
.L21:
	p.lbu	a6,a5(a1)
	p.lbu	a7,a5(a2)
	add	a4,a5,1
	add	a6,a6,a7
	p.sb	a6,a5(a0)	# store reg(reg)
	ble	a3,a4,.L19
	p.lbu	a7,a4(a1)
	p.lbu	t1,a4(a2)
	add	a6,a5,2
	add	a7,a7,t1
	p.sb	a7,a4(a0)	# store reg(reg)
	ble	a3,a6,.L19
	p.lbu	a7,a6(a1)
	p.lbu	t1,a6(a2)
	add	a4,a5,3
	add	a7,a7,t1
	p.sb	a7,a6(a0)	# store reg(reg)
	ble	a3,a4,.L19
	p.lbu	a7,a4(a1)
	p.lbu	t1,a4(a2)
	add	a6,a5,4
	add	a7,a7,t1
	p.sb	a7,a4(a0)	# store reg(reg)
	ble	a3,a6,.L19
	p.lbu	a4,a6(a1)
	p.lbu	a7,a6(a2)
	add	a5,a5,5
	add	a4,a4,a7
	p.sb	a4,a6(a0)	# store reg(reg)
	ble	a3,a5,.L19
	p.lbu	a4,a5(a1)
	p.lbu	a3,a5(a2)
	add	a4,a4,a3
	p.sb	a4,a5(a0)	# store reg(reg)
.L19:
	ret
.L35:
	ret
.L26:
	li	a5,0
	j	.L21
.L34:
	li	a6,1
	j	.L37
	.size	add8, .-add8
	.align	1
	.globl	sub16
	.type	sub16, @function
sub16:
	blez	a3,.L38
	srl	a5,a1,1
	p.bclr 	a5,a5,30,1 # Bit clear
	add	a4,a3,-1
	add	a6,a5,1
	bltu	a4,a6,.L46
	li	t4,0
	beqz	a5,.L43
	lhu	a4,0(a1)
	lhu	a6,0(a2)
	li	t4,1
	sub	a4,a4,a6
	sh	a4,0(a0)
.L43:
	sub	t5,a3,a5
	srl	a6,t5,1
	sll	a5,a5,1
	add	t1,a0,a5
	add	a7,a1,a5
	add	a5,a2,a5
	beqz	a6,.L51
.L54:
	lp.setup  	x1,a6,(.L53)	 # loop setup, lc+le set
.L44:
	p.lw	a4,4(a7!)	# load post inc
	p.lw	t3,4(a5!)	# load post inc
	pv.sub.h 	a4,a4,t3	 # Vect Op Vect
.L53:
	p.sw	a4,4(t1!)	# store post inc
	/* loop end a6 .L44 */
	p.bclr 	a4,t5,0,0 # Bit clear
	add	a5,a4,t4
	beq	t5,a4,.L52
.L40:
	sll	a4,a5,1
	p.lhu	a6,a4(a1)
	p.lhu	a7,a4(a2)
	add	a5,a5,1
	sub	a6,a6,a7
	p.sh	a6,a4(a0)	# store reg(reg)
	ble	a3,a5,.L38
	add	a4,a4,2
	p.lhu	a5,a4(a1)
	p.lhu	a3,a4(a2)
	sub	a5,a5,a3
	p.sh	a5,a4(a0)	# store reg(reg)
.L38:
	ret
.L52:
	ret
.L46:
	li	a5,0
	j	.L40
.L51:
	li	a6,1
	j	.L54
	.size	sub16, .-sub16
	.align	1
	.globl	and16
	.type	and16, @function
and16:
	blez	a3,.L55
	srl	a5,a1,1
	p.bclr 	a5,a5,30,1 # Bit clear
	add	a4,a3,-1
	add	a6,a5,1
	bltu	a4,a6,.L63
	li	t4,0
	beqz	a5,.L60
	lhu	a4,0(a2)
	lhu	a6,0(a1)
	li	t4,1
	and	a4,a4,a6
	sh	a4,0(a0)
.L60:
	sub	t5,a3,a5
	srl	a6,t5,1
	sll	a5,a5,1
	add	t1,a0,a5
	add	a7,a1,a5
	add	a5,a2,a5
	beqz	a6,.L68
.L71:
	lp.setup  	x1,a6,(.L70)	 # loop setup, lc+le set
.L61:
	p.lw	a4,4(a7!)	# load post inc
	p.lw	t3,4(a5!)	# load post inc
	pv.and.h 	a4,a4,t3	 # Logical Vect Op Vect
.L70:
	p.sw	a4,4(t1!)	# store post inc
	/* loop end a6 .L61 */
	p.bclr 	a4,t5,0,0 # Bit clear
	add	a5,a4,t4
	beq	t5,a4,.L69
.L57:
	sll	a4,a5,1
	p.lhu	a6,a4(a1)
	p.lhu	a7,a4(a2)
	add	a5,a5,1
	and	a6,a6,a7
	p.sh	a6,a4(a0)	# store reg(reg)
	ble	a3,a5,.L55
	add	a4,a4,2
	p.lhu	a5,a4(a1)
	p.lhu	a3,a4(a2)
	and	a5,a5,a3
	p.sh	a5,a4(a0)	# store reg(reg)
.L55:
	ret
.L69:
	ret
.L63:
	li	a5,0
	j	.L57
.L68:
	li	a6,1
	j	.L71
	.size	and16, .-and16
	.align	1
	.globl	min16
	.type	min16, @function
min16:
	blez	a3,.L72
	srl	a5,a2,1
	p.bclr 	a5,a5,30,1 # Bit clear
	add	a4,a3,-1
	add	a6,a5,1
	bltu	a4,a6,.L80
	li	t4,0
	beqz	a5,.L77
	lh	a4,0(a1)
	lh	a6,0(a2)
	li	t4,1
	p.min 	a4,a4,a6	# signed min
	sh	a4,0(a0)
.L77:
	sub	t5,a3,a5
	srl	a6,t5,1
	sll	a5,a5,1
	add	t1,a0,a5
	add	a7,a2,a5
	add	a5,a1,a5
	beqz	a6,.L85
.L88:
	lp.setup  	x1,a6,(.L87)	 # loop setup, lc+le set
.L78:
	p.lw	a4,4(a7!)	# load post inc
	p.lw	t3,4(a5!)	# load post inc
	pv.min.h 	a4,a4,t3	 # Vect Op Vect
.L87:
	p.sw	a4,4(t1!)	# store post inc
	/* loop end a6 .L78 */
	p.bclr 	a4,t5,0,0 # Bit clear
	add	a5,a4,t4
	beq	t5,a4,.L86
.L74:
	sll	a4,a5,1
	add	a6,a2,a4
	add	a7,a1,a4
	lh	a6,0(a6)
	lh	a7,0(a7)
	add	a5,a5,1
	p.min 	a6,a6,a7	# signed min
	p.sh	a6,a4(a0)	# store reg(reg)
	ble	a3,a5,.L72
	add	a4,a4,2
	add	a2,a2,a4
	add	a1,a1,a4
	lh	a5,0(a2)
	lh	a3,0(a1)
	p.min 	a5,a5,a3	# signed min
	p.sh	a5,a4(a0)	# store reg(reg)
.L72:
	ret
.L86:
	ret
.L80:
	li	a5,0
	j	.L74
.L85:
	li	a6,1
	j	.L88
	.size	min16, .-min16
	.align	1
	.globl	max8
	.type	max8, @function
max8:
	blez	a3,.L89
	sub	a4,zero,a2
	p.bclr 	a4,a4,29,2 # Bit clear
	add	a5,a3,-1
	add	a6,a4,3
	bltu	a5,a6,.L96
	li	t5,0
	beqz	a4,.L92
	lb	a5,0(a2)
	lb	a6,0(a1)
	li	t5,1
	p.max 	a5,a5,a6	# signed max
	sb	a5,0(a0)
	p.beqimm	a4,1,.L92
	lb	a5,1(a2)
	lb	a6,1(a1)
	li	t5,2
	p.max 	a5,a5,a6	# signed max
	sb	a5,1(a0)
	p.bneimm	a4,3,.L92
	lb	a5,2(a1)
	lb	a6,2(a2)
	li	t5,3
	p.max 	a5,a5,a6	# signed max
	sb	a5,2(a0)
.L92:
	sub	t4,a3,a4
	srl	a6,t4,2
	add	a7,a0,a4
	add	t1,a2,a4
	add	a4,a1,a4
	beqz	a6,.L104
.L107:
	lp.setup  	x1,a6,(.L106)	 # loop setup, lc+le set
.L94:
	p.lw	a5,4(t1!)	# load post inc
	p.lw	t3,4(a4!)	# load post inc
	pv.max.b 	a5,a5,t3	 # Vect Op Vect
.L106:
	p.sw	a5,4(a7!)	# store post inc
	/* loop end a6 .L94 */
	p.bclr 	a4,t4,1,0 # Bit clear
	add	a5,a4,t5
	beq	t4,a4,.L105
.L91:
	add	a4,a1,a5
	add	a6,a2,a5
	lb	a7,0(a4)
	lb	a6,0(a6)
	add	a4,a5,1
	p.max 	a6,a6,a7	# signed max
	p.sb	a6,a5(a0)	# store reg(reg)
	ble	a3,a4,.L89
	add	a6,a1,a4
	add	a7,a2,a4
	lb	t1,0(a6)
	lb	a7,0(a7)
	add	a6,a5,2
	p.max 	a7,a7,t1	# signed max
	p.sb	a7,a4(a0)	# store reg(reg)
	ble	a3,a6,.L89
	add	a4,a1,a6
	add	a7,a2,a6
	lb	t1,0(a4)
	lb	a7,0(a7)
	add	a4,a5,3
	p.max 	a7,a7,t1	# signed max
	p.sb	a7,a6(a0)	# store reg(reg)
	ble	a3,a4,.L89
	add	a6,a1,a4
	add	a7,a2,a4
	lb	t1,0(a6)
	lb	a7,0(a7)
	add	a6,a5,4
	p.max 	a7,a7,t1	# signed max
	p.sb	a7,a4(a0)	# store reg(reg)
	ble	a3,a6,.L89
	add	a4,a2,a6
	add	a7,a1,a6
	lb	a4,0(a4)
	lb	a7,0(a7)
	add	a5,a5,5
	p.max 	a4,a4,a7	# signed max
	p.sb	a4,a6(a0)	# store reg(reg)
	ble	a3,a5,.L89
	add	a2,a2,a5
	add	a1,a1,a5
	lb	a4,0(a2)
	lb	a3,0(a1)
	p.max 	a4,a4,a3	# signed max
	p.sb	a4,a5(a0)	# store reg(reg)
.L89:
	ret
.L105:
	ret
.L96:
	li	a5,0
	j	.L91
.L104:
	li	a6,1
	j	.L107
	.size	max8, .-max8
	.align	1
	.globl	maxu8
	.type	maxu8, @function
maxu8:
	blez	a3,.L108
	sub	a4,zero,a2
	p.bclr 	a4,a4,29,2 # Bit clear
	add	a5,a3,-1
	add	a6,a4,3
	bltu	a5,a6,.L115
	li	t5,0
	beqz	a4,.L111
	lbu	a5,0(a2)
	lbu	a6,0(a1)
	li	t5,1
	p.maxu 	a5,a5,a6	# signed max
	sb	a5,0(a0)
	p.beqimm	a4,1,.L111
	lbu	a5,1(a2)
	lbu	a6,1(a1)
	li	t5,2
	p.maxu 	a5,a5,a6	# signed max
	sb	a5,1(a0)
	p.bneimm	a4,3,.L111
	lbu	a5,2(a1)
	lbu	a6,2(a2)
	li	t5,3
	p.maxu 	a5,a5,a6	# signed max
	sb	a5,2(a0)
.L111:
	sub	t4,a3,a4
	srl	a6,t4,2
	add	a7,a0,a4
	add	t1,a2,a4
	add	a4,a1,a4
	beqz	a6,.L123
.L126:
	lp.setup  	x1,a6,(.L125)	 # loop setup, lc+le set
.L113:
	p.lw	a5,4(t1!)	# load post inc
	p.lw	t3,4(a4!)	# load post inc
	pv.maxu.b 	a5,a5,t3	 # VectU Op Vect
.L125:
	p.sw	a5,4(a7!)	# store post inc
	/* loop end a6 .L113 */
	p.bclr 	a4,t4,1,0 # Bit clear
	add	a5,a4,t5
	beq	t4,a4,.L124
.L110:
	add	a4,a1,a5
	add	a6,a2,a5
	lbu	a7,0(a4)
	lbu	a6,0(a6)
	add	a4,a5,1
	p.maxu 	a6,a6,a7	# signed max
	p.sb	a6,a5(a0)	# store reg(reg)
	ble	a3,a4,.L108
	add	a6,a1,a4
	add	a7,a2,a4
	lbu	t1,0(a6)
	lbu	a7,0(a7)
	add	a6,a5,2
	p.maxu 	a7,a7,t1	# signed max
	p.sb	a7,a4(a0)	# store reg(reg)
	ble	a3,a6,.L108
	add	a4,a1,a6
	add	a7,a2,a6
	lbu	t1,0(a4)
	lbu	a7,0(a7)
	add	a4,a5,3
	p.maxu 	a7,a7,t1	# signed max
	p.sb	a7,a6(a0)	# store reg(reg)
	ble	a3,a4,.L108
	add	a6,a1,a4
	add	a7,a2,a4
	lbu	t1,0(a6)
	lbu	a7,0(a7)
	add	a6,a5,4
	p.maxu 	a7,a7,t1	# signed max
	p.sb	a7,a4(a0)	# store reg(reg)
	ble	a3,a6,.L108
	add	a4,a2,a6
	add	a7,a1,a6
	lbu	a4,0(a4)
	lbu	a7,0(a7)
	add	a5,a5,5
	p.maxu 	a4,a4,a7	# signed max
	p.sb	a4,a6(a0)	# store reg(reg)
	ble	a3,a5,.L108
	add	a2,a2,a5
	add	a1,a1,a5
	lbu	a4,0(a2)
	lbu	a3,0(a1)
	p.maxu 	a4,a4,a3	# signed max
	p.sb	a4,a5(a0)	# store reg(reg)
.L108:
	ret
.L124:
	ret
.L115:
	li	a5,0
	j	.L110
.L123:
	li	a6,1
	j	.L126
	.size	maxu8, .-maxu8
	.align	1
	.globl	abs16
	.type	abs16, @function
abs16:
	blez	a2,.L127
	sll	a4,a2,1
	add	a4,a4,-2
	srl	a4,a4,1
	add	a4,a4,1
	lp.setup  	x1,a4,(.L131)	 # loop setup, lc+le set
.L129:
	p.lh	a5,2(a1!)	# load post inc, ext
	p.abs	a5,a5
.L131:
	p.sh	a5,2(a0!)	# store post inc
	/* loop end a4 .L129 */
.L127:
	ret
	.size	abs16, .-abs16
	.align	1
	.globl	shr16
	.type	shr16, @function
shr16:
	blez	a2,.L132
	srl	a5,a1,1
	add	a4,a2,-1
	li	a3,1
	p.bclr 	a5,a5,30,1 # Bit clear
	bleu	a4,a3,.L138
	li	a7,0
	beqz	a5,.L135
	lh	a4,0(a1)
	li	a7,1
	sra	a4,a4,3
	sh	a4,0(a0)
.L135:
	sub	t1,a2,a5
	srl	a3,t1,1
	sll	a5,a5,1
	add	a6,a0,a5
	add	a5,a1,a5
	beqz	a3,.L143
.L146:
	lp.setup  	x1,a3,(.L145)	 # loop setup, lc+le set
.L136:
	p.lw	a4,4(a5!)	# load post inc
	pv.sra.sci.h 	a4,a4,3	 # Vect Shift Immediate Scalar
.L145:
	p.sw	a4,4(a6!)	# store post inc
	/* loop end a3 .L136 */
	p.bclr 	a4,t1,0,0 # Bit clear
	add	a5,a4,a7
	beq	t1,a4,.L144
.L134:
	sll	a4,a5,1
	add	a3,a1,a4
	lh	a3,0(a3)
	add	a5,a5,1
	sra	a3,a3,3
	p.sh	a3,a4(a0)	# store reg(reg)
	ble	a2,a5,.L132
	add	a4,a4,2
	add	a1,a1,a4
	lh	a5,0(a1)
	sra	a5,a5,3
	p.sh	a5,a4(a0)	# store reg(reg)
.L132:
	ret
.L144:
	ret
.L138:
	li	a5,0
	j	.L134
.L143:
	li	a3,1
	j	.L146
	.size	shr16, .-shr16
	.align	1
	.globl	shl8
	.type	shl8, @function
shl8:
	blez	a2,.L147
	sub	a4,zero,a1
	p.bclr 	a4,a4,29,2 # Bit clear
	add	a5,a2,-1
	add	a3,a4,3
	bltu	a5,a3,.L154
	li	a7,0
	beqz	a4,.L150
	lbu	a5,0(a1)
	li	a7,1
	sll	a5,a5,2
	sb	a5,0(a0)
	p.beqimm	a4,1,.L150
	lbu	a5,1(a1)
	li	a7,2
	sll	a5,a5,2
	sb	a5,1(a0)
	p.bneimm	a4,3,.L150
	lbu	a5,2(a1)
	li	a7,3
	sll	a5,a5,2
	sb	a5,2(a0)
.L150:
	sub	t1,a2,a4
	srl	a3,t1,2
	add	a6,a0,a4
	add	a4,a1,a4
	beqz	a3,.L162
.L165:
	lp.setup  	x1,a3,(.L164)	 # loop setup, lc+le set
.L152:
	p.lw	a5,4(a4!)	# load post inc
	pv.sll.sci.b 	a5,a5,2	 # Vect Shift Immediate Scalar
.L164:
	p.sw	a5,4(a6!)	# store post inc
	/* loop end a3 .L152 */
	p.bclr 	a4,t1,1,0 # Bit clear
	add	a5,a4,a7
	beq	t1,a4,.L163
.L149:
	p.lbu	a4,a5(a1)
	add	a3,a5,1
	sll	a4,a4,2
	p.sb	a4,a5(a0)	# store reg(reg)
	ble	a2,a3,.L147
	p.lbu	a4,a3(a1)
	add	a6,a5,2
	sll	a4,a4,2
	p.sb	a4,a3(a0)	# store reg(reg)
	ble	a2,a6,.L147
	p.lbu	a4,a6(a1)
	add	a3,a5,3
	sll	a4,a4,2
	p.sb	a4,a6(a0)	# store reg(reg)
	ble	a2,a3,.L147
	p.lbu	a4,a3(a1)
	add	a6,a5,4
	sll	a4,a4,2
	p.sb	a4,a3(a0)	# store reg(reg)
	ble	a2,a6,.L147
	p.lbu	a4,a6(a1)
	add	a5,a5,5
	sll	a4,a4,2
	p.sb	a4,a6(a0)	# store reg(reg)
	ble	a2,a5,.L147
	p.lbu	a4,a5(a1)
	sll	a4,a4,2
	p.sb	a4,a5(a0)	# store reg(reg)
.L147:
	ret
.L163:
	ret
.L154:
	li	a5,0
	j	.L149
.L162:
	li	a3,1
	j	.L165
	.size	shl8, .-shl8
	.align	1
	.globl	shrv16
	.type	shrv16, @function
shrv16:
	blez	a3,.L166
	sll	a4,a3,1
	add	a4,a4,-2
	srl	a4,a4,1
	add	a4,a4,1
	lp.setup  	x1,a4,(.L170)	 # loop setup, lc+le set
.L168:
	p.lh	a5,2(a1!)	# load post inc, ext
	sra	a5,a5,a2
.L170:
	p.sh	a5,2(a0!)	# store post inc
	/* loop end a4 .L168 */
.L166:
	ret
	.size	shrv16, .-shrv16
	.align	1
	.globl	addc16
	.type	addc16, @function
addc16:
	blez	a2,.L171
	srl	a4,a1,1
	p.bclr 	a4,a4,30,1 # Bit clear
	add	a5,a2,-1
	add	a3,a4,1
	bltu	a5,a3,.L179
	li	a7,0
	beqz	a4,.L176
	lhu	a5,0(a1)
	li	a7,1
	add	a5,a5,5
	sh	a5,0(a0)
.L176:
	sub	t1,a2,a4
	srl	a3,t1,1
	sll	a4,a4,1
	add	a6,a0,a4
	add	a4,a1,a4
	beqz	a3,.L184
.L187:
	lp.setup  	x1,a3,(.L186)	 # loop setup, lc+le set
.L177:
	p.lw	a5,4(a4!)	# load post inc
	pv.add.sci.h 	a5,a5,5	 # Vect Op Immediate Scalar
.L186:
	p.sw	a5,4(a6!)	# store post inc
	/* loop end a3 .L177 */
	p.bclr 	a4,t1,0,0 # Bit clear
	add	a5,a4,a7
	beq	t1,a4,.L185
.L173:
	sll	a4,a5,1
	p.lhu	a3,a4(a1)
	add	a5,a5,1
	add	a3,a3,5
	p.sh	a3,a4(a0)	# store reg(reg)
	ble	a2,a5,.L171
	add	a4,a4,2
	p.lhu	a5,a4(a1)
	add	a5,a5,5
	p.sh	a5,a4(a0)	# store reg(reg)
.L171:
	ret
.L185:
	ret
.L179:
	li	a5,0
	j	.L173
.L184:
	li	a3,1
	j	.L187
	.size	addc16, .-addc16
	.align	1
	.globl	adds16
	.type	adds16, @function
adds16:
	blez	a3,.L188
	srl	a4,a1,1
	p.bclr 	a4,a4,30,1 # Bit clear
	add	a5,a3,-1
	add	a6,a4,1
	p.exthz	a2,a2
	bltu	a5,a6,.L196
	li	t3,0
	beqz	a4,.L193
	lhu	a5,0(a1)
	li	t3,1
	add	a5,a2,a5
	sh	a5,0(a0)
.L193:
	sub	t4,a3,a4
	srl	a6,t4,1
	sll	a4,a4,1
	add	a7,a0,a4
	pv.add.sc.h	t1,x0,a2 # Vector insert Scalar Reg
	add	a4,a1,a4
	beqz	a6,.L201
.L204:
	lp.setup  	x1,a6,(.L203)	 # loop setup, lc+le set
.L194:
	p.lw	a5,4(a4!)	# load post inc
	pv.add.h 	a5,a5,t1	 # Vect Op Vect
.L203:
	p.sw	a5,4(a7!)	# store post inc
	/* loop end a6 .L194 */
	p.bclr 	a4,t4,0,0 # Bit clear
	add	a5,a4,t3
	beq	t4,a4,.L202
.L190:
	sll	a4,a5,1
	p.lhu	a6,a4(a1)
	add	a5,a5,1
	add	a6,a2,a6
	p.sh	a6,a4(a0)	# store reg(reg)
	ble	a3,a5,.L188
	add	a4,a4,2
	p.lhu	a5,a4(a1)
	add	a2,a2,a5
	p.sh	a2,a4(a0)	# store reg(reg)
.L188:
	ret
.L202:
	ret
.L196:
	li	a5,0
	j	.L190
.L201:
	li	a6,1
	j	.L204
	.size	adds16, .-adds16
	.align	1
	.globl	scale16
	.type	scale16, @function
scale16:
	blez	a2,.L205
	srl	a5,a1,1
	add	a4,a2,-1
	li	a3,1
	p.bclr 	a5,a5,30,1 # Bit clear
	bleu	a4,a3,.L211
	li	t1,0
	beqz	a5,.L208
	lhu	a3,0(a1)
	li	a4,3
	li	t1,1
	p.mulu 	a4,a4,a3
	sh	a4,0(a0)
.L208:
	sub	t3,a2,a5
	srl	a3,t3,1
	sll	a5,a5,1
	add	a7,a0,a5
	add	a5,a1,a5
	beqz	a3,.L216
.L219:
	lp.setup  	x1,a3,(.L218)	 # loop setup, lc+le set
.L209:
	p.lw	a6,4(a5!)	# load post inc
	pv.sll.sci.h 	a4,a6,1	 # Vect Shift Immediate Scalar
	pv.add.h 	a4,a4,a6	 # Vect Op Vect
.L218:
	p.sw	a4,4(a7!)	# store post inc
	/* loop end a3 .L209 */
	p.bclr 	a4,t3,0,0 # Bit clear
	add	a5,a4,t1
	beq	t3,a4,.L217
.L207:
	sll	a4,a5,1
	p.lhu	a6,a4(a1)
	li	a3,3
	add	a5,a5,1
	p.mulu 	a6,a3,a6
	p.sh	a6,a4(a0)	# store reg(reg)
	ble	a2,a5,.L205
	add	a4,a4,2
	p.lhu	a5,a4(a1)
	p.mulu 	a3,a3,a5
	p.sh	a3,a4(a0)	# store reg(reg)
.L205:
	ret
.L217:
	ret
.L211:
	li	a5,0
	j	.L207
.L216:
	li	a3,1
	j	.L219
	.size	scale16, .-scale16
	.align	1
	.globl	scaleq15
	.type	scaleq15, @function
scaleq15:
	blez	a3,.L220
	sll	a4,a3,1
	add	a4,a4,-2
	srl	a4,a4,1
	add	a4,a4,1
	lp.setup  	x1,a4,(.L224)	 # loop setup, lc+le set
.L222:
	p.lh	a5,2(a1!)	# load post inc, ext
	p.mul	a5,a5,a2
	sra	a5,a5,15
.L224:
	p.sh	a5,2(a0!)	# store post inc
	/* loop end a4 .L222 */
.L220:
	ret
	.size	scaleq15, .-scaleq15
	.align	1
	.globl	mul16
	.type	mul16, @function
mul16:
	blez	a3,.L225
	sll	a5,a3,1
	add	a5,a5,-2
	srl	a5,a5,1
	add	a5,a5,1
	lp.setup  	x1,a5,(.L229)	 # loop setup, lc+le set
.L227:
	p.lh	a4,2(a1!)	# load post inc, ext
	p.lh	a3,2(a2!)	# load post inc, ext
	p.mulu 	a4,a4,a3
.L229:
	p.sh	a4,2(a0!)	# store post inc
	/* loop end a5 .L227 */
.L225:
	ret
	.size	mul16, .-mul16
	.align	1
	.globl	copy16
	.type	copy16, @function
copy16:
	blez	a2,.L230
	sll	a2,a2,1
	tail	memcpy
.L230:
	ret
	.size	copy16, .-copy16
	.align	1
	.globl	set16
	.type	set16, @function
set16:
	blez	a2,.L232
	srl	a5,a0,1
	add	a4,a2,-1
	li	a3,4
	p.bclr 	a5,a5,30,1 # Bit clear
	bleu	a4,a3,.L238
	li	a3,0
	beqz	a5,.L235
	sh	a1,0(a0)
	li	a3,1
.L235:
	sub	a7,a2,a5
	srl	a4,a7,1
	sll	a5,a5,1
	pv.add.sc.h	a6,x0,a1 # Vector insert Scalar Reg
	add	a5,a0,a5
	beqz	a4,.L243
.L247:
	lp.setup  	x1,a4,(.L246)	 # loop setup, lc+le set
.L236:
	p.sw	a6,4(a5!)	# store post inc
.L246:
	nop
	/* loop end a4 .L236 */
.L245:
	p.bclr 	a4,a7,0,0 # Bit clear
	add	a5,a4,a3
	beq	a7,a4,.L244
.L234:
	sll	a4,a5,1
	p.sh	a1,a4(a0)	# store reg(reg)
	add	a3,a5,1
	ble	a2,a3,.L232
	add	a0,a0,a4
	sh	a1,2(a0)
	add	a4,a5,2
	ble	a2,a4,.L232
	sh	a1,4(a0)
	add	a4,a5,3
	ble	a2,a4,.L232
	sh	a1,6(a0)
	add	a5,a5,4
	ble	a2,a5,.L232
	sh	a1,8(a0)
.L232:
	ret
.L244:
	ret
.L238:
	li	a5,0
	j	.L234
.L243:
	li	a4,1
	p.sw	a6,4(a5!)	# store post inc
	add	a4,a4,-1
	bnez	a4,.L247
	j	.L245
	.size	set16, .-set16
	.align	1
	.globl	avg8
	.type	avg8, @function
avg8:
	blez	a3,.L248
	lp.setup  	x1,a3,(.L252)	 # loop setup, lc+le set
.L250:
	p.lbu	a5,1(a1!)	# load post inc, ext
	p.lbu	a4,1(a2!)	# load post inc, ext
	p.adduRN 	a5,a5,a4,1
.L252:
	p.sb	a5,1(a0!)	# store post inc
	/* loop end a3 .L250 */
.L248:
	ret
	.size	avg8, .-avg8
	.align	1
	.globl	sat16
	.type	sat16, @function
sat16:
	blez	a3,.L253
	sll	a4,a3,1
	add	a4,a4,-2
	srl	a4,a4,1
	li	a6,-32768
	add	a4,a4,1
	lp.setup  	x1,a4,(.L257)	 # loop setup, lc+le set
.L255:
	p.lh	a3,2(a2!)	# load post inc, ext
	p.lh	a5,2(a1!)	# load post inc, ext
	add	a5,a5,a3
	li	a3,32768
	p.max 	a5,a5,a6	# signed max
	add	a3,a3,-1
	p.min 	a5,a5,a3	# signed min
.L257:
	p.sh	a5,2(a0!)	# store post inc
	/* loop end a4 .L255 */
.L253:
	ret
	.size	sat16, .-sat16
	.align	1
	.globl	clip16
	.type	clip16, @function
clip16:
	blez	a2,.L258
	sll	a4,a2,1
	add	a4,a4,-2
	srl	a4,a4,1
	li	a2,-256
	li	a3,255
	add	a4,a4,1
	lp.setup  	x1,a4,(.L262)	 # loop setup, lc+le set
.L260:
	p.lh	a5,2(a1!)	# load post inc, ext
	p.max 	a5,a5,a2	# signed max
	p.min 	a5,a5,a3	# signed min
.L262:
	p.sh	a5,2(a0!)	# store post inc
	/* loop end a4 .L260 */
.L258:
	ret
	.size	clip16, .-clip16
	.align	1
	.globl	relu8
	.type	relu8, @function
relu8:
	blez	a2,.L263
	sub	a4,zero,a1
	p.bclr 	a4,a4,29,2 # Bit clear
	add	a5,a2,-1
	add	a3,a4,3
	bltu	a5,a3,.L270
	li	a7,0
	beqz	a4,.L266
	lb	a5,0(a1)
	li	a7,1
	p.max 	a5,a5,x0	# signed max 0
	sb	a5,0(a0)
	p.beqimm	a4,1,.L266
	lb	a5,1(a1)
	li	a7,2
	p.max 	a5,a5,x0	# signed max 0
	sb	a5,1(a0)
	p.bneimm	a4,3,.L266
	lb	a5,2(a1)
	li	a7,3
	p.max 	a5,a5,x0	# signed max 0
	sb	a5,2(a0)
.L266:
	sub	t1,a2,a4
	srl	a3,t1,2
	add	a6,a0,a4
	add	a4,a1,a4
	beqz	a3,.L278
.L281:
	lp.setup  	x1,a3,(.L280)	 # loop setup, lc+le set
.L268:
	p.lw	a5,4(a4!)	# load post inc
	pv.max.sci.b 	a5,a5,0	 # Vect Op Immediate Scalar
.L280:
	p.sw	a5,4(a6!)	# store post inc
	/* loop end a3 .L268 */
	p.bclr 	a4,t1,1,0 # Bit clear
	add	a5,a4,a7
	beq	t1,a4,.L279
.L265:
	add	a4,a1,a5
	lb	a4,0(a4)
	add	a3,a5,1
	p.max 	a4,a4,x0	# signed max 0
	p.sb	a4,a5(a0)	# store reg(reg)
	ble	a2,a3,.L263
	add	a4,a1,a3
	lb	a4,0(a4)
	add	a6,a5,2
	p.max 	a4,a4,x0	# signed max 0
	p.sb	a4,a3(a0)	# store reg(reg)
	ble	a2,a6,.L263
	add	a4,a1,a6
	lb	a4,0(a4)
	add	a3,a5,3
	p.max 	a4,a4,x0	# signed max 0
	p.sb	a4,a6(a0)	# store reg(reg)
	ble	a2,a3,.L263
	add	a4,a1,a3
	lb	a4,0(a4)
	add	a6,a5,4
	p.max 	a4,a4,x0	# signed max 0
	p.sb	a4,a3(a0)	# store reg(reg)
	ble	a2,a6,.L263
	add	a4,a1,a6
	lb	a4,0(a4)
	add	a5,a5,5
	p.max 	a4,a4,x0	# signed max 0
	p.sb	a4,a6(a0)	# store reg(reg)
	ble	a2,a5,.L263
	add	a1,a1,a5
	lb	a4,0(a1)
	p.max 	a4,a4,x0	# signed max 0
	p.sb	a4,a5(a0)	# store reg(reg)
.L263:
	ret
.L279:
	ret
.L270:
	li	a5,0
	j	.L265
.L278:
	li	a3,1
	j	.L281
	.size	relu8, .-relu8
	.align	1
	.globl	sel16
	.type	sel16, @function
sel16:
	blez	a3,.L282
	srl	a4,a1,1
	p.bclr 	a4,a4,30,1 # Bit clear
	add	a5,a3,-1
	add	a6,a4,1
	bltu	a5,a6,.L295
	li	t5,0
	beqz	a4,.L287
	lh	a5,0(a1)
	lh	a6,0(a2)
	bgt	a5,a6,.L288
	li	a5,0
.L289:
	sh	a5,0(a0)
	li	t5,1
.L287:
	sub	t6,a3,a4
	srl	a6,t6,1
	sll	a4,a4,1
	add	t3,a0,a4
	add	t1,a1,a4
	add	a4,a2,a4
	beqz	a6,.L301
.L305:
	lp.setup  	x1,a6,(.L304)	 # loop setup, lc+le set
.L290:
	p.lw	a5,4(t1!)	# load post inc
	p.lw	a7,4(a4!)	# load post inc
	pv.sub.h 	t4,a5,a7	 # Vect Op Vect
	pv.cmpgt.h	a5,a5,a7 # cmp vect op
	pv.and.h 	a5,a5,t4	 # Logical Vect Op Vect
.L304:
	p.sw	a5,4(t3!)	# store post inc
	/* loop end a6 .L290 */
	p.bclr 	a4,t6,0,0 # Bit clear
	add	a5,a4,t5
	beq	t6,a4,.L302
.L284:
	sll	a4,a5,1
	add	a7,a2,a4
	add	a6,a1,a4
	lh	t1,0(a7)
	lh	a6,0(a6)
	li	a7,0
	bgt	a6,t1,.L303
.L292:
	p.sh	a7,a4(a0)	# store reg(reg)
	add	a5,a5,1
	bge	a5,a3,.L282
	add	a4,a4,2
	add	a1,a1,a4
	add	a2,a2,a4
	lh	a5,0(a1)
	lh	a3,0(a2)
	bgt	a5,a3,.L293
	li	a5,0
	p.sh	a5,a4(a0)	# store reg(reg)
	ret
.L282:
	ret
.L303:
	sub	a6,a6,t1
	p.exths	a7,a6
	j	.L292
.L288:
	sub	a5,a5,a6
	p.exths	a5,a5
	j	.L289
.L293:
	sub	a5,a5,a3
	p.exths	a5,a5
	p.sh	a5,a4(a0)	# store reg(reg)
	ret
.L302:
	ret
.L295:
	li	a5,0
	j	.L284
.L301:
	li	a6,1
	j	.L305
	.size	sel16, .-sel16
	.align	1
	.globl	dot16
	.type	dot16, @function
dot16:
	blez	a2,.L309
	sll	a5,a2,1
	add	a5,a5,-2
	srl	a5,a5,1
	mv	a4,a0
	add	a5,a5,1
	li	a0,0
	lp.setup  	x1,a5,(.L311)	 # loop setup, lc+le set
.L308:
	p.lh	a2,2(a4!)	# load post inc, ext
	p.lh	a3,2(a1!)	# load post inc, ext
.L311:
	p.mac 	a0,a2,a3	# mac 32x32 in 32 instruction
	/* loop end a5 .L308 */
	ret
.L309:
	li	a0,0
	ret
	.size	dot16, .-dot16
	.align	1
	.globl	dot8
	.type	dot8, @function
dot8:
	blez	a2,.L315
	mv	a5,a0
	li	a0,0
	lp.setup  	x1,a2,(.L317)	 # loop setup, lc+le set
.L314:
	p.lb	a3,1(a5!)	# load post inc, ext
	p.lb	a4,1(a1!)	# load post inc, ext
.L317:
	p.mac 	a0,a3,a4	# mac 32x32 in 32 instruction
	/* loop end a2 .L314 */
	ret
.L315:
	li	a0,0
	ret
	.size	dot8, .-dot8
	.align	1
	.globl	dotu8
	.type	dotu8, @function
dotu8:
	blez	a2,.L321
	mv	a5,a0
	li	a0,0
	lp.setup  	x1,a2,(.L323)	 # loop setup, lc+le set
.L320:
	p.lbu	a3,1(a5!)	# load post inc, ext
	p.lbu	a4,1(a1!)	# load post inc, ext
.L323:
	p.mac 	a0,a3,a4	# mac 32x32 in 32 instruction
	/* loop end a2 .L320 */
	ret
.L321:
	li	a0,0
	ret
	.size	dotu8, .-dotu8
	.align	1
	.globl	sum16
	.type	sum16, @function
sum16:
	blez	a1,.L327
	sll	a5,a1,1
	add	a5,a5,-2
	srl	a5,a5,1
	mv	a4,a0
	add	a5,a5,1
	li	a0,0
	lp.setup  	x1,a5,(.L329)	 # loop setup, lc+le set
.L326:
	p.lh	a3,2(a4!)	# load post inc, ext
.L329:
	add	a0,a0,a3
	/* loop end a5 .L326 */
	ret
.L327:
	li	a0,0
	ret
	.size	sum16, .-sum16
	.align	1
	.globl	sum8
	.type	sum8, @function
sum8:
	blez	a1,.L333
	mv	a5,a0
	li	a0,0
	lp.setup  	x1,a1,(.L335)	 # loop setup, lc+le set
.L332:
	p.lb	a4,1(a5!)	# load post inc, ext
.L335:
	add	a0,a0,a4
	/* loop end a1 .L332 */
	ret
.L333:
	li	a0,0
	ret
	.size	sum8, .-sum8
	.align	1
	.globl	sum16n
	.type	sum16n, @function
sum16n:
	blez	a1,.L339
	sll	a5,a1,1
	add	a5,a5,-2
	srl	a5,a5,1
	mv	a4,a0
	add	a5,a5,1
	li	a0,0
	lp.setup  	x1,a5,(.L341)	 # loop setup, lc+le set
.L338:
	p.lh	a3,2(a4!)	# load post inc, ext
	add	a0,a3,a0
.L341:
	p.exths	a0,a0
	/* loop end a5 .L338 */
	ret
.L339:
	li	a0,0
	ret
	.size	sum16n, .-sum16n
	.align	1
	.globl	max16r
	.type	max16r, @function
max16r:
	blez	a1,.L345
	sll	a5,a1,1
	add	a5,a5,-2
	srl	a5,a5,1
	mv	a4,a0
	add	a5,a5,1
	li	a0,-32768
	lp.setup  	x1,a5,(.L347)	 # loop setup, lc+le set
.L344:
	p.lh	a3,2(a4!)	# load post inc, ext
.L347:
	p.max 	a0,a0,a3	# signed max
	/* loop end a5 .L344 */
	ret
.L345:
	li	a0,-32768
	ret
	.size	max16r, .-max16r
	.align	1
	.globl	max16rn
	.type	max16rn, @function
max16rn:
	blez	a1,.L354
	add	a5,a1,-1
	li	a4,3
	bleu	a5,a4,.L355
	lui	a5,%hi(.LC0)
	srl	a4,a1,1
	mv	a3,a0
	lw	a5,%lo(.LC0)(a5)
	beqz	a4,.L358
.L360:
	lp.setup  	x1,a4,(.L359)	 # loop setup, lc+le set
.L351:
	p.lw	a2,4(a3!)	# load post inc
.L359:
	pv.max.h 	a5,a5,a2	 # Vect Op Vect
	/* loop end a4 .L351 */
	lui	a2,%hi(.LC1)
	lw	a2,%lo(.LC1)(a2)
	mv	a6,a5
	pv.add.sci.h	a3,x0,0
	pv.shuffle2.h	a6,a3,a2 	# Shuffle2, word
	pv.max.h 	a5,a5,a6	 # Vect Op Vect
	p.bclr 	a4,a1,0,0 # Bit clear
	pv.extract.h	a5,a5,0	 # vect extract, with sign ext
	beq	a1,a4,.L349
.L350:
	sll	a3,a4,1
	add	a0,a0,a3
	lh	a2,0(a0)
	add	a3,a4,1
	p.max 	a5,a2,a5	# signed max
	bge	a3,a1,.L349
	lh	a2,2(a0)
	add	a3,a4,2
	p.max 	a5,a2,a5	# signed max
	p.exths	a5,a5
	ble	a1,a3,.L349
	lh	a3,4(a0)
	add	a4,a4,3
	p.max 	a5,a3,a5	# signed max
	ble	a1,a4,.L349
	lh	a4,6(a0)
	p.max 	a5,a4,a5	# signed max
.L349:
	mv	a0,a5
	ret
.L354:
	li	a5,-32768
	mv	a0,a5
	ret
.L355:
	li	a4,0
	li	a5,-32768
	j	.L350
.L358:
	li	a4,1
	j	.L360
	.size	max16rn, .-max16rn
	.align	1
	.globl	sad8
	.type	sad8, @function
sad8:
	blez	a2,.L364
	mv	a4,a0
	li	a0,0
	lp.setup  	x1,a2,(.L366)	 # loop setup, lc+le set
.L363:
	p.lbu	a5,1(a4!)	# load post inc, ext
	p.lbu	a3,1(a1!)	# load post inc, ext
	sub	a5,a5,a3
	p.abs	a5,a5
.L366:
	add	a0,a0,a5
	/* loop end a2 .L363 */
	ret
.L364:
	li	a0,0
	ret
	.size	sad8, .-sad8
	.align	1
	.globl	add16_k64
	.type	add16_k64, @function
add16_k64:
	srl	a4,a1,1
	p.bclr 	a4,a4,30,1 # Bit clear
	li	a5,0
	beqz	a4,.L368
	lhu	a3,0(a2)
	lhu	a6,0(a1)
	li	a5,1
	add	a3,a3,a6
	sh	a3,0(a0)
.L368:
	li	t4,64
	sub	t4,t4,a4
	srl	a3,t4,1
	sll	a4,a4,1
	add	t1,a0,a4
	add	a7,a1,a4
	add	a6,a2,a4
	beqz	a3,.L375
.L377:
	lp.setup  	x1,a3,(.L376)	 # loop setup, lc+le set
.L369:
	p.lw	a4,4(a7!)	# load post inc
	p.lw	t3,4(a6!)	# load post inc
	pv.add.h 	a4,a4,t3	 # Vect Op Vect
.L376:
	p.sw	a4,4(t1!)	# store post inc
	/* loop end a3 .L369 */
	p.bclr 	a4,t4,0,0 # Bit clear
	add	a5,a4,a5
	beq	t4,a4,.L367
	sll	a5,a5,1
	p.lhu	a4,a5(a1)
	p.lhu	a3,a5(a2)
	add	a4,a4,a3
	p.sh	a4,a5(a0)	# store reg(reg)
.L367:
	ret
.L375:
	li	a3,1
	j	.L377
	.size	add16_k64, .-add16_k64
	.align	1
	.globl	add16_k63
	.type	add16_k63, @function
add16_k63:
	srl	a5,a1,1
	p.bclr 	a5,a5,30,1 # Bit clear
	beqz	a5,.L379
	lhu	a4,0(a2)
	lhu	a3,0(a1)
	add	a4,a4,a3
	sh	a4,0(a0)
.L379:
	sll	a3,a5,1
	li	t3,63
	add	a7,a0,a3
	add	a6,a1,a3
	sub	t3,t3,a5
	add	a3,a2,a3
	lp.setupi  	x1,31,(.L386)	 # loop setup, lc+le set
.L380:
	p.lw	a5,4(a6!)	# load post inc
	p.lw	t1,4(a3!)	# load post inc
	pv.add.h 	a5,a5,t1	 # Vect Op Vect
.L386:
	p.sw	a5,4(a7!)	# store post inc
	/* loop end a4 .L380 */
	li	a5,62
	beq	t3,a5,.L378
	lhu	a5,124(a1)
	lhu	a4,124(a2)
	add	a5,a5,a4
	sh	a5,124(a0)
.L378:
	ret
	.size	add16_k63, .-add16_k63
	.align	1
	.globl	add8_k4
	.type	add8_k4, @function
add8_k4:
	lw	a5,0(a2)
	lw	a4,0(a1)
	pv.add.b 	a5,a5,a4	 # Vect Op Vect
	sw	a5,0(a0)
	ret
	.size	add8_k4, .-add8_k4
	.align	1
	.globl	add16_k2
	.type	add16_k2, @function
add16_k2:
	lw	a5,0(a2)
	lw	a4,0(a1)
	pv.add.h 	a5,a5,a4	 # Vect Op Vect
	sw	a5,0(a0)
	ret
	.size	add16_k2, .-add16_k2
	.align	1
	.globl	dot16_k64
	.type	dot16_k64, @function
dot16_k64:
	li	a4,0
	lp.setupi  	x1,64,(.L392)	 # loop setup, lc+le set
.L390:
	p.lh	a2,2(a0!)	# load post inc, ext
	p.lh	a3,2(a1!)	# load post inc, ext
.L392:
	p.mac 	a4,a2,a3	# mac 32x32 in 32 instruction
	/* loop end a5 .L390 */
	mv	a0,a4
	ret
	.size	dot16_k64, .-dot16_k64
	.align	1
	.globl	add16_glob
	.type	add16_glob, @function
add16_glob:
	lui	a5,%hi(GB)
	addi	t3,a5,%lo(GB)
	srl	a2,t3,1
	p.bclr 	a2,a2,30,1 # Bit clear
	beqz	a2,.L397
	lui	t1,%hi(GC)
	lhu	a3,%lo(GB)(a5)
	lhu	a4,%lo(GC)(t1)
	lui	a7,%hi(GA)
	li	a5,1
	add	a4,a4,a3
	sh	a4,%lo(GA)(a7)
.L394:
	li	t4,64
	sub	t4,t4,a2
	addi	a7,a7,%lo(GA)
	sll	a2,a2,1
	addi	t1,t1,%lo(GC)
	srl	a3,t4,1
	add	a0,a7,a2
	add	a1,t3,a2
	add	a2,t1,a2
	beqz	a3,.L400
.L402:
	lp.setup  	x1,a3,(.L401)	 # loop setup, lc+le set
.L395:
	p.lw	a4,4(a1!)	# load post inc
	p.lw	a6,4(a2!)	# load post inc
	pv.add.h 	a4,a4,a6	 # Vect Op Vect
.L401:
	p.sw	a4,4(a0!)	# store post inc
	/* loop end a3 .L395 */
	p.bclr 	a4,t4,0,0 # Bit clear
	add	a5,a4,a5
	beq	t4,a4,.L393
	sll	a5,a5,1
	p.lhu	a4,a5(t3)
	p.lhu	a3,a5(t1)
	add	a4,a4,a3
	p.sh	a4,a5(a7)	# store reg(reg)
.L393:
	ret
.L397:
	li	a5,0
	lui	a7,%hi(GA)
	lui	t1,%hi(GC)
	j	.L394
.L400:
	li	a3,1
	j	.L402
	.size	add16_glob, .-add16_glob
	.align	1
	.globl	add16_nr
	.type	add16_nr, @function
add16_nr:
	blez	a3,.L403
	add	a7,a0,4
	add	a4,a1,4
	p.sletu	a4,a4,a0
	p.sletu	t1,a7,a1
	mv	a6,a4
	sltu	a5,a3,4
	mv	a4,t1
	xor	a5,a5,1
	or	a4,a6,a4
	and	a5,a4,a5
	and	a5,a5,0xff
	beqz	a5,.L405
	add	a5,a2,4
	p.sletu	a5,a5,a0
	p.sletu	a7,a7,a2
	mv	a4,a5
	mv	a5,a7
	or	a5,a4,a5
	and	a5,a5,0xff
	beqz	a5,.L405
	srl	a4,a1,1
	p.bclr 	a4,a4,30,1 # Bit clear
	li	t4,0
	beqz	a4,.L406
	lhu	a5,0(a1)
	lhu	a6,0(a2)
	li	t4,1
	add	a5,a5,a6
	sh	a5,0(a0)
.L406:
	sub	t5,a3,a4
	srl	a6,t5,1
	sll	a4,a4,1
	add	a7,a0,a4
	add	t1,a1,a4
	add	a4,a2,a4
	beqz	a6,.L422
.L425:
	lp.setup  	x1,a6,(.L424)	 # loop setup, lc+le set
.L407:
	p.lw	a5,4(t1!)	# load post inc
	p.lw	t3,4(a4!)	# load post inc
	pv.add.h 	a5,a5,t3	 # Vect Op Vect
.L424:
	p.sw	a5,4(a7!)	# store post inc
	/* loop end a6 .L407 */
	p.bclr 	a5,t5,0,0 # Bit clear
	add	t4,a5,t4
	beq	t5,a5,.L403
	sll	a5,t4,1
	p.lhu	a4,a5(a1)
	p.lhu	a6,a5(a2)
	add	t4,t4,1
	add	a4,a4,a6
	p.sh	a4,a5(a0)	# store reg(reg)
	ble	a3,t4,.L403
	add	a5,a5,2
	p.lhu	a4,a5(a1)
	p.lhu	a3,a5(a2)
	add	a4,a4,a3
	p.sh	a4,a5(a0)	# store reg(reg)
	ret
.L405:
	sll	a5,a3,1
	add	a5,a5,-2
	srl	a5,a5,1
	add	a5,a5,1
	lp.setup  	x1,a5,(.L423)	 # loop setup, lc+le set
.L409:
	p.lh	a4,2(a1!)	# load post inc, ext
	p.lh	a3,2(a2!)	# load post inc, ext
	add	a4,a4,a3
.L423:
	p.sh	a4,2(a0!)	# store post inc
	/* loop end a5 .L409 */
.L403:
	ret
.L422:
	li	a6,1
	j	.L425
	.size	add16_nr, .-add16_nr
	.align	1
	.globl	add8_nr
	.type	add8_nr, @function
add8_nr:
	blez	a3,.L426
	add	a7,a0,4
	add	a4,a1,4
	p.sletu	a4,a4,a0
	p.sletu	t1,a7,a1
	mv	a6,a4
	sltu	a5,a3,6
	mv	a4,t1
	xor	a5,a5,1
	or	a4,a6,a4
	and	a5,a4,a5
	and	a5,a5,0xff
	beqz	a5,.L453
	add	a5,a2,4
	p.sletu	a5,a5,a0
	p.sletu	a7,a7,a2
	mv	a4,a5
	mv	a5,a7
	or	a5,a4,a5
	and	a5,a5,0xff
	beqz	a5,.L453
	sub	a4,zero,a1
	p.bclr 	a4,a4,29,2 # Bit clear
	add	a5,a3,-1
	add	a6,a4,3
	bltu	a5,a6,.L429
	li	t4,0
	beqz	a4,.L430
	lbu	a5,0(a1)
	lbu	a6,0(a2)
	li	t4,1
	add	a5,a5,a6
	sb	a5,0(a0)
	p.beqimm	a4,1,.L430
	lbu	a5,1(a1)
	lbu	a6,1(a2)
	li	t4,2
	add	a5,a5,a6
	sb	a5,1(a0)
	p.bneimm	a4,3,.L430
	lbu	a5,2(a1)
	lbu	a6,2(a2)
	li	t4,3
	add	a5,a5,a6
	sb	a5,2(a0)
.L430:
	sub	t5,a3,a4
	srl	a6,t5,2
	add	a7,a0,a4
	add	t1,a1,a4
	add	a4,a2,a4
	beqz	a6,.L451
.L455:
	lp.setup  	x1,a6,(.L454)	 # loop setup, lc+le set
.L432:
	p.lw	a5,4(t1!)	# load post inc
	p.lw	t3,4(a4!)	# load post inc
	pv.add.b 	a5,a5,t3	 # Vect Op Vect
.L454:
	p.sw	a5,4(a7!)	# store post inc
	/* loop end a6 .L432 */
	p.bclr 	a5,t5,1,0 # Bit clear
	add	a4,a5,t4
	beq	t5,a5,.L426
	p.lbu	a6,a4(a1)
	p.lbu	a7,a4(a2)
	add	a5,a4,1
	add	a6,a6,a7
	p.sb	a6,a4(a0)	# store reg(reg)
	ble	a3,a5,.L426
.L436:
	p.lbu	a6,a5(a1)
	p.lbu	a7,a5(a2)
	add	a4,a5,1
	add	a6,a6,a7
	p.sb	a6,a5(a0)	# store reg(reg)
	ble	a3,a4,.L426
	p.lbu	a7,a4(a1)
	p.lbu	t1,a4(a2)
	add	a6,a5,2
	add	a7,a7,t1
	p.sb	a7,a4(a0)	# store reg(reg)
	ble	a3,a6,.L426
	p.lbu	a7,a6(a1)
	p.lbu	t1,a6(a2)
	add	a4,a5,3
	add	a7,a7,t1
	p.sb	a7,a6(a0)	# store reg(reg)
	ble	a3,a4,.L426
	p.lbu	a6,a4(a1)
	p.lbu	a7,a4(a2)
	add	a5,a5,4
	add	a6,a6,a7
	p.sb	a6,a4(a0)	# store reg(reg)
	ble	a3,a5,.L426
	p.lbu	a4,a5(a1)
	p.lbu	a3,a5(a2)
	add	a4,a4,a3
	p.sb	a4,a5(a0)	# store reg(reg)
	ret
.L453:
	lp.setup  	x1,a3,(.L452)	 # loop setup, lc+le set
.L434:
	p.lb	a5,1(a1!)	# load post inc, ext
	p.lb	a4,1(a2!)	# load post inc, ext
	add	a5,a5,a4
.L452:
	p.sb	a5,1(a0!)	# store post inc
	/* loop end a3 .L434 */
	ret
.L426:
	ret
.L429:
	lbu	a4,0(a1)
	lbu	a6,0(a2)
	li	a5,1
	add	a4,a4,a6
	sb	a4,0(a0)
	j	.L436
.L451:
	li	a6,1
	j	.L455
	.size	add8_nr, .-add8_nr
	.align	1
	.globl	inplace16
	.type	inplace16, @function
inplace16:
	blez	a2,.L456
	add	a5,a1,4
	add	a3,a0,4
	p.sletu	a5,a5,a0
	p.sletu	a3,a3,a1
	mv	a4,a5
	mv	a5,a3
	or	a5,a4,a5
	and	a5,a5,0xff
	beqz	a5,.L458
	sltu	a5,a2,4
	xor	a5,a5,1
	and	a5,a5,0xff
	beqz	a5,.L458
	srl	a5,a0,1
	p.bclr 	a5,a5,30,1 # Bit clear
	li	t4,0
	beqz	a5,.L459
	lhu	a4,0(a0)
	lhu	a3,0(a1)
	li	t4,1
	add	a4,a4,a3
	sh	a4,0(a0)
.L459:
	sll	a3,a5,1
	sub	t3,a2,a5
	add	a6,a0,a3
	srl	a4,t3,1
	mv	a7,a6
	add	a3,a1,a3
	beqz	a4,.L475
.L478:
	lp.setup  	x1,a4,(.L477)	 # loop setup, lc+le set
.L460:
	p.lw	a5,4(a7!)	# load post inc
	p.lw	t1,4(a3!)	# load post inc
	pv.add.h 	a5,a5,t1	 # Vect Op Vect
.L477:
	p.sw	a5,4(a6!)	# store post inc
	/* loop end a4 .L460 */
	p.bclr 	a5,t3,0,0 # Bit clear
	add	t4,a5,t4
	beq	t3,a5,.L456
	sll	a5,t4,1
	add	a3,a0,a5
	p.lhu	a4,a5(a1)
	lhu	a6,0(a3)
	add	t4,t4,1
	add	a4,a4,a6
	sh	a4,0(a3)
	ble	a2,t4,.L456
	add	a5,a5,2
	add	a0,a0,a5
	lhu	a4,0(a0)
	p.lhu	a5,a5(a1)
	add	a5,a5,a4
	sh	a5,0(a0)
	ret
.L458:
	sll	a5,a2,1
	add	a5,a5,-2
	srl	a5,a5,1
	add	a5,a5,1
	lp.setup  	x1,a5,(.L476)	 # loop setup, lc+le set
.L462:
	lh	a4,0(a0)
	p.lh	a3,2(a1!)	# load post inc, ext
	add	a4,a4,a3
.L476:
	p.sh	a4,2(a0!)	# store post inc
	/* loop end a5 .L462 */
.L456:
	ret
.L475:
	li	a4,1
	j	.L478
	.size	inplace16, .-inplace16
	.align	1
	.globl	slp_add16
	.type	slp_add16, @function
slp_add16:
	lw	a5,0(a1)
	lw	a4,0(a2)
	pv.add.h 	a5,a5,a4	 # Vect Op Vect
	sw	a5,0(a0)
	ret
	.size	slp_add16, .-slp_add16
	.align	1
	.globl	slp_add8
	.type	slp_add8, @function
slp_add8:
	lw	a5,0(a1)
	lw	a4,0(a2)
	pv.add.b 	a5,a5,a4	 # Vect Op Vect
	sw	a5,0(a0)
	ret
	.size	slp_add8, .-slp_add8
	.align	1
	.globl	slp_px
	.type	slp_px, @function
slp_px:
	lw	a5,0(a1)
	lw	a4,0(a2)
	pv.add.b 	a5,a5,a4	 # Vect Op Vect
	sw	a5,0(a0)
	ret
	.size	slp_px, .-slp_px
	.align	1
	.globl	add32
	.type	add32, @function
add32:
	blez	a3,.L482
	sll	a5,a3,2
	add	a5,a5,-4
	srl	a5,a5,2
	add	a5,a5,1
	lp.setup  	x1,a5,(.L486)	 # loop setup, lc+le set
.L484:
	p.lw	a4,4(a1!)	# load post inc
	p.lw	a3,4(a2!)	# load post inc
	add	a4,a4,a3
.L486:
	p.sw	a4,4(a0!)	# store post inc
	/* loop end a5 .L484 */
.L482:
	ret
	.size	add32, .-add32
	.comm	GC,128,4
	.comm	GB,128,4
	.comm	GA,128,4
	.section	.srodata.cst4,"aM",@progbits,4
	.align	2
.LC0:
	.half	-32768
	.half	-32768
.LC1:
	.half	1
	.half	2
	.ident	"GCC: (GNU) 7.1.1 20170509"
