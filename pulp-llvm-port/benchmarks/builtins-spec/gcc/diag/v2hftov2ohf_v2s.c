/* GCC diagnostic probe: v2hftov2ohf_v2s */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));
typedef float16 v2h __attribute__((vector_size(4)));
typedef float16alt v2ah __attribute__((vector_size(4)));
v2ah f(v2s a){return __builtin_pulp_v2hftov2ohf(a);}
