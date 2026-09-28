	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_xpulpv2p0"
	.file	"kern.c"
	.text
	.globl	kern                            # -- Begin function kern
	.p2align	1
	.type	kern,@function
kern:                                   # @kern
# %bb.0:                                # %entry
	li	a6, 2
	li	a2, 12
	mv	a4, a3
	beqz	a3, .LBB0_2
.LBB0_1:                                # %for.body14
                                        # =>This Inner Loop Header: Depth=1
	andi	a0, a2, 63
	slli	a0, a0, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	addi	a4, a4, -1
	add	a6, a6, a0
	addi	a2, a2, 1
	bnez	a4, .LBB0_1
.LBB0_2:                                # %for.cond.cleanup13
	li	a1, 383
	mul	a1, a3, a1
	li	a2, 79
	p.mac	a1, a5, a2
	addi	a1, a1, 3
	xor	a0, a6, a1
	xori	a0, a0, 1
	ret
.Lfunc_end0:
	.size	kern, .Lfunc_end0-kern
                                        # -- End function
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 7459255b6120075684cf3aef0b310567d60b5f80)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
