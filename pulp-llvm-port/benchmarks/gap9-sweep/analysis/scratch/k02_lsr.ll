*** IR Dump After Loop Strength Reduction (loop-reduce) ***
; Preheader:
for.body182.lr.ph:                                ; preds = %if.end
  %37 = getelementptr float, ptr %DelayLine, i32 %NSamples
  %38 = add i32 %NCoeffs, -1
  br label %for.body182

; Loop:
for.body182:                                      ; preds = %for.body182.lr.ph, %for.body182
  %lsr.iv326 = phi ptr [ %37, %for.body182.lr.ph ], [ %scevgep327, %for.body182 ]
  %lsr.iv325 = phi ptr [ %DelayLine, %for.body182.lr.ph ], [ %scevgep, %for.body182 ]
  %lsr.iv = phi i32 [ %38, %for.body182.lr.ph ], [ %lsr.iv.next, %for.body182 ]
  %39 = load float, ptr %lsr.iv326, align 4, !tbaa !6
  store float %39, ptr %lsr.iv325, align 4, !tbaa !6
  %lsr.iv.next = add i32 %lsr.iv, -1
  %scevgep = getelementptr i8, ptr %lsr.iv325, i32 4
  %scevgep327 = getelementptr i8, ptr %lsr.iv326, i32 4
  %exitcond324.not = icmp eq i32 %lsr.iv.next, 0
  br i1 %exitcond324.not, label %for.end188.loopexit, label %for.body182, !llvm.loop !16

; Exit blocks
for.end188.loopexit:                              ; preds = %for.body182
  br label %for.end188
*** IR Dump After Loop Strength Reduction (loop-reduce) ***
; Preheader:
for.body164.preheader:                            ; preds = %for.end158
  %34 = sub i32 %NCoeffs, %mul160
  %35 = shl i32 %div116, 4
  %scevgep329 = getelementptr i8, ptr %Coeffs, i32 %35
  %36 = shl i32 %NSamples, 2
  %37 = add i32 %35, %36
  %38 = add i32 %37, -4
  %scevgep332 = getelementptr i8, ptr %DelayLine, i32 %38
  br label %for.body164

; Loop:
for.body164:                                      ; preds = %for.body164.preheader, %for.body164
  %lsr.iv333 = phi ptr [ %scevgep332, %for.body164.preheader ], [ %scevgep334, %for.body164 ]
  %lsr.iv330 = phi ptr [ %scevgep329, %for.body164.preheader ], [ %scevgep331, %for.body164 ]
  %lsr.iv = phi i32 [ %34, %for.body164.preheader ], [ %lsr.iv.next, %for.body164 ]
  %Acc1112.1316 = phi i32 [ %conv171, %for.body164 ], [ %Acc1112.0.lcssa, %for.body164.preheader ]
  %39 = load float, ptr %lsr.iv333, align 4, !tbaa !6
  %40 = load float, ptr %lsr.iv330, align 4, !tbaa !6
  %conv170 = sitofp i32 %Acc1112.1316 to float
  %41 = tail call float @llvm.fmuladd.f32(float %39, float %40, float %conv170)
  %conv171 = fptosi float %41 to i32
  %lsr.iv.next = add i32 %lsr.iv, -1
  %scevgep331 = getelementptr i8, ptr %lsr.iv330, i32 4
  %scevgep334 = getelementptr i8, ptr %lsr.iv333, i32 4
  %exitcond323.not = icmp eq i32 %lsr.iv.next, 0
  br i1 %exitcond323.not, label %for.end174.loopexit, label %for.body164, !llvm.loop !15

; Exit blocks
for.end174.loopexit:                              ; preds = %for.body164
  br label %for.end174
*** IR Dump After Loop Strength Reduction (loop-reduce) ***
; Preheader:
for.body119.preheader:                            ; preds = %if.then
  %22 = shl i32 %NSamples, 2
  %23 = add i32 %22, 4
  %scevgep337 = getelementptr i8, ptr %DelayLine, i32 %23
  %scevgep343 = getelementptr i8, ptr %Coeffs, i32 8
  br label %for.body119

; Loop:
for.body119:                                      ; preds = %for.body119.preheader, %for.body119
  %lsr.iv344 = phi ptr [ %scevgep343, %for.body119.preheader ], [ %scevgep345, %for.body119 ]
  %lsr.iv338 = phi ptr [ %scevgep337, %for.body119.preheader ], [ %scevgep339, %for.body119 ]
  %lsr.iv335 = phi i32 [ %div116, %for.body119.preheader ], [ %lsr.iv.next336, %for.body119 ]
  %Acc1112.0311 = phi i32 [ %conv155, %for.body119 ], [ 0, %for.body119.preheader ]
  %scevgep342 = getelementptr i8, ptr %lsr.iv338, i32 -8
  %24 = load float, ptr %scevgep342, align 4, !tbaa !6
  %scevgep347 = getelementptr i8, ptr %lsr.iv344, i32 -8
  %25 = load float, ptr %scevgep347, align 4, !tbaa !6
  %conv127 = sitofp i32 %Acc1112.0311 to float
  %26 = tail call float @llvm.fmuladd.f32(float %24, float %25, float %conv127)
  %conv128 = fptosi float %26 to i32
  %scevgep340 = getelementptr i8, ptr %lsr.iv338, i32 -4
  %27 = load float, ptr %scevgep340, align 4, !tbaa !6
  %scevgep348 = getelementptr i8, ptr %lsr.iv344, i32 -4
  %28 = load float, ptr %scevgep348, align 4, !tbaa !6
  %conv136 = sitofp i32 %conv128 to float
  %29 = tail call float @llvm.fmuladd.f32(float %27, float %28, float %conv136)
  %conv137 = fptosi float %29 to i32
  %30 = load float, ptr %lsr.iv338, align 4, !tbaa !6
  %31 = load float, ptr %lsr.iv344, align 4, !tbaa !6
  %conv145 = sitofp i32 %conv137 to float
  %32 = tail call float @llvm.fmuladd.f32(float %30, float %31, float %conv145)
  %conv146 = fptosi float %32 to i32
  %scevgep341 = getelementptr i8, ptr %lsr.iv338, i32 4
  %33 = load float, ptr %scevgep341, align 4, !tbaa !6
  %scevgep346 = getelementptr i8, ptr %lsr.iv344, i32 4
  %34 = load float, ptr %scevgep346, align 4, !tbaa !6
  %conv154 = sitofp i32 %conv146 to float
  %35 = tail call float @llvm.fmuladd.f32(float %33, float %34, float %conv154)
  %conv155 = fptosi float %35 to i32
  %lsr.iv.next336 = add i32 %lsr.iv335, -1
  %scevgep339 = getelementptr i8, ptr %lsr.iv338, i32 16
  %scevgep345 = getelementptr i8, ptr %lsr.iv344, i32 16
  %exitcond322.not = icmp eq i32 %lsr.iv.next336, 0
  br i1 %exitcond322.not, label %for.end158.loopexit, label %for.body119, !llvm.loop !14

; Exit blocks
for.end158.loopexit:                              ; preds = %for.body119
  br label %for.end158
*** IR Dump After Loop Strength Reduction (loop-reduce) ***
; Preheader:
for.body6.preheader:                              ; preds = %for.body
  br label %for.body6

; Loop:
for.body6:                                        ; preds = %for.body6.preheader, %for.body6
  %lsr.iv363 = phi ptr [ %scevgep362, %for.body6.preheader ], [ %scevgep364, %for.body6 ]
  %lsr.iv356 = phi ptr [ %lsr.iv354, %for.body6.preheader ], [ %scevgep357, %for.body6 ]
  %lsr.iv351 = phi i32 [ %div4, %for.body6.preheader ], [ %lsr.iv.next352, %for.body6 ]
  %Acc1.0297 = phi i32 [ %conv41, %for.body6 ], [ 0, %for.body6.preheader ]
  %Acc2.0296 = phi i32 [ %conv77, %for.body6 ], [ 0, %for.body6.preheader ]
  %scevgep359 = getelementptr i8, ptr %lsr.iv356, i32 -8
  %0 = load float, ptr %scevgep359, align 4, !tbaa !6
  %scevgep366 = getelementptr i8, ptr %lsr.iv363, i32 -8
  %1 = load float, ptr %scevgep366, align 4, !tbaa !6
  %conv = sitofp i32 %Acc1.0297 to float
  %2 = tail call float @llvm.fmuladd.f32(float %0, float %1, float %conv)
  %conv14 = fptosi float %2 to i32
  %scevgep361 = getelementptr i8, ptr %lsr.iv356, i32 -4
  %3 = load float, ptr %scevgep361, align 4, !tbaa !6
  %scevgep367 = getelementptr i8, ptr %lsr.iv363, i32 -4
  %4 = load float, ptr %scevgep367, align 4, !tbaa !6
  %conv22 = sitofp i32 %conv14 to float
  %5 = tail call float @llvm.fmuladd.f32(float %3, float %4, float %conv22)
  %conv23 = fptosi float %5 to i32
  %6 = load float, ptr %lsr.iv356, align 4, !tbaa !6
  %7 = load float, ptr %lsr.iv363, align 4, !tbaa !6
  %conv31 = sitofp i32 %conv23 to float
  %8 = tail call float @llvm.fmuladd.f32(float %6, float %7, float %conv31)
  %conv32 = fptosi float %8 to i32
  %scevgep360 = getelementptr i8, ptr %lsr.iv356, i32 4
  %9 = load float, ptr %scevgep360, align 4, !tbaa !6
  %scevgep365 = getelementptr i8, ptr %lsr.iv363, i32 4
  %10 = load float, ptr %scevgep365, align 4, !tbaa !6
  %conv40 = sitofp i32 %conv32 to float
  %11 = tail call float @llvm.fmuladd.f32(float %9, float %10, float %conv40)
  %conv41 = fptosi float %11 to i32
  %conv49 = sitofp i32 %Acc2.0296 to float
  %12 = tail call float @llvm.fmuladd.f32(float %3, float %1, float %conv49)
  %conv50 = fptosi float %12 to i32
  %conv58 = sitofp i32 %conv50 to float
  %13 = tail call float @llvm.fmuladd.f32(float %6, float %4, float %conv58)
  %conv59 = fptosi float %13 to i32
  %conv67 = sitofp i32 %conv59 to float
  %14 = tail call float @llvm.fmuladd.f32(float %9, float %7, float %conv67)
  %conv68 = fptosi float %14 to i32
  %scevgep358 = getelementptr i8, ptr %lsr.iv356, i32 8
  %15 = load float, ptr %scevgep358, align 4, !tbaa !6
  %conv76 = sitofp i32 %conv68 to float
  %16 = tail call float @llvm.fmuladd.f32(float %15, float %10, float %conv76)
  %conv77 = fptosi float %16 to i32
  %lsr.iv.next352 = add i32 %lsr.iv351, -1
  %scevgep357 = getelementptr i8, ptr %lsr.iv356, i32 16
  %scevgep364 = getelementptr i8, ptr %lsr.iv363, i32 16
  %exitcond.not = icmp eq i32 %lsr.iv.next352, 0
  br i1 %exitcond.not, label %for.end.loopexit, label %for.body6, !llvm.loop !10

; Exit blocks
for.end.loopexit:                                 ; preds = %for.body6
  br label %for.end
*** IR Dump After Loop Strength Reduction (loop-reduce) ***
; Preheader:
for.body83.preheader:                             ; preds = %for.end
  br label %for.body83

; Loop:
for.body83:                                       ; preds = %for.body83.preheader, %for.body83
  %lsr.iv378 = phi ptr [ %lsr.iv376, %for.body83.preheader ], [ %scevgep379, %for.body83 ]
  %lsr.iv373 = phi ptr [ %scevgep372, %for.body83.preheader ], [ %scevgep374, %for.body83 ]
  %lsr.iv370 = phi i32 [ %2, %for.body83.preheader ], [ %lsr.iv.next371, %for.body83 ]
  %Acc1.1303 = phi i32 [ %conv90, %for.body83 ], [ %Acc1.0.lcssa, %for.body83.preheader ]
  %Acc2.1302 = phi i32 [ %conv98, %for.body83 ], [ %Acc2.0.lcssa, %for.body83.preheader ]
  %scevgep380 = getelementptr i8, ptr %lsr.iv378, i32 -4
  %23 = load float, ptr %scevgep380, align 4, !tbaa !6
  %24 = load float, ptr %lsr.iv373, align 4, !tbaa !6
  %conv89 = sitofp i32 %Acc1.1303 to float
  %25 = tail call float @llvm.fmuladd.f32(float %23, float %24, float %conv89)
  %conv90 = fptosi float %25 to i32
  %26 = load float, ptr %lsr.iv378, align 4, !tbaa !6
  %conv97 = sitofp i32 %Acc2.1302 to float
  %27 = tail call float @llvm.fmuladd.f32(float %26, float %24, float %conv97)
  %conv98 = fptosi float %27 to i32
  %lsr.iv.next371 = add i32 %lsr.iv370, -1
  %scevgep374 = getelementptr i8, ptr %lsr.iv373, i32 4
  %scevgep379 = getelementptr i8, ptr %lsr.iv378, i32 4
  %exitcond320.not = icmp eq i32 %lsr.iv.next371, 0
  br i1 %exitcond320.not, label %for.end101.loopexit, label %for.body83, !llvm.loop !12

; Exit blocks
for.end101.loopexit:                              ; preds = %for.body83
  br label %for.end101
*** IR Dump After Loop Strength Reduction (loop-reduce) ***
; Preheader:
for.body.lr.ph:                                   ; preds = %entry
  %div4 = sdiv i32 %NCoeffs, 4
  %cmp5295 = icmp sgt i32 %NCoeffs, 3
  %mul79 = shl i32 %div4, 2
  %cmp81301 = icmp slt i32 %mul79, %NCoeffs
  %scevgep353 = getelementptr i8, ptr %DelayLine, i32 8
  %scevgep362 = getelementptr i8, ptr %Coeffs, i32 8
  %0 = shl i32 %div4, 4
  %1 = add nuw nsw i32 %0, 8
  %2 = sub i32 %NCoeffs, %mul79
  %scevgep372 = getelementptr i8, ptr %Coeffs, i32 %0
  %3 = add nuw nsw i32 %0, 4
  %scevgep375 = getelementptr i8, ptr %DelayLine, i32 %3
  br label %for.body

; Loop:
for.body:                                         ; preds = %for.body.lr.ph, %for.end101
  %lsr.iv376 = phi ptr [ %scevgep375, %for.body.lr.ph ], [ %scevgep377, %for.end101 ]
  %lsr.iv354 = phi ptr [ %scevgep353, %for.body.lr.ph ], [ %scevgep355, %for.end101 ]
  %i.0308 = phi i32 [ 0, %for.body.lr.ph ], [ %inc110, %for.end101 ]
  %4 = shl i32 %i.0308, 3
  %5 = add i32 %1, %4
  %scevgep368 = getelementptr i8, ptr %DelayLine, i32 %5
  %mul = shl nuw nsw i32 %i.0308, 1
  %add = or disjoint i32 %mul, 1
  br i1 %cmp5295, label %for.body6.preheader, label %for.end

for.body6:                                        ; preds = %for.body6.preheader, %for.body6
  %lsr.iv363 = phi ptr [ %scevgep362, %for.body6.preheader ], [ %scevgep364, %for.body6 ]
  %lsr.iv356 = phi ptr [ %lsr.iv354, %for.body6.preheader ], [ %scevgep357, %for.body6 ]
  %Acc1.0297 = phi i32 [ %conv41, %for.body6 ], [ 0, %for.body6.preheader ]
  %Acc2.0296 = phi i32 [ %conv77, %for.body6 ], [ 0, %for.body6.preheader ]
  %scevgep359 = getelementptr i8, ptr %lsr.iv356, i32 -8
  %6 = load float, ptr %scevgep359, align 4, !tbaa !6
  %scevgep366 = getelementptr i8, ptr %lsr.iv363, i32 -8
  %7 = load float, ptr %scevgep366, align 4, !tbaa !6
  %conv = sitofp i32 %Acc1.0297 to float
  %8 = tail call float @llvm.fmuladd.f32(float %6, float %7, float %conv)
  %conv14 = fptosi float %8 to i32
  %scevgep361 = getelementptr i8, ptr %lsr.iv356, i32 -4
  %9 = load float, ptr %scevgep361, align 4, !tbaa !6
  %scevgep367 = getelementptr i8, ptr %lsr.iv363, i32 -4
  %10 = load float, ptr %scevgep367, align 4, !tbaa !6
  %conv22 = sitofp i32 %conv14 to float
  %11 = tail call float @llvm.fmuladd.f32(float %9, float %10, float %conv22)
  %conv23 = fptosi float %11 to i32
  %12 = load float, ptr %lsr.iv356, align 4, !tbaa !6
  %13 = load float, ptr %lsr.iv363, align 4, !tbaa !6
  %conv31 = sitofp i32 %conv23 to float
  %14 = tail call float @llvm.fmuladd.f32(float %12, float %13, float %conv31)
  %conv32 = fptosi float %14 to i32
  %scevgep360 = getelementptr i8, ptr %lsr.iv356, i32 4
  %15 = load float, ptr %scevgep360, align 4, !tbaa !6
  %scevgep365 = getelementptr i8, ptr %lsr.iv363, i32 4
  %16 = load float, ptr %scevgep365, align 4, !tbaa !6
  %conv40 = sitofp i32 %conv32 to float
  %17 = tail call float @llvm.fmuladd.f32(float %15, float %16, float %conv40)
  %conv41 = fptosi float %17 to i32
  %conv49 = sitofp i32 %Acc2.0296 to float
  %18 = tail call float @llvm.fmuladd.f32(float %9, float %7, float %conv49)
  %conv50 = fptosi float %18 to i32
  %conv58 = sitofp i32 %conv50 to float
  %19 = tail call float @llvm.fmuladd.f32(float %12, float %10, float %conv58)
  %conv59 = fptosi float %19 to i32
  %conv67 = sitofp i32 %conv59 to float
  %20 = tail call float @llvm.fmuladd.f32(float %15, float %13, float %conv67)
  %conv68 = fptosi float %20 to i32
  %scevgep358 = getelementptr i8, ptr %lsr.iv356, i32 8
  %21 = load float, ptr %scevgep358, align 4, !tbaa !6
  %conv76 = sitofp i32 %conv68 to float
  %22 = tail call float @llvm.fmuladd.f32(float %21, float %16, float %conv76)
  %conv77 = fptosi float %22 to i32
  %scevgep357 = getelementptr i8, ptr %lsr.iv356, i32 16
  %scevgep364 = getelementptr i8, ptr %lsr.iv363, i32 16
  %lsr_fold_term_cond.replaced_term_cond369 = icmp eq ptr %scevgep357, %scevgep368
  br i1 %lsr_fold_term_cond.replaced_term_cond369, label %for.end.loopexit, label %for.body6, !llvm.loop !10

for.end:                                          ; preds = %for.end.loopexit, %for.body
  %Acc2.0.lcssa = phi i32 [ 0, %for.body ], [ %conv77, %for.end.loopexit ]
  %Acc1.0.lcssa = phi i32 [ 0, %for.body ], [ %conv41, %for.end.loopexit ]
  br i1 %cmp81301, label %for.body83.preheader, label %for.end101

for.body83:                                       ; preds = %for.body83.preheader, %for.body83
  %lsr.iv378 = phi ptr [ %lsr.iv376, %for.body83.preheader ], [ %scevgep379, %for.body83 ]
  %lsr.iv373 = phi ptr [ %scevgep372, %for.body83.preheader ], [ %scevgep374, %for.body83 ]
  %lsr.iv370 = phi i32 [ %2, %for.body83.preheader ], [ %lsr.iv.next371, %for.body83 ]
  %Acc1.1303 = phi i32 [ %conv90, %for.body83 ], [ %Acc1.0.lcssa, %for.body83.preheader ]
  %Acc2.1302 = phi i32 [ %conv98, %for.body83 ], [ %Acc2.0.lcssa, %for.body83.preheader ]
  %scevgep380 = getelementptr i8, ptr %lsr.iv378, i32 -4
  %23 = load float, ptr %scevgep380, align 4, !tbaa !6
  %24 = load float, ptr %lsr.iv373, align 4, !tbaa !6
  %conv89 = sitofp i32 %Acc1.1303 to float
  %25 = tail call float @llvm.fmuladd.f32(float %23, float %24, float %conv89)
  %conv90 = fptosi float %25 to i32
  %26 = load float, ptr %lsr.iv378, align 4, !tbaa !6
  %conv97 = sitofp i32 %Acc2.1302 to float
  %27 = tail call float @llvm.fmuladd.f32(float %26, float %24, float %conv97)
  %conv98 = fptosi float %27 to i32
  %lsr.iv.next371 = add i32 %lsr.iv370, -1
  %scevgep374 = getelementptr i8, ptr %lsr.iv373, i32 4
  %scevgep379 = getelementptr i8, ptr %lsr.iv378, i32 4
  %exitcond320.not = icmp eq i32 %lsr.iv.next371, 0
  br i1 %exitcond320.not, label %for.end101.loopexit, label %for.body83, !llvm.loop !12

for.end101:                                       ; preds = %for.end101.loopexit, %for.end
  %Acc2.1.lcssa = phi i32 [ %Acc2.0.lcssa, %for.end ], [ %conv98, %for.end101.loopexit ]
  %Acc1.1.lcssa = phi i32 [ %Acc1.0.lcssa, %for.end ], [ %conv90, %for.end101.loopexit ]
  %conv102 = sitofp i32 %Acc1.1.lcssa to float
  %arrayidx104 = getelementptr inbounds nuw float, ptr %Out, i32 %mul
  store float %conv102, ptr %arrayidx104, align 4, !tbaa !6
  %conv105 = sitofp i32 %Acc2.1.lcssa to float
  %arrayidx108 = getelementptr inbounds nuw float, ptr %Out, i32 %add
  store float %conv105, ptr %arrayidx108, align 4, !tbaa !6
  %inc110 = add nuw nsw i32 %i.0308, 1
  %scevgep355 = getelementptr i8, ptr %lsr.iv354, i32 8
  %scevgep377 = getelementptr i8, ptr %lsr.iv376, i32 8
  %exitcond321.not = icmp eq i32 %inc110, %div
  br i1 %exitcond321.not, label %for.end111.loopexit, label %for.body, !llvm.loop !13

for.body83.preheader:                             ; preds = %for.end
  br label %for.body83

for.end101.loopexit:                              ; preds = %for.body83
  br label %for.end101

for.body6.preheader:                              ; preds = %for.body
  br label %for.body6

for.end.loopexit:                                 ; preds = %for.body6
  br label %for.end

; Exit blocks
for.end111.loopexit:                              ; preds = %for.end101
  br label %for.end111
