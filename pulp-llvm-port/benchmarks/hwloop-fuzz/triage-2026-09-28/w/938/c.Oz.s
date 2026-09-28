	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_xpulpv2p0"
	.file	"kern.c"
	.text
	.globl	kern                            # -- Begin function kern
	.p2align	1
	.type	kern,@function
kern:                                   # @kern
# %bb.0:                                # %entry
	li	a7, 0
	andi	a6, a4, 3
	li	a2, 3
	li	t0, 1
	p.beqimm	zero, 8, .LBB0_5
.LBB0_1:                                # %for.cond1.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
	addi	a3, t0, 41
	andi	a3, a3, 63
	slli	a3, a3, 2
	add	a5, a1, a3
	mv	a3, a6
	beqz	a6, .LBB0_3
.LBB0_2:                                # %for.body4
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	lw	a0, 0(a5)
	add	a2, a2, a0
	addi	a3, a3, -1
	bnez	a3, .LBB0_2
.LBB0_3:                                # %for.cond.cleanup3
                                        #   in Loop: Header=BB0_1 Depth=1
	addi	a3, t0, 30
	andi	a3, a3, 63
	slli	a3, a3, 2
	add	a3, a3, a1
	lw	a3, 0(a3)
	slli	a5, a3, 2
	add	a3, a3, a5
	xor	a3, a3, a2
	add	t0, t0, a3
	addi	a7, a7, 1
	p.beqimm	a7, 8, .LBB0_5
	j	.LBB0_1
.LBB0_4:                                # %for.body18
                                        #   in Loop: Header=BB0_5 Depth=1
	slli	a2, a2, 1
	addi	a4, a4, -1
.LBB0_5:                                # %for.cond15
                                        # =>This Inner Loop Header: Depth=1
	bnez	a4, .LBB0_4
# %bb.6:                                # %for.cond.cleanup17
	xor	a0, t0, a2
	xori	a0, a0, 2
	ret
.Lfunc_end0:
	.size	kern, .Lfunc_end0-kern
                                        # -- End function
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 7459255b6120075684cf3aef0b310567d60b5f80)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
