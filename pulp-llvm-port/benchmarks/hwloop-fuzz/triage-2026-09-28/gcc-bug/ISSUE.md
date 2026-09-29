# GAP9 GCC 7.1.1: hardware loop gets count 1 instead of register at -O2/-O3 (wrong result)

Hello,

we found a miscompilation in GAP9 GCC when hardware loops are enabled. At `-O2` and `-O3` a loop whose count is in a register is compiled with `lp.setupi x1,1`, so the loop runs only once and the program gives a wrong result, without any warning.

**Toolchain:** `riscv32-unknown-elf-gcc (GCC) 7.1.1 20170509`, flags `-march=rv32imcxgap9 -O2` (or `-O3`)

## Test program

```c
#include <stdio.h>

__attribute__((noinline))
unsigned checksum(const unsigned char *buf, unsigned len, unsigned rounds) {
  unsigned acc = 0, key = 0;
  if (len) key = 5;
  for (unsigned r = 0; r < rounds; r++) key ^= 79u;
  for (unsigned i = 0; i < len; i++) acc += buf[i];
  return acc ^ key;
}

unsigned char data[4] = {1, 2, 3, 4};
volatile unsigned vlen = 4, vrounds = 3;

int main(void) {
  printf("checksum = 0x%x\n", checksum(data, vlen, vrounds));
  return 0;
}
```

The problem needs the loop count as the second argument (register `a1`), like in the usual `func(const T *buf, unsigned len, ...)` shape.

## Results

| flags | result |
|---|---|
| `-O0` | `0x40` ✅ |
| `-O1` | `0x40` ✅ |
| `-O2` | `0x4b` ❌ |
| `-O3` | `0x4b` ❌ |
| `-Os` | `0x40` ✅ |
| `-O2 -mnohwloop` | `0x40` ✅ |

The correct result is `0x40`: the sum 1+2+3+4 = 10, the key 5^79^79^79 = 74, and 10^74 = 0x40. With `0x4b` only the first byte was added (1^74 = 0x4b), so the byte loop was executed only once. Host gcc also gives `0x40`. Tested on GVSoC (ri5ky_testbench).

It is also reproduced with the same flags used by the GAP9 SDK build, for example:

```
riscv32-unknown-elf-gcc -march=rv32imcxgap9 -mPE=8 -mFC=1 -mint64 -O3 -std=gnu99 -fno-exceptions -funsigned-char -fno-jump-tables -fdata-sections -ffunction-sections -fcommon -fno-delete-null-pointer-checks -fno-tree-loop-distribute-patterns -fomit-frame-pointer -fmessage-length=0 -Wall -Wextra -Werror -Wno-unused-function -Wno-unused-parameter -Wno-unused-variable -Wno-unused-but-set-variable -Wno-implicit-fallthrough -Wno-discarded-qualifiers -S issue-standalone.c
```

This gives the same `lp.setupi x1,1`. With `-Os` (the SDK default) GCC does not generate hardware loops, so it is not affected, but the SDK compiles many DSP and audio files with `-O3`.

## Generated code (-O2)

```
checksum:
	beqz	a1,.L21
	li	a5,5
	beqz	a2,.L8
	beqz	a2,.L22
	lp.setup  x1,a2,(.L27)     # first loop: count in a2, correct
	xor	a5,a5,79
	nop
	/* loop end a2 .L4 */
	beqz	a1,.L1
	li	a4,0
	beqz	a1,.L23
	lp.setupi x1,1,(.L25)      # second loop: count is the constant 1
	p.lbu	a3,1(a0!)
	add	a4,a4,a3
	/* loop end a1 .L6 */      # but the loop count is in a1 (= len)
	xor	a5,a5,a4
	mv	a0,a5
	ret
```

For the second loop we expect `lp.setup x1,a1,(.L25)`. Also the `li a1,1` on the `len == 0` path is removed, but it should stay there.

## What we think happens (from `-fdump-rtl-all`)

1. `loop2_doloop` creates two definitions of the count register: `count = len - i`, and `count = 1` on the `len == 0` path.
2. `cse2` simplifies the first one to `count = len`.
3. The register allocator puts the count in `a1`, the same register as the argument `len`, and deletes the copy `a1 = a1`. Now the only instruction writing `a1` in the function is `a1 = 1`.
4. In `mach`, the GAP9 hardware loop code prints `Iter reg is defined once and only once` and `init_iter_is_constant=yes, 1`, and emits `lp.setupi x1,1`.

We think the check in step 4 only counts the instructions that write the register. It does not see that `a1` also holds the argument `len` from the function entry, on the other path into the loop.

## How we found it

We compare different compilers on many small random C programs with loops, running them on GVSoC. A few programs gave a different result only with GAP9 GCC at `-O2` with hardware loops enabled; with `-mnohwloop`, with `-O0` and with other compilers the result was the same. We reduced them to the program above. It happens in about 0.2% of our generated programs.

## Workaround

`-mnohwloop`, but then no hardware loops are used.

---

Attached: the test program (`issue-standalone.c`), the generated assembly (`issue-standalone.O2.s`), and an excerpt of the `.299r.mach` dump (`issue-standalone.299r.mach.excerpt.txt`).

Thank you!
