typedef unsigned char v4u __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));
typedef unsigned short v2u __attribute__((vector_size(4)));
typedef short v2s __attribute__((vector_size(4)));
void packed_add8_loop(v4u *restrict d,const v4u *restrict a,const v4u *restrict b,unsigned n) { for(unsigned i=0;i<n;i++) d[i]=a[i]+b[i]; }
