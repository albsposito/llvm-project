/* GCC reference test for __builtin_pulp_f32min. Generated for the PULP LLVM port builtin spec.
   Compile: riscv32-unknown-elf-gcc -march=rv32imcxgap9 -mPE=8 -mFC=1 -O2 -S f32min.c */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));

float t_f32min(float a0, float a1) { return __builtin_pulp_f32min(a0, a1); }
float t_f32min_const(void) { return __builtin_pulp_f32min(2.5f, -3.5f); }
