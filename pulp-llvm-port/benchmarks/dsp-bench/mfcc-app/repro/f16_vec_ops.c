/* Reproducer: the GAP9 GCC build of the SDK's float16 FFT (FftLibraryf16.c) gives a wrong result
 * on GVSoC ri5ky_testbench. Each packed-float16 operation that GCC emits for CplxMult_f16 and the
 * RFFT loop is done here once as a packed (v2h) operation and once lane by lane with scalar
 * float16 arithmetic; a line is printed for each, with MISMATCH when the two differ.
 *
 *   riscv32-unknown-elf-gcc -march=rv32imcxgap9 -mPE=8 -mFC=1 -O2 -ffreestanding -fno-builtin \
 *       -I benchmarks/gap9-sweep/sim crt0.S f16_vec_ops.c -nostdlib -T link.ld -lgcc
 */
#include "bench.h"
typedef signed short v2s __attribute__((vector_size(4)));
typedef float16 f16;
typedef float16 v2h __attribute__((vector_size(4)));
#define NI __attribute__((noinline))

NI static v2h v_mul(v2h a, v2h b) { return a * b; }
NI static v2h v_add(v2h a, v2h b) { return a + b; }
NI static v2h v_sub(v2h a, v2h b) { return a - b; }
NI static v2h v_swap(v2h a) { return __builtin_shuffle(a, (v2s){1, 0}); }
NI static v2h v_pack02(v2h a, v2h b) { return __builtin_shuffle(a, b, (v2s){0, 2}); }
NI static v2h v_pack13(v2h a, v2h b) { return __builtin_shuffle(a, b, (v2s){1, 3}); }
NI static v2h v_mac(v2h acc, v2h a, v2h b) { return acc + a * b; }          /* vfmac.h */
NI static v2h v_mre(v2h c, v2h a, v2h b) { return a * b - c; }              /* vfmre.h */
NI static v2h v_cplxmul(v2h A, v2h B)                                       /* SDK CplxMult_f16 */
{
    v2h P0, P1, P2, P3;
    P0 = A * B;
    B = __builtin_shuffle(B, (v2s){1, 0});
    P1 = A * B;
    P2 = __builtin_shuffle(P0, P1, (v2s){0, 2});
    P3 = __builtin_shuffle(P0, P1, (v2s){1, 3});
    P3 = P3 * (v2h){-1.0, 1.0};
    return P3 + P2;
}
NI static v2h v_rfft_body(v2h xA, v2h xB, v2h tw)                           /* SDK RFFT_DIF_Par_f16 loop body */
{
    v2h t1, t2;
    t2 = xB * (v2h){1.0, -1.0};
    t1 = t2 - xA;
    t2 = t2 + xA;
    return (v_cplxmul(tw, t1) + t2) * (v2h){0.5f, 0.5f};
}
/* scalar models; volatile keeps GCC from re-vectorising them */
NI static f16 s_mul(f16 a, f16 b) { volatile f16 r = a * b; return r; }
NI static f16 s_add(f16 a, f16 b) { volatile f16 r = a + b; return r; }
NI static f16 s_sub(f16 a, f16 b) { volatile f16 r = a - b; return r; }
static v2h mk(f16 x, f16 y) { union { v2h v; f16 f[2]; } u; u.f[0] = x; u.f[1] = y; return u.v; }
static uint32_t bits(v2h v) { union { v2h v; uint32_t u; } u; u.v = v; return u.u; }
static int fails;
NI static void check(const char *name, v2h got, v2h want)
{
    bench_puts(name); bench_puts(" packed="); bench_print_hex(bits(got));
    bench_puts(" scalar="); bench_print_hex(bits(want));
    if (bits(got) != bits(want)) { bench_puts(" MISMATCH"); fails++; }
    bench_puts("\n");
}
#define L(v, i) (((union { v2h vv; f16 f[2]; }){ .vv = (v) }).f[i])

int main(void)
{
    volatile f16 in[6] = { 1.5f, -2.25f, 0.75f, 3.0f, -0.5f, 4.0f };
    v2h a = mk(in[0], in[1]), b = mk(in[2], in[3]), c = mk(in[4], in[5]);
    check("mul    ", v_mul(a, b), mk(s_mul(L(a, 0), L(b, 0)), s_mul(L(a, 1), L(b, 1))));
    check("add    ", v_add(a, b), mk(s_add(L(a, 0), L(b, 0)), s_add(L(a, 1), L(b, 1))));
    check("sub    ", v_sub(a, b), mk(s_sub(L(a, 0), L(b, 0)), s_sub(L(a, 1), L(b, 1))));
    check("swap   ", v_swap(a), mk(L(a, 1), L(a, 0)));
    check("pack02 ", v_pack02(a, b), mk(L(a, 0), L(b, 0)));
    check("pack13 ", v_pack13(a, b), mk(L(a, 1), L(b, 1)));
    check("mac    ", v_mac(c, a, b), mk(s_add(L(c, 0), s_mul(L(a, 0), L(b, 0))), s_add(L(c, 1), s_mul(L(a, 1), L(b, 1)))));
    check("mre    ", v_mre(c, a, b), mk(s_sub(s_mul(L(a, 0), L(b, 0)), L(c, 0)), s_sub(s_mul(L(a, 1), L(b, 1)), L(c, 1))));
    /* (ar + j ai)(br + j bi) = (ar br - ai bi) + j (ar bi + ai br) */
    check("cplxmul", v_cplxmul(a, b), mk(s_sub(s_mul(L(a, 0), L(b, 0)), s_mul(L(a, 1), L(b, 1))),
                                         s_add(s_mul(L(a, 0), L(b, 1)), s_mul(L(a, 1), L(b, 0)))));
    {
        f16 t2r = L(b, 0), t2i = s_sub(0, L(b, 1));
        f16 t1r = s_sub(t2r, L(a, 0)), t1i = s_sub(t2i, L(a, 1));
        f16 u2r = s_add(t2r, L(a, 0)), u2i = s_add(t2i, L(a, 1));
        f16 mr = s_sub(s_mul(L(c, 0), t1r), s_mul(L(c, 1), t1i)), mi = s_add(s_mul(L(c, 0), t1i), s_mul(L(c, 1), t1r));
        check("rfft   ", v_rfft_body(a, b, c), mk(s_mul(s_add(mr, u2r), 0.5f), s_mul(s_add(mi, u2i), 0.5f)));
    }
    bench_puts(fails ? "RESULT FAIL\n" : "RESULT PASS\n");
    return fails;
}
