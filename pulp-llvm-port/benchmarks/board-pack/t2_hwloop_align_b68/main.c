/* Test 2 (backlog B68): do GAP9 hardware loops need a 4-byte-aligned lp.setup / body?
 *
 * Part A (hwl_cases.S, exact placement): every case runs with lp.setup aligned (_A) and
 * misaligned (_M, 2 mod 4), for several trip counts, and is checked against the value the
 * loop must compute. Then each case is timed at n=100 (cycles of one call, warm cache).
 * Part B (hwl_c.inc): C loops compiled by GAP9 GCC -O2 (default), -O2 -mhwloopalign,
 * -O2 -mhwloopnorvc; checked against -O2 -mnohwloop and timed. The lp.setup positions GCC
 * chose are found by scanning the code at run time.
 * Both parts run on the FC and on the cluster controller core. */
#include "pack.h"
#include <stdint.h>

typedef void (*case_fn)(uint32_t n, uint32_t out[3], const uint32_t *arr);
#define EXT(n) extern void n(uint32_t, uint32_t *, const uint32_t *); extern char n##_lp[], n##_body[];
EXT(c2_A) EXT(c2_M) EXT(w2_A) EXT(w2_M) EXT(cw_A) EXT(cw_M) EXT(wc_A) EXT(wc_M)
EXT(mix3_A) EXT(mix3_M) EXT(ld_A) EXT(ld_M) EXT(seti_A) EXT(seti_M) EXT(long_A) EXT(long_M)
EXT(nest_AA) EXT(nest_AM) EXT(nest_MA) EXT(nest_MM)

enum kind { K_SIMPLE, K_MIX3, K_LD, K_SETI, K_NEST };
typedef struct { const char *name; case_fn fn; char *lp, *body; enum kind k; } acase_t;
#define C(n, k) { #n, n, n##_lp, n##_body, k }
static const acase_t acases[] = {
    C(c2_A, K_SIMPLE), C(c2_M, K_SIMPLE), C(w2_A, K_SIMPLE), C(w2_M, K_SIMPLE),
    C(cw_A, K_SIMPLE), C(cw_M, K_SIMPLE), C(wc_A, K_SIMPLE), C(wc_M, K_SIMPLE),
    C(mix3_A, K_MIX3), C(mix3_M, K_MIX3), C(ld_A, K_LD), C(ld_M, K_LD),
    C(seti_A, K_SETI), C(seti_M, K_SETI), C(long_A, K_SIMPLE), C(long_M, K_SIMPLE),
    C(nest_AA, K_NEST), C(nest_AM, K_NEST), C(nest_MA, K_NEST), C(nest_MM, K_NEST),
};
#define NCASES (sizeof acases / sizeof acases[0])
static const uint32_t trips[] = { 1, 2, 3, 5, 100 };
#define NTRIPS (sizeof trips / sizeof trips[0])

static uint32_t arr[128];

static void expected(enum kind k, uint32_t n, uint32_t e[3])
{
    e[0] = e[1] = e[2] = 0;
    switch (k) {
    case K_SIMPLE: e[0] = n; e[1] = 3 * n; break;
    case K_MIX3:   e[0] = n; e[1] = 3 * n; e[2] = n * (n + 1) / 2; break;
    case K_LD:     for (uint32_t i = 0; i < n; i++) e[2] += arr[i]; break;
    case K_SETI:   e[0] = 7; e[1] = 21; break;
    case K_NEST:   e[0] = 3 * n; e[1] = 6 * n; e[2] = n; break;
    }
}

/* ---- Part B declarations ---- */
#define DECLC(v) uint32_t sum_u8_##v(const uint8_t *, unsigned); \
    int32_t dot_i16_##v(const int16_t *, const int16_t *, unsigned); \
    void mm_i32_##v(const int32_t *, const int32_t *, int32_t *, unsigned); \
    uint32_t lcg_##v(uint32_t, unsigned);
DECLC(O2) DECLC(O2_hwloopalign) DECLC(O2_hwloopnorvc) DECLC(O2_nohwloop)
typedef struct {
    const char *name;
    uint32_t (*sum_u8)(const uint8_t *, unsigned);
    int32_t (*dot_i16)(const int16_t *, const int16_t *, unsigned);
    void (*mm_i32)(const int32_t *, const int32_t *, int32_t *, unsigned);
    uint32_t (*lcg)(uint32_t, unsigned);
} cvar_t;
#define V(v) { #v, sum_u8_##v, dot_i16_##v, mm_i32_##v, lcg_##v }
static const cvar_t cvars[] = { V(O2_nohwloop), V(O2), V(O2_hwloopalign), V(O2_hwloopnorvc) };
#define NCVARS (sizeof cvars / sizeof cvars[0])

static uint8_t u8buf[256];
static int16_t ia[128], ib[128];
static int32_t MA[64], MB[64], MC[64];
static volatile unsigned vn256 = 256, vn128 = 128, vn8 = 8, vn1000 = 1000;

/* Print the offset and address%4 of every lp.setup/lp.setupi/lp.starti in a function
 * (scans at most maxb bytes of code, stops at the first c.jr ra / jalr x0,0(ra)). */
static void scan_hwloops(const char *tag, const void *fn, unsigned maxb)
{
    const uint16_t *p = (const uint16_t *)fn;
    unsigned off = 0, count = 0;
    printf("INFO hwloops %s:", tag);
    while (off < maxb) {
        uint16_t lo = p[off / 2];
        if ((lo & 3) != 3) {                       /* 16-bit instruction */
            if (lo == 0x8082) break;               /* c.jr ra (ret) */
            off += 2; continue;
        }
        uint32_t w = lo | ((uint32_t)p[off / 2 + 1] << 16);
        if (w == 0x00008067) break;                /* jalr x0, 0(ra) */
        if ((w & 0x7f) == 0x7b) {                  /* PULP hardware-loop opcode */
            uint32_t f3 = (w >> 12) & 7;
            const char *m = f3 == 4 ? "lp.setup" : f3 == 5 ? "lp.setupi" : f3 == 0 ? "lp.starti" : 0;
            if (m) {
                printf(" %s@+0x%x(mod4=%u)", m, off, (unsigned)(((uintptr_t)fn + off) & 3));
                count++;
            }
        }
        off += 4;
    }
    printf("%s\n", count ? "" : " none");
}

static void part_a(void)
{
    const char *core = pack_is_fc() ? "fc" : "cl";
    uint32_t out[3], e[3];
    char nm[64];
    for (unsigned i = 0; i < NCASES; i++) {
        const acase_t *c = &acases[i];
        printf("INFO case %s lp_mod4=%u body_mod4=%u\n", c->name,
               (unsigned)((uintptr_t)c->lp & 3), (unsigned)((uintptr_t)c->body & 3));
        int ok = 1;
        for (unsigned t = 0; t < NTRIPS; t++) {
            out[0] = out[1] = out[2] = 0xdeadbeef;
            c->fn(trips[t], out, arr);
            expected(c->k, trips[t], e);
            if (out[0] != e[0] || out[1] != e[1] || out[2] != e[2]) {
                ok = 0;
                printf("INFO   MISMATCH n=%u got={%u,%u,%u} want={%u,%u,%u}\n", (unsigned)trips[t],
                       (unsigned)out[0], (unsigned)out[1], (unsigned)out[2],
                       (unsigned)e[0], (unsigned)e[1], (unsigned)e[2]);
            }
        }
        sprintf(nm, "t2.%s.asm.%s", core, c->name);
        pack_check(nm, ok, 1);
        /* timing: warm-up call, then one timed call with n = 100 */
        c->fn(100, out, arr);
        pack_perf_start();
        uint32_t c0 = pack_perf_cycles(), i0 = pack_perf_instr();
        c->fn(100, out, arr);
        uint32_t c1 = pack_perf_cycles(), i1 = pack_perf_instr();
        printf("RESULT t2 core=%s part=asm case=%s n=100 cycles=%u instrs=%u\n", core, c->name,
               (unsigned)(c1 - c0), (unsigned)(i1 - i0));
    }
}

static void part_b(void)
{
    const char *core = pack_is_fc() ? "fc" : "cl";
    char nm[64];
    uint32_t ref[4] = {0};
    for (unsigned v = 0; v < NCVARS; v++) {
        const cvar_t *cv = &cvars[v];
        uint32_t r[4], cyc[4];
        for (int k = 0; k < 4; k++) {
            for (int rep = 0; rep < 2; rep++) {        /* rep 0 = warm-up, rep 1 = timed */
                pack_perf_start();
                uint32_t c0 = pack_perf_cycles();
                switch (k) {
                case 0: r[k] = cv->sum_u8(u8buf, vn256); break;
                case 1: r[k] = (uint32_t)cv->dot_i16(ia, ib, vn128); break;
                case 2: {
                    cv->mm_i32(MA, MB, MC, vn8);
                    uint32_t h = 2166136261u;
                    for (int q = 0; q < 64; q++) h = (h ^ (uint32_t)MC[q]) * 16777619u;
                    r[k] = h; break;
                }
                case 3: r[k] = cv->lcg(12345, vn1000); break;
                }
                cyc[k] = pack_perf_cycles() - c0;
            }
        }
        if (v == 0) for (int k = 0; k < 4; k++) ref[k] = r[k];
        printf("RESULT t2 core=%s part=c variant=%s sum_u8=0x%08x/%u dot_i16=0x%08x/%u mm_i32=0x%08x/%u lcg=0x%08x/%u (value/cycles)\n",
               core, cv->name, (unsigned)r[0], (unsigned)cyc[0], (unsigned)r[1], (unsigned)cyc[1],
               (unsigned)r[2], (unsigned)cyc[2], (unsigned)r[3], (unsigned)cyc[3]);
        if (v > 0) {
            static const char *kn[4] = { "sum_u8", "dot_i16", "mm_i32", "lcg" };
            for (int k = 0; k < 4; k++) {
                sprintf(nm, "t2.%s.c.%s.%s", core, cv->name, kn[k]);
                pack_check(nm, r[k], ref[k]);
            }
        }
    }
}

static void run(void *arg)
{
    (void)arg;
    printf("INFO running on %s\n", pack_is_fc() ? "FC" : "the cluster controller core");
    part_a();
    part_b();
}

int main(void)
{
    pack_banner("t2_hwloop_align_b68");
    for (unsigned i = 0; i < 128; i++) arr[i] = i * 7 + 1;
    for (unsigned i = 0; i < 256; i++) u8buf[i] = (uint8_t)(i * 37 + 11);
    for (unsigned i = 0; i < 128; i++) { ia[i] = (int16_t)(i * 97 - 5000); ib[i] = (int16_t)(3000 - i * 41); }
    for (unsigned i = 0; i < 64; i++) { MA[i] = (int32_t)(i * 13) - 400; MB[i] = 300 - (int32_t)(i * 11); }
    for (unsigned v = 0; v < NCVARS; v++) {
        char t[64];
        sprintf(t, "%s.sum_u8", cvars[v].name); scan_hwloops(t, (const void *)cvars[v].sum_u8, 256);
        sprintf(t, "%s.dot_i16", cvars[v].name); scan_hwloops(t, (const void *)cvars[v].dot_i16, 256);
        sprintf(t, "%s.mm_i32", cvars[v].name); scan_hwloops(t, (const void *)cvars[v].mm_i32, 512);
        sprintf(t, "%s.lcg", cvars[v].name); scan_hwloops(t, (const void *)cvars[v].lcg, 256);
    }
    pack_run_on(PACK_ON_FC, run, 0);
    pack_run_on(PACK_ON_CLUSTER, run, 0);
    int fails = pack_fail;
    printf("VERDICT B68 misaligned hardware loops: %s\n",
           fails ? "SOME RESULTS WRONG (see CHECK FAIL lines: alignment may be required)"
                 : "all aligned and misaligned cases correct (padding not needed for correctness)");
    return pack_end("t2_hwloop_align_b68");
}
