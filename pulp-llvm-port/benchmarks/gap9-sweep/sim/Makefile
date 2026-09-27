# Build the validation programs with both GAP9 GCC and port-20 clang.
SIM      := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
GAPTC    ?= /home/ubuntu/gap_riscv_toolchain_ubuntu
LLVMBIN  ?= /home/ubuntu/llvm-project/pulp-llvm-port/toolchains/port-20/bin
GCC      := $(GAPTC)/bin/riscv32-unknown-elf-gcc
CLANG    := $(LLVMBIN)/clang
OUT      ?= $(SIM)/out
COMMON   := -O2 -g -ffreestanding -fno-builtin -nostdlib -I$(SIM) -Wall
GCCFLAGS := -march=rv32imcxgap9 -mabi=ilp32 $(COMMON)
CLANGFLAGS = --target=riscv32-unknown-elf -march=rv32imc_zfinx_xpulpv2 -mabi=ilp32 -mno-relax \
              -isystem $(GAPTC)/riscv32-unknown-elf/include $(COMMON) $(CLANG_WORKAROUND)
# port-20 clang crashes in the integrated assembler on `lp.setupi xN, cnt, <label>`
# (RISCVMCCodeEmitter.cpp:555 "Unhandled expression!"; via .s: "immediate must be an
# integer in the range [0, 31]"). Forcing the lp.starti/lp.endi/lp.counti form avoids it.
CLANG_WORKAROUND ?= -mllvm -pulp-loop-range-immediate=0
LDFLAGS  := -nostdlib -static -T $(SIM)/link.ld
TESTS    := hello loop clip

all: $(foreach t,$(TESTS),$(OUT)/$(t).gcc.elf $(OUT)/$(t).clang.elf)

$(OUT)/%.gcc.o: $(SIM)/tests/%.c $(SIM)/bench.h ; @mkdir -p $(OUT); $(GCC) $(GCCFLAGS) -c $< -o $@
$(OUT)/crt0.gcc.o: $(SIM)/crt0.S ; @mkdir -p $(OUT); $(GCC) $(GCCFLAGS) -c $< -o $@
$(OUT)/%.gcc.elf: $(OUT)/crt0.gcc.o $(OUT)/%.gcc.o ; $(GCC) $(GCCFLAGS) $(LDFLAGS) $^ -lgcc -o $@

$(OUT)/%.clang.o: $(SIM)/tests/%.c $(SIM)/bench.h ; @mkdir -p $(OUT); $(CLANG) $(CLANGFLAGS) -c $< -o $@
$(OUT)/crt0.clang.o: $(SIM)/crt0.S ; @mkdir -p $(OUT); $(CLANG) $(CLANGFLAGS) -c $< -o $@
$(OUT)/%.clang.elf: $(OUT)/crt0.clang.o $(OUT)/%.clang.o ; $(LLVMBIN)/ld.lld $(LDFLAGS) $^ -o $@

run: all
	@for e in $(OUT)/*.elf; do echo "=== $$e"; $(SIM)/run_sim.sh $$e; done

clean: ; rm -rf $(OUT)
.PHONY: all run clean
.SECONDARY:
