target datalayout = "e-m:e-p:32:32-i64:64-n32-S128"
target triple = "riscv32-unknown-unknown-elf"

define fastcc void @_DIT_DFT_MR(ptr %In, ptr %InOut) #0 {
entry:
  %0 = load bfloat, ptr %In, align 2
  %arrayidx5.i = getelementptr i8, ptr %In, i32 2
  %1 = load bfloat, ptr %arrayidx5.i, align 2
  store bfloat %0, ptr %InOut, align 2
  %arrayidx10.i = getelementptr i8, ptr %InOut, i32 2
  store bfloat %1, ptr %arrayidx10.i, align 2
  ret void
}

attributes #0 = { "target-features"="+32bit,+c,+m,+xpulpv,+zfinx,+zhinx,+zhinxmin,+zicsr,+zmmul" }
