#include <stdint.h>
__attribute__((noinline)) unsigned kern(unsigned *A, unsigned *B, unsigned *out, unsigned n, unsigned m, unsigned k) {
unsigned acc = 1, s = 2, t = 3;
for (unsigned i0 = 0; i0 < m; i0++) { out[((i0 + 8u) & 63u)] = (((B[((s + 51u) & 63u)] * 2u) + B[((acc + 62u) & 63u)]) * 7u); t += 73u; }
for (unsigned i0 = 0; i0 < (n+1u); i0++) { t += ((A[((t + 32u) & 63u)] * 2u) ^ t); for (unsigned i1 = 0; i1 < k; i1++) { if ((4u * 7u) & 8u) { s += 19u; } } }
for (unsigned i0 = 0; i0 < n; i0++) { s += B[((s + 53u) & 63u)]; }
return acc ^ s ^ t;}
