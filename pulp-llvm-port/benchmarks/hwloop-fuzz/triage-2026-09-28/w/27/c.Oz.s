	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_xpulpv2p0"
	.file	"kern.c"
	.text
	.globl	kern                            # -- Begin function kern
	.p2align	1
	.type	kern,@function
kern:                                   # @kern
# %bb.0:                                # %entry
	li	a6, 73
	mul	a6, a4, a6
	li	a7, 8
	beqz	a4, .LBB0_2
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	lw	t0, 212(a1)
	lw	t1, 252(a1)
	slli	t0, t0, 1
	add	t0, t0, t1
	slli	t1, t0, 3
	sub	t0, t1, t0
	andi	t1, a7, 63
	addi	a4, a4, -1
	slli	t1, t1, 2
	add	t1, t1, a2
	sw	t0, 0(t1)
	addi	a7, a7, 1
	bnez	a4, .LBB0_1
.LBB0_2:                                # %for.cond11.preheader
	addi	a2, a6, 3
	addi	a4, a3, 1
	mul	a6, a5, a4
	li	a5, 19
	mul	a6, a6, a5
	beqz	a4, .LBB0_4
.LBB0_3:                                # %for.body15
                                        # =>This Inner Loop Header: Depth=1
	andi	a5, a2, 63
	xori	a5, a5, 32
	slli	a5, a5, 2
	add	a5, a5, a0
	lw	a5, 0(a5)
	slli	a5, a5, 1
	xor	a5, a5, a2
	add	a2, a2, a5
	addi	a4, a4, -1
	bnez	a4, .LBB0_3
.LBB0_4:                                # %for.cond33.preheader
	addi	a5, a6, 2
	beqz	a3, .LBB0_6
.LBB0_5:                                # %for.body36
                                        # =>This Inner Loop Header: Depth=1
	addi	a0, a5, 53
	andi	a0, a0, 63
	slli	a0, a0, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	add	a5, a5, a0
	addi	a3, a3, -1
	bnez	a3, .LBB0_5
.LBB0_6:                                # %for.cond.cleanup35
	xor	a2, a2, a5
	xori	a0, a2, 1
	ret
.Lfunc_end0:
	.size	kern, .Lfunc_end0-kern
                                        # -- End function
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 7459255b6120075684cf3aef0b310567d60b5f80)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
