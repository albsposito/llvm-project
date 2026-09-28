	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_xpulpv2p0"
	.file	"kern.c"
	.text
	.globl	kern                            # -- Begin function kern
	.p2align	1
	.type	kern,@function
kern:                                   # @kern
# %bb.0:                                # %entry
	li	a7, 3
	mv	a6, a3
	beqz	a3, .LBB0_2
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	lbu	a5, 180(a0)
	andi	a5, a5, 7
	snez	a5, a5
	sll	a7, a7, a5
	addi	a6, a6, -1
	bnez	a6, .LBB0_1
.LBB0_2:                                # %for.cond4.preheader
	li	t0, 2
	li	a5, 9
	beqz	a4, .LBB0_4
.LBB0_3:                                # %for.body7
                                        # =>This Inner Loop Header: Depth=1
	andi	a0, a5, 63
	slli	a0, a0, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	addi	a4, a4, -1
	add	t0, t0, a0
	addi	a5, a5, 1
	bnez	a4, .LBB0_3
.LBB0_4:                                # %for.cond16.preheader
	xori	a6, a7, 29
	li	t1, 64
	li	a5, 63
	beqz	a3, .LBB0_6
.LBB0_5:                                # %for.body19
                                        # =>This Inner Loop Header: Depth=1
	andi	a0, t1, 63
	andi	a4, a5, 63
	add	t1, t1, a6
	slli	a0, a0, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	addi	a3, a3, -1
	slli	a4, a4, 2
	add	a4, a4, a2
	xor	a0, a0, t0
	sw	a0, 0(a4)
	addi	a5, a5, 1
	bnez	a3, .LBB0_5
.LBB0_6:                                # %for.cond.cleanup18
	xor	a0, t0, a7
	addi	a1, t1, -63
	xor	a0, a0, a1
	ret
.Lfunc_end0:
	.size	kern, .Lfunc_end0-kern
                                        # -- End function
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 7459255b6120075684cf3aef0b310567d60b5f80)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
