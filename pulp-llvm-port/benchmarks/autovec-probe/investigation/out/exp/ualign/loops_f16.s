	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops_f16.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	win_f16                         # -- Begin function win_f16
	.p2align	1
	.type	win_f16,@function
win_f16:                                # @win_f16
# %bb.0:                                # %entry
	blez	a2, .LBB0_3
# %bb.1:                                # %for.body.preheader
	slli	a2, a2, 1
	add	a2, a2, a1
	sub	a3, a2, a1
	srli	a3, a3, 1
	.p2align	2
# %bb.5:                                # %for.body.preheader
	lp.setup	x0, a3, .LBB0_4
.LBB0_2:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	lh	a3, 0(a0)
	lh	a4, 0(a1)
	addi	a1, a1, 2
	fmul.h	a3, a3, a4
	sh	a3, 0(a0)
.LBB0_4:                                #   in Loop: Header=BB0_2 Depth=1
                                        # Label of block must be emitted
	addi	a0, a0, 2
.LBB0_3:                                # %for.cond.cleanup
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	win_f16, .Lfunc_end0-win_f16
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops_f16.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	win_f16_o                       # -- Begin function win_f16_o
	.p2align	1
	.type	win_f16_o,@function
win_f16_o:                              # @win_f16_o
# %bb.0:                                # %entry
	blez	a3, .LBB0_3
# %bb.1:                                # %for.body.preheader
	slli	a3, a3, 1
	add	a3, a3, a0
	sub	a4, a3, a0
	srli	a4, a4, 1
	.p2align	2
# %bb.5:                                # %for.body.preheader
	lp.setup	x0, a4, .LBB0_4
.LBB0_2:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	lh	a4, 0(a1)
	lh	a5, 0(a2)
	fmul.h	a4, a4, a5
	sh	a4, 0(a0)
	addi	a0, a0, 2
	addi	a2, a2, 2
.LBB0_4:                                #   in Loop: Header=BB0_2 Depth=1
                                        # Label of block must be emitted
	addi	a1, a1, 2
.LBB0_3:                                # %for.cond.cleanup
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	win_f16_o, .Lfunc_end0-win_f16_o
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops_f16.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	add_f16                         # -- Begin function add_f16
	.p2align	1
	.type	add_f16,@function
add_f16:                                # @add_f16
# %bb.0:                                # %entry
	blez	a3, .LBB0_3
# %bb.1:                                # %for.body.preheader
	slli	a3, a3, 1
	add	a3, a3, a0
	sub	a4, a3, a0
	srli	a4, a4, 1
	.p2align	2
# %bb.5:                                # %for.body.preheader
	lp.setup	x0, a4, .LBB0_4
.LBB0_2:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	lh	a4, 0(a1)
	lh	a5, 0(a2)
	fadd.h	a4, a4, a5
	sh	a4, 0(a0)
	addi	a0, a0, 2
	addi	a2, a2, 2
.LBB0_4:                                #   in Loop: Header=BB0_2 Depth=1
                                        # Label of block must be emitted
	addi	a1, a1, 2
.LBB0_3:                                # %for.cond.cleanup
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	add_f16, .Lfunc_end0-add_f16
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops_f16.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	axpy_f16                        # -- Begin function axpy_f16
	.p2align	1
	.type	axpy_f16,@function
axpy_f16:                               # @axpy_f16
# %bb.0:                                # %entry
	blez	a3, .LBB0_3
# %bb.1:                                # %for.body.preheader
	slli	a3, a3, 1
	add	a3, a3, a1
	sub	a4, a3, a1
	srli	a4, a4, 1
	.p2align	2
# %bb.5:                                # %for.body.preheader
	lp.setup	x0, a4, .LBB0_4
.LBB0_2:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	lh	a4, 0(a0)
	lh	a5, 0(a1)
	addi	a1, a1, 2
	fmadd.h	a4, a2, a5, a4
	sh	a4, 0(a0)
.LBB0_4:                                #   in Loop: Header=BB0_2 Depth=1
                                        # Label of block must be emitted
	addi	a0, a0, 2
.LBB0_3:                                # %for.cond.cleanup
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	axpy_f16, .Lfunc_end0-axpy_f16
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops_f16.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	scale_f16                       # -- Begin function scale_f16
	.p2align	1
	.type	scale_f16,@function
scale_f16:                              # @scale_f16
# %bb.0:                                # %entry
	blez	a3, .LBB0_3
# %bb.1:                                # %for.body.preheader
	slli	a3, a3, 1
	add	a3, a3, a0
	sub	a4, a3, a0
	srli	a4, a4, 1
	.p2align	2
# %bb.5:                                # %for.body.preheader
	lp.setup	x0, a4, .LBB0_4
.LBB0_2:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	lh	a4, 0(a1)
	fmul.h	a4, a2, a4
	sh	a4, 0(a0)
	addi	a0, a0, 2
.LBB0_4:                                #   in Loop: Header=BB0_2 Depth=1
                                        # Label of block must be emitted
	addi	a1, a1, 2
.LBB0_3:                                # %for.cond.cleanup
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	scale_f16, .Lfunc_end0-scale_f16
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops_f16.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	max_f16                         # -- Begin function max_f16
	.p2align	1
	.type	max_f16,@function
max_f16:                                # @max_f16
# %bb.0:                                # %entry
	blez	a3, .LBB0_5
# %bb.1:                                # %for.body.preheader
	slli	a3, a3, 1
	add	a6, a0, a3
	sub	a4, a6, a0
	srli	a4, a4, 1
	.p2align	2
# %bb.7:                                # %for.body.preheader
	lp.setup	x0, a4, .LBB0_6
.LBB0_3:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	lh	a4, 0(a1)
	lh	a5, 0(a2)
	flt.h	a3, a5, a4
	bnez	a3, .LBB0_2
# %bb.4:                                # %for.body
                                        #   in Loop: Header=BB0_3 Depth=1
	mv	a4, a5
.LBB0_2:                                # Block address taken
                                        # %for.body
                                        #   in Loop: Header=BB0_3 Depth=1
                                        # Label of block must be emitted
	sh	a4, 0(a0)
	addi	a0, a0, 2
	addi	a2, a2, 2
.LBB0_6:                                #   in Loop: Header=BB0_3 Depth=1
                                        # Label of block must be emitted
	addi	a1, a1, 2
	j	.LBB0_5
.LBB0_5:                                # %for.cond.cleanup
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	max_f16, .Lfunc_end0-max_f16
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops_f16.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	magsq_f16                       # -- Begin function magsq_f16
	.p2align	1
	.type	magsq_f16,@function
magsq_f16:                              # @magsq_f16
# %bb.0:                                # %entry
	blez	a2, .LBB0_3
# %bb.1:                                # %for.body.preheader
	slli	a2, a2, 1
	add	a2, a2, a0
	sub	a3, a2, a0
	srli	a3, a3, 1
	addi	a1, a1, 2
	.p2align	2
# %bb.5:                                # %for.body.preheader
	lp.setup	x0, a3, .LBB0_4
.LBB0_2:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	lh	a3, 0(a1)
	lh	a4, -2(a1)
	fmul.h	a3, a3, a3
	fmadd.h	a3, a4, a4, a3
	sh	a3, 0(a0)
	addi	a0, a0, 2
.LBB0_4:                                #   in Loop: Header=BB0_2 Depth=1
                                        # Label of block must be emitted
	addi	a1, a1, 4
.LBB0_3:                                # %for.cond.cleanup
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	magsq_f16, .Lfunc_end0-magsq_f16
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops_f16.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	dot_f16                         # -- Begin function dot_f16
	.p2align	1
	.type	dot_f16,@function
dot_f16:                                # @dot_f16
# %bb.0:                                # %entry
	blez	a2, .LBB0_4
# %bb.1:                                # %for.body.preheader
	slli	a2, a2, 1
	add	a3, a1, a2
	sub	a2, a3, a1
	srli	a4, a2, 1
	li	a2, 0
	.p2align	2
# %bb.6:                                # %for.body.preheader
	lp.setup	x0, a4, .LBB0_5
.LBB0_2:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	lh	a4, 0(a0)
	lh	a5, 0(a1)
	addi	a1, a1, 2
	fmadd.h	a2, a4, a5, a2
.LBB0_5:                                #   in Loop: Header=BB0_2 Depth=1
                                        # Label of block must be emitted
	addi	a0, a0, 2
# %bb.3:                                # %for.cond.cleanup
	mv	a0, a2
	ret
.LBB0_4:
	li	a0, 0
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	dot_f16, .Lfunc_end0-dot_f16
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops_f16.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	win_f16_nr                      # -- Begin function win_f16_nr
	.p2align	1
	.type	win_f16_nr,@function
win_f16_nr:                             # @win_f16_nr
# %bb.0:                                # %entry
	blez	a2, .LBB0_3
# %bb.1:                                # %for.body.preheader
	slli	a2, a2, 1
	add	a2, a2, a1
	sub	a3, a2, a1
	srli	a3, a3, 1
	.p2align	2
# %bb.5:                                # %for.body.preheader
	lp.setup	x0, a3, .LBB0_4
.LBB0_2:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	lh	a3, 0(a0)
	lh	a4, 0(a1)
	addi	a1, a1, 2
	fmul.h	a3, a3, a4
	sh	a3, 0(a0)
.LBB0_4:                                #   in Loop: Header=BB0_2 Depth=1
                                        # Label of block must be emitted
	addi	a0, a0, 2
.LBB0_3:                                # %for.cond.cleanup
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	win_f16_nr, .Lfunc_end0-win_f16_nr
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"
	.file	"loops_f16.c"
	.option	push
	.option	arch, +c, +m, +xgap, +xpulpf16alt, +xpulpfvec, +xpulpv, +zfinx, +zhinx, +zhinxmin, +zicsr, +zmmul
	.text
	.globl	win_f16_k256                    # -- Begin function win_f16_k256
	.p2align	1
	.type	win_f16_k256,@function
win_f16_k256:                           # @win_f16_k256
# %bb.0:                                # %entry
	addi	a2, a1, 512
	sub	a3, a2, a1
	srli	a3, a3, 1
	.p2align	2
# %bb.4:                                # %entry
	lp.setup	x0, a3, .LBB0_3
.LBB0_1:                                # Block address taken
                                        # %for.body
                                        # =>This Inner Loop Header: Depth=1
                                        # Label of block must be emitted
	lh	a3, 0(a0)
	lh	a4, 0(a1)
	addi	a1, a1, 2
	fmul.h	a3, a3, a4
	sh	a3, 0(a0)
.LBB0_3:                                #   in Loop: Header=BB0_1 Depth=1
                                        # Label of block must be emitted
	addi	a0, a0, 2
# %bb.2:                                # %for.cond.cleanup
	ret
.Ltmp0:                                 # Address of block that was removed by CodeGen
.Lfunc_end0:
	.size	win_f16_k256, .Lfunc_end0-win_f16_k256
                                        # -- End function
	.option	pop
	.ident	"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"
	.section	".note.GNU-stack","",@progbits
