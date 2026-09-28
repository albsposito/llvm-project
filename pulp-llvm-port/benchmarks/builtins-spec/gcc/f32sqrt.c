/* GCC reference test for __builtin_pulp_f32sqrt. Generated for the PULP LLVM port builtin spec.
   Compile: riscv32-unknown-elf-gcc -march=rv32imcxgap9 -mPE=8 -mFC=1 -O2 -S f32sqrt.c */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));

float t_f32sqrt(float a0) { return __builtin_pulp_f32sqrt(a0); }
float t_f32sqrt_const(void) { return __builtin_pulp_f32sqrt(2.5f); }
