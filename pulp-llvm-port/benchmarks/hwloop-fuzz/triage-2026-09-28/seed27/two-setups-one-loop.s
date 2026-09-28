	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_xpulpv2p0"
	.file	"two-setups-one-loop.c"
	.option	push
	.option	arch, +c, +m, +xpulpv, +zfinx, +zicsr, +zmmul
	.text
	.globl	kern                            # -- Begin function kern
	.p2align	1
	.type	kern,@function
kern:                                   # @kern
# %bb.0:                                # %entry
	addi	a4, a2, 1
	bnez	a4, .LBB0_2
# %bb.1:
	li	a0, 2
	li	a3, 3
	.p2align	2
# %bb.11:
	lp.setup	x0, a2, .LBB0_8
	j	.LBB0_6
.LBB0_2:                                # %for.body.preheader
	mul	a6, a3, a4
	li	a3, 3
	.p2align	2
# %bb.12:                               # %for.body.preheader
	lp.setup	x0, a4, .LBB0_9
.LBB0_3:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	andi	a5, a3, 63
	xori	a5, a5, 32
	slli	a5, a5, 2
	add	a5, a5, a0
	lw	a5, 0(a5)
.LBB0_9:                                #   in Loop: Header=BB0_3 Depth=1
                                        # Label of block must be emitted
	add	a3, a3, a5
# %bb.4:                                # %for.cond5.preheader
	addi	a0, a6, 2
	beqz	a2, .LBB0_7
# %bb.5:                                # %for.body8.preheader
	lp.setup	x0, a2, .LBB0_10
.LBB0_6:                                # Block address taken
                                        # %for.body8
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	addi	a4, a0, 53
	andi	a4, a4, 63
	slli	a4, a4, 2
	add	a4, a4, a1
	lw	a4, 0(a4)
.LBB0_10:                               #   in Loop: Header=BB0_6 Depth=1
                                        # Label of block must be emitted
	addi	a2, a2, -1
.LBB0_8:                                #   in Loop: Header=BB0_6 Depth=1
                                        # Label of block must be emitted
	add	a0, a0, a4
.LBB0_7:                                # %for.cond.cleanup7
	xor	a0, a0, a3
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Ltmp1:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	kern, .Lfunc_end0-kern
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 7459255b6120075684cf3aef0b310567d60b5f80)"
	.section	".note.GNU-stack","",@progbits
