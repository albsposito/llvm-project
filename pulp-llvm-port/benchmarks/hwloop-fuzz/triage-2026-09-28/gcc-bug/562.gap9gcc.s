	.file	"kern.c"
	.option nopic
	.text
	.align	1
	.globl	kern
	.type	kern, @function
kern:
	add	a3,a3,1
	beqz	a4,.L2
	li	a6,48
	li	a7,23
	mv	a1,a4
	lp.setup  	x1,a1,(.L30)	 # loop setup, lc+le set
.L3:
	p.bclr 	a5,a6,25,6 # Bit clear
	sll	a5,a5,2
	p.sw	a7,a5(a2)	# store reg(reg)
.L30:
	add	a6,a6,1
	/* loop end a1 .L3 */
	beqz	a3,.L23
.L10:
	lw	a7,164(a0)
	lw	a5,56(a0)
	li	a1,0
	li	a2,2
	add	a7,a7,a5
	and	a7,a7,8
	li	a6,1
	beqz	a3,.L24
.L29:
	lp.setup  	x1,a3,(.L28)	 # loop setup, lc+le set
.L6:
	add	a5,a1,55
	p.bclr 	a5,a5,25,6 # Bit clear
	sll	a5,a5,2
	add	a2,a2,63
	beqz	a7,.L5
	p.lw	a5,a5(a0)	# load reg(reg)
	add	a6,a6,a5
.L5:
	add	a1,a1,1
.L28:
	nop
	/* loop end a3 .L6 */
	xor	a6,a6,a2
	xor	a3,a6,3
	beqz	a4,.L1
.L11:
	srl	a2,a2,31
	li	a3,3
	beqz	a4,.L25
.L27:
	lp.setupi  	x1,1,(.L26)	 # loop setup, lc+le set
.L8:
	sll	a3,a3,1
.L26:
	or	a3,a3,a2
	/* loop end a4 .L8 */
	xor	a3,a3,a6
.L1:
	mv	a0,a3
	ret
.L2:
	bnez	a3,.L10
	mv	a0,a3
	ret
.L23:
	li	a6,3
	li	a2,2
	j	.L11
.L25:
	j	.L27
.L24:
	li	a3,1
	j	.L29
	.size	kern, .-kern
	.ident	"GCC: (GNU) 7.1.1 20170509"
