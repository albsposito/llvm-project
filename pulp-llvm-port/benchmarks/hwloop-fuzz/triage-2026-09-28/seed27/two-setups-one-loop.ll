; ModuleID = 'two-setups-one-loop.c'
source_filename = "two-setups-one-loop.c"
target datalayout = "e-m:e-p:32:32-i64:64-n32-S128"
target triple = "riscv32-unknown-unknown-elf"

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read)
define dso_local i32 @kern(ptr nocapture noundef readonly %A, ptr nocapture noundef readonly %B, i32 noundef %n, i32 noundef %k) local_unnamed_addr #0 {
entry:
  %add = add i32 %n, 1
  %cmp24.not = icmp eq i32 %add, 0
  br i1 %cmp24.not, label %for.body8.preheader, label %for.body.preheader

for.body.preheader:                               ; preds = %entry
  %0 = mul i32 %k, %add
  br label %for.body

for.cond5.preheader:                              ; preds = %for.body
  %1 = add i32 %0, 2
  %cmp629.not = icmp eq i32 %n, 0
  br i1 %cmp629.not, label %for.cond.cleanup7, label %for.body8.preheader

for.body8.preheader:                              ; preds = %entry, %for.cond5.preheader
  %t.0.lcssa38 = phi i32 [ %add2, %for.cond5.preheader ], [ 3, %entry ]
  %s.0.lcssa37 = phi i32 [ %1, %for.cond5.preheader ], [ 2, %entry ]
  br label %for.body8

for.body:                                         ; preds = %for.body.preheader, %for.body
  %i.027 = phi i32 [ %inc, %for.body ], [ 0, %for.body.preheader ]
  %t.026 = phi i32 [ %add2, %for.body ], [ 3, %for.body.preheader ]
  %2 = and i32 %t.026, 63
  %and = xor i32 %2, 32
  %arrayidx = getelementptr inbounds nuw i32, ptr %A, i32 %and
  %3 = load i32, ptr %arrayidx, align 4, !tbaa !6
  %add2 = add i32 %3, %t.026
  %inc = add nuw i32 %i.027, 1
  %exitcond.not = icmp eq i32 %i.027, %n
  br i1 %exitcond.not, label %for.cond5.preheader, label %for.body, !llvm.loop !10

for.cond.cleanup7:                                ; preds = %for.body8, %for.cond5.preheader
  %t.0.lcssa39 = phi i32 [ %add2, %for.cond5.preheader ], [ %t.0.lcssa38, %for.body8 ]
  %s.1.lcssa = phi i32 [ %1, %for.cond5.preheader ], [ %add12, %for.body8 ]
  %xor = xor i32 %s.1.lcssa, %t.0.lcssa39
  ret i32 %xor

for.body8:                                        ; preds = %for.body8.preheader, %for.body8
  %i4.031 = phi i32 [ %inc14, %for.body8 ], [ 0, %for.body8.preheader ]
  %s.130 = phi i32 [ %add12, %for.body8 ], [ %s.0.lcssa37, %for.body8.preheader ]
  %add9 = add i32 %s.130, 53
  %and10 = and i32 %add9, 63
  %arrayidx11 = getelementptr inbounds nuw i32, ptr %B, i32 %and10
  %4 = load i32, ptr %arrayidx11, align 4, !tbaa !6
  %add12 = add i32 %4, %s.130
  %inc14 = add nuw i32 %i4.031, 1
  %exitcond33.not = icmp eq i32 %inc14, %n
  br i1 %exitcond33.not, label %for.cond.cleanup7, label %for.body8, !llvm.loop !12
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: read) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv32" "target-features"="+32bit,+c,+m,+xpulpv,+zfinx,+zicsr,+zmmul,-a,-b,-d,-e,-experimental-sdext,-experimental-sdtrig,-experimental-smctr,-experimental-ssctr,-experimental-svukte,-experimental-xqcia,-experimental-xqciac,-experimental-xqcicli,-experimental-xqcicm,-experimental-xqcics,-experimental-xqcicsr,-experimental-xqciint,-experimental-xqcilo,-experimental-xqcilsm,-experimental-xqcisls,-experimental-zalasr,-experimental-zicfilp,-experimental-zicfiss,-experimental-zvbc32e,-experimental-zvkgs,-f,-h,-relax,-sha,-shcounterenw,-shgatpa,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcsrind,-smdbltrp,-smepmp,-smmpm,-smnpm,-smrnmi,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssdbltrp,-ssnpm,-sspm,-ssqosid,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-supm,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-svvptc,-v,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xdma,-xfalthalf,-xfaltquarter,-xfauxalthalf,-xfauxaltquarter,-xfauxhalf,-xfauxquarter,-xfauxvecalthalf,-xfauxvecaltquarter,-xfauxvechalf,-xfauxvecquarter,-xfauxvecsingle,-xfexpauxvecalthalf,-xfexpauxvecaltquarter,-xfexpauxvechalf,-xfexpauxvecquarter,-xfquarter,-xfrep,-xfvecalthalf,-xfvecaltquarter,-xfvechalf,-xfvecquarter,-xfvecsingle,-xmempool,-xmipscmove,-xmipslsp,-xsfcease,-xsfvcp,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xssr,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-xwchc,-za128rs,-za64rs,-zaamo,-zabha,-zacas,-zalrsc,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zca,-zcb,-zcd,-zce,-zcf,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfbfmin,-zfh,-zfhmin,-zhinx,-zhinxmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zifencei,-zihintntl,-zihintpause,-zihpm,-zimop,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-ztso,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfbfmin,-zvfbfwma,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }

!llvm.module.flags = !{!0, !1, !2, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"target-abi", !"ilp32"}
!2 = !{i32 6, !"riscv-isa", !3}
!3 = !{!"rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_xpulpv2p0"}
!4 = !{i32 8, !"SmallDataLimit", i32 0}
!5 = !{!"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 7459255b6120075684cf3aef0b310567d60b5f80)"}
!6 = !{!7, !7, i64 0}
!7 = !{!"int", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = distinct !{!10, !11}
!11 = !{!"llvm.loop.mustprogress"}
!12 = distinct !{!12, !11}
