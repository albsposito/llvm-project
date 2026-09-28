/* Queue item N2: inline asm "r" operands of 32-bit vector type.
 * GAP9 GCC accepts all of these (a vector_size(4) value lives in a GPR);
 * our clang (int-20, 20/F019-rev2) says "couldn't allocate output register
 * for constraint 'r'" / "couldn't allocate input reg" for v2s, v4s, v2h, v2ah
 * (scalar _Float16/__bf16/int are fine).  The SDK hits it through
 * GapBuiltins.h vfcvt_h_x()/vfcvt_x_h() in CNN_Copy.c and CNN_Pooling_SQ8.c
 * (those asm strings also need the GPR vfcvt.* MC definitions, item 15).
 * clang --target=riscv32-unknown-elf -march=rv32imc_xgap9 -mabi=ilp32 -O2 -c N2-asm-r-vector.c */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));
typedef _Float16 v2h __attribute__((vector_size(4)));
v2s f(int x) { v2s d; __asm__("mv %0, %1" : "=r"(d) : "r"(x)); return d; }
int g(v4s x) { int d; __asm__("mv %0, %1" : "=r"(d) : "r"(x)); return d; }
v2h h(v2s x) { v2h d; __asm__("vfcvt.h.x %0, %1" : "=r"(d) : "r"(x)); return d; }
