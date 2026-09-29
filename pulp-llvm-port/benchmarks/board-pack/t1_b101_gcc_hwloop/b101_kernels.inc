/* B101: GAP9 GCC 7.1.1 hardware-loop miscompile (count register replaced by the constant 1).
 * Included by b101_<variant>.c with PACK_SFX defined; each variant is compiled with different
 * GCC options (see CMakeLists.txt). Both functions are verbatim from
 * benchmarks/hwloop-fuzz/triage-2026-09-28/gcc-bug/ (issue-standalone.c = checksum,
 * issue-standalone-gvsoc.c = kern); only the names get the variant suffix. */
#define PACK_CAT2(a, b) a##b
#define PACK_CAT(a, b) PACK_CAT2(a, b)

/* issue-standalone.c: correct result 0x40 (1+2+3+4 = 10, key 5^79^79^79 = 74, 10^74 = 0x40).
 * With the bug the byte loop runs once: 1^74 = 0x4b. */
__attribute__((noinline))
unsigned PACK_CAT(checksum_, PACK_SFX)(const unsigned char *buf, unsigned len, unsigned rounds) {
  unsigned acc = 0, key = 0;
  if (len) key = 5;
  for (unsigned r = 0; r < rounds; r++) key ^= 79u;
  for (unsigned i = 0; i < len; i++) acc += buf[i];
  return acc ^ key;
}

/* issue-standalone-gvsoc.c (kern): correct result 0x4c (0+1+2+3 = 6, 6^74 = 0x4c).
 * With the bug the sum loop runs once: 0^74 = 0x4a. */
__attribute__((noinline))
unsigned PACK_CAT(kern_, PACK_SFX)(unsigned *unused, unsigned n, unsigned k) {
  unsigned s = 0, t = 0;
  if (n) t = 5;
  for (unsigned i = 0; i < k; i++) t ^= 79u;
  for (unsigned i = 0; i < n; i++) s += i;
  return s ^ t;
}
