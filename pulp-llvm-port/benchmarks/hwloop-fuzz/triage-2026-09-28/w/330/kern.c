#include <stdint.h>
__attribute__((noinline)) unsigned kern(unsigned *A, unsigned *B, unsigned *out, unsigned n, unsigned m, unsigned k) {
unsigned acc = 1, s = 2, t = 3;
for (unsigned i0 = 0; i0 < n; i0++) { if ((A[((s + 43u) & 63u)] & 7u) == 0) continue; t = (t << 1) | (s >> 31); }
for (unsigned i0 = 0; i0 < m; i0++) { s += B[((i0 + 9u) & 63u)]; }
for (unsigned i0 = 0; i0 < n; i0++) { if (89u & 2u) { t = (t << 1) | (s >> 31); } if (66u & 1u) { if ((((22u + (B[((s + 43u) & 63u)] ^ acc)) ^ acc) & 7u) == 0) continue; for (unsigned i1 = 0; i1 < (m&3u); i1++) { if (((98u + ((A[((i1 + 37u) & 63u)] + A[((s + 49u) & 63u)]) * 4u)) & 7u) == 0) continue; s += ((B[((i1 + 13u) & 63u)] ^ s) + ((A[((acc + 2u) & 63u)] + A[((i0 + 23u) & 63u)]) + B[((acc + 10u) & 63u)])); } t = (t << 1) | (s >> 31); } else { out[((i0 + 63u) & 63u)] = (B[((acc + 63u) & 63u)] ^ s); acc += (29u ^ t); } }
return acc ^ s ^ t;}
