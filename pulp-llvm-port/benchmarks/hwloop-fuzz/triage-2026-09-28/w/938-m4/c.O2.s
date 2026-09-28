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
	beqz	a6, .LBB0_2
# %bb.1:                                # %for.body4.lr.ph.1
	lw	a0, 168(a1)
	lw	a3, 124(a1)
	mul	a0, a6, a0
	slli	a5, a3, 2
	addi	a0, a0, 3
	add	a3, a3, a5
	xor	a3, a3, a0
	addi	a5, a3, 42
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a1
	lw	a5, 0(a5)
	p.mac	a0, a6, a5
	j	.LBB0_3
.LBB0_2:                                # %for.cond.cleanup3.thread
	lw	a0, 124(a1)
	slli	a3, a0, 2
	add	a0, a0, a3
	xori	a3, a0, 3
	li	a0, 3
.LBB0_3:                                # %for.cond.cleanup3.1
	addi	a5, a3, 31
	andi	a5, a5, 63
	slli	a5, a5, 2
	add	a5, a5, a1
	lw	a2, 0(a5)
	slli	a5, a2, 2
	add	a2, a2, a5
	xor	a2, a2, a0
	add	a2, a2, a3
	addi	a3, a2, 1
	beqz	a6, .LBB0_5
# %bb.4:                                # %for.body4.lr.ph.2
	addi	a2, a3, 41
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a2, a2, a1
	lw	a2, 0(a2)
	p.mac	a0, a6, a2
.LBB0_5:                                # %for.cond.cleanup3.2
	addi	a2, a3, 30
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a2, a2, a1
	lw	a2, 0(a2)
	slli	a5, a2, 2
	add	a2, a2, a5
	xor	a2, a2, a0
	add	a3, a3, a2
	beqz	a6, .LBB0_7
# %bb.6:                                # %for.body4.lr.ph.3
	addi	a2, a3, 41
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a2, a2, a1
	lw	a2, 0(a2)
	p.mac	a0, a6, a2
.LBB0_7:                                # %for.cond.cleanup3.3
	addi	a2, a3, 30
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a2, a2, a1
	lw	a2, 0(a2)
	slli	a5, a2, 2
	add	a2, a2, a5
	xor	a2, a2, a0
	add	a3, a3, a2
	beqz	a6, .LBB0_9
# %bb.8:                                # %for.body4.lr.ph.4
	addi	a2, a3, 41
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a2, a2, a1
	lw	a2, 0(a2)
	p.mac	a0, a6, a2
.LBB0_9:                                # %for.cond.cleanup3.4
	addi	a2, a3, 30
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a2, a2, a1
	lw	a2, 0(a2)
	slli	a5, a2, 2
	add	a2, a2, a5
	xor	a2, a2, a0
	add	a3, a3, a2
	beqz	a6, .LBB0_11
# %bb.10:                               # %for.body4.lr.ph.5
	addi	a2, a3, 41
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a2, a2, a1
	lw	a2, 0(a2)
	p.mac	a0, a6, a2
.LBB0_11:                               # %for.cond.cleanup3.5
	addi	a2, a3, 30
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a2, a2, a1
	lw	a2, 0(a2)
	slli	a5, a2, 2
	add	a2, a2, a5
	xor	a2, a2, a0
	add	a3, a3, a2
	beqz	a6, .LBB0_13
# %bb.12:                               # %for.body4.lr.ph.6
	addi	a2, a3, 41
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a2, a2, a1
	lw	a2, 0(a2)
	p.mac	a0, a6, a2
.LBB0_13:                               # %for.cond.cleanup3.6
	addi	a2, a3, 30
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a2, a2, a1
	lw	a2, 0(a2)
	slli	a5, a2, 2
	add	a2, a2, a5
	xor	a2, a2, a0
	add	a3, a3, a2
	beqz	a6, .LBB0_15
# %bb.14:                               # %for.cond.cleanup3.7.thread
	addi	a2, a3, 41
	addi	a5, a3, 30
	andi	a2, a2, 63
	andi	a5, a5, 63
	slli	a2, a2, 2
	slli	a5, a5, 2
	add	a2, a2, a1
	add	a1, a1, a5
	lw	a2, 0(a2)
	lw	a1, 0(a1)
	p.mac	a0, a6, a2
	j	.LBB0_16
.LBB0_15:                               # %for.cond.cleanup3.7
	addi	a2, a3, 30
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	lw	a1, 0(a1)
	mv	a2, a0
	beqz	a4, .LBB0_18
.LBB0_16:                               # %for.body18.preheader
	mv	a2, a0
	.p2align	2
# %bb.21:                               # %for.body18.preheader
	lp.setup	x0, a4, .LBB0_19
.LBB0_20:
	nop
	nop
.LBB0_17:                               # Block address taken
                                        # %for.body18
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
.LBB0_19:                               #   in Loop: Header=BB0_17 Depth=1
                                        # Label of block must be emitted
	slli	a2, a2, 1
.LBB0_18:                               # %for.cond.cleanup17
	slli	a4, a1, 2
	add	a1, a1, a4
	xor	a0, a0, a1
	add	a0, a0, a3
	xor	a0, a0, a2
	xori	a0, a0, 2
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	kern, .Lfunc_end0-kern
                                        # -- End function
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 7459255b6120075684cf3aef0b310567d60b5f80)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
