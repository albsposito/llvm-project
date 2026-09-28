	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_xpulpv2p0"
	.file	"kern.c"
	.text
	.globl	kern                            # -- Begin function kern
	.p2align	1
	.type	kern,@function
kern:                                   # @kern
# %bb.0:                                # %entry
	andi	a6, a4, 3
	li	a0, 1
	li	a7, 3
	li	a5, 8
	lp.starti	x0, .LBB0_1
	lp.endi	x0, .LBB0_8
	lp.counti	x0, 8
.LBB0_1:                                # Block address taken
                                        # %for.cond1.preheader
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	beqz	a6, .LBB0_3
# %bb.2:                                # %for.cond.cleanup3.loopexit
                                        #   in Loop: Header=BB0_1 Depth=1
	addi	a3, a0, 41
	andi	a3, a3, 63
	slli	a3, a3, 2
	add	a3, a3, a1
	lw	a3, 0(a3)
	p.mac	a7, a6, a3
.LBB0_3:                                # Block address taken
                                        # %for.cond.cleanup3
                                        #   in Loop: Header=BB0_1 Depth=1
                                        # Label of block must be emitted
	addi	a3, a0, 30
	andi	a3, a3, 63
	slli	a3, a3, 2
	add	a3, a3, a1
	lw	a2, 0(a3)
	slli	a3, a2, 2
	add	a2, a2, a3
	xor	a2, a2, a7
.LBB0_8:                                #   in Loop: Header=BB0_1 Depth=1
                                        # Label of block must be emitted
	add	a0, a0, a2
# %bb.4:                                # %for.cond15.preheader
	beqz	a4, .LBB0_7
# %bb.5:
	lp.setup	x0, a4, .LBB0_9
.LBB0_10:
	nop
	nop
.LBB0_6:                                # Block address taken
                                        # %for.body18
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
.LBB0_9:                                #   in Loop: Header=BB0_6 Depth=1
                                        # Label of block must be emitted
	slli	a7, a7, 1
.LBB0_7:                                # %for.cond.cleanup17
	xor	a0, a0, a7
	xori	a0, a0, 2
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Ltmp1:                                 # Address of block that was removed by CodeGen
.Ltmp2:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	kern, .Lfunc_end0-kern
                                        # -- End function
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 7459255b6120075684cf3aef0b310567d60b5f80)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
