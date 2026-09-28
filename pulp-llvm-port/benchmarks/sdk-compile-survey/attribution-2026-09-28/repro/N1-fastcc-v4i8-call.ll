; Queue item N1 (call side), reduced from CNN_Conv_SQ8.c at -O3 with 20/F019-rev2:
; a fastcc call passing a <4 x i8> crashes ISel (segfault).
; llc -O3 N1-fastcc-v4i8-call.ll -o /dev/null
target triple = "riscv32-unknown-unknown-elf"
define void @KerParConv1x1Stride1_SQ8() "target-features"="+xgap,+xpulpv,+zfinx" {
entry:
  tail call fastcc void null(ptr null, ptr null, <4 x i8> zeroinitializer, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0)
  ret void
}
