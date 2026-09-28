/* GCC reference test for __builtin_pulp_macfsRN. Generated for the PULP LLVM port builtin spec.
   Compile: riscv32-unknown-elf-gcc -march=rv32imcxgap9 -mPE=8 -mFC=1 -O2 -S macfsRN.c */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));

int t_macfsRN_n1(int a0, int a1, int a2) { return __builtin_pulp_macfsRN(a0, a1, a2, 1, 1); }
int t_macfsRN_n5(int a0, int a1, int a2) { return __builtin_pulp_macfsRN(a0, a1, a2, 5, 16); }
int t_macfsRN_n11(int a0, int a1, int a2) { return __builtin_pulp_macfsRN(a0, a1, a2, 11, 1024); }
int t_macfsRN_n15(int a0, int a1, int a2) { return __builtin_pulp_macfsRN(a0, a1, a2, 15, 16384); }
int t_macfsRN_n16(int a0, int a1, int a2) { return __builtin_pulp_macfsRN(a0, a1, a2, 16, 32768); }
int t_macfsRN_n31(int a0, int a1, int a2) { return __builtin_pulp_macfsRN(a0, a1, a2, 31, 1073741824); }
/* non-constant N (see macfsRN_bad.c for diagnostics) */
