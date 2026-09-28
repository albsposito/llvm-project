; ModuleID = 'w/27/kern.c'
source_filename = "w/27/kern.c"
target datalayout = "e-m:e-p:32:32-i64:64-n32-S128"
target triple = "riscv32-unknown-unknown-elf"

; Function Attrs: nofree noinline norecurse nosync nounwind memory(argmem: readwrite)
define dso_local i32 @kern(ptr nocapture noundef readonly %A, ptr nocapture noundef readonly %B, ptr nocapture noundef writeonly %out, i32 noundef %n, i32 noundef %m, i32 noundef %k) local_unnamed_addr #0 {
entry:
  %cmp63.not = icmp eq i32 %m, 0
  br i1 %cmp63.not, label %for.cond11.preheader, label %for.body.lr.ph

for.body.lr.ph:                                   ; preds = %entry
  %arrayidx = getelementptr inbounds nuw i8, ptr %B, i32 212
  %arrayidx3 = getelementptr inbounds nuw i8, ptr %B, i32 252
  %0 = mul i32 %m, 73
  br label %for.body

for.cond11.preheader.loopexit:                    ; preds = %for.body
  %1 = add i32 %0, 3
  br label %for.cond11.preheader

for.cond11.preheader:                             ; preds = %for.cond11.preheader.loopexit, %entry
  %t.0.lcssa = phi i32 [ 3, %entry ], [ %1, %for.cond11.preheader.loopexit ]
  %cmp1370.not = icmp eq i32 %n, -1
  br i1 %cmp1370.not, label %for.body36.preheader, label %for.body15.lr.ph

for.body15.lr.ph:                                 ; preds = %for.cond11.preheader
  %2 = mul i32 %k, 19
  br label %for.body15

for.body:                                         ; preds = %for.body.lr.ph, %for.body
  %i0.065 = phi i32 [ 0, %for.body.lr.ph ], [ %inc, %for.body ]
  %3 = load i32, ptr %arrayidx, align 4, !tbaa !6
  %mul = shl i32 %3, 1
  %4 = load i32, ptr %arrayidx3, align 4, !tbaa !6
  %add4 = add i32 %mul, %4
  %mul5 = mul i32 %add4, 7
  %add6 = add i32 %i0.065, 8
  %and7 = and i32 %add6, 63
  %arrayidx8 = getelementptr inbounds nuw i32, ptr %out, i32 %and7
  store i32 %mul5, ptr %arrayidx8, align 4, !tbaa !6
  %inc = add nuw i32 %i0.065, 1
  %exitcond.not = icmp eq i32 %inc, %m
  br i1 %exitcond.not, label %for.cond11.preheader.loopexit, label %for.body, !llvm.loop !10

for.cond33.preheader:                             ; preds = %for.body15
  %cmp3476.not = icmp eq i32 %n, 0
  br i1 %cmp3476.not, label %for.cond.cleanup35, label %for.body36.preheader

for.body36.preheader:                             ; preds = %for.cond11.preheader, %for.cond33.preheader
  %t.1.lcssa86 = phi i32 [ %add20, %for.cond33.preheader ], [ %t.0.lcssa, %for.cond11.preheader ]
  %s.0.lcssa85 = phi i32 [ %7, %for.cond33.preheader ], [ 2, %for.cond11.preheader ]
  br label %for.body36

for.body15:                                       ; preds = %for.body15.lr.ph, %for.body15
  %i010.073 = phi i32 [ 0, %for.body15.lr.ph ], [ %inc30, %for.body15 ]
  %t.172 = phi i32 [ %t.0.lcssa, %for.body15.lr.ph ], [ %add20, %for.body15 ]
  %s.071 = phi i32 [ 2, %for.body15.lr.ph ], [ %7, %for.body15 ]
  %5 = and i32 %t.172, 63
  %and17 = xor i32 %5, 32
  %arrayidx18 = getelementptr inbounds nuw i32, ptr %A, i32 %and17
  %6 = load i32, ptr %arrayidx18, align 4, !tbaa !6
  %mul19 = shl i32 %6, 1
  %xor = xor i32 %mul19, %t.172
  %add20 = add i32 %xor, %t.172
  %7 = add i32 %2, %s.071
  %inc30 = add nuw i32 %i010.073, 1
  %exitcond80.not = icmp eq i32 %i010.073, %n
  br i1 %exitcond80.not, label %for.cond33.preheader, label %for.body15, !llvm.loop !12

for.cond.cleanup35:                               ; preds = %for.body36, %for.cond33.preheader
  %t.1.lcssa87 = phi i32 [ %add20, %for.cond33.preheader ], [ %t.1.lcssa86, %for.body36 ]
  %s.2.lcssa = phi i32 [ %7, %for.cond33.preheader ], [ %add40, %for.body36 ]
  %8 = xor i32 %t.1.lcssa87, %s.2.lcssa
  %xor45 = xor i32 %8, 1
  ret i32 %xor45

for.body36:                                       ; preds = %for.body36.preheader, %for.body36
  %i032.078 = phi i32 [ %inc42, %for.body36 ], [ 0, %for.body36.preheader ]
  %s.277 = phi i32 [ %add40, %for.body36 ], [ %s.0.lcssa85, %for.body36.preheader ]
  %add37 = add i32 %s.277, 53
  %and38 = and i32 %add37, 63
  %arrayidx39 = getelementptr inbounds nuw i32, ptr %B, i32 %and38
  %9 = load i32, ptr %arrayidx39, align 4, !tbaa !6
  %add40 = add i32 %9, %s.277
  %inc42 = add nuw i32 %i032.078, 1
  %exitcond81.not = icmp eq i32 %inc42, %n
  br i1 %exitcond81.not, label %for.cond.cleanup35, label %for.body36, !llvm.loop !13
}

attributes #0 = { nofree noinline norecurse nosync nounwind memory(argmem: readwrite) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv32" "target-features"="+32bit,+c,+m,+xpulpv,+zfinx,+zicsr,+zmmul,-a,-b,-d,-e,-experimental-sdext,-experimental-sdtrig,-experimental-smctr,-experimental-ssctr,-experimental-svukte,-experimental-xqcia,-experimental-xqciac,-experimental-xqcicli,-experimental-xqcicm,-experimental-xqcics,-experimental-xqcicsr,-experimental-xqciint,-experimental-xqcilo,-experimental-xqcilsm,-experimental-xqcisls,-experimental-zalasr,-experimental-zicfilp,-experimental-zicfiss,-experimental-zvbc32e,-experimental-zvkgs,-f,-h,-relax,-sha,-shcounterenw,-shgatpa,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcsrind,-smdbltrp,-smepmp,-smmpm,-smnpm,-smrnmi,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssdbltrp,-ssnpm,-sspm,-ssqosid,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-supm,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-svvptc,-v,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xdma,-xfalthalf,-xfaltquarter,-xfauxalthalf,-xfauxaltquarter,-xfauxhalf,-xfauxquarter,-xfauxvecalthalf,-xfauxvecaltquarter,-xfauxvechalf,-xfauxvecquarter,-xfauxvecsingle,-xfexpauxvecalthalf,-xfexpauxvecaltquarter,-xfexpauxvechalf,-xfexpauxvecquarter,-xfquarter,-xfrep,-xfvecalthalf,-xfvecaltquarter,-xfvechalf,-xfvecquarter,-xfvecsingle,-xmempool,-xmipscmove,-xmipslsp,-xsfcease,-xsfvcp,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xssr,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-xwchc,-za128rs,-za64rs,-zaamo,-zabha,-zacas,-zalrsc,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zca,-zcb,-zcd,-zce,-zcf,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfbfmin,-zfh,-zfhmin,-zhinx,-zhinxmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zifencei,-zihintntl,-zihintpause,-zihpm,-zimop,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-ztso,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfbfmin,-zvfbfwma,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }

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
!13 = distinct !{!13, !11}
