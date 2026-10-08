; B156 investigation. Generic LLVM 20.1.8 bug, NOT PULP code: with any loop-vectorize remark option the
; vectorizer asserts while printing 'invalid cost' remarks for an in-loop ordered fadd reduction on half.
;   toolchains/port-20-bench/bin/opt -passes=loop-vectorize -pass-remarks-missed=loop-vectorize %s -S -o /dev/null
; Assertion: cast<VectorType>() argument of incompatible type, in VPReductionRecipe::computeCost,
; called from LoopVectorizationPlanner::emitInvalidCostRemarks.
; Shown here with plain RVV features (zve32f); with xgap9 it only becomes reachable once the loop vectorizer
; is enabled for PULP (then clang -Rpass-missed=loop-vectorize crashes on SDK float16 files).
target datalayout = "e-m:e-p:32:32-i64:64-n32-S128"
target triple = "riscv32-unknown-unknown-elf"

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare half @llvm.fmuladd.f16(half, half, half) #0

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read)
define dso_local half @dot_f16(ptr noalias nocapture noundef readonly %b, ptr noalias nocapture noundef readonly %c, i32 noundef %n) local_unnamed_addr #1 {
entry:
  %cmp5 = icmp sgt i32 %n, 0
  br i1 %cmp5, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.body, %entry
  %s.0.lcssa = phi half [ 0xH0000, %entry ], [ %2, %for.body ]
  ret half %s.0.lcssa

for.body:                                         ; preds = %entry, %for.body
  %i.07 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %s.06 = phi half [ %2, %for.body ], [ 0xH0000, %entry ]
  %arrayidx = getelementptr inbounds nuw half, ptr %b, i32 %i.07
  %0 = load half, ptr %arrayidx, align 2, !tbaa !6
  %arrayidx1 = getelementptr inbounds nuw half, ptr %c, i32 %i.07
  %1 = load half, ptr %arrayidx1, align 2, !tbaa !6
  %2 = tail call half @llvm.fmuladd.f16(half %0, half %1, half %s.06)
  %inc = add nuw nsw i32 %i.07, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !10
}

attributes #0 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #1 = { nofree norecurse nosync nounwind memory(argmem: read) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv32" "target-features"="+32bit,+m,+c,+f,+zve32f,+zvl128b" }

!llvm.module.flags = !{!0, !1, !2, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"target-abi", !"ilp32"}
!2 = !{i32 6, !"riscv-isa", !3}
!3 = !{!"rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"}
!4 = !{i32 8, !"SmallDataLimit", i32 0}
!5 = !{!"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"}
!6 = !{!7, !7, i64 0}
!7 = !{!"_Float16", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = distinct !{!10, !11}
!11 = !{!"llvm.loop.mustprogress"}
