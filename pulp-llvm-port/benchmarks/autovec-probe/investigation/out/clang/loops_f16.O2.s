	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops_f16.c"
	.text
	.globl	win_f16                         # -- Begin function win_f16
	.p2align	1
	.type	win_f16,@function
win_f16:                                # @win_f16
# %bb.0:                                # %entry
	blez	a2, .LBB0_3
# %bb.1:                                # %for.body.preheader
	slli	a2, a2, 1
	add	a2, a2, a1
	sub	a3, a2, a1
	srli	a3, a3, 1
	.p2align	2
# %bb.5:                                # %for.body.preheader
	lp.setup	x0, a3, .LBB0_4
.LBB0_2:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	lh	a3, 0(a0)
	lh	a4, 0(a1)
	addi	a1, a1, 2
	fmul.h	a3, a3, a4
	sh	a3, 0(a0)
.LBB0_4:                                #   in Loop: Header=BB0_2 Depth=1
                                        # Label of block must be emitted
	addi	a0, a0, 2
.LBB0_3:                                # %for.cond.cleanup
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	win_f16, .Lfunc_end0-win_f16
                                        # -- End function
	.globl	win_f16_o                       # -- Begin function win_f16_o
	.p2align	1
	.type	win_f16_o,@function
win_f16_o:                              # @win_f16_o
# %bb.0:                                # %entry
	blez	a3, .LBB1_3
# %bb.1:                                # %for.body.preheader
	slli	a3, a3, 1
	add	a3, a3, a0
	sub	a4, a3, a0
	srli	a4, a4, 1
	.p2align	2
# %bb.5:                                # %for.body.preheader
	lp.setup	x0, a4, .LBB1_4
.LBB1_2:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	lh	a4, 0(a1)
	lh	a5, 0(a2)
	fmul.h	a4, a4, a5
	sh	a4, 0(a0)
	addi	a0, a0, 2
	addi	a2, a2, 2
.LBB1_4:                                #   in Loop: Header=BB1_2 Depth=1
                                        # Label of block must be emitted
	addi	a1, a1, 2
.LBB1_3:                                # %for.cond.cleanup
	ret
.Ltmp1:                                 # Address of block that was removed by CodeGen
.Lfunc_end1:
	.size	win_f16_o, .Lfunc_end1-win_f16_o
                                        # -- End function
	.globl	add_f16                         # -- Begin function add_f16
	.p2align	1
	.type	add_f16,@function
add_f16:                                # @add_f16
# %bb.0:                                # %entry
	blez	a3, .LBB2_3
# %bb.1:                                # %for.body.preheader
	slli	a3, a3, 1
	add	a3, a3, a0
	sub	a4, a3, a0
	srli	a4, a4, 1
	.p2align	2
# %bb.5:                                # %for.body.preheader
	lp.setup	x0, a4, .LBB2_4
.LBB2_2:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	lh	a4, 0(a1)
	lh	a5, 0(a2)
	fadd.h	a4, a4, a5
	sh	a4, 0(a0)
	addi	a0, a0, 2
	addi	a2, a2, 2
.LBB2_4:                                #   in Loop: Header=BB2_2 Depth=1
                                        # Label of block must be emitted
	addi	a1, a1, 2
.LBB2_3:                                # %for.cond.cleanup
	ret
.Ltmp2:                                 # Address of block that was removed by CodeGen
.Lfunc_end2:
	.size	add_f16, .Lfunc_end2-add_f16
                                        # -- End function
	.globl	axpy_f16                        # -- Begin function axpy_f16
	.p2align	1
	.type	axpy_f16,@function
axpy_f16:                               # @axpy_f16
# %bb.0:                                # %entry
	blez	a3, .LBB3_3
# %bb.1:                                # %for.body.preheader
	slli	a3, a3, 1
	add	a3, a3, a1
	sub	a4, a3, a1
	srli	a4, a4, 1
	.p2align	2
# %bb.5:                                # %for.body.preheader
	lp.setup	x0, a4, .LBB3_4
.LBB3_2:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	lh	a4, 0(a0)
	lh	a5, 0(a1)
	addi	a1, a1, 2
	fmadd.h	a4, a2, a5, a4
	sh	a4, 0(a0)
.LBB3_4:                                #   in Loop: Header=BB3_2 Depth=1
                                        # Label of block must be emitted
	addi	a0, a0, 2
.LBB3_3:                                # %for.cond.cleanup
	ret
.Ltmp3:                                 # Address of block that was removed by CodeGen
.Lfunc_end3:
	.size	axpy_f16, .Lfunc_end3-axpy_f16
                                        # -- End function
	.globl	scale_f16                       # -- Begin function scale_f16
	.p2align	1
	.type	scale_f16,@function
scale_f16:                              # @scale_f16
# %bb.0:                                # %entry
	blez	a3, .LBB4_3
# %bb.1:                                # %for.body.preheader
	slli	a3, a3, 1
	add	a3, a3, a0
	sub	a4, a3, a0
	srli	a4, a4, 1
	.p2align	2
# %bb.5:                                # %for.body.preheader
	lp.setup	x0, a4, .LBB4_4
.LBB4_2:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	lh	a4, 0(a1)
	fmul.h	a4, a2, a4
	sh	a4, 0(a0)
	addi	a0, a0, 2
.LBB4_4:                                #   in Loop: Header=BB4_2 Depth=1
                                        # Label of block must be emitted
	addi	a1, a1, 2
.LBB4_3:                                # %for.cond.cleanup
	ret
.Ltmp4:                                 # Address of block that was removed by CodeGen
.Lfunc_end4:
	.size	scale_f16, .Lfunc_end4-scale_f16
                                        # -- End function
	.globl	max_f16                         # -- Begin function max_f16
	.p2align	1
	.type	max_f16,@function
max_f16:                                # @max_f16
# %bb.0:                                # %entry
	blez	a3, .LBB5_5
# %bb.1:                                # %for.body.preheader
	slli	a3, a3, 1
	add	a6, a0, a3
	sub	a4, a6, a0
	srli	a4, a4, 1
	.p2align	2
# %bb.7:                                # %for.body.preheader
	lp.setup	x0, a4, .LBB5_6
.LBB5_3:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	lh	a4, 0(a1)
	lh	a5, 0(a2)
	flt.h	a3, a5, a4
	bnez	a3, .LBB5_2
# %bb.4:                                # %for.body
                                        #   in Loop: Header=BB5_3 Depth=1
	mv	a4, a5
.LBB5_2:                                # Block address taken
                                        # %for.body
                                        #   in Loop: Header=BB5_3 Depth=1
                                        # Label of block must be emitted
	sh	a4, 0(a0)
	addi	a0, a0, 2
	addi	a2, a2, 2
.LBB5_6:                                #   in Loop: Header=BB5_3 Depth=1
                                        # Label of block must be emitted
	addi	a1, a1, 2
	j	.LBB5_5
.LBB5_5:                                # %for.cond.cleanup
	ret
.Ltmp5:                                 # Address of block that was removed by CodeGen
.Lfunc_end5:
	.size	max_f16, .Lfunc_end5-max_f16
                                        # -- End function
	.globl	magsq_f16                       # -- Begin function magsq_f16
	.p2align	1
	.type	magsq_f16,@function
magsq_f16:                              # @magsq_f16
# %bb.0:                                # %entry
	blez	a2, .LBB6_3
# %bb.1:                                # %for.body.preheader
	slli	a2, a2, 1
	add	a2, a2, a0
	sub	a3, a2, a0
	srli	a3, a3, 1
	addi	a1, a1, 2
	.p2align	2
# %bb.5:                                # %for.body.preheader
	lp.setup	x0, a3, .LBB6_4
.LBB6_2:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	lh	a3, 0(a1)
	lh	a4, -2(a1)
	fmul.h	a3, a3, a3
	fmadd.h	a3, a4, a4, a3
	sh	a3, 0(a0)
	addi	a0, a0, 2
.LBB6_4:                                #   in Loop: Header=BB6_2 Depth=1
                                        # Label of block must be emitted
	addi	a1, a1, 4
.LBB6_3:                                # %for.cond.cleanup
	ret
.Ltmp6:                                 # Address of block that was removed by CodeGen
.Lfunc_end6:
	.size	magsq_f16, .Lfunc_end6-magsq_f16
                                        # -- End function
	.globl	dot_f16                         # -- Begin function dot_f16
	.p2align	1
	.type	dot_f16,@function
dot_f16:                                # @dot_f16
# %bb.0:                                # %entry
	blez	a2, .LBB7_4
# %bb.1:                                # %for.body.preheader
	slli	a2, a2, 1
	add	a3, a1, a2
	sub	a2, a3, a1
	srli	a4, a2, 1
	li	a2, 0
	.p2align	2
# %bb.6:                                # %for.body.preheader
	lp.setup	x0, a4, .LBB7_5
.LBB7_2:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	lh	a4, 0(a0)
	lh	a5, 0(a1)
	addi	a1, a1, 2
	fmadd.h	a2, a4, a5, a2
.LBB7_5:                                #   in Loop: Header=BB7_2 Depth=1
                                        # Label of block must be emitted
	addi	a0, a0, 2
# %bb.3:                                # %for.cond.cleanup
	mv	a0, a2
	ret
.LBB7_4:
	li	a0, 0
	ret
.Ltmp7:                                 # Address of block that was removed by CodeGen
.Lfunc_end7:
	.size	dot_f16, .Lfunc_end7-dot_f16
                                        # -- End function
	.globl	win_f16_nr                      # -- Begin function win_f16_nr
	.p2align	1
	.type	win_f16_nr,@function
win_f16_nr:                             # @win_f16_nr
# %bb.0:                                # %entry
	blez	a2, .LBB8_3
# %bb.1:                                # %for.body.preheader
	slli	a2, a2, 1
	add	a2, a2, a1
	sub	a3, a2, a1
	srli	a3, a3, 1
	.p2align	2
# %bb.5:                                # %for.body.preheader
	lp.setup	x0, a3, .LBB8_4
.LBB8_2:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	lh	a3, 0(a0)
	lh	a4, 0(a1)
	addi	a1, a1, 2
	fmul.h	a3, a3, a4
	sh	a3, 0(a0)
.LBB8_4:                                #   in Loop: Header=BB8_2 Depth=1
                                        # Label of block must be emitted
	addi	a0, a0, 2
.LBB8_3:                                # %for.cond.cleanup
	ret
.Ltmp8:                                 # Address of block that was removed by CodeGen
.Lfunc_end8:
	.size	win_f16_nr, .Lfunc_end8-win_f16_nr
                                        # -- End function
	.globl	win_f16_k256                    # -- Begin function win_f16_k256
	.p2align	1
	.type	win_f16_k256,@function
win_f16_k256:                           # @win_f16_k256
# %bb.0:                                # %entry
	addi	a2, a1, 512
	sub	a3, a2, a1
	srli	a3, a3, 1
	.p2align	2
# %bb.4:                                # %entry
	lp.setup	x0, a3, .LBB9_3
.LBB9_1:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	lh	a3, 0(a0)
	lh	a4, 0(a1)
	addi	a1, a1, 2
	fmul.h	a3, a3, a4
	sh	a3, 0(a0)
.LBB9_3:                                #   in Loop: Header=BB9_1 Depth=1
                                        # Label of block must be emitted
	addi	a0, a0, 2
# %bb.2:                                # %for.cond.cleanup
	ret
.Ltmp9:                                 # Address of block that was removed by CodeGen
.Lfunc_end9:
	.size	win_f16_k256, .Lfunc_end9-win_f16_k256
                                        # -- End function
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
