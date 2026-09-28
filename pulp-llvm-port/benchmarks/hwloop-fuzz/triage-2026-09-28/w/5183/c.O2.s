	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_xpulpv2p0"
	.file	"kern.c"
	.text
	.globl	kern                            # -- Begin function kern
	.p2align	1
	.type	kern,@function
kern:                                   # @kern
# %bb.0:                                # %entry
	li	a0, 79
	mul	a0, a5, a0
	li	a2, 52
	p.mac	a0, a3, a2
	addi	a0, a0, 3
	beqz	a3, .LBB0_4
# %bb.1:                                # %for.body14.preheader
	li	a2, 331
	addi	a4, a3, 12
	li	a5, 12
	mul	a6, a3, a2
	sub	a3, a4, a5
	li	a2, 2
	.p2align	2
# %bb.7:                                # %for.body14.preheader
	lp.setup	x0, a3, .LBB0_6
.LBB0_2:                                # Block address taken
                                        # %for.body14
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	andi	a3, a5, 63
	slli	a3, a3, 2
	add	a3, a3, a1
	lw	a3, 0(a3)
	addi	a5, a5, 1
.LBB0_6:                                #   in Loop: Header=BB0_2 Depth=1
                                        # Label of block must be emitted
	add	a2, a2, a3
# %bb.3:                                # %for.cond.cleanup13.loopexit
	add	a0, a0, a6
	j	.LBB0_5
.LBB0_4:
	li	a2, 2
.LBB0_5:                                # %for.cond.cleanup13
	xor	a0, a0, a2
	xori	a0, a0, 1
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	kern, .Lfunc_end0-kern
                                        # -- End function
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 7459255b6120075684cf3aef0b310567d60b5f80)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
