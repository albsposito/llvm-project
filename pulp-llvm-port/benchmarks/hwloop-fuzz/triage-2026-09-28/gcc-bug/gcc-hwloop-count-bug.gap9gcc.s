	.file	"gcc-hwloop-count-bug.c"
	.option nopic
	.text
	.align	1
	.globl	kern
	.type	kern, @function
kern:
	beqz	a1,.L20
	li	a0,5
	beqz	a2,.L8
.L7:
	beqz	a2,.L21
.L27:
	lp.setup  	x1,a2,(.L26)	 # loop setup, lc+le set
.L4:
	xor	a0,a0,79
.L26:
	nop
	/* loop end a2 .L4 */
.L23:
	beqz	a1,.L1
.L8:
	li	a5,0
	li	a4,0
	beqz	a1,.L22
.L25:
	lp.setupi  	x1,1,(.L24)	 # loop setup, lc+le set
.L6:
	add	a4,a4,a5
.L24:
	add	a5,a5,1
	/* loop end a1 .L6 */
	xor	a0,a0,a4
	ret
.L20:
	li	a0,0
	bnez	a2,.L7
.L1:
	ret
.L21:
	li	a2,1
	xor	a0,a0,79
	add	a2,a2,-1
	bnez	a2,.L27
	j	.L23
.L22:
	j	.L25
	.size	kern, .-kern
	.ident	"GCC: (GNU) 7.1.1 20170509"
