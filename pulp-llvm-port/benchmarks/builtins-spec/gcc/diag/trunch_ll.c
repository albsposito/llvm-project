/* GCC diagnostic probe: trunch_ll */
typedef short v2s __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));
typedef float16 v2h __attribute__((vector_size(4)));
typedef float16alt v2ah __attribute__((vector_size(4)));
short f(long long a){return __builtin_pulp_trunch(a);}
