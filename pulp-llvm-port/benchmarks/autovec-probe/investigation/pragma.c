/* B156: can a source pragma force it? (question 3) */
void add16_pragma(short *restrict a, const short *restrict b, const short *restrict c, int n){
#pragma clang loop vectorize(enable) vectorize_width(2)
  for(int i=0;i<n;i++) a[i]=b[i]+c[i];
}
void add8_pragma(signed char *restrict a, const signed char *restrict b, const signed char *restrict c, int n){
#pragma clang loop vectorize(enable) vectorize_width(4) interleave_count(1)
  for(int i=0;i<n;i++) a[i]=b[i]+c[i];
}
