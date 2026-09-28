#define CLR(x,b) ({int _t = (x) < ~(b) ? ~(b) : (x); _t > (b) ? (b) : _t;})
#define CLR2(x,b) ({int _t = (x) > (b) ? (b) : (x); _t < ~(b) ? ~(b) : _t;})
#define CLU(x,b) ({int _t = (x) < 0 ? 0 : (x); _t > (b) ? (b) : _t;})
#define CLU2(x,b) ({int _t = (x) > (b) ? (b) : (x); _t < 0 ? 0 : _t;})
#define IMIN (-2147483647-1)
N(0){ return CLR(x,b); }
N(1){ return CLR(x,IMIN); }
N(2){ return CLR(x,-1); }
N(3){ return CLR(x,0); }
N(4){ return CLU(x,-1); }
N(5){ return CLU(x,0); }
N(6){ return CLU(x,IMIN); }
N(7){ return CLR2(x,-1); }
N(8){ b&=0xff; return CLR(x,b); }
N(9){ b&=0xff; return CLU2(x,b); }
N(10){ b=(short)b; return CLR(x,b); }
N(11){ b>>=1; return CLR(x,b); }
N(12){ b=b<0?0:b; return CLR(x,b); }
N(13){ int c=(b>>8)&0xff; b&=0xff; int t = x<~c?~c:x; return t>b?b:t; }
N(14){ b>>=31; return CLU(x,b); }
N(15){ b=(int)((unsigned)b>>31); return CLU(x,b); }
N(16){ int t=x<0?0:x; return (unsigned)t>(unsigned)b?b:t; }
N(17){ b=b<100?b:100; return CLR(x,b); }
N(18){ b=(int)((unsigned)b%1000u); return CLR2(x,b); }
N(19){ b=(short)b; return CLU(x,b); }
N(20){ b=b<0?0:b; return CLU2(x,b); }
N(21){ b=b|0x80000000; return CLR(x,b); }
N(22){ b=(b&0xffff)-1; return CLR(x,b); }
N(23){ b=(b&0xffff)-1; return CLU(x,b); }
