/* Stop-gap definitions of GAP9 GCC builtins our clang does not have yet.
 * Force-included by bin/riscv32-unknown-elf-clang when GAP_CLANG_COMPAT=1.
 * Each block disables itself once clang provides the builtin (__has_builtin),
 * so it is safe to keep using after task 20/F016 lands.
 *
 * Semantics follow what GAP9 GCC 7.1.1 emits (-O2):
 *   __builtin_pulp_event_unit_read_fenced(base, IMM)  -> p.elw rd, IMM(base)
 *     (GCC rejects a non-immediate offset; volatile, never merged/hoisted)
 *   __builtin_pulp_OffsetedWritePtr(value, base, off) -> p.sw value, off(base)
 *     ("Offseted Write volatile": a volatile pointer-sized store)
 */
#ifndef GAP9_CLANG_COMPAT_H
#define GAP9_CLANG_COMPAT_H

#if !defined(__ASSEMBLER__) && defined(__clang__)

#if !__has_builtin(__builtin_pulp_event_unit_read_fenced)
#define __builtin_pulp_event_unit_read_fenced(base, offset)                  \
  ({                                                                         \
    unsigned int __gap_v;                                                    \
    __asm__ __volatile__("p.elw %0, %2(%1)"                                  \
                         : "=r"(__gap_v)                                     \
                         : "r"(base), "i"(offset)                            \
                         : "memory");                                        \
    __gap_v;                                                                 \
  })
#endif

#if !__has_builtin(__builtin_pulp_OffsetedWritePtr)
#define __builtin_pulp_OffsetedWritePtr(value, base, offset)                 \
  ((void)(*(int *volatile *)((char *)(base) + (offset)) = (int *)(value)))
#endif

/* GAP9 GCC folds __builtin_pulp_CoreCount() to the -mPE=N value (the SDK
 * always passes -mPE=8).  Our clang lowers it to a run-time load
 * (RISCVInstrInfoXpulp.td: ANDI (LW (LUI 0x1A103), 0), 0x12), which on GAP9
 * yields 0, so pi_cl_team_fork() runs the team on zero cores (the helloworld
 * cluster printf never happens).  The wrapper turns -mPE=N into
 * -D__GAP9_CLANG_PE__=N; mimic GCC until task 20/F018 lands. */
#if defined(__GAP9_CLANG_PE__)
#define __builtin_pulp_CoreCount() (__GAP9_CLANG_PE__)
#endif

/* PROBE ONLY (GAP_CLANG_FP16PROBE=1 -> -D__GAP9_CLANG_FP16PROBE__):
 * GAP9 GCC has built-in types float16 (IEEE half) and float16alt (PULP's
 * 1-8-7 "alt" half, bfloat16 layout).  Our clang has neither.  Map them to
 * _Float16 (with +zhinx) and __bf16 so that code behind them can be compiled
 * and linked.  __bf16 arithmetic is promoted to float by clang, GCC emits
 * native .ah instructions: rounding differs, so results are NOT comparable. */
#if defined(__GAP9_CLANG_FP16PROBE__)
typedef _Float16 float16;
typedef __bf16 float16alt;
#endif

#endif /* !__ASSEMBLER__ && __clang__ */
#endif /* GAP9_CLANG_COMPAT_H */
