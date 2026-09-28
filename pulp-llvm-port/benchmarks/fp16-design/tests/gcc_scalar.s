	.file	"gcc_scalar.c"
	.option nopic
	.text
	.align	1
	.globl	h_add
	.type	h_add, @function
h_add:
	fadd.h	a0,a0,a1
	ret
	.size	h_add, .-h_add
	.align	1
	.globl	h_mul
	.type	h_mul, @function
h_mul:
	fmul.h	a0,a0,a1
	ret
	.size	h_mul, .-h_mul
	.align	1
	.globl	h_fma
	.type	h_fma, @function
h_fma:
	fmadd.h	a0,a0,a1,a2
	ret
	.size	h_fma, .-h_fma
	.align	1
	.globl	h_div
	.type	h_div, @function
h_div:
	fdiv.h	a0,a0,a1
	ret
	.size	h_div, .-h_div
	.align	1
	.globl	h_expr
	.type	h_expr, @function
h_expr:
	fadd.h	a1,a0,a1
	fmsub.h	a0,a1,a2,a0
	ret
	.size	h_expr, .-h_expr
	.align	1
	.globl	h_lt
	.type	h_lt, @function
h_lt:
	flt.h	a0,a0,a1
	ret
	.size	h_lt, .-h_lt
	.align	1
	.globl	a_add
	.type	a_add, @function
a_add:
	fadd.ah	a0,a0,a1
	ret
	.size	a_add, .-a_add
	.align	1
	.globl	a_mul
	.type	a_mul, @function
a_mul:
	fmul.ah	a0,a0,a1
	ret
	.size	a_mul, .-a_mul
	.align	1
	.globl	a_fma
	.type	a_fma, @function
a_fma:
	fmadd.ah	a0,a0,a1,a2
	ret
	.size	a_fma, .-a_fma
	.align	1
	.globl	a_expr
	.type	a_expr, @function
a_expr:
	fadd.ah	a1,a0,a1
	fmsub.ah	a0,a1,a2,a0
	ret
	.size	a_expr, .-a_expr
	.align	1
	.globl	a_lt
	.type	a_lt, @function
a_lt:
	flt.ah	a0,a0,a1
	ret
	.size	a_lt, .-a_lt
	.align	1
	.globl	h2f
	.type	h2f, @function
h2f:
	fcvt.s.h	a0,a0
	ret
	.size	h2f, .-h2f
	.align	1
	.globl	f2h
	.type	f2h, @function
f2h:
	fcvt.h.s	a0,a0
	ret
	.size	f2h, .-f2h
	.align	1
	.globl	a2f
	.type	a2f, @function
a2f:
	fcvt.s.ah	a0,a0
	ret
	.size	a2f, .-a2f
	.align	1
	.globl	f2a
	.type	f2a, @function
f2a:
	fcvt.ah.s	a0,a0
	ret
	.size	f2a, .-f2a
	.align	1
	.globl	h2a
	.type	h2a, @function
h2a:
	fcvt.ah.h	a0,a0
	ret
	.size	h2a, .-h2a
	.align	1
	.globl	a2h
	.type	a2h, @function
a2h:
	fcvt.h.ah	a0,a0
	ret
	.size	a2h, .-a2h
	.align	1
	.globl	h2i
	.type	h2i, @function
h2i:
	fcvt.w.h	a0,a0,rtz
	ret
	.size	h2i, .-h2i
	.align	1
	.globl	i2h
	.type	i2h, @function
i2h:
	fcvt.h.w	a0,a0
	ret
	.size	i2h, .-i2h
	.align	1
	.globl	h2u
	.type	h2u, @function
h2u:
	fcvt.wu.h	a0,a0,rtz
	ret
	.size	h2u, .-h2u
	.align	1
	.globl	a2i
	.type	a2i, @function
a2i:
	fcvt.w.ah	a0,a0
	ret
	.size	a2i, .-a2i
	.align	1
	.globl	i2a
	.type	i2a, @function
i2a:
	fcvt.ah.w	a0,a0
	ret
	.size	i2a, .-i2a
	.globl	__extendhfdf2
	.align	1
	.globl	h2d
	.type	h2d, @function
h2d:
	add	sp,sp,-16
	sw	ra,12(sp)
	call	__extendhfdf2
	lw	ra,12(sp)
	add	sp,sp,16
	jr	ra
	.size	h2d, .-h2d
	.globl	__truncdfhf2
	.align	1
	.globl	d2h
	.type	d2h, @function
d2h:
	add	sp,sp,-16
	sw	ra,12(sp)
	call	__truncdfhf2
	lw	ra,12(sp)
	add	sp,sp,16
	jr	ra
	.size	d2h, .-d2h
	.align	1
	.globl	mix_hf
	.type	mix_hf, @function
mix_hf:
	fcvt.s.h	a0,a0
	fmul.s	a0,a0,a1
	ret
	.size	mix_hf, .-mix_hf
	.align	1
	.globl	mix_ha
	.type	mix_ha, @function
mix_ha:
	fcvt.ah.h	a0,a0
	fadd.ah	a0,a0,a1
	fcvt.h.ah	a0,a0
	ret
	.size	mix_ha, .-mix_ha
	.align	1
	.globl	h_copy
	.type	h_copy, @function
h_copy:
	lhu	a5,0(a1)
	sh	a5,0(a0)
	lhu	a5,2(a1)
	sh	a5,2(a0)
	ret
	.size	h_copy, .-h_copy
	.align	1
	.globl	h_axpy
	.type	h_axpy, @function
h_axpy:
	blez	a3,.L31
	sll	a5,a3,1
	add	a5,a5,-2
	srl	a5,a5,1
	add	a5,a5,1
	lp.setup  	x1,a5,(.L35)	 # loop setup, lc+le set
.L33:
	lhu	a3,0(a0)
	p.lhu	a4,2(a1!)	# load post inc
	fmadd.h	a4,a4,a2,a3
.L35:
	p.sh	a4,2(a0!)	# store post inc
	/* loop end a5 .L33 */
.L31:
	ret
	.size	h_axpy, .-h_axpy
	.align	1
	.globl	a_axpy
	.type	a_axpy, @function
a_axpy:
	blez	a3,.L36
	sll	a5,a3,1
	add	a5,a5,-2
	srl	a5,a5,1
	add	a5,a5,1
	lp.setup  	x1,a5,(.L40)	 # loop setup, lc+le set
.L38:
	lhu	a3,0(a0)
	p.lhu	a4,2(a1!)	# load post inc
	fmadd.ah	a4,a4,a2,a3
.L40:
	p.sh	a4,2(a0!)	# store post inc
	/* loop end a5 .L38 */
.L36:
	ret
	.size	a_axpy, .-a_axpy
	.align	1
	.globl	h_const
	.type	h_const, @function
h_const:
	lui	a5,%hi(.LC0)
	lhu	a0,%lo(.LC0)(a5)
	ret
	.size	h_const, .-h_const
	.align	1
	.globl	a_const
	.type	a_const, @function
a_const:
	lui	a5,%hi(.LC1)
	lhu	a0,%lo(.LC1)(a5)
	ret
	.size	a_const, .-a_const
	.align	1
	.globl	call_h
	.type	call_h, @function
call_h:
	mv	a3,a0
	add	sp,sp,-16
	li	a2,3
	sw	ra,12(sp)
	call	ext_h
	lui	a5,%hi(.LC2)
	lhu	a5,%lo(.LC2)(a5)
	lw	ra,12(sp)
	fadd.h	a0,a0,a5
	add	sp,sp,16
	jr	ra
	.size	call_h, .-call_h
	.align	1
	.globl	many
	.type	many, @function
many:
	lhu	a5,4(sp)
	fadd.h	a0,a0,a5
	lhu	a5,0(sp)
	fadd.h	a0,a0,a5
	ret
	.size	many, .-many
	.align	1
	.globl	call_var
	.type	call_var, @function
call_var:
	add	sp,sp,-16
	sw	ra,12(sp)
	call	__extendhfdf2
	lw	ra,12(sp)
	mv	a2,a0
	mv	a3,a1
	li	a0,1
	add	sp,sp,16
	tail	vf
	.size	call_var, .-call_var
	.align	1
	.globl	h_abs
	.type	h_abs, @function
h_abs:
	mv	a5,zero
	flt.h	a5,a0,a5
	bnez	a5,.L52
	ret
.L52:
	fneg.h	a0,a0
	ret
	.size	h_abs, .-h_abs
	.align	1
	.globl	h_neg
	.type	h_neg, @function
h_neg:
	fneg.h	a0,a0
	ret
	.size	h_neg, .-h_neg
	.globl	sz
	.data
	.align	2
	.type	sz, @object
	.size	sz, 16
sz:
	.word	2
	.word	2
	.word	2
	.word	2
	.section	.srodata.cst2,"aM",@progbits,2
	.align	1
.LC0:
	.half	15872
.LC1:
	.half	16457
.LC2:
	.half	15360
	.ident	"GCC: (GNU) 7.1.1 20170509"
