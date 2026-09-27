volatile unsigned sink;
__attribute__((noinline)) unsigned single31(unsigned x, unsigned y){unsigned cnt=0;for(int i=0;i<31;i++){x=x*3+(y>>5);y^=x;cnt++;}sink=cnt;return x^y;}
__attribute__((noinline)) unsigned nested(unsigned x, unsigned y){for(int i=0;i<10;i++){for(int j=0;j<20;j++){x=x*3+(y>>5);y^=x;}y+=i;}return x^y;}
__attribute__((noinline)) unsigned nestedvar(unsigned x, unsigned y,int n,int m){for(int i=0;i<n;i++){for(int j=0;j<m;j++){x=x*3+(y>>5);y^=x;}y+=i;}return x^y;}
