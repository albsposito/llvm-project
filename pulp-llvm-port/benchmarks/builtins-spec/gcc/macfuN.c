/* GCC reference test for __builtin_pulp_macfuN. Generated for the PULP LLVM port builtin spec.
   Compile: riscv32-unknown-elf-gcc -march=rv32imcxgap9 -mPE=8 -mFC=1 -O2 -S macfuN.c */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));

int t_macfuN_n1(int a0, int a1, int a2) { return __builtin_pulp_macfuN(a0, a1, a2, 1); }
int t_macfuN_n5(int a0, int a1, int a2) { return __builtin_pulp_macfuN(a0, a1, a2, 5); }
int t_macfuN_n11(int a0, int a1, int a2) { return __builtin_pulp_macfuN(a0, a1, a2, 11); }
int t_macfuN_n15(int a0, int a1, int a2) { return __builtin_pulp_macfuN(a0, a1, a2, 15); }
int t_macfuN_n16(int a0, int a1, int a2) { return __builtin_pulp_macfuN(a0, a1, a2, 16); }
int t_macfuN_n31(int a0, int a1, int a2) { return __builtin_pulp_macfuN(a0, a1, a2, 31); }
/* non-constant N (see macfuN_bad.c for diagnostics) */
