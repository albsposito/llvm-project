	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	add16                           # -- Begin function add16
	.p2align	1
	.type	add16,@function
add16:                                  # @add16
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
	mv	t2, a2
	mv	a4, a0
.LBB0_4:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	p.lw	t1, 4(t0!)
	p.lw	a5, 4(t2!)
	pv.add.h	a5, a5, t1
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
	p.lhu	a4, 2(a1!)
	p.lhu	a5, 2(a2!)
	add	a4, a4, a5
	p.sh	a4, 2(a3!)
	bne	a3, a0, .LBB0_7
.LBB0_8:                                # %for.cond.cleanup
	ret
.Lfunc_end0:
	.size	add16, .Lfunc_end0-add16
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	add8                            # -- Begin function add8
	.p2align	1
	.type	add8,@function
add8:                                   # @add8
# %bb.0:                                # %entry
	blez	a3, .LBB0_8
# %bb.1:                                # %for.body.preheader
	li	a4, 4
	bgeu	a3, a4, .LBB0_3
# %bb.2:
	li	a6, 0
	j	.LBB0_6
.LBB0_3:                                # %vector.ph
	lui	a4, 524288
	addi	a4, a4, -4
	and	a6, a3, a4
	add	a7, a6, a0
	mv	t0, a1
	mv	t2, a2
	mv	a4, a0
.LBB0_4:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	p.lw	t1, 4(t0!)
	p.lw	a5, 4(t2!)
	pv.add.b	a5, a5, t1
	p.sw	a5, 4(a4!)
	bne	a4, a7, .LBB0_4
# %bb.5:                                # %middle.block
	beq	a3, a6, .LBB0_8
.LBB0_6:                                # %for.body.preheader8
	add	a5, a0, a6
	add	a2, a2, a6
	add	a1, a1, a6
	add	a0, a0, a3
.LBB0_7:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lbu	a3, 1(a1!)
	p.lbu	a4, 1(a2!)
	add	a3, a3, a4
	p.sb	a3, 1(a5!)
	bne	a5, a0, .LBB0_7
.LBB0_8:                                # %for.cond.cleanup
	ret
.Lfunc_end0:
	.size	add8, .Lfunc_end0-add8
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	sub16                           # -- Begin function sub16
	.p2align	1
	.type	sub16,@function
sub16:                                  # @sub16
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
	mv	t2, a2
	mv	a4, a0
.LBB0_4:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	p.lw	t1, 4(t0!)
	p.lw	a5, 4(t2!)
	pv.sub.h	a5, t1, a5
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
	p.lhu	a4, 2(a1!)
	p.lhu	a5, 2(a2!)
	sub	a4, a4, a5
	p.sh	a4, 2(a3!)
	bne	a3, a0, .LBB0_7
.LBB0_8:                                # %for.cond.cleanup
	ret
.Lfunc_end0:
	.size	sub16, .Lfunc_end0-sub16
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	and16                           # -- Begin function and16
	.p2align	1
	.type	and16,@function
and16:                                  # @and16
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
	mv	t2, a2
	mv	a4, a0
.LBB0_4:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	p.lw	t1, 4(t0!)
	p.lw	a5, 4(t2!)
	pv.and.h	a5, a5, t1
	p.sw	a5, 4(a4!)
	bne	a4, a7, .LBB0_4
# %bb.5:                                # %middle.block
	beq	a3, a6, .LBB0_8
.LBB0_6:                                # %for.body.preheader9
	slli	a6, a6, 1
	slli	a4, a3, 1
	add	a3, a0, a6
	add	a2, a2, a6
	add	a1, a1, a6
	add	a0, a0, a4
.LBB0_7:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lhu	a4, 2(a1!)
	p.lhu	a5, 2(a2!)
	and	a4, a4, a5
	p.sh	a4, 2(a3!)
	bne	a3, a0, .LBB0_7
.LBB0_8:                                # %for.cond.cleanup
	ret
.Lfunc_end0:
	.size	and16, .Lfunc_end0-and16
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	min16                           # -- Begin function min16
	.p2align	1
	.type	min16,@function
min16:                                  # @min16
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
	mv	t2, a2
	mv	a4, a0
.LBB0_4:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	p.lw	t1, 4(t0!)
	p.lw	a5, 4(t2!)
	pv.min.h	a5, t1, a5
	p.sw	a5, 4(a4!)
	bne	a4, a7, .LBB0_4
# %bb.5:                                # %middle.block
	beq	a3, a6, .LBB0_8
.LBB0_6:                                # %for.body.preheader12
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
	p.min	a4, a4, a5
	p.sh	a4, 2(a3!)
	bne	a3, a0, .LBB0_7
.LBB0_8:                                # %for.cond.cleanup
	ret
.Lfunc_end0:
	.size	min16, .Lfunc_end0-min16
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	max8                            # -- Begin function max8
	.p2align	1
	.type	max8,@function
max8:                                   # @max8
# %bb.0:                                # %entry
	blez	a3, .LBB0_8
# %bb.1:                                # %for.body.preheader
	li	a4, 4
	bgeu	a3, a4, .LBB0_3
# %bb.2:
	li	a6, 0
	j	.LBB0_6
.LBB0_3:                                # %vector.ph
	lui	a4, 524288
	addi	a4, a4, -4
	and	a6, a3, a4
	add	a7, a6, a0
	mv	t0, a1
	mv	t2, a2
	mv	a4, a0
.LBB0_4:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	p.lw	t1, 4(t0!)
	p.lw	a5, 4(t2!)
	pv.max.b	a5, t1, a5
	p.sw	a5, 4(a4!)
	bne	a4, a7, .LBB0_4
# %bb.5:                                # %middle.block
	beq	a3, a6, .LBB0_8
.LBB0_6:                                # %for.body.preheader12
	add	a5, a0, a6
	add	a2, a2, a6
	add	a1, a1, a6
	add	a0, a0, a3
.LBB0_7:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lb	a3, 1(a1!)
	p.lb	a4, 1(a2!)
	p.max	a3, a3, a4
	p.sb	a3, 1(a5!)
	bne	a5, a0, .LBB0_7
.LBB0_8:                                # %for.cond.cleanup
	ret
.Lfunc_end0:
	.size	max8, .Lfunc_end0-max8
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	maxu8                           # -- Begin function maxu8
	.p2align	1
	.type	maxu8,@function
maxu8:                                  # @maxu8
# %bb.0:                                # %entry
	blez	a3, .LBB0_8
# %bb.1:                                # %for.body.preheader
	li	a4, 4
	bgeu	a3, a4, .LBB0_3
# %bb.2:
	li	a6, 0
	j	.LBB0_6
.LBB0_3:                                # %vector.ph
	lui	a4, 524288
	addi	a4, a4, -4
	and	a6, a3, a4
	add	a7, a6, a0
	mv	t0, a1
	mv	t2, a2
	mv	a4, a0
.LBB0_4:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	p.lw	t1, 4(t0!)
	p.lw	a5, 4(t2!)
	pv.maxu.b	a5, t1, a5
	p.sw	a5, 4(a4!)
	bne	a4, a7, .LBB0_4
# %bb.5:                                # %middle.block
	beq	a3, a6, .LBB0_8
.LBB0_6:                                # %for.body.preheader12
	add	a5, a0, a6
	add	a2, a2, a6
	add	a1, a1, a6
	add	a0, a0, a3
.LBB0_7:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lbu	a3, 1(a1!)
	p.lbu	a4, 1(a2!)
	p.maxu	a3, a3, a4
	p.sb	a3, 1(a5!)
	bne	a5, a0, .LBB0_7
.LBB0_8:                                # %for.cond.cleanup
	ret
.Lfunc_end0:
	.size	maxu8, .Lfunc_end0-maxu8
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	abs16                           # -- Begin function abs16
	.p2align	1
	.type	abs16,@function
abs16:                                  # @abs16
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
	p.lw	a4, 4(a5!)
	pv.abs.h	a4, a4
	p.sw	a4, 4(a3!)
	bne	a3, a7, .LBB0_4
# %bb.5:                                # %middle.block
	beq	a2, a6, .LBB0_8
.LBB0_6:                                # %for.body.preheader10
	slli	a6, a6, 1
	slli	a3, a2, 1
	add	a2, a0, a6
	add	a1, a1, a6
	add	a0, a0, a3
.LBB0_7:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lh	a3, 2(a1!)
	p.abs	a3, a3
	p.sh	a3, 2(a2!)
	bne	a2, a0, .LBB0_7
.LBB0_8:                                # %for.cond.cleanup
	ret
.Lfunc_end0:
	.size	abs16, .Lfunc_end0-abs16
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	shr16                           # -- Begin function shr16
	.p2align	1
	.type	shr16,@function
shr16:                                  # @shr16
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
	slli	a7, a6, 1
	add	a7, a7, a0
	pv.add.sci.h	t0, zero, 3
	mv	a3, a1
	mv	a4, a0
.LBB0_4:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	p.lw	a5, 4(a3!)
	pv.sra.h	a5, a5, t0
	p.sw	a5, 4(a4!)
	bne	a4, a7, .LBB0_4
# %bb.5:                                # %middle.block
	beq	a2, a6, .LBB0_8
.LBB0_6:                                # %for.body.preheader6
	slli	a6, a6, 1
	slli	a3, a2, 1
	add	a2, a0, a6
	add	a1, a1, a6
	add	a0, a0, a3
.LBB0_7:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lh	a3, 2(a1!)
	srli	a3, a3, 3
	p.sh	a3, 2(a2!)
	bne	a2, a0, .LBB0_7
.LBB0_8:                                # %for.cond.cleanup
	ret
.Lfunc_end0:
	.size	shr16, .Lfunc_end0-shr16
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	shl8                            # -- Begin function shl8
	.p2align	1
	.type	shl8,@function
shl8:                                   # @shl8
# %bb.0:                                # %entry
	blez	a2, .LBB0_8
# %bb.1:                                # %for.body.preheader
	li	a3, 4
	bgeu	a2, a3, .LBB0_3
# %bb.2:
	li	a6, 0
	j	.LBB0_6
.LBB0_3:                                # %vector.ph
	lui	a3, 524288
	addi	a3, a3, -4
	and	a6, a2, a3
	add	a7, a6, a0
	pv.add.sci.b	t0, zero, 2
	mv	a3, a1
	mv	a4, a0
.LBB0_4:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	p.lw	a5, 4(a3!)
	pv.sll.b	a5, a5, t0
	p.sw	a5, 4(a4!)
	bne	a4, a7, .LBB0_4
# %bb.5:                                # %middle.block
	beq	a2, a6, .LBB0_8
.LBB0_6:                                # %for.body.preheader6
	add	a4, a0, a6
	add	a1, a1, a6
	add	a0, a0, a2
.LBB0_7:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lbu	a2, 1(a1!)
	slli	a2, a2, 2
	p.sb	a2, 1(a4!)
	bne	a4, a0, .LBB0_7
.LBB0_8:                                # %for.cond.cleanup
	ret
.Lfunc_end0:
	.size	shl8, .Lfunc_end0-shl8
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	shrv16                          # -- Begin function shrv16
	.p2align	1
	.type	shrv16,@function
shrv16:                                 # @shrv16
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
	mv	t2, a1
	mv	a5, a0
.LBB0_4:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	p.lw	t0, 4(t2!)
	pv.extract.h	t1, t0, 1
	pv.extract.h	a4, t0, 0
	sra	t0, a4, a2
	sra	a4, t1, a2
	pv.pack.h	a4, a4, t0
	p.sw	a4, 4(a5!)
	bne	a5, a7, .LBB0_4
# %bb.5:                                # %middle.block
	beq	a3, a6, .LBB0_8
.LBB0_6:                                # %for.body.preheader6
	slli	a6, a6, 1
	slli	a4, a3, 1
	add	a3, a0, a6
	add	a1, a1, a6
	add	a0, a0, a4
.LBB0_7:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lh	a4, 2(a1!)
	sra	a4, a4, a2
	p.sh	a4, 2(a3!)
	bne	a3, a0, .LBB0_7
.LBB0_8:                                # %for.cond.cleanup
	ret
.Lfunc_end0:
	.size	shrv16, .Lfunc_end0-shrv16
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	addc16                          # -- Begin function addc16
	.p2align	1
	.type	addc16,@function
addc16:                                 # @addc16
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
	slli	a7, a6, 1
	add	a7, a7, a0
	pv.add.sci.h	t0, zero, 5
	mv	a3, a1
	mv	a4, a0
.LBB0_4:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	p.lw	a5, 4(a3!)
	pv.add.h	a5, a5, t0
	p.sw	a5, 4(a4!)
	bne	a4, a7, .LBB0_4
# %bb.5:                                # %middle.block
	beq	a2, a6, .LBB0_8
.LBB0_6:                                # %for.body.preheader6
	slli	a6, a6, 1
	slli	a3, a2, 1
	add	a2, a0, a6
	add	a1, a1, a6
	add	a0, a0, a3
.LBB0_7:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lhu	a3, 2(a1!)
	addi	a3, a3, 5
	p.sh	a3, 2(a2!)
	bne	a2, a0, .LBB0_7
.LBB0_8:                                # %for.cond.cleanup
	ret
.Lfunc_end0:
	.size	addc16, .Lfunc_end0-addc16
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	adds16                          # -- Begin function adds16
	.p2align	1
	.type	adds16,@function
adds16:                                 # @adds16
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
	pv.add.sc.h	a7, zero, a2
	slli	t0, a6, 1
	add	t0, t0, a0
	mv	t1, a1
	mv	a4, a0
.LBB0_4:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	p.lw	a5, 4(t1!)
	pv.add.h	a5, a5, a7
	p.sw	a5, 4(a4!)
	bne	a4, t0, .LBB0_4
# %bb.5:                                # %middle.block
	beq	a3, a6, .LBB0_8
.LBB0_6:                                # %for.body.preheader6
	slli	a6, a6, 1
	slli	a4, a3, 1
	add	a3, a0, a6
	add	a1, a1, a6
	add	a0, a0, a4
.LBB0_7:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lhu	a4, 2(a1!)
	add	a4, a4, a2
	p.sh	a4, 2(a3!)
	bne	a3, a0, .LBB0_7
.LBB0_8:                                # %for.cond.cleanup
	ret
.Lfunc_end0:
	.size	adds16, .Lfunc_end0-adds16
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	scale16                         # -- Begin function scale16
	.p2align	1
	.type	scale16,@function
scale16:                                # @scale16
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
	p.lw	a4, 4(a5!)
	pv.extract.h	t0, a4, 0
	pv.extract.h	t1, a4, 1
	slli	a4, t0, 1
	add	t0, t0, a4
	slli	a4, t1, 1
	add	a4, a4, t1
	pv.pack.h	a4, a4, t0
	p.sw	a4, 4(a3!)
	bne	a3, a7, .LBB0_4
# %bb.5:                                # %middle.block
	beq	a2, a6, .LBB0_8
.LBB0_6:                                # %for.body.preheader6
	slli	a6, a6, 1
	slli	a3, a2, 1
	add	a2, a0, a6
	add	a1, a1, a6
	add	a0, a0, a3
.LBB0_7:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lhu	a3, 2(a1!)
	slli	a4, a3, 1
	add	a3, a3, a4
	p.sh	a3, 2(a2!)
	bne	a2, a0, .LBB0_7
.LBB0_8:                                # %for.cond.cleanup
	ret
.Lfunc_end0:
	.size	scale16, .Lfunc_end0-scale16
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	scaleq15                        # -- Begin function scaleq15
	.p2align	1
	.type	scaleq15,@function
scaleq15:                               # @scaleq15
# %bb.0:                                # %entry
	blez	a3, .LBB0_8
# %bb.1:                                # %for.body.lr.ph
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
	mv	t2, a1
	mv	a5, a0
.LBB0_4:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	p.lw	t0, 4(t2!)
	pv.extract.h	t1, t0, 0
	pv.extract.h	a4, t0, 1
	mul	t0, a2, a4
	mul	a4, a2, t1
	srli	t1, a4, 15
	srli	a4, t0, 15
	pv.pack.h	a4, a4, t1
	p.sw	a4, 4(a5!)
	bne	a5, a7, .LBB0_4
# %bb.5:                                # %middle.block
	beq	a3, a6, .LBB0_8
.LBB0_6:                                # %for.body.preheader
	slli	a6, a6, 1
	slli	a4, a3, 1
	add	a3, a0, a6
	add	a1, a1, a6
	add	a0, a0, a4
.LBB0_7:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lh	a4, 2(a1!)
	mul	a4, a4, a2
	srli	a4, a4, 15
	p.sh	a4, 2(a3!)
	bne	a3, a0, .LBB0_7
.LBB0_8:                                # %for.cond.cleanup
	ret
.Lfunc_end0:
	.size	scaleq15, .Lfunc_end0-scaleq15
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	mul16                           # -- Begin function mul16
	.p2align	1
	.type	mul16,@function
mul16:                                  # @mul16
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
	pv.extract.h	t4, t2, 0
	pv.extract.h	t1, t1, 1
	pv.extract.h	t2, t2, 1
	mul	t3, t4, t3
	mul	a5, t2, t1
	pv.pack.h	a5, a5, t3
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
	p.lhu	a4, 2(a1!)
	p.lhu	a5, 2(a2!)
	mul	a4, a5, a4
	p.sh	a4, 2(a3!)
	bne	a3, a0, .LBB0_7
.LBB0_8:                                # %for.cond.cleanup
	ret
.Lfunc_end0:
	.size	mul16, .Lfunc_end0-mul16
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	copy16                          # -- Begin function copy16
	.p2align	1
	.type	copy16,@function
copy16:                                 # @copy16
# %bb.0:                                # %entry
	blez	a2, .LBB0_2
# %bb.1:                                # %for.body.preheader
	slli	a2, a2, 1
	tail	memcpy
.LBB0_2:                                # %for.cond.cleanup
	ret
.Lfunc_end0:
	.size	copy16, .Lfunc_end0-copy16
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	set16                           # -- Begin function set16
	.p2align	1
	.type	set16,@function
set16:                                  # @set16
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
	pv.add.sc.h	a4, zero, a1
	slli	a5, a6, 1
	add	a5, a5, a0
	mv	a3, a0
.LBB0_4:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	p.sw	a4, 4(a3!)
	bne	a3, a5, .LBB0_4
# %bb.5:                                # %middle.block
	beq	a2, a6, .LBB0_8
.LBB0_6:                                # %for.body.preheader5
	slli	a6, a6, 1
	slli	a3, a2, 1
	add	a2, a0, a6
	add	a0, a0, a3
.LBB0_7:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.sh	a1, 2(a2!)
	bne	a2, a0, .LBB0_7
.LBB0_8:                                # %for.cond.cleanup
	ret
.Lfunc_end0:
	.size	set16, .Lfunc_end0-set16
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	avg8                            # -- Begin function avg8
	.p2align	1
	.type	avg8,@function
avg8:                                   # @avg8
# %bb.0:                                # %entry
	blez	a3, .LBB0_8
# %bb.1:                                # %for.body.preheader
	li	a4, 4
	bgeu	a3, a4, .LBB0_3
# %bb.2:
	li	a6, 0
	j	.LBB0_6
.LBB0_3:                                # %vector.ph
	lui	a4, 524288
	addi	a4, a4, -4
	and	a6, a3, a4
	add	a7, a6, a0
	pv.add.sci.b	t0, zero, 1
	mv	t1, a1
	mv	t5, a2
	mv	a5, a0
.LBB0_4:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	p.lw	t2, 4(t1!)
	p.lw	t3, 4(t5!)
	pv.or.b	t4, t2, t3
	pv.xor.b	a4, t2, t3
	pv.srl.b	a4, a4, t0
	pv.sub.b	a4, t4, a4
	p.sw	a4, 4(a5!)
	bne	a5, a7, .LBB0_4
# %bb.5:                                # %middle.block
	beq	a3, a6, .LBB0_8
.LBB0_6:                                # %for.body.preheader8
	add	a5, a0, a6
	add	a2, a2, a6
	add	a1, a1, a6
	add	a0, a0, a3
	li	a6, 1
.LBB0_7:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lbu	a4, 1(a1!)
	p.lbu	a3, 1(a2!)
	add	a3, a3, a4
	p.addun	a3, a3, a6, 1
	p.sb	a3, 1(a5!)
	bne	a5, a0, .LBB0_7
.LBB0_8:                                # %for.cond.cleanup
	ret
.Lfunc_end0:
	.size	avg8, .Lfunc_end0-avg8
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	sat16                           # -- Begin function sat16
	.p2align	1
	.type	sat16,@function
sat16:                                  # @sat16
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
	pv.extract.h	t4, t2, 0
	pv.extract.h	t2, t2, 1
	pv.extract.h	t1, t1, 1
	add	t3, t3, t4
	add	t1, t1, t2
	p.clip	t2, t3, 16
	p.clip	a5, t1, 16
	pv.pack.h	a5, a5, t2
	p.sw	a5, 4(a4!)
	bne	a4, a7, .LBB0_4
# %bb.5:                                # %middle.block
	beq	a3, a6, .LBB0_8
.LBB0_6:                                # %for.body.preheader11
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
	add	a4, a4, a5
	p.clip	a4, a4, 16
	p.sh	a4, 2(a3!)
	bne	a3, a0, .LBB0_7
.LBB0_8:                                # %for.cond.cleanup
	ret
.Lfunc_end0:
	.size	sat16, .Lfunc_end0-sat16
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	clip16                          # -- Begin function clip16
	.p2align	1
	.type	clip16,@function
clip16:                                 # @clip16
# %bb.0:                                # %entry
	blez	a2, .LBB0_8
# %bb.1:                                # %for.body.preheader
	p.bneimm	a2, 1, .LBB0_3
# %bb.2:
	li	a6, 0
	j	.LBB0_6
.LBB0_3:                                # %vector.ph
	lui	a3, 524288
	li	a4, 255
	li	a5, -256
	addi	a3, a3, -2
	pv.add.sc.h	a7, zero, a4
	and	a6, a2, a3
	slli	t0, a6, 1
	add	t0, t0, a0
	pv.add.sc.h	t1, zero, a5
	mv	a4, a1
	mv	a5, a0
.LBB0_4:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	p.lw	a3, 4(a4!)
	pv.min.h	a3, a3, a7
	pv.max.h	a3, a3, t1
	p.sw	a3, 4(a5!)
	bne	a5, t0, .LBB0_4
# %bb.5:                                # %middle.block
	beq	a2, a6, .LBB0_8
.LBB0_6:                                # %for.body.preheader9
	slli	a6, a6, 1
	slli	a3, a2, 1
	add	a2, a0, a6
	add	a1, a1, a6
	add	a0, a0, a3
.LBB0_7:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lh	a3, 2(a1!)
	p.clip	a3, a3, 9
	p.sh	a3, 2(a2!)
	bne	a2, a0, .LBB0_7
.LBB0_8:                                # %for.cond.cleanup
	ret
.Lfunc_end0:
	.size	clip16, .Lfunc_end0-clip16
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	relu8                           # -- Begin function relu8
	.p2align	1
	.type	relu8,@function
relu8:                                  # @relu8
# %bb.0:                                # %entry
	blez	a2, .LBB0_8
# %bb.1:                                # %for.body.preheader
	li	a3, 4
	bgeu	a2, a3, .LBB0_3
# %bb.2:
	li	a6, 0
	j	.LBB0_6
.LBB0_3:                                # %vector.ph
	lui	a3, 524288
	addi	a3, a3, -4
	and	a6, a2, a3
	add	a7, a6, a0
	pv.add.sci.b	t0, zero, 0
	mv	a3, a1
	mv	a4, a0
.LBB0_4:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	p.lw	a5, 4(a3!)
	pv.max.b	a5, a5, t0
	p.sw	a5, 4(a4!)
	bne	a4, a7, .LBB0_4
# %bb.5:                                # %middle.block
	beq	a2, a6, .LBB0_8
.LBB0_6:                                # %for.body.preheader8
	add	a4, a0, a6
	add	a1, a1, a6
	add	a0, a0, a2
.LBB0_7:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lb	a2, 1(a1!)
	p.max	a2, a2, zero
	p.sb	a2, 1(a4!)
	bne	a4, a0, .LBB0_7
.LBB0_8:                                # %for.cond.cleanup
	ret
.Lfunc_end0:
	.size	relu8, .Lfunc_end0-relu8
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	sel16                           # -- Begin function sel16
	.p2align	1
	.type	sel16,@function
sel16:                                  # @sel16
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
	mv	t4, a2
	mv	a4, a0
.LBB0_4:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	p.lw	t1, 4(t0!)
	p.lw	t2, 4(t4!)
	pv.cmpgt.h	t3, t1, t2
	pv.sub.h	a5, t1, t2
	pv.and.h	a5, a5, t3
	p.sw	a5, 4(a4!)
	bne	a4, a7, .LBB0_4
# %bb.5:                                # %middle.block
	beq	a3, a6, .LBB0_8
.LBB0_6:                                # %for.body.preheader12
	slli	a6, a6, 1
	slli	a4, a3, 1
	add	a3, a0, a6
	add	a2, a2, a6
	add	a1, a1, a6
	add	a6, a0, a4
.LBB0_7:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lh	a4, 2(a1!)
	p.lh	a5, 2(a2!)
	slt	a0, a5, a4
	sub	a4, a4, a5
	neg	a0, a0
	and	a0, a0, a4
	p.sh	a0, 2(a3!)
	bne	a3, a6, .LBB0_7
.LBB0_8:                                # %for.cond.cleanup
	ret
.Lfunc_end0:
	.size	sel16, .Lfunc_end0-sel16
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	dot16                           # -- Begin function dot16
	.p2align	1
	.type	dot16,@function
dot16:                                  # @dot16
# %bb.0:                                # %entry
	blez	a2, .LBB0_4
# %bb.1:                                # %for.body.preheader
	slli	a2, a2, 1
	add	a3, a1, a2
	sub	a2, a3, a1
	srli	a4, a2, 1
	li	a2, 0
	.p2align	2
# %bb.6:                                # %for.body.preheader
	lp.setup	x0, a4, .LBB0_5
.LBB0_2:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	p.lh	a4, 2(a0!)
	p.lh	a5, 2(a1!)
.LBB0_5:                                #   in Loop: Header=BB0_2 Depth=1
                                        # Label of block must be emitted
	p.mac	a2, a5, a4
# %bb.3:                                # %for.cond.cleanup
	mv	a0, a2
	ret
.LBB0_4:
	li	a0, 0
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	dot16, .Lfunc_end0-dot16
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	dot8                            # -- Begin function dot8
	.p2align	1
	.type	dot8,@function
dot8:                                   # @dot8
# %bb.0:                                # %entry
	blez	a2, .LBB0_4
# %bb.1:                                # %for.body.preheader
	add	a3, a1, a2
	sub	a4, a3, a1
	li	a2, 0
	.p2align	2
# %bb.6:                                # %for.body.preheader
	lp.setup	x0, a4, .LBB0_5
.LBB0_2:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	p.lb	a4, 1(a0!)
	p.lb	a5, 1(a1!)
.LBB0_5:                                #   in Loop: Header=BB0_2 Depth=1
                                        # Label of block must be emitted
	p.mac	a2, a5, a4
# %bb.3:                                # %for.cond.cleanup
	mv	a0, a2
	ret
.LBB0_4:
	li	a0, 0
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	dot8, .Lfunc_end0-dot8
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	dotu8                           # -- Begin function dotu8
	.p2align	1
	.type	dotu8,@function
dotu8:                                  # @dotu8
# %bb.0:                                # %entry
	blez	a2, .LBB0_4
# %bb.1:                                # %for.body.preheader
	add	a3, a1, a2
	sub	a4, a3, a1
	li	a2, 0
	.p2align	2
# %bb.6:                                # %for.body.preheader
	lp.setup	x0, a4, .LBB0_5
.LBB0_2:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	p.lbu	a4, 1(a0!)
	p.lbu	a5, 1(a1!)
.LBB0_5:                                #   in Loop: Header=BB0_2 Depth=1
                                        # Label of block must be emitted
	p.mac	a2, a5, a4
# %bb.3:                                # %for.cond.cleanup
	mv	a0, a2
	ret
.LBB0_4:
	li	a0, 0
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	dotu8, .Lfunc_end0-dotu8
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	sum16                           # -- Begin function sum16
	.p2align	1
	.type	sum16,@function
sum16:                                  # @sum16
# %bb.0:                                # %entry
	blez	a1, .LBB0_4
# %bb.1:                                # %for.body.preheader
	slli	a1, a1, 1
	add	a2, a0, a1
	sub	a1, a2, a0
	srli	a3, a1, 1
	li	a1, 0
	.p2align	2
# %bb.6:                                # %for.body.preheader
	lp.setup	x0, a3, .LBB0_5
.LBB0_2:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	p.lh	a3, 2(a0!)
.LBB0_5:                                #   in Loop: Header=BB0_2 Depth=1
                                        # Label of block must be emitted
	add	a1, a1, a3
# %bb.3:                                # %for.cond.cleanup
	mv	a0, a1
	ret
.LBB0_4:
	li	a0, 0
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	sum16, .Lfunc_end0-sum16
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	sum8                            # -- Begin function sum8
	.p2align	1
	.type	sum8,@function
sum8:                                   # @sum8
# %bb.0:                                # %entry
	blez	a1, .LBB0_4
# %bb.1:                                # %for.body.preheader
	add	a2, a0, a1
	sub	a3, a2, a0
	li	a1, 0
	.p2align	2
# %bb.6:                                # %for.body.preheader
	lp.setup	x0, a3, .LBB0_5
.LBB0_2:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	p.lb	a3, 1(a0!)
.LBB0_5:                                #   in Loop: Header=BB0_2 Depth=1
                                        # Label of block must be emitted
	add	a1, a1, a3
# %bb.3:                                # %for.cond.cleanup
	mv	a0, a1
	ret
.LBB0_4:
	li	a0, 0
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	sum8, .Lfunc_end0-sum8
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	max16r                          # -- Begin function max16r
	.p2align	1
	.type	max16r,@function
max16r:                                 # @max16r
# %bb.0:                                # %entry
	blez	a1, .LBB0_4
# %bb.1:                                # %for.body.preheader
	slli	a1, a1, 1
	add	a2, a0, a1
	sub	a1, a2, a0
	srli	a3, a1, 1
	lui	a1, 1048568
	.p2align	2
# %bb.6:                                # %for.body.preheader
	lp.setup	x0, a3, .LBB0_5
.LBB0_2:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	p.lh	a3, 2(a0!)
.LBB0_5:                                #   in Loop: Header=BB0_2 Depth=1
                                        # Label of block must be emitted
	p.max	a1, a1, a3
# %bb.3:                                # %for.cond.cleanup
	mv	a0, a1
	ret
.LBB0_4:
	lui	a0, 1048568
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	max16r, .Lfunc_end0-max16r
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	max16rn                         # -- Begin function max16rn
	.p2align	1
	.type	max16rn,@function
max16rn:                                # @max16rn
# %bb.0:                                # %entry
	blez	a1, .LBB0_3
# %bb.1:                                # %for.body.preheader
	p.bneimm	a1, 1, .LBB0_4
# %bb.2:
	li	a7, 0
	lui	a2, 8
	j	.LBB0_7
.LBB0_3:
	lui	a2, 8
	p.exths	a0, a2
	ret
.LBB0_4:                                # %vector.ph
	lui	a2, 524288
	addi	a2, a2, -2
	and	a7, a1, a2
	slli	a2, a7, 1
	add	a2, a2, a0
	lui	a4, 1048568
	sub	a5, a2, a0
	srli	a6, a5, 2
	pv.add.sc.h	a4, zero, a4
	mv	a5, a0
	.p2align	2
# %bb.12:                               # %vector.ph
	lp.setup	x0, a6, .LBB0_10
.LBB0_5:                                # Block address taken
                                        # %vector.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	p.lw	a3, 4(a5!)
.LBB0_10:                               #   in Loop: Header=BB0_5 Depth=1
                                        # Label of block must be emitted
	pv.max.h	a4, a3, a4
# %bb.6:                                # %middle.block
	pv.extract.h	a2, a4, 1
	pv.extract.h	a3, a4, 0
	p.max	a2, a3, a2
	beq	a1, a7, .LBB0_9
.LBB0_7:                                # %for.body.preheader9
	slli	a7, a7, 1
	slli	a3, a1, 1
	add	a1, a0, a7
	add	a0, a0, a3
	sub	a3, a0, a1
	srli	a3, a3, 1
	.p2align	2
# %bb.13:                               # %for.body.preheader9
	lp.setup	x0, a3, .LBB0_11
.LBB0_8:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	p.lh	a3, 2(a1!)
	p.exths	a2, a2
.LBB0_11:                               #   in Loop: Header=BB0_8 Depth=1
                                        # Label of block must be emitted
	p.max	a2, a3, a2
.LBB0_9:                                # %for.cond.cleanup
	p.exths	a0, a2
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Ltmp1:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	max16rn, .Lfunc_end0-max16rn
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	sad8                            # -- Begin function sad8
	.p2align	1
	.type	sad8,@function
sad8:                                   # @sad8
# %bb.0:                                # %entry
	blez	a2, .LBB0_4
# %bb.1:                                # %for.body.preheader
	add	a6, a1, a2
	sub	a4, a6, a1
	li	a2, 0
	.p2align	2
# %bb.6:                                # %for.body.preheader
	lp.setup	x0, a4, .LBB0_5
.LBB0_2:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	p.lbu	a4, 1(a0!)
	p.lbu	a5, 1(a1!)
	p.minu	a3, a4, a5
	p.maxu	a4, a4, a5
	sub	a4, a4, a3
.LBB0_5:                                #   in Loop: Header=BB0_2 Depth=1
                                        # Label of block must be emitted
	add	a2, a2, a4
# %bb.3:                                # %for.cond.cleanup
	mv	a0, a2
	ret
.LBB0_4:
	li	a0, 0
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	sad8, .Lfunc_end0-sad8
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	add16_k64                       # -- Begin function add16_k64
	.p2align	1
	.type	add16_k64,@function
add16_k64:                              # @add16_k64
# %bb.0:                                # %entry
	addi	sp, sp, -96
	sw	ra, 92(sp)                      # 4-byte Folded Spill
	sw	s0, 88(sp)                      # 4-byte Folded Spill
	sw	s1, 84(sp)                      # 4-byte Folded Spill
	sw	s2, 80(sp)                      # 4-byte Folded Spill
	sw	s3, 76(sp)                      # 4-byte Folded Spill
	sw	s4, 72(sp)                      # 4-byte Folded Spill
	sw	s5, 68(sp)                      # 4-byte Folded Spill
	sw	s6, 64(sp)                      # 4-byte Folded Spill
	sw	s7, 60(sp)                      # 4-byte Folded Spill
	sw	s8, 56(sp)                      # 4-byte Folded Spill
	sw	s9, 52(sp)                      # 4-byte Folded Spill
	sw	s10, 48(sp)                     # 4-byte Folded Spill
	sw	s11, 44(sp)                     # 4-byte Folded Spill
	lw	a3, 0(a1)
	lw	a4, 4(a1)
	lw	t0, 8(a1)
	lw	a5, 12(a1)
	lw	s5, 0(a2)
	lw	s6, 4(a2)
	lw	s8, 8(a2)
	lw	t2, 12(a2)
	lw	t3, 16(a1)
	lw	t4, 20(a1)
	lw	t6, 24(a1)
	lw	t5, 28(a1)
	lw	s9, 16(a2)
	lw	s10, 20(a2)
	lw	s2, 24(a2)
	lw	s3, 28(a2)
	lw	s4, 32(a1)
	lw	ra, 36(a1)
	lw	a7, 40(a1)
	lw	s7, 44(a1)
	lw	t1, 32(a2)
	lw	s0, 36(a2)
	lw	s1, 40(a2)
	lw	s11, 44(a2)
	pv.add.h	a3, s5, a3
	sw	a3, 40(sp)                      # 4-byte Folded Spill
	pv.add.h	a3, s6, a4
	sw	a3, 36(sp)                      # 4-byte Folded Spill
	pv.add.h	a3, s8, t0
	sw	a3, 32(sp)                      # 4-byte Folded Spill
	lw	s5, 48(a1)
	lw	s8, 52(a1)
	lw	a6, 56(a1)
	lw	s6, 60(a1)
	pv.add.h	a3, t2, a5
	sw	a3, 28(sp)                      # 4-byte Folded Spill
	pv.add.h	a3, s9, t3
	sw	a3, 24(sp)                      # 4-byte Folded Spill
	pv.add.h	a3, s10, t4
	sw	a3, 20(sp)                      # 4-byte Folded Spill
	pv.add.h	a3, s2, t6
	sw	a3, 16(sp)                      # 4-byte Folded Spill
	lw	s9, 48(a2)
	lw	s10, 52(a2)
	lw	a3, 56(a2)
	lw	a4, 60(a2)
	pv.add.h	a5, s3, t5
	sw	a5, 12(sp)                      # 4-byte Folded Spill
	pv.add.h	s2, t1, s4
	pv.add.h	s3, s0, ra
	pv.add.h	a5, s1, a7
	sw	a5, 8(sp)                       # 4-byte Folded Spill
	lw	a5, 64(a1)
	lw	s1, 68(a1)
	lw	s0, 72(a1)
	lw	a7, 76(a1)
	pv.add.h	s4, s11, s7
	pv.add.h	ra, s9, s5
	pv.add.h	s7, s10, s8
	pv.add.h	s5, a3, a6
	lw	a3, 64(a2)
	lw	a6, 68(a2)
	lw	s11, 72(a2)
	lw	s8, 76(a2)
	pv.add.h	s10, a4, s6
	pv.add.h	s6, a3, a5
	pv.add.h	s9, a6, s1
	pv.add.h	s11, s11, s0
	lw	a6, 80(a1)
	lw	a4, 84(a1)
	lw	a5, 88(a1)
	lw	s0, 92(a1)
	pv.add.h	t6, s8, a7
	lw	s1, 80(a2)
	lw	a7, 84(a2)
	lw	s8, 88(a2)
	lw	a3, 92(a2)
	pv.add.h	s1, s1, a6
	pv.add.h	t4, a7, a4
	pv.add.h	t5, s8, a5
	pv.add.h	s8, a3, s0
	lw	t1, 96(a1)
	lw	t0, 100(a1)
	lw	a7, 104(a1)
	lw	s0, 108(a1)
	lw	a3, 96(a2)
	lw	a4, 100(a2)
	lw	a5, 104(a2)
	lw	a6, 108(a2)
	pv.add.h	t1, a3, t1
	pv.add.h	t0, a4, t0
	pv.add.h	t3, a5, a7
	pv.add.h	t2, a6, s0
	lw	a7, 112(a1)
	lw	a6, 116(a1)
	lw	a5, 120(a1)
	lw	a4, 124(a1)
	lw	s0, 112(a2)
	lw	a1, 116(a2)
	lw	a3, 120(a2)
	lw	a2, 124(a2)
	pv.add.h	s0, s0, a7
	pv.add.h	a1, a1, a6
	pv.add.h	a3, a3, a5
	pv.add.h	a2, a2, a4
	lw	a4, 40(sp)                      # 4-byte Folded Reload
	sw	a4, 0(a0)
	lw	a4, 36(sp)                      # 4-byte Folded Reload
	sw	a4, 4(a0)
	lw	a4, 32(sp)                      # 4-byte Folded Reload
	sw	a4, 8(a0)
	lw	a4, 28(sp)                      # 4-byte Folded Reload
	sw	a4, 12(a0)
	lw	a4, 24(sp)                      # 4-byte Folded Reload
	sw	a4, 16(a0)
	lw	a4, 20(sp)                      # 4-byte Folded Reload
	sw	a4, 20(a0)
	lw	a4, 16(sp)                      # 4-byte Folded Reload
	sw	a4, 24(a0)
	lw	a4, 12(sp)                      # 4-byte Folded Reload
	sw	a4, 28(a0)
	sw	s2, 32(a0)
	sw	s3, 36(a0)
	lw	a4, 8(sp)                       # 4-byte Folded Reload
	sw	a4, 40(a0)
	sw	s4, 44(a0)
	sw	ra, 48(a0)
	sw	s7, 52(a0)
	sw	s5, 56(a0)
	sw	s10, 60(a0)
	sw	s6, 64(a0)
	sw	s9, 68(a0)
	sw	s11, 72(a0)
	sw	t6, 76(a0)
	sw	s1, 80(a0)
	sw	t4, 84(a0)
	sw	t5, 88(a0)
	sw	s8, 92(a0)
	sw	t1, 96(a0)
	sw	t0, 100(a0)
	sw	t3, 104(a0)
	sw	t2, 108(a0)
	sw	s0, 112(a0)
	sw	a1, 116(a0)
	sw	a3, 120(a0)
	sw	a2, 124(a0)
	lw	ra, 92(sp)                      # 4-byte Folded Reload
	lw	s0, 88(sp)                      # 4-byte Folded Reload
	lw	s1, 84(sp)                      # 4-byte Folded Reload
	lw	s2, 80(sp)                      # 4-byte Folded Reload
	lw	s3, 76(sp)                      # 4-byte Folded Reload
	lw	s4, 72(sp)                      # 4-byte Folded Reload
	lw	s5, 68(sp)                      # 4-byte Folded Reload
	lw	s6, 64(sp)                      # 4-byte Folded Reload
	lw	s7, 60(sp)                      # 4-byte Folded Reload
	lw	s8, 56(sp)                      # 4-byte Folded Reload
	lw	s9, 52(sp)                      # 4-byte Folded Reload
	lw	s10, 48(sp)                     # 4-byte Folded Reload
	lw	s11, 44(sp)                     # 4-byte Folded Reload
	addi	sp, sp, 96
	ret
.Lfunc_end0:
	.size	add16_k64, .Lfunc_end0-add16_k64
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	add16_k63                       # -- Begin function add16_k63
	.p2align	1
	.type	add16_k63,@function
add16_k63:                              # @add16_k63
# %bb.0:                                # %entry
	addi	sp, sp, -96
	sw	ra, 92(sp)                      # 4-byte Folded Spill
	sw	s0, 88(sp)                      # 4-byte Folded Spill
	sw	s1, 84(sp)                      # 4-byte Folded Spill
	sw	s2, 80(sp)                      # 4-byte Folded Spill
	sw	s3, 76(sp)                      # 4-byte Folded Spill
	sw	s4, 72(sp)                      # 4-byte Folded Spill
	sw	s5, 68(sp)                      # 4-byte Folded Spill
	sw	s6, 64(sp)                      # 4-byte Folded Spill
	sw	s7, 60(sp)                      # 4-byte Folded Spill
	sw	s8, 56(sp)                      # 4-byte Folded Spill
	sw	s9, 52(sp)                      # 4-byte Folded Spill
	sw	s10, 48(sp)                     # 4-byte Folded Spill
	sw	s11, 44(sp)                     # 4-byte Folded Spill
	lw	a3, 0(a1)
	lw	a4, 4(a1)
	lw	t0, 8(a1)
	lw	a5, 12(a1)
	lw	s5, 0(a2)
	lw	s6, 4(a2)
	lw	s8, 8(a2)
	lw	t2, 12(a2)
	lw	t3, 16(a1)
	lw	t4, 20(a1)
	lw	t6, 24(a1)
	lw	t5, 28(a1)
	lw	s9, 16(a2)
	lw	s10, 20(a2)
	lw	s2, 24(a2)
	lw	s3, 28(a2)
	lw	s4, 32(a1)
	lw	ra, 36(a1)
	lw	a7, 40(a1)
	lw	s7, 44(a1)
	lw	t1, 32(a2)
	lw	s0, 36(a2)
	lw	s1, 40(a2)
	lw	s11, 44(a2)
	pv.add.h	a3, s5, a3
	sw	a3, 40(sp)                      # 4-byte Folded Spill
	pv.add.h	a3, s6, a4
	sw	a3, 36(sp)                      # 4-byte Folded Spill
	pv.add.h	a3, s8, t0
	sw	a3, 32(sp)                      # 4-byte Folded Spill
	lw	s5, 48(a1)
	lw	s8, 52(a1)
	lw	a6, 56(a1)
	lw	s6, 60(a1)
	pv.add.h	a3, t2, a5
	sw	a3, 28(sp)                      # 4-byte Folded Spill
	pv.add.h	a3, s9, t3
	sw	a3, 24(sp)                      # 4-byte Folded Spill
	pv.add.h	a3, s10, t4
	sw	a3, 20(sp)                      # 4-byte Folded Spill
	pv.add.h	a3, s2, t6
	sw	a3, 16(sp)                      # 4-byte Folded Spill
	lw	s9, 48(a2)
	lw	s10, 52(a2)
	lw	a3, 56(a2)
	lw	a4, 60(a2)
	pv.add.h	a5, s3, t5
	sw	a5, 12(sp)                      # 4-byte Folded Spill
	pv.add.h	s2, t1, s4
	pv.add.h	s3, s0, ra
	pv.add.h	a5, s1, a7
	sw	a5, 8(sp)                       # 4-byte Folded Spill
	lw	a5, 64(a1)
	lw	s1, 68(a1)
	lw	s0, 72(a1)
	lw	a7, 76(a1)
	pv.add.h	s4, s11, s7
	pv.add.h	ra, s9, s5
	pv.add.h	s7, s10, s8
	pv.add.h	s5, a3, a6
	lw	a3, 64(a2)
	lw	a6, 68(a2)
	lw	s11, 72(a2)
	lw	s8, 76(a2)
	pv.add.h	s10, a4, s6
	pv.add.h	s6, a3, a5
	pv.add.h	s9, a6, s1
	pv.add.h	s11, s11, s0
	lw	a6, 80(a1)
	lw	a4, 84(a1)
	lw	a5, 88(a1)
	lw	s0, 92(a1)
	pv.add.h	t6, s8, a7
	lw	s1, 80(a2)
	lw	a7, 84(a2)
	lw	s8, 88(a2)
	lw	a3, 92(a2)
	pv.add.h	s1, s1, a6
	pv.add.h	t4, a7, a4
	pv.add.h	t5, s8, a5
	pv.add.h	s8, a3, s0
	lw	t1, 96(a1)
	lw	t0, 100(a1)
	lw	a7, 104(a1)
	lw	s0, 108(a1)
	lw	a3, 96(a2)
	lw	a4, 100(a2)
	lw	a5, 104(a2)
	lw	a6, 108(a2)
	pv.add.h	t1, a3, t1
	pv.add.h	t0, a4, t0
	pv.add.h	t3, a5, a7
	pv.add.h	t2, a6, s0
	lw	a7, 112(a1)
	lw	a6, 116(a1)
	lw	a5, 120(a1)
	lh	a4, 124(a1)
	lw	s0, 112(a2)
	lw	a1, 116(a2)
	lw	a3, 120(a2)
	lh	a2, 124(a2)
	pv.add.h	s0, s0, a7
	pv.add.h	a1, a1, a6
	pv.add.h	a3, a3, a5
	add	a2, a2, a4
	lw	a4, 40(sp)                      # 4-byte Folded Reload
	sw	a4, 0(a0)
	lw	a4, 36(sp)                      # 4-byte Folded Reload
	sw	a4, 4(a0)
	lw	a4, 32(sp)                      # 4-byte Folded Reload
	sw	a4, 8(a0)
	lw	a4, 28(sp)                      # 4-byte Folded Reload
	sw	a4, 12(a0)
	lw	a4, 24(sp)                      # 4-byte Folded Reload
	sw	a4, 16(a0)
	lw	a4, 20(sp)                      # 4-byte Folded Reload
	sw	a4, 20(a0)
	lw	a4, 16(sp)                      # 4-byte Folded Reload
	sw	a4, 24(a0)
	lw	a4, 12(sp)                      # 4-byte Folded Reload
	sw	a4, 28(a0)
	sw	s2, 32(a0)
	sw	s3, 36(a0)
	lw	a4, 8(sp)                       # 4-byte Folded Reload
	sw	a4, 40(a0)
	sw	s4, 44(a0)
	sw	ra, 48(a0)
	sw	s7, 52(a0)
	sw	s5, 56(a0)
	sw	s10, 60(a0)
	sw	s6, 64(a0)
	sw	s9, 68(a0)
	sw	s11, 72(a0)
	sw	t6, 76(a0)
	sw	s1, 80(a0)
	sw	t4, 84(a0)
	sw	t5, 88(a0)
	sw	s8, 92(a0)
	sw	t1, 96(a0)
	sw	t0, 100(a0)
	sw	t3, 104(a0)
	sw	t2, 108(a0)
	sw	s0, 112(a0)
	sw	a1, 116(a0)
	sw	a3, 120(a0)
	sh	a2, 124(a0)
	lw	ra, 92(sp)                      # 4-byte Folded Reload
	lw	s0, 88(sp)                      # 4-byte Folded Reload
	lw	s1, 84(sp)                      # 4-byte Folded Reload
	lw	s2, 80(sp)                      # 4-byte Folded Reload
	lw	s3, 76(sp)                      # 4-byte Folded Reload
	lw	s4, 72(sp)                      # 4-byte Folded Reload
	lw	s5, 68(sp)                      # 4-byte Folded Reload
	lw	s6, 64(sp)                      # 4-byte Folded Reload
	lw	s7, 60(sp)                      # 4-byte Folded Reload
	lw	s8, 56(sp)                      # 4-byte Folded Reload
	lw	s9, 52(sp)                      # 4-byte Folded Reload
	lw	s10, 48(sp)                     # 4-byte Folded Reload
	lw	s11, 44(sp)                     # 4-byte Folded Reload
	addi	sp, sp, 96
	ret
.Lfunc_end0:
	.size	add16_k63, .Lfunc_end0-add16_k63
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	add8_k4                         # -- Begin function add8_k4
	.p2align	1
	.type	add8_k4,@function
add8_k4:                                # @add8_k4
# %bb.0:                                # %entry
	lw	a1, 0(a1)
	lw	a2, 0(a2)
	pv.add.b	a1, a2, a1
	sw	a1, 0(a0)
	ret
.Lfunc_end0:
	.size	add8_k4, .Lfunc_end0-add8_k4
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	add16_k2                        # -- Begin function add16_k2
	.p2align	1
	.type	add16_k2,@function
add16_k2:                               # @add16_k2
# %bb.0:                                # %entry
	lw	a1, 0(a1)
	lw	a2, 0(a2)
	pv.add.h	a1, a2, a1
	sw	a1, 0(a0)
	ret
.Lfunc_end0:
	.size	add16_k2, .Lfunc_end0-add16_k2
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	dot16_k64                       # -- Begin function dot16_k64
	.p2align	1
	.type	dot16_k64,@function
dot16_k64:                              # @dot16_k64
# %bb.0:                                # %entry
	addi	a3, a1, 128
	sub	a2, a3, a1
	srli	a4, a2, 1
	li	a2, 0
	.p2align	2
# %bb.4:                                # %entry
	lp.setup	x0, a4, .LBB0_3
.LBB0_1:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	p.lh	a4, 2(a0!)
	p.lh	a5, 2(a1!)
.LBB0_3:                                #   in Loop: Header=BB0_1 Depth=1
                                        # Label of block must be emitted
	p.mac	a2, a5, a4
# %bb.2:                                # %for.cond.cleanup
	mv	a0, a2
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	dot16_k64, .Lfunc_end0-dot16_k64
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	add16_glob                      # -- Begin function add16_glob
	.p2align	1
	.type	add16_glob,@function
add16_glob:                             # @add16_glob
# %bb.0:                                # %entry
	addi	sp, sp, -80
	sw	ra, 76(sp)                      # 4-byte Folded Spill
	sw	s0, 72(sp)                      # 4-byte Folded Spill
	sw	s1, 68(sp)                      # 4-byte Folded Spill
	sw	s2, 64(sp)                      # 4-byte Folded Spill
	sw	s3, 60(sp)                      # 4-byte Folded Spill
	sw	s4, 56(sp)                      # 4-byte Folded Spill
	sw	s5, 52(sp)                      # 4-byte Folded Spill
	sw	s6, 48(sp)                      # 4-byte Folded Spill
	sw	s7, 44(sp)                      # 4-byte Folded Spill
	sw	s8, 40(sp)                      # 4-byte Folded Spill
	sw	s9, 36(sp)                      # 4-byte Folded Spill
	sw	s10, 32(sp)                     # 4-byte Folded Spill
	sw	s11, 28(sp)                     # 4-byte Folded Spill
	lui	a0, %hi(GB)
	lui	a3, %hi(GC)
	addi	a2, a0, %lo(GB)
	lw	t0, %lo(GB)(a0)
	addi	a1, a3, %lo(GC)
	lw	t6, %lo(GC)(a3)
	lw	t2, 4(a2)
	lw	t1, 8(a2)
	lw	s4, 12(a2)
	lw	a0, 16(a2)
	sw	a0, 12(sp)                      # 4-byte Folded Spill
	lw	s10, 4(a1)
	lw	s11, 8(a1)
	lw	s1, 12(a1)
	lw	t3, 16(a1)
	lw	t4, 20(a2)
	lw	t5, 24(a2)
	lw	a6, 28(a2)
	lw	s2, 32(a2)
	lw	ra, 20(a1)
	lw	s7, 24(a1)
	lw	s8, 28(a1)
	lw	s5, 32(a1)
	lw	s6, 36(a2)
	lw	s3, 40(a2)
	lw	a3, 44(a2)
	lw	s9, 48(a2)
	pv.add.h	a4, t6, t0
	lw	a5, 36(a1)
	lw	s0, 40(a1)
	lw	t6, 44(a1)
	lw	a7, 48(a1)
	lui	a0, %hi(GA)
	sw	a4, %lo(GA)(a0)
	pv.add.h	a0, s10, t2
	sw	a0, 24(sp)                      # 4-byte Folded Spill
	pv.add.h	a0, s11, t1
	sw	a0, 20(sp)                      # 4-byte Folded Spill
	pv.add.h	a0, s1, s4
	sw	a0, 16(sp)                      # 4-byte Folded Spill
	lw	s10, 52(a2)
	lw	s11, 56(a2)
	lw	a4, 60(a2)
	lw	s1, 64(a2)
	lw	a0, 12(sp)                      # 4-byte Folded Reload
	pv.add.h	a0, t3, a0
	sw	a0, 12(sp)                      # 4-byte Folded Spill
	pv.add.h	a0, ra, t4
	sw	a0, 8(sp)                       # 4-byte Folded Spill
	pv.add.h	a0, s7, t5
	sw	a0, 4(sp)                       # 4-byte Folded Spill
	pv.add.h	a0, s8, a6
	sw	a0, 0(sp)                       # 4-byte Folded Spill
	lw	s7, 52(a1)
	lw	s8, 56(a1)
	lw	s4, 60(a1)
	lw	a6, 64(a1)
	pv.add.h	ra, s5, s2
	pv.add.h	s2, a5, s6
	pv.add.h	s3, s0, s3
	pv.add.h	t6, t6, a3
	lw	a5, 68(a2)
	lw	s0, 72(a2)
	lw	s5, 76(a2)
	lw	s6, 80(a2)
	pv.add.h	t5, a7, s9
	pv.add.h	s7, s7, s10
	pv.add.h	s8, s8, s11
	pv.add.h	s4, s4, a4
	lw	a4, 68(a1)
	lw	a3, 72(a1)
	lw	s10, 76(a1)
	lw	a0, 80(a1)
	pv.add.h	s11, a6, s1
	pv.add.h	t4, a4, a5
	pv.add.h	s9, a3, s0
	pv.add.h	s10, s10, s5
	lw	a6, 84(a2)
	lw	a4, 88(a2)
	lw	a5, 92(a2)
	lw	s0, 96(a2)
	pv.add.h	s5, a0, s6
	lw	a0, 84(a1)
	lw	s1, 88(a1)
	lw	a3, 92(a1)
	lw	s6, 96(a1)
	pv.add.h	t1, a0, a6
	pv.add.h	t2, s1, a4
	pv.add.h	t3, a3, a5
	pv.add.h	s6, s6, s0
	lw	a5, 100(a2)
	lw	s0, 104(a2)
	lw	s1, 108(a2)
	lw	a7, 112(a2)
	lw	a0, 100(a1)
	lw	a3, 104(a1)
	lw	a4, 108(a1)
	lw	a6, 112(a1)
	pv.add.h	t0, a0, a5
	pv.add.h	a3, a3, s0
	pv.add.h	a4, a4, s1
	lw	a5, 116(a2)
	lw	s0, 120(a2)
	lw	a2, 124(a2)
	lw	s1, 116(a1)
	lw	a0, 120(a1)
	lw	a1, 124(a1)
	pv.add.h	a6, a6, a7
	pv.add.h	a5, s1, a5
	pv.add.h	a0, a0, s0
	pv.add.h	a1, a1, a2
	lui	a2, %hi(GA)
	addi	a2, a2, %lo(GA)
	lw	s1, 24(sp)                      # 4-byte Folded Reload
	sw	s1, 4(a2)
	lw	s1, 20(sp)                      # 4-byte Folded Reload
	sw	s1, 8(a2)
	lw	s1, 16(sp)                      # 4-byte Folded Reload
	sw	s1, 12(a2)
	lw	s1, 12(sp)                      # 4-byte Folded Reload
	sw	s1, 16(a2)
	lw	s1, 8(sp)                       # 4-byte Folded Reload
	sw	s1, 20(a2)
	lw	s1, 4(sp)                       # 4-byte Folded Reload
	sw	s1, 24(a2)
	lw	s1, 0(sp)                       # 4-byte Folded Reload
	sw	s1, 28(a2)
	sw	ra, 32(a2)
	sw	s2, 36(a2)
	sw	s3, 40(a2)
	sw	t6, 44(a2)
	sw	t5, 48(a2)
	sw	s7, 52(a2)
	sw	s8, 56(a2)
	sw	s4, 60(a2)
	sw	s11, 64(a2)
	sw	t4, 68(a2)
	sw	s9, 72(a2)
	sw	s10, 76(a2)
	sw	s5, 80(a2)
	sw	t1, 84(a2)
	sw	t2, 88(a2)
	sw	t3, 92(a2)
	sw	s6, 96(a2)
	sw	t0, 100(a2)
	sw	a3, 104(a2)
	sw	a4, 108(a2)
	sw	a6, 112(a2)
	sw	a5, 116(a2)
	sw	a0, 120(a2)
	sw	a1, 124(a2)
	lw	ra, 76(sp)                      # 4-byte Folded Reload
	lw	s0, 72(sp)                      # 4-byte Folded Reload
	lw	s1, 68(sp)                      # 4-byte Folded Reload
	lw	s2, 64(sp)                      # 4-byte Folded Reload
	lw	s3, 60(sp)                      # 4-byte Folded Reload
	lw	s4, 56(sp)                      # 4-byte Folded Reload
	lw	s5, 52(sp)                      # 4-byte Folded Reload
	lw	s6, 48(sp)                      # 4-byte Folded Reload
	lw	s7, 44(sp)                      # 4-byte Folded Reload
	lw	s8, 40(sp)                      # 4-byte Folded Reload
	lw	s9, 36(sp)                      # 4-byte Folded Reload
	lw	s10, 32(sp)                     # 4-byte Folded Reload
	lw	s11, 28(sp)                     # 4-byte Folded Reload
	addi	sp, sp, 80
	ret
.Lfunc_end0:
	.size	add16_glob, .Lfunc_end0-add16_glob
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	add16_nr                        # -- Begin function add16_nr
	.p2align	1
	.type	add16_nr,@function
add16_nr:                               # @add16_nr
# %bb.0:                                # %entry
	blez	a3, .LBB0_5
# %bb.1:                                # %for.body.preheader
	li	a4, 10
	bgeu	a3, a4, .LBB0_6
# %bb.2:
	li	a6, 0
.LBB0_3:                                # %for.body.preheader12
	slli	a6, a6, 1
	slli	a4, a3, 1
	add	a3, a0, a6
	add	a2, a2, a6
	add	a1, a1, a6
	add	a0, a0, a4
.LBB0_4:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lhu	a4, 2(a1!)
	p.lhu	a5, 2(a2!)
	add	a4, a4, a5
	p.sh	a4, 2(a3!)
	bne	a3, a0, .LBB0_4
.LBB0_5:                                # %for.cond.cleanup
	ret
.LBB0_6:                                # %vector.memcheck
	sub	a5, a0, a1
	li	a4, 4
	li	a6, 0
	bltu	a5, a4, .LBB0_3
# %bb.7:                                # %vector.memcheck
	sub	a5, a0, a2
	bltu	a5, a4, .LBB0_3
# %bb.8:                                # %vector.ph
	lui	a4, 524288
	addi	a4, a4, -2
	and	a6, a3, a4
	slli	a7, a6, 1
	add	a7, a7, a0
	mv	t0, a1
	mv	t2, a2
	mv	a4, a0
.LBB0_9:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	p.lw	t1, 4(t0!)
	p.lw	a5, 4(t2!)
	pv.add.h	a5, a5, t1
	p.sw	a5, 4(a4!)
	bne	a4, a7, .LBB0_9
# %bb.10:                               # %middle.block
	bne	a3, a6, .LBB0_3
	j	.LBB0_5
.Lfunc_end0:
	.size	add16_nr, .Lfunc_end0-add16_nr
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	add8_nr                         # -- Begin function add8_nr
	.p2align	1
	.type	add8_nr,@function
add8_nr:                                # @add8_nr
# %bb.0:                                # %entry
	blez	a3, .LBB0_5
# %bb.1:                                # %for.body.preheader
	li	a4, 12
	bgeu	a3, a4, .LBB0_6
# %bb.2:
	li	a6, 0
.LBB0_3:                                # %for.body.preheader12
	add	a5, a0, a6
	add	a2, a2, a6
	add	a1, a1, a6
	add	a0, a0, a3
.LBB0_4:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lbu	a3, 1(a1!)
	p.lbu	a4, 1(a2!)
	add	a3, a3, a4
	p.sb	a3, 1(a5!)
	bne	a5, a0, .LBB0_4
.LBB0_5:                                # %for.cond.cleanup
	ret
.LBB0_6:                                # %vector.memcheck
	sub	a5, a0, a1
	li	a4, 4
	li	a6, 0
	bltu	a5, a4, .LBB0_3
# %bb.7:                                # %vector.memcheck
	sub	a5, a0, a2
	bltu	a5, a4, .LBB0_3
# %bb.8:                                # %vector.ph
	lui	a4, 524288
	addi	a4, a4, -4
	and	a6, a3, a4
	add	a7, a6, a0
	mv	t0, a1
	mv	t2, a2
	mv	a4, a0
.LBB0_9:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	p.lw	t1, 4(t0!)
	p.lw	a5, 4(t2!)
	pv.add.b	a5, a5, t1
	p.sw	a5, 4(a4!)
	bne	a4, a7, .LBB0_9
# %bb.10:                               # %middle.block
	bne	a3, a6, .LBB0_3
	j	.LBB0_5
.Lfunc_end0:
	.size	add8_nr, .Lfunc_end0-add8_nr
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	inplace16                       # -- Begin function inplace16
	.p2align	1
	.type	inplace16,@function
inplace16:                              # @inplace16
# %bb.0:                                # %entry
	blez	a2, .LBB0_7
# %bb.1:                                # %for.body.preheader
	li	a3, 10
	slli	a6, a2, 1
	bltu	a2, a3, .LBB0_4
# %bb.2:                                # %vector.memcheck
	add	a3, a1, a6
	bgeu	a0, a3, .LBB0_8
# %bb.3:                                # %vector.memcheck
	add	a3, a0, a6
	bgeu	a1, a3, .LBB0_8
.LBB0_4:
	li	a7, 0
.LBB0_5:                                # %for.body.preheader8
	slli	a7, a7, 1
	add	a2, a0, a7
	add	a1, a1, a7
	add	a0, a0, a6
.LBB0_6:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lhu	a3, 2(a1!)
	lh	a4, 0(a2)
	add	a3, a3, a4
	p.sh	a3, 2(a2!)
	bne	a2, a0, .LBB0_6
.LBB0_7:                                # %for.cond.cleanup
	ret
.LBB0_8:                                # %vector.ph
	lui	a3, 524288
	addi	a3, a3, -2
	and	a7, a2, a3
	slli	a5, a7, 1
	add	t0, a5, a0
	mv	a3, a1
	mv	a4, a0
.LBB0_9:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	p.lw	t1, 4(a3!)
	lw	a5, 0(a4)
	pv.add.h	a5, a5, t1
	p.sw	a5, 4(a4!)
	bne	a4, t0, .LBB0_9
# %bb.10:                               # %middle.block
	beq	a2, a7, .LBB0_7
	j	.LBB0_5
.Lfunc_end0:
	.size	inplace16, .Lfunc_end0-inplace16
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	slp_add16                       # -- Begin function slp_add16
	.p2align	1
	.type	slp_add16,@function
slp_add16:                              # @slp_add16
# %bb.0:                                # %entry
	lw	a1, 0(a1)
	lw	a2, 0(a2)
	pv.add.h	a1, a2, a1
	sw	a1, 0(a0)
	ret
.Lfunc_end0:
	.size	slp_add16, .Lfunc_end0-slp_add16
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	slp_add8                        # -- Begin function slp_add8
	.p2align	1
	.type	slp_add8,@function
slp_add8:                               # @slp_add8
# %bb.0:                                # %entry
	lw	a1, 0(a1)
	lw	a2, 0(a2)
	pv.add.b	a1, a2, a1
	sw	a1, 0(a0)
	ret
.Lfunc_end0:
	.size	slp_add8, .Lfunc_end0-slp_add8
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	slp_px                          # -- Begin function slp_px
	.p2align	1
	.type	slp_px,@function
slp_px:                                 # @slp_px
# %bb.0:                                # %entry
	lw	a1, 0(a1)
	lw	a2, 0(a2)
	pv.add.b	a1, a2, a1
	sw	a1, 0(a0)
	ret
.Lfunc_end0:
	.size	slp_px, .Lfunc_end0-slp_px
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops2.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	add32                           # -- Begin function add32
	.p2align	1
	.type	add32,@function
add32:                                  # @add32
# %bb.0:                                # %entry
	blez	a3, .LBB0_3
# %bb.1:                                # %for.body.preheader
	slli	a3, a3, 2
	add	a3, a3, a0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lw	a4, 4(a1!)
	p.lw	a5, 4(a2!)
	add	a4, a4, a5
	p.sw	a4, 4(a0!)
	bne	a0, a3, .LBB0_2
.LBB0_3:                                # %for.cond.cleanup
	ret
.Lfunc_end0:
	.size	add32, .Lfunc_end0-add32
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
