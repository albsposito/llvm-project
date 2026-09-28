#define N(n) int k##n(int x,int b)
#include "kern.h"
int kl0(int x,const unsigned char*p){ int b=*p; return CLR(x,b); }
int kl1(int x,const unsigned char*p){ int b=*p; return CLU(x,b); }
int kl2(int x,const signed char*p){ int b=*p; return CLR(x,b); }
int kl3(int x,const signed char*p){ int b=*p; return CLU2(x,b); }
