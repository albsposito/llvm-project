typedef unsigned char v4u __attribute__((vector_size(4)));
typedef signed char v4s __attribute__((vector_size(4)));
typedef unsigned short v2u __attribute__((vector_size(4)));
typedef short v2s __attribute__((vector_size(4)));
unsigned sum_loop(const unsigned *a,unsigned n) { unsigned s=0; for(unsigned i=0;i<n;i++) s+=a[i]; return s; }
