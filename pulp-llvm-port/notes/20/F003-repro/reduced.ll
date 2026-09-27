target datalayout = "e-m:e-p:32:32-i64:64-n32-S128"
target triple = "riscv32-unknown-unknown-elf"

define void @KerFirSeq() #0 {
entry:
  br label %for.body60

for.body60:                                       ; preds = %for.body60, %entry
  %j.1271 = phi i32 [ %inc78, %for.body60 ], [ 0, %entry ]
  %inc78 = add i32 %j.1271, 1
  %exitcond288.not = icmp eq i32 %j.1271, 0
  br i1 %exitcond288.not, label %for.end79, label %for.body60

for.end79:                                        ; preds = %for.body60
  ret void
}

attributes #0 = { "target-features"="+xpulpv" }
