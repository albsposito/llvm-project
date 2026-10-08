define void @f(ptr noalias %a, ptr noalias %b, ptr noalias %c, i32 %n) {
entry:
  br label %vector.body
vector.body:
  %index = phi i32 [ 0, %entry ], [ %index.next, %vector.body ]
  %pb = getelementptr inbounds i8, ptr %b, i32 %index
  %pc = getelementptr inbounds i8, ptr %c, i32 %index
  %pa = getelementptr inbounds i8, ptr %a, i32 %index
  %vb = load <4 x i8>, ptr %pb, align 1
  %vc = load <4 x i8>, ptr %pc, align 1
  %s = add <4 x i8> %vb, %vc
  store <4 x i8> %s, ptr %pa, align 1
  %index.next = add nuw i32 %index, 4
  %done = icmp eq i32 %index.next, %n
  br i1 %done, label %exit, label %vector.body
exit:
  ret void
}
