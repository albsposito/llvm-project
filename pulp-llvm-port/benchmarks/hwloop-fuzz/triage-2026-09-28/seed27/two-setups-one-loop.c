unsigned kern(unsigned *A, unsigned *B, unsigned n, unsigned k) {
  unsigned s = 2, t = 3;
  for (unsigned i = 0; i < n + 1u; i++) { t += A[(t + 32u) & 63u]; s += k; }
  for (unsigned i = 0; i < n; i++) s += B[(s + 53u) & 63u];
  return s ^ t;
}
