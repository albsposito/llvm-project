; ModuleID = '/home/ubuntu/llvm-project/pulp-llvm-port/benchmarks/autovec-probe/investigation/out/exp/ualign/loops_f16.O0.ll'
source_filename = "/home/ubuntu/llvm-project/pulp-llvm-port/benchmarks/autovec-probe/investigation/loops_f16.c"
target datalayout = "e-m:e-p:32:32-i64:64-n32-S128"
target triple = "riscv32-unknown-unknown-elf"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @win_f16(ptr noalias nocapture noundef %frame, ptr noalias nocapture noundef readonly %win, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp6 = icmp sgt i32 %n, 0
  br i1 %cmp6, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.body, %entry
  ret void

for.body:                                         ; preds = %entry, %for.body
  %i.07 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds nuw half, ptr %frame, i32 %i.07
  %0 = load half, ptr %arrayidx, align 2, !tbaa !6
  %arrayidx1 = getelementptr inbounds nuw half, ptr %win, i32 %i.07
  %1 = load half, ptr %arrayidx1, align 2, !tbaa !6
  %mul = fmul half %0, %1
  store half %mul, ptr %arrayidx, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.07, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !10
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @win_f16_o(ptr noalias nocapture noundef writeonly %out, ptr noalias nocapture noundef readonly %in, ptr noalias nocapture noundef readonly %win, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp5 = icmp sgt i32 %n, 0
  br i1 %cmp5, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.body, %entry
  ret void

for.body:                                         ; preds = %entry, %for.body
  %i.06 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds nuw half, ptr %in, i32 %i.06
  %0 = load half, ptr %arrayidx, align 2, !tbaa !6
  %arrayidx1 = getelementptr inbounds nuw half, ptr %win, i32 %i.06
  %1 = load half, ptr %arrayidx1, align 2, !tbaa !6
  %mul = fmul half %0, %1
  %arrayidx2 = getelementptr inbounds nuw half, ptr %out, i32 %i.06
  store half %mul, ptr %arrayidx2, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.06, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !12
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @add_f16(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, ptr noalias nocapture noundef readonly %c, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp5 = icmp sgt i32 %n, 0
  br i1 %cmp5, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.body, %entry
  ret void

for.body:                                         ; preds = %entry, %for.body
  %i.06 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds nuw half, ptr %b, i32 %i.06
  %0 = load half, ptr %arrayidx, align 2, !tbaa !6
  %arrayidx1 = getelementptr inbounds nuw half, ptr %c, i32 %i.06
  %1 = load half, ptr %arrayidx1, align 2, !tbaa !6
  %add = fadd half %0, %1
  %arrayidx2 = getelementptr inbounds nuw half, ptr %a, i32 %i.06
  store half %add, ptr %arrayidx2, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.06, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !13
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @axpy_f16(ptr noalias nocapture noundef %y, ptr noalias nocapture noundef readonly %x, half noundef %k, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp6 = icmp sgt i32 %n, 0
  br i1 %cmp6, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.body, %entry
  ret void

for.body:                                         ; preds = %entry, %for.body
  %i.07 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds nuw half, ptr %y, i32 %i.07
  %0 = load half, ptr %arrayidx, align 2, !tbaa !6
  %arrayidx1 = getelementptr inbounds nuw half, ptr %x, i32 %i.07
  %1 = load half, ptr %arrayidx1, align 2, !tbaa !6
  %2 = tail call half @llvm.fmuladd.f16(half %k, half %1, half %0)
  store half %2, ptr %arrayidx, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.07, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !14
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare half @llvm.fmuladd.f16(half, half, half) #1

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @scale_f16(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, half noundef %k, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp4 = icmp sgt i32 %n, 0
  br i1 %cmp4, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.body, %entry
  ret void

for.body:                                         ; preds = %entry, %for.body
  %i.05 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds nuw half, ptr %b, i32 %i.05
  %0 = load half, ptr %arrayidx, align 2, !tbaa !6
  %mul = fmul half %k, %0
  %arrayidx1 = getelementptr inbounds nuw half, ptr %a, i32 %i.05
  store half %mul, ptr %arrayidx1, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.05, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !15
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @max_f16(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, ptr noalias nocapture noundef readonly %c, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp10 = icmp sgt i32 %n, 0
  br i1 %cmp10, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.body, %entry
  ret void

for.body:                                         ; preds = %entry, %for.body
  %i.011 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds nuw half, ptr %b, i32 %i.011
  %0 = load half, ptr %arrayidx, align 2, !tbaa !6
  %arrayidx1 = getelementptr inbounds nuw half, ptr %c, i32 %i.011
  %1 = load half, ptr %arrayidx1, align 2, !tbaa !6
  %cmp2 = fcmp ogt half %0, %1
  %. = select i1 %cmp2, half %0, half %1
  %arrayidx5 = getelementptr inbounds nuw half, ptr %a, i32 %i.011
  store half %., ptr %arrayidx5, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.011, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !16
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @magsq_f16(ptr noalias nocapture noundef writeonly %out, ptr noalias nocapture noundef readonly %in, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp10 = icmp sgt i32 %n, 0
  br i1 %cmp10, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.body, %entry
  ret void

for.body:                                         ; preds = %entry, %for.body
  %i.011 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %mul = shl nuw nsw i32 %i.011, 1
  %arrayidx = getelementptr inbounds nuw half, ptr %in, i32 %mul
  %0 = load half, ptr %arrayidx, align 2, !tbaa !6
  %add = or disjoint i32 %mul, 1
  %arrayidx5 = getelementptr inbounds nuw half, ptr %in, i32 %add
  %1 = load half, ptr %arrayidx5, align 2, !tbaa !6
  %mul9 = fmul half %1, %1
  %2 = tail call half @llvm.fmuladd.f16(half %0, half %0, half %mul9)
  %arrayidx10 = getelementptr inbounds nuw half, ptr %out, i32 %i.011
  store half %2, ptr %arrayidx10, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.011, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !17
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read)
define dso_local half @dot_f16(ptr noalias nocapture noundef readonly %b, ptr noalias nocapture noundef readonly %c, i32 noundef %n) local_unnamed_addr #2 {
entry:
  %cmp5 = icmp sgt i32 %n, 0
  br i1 %cmp5, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.body, %entry
  %s.0.lcssa = phi half [ 0xH0000, %entry ], [ %2, %for.body ]
  ret half %s.0.lcssa

for.body:                                         ; preds = %entry, %for.body
  %i.07 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %s.06 = phi half [ %2, %for.body ], [ 0xH0000, %entry ]
  %arrayidx = getelementptr inbounds nuw half, ptr %b, i32 %i.07
  %0 = load half, ptr %arrayidx, align 2, !tbaa !6
  %arrayidx1 = getelementptr inbounds nuw half, ptr %c, i32 %i.07
  %1 = load half, ptr %arrayidx1, align 2, !tbaa !6
  %2 = tail call half @llvm.fmuladd.f16(half %0, half %1, half %s.06)
  %inc = add nuw nsw i32 %i.07, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !18
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @win_f16_nr(ptr nocapture noundef %frame, ptr nocapture noundef readonly %win, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp6 = icmp sgt i32 %n, 0
  br i1 %cmp6, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.body, %entry
  ret void

for.body:                                         ; preds = %entry, %for.body
  %i.07 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds nuw half, ptr %frame, i32 %i.07
  %0 = load half, ptr %arrayidx, align 2, !tbaa !6
  %arrayidx1 = getelementptr inbounds nuw half, ptr %win, i32 %i.07
  %1 = load half, ptr %arrayidx1, align 2, !tbaa !6
  %mul = fmul half %0, %1
  store half %mul, ptr %arrayidx, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.07, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !19
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @win_f16_k256(ptr noalias nocapture noundef %frame, ptr noalias nocapture noundef readonly %win) local_unnamed_addr #0 {
entry:
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body
  ret void

for.body:                                         ; preds = %entry, %for.body
  %i.06 = phi i32 [ 0, %entry ], [ %inc, %for.body ]
  %arrayidx = getelementptr inbounds nuw half, ptr %frame, i32 %i.06
  %0 = load half, ptr %arrayidx, align 2, !tbaa !6
  %arrayidx1 = getelementptr inbounds nuw half, ptr %win, i32 %i.06
  %1 = load half, ptr %arrayidx1, align 2, !tbaa !6
  %mul = fmul half %0, %1
  store half %mul, ptr %arrayidx, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.06, 1
  %exitcond.not = icmp eq i32 %inc, 256
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !20
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv32" "target-features"="+unaligned-scalar-mem,+32bit,+c,+m,+relax,+xgap,+xpulpf16alt,+xpulpfvec,+xpulpv,+zfinx,+zhinx,+zhinxmin,+zicsr,+zmmul,-a,-b,-d,-e,-experimental-sdext,-experimental-sdtrig,-experimental-smctr,-experimental-ssctr,-experimental-svukte,-experimental-xqcia,-experimental-xqciac,-experimental-xqcicli,-experimental-xqcicm,-experimental-xqcics,-experimental-xqcicsr,-experimental-xqciint,-experimental-xqcilo,-experimental-xqcilsm,-experimental-xqcisls,-experimental-zalasr,-experimental-zicfilp,-experimental-zicfiss,-experimental-zvbc32e,-experimental-zvkgs,-f,-h,-sha,-shcounterenw,-shgatpa,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcsrind,-smdbltrp,-smepmp,-smmpm,-smnpm,-smrnmi,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssdbltrp,-ssnpm,-sspm,-ssqosid,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-supm,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-svvptc,-v,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xdma,-xfalthalf,-xfaltquarter,-xfauxalthalf,-xfauxaltquarter,-xfauxhalf,-xfauxquarter,-xfauxvecalthalf,-xfauxvecaltquarter,-xfauxvechalf,-xfauxvecquarter,-xfauxvecsingle,-xfexpauxvecalthalf,-xfexpauxvecaltquarter,-xfexpauxvechalf,-xfexpauxvecquarter,-xfquarter,-xfrep,-xfvecalthalf,-xfvecaltquarter,-xfvechalf,-xfvecquarter,-xfvecsingle,-xmempool,-xmipscmove,-xmipslsp,-xsfcease,-xsfvcp,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xssr,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-xwchc,-za128rs,-za64rs,-zaamo,-zabha,-zacas,-zalrsc,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zca,-zcb,-zcd,-zce,-zcf,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfbfmin,-zfh,-zfhmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zifencei,-zihintntl,-zihintpause,-zihpm,-zimop,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-ztso,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfbfmin,-zvfbfwma,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { nofree norecurse nosync nounwind memory(argmem: read) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv32" "target-features"="+unaligned-scalar-mem,+32bit,+c,+m,+relax,+xgap,+xpulpf16alt,+xpulpfvec,+xpulpv,+zfinx,+zhinx,+zhinxmin,+zicsr,+zmmul,-a,-b,-d,-e,-experimental-sdext,-experimental-sdtrig,-experimental-smctr,-experimental-ssctr,-experimental-svukte,-experimental-xqcia,-experimental-xqciac,-experimental-xqcicli,-experimental-xqcicm,-experimental-xqcics,-experimental-xqcicsr,-experimental-xqciint,-experimental-xqcilo,-experimental-xqcilsm,-experimental-xqcisls,-experimental-zalasr,-experimental-zicfilp,-experimental-zicfiss,-experimental-zvbc32e,-experimental-zvkgs,-f,-h,-sha,-shcounterenw,-shgatpa,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcsrind,-smdbltrp,-smepmp,-smmpm,-smnpm,-smrnmi,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssdbltrp,-ssnpm,-sspm,-ssqosid,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-supm,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-svvptc,-v,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xdma,-xfalthalf,-xfaltquarter,-xfauxalthalf,-xfauxaltquarter,-xfauxhalf,-xfauxquarter,-xfauxvecalthalf,-xfauxvecaltquarter,-xfauxvechalf,-xfauxvecquarter,-xfauxvecsingle,-xfexpauxvecalthalf,-xfexpauxvecaltquarter,-xfexpauxvechalf,-xfexpauxvecquarter,-xfquarter,-xfrep,-xfvecalthalf,-xfvecaltquarter,-xfvechalf,-xfvecquarter,-xfvecsingle,-xmempool,-xmipscmove,-xmipslsp,-xsfcease,-xsfvcp,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xssr,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-xwchc,-za128rs,-za64rs,-zaamo,-zabha,-zacas,-zalrsc,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zca,-zcb,-zcd,-zce,-zcf,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfbfmin,-zfh,-zfhmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zifencei,-zihintntl,-zihintpause,-zihpm,-zimop,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-ztso,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfbfmin,-zvfbfwma,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }

!llvm.module.flags = !{!0, !1, !2, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"target-abi", !"ilp32"}
!2 = !{i32 6, !"riscv-isa", !3}
!3 = !{!"rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"}
!4 = !{i32 8, !"SmallDataLimit", i32 0}
!5 = !{!"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"}
!6 = !{!7, !7, i64 0}
!7 = !{!"_Float16", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = distinct !{!10, !11}
!11 = !{!"llvm.loop.mustprogress"}
!12 = distinct !{!12, !11}
!13 = distinct !{!13, !11}
!14 = distinct !{!14, !11}
!15 = distinct !{!15, !11}
!16 = distinct !{!16, !11}
!17 = distinct !{!17, !11}
!18 = distinct !{!18, !11}
!19 = distinct !{!19, !11}
!20 = distinct !{!20, !11}
