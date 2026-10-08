void add16(short *restrict a, const short *restrict b, const short *restrict c, int n){ for(int i=0;i<n;i++) a[i]=b[i]+c[i]; }
void add8(signed char *restrict a, const signed char *restrict b, const signed char *restrict c, int n){ for(int i=0;i<n;i++) a[i]=b[i]+c[i]; }
int dot16(const short *restrict b, const short *restrict c, int n){ int s=0; for(int i=0;i<n;i++) s+=b[i]*c[i]; return s; }
