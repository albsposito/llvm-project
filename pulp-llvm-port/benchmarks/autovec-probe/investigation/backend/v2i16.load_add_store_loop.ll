define void @f(ptr noalias %a, ptr noalias %b, ptr noalias %c, i32 %n) {
entry:
  br label %vector.body
vector.body:
  %index = phi i32 [ 0, %entry ], [ %index.next, %vector.body ]
  %pb = getelementptr inbounds i16, ptr %b, i32 %index
  %pc = getelementptr inbounds i16, ptr %c, i32 %index
  %pa = getelementptr inbounds i16, ptr %a, i32 %index
  %vb = load <2 x i16>, ptr %pb, align 2
  %vc = load <2 x i16>, ptr %pc, align 2
  %s = add <2 x i16> %vb, %vc
  store <2 x i16> %s, ptr %pa, align 2
  %index.next = add nuw i32 %index, 2
  %done = icmp eq i32 %index.next, %n
  br i1 %done, label %exit, label %vector.body
exit:
  ret void
}
