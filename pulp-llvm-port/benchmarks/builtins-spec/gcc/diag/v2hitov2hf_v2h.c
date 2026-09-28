/* GCC diagnostic probe: v2hitov2hf_v2h */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));
typedef float16 v2h __attribute__((vector_size(4)));
typedef float16alt v2ah __attribute__((vector_size(4)));
v2h f(v2h a){return __builtin_pulp_v2hitov2hf(a);}
