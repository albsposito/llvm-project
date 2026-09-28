unsigned kern(unsigned *B, unsigned n, unsigned k) {
  unsigned s = 0, t = 0;
  if (n) t = 5;
  for (unsigned i = 0; i < k; i++) t ^= 79u;
  for (unsigned i = 0; i < n; i++) s += B[i];
  return s ^ t;
}
