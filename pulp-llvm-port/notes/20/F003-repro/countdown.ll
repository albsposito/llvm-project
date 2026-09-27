; Count-down loop: the latch compares the decremented counter with 0, which
; RISC-V ISel emits as "BNE %iv.next, $x0".
target datalayout = "e-m:e-p:32:32-i64:64-n32-S128"
target triple = "riscv32-unknown-unknown-elf"

define i32 @countdown(ptr %p, i32 %n) {
entry:
  %cmp = icmp sgt i32 %n, 0
  br i1 %cmp, label %loop, label %exit

loop:
  %i = phi i32 [ %n, %entry ], [ %i.next, %loop ]
  %ptr = phi ptr [ %p, %entry ], [ %ptr.next, %loop ]
  %acc = phi i32 [ 0, %entry ], [ %acc.next, %loop ]
  %v = load i32, ptr %ptr
  %acc.next = add i32 %acc, %v
  %ptr.next = getelementptr i8, ptr %ptr, i32 4
  %i.next = add nsw i32 %i, -1
  %done = icmp eq i32 %i.next, 0
  br i1 %done, label %exit, label %loop

exit:
  %r = phi i32 [ 0, %entry ], [ %acc.next, %loop ]
  ret i32 %r
}
