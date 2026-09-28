#include <stdint.h>
__attribute__((noinline)) unsigned kern(unsigned *A, unsigned *B, unsigned *out, unsigned n, unsigned m, unsigned k) {
unsigned acc = 1, s = 2, t = 3;
for (unsigned i0 = 0; i0 < 8u; i0++) { if ((22u & 7u) == 0) continue; for (unsigned i1 = 0; i1 < (m&3u); i1++) { t += B[((acc + 41u) & 63u)]; } acc += ((B[((acc + 30u) & 63u)] * 5u) ^ t); }
for (unsigned i0 = 0; i0 < m; i0++) { t = (t << 1) | (s >> 31); }
return acc ^ s ^ t;}
