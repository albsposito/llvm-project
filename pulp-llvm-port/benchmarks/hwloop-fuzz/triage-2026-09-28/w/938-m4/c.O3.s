	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_xpulpv2p0"
	.file	"kern.c"
	.text
	.globl	kern                            # -- Begin function kern
	.p2align	1
	.type	kern,@function
kern:                                   # @kern
# %bb.0:                                # %entry
	andi	a7, a4, 3
	beqz	a7, .LBB0_2
# %bb.1:                                # %for.cond15.preheader.thread
	lw	a0, 168(a1)
	lw	a3, 124(a1)
	mul	a0, a7, a0
	slli	a5, a3, 2
	addi	a0, a0, 3
	add	a3, a3, a5
	xor	a3, a3, a0
	addi	a6, a3, 42
	addi	a5, a3, 31
	andi	a2, a6, 63
	andi	a5, a5, 63
	slli	a2, a2, 2
	slli	a5, a5, 2
	add	a2, a2, a1
	add	a5, a5, a1
	lw	a2, 0(a2)
	lw	a5, 0(a5)
	p.mac	a0, a7, a2
	slli	a2, a5, 2
	add	a2, a2, a5
	xor	a2, a2, a0
	add	a2, a2, a3
	addi	a3, a2, 42
	addi	a5, a2, 31
	andi	a3, a3, 63
	andi	a5, a5, 63
	slli	a3, a3, 2
	slli	a5, a5, 2
	add	a3, a3, a1
	add	a5, a5, a1
	lw	a3, 0(a3)
	lw	a5, 0(a5)
	p.mac	a0, a7, a3
	slli	a3, a5, 2
	add	a3, a3, a5
	xor	a3, a3, a0
	add	a2, a2, a3
	addi	a3, a2, 42
	addi	a5, a2, 31
	andi	a3, a3, 63
	andi	a5, a5, 63
	slli	a3, a3, 2
	slli	a5, a5, 2
	add	a3, a3, a1
	add	a5, a5, a1
	lw	a3, 0(a3)
	lw	a5, 0(a5)
	addi	a2, a2, 1
	p.mac	a0, a7, a3
	slli	a3, a5, 2
	add	a3, a3, a5
	xor	a3, a3, a0
	add	a2, a2, a3
	addi	a3, a2, 41
	addi	a5, a2, 30
	andi	a3, a3, 63
	andi	a5, a5, 63
	slli	a3, a3, 2
	slli	a5, a5, 2
	add	a3, a3, a1
	add	a5, a5, a1
	lw	a3, 0(a3)
	lw	a5, 0(a5)
	p.mac	a0, a7, a3
	slli	a3, a5, 2
	add	a3, a3, a5
	xor	a3, a3, a0
	add	a2, a2, a3
	addi	a3, a2, 41
	addi	a5, a2, 30
	andi	a3, a3, 63
	andi	a5, a5, 63
	slli	a3, a3, 2
	slli	a5, a5, 2
	add	a3, a3, a1
	add	a5, a5, a1
	lw	a3, 0(a3)
	lw	a5, 0(a5)
	p.mac	a0, a7, a3
	slli	a3, a5, 2
	add	a3, a3, a5
	xor	a3, a3, a0
	add	a2, a2, a3
	addi	a3, a2, 41
	addi	a5, a2, 30
	andi	a3, a3, 63
	andi	a5, a5, 63
	slli	a3, a3, 2
	slli	a5, a5, 2
	add	a3, a3, a1
	add	a5, a5, a1
	lw	a3, 0(a3)
	lw	a5, 0(a5)
	p.mac	a0, a7, a3
	slli	a3, a5, 2
	add	a3, a3, a5
	xor	a3, a3, a0
	add	a2, a2, a3
	addi	a3, a2, 41
	addi	a5, a2, 30
	andi	a3, a3, 63
	andi	a5, a5, 63
	slli	a3, a3, 2
	slli	a5, a5, 2
	add	a3, a3, a1
	add	a1, a1, a5
	lw	a3, 0(a3)
	lw	a1, 0(a1)
	p.mac	a0, a7, a3
	slli	a3, a1, 2
	add	a1, a1, a3
	xor	a1, a1, a0
	add	a1, a1, a2
	.p2align	2
# %bb.9:                                # %for.cond15.preheader.thread
	lp.setup	x0, a4, .LBB0_6
	j	.LBB0_4
.LBB0_2:                                # %for.cond15.preheader
	lw	a0, 124(a1)
	slli	a2, a0, 2
	add	a0, a0, a2
	xori	a0, a0, 3
	addi	a2, a0, 31
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a2, a2, a1
	lw	a2, 0(a2)
	slli	a3, a2, 2
	add	a2, a2, a3
	xori	a2, a2, 3
	add	a0, a0, a2
	addi	a2, a0, 31
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a2, a2, a1
	lw	a2, 0(a2)
	slli	a3, a2, 2
	add	a2, a2, a3
	xori	a2, a2, 3
	add	a0, a0, a2
	addi	a2, a0, 31
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a2, a2, a1
	lw	a2, 0(a2)
	slli	a3, a2, 2
	add	a2, a2, a3
	xori	a2, a2, 3
	add	a0, a0, a2
	addi	a2, a0, 31
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a2, a2, a1
	lw	a2, 0(a2)
	addi	a0, a0, 1
	slli	a3, a2, 2
	add	a2, a2, a3
	xori	a2, a2, 3
	add	a0, a0, a2
	addi	a2, a0, 30
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a2, a2, a1
	lw	a2, 0(a2)
	slli	a3, a2, 2
	add	a2, a2, a3
	xori	a2, a2, 3
	add	a0, a0, a2
	addi	a2, a0, 30
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a2, a2, a1
	lw	a2, 0(a2)
	slli	a3, a2, 2
	add	a2, a2, a3
	xori	a2, a2, 3
	add	a0, a0, a2
	addi	a2, a0, 30
	andi	a2, a2, 63
	slli	a2, a2, 2
	add	a1, a1, a2
	lw	a1, 0(a1)
	slli	a2, a1, 2
	add	a1, a1, a2
	xori	a1, a1, 3
	add	a1, a1, a0
	li	a0, 3
	beqz	a4, .LBB0_5
# %bb.3:                                # %for.body18.preheader
	lp.setup	x0, a4, .LBB0_7
.LBB0_8:
	nop
	nop
.LBB0_4:                                # Block address taken
                                        # %for.body18
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
.LBB0_7:                                #   in Loop: Header=BB0_4 Depth=1
                                        # Label of block must be emitted
	addi	a4, a4, -1
.LBB0_6:                                #   in Loop: Header=BB0_4 Depth=1
                                        # Label of block must be emitted
	slli	a0, a0, 1
.LBB0_5:                                # %for.cond.cleanup17
	xor	a0, a0, a1
	xori	a0, a0, 2
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	kern, .Lfunc_end0-kern
                                        # -- End function
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 7459255b6120075684cf3aef0b310567d60b5f80)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
