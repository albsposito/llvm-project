/* GCC reference test for __builtin_pulp_f16altmin. Generated for the PULP LLVM port builtin spec.
   Compile: riscv32-unknown-elf-gcc -march=rv32imcxgap9 -mPE=8 -mFC=1 -O2 -S f16altmin.c */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));
typedef float16 v2h __attribute__((vector_size(4)));
typedef float16alt v2ah __attribute__((vector_size(4)));

float16alt t_f16altmin(float16alt a0, float16alt a1) { return __builtin_pulp_f16altmin(a0, a1); }
