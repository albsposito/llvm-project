	.file	"kern.c"
	.option nopic
	.text
	.align	1
	.globl	kern
	.type	kern, @function
kern:
	beqz	a3,.L18
	li	a4,52
	p.mul	a4,a3,a4
	add	a4,a4,3
	beqz	a5,.L9
	beqz	a5,.L19
.L25:
	lp.setup  	x1,a5,(.L24)	 # loop setup, lc+le set
.L4:
	add	a4,a4,79
.L24:
	nop
	/* loop end a5 .L4 */
.L21:
	xor	a0,a4,3
	beqz	a3,.L1
.L9:
	li	a2,0
	li	a0,2
	beqz	a3,.L20
.L23:
	lp.setupi  	x1,1,(.L22)	 # loop setup, lc+le set
.L6:
	add	a5,a2,12
	p.bclr 	a5,a5,25,6 # Bit clear
	sll	a5,a5,2
	p.lw	a5,a5(a1)	# load reg(reg)
	add	a4,a4,331
	add	a2,a2,1
.L22:
	add	a0,a0,a5
	/* loop end a3 .L6 */
	xor	a4,a4,a0
	xor	a0,a4,1
	ret
.L18:
	bnez	a5,.L10
	li	a0,0
.L1:
	ret
.L10:
	li	a4,3
	bnez	a5,.L25
	j	.L19
.L20:
	j	.L23
.L19:
	li	a5,1
	add	a4,a4,79
	add	a5,a5,-1
	bnez	a5,.L25
	j	.L21
	.size	kern, .-kern
	.ident	"GCC: (GNU) 7.1.1 20170509"
