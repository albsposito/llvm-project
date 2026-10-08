; B156 investigation, new back-end crash (not B147/B148). Stock compiler, no patch needed:
;   toolchains/port-20-bench/bin/llc -mtriple=riscv32-unknown-elf -mattr=+m,+c,+xgap,+xpulpv,+xpulpfvec,+xpulpf16alt,+zfinx,+zhinx,+zhinxmin %s -o -
; LLVM ERROR: Cannot select: i32 = vecreduce_add <v2i16>
; Cause: RISCVISelLowering.cpp:678 marks VECREDUCE_ADD Legal for v2i16/v4i8 but no pattern selects it.
; Reached from C: short s=0; for(...) s+=b[i];  (loops2.c sum16n) once the loop vectorizer is on.
declare i16 @llvm.vector.reduce.add.v2i16(<2 x i16>)
declare i8 @llvm.vector.reduce.add.v4i8(<4 x i8>)
define i16 @red_h(<2 x i16> %a) {
  %r = call i16 @llvm.vector.reduce.add.v2i16(<2 x i16> %a)
  ret i16 %r
}
define i8 @red_b(<4 x i8> %a) {
  %r = call i8 @llvm.vector.reduce.add.v4i8(<4 x i8> %a)
  ret i8 %r
}
