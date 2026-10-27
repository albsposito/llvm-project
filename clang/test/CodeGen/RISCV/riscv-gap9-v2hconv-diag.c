// RUN: %clang_cc1 -triple riscv32 -target-feature +zfinx -target-feature +zhinx \
// RUN:     -target-feature +xpulpv -target-feature +xpulpfvec -fsyntax-only -verify=gap9 -DGAP9 %s
// RUN: %clang_cc1 -triple riscv32 -target-feature +zfinx -target-feature +zhinx \
// RUN:     -target-feature +xpulpv -emit-llvm-only -verify=nofvec %s

// Task 20/F049 (backlog B149): the four builtins exist under xpulpfvec+zhinx
// (GAP9), with GAP9 GCC's prototypes, so a wrong argument type is diagnosed
// instead of becoming an implicit declaration; without xpulpfvec they are
// rejected.

typedef _Float16 v2h __attribute__((vector_size(4)));
typedef short v2s __attribute__((vector_size(4)));

#ifdef GAP9
#if !__has_builtin(__builtin_pulp_v2hftov2hi) || !__has_builtin(__builtin_pulp_v2hftov2hi_u) || \
    !__has_builtin(__builtin_pulp_v2hitov2hf) || !__has_builtin(__builtin_pulp_v2hitov2hf_u)
#error "missing builtin"
#endif

void bad(int *p) {
  (void)__builtin_pulp_v2hftov2hi(p);   // gap9-error {{passing 'int *' to parameter of incompatible type}}
  (void)__builtin_pulp_v2hftov2hi_u(p); // gap9-error {{passing 'int *' to parameter of incompatible type}}
  (void)__builtin_pulp_v2hitov2hf(p);   // gap9-error {{passing 'int *' to parameter of incompatible type}}
  (void)__builtin_pulp_v2hitov2hf_u(p); // gap9-error {{passing 'int *' to parameter of incompatible type}}
}
#endif

void ok(v2h h, v2s s, v2s *ps, v2h *ph) {
  ps[0] = __builtin_pulp_v2hftov2hi(h);   // nofvec-error {{'__builtin_pulp_v2hftov2hi' needs target feature xpulpfvec,zhinx}}
  ps[1] = __builtin_pulp_v2hftov2hi_u(h); // nofvec-error {{'__builtin_pulp_v2hftov2hi_u' needs target feature xpulpfvec,zhinx}}
  ph[0] = __builtin_pulp_v2hitov2hf(s);   // nofvec-error {{'__builtin_pulp_v2hitov2hf' needs target feature xpulpfvec,zhinx}}
  ph[1] = __builtin_pulp_v2hitov2hf_u(s); // nofvec-error {{'__builtin_pulp_v2hitov2hf_u' needs target feature xpulpfvec,zhinx}}
}
