; RUN: llc -mtriple=riscv32 -mattr=+xpulpv -filetype=obj < %s \
; RUN:   | llvm-objdump -d -r --mattr=+xpulpv - \
; RUN:   | FileCheck %s --implicit-check-not=R_RISCV
; RUN: llc -mtriple=riscv32 -mattr=+xpulpv -filetype=obj \
; RUN:   -pulp-loop-range-immediate=0 < %s \
; RUN:   | llvm-objdump -d -r --mattr=+xpulpv - \
; RUN:   | FileCheck %s --check-prefix=RANGE --implicit-check-not=R_RISCV

; Guards 20/R001: a hardware loop must survive object emission. The loop-end
; label operand of lp.setupi (5-bit, pc-relative) and of lp.setup/lp.starti/
; lp.endi must be encoded through the fork's hardware-loop fixups and resolved
; locally, leaving no relocation. At port-20-green, @work crashed in
; RISCVMCCodeEmitter ("Unhandled expression!").
; llvm-objdump output has no update script; the CHECK lines are the encodings
; emitted by the step-20 integration build (lp.setupi 0x3e8 = 1000 iterations).

; CHECK-LABEL: <work>:
; CHECK:         3e84507b lp.setupi x0, 0x3e8, 0x8
; CHECK-LABEL: <workn>:
; CHECK:         0085407b lp.setup x0, a0, 0x8

; RANGE-LABEL: <work>:
; RANGE:         0060007b lp.starti x0, 0x6
; RANGE-NEXT:    00a0107b lp.endi x0, 0xa
; RANGE-NEXT:    3e80307b lp.counti x0, 0x3e8
; RANGE-LABEL: <workn>:
; RANGE:         0085407b lp.setup x0, a0, 0x8

; int work(void) { int acc = 0; for (int i = 0; i < 1000; i++) acc += i ^ (acc >> 3); return acc; }
define i32 @work() {
entry:
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body
  ret i32 %add

for.body:                                         ; preds = %entry, %for.body
  %i.06 = phi i32 [ 0, %entry ], [ %inc, %for.body ]
  %acc.05 = phi i32 [ 0, %entry ], [ %add, %for.body ]
  %shr = ashr i32 %acc.05, 3
  %xor = xor i32 %i.06, %shr
  %add = add nsw i32 %xor, %acc.05
  %inc = add nuw nsw i32 %i.06, 1
  %exitcond.not = icmp eq i32 %inc, 1000
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body
}

; Same loop with a variable trip count n.
define i32 @workn(i32 noundef %n) {
entry:
  %cmp5 = icmp sgt i32 %n, 0
  br i1 %cmp5, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.body, %entry
  %acc.0.lcssa = phi i32 [ 0, %entry ], [ %add, %for.body ]
  ret i32 %acc.0.lcssa

for.body:                                         ; preds = %entry, %for.body
  %i.07 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %acc.06 = phi i32 [ %add, %for.body ], [ 0, %entry ]
  %shr = ashr i32 %acc.06, 3
  %xor = xor i32 %i.07, %shr
  %add = add nsw i32 %xor, %acc.06
  %inc = add nuw nsw i32 %i.07, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body
}
