	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_xpulpv2p0"
	.file	"kern.c"
	.text
	.globl	kern                            # -- Begin function kern
	.p2align	1
	.type	kern,@function
kern:                                   # @kern
# %bb.0:                                # %entry
	li	a7, 48
	li	a6, 23
	mv	a5, a4
	beqz	a4, .LBB0_2
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	andi	a1, a7, 63
	addi	a5, a5, -1
	slli	a1, a1, 2
	add	a1, a1, a2
	sw	a6, 0(a1)
	addi	a7, a7, 1
	bnez	a5, .LBB0_1
.LBB0_2:                                # %for.cond2.preheader
	addi	a2, a3, 1
	slli	a5, a3, 6
	li	a7, 1
	sub	a6, a5, a3
	li	a5, 55
	beqz	a2, .LBB0_6
.LBB0_3:                                # %for.body6
                                        # =>This Inner Loop Header: Depth=1
	lw	a3, 164(a0)
	lw	a1, 56(a0)
	add	a1, a1, a3
	andi	a1, a1, 8
	beqz	a1, .LBB0_5
# %bb.4:                                # %if.then
                                        #   in Loop: Header=BB0_3 Depth=1
	andi	a1, a5, 63
	slli	a1, a1, 2
	add	a1, a1, a0
	lw	a1, 0(a1)
	add	a7, a7, a1
.LBB0_5:                                # %for.inc20
                                        #   in Loop: Header=BB0_3 Depth=1
	addi	a2, a2, -1
	addi	a5, a5, 1
	bnez	a2, .LBB0_3
.LBB0_6:                                # %for.cond24.preheader
	addi	a0, a6, 65
	li	a2, 3
	srli	a3, a0, 31
	beqz	a4, .LBB0_8
.LBB0_7:                                # %for.body27
                                        # =>This Inner Loop Header: Depth=1
	slli	a2, a2, 1
	or	a2, a2, a3
	addi	a4, a4, -1
	bnez	a4, .LBB0_7
.LBB0_8:                                # %for.cond.cleanup26
	xor	a0, a0, a7
	xor	a0, a0, a2
	ret
.Lfunc_end0:
	.size	kern, .Lfunc_end0-kern
                                        # -- End function
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 7459255b6120075684cf3aef0b310567d60b5f80)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
