	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops3.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	rev16                           # -- Begin function rev16
	.p2align	1
	.type	rev16,@function
rev16:                                  # @rev16
# %bb.0:                                # %entry
	blez	a3, .LBB0_8
# %bb.1:                                # %for.body.lr.ph
	slli	a6, a3, 1
	p.bneimm	a3, 1, .LBB0_3
# %bb.2:
	li	a7, 0
	j	.LBB0_6
.LBB0_3:                                # %vector.ph
	lui	a4, 524288
	add	a5, a6, a1
	addi	a4, a4, -2
	and	a7, a3, a4
	addi	t4, a5, -4
	slli	t0, a7, 1
	add	t0, t0, a0
	mv	t1, a2
	mv	a5, a0
.LBB0_4:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	lw	t2, 0(t4)
	p.lw	t3, 4(t1!)
	pv.shuffle.sci.h	a4, t2, 1
	pv.add.h	a4, t3, a4
	p.sw	a4, 4(a5!)
	addi	t4, t4, -4
	bne	a5, t0, .LBB0_4
# %bb.5:                                # %middle.block
	beq	a3, a7, .LBB0_8
.LBB0_6:                                # %for.body.preheader
	slli	a7, a7, 1
	add	a3, a0, a7
	add	a2, a2, a7
	sub	a4, a6, a7
	add	a1, a1, a4
	addi	a1, a1, -2
	add	a0, a0, a6
.LBB0_7:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	lh	a4, 0(a1)
	p.lhu	a5, 2(a2!)
	add	a4, a4, a5
	p.sh	a4, 2(a3!)
	addi	a1, a1, -2
	bne	a3, a0, .LBB0_7
.LBB0_8:                                # %for.cond.cleanup
	ret
.Lfunc_end0:
	.size	rev16, .Lfunc_end0-rev16
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops3.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	rev8                            # -- Begin function rev8
	.p2align	1
	.type	rev8,@function
rev8:                                   # @rev8
# %bb.0:                                # %entry
	blez	a2, .LBB0_8
# %bb.1:                                # %for.body.lr.ph
	li	a3, 4
	bgeu	a2, a3, .LBB0_3
# %bb.2:
	li	a6, 0
	j	.LBB0_6
.LBB0_3:                                # %vector.ph
	lui	a3, 524288
	add	a4, a2, a1
	addi	a3, a3, -4
	and	a6, a2, a3
	addi	a4, a4, -4
	add	a7, a6, a0
	mv	a3, a0
.LBB0_4:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	lw	a5, 0(a4)
	pv.shufflei0.sci.b	a5, a5, 27
	p.sw	a5, 4(a3!)
	addi	a4, a4, -4
	bne	a3, a7, .LBB0_4
# %bb.5:                                # %middle.block
	beq	a2, a6, .LBB0_8
.LBB0_6:                                # %for.body.preheader
	add	a4, a0, a6
	not	a3, a6
	add	a1, a1, a2
	add	a1, a1, a3
	add	a0, a0, a2
.LBB0_7:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	lbu	a2, 0(a1)
	p.sb	a2, 1(a4!)
	addi	a1, a1, -1
	bne	a4, a0, .LBB0_7
.LBB0_8:                                # %for.cond.cleanup
	ret
.Lfunc_end0:
	.size	rev8, .Lfunc_end0-rev8
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops3.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	cond16                          # -- Begin function cond16
	.p2align	1
	.type	cond16,@function
cond16:                                 # @cond16
# %bb.0:                                # %entry
	blez	a2, .LBB0_10
# %bb.1:                                # %for.body.preheader
	p.bneimm	a2, 1, .LBB0_3
# %bb.2:
	li	a6, 0
	j	.LBB0_11
.LBB0_3:                                # %vector.ph
	lui	a3, 524288
	addi	a3, a3, -2
	and	a6, a2, a3
	addi	a4, a0, 2
	slli	a7, a6, 1
	add	a7, a7, a1
	sub	a3, a7, a1
	srli	a3, a3, 2
	pv.add.sci.h	t0, zero, 0
	mv	a5, a1
.LBB0_4:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	lw	t1, 0(a5)
	pv.cmpgt.h	t2, t1, t0
	pv.extract.h	a3, t2, 0
	andi	a3, a3, 1
	bnez	a3, .LBB0_7
# %bb.5:                                # %pred.store.continue
                                        #   in Loop: Header=BB0_4 Depth=1
	pv.extract.h	a3, t2, 1
	andi	a3, a3, 1
	bnez	a3, .LBB0_8
.LBB0_6:                                # Block address taken
                                        # %pred.store.continue9
                                        #   in Loop: Header=BB0_4 Depth=1
                                        # Label of block must be emitted
	addi	a5, a5, 4
	addi	a4, a4, 4
	bne	a5, a7, .LBB0_4
	j	.LBB0_9
.LBB0_7:                                # %pred.store.if
                                        #   in Loop: Header=BB0_4 Depth=1
	pv.extract.h	a3, t1, 0
	sh	a3, -2(a4)
	pv.extract.h	a3, t2, 1
	andi	a3, a3, 1
	beqz	a3, .LBB0_6
.LBB0_8:                                # %pred.store.if8
                                        #   in Loop: Header=BB0_4 Depth=1
	pv.extract.h	a3, t1, 1
	sh	a3, 0(a4)
	addi	a5, a5, 4
	addi	a4, a4, 4
	bne	a5, a7, .LBB0_4
.LBB0_9:                                # %middle.block
	bne	a2, a6, .LBB0_11
.LBB0_10:                               # %for.cond.cleanup
	ret
.LBB0_11:                               # %for.body.preheader10
	slli	a6, a6, 1
	slli	a3, a2, 1
	add	a2, a1, a6
	add	a1, a1, a3
	sub	a3, a1, a2
	srli	a3, a3, 1
	add	a0, a0, a6
	.p2align	2
# %bb.16:                               # %for.body.preheader10
	lp.setup	x0, a3, .LBB0_15
.LBB0_13:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lh	a3, 2(a2!)
	blez	a3, .LBB0_12
# %bb.14:                               # %if.then
                                        #   in Loop: Header=BB0_13 Depth=1
	sh	a3, 0(a0)
.LBB0_12:                               # Block address taken
                                        # %for.inc
                                        #   in Loop: Header=BB0_13 Depth=1
                                        # Label of block must be emitted
.LBB0_15:                               #   in Loop: Header=BB0_13 Depth=1
                                        # Label of block must be emitted
	addi	a0, a0, 2
	j	.LBB0_10
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Ltmp1:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	cond16, .Lfunc_end0-cond16
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops3.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	widen8to16                      # -- Begin function widen8to16
	.p2align	1
	.type	widen8to16,@function
widen8to16:                             # @widen8to16
# %bb.0:                                # %entry
	blez	a2, .LBB0_8
# %bb.1:                                # %for.body.preheader
	p.bneimm	a2, 1, .LBB0_3
# %bb.2:
	li	a6, 0
	j	.LBB0_6
.LBB0_3:                                # %vector.ph
	lui	a3, 524288
	addi	a3, a3, -2
	and	a6, a2, a3
	slli	a4, a6, 1
	add	a7, a4, a0
	mv	a5, a1
	mv	a3, a0
.LBB0_4:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	lb	t0, 0(a5)
	lb	a4, 1(a5)
	pv.pack.h	a4, a4, t0
	p.sw	a4, 4(a3!)
	addi	a5, a5, 2
	bne	a3, a7, .LBB0_4
# %bb.5:                                # %middle.block
	beq	a2, a6, .LBB0_8
.LBB0_6:                                # %for.body.preheader6
	slli	a3, a6, 1
	add	a1, a1, a6
	slli	a4, a2, 1
	add	a2, a0, a3
	add	a0, a0, a4
.LBB0_7:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lb	a3, 1(a1!)
	p.sh	a3, 2(a2!)
	bne	a2, a0, .LBB0_7
.LBB0_8:                                # %for.cond.cleanup
	ret
.Lfunc_end0:
	.size	widen8to16, .Lfunc_end0-widen8to16
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops3.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	narrow16to8                     # -- Begin function narrow16to8
	.p2align	1
	.type	narrow16to8,@function
narrow16to8:                            # @narrow16to8
# %bb.0:                                # %entry
	blez	a2, .LBB0_8
# %bb.1:                                # %for.body.preheader
	p.bneimm	a2, 1, .LBB0_3
# %bb.2:
	li	a6, 0
	j	.LBB0_6
.LBB0_3:                                # %vector.ph
	lui	a3, 524288
	addi	a3, a3, -2
	and	a6, a2, a3
	add	a7, a6, a0
	sub	a3, a7, a0
	srli	t0, a3, 1
	pv.add.sci.h	t1, zero, 8
	mv	a3, a1
	mv	a4, a0
	.p2align	2
# %bb.10:                               # %vector.ph
	lp.setup	x0, t0, .LBB0_9
.LBB0_4:                                # Block address taken
                                        # %vector.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	p.lw	a5, 4(a3!)
	pv.srl.h	a5, a5, t1
	pv.extract.h	t0, a5, 1
	pv.extract.h	a5, a5, 0
	sb	a5, 0(a4)
	sb	t0, 1(a4)
.LBB0_9:                                #   in Loop: Header=BB0_4 Depth=1
                                        # Label of block must be emitted
	addi	a4, a4, 2
# %bb.5:                                # %middle.block
	beq	a2, a6, .LBB0_8
.LBB0_6:                                # %for.body.preheader6
	add	a3, a0, a6
	slli	a6, a6, 1
	add	a1, a1, a6
	add	a0, a0, a2
.LBB0_7:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	lbu	a2, 1(a1)
	p.sb	a2, 1(a3!)
	addi	a1, a1, 2
	bne	a3, a0, .LBB0_7
.LBB0_8:                                # %for.cond.cleanup
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	narrow16to8, .Lfunc_end0-narrow16to8
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops3.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	mulhi16                         # -- Begin function mulhi16
	.p2align	1
	.type	mulhi16,@function
mulhi16:                                # @mulhi16
# %bb.0:                                # %entry
	blez	a3, .LBB0_8
# %bb.1:                                # %for.body.preheader
	p.bneimm	a3, 1, .LBB0_3
# %bb.2:
	li	a6, 0
	j	.LBB0_6
.LBB0_3:                                # %vector.ph
	lui	a4, 524288
	addi	a4, a4, -2
	and	a6, a3, a4
	slli	a7, a6, 1
	add	a7, a7, a0
	mv	t0, a1
	mv	t5, a2
	mv	a4, a0
.LBB0_4:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	p.lw	t1, 4(t0!)
	p.lw	t2, 4(t5!)
	pv.extract.h	t3, t1, 0
	pv.extract.h	t1, t1, 1
	pv.extract.h	t4, t2, 0
	pv.extract.h	a5, t2, 1
	p.muls	t1, a5, t1
	p.muls	a5, t4, t3
	srli	t2, a5, 15
	srli	a5, t1, 15
	pv.pack.h	a5, a5, t2
	p.sw	a5, 4(a4!)
	bne	a4, a7, .LBB0_4
# %bb.5:                                # %middle.block
	beq	a3, a6, .LBB0_8
.LBB0_6:                                # %for.body.preheader8
	slli	a6, a6, 1
	slli	a4, a3, 1
	add	a3, a0, a6
	add	a2, a2, a6
	add	a1, a1, a6
	add	a0, a0, a4
.LBB0_7:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lh	a4, 2(a1!)
	p.lh	a5, 2(a2!)
	mul	a4, a5, a4
	srli	a4, a4, 15
	p.sh	a4, 2(a3!)
	bne	a3, a0, .LBB0_7
.LBB0_8:                                # %for.cond.cleanup
	ret
.Lfunc_end0:
	.size	mulhi16, .Lfunc_end0-mulhi16
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops3.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	idx16                           # -- Begin function idx16
	.p2align	1
	.type	idx16,@function
idx16:                                  # @idx16
# %bb.0:                                # %entry
	blez	a3, .LBB0_8
# %bb.1:                                # %for.body.preheader
	p.bneimm	a3, 1, .LBB0_3
# %bb.2:
	li	a6, 0
	j	.LBB0_6
.LBB0_3:                                # %vector.ph
	lui	a4, 524288
	addi	a4, a4, -2
	and	a6, a3, a4
	slli	a7, a6, 1
	add	a7, a7, a0
	mv	a4, a2
	mv	t1, a0
.LBB0_4:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	lbu	t0, 0(a4)
	lbu	a5, 1(a4)
	pv.pack.h	a5, a5, t0
	pv.extract.h	t0, a5, 1
	pv.extract.h	a5, a5, 0
	p.extbz	t0, t0
	p.extbz	a5, a5
	slli	a5, a5, 1
	slli	t0, t0, 1
	add	a5, a5, a1
	add	t0, t0, a1
	lh	t2, 0(a5)
	lh	a5, 0(t0)
	pv.pack.h	a5, a5, t2
	p.sw	a5, 4(t1!)
	addi	a4, a4, 2
	bne	t1, a7, .LBB0_4
# %bb.5:                                # %middle.block
	beq	a3, a6, .LBB0_8
.LBB0_6:                                # %for.body.preheader6
	slli	a4, a6, 1
	add	a2, a2, a6
	slli	a5, a3, 1
	add	a3, a0, a4
	add	a0, a0, a5
.LBB0_7:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lbu	a4, 1(a2!)
	slli	a4, a4, 1
	add	a4, a4, a1
	lh	a4, 0(a4)
	p.sh	a4, 2(a3!)
	bne	a3, a0, .LBB0_7
.LBB0_8:                                # %for.cond.cleanup
	ret
.Lfunc_end0:
	.size	idx16, .Lfunc_end0-idx16
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops3.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	find16                          # -- Begin function find16
	.p2align	1
	.type	find16,@function
find16:                                 # @find16
# %bb.0:                                # %entry
	mv	a3, a0
	li	a0, -1
	blez	a2, .LBB0_4
# %bb.1:                                # %for.body.preheader
	li	a4, 0
	p.exthz	a1, a1
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lhu	a5, 2(a3!)
	beq	a5, a1, .LBB0_5
# %bb.3:                                # %for.inc
                                        #   in Loop: Header=BB0_2 Depth=1
	addi	a4, a4, 1
	bne	a2, a4, .LBB0_2
.LBB0_4:                                # %cleanup
	ret
.LBB0_5:
	mv	a0, a4
	ret
.Lfunc_end0:
	.size	find16, .Lfunc_end0-find16
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops3.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	iota8                           # -- Begin function iota8
	.p2align	1
	.type	iota8,@function
iota8:                                  # @iota8
# %bb.0:                                # %entry
	blez	a1, .LBB0_8
# %bb.1:                                # %for.body.preheader
	li	a2, 4
	bgeu	a1, a2, .LBB0_3
# %bb.2:
	li	a2, 0
	j	.LBB0_6
.LBB0_3:                                # %vector.ph
	lui	a2, 524288
	li	a3, 2
	li	a4, 3
	li	a5, 1
	addi	a2, a2, -4
	pv.packhi.b	a3, a4, a3
	and	a2, a2, a1
	pv.packlo.b	a3, a5, zero
	add	a6, a2, a0
	pv.add.sci.b	a5, zero, 4
	mv	a4, a0
.LBB0_4:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	p.sw	a3, 4(a4!)
	pv.add.b	a3, a3, a5
	bne	a4, a6, .LBB0_4
# %bb.5:                                # %middle.block
	beq	a1, a2, .LBB0_8
.LBB0_6:                                # %for.body.preheader6
	add	a3, a0, a2
	add	a0, a0, a1
.LBB0_7:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.sb	a2, 1(a3!)
	addi	a2, a2, 1
	bne	a3, a0, .LBB0_7
.LBB0_8:                                # %for.cond.cleanup
	ret
.Lfunc_end0:
	.size	iota8, .Lfunc_end0-iota8
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops3.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	cadd                            # -- Begin function cadd
	.p2align	1
	.type	cadd,@function
cadd:                                   # @cadd
# %bb.0:                                # %entry
	blez	a3, .LBB0_8
# %bb.1:                                # %for.body.preheader
	p.bneimm	a3, 1, .LBB0_3
# %bb.2:
	li	a6, 0
	j	.LBB0_6
.LBB0_3:                                # %vector.ph
	lui	a4, 524288
	addi	a4, a4, -2
	and	a6, a3, a4
	slli	a7, a6, 2
	add	a7, a7, a0
	sub	a4, a7, a0
	srli	t1, a4, 3
	mv	t0, a1
	mv	a5, a2
	mv	a4, a0
	.p2align	2
# %bb.10:                               # %vector.ph
	lp.setup	x0, t1, .LBB0_9
.LBB0_4:                                # Block address taken
                                        # %vector.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	lw	t1, 0(t0)
	lw	t2, 4(t0)
	lw	t3, 0(a5)
	lw	t4, 4(a5)
	pv.add.h	t1, t3, t1
	pv.add.h	t2, t4, t2
	sw	t1, 0(a4)
	sw	t2, 4(a4)
	addi	a4, a4, 8
	addi	a5, a5, 8
.LBB0_9:                                #   in Loop: Header=BB0_4 Depth=1
                                        # Label of block must be emitted
	addi	t0, t0, 8
# %bb.5:                                # %middle.block
	beq	a3, a6, .LBB0_8
.LBB0_6:                                # %for.body.preheader17
	slli	a6, a6, 2
	slli	a4, a3, 2
	add	a3, a0, a6
	add	a2, a2, a6
	add	a1, a1, a6
	add	a0, a0, a4
.LBB0_7:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lw	a4, 4(a1!)
	p.lw	a5, 4(a2!)
	pv.add.h	a4, a5, a4
	p.sw	a4, 4(a3!)
	bne	a3, a0, .LBB0_7
.LBB0_8:                                # %for.cond.cleanup
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	cadd, .Lfunc_end0-cadd
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
