/* Test 2, C part: small loops compiled by GAP9 GCC with different hardware-loop options
 * (CMakeLists.txt). Included by hwl_c_<variant>.c with PACK_SFX defined. */
#include <stdint.h>
#define PACK_CAT2(a, b) a##b
#define PACK_CAT(a, b) PACK_CAT2(a, b)
#define F(name) PACK_CAT(name##_, PACK_SFX)

/* 2-instruction body (p.lbu + add) */
__attribute__((noinline)) uint32_t F(sum_u8)(const uint8_t *p, unsigned n)
{
    uint32_t s = 0;
    for (unsigned i = 0; i < n; i++) s += p[i];
    return s;
}

/* 3-instruction body (p.lh, p.lh, p.mac) */
__attribute__((noinline)) int32_t F(dot_i16)(const int16_t *a, const int16_t *b, unsigned n)
{
    int32_t s = 0;
    for (unsigned i = 0; i < n; i++) s += a[i] * b[i];
    return s;
}

/* nested hardware loops (x0 inner, x1 middle) */
__attribute__((noinline)) void F(mm_i32)(const int32_t *A, const int32_t *B, int32_t *C, unsigned n)
{
    for (unsigned i = 0; i < n; i++)
        for (unsigned j = 0; j < n; j++) {
            int32_t s = 0;
            for (unsigned k = 0; k < n; k++) s += A[i * n + k] * B[k * n + j];
            C[i * n + j] = s;
        }
}

/* short body of compressed-friendly ALU ops */
__attribute__((noinline)) uint32_t F(lcg)(uint32_t x, unsigned n)
{
    for (unsigned i = 0; i < n; i++) x = (x << 2) + x + 7;
    return x;
}
