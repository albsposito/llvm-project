#define N(n) int r##n(int x,int b)
#include "kern.h"
int rl0(int x,const unsigned char*p){ int b=*p; return CLR(x,b); }
int rl1(int x,const unsigned char*p){ int b=*p; return CLU(x,b); }
int rl2(int x,const signed char*p){ int b=*p; return CLR(x,b); }
int rl3(int x,const signed char*p){ int b=*p; return CLU2(x,b); }
