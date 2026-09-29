/* Runtime-benchmark driver helpers, board-pack version of benchmarks/gap9-sweep/runtime/rt.h.
 * Only the I/O and counter functions differ: they call pack_k_* functions that the PMSIS app
 * (main.c, built by GAP9 GCC through the SDK) provides, so the kernel library itself (drivers +
 * kernels, built by GAP9 GCC or by our clang) has no PMSIS dependency. Timing, data generation,
 * hashing and the RESULT line are the same as in the GVSoC sweep, so checksums are comparable
 * with benchmarks/gap9-sweep/runtime/runtime_results.json.
 *
 * All loop trip counts in drivers come from volatile globals (rt_n). */
#pragma once
#include <stdint.h>
extern uint32_t pack_k_cycles(void);        /* PCCR active cycles of the calling core */
extern uint32_t pack_k_instr(void);         /* PCCR retired instructions */
extern void pack_k_puts(const char *s);
extern void pack_k_u32(uint32_t v);
extern void pack_k_hex(uint32_t v);
extern const char *pack_k_tag(void);        /* "core=fc lib=clang-O2" etc. */
extern void pack_k_abort(int code) __attribute__((noreturn));  /* replaces bench_exit() */
#define bench_exit(c) pack_k_abort(c)
extern void pack_k_result(const char *kernel, uint32_t checksum, uint32_t cycles, uint32_t instrs);
static inline uint64_t rt_cycles(void) { return pack_k_cycles(); }
static inline uint32_t rt_instr(void) { return pack_k_instr(); }
static inline uint32_t rt_pcycles(void) { return pack_k_cycles(); }
static inline void rt_puts(const char *s) { pack_k_puts(s); }
static inline void rt_u64(uint64_t v) { pack_k_u32((uint32_t)v); }
static inline void rt_hex(uint32_t v) { pack_k_hex(v); }

#ifndef RT_REPS
#define RT_REPS 4
#endif
/* volatile so the compiler cannot see the trip counts */
static volatile uint32_t rt_reps_v = RT_REPS;
static inline uint32_t rt_n(uint32_t n) { volatile uint32_t v = n; return v; }

/* Untimed helpers (fill/hash/dump) are optnone under clang: ref-18 and port-19 crash in the
 * "PULP Hardware Loops" pass on these simple runtime-trip-count loops (the fork's known bug the
 * static sweep hit in k12 sum_loop etc.). They run outside the timed region, so this does not
 * affect any measurement. GCC builds them normally. */
#ifdef __clang__
#define RT_UNTIMED __attribute__((noinline, optnone))
#else
#define RT_UNTIMED __attribute__((noinline))
#endif

/* xorshift32, fixed seed per buffer */
static uint32_t rt_state;
static inline void rt_seed(uint32_t s) { rt_state = s ? s : 0x9e3779b9u; }
static inline uint32_t rt_rand(void)
{
    uint32_t x = rt_state;
    x ^= x << 13; x ^= x >> 17; x ^= x << 5;
    return rt_state = x;
}
/* uniform integer in [lo, hi] (hi - lo < 2^16) */
static inline int32_t rt_range(int32_t lo, int32_t hi) { return lo + (int32_t)((rt_rand() >> 8) % (uint32_t)(hi - lo + 1)); }

RT_UNTIMED static void rt_fill_i8(int8_t *p, uint32_t n, int32_t lo, int32_t hi)
{ for (uint32_t i = 0; i < n; i++) p[i] = (int8_t)rt_range(lo, hi); }
RT_UNTIMED static void rt_fill_i16(int16_t *p, uint32_t n, int32_t lo, int32_t hi)
{ for (uint32_t i = 0; i < n; i++) p[i] = (int16_t)rt_range(lo, hi); }
RT_UNTIMED static void rt_fill_i32(int32_t *p, uint32_t n, int32_t lo, int32_t hi)
{ for (uint32_t i = 0; i < n; i++) p[i] = rt_range(lo, hi); }
RT_UNTIMED static void rt_fill_u32(uint32_t *p, uint32_t n)
{ for (uint32_t i = 0; i < n; i++) p[i] = rt_rand(); }
/* floats in [-1, 1) with 16 fractional bits: exactly representable */
RT_UNTIMED static void rt_fill_f32(float *p, uint32_t n)
{ for (uint32_t i = 0; i < n; i++) p[i] = (float)rt_range(-32768, 32767) * (1.0f / 32768.0f); }

/* FNV-1a over bytes (little-endian layout on both target and host) */
RT_UNTIMED static uint32_t rt_hash(const void *p, uint32_t n)
{
    const uint8_t *b = (const uint8_t *)p; uint32_t h = 2166136261u;
    for (uint32_t i = 0; i < n; i++) { h ^= b[i]; h *= 16777619u; }
    return h;
}

/* Timing: one warm-up call, then RT_REPS timed calls. */
#define RT_BENCH(body) do {                                                    \
        body;                                                                  \
        uint32_t _reps = rt_reps_v;                                            \
        uint32_t _i0 = rt_instr(), _p0 = rt_pcycles();                         \
        uint64_t _c0 = rt_cycles();                                            \
        for (uint32_t _r = 0; _r < _reps; _r++) { body; }                      \
        uint64_t _c1 = rt_cycles();                                            \
        uint32_t _p1 = rt_pcycles(), _i1 = rt_instr();                         \
        rt_c = _c1 - _c0; rt_i = _i1 - _i0; rt_pc = _p1 - _p0; rt_r = _reps;   \
    } while (0)
static uint64_t rt_c; static uint32_t rt_i, rt_pc, rt_r;

RT_UNTIMED static void rt_result(const char *k, uint32_t cks)
{
    rt_puts("RESULT t6 "); rt_puts(pack_k_tag()); rt_puts(" kernel="); rt_puts(k);
    rt_puts(" cycles="); rt_u64((uint32_t)rt_c / rt_r);
    rt_puts(" instrs="); rt_u64(rt_i / rt_r);
    rt_puts(" checksum="); rt_hex(cks);
    rt_puts(" reps="); rt_u64(rt_r);
    rt_puts(" total_cycles="); rt_u64(rt_c);
    rt_puts(" pccr_cycles="); rt_u64(rt_pc);
    rt_puts("\n");
    pack_k_result(k, cks, (uint32_t)rt_c / rt_r, rt_i / rt_r);
}
/* Raw float dump: disabled on the board (the checksum covers the output; the GVSoC sweep found
 * every LLVM and GCC build bit-exact on these kernels). Build with -DPACK_DUMP to print it. */
RT_UNTIMED static void rt_dump_f32(const float *p, uint32_t n)
{
#ifdef PACK_DUMP
    rt_puts("OUTF");
    for (uint32_t i = 0; i < n; i++) { union { float f; uint32_t u; } c; c.f = p[i]; rt_puts(" "); rt_hex(c.u); }
    rt_puts("\n");
#else
    (void)p; (void)n;
#endif
}
