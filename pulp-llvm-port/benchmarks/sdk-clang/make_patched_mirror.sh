#!/usr/bin/env bash
# Build a second SDK mirror, $SDK_CLANG_WORK/sdkp, whose rtos/ is a COPY with the
# minimal assembler-source changes that let clang's integrated assembler (and so
# an all-LLVM link with ld.lld) handle the GAP9 runtime's hand-written .S files.
# This is the "what the SDK would need to change" experiment; the SDK itself is
# never touched.  Changes (all semantics-preserving):
#   1. drop .func/.endfunc (GNU-as STABS-only directives, unknown to LLVM MC)
#   2. %tiny(sym) -> %lo(sym): GAP binutils' %tiny emits GAP-private relocations
#      R_RISCV_12_I/R_RISCV_12_S (numbers 59/60; 60 is R_RISCV_SET_ULEB128
#      upstream).  The tiny symbols live in the 0x4..0x7FF aliased window, where
#      %lo(sym)(x0) encodes the same instruction (only the range check is lost).
#   3. p.mul rd,rs1,rs2 -> mul (GNU-as alias; GNU as emits plain mul)
#   4. p.lw rd, IMM(rs) without '!' -> lw (GNU-as alias; GNU as emits plain lw)
#   5. gap_iet.S: ".weak default_handler" moved after DECLARE (which does .global):
#      GNU as keeps the symbol WEAK, LLVM MC errors on weak->global.
#   6. (link-order bug, not an assembler issue) os/freeRTOS/vendors/gwt/libs/
#      include/stdlib.h declares system_exit() weak, which makes the real
#      definition in implem/rtos/os/system_gap.c weak too.  The stub in
#      libs/src/stdlib.c (explicitly weak, no semihosting exit) is the second
#      weak definition; GNU ld keeps system_gap.c's, ld.lld keeps the stub, and
#      then the app never leaves GVSoC after main() returns.  Drop the weak
#      attribute from the declaration so the real one is strong.
set -euo pipefail
W=${SDK_CLANG_WORK:-/tmp/sdk-clang-work}
SDK=${SDK:-/home/ubuntu/gap_sdk_release}
P=$W/sdkp
rm -rf "$P"; mkdir -p "$P"
for e in $(ls -A "$W/sdk"); do
  [ "$e" = rtos ] && continue
  ln -s "$(readlink -f "$W/sdk/$e")" "$P/$e"
done
cp -a "$SDK/rtos" "$P/rtos"
cd "$P/rtos"
FILES=$(grep -rlE '^\s*\.(end)?func\b|%tiny\(|\bp\.mul\b|^\s*p\.lw\s' --include=*.S . || true)
for f in $FILES; do
  sed -i -E 's/^(\s*)\.(end)?func\b.*$/\1/; s/%tiny\(/%lo(/g; s/\bp\.mul(\s)/mul\1/' "$f"
  # p.lw rd, imm(rs) (no '!' post-increment, immediate offset) -> lw
  sed -i -E '/!/! s/^(\s*)p\.lw(\s+[a-z0-9]+\s*,\s*[A-Z_0-9+ ]+\([a-z0-9]+\))/\1lw\2/' "$f"
done
# macro bodies: ".func \Routine" inside .macro DECLARE was removed by rule 1.
f=pmsis/implem/chips/gap9/gap_iet.S
python3 - "$f" <<'PY'
import sys,re
p=sys.argv[1]; s=open(p).read()
s=s.replace("\t.weak default_handler\n\tDECLARE default_handler\n",
            "\tDECLARE default_handler\n\t.weak default_handler\n")
open(p,'w').write(s)
PY
f=os/freeRTOS/vendors/gwt/libs/include/stdlib.h
sed -i 's/^void __attribute__((weak)) system_exit(int32_t status);/void system_exit(int32_t status);/' "$P/rtos/pmsis/$f"
grep -q '^void system_exit(int32_t status);' "$P/rtos/pmsis/$f"
echo "patched: $(echo $FILES | wc -w) files"; (cd "$P/rtos" && diff -r "$SDK/rtos" . | grep -c '^[<>]') || true
