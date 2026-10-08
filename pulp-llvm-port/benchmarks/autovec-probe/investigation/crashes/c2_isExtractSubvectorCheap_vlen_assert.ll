; B156 investigation, new back-end crash (not B147/B148). Stock compiler, no patch needed:
;   toolchains/port-20-bench/bin/llc -mtriple=riscv32-unknown-elf -mattr=+m,+c,+xgap,+xpulpv,+xpulpfvec,+xpulpf16alt,+zfinx,+zhinx,+zhinxmin %s -o -
; Assertion: RISCVSubtarget::getMinRVVVectorSizeInBits(): hasVInstructions() && "Tried to get vector length without Zve or V extension support!"
; Stack: DAGCombiner::visitBUILD_VECTOR -> reduceBuildVecToShuffle -> RISCVTargetLowering::isExtractSubvectorCheap
;        (RISCVISelLowering.cpp:2320-2340 reads Subtarget.getRealMinVLen() for any fixed vector).
;        Also reached through DAGCombiner::visitEXTRACT_SUBVECTOR (forced VF4 on a 16-bit max reduction).
; Reached from C once vectorization is on: o[i]=in[2*i]+in[2*i+1] (loops3.c deint16), a[i]=b[2*i] (stride2),
; and SDK FftLibraryFix.c Radix2FFT_DIF_Scalar. This is the 'assert RVV-VLEN' family of gap9-sweep/report.md.
define <2 x i16> @deint(ptr %p) {
  %w = load <4 x i16>, ptr %p, align 2
  %e = shufflevector <4 x i16> %w, <4 x i16> poison, <2 x i32> <i32 0, i32 2>
  %o = shufflevector <4 x i16> %w, <4 x i16> poison, <2 x i32> <i32 1, i32 3>
  %r = add <2 x i16> %e, %o
  ret <2 x i16> %r
}
