; B156: what the cost model answers for packed types (opt -passes='print<cost-model>')
target datalayout = "e-m:e-p:32:32-i64:64-n32-S128"
target triple = "riscv32-unknown-unknown-elf"
declare <2 x i16> @llvm.smin.v2i16(<2 x i16>, <2 x i16>)
declare <2 x i16> @llvm.sadd.sat.v2i16(<2 x i16>, <2 x i16>)
declare i32 @llvm.vector.reduce.add.v2i32(<2 x i32>)
declare i16 @llvm.vector.reduce.add.v2i16(<2 x i16>)
declare i16 @llvm.vector.reduce.smax.v2i16(<2 x i16>)
define void @f(ptr %p, ptr %q, <2 x i16> %a, <2 x i16> %b, <4 x i8> %c, <4 x i8> %d, i16 %s, <2 x half> %h, <2 x half> %k, <4 x i16> %w) #0 {
  %l2 = load <2 x i16>, ptr %p, align 2
  %l4 = load <4 x i8>, ptr %p, align 1
  %l2a = load <2 x i16>, ptr %p, align 4
  %lh = load <2 x half>, ptr %p, align 2
  %lw = load <4 x i16>, ptr %p, align 2
  store <2 x i16> %a, ptr %q, align 2
  store <4 x i8> %c, ptr %q, align 1
  %add2 = add <2 x i16> %a, %b
  %add4 = add <4 x i8> %c, %d
  %add44 = add <4 x i16> %w, %w
  %mul2 = mul <2 x i16> %a, %b
  %mul4 = mul <4 x i8> %c, %d
  %shl2 = shl <2 x i16> %a, <i16 3, i16 3>
  %ashr2 = ashr <2 x i16> %a, %b
  %cmp2 = icmp slt <2 x i16> %a, %b
  %sel2 = select <2 x i1> %cmp2, <2 x i16> %a, <2 x i16> %b
  %min2 = call <2 x i16> @llvm.smin.v2i16(<2 x i16> %a, <2 x i16> %b)
  %sat2 = call <2 x i16> @llvm.sadd.sat.v2i16(<2 x i16> %a, <2 x i16> %b)
  %ins = insertelement <2 x i16> poison, i16 %s, i32 0
  %spl = shufflevector <2 x i16> %ins, <2 x i16> poison, <2 x i32> zeroinitializer
  %rev = shufflevector <4 x i8> %c, <4 x i8> poison, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
  %ext = extractelement <2 x i16> %a, i32 1
  %sx = sext <2 x i16> %a to <2 x i32>
  %zx = zext <4 x i8> %c to <4 x i32>
  %sx48 = sext <4 x i8> %c to <4 x i16>
  %mulw = mul <2 x i32> %sx, %sx
  %red = call i32 @llvm.vector.reduce.add.v2i32(<2 x i32> %mulw)
  %red16 = call i16 @llvm.vector.reduce.add.v2i16(<2 x i16> %a)
  %redmx = call i16 @llvm.vector.reduce.smax.v2i16(<2 x i16> %a)
  %tr = trunc <2 x i32> %mulw to <2 x i16>
  %fmul = fmul <2 x half> %h, %k
  %sadd = add i16 %s, %s
  %sl = load i16, ptr %p, align 2
  ret void
}
attributes #0 = { "target-features"="+32bit,+c,+m,+xgap,+xpulpf16alt,+xpulpfvec,+xpulpv,+zfinx,+zhinx,+zhinxmin,+zicsr,+zmmul" }
