typedef unsigned char v4u __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));
typedef unsigned short v2u __attribute__((vector_size(4)));
typedef short v2s __attribute__((vector_size(4)));
int dot16_loop(const v2s *a,const v2s *b,unsigned n) { int s=0; for(unsigned i=0;i<n;i++) s=__builtin_pulp_sdotsp2(a[i],b[i],s); return s; }
