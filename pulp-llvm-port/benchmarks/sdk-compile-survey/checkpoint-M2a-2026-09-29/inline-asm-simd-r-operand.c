/* M2a checkpoint: a 32-bit packed-SIMD vector (v2s, v2h, v2ah; the GAP9 SDK's
 * vfcvt_h_x/vfcvt_x_h macros in tools/autotiler_v3/Emulation/GapBuiltins.h)
 * as an "r" inline-asm operand is rejected by our clang; GAP9 GCC accepts it.
 *   clang --target=riscv32-unknown-elf -march=rv32imc_xgap9 -mabi=ilp32 -O2 -c inline-asm-simd-r-operand.c
 *   -> error: couldn't allocate output register for constraint 'r'   (x3)
 *   -> error: couldn't allocate input reg for constraint 'r'          (x1)
 * Same with -march=rv32imc_zfinx_xpulpv2 (v2s case). Scalar float16/int operands work.
 * SDK files affected: CNN_Libraries/CNN_Copy.c, CNN_Libraries_SQ8/CNN_Pooling_SQ8.c. */
typedef short v2s __attribute__((vector_size(4)));
typedef float16 v2h __attribute__((vector_size(4)));
typedef float16alt v2ah __attribute__((vector_size(4)));

v2h cvt_h_x(v2s s) { v2h d; __asm__ __volatile__("vfcvt.h.x %0, %1" : "=r"(d) : "r"(s)); return d; }
v2s cvt_x_h_in(v2h s) { int d; __asm__ __volatile__("vfcvt.x.h %0, %1" : "=r"(d) : "r"(s)); return (v2s)d; }
v2ah cvt_ah_x(v2s s) { v2ah d; __asm__ __volatile__("vfcvt.ah.x %0, %1" : "=r"(d) : "r"(s)); return d; }
v2s mv_v2s(v2s s) { v2s d; __asm__("mv %0, %1" : "=r"(d) : "r"(s)); return d; }
