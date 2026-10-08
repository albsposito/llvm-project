; B156 investigation, new back-end crash (not B147/B148). Stock compiler, no patch needed:
;   toolchains/port-20-bench/bin/llc -mtriple=riscv32-unknown-elf -mattr=+m,+c,+xgap,+xpulpv,+xpulpfvec,+xpulpf16alt,+zfinx,+zhinx,+zhinxmin %s -o -
; Assertion: RISCVSubtarget::getELen(): hasVInstructions() && "Expected V extension"
; Stack: DAGCombiner::visitVECTOR_SHUFFLE -> foldShuffleOfConcatUndefs -> RISCVTargetLowering::isShuffleMaskLegal
;        -> isInterleaveShuffle (RISCVISelLowering.cpp) reads Subtarget.getELen().
; Reached from C once vectorization is on: o[2*i]=a[i]; o[2*i+1]=b[i]; (loops3.c int16).
define void @interleave(ptr %p, <2 x i16> %a, <2 x i16> %b) {
  %s = shufflevector <2 x i16> %a, <2 x i16> %b, <4 x i32> <i32 0, i32 2, i32 1, i32 3>
  store <4 x i16> %s, ptr %p, align 2
  ret void
}
