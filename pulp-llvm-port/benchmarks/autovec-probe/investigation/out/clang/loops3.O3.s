	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops3.c"
	.text
	.globl	deint16                         # -- Begin function deint16
	.p2align	1
	.type	deint16,@function
deint16:                                # @deint16
# %bb.0:                                # %entry
	blez	a2, .LBB0_3
# %bb.1:                                # %for.body.preheader
	addi	a1, a1, 2
	slli	a2, a2, 1
	add	a2, a2, a0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	lh	a3, -2(a1)
	lh	a4, 0(a1)
	add	a3, a3, a4
	p.sh	a3, 2(a0!)
	addi	a1, a1, 4
	bne	a0, a2, .LBB0_2
.LBB0_3:                                # %for.cond.cleanup
	ret
.Lfunc_end0:
	.size	deint16, .Lfunc_end0-deint16
                                        # -- End function
	.globl	int16                           # -- Begin function int16
	.p2align	1
	.type	int16,@function
int16:                                  # @int16
# %bb.0:                                # %entry
	blez	a3, .LBB1_3
# %bb.1:                                # %for.body.preheader
	slli	a3, a3, 1
	add	a3, a3, a2
	sub	a4, a3, a2
	srli	a4, a4, 1
	addi	a0, a0, 2
	.p2align	2
# %bb.5:                                # %for.body.preheader
	lp.setup	x0, a4, .LBB1_4
.LBB1_2:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	p.lhu	a4, 2(a1!)
	sh	a4, -2(a0)
	p.lhu	a4, 2(a2!)
	sh	a4, 0(a0)
.LBB1_4:                                #   in Loop: Header=BB1_2 Depth=1
                                        # Label of block must be emitted
	addi	a0, a0, 4
.LBB1_3:                                # %for.cond.cleanup
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Lfunc_end1:
	.size	int16, .Lfunc_end1-int16
                                        # -- End function
	.globl	rev16                           # -- Begin function rev16
	.p2align	1
	.type	rev16,@function
rev16:                                  # @rev16
# %bb.0:                                # %entry
	blez	a3, .LBB2_3
# %bb.1:                                # %for.body.lr.ph
	slli	a3, a3, 1
	add	a1, a1, a3
	addi	a1, a1, -2
	add	a3, a3, a0
.LBB2_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	lh	a4, 0(a1)
	p.lhu	a5, 2(a2!)
	add	a4, a4, a5
	p.sh	a4, 2(a0!)
	addi	a1, a1, -2
	bne	a0, a3, .LBB2_2
.LBB2_3:                                # %for.cond.cleanup
	ret
.Lfunc_end2:
	.size	rev16, .Lfunc_end2-rev16
                                        # -- End function
	.globl	rev8                            # -- Begin function rev8
	.p2align	1
	.type	rev8,@function
rev8:                                   # @rev8
# %bb.0:                                # %entry
	blez	a2, .LBB3_3
# %bb.1:                                # %for.body.lr.ph
	add	a1, a1, a2
	addi	a1, a1, -1
	add	a2, a2, a0
.LBB3_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	lbu	a3, 0(a1)
	p.sb	a3, 1(a0!)
	addi	a1, a1, -1
	bne	a0, a2, .LBB3_2
.LBB3_3:                                # %for.cond.cleanup
	ret
.Lfunc_end3:
	.size	rev8, .Lfunc_end3-rev8
                                        # -- End function
	.globl	cond16                          # -- Begin function cond16
	.p2align	1
	.type	cond16,@function
cond16:                                 # @cond16
# %bb.0:                                # %entry
	blez	a2, .LBB4_5
# %bb.1:                                # %for.body.preheader
	slli	a2, a2, 1
	add	a2, a2, a1
	sub	a3, a2, a1
	srli	a3, a3, 1
	.p2align	2
# %bb.7:                                # %for.body.preheader
	lp.setup	x0, a3, .LBB4_6
.LBB4_3:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lh	a3, 2(a1!)
	blez	a3, .LBB4_2
# %bb.4:                                # %if.then
                                        #   in Loop: Header=BB4_3 Depth=1
	sh	a3, 0(a0)
.LBB4_2:                                # Block address taken
                                        # %for.inc
                                        #   in Loop: Header=BB4_3 Depth=1
                                        # Label of block must be emitted
.LBB4_6:                                #   in Loop: Header=BB4_3 Depth=1
                                        # Label of block must be emitted
	addi	a0, a0, 2
	j	.LBB4_5
.LBB4_5:                                # %for.cond.cleanup
	ret
.Ltmp1:                                 # Address of block that was removed by CodeGen
.Lfunc_end4:
	.size	cond16, .Lfunc_end4-cond16
                                        # -- End function
	.globl	widen8to16                      # -- Begin function widen8to16
	.p2align	1
	.type	widen8to16,@function
widen8to16:                             # @widen8to16
# %bb.0:                                # %entry
	blez	a2, .LBB5_3
# %bb.1:                                # %for.body.preheader
	slli	a2, a2, 1
	add	a2, a2, a0
.LBB5_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lb	a3, 1(a1!)
	p.sh	a3, 2(a0!)
	bne	a0, a2, .LBB5_2
.LBB5_3:                                # %for.cond.cleanup
	ret
.Lfunc_end5:
	.size	widen8to16, .Lfunc_end5-widen8to16
                                        # -- End function
	.globl	narrow16to8                     # -- Begin function narrow16to8
	.p2align	1
	.type	narrow16to8,@function
narrow16to8:                            # @narrow16to8
# %bb.0:                                # %entry
	blez	a2, .LBB6_3
# %bb.1:                                # %for.body.preheader
	add	a2, a2, a0
.LBB6_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	lbu	a3, 1(a1)
	p.sb	a3, 1(a0!)
	addi	a1, a1, 2
	bne	a0, a2, .LBB6_2
.LBB6_3:                                # %for.cond.cleanup
	ret
.Lfunc_end6:
	.size	narrow16to8, .Lfunc_end6-narrow16to8
                                        # -- End function
	.globl	mulhi16                         # -- Begin function mulhi16
	.p2align	1
	.type	mulhi16,@function
mulhi16:                                # @mulhi16
# %bb.0:                                # %entry
	blez	a3, .LBB7_3
# %bb.1:                                # %for.body.preheader
	slli	a3, a3, 1
	add	a3, a3, a0
.LBB7_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lh	a4, 2(a1!)
	p.lh	a5, 2(a2!)
	mul	a4, a5, a4
	srli	a4, a4, 15
	p.sh	a4, 2(a0!)
	bne	a0, a3, .LBB7_2
.LBB7_3:                                # %for.cond.cleanup
	ret
.Lfunc_end7:
	.size	mulhi16, .Lfunc_end7-mulhi16
                                        # -- End function
	.globl	stride2                         # -- Begin function stride2
	.p2align	1
	.type	stride2,@function
stride2:                                # @stride2
# %bb.0:                                # %entry
	blez	a2, .LBB8_3
# %bb.1:                                # %for.body.preheader
	slli	a2, a2, 1
	add	a2, a2, a0
.LBB8_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lhu	a3, 4(a1!)
	p.sh	a3, 2(a0!)
	bne	a0, a2, .LBB8_2
.LBB8_3:                                # %for.cond.cleanup
	ret
.Lfunc_end8:
	.size	stride2, .Lfunc_end8-stride2
                                        # -- End function
	.globl	idx16                           # -- Begin function idx16
	.p2align	1
	.type	idx16,@function
idx16:                                  # @idx16
# %bb.0:                                # %entry
	blez	a3, .LBB9_3
# %bb.1:                                # %for.body.preheader
	slli	a3, a3, 1
	add	a3, a3, a0
.LBB9_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lbu	a4, 1(a2!)
	slli	a4, a4, 1
	add	a4, a4, a1
	lh	a4, 0(a4)
	p.sh	a4, 2(a0!)
	bne	a0, a3, .LBB9_2
.LBB9_3:                                # %for.cond.cleanup
	ret
.Lfunc_end9:
	.size	idx16, .Lfunc_end9-idx16
                                        # -- End function
	.globl	find16                          # -- Begin function find16
	.p2align	1
	.type	find16,@function
find16:                                 # @find16
# %bb.0:                                # %entry
	mv	a3, a0
	li	a0, -1
	blez	a2, .LBB10_4
# %bb.1:                                # %for.body.preheader
	li	a4, 0
	p.exthz	a1, a1
.LBB10_2:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lhu	a5, 2(a3!)
	beq	a5, a1, .LBB10_5
# %bb.3:                                # %for.inc
                                        #   in Loop: Header=BB10_2 Depth=1
	addi	a4, a4, 1
	bne	a2, a4, .LBB10_2
.LBB10_4:                               # %cleanup
	ret
.LBB10_5:
	mv	a0, a4
	ret
.Lfunc_end10:
	.size	find16, .Lfunc_end10-find16
                                        # -- End function
	.globl	iota8                           # -- Begin function iota8
	.p2align	1
	.type	iota8,@function
iota8:                                  # @iota8
# %bb.0:                                # %entry
	blez	a1, .LBB11_3
# %bb.1:                                # %for.body.preheader
	li	a2, 0
	add	a1, a1, a0
.LBB11_2:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.sb	a2, 1(a0!)
	addi	a2, a2, 1
	bne	a0, a1, .LBB11_2
.LBB11_3:                               # %for.cond.cleanup
	ret
.Lfunc_end11:
	.size	iota8, .Lfunc_end11-iota8
                                        # -- End function
	.globl	cadd                            # -- Begin function cadd
	.p2align	1
	.type	cadd,@function
cadd:                                   # @cadd
# %bb.0:                                # %entry
	blez	a3, .LBB12_3
# %bb.1:                                # %for.body.preheader
	addi	a0, a0, 2
	addi	a2, a2, 2
	slli	a3, a3, 2
	add	a6, a0, a3
	sub	a4, a6, a0
	srli	a4, a4, 2
	addi	a1, a1, 2
	.p2align	2
# %bb.5:                                # %for.body.preheader
	lp.setup	x0, a4, .LBB12_4
.LBB12_2:                               # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	lh	a7, -2(a1)
	lh	a5, 0(a1)
	lh	a3, -2(a2)
	lh	a4, 0(a2)
	add	a3, a3, a7
	add	a4, a4, a5
	sh	a3, -2(a0)
	sh	a4, 0(a0)
	addi	a0, a0, 4
	addi	a2, a2, 4
.LBB12_4:                               #   in Loop: Header=BB12_2 Depth=1
                                        # Label of block must be emitted
	addi	a1, a1, 4
.LBB12_3:                               # %for.cond.cleanup
	ret
.Ltmp2:                                 # Address of block that was removed by CodeGen
.Lfunc_end12:
	.size	cadd, .Lfunc_end12-cadd
                                        # -- End function
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
