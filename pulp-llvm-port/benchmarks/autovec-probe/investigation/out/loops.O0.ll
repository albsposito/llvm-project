; ModuleID = '../loops.c'
source_filename = "../loops.c"
target datalayout = "e-m:e-p:32:32-i64:64-n32-S128"
target triple = "riscv32-unknown-unknown-elf"

; Function Attrs: nounwind
define dso_local void @add16(ptr noalias noundef %a, ptr noalias noundef %b, ptr noalias noundef %c, i32 noundef %n) #0 {
entry:
  %a.addr = alloca ptr, align 4
  %b.addr = alloca ptr, align 4
  %c.addr = alloca ptr, align 4
  %n.addr = alloca i32, align 4
  %i = alloca i32, align 4
  store ptr %a, ptr %a.addr, align 4, !tbaa !6
  store ptr %b, ptr %b.addr, align 4, !tbaa !6
  store ptr %c, ptr %c.addr, align 4, !tbaa !6
  store i32 %n, ptr %n.addr, align 4, !tbaa !11
  call void @llvm.lifetime.start.p0(i64 4, ptr %i) #2
  store i32 0, ptr %i, align 4, !tbaa !11
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, ptr %i, align 4, !tbaa !11
  %1 = load i32, ptr %n.addr, align 4, !tbaa !11
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  call void @llvm.lifetime.end.p0(i64 4, ptr %i) #2
  br label %for.end

for.body:                                         ; preds = %for.cond
  %2 = load ptr, ptr %b.addr, align 4, !tbaa !6
  %3 = load i32, ptr %i, align 4, !tbaa !11
  %arrayidx = getelementptr inbounds i16, ptr %2, i32 %3
  %4 = load i16, ptr %arrayidx, align 2, !tbaa !13
  %conv = sext i16 %4 to i32
  %5 = load ptr, ptr %c.addr, align 4, !tbaa !6
  %6 = load i32, ptr %i, align 4, !tbaa !11
  %arrayidx1 = getelementptr inbounds i16, ptr %5, i32 %6
  %7 = load i16, ptr %arrayidx1, align 2, !tbaa !13
  %conv2 = sext i16 %7 to i32
  %add = add nsw i32 %conv, %conv2
  %conv3 = trunc i32 %add to i16
  %8 = load ptr, ptr %a.addr, align 4, !tbaa !6
  %9 = load i32, ptr %i, align 4, !tbaa !11
  %arrayidx4 = getelementptr inbounds i16, ptr %8, i32 %9
  store i16 %conv3, ptr %arrayidx4, align 2, !tbaa !13
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %10 = load i32, ptr %i, align 4, !tbaa !11
  %inc = add nsw i32 %10, 1
  store i32 %inc, ptr %i, align 4, !tbaa !11
  br label %for.cond, !llvm.loop !15

for.end:                                          ; preds = %for.cond.cleanup
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nounwind
define dso_local void @add8(ptr noalias noundef %a, ptr noalias noundef %b, ptr noalias noundef %c, i32 noundef %n) #0 {
entry:
  %a.addr = alloca ptr, align 4
  %b.addr = alloca ptr, align 4
  %c.addr = alloca ptr, align 4
  %n.addr = alloca i32, align 4
  %i = alloca i32, align 4
  store ptr %a, ptr %a.addr, align 4, !tbaa !17
  store ptr %b, ptr %b.addr, align 4, !tbaa !17
  store ptr %c, ptr %c.addr, align 4, !tbaa !17
  store i32 %n, ptr %n.addr, align 4, !tbaa !11
  call void @llvm.lifetime.start.p0(i64 4, ptr %i) #2
  store i32 0, ptr %i, align 4, !tbaa !11
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, ptr %i, align 4, !tbaa !11
  %1 = load i32, ptr %n.addr, align 4, !tbaa !11
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  call void @llvm.lifetime.end.p0(i64 4, ptr %i) #2
  br label %for.end

for.body:                                         ; preds = %for.cond
  %2 = load ptr, ptr %b.addr, align 4, !tbaa !17
  %3 = load i32, ptr %i, align 4, !tbaa !11
  %arrayidx = getelementptr inbounds i8, ptr %2, i32 %3
  %4 = load i8, ptr %arrayidx, align 1, !tbaa !19
  %conv = sext i8 %4 to i32
  %5 = load ptr, ptr %c.addr, align 4, !tbaa !17
  %6 = load i32, ptr %i, align 4, !tbaa !11
  %arrayidx1 = getelementptr inbounds i8, ptr %5, i32 %6
  %7 = load i8, ptr %arrayidx1, align 1, !tbaa !19
  %conv2 = sext i8 %7 to i32
  %add = add nsw i32 %conv, %conv2
  %conv3 = trunc i32 %add to i8
  %8 = load ptr, ptr %a.addr, align 4, !tbaa !17
  %9 = load i32, ptr %i, align 4, !tbaa !11
  %arrayidx4 = getelementptr inbounds i8, ptr %8, i32 %9
  store i8 %conv3, ptr %arrayidx4, align 1, !tbaa !19
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %10 = load i32, ptr %i, align 4, !tbaa !11
  %inc = add nsw i32 %10, 1
  store i32 %inc, ptr %i, align 4, !tbaa !11
  br label %for.cond, !llvm.loop !20

for.end:                                          ; preds = %for.cond.cleanup
  ret void
}

; Function Attrs: nounwind
define dso_local i32 @dot16(ptr noalias noundef %b, ptr noalias noundef %c, i32 noundef %n) #0 {
entry:
  %b.addr = alloca ptr, align 4
  %c.addr = alloca ptr, align 4
  %n.addr = alloca i32, align 4
  %s = alloca i32, align 4
  %i = alloca i32, align 4
  store ptr %b, ptr %b.addr, align 4, !tbaa !6
  store ptr %c, ptr %c.addr, align 4, !tbaa !6
  store i32 %n, ptr %n.addr, align 4, !tbaa !11
  call void @llvm.lifetime.start.p0(i64 4, ptr %s) #2
  store i32 0, ptr %s, align 4, !tbaa !11
  call void @llvm.lifetime.start.p0(i64 4, ptr %i) #2
  store i32 0, ptr %i, align 4, !tbaa !11
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, ptr %i, align 4, !tbaa !11
  %1 = load i32, ptr %n.addr, align 4, !tbaa !11
  %cmp = icmp slt i32 %0, %1
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  call void @llvm.lifetime.end.p0(i64 4, ptr %i) #2
  br label %for.end

for.body:                                         ; preds = %for.cond
  %2 = load ptr, ptr %b.addr, align 4, !tbaa !6
  %3 = load i32, ptr %i, align 4, !tbaa !11
  %arrayidx = getelementptr inbounds i16, ptr %2, i32 %3
  %4 = load i16, ptr %arrayidx, align 2, !tbaa !13
  %conv = sext i16 %4 to i32
  %5 = load ptr, ptr %c.addr, align 4, !tbaa !6
  %6 = load i32, ptr %i, align 4, !tbaa !11
  %arrayidx1 = getelementptr inbounds i16, ptr %5, i32 %6
  %7 = load i16, ptr %arrayidx1, align 2, !tbaa !13
  %conv2 = sext i16 %7 to i32
  %mul = mul nsw i32 %conv, %conv2
  %8 = load i32, ptr %s, align 4, !tbaa !11
  %add = add nsw i32 %8, %mul
  store i32 %add, ptr %s, align 4, !tbaa !11
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %9 = load i32, ptr %i, align 4, !tbaa !11
  %inc = add nsw i32 %9, 1
  store i32 %inc, ptr %i, align 4, !tbaa !11
  br label %for.cond, !llvm.loop !21

for.end:                                          ; preds = %for.cond.cleanup
  %10 = load i32, ptr %s, align 4, !tbaa !11
  call void @llvm.lifetime.end.p0(i64 4, ptr %s) #2
  ret i32 %10
}

attributes #0 = { nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv32" "target-features"="+32bit,+c,+m,+relax,+xgap,+xpulpf16alt,+xpulpfvec,+xpulpv,+zfinx,+zhinx,+zhinxmin,+zicsr,+zmmul,-a,-b,-d,-e,-experimental-sdext,-experimental-sdtrig,-experimental-smctr,-experimental-ssctr,-experimental-svukte,-experimental-xqcia,-experimental-xqciac,-experimental-xqcicli,-experimental-xqcicm,-experimental-xqcics,-experimental-xqcicsr,-experimental-xqciint,-experimental-xqcilo,-experimental-xqcilsm,-experimental-xqcisls,-experimental-zalasr,-experimental-zicfilp,-experimental-zicfiss,-experimental-zvbc32e,-experimental-zvkgs,-f,-h,-sha,-shcounterenw,-shgatpa,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcsrind,-smdbltrp,-smepmp,-smmpm,-smnpm,-smrnmi,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssdbltrp,-ssnpm,-sspm,-ssqosid,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-supm,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-svvptc,-v,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xdma,-xfalthalf,-xfaltquarter,-xfauxalthalf,-xfauxaltquarter,-xfauxhalf,-xfauxquarter,-xfauxvecalthalf,-xfauxvecaltquarter,-xfauxvechalf,-xfauxvecquarter,-xfauxvecsingle,-xfexpauxvecalthalf,-xfexpauxvecaltquarter,-xfexpauxvechalf,-xfexpauxvecquarter,-xfquarter,-xfrep,-xfvecalthalf,-xfvecaltquarter,-xfvechalf,-xfvecquarter,-xfvecsingle,-xmempool,-xmipscmove,-xmipslsp,-xsfcease,-xsfvcp,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xssr,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-xwchc,-za128rs,-za64rs,-zaamo,-zabha,-zacas,-zalrsc,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zca,-zcb,-zcd,-zce,-zcf,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfbfmin,-zfh,-zfhmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zifencei,-zihintntl,-zihintpause,-zihpm,-zimop,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-ztso,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfbfmin,-zvfbfwma,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"target-abi", !"ilp32"}
!2 = !{i32 6, !"riscv-isa", !3}
!3 = !{!"rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"}
!4 = !{i32 8, !"SmallDataLimit", i32 0}
!5 = !{!"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"}
!6 = !{!7, !7, i64 0}
!7 = !{!"p1 short", !8, i64 0}
!8 = !{!"any pointer", !9, i64 0}
!9 = !{!"omnipotent char", !10, i64 0}
!10 = !{!"Simple C/C++ TBAA"}
!11 = !{!12, !12, i64 0}
!12 = !{!"int", !9, i64 0}
!13 = !{!14, !14, i64 0}
!14 = !{!"short", !9, i64 0}
!15 = distinct !{!15, !16}
!16 = !{!"llvm.loop.mustprogress"}
!17 = !{!18, !18, i64 0}
!18 = !{!"p1 omnipotent char", !8, i64 0}
!19 = !{!9, !9, i64 0}
!20 = distinct !{!20, !16}
!21 = distinct !{!21, !16}
