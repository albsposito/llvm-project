/* GCC diagnostic probe: CoreCount_m1_arg */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));
typedef float16 v2h __attribute__((vector_size(4)));
typedef float16alt v2ah __attribute__((vector_size(4)));
int f(void){return __builtin_pulp_CoreCount_m1(1);}
