	.file	"loops3.c"
	.option nopic
	.text
	.align	1
	.globl	deint16
	.type	deint16, @function
deint16:
	blez	a2,.L1
	sll	a5,a2,2
	add	a5,a5,-4
	srl	a5,a5,2
	add	a3,a1,2
	add	a5,a5,1
	lp.setup  	x1,a5,(.L6)	 # loop setup, lc+le set
.L3:
	p.lhu	a4,4(a1!)	# load post modify imm, ext
	p.lhu	a2,4(a3!)	# load post modify imm, ext
	add	a4,a4,a2
.L6:
	p.sh	a4,2(a0!)	# store post inc
	/* loop end a5 .L3 */
.L1:
	ret
	.size	deint16, .-deint16
	.align	1
	.globl	int16
	.type	int16, @function
int16:
	blez	a3,.L7
	sll	a5,a3,1
	add	a5,a5,-2
	srl	a5,a5,1
	add	a4,a0,2
	add	a5,a5,1
	lp.setup  	x1,a5,(.L11)	 # loop setup, lc+le set
.L9:
	p.lh	a6,2(a1!)	# load post inc, ext
	p.lh	a3,2(a2!)	# load post inc, ext
	p.sh	a6,4(a0!)	# store post modify imm
.L11:
	p.sh	a3,4(a4!)	# store post modify imm
	/* loop end a5 .L9 */
.L7:
	ret
	.size	int16, .-int16
	.align	1
	.globl	rev16
	.type	rev16, @function
rev16:
	blez	a3,.L12
	add	a3,a3,-1
	sll	a3,a3,1
	srl	a4,a3,1
	add	a1,a1,a3
	add	a4,a4,1
	lp.setup  	x1,a4,(.L16)	 # loop setup, lc+le set
.L14:
	p.lh	a5,-2(a1!)	# load post dec, ext
	p.lh	a3,2(a2!)	# load post inc, ext
	add	a5,a5,a3
.L16:
	p.sh	a5,2(a0!)	# store post inc
	/* loop end a4 .L14 */
.L12:
	ret
	.size	rev16, .-rev16
	.align	1
	.globl	rev8
	.type	rev8, @function
rev8:
	blez	a2,.L17
	add	a2,a2,-1
	add	a1,a1,a2
	add	a2,a2,1
	lp.setup  	x1,a2,(.L21)	 # loop setup, lc+le set
.L19:
	p.lb	a5,-1(a1!)	# load post dec, ext
.L21:
	p.sb	a5,1(a0!)	# store post inc
	/* loop end a2 .L19 */
.L17:
	ret
	.size	rev8, .-rev8
	.align	1
	.globl	cond16
	.type	cond16, @function
cond16:
	blez	a2,.L22
	sll	a5,a2,1
	add	a5,a5,-2
	srl	a5,a5,1
	add	a5,a5,1
	lp.setup  	x1,a5,(.L27)	 # loop setup, lc+le set
.L25:
	p.lh	a4,2(a1!)	# load post inc, ext
	blez	a4,.L24
	sh	a4,0(a0)
.L24:
	add	a0,a0,2
.L27:
	nop
	/* loop end a5 .L25 */
.L22:
	ret
	.size	cond16, .-cond16
	.align	1
	.globl	widen8to16
	.type	widen8to16, @function
widen8to16:
	blez	a2,.L28
	lp.setup  	x1,a2,(.L32)	 # loop setup, lc+le set
.L30:
	p.lb	a5,1(a1!)	# load post inc, ext
.L32:
	p.sh	a5,2(a0!)	# store post inc
	/* loop end a2 .L30 */
.L28:
	ret
	.size	widen8to16, .-widen8to16
	.align	1
	.globl	narrow16to8
	.type	narrow16to8, @function
narrow16to8:
	blez	a2,.L33
	sll	a5,a2,1
	add	a5,a5,-2
	srl	a5,a5,1
	add	a5,a5,1
	lp.setup  	x1,a5,(.L37)	 # loop setup, lc+le set
.L35:
	p.lh	a4,2(a1!)	# load post inc, ext
	sra	a4,a4,8
.L37:
	p.sb	a4,1(a0!)	# store post inc
	/* loop end a5 .L35 */
.L33:
	ret
	.size	narrow16to8, .-narrow16to8
	.align	1
	.globl	mulhi16
	.type	mulhi16, @function
mulhi16:
	blez	a3,.L38
	sll	a4,a3,1
	add	a4,a4,-2
	srl	a4,a4,1
	add	a4,a4,1
	lp.setup  	x1,a4,(.L42)	 # loop setup, lc+le set
.L40:
	p.lh	a5,2(a1!)	# load post inc, ext
	p.lh	a3,2(a2!)	# load post inc, ext
	p.mul	a5,a5,a3
	sra	a5,a5,15
.L42:
	p.sh	a5,2(a0!)	# store post inc
	/* loop end a4 .L40 */
.L38:
	ret
	.size	mulhi16, .-mulhi16
	.align	1
	.globl	stride2
	.type	stride2, @function
stride2:
	blez	a2,.L43
	sll	a5,a2,1
	add	a5,a5,-2
	srl	a5,a5,1
	add	a5,a5,1
	lp.setup  	x1,a5,(.L47)	 # loop setup, lc+le set
.L45:
	p.lhu	a4,4(a1!)	# load post modify imm, ext
.L47:
	p.sh	a4,2(a0!)	# store post inc
	/* loop end a5 .L45 */
.L43:
	ret
	.size	stride2, .-stride2
	.align	1
	.globl	idx16
	.type	idx16, @function
idx16:
	blez	a3,.L48
	lp.setup  	x1,a3,(.L52)	 # loop setup, lc+le set
.L50:
	p.lbu	a5,1(a2!)	# load post inc, ext
	sll	a5,a5,1
	p.lhu	a5,a5(a1)
.L52:
	p.sh	a5,2(a0!)	# store post inc
	/* loop end a3 .L50 */
.L48:
	ret
	.size	idx16, .-idx16
	.align	1
	.globl	find16
	.type	find16, @function
find16:
	blez	a2,.L57
	lh	a5,0(a0)
	beq	a5,a1,.L58
	add	a5,a0,2
	li	a0,0
	j	.L55
.L56:
	p.lh	a4,2(a5!)	# load post inc, ext
	beq	a4,a1,.L53
.L55:
	add	a0,a0,1
	bne	a2,a0,.L56
.L57:
	li	a0,-1
	ret
.L58:
	li	a0,0
.L53:
	ret
	.size	find16, .-find16
	.align	1
	.globl	iota8
	.type	iota8, @function
iota8:
	blez	a1,.L59
	li	a5,0
	lp.setup  	x1,a1,(.L63)	 # loop setup, lc+le set
.L61:
	mv	a4,a5
	p.sb	a4,1(a0!)	# store post inc
.L63:
	add	a5,a5,1
	/* loop end a1 .L61 */
.L59:
	ret
	.size	iota8, .-iota8
	.align	1
	.globl	cadd
	.type	cadd, @function
cadd:
	blez	a3,.L64
	sll	a5,a3,2
	add	a5,a5,-4
	srl	a5,a5,2
	add	t1,a1,2
	add	a7,a2,2
	add	a6,a0,2
	add	a5,a5,1
	lp.setup  	x1,a5,(.L68)	 # loop setup, lc+le set
.L66:
	p.lhu	a3,4(a1!)	# load post modify imm, ext
	p.lhu	t4,4(a2!)	# load post modify imm, ext
	p.lhu	a4,4(t1!)	# load post modify imm, ext
	p.lhu	t3,4(a7!)	# load post modify imm, ext
	add	a3,a3,t4
	p.sh	a3,4(a0!)	# store post modify imm
	add	a4,a4,t3
.L68:
	p.sh	a4,4(a6!)	# store post modify imm
	/* loop end a5 .L66 */
.L64:
	ret
	.size	cadd, .-cadd
	.ident	"GCC: (GNU) 7.1.1 20170509"
