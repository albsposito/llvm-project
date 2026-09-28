	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xpulpv2p0"
	.file	"clang_abi.c"
	.text
	.globl	many                            # -- Begin function many
	.p2align	1
	.type	many,@function
many:                                   # @many
# %bb.0:                                # %entry
	lh	a1, 4(sp)
	lh	a2, 0(sp)
	fadd.h	a0, a0, a1
	fadd.h	a0, a2, a0
	ret
.Lfunc_end0:
	.size	many, .Lfunc_end0-many
                                        # -- End function
	.globl	call_h                          # -- Begin function call_h
	.p2align	1
	.type	call_h,@function
call_h:                                 # @call_h
# %bb.0:                                # %entry
                                        # kill: def $x11_w killed $x11_w def $x11
	lui	a2, 1048560
	or	a1, a1, a2
	li	a2, 3
                                        # kill: def $x11_w killed $x11_w killed $x11
	mv	a3, a0
	tail	ext_h
.Lfunc_end1:
	.size	call_h, .Lfunc_end1-call_h
                                        # -- End function
	.globl	call10                          # -- Begin function call10
	.p2align	1
	.type	call10,@function
call10:                                 # @call10
# %bb.0:                                # %entry
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	lui	a1, 4
	sh	a0, 0(sp)
	sh	a1, 4(sp)
	mv	a1, a0
	mv	a2, a0
	mv	a3, a0
	mv	a4, a0
	mv	a5, a0
	mv	a6, a0
	mv	a7, a0
	call	ext10
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
.Lfunc_end2:
	.size	call10, .Lfunc_end2-call10
                                        # -- End function
	.globl	manya                           # -- Begin function manya
	.p2align	1
	.type	manya,@function
manya:                                  # @manya
# %bb.0:                                # %entry
	lw	a0, 4(sp)
	lui	a1, 1048560
	or	a0, a0, a1
                                        # kill: def $x10_w killed $x10_w killed $x10
	ret
.Lfunc_end3:
	.size	manya, .Lfunc_end3-manya
                                        # -- End function
	.globl	vret                            # -- Begin function vret
	.p2align	1
	.type	vret,@function
vret:                                   # @vret
# %bb.0:                                # %entry
	mv	a0, a1
	ret
.Lfunc_end4:
	.size	vret, .Lfunc_end4-vret
                                        # -- End function
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 7459255b6120075684cf3aef0b310567d60b5f80)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
