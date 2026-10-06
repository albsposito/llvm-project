/* Test 8 (backlog B151): what does the packed float16 instruction vfmre.h compute?
 * For the packed C expression a*b - c, GAP9 GCC 7.1.1 emits `vfmre.h c, a, b`. GVSoC executes
 * vfmre.h as rd = rd - rs1*rs2, the opposite sign, so GCC's float16 / float16alt FFT comes out
 * wrong on the simulator. Either GCC picks the wrong instruction or GVSoC models it with the
 * wrong sign. This test decides it on silicon.
 *
 * Part 1, raw probes (no compiler code generation involved). Each instruction is executed as a
 * fixed 32-bit word with fixed registers (`<op> a0, a1, a2`: rd = a0, rs1 = a1, rs2 = a2) and,
 * next to it, as the mnemonic assembled by the toolchain; the two words are compared at run time.
 * Inputs are small integers, exact in float16 and float16alt, different in the two lanes. The
 * result is compared with every candidate below, computed with integer arithmetic only:
 *   rd - a*b      what GVSoC does for vfmre
 *   a*b - rd      what GAP9 GCC assumes for vfmre
 *   rd + a*b      what vfmac is expected to do (the control)
 *   -(rd + a*b)
 * each with b taken per lane, or from lane 0 / lane 1 of rs2 in both lanes (the .r variants).
 * Probed: vfmre.h vfmac.h vfmre.ah vfmac.ah, then (last, see main) the .r forms of the four.
 *
 * Part 2, compiled code: packed a*b - c, c - a*b and a*b + c compiled by the compiler that
 * builds this file, against the same expression done lane by lane with scalar arithmetic
 * (noinline + volatile, so it cannot be turned into a packed instruction). MATCH / MISMATCH.
 * The program also scans its own code and prints which of vfmre / vfmac the compiler used.
 *
 * CHECK PASS in this test means "the probe ran and matched exactly one candidate" (and "the
 * fixed word is what the assembler emits"). It does not say which side is right: the VERDICT
 * lines do. Runs on the cluster controller core first, then on the FC. */
#include "pack.h"
#include <stdint.h>

#define NI __attribute__((noinline))

/* ---------------------------------------------------------------- part 1: raw probes */

/* t8_w_<sym>: the instruction as a fixed word. t8_m_<sym>: the same mnemonic, assembled by the
 * toolchain. Both are `uint32_t f(uint32_t rd, uint32_t rs1, uint32_t rs2)`: the arguments
 * arrive in a0, a1, a2 and the result leaves in a0, so no compiler-chosen register is involved. */
#define T8_PROBE(sym, word, mn) \
    __asm__(".pushsection .text.t8_probes,\"ax\",@progbits\n" \
            ".option push\n.option norvc\n" \
            ".balign 4\n.globl t8_w_" #sym "\n.type t8_w_" #sym ",@function\n" \
            "t8_w_" #sym ":\n\t.word " #word "\n\tret\n.size t8_w_" #sym ", .-t8_w_" #sym "\n" \
            ".balign 4\n.globl t8_m_" #sym "\n.type t8_m_" #sym ",@function\n" \
            "t8_m_" #sym ":\n\t" mn " a0, a1, a2\n\tret\n.size t8_m_" #sym ", .-t8_m_" #sym "\n" \
            ".option pop\n.popsection\n"); \
    uint32_t t8_w_##sym(uint32_t rd, uint32_t rs1, uint32_t rs2); \
    uint32_t t8_m_##sym(uint32_t rd, uint32_t rs1, uint32_t rs2);

/* funct7 1001001 = vfmre, 1001000 = vfmac; funct3 010 = .h, 001 = .ah, 110 = .r.h, 101 = .r.ah;
 * rs2 = a2 (x12), rs1 = a1 (x11), rd = a0 (x10), opcode 0110011. */
T8_PROBE(vfmre_h,   0x92c5a533, "vfmre.h")
T8_PROBE(vfmac_h,   0x90c5a533, "vfmac.h")
T8_PROBE(vfmre_ah,  0x92c59533, "vfmre.ah")
T8_PROBE(vfmac_ah,  0x90c59533, "vfmac.ah")
T8_PROBE(vfmre_r_h, 0x92c5e533, "vfmre.r.h")
T8_PROBE(vfmac_r_h, 0x90c5e533, "vfmac.r.h")
T8_PROBE(vfmre_r_ah, 0x92c5d533, "vfmre.r.ah")
T8_PROBE(vfmac_r_ah, 0x90c5d533, "vfmac.r.ah")

typedef uint32_t (*probe_fn)(uint32_t, uint32_t, uint32_t);
typedef struct { const char *mn; probe_fn w, m; uint32_t word; uint8_t alt, rep; } probe_t;
#define P(sym, word, mn, alt, rep) { mn, t8_w_##sym, t8_m_##sym, word, alt, rep }
static const probe_t probes[] = {
    P(vfmre_h,   0x92c5a533, "vfmre.h", 0, 0),      P(vfmac_h,   0x90c5a533, "vfmac.h", 0, 0),
    P(vfmre_ah,  0x92c59533, "vfmre.ah", 1, 0),     P(vfmac_ah,  0x90c59533, "vfmac.ah", 1, 0),
    P(vfmre_r_h, 0x92c5e533, "vfmre.r.h", 0, 1),    P(vfmac_r_h, 0x90c5e533, "vfmac.r.h", 0, 1),
    P(vfmre_r_ah, 0x92c5d533, "vfmre.r.ah", 1, 1),  P(vfmac_r_ah, 0x90c5d533, "vfmac.r.ah", 1, 1),
};
enum { I_MRE_H, I_MAC_H, I_MRE_AH, I_MAC_AH, N_MAIN, N_PROBES = 8 };

/* Inputs: integers per lane {lane 0, lane 1}; lane 0 is the low half of the register. */
typedef struct { int d[2], a[2], b[2]; } in_t;
static const in_t ins[] = {
    { { 10, 1 },  { 2, 3 },  { 4, 5 } },     /* a*b = {8,15}:  rd-a*b = {2,-14}   a*b-rd = {-2,14}  */
    { { 4, -20 }, { -3, 7 }, { 5, 2 } },     /* a*b = {-15,14}: rd-a*b = {19,-34} a*b-rd = {-19,34} */
};
#define NSETS 2

/* The float16 (alt = 0: IEEE half, 1-5-10) or float16alt (alt = 1: 1-8-7) bits of a small
 * integer. Exact for every value this test uses (at most 6 significant bits). */
static uint32_t enc1(int n, int alt)
{
    if (n == 0) return 0;
    uint32_t s = n < 0, m = s ? (uint32_t)-n : (uint32_t)n;
    int e = 0, M = alt ? 7 : 10, bias = alt ? 127 : 15;
    while ((m >> e) > 1) e++;
    return (s << 15) | ((uint32_t)(e + bias) << M) | ((m << (M - e)) & ((1u << M) - 1));
}
static uint32_t encv(int l0, int l1, int alt) { return enc1(l0, alt) | (enc1(l1, alt) << 16); }

/* Candidates. op: 0 rd - a*b, 1 a*b - rd, 2 rd + a*b, 3 -(rd + a*b).
 * rep: 0 b per lane, 1 b = rs2 lane 0 in both lanes, 2 b = rs2 lane 1 in both lanes. */
enum { OP_RD_MINUS_AB, OP_AB_MINUS_RD, OP_RD_PLUS_AB, OP_NEG_SUM, N_OPS };
#define N_CLASSES (N_OPS * 3)
#define CLS_NONE (-1)
static const char *const op_name[N_OPS] = { "rd - a*b", "a*b - rd", "rd + a*b", "-(rd + a*b)" };
static const char *const rep_name[3] = { "", " with b = rs2 lane 0 in both lanes", " with b = rs2 lane 1 in both lanes" };
static const char *cls_op(int c) { return c < 0 ? "neither" : op_name[c / 3]; }
static const char *cls_rep(int c) { return c < 0 ? " (matches no candidate, see the out= values)" : rep_name[c % 3]; }

static uint32_t model(int cls, const in_t *s, int alt)
{
    int r[2];
    for (int l = 0; l < 2; l++) {
        int rep = cls % 3, b = rep == 0 ? s->b[l] : s->b[rep - 1];
        int p = s->a[l] * b, d = s->d[l];
        switch (cls / 3) {
        case OP_RD_MINUS_AB: r[l] = d - p; break;
        case OP_AB_MINUS_RD: r[l] = p - d; break;
        case OP_RD_PLUS_AB:  r[l] = d + p; break;
        default:             r[l] = -(d + p); break;
        }
    }
    return encv(r[0], r[1], alt);
}

/* What one core found. cls[i]: candidate that probe i matched on every input set, or CLS_NONE. */
typedef struct { int ran, ran_r, word_ne_mnemonic; int cls[N_PROBES]; char cmp[2][3]; } core_res_t;
static core_res_t res[2];                 /* [0] cluster controller, [1] FC */

static void run_probes(core_res_t *R, const char *core, int first, int last)
{
    char nm[64];
    for (int i = first; i < last; i++) {
        const probe_t *p = &probes[i];
        uint32_t out[NSETS];
        for (int s = 0; s < NSETS; s++) {
            uint32_t d = encv(ins[s].d[0], ins[s].d[1], p->alt), a = encv(ins[s].a[0], ins[s].a[1], p->alt),
                     b = encv(ins[s].b[0], ins[s].b[1], p->alt);
            uint32_t om = p->m(d, a, b);
            out[s] = p->w(d, a, b);
            if (om != out[s]) R->word_ne_mnemonic = 1;
            printf("RESULT t8 core=%s op=%s set=%d rd=0x%08x a=0x%08x b=0x%08x out=0x%08x out_mnemonic=0x%08x "
                   "candidates%s: rd-a*b=0x%08x a*b-rd=0x%08x rd+a*b=0x%08x\n",
                   core, p->mn, s, (unsigned)d, (unsigned)a, (unsigned)b, (unsigned)out[s], (unsigned)om,
                   p->rep ? "(b = rs2 lane 0)" : "",
                   (unsigned)model(OP_RD_MINUS_AB * 3 + p->rep, &ins[s], p->alt),
                   (unsigned)model(OP_AB_MINUS_RD * 3 + p->rep, &ins[s], p->alt),
                   (unsigned)model(OP_RD_PLUS_AB * 3 + p->rep, &ins[s], p->alt));
        }
        int cls = CLS_NONE, n = 0;
        for (int c = 0; c < N_CLASSES; c++) {
            int ok = 1;
            for (int s = 0; s < NSETS; s++) if (out[s] != model(c, &ins[s], p->alt)) ok = 0;
            if (ok) { cls = c; n++; }
        }
        if (n != 1) cls = CLS_NONE;
        R->cls[i] = cls;
        printf("RESULT t8 core=%s op=%s computes: %s%s\n", core, p->mn, cls_op(cls), cls_rep(cls));
        sprintf(nm, "t8.%s.%s_classified", core, p->mn);
        pack_check(nm, cls != CLS_NONE, 1);
    }
}

/* ---------------------------------------------------------------- part 2: compiled code */

/* The float16alt half of part 2 needs float16alt arithmetic from the compiler. GAP9 GCC has it.
 * Our clang 20 calls a soft-float helper (__truncsfbf2) that the GAP9 libgcc does not have, so
 * there it is left out (-DT8_COMPILED_ALT=0/1 overrides). The raw .ah probes do not depend on it. */
#ifndef T8_COMPILED_ALT
#ifdef __clang__
#define T8_COMPILED_ALT 0
#else
#define T8_COMPILED_ALT 1
#endif
#endif

typedef float16 f16h;
typedef f16h v2h __attribute__((vector_size(4)));
#if T8_COMPILED_ALT
typedef float16alt f16a;
typedef f16a v2a __attribute__((vector_size(4)));
#endif

/* Packed expressions, as in benchmarks/dsp-bench/sdk-kernels/repro/gcc_vfmre_sign.c. */
NI v2h c_msub_h(v2h a, v2h b, v2h c) { return a * b - c; }
NI v2h c_nmsub_h(v2h a, v2h b, v2h c) { return c - a * b; }
NI v2h c_madd_h(v2h a, v2h b, v2h c) { return a * b + c; }
#if T8_COMPILED_ALT
NI v2a c_msub_a(v2a a, v2a b, v2a c) { return a * b - c; }
NI v2a c_nmsub_a(v2a a, v2a b, v2a c) { return c - a * b; }
NI v2a c_madd_a(v2a a, v2a b, v2a c) { return a * b + c; }
#endif

/* Scalar reference, one operation per call; the volatile result keeps the compiler from
 * fusing or re-vectorising the operations. */
#define SCALAR(T, sfx) \
    NI static T s_mul_##sfx(T a, T b) { volatile T r = a * b; return r; } \
    NI static T s_add_##sfx(T a, T b) { volatile T r = a + b; return r; } \
    NI static T s_sub_##sfx(T a, T b) { volatile T r = a - b; return r; } \
    static T lane_##sfx(uint32_t v, int l) { union { T f; uint16_t u; } q; q.u = (uint16_t)(v >> (16 * l)); return q.f; } \
    static uint32_t bits_##sfx(T x) { union { T f; uint16_t u; } q; q.f = x; return q.u; } \
    /* e: 0 a*b - c, 1 c - a*b, 2 a*b + c */ \
    NI static uint32_t ref_##sfx(int e, uint32_t a, uint32_t b, uint32_t c) \
    { \
        uint32_t r = 0; \
        for (int l = 0; l < 2; l++) { \
            T p = s_mul_##sfx(lane_##sfx(a, l), lane_##sfx(b, l)), cl = lane_##sfx(c, l); \
            T x = e == 0 ? s_sub_##sfx(p, cl) : e == 1 ? s_sub_##sfx(cl, p) : s_add_##sfx(p, cl); \
            r |= bits_##sfx(x) << (16 * l); \
        } \
        return r; \
    }
SCALAR(f16h, h)
#if T8_COMPILED_ALT
SCALAR(f16a, a)
#endif

static volatile uint32_t VIN[3];          /* a, b, c: read at run time, so nothing is folded */

NI static uint32_t packed_h(int e)
{
    union { v2h v; uint32_t u; } a, b, c, r;
    a.u = VIN[0]; b.u = VIN[1]; c.u = VIN[2];
    r.v = e == 0 ? c_msub_h(a.v, b.v, c.v) : e == 1 ? c_nmsub_h(a.v, b.v, c.v) : c_madd_h(a.v, b.v, c.v);
    return r.u;
}
#if T8_COMPILED_ALT
NI static uint32_t packed_a(int e)
{
    union { v2a v; uint32_t u; } a, b, c, r;
    a.u = VIN[0]; b.u = VIN[1]; c.u = VIN[2];
    r.v = e == 0 ? c_msub_a(a.v, b.v, c.v) : e == 1 ? c_nmsub_a(a.v, b.v, c.v) : c_madd_a(a.v, b.v, c.v);
    return r.u;
}
#else
static uint32_t packed_a(int e) { (void)e; return 0; }
static uint32_t ref_a(int e, uint32_t a, uint32_t b, uint32_t c) { (void)e; (void)a; (void)b; (void)c; return 0; }
#endif

static const char *const expr_name[3] = { "a*b-c", "c-a*b", "a*b+c" };
static const int expr_cls[3] = { OP_AB_MINUS_RD * 3, OP_RD_MINUS_AB * 3, OP_RD_PLUS_AB * 3 };

/* cmp[][] values */
enum { CMP_MISMATCH, CMP_MATCH, CMP_NOT_BUILT };
static const char *const cmp_name[3] = { "MISMATCH", "MATCH", "not built" };

static void run_compiled(core_res_t *R, const char *core)
{
    for (int alt = 0; alt < 2; alt++) {
        if (alt && !T8_COMPILED_ALT) {
            for (int e = 0; e < 3; e++) R->cmp[alt][e] = CMP_NOT_BUILT;
            printf("INFO core=%s compiled float16alt: not built (this compiler has no float16alt arithmetic "
                   "without a helper library)\n", core);
            continue;
        }
        const in_t *s = &ins[0];
        uint32_t a = encv(s->a[0], s->a[1], alt), b = encv(s->b[0], s->b[1], alt), c = encv(s->d[0], s->d[1], alt);
        VIN[0] = a; VIN[1] = b; VIN[2] = c;
        for (int e = 0; e < 3; e++) {
            uint32_t pk = alt ? packed_a(e) : packed_h(e);
            uint32_t sc = alt ? ref_a(e, a, b, c) : ref_h(e, a, b, c);
            uint32_t ex = model(expr_cls[e], s, alt);
            R->cmp[alt][e] = pk == sc ? CMP_MATCH : CMP_MISMATCH;
            printf("RESULT t8 core=%s compiled %s %s packed=0x%08x scalar_lanes=0x%08x exact=0x%08x %s%s\n",
                   core, alt ? "float16alt" : "float16", expr_name[e], (unsigned)pk, (unsigned)sc, (unsigned)ex,
                   pk == sc ? "MATCH" : "MISMATCH", sc == ex ? "" : " (the scalar reference is not the exact value!)");
        }
    }
}

/* First instruction in a function with (insn & mask) == match, 0 if none (scans at most maxb
 * bytes, stops at the first c.jr ra / jalr x0,0(ra)). */
static uint32_t find_insn(const void *fn, uint32_t mask, uint32_t match, unsigned maxb)
{
    const uint8_t *p = (const uint8_t *)fn;
    unsigned off = 0;
    while (off < maxb) {
        uint32_t lo = p[off] | ((uint32_t)p[off + 1] << 8);
        if ((lo & 3) != 3) {
            if (lo == 0x8082) break;
            off += 2; continue;
        }
        uint32_t w = lo | ((uint32_t)p[off + 2] << 16) | ((uint32_t)p[off + 3] << 24);
        if (w == 0x00008067) break;
        if ((w & mask) == match) return w;
        off += 4;
    }
    return 0;
}
static uint32_t code_word(probe_fn f) { return find_insn((const void *)(uintptr_t)f, 0, 0, 4); }

#define REGMASK 0xfe00707fu               /* funct7, funct3, opcode: everything but the registers */

/* Which of vfmre / vfmac the compiler put into one of the packed functions above. */
static void scan_compiled(const char *what, const void *fn, int alt)
{
    uint32_t mre = find_insn(fn, REGMASK, probes[alt ? I_MRE_AH : I_MRE_H].word & REGMASK, 512);
    uint32_t mac = find_insn(fn, REGMASK, probes[alt ? I_MAC_AH : I_MAC_H].word & REGMASK, 512);
    printf("RESULT t8 compiled_code %s %s: %s=0x%08x %s=0x%08x (0 = not used; same opcode bits as the probes "
           "under mask 0x%08x)\n", alt ? "float16alt" : "float16", what, alt ? "vfmre.ah" : "vfmre.h", (unsigned)mre,
           alt ? "vfmac.ah" : "vfmac.h", (unsigned)mac, (unsigned)REGMASK);
}

/* ---------------------------------------------------------------- driver */

static void run_main(void *arg)
{
    (void)arg;
    int fc = pack_is_fc();
    if (!fc) printf("INFO cluster task runs on cluster %d core %d (the cluster controller)\n", (int)pi_cluster_id(),
                    (int)pi_core_id());
    const char *core = fc ? "fc" : "cl";
    core_res_t *R = &res[fc];
    run_probes(R, core, 0, N_MAIN);
    run_compiled(R, core);
    printf("VERDICT B151 probes on %s: vfmre.h computes %s%s; vfmre.ah %s%s; control vfmac.h %s%s; vfmac.ah %s%s\n",
           core, cls_op(R->cls[I_MRE_H]), cls_rep(R->cls[I_MRE_H]), cls_op(R->cls[I_MRE_AH]), cls_rep(R->cls[I_MRE_AH]),
           cls_op(R->cls[I_MAC_H]), cls_rep(R->cls[I_MAC_H]), cls_op(R->cls[I_MAC_AH]), cls_rep(R->cls[I_MAC_AH]));
    printf("VERDICT B151 compiled code on %s: float16 a*b-c %s, c-a*b %s, a*b+c %s; float16alt a*b-c %s, c-a*b %s, "
           "a*b+c %s (packed against scalar lanes)\n", core,
           cmp_name[(int)R->cmp[0][0]], cmp_name[(int)R->cmp[0][1]], cmp_name[(int)R->cmp[0][2]],
           cmp_name[(int)R->cmp[1][0]], cmp_name[(int)R->cmp[1][1]], cmp_name[(int)R->cmp[1][2]]);
    R->ran = 1;
}

static void run_r(void *arg)
{
    (void)arg;
    int fc = pack_is_fc();
    run_probes(&res[fc], fc ? "fc" : "cl", N_MAIN, N_PROBES);
    res[fc].ran_r = 1;
}

/* 0 / 1: this core's probes say vfmre.h computes rd - a*b / a*b - rd, with vfmre.ah the same,
 * both vfmac controls = rd + a*b and the fixed words = the mnemonics. -1: anything else. */
static int core_answer(const core_res_t *R)
{
    int c = R->cls[I_MRE_H];
    if (!R->ran || R->word_ne_mnemonic) return -1;
    if (R->cls[I_MAC_H] != OP_RD_PLUS_AB * 3 || R->cls[I_MAC_AH] != OP_RD_PLUS_AB * 3) return -1;
    if (c != R->cls[I_MRE_AH]) return -1;
    return c == OP_RD_MINUS_AB * 3 ? 0 : c == OP_AB_MINUS_RD * 3 ? 1 : -1;
}

int main(void)
{
    pack_banner("t8_vfmre_sign_b151");
    for (int k = 0; k < 2; k++) for (int i = 0; i < N_PROBES; i++) res[k].cls[i] = CLS_NONE;
    printf("INFO CHECK PASS = the probe ran and matched exactly one candidate. It does not say who is right: "
           "read the VERDICT lines\n");
    printf("INFO probes are `<op> a0, a1, a2` (rd = a0, rs1 = a1 = a, rs2 = a2 = b); lanes {lane 0, lane 1}, "
           "lane 0 = low half\n");
    for (int s = 0; s < NSETS; s++)
        printf("INFO set=%d rd={%d,%d} a={%d,%d} b={%d,%d}\n", s, ins[s].d[0], ins[s].d[1], ins[s].a[0], ins[s].a[1],
               ins[s].b[0], ins[s].b[1]);

    /* The fixed words against what the assembler emits for the mnemonics. */
    int enc_same = 1;
    for (int i = 0; i < N_PROBES; i++) {
        uint32_t w = code_word(probes[i].w), m = code_word(probes[i].m);
        if (w != m || w != probes[i].word) enc_same = 0;
        printf("RESULT t8 encoding %s a0,a1,a2: probe word=0x%08x assembler=0x%08x %s\n", probes[i].mn, (unsigned)w,
               (unsigned)m, w == m && w == probes[i].word ? "same" : "DIFFERENT");
    }
    pack_check("t8.probe_words_are_the_assembler_encodings", enc_same, 1);
    /* What this compiler emitted for the packed C expressions. */
    scan_compiled("a*b-c", (const void *)(uintptr_t)c_msub_h, 0);
    scan_compiled("c-a*b", (const void *)(uintptr_t)c_nmsub_h, 0);
#if T8_COMPILED_ALT
    scan_compiled("a*b-c", (const void *)(uintptr_t)c_msub_a, 1);
    scan_compiled("c-a*b", (const void *)(uintptr_t)c_nmsub_a, 1);
#endif

    /* The cluster is opened once and gets two tasks (the main probes now, the .r controls at the
     * very end), so this test does not use pack_run_on_cluster(), which opens and closes it. */
    struct pi_device cluster_dev;
    struct pi_cluster_conf conf;
    struct pi_cluster_task task;
    pi_cluster_conf_init(&conf);
    conf.id = 0;
    pi_open_from_conf(&cluster_dev, &conf);
    int have_cl = pi_cluster_open(&cluster_dev) == 0;
    if (have_cl) {
        pi_cluster_task(&task, run_main, 0);
        pi_cluster_send_task_to_cl(&cluster_dev, &task);
    } else
        printf("INFO cluster open FAILED\n");
    printf("INFO starting the FC part; if the output stops here, the FC does not implement the packed fp16 "
           "multiply-accumulate (the cluster VERDICT lines above are the answer)\n");
    pack_run_on(PACK_ON_FC, run_main, 0);

    int cl = core_answer(&res[0]), fc = core_answer(&res[1]);
    if (cl == 0 && fc == 0)
        printf("VERDICT B151: vfmre.h and vfmre.ah compute rd - a*b on this target (same as GVSoC) => if this is the "
               "board, GAP9 GCC emits the wrong instruction for a*b - c\n");
    else if (cl == 1 && fc == 1)
        printf("VERDICT B151: vfmre.h and vfmre.ah compute a*b - rd on this target (not what GVSoC does) => if this is "
               "the board, GVSoC models vfmre with the wrong sign and GAP9 GCC's code is right\n");
    else
        printf("VERDICT B151: inconclusive (cl: vfmre.h %s%s, vfmre.ah %s%s, vfmac.h %s%s, vfmac.ah %s%s; "
               "fc: vfmre.h %s%s, vfmre.ah %s%s, vfmac.h %s%s, vfmac.ah %s%s; word/mnemonic results differ: cl %d fc %d)\n",
               cls_op(res[0].cls[I_MRE_H]), cls_rep(res[0].cls[I_MRE_H]), cls_op(res[0].cls[I_MRE_AH]), cls_rep(res[0].cls[I_MRE_AH]),
               cls_op(res[0].cls[I_MAC_H]), cls_rep(res[0].cls[I_MAC_H]), cls_op(res[0].cls[I_MAC_AH]), cls_rep(res[0].cls[I_MAC_AH]),
               cls_op(res[1].cls[I_MRE_H]), cls_rep(res[1].cls[I_MRE_H]), cls_op(res[1].cls[I_MRE_AH]), cls_rep(res[1].cls[I_MRE_AH]),
               cls_op(res[1].cls[I_MAC_H]), cls_rep(res[1].cls[I_MAC_H]), cls_op(res[1].cls[I_MAC_AH]), cls_rep(res[1].cls[I_MAC_AH]),
               res[0].word_ne_mnemonic, res[1].word_ne_mnemonic);

    /* The .r (rs2 lane 0 replicated) forms come last: they are only extra controls, and if a
     * core does not implement them the answer above is already printed. */
    printf("INFO starting the .r controls (vfmre.r.h, vfmac.r.h, .r.ah) on the FC, then on the cluster; if the "
           "output stops here, that core does not implement them (the VERDICT above stands)\n");
    pack_run_on(PACK_ON_FC, run_r, 0);
    if (have_cl) {
        pi_cluster_task(&task, run_r, 0);
        pi_cluster_send_task_to_cl(&cluster_dev, &task);
        pi_cluster_close(&cluster_dev);
    }
    return pack_end("t8_vfmre_sign_b151");
}
