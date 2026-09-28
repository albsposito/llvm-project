#include <stdint.h>
__attribute__((noinline)) unsigned kern(unsigned *A, unsigned *B, unsigned *out, unsigned n, unsigned m, unsigned k) {
unsigned acc = 1, s = 2, t = 3;
for (unsigned i0 = 0; i0 < m; i0++) { out[((i0 + 48u) & 63u)] = 23u; }
for (unsigned i0 = 0; i0 < (n+1u); i0++) { s += 63u; if ((A[((t + 38u) & 63u)] + A[((t + 11u) & 63u)]) & 8u) { acc += A[((i0 + 55u) & 63u)]; } }
for (unsigned i0 = 0; i0 < m; i0++) { t = (t << 1) | (s >> 31); }
return acc ^ s ^ t;}
