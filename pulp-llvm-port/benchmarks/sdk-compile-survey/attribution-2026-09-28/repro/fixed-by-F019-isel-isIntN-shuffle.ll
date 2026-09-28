; int-20 llc -O2: APInt isIntN assertion in RISC-V ISel on a constant <4 x i8> shufflevector feeding
; pulp.sdotsp4 (10 SQ8/SQX conv kernels once __builtin_shuffle is mapped to shufflevector).
; Does NOT reproduce with 20/F019-rev2 llc: item 3 covers it. Kept for regression testing.
target datalayout = "e-m:e-p:32:32-i64:64-n32-S128"
target triple = "riscv32-unknown-unknown-elf"

define fastcc void @KerConv1x3Stride1x1_Body_SQ8() #0 {
entry:
  %vecins40.3 = shufflevector <4 x i8> zeroinitializer, <4 x i8> splat (i8 1), <4 x i32> <i32 0, i32 1, i32 2, i32 4>
  %0 = tail call i32 @llvm.riscv.pulp.sdotsp4(<4 x i8> %vecins40.3, <4 x i8> zeroinitializer, i32 0)
  store i32 %0, ptr null, align 4
  ret void
}

; Function Attrs: nounwind memory(none)
declare i32 @llvm.riscv.pulp.sdotsp4(<4 x i8>, <4 x i8>, i32) #1

attributes #0 = { "target-features"="+32bit,+c,+m,+xgap,+xpulpv,+zfinx,+zhinx,+zicsr" }
attributes #1 = { nounwind memory(none) }
