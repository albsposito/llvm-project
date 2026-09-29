/* Test 3 (design Q2 / backlog B99): what do the packed fp16 compares write per 16-bit lane?
 * vfeq/vfne/vflt/vfle/vfgt/vfge in .h (IEEE half) and .ah (float16alt = bfloat16 layout),
 * issued with inline asm on known inputs (GAP9 GCC assembles them; no compiler codegen
 * involved). Three candidate result formats (lane 0 = low half, "T" = compare true):
 *   bitmask   : lane i true -> bit i of rD   (lane1 only true = 0x00000002)  <- both GVSoC models
 *   lane 0/1  : lane i true -> 0x0001 in lane i (lane1 only true = 0x00010000)
 *   lane 0/-1 : lane i true -> 0xffff in lane i (lane1 only true = 0xffff0000) <- GCC's select assumes this
 * Then the GCC-compiled C select from benchmarks/fp16-design/tests/vcmp.c.
 * Runs on the cluster controller core first, then on the FC (see the INFO line before the FC part). */
#include "pack.h"
#include <stdint.h>

#define PK(lo, hi) ((uint32_t)(uint16_t)(lo) | ((uint32_t)(uint16_t)(hi) << 16))
/* IEEE half */
#define H1 0x3c00
#define H2 0x4000
#define H3 0x4200
#define HNAN 0x7e00
/* float16alt (1-8-7) */
#define A1 0x3f80
#define A2 0x4000
#define A3 0x4040
#define ANAN 0x7fc0

typedef struct { const char *name; uint32_t a, b; } pair_t;
/* lane0 = low half. Comments give lane0/lane1 truth of a<b. */
static const pair_t hpairs[] = {
    { "a={1,3} b={2,2}",     PK(H1, H3), PK(H2, H2) },   /* lt: T F */
    { "a={3,1} b={2,2}",     PK(H3, H1), PK(H2, H2) },   /* lt: F T */
    { "a={2,1} b={2,2}",     PK(H2, H1), PK(H2, H2) },   /* eq: T F, lt: F T */
    { "a={nan,1} b={1,nan}", PK(HNAN, H1), PK(H1, HNAN) },
};
static const pair_t apairs[] = {
    { "a={1,3} b={2,2}",     PK(A1, A3), PK(A2, A2) },
    { "a={3,1} b={2,2}",     PK(A3, A1), PK(A2, A2) },
    { "a={2,1} b={2,2}",     PK(A2, A1), PK(A2, A2) },
    { "a={nan,1} b={1,nan}", PK(ANAN, A1), PK(A1, ANAN) },
};
#define NP 4

/* mnemonics contain a '.', so build the function names by hand */
#define DEF(nm, mn) static uint32_t nm(uint32_t a, uint32_t b) \
    { uint32_t r; __asm__ volatile(mn " %0, %1, %2" : "=r"(r) : "r"(a), "r"(b)); return r; }
DEF(eq_h, "vfeq.h") DEF(ne_h, "vfne.h") DEF(lt_h, "vflt.h") DEF(le_h, "vfle.h") DEF(gt_h, "vfgt.h") DEF(ge_h, "vfge.h")
DEF(eq_ah, "vfeq.ah") DEF(ne_ah, "vfne.ah") DEF(lt_ah, "vflt.ah") DEF(le_ah, "vfle.ah") DEF(gt_ah, "vfgt.ah") DEF(ge_ah, "vfge.ah")

/* expected truth per pair for eq ne lt le gt ge: bit0 = lane0 true, bit1 = lane1 true.
 * Pair 3 (NaN in one operand of each lane) follows IEEE: only ne is true. */
static const uint8_t truth[NP][6] = {
    { 0, 3, 1, 1, 2, 2 },   /* a={1,3} b={2,2} */
    { 0, 3, 2, 2, 1, 1 },   /* a={3,1} b={2,2} */
    { 1, 2, 2, 3, 0, 1 },   /* a={2,1} b={2,2} */
    { 0, 3, 0, 0, 0, 0 },   /* NaN */
};
static uint32_t enc(int fmt, unsigned t)
{
    uint32_t r = 0;
    for (int l = 0; l < 2; l++)
        if ((t >> l) & 1) r |= fmt == 0 ? (1u << l) : fmt == 1 ? (1u << (16 * l)) : (0xffffu << (16 * l));
    return r;
}
static const char *fmt_name[3] = { "bitmask (lane i -> bit i)", "per-lane 0/1", "per-lane 0/-1 (0xffff)" };

typedef struct { const char *mn; uint32_t (*fn)(uint32_t, uint32_t); int alt; } op_t;
static const op_t ops[] = {
    { "vfeq.h", eq_h, 0 }, { "vfne.h", ne_h, 0 }, { "vflt.h", lt_h, 0 },
    { "vfle.h", le_h, 0 }, { "vfgt.h", gt_h, 0 }, { "vfge.h", ge_h, 0 },
    { "vfeq.ah", eq_ah, 1 }, { "vfne.ah", ne_ah, 1 }, { "vflt.ah", lt_ah, 1 },
    { "vfle.ah", le_ah, 1 }, { "vfgt.ah", gt_ah, 1 }, { "vfge.ah", ge_ah, 1 },
};
#define NOPS (sizeof ops / sizeof ops[0])

/* GCC-compiled vector compare + select (benchmarks/fp16-design/tests/vcmp.c) */
typedef float16 v2h __attribute__((vector_size(4)));
typedef short v2s __attribute__((vector_size(4)));
static volatile v2h VA = {1.0, 3.0}, VB = {2.0, 2.0};
__attribute__((noinline)) static uint32_t gcc_cmp(void)
{
    v2h a = VA, b = VB;
    v2s m = a < b;
    union { v2s v; uint32_t u; } q; q.v = m; return q.u;
}
__attribute__((noinline)) static uint32_t gcc_select(void)
{
    v2h a = VA, b = VB;
    v2s m = a < b;
    v2h s = (v2h)(((v2s)a & m) | ((v2s)b & ~m));
    union { v2h v; uint32_t u; } r; r.v = s; return r.u;
}

static void run(void *arg)
{
    (void)arg;
    const char *core = pack_is_fc() ? "fc" : "cl";
    int match[3] = { 0, 0, 0 }, total = 0;
    uint32_t nan_ne[2] = { 0, 0 };
    for (unsigned o = 0; o < NOPS; o++) {
        const pair_t *pp = ops[o].alt ? apairs : hpairs;
        for (unsigned p = 0; p < NP; p++) {
            uint32_t r = ops[o].fn(pp[p].a, pp[p].b);
            printf("RESULT t3 core=%s op=%s pair=\"%s\" a=0x%08x b=0x%08x rd=0x%08x\n", core, ops[o].mn,
                   pp[p].name, (unsigned)pp[p].a, (unsigned)pp[p].b, (unsigned)r);
            if (p == 3) {                       /* NaN handled separately */
                if (o % 6 == 1) nan_ne[ops[o].alt] = r;
                continue;
            }
            total++;
            for (int f = 0; f < 3; f++) if (r == enc(f, truth[p][o % 6])) match[f]++;
        }
    }
    int fmt = -1;
    for (int f = 0; f < 3; f++) if (match[f] == total) fmt = f;
    uint32_t m = gcc_cmp(), s = gcc_select();
    printf("RESULT t3 core=%s gcc_c_compare(a<b, a={1,3} b={2,2}) lanes=0x%08x\n", core, (unsigned)m);
    printf("RESULT t3 core=%s gcc_c_select=0x%08x (C semantics want 0x40003c00; GVSoC gives 0x40004000)\n",
           core, (unsigned)s);
    printf("VERDICT Q2 compare result format on %s: %s (matches of %d non-NaN results: bitmask %d, lane0/1 %d, lane0/-1 %d)\n",
           core, fmt >= 0 ? fmt_name[fmt] : "NONE of the three (see RESULT rows)", total, match[0], match[1], match[2]);
    printf("VERDICT Q2 NaN on %s: vfne.h(NaN)=0x%08x vfne.ah(NaN)=0x%08x (IEEE unordered '!=' is true in both lanes; "
           "GVSoC gives 0)\n", core, (unsigned)nan_ne[0], (unsigned)nan_ne[1]);
    char nm[48];
    /* PASS = same as GVSoC */
    sprintf(nm, "t3.%s.format_is_bitmask_like_gvsoc", core);
    pack_check(nm, (uint32_t)fmt, 0);
    sprintf(nm, "t3.%s.vfne_h_nan_like_gvsoc", core);
    pack_check(nm, nan_ne[0], 0);
    sprintf(nm, "t3.%s.gcc_select_like_gvsoc", core);
    pack_check(nm, s, 0x40004000);
}

int main(void)
{
    pack_banner("t3_fp16_vcmp_lanes_b99");
    pack_run_on(PACK_ON_CLUSTER, run, 0);
    printf("INFO starting the FC part; if the output stops here, the FC does not implement the "
           "packed fp16 compares (the cluster results above are the answer)\n");
    pack_run_on(PACK_ON_FC, run, 0);
    return pack_end("t3_fp16_vcmp_lanes_b99");
}
