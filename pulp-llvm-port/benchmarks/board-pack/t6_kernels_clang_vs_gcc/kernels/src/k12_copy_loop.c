typedef unsigned char v4u __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));
typedef unsigned short v2u __attribute__((vector_size(4)));
typedef short v2s __attribute__((vector_size(4)));
void copy_loop(unsigned *restrict d,const unsigned *restrict a,unsigned n) { for(unsigned i=0;i<n;i++) d[i]=a[i]+7; }
