	.file	"add2div2_const.c"
	.option nopic
	.text
	.align	1
	.globl	f
	.type	f, @function
f:
	lui	a5,%hi(.LC0)
	lw	a0,%lo(.LC0)(a5)
	lui	a5,%hi(.LC1)
	lw	a5,%lo(.LC1)(a5)
	pv.add.h.div2 	a0,a0,a5	 # Add2>>1 Op Vect
	ret
	.size	f, .-f
	.section	.srodata.cst4,"aM",@progbits,4
	.align	2
.LC0:
	.half	32767
	.half	-4
.LC1:
	.half	1
	.half	-4
	.ident	"GCC: (GNU) 7.1.1 20170509"
