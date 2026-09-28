; M1 checkpoint 2026-09-28: libs/gap_lib/img_io/ImgIO.c @GetInputImageInfos, llvm-reduce of clang 4851ef81477b -O2 -march=rv32imc_xgap9 IR.
; LiveVariables.cpp:141 "Cant find reaching def for virtreg" after PULP Hardware Loops.
; RUN: llc -O2 %s -o /dev/null
; (the older ../crash-pulp-hwloops-GetInputImageInfos.ll no longer crashes with int-20 llc 4851ef81477b; this one does)
target datalayout = "e-m:e-p:32:32-i64:64-n32-S128"
target triple = "riscv32-unknown-unknown-elf"

define fastcc i32 @GetInputImageInfos(i1 %or.cond.i130.i) #0 {
entry:
  br label %land.rhs.i.i.i

land.rhs.i.i.i:                                   ; preds = %land.rhs.i.i.i, %land.rhs.i.i.i, %land.rhs.i.i.i, %land.rhs.i.i.i, %land.rhs.i.i.i, %entry
  %i.5.i = phi i32 [ 1, %entry ], [ 0, %land.rhs.i.i.i ], [ 0, %land.rhs.i.i.i ], [ 0, %land.rhs.i.i.i ], [ 0, %land.rhs.i.i.i ], [ 0, %land.rhs.i.i.i ]
  switch i8 0, label %land.rhs12.i127.i [
    i8 1, label %land.rhs.i.i.i
    i8 32, label %land.rhs.i.i.i
    i8 9, label %land.rhs.i.i.i
    i8 13, label %land.rhs.i.i.i
    i8 0, label %land.rhs.i.i.i
  ]

land.rhs12.i127.i:                                ; preds = %while.body24.i131.i, %land.rhs.i.i.i
  %i.15.i = phi i32 [ %inc27.i136.i, %while.body24.i131.i ], [ %i.5.i, %land.rhs.i.i.i ]
  br i1 %or.cond.i130.i, label %while.body24.i131.i, label %if.end41.i

while.body24.i131.i:                              ; preds = %land.rhs12.i127.i
  %inc27.i136.i = add i32 %i.15.i, 1
  %exitcond54.not.i137.i = icmp eq i32 %inc27.i136.i, 256
  br i1 %exitcond54.not.i137.i, label %if.end41.i, label %land.rhs12.i127.i

if.end41.i:                                       ; preds = %while.body24.i131.i, %land.rhs12.i127.i
  %i.18.i = phi i32 [ 256, %while.body24.i131.i ], [ %i.15.i, %land.rhs12.i127.i ]
  %call17 = call i32 (ptr, ...) null(ptr null, ptr null, i32 0, i32 0, i32 0, i32 %i.18.i)
  ret i32 0
}

attributes #0 = { "target-features"="+32bit,+c,+m,+xpulpv,+zfinx" }
