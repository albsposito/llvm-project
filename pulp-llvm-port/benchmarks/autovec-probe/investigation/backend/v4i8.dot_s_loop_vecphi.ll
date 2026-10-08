declare i32 @llvm.vector.reduce.add.v4i32(<4 x i32>)
define i32 @f(ptr %b, ptr %c, i32 %n) {
entry:
  br label %vector.body
vector.body:
  %index = phi i32 [ 0, %entry ], [ %index.next, %vector.body ]
  %acc = phi <4 x i32> [ zeroinitializer, %entry ], [ %acc.next, %vector.body ]
  %pb = getelementptr inbounds i8, ptr %b, i32 %index
  %pc = getelementptr inbounds i8, ptr %c, i32 %index
  %vb = load <4 x i8>, ptr %pb, align 1
  %vc = load <4 x i8>, ptr %pc, align 1
  %eb = sext <4 x i8> %vb to <4 x i32>
  %ec = sext <4 x i8> %vc to <4 x i32>
  %m = mul nsw <4 x i32> %eb, %ec
  %acc.next = add <4 x i32> %acc, %m
  %index.next = add nuw i32 %index, 4
  %done = icmp eq i32 %index.next, %n
  br i1 %done, label %exit, label %vector.body
exit:
  %r = call i32 @llvm.vector.reduce.add.v4i32(<4 x i32> %acc.next)
  ret i32 %r
}
