; ModuleID = '/home/ubuntu/llvm-project/pulp-llvm-port/benchmarks/autovec-probe/investigation/out/exp/ualign/loops3.O0.ll'
source_filename = "/home/ubuntu/llvm-project/pulp-llvm-port/benchmarks/autovec-probe/investigation/loops3.c"
target datalayout = "e-m:e-p:32:32-i64:64-n32-S128"
target triple = "riscv32-unknown-unknown-elf"

%struct.cpx = type { i16, i16 }

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @deint16(ptr noalias nocapture noundef writeonly %o, ptr noalias nocapture noundef readonly %in, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp6 = icmp sgt i32 %n, 0
  br i1 %cmp6, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry
  %min.iters.check = icmp eq i32 %n, 1
  br i1 %min.iters.check, label %for.body.preheader9, label %vector.ph

vector.ph:                                        ; preds = %for.body.preheader
  %n.vec = and i32 %n, 2147483646
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %.idx = shl nuw nsw i32 %index, 2
  %0 = getelementptr inbounds nuw i8, ptr %in, i32 %.idx
  %wide.vec = load <4 x i16>, ptr %0, align 2, !tbaa !6
  %strided.vec = shufflevector <4 x i16> %wide.vec, <4 x i16> poison, <2 x i32> <i32 0, i32 2>
  %strided.vec8 = shufflevector <4 x i16> %wide.vec, <4 x i16> poison, <2 x i32> <i32 1, i32 3>
  %1 = add <2 x i16> %strided.vec8, %strided.vec
  %2 = getelementptr inbounds nuw i16, ptr %o, i32 %index
  store <2 x i16> %1, ptr %2, align 2, !tbaa !6
  %index.next = add nuw i32 %index, 2
  %3 = icmp eq i32 %index.next, %n.vec
  br i1 %3, label %middle.block, label %vector.body, !llvm.loop !10

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i32 %n, %n.vec
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader9

for.body.preheader9:                              ; preds = %for.body.preheader, %middle.block
  %i.07.ph = phi i32 [ 0, %for.body.preheader ], [ %n.vec, %middle.block ]
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %middle.block, %entry
  ret void

for.body:                                         ; preds = %for.body.preheader9, %for.body
  %i.07 = phi i32 [ %inc, %for.body ], [ %i.07.ph, %for.body.preheader9 ]
  %mul = shl nuw nsw i32 %i.07, 1
  %arrayidx = getelementptr inbounds nuw i16, ptr %in, i32 %mul
  %4 = load i16, ptr %arrayidx, align 2, !tbaa !6
  %add = or disjoint i32 %mul, 1
  %arrayidx2 = getelementptr inbounds nuw i16, ptr %in, i32 %add
  %5 = load i16, ptr %arrayidx2, align 2, !tbaa !6
  %add4 = add i16 %5, %4
  %arrayidx6 = getelementptr inbounds nuw i16, ptr %o, i32 %i.07
  store i16 %add4, ptr %arrayidx6, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.07, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !14
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @int16(ptr noalias nocapture noundef writeonly %o, ptr noalias nocapture noundef readonly %a, ptr noalias nocapture noundef readonly %b, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp7 = icmp sgt i32 %n, 0
  br i1 %cmp7, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry
  %min.iters.check = icmp eq i32 %n, 1
  br i1 %min.iters.check, label %for.body.preheader10, label %vector.ph

vector.ph:                                        ; preds = %for.body.preheader
  %n.vec = and i32 %n, 2147483646
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds nuw i16, ptr %a, i32 %index
  %wide.load = load <2 x i16>, ptr %0, align 2, !tbaa !6
  %.idx = shl nuw nsw i32 %index, 2
  %1 = getelementptr inbounds nuw i8, ptr %o, i32 %.idx
  %2 = getelementptr inbounds nuw i16, ptr %b, i32 %index
  %wide.load9 = load <2 x i16>, ptr %2, align 2, !tbaa !6
  %interleaved.vec = shufflevector <2 x i16> %wide.load, <2 x i16> %wide.load9, <4 x i32> <i32 0, i32 2, i32 1, i32 3>
  store <4 x i16> %interleaved.vec, ptr %1, align 2, !tbaa !6
  %index.next = add nuw i32 %index, 2
  %3 = icmp eq i32 %index.next, %n.vec
  br i1 %3, label %middle.block, label %vector.body, !llvm.loop !15

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i32 %n, %n.vec
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader10

for.body.preheader10:                             ; preds = %for.body.preheader, %middle.block
  %i.08.ph = phi i32 [ 0, %for.body.preheader ], [ %n.vec, %middle.block ]
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %middle.block, %entry
  ret void

for.body:                                         ; preds = %for.body.preheader10, %for.body
  %i.08 = phi i32 [ %inc, %for.body ], [ %i.08.ph, %for.body.preheader10 ]
  %arrayidx = getelementptr inbounds nuw i16, ptr %a, i32 %i.08
  %4 = load i16, ptr %arrayidx, align 2, !tbaa !6
  %mul = shl nuw nsw i32 %i.08, 1
  %arrayidx1 = getelementptr inbounds nuw i16, ptr %o, i32 %mul
  store i16 %4, ptr %arrayidx1, align 2, !tbaa !6
  %arrayidx2 = getelementptr inbounds nuw i16, ptr %b, i32 %i.08
  %5 = load i16, ptr %arrayidx2, align 2, !tbaa !6
  %add = or disjoint i32 %mul, 1
  %arrayidx4 = getelementptr inbounds nuw i16, ptr %o, i32 %add
  store i16 %5, ptr %arrayidx4, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.08, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !16
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @rev16(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, ptr noalias nocapture noundef readonly %c, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp6 = icmp sgt i32 %n, 0
  br i1 %cmp6, label %for.body.lr.ph, label %for.cond.cleanup

for.body.lr.ph:                                   ; preds = %entry
  %0 = getelementptr i16, ptr %b, i32 %n
  %min.iters.check = icmp eq i32 %n, 1
  br i1 %min.iters.check, label %for.body.preheader, label %vector.ph

vector.ph:                                        ; preds = %for.body.lr.ph
  %n.vec = and i32 %n, 2147483646
  %invariant.gep = getelementptr i8, ptr %0, i32 -2
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %1 = xor i32 %index, -1
  %gep = getelementptr i16, ptr %invariant.gep, i32 %1
  %wide.load = load <2 x i16>, ptr %gep, align 2, !tbaa !6
  %reverse = shufflevector <2 x i16> %wide.load, <2 x i16> poison, <2 x i32> <i32 1, i32 0>
  %2 = getelementptr inbounds nuw i16, ptr %c, i32 %index
  %wide.load8 = load <2 x i16>, ptr %2, align 2, !tbaa !6
  %3 = add <2 x i16> %wide.load8, %reverse
  %4 = getelementptr inbounds nuw i16, ptr %a, i32 %index
  store <2 x i16> %3, ptr %4, align 2, !tbaa !6
  %index.next = add nuw i32 %index, 2
  %5 = icmp eq i32 %index.next, %n.vec
  br i1 %5, label %middle.block, label %vector.body, !llvm.loop !17

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i32 %n, %n.vec
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader

for.body.preheader:                               ; preds = %for.body.lr.ph, %middle.block
  %i.07.ph = phi i32 [ 0, %for.body.lr.ph ], [ %n.vec, %middle.block ]
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %middle.block, %entry
  ret void

for.body:                                         ; preds = %for.body.preheader, %for.body
  %i.07 = phi i32 [ %inc, %for.body ], [ %i.07.ph, %for.body.preheader ]
  %6 = xor i32 %i.07, -1
  %arrayidx = getelementptr i16, ptr %0, i32 %6
  %7 = load i16, ptr %arrayidx, align 2, !tbaa !6
  %arrayidx2 = getelementptr inbounds nuw i16, ptr %c, i32 %i.07
  %8 = load i16, ptr %arrayidx2, align 2, !tbaa !6
  %add = add i16 %8, %7
  %arrayidx5 = getelementptr inbounds nuw i16, ptr %a, i32 %i.07
  store i16 %add, ptr %arrayidx5, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.07, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !18
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @rev8(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp5 = icmp sgt i32 %n, 0
  br i1 %cmp5, label %for.body.lr.ph, label %for.cond.cleanup

for.body.lr.ph:                                   ; preds = %entry
  %0 = getelementptr i8, ptr %b, i32 %n
  %min.iters.check = icmp ult i32 %n, 4
  br i1 %min.iters.check, label %for.body.preheader, label %vector.ph

vector.ph:                                        ; preds = %for.body.lr.ph
  %n.vec = and i32 %n, 2147483644
  %invariant.gep = getelementptr i8, ptr %0, i32 -3
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %1 = xor i32 %index, -1
  %gep = getelementptr i8, ptr %invariant.gep, i32 %1
  %wide.load = load <4 x i8>, ptr %gep, align 1, !tbaa !19
  %reverse = shufflevector <4 x i8> %wide.load, <4 x i8> poison, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
  %2 = getelementptr inbounds nuw i8, ptr %a, i32 %index
  store <4 x i8> %reverse, ptr %2, align 1, !tbaa !19
  %index.next = add nuw i32 %index, 4
  %3 = icmp eq i32 %index.next, %n.vec
  br i1 %3, label %middle.block, label %vector.body, !llvm.loop !20

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i32 %n, %n.vec
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader

for.body.preheader:                               ; preds = %for.body.lr.ph, %middle.block
  %i.06.ph = phi i32 [ 0, %for.body.lr.ph ], [ %n.vec, %middle.block ]
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %middle.block, %entry
  ret void

for.body:                                         ; preds = %for.body.preheader, %for.body
  %i.06 = phi i32 [ %inc, %for.body ], [ %i.06.ph, %for.body.preheader ]
  %4 = xor i32 %i.06, -1
  %arrayidx = getelementptr i8, ptr %0, i32 %4
  %5 = load i8, ptr %arrayidx, align 1, !tbaa !19
  %arrayidx2 = getelementptr inbounds nuw i8, ptr %a, i32 %i.06
  store i8 %5, ptr %arrayidx2, align 1, !tbaa !19
  %inc = add nuw nsw i32 %i.06, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !21
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @cond16(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp6 = icmp sgt i32 %n, 0
  br i1 %cmp6, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry
  %min.iters.check = icmp eq i32 %n, 1
  br i1 %min.iters.check, label %for.body.preheader10, label %vector.ph

vector.ph:                                        ; preds = %for.body.preheader
  %n.vec = and i32 %n, 2147483646
  br label %vector.body

vector.body:                                      ; preds = %pred.store.continue9, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %pred.store.continue9 ]
  %0 = getelementptr inbounds nuw i16, ptr %b, i32 %index
  %wide.load = load <2 x i16>, ptr %0, align 2, !tbaa !6
  %1 = icmp sgt <2 x i16> %wide.load, zeroinitializer
  %2 = extractelement <2 x i1> %1, i64 0
  br i1 %2, label %pred.store.if, label %pred.store.continue

pred.store.if:                                    ; preds = %vector.body
  %3 = getelementptr inbounds nuw i16, ptr %a, i32 %index
  %4 = extractelement <2 x i16> %wide.load, i64 0
  store i16 %4, ptr %3, align 2, !tbaa !6
  br label %pred.store.continue

pred.store.continue:                              ; preds = %pred.store.if, %vector.body
  %5 = extractelement <2 x i1> %1, i64 1
  br i1 %5, label %pred.store.if8, label %pred.store.continue9

pred.store.if8:                                   ; preds = %pred.store.continue
  %6 = or disjoint i32 %index, 1
  %7 = getelementptr inbounds nuw i16, ptr %a, i32 %6
  %8 = extractelement <2 x i16> %wide.load, i64 1
  store i16 %8, ptr %7, align 2, !tbaa !6
  br label %pred.store.continue9

pred.store.continue9:                             ; preds = %pred.store.if8, %pred.store.continue
  %index.next = add nuw i32 %index, 2
  %9 = icmp eq i32 %index.next, %n.vec
  br i1 %9, label %middle.block, label %vector.body, !llvm.loop !22

middle.block:                                     ; preds = %pred.store.continue9
  %cmp.n = icmp eq i32 %n, %n.vec
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader10

for.body.preheader10:                             ; preds = %for.body.preheader, %middle.block
  %i.07.ph = phi i32 [ 0, %for.body.preheader ], [ %n.vec, %middle.block ]
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.inc, %middle.block, %entry
  ret void

for.body:                                         ; preds = %for.body.preheader10, %for.inc
  %i.07 = phi i32 [ %inc, %for.inc ], [ %i.07.ph, %for.body.preheader10 ]
  %arrayidx = getelementptr inbounds nuw i16, ptr %b, i32 %i.07
  %10 = load i16, ptr %arrayidx, align 2, !tbaa !6
  %cmp1 = icmp sgt i16 %10, 0
  br i1 %cmp1, label %if.then, label %for.inc

if.then:                                          ; preds = %for.body
  %arrayidx4 = getelementptr inbounds nuw i16, ptr %a, i32 %i.07
  store i16 %10, ptr %arrayidx4, align 2, !tbaa !6
  br label %for.inc

for.inc:                                          ; preds = %for.body, %if.then
  %inc = add nuw nsw i32 %i.07, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !23
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @widen8to16(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp4 = icmp sgt i32 %n, 0
  br i1 %cmp4, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry
  %min.iters.check = icmp eq i32 %n, 1
  br i1 %min.iters.check, label %for.body.preheader6, label %vector.ph

vector.ph:                                        ; preds = %for.body.preheader
  %n.vec = and i32 %n, 2147483646
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds nuw i8, ptr %b, i32 %index
  %wide.load = load <2 x i8>, ptr %0, align 1, !tbaa !19
  %1 = sext <2 x i8> %wide.load to <2 x i16>
  %2 = getelementptr inbounds nuw i16, ptr %a, i32 %index
  store <2 x i16> %1, ptr %2, align 2, !tbaa !6
  %index.next = add nuw i32 %index, 2
  %3 = icmp eq i32 %index.next, %n.vec
  br i1 %3, label %middle.block, label %vector.body, !llvm.loop !24

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i32 %n, %n.vec
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader6

for.body.preheader6:                              ; preds = %for.body.preheader, %middle.block
  %i.05.ph = phi i32 [ 0, %for.body.preheader ], [ %n.vec, %middle.block ]
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %middle.block, %entry
  ret void

for.body:                                         ; preds = %for.body.preheader6, %for.body
  %i.05 = phi i32 [ %inc, %for.body ], [ %i.05.ph, %for.body.preheader6 ]
  %arrayidx = getelementptr inbounds nuw i8, ptr %b, i32 %i.05
  %4 = load i8, ptr %arrayidx, align 1, !tbaa !19
  %conv = sext i8 %4 to i16
  %arrayidx1 = getelementptr inbounds nuw i16, ptr %a, i32 %i.05
  store i16 %conv, ptr %arrayidx1, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.05, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !25
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @narrow16to8(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp4 = icmp sgt i32 %n, 0
  br i1 %cmp4, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry
  %min.iters.check = icmp eq i32 %n, 1
  br i1 %min.iters.check, label %for.body.preheader6, label %vector.ph

vector.ph:                                        ; preds = %for.body.preheader
  %n.vec = and i32 %n, 2147483646
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds nuw i16, ptr %b, i32 %index
  %wide.load = load <2 x i16>, ptr %0, align 2, !tbaa !6
  %1 = lshr <2 x i16> %wide.load, splat (i16 8)
  %2 = trunc nuw <2 x i16> %1 to <2 x i8>
  %3 = getelementptr inbounds nuw i8, ptr %a, i32 %index
  store <2 x i8> %2, ptr %3, align 1, !tbaa !19
  %index.next = add nuw i32 %index, 2
  %4 = icmp eq i32 %index.next, %n.vec
  br i1 %4, label %middle.block, label %vector.body, !llvm.loop !26

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i32 %n, %n.vec
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader6

for.body.preheader6:                              ; preds = %for.body.preheader, %middle.block
  %i.05.ph = phi i32 [ 0, %for.body.preheader ], [ %n.vec, %middle.block ]
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %middle.block, %entry
  ret void

for.body:                                         ; preds = %for.body.preheader6, %for.body
  %i.05 = phi i32 [ %inc, %for.body ], [ %i.05.ph, %for.body.preheader6 ]
  %arrayidx = getelementptr inbounds nuw i16, ptr %b, i32 %i.05
  %5 = load i16, ptr %arrayidx, align 2, !tbaa !6
  %6 = lshr i16 %5, 8
  %conv1 = trunc nuw i16 %6 to i8
  %arrayidx2 = getelementptr inbounds nuw i8, ptr %a, i32 %i.05
  store i8 %conv1, ptr %arrayidx2, align 1, !tbaa !19
  %inc = add nuw nsw i32 %i.05, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !27
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @mulhi16(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, ptr noalias nocapture noundef readonly %c, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp5 = icmp sgt i32 %n, 0
  br i1 %cmp5, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry
  %min.iters.check = icmp eq i32 %n, 1
  br i1 %min.iters.check, label %for.body.preheader8, label %vector.ph

vector.ph:                                        ; preds = %for.body.preheader
  %n.vec = and i32 %n, 2147483646
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds nuw i16, ptr %b, i32 %index
  %wide.load = load <2 x i16>, ptr %0, align 2, !tbaa !6
  %1 = sext <2 x i16> %wide.load to <2 x i32>
  %2 = getelementptr inbounds nuw i16, ptr %c, i32 %index
  %wide.load7 = load <2 x i16>, ptr %2, align 2, !tbaa !6
  %3 = sext <2 x i16> %wide.load7 to <2 x i32>
  %4 = mul nsw <2 x i32> %3, %1
  %5 = lshr <2 x i32> %4, splat (i32 15)
  %6 = trunc <2 x i32> %5 to <2 x i16>
  %7 = getelementptr inbounds nuw i16, ptr %a, i32 %index
  store <2 x i16> %6, ptr %7, align 2, !tbaa !6
  %index.next = add nuw i32 %index, 2
  %8 = icmp eq i32 %index.next, %n.vec
  br i1 %8, label %middle.block, label %vector.body, !llvm.loop !28

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i32 %n, %n.vec
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader8

for.body.preheader8:                              ; preds = %for.body.preheader, %middle.block
  %i.06.ph = phi i32 [ 0, %for.body.preheader ], [ %n.vec, %middle.block ]
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %middle.block, %entry
  ret void

for.body:                                         ; preds = %for.body.preheader8, %for.body
  %i.06 = phi i32 [ %inc, %for.body ], [ %i.06.ph, %for.body.preheader8 ]
  %arrayidx = getelementptr inbounds nuw i16, ptr %b, i32 %i.06
  %9 = load i16, ptr %arrayidx, align 2, !tbaa !6
  %conv = sext i16 %9 to i32
  %arrayidx1 = getelementptr inbounds nuw i16, ptr %c, i32 %i.06
  %10 = load i16, ptr %arrayidx1, align 2, !tbaa !6
  %conv2 = sext i16 %10 to i32
  %mul = mul nsw i32 %conv2, %conv
  %shr = lshr i32 %mul, 15
  %conv3 = trunc i32 %shr to i16
  %arrayidx4 = getelementptr inbounds nuw i16, ptr %a, i32 %i.06
  store i16 %conv3, ptr %arrayidx4, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.06, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !29
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @stride2(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp4 = icmp sgt i32 %n, 0
  br i1 %cmp4, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry
  %min.iters.check = icmp ult i32 %n, 3
  br i1 %min.iters.check, label %for.body.preheader6, label %vector.ph

for.body.preheader6:                              ; preds = %vector.body, %for.body.preheader
  %i.05.ph = phi i32 [ 0, %for.body.preheader ], [ %n.vec, %vector.body ]
  br label %for.body

vector.ph:                                        ; preds = %for.body.preheader
  %.neg = or i32 %n, -2
  %n.vec = add nsw i32 %.neg, %n
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %0 = shl nsw i32 %index, 2
  %1 = getelementptr inbounds nuw i8, ptr %b, i32 %0
  %wide.vec = load <4 x i16>, ptr %1, align 2, !tbaa !6
  %strided.vec = shufflevector <4 x i16> %wide.vec, <4 x i16> poison, <2 x i32> <i32 0, i32 2>
  %2 = getelementptr inbounds nuw i16, ptr %a, i32 %index
  store <2 x i16> %strided.vec, ptr %2, align 2, !tbaa !6
  %index.next = add nuw i32 %index, 2
  %3 = icmp eq i32 %index.next, %n.vec
  br i1 %3, label %for.body.preheader6, label %vector.body, !llvm.loop !30

for.cond.cleanup:                                 ; preds = %for.body, %entry
  ret void

for.body:                                         ; preds = %for.body.preheader6, %for.body
  %i.05 = phi i32 [ %inc, %for.body ], [ %i.05.ph, %for.body.preheader6 ]
  %arrayidx.idx = shl nsw i32 %i.05, 2
  %arrayidx = getelementptr inbounds nuw i8, ptr %b, i32 %arrayidx.idx
  %4 = load i16, ptr %arrayidx, align 2, !tbaa !6
  %arrayidx1 = getelementptr inbounds nuw i16, ptr %a, i32 %i.05
  store i16 %4, ptr %arrayidx1, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.05, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !31
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @idx16(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, ptr noalias nocapture noundef readonly %idx, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp4 = icmp sgt i32 %n, 0
  br i1 %cmp4, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry
  %min.iters.check = icmp eq i32 %n, 1
  br i1 %min.iters.check, label %for.body.preheader6, label %vector.ph

vector.ph:                                        ; preds = %for.body.preheader
  %n.vec = and i32 %n, 2147483646
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds nuw i8, ptr %idx, i32 %index
  %wide.load = load <2 x i8>, ptr %0, align 1, !tbaa !19
  %1 = zext <2 x i8> %wide.load to <2 x i32>
  %2 = extractelement <2 x i32> %1, i64 0
  %3 = getelementptr inbounds nuw i16, ptr %b, i32 %2
  %4 = extractelement <2 x i32> %1, i64 1
  %5 = getelementptr inbounds nuw i16, ptr %b, i32 %4
  %6 = load i16, ptr %3, align 2, !tbaa !6
  %7 = load i16, ptr %5, align 2, !tbaa !6
  %8 = insertelement <2 x i16> poison, i16 %6, i64 0
  %9 = insertelement <2 x i16> %8, i16 %7, i64 1
  %10 = getelementptr inbounds nuw i16, ptr %a, i32 %index
  store <2 x i16> %9, ptr %10, align 2, !tbaa !6
  %index.next = add nuw i32 %index, 2
  %11 = icmp eq i32 %index.next, %n.vec
  br i1 %11, label %middle.block, label %vector.body, !llvm.loop !32

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i32 %n, %n.vec
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader6

for.body.preheader6:                              ; preds = %for.body.preheader, %middle.block
  %i.05.ph = phi i32 [ 0, %for.body.preheader ], [ %n.vec, %middle.block ]
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %middle.block, %entry
  ret void

for.body:                                         ; preds = %for.body.preheader6, %for.body
  %i.05 = phi i32 [ %inc, %for.body ], [ %i.05.ph, %for.body.preheader6 ]
  %arrayidx = getelementptr inbounds nuw i8, ptr %idx, i32 %i.05
  %12 = load i8, ptr %arrayidx, align 1, !tbaa !19
  %idxprom = zext i8 %12 to i32
  %arrayidx1 = getelementptr inbounds nuw i16, ptr %b, i32 %idxprom
  %13 = load i16, ptr %arrayidx1, align 2, !tbaa !6
  %arrayidx2 = getelementptr inbounds nuw i16, ptr %a, i32 %i.05
  store i16 %13, ptr %arrayidx2, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.05, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !33
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read)
define dso_local i32 @find16(ptr noalias nocapture noundef readonly %b, i16 noundef signext %k, i32 noundef %n) local_unnamed_addr #1 {
entry:
  %cmp.not4 = icmp sgt i32 %n, 0
  br i1 %cmp.not4, label %for.body, label %cleanup

for.body:                                         ; preds = %entry, %for.inc
  %i.05 = phi i32 [ %inc, %for.inc ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds nuw i16, ptr %b, i32 %i.05
  %0 = load i16, ptr %arrayidx, align 2, !tbaa !6
  %cmp2 = icmp eq i16 %0, %k
  br i1 %cmp2, label %cleanup, label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nuw nsw i32 %i.05, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %cleanup, label %for.body, !llvm.loop !34

cleanup:                                          ; preds = %for.inc, %for.body, %entry
  %spec.select = phi i32 [ -1, %entry ], [ %i.05, %for.body ], [ -1, %for.inc ]
  ret i32 %spec.select
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: write)
define dso_local void @iota8(ptr nocapture noundef writeonly %a, i32 noundef %n) local_unnamed_addr #2 {
entry:
  %cmp4 = icmp sgt i32 %n, 0
  br i1 %cmp4, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry
  %min.iters.check = icmp ult i32 %n, 4
  br i1 %min.iters.check, label %for.body.preheader6, label %vector.ph

vector.ph:                                        ; preds = %for.body.preheader
  %n.vec = and i32 %n, 2147483644
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %vec.ind = phi <4 x i8> [ <i8 0, i8 1, i8 2, i8 3>, %vector.ph ], [ %vec.ind.next, %vector.body ]
  %0 = getelementptr inbounds nuw i8, ptr %a, i32 %index
  store <4 x i8> %vec.ind, ptr %0, align 1, !tbaa !19
  %index.next = add nuw i32 %index, 4
  %vec.ind.next = add <4 x i8> %vec.ind, splat (i8 4)
  %1 = icmp eq i32 %index.next, %n.vec
  br i1 %1, label %middle.block, label %vector.body, !llvm.loop !35

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i32 %n, %n.vec
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader6

for.body.preheader6:                              ; preds = %for.body.preheader, %middle.block
  %i.05.ph = phi i32 [ 0, %for.body.preheader ], [ %n.vec, %middle.block ]
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %middle.block, %entry
  ret void

for.body:                                         ; preds = %for.body.preheader6, %for.body
  %i.05 = phi i32 [ %inc, %for.body ], [ %i.05.ph, %for.body.preheader6 ]
  %conv = trunc i32 %i.05 to i8
  %arrayidx = getelementptr inbounds nuw i8, ptr %a, i32 %i.05
  store i8 %conv, ptr %arrayidx, align 1, !tbaa !19
  %inc = add nuw nsw i32 %i.05, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !36
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @cadd(ptr noalias nocapture noundef writeonly %o, ptr noalias nocapture noundef readonly %a, ptr noalias nocapture noundef readonly %b, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp11 = icmp sgt i32 %n, 0
  br i1 %cmp11, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry
  %min.iters.check = icmp eq i32 %n, 1
  br i1 %min.iters.check, label %for.body.preheader17, label %vector.ph

vector.ph:                                        ; preds = %for.body.preheader
  %n.vec = and i32 %n, 2147483646
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds nuw %struct.cpx, ptr %a, i32 %index
  %wide.vec = load <4 x i16>, ptr %0, align 2, !tbaa !6
  %1 = getelementptr inbounds nuw %struct.cpx, ptr %b, i32 %index
  %wide.vec14 = load <4 x i16>, ptr %1, align 2, !tbaa !6
  %2 = getelementptr inbounds nuw %struct.cpx, ptr %o, i32 %index
  %interleaved.vec = add <4 x i16> %wide.vec14, %wide.vec
  store <4 x i16> %interleaved.vec, ptr %2, align 2, !tbaa !6
  %index.next = add nuw i32 %index, 2
  %3 = icmp eq i32 %index.next, %n.vec
  br i1 %3, label %middle.block, label %vector.body, !llvm.loop !37

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i32 %n, %n.vec
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader17

for.body.preheader17:                             ; preds = %for.body.preheader, %middle.block
  %i.012.ph = phi i32 [ 0, %for.body.preheader ], [ %n.vec, %middle.block ]
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %middle.block, %entry
  ret void

for.body:                                         ; preds = %for.body.preheader17, %for.body
  %i.012 = phi i32 [ %inc, %for.body ], [ %i.012.ph, %for.body.preheader17 ]
  %arrayidx = getelementptr inbounds nuw %struct.cpx, ptr %a, i32 %i.012
  %arrayidx1 = getelementptr inbounds nuw %struct.cpx, ptr %b, i32 %i.012
  %arrayidx5 = getelementptr inbounds nuw %struct.cpx, ptr %o, i32 %i.012
  %4 = load <2 x i16>, ptr %arrayidx, align 2, !tbaa !6
  %5 = load <2 x i16>, ptr %arrayidx1, align 2, !tbaa !6
  %6 = add <2 x i16> %5, %4
  store <2 x i16> %6, ptr %arrayidx5, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.012, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !38
}

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv32" "target-features"="+unaligned-scalar-mem,+32bit,+c,+m,+relax,+xgap,+xpulpf16alt,+xpulpfvec,+xpulpv,+zfinx,+zhinx,+zhinxmin,+zicsr,+zmmul,-a,-b,-d,-e,-experimental-sdext,-experimental-sdtrig,-experimental-smctr,-experimental-ssctr,-experimental-svukte,-experimental-xqcia,-experimental-xqciac,-experimental-xqcicli,-experimental-xqcicm,-experimental-xqcics,-experimental-xqcicsr,-experimental-xqciint,-experimental-xqcilo,-experimental-xqcilsm,-experimental-xqcisls,-experimental-zalasr,-experimental-zicfilp,-experimental-zicfiss,-experimental-zvbc32e,-experimental-zvkgs,-f,-h,-sha,-shcounterenw,-shgatpa,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcsrind,-smdbltrp,-smepmp,-smmpm,-smnpm,-smrnmi,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssdbltrp,-ssnpm,-sspm,-ssqosid,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-supm,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-svvptc,-v,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xdma,-xfalthalf,-xfaltquarter,-xfauxalthalf,-xfauxaltquarter,-xfauxhalf,-xfauxquarter,-xfauxvecalthalf,-xfauxvecaltquarter,-xfauxvechalf,-xfauxvecquarter,-xfauxvecsingle,-xfexpauxvecalthalf,-xfexpauxvecaltquarter,-xfexpauxvechalf,-xfexpauxvecquarter,-xfquarter,-xfrep,-xfvecalthalf,-xfvecaltquarter,-xfvechalf,-xfvecquarter,-xfvecsingle,-xmempool,-xmipscmove,-xmipslsp,-xsfcease,-xsfvcp,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xssr,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-xwchc,-za128rs,-za64rs,-zaamo,-zabha,-zacas,-zalrsc,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zca,-zcb,-zcd,-zce,-zcf,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfbfmin,-zfh,-zfhmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zifencei,-zihintntl,-zihintpause,-zihpm,-zimop,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-ztso,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfbfmin,-zvfbfwma,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #1 = { nofree norecurse nosync nounwind memory(argmem: read) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv32" "target-features"="+unaligned-scalar-mem,+32bit,+c,+m,+relax,+xgap,+xpulpf16alt,+xpulpfvec,+xpulpv,+zfinx,+zhinx,+zhinxmin,+zicsr,+zmmul,-a,-b,-d,-e,-experimental-sdext,-experimental-sdtrig,-experimental-smctr,-experimental-ssctr,-experimental-svukte,-experimental-xqcia,-experimental-xqciac,-experimental-xqcicli,-experimental-xqcicm,-experimental-xqcics,-experimental-xqcicsr,-experimental-xqciint,-experimental-xqcilo,-experimental-xqcilsm,-experimental-xqcisls,-experimental-zalasr,-experimental-zicfilp,-experimental-zicfiss,-experimental-zvbc32e,-experimental-zvkgs,-f,-h,-sha,-shcounterenw,-shgatpa,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcsrind,-smdbltrp,-smepmp,-smmpm,-smnpm,-smrnmi,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssdbltrp,-ssnpm,-sspm,-ssqosid,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-supm,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-svvptc,-v,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xdma,-xfalthalf,-xfaltquarter,-xfauxalthalf,-xfauxaltquarter,-xfauxhalf,-xfauxquarter,-xfauxvecalthalf,-xfauxvecaltquarter,-xfauxvechalf,-xfauxvecquarter,-xfauxvecsingle,-xfexpauxvecalthalf,-xfexpauxvecaltquarter,-xfexpauxvechalf,-xfexpauxvecquarter,-xfquarter,-xfrep,-xfvecalthalf,-xfvecaltquarter,-xfvechalf,-xfvecquarter,-xfvecsingle,-xmempool,-xmipscmove,-xmipslsp,-xsfcease,-xsfvcp,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xssr,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-xwchc,-za128rs,-za64rs,-zaamo,-zabha,-zacas,-zalrsc,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zca,-zcb,-zcd,-zce,-zcf,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfbfmin,-zfh,-zfhmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zifencei,-zihintntl,-zihintpause,-zihpm,-zimop,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-ztso,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfbfmin,-zvfbfwma,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #2 = { nofree norecurse nosync nounwind memory(argmem: write) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv32" "target-features"="+unaligned-scalar-mem,+32bit,+c,+m,+relax,+xgap,+xpulpf16alt,+xpulpfvec,+xpulpv,+zfinx,+zhinx,+zhinxmin,+zicsr,+zmmul,-a,-b,-d,-e,-experimental-sdext,-experimental-sdtrig,-experimental-smctr,-experimental-ssctr,-experimental-svukte,-experimental-xqcia,-experimental-xqciac,-experimental-xqcicli,-experimental-xqcicm,-experimental-xqcics,-experimental-xqcicsr,-experimental-xqciint,-experimental-xqcilo,-experimental-xqcilsm,-experimental-xqcisls,-experimental-zalasr,-experimental-zicfilp,-experimental-zicfiss,-experimental-zvbc32e,-experimental-zvkgs,-f,-h,-sha,-shcounterenw,-shgatpa,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcsrind,-smdbltrp,-smepmp,-smmpm,-smnpm,-smrnmi,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssdbltrp,-ssnpm,-sspm,-ssqosid,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-supm,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-svvptc,-v,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xdma,-xfalthalf,-xfaltquarter,-xfauxalthalf,-xfauxaltquarter,-xfauxhalf,-xfauxquarter,-xfauxvecalthalf,-xfauxvecaltquarter,-xfauxvechalf,-xfauxvecquarter,-xfauxvecsingle,-xfexpauxvecalthalf,-xfexpauxvecaltquarter,-xfexpauxvechalf,-xfexpauxvecquarter,-xfquarter,-xfrep,-xfvecalthalf,-xfvecaltquarter,-xfvechalf,-xfvecquarter,-xfvecsingle,-xmempool,-xmipscmove,-xmipslsp,-xsfcease,-xsfvcp,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xssr,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-xwchc,-za128rs,-za64rs,-zaamo,-zabha,-zacas,-zalrsc,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zca,-zcb,-zcd,-zce,-zcf,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfbfmin,-zfh,-zfhmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zifencei,-zihintntl,-zihintpause,-zihpm,-zimop,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-ztso,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfbfmin,-zvfbfwma,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }

!llvm.module.flags = !{!0, !1, !2, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"target-abi", !"ilp32"}
!2 = !{i32 6, !"riscv-isa", !3}
!3 = !{!"rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_zhinx1p0_zhinxmin1p0_xgap9p0_xpulpf16alt1p0_xpulpfvec1p0_xpulpv2p0"}
!4 = !{i32 8, !"SmallDataLimit", i32 0}
!5 = !{!"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 26e7268c3127ca9bc091afe463af37b621353e71)"}
!6 = !{!7, !7, i64 0}
!7 = !{!"short", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = distinct !{!10, !11, !12, !13}
!11 = !{!"llvm.loop.mustprogress"}
!12 = !{!"llvm.loop.isvectorized", i32 1}
!13 = !{!"llvm.loop.unroll.runtime.disable"}
!14 = distinct !{!14, !11, !13, !12}
!15 = distinct !{!15, !11, !12, !13}
!16 = distinct !{!16, !11, !13, !12}
!17 = distinct !{!17, !11, !12, !13}
!18 = distinct !{!18, !11, !13, !12}
!19 = !{!8, !8, i64 0}
!20 = distinct !{!20, !11, !12, !13}
!21 = distinct !{!21, !11, !13, !12}
!22 = distinct !{!22, !11, !12, !13}
!23 = distinct !{!23, !11, !13, !12}
!24 = distinct !{!24, !11, !12, !13}
!25 = distinct !{!25, !11, !13, !12}
!26 = distinct !{!26, !11, !12, !13}
!27 = distinct !{!27, !11, !13, !12}
!28 = distinct !{!28, !11, !12, !13}
!29 = distinct !{!29, !11, !13, !12}
!30 = distinct !{!30, !11, !12, !13}
!31 = distinct !{!31, !11, !13, !12}
!32 = distinct !{!32, !11, !12, !13}
!33 = distinct !{!33, !11, !13, !12}
!34 = distinct !{!34, !11}
!35 = distinct !{!35, !11, !12, !13}
!36 = distinct !{!36, !11, !13, !12}
!37 = distinct !{!37, !11, !12, !13}
!38 = distinct !{!38, !11, !13, !12}
