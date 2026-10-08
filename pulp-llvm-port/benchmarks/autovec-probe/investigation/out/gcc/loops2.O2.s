	.file	"loops2.c"
	.option nopic
	.text
	.align	1
	.globl	add16
	.type	add16, @function
add16:
	blez	a3,.L1
	sll	a5,a3,1
	add	a5,a5,-2
	srl	a5,a5,1
	add	a5,a5,1
	lp.setup  	x1,a5,(.L6)	 # loop setup, lc+le set
.L3:
	p.lh	a4,2(a1!)	# load post inc, ext
	p.lh	a3,2(a2!)	# load post inc, ext
	add	a4,a4,a3
.L6:
	p.sh	a4,2(a0!)	# store post inc
	/* loop end a5 .L3 */
.L1:
	ret
	.size	add16, .-add16
	.align	1
	.globl	add8
	.type	add8, @function
add8:
	blez	a3,.L7
	lp.setup  	x1,a3,(.L11)	 # loop setup, lc+le set
.L9:
	p.lb	a5,1(a1!)	# load post inc, ext
	p.lb	a4,1(a2!)	# load post inc, ext
	add	a5,a5,a4
.L11:
	p.sb	a5,1(a0!)	# store post inc
	/* loop end a3 .L9 */
.L7:
	ret
	.size	add8, .-add8
	.align	1
	.globl	sub16
	.type	sub16, @function
sub16:
	blez	a3,.L12
	sll	a5,a3,1
	add	a5,a5,-2
	srl	a5,a5,1
	add	a5,a5,1
	lp.setup  	x1,a5,(.L16)	 # loop setup, lc+le set
.L14:
	p.lh	a4,2(a1!)	# load post inc, ext
	p.lh	a3,2(a2!)	# load post inc, ext
	sub	a4,a4,a3
.L16:
	p.sh	a4,2(a0!)	# store post inc
	/* loop end a5 .L14 */
.L12:
	ret
	.size	sub16, .-sub16
	.align	1
	.globl	and16
	.type	and16, @function
and16:
	blez	a3,.L17
	sll	a5,a3,1
	add	a5,a5,-2
	srl	a5,a5,1
	add	a5,a5,1
	lp.setup  	x1,a5,(.L21)	 # loop setup, lc+le set
.L19:
	p.lh	a4,2(a1!)	# load post inc, ext
	p.lh	a3,2(a2!)	# load post inc, ext
	and	a4,a4,a3
.L21:
	p.sh	a4,2(a0!)	# store post inc
	/* loop end a5 .L19 */
.L17:
	ret
	.size	and16, .-and16
	.align	1
	.globl	min16
	.type	min16, @function
min16:
	blez	a3,.L22
	sll	a5,a3,1
	add	a5,a5,-2
	srl	a5,a5,1
	add	a5,a5,1
	lp.setup  	x1,a5,(.L26)	 # loop setup, lc+le set
.L24:
	p.lh	a4,2(a2!)	# load post inc, ext
	p.lh	a3,2(a1!)	# load post inc, ext
	p.min 	a4,a4,a3	# signed min
.L26:
	p.sh	a4,2(a0!)	# store post inc
	/* loop end a5 .L24 */
.L22:
	ret
	.size	min16, .-min16
	.align	1
	.globl	max8
	.type	max8, @function
max8:
	blez	a3,.L27
	lp.setup  	x1,a3,(.L31)	 # loop setup, lc+le set
.L29:
	p.lb	a5,1(a2!)	# load post inc, ext
	p.lb	a4,1(a1!)	# load post inc, ext
	p.max 	a5,a5,a4	# signed max
.L31:
	p.sb	a5,1(a0!)	# store post inc
	/* loop end a3 .L29 */
.L27:
	ret
	.size	max8, .-max8
	.align	1
	.globl	maxu8
	.type	maxu8, @function
maxu8:
	blez	a3,.L32
	lp.setup  	x1,a3,(.L36)	 # loop setup, lc+le set
.L34:
	p.lbu	a5,1(a2!)	# load post inc, ext
	p.lbu	a4,1(a1!)	# load post inc, ext
	p.maxu 	a5,a5,a4	# signed max
.L36:
	p.sb	a5,1(a0!)	# store post inc
	/* loop end a3 .L34 */
.L32:
	ret
	.size	maxu8, .-maxu8
	.align	1
	.globl	abs16
	.type	abs16, @function
abs16:
	blez	a2,.L37
	sll	a4,a2,1
	add	a4,a4,-2
	srl	a4,a4,1
	add	a4,a4,1
	lp.setup  	x1,a4,(.L41)	 # loop setup, lc+le set
.L39:
	p.lh	a5,2(a1!)	# load post inc, ext
	p.abs	a5,a5
.L41:
	p.sh	a5,2(a0!)	# store post inc
	/* loop end a4 .L39 */
.L37:
	ret
	.size	abs16, .-abs16
	.align	1
	.globl	shr16
	.type	shr16, @function
shr16:
	blez	a2,.L42
	sll	a5,a2,1
	add	a5,a5,-2
	srl	a5,a5,1
	add	a5,a5,1
	lp.setup  	x1,a5,(.L46)	 # loop setup, lc+le set
.L44:
	p.lh	a4,2(a1!)	# load post inc, ext
	sra	a4,a4,3
.L46:
	p.sh	a4,2(a0!)	# store post inc
	/* loop end a5 .L44 */
.L42:
	ret
	.size	shr16, .-shr16
	.align	1
	.globl	shl8
	.type	shl8, @function
shl8:
	blez	a2,.L47
	lp.setup  	x1,a2,(.L51)	 # loop setup, lc+le set
.L49:
	p.lbu	a5,1(a1!)	# load post inc, ext
	sll	a5,a5,2
.L51:
	p.sb	a5,1(a0!)	# store post inc
	/* loop end a2 .L49 */
.L47:
	ret
	.size	shl8, .-shl8
	.align	1
	.globl	shrv16
	.type	shrv16, @function
shrv16:
	blez	a3,.L52
	sll	a4,a3,1
	add	a4,a4,-2
	srl	a4,a4,1
	add	a4,a4,1
	lp.setup  	x1,a4,(.L56)	 # loop setup, lc+le set
.L54:
	p.lh	a5,2(a1!)	# load post inc, ext
	sra	a5,a5,a2
.L56:
	p.sh	a5,2(a0!)	# store post inc
	/* loop end a4 .L54 */
.L52:
	ret
	.size	shrv16, .-shrv16
	.align	1
	.globl	addc16
	.type	addc16, @function
addc16:
	blez	a2,.L57
	sll	a5,a2,1
	add	a5,a5,-2
	srl	a5,a5,1
	add	a5,a5,1
	lp.setup  	x1,a5,(.L61)	 # loop setup, lc+le set
.L59:
	p.lh	a4,2(a1!)	# load post inc, ext
	add	a4,a4,5
.L61:
	p.sh	a4,2(a0!)	# store post inc
	/* loop end a5 .L59 */
.L57:
	ret
	.size	addc16, .-addc16
	.align	1
	.globl	adds16
	.type	adds16, @function
adds16:
	blez	a3,.L62
	sll	a5,a3,1
	add	a5,a5,-2
	srl	a5,a5,1
	p.exthz	a2,a2
	add	a5,a5,1
	lp.setup  	x1,a5,(.L66)	 # loop setup, lc+le set
.L64:
	p.lh	a4,2(a1!)	# load post inc, ext
	add	a4,a2,a4
.L66:
	p.sh	a4,2(a0!)	# store post inc
	/* loop end a5 .L64 */
.L62:
	ret
	.size	adds16, .-adds16
	.align	1
	.globl	scale16
	.type	scale16, @function
scale16:
	blez	a2,.L67
	sll	a5,a2,1
	add	a5,a5,-2
	srl	a5,a5,1
	li	a3,3
	add	a5,a5,1
	lp.setup  	x1,a5,(.L71)	 # loop setup, lc+le set
.L69:
	p.lh	a4,2(a1!)	# load post inc, ext
	p.mulu 	a4,a3,a4
.L71:
	p.sh	a4,2(a0!)	# store post inc
	/* loop end a5 .L69 */
.L67:
	ret
	.size	scale16, .-scale16
	.align	1
	.globl	scaleq15
	.type	scaleq15, @function
scaleq15:
	blez	a3,.L72
	sll	a4,a3,1
	add	a4,a4,-2
	srl	a4,a4,1
	add	a4,a4,1
	lp.setup  	x1,a4,(.L76)	 # loop setup, lc+le set
.L74:
	p.lh	a5,2(a1!)	# load post inc, ext
	p.mul	a5,a5,a2
	sra	a5,a5,15
.L76:
	p.sh	a5,2(a0!)	# store post inc
	/* loop end a4 .L74 */
.L72:
	ret
	.size	scaleq15, .-scaleq15
	.align	1
	.globl	mul16
	.type	mul16, @function
mul16:
	blez	a3,.L77
	sll	a5,a3,1
	add	a5,a5,-2
	srl	a5,a5,1
	add	a5,a5,1
	lp.setup  	x1,a5,(.L81)	 # loop setup, lc+le set
.L79:
	p.lh	a4,2(a1!)	# load post inc, ext
	p.lh	a3,2(a2!)	# load post inc, ext
	p.mulu 	a4,a4,a3
.L81:
	p.sh	a4,2(a0!)	# store post inc
	/* loop end a5 .L79 */
.L77:
	ret
	.size	mul16, .-mul16
	.align	1
	.globl	copy16
	.type	copy16, @function
copy16:
	blez	a2,.L82
	sll	a5,a2,1
	add	a5,a5,-2
	srl	a5,a5,1
	add	a5,a5,1
	lp.setup  	x1,a5,(.L86)	 # loop setup, lc+le set
.L84:
	p.lh	a4,2(a1!)	# load post inc, ext
.L86:
	p.sh	a4,2(a0!)	# store post inc
	/* loop end a5 .L84 */
.L82:
	ret
	.size	copy16, .-copy16
	.align	1
	.globl	set16
	.type	set16, @function
set16:
	blez	a2,.L87
	sll	a5,a2,1
	add	a5,a5,-2
	srl	a5,a5,1
	add	a5,a5,1
	lp.setup  	x1,a5,(.L91)	 # loop setup, lc+le set
.L89:
	p.sh	a1,2(a0!)	# store post inc
.L91:
	nop
	/* loop end a5 .L89 */
.L87:
	ret
	.size	set16, .-set16
	.align	1
	.globl	avg8
	.type	avg8, @function
avg8:
	blez	a3,.L92
	lp.setup  	x1,a3,(.L96)	 # loop setup, lc+le set
.L94:
	p.lbu	a5,1(a1!)	# load post inc, ext
	p.lbu	a4,1(a2!)	# load post inc, ext
	p.adduRN 	a5,a5,a4,1
.L96:
	p.sb	a5,1(a0!)	# store post inc
	/* loop end a3 .L94 */
.L92:
	ret
	.size	avg8, .-avg8
	.align	1
	.globl	sat16
	.type	sat16, @function
sat16:
	blez	a3,.L97
	sll	a4,a3,1
	add	a4,a4,-2
	srl	a4,a4,1
	li	a6,-32768
	add	a4,a4,1
	lp.setup  	x1,a4,(.L101)	 # loop setup, lc+le set
.L99:
	p.lh	a3,2(a2!)	# load post inc, ext
	p.lh	a5,2(a1!)	# load post inc, ext
	add	a5,a5,a3
	li	a3,32768
	p.max 	a5,a5,a6	# signed max
	add	a3,a3,-1
	p.min 	a5,a5,a3	# signed min
.L101:
	p.sh	a5,2(a0!)	# store post inc
	/* loop end a4 .L99 */
.L97:
	ret
	.size	sat16, .-sat16
	.align	1
	.globl	clip16
	.type	clip16, @function
clip16:
	blez	a2,.L102
	sll	a4,a2,1
	add	a4,a4,-2
	srl	a4,a4,1
	li	a2,-256
	li	a3,255
	add	a4,a4,1
	lp.setup  	x1,a4,(.L106)	 # loop setup, lc+le set
.L104:
	p.lh	a5,2(a1!)	# load post inc, ext
	p.max 	a5,a5,a2	# signed max
	p.min 	a5,a5,a3	# signed min
.L106:
	p.sh	a5,2(a0!)	# store post inc
	/* loop end a4 .L104 */
.L102:
	ret
	.size	clip16, .-clip16
	.align	1
	.globl	relu8
	.type	relu8, @function
relu8:
	blez	a2,.L107
	lp.setup  	x1,a2,(.L111)	 # loop setup, lc+le set
.L109:
	p.lb	a5,1(a1!)	# load post inc, ext
	p.max 	a5,a5,x0	# signed max 0
.L111:
	p.sb	a5,1(a0!)	# store post inc
	/* loop end a2 .L109 */
.L107:
	ret
	.size	relu8, .-relu8
	.align	1
	.globl	sel16
	.type	sel16, @function
sel16:
	blez	a3,.L112
	sll	a5,a3,1
	add	a5,a5,-2
	srl	a5,a5,1
	add	a5,a5,1
	lp.setup  	x1,a5,(.L118)	 # loop setup, lc+le set
.L115:
	p.lh	a3,2(a1!)	# load post inc, ext
	p.lh	a4,2(a2!)	# load post inc, ext
	li	a6,0
	sub	a7,a3,a4
	ble	a3,a4,.L114
	p.exths	a6,a7
.L114:
	p.sh	a6,2(a0!)	# store post inc
.L118:
	nop
	/* loop end a5 .L115 */
.L112:
	ret
	.size	sel16, .-sel16
	.align	1
	.globl	dot16
	.type	dot16, @function
dot16:
	blez	a2,.L122
	sll	a5,a2,1
	add	a5,a5,-2
	srl	a5,a5,1
	mv	a4,a0
	add	a5,a5,1
	li	a0,0
	lp.setup  	x1,a5,(.L124)	 # loop setup, lc+le set
.L121:
	p.lh	a2,2(a4!)	# load post inc, ext
	p.lh	a3,2(a1!)	# load post inc, ext
.L124:
	p.mac 	a0,a2,a3	# mac 32x32 in 32 instruction
	/* loop end a5 .L121 */
	ret
.L122:
	li	a0,0
	ret
	.size	dot16, .-dot16
	.align	1
	.globl	dot8
	.type	dot8, @function
dot8:
	blez	a2,.L128
	mv	a5,a0
	li	a0,0
	lp.setup  	x1,a2,(.L130)	 # loop setup, lc+le set
.L127:
	p.lb	a3,1(a5!)	# load post inc, ext
	p.lb	a4,1(a1!)	# load post inc, ext
.L130:
	p.mac 	a0,a3,a4	# mac 32x32 in 32 instruction
	/* loop end a2 .L127 */
	ret
.L128:
	li	a0,0
	ret
	.size	dot8, .-dot8
	.align	1
	.globl	dotu8
	.type	dotu8, @function
dotu8:
	blez	a2,.L134
	mv	a5,a0
	li	a0,0
	lp.setup  	x1,a2,(.L136)	 # loop setup, lc+le set
.L133:
	p.lbu	a3,1(a5!)	# load post inc, ext
	p.lbu	a4,1(a1!)	# load post inc, ext
.L136:
	p.mac 	a0,a3,a4	# mac 32x32 in 32 instruction
	/* loop end a2 .L133 */
	ret
.L134:
	li	a0,0
	ret
	.size	dotu8, .-dotu8
	.align	1
	.globl	sum16
	.type	sum16, @function
sum16:
	blez	a1,.L140
	sll	a5,a1,1
	add	a5,a5,-2
	srl	a5,a5,1
	mv	a4,a0
	add	a5,a5,1
	li	a0,0
	lp.setup  	x1,a5,(.L142)	 # loop setup, lc+le set
.L139:
	p.lh	a3,2(a4!)	# load post inc, ext
.L142:
	add	a0,a0,a3
	/* loop end a5 .L139 */
	ret
.L140:
	li	a0,0
	ret
	.size	sum16, .-sum16
	.align	1
	.globl	sum8
	.type	sum8, @function
sum8:
	blez	a1,.L146
	mv	a5,a0
	li	a0,0
	lp.setup  	x1,a1,(.L148)	 # loop setup, lc+le set
.L145:
	p.lb	a4,1(a5!)	# load post inc, ext
.L148:
	add	a0,a0,a4
	/* loop end a1 .L145 */
	ret
.L146:
	li	a0,0
	ret
	.size	sum8, .-sum8
	.align	1
	.globl	sum16n
	.type	sum16n, @function
sum16n:
	blez	a1,.L152
	sll	a5,a1,1
	add	a5,a5,-2
	srl	a5,a5,1
	mv	a4,a0
	add	a5,a5,1
	li	a0,0
	lp.setup  	x1,a5,(.L154)	 # loop setup, lc+le set
.L151:
	p.lh	a3,2(a4!)	# load post inc, ext
	add	a0,a3,a0
.L154:
	p.exths	a0,a0
	/* loop end a5 .L151 */
	ret
.L152:
	li	a0,0
	ret
	.size	sum16n, .-sum16n
	.align	1
	.globl	max16r
	.type	max16r, @function
max16r:
	blez	a1,.L158
	sll	a5,a1,1
	add	a5,a5,-2
	srl	a5,a5,1
	mv	a4,a0
	add	a5,a5,1
	li	a0,-32768
	lp.setup  	x1,a5,(.L160)	 # loop setup, lc+le set
.L157:
	p.lh	a3,2(a4!)	# load post inc, ext
.L160:
	p.max 	a0,a0,a3	# signed max
	/* loop end a5 .L157 */
	ret
.L158:
	li	a0,-32768
	ret
	.size	max16r, .-max16r
	.align	1
	.globl	max16rn
	.type	max16rn, @function
max16rn:
	blez	a1,.L164
	sll	a5,a1,1
	add	a5,a5,-2
	srl	a5,a5,1
	mv	a4,a0
	add	a5,a5,1
	li	a0,-32768
	lp.setup  	x1,a5,(.L166)	 # loop setup, lc+le set
.L163:
	p.lh	a3,2(a4!)	# load post inc, ext
.L166:
	p.max 	a0,a3,a0	# signed max
	/* loop end a5 .L163 */
	ret
.L164:
	li	a0,-32768
	ret
	.size	max16rn, .-max16rn
	.align	1
	.globl	sad8
	.type	sad8, @function
sad8:
	blez	a2,.L170
	mv	a4,a0
	li	a0,0
	lp.setup  	x1,a2,(.L172)	 # loop setup, lc+le set
.L169:
	p.lbu	a5,1(a4!)	# load post inc, ext
	p.lbu	a3,1(a1!)	# load post inc, ext
	sub	a5,a5,a3
	p.abs	a5,a5
.L172:
	add	a0,a0,a5
	/* loop end a2 .L169 */
	ret
.L170:
	li	a0,0
	ret
	.size	sad8, .-sad8
	.align	1
	.globl	add16_k64
	.type	add16_k64, @function
add16_k64:
	lp.setupi  	x1,64,(.L176)	 # loop setup, lc+le set
.L174:
	p.lh	a5,2(a1!)	# load post inc, ext
	p.lh	a3,2(a2!)	# load post inc, ext
	add	a5,a5,a3
.L176:
	p.sh	a5,2(a0!)	# store post inc
	/* loop end a4 .L174 */
	ret
	.size	add16_k64, .-add16_k64
	.align	1
	.globl	add16_k63
	.type	add16_k63, @function
add16_k63:
	lp.setupi  	x1,63,(.L180)	 # loop setup, lc+le set
.L178:
	p.lh	a5,2(a1!)	# load post inc, ext
	p.lh	a3,2(a2!)	# load post inc, ext
	add	a5,a5,a3
.L180:
	p.sh	a5,2(a0!)	# store post inc
	/* loop end a4 .L178 */
	ret
	.size	add16_k63, .-add16_k63
	.align	1
	.globl	add8_k4
	.type	add8_k4, @function
add8_k4:
	lp.setupi  	x1,4,(.L184)	 # loop setup, lc+le set
.L182:
	p.lb	a5,1(a1!)	# load post inc, ext
	p.lb	a3,1(a2!)	# load post inc, ext
	add	a5,a5,a3
.L184:
	p.sb	a5,1(a0!)	# store post inc
	/* loop end a4 .L182 */
	ret
	.size	add8_k4, .-add8_k4
	.align	1
	.globl	add16_k2
	.type	add16_k2, @function
add16_k2:
	lhu	a4,0(a1)
	lhu	a6,0(a2)
	lhu	a5,2(a1)
	lhu	a3,2(a2)
	add	a4,a4,a6
	sh	a4,0(a0)
	add	a5,a5,a3
	sh	a5,2(a0)
	ret
	.size	add16_k2, .-add16_k2
	.align	1
	.globl	dot16_k64
	.type	dot16_k64, @function
dot16_k64:
	li	a4,0
	lp.setupi  	x1,64,(.L189)	 # loop setup, lc+le set
.L187:
	p.lh	a2,2(a0!)	# load post inc, ext
	p.lh	a3,2(a1!)	# load post inc, ext
.L189:
	p.mac 	a4,a2,a3	# mac 32x32 in 32 instruction
	/* loop end a5 .L187 */
	mv	a0,a4
	ret
	.size	dot16_k64, .-dot16_k64
	.align	1
	.globl	add16_glob
	.type	add16_glob, @function
add16_glob:
	lui	a1,%hi(GB)
	lui	a2,%hi(GC)
	lui	a3,%hi(GA)
	addi	a1,a1,%lo(GB)
	addi	a2,a2,%lo(GC)
	addi	a3,a3,%lo(GA)
	lp.setupi  	x1,64,(.L193)	 # loop setup, lc+le set
.L191:
	p.lh	a5,2(a1!)	# load post inc, ext
	p.lh	a0,2(a2!)	# load post inc, ext
	add	a5,a5,a0
.L193:
	p.sh	a5,2(a3!)	# store post inc
	/* loop end a4 .L191 */
	ret
	.size	add16_glob, .-add16_glob
	.align	1
	.globl	add16_nr
	.type	add16_nr, @function
add16_nr:
	blez	a3,.L194
	sll	a5,a3,1
	add	a5,a5,-2
	srl	a5,a5,1
	add	a5,a5,1
	lp.setup  	x1,a5,(.L198)	 # loop setup, lc+le set
.L196:
	p.lh	a4,2(a1!)	# load post inc, ext
	p.lh	a3,2(a2!)	# load post inc, ext
	add	a4,a4,a3
.L198:
	p.sh	a4,2(a0!)	# store post inc
	/* loop end a5 .L196 */
.L194:
	ret
	.size	add16_nr, .-add16_nr
	.align	1
	.globl	add8_nr
	.type	add8_nr, @function
add8_nr:
	blez	a3,.L199
	lp.setup  	x1,a3,(.L203)	 # loop setup, lc+le set
.L201:
	p.lb	a5,1(a1!)	# load post inc, ext
	p.lb	a4,1(a2!)	# load post inc, ext
	add	a5,a5,a4
.L203:
	p.sb	a5,1(a0!)	# store post inc
	/* loop end a3 .L201 */
.L199:
	ret
	.size	add8_nr, .-add8_nr
	.align	1
	.globl	inplace16
	.type	inplace16, @function
inplace16:
	blez	a2,.L204
	sll	a5,a2,1
	add	a5,a5,-2
	srl	a5,a5,1
	add	a5,a5,1
	lp.setup  	x1,a5,(.L208)	 # loop setup, lc+le set
.L206:
	lh	a4,0(a0)
	p.lh	a3,2(a1!)	# load post inc, ext
	add	a4,a4,a3
.L208:
	p.sh	a4,2(a0!)	# store post inc
	/* loop end a5 .L206 */
.L204:
	ret
	.size	inplace16, .-inplace16
	.align	1
	.globl	slp_add16
	.type	slp_add16, @function
slp_add16:
	lhu	a4,0(a1)
	lhu	a6,0(a2)
	lhu	a5,2(a1)
	lhu	a3,2(a2)
	add	a4,a4,a6
	sh	a4,0(a0)
	add	a5,a5,a3
	sh	a5,2(a0)
	ret
	.size	slp_add16, .-slp_add16
	.align	1
	.globl	slp_add8
	.type	slp_add8, @function
slp_add8:
	lbu	t3,0(a2)
	lbu	t1,1(a2)
	lbu	a7,2(a2)
	lbu	a6,0(a1)
	lbu	a3,1(a1)
	lbu	a4,2(a1)
	lbu	a5,3(a1)
	lbu	a2,3(a2)
	add	a6,a6,t3
	add	a3,a3,t1
	add	a4,a4,a7
	add	a5,a5,a2
	sb	a6,0(a0)
	sb	a3,1(a0)
	sb	a4,2(a0)
	sb	a5,3(a0)
	ret
	.size	slp_add8, .-slp_add8
	.align	1
	.globl	slp_px
	.type	slp_px, @function
slp_px:
	lbu	t3,0(a2)
	lbu	t1,1(a2)
	lbu	a7,2(a2)
	lbu	a6,0(a1)
	lbu	a3,1(a1)
	lbu	a4,2(a1)
	lbu	a5,3(a1)
	lbu	a2,3(a2)
	add	a6,a6,t3
	add	a3,a3,t1
	add	a4,a4,a7
	add	a5,a5,a2
	sb	a6,0(a0)
	sb	a3,1(a0)
	sb	a4,2(a0)
	sb	a5,3(a0)
	ret
	.size	slp_px, .-slp_px
	.align	1
	.globl	add32
	.type	add32, @function
add32:
	blez	a3,.L212
	sll	a5,a3,2
	add	a5,a5,-4
	srl	a5,a5,2
	add	a5,a5,1
	lp.setup  	x1,a5,(.L216)	 # loop setup, lc+le set
.L214:
	p.lw	a4,4(a1!)	# load post inc
	p.lw	a3,4(a2!)	# load post inc
	add	a4,a4,a3
.L216:
	p.sw	a4,4(a0!)	# store post inc
	/* loop end a5 .L214 */
.L212:
	ret
	.size	add32, .-add32
	.comm	GC,128,4
	.comm	GB,128,4
	.comm	GA,128,4
	.ident	"GCC: (GNU) 7.1.1 20170509"
