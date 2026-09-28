// RUN: %clang_cc1 -triple riscv32 -target-feature +xpulpv -fsyntax-only -verify %s

// Guards 20/F001: the rounding argument of the PULP *RN builtins must equal
// 2^(Norm-1), computed from the Norm argument (GAP9 GCC rule; the SDK's
// GapBuiltins.h always passes (n), (1<<((n)-1))). Norm itself is in [0, 31].

void rn_valid(int a, int b, int c, unsigned ua) {
  (void)__builtin_pulp_mulsRN(a, b, 15, 1 << 14);
  (void)__builtin_pulp_macsRN(a, b, c, 15, 1 << 14);
  (void)__builtin_pulp_adduRN(ua, 0, 8, 1 << 7);
  (void)__builtin_pulp_addRN(a, b, 31, 1u << 30);
}

void rn_invalid(int a, int b, int c) {
  (void)__builtin_pulp_mulsRN(a, b, 15, 1 << 13); // expected-error {{argument value 8192 is outside the valid range [16384, 16384]}}
  (void)__builtin_pulp_mulsRN(a, b, 32, 1 << 14); // expected-error {{argument value 32 is outside the valid range [0, 31]}}
  (void)__builtin_pulp_macsRN(a, b, c, 2, 1); // expected-error {{argument value 1 is outside the valid range [2, 2]}}
}
