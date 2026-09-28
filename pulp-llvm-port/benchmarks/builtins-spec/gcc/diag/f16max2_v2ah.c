/* GCC diagnostic probe: f16max2_v2ah */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));
typedef float16 v2h __attribute__((vector_size(4)));
typedef float16alt v2ah __attribute__((vector_size(4)));
v2h f(v2ah a,v2ah b){return __builtin_pulp_f16max2(a,b);}
