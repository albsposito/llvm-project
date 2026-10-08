declare i32 @llvm.vector.reduce.add.v2i32(<2 x i32>)
define i32 @f(ptr %b, ptr %c, i32 %n) {
entry:
  br label %vector.body
vector.body:
  %index = phi i32 [ 0, %entry ], [ %index.next, %vector.body ]
  %acc = phi <2 x i32> [ zeroinitializer, %entry ], [ %acc.next, %vector.body ]
  %pb = getelementptr inbounds i16, ptr %b, i32 %index
  %pc = getelementptr inbounds i16, ptr %c, i32 %index
  %vb = load <2 x i16>, ptr %pb, align 2
  %vc = load <2 x i16>, ptr %pc, align 2
  %eb = sext <2 x i16> %vb to <2 x i32>
  %ec = sext <2 x i16> %vc to <2 x i32>
  %m = mul nsw <2 x i32> %eb, %ec
  %acc.next = add <2 x i32> %acc, %m
  %index.next = add nuw i32 %index, 2
  %done = icmp eq i32 %index.next, %n
  br i1 %done, label %exit, label %vector.body
exit:
  %r = call i32 @llvm.vector.reduce.add.v2i32(<2 x i32> %acc.next)
  ret i32 %r
}
