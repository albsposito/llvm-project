	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xpulpv2p0"
	.file	"clang_probe.c"
	.text
	.globl	h_add                           # -- Begin function h_add
	.p2align	1
	.type	h_add,@function
h_add:                                  # @h_add
# %bb.0:                                # %entry
	fadd.h	a0, a0, a1
	ret
.Lfunc_end0:
	.size	h_add, .Lfunc_end0-h_add
                                        # -- End function
	.globl	h_expr                          # -- Begin function h_expr
	.p2align	1
	.type	h_expr,@function
h_expr:                                 # @h_expr
# %bb.0:                                # %entry
	fadd.h	a1, a0, a1
	fmsub.h	a0, a1, a2, a0
	ret
.Lfunc_end1:
	.size	h_expr, .Lfunc_end1-h_expr
                                        # -- End function
	.globl	h_fma                           # -- Begin function h_fma
	.p2align	1
	.type	h_fma,@function
h_fma:                                  # @h_fma
# %bb.0:                                # %entry
	fmadd.h	a0, a0, a1, a2
	ret
.Lfunc_end2:
	.size	h_fma, .Lfunc_end2-h_fma
                                        # -- End function
	.globl	a_add                           # -- Begin function a_add
	.p2align	1
	.type	a_add,@function
a_add:                                  # @a_add
# %bb.0:                                # %entry
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
                                        # kill: def $x11_w killed $x11_w def $x11
                                        # kill: def $x10_w killed $x10_w def $x10
	slli	a1, a1, 16
	slli	a0, a0, 16
	fadd.s	a0, a0, a1
	call	__truncsfbf2
	lui	a1, 1048560
	or	a0, a0, a1
                                        # kill: def $x10_w killed $x10_w killed $x10
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
.Lfunc_end3:
	.size	a_add, .Lfunc_end3-a_add
                                        # -- End function
	.globl	a_expr                          # -- Begin function a_expr
	.p2align	1
	.type	a_expr,@function
a_expr:                                 # @a_expr
# %bb.0:                                # %entry
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
                                        # kill: def $x12_w killed $x12_w def $x12
                                        # kill: def $x11_w killed $x11_w def $x11
                                        # kill: def $x10_w killed $x10_w def $x10
	slli	a0, a0, 16
	slli	a1, a1, 16
	fadd.s	a1, a0, a1
	slli	a2, a2, 16
	fmsub.s	a0, a1, a2, a0
	call	__truncsfbf2
	lui	a1, 1048560
	or	a0, a0, a1
                                        # kill: def $x10_w killed $x10_w killed $x10
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
.Lfunc_end4:
	.size	a_expr, .Lfunc_end4-a_expr
                                        # -- End function
	.globl	a2i                             # -- Begin function a2i
	.p2align	1
	.type	a2i,@function
a2i:                                    # @a2i
# %bb.0:                                # %entry
                                        # kill: def $x10_w killed $x10_w def $x10
	slli	a0, a0, 16
	fcvt.w.s	a0, a0, rtz
	ret
.Lfunc_end5:
	.size	a2i, .Lfunc_end5-a2i
                                        # -- End function
	.globl	a2f                             # -- Begin function a2f
	.p2align	1
	.type	a2f,@function
a2f:                                    # @a2f
# %bb.0:                                # %entry
                                        # kill: def $x10_w killed $x10_w def $x10
	slli	a0, a0, 16
                                        # kill: def $x10_w killed $x10_w killed $x10
	ret
.Lfunc_end6:
	.size	a2f, .Lfunc_end6-a2f
                                        # -- End function
	.globl	f2a                             # -- Begin function f2a
	.p2align	1
	.type	f2a,@function
f2a:                                    # @f2a
# %bb.0:                                # %entry
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	call	__truncsfbf2
	lui	a1, 1048560
	or	a0, a0, a1
                                        # kill: def $x10_w killed $x10_w killed $x10
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
.Lfunc_end7:
	.size	f2a, .Lfunc_end7-f2a
                                        # -- End function
	.globl	vh_add                          # -- Begin function vh_add
	.p2align	1
	.type	vh_add,@function
vh_add:                                 # @vh_add
# %bb.0:                                # %entry
	srli	a2, a1, 16
	srli	a3, a0, 16
	fadd.h	a0, a0, a1
	p.exthz	a0, a0
	fadd.h	a1, a3, a2
	slli	a1, a1, 16
	or	a0, a0, a1
	ret
.Lfunc_end8:
	.size	vh_add, .Lfunc_end8-vh_add
                                        # -- End function
	.globl	va_add                          # -- Begin function va_add
	.p2align	1
	.type	va_add,@function
va_add:                                 # @va_add
# %bb.0:                                # %entry
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	sw	s1, 4(sp)                       # 4-byte Folded Spill
	sw	s2, 0(sp)                       # 4-byte Folded Spill
	mv	s0, a1
	mv	s1, a0
	lui	a0, 1048560
	and	a1, a1, a0
	and	a0, a0, s1
	fadd.s	a0, a0, a1
	call	__truncsfbf2
	slli	s2, a0, 16
	slli	s0, s0, 16
	slli	s1, s1, 16
	fadd.s	a0, s1, s0
	call	__truncsfbf2
	p.exthz	a0, a0
	or	a0, a0, s2
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	lw	s1, 4(sp)                       # 4-byte Folded Reload
	lw	s2, 0(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
.Lfunc_end9:
	.size	va_add, .Lfunc_end9-va_add
                                        # -- End function
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 7459255b6120075684cf3aef0b310567d60b5f80)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
