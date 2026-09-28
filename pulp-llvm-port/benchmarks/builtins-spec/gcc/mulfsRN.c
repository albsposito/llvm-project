/* GCC reference test for __builtin_pulp_mulfsRN. Generated for the PULP LLVM port builtin spec.
   Compile: riscv32-unknown-elf-gcc -march=rv32imcxgap9 -mPE=8 -mFC=1 -O2 -S mulfsRN.c */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));

int t_mulfsRN_n1(int a0, int a1) { return __builtin_pulp_mulfsRN(a0, a1, 1, 1); }
int t_mulfsRN_n5(int a0, int a1) { return __builtin_pulp_mulfsRN(a0, a1, 5, 16); }
int t_mulfsRN_n11(int a0, int a1) { return __builtin_pulp_mulfsRN(a0, a1, 11, 1024); }
int t_mulfsRN_n15(int a0, int a1) { return __builtin_pulp_mulfsRN(a0, a1, 15, 16384); }
int t_mulfsRN_n16(int a0, int a1) { return __builtin_pulp_mulfsRN(a0, a1, 16, 32768); }
int t_mulfsRN_n31(int a0, int a1) { return __builtin_pulp_mulfsRN(a0, a1, 31, 1073741824); }
/* non-constant N (see mulfsRN_bad.c for diagnostics) */
