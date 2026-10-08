; ModuleID = '/home/ubuntu/llvm-project/pulp-llvm-port/benchmarks/autovec-probe/investigation/out/exp/base/loops2.O0.ll'
source_filename = "/home/ubuntu/llvm-project/pulp-llvm-port/benchmarks/autovec-probe/investigation/loops2.c"
target datalayout = "e-m:e-p:32:32-i64:64-n32-S128"
target triple = "riscv32-unknown-unknown-elf"

@GB = dso_local local_unnamed_addr global [64 x i16] zeroinitializer, align 4
@GC = dso_local local_unnamed_addr global [64 x i16] zeroinitializer, align 4
@GA = dso_local local_unnamed_addr global [64 x i16] zeroinitializer, align 4

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @add16(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, ptr noalias nocapture noundef readonly %c, i32 noundef %n) local_unnamed_addr #0 {
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
  %1 = getelementptr inbounds nuw i16, ptr %c, i32 %index
  %wide.load7 = load <2 x i16>, ptr %1, align 2, !tbaa !6
  %2 = add <2 x i16> %wide.load7, %wide.load
  %3 = getelementptr inbounds nuw i16, ptr %a, i32 %index
  store <2 x i16> %2, ptr %3, align 2, !tbaa !6
  %index.next = add nuw i32 %index, 2
  %4 = icmp eq i32 %index.next, %n.vec
  br i1 %4, label %middle.block, label %vector.body, !llvm.loop !10

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
  %5 = load i16, ptr %arrayidx, align 2, !tbaa !6
  %arrayidx1 = getelementptr inbounds nuw i16, ptr %c, i32 %i.06
  %6 = load i16, ptr %arrayidx1, align 2, !tbaa !6
  %add = add i16 %6, %5
  %arrayidx4 = getelementptr inbounds nuw i16, ptr %a, i32 %i.06
  store i16 %add, ptr %arrayidx4, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.06, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !14
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @add8(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, ptr noalias nocapture noundef readonly %c, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp5 = icmp sgt i32 %n, 0
  br i1 %cmp5, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry
  %min.iters.check = icmp ult i32 %n, 4
  br i1 %min.iters.check, label %for.body.preheader8, label %vector.ph

vector.ph:                                        ; preds = %for.body.preheader
  %n.vec = and i32 %n, 2147483644
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds nuw i8, ptr %b, i32 %index
  %wide.load = load <4 x i8>, ptr %0, align 1, !tbaa !15
  %1 = getelementptr inbounds nuw i8, ptr %c, i32 %index
  %wide.load7 = load <4 x i8>, ptr %1, align 1, !tbaa !15
  %2 = add <4 x i8> %wide.load7, %wide.load
  %3 = getelementptr inbounds nuw i8, ptr %a, i32 %index
  store <4 x i8> %2, ptr %3, align 1, !tbaa !15
  %index.next = add nuw i32 %index, 4
  %4 = icmp eq i32 %index.next, %n.vec
  br i1 %4, label %middle.block, label %vector.body, !llvm.loop !16

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
  %arrayidx = getelementptr inbounds nuw i8, ptr %b, i32 %i.06
  %5 = load i8, ptr %arrayidx, align 1, !tbaa !15
  %arrayidx1 = getelementptr inbounds nuw i8, ptr %c, i32 %i.06
  %6 = load i8, ptr %arrayidx1, align 1, !tbaa !15
  %add = add i8 %6, %5
  %arrayidx4 = getelementptr inbounds nuw i8, ptr %a, i32 %i.06
  store i8 %add, ptr %arrayidx4, align 1, !tbaa !15
  %inc = add nuw nsw i32 %i.06, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !17
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @sub16(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, ptr noalias nocapture noundef readonly %c, i32 noundef %n) local_unnamed_addr #0 {
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
  %1 = getelementptr inbounds nuw i16, ptr %c, i32 %index
  %wide.load7 = load <2 x i16>, ptr %1, align 2, !tbaa !6
  %2 = sub <2 x i16> %wide.load, %wide.load7
  %3 = getelementptr inbounds nuw i16, ptr %a, i32 %index
  store <2 x i16> %2, ptr %3, align 2, !tbaa !6
  %index.next = add nuw i32 %index, 2
  %4 = icmp eq i32 %index.next, %n.vec
  br i1 %4, label %middle.block, label %vector.body, !llvm.loop !18

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
  %5 = load i16, ptr %arrayidx, align 2, !tbaa !6
  %arrayidx1 = getelementptr inbounds nuw i16, ptr %c, i32 %i.06
  %6 = load i16, ptr %arrayidx1, align 2, !tbaa !6
  %sub = sub i16 %5, %6
  %arrayidx4 = getelementptr inbounds nuw i16, ptr %a, i32 %i.06
  store i16 %sub, ptr %arrayidx4, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.06, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !19
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @and16(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, ptr noalias nocapture noundef readonly %c, i32 noundef %n) local_unnamed_addr #0 {
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
  %0 = getelementptr inbounds nuw i16, ptr %b, i32 %index
  %wide.load = load <2 x i16>, ptr %0, align 2, !tbaa !6
  %1 = getelementptr inbounds nuw i16, ptr %c, i32 %index
  %wide.load8 = load <2 x i16>, ptr %1, align 2, !tbaa !6
  %2 = and <2 x i16> %wide.load8, %wide.load
  %3 = getelementptr inbounds nuw i16, ptr %a, i32 %index
  store <2 x i16> %2, ptr %3, align 2, !tbaa !6
  %index.next = add nuw i32 %index, 2
  %4 = icmp eq i32 %index.next, %n.vec
  br i1 %4, label %middle.block, label %vector.body, !llvm.loop !20

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
  %arrayidx = getelementptr inbounds nuw i16, ptr %b, i32 %i.07
  %5 = load i16, ptr %arrayidx, align 2, !tbaa !6
  %arrayidx1 = getelementptr inbounds nuw i16, ptr %c, i32 %i.07
  %6 = load i16, ptr %arrayidx1, align 2, !tbaa !6
  %and5 = and i16 %6, %5
  %arrayidx4 = getelementptr inbounds nuw i16, ptr %a, i32 %i.07
  store i16 %and5, ptr %arrayidx4, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.07, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !21
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @min16(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, ptr noalias nocapture noundef readonly %c, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp9 = icmp sgt i32 %n, 0
  br i1 %cmp9, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry
  %min.iters.check = icmp eq i32 %n, 1
  br i1 %min.iters.check, label %for.body.preheader12, label %vector.ph

vector.ph:                                        ; preds = %for.body.preheader
  %n.vec = and i32 %n, 2147483646
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds nuw i16, ptr %b, i32 %index
  %wide.load = load <2 x i16>, ptr %0, align 2, !tbaa !6
  %1 = getelementptr inbounds nuw i16, ptr %c, i32 %index
  %wide.load11 = load <2 x i16>, ptr %1, align 2, !tbaa !6
  %2 = tail call <2 x i16> @llvm.smin.v2i16(<2 x i16> %wide.load, <2 x i16> %wide.load11)
  %3 = getelementptr inbounds nuw i16, ptr %a, i32 %index
  store <2 x i16> %2, ptr %3, align 2, !tbaa !6
  %index.next = add nuw i32 %index, 2
  %4 = icmp eq i32 %index.next, %n.vec
  br i1 %4, label %middle.block, label %vector.body, !llvm.loop !22

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i32 %n, %n.vec
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader12

for.body.preheader12:                             ; preds = %for.body.preheader, %middle.block
  %i.010.ph = phi i32 [ 0, %for.body.preheader ], [ %n.vec, %middle.block ]
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %middle.block, %entry
  ret void

for.body:                                         ; preds = %for.body.preheader12, %for.body
  %i.010 = phi i32 [ %inc, %for.body ], [ %i.010.ph, %for.body.preheader12 ]
  %arrayidx = getelementptr inbounds nuw i16, ptr %b, i32 %i.010
  %5 = load i16, ptr %arrayidx, align 2, !tbaa !6
  %arrayidx1 = getelementptr inbounds nuw i16, ptr %c, i32 %i.010
  %6 = load i16, ptr %arrayidx1, align 2, !tbaa !6
  %. = tail call i16 @llvm.smin.i16(i16 %5, i16 %6)
  %arrayidx10 = getelementptr inbounds nuw i16, ptr %a, i32 %i.010
  store i16 %., ptr %arrayidx10, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.010, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !23
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @max8(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, ptr noalias nocapture noundef readonly %c, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp9 = icmp sgt i32 %n, 0
  br i1 %cmp9, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry
  %min.iters.check = icmp ult i32 %n, 4
  br i1 %min.iters.check, label %for.body.preheader12, label %vector.ph

vector.ph:                                        ; preds = %for.body.preheader
  %n.vec = and i32 %n, 2147483644
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds nuw i8, ptr %b, i32 %index
  %wide.load = load <4 x i8>, ptr %0, align 1, !tbaa !15
  %1 = getelementptr inbounds nuw i8, ptr %c, i32 %index
  %wide.load11 = load <4 x i8>, ptr %1, align 1, !tbaa !15
  %2 = tail call <4 x i8> @llvm.smax.v4i8(<4 x i8> %wide.load, <4 x i8> %wide.load11)
  %3 = getelementptr inbounds nuw i8, ptr %a, i32 %index
  store <4 x i8> %2, ptr %3, align 1, !tbaa !15
  %index.next = add nuw i32 %index, 4
  %4 = icmp eq i32 %index.next, %n.vec
  br i1 %4, label %middle.block, label %vector.body, !llvm.loop !24

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i32 %n, %n.vec
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader12

for.body.preheader12:                             ; preds = %for.body.preheader, %middle.block
  %i.010.ph = phi i32 [ 0, %for.body.preheader ], [ %n.vec, %middle.block ]
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %middle.block, %entry
  ret void

for.body:                                         ; preds = %for.body.preheader12, %for.body
  %i.010 = phi i32 [ %inc, %for.body ], [ %i.010.ph, %for.body.preheader12 ]
  %arrayidx = getelementptr inbounds nuw i8, ptr %b, i32 %i.010
  %5 = load i8, ptr %arrayidx, align 1, !tbaa !15
  %arrayidx1 = getelementptr inbounds nuw i8, ptr %c, i32 %i.010
  %6 = load i8, ptr %arrayidx1, align 1, !tbaa !15
  %. = tail call i8 @llvm.smax.i8(i8 %5, i8 %6)
  %arrayidx10 = getelementptr inbounds nuw i8, ptr %a, i32 %i.010
  store i8 %., ptr %arrayidx10, align 1, !tbaa !15
  %inc = add nuw nsw i32 %i.010, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !25
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @maxu8(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, ptr noalias nocapture noundef readonly %c, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp9 = icmp sgt i32 %n, 0
  br i1 %cmp9, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry
  %min.iters.check = icmp ult i32 %n, 4
  br i1 %min.iters.check, label %for.body.preheader12, label %vector.ph

vector.ph:                                        ; preds = %for.body.preheader
  %n.vec = and i32 %n, 2147483644
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds nuw i8, ptr %b, i32 %index
  %wide.load = load <4 x i8>, ptr %0, align 1, !tbaa !15
  %1 = getelementptr inbounds nuw i8, ptr %c, i32 %index
  %wide.load11 = load <4 x i8>, ptr %1, align 1, !tbaa !15
  %2 = tail call <4 x i8> @llvm.umax.v4i8(<4 x i8> %wide.load, <4 x i8> %wide.load11)
  %3 = getelementptr inbounds nuw i8, ptr %a, i32 %index
  store <4 x i8> %2, ptr %3, align 1, !tbaa !15
  %index.next = add nuw i32 %index, 4
  %4 = icmp eq i32 %index.next, %n.vec
  br i1 %4, label %middle.block, label %vector.body, !llvm.loop !26

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i32 %n, %n.vec
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader12

for.body.preheader12:                             ; preds = %for.body.preheader, %middle.block
  %i.010.ph = phi i32 [ 0, %for.body.preheader ], [ %n.vec, %middle.block ]
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %middle.block, %entry
  ret void

for.body:                                         ; preds = %for.body.preheader12, %for.body
  %i.010 = phi i32 [ %inc, %for.body ], [ %i.010.ph, %for.body.preheader12 ]
  %arrayidx = getelementptr inbounds nuw i8, ptr %b, i32 %i.010
  %5 = load i8, ptr %arrayidx, align 1, !tbaa !15
  %arrayidx1 = getelementptr inbounds nuw i8, ptr %c, i32 %i.010
  %6 = load i8, ptr %arrayidx1, align 1, !tbaa !15
  %. = tail call i8 @llvm.umax.i8(i8 %5, i8 %6)
  %arrayidx10 = getelementptr inbounds nuw i8, ptr %a, i32 %i.010
  store i8 %., ptr %arrayidx10, align 1, !tbaa !15
  %inc = add nuw nsw i32 %i.010, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !27
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @abs16(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp8 = icmp sgt i32 %n, 0
  br i1 %cmp8, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry
  %min.iters.check = icmp eq i32 %n, 1
  br i1 %min.iters.check, label %for.body.preheader10, label %vector.ph

vector.ph:                                        ; preds = %for.body.preheader
  %n.vec = and i32 %n, 2147483646
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds nuw i16, ptr %b, i32 %index
  %wide.load = load <2 x i16>, ptr %0, align 2, !tbaa !6
  %1 = tail call <2 x i16> @llvm.abs.v2i16(<2 x i16> %wide.load, i1 false)
  %2 = getelementptr inbounds nuw i16, ptr %a, i32 %index
  store <2 x i16> %1, ptr %2, align 2, !tbaa !6
  %index.next = add nuw i32 %index, 2
  %3 = icmp eq i32 %index.next, %n.vec
  br i1 %3, label %middle.block, label %vector.body, !llvm.loop !28

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i32 %n, %n.vec
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader10

for.body.preheader10:                             ; preds = %for.body.preheader, %middle.block
  %i.09.ph = phi i32 [ 0, %for.body.preheader ], [ %n.vec, %middle.block ]
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %middle.block, %entry
  ret void

for.body:                                         ; preds = %for.body.preheader10, %for.body
  %i.09 = phi i32 [ %inc, %for.body ], [ %i.09.ph, %for.body.preheader10 ]
  %arrayidx = getelementptr inbounds nuw i16, ptr %b, i32 %i.09
  %4 = load i16, ptr %arrayidx, align 2, !tbaa !6
  %cond = tail call i16 @llvm.abs.i16(i16 %4, i1 false)
  %arrayidx8 = getelementptr inbounds nuw i16, ptr %a, i32 %i.09
  store i16 %cond, ptr %arrayidx8, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.09, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !29
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @shr16(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, i32 noundef %n) local_unnamed_addr #0 {
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
  %1 = ashr <2 x i16> %wide.load, splat (i16 3)
  %2 = getelementptr inbounds nuw i16, ptr %a, i32 %index
  store <2 x i16> %1, ptr %2, align 2, !tbaa !6
  %index.next = add nuw i32 %index, 2
  %3 = icmp eq i32 %index.next, %n.vec
  br i1 %3, label %middle.block, label %vector.body, !llvm.loop !30

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
  %4 = load i16, ptr %arrayidx, align 2, !tbaa !6
  %5 = ashr i16 %4, 3
  %arrayidx2 = getelementptr inbounds nuw i16, ptr %a, i32 %i.05
  store i16 %5, ptr %arrayidx2, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.05, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !31
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @shl8(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, i32 noundef %n) local_unnamed_addr #0 {
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
  %0 = getelementptr inbounds nuw i8, ptr %b, i32 %index
  %wide.load = load <4 x i8>, ptr %0, align 1, !tbaa !15
  %1 = shl <4 x i8> %wide.load, splat (i8 2)
  %2 = getelementptr inbounds nuw i8, ptr %a, i32 %index
  store <4 x i8> %1, ptr %2, align 1, !tbaa !15
  %index.next = add nuw i32 %index, 4
  %3 = icmp eq i32 %index.next, %n.vec
  br i1 %3, label %middle.block, label %vector.body, !llvm.loop !32

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
  %4 = load i8, ptr %arrayidx, align 1, !tbaa !15
  %shl = shl i8 %4, 2
  %arrayidx2 = getelementptr inbounds nuw i8, ptr %a, i32 %i.05
  store i8 %shl, ptr %arrayidx2, align 1, !tbaa !15
  %inc = add nuw nsw i32 %i.05, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !33
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @shrv16(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, i32 noundef %s, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp4 = icmp sgt i32 %n, 0
  br i1 %cmp4, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry
  %min.iters.check = icmp eq i32 %n, 1
  br i1 %min.iters.check, label %for.body.preheader6, label %vector.ph

vector.ph:                                        ; preds = %for.body.preheader
  %n.vec = and i32 %n, 2147483646
  %broadcast.splatinsert = insertelement <2 x i32> poison, i32 %s, i64 0
  %broadcast.splat = shufflevector <2 x i32> %broadcast.splatinsert, <2 x i32> poison, <2 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds nuw i16, ptr %b, i32 %index
  %wide.load = load <2 x i16>, ptr %0, align 2, !tbaa !6
  %1 = sext <2 x i16> %wide.load to <2 x i32>
  %2 = ashr <2 x i32> %1, %broadcast.splat
  %3 = trunc nsw <2 x i32> %2 to <2 x i16>
  %4 = getelementptr inbounds nuw i16, ptr %a, i32 %index
  store <2 x i16> %3, ptr %4, align 2, !tbaa !6
  %index.next = add nuw i32 %index, 2
  %5 = icmp eq i32 %index.next, %n.vec
  br i1 %5, label %middle.block, label %vector.body, !llvm.loop !34

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
  %6 = load i16, ptr %arrayidx, align 2, !tbaa !6
  %conv = sext i16 %6 to i32
  %shr = ashr i32 %conv, %s
  %conv1 = trunc nsw i32 %shr to i16
  %arrayidx2 = getelementptr inbounds nuw i16, ptr %a, i32 %i.05
  store i16 %conv1, ptr %arrayidx2, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.05, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !35
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @addc16(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, i32 noundef %n) local_unnamed_addr #0 {
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
  %1 = add <2 x i16> %wide.load, splat (i16 5)
  %2 = getelementptr inbounds nuw i16, ptr %a, i32 %index
  store <2 x i16> %1, ptr %2, align 2, !tbaa !6
  %index.next = add nuw i32 %index, 2
  %3 = icmp eq i32 %index.next, %n.vec
  br i1 %3, label %middle.block, label %vector.body, !llvm.loop !36

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
  %4 = load i16, ptr %arrayidx, align 2, !tbaa !6
  %add = add i16 %4, 5
  %arrayidx2 = getelementptr inbounds nuw i16, ptr %a, i32 %i.05
  store i16 %add, ptr %arrayidx2, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.05, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !37
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @adds16(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, i16 noundef signext %k, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp4 = icmp sgt i32 %n, 0
  br i1 %cmp4, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry
  %min.iters.check = icmp eq i32 %n, 1
  br i1 %min.iters.check, label %for.body.preheader6, label %vector.ph

vector.ph:                                        ; preds = %for.body.preheader
  %n.vec = and i32 %n, 2147483646
  %broadcast.splatinsert = insertelement <2 x i16> poison, i16 %k, i64 0
  %broadcast.splat = shufflevector <2 x i16> %broadcast.splatinsert, <2 x i16> poison, <2 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds nuw i16, ptr %b, i32 %index
  %wide.load = load <2 x i16>, ptr %0, align 2, !tbaa !6
  %1 = add <2 x i16> %wide.load, %broadcast.splat
  %2 = getelementptr inbounds nuw i16, ptr %a, i32 %index
  store <2 x i16> %1, ptr %2, align 2, !tbaa !6
  %index.next = add nuw i32 %index, 2
  %3 = icmp eq i32 %index.next, %n.vec
  br i1 %3, label %middle.block, label %vector.body, !llvm.loop !38

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
  %4 = load i16, ptr %arrayidx, align 2, !tbaa !6
  %add = add i16 %4, %k
  %arrayidx3 = getelementptr inbounds nuw i16, ptr %a, i32 %i.05
  store i16 %add, ptr %arrayidx3, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.05, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !39
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @scale16(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, i32 noundef %n) local_unnamed_addr #0 {
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
  %1 = mul <2 x i16> %wide.load, splat (i16 3)
  %2 = getelementptr inbounds nuw i16, ptr %a, i32 %index
  store <2 x i16> %1, ptr %2, align 2, !tbaa !6
  %index.next = add nuw i32 %index, 2
  %3 = icmp eq i32 %index.next, %n.vec
  br i1 %3, label %middle.block, label %vector.body, !llvm.loop !40

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
  %4 = load i16, ptr %arrayidx, align 2, !tbaa !6
  %mul = mul i16 %4, 3
  %arrayidx2 = getelementptr inbounds nuw i16, ptr %a, i32 %i.05
  store i16 %mul, ptr %arrayidx2, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.05, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !41
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @scaleq15(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, i16 noundef signext %k, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp4 = icmp sgt i32 %n, 0
  br i1 %cmp4, label %for.body.lr.ph, label %for.cond.cleanup

for.body.lr.ph:                                   ; preds = %entry
  %conv1 = sext i16 %k to i32
  %min.iters.check = icmp eq i32 %n, 1
  br i1 %min.iters.check, label %for.body.preheader, label %vector.ph

vector.ph:                                        ; preds = %for.body.lr.ph
  %n.vec = and i32 %n, 2147483646
  %broadcast.splatinsert = insertelement <2 x i32> poison, i32 %conv1, i64 0
  %broadcast.splat = shufflevector <2 x i32> %broadcast.splatinsert, <2 x i32> poison, <2 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds nuw i16, ptr %b, i32 %index
  %wide.load = load <2 x i16>, ptr %0, align 2, !tbaa !6
  %1 = sext <2 x i16> %wide.load to <2 x i32>
  %2 = mul nsw <2 x i32> %broadcast.splat, %1
  %3 = lshr <2 x i32> %2, splat (i32 15)
  %4 = trunc <2 x i32> %3 to <2 x i16>
  %5 = getelementptr inbounds nuw i16, ptr %a, i32 %index
  store <2 x i16> %4, ptr %5, align 2, !tbaa !6
  %index.next = add nuw i32 %index, 2
  %6 = icmp eq i32 %index.next, %n.vec
  br i1 %6, label %middle.block, label %vector.body, !llvm.loop !42

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i32 %n, %n.vec
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader

for.body.preheader:                               ; preds = %for.body.lr.ph, %middle.block
  %i.05.ph = phi i32 [ 0, %for.body.lr.ph ], [ %n.vec, %middle.block ]
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %middle.block, %entry
  ret void

for.body:                                         ; preds = %for.body.preheader, %for.body
  %i.05 = phi i32 [ %inc, %for.body ], [ %i.05.ph, %for.body.preheader ]
  %arrayidx = getelementptr inbounds nuw i16, ptr %b, i32 %i.05
  %7 = load i16, ptr %arrayidx, align 2, !tbaa !6
  %conv = sext i16 %7 to i32
  %mul = mul nsw i32 %conv, %conv1
  %shr = lshr i32 %mul, 15
  %conv2 = trunc i32 %shr to i16
  %arrayidx3 = getelementptr inbounds nuw i16, ptr %a, i32 %i.05
  store i16 %conv2, ptr %arrayidx3, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.05, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !43
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @mul16(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, ptr noalias nocapture noundef readonly %c, i32 noundef %n) local_unnamed_addr #0 {
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
  %1 = getelementptr inbounds nuw i16, ptr %c, i32 %index
  %wide.load7 = load <2 x i16>, ptr %1, align 2, !tbaa !6
  %2 = mul <2 x i16> %wide.load7, %wide.load
  %3 = getelementptr inbounds nuw i16, ptr %a, i32 %index
  store <2 x i16> %2, ptr %3, align 2, !tbaa !6
  %index.next = add nuw i32 %index, 2
  %4 = icmp eq i32 %index.next, %n.vec
  br i1 %4, label %middle.block, label %vector.body, !llvm.loop !44

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
  %5 = load i16, ptr %arrayidx, align 2, !tbaa !6
  %arrayidx1 = getelementptr inbounds nuw i16, ptr %c, i32 %i.06
  %6 = load i16, ptr %arrayidx1, align 2, !tbaa !6
  %mul = mul i16 %6, %5
  %arrayidx4 = getelementptr inbounds nuw i16, ptr %a, i32 %i.06
  store i16 %mul, ptr %arrayidx4, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.06, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !45
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
define dso_local void @copy16(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, i32 noundef %n) local_unnamed_addr #1 {
entry:
  %cmp4 = icmp sgt i32 %n, 0
  br i1 %cmp4, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry
  %0 = shl nuw i32 %n, 1
  tail call void @llvm.memcpy.p0.p0.i32(ptr align 2 %a, ptr align 2 %b, i32 %0, i1 false), !tbaa !6
  br label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.body.preheader, %entry
  ret void
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: write)
define dso_local void @set16(ptr nocapture noundef writeonly %a, i16 noundef signext %k, i32 noundef %n) local_unnamed_addr #2 {
entry:
  %cmp3 = icmp sgt i32 %n, 0
  br i1 %cmp3, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry
  %min.iters.check = icmp eq i32 %n, 1
  br i1 %min.iters.check, label %for.body.preheader5, label %vector.ph

vector.ph:                                        ; preds = %for.body.preheader
  %n.vec = and i32 %n, 2147483646
  %broadcast.splatinsert = insertelement <2 x i16> poison, i16 %k, i64 0
  %broadcast.splat = shufflevector <2 x i16> %broadcast.splatinsert, <2 x i16> poison, <2 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds nuw i16, ptr %a, i32 %index
  store <2 x i16> %broadcast.splat, ptr %0, align 2, !tbaa !6
  %index.next = add nuw i32 %index, 2
  %1 = icmp eq i32 %index.next, %n.vec
  br i1 %1, label %middle.block, label %vector.body, !llvm.loop !46

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i32 %n, %n.vec
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader5

for.body.preheader5:                              ; preds = %for.body.preheader, %middle.block
  %i.04.ph = phi i32 [ 0, %for.body.preheader ], [ %n.vec, %middle.block ]
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %middle.block, %entry
  ret void

for.body:                                         ; preds = %for.body.preheader5, %for.body
  %i.04 = phi i32 [ %inc, %for.body ], [ %i.04.ph, %for.body.preheader5 ]
  %arrayidx = getelementptr inbounds nuw i16, ptr %a, i32 %i.04
  store i16 %k, ptr %arrayidx, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.04, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !47
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @avg8(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, ptr noalias nocapture noundef readonly %c, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp5 = icmp sgt i32 %n, 0
  br i1 %cmp5, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry
  %min.iters.check = icmp ult i32 %n, 4
  br i1 %min.iters.check, label %for.body.preheader8, label %vector.ph

vector.ph:                                        ; preds = %for.body.preheader
  %n.vec = and i32 %n, 2147483644
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds nuw i8, ptr %b, i32 %index
  %wide.load = load <4 x i8>, ptr %0, align 1, !tbaa !15
  %1 = zext <4 x i8> %wide.load to <4 x i16>
  %2 = getelementptr inbounds nuw i8, ptr %c, i32 %index
  %wide.load7 = load <4 x i8>, ptr %2, align 1, !tbaa !15
  %3 = zext <4 x i8> %wide.load7 to <4 x i16>
  %4 = add nuw nsw <4 x i16> %1, splat (i16 1)
  %5 = add nuw nsw <4 x i16> %4, %3
  %6 = lshr <4 x i16> %5, splat (i16 1)
  %7 = trunc <4 x i16> %6 to <4 x i8>
  %8 = getelementptr inbounds nuw i8, ptr %a, i32 %index
  store <4 x i8> %7, ptr %8, align 1, !tbaa !15
  %index.next = add nuw i32 %index, 4
  %9 = icmp eq i32 %index.next, %n.vec
  br i1 %9, label %middle.block, label %vector.body, !llvm.loop !48

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
  %arrayidx = getelementptr inbounds nuw i8, ptr %b, i32 %i.06
  %10 = load i8, ptr %arrayidx, align 1, !tbaa !15
  %conv = zext i8 %10 to i16
  %arrayidx1 = getelementptr inbounds nuw i8, ptr %c, i32 %i.06
  %11 = load i8, ptr %arrayidx1, align 1, !tbaa !15
  %conv2 = zext i8 %11 to i16
  %add = add nuw nsw i16 %conv, 1
  %add3 = add nuw nsw i16 %add, %conv2
  %shr = lshr i16 %add3, 1
  %conv4 = trunc nuw i16 %shr to i8
  %arrayidx5 = getelementptr inbounds nuw i8, ptr %a, i32 %i.06
  store i8 %conv4, ptr %arrayidx5, align 1, !tbaa !15
  %inc = add nuw nsw i32 %i.06, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !49
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @sat16(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, ptr noalias nocapture noundef readonly %c, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp8 = icmp sgt i32 %n, 0
  br i1 %cmp8, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry
  %min.iters.check = icmp eq i32 %n, 1
  br i1 %min.iters.check, label %for.body.preheader11, label %vector.ph

vector.ph:                                        ; preds = %for.body.preheader
  %n.vec = and i32 %n, 2147483646
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds nuw i16, ptr %b, i32 %index
  %wide.load = load <2 x i16>, ptr %0, align 2, !tbaa !6
  %1 = getelementptr inbounds nuw i16, ptr %c, i32 %index
  %wide.load10 = load <2 x i16>, ptr %1, align 2, !tbaa !6
  %2 = tail call <2 x i16> @llvm.sadd.sat.v2i16(<2 x i16> %wide.load, <2 x i16> %wide.load10)
  %3 = getelementptr inbounds nuw i16, ptr %a, i32 %index
  store <2 x i16> %2, ptr %3, align 2, !tbaa !6
  %index.next = add nuw i32 %index, 2
  %4 = icmp eq i32 %index.next, %n.vec
  br i1 %4, label %middle.block, label %vector.body, !llvm.loop !50

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i32 %n, %n.vec
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader11

for.body.preheader11:                             ; preds = %for.body.preheader, %middle.block
  %i.09.ph = phi i32 [ 0, %for.body.preheader ], [ %n.vec, %middle.block ]
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %middle.block, %entry
  ret void

for.body:                                         ; preds = %for.body.preheader11, %for.body
  %i.09 = phi i32 [ %inc, %for.body ], [ %i.09.ph, %for.body.preheader11 ]
  %arrayidx = getelementptr inbounds nuw i16, ptr %b, i32 %i.09
  %5 = load i16, ptr %arrayidx, align 2, !tbaa !6
  %arrayidx1 = getelementptr inbounds nuw i16, ptr %c, i32 %i.09
  %6 = load i16, ptr %arrayidx1, align 2, !tbaa !6
  %7 = tail call i16 @llvm.sadd.sat.i16(i16 %5, i16 %6)
  %arrayidx10 = getelementptr inbounds nuw i16, ptr %a, i32 %i.09
  store i16 %7, ptr %arrayidx10, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.09, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !51
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @clip16(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp7 = icmp sgt i32 %n, 0
  br i1 %cmp7, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry
  %min.iters.check = icmp eq i32 %n, 1
  br i1 %min.iters.check, label %for.body.preheader9, label %vector.ph

vector.ph:                                        ; preds = %for.body.preheader
  %n.vec = and i32 %n, 2147483646
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds nuw i16, ptr %b, i32 %index
  %wide.load = load <2 x i16>, ptr %0, align 2, !tbaa !6
  %1 = tail call <2 x i16> @llvm.smin.v2i16(<2 x i16> %wide.load, <2 x i16> splat (i16 255))
  %2 = tail call <2 x i16> @llvm.smax.v2i16(<2 x i16> %1, <2 x i16> splat (i16 -256))
  %3 = getelementptr inbounds nuw i16, ptr %a, i32 %index
  store <2 x i16> %2, ptr %3, align 2, !tbaa !6
  %index.next = add nuw i32 %index, 2
  %4 = icmp eq i32 %index.next, %n.vec
  br i1 %4, label %middle.block, label %vector.body, !llvm.loop !52

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i32 %n, %n.vec
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader9

for.body.preheader9:                              ; preds = %for.body.preheader, %middle.block
  %i.08.ph = phi i32 [ 0, %for.body.preheader ], [ %n.vec, %middle.block ]
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %middle.block, %entry
  ret void

for.body:                                         ; preds = %for.body.preheader9, %for.body
  %i.08 = phi i32 [ %inc, %for.body ], [ %i.08.ph, %for.body.preheader9 ]
  %arrayidx = getelementptr inbounds nuw i16, ptr %b, i32 %i.08
  %5 = load i16, ptr %arrayidx, align 2, !tbaa !6
  %6 = tail call i16 @llvm.smin.i16(i16 %5, i16 255)
  %7 = tail call i16 @llvm.smax.i16(i16 %6, i16 -256)
  %arrayidx8 = getelementptr inbounds nuw i16, ptr %a, i32 %i.08
  store i16 %7, ptr %arrayidx8, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.08, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !53
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @relu8(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp6 = icmp sgt i32 %n, 0
  br i1 %cmp6, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry
  %min.iters.check = icmp ult i32 %n, 4
  br i1 %min.iters.check, label %for.body.preheader8, label %vector.ph

vector.ph:                                        ; preds = %for.body.preheader
  %n.vec = and i32 %n, 2147483644
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds nuw i8, ptr %b, i32 %index
  %wide.load = load <4 x i8>, ptr %0, align 1, !tbaa !15
  %1 = tail call <4 x i8> @llvm.smax.v4i8(<4 x i8> %wide.load, <4 x i8> zeroinitializer)
  %2 = getelementptr inbounds nuw i8, ptr %a, i32 %index
  store <4 x i8> %1, ptr %2, align 1, !tbaa !15
  %index.next = add nuw i32 %index, 4
  %3 = icmp eq i32 %index.next, %n.vec
  br i1 %3, label %middle.block, label %vector.body, !llvm.loop !54

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i32 %n, %n.vec
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader8

for.body.preheader8:                              ; preds = %for.body.preheader, %middle.block
  %i.07.ph = phi i32 [ 0, %for.body.preheader ], [ %n.vec, %middle.block ]
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %middle.block, %entry
  ret void

for.body:                                         ; preds = %for.body.preheader8, %for.body
  %i.07 = phi i32 [ %inc, %for.body ], [ %i.07.ph, %for.body.preheader8 ]
  %arrayidx = getelementptr inbounds nuw i8, ptr %b, i32 %i.07
  %4 = load i8, ptr %arrayidx, align 1, !tbaa !15
  %spec.select = tail call i8 @llvm.smax.i8(i8 %4, i8 0)
  %arrayidx6 = getelementptr inbounds nuw i8, ptr %a, i32 %i.07
  store i8 %spec.select, ptr %arrayidx6, align 1, !tbaa !15
  %inc = add nuw nsw i32 %i.07, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !55
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @sel16(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, ptr noalias nocapture noundef readonly %c, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp9 = icmp sgt i32 %n, 0
  br i1 %cmp9, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry
  %min.iters.check = icmp eq i32 %n, 1
  br i1 %min.iters.check, label %for.body.preheader12, label %vector.ph

vector.ph:                                        ; preds = %for.body.preheader
  %n.vec = and i32 %n, 2147483646
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds nuw i16, ptr %b, i32 %index
  %wide.load = load <2 x i16>, ptr %0, align 2, !tbaa !6
  %1 = getelementptr inbounds nuw i16, ptr %c, i32 %index
  %wide.load11 = load <2 x i16>, ptr %1, align 2, !tbaa !6
  %2 = icmp sgt <2 x i16> %wide.load, %wide.load11
  %3 = sub <2 x i16> %wide.load, %wide.load11
  %4 = select <2 x i1> %2, <2 x i16> %3, <2 x i16> zeroinitializer
  %5 = getelementptr inbounds nuw i16, ptr %a, i32 %index
  store <2 x i16> %4, ptr %5, align 2, !tbaa !6
  %index.next = add nuw i32 %index, 2
  %6 = icmp eq i32 %index.next, %n.vec
  br i1 %6, label %middle.block, label %vector.body, !llvm.loop !56

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i32 %n, %n.vec
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader12

for.body.preheader12:                             ; preds = %for.body.preheader, %middle.block
  %i.010.ph = phi i32 [ 0, %for.body.preheader ], [ %n.vec, %middle.block ]
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %middle.block, %entry
  ret void

for.body:                                         ; preds = %for.body.preheader12, %for.body
  %i.010 = phi i32 [ %inc, %for.body ], [ %i.010.ph, %for.body.preheader12 ]
  %arrayidx = getelementptr inbounds nuw i16, ptr %b, i32 %i.010
  %7 = load i16, ptr %arrayidx, align 2, !tbaa !6
  %arrayidx1 = getelementptr inbounds nuw i16, ptr %c, i32 %i.010
  %8 = load i16, ptr %arrayidx1, align 2, !tbaa !6
  %cmp3 = icmp sgt i16 %7, %8
  %sub = sub i16 %7, %8
  %spec.select = select i1 %cmp3, i16 %sub, i16 0
  %arrayidx10 = getelementptr inbounds nuw i16, ptr %a, i32 %i.010
  store i16 %spec.select, ptr %arrayidx10, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.010, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !57
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read)
define dso_local i32 @dot16(ptr noalias nocapture noundef readonly %b, ptr noalias nocapture noundef readonly %c, i32 noundef %n) local_unnamed_addr #3 {
entry:
  %cmp5 = icmp sgt i32 %n, 0
  br i1 %cmp5, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.body, %entry
  %s.0.lcssa = phi i32 [ 0, %entry ], [ %add, %for.body ]
  ret i32 %s.0.lcssa

for.body:                                         ; preds = %entry, %for.body
  %i.07 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %s.06 = phi i32 [ %add, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds nuw i16, ptr %b, i32 %i.07
  %0 = load i16, ptr %arrayidx, align 2, !tbaa !6
  %conv = sext i16 %0 to i32
  %arrayidx1 = getelementptr inbounds nuw i16, ptr %c, i32 %i.07
  %1 = load i16, ptr %arrayidx1, align 2, !tbaa !6
  %conv2 = sext i16 %1 to i32
  %mul = mul nsw i32 %conv2, %conv
  %add = add nsw i32 %mul, %s.06
  %inc = add nuw nsw i32 %i.07, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !58
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read)
define dso_local i32 @dot8(ptr noalias nocapture noundef readonly %b, ptr noalias nocapture noundef readonly %c, i32 noundef %n) local_unnamed_addr #3 {
entry:
  %cmp5 = icmp sgt i32 %n, 0
  br i1 %cmp5, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.body, %entry
  %s.0.lcssa = phi i32 [ 0, %entry ], [ %add, %for.body ]
  ret i32 %s.0.lcssa

for.body:                                         ; preds = %entry, %for.body
  %i.07 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %s.06 = phi i32 [ %add, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds nuw i8, ptr %b, i32 %i.07
  %0 = load i8, ptr %arrayidx, align 1, !tbaa !15
  %conv = sext i8 %0 to i32
  %arrayidx1 = getelementptr inbounds nuw i8, ptr %c, i32 %i.07
  %1 = load i8, ptr %arrayidx1, align 1, !tbaa !15
  %conv2 = sext i8 %1 to i32
  %mul = mul nsw i32 %conv2, %conv
  %add = add nsw i32 %mul, %s.06
  %inc = add nuw nsw i32 %i.07, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !59
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read)
define dso_local i32 @dotu8(ptr noalias nocapture noundef readonly %b, ptr noalias nocapture noundef readonly %c, i32 noundef %n) local_unnamed_addr #3 {
entry:
  %cmp5 = icmp sgt i32 %n, 0
  br i1 %cmp5, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.body, %entry
  %s.0.lcssa = phi i32 [ 0, %entry ], [ %add, %for.body ]
  ret i32 %s.0.lcssa

for.body:                                         ; preds = %entry, %for.body
  %i.07 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %s.06 = phi i32 [ %add, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds nuw i8, ptr %b, i32 %i.07
  %0 = load i8, ptr %arrayidx, align 1, !tbaa !15
  %conv = zext i8 %0 to i32
  %arrayidx1 = getelementptr inbounds nuw i8, ptr %c, i32 %i.07
  %1 = load i8, ptr %arrayidx1, align 1, !tbaa !15
  %conv2 = zext i8 %1 to i32
  %mul = mul nuw nsw i32 %conv2, %conv
  %add = add nuw nsw i32 %mul, %s.06
  %inc = add nuw nsw i32 %i.07, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !60
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read)
define dso_local i32 @sum16(ptr noalias nocapture noundef readonly %b, i32 noundef %n) local_unnamed_addr #3 {
entry:
  %cmp4 = icmp sgt i32 %n, 0
  br i1 %cmp4, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.body, %entry
  %s.0.lcssa = phi i32 [ 0, %entry ], [ %add, %for.body ]
  ret i32 %s.0.lcssa

for.body:                                         ; preds = %entry, %for.body
  %i.06 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %s.05 = phi i32 [ %add, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds nuw i16, ptr %b, i32 %i.06
  %0 = load i16, ptr %arrayidx, align 2, !tbaa !6
  %conv = sext i16 %0 to i32
  %add = add nsw i32 %s.05, %conv
  %inc = add nuw nsw i32 %i.06, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !61
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read)
define dso_local i32 @sum8(ptr noalias nocapture noundef readonly %b, i32 noundef %n) local_unnamed_addr #3 {
entry:
  %cmp4 = icmp sgt i32 %n, 0
  br i1 %cmp4, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.body, %entry
  %s.0.lcssa = phi i32 [ 0, %entry ], [ %add, %for.body ]
  ret i32 %s.0.lcssa

for.body:                                         ; preds = %entry, %for.body
  %i.06 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %s.05 = phi i32 [ %add, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds nuw i8, ptr %b, i32 %i.06
  %0 = load i8, ptr %arrayidx, align 1, !tbaa !15
  %conv = sext i8 %0 to i32
  %add = add nsw i32 %s.05, %conv
  %inc = add nuw nsw i32 %i.06, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !62
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read)
define dso_local signext i16 @sum16n(ptr noalias nocapture noundef readonly %b, i32 noundef %n) local_unnamed_addr #3 {
entry:
  %cmp4 = icmp sgt i32 %n, 0
  br i1 %cmp4, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry
  %min.iters.check = icmp eq i32 %n, 1
  br i1 %min.iters.check, label %for.body.preheader7, label %vector.ph

vector.ph:                                        ; preds = %for.body.preheader
  %n.vec = and i32 %n, 2147483646
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %vec.phi = phi <2 x i16> [ zeroinitializer, %vector.ph ], [ %1, %vector.body ]
  %0 = getelementptr inbounds nuw i16, ptr %b, i32 %index
  %wide.load = load <2 x i16>, ptr %0, align 2, !tbaa !6
  %1 = add <2 x i16> %wide.load, %vec.phi
  %index.next = add nuw i32 %index, 2
  %2 = icmp eq i32 %index.next, %n.vec
  br i1 %2, label %middle.block, label %vector.body, !llvm.loop !63

middle.block:                                     ; preds = %vector.body
  %3 = tail call i16 @llvm.vector.reduce.add.v2i16(<2 x i16> %1)
  %cmp.n = icmp eq i32 %n, %n.vec
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader7

for.body.preheader7:                              ; preds = %for.body.preheader, %middle.block
  %i.06.ph = phi i32 [ 0, %for.body.preheader ], [ %n.vec, %middle.block ]
  %s.05.ph = phi i16 [ 0, %for.body.preheader ], [ %3, %middle.block ]
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %middle.block, %entry
  %s.0.lcssa = phi i16 [ 0, %entry ], [ %3, %middle.block ], [ %add, %for.body ]
  ret i16 %s.0.lcssa

for.body:                                         ; preds = %for.body.preheader7, %for.body
  %i.06 = phi i32 [ %inc, %for.body ], [ %i.06.ph, %for.body.preheader7 ]
  %s.05 = phi i16 [ %add, %for.body ], [ %s.05.ph, %for.body.preheader7 ]
  %arrayidx = getelementptr inbounds nuw i16, ptr %b, i32 %i.06
  %4 = load i16, ptr %arrayidx, align 2, !tbaa !6
  %add = add i16 %4, %s.05
  %inc = add nuw nsw i32 %i.06, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !64
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read)
define dso_local range(i32 -32768, 32768) i32 @max16r(ptr noalias nocapture noundef readonly %b, i32 noundef %n) local_unnamed_addr #3 {
entry:
  %cmp6 = icmp sgt i32 %n, 0
  br i1 %cmp6, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.body, %entry
  %m.0.lcssa = phi i32 [ -32768, %entry ], [ %spec.select, %for.body ]
  ret i32 %m.0.lcssa

for.body:                                         ; preds = %entry, %for.body
  %i.08 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %m.07 = phi i32 [ %spec.select, %for.body ], [ -32768, %entry ]
  %arrayidx = getelementptr inbounds nuw i16, ptr %b, i32 %i.08
  %0 = load i16, ptr %arrayidx, align 2, !tbaa !6
  %conv = sext i16 %0 to i32
  %spec.select = tail call i32 @llvm.smax.i32(i32 %m.07, i32 %conv)
  %inc = add nuw nsw i32 %i.08, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !65
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read)
define dso_local signext i16 @max16rn(ptr noalias nocapture noundef readonly %b, i32 noundef %n) local_unnamed_addr #3 {
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
  %vec.phi = phi <2 x i16> [ splat (i16 -32768), %vector.ph ], [ %1, %vector.body ]
  %0 = getelementptr inbounds nuw i16, ptr %b, i32 %index
  %wide.load = load <2 x i16>, ptr %0, align 2, !tbaa !6
  %1 = tail call <2 x i16> @llvm.smax.v2i16(<2 x i16> %wide.load, <2 x i16> %vec.phi)
  %index.next = add nuw i32 %index, 2
  %2 = icmp eq i32 %index.next, %n.vec
  br i1 %2, label %middle.block, label %vector.body, !llvm.loop !66

middle.block:                                     ; preds = %vector.body
  %3 = tail call i16 @llvm.vector.reduce.smax.v2i16(<2 x i16> %1)
  %cmp.n = icmp eq i32 %n, %n.vec
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader9

for.body.preheader9:                              ; preds = %for.body.preheader, %middle.block
  %i.08.ph = phi i32 [ 0, %for.body.preheader ], [ %n.vec, %middle.block ]
  %m.07.ph = phi i16 [ -32768, %for.body.preheader ], [ %3, %middle.block ]
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %middle.block, %entry
  %m.0.lcssa = phi i16 [ -32768, %entry ], [ %3, %middle.block ], [ %spec.select, %for.body ]
  ret i16 %m.0.lcssa

for.body:                                         ; preds = %for.body.preheader9, %for.body
  %i.08 = phi i32 [ %inc, %for.body ], [ %i.08.ph, %for.body.preheader9 ]
  %m.07 = phi i16 [ %spec.select, %for.body ], [ %m.07.ph, %for.body.preheader9 ]
  %arrayidx = getelementptr inbounds nuw i16, ptr %b, i32 %i.08
  %4 = load i16, ptr %arrayidx, align 2, !tbaa !6
  %spec.select = tail call i16 @llvm.smax.i16(i16 %4, i16 %m.07)
  %inc = add nuw nsw i32 %i.08, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !67
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read)
define dso_local i32 @sad8(ptr noalias nocapture noundef readonly %b, ptr noalias nocapture noundef readonly %c, i32 noundef %n) local_unnamed_addr #3 {
entry:
  %cmp7 = icmp sgt i32 %n, 0
  br i1 %cmp7, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.body, %entry
  %s.0.lcssa = phi i32 [ 0, %entry ], [ %add, %for.body ]
  ret i32 %s.0.lcssa

for.body:                                         ; preds = %entry, %for.body
  %s.09 = phi i32 [ %add, %for.body ], [ 0, %entry ]
  %i.08 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds nuw i8, ptr %b, i32 %i.08
  %0 = load i8, ptr %arrayidx, align 1, !tbaa !15
  %conv = zext i8 %0 to i32
  %arrayidx1 = getelementptr inbounds nuw i8, ptr %c, i32 %i.08
  %1 = load i8, ptr %arrayidx1, align 1, !tbaa !15
  %conv2 = zext i8 %1 to i32
  %sub = sub nsw i32 %conv, %conv2
  %cond = tail call i32 @llvm.abs.i32(i32 %sub, i1 true)
  %add = add nuw nsw i32 %cond, %s.09
  %inc = add nuw nsw i32 %i.08, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !68
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @add16_k64(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, ptr noalias nocapture noundef readonly %c) local_unnamed_addr #0 {
entry:
  %wide.load = load <2 x i16>, ptr %b, align 2, !tbaa !6
  %wide.load6 = load <2 x i16>, ptr %c, align 2, !tbaa !6
  %0 = add <2 x i16> %wide.load6, %wide.load
  store <2 x i16> %0, ptr %a, align 2, !tbaa !6
  %1 = getelementptr inbounds nuw i8, ptr %b, i32 4
  %wide.load.1 = load <2 x i16>, ptr %1, align 2, !tbaa !6
  %2 = getelementptr inbounds nuw i8, ptr %c, i32 4
  %wide.load6.1 = load <2 x i16>, ptr %2, align 2, !tbaa !6
  %3 = add <2 x i16> %wide.load6.1, %wide.load.1
  %4 = getelementptr inbounds nuw i8, ptr %a, i32 4
  store <2 x i16> %3, ptr %4, align 2, !tbaa !6
  %5 = getelementptr inbounds nuw i8, ptr %b, i32 8
  %wide.load.2 = load <2 x i16>, ptr %5, align 2, !tbaa !6
  %6 = getelementptr inbounds nuw i8, ptr %c, i32 8
  %wide.load6.2 = load <2 x i16>, ptr %6, align 2, !tbaa !6
  %7 = add <2 x i16> %wide.load6.2, %wide.load.2
  %8 = getelementptr inbounds nuw i8, ptr %a, i32 8
  store <2 x i16> %7, ptr %8, align 2, !tbaa !6
  %9 = getelementptr inbounds nuw i8, ptr %b, i32 12
  %wide.load.3 = load <2 x i16>, ptr %9, align 2, !tbaa !6
  %10 = getelementptr inbounds nuw i8, ptr %c, i32 12
  %wide.load6.3 = load <2 x i16>, ptr %10, align 2, !tbaa !6
  %11 = add <2 x i16> %wide.load6.3, %wide.load.3
  %12 = getelementptr inbounds nuw i8, ptr %a, i32 12
  store <2 x i16> %11, ptr %12, align 2, !tbaa !6
  %13 = getelementptr inbounds nuw i8, ptr %b, i32 16
  %wide.load.4 = load <2 x i16>, ptr %13, align 2, !tbaa !6
  %14 = getelementptr inbounds nuw i8, ptr %c, i32 16
  %wide.load6.4 = load <2 x i16>, ptr %14, align 2, !tbaa !6
  %15 = add <2 x i16> %wide.load6.4, %wide.load.4
  %16 = getelementptr inbounds nuw i8, ptr %a, i32 16
  store <2 x i16> %15, ptr %16, align 2, !tbaa !6
  %17 = getelementptr inbounds nuw i8, ptr %b, i32 20
  %wide.load.5 = load <2 x i16>, ptr %17, align 2, !tbaa !6
  %18 = getelementptr inbounds nuw i8, ptr %c, i32 20
  %wide.load6.5 = load <2 x i16>, ptr %18, align 2, !tbaa !6
  %19 = add <2 x i16> %wide.load6.5, %wide.load.5
  %20 = getelementptr inbounds nuw i8, ptr %a, i32 20
  store <2 x i16> %19, ptr %20, align 2, !tbaa !6
  %21 = getelementptr inbounds nuw i8, ptr %b, i32 24
  %wide.load.6 = load <2 x i16>, ptr %21, align 2, !tbaa !6
  %22 = getelementptr inbounds nuw i8, ptr %c, i32 24
  %wide.load6.6 = load <2 x i16>, ptr %22, align 2, !tbaa !6
  %23 = add <2 x i16> %wide.load6.6, %wide.load.6
  %24 = getelementptr inbounds nuw i8, ptr %a, i32 24
  store <2 x i16> %23, ptr %24, align 2, !tbaa !6
  %25 = getelementptr inbounds nuw i8, ptr %b, i32 28
  %wide.load.7 = load <2 x i16>, ptr %25, align 2, !tbaa !6
  %26 = getelementptr inbounds nuw i8, ptr %c, i32 28
  %wide.load6.7 = load <2 x i16>, ptr %26, align 2, !tbaa !6
  %27 = add <2 x i16> %wide.load6.7, %wide.load.7
  %28 = getelementptr inbounds nuw i8, ptr %a, i32 28
  store <2 x i16> %27, ptr %28, align 2, !tbaa !6
  %29 = getelementptr inbounds nuw i8, ptr %b, i32 32
  %wide.load.8 = load <2 x i16>, ptr %29, align 2, !tbaa !6
  %30 = getelementptr inbounds nuw i8, ptr %c, i32 32
  %wide.load6.8 = load <2 x i16>, ptr %30, align 2, !tbaa !6
  %31 = add <2 x i16> %wide.load6.8, %wide.load.8
  %32 = getelementptr inbounds nuw i8, ptr %a, i32 32
  store <2 x i16> %31, ptr %32, align 2, !tbaa !6
  %33 = getelementptr inbounds nuw i8, ptr %b, i32 36
  %wide.load.9 = load <2 x i16>, ptr %33, align 2, !tbaa !6
  %34 = getelementptr inbounds nuw i8, ptr %c, i32 36
  %wide.load6.9 = load <2 x i16>, ptr %34, align 2, !tbaa !6
  %35 = add <2 x i16> %wide.load6.9, %wide.load.9
  %36 = getelementptr inbounds nuw i8, ptr %a, i32 36
  store <2 x i16> %35, ptr %36, align 2, !tbaa !6
  %37 = getelementptr inbounds nuw i8, ptr %b, i32 40
  %wide.load.10 = load <2 x i16>, ptr %37, align 2, !tbaa !6
  %38 = getelementptr inbounds nuw i8, ptr %c, i32 40
  %wide.load6.10 = load <2 x i16>, ptr %38, align 2, !tbaa !6
  %39 = add <2 x i16> %wide.load6.10, %wide.load.10
  %40 = getelementptr inbounds nuw i8, ptr %a, i32 40
  store <2 x i16> %39, ptr %40, align 2, !tbaa !6
  %41 = getelementptr inbounds nuw i8, ptr %b, i32 44
  %wide.load.11 = load <2 x i16>, ptr %41, align 2, !tbaa !6
  %42 = getelementptr inbounds nuw i8, ptr %c, i32 44
  %wide.load6.11 = load <2 x i16>, ptr %42, align 2, !tbaa !6
  %43 = add <2 x i16> %wide.load6.11, %wide.load.11
  %44 = getelementptr inbounds nuw i8, ptr %a, i32 44
  store <2 x i16> %43, ptr %44, align 2, !tbaa !6
  %45 = getelementptr inbounds nuw i8, ptr %b, i32 48
  %wide.load.12 = load <2 x i16>, ptr %45, align 2, !tbaa !6
  %46 = getelementptr inbounds nuw i8, ptr %c, i32 48
  %wide.load6.12 = load <2 x i16>, ptr %46, align 2, !tbaa !6
  %47 = add <2 x i16> %wide.load6.12, %wide.load.12
  %48 = getelementptr inbounds nuw i8, ptr %a, i32 48
  store <2 x i16> %47, ptr %48, align 2, !tbaa !6
  %49 = getelementptr inbounds nuw i8, ptr %b, i32 52
  %wide.load.13 = load <2 x i16>, ptr %49, align 2, !tbaa !6
  %50 = getelementptr inbounds nuw i8, ptr %c, i32 52
  %wide.load6.13 = load <2 x i16>, ptr %50, align 2, !tbaa !6
  %51 = add <2 x i16> %wide.load6.13, %wide.load.13
  %52 = getelementptr inbounds nuw i8, ptr %a, i32 52
  store <2 x i16> %51, ptr %52, align 2, !tbaa !6
  %53 = getelementptr inbounds nuw i8, ptr %b, i32 56
  %wide.load.14 = load <2 x i16>, ptr %53, align 2, !tbaa !6
  %54 = getelementptr inbounds nuw i8, ptr %c, i32 56
  %wide.load6.14 = load <2 x i16>, ptr %54, align 2, !tbaa !6
  %55 = add <2 x i16> %wide.load6.14, %wide.load.14
  %56 = getelementptr inbounds nuw i8, ptr %a, i32 56
  store <2 x i16> %55, ptr %56, align 2, !tbaa !6
  %57 = getelementptr inbounds nuw i8, ptr %b, i32 60
  %wide.load.15 = load <2 x i16>, ptr %57, align 2, !tbaa !6
  %58 = getelementptr inbounds nuw i8, ptr %c, i32 60
  %wide.load6.15 = load <2 x i16>, ptr %58, align 2, !tbaa !6
  %59 = add <2 x i16> %wide.load6.15, %wide.load.15
  %60 = getelementptr inbounds nuw i8, ptr %a, i32 60
  store <2 x i16> %59, ptr %60, align 2, !tbaa !6
  %61 = getelementptr inbounds nuw i8, ptr %b, i32 64
  %wide.load.16 = load <2 x i16>, ptr %61, align 2, !tbaa !6
  %62 = getelementptr inbounds nuw i8, ptr %c, i32 64
  %wide.load6.16 = load <2 x i16>, ptr %62, align 2, !tbaa !6
  %63 = add <2 x i16> %wide.load6.16, %wide.load.16
  %64 = getelementptr inbounds nuw i8, ptr %a, i32 64
  store <2 x i16> %63, ptr %64, align 2, !tbaa !6
  %65 = getelementptr inbounds nuw i8, ptr %b, i32 68
  %wide.load.17 = load <2 x i16>, ptr %65, align 2, !tbaa !6
  %66 = getelementptr inbounds nuw i8, ptr %c, i32 68
  %wide.load6.17 = load <2 x i16>, ptr %66, align 2, !tbaa !6
  %67 = add <2 x i16> %wide.load6.17, %wide.load.17
  %68 = getelementptr inbounds nuw i8, ptr %a, i32 68
  store <2 x i16> %67, ptr %68, align 2, !tbaa !6
  %69 = getelementptr inbounds nuw i8, ptr %b, i32 72
  %wide.load.18 = load <2 x i16>, ptr %69, align 2, !tbaa !6
  %70 = getelementptr inbounds nuw i8, ptr %c, i32 72
  %wide.load6.18 = load <2 x i16>, ptr %70, align 2, !tbaa !6
  %71 = add <2 x i16> %wide.load6.18, %wide.load.18
  %72 = getelementptr inbounds nuw i8, ptr %a, i32 72
  store <2 x i16> %71, ptr %72, align 2, !tbaa !6
  %73 = getelementptr inbounds nuw i8, ptr %b, i32 76
  %wide.load.19 = load <2 x i16>, ptr %73, align 2, !tbaa !6
  %74 = getelementptr inbounds nuw i8, ptr %c, i32 76
  %wide.load6.19 = load <2 x i16>, ptr %74, align 2, !tbaa !6
  %75 = add <2 x i16> %wide.load6.19, %wide.load.19
  %76 = getelementptr inbounds nuw i8, ptr %a, i32 76
  store <2 x i16> %75, ptr %76, align 2, !tbaa !6
  %77 = getelementptr inbounds nuw i8, ptr %b, i32 80
  %wide.load.20 = load <2 x i16>, ptr %77, align 2, !tbaa !6
  %78 = getelementptr inbounds nuw i8, ptr %c, i32 80
  %wide.load6.20 = load <2 x i16>, ptr %78, align 2, !tbaa !6
  %79 = add <2 x i16> %wide.load6.20, %wide.load.20
  %80 = getelementptr inbounds nuw i8, ptr %a, i32 80
  store <2 x i16> %79, ptr %80, align 2, !tbaa !6
  %81 = getelementptr inbounds nuw i8, ptr %b, i32 84
  %wide.load.21 = load <2 x i16>, ptr %81, align 2, !tbaa !6
  %82 = getelementptr inbounds nuw i8, ptr %c, i32 84
  %wide.load6.21 = load <2 x i16>, ptr %82, align 2, !tbaa !6
  %83 = add <2 x i16> %wide.load6.21, %wide.load.21
  %84 = getelementptr inbounds nuw i8, ptr %a, i32 84
  store <2 x i16> %83, ptr %84, align 2, !tbaa !6
  %85 = getelementptr inbounds nuw i8, ptr %b, i32 88
  %wide.load.22 = load <2 x i16>, ptr %85, align 2, !tbaa !6
  %86 = getelementptr inbounds nuw i8, ptr %c, i32 88
  %wide.load6.22 = load <2 x i16>, ptr %86, align 2, !tbaa !6
  %87 = add <2 x i16> %wide.load6.22, %wide.load.22
  %88 = getelementptr inbounds nuw i8, ptr %a, i32 88
  store <2 x i16> %87, ptr %88, align 2, !tbaa !6
  %89 = getelementptr inbounds nuw i8, ptr %b, i32 92
  %wide.load.23 = load <2 x i16>, ptr %89, align 2, !tbaa !6
  %90 = getelementptr inbounds nuw i8, ptr %c, i32 92
  %wide.load6.23 = load <2 x i16>, ptr %90, align 2, !tbaa !6
  %91 = add <2 x i16> %wide.load6.23, %wide.load.23
  %92 = getelementptr inbounds nuw i8, ptr %a, i32 92
  store <2 x i16> %91, ptr %92, align 2, !tbaa !6
  %93 = getelementptr inbounds nuw i8, ptr %b, i32 96
  %wide.load.24 = load <2 x i16>, ptr %93, align 2, !tbaa !6
  %94 = getelementptr inbounds nuw i8, ptr %c, i32 96
  %wide.load6.24 = load <2 x i16>, ptr %94, align 2, !tbaa !6
  %95 = add <2 x i16> %wide.load6.24, %wide.load.24
  %96 = getelementptr inbounds nuw i8, ptr %a, i32 96
  store <2 x i16> %95, ptr %96, align 2, !tbaa !6
  %97 = getelementptr inbounds nuw i8, ptr %b, i32 100
  %wide.load.25 = load <2 x i16>, ptr %97, align 2, !tbaa !6
  %98 = getelementptr inbounds nuw i8, ptr %c, i32 100
  %wide.load6.25 = load <2 x i16>, ptr %98, align 2, !tbaa !6
  %99 = add <2 x i16> %wide.load6.25, %wide.load.25
  %100 = getelementptr inbounds nuw i8, ptr %a, i32 100
  store <2 x i16> %99, ptr %100, align 2, !tbaa !6
  %101 = getelementptr inbounds nuw i8, ptr %b, i32 104
  %wide.load.26 = load <2 x i16>, ptr %101, align 2, !tbaa !6
  %102 = getelementptr inbounds nuw i8, ptr %c, i32 104
  %wide.load6.26 = load <2 x i16>, ptr %102, align 2, !tbaa !6
  %103 = add <2 x i16> %wide.load6.26, %wide.load.26
  %104 = getelementptr inbounds nuw i8, ptr %a, i32 104
  store <2 x i16> %103, ptr %104, align 2, !tbaa !6
  %105 = getelementptr inbounds nuw i8, ptr %b, i32 108
  %wide.load.27 = load <2 x i16>, ptr %105, align 2, !tbaa !6
  %106 = getelementptr inbounds nuw i8, ptr %c, i32 108
  %wide.load6.27 = load <2 x i16>, ptr %106, align 2, !tbaa !6
  %107 = add <2 x i16> %wide.load6.27, %wide.load.27
  %108 = getelementptr inbounds nuw i8, ptr %a, i32 108
  store <2 x i16> %107, ptr %108, align 2, !tbaa !6
  %109 = getelementptr inbounds nuw i8, ptr %b, i32 112
  %wide.load.28 = load <2 x i16>, ptr %109, align 2, !tbaa !6
  %110 = getelementptr inbounds nuw i8, ptr %c, i32 112
  %wide.load6.28 = load <2 x i16>, ptr %110, align 2, !tbaa !6
  %111 = add <2 x i16> %wide.load6.28, %wide.load.28
  %112 = getelementptr inbounds nuw i8, ptr %a, i32 112
  store <2 x i16> %111, ptr %112, align 2, !tbaa !6
  %113 = getelementptr inbounds nuw i8, ptr %b, i32 116
  %wide.load.29 = load <2 x i16>, ptr %113, align 2, !tbaa !6
  %114 = getelementptr inbounds nuw i8, ptr %c, i32 116
  %wide.load6.29 = load <2 x i16>, ptr %114, align 2, !tbaa !6
  %115 = add <2 x i16> %wide.load6.29, %wide.load.29
  %116 = getelementptr inbounds nuw i8, ptr %a, i32 116
  store <2 x i16> %115, ptr %116, align 2, !tbaa !6
  %117 = getelementptr inbounds nuw i8, ptr %b, i32 120
  %wide.load.30 = load <2 x i16>, ptr %117, align 2, !tbaa !6
  %118 = getelementptr inbounds nuw i8, ptr %c, i32 120
  %wide.load6.30 = load <2 x i16>, ptr %118, align 2, !tbaa !6
  %119 = add <2 x i16> %wide.load6.30, %wide.load.30
  %120 = getelementptr inbounds nuw i8, ptr %a, i32 120
  store <2 x i16> %119, ptr %120, align 2, !tbaa !6
  %121 = getelementptr inbounds nuw i8, ptr %b, i32 124
  %wide.load.31 = load <2 x i16>, ptr %121, align 2, !tbaa !6
  %122 = getelementptr inbounds nuw i8, ptr %c, i32 124
  %wide.load6.31 = load <2 x i16>, ptr %122, align 2, !tbaa !6
  %123 = add <2 x i16> %wide.load6.31, %wide.load.31
  %124 = getelementptr inbounds nuw i8, ptr %a, i32 124
  store <2 x i16> %123, ptr %124, align 2, !tbaa !6
  ret void
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @add16_k63(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, ptr noalias nocapture noundef readonly %c) local_unnamed_addr #0 {
entry:
  %wide.load = load <2 x i16>, ptr %b, align 2, !tbaa !6
  %wide.load6 = load <2 x i16>, ptr %c, align 2, !tbaa !6
  %0 = add <2 x i16> %wide.load6, %wide.load
  store <2 x i16> %0, ptr %a, align 2, !tbaa !6
  %1 = getelementptr inbounds nuw i8, ptr %b, i32 4
  %wide.load.1 = load <2 x i16>, ptr %1, align 2, !tbaa !6
  %2 = getelementptr inbounds nuw i8, ptr %c, i32 4
  %wide.load6.1 = load <2 x i16>, ptr %2, align 2, !tbaa !6
  %3 = add <2 x i16> %wide.load6.1, %wide.load.1
  %4 = getelementptr inbounds nuw i8, ptr %a, i32 4
  store <2 x i16> %3, ptr %4, align 2, !tbaa !6
  %5 = getelementptr inbounds nuw i8, ptr %b, i32 8
  %wide.load.2 = load <2 x i16>, ptr %5, align 2, !tbaa !6
  %6 = getelementptr inbounds nuw i8, ptr %c, i32 8
  %wide.load6.2 = load <2 x i16>, ptr %6, align 2, !tbaa !6
  %7 = add <2 x i16> %wide.load6.2, %wide.load.2
  %8 = getelementptr inbounds nuw i8, ptr %a, i32 8
  store <2 x i16> %7, ptr %8, align 2, !tbaa !6
  %9 = getelementptr inbounds nuw i8, ptr %b, i32 12
  %wide.load.3 = load <2 x i16>, ptr %9, align 2, !tbaa !6
  %10 = getelementptr inbounds nuw i8, ptr %c, i32 12
  %wide.load6.3 = load <2 x i16>, ptr %10, align 2, !tbaa !6
  %11 = add <2 x i16> %wide.load6.3, %wide.load.3
  %12 = getelementptr inbounds nuw i8, ptr %a, i32 12
  store <2 x i16> %11, ptr %12, align 2, !tbaa !6
  %13 = getelementptr inbounds nuw i8, ptr %b, i32 16
  %wide.load.4 = load <2 x i16>, ptr %13, align 2, !tbaa !6
  %14 = getelementptr inbounds nuw i8, ptr %c, i32 16
  %wide.load6.4 = load <2 x i16>, ptr %14, align 2, !tbaa !6
  %15 = add <2 x i16> %wide.load6.4, %wide.load.4
  %16 = getelementptr inbounds nuw i8, ptr %a, i32 16
  store <2 x i16> %15, ptr %16, align 2, !tbaa !6
  %17 = getelementptr inbounds nuw i8, ptr %b, i32 20
  %wide.load.5 = load <2 x i16>, ptr %17, align 2, !tbaa !6
  %18 = getelementptr inbounds nuw i8, ptr %c, i32 20
  %wide.load6.5 = load <2 x i16>, ptr %18, align 2, !tbaa !6
  %19 = add <2 x i16> %wide.load6.5, %wide.load.5
  %20 = getelementptr inbounds nuw i8, ptr %a, i32 20
  store <2 x i16> %19, ptr %20, align 2, !tbaa !6
  %21 = getelementptr inbounds nuw i8, ptr %b, i32 24
  %wide.load.6 = load <2 x i16>, ptr %21, align 2, !tbaa !6
  %22 = getelementptr inbounds nuw i8, ptr %c, i32 24
  %wide.load6.6 = load <2 x i16>, ptr %22, align 2, !tbaa !6
  %23 = add <2 x i16> %wide.load6.6, %wide.load.6
  %24 = getelementptr inbounds nuw i8, ptr %a, i32 24
  store <2 x i16> %23, ptr %24, align 2, !tbaa !6
  %25 = getelementptr inbounds nuw i8, ptr %b, i32 28
  %wide.load.7 = load <2 x i16>, ptr %25, align 2, !tbaa !6
  %26 = getelementptr inbounds nuw i8, ptr %c, i32 28
  %wide.load6.7 = load <2 x i16>, ptr %26, align 2, !tbaa !6
  %27 = add <2 x i16> %wide.load6.7, %wide.load.7
  %28 = getelementptr inbounds nuw i8, ptr %a, i32 28
  store <2 x i16> %27, ptr %28, align 2, !tbaa !6
  %29 = getelementptr inbounds nuw i8, ptr %b, i32 32
  %wide.load.8 = load <2 x i16>, ptr %29, align 2, !tbaa !6
  %30 = getelementptr inbounds nuw i8, ptr %c, i32 32
  %wide.load6.8 = load <2 x i16>, ptr %30, align 2, !tbaa !6
  %31 = add <2 x i16> %wide.load6.8, %wide.load.8
  %32 = getelementptr inbounds nuw i8, ptr %a, i32 32
  store <2 x i16> %31, ptr %32, align 2, !tbaa !6
  %33 = getelementptr inbounds nuw i8, ptr %b, i32 36
  %wide.load.9 = load <2 x i16>, ptr %33, align 2, !tbaa !6
  %34 = getelementptr inbounds nuw i8, ptr %c, i32 36
  %wide.load6.9 = load <2 x i16>, ptr %34, align 2, !tbaa !6
  %35 = add <2 x i16> %wide.load6.9, %wide.load.9
  %36 = getelementptr inbounds nuw i8, ptr %a, i32 36
  store <2 x i16> %35, ptr %36, align 2, !tbaa !6
  %37 = getelementptr inbounds nuw i8, ptr %b, i32 40
  %wide.load.10 = load <2 x i16>, ptr %37, align 2, !tbaa !6
  %38 = getelementptr inbounds nuw i8, ptr %c, i32 40
  %wide.load6.10 = load <2 x i16>, ptr %38, align 2, !tbaa !6
  %39 = add <2 x i16> %wide.load6.10, %wide.load.10
  %40 = getelementptr inbounds nuw i8, ptr %a, i32 40
  store <2 x i16> %39, ptr %40, align 2, !tbaa !6
  %41 = getelementptr inbounds nuw i8, ptr %b, i32 44
  %wide.load.11 = load <2 x i16>, ptr %41, align 2, !tbaa !6
  %42 = getelementptr inbounds nuw i8, ptr %c, i32 44
  %wide.load6.11 = load <2 x i16>, ptr %42, align 2, !tbaa !6
  %43 = add <2 x i16> %wide.load6.11, %wide.load.11
  %44 = getelementptr inbounds nuw i8, ptr %a, i32 44
  store <2 x i16> %43, ptr %44, align 2, !tbaa !6
  %45 = getelementptr inbounds nuw i8, ptr %b, i32 48
  %wide.load.12 = load <2 x i16>, ptr %45, align 2, !tbaa !6
  %46 = getelementptr inbounds nuw i8, ptr %c, i32 48
  %wide.load6.12 = load <2 x i16>, ptr %46, align 2, !tbaa !6
  %47 = add <2 x i16> %wide.load6.12, %wide.load.12
  %48 = getelementptr inbounds nuw i8, ptr %a, i32 48
  store <2 x i16> %47, ptr %48, align 2, !tbaa !6
  %49 = getelementptr inbounds nuw i8, ptr %b, i32 52
  %wide.load.13 = load <2 x i16>, ptr %49, align 2, !tbaa !6
  %50 = getelementptr inbounds nuw i8, ptr %c, i32 52
  %wide.load6.13 = load <2 x i16>, ptr %50, align 2, !tbaa !6
  %51 = add <2 x i16> %wide.load6.13, %wide.load.13
  %52 = getelementptr inbounds nuw i8, ptr %a, i32 52
  store <2 x i16> %51, ptr %52, align 2, !tbaa !6
  %53 = getelementptr inbounds nuw i8, ptr %b, i32 56
  %wide.load.14 = load <2 x i16>, ptr %53, align 2, !tbaa !6
  %54 = getelementptr inbounds nuw i8, ptr %c, i32 56
  %wide.load6.14 = load <2 x i16>, ptr %54, align 2, !tbaa !6
  %55 = add <2 x i16> %wide.load6.14, %wide.load.14
  %56 = getelementptr inbounds nuw i8, ptr %a, i32 56
  store <2 x i16> %55, ptr %56, align 2, !tbaa !6
  %57 = getelementptr inbounds nuw i8, ptr %b, i32 60
  %wide.load.15 = load <2 x i16>, ptr %57, align 2, !tbaa !6
  %58 = getelementptr inbounds nuw i8, ptr %c, i32 60
  %wide.load6.15 = load <2 x i16>, ptr %58, align 2, !tbaa !6
  %59 = add <2 x i16> %wide.load6.15, %wide.load.15
  %60 = getelementptr inbounds nuw i8, ptr %a, i32 60
  store <2 x i16> %59, ptr %60, align 2, !tbaa !6
  %61 = getelementptr inbounds nuw i8, ptr %b, i32 64
  %wide.load.16 = load <2 x i16>, ptr %61, align 2, !tbaa !6
  %62 = getelementptr inbounds nuw i8, ptr %c, i32 64
  %wide.load6.16 = load <2 x i16>, ptr %62, align 2, !tbaa !6
  %63 = add <2 x i16> %wide.load6.16, %wide.load.16
  %64 = getelementptr inbounds nuw i8, ptr %a, i32 64
  store <2 x i16> %63, ptr %64, align 2, !tbaa !6
  %65 = getelementptr inbounds nuw i8, ptr %b, i32 68
  %wide.load.17 = load <2 x i16>, ptr %65, align 2, !tbaa !6
  %66 = getelementptr inbounds nuw i8, ptr %c, i32 68
  %wide.load6.17 = load <2 x i16>, ptr %66, align 2, !tbaa !6
  %67 = add <2 x i16> %wide.load6.17, %wide.load.17
  %68 = getelementptr inbounds nuw i8, ptr %a, i32 68
  store <2 x i16> %67, ptr %68, align 2, !tbaa !6
  %69 = getelementptr inbounds nuw i8, ptr %b, i32 72
  %wide.load.18 = load <2 x i16>, ptr %69, align 2, !tbaa !6
  %70 = getelementptr inbounds nuw i8, ptr %c, i32 72
  %wide.load6.18 = load <2 x i16>, ptr %70, align 2, !tbaa !6
  %71 = add <2 x i16> %wide.load6.18, %wide.load.18
  %72 = getelementptr inbounds nuw i8, ptr %a, i32 72
  store <2 x i16> %71, ptr %72, align 2, !tbaa !6
  %73 = getelementptr inbounds nuw i8, ptr %b, i32 76
  %wide.load.19 = load <2 x i16>, ptr %73, align 2, !tbaa !6
  %74 = getelementptr inbounds nuw i8, ptr %c, i32 76
  %wide.load6.19 = load <2 x i16>, ptr %74, align 2, !tbaa !6
  %75 = add <2 x i16> %wide.load6.19, %wide.load.19
  %76 = getelementptr inbounds nuw i8, ptr %a, i32 76
  store <2 x i16> %75, ptr %76, align 2, !tbaa !6
  %77 = getelementptr inbounds nuw i8, ptr %b, i32 80
  %wide.load.20 = load <2 x i16>, ptr %77, align 2, !tbaa !6
  %78 = getelementptr inbounds nuw i8, ptr %c, i32 80
  %wide.load6.20 = load <2 x i16>, ptr %78, align 2, !tbaa !6
  %79 = add <2 x i16> %wide.load6.20, %wide.load.20
  %80 = getelementptr inbounds nuw i8, ptr %a, i32 80
  store <2 x i16> %79, ptr %80, align 2, !tbaa !6
  %81 = getelementptr inbounds nuw i8, ptr %b, i32 84
  %wide.load.21 = load <2 x i16>, ptr %81, align 2, !tbaa !6
  %82 = getelementptr inbounds nuw i8, ptr %c, i32 84
  %wide.load6.21 = load <2 x i16>, ptr %82, align 2, !tbaa !6
  %83 = add <2 x i16> %wide.load6.21, %wide.load.21
  %84 = getelementptr inbounds nuw i8, ptr %a, i32 84
  store <2 x i16> %83, ptr %84, align 2, !tbaa !6
  %85 = getelementptr inbounds nuw i8, ptr %b, i32 88
  %wide.load.22 = load <2 x i16>, ptr %85, align 2, !tbaa !6
  %86 = getelementptr inbounds nuw i8, ptr %c, i32 88
  %wide.load6.22 = load <2 x i16>, ptr %86, align 2, !tbaa !6
  %87 = add <2 x i16> %wide.load6.22, %wide.load.22
  %88 = getelementptr inbounds nuw i8, ptr %a, i32 88
  store <2 x i16> %87, ptr %88, align 2, !tbaa !6
  %89 = getelementptr inbounds nuw i8, ptr %b, i32 92
  %wide.load.23 = load <2 x i16>, ptr %89, align 2, !tbaa !6
  %90 = getelementptr inbounds nuw i8, ptr %c, i32 92
  %wide.load6.23 = load <2 x i16>, ptr %90, align 2, !tbaa !6
  %91 = add <2 x i16> %wide.load6.23, %wide.load.23
  %92 = getelementptr inbounds nuw i8, ptr %a, i32 92
  store <2 x i16> %91, ptr %92, align 2, !tbaa !6
  %93 = getelementptr inbounds nuw i8, ptr %b, i32 96
  %wide.load.24 = load <2 x i16>, ptr %93, align 2, !tbaa !6
  %94 = getelementptr inbounds nuw i8, ptr %c, i32 96
  %wide.load6.24 = load <2 x i16>, ptr %94, align 2, !tbaa !6
  %95 = add <2 x i16> %wide.load6.24, %wide.load.24
  %96 = getelementptr inbounds nuw i8, ptr %a, i32 96
  store <2 x i16> %95, ptr %96, align 2, !tbaa !6
  %97 = getelementptr inbounds nuw i8, ptr %b, i32 100
  %wide.load.25 = load <2 x i16>, ptr %97, align 2, !tbaa !6
  %98 = getelementptr inbounds nuw i8, ptr %c, i32 100
  %wide.load6.25 = load <2 x i16>, ptr %98, align 2, !tbaa !6
  %99 = add <2 x i16> %wide.load6.25, %wide.load.25
  %100 = getelementptr inbounds nuw i8, ptr %a, i32 100
  store <2 x i16> %99, ptr %100, align 2, !tbaa !6
  %101 = getelementptr inbounds nuw i8, ptr %b, i32 104
  %wide.load.26 = load <2 x i16>, ptr %101, align 2, !tbaa !6
  %102 = getelementptr inbounds nuw i8, ptr %c, i32 104
  %wide.load6.26 = load <2 x i16>, ptr %102, align 2, !tbaa !6
  %103 = add <2 x i16> %wide.load6.26, %wide.load.26
  %104 = getelementptr inbounds nuw i8, ptr %a, i32 104
  store <2 x i16> %103, ptr %104, align 2, !tbaa !6
  %105 = getelementptr inbounds nuw i8, ptr %b, i32 108
  %wide.load.27 = load <2 x i16>, ptr %105, align 2, !tbaa !6
  %106 = getelementptr inbounds nuw i8, ptr %c, i32 108
  %wide.load6.27 = load <2 x i16>, ptr %106, align 2, !tbaa !6
  %107 = add <2 x i16> %wide.load6.27, %wide.load.27
  %108 = getelementptr inbounds nuw i8, ptr %a, i32 108
  store <2 x i16> %107, ptr %108, align 2, !tbaa !6
  %109 = getelementptr inbounds nuw i8, ptr %b, i32 112
  %wide.load.28 = load <2 x i16>, ptr %109, align 2, !tbaa !6
  %110 = getelementptr inbounds nuw i8, ptr %c, i32 112
  %wide.load6.28 = load <2 x i16>, ptr %110, align 2, !tbaa !6
  %111 = add <2 x i16> %wide.load6.28, %wide.load.28
  %112 = getelementptr inbounds nuw i8, ptr %a, i32 112
  store <2 x i16> %111, ptr %112, align 2, !tbaa !6
  %113 = getelementptr inbounds nuw i8, ptr %b, i32 116
  %wide.load.29 = load <2 x i16>, ptr %113, align 2, !tbaa !6
  %114 = getelementptr inbounds nuw i8, ptr %c, i32 116
  %wide.load6.29 = load <2 x i16>, ptr %114, align 2, !tbaa !6
  %115 = add <2 x i16> %wide.load6.29, %wide.load.29
  %116 = getelementptr inbounds nuw i8, ptr %a, i32 116
  store <2 x i16> %115, ptr %116, align 2, !tbaa !6
  %117 = getelementptr inbounds nuw i8, ptr %b, i32 120
  %wide.load.30 = load <2 x i16>, ptr %117, align 2, !tbaa !6
  %118 = getelementptr inbounds nuw i8, ptr %c, i32 120
  %wide.load6.30 = load <2 x i16>, ptr %118, align 2, !tbaa !6
  %119 = add <2 x i16> %wide.load6.30, %wide.load.30
  %120 = getelementptr inbounds nuw i8, ptr %a, i32 120
  store <2 x i16> %119, ptr %120, align 2, !tbaa !6
  %arrayidx = getelementptr inbounds nuw i8, ptr %b, i32 124
  %121 = load i16, ptr %arrayidx, align 2, !tbaa !6
  %arrayidx1 = getelementptr inbounds nuw i8, ptr %c, i32 124
  %122 = load i16, ptr %arrayidx1, align 2, !tbaa !6
  %add = add i16 %122, %121
  %arrayidx4 = getelementptr inbounds nuw i8, ptr %a, i32 124
  store i16 %add, ptr %arrayidx4, align 2, !tbaa !6
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
define dso_local void @add8_k4(ptr noalias nocapture noundef writeonly initializes((0, 4)) %a, ptr noalias nocapture noundef readonly %b, ptr noalias nocapture noundef readonly %c) local_unnamed_addr #1 {
entry:
  %0 = load <4 x i8>, ptr %b, align 1, !tbaa !15
  %1 = load <4 x i8>, ptr %c, align 1, !tbaa !15
  %2 = add <4 x i8> %1, %0
  store <4 x i8> %2, ptr %a, align 1, !tbaa !15
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
define dso_local void @add16_k2(ptr noalias nocapture noundef writeonly initializes((0, 4)) %a, ptr noalias nocapture noundef readonly %b, ptr noalias nocapture noundef readonly %c) local_unnamed_addr #1 {
entry:
  %0 = load <2 x i16>, ptr %b, align 2, !tbaa !6
  %1 = load <2 x i16>, ptr %c, align 2, !tbaa !6
  %2 = add <2 x i16> %1, %0
  store <2 x i16> %2, ptr %a, align 2, !tbaa !6
  ret void
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read)
define dso_local i32 @dot16_k64(ptr noalias nocapture noundef readonly %b, ptr noalias nocapture noundef readonly %c) local_unnamed_addr #3 {
entry:
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body
  ret i32 %add

for.body:                                         ; preds = %entry, %for.body
  %i.06 = phi i32 [ 0, %entry ], [ %inc, %for.body ]
  %s.05 = phi i32 [ 0, %entry ], [ %add, %for.body ]
  %arrayidx = getelementptr inbounds nuw i16, ptr %b, i32 %i.06
  %0 = load i16, ptr %arrayidx, align 2, !tbaa !6
  %conv = sext i16 %0 to i32
  %arrayidx1 = getelementptr inbounds nuw i16, ptr %c, i32 %i.06
  %1 = load i16, ptr %arrayidx1, align 2, !tbaa !6
  %conv2 = sext i16 %1 to i32
  %mul = mul nsw i32 %conv2, %conv
  %add = add nsw i32 %mul, %s.05
  %inc = add nuw nsw i32 %i.06, 1
  %exitcond.not = icmp eq i32 %inc, 64
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !69
}

; Function Attrs: nofree norecurse nosync nounwind memory(readwrite, argmem: none, inaccessiblemem: none)
define dso_local void @add16_glob() local_unnamed_addr #4 {
entry:
  %wide.load = load <2 x i16>, ptr @GB, align 4, !tbaa !6
  %wide.load6 = load <2 x i16>, ptr @GC, align 4, !tbaa !6
  %0 = add <2 x i16> %wide.load6, %wide.load
  store <2 x i16> %0, ptr @GA, align 4, !tbaa !6
  %wide.load.1 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GB, i32 4), align 4, !tbaa !6
  %wide.load6.1 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GC, i32 4), align 4, !tbaa !6
  %1 = add <2 x i16> %wide.load6.1, %wide.load.1
  store <2 x i16> %1, ptr getelementptr inbounds nuw (i8, ptr @GA, i32 4), align 4, !tbaa !6
  %wide.load.2 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GB, i32 8), align 4, !tbaa !6
  %wide.load6.2 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GC, i32 8), align 4, !tbaa !6
  %2 = add <2 x i16> %wide.load6.2, %wide.load.2
  store <2 x i16> %2, ptr getelementptr inbounds nuw (i8, ptr @GA, i32 8), align 4, !tbaa !6
  %wide.load.3 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GB, i32 12), align 4, !tbaa !6
  %wide.load6.3 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GC, i32 12), align 4, !tbaa !6
  %3 = add <2 x i16> %wide.load6.3, %wide.load.3
  store <2 x i16> %3, ptr getelementptr inbounds nuw (i8, ptr @GA, i32 12), align 4, !tbaa !6
  %wide.load.4 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GB, i32 16), align 4, !tbaa !6
  %wide.load6.4 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GC, i32 16), align 4, !tbaa !6
  %4 = add <2 x i16> %wide.load6.4, %wide.load.4
  store <2 x i16> %4, ptr getelementptr inbounds nuw (i8, ptr @GA, i32 16), align 4, !tbaa !6
  %wide.load.5 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GB, i32 20), align 4, !tbaa !6
  %wide.load6.5 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GC, i32 20), align 4, !tbaa !6
  %5 = add <2 x i16> %wide.load6.5, %wide.load.5
  store <2 x i16> %5, ptr getelementptr inbounds nuw (i8, ptr @GA, i32 20), align 4, !tbaa !6
  %wide.load.6 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GB, i32 24), align 4, !tbaa !6
  %wide.load6.6 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GC, i32 24), align 4, !tbaa !6
  %6 = add <2 x i16> %wide.load6.6, %wide.load.6
  store <2 x i16> %6, ptr getelementptr inbounds nuw (i8, ptr @GA, i32 24), align 4, !tbaa !6
  %wide.load.7 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GB, i32 28), align 4, !tbaa !6
  %wide.load6.7 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GC, i32 28), align 4, !tbaa !6
  %7 = add <2 x i16> %wide.load6.7, %wide.load.7
  store <2 x i16> %7, ptr getelementptr inbounds nuw (i8, ptr @GA, i32 28), align 4, !tbaa !6
  %wide.load.8 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GB, i32 32), align 4, !tbaa !6
  %wide.load6.8 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GC, i32 32), align 4, !tbaa !6
  %8 = add <2 x i16> %wide.load6.8, %wide.load.8
  store <2 x i16> %8, ptr getelementptr inbounds nuw (i8, ptr @GA, i32 32), align 4, !tbaa !6
  %wide.load.9 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GB, i32 36), align 4, !tbaa !6
  %wide.load6.9 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GC, i32 36), align 4, !tbaa !6
  %9 = add <2 x i16> %wide.load6.9, %wide.load.9
  store <2 x i16> %9, ptr getelementptr inbounds nuw (i8, ptr @GA, i32 36), align 4, !tbaa !6
  %wide.load.10 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GB, i32 40), align 4, !tbaa !6
  %wide.load6.10 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GC, i32 40), align 4, !tbaa !6
  %10 = add <2 x i16> %wide.load6.10, %wide.load.10
  store <2 x i16> %10, ptr getelementptr inbounds nuw (i8, ptr @GA, i32 40), align 4, !tbaa !6
  %wide.load.11 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GB, i32 44), align 4, !tbaa !6
  %wide.load6.11 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GC, i32 44), align 4, !tbaa !6
  %11 = add <2 x i16> %wide.load6.11, %wide.load.11
  store <2 x i16> %11, ptr getelementptr inbounds nuw (i8, ptr @GA, i32 44), align 4, !tbaa !6
  %wide.load.12 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GB, i32 48), align 4, !tbaa !6
  %wide.load6.12 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GC, i32 48), align 4, !tbaa !6
  %12 = add <2 x i16> %wide.load6.12, %wide.load.12
  store <2 x i16> %12, ptr getelementptr inbounds nuw (i8, ptr @GA, i32 48), align 4, !tbaa !6
  %wide.load.13 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GB, i32 52), align 4, !tbaa !6
  %wide.load6.13 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GC, i32 52), align 4, !tbaa !6
  %13 = add <2 x i16> %wide.load6.13, %wide.load.13
  store <2 x i16> %13, ptr getelementptr inbounds nuw (i8, ptr @GA, i32 52), align 4, !tbaa !6
  %wide.load.14 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GB, i32 56), align 4, !tbaa !6
  %wide.load6.14 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GC, i32 56), align 4, !tbaa !6
  %14 = add <2 x i16> %wide.load6.14, %wide.load.14
  store <2 x i16> %14, ptr getelementptr inbounds nuw (i8, ptr @GA, i32 56), align 4, !tbaa !6
  %wide.load.15 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GB, i32 60), align 4, !tbaa !6
  %wide.load6.15 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GC, i32 60), align 4, !tbaa !6
  %15 = add <2 x i16> %wide.load6.15, %wide.load.15
  store <2 x i16> %15, ptr getelementptr inbounds nuw (i8, ptr @GA, i32 60), align 4, !tbaa !6
  %wide.load.16 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GB, i32 64), align 4, !tbaa !6
  %wide.load6.16 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GC, i32 64), align 4, !tbaa !6
  %16 = add <2 x i16> %wide.load6.16, %wide.load.16
  store <2 x i16> %16, ptr getelementptr inbounds nuw (i8, ptr @GA, i32 64), align 4, !tbaa !6
  %wide.load.17 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GB, i32 68), align 4, !tbaa !6
  %wide.load6.17 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GC, i32 68), align 4, !tbaa !6
  %17 = add <2 x i16> %wide.load6.17, %wide.load.17
  store <2 x i16> %17, ptr getelementptr inbounds nuw (i8, ptr @GA, i32 68), align 4, !tbaa !6
  %wide.load.18 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GB, i32 72), align 4, !tbaa !6
  %wide.load6.18 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GC, i32 72), align 4, !tbaa !6
  %18 = add <2 x i16> %wide.load6.18, %wide.load.18
  store <2 x i16> %18, ptr getelementptr inbounds nuw (i8, ptr @GA, i32 72), align 4, !tbaa !6
  %wide.load.19 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GB, i32 76), align 4, !tbaa !6
  %wide.load6.19 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GC, i32 76), align 4, !tbaa !6
  %19 = add <2 x i16> %wide.load6.19, %wide.load.19
  store <2 x i16> %19, ptr getelementptr inbounds nuw (i8, ptr @GA, i32 76), align 4, !tbaa !6
  %wide.load.20 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GB, i32 80), align 4, !tbaa !6
  %wide.load6.20 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GC, i32 80), align 4, !tbaa !6
  %20 = add <2 x i16> %wide.load6.20, %wide.load.20
  store <2 x i16> %20, ptr getelementptr inbounds nuw (i8, ptr @GA, i32 80), align 4, !tbaa !6
  %wide.load.21 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GB, i32 84), align 4, !tbaa !6
  %wide.load6.21 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GC, i32 84), align 4, !tbaa !6
  %21 = add <2 x i16> %wide.load6.21, %wide.load.21
  store <2 x i16> %21, ptr getelementptr inbounds nuw (i8, ptr @GA, i32 84), align 4, !tbaa !6
  %wide.load.22 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GB, i32 88), align 4, !tbaa !6
  %wide.load6.22 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GC, i32 88), align 4, !tbaa !6
  %22 = add <2 x i16> %wide.load6.22, %wide.load.22
  store <2 x i16> %22, ptr getelementptr inbounds nuw (i8, ptr @GA, i32 88), align 4, !tbaa !6
  %wide.load.23 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GB, i32 92), align 4, !tbaa !6
  %wide.load6.23 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GC, i32 92), align 4, !tbaa !6
  %23 = add <2 x i16> %wide.load6.23, %wide.load.23
  store <2 x i16> %23, ptr getelementptr inbounds nuw (i8, ptr @GA, i32 92), align 4, !tbaa !6
  %wide.load.24 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GB, i32 96), align 4, !tbaa !6
  %wide.load6.24 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GC, i32 96), align 4, !tbaa !6
  %24 = add <2 x i16> %wide.load6.24, %wide.load.24
  store <2 x i16> %24, ptr getelementptr inbounds nuw (i8, ptr @GA, i32 96), align 4, !tbaa !6
  %wide.load.25 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GB, i32 100), align 4, !tbaa !6
  %wide.load6.25 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GC, i32 100), align 4, !tbaa !6
  %25 = add <2 x i16> %wide.load6.25, %wide.load.25
  store <2 x i16> %25, ptr getelementptr inbounds nuw (i8, ptr @GA, i32 100), align 4, !tbaa !6
  %wide.load.26 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GB, i32 104), align 4, !tbaa !6
  %wide.load6.26 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GC, i32 104), align 4, !tbaa !6
  %26 = add <2 x i16> %wide.load6.26, %wide.load.26
  store <2 x i16> %26, ptr getelementptr inbounds nuw (i8, ptr @GA, i32 104), align 4, !tbaa !6
  %wide.load.27 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GB, i32 108), align 4, !tbaa !6
  %wide.load6.27 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GC, i32 108), align 4, !tbaa !6
  %27 = add <2 x i16> %wide.load6.27, %wide.load.27
  store <2 x i16> %27, ptr getelementptr inbounds nuw (i8, ptr @GA, i32 108), align 4, !tbaa !6
  %wide.load.28 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GB, i32 112), align 4, !tbaa !6
  %wide.load6.28 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GC, i32 112), align 4, !tbaa !6
  %28 = add <2 x i16> %wide.load6.28, %wide.load.28
  store <2 x i16> %28, ptr getelementptr inbounds nuw (i8, ptr @GA, i32 112), align 4, !tbaa !6
  %wide.load.29 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GB, i32 116), align 4, !tbaa !6
  %wide.load6.29 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GC, i32 116), align 4, !tbaa !6
  %29 = add <2 x i16> %wide.load6.29, %wide.load.29
  store <2 x i16> %29, ptr getelementptr inbounds nuw (i8, ptr @GA, i32 116), align 4, !tbaa !6
  %wide.load.30 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GB, i32 120), align 4, !tbaa !6
  %wide.load6.30 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GC, i32 120), align 4, !tbaa !6
  %30 = add <2 x i16> %wide.load6.30, %wide.load.30
  store <2 x i16> %30, ptr getelementptr inbounds nuw (i8, ptr @GA, i32 120), align 4, !tbaa !6
  %wide.load.31 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GB, i32 124), align 4, !tbaa !6
  %wide.load6.31 = load <2 x i16>, ptr getelementptr inbounds nuw (i8, ptr @GC, i32 124), align 4, !tbaa !6
  %31 = add <2 x i16> %wide.load6.31, %wide.load.31
  store <2 x i16> %31, ptr getelementptr inbounds nuw (i8, ptr @GA, i32 124), align 4, !tbaa !6
  ret void
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @add16_nr(ptr nocapture noundef writeonly %a, ptr nocapture noundef readonly %b, ptr nocapture noundef readonly %c, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %c9 = ptrtoint ptr %c to i32
  %b8 = ptrtoint ptr %b to i32
  %a7 = ptrtoint ptr %a to i32
  %cmp5 = icmp sgt i32 %n, 0
  br i1 %cmp5, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry
  %min.iters.check = icmp ult i32 %n, 10
  br i1 %min.iters.check, label %for.body.preheader12, label %vector.memcheck

vector.memcheck:                                  ; preds = %for.body.preheader
  %0 = sub i32 %a7, %b8
  %diff.check = icmp ult i32 %0, 4
  %1 = sub i32 %a7, %c9
  %diff.check10 = icmp ult i32 %1, 4
  %conflict.rdx = or i1 %diff.check, %diff.check10
  br i1 %conflict.rdx, label %for.body.preheader12, label %vector.ph

vector.ph:                                        ; preds = %vector.memcheck
  %n.vec = and i32 %n, 2147483646
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %2 = getelementptr inbounds nuw i16, ptr %b, i32 %index
  %wide.load = load <2 x i16>, ptr %2, align 2, !tbaa !6
  %3 = getelementptr inbounds nuw i16, ptr %c, i32 %index
  %wide.load11 = load <2 x i16>, ptr %3, align 2, !tbaa !6
  %4 = add <2 x i16> %wide.load11, %wide.load
  %5 = getelementptr inbounds nuw i16, ptr %a, i32 %index
  store <2 x i16> %4, ptr %5, align 2, !tbaa !6
  %index.next = add nuw i32 %index, 2
  %6 = icmp eq i32 %index.next, %n.vec
  br i1 %6, label %middle.block, label %vector.body, !llvm.loop !70

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i32 %n, %n.vec
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader12

for.body.preheader12:                             ; preds = %vector.memcheck, %for.body.preheader, %middle.block
  %i.06.ph = phi i32 [ 0, %for.body.preheader ], [ 0, %vector.memcheck ], [ %n.vec, %middle.block ]
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %middle.block, %entry
  ret void

for.body:                                         ; preds = %for.body.preheader12, %for.body
  %i.06 = phi i32 [ %inc, %for.body ], [ %i.06.ph, %for.body.preheader12 ]
  %arrayidx = getelementptr inbounds nuw i16, ptr %b, i32 %i.06
  %7 = load i16, ptr %arrayidx, align 2, !tbaa !6
  %arrayidx1 = getelementptr inbounds nuw i16, ptr %c, i32 %i.06
  %8 = load i16, ptr %arrayidx1, align 2, !tbaa !6
  %add = add i16 %8, %7
  %arrayidx4 = getelementptr inbounds nuw i16, ptr %a, i32 %i.06
  store i16 %add, ptr %arrayidx4, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.06, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !71
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @add8_nr(ptr nocapture noundef writeonly %a, ptr nocapture noundef readonly %b, ptr nocapture noundef readonly %c, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %c9 = ptrtoint ptr %c to i32
  %b8 = ptrtoint ptr %b to i32
  %a7 = ptrtoint ptr %a to i32
  %cmp5 = icmp sgt i32 %n, 0
  br i1 %cmp5, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry
  %min.iters.check = icmp ult i32 %n, 12
  br i1 %min.iters.check, label %for.body.preheader12, label %vector.memcheck

vector.memcheck:                                  ; preds = %for.body.preheader
  %0 = sub i32 %a7, %b8
  %diff.check = icmp ult i32 %0, 4
  %1 = sub i32 %a7, %c9
  %diff.check10 = icmp ult i32 %1, 4
  %conflict.rdx = or i1 %diff.check, %diff.check10
  br i1 %conflict.rdx, label %for.body.preheader12, label %vector.ph

vector.ph:                                        ; preds = %vector.memcheck
  %n.vec = and i32 %n, 2147483644
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %2 = getelementptr inbounds nuw i8, ptr %b, i32 %index
  %wide.load = load <4 x i8>, ptr %2, align 1, !tbaa !15
  %3 = getelementptr inbounds nuw i8, ptr %c, i32 %index
  %wide.load11 = load <4 x i8>, ptr %3, align 1, !tbaa !15
  %4 = add <4 x i8> %wide.load11, %wide.load
  %5 = getelementptr inbounds nuw i8, ptr %a, i32 %index
  store <4 x i8> %4, ptr %5, align 1, !tbaa !15
  %index.next = add nuw i32 %index, 4
  %6 = icmp eq i32 %index.next, %n.vec
  br i1 %6, label %middle.block, label %vector.body, !llvm.loop !72

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i32 %n, %n.vec
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader12

for.body.preheader12:                             ; preds = %vector.memcheck, %for.body.preheader, %middle.block
  %i.06.ph = phi i32 [ 0, %for.body.preheader ], [ 0, %vector.memcheck ], [ %n.vec, %middle.block ]
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %middle.block, %entry
  ret void

for.body:                                         ; preds = %for.body.preheader12, %for.body
  %i.06 = phi i32 [ %inc, %for.body ], [ %i.06.ph, %for.body.preheader12 ]
  %arrayidx = getelementptr inbounds nuw i8, ptr %b, i32 %i.06
  %7 = load i8, ptr %arrayidx, align 1, !tbaa !15
  %arrayidx1 = getelementptr inbounds nuw i8, ptr %c, i32 %i.06
  %8 = load i8, ptr %arrayidx1, align 1, !tbaa !15
  %add = add i8 %8, %7
  %arrayidx4 = getelementptr inbounds nuw i8, ptr %a, i32 %i.06
  store i8 %add, ptr %arrayidx4, align 1, !tbaa !15
  %inc = add nuw nsw i32 %i.06, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !73
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @inplace16(ptr nocapture noundef %a, ptr nocapture noundef readonly %b, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp4 = icmp sgt i32 %n, 0
  br i1 %cmp4, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry
  %min.iters.check = icmp ult i32 %n, 10
  br i1 %min.iters.check, label %for.body.preheader8, label %vector.memcheck

vector.memcheck:                                  ; preds = %for.body.preheader
  %0 = shl nuw i32 %n, 1
  %scevgep = getelementptr i8, ptr %a, i32 %0
  %scevgep6 = getelementptr i8, ptr %b, i32 %0
  %bound0 = icmp ult ptr %a, %scevgep6
  %bound1 = icmp ult ptr %b, %scevgep
  %found.conflict = and i1 %bound0, %bound1
  br i1 %found.conflict, label %for.body.preheader8, label %vector.ph

vector.ph:                                        ; preds = %vector.memcheck
  %n.vec = and i32 %n, 2147483646
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %1 = getelementptr inbounds nuw i16, ptr %b, i32 %index
  %wide.load = load <2 x i16>, ptr %1, align 2, !tbaa !6, !alias.scope !74
  %2 = getelementptr inbounds nuw i16, ptr %a, i32 %index
  %wide.load7 = load <2 x i16>, ptr %2, align 2, !tbaa !6, !alias.scope !77, !noalias !74
  %3 = add <2 x i16> %wide.load7, %wide.load
  store <2 x i16> %3, ptr %2, align 2, !tbaa !6, !alias.scope !77, !noalias !74
  %index.next = add nuw i32 %index, 2
  %4 = icmp eq i32 %index.next, %n.vec
  br i1 %4, label %middle.block, label %vector.body, !llvm.loop !79

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i32 %n, %n.vec
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader8

for.body.preheader8:                              ; preds = %vector.memcheck, %for.body.preheader, %middle.block
  %i.05.ph = phi i32 [ 0, %for.body.preheader ], [ 0, %vector.memcheck ], [ %n.vec, %middle.block ]
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %middle.block, %entry
  ret void

for.body:                                         ; preds = %for.body.preheader8, %for.body
  %i.05 = phi i32 [ %inc, %for.body ], [ %i.05.ph, %for.body.preheader8 ]
  %arrayidx = getelementptr inbounds nuw i16, ptr %b, i32 %i.05
  %5 = load i16, ptr %arrayidx, align 2, !tbaa !6
  %arrayidx1 = getelementptr inbounds nuw i16, ptr %a, i32 %i.05
  %6 = load i16, ptr %arrayidx1, align 2, !tbaa !6
  %add = add i16 %6, %5
  store i16 %add, ptr %arrayidx1, align 2, !tbaa !6
  %inc = add nuw nsw i32 %i.05, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !80
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
define dso_local void @slp_add16(ptr noalias nocapture noundef writeonly initializes((0, 4)) %a, ptr noalias nocapture noundef readonly %b, ptr noalias nocapture noundef readonly %c) local_unnamed_addr #1 {
entry:
  %0 = load <2 x i16>, ptr %b, align 2, !tbaa !6
  %1 = load <2 x i16>, ptr %c, align 2, !tbaa !6
  %2 = add <2 x i16> %1, %0
  store <2 x i16> %2, ptr %a, align 2, !tbaa !6
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
define dso_local void @slp_add8(ptr noalias nocapture noundef writeonly initializes((0, 4)) %a, ptr noalias nocapture noundef readonly %b, ptr noalias nocapture noundef readonly %c) local_unnamed_addr #1 {
entry:
  %0 = load <4 x i8>, ptr %b, align 1, !tbaa !15
  %1 = load <4 x i8>, ptr %c, align 1, !tbaa !15
  %2 = add <4 x i8> %1, %0
  store <4 x i8> %2, ptr %a, align 1, !tbaa !15
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite)
define dso_local void @slp_px(ptr noalias nocapture noundef writeonly initializes((0, 4)) %d, ptr noalias nocapture noundef readonly %s, ptr noalias nocapture noundef readonly %t) local_unnamed_addr #1 {
entry:
  %0 = load <4 x i8>, ptr %s, align 1, !tbaa !15
  %1 = load <4 x i8>, ptr %t, align 1, !tbaa !15
  %2 = add <4 x i8> %1, %0
  store <4 x i8> %2, ptr %d, align 1, !tbaa !15
  ret void
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite)
define dso_local void @add32(ptr noalias nocapture noundef writeonly %a, ptr noalias nocapture noundef readonly %b, ptr noalias nocapture noundef readonly %c, i32 noundef %n) local_unnamed_addr #0 {
entry:
  %cmp5 = icmp sgt i32 %n, 0
  br i1 %cmp5, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.body, %entry
  ret void

for.body:                                         ; preds = %entry, %for.body
  %i.06 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds nuw i32, ptr %b, i32 %i.06
  %0 = load i32, ptr %arrayidx, align 4, !tbaa !81
  %arrayidx1 = getelementptr inbounds nuw i32, ptr %c, i32 %i.06
  %1 = load i32, ptr %arrayidx1, align 4, !tbaa !81
  %add = add nsw i32 %1, %0
  %arrayidx2 = getelementptr inbounds nuw i32, ptr %a, i32 %i.06
  store i32 %add, ptr %arrayidx2, align 4, !tbaa !81
  %inc = add nuw nsw i32 %i.06, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body, !llvm.loop !83
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #5

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i16 @llvm.sadd.sat.i16(i16, i16) #5

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i16 @llvm.smin.i16(i16, i16) #5

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i16 @llvm.smax.i16(i16, i16) #5

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.abs.i32(i32, i1 immarg) #5

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i8 @llvm.smax.i8(i8, i8) #5

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i8 @llvm.umax.i8(i8, i8) #5

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i16 @llvm.abs.i16(i16, i1 immarg) #5

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i32(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i32, i1 immarg) #6

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare <2 x i16> @llvm.smin.v2i16(<2 x i16>, <2 x i16>) #5

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare <4 x i8> @llvm.smax.v4i8(<4 x i8>, <4 x i8>) #5

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare <4 x i8> @llvm.umax.v4i8(<4 x i8>, <4 x i8>) #5

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare <2 x i16> @llvm.abs.v2i16(<2 x i16>, i1 immarg) #5

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare <2 x i16> @llvm.sadd.sat.v2i16(<2 x i16>, <2 x i16>) #5

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare <2 x i16> @llvm.smax.v2i16(<2 x i16>, <2 x i16>) #5

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i16 @llvm.vector.reduce.add.v2i16(<2 x i16>) #5

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i16 @llvm.vector.reduce.smax.v2i16(<2 x i16>) #5

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv32" "target-features"="+32bit,+c,+m,+relax,+xgap,+xpulpf16alt,+xpulpfvec,+xpulpv,+zfinx,+zhinx,+zhinxmin,+zicsr,+zmmul,-a,-b,-d,-e,-experimental-sdext,-experimental-sdtrig,-experimental-smctr,-experimental-ssctr,-experimental-svukte,-experimental-xqcia,-experimental-xqciac,-experimental-xqcicli,-experimental-xqcicm,-experimental-xqcics,-experimental-xqcicsr,-experimental-xqciint,-experimental-xqcilo,-experimental-xqcilsm,-experimental-xqcisls,-experimental-zalasr,-experimental-zicfilp,-experimental-zicfiss,-experimental-zvbc32e,-experimental-zvkgs,-f,-h,-sha,-shcounterenw,-shgatpa,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcsrind,-smdbltrp,-smepmp,-smmpm,-smnpm,-smrnmi,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssdbltrp,-ssnpm,-sspm,-ssqosid,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-supm,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-svvptc,-v,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xdma,-xfalthalf,-xfaltquarter,-xfauxalthalf,-xfauxaltquarter,-xfauxhalf,-xfauxquarter,-xfauxvecalthalf,-xfauxvecaltquarter,-xfauxvechalf,-xfauxvecquarter,-xfauxvecsingle,-xfexpauxvecalthalf,-xfexpauxvecaltquarter,-xfexpauxvechalf,-xfexpauxvecquarter,-xfquarter,-xfrep,-xfvecalthalf,-xfvecaltquarter,-xfvechalf,-xfvecquarter,-xfvecsingle,-xmempool,-xmipscmove,-xmipslsp,-xsfcease,-xsfvcp,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xssr,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-xwchc,-za128rs,-za64rs,-zaamo,-zabha,-zacas,-zalrsc,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zca,-zcb,-zcd,-zce,-zcf,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfbfmin,-zfh,-zfhmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zifencei,-zihintntl,-zihintpause,-zihpm,-zimop,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-ztso,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfbfmin,-zvfbfwma,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #1 = { mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: readwrite) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv32" "target-features"="+32bit,+c,+m,+relax,+xgap,+xpulpf16alt,+xpulpfvec,+xpulpv,+zfinx,+zhinx,+zhinxmin,+zicsr,+zmmul,-a,-b,-d,-e,-experimental-sdext,-experimental-sdtrig,-experimental-smctr,-experimental-ssctr,-experimental-svukte,-experimental-xqcia,-experimental-xqciac,-experimental-xqcicli,-experimental-xqcicm,-experimental-xqcics,-experimental-xqcicsr,-experimental-xqciint,-experimental-xqcilo,-experimental-xqcilsm,-experimental-xqcisls,-experimental-zalasr,-experimental-zicfilp,-experimental-zicfiss,-experimental-zvbc32e,-experimental-zvkgs,-f,-h,-sha,-shcounterenw,-shgatpa,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcsrind,-smdbltrp,-smepmp,-smmpm,-smnpm,-smrnmi,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssdbltrp,-ssnpm,-sspm,-ssqosid,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-supm,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-svvptc,-v,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xdma,-xfalthalf,-xfaltquarter,-xfauxalthalf,-xfauxaltquarter,-xfauxhalf,-xfauxquarter,-xfauxvecalthalf,-xfauxvecaltquarter,-xfauxvechalf,-xfauxvecquarter,-xfauxvecsingle,-xfexpauxvecalthalf,-xfexpauxvecaltquarter,-xfexpauxvechalf,-xfexpauxvecquarter,-xfquarter,-xfrep,-xfvecalthalf,-xfvecaltquarter,-xfvechalf,-xfvecquarter,-xfvecsingle,-xmempool,-xmipscmove,-xmipslsp,-xsfcease,-xsfvcp,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xssr,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-xwchc,-za128rs,-za64rs,-zaamo,-zabha,-zacas,-zalrsc,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zca,-zcb,-zcd,-zce,-zcf,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfbfmin,-zfh,-zfhmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zifencei,-zihintntl,-zihintpause,-zihpm,-zimop,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-ztso,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfbfmin,-zvfbfwma,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #2 = { nofree norecurse nosync nounwind memory(argmem: write) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv32" "target-features"="+32bit,+c,+m,+relax,+xgap,+xpulpf16alt,+xpulpfvec,+xpulpv,+zfinx,+zhinx,+zhinxmin,+zicsr,+zmmul,-a,-b,-d,-e,-experimental-sdext,-experimental-sdtrig,-experimental-smctr,-experimental-ssctr,-experimental-svukte,-experimental-xqcia,-experimental-xqciac,-experimental-xqcicli,-experimental-xqcicm,-experimental-xqcics,-experimental-xqcicsr,-experimental-xqciint,-experimental-xqcilo,-experimental-xqcilsm,-experimental-xqcisls,-experimental-zalasr,-experimental-zicfilp,-experimental-zicfiss,-experimental-zvbc32e,-experimental-zvkgs,-f,-h,-sha,-shcounterenw,-shgatpa,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcsrind,-smdbltrp,-smepmp,-smmpm,-smnpm,-smrnmi,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssdbltrp,-ssnpm,-sspm,-ssqosid,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-supm,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-svvptc,-v,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xdma,-xfalthalf,-xfaltquarter,-xfauxalthalf,-xfauxaltquarter,-xfauxhalf,-xfauxquarter,-xfauxvecalthalf,-xfauxvecaltquarter,-xfauxvechalf,-xfauxvecquarter,-xfauxvecsingle,-xfexpauxvecalthalf,-xfexpauxvecaltquarter,-xfexpauxvechalf,-xfexpauxvecquarter,-xfquarter,-xfrep,-xfvecalthalf,-xfvecaltquarter,-xfvechalf,-xfvecquarter,-xfvecsingle,-xmempool,-xmipscmove,-xmipslsp,-xsfcease,-xsfvcp,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xssr,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-xwchc,-za128rs,-za64rs,-zaamo,-zabha,-zacas,-zalrsc,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zca,-zcb,-zcd,-zce,-zcf,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfbfmin,-zfh,-zfhmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zifencei,-zihintntl,-zihintpause,-zihpm,-zimop,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-ztso,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfbfmin,-zvfbfwma,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #3 = { nofree norecurse nosync nounwind memory(argmem: read) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv32" "target-features"="+32bit,+c,+m,+relax,+xgap,+xpulpf16alt,+xpulpfvec,+xpulpv,+zfinx,+zhinx,+zhinxmin,+zicsr,+zmmul,-a,-b,-d,-e,-experimental-sdext,-experimental-sdtrig,-experimental-smctr,-experimental-ssctr,-experimental-svukte,-experimental-xqcia,-experimental-xqciac,-experimental-xqcicli,-experimental-xqcicm,-experimental-xqcics,-experimental-xqcicsr,-experimental-xqciint,-experimental-xqcilo,-experimental-xqcilsm,-experimental-xqcisls,-experimental-zalasr,-experimental-zicfilp,-experimental-zicfiss,-experimental-zvbc32e,-experimental-zvkgs,-f,-h,-sha,-shcounterenw,-shgatpa,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcsrind,-smdbltrp,-smepmp,-smmpm,-smnpm,-smrnmi,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssdbltrp,-ssnpm,-sspm,-ssqosid,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-supm,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-svvptc,-v,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xdma,-xfalthalf,-xfaltquarter,-xfauxalthalf,-xfauxaltquarter,-xfauxhalf,-xfauxquarter,-xfauxvecalthalf,-xfauxvecaltquarter,-xfauxvechalf,-xfauxvecquarter,-xfauxvecsingle,-xfexpauxvecalthalf,-xfexpauxvecaltquarter,-xfexpauxvechalf,-xfexpauxvecquarter,-xfquarter,-xfrep,-xfvecalthalf,-xfvecaltquarter,-xfvechalf,-xfvecquarter,-xfvecsingle,-xmempool,-xmipscmove,-xmipslsp,-xsfcease,-xsfvcp,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xssr,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-xwchc,-za128rs,-za64rs,-zaamo,-zabha,-zacas,-zalrsc,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zca,-zcb,-zcd,-zce,-zcf,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfbfmin,-zfh,-zfhmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zifencei,-zihintntl,-zihintpause,-zihpm,-zimop,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-ztso,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfbfmin,-zvfbfwma,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #4 = { nofree norecurse nosync nounwind memory(readwrite, argmem: none, inaccessiblemem: none) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv32" "target-features"="+32bit,+c,+m,+relax,+xgap,+xpulpf16alt,+xpulpfvec,+xpulpv,+zfinx,+zhinx,+zhinxmin,+zicsr,+zmmul,-a,-b,-d,-e,-experimental-sdext,-experimental-sdtrig,-experimental-smctr,-experimental-ssctr,-experimental-svukte,-experimental-xqcia,-experimental-xqciac,-experimental-xqcicli,-experimental-xqcicm,-experimental-xqcics,-experimental-xqcicsr,-experimental-xqciint,-experimental-xqcilo,-experimental-xqcilsm,-experimental-xqcisls,-experimental-zalasr,-experimental-zicfilp,-experimental-zicfiss,-experimental-zvbc32e,-experimental-zvkgs,-f,-h,-sha,-shcounterenw,-shgatpa,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcsrind,-smdbltrp,-smepmp,-smmpm,-smnpm,-smrnmi,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssdbltrp,-ssnpm,-sspm,-ssqosid,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-supm,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-svvptc,-v,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xdma,-xfalthalf,-xfaltquarter,-xfauxalthalf,-xfauxaltquarter,-xfauxhalf,-xfauxquarter,-xfauxvecalthalf,-xfauxvecaltquarter,-xfauxvechalf,-xfauxvecquarter,-xfauxvecsingle,-xfexpauxvecalthalf,-xfexpauxvecaltquarter,-xfexpauxvechalf,-xfexpauxvecquarter,-xfquarter,-xfrep,-xfvecalthalf,-xfvecaltquarter,-xfvechalf,-xfvecquarter,-xfvecsingle,-xmempool,-xmipscmove,-xmipslsp,-xsfcease,-xsfvcp,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xssr,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-xwchc,-za128rs,-za64rs,-zaamo,-zabha,-zacas,-zalrsc,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zca,-zcb,-zcd,-zce,-zcf,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfbfmin,-zfh,-zfhmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zifencei,-zihintntl,-zihintpause,-zihpm,-zimop,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-ztso,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfbfmin,-zvfbfwma,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #5 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #6 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }

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
!15 = !{!8, !8, i64 0}
!16 = distinct !{!16, !11, !12, !13}
!17 = distinct !{!17, !11, !13, !12}
!18 = distinct !{!18, !11, !12, !13}
!19 = distinct !{!19, !11, !13, !12}
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
!34 = distinct !{!34, !11, !12, !13}
!35 = distinct !{!35, !11, !13, !12}
!36 = distinct !{!36, !11, !12, !13}
!37 = distinct !{!37, !11, !13, !12}
!38 = distinct !{!38, !11, !12, !13}
!39 = distinct !{!39, !11, !13, !12}
!40 = distinct !{!40, !11, !12, !13}
!41 = distinct !{!41, !11, !13, !12}
!42 = distinct !{!42, !11, !12, !13}
!43 = distinct !{!43, !11, !13, !12}
!44 = distinct !{!44, !11, !12, !13}
!45 = distinct !{!45, !11, !13, !12}
!46 = distinct !{!46, !11, !12, !13}
!47 = distinct !{!47, !11, !13, !12}
!48 = distinct !{!48, !11, !12, !13}
!49 = distinct !{!49, !11, !13, !12}
!50 = distinct !{!50, !11, !12, !13}
!51 = distinct !{!51, !11, !13, !12}
!52 = distinct !{!52, !11, !12, !13}
!53 = distinct !{!53, !11, !13, !12}
!54 = distinct !{!54, !11, !12, !13}
!55 = distinct !{!55, !11, !13, !12}
!56 = distinct !{!56, !11, !12, !13}
!57 = distinct !{!57, !11, !13, !12}
!58 = distinct !{!58, !11}
!59 = distinct !{!59, !11}
!60 = distinct !{!60, !11}
!61 = distinct !{!61, !11}
!62 = distinct !{!62, !11}
!63 = distinct !{!63, !11, !12, !13}
!64 = distinct !{!64, !11, !13, !12}
!65 = distinct !{!65, !11}
!66 = distinct !{!66, !11, !12, !13}
!67 = distinct !{!67, !11, !13, !12}
!68 = distinct !{!68, !11}
!69 = distinct !{!69, !11}
!70 = distinct !{!70, !11, !12, !13}
!71 = distinct !{!71, !11, !12}
!72 = distinct !{!72, !11, !12, !13}
!73 = distinct !{!73, !11, !12}
!74 = !{!75}
!75 = distinct !{!75, !76}
!76 = distinct !{!76, !"LVerDomain"}
!77 = !{!78}
!78 = distinct !{!78, !76}
!79 = distinct !{!79, !11, !12, !13}
!80 = distinct !{!80, !11, !12}
!81 = !{!82, !82, i64 0}
!82 = !{!"int", !8, i64 0}
!83 = distinct !{!83, !11}
