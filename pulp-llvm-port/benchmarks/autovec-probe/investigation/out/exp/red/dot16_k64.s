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
	srli	a4, a2, 2
	li	a2, 0
	.p2align	2
# %bb.4:                                # %entry
	lp.setup	x0, a4, .LBB0_3
.LBB0_1:                                # Block address taken
                                        # %vector.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	p.lw	a4, 4(a0!)
	p.lw	a5, 4(a1!)
.LBB0_3:                                #   in Loop: Header=BB0_1 Depth=1
                                        # Label of block must be emitted
	pv.sdotsp.h	a2, a5, a4
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
