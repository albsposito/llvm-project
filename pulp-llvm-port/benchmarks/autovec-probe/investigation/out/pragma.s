	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"pragma.c"
	.text
	.globl	add16_pragma                    # -- Begin function add16_pragma
	.p2align	1
	.type	add16_pragma,@function
add16_pragma:                           # @add16_pragma
# %bb.0:                                # %entry
	blez	a3, .LBB0_3
# %bb.1:                                # %for.body.preheader
	slli	a3, a3, 1
	add	a3, a3, a0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lhu	a4, 2(a1!)
	p.lhu	a5, 2(a2!)
	add	a4, a4, a5
	p.sh	a4, 2(a0!)
	bne	a0, a3, .LBB0_2
.LBB0_3:                                # %for.cond.cleanup
	ret
.Lfunc_end0:
	.size	add16_pragma, .Lfunc_end0-add16_pragma
                                        # -- End function
	.globl	add8_pragma                     # -- Begin function add8_pragma
	.p2align	1
	.type	add8_pragma,@function
add8_pragma:                            # @add8_pragma
# %bb.0:                                # %entry
	blez	a3, .LBB1_3
# %bb.1:                                # %for.body.preheader
	add	a3, a3, a0
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	p.lbu	a4, 1(a1!)
	p.lbu	a5, 1(a2!)
	add	a4, a4, a5
	p.sb	a4, 1(a0!)
	bne	a0, a3, .LBB1_2
.LBB1_3:                                # %for.cond.cleanup
	ret
.Lfunc_end1:
	.size	add8_pragma, .Lfunc_end1-add8_pragma
                                        # -- End function
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
