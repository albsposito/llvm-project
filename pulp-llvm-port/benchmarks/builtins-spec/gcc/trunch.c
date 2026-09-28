/* GCC reference test for __builtin_pulp_trunch. Generated for the PULP LLVM port builtin spec.
   Compile: riscv32-unknown-elf-gcc -march=rv32imcxgap9 -mPE=8 -mFC=1 -O2 -S trunch.c */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));

short int t_trunch(int a0) { return __builtin_pulp_trunch(a0); }
short int t_trunch_const(void) { return __builtin_pulp_trunch(0x12345678); }
void t_trunch_store(short *p, int a, int b) { p[0] = __builtin_pulp_trunch(a + b); p[4] = __builtin_pulp_trunch(a - b); }
