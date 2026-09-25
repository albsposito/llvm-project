typedef unsigned char v4u __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));
typedef unsigned short v2u __attribute__((vector_size(4)));
typedef short v2s __attribute__((vector_size(4)));
v4u packed_add8(v4u a,v4u b) { return a+b; }
v2u packed_add16(v2u a,v2u b) { return a+b; }
v4u packed_shift8(v4u a) { return a >> 3; }
v2u packed_shift16(v2u a) { return a >> 3; }
v4s packed_max8(v4s a,v4s b) { return __builtin_pulp_max4(a,b); }
int dot8(v4s a,v4s b,int acc) { return __builtin_pulp_sdotsp4(a,b,acc); }
int dot16(v2s a,v2s b,int acc) { return __builtin_pulp_sdotsp2(a,b,acc); }
unsigned bit_extract(unsigned a) { return __builtin_pulp_bextractu(a,8,8); }
unsigned bit_count(unsigned a) { return __builtin_popcount(a); }
unsigned mac(unsigned a,unsigned b,unsigned c) { return a*b+c; }
unsigned sum_loop(const unsigned *a,unsigned n) { unsigned s=0; for(unsigned i=0;i<n;i++) s+=a[i]; return s; }
void copy_loop(unsigned *restrict d,const unsigned *restrict a,unsigned n) { for(unsigned i=0;i<n;i++) d[i]=a[i]+7; }
int dot8_loop(const v4s *a,const v4s *b,unsigned n) { int s=0; for(unsigned i=0;i<n;i++) s=__builtin_pulp_sdotsp4(a[i],b[i],s); return s; }
int dot16_loop(const v2s *a,const v2s *b,unsigned n) { int s=0; for(unsigned i=0;i<n;i++) s=__builtin_pulp_sdotsp2(a[i],b[i],s); return s; }
void packed_add8_loop(v4u *restrict d,const v4u *restrict a,const v4u *restrict b,unsigned n) { for(unsigned i=0;i<n;i++) d[i]=a[i]+b[i]; }
