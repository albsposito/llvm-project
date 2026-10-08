	.file	"loops_f16.c"
	.option nopic
	.text
	.align	1
	.globl	win_f16
	.type	win_f16, @function
win_f16:
	blez	a2,.L1
	sll	a5,a2,1
	add	a5,a5,-2
	srl	a5,a5,1
	add	a5,a5,1
	lp.setup  	x1,a5,(.L6)	 # loop setup, lc+le set
.L3:
	lhu	a4,0(a0)
	p.lhu	a3,2(a1!)	# load post inc
	fmul.h	a4,a4,a3
.L6:
	p.sh	a4,2(a0!)	# store post inc
	/* loop end a5 .L3 */
.L1:
	ret
	.size	win_f16, .-win_f16
	.align	1
	.globl	win_f16_o
	.type	win_f16_o, @function
win_f16_o:
	blez	a3,.L7
	sll	a5,a3,1
	add	a5,a5,-2
	srl	a5,a5,1
	add	a5,a5,1
	lp.setup  	x1,a5,(.L11)	 # loop setup, lc+le set
.L9:
	p.lhu	a4,2(a1!)	# load post inc
	p.lhu	a3,2(a2!)	# load post inc
	fmul.h	a4,a4,a3
.L11:
	p.sh	a4,2(a0!)	# store post inc
	/* loop end a5 .L9 */
.L7:
	ret
	.size	win_f16_o, .-win_f16_o
	.align	1
	.globl	add_f16
	.type	add_f16, @function
add_f16:
	blez	a3,.L12
	sll	a5,a3,1
	add	a5,a5,-2
	srl	a5,a5,1
	add	a5,a5,1
	lp.setup  	x1,a5,(.L16)	 # loop setup, lc+le set
.L14:
	p.lhu	a4,2(a1!)	# load post inc
	p.lhu	a3,2(a2!)	# load post inc
	fadd.h	a4,a4,a3
.L16:
	p.sh	a4,2(a0!)	# store post inc
	/* loop end a5 .L14 */
.L12:
	ret
	.size	add_f16, .-add_f16
	.align	1
	.globl	axpy_f16
	.type	axpy_f16, @function
axpy_f16:
	blez	a3,.L17
	sll	a5,a3,1
	add	a5,a5,-2
	srl	a5,a5,1
	add	a5,a5,1
	lp.setup  	x1,a5,(.L21)	 # loop setup, lc+le set
.L19:
	lhu	a3,0(a0)
	p.lhu	a4,2(a1!)	# load post inc
	fmadd.h	a4,a4,a2,a3
.L21:
	p.sh	a4,2(a0!)	# store post inc
	/* loop end a5 .L19 */
.L17:
	ret
	.size	axpy_f16, .-axpy_f16
	.align	1
	.globl	scale_f16
	.type	scale_f16, @function
scale_f16:
	blez	a3,.L22
	sll	a5,a3,1
	add	a5,a5,-2
	srl	a5,a5,1
	add	a5,a5,1
	lp.setup  	x1,a5,(.L26)	 # loop setup, lc+le set
.L24:
	p.lhu	a4,2(a1!)	# load post inc
	fmul.h	a4,a4,a2
.L26:
	p.sh	a4,2(a0!)	# store post inc
	/* loop end a5 .L24 */
.L22:
	ret
	.size	scale_f16, .-scale_f16
	.align	1
	.globl	max_f16
	.type	max_f16, @function
max_f16:
	blez	a3,.L27
	sll	a5,a3,1
	add	a5,a5,-2
	srl	a5,a5,1
	add	a5,a5,1
	lp.setup  	x1,a5,(.L32)	 # loop setup, lc+le set
.L30:
	p.lhu	a4,2(a1!)	# load post inc
	p.lhu	a3,2(a2!)	# load post inc
	fgt.h	a6,a4,a3
	bnez	a6,.L29
	mv	a4,a3
.L29:
	p.sh	a4,2(a0!)	# store post inc
.L32:
	nop
	/* loop end a5 .L30 */
.L27:
	ret
	.size	max_f16, .-max_f16
	.align	1
	.globl	magsq_f16
	.type	magsq_f16, @function
magsq_f16:
	blez	a2,.L33
	sll	a3,a2,2
	add	a3,a3,-4
	srl	a3,a3,2
	add	a2,a1,2
	add	a3,a3,1
	lp.setup  	x1,a3,(.L37)	 # loop setup, lc+le set
.L35:
	p.lhu	a5,4(a1!)	# load post modify imm
	p.lhu	a4,4(a2!)	# load post modify imm
	fmul.h	a4,a4,a4
	fmadd.h	a5,a5,a5,a4
.L37:
	p.sh	a5,2(a0!)	# store post inc
	/* loop end a3 .L35 */
.L33:
	ret
	.size	magsq_f16, .-magsq_f16
	.align	1
	.globl	dot_f16
	.type	dot_f16, @function
dot_f16:
	mv	a4,a0
	blez	a2,.L41
	sll	a5,a2,1
	add	a5,a5,-2
	mv	a0,zero
	srl	a5,a5,1
	add	a5,a5,1
	lp.setup  	x1,a5,(.L43)	 # loop setup, lc+le set
.L40:
	p.lhu	a2,2(a4!)	# load post inc
	p.lhu	a3,2(a1!)	# load post inc
.L43:
	fmadd.h	a0,a2,a3,a0
	/* loop end a5 .L40 */
	ret
.L41:
	mv	a0,zero
	ret
	.size	dot_f16, .-dot_f16
	.align	1
	.globl	win_f16_nr
	.type	win_f16_nr, @function
win_f16_nr:
	blez	a2,.L44
	sll	a5,a2,1
	add	a5,a5,-2
	srl	a5,a5,1
	add	a5,a5,1
	lp.setup  	x1,a5,(.L48)	 # loop setup, lc+le set
.L46:
	lhu	a4,0(a0)
	p.lhu	a3,2(a1!)	# load post inc
	fmul.h	a4,a4,a3
.L48:
	p.sh	a4,2(a0!)	# store post inc
	/* loop end a5 .L46 */
.L44:
	ret
	.size	win_f16_nr, .-win_f16_nr
	.align	1
	.globl	win_f16_k256
	.type	win_f16_k256, @function
win_f16_k256:
	lp.setupi  	x1,256,(.L52)	 # loop setup, lc+le set
.L50:
	lhu	a5,0(a0)
	p.lhu	a3,2(a1!)	# load post inc
	fmul.h	a5,a5,a3
.L52:
	p.sh	a5,2(a0!)	# store post inc
	/* loop end a4 .L50 */
	ret
	.size	win_f16_k256, .-win_f16_k256
	.ident	"GCC: (GNU) 7.1.1 20170509"
