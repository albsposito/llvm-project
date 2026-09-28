; Queue item N1: fastcc + PULP packed-vector argument crashes RISC-V ISel
; (RISCVTargetLowering::analyzeInputArgs, CC_RISCV_FastCC has no case for
; v2i16/v4i8 in GPRs).  Crashes int-20 and 20/F019-rev2; not with the C
; calling convention, not without +xpulpv, not for i32.  At -O3 the SDK's
; static helpers become fastcc and 7 CNN kernel files crash.
; llc -O2 N1-fastcc-v2i16-arg.ll -o /dev/null   -> abort/segfault
target triple = "riscv32-unknown-unknown-elf"
define fastcc void @f(<2 x i16> %s) "target-features"="+xpulpv" {
  ret void
}
