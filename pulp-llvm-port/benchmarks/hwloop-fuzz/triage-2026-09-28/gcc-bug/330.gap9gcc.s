	.file	"kern.c"
	.option nopic
	.text
	.align	1
	.globl	kern
	.type	kern, @function
kern:
	beqz	a3,.L2
	lw	a0,180(a0)
	li	a7,3
	mv	a5,a3
	p.bclr 	a0,a0,28,3 # Bit clear
.L4:
	beqz	a0,.L3
	sll	a7,a7,1
.L3:
	add	a5,a5,-1
	bnez	a5,.L4
	beqz	a4,.L24
.L10:
	li	a0,0
	li	a6,2
	beqz	a4,.L25
.L30:
	lp.setupi  	x1,1,(.L29)	 # loop setup, lc+le set
.L6:
	add	a5,a0,9
	p.bclr 	a5,a5,25,6 # Bit clear
	sll	a5,a5,2
	p.lw	a5,a5(a1)	# load reg(reg)
	add	a0,a0,1
.L29:
	add	a6,a6,a5
	/* loop end a4 .L6 */
	xor	t3,a7,a6
	xor	a0,t3,1
	beqz	a3,.L1
.L11:
	xor	t1,a7,29
	li	a0,1
	li	a7,0
	beqz	a3,.L26
.L28:
	lp.setupi  	x1,1,(.L27)	 # loop setup, lc+le set
.L8:
	add	a5,a0,63
	p.bclr 	a5,a5,25,6 # Bit clear
	sll	a5,a5,2
	p.lw	a5,a5(a1)	# load reg(reg)
	add	a4,a7,63
	p.bclr 	a4,a4,25,6 # Bit clear
	sll	a4,a4,2
	xor	a5,a5,a6
	p.sw	a5,a4(a2)	# store reg(reg)
	add	a0,a0,t1
.L27:
	add	a7,a7,1
	/* loop end a3 .L8 */
	xor	a0,a0,t3
	ret
.L2:
	bnez	a4,.L12
	li	a0,0
.L1:
	ret
.L12:
	li	a7,3
	j	.L10
.L26:
	j	.L28
.L25:
	j	.L30
.L24:
	xor	t3,a7,2
	li	a6,2
	j	.L11
	.size	kern, .-kern
	.ident	"GCC: (GNU) 7.1.1 20170509"
