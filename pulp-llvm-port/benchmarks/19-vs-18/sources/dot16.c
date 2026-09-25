typedef unsigned char v4u __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));
typedef unsigned short v2u __attribute__((vector_size(4)));
typedef short v2s __attribute__((vector_size(4)));
int dot16(v2s a,v2s b,int acc) { return __builtin_pulp_sdotsp2(a,b,acc); }
