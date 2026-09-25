# Xpulpv2 LLVM 19 versus LLVM 18

Status: measurements complete. See [report.md](report.md) for the full results, limits, and reproduction instructions. Independent review pending.

Results are in `results.json` (15 C kernels, two optimization levels, two compilers), `hwloop-mix.json` and `supplement.json` (unchanged LLVM18 hardware-loop IR corpus). Exact commands are in `commands.json` and `supplement.json`. Each compiler/optimization directory contains disassembly, symbol sizes and diagnostic/crash logs. Reproduce with `python3 run.py` and `python3 supplement.py` from this directory or any working directory.

Initial findings: all ten straight-line C kernels retain identical function sizes and instruction counts at O2 and O3. Five unsigned dynamic-loop kernels crash in both compiler versions' PULP Hardware Loops pass. The supplemental IR retains eight hardware-loop and four postincrement instructions; strcmp loses two zero-extension instructions and shrinks 42 to 34 bytes, flagged by the strict instruction-family oracle. No simulator was available: these are static compiler-output measurements, not execution-time or correctness results.
