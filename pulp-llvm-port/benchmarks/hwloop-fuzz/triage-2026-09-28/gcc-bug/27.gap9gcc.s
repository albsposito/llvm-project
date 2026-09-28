	.file	"kern.c"
	.option nopic
	.text
	.align	1
	.globl	kern
	.type	kern, @function
kern:
	beqz	a4,.L9
	li	t3,8
	li	t5,7
	mv	t1,a4
	lp.setup  	x1,t1,(.L24)	 # loop setup, lc+le set
.L3:
	lw	a6,212(a1)
	lw	t4,252(a1)
	p.bclr 	a7,t3,25,6 # Bit clear
	sll	a6,a6,1
	add	a6,a6,t4
	p.mul	a6,a6,t5
	sll	a7,a7,2
	add	t3,t3,1
.L24:
	p.sw	a6,a7(a2)	# store reg(reg)
	/* loop end t1 .L3 */
	li	a2,73
	p.mul	a4,a4,a2
	add	a7,a3,1
	add	a2,a4,3
	beqz	a7,.L10
.L21:
	li	t1,19
	p.mul	t1,a5,t1
	li	a6,2
.L6:
	add	a4,a2,32
	p.bclr 	a4,a4,25,6 # Bit clear
	sll	a4,a4,2
	p.lw	a4,a4(a0)	# load reg(reg)
	sll	a4,a4,1
	xor	a4,a4,a2
	add	a2,a2,a4
	beqz	a5,.L5
	add	a6,a6,t1
.L5:
	add	a7,a7,-1
	bnez	a7,.L6
	beqz	a3,.L7
.L23:
	lp.setup  	x1,a3,(.L22)	 # loop setup, lc+le set
.L8:
	add	a5,a6,53
	p.bclr 	a5,a5,25,6 # Bit clear
	sll	a5,a5,2
	p.lw	a5,a5(a1)	# load reg(reg)
.L22:
	add	a6,a6,a5
	/* loop end a3 .L8 */
.L7:
	xor	a2,a2,1
	xor	a0,a2,a6
	ret
.L9:
	add	a7,a3,1
	li	a2,3
	bnez	a7,.L21
.L10:
	li	a6,2
	j	.L23
	.size	kern, .-kern
	.ident	"GCC: (GNU) 7.1.1 20170509"
