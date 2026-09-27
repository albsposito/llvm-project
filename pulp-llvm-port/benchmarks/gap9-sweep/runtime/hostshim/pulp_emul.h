/* Host (x86-64 gcc) plain-C models of the few __builtin_pulp_* calls used directly by the
 * sweep's own TUs (clip.c, 19-vs-18/kernels.c). Hand-written from the PULP ISA definitions
 * (p.clip clamps to [lo,hi]; pv.sdotsp.{b,h} signed dot product + accumulate; pv.max.b
 * signed per-byte max; p.extractu zero-extended bit field). Forced in with -include. */
#pragma once
static inline int hemu_clamp(int x, int lo, int hi) { return x < lo ? lo : x > hi ? hi : x; }
#define __builtin_pulp_clip(x, lo, hi)  hemu_clamp((x), (lo), (hi))
#define __builtin_pulp_clipu(x, lo, hi) ((unsigned)hemu_clamp((x), (lo), (hi)))
#define __builtin_pulp_max4(a, b) ({ __typeof__(a) _a = (a), _b = (b), _r; \
    for (int _i = 0; _i < 4; _i++) _r[_i] = _a[_i] > _b[_i] ? _a[_i] : _b[_i]; _r; })
#define __builtin_pulp_sdotsp4(a, b, acc) ({ __typeof__(a) _a = (a), _b = (b); int _s = (acc); \
    for (int _i = 0; _i < 4; _i++) _s += (int)_a[_i] * (int)_b[_i]; _s; })
#define __builtin_pulp_sdotsp2(a, b, acc) ({ __typeof__(a) _a = (a), _b = (b); int _s = (acc); \
    for (int _i = 0; _i < 2; _i++) _s += (int)_a[_i] * (int)_b[_i]; _s; })
#define __builtin_pulp_bextractu(a, size, off) ((((unsigned)(a)) >> (off)) & ((1u << (size)) - 1u))
