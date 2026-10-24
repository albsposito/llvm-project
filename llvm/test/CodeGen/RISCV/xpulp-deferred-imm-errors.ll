; RUN: split-file %s %t
; RUN: not llc -mtriple=riscv32 -mattr=+xpulpv -filetype=null %t/nonconst.ll 2>&1 \
; RUN:   | FileCheck %t/nonconst.ll
; RUN: not llc -mtriple=riscv32 -mattr=+xpulpv -filetype=null %t/norm.ll 2>&1 \
; RUN:   | FileCheck %t/norm.ll
; RUN: not llc -mtriple=riscv32 -mattr=+xpulpv -filetype=null %t/round.ll 2>&1 \
; RUN:   | FileCheck %t/round.ll
; RUN: not llc -mtriple=riscv32 -mattr=+xpulpv -filetype=null %t/clip.ll 2>&1 \
; RUN:   | FileCheck %t/clip.ll

; Guards 20/F043: a llvm.riscv.pulp.<op>.deferred call whose immediate is not
; a constant after optimisation, or is a constant that breaks GAP9 GCC's rules
; (normalisation N <= 31; RN: 1 <= N <= 31 and rounding 2^(N-1); clip bounds
; -2^(N-1) and 2^(N-1)-1), is reported as an error by instruction selection,
; like GAP9 GCC does, instead of being selected with a wrong immediate.

;--- nonconst.ll
; CHECK: error: {{.*}}argument 3 to '__builtin_pulp_mulsN' must be a constant integer (it is not constant after optimization)
declare i32 @llvm.riscv.pulp.mulsN.deferred(i32, i32, i32)
define i32 @f(i32 %x, i32 %y, i32 %n) {
  %r = call i32 @llvm.riscv.pulp.mulsN.deferred(i32 %x, i32 %y, i32 %n)
  ret i32 %r
}

;--- norm.ll
; CHECK: error: {{.*}}normalization argument to '__builtin_pulp_mulsN' must be in range [0, 31] (got 32)
declare i32 @llvm.riscv.pulp.mulsN.deferred(i32, i32, i32)
define i32 @f(i32 %x, i32 %y) {
  %r = call i32 @llvm.riscv.pulp.mulsN.deferred(i32 %x, i32 %y, i32 32)
  ret i32 %r
}

;--- round.ll
; CHECK: error: {{.*}}arguments to '__builtin_pulp_mulsRN' must be a normalization N in range [1, 31] and a rounding value 2^(N-1) (got 3 and 3)
declare i32 @llvm.riscv.pulp.mulsRN.deferred(i32, i32, i32, i32)
define i32 @f(i32 %x, i32 %y) {
  %r = call i32 @llvm.riscv.pulp.mulsRN.deferred(i32 %x, i32 %y, i32 3, i32 3)
  ret i32 %r
}

;--- clip.ll
; CHECK: error: {{.*}}bounds of '__builtin_pulp_clip' must be -2^(N-1) and 2^(N-1)-1 with 1 <= N <= 30 (got -4 and 127)
declare i32 @llvm.riscv.pulp.clip.deferred(i32, i32, i32)
define i32 @f(i32 %x) {
  %r = call i32 @llvm.riscv.pulp.clip.deferred(i32 %x, i32 -4, i32 127)
  ret i32 %r
}
