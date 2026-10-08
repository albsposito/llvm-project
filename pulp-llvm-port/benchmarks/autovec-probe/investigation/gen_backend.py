#!/usr/bin/env python3
"""Generate one small .ll per (operation, vector type) under backend/ for the
back-end coverage table of report.md (B156, question 4)."""
import os, sys

out = sys.argv[1] if len(sys.argv) > 1 else "backend"
os.makedirs(out, exist_ok=True)

INT = {"v2i16": ("<2 x i16>", "i16", 2, 2), "v4i8": ("<4 x i8>", "i8", 4, 1)}
FP = {"v2f16": ("<2 x half>", "half", 2, 2), "v2bf16": ("<2 x bfloat>", "bfloat", 2, 2)}
WIDE = {"v2i16": "<2 x i32>", "v4i8": "<4 x i32>"}
MANGLE = {"v2i16": "v2i16", "v4i8": "v4i8", "v2f16": "v2f16", "v2bf16": "v2bf16"}


def w(name, body):
    with open(os.path.join(out, name + ".ll"), "w") as f:
        f.write(body)


def splat(vt, n, v):
    return "<" + ", ".join(f"{vt} {v}" for _ in range(n)) + ">"


for tn, (VT, ET, N, AL) in INT.items():
    # binary ops, vector-vector
    for op in ["add", "sub", "mul", "and", "or", "xor", "shl", "lshr", "ashr",
               "sdiv", "udiv"]:
        w(f"{tn}.{op}", f"define {VT} @f({VT} %a, {VT} %b) {{\n  %r = {op} {VT} %a, %b\n  ret {VT} %r\n}}\n")
    # shift by splat constant, add splat scalar, mul by splat constant
    w(f"{tn}.ashr_const", f"define {VT} @f({VT} %a) {{\n  %r = ashr {VT} %a, {splat(ET, N, 3)}\n  ret {VT} %r\n}}\n")
    w(f"{tn}.mul_const", f"define {VT} @f({VT} %a) {{\n  %r = mul {VT} %a, {splat(ET, N, 7)}\n  ret {VT} %r\n}}\n")
    w(f"{tn}.add_splat_scalar", f"""define {VT} @f({VT} %a, {ET} %s) {{
  %i = insertelement {VT} poison, {ET} %s, i32 0
  %sp = shufflevector {VT} %i, {VT} poison, <{N} x i32> zeroinitializer
  %r = add {VT} %a, %sp
  ret {VT} %r
}}
""")
    w(f"{tn}.splat", f"""define {VT} @f({ET} %s) {{
  %i = insertelement {VT} poison, {ET} %s, i32 0
  %sp = shufflevector {VT} %i, {VT} poison, <{N} x i32> zeroinitializer
  ret {VT} %sp
}}
""")
    w(f"{tn}.splat_const", f"define {VT} @f() {{\n  ret {VT} {splat(ET, N, 5)}\n}}\n")
    w(f"{tn}.const_nonsplat", f"define {VT} @f() {{\n  ret {VT} <" + ", ".join(f"{ET} {i+1}" for i in range(N)) + ">\n}\n")
    for op in ["smin", "smax", "umin", "umax", "sadd.sat", "ssub.sat", "uadd.sat", "usub.sat"]:
        w(f"{tn}.{op.replace('.', '_')}", f"""declare {VT} @llvm.{op}.{MANGLE[tn]}({VT}, {VT})
define {VT} @f({VT} %a, {VT} %b) {{
  %r = call {VT} @llvm.{op}.{MANGLE[tn]}({VT} %a, {VT} %b)
  ret {VT} %r
}}
""")
    w(f"{tn}.abs", f"""declare {VT} @llvm.abs.{MANGLE[tn]}({VT}, i1)
define {VT} @f({VT} %a) {{
  %r = call {VT} @llvm.abs.{MANGLE[tn]}({VT} %a, i1 false)
  ret {VT} %r
}}
""")
    # compare + select
    for cc in ["eq", "slt", "ugt"]:
        w(f"{tn}.icmp_{cc}_sext", f"define {VT} @f({VT} %a, {VT} %b) {{\n  %c = icmp {cc} {VT} %a, %b\n  %r = sext <{N} x i1> %c to {VT}\n  ret {VT} %r\n}}\n")
    w(f"{tn}.icmp_select", f"""define {VT} @f({VT} %a, {VT} %b, {VT} %x, {VT} %y) {{
  %c = icmp slt {VT} %a, %b
  %r = select <{N} x i1> %c, {VT} %x, {VT} %y
  ret {VT} %r
}}
""")
    w(f"{tn}.icmp_select_minpat", f"""define {VT} @f({VT} %a, {VT} %b) {{
  %c = icmp slt {VT} %a, %b
  %r = select <{N} x i1> %c, {VT} %a, {VT} %b
  ret {VT} %r
}}
""")
    w(f"{tn}.select_scalar_cond", f"define {VT} @f(i1 %c, {VT} %x, {VT} %y) {{\n  %r = select i1 %c, {VT} %x, {VT} %y\n  ret {VT} %r\n}}\n")
    # memory
    for al, an in [(4, "aligned4"), (AL, "natural"), (1, "align1")]:
        w(f"{tn}.load_{an}", f"define {VT} @f(ptr %p) {{\n  %r = load {VT}, ptr %p, align {al}\n  ret {VT} %r\n}}\n")
        w(f"{tn}.store_{an}", f"define void @f(ptr %p, {VT} %v) {{\n  store {VT} %v, ptr %p, align {al}\n  ret void\n}}\n")
    w(f"{tn}.load_add_store_loop", f"""define void @f(ptr noalias %a, ptr noalias %b, ptr noalias %c, i32 %n) {{
entry:
  br label %vector.body
vector.body:
  %index = phi i32 [ 0, %entry ], [ %index.next, %vector.body ]
  %pb = getelementptr inbounds {ET}, ptr %b, i32 %index
  %pc = getelementptr inbounds {ET}, ptr %c, i32 %index
  %pa = getelementptr inbounds {ET}, ptr %a, i32 %index
  %vb = load {VT}, ptr %pb, align {AL}
  %vc = load {VT}, ptr %pc, align {AL}
  %s = add {VT} %vb, %vc
  store {VT} %s, ptr %pa, align {AL}
  %index.next = add nuw i32 %index, {N}
  %done = icmp eq i32 %index.next, %n
  br i1 %done, label %exit, label %vector.body
exit:
  ret void
}}
""")
    w(f"{tn}.masked_load", f"""declare {VT} @llvm.masked.load.{MANGLE[tn]}.p0(ptr, i32, <{N} x i1>, {VT})
define {VT} @f(ptr %p, <{N} x i1> %m) {{
  %r = call {VT} @llvm.masked.load.{MANGLE[tn]}.p0(ptr %p, i32 {AL}, <{N} x i1> %m, {VT} poison)
  ret {VT} %r
}}
""")
    w(f"{tn}.masked_store", f"""declare void @llvm.masked.store.{MANGLE[tn]}.p0({VT}, ptr, i32, <{N} x i1>)
define void @f(ptr %p, {VT} %v, <{N} x i1> %m) {{
  call void @llvm.masked.store.{MANGLE[tn]}.p0({VT} %v, ptr %p, i32 {AL}, <{N} x i1> %m)
  ret void
}}
""")
    # element access
    w(f"{tn}.extract0", f"define {ET} @f({VT} %a) {{\n  %r = extractelement {VT} %a, i32 0\n  ret {ET} %r\n}}\n")
    w(f"{tn}.extract_last_sext", f"define i32 @f({VT} %a) {{\n  %e = extractelement {VT} %a, i32 {N-1}\n  %r = sext {ET} %e to i32\n  ret i32 %r\n}}\n")
    w(f"{tn}.extract_var", f"define {ET} @f({VT} %a, i32 %i) {{\n  %r = extractelement {VT} %a, i32 %i\n  ret {ET} %r\n}}\n")
    w(f"{tn}.insert1", f"define {VT} @f({VT} %a, {ET} %s) {{\n  %r = insertelement {VT} %a, {ET} %s, i32 1\n  ret {VT} %r\n}}\n")
    w(f"{tn}.insert_var", f"define {VT} @f({VT} %a, {ET} %s, i32 %i) {{\n  %r = insertelement {VT} %a, {ET} %s, i32 %i\n  ret {VT} %r\n}}\n")
    w(f"{tn}.build_vector", f"define {VT} @f(" + ", ".join(f"{ET} %e{i}" for i in range(N)) + ") {\n" +
      "".join(f"  %v{i} = insertelement {VT} {'poison' if i == 0 else '%v' + str(i-1)}, {ET} %e{i}, i32 {i}\n" for i in range(N)) +
      f"  ret {VT} %v{N-1}\n}}\n")
    # shuffles
    rev = ", ".join(f"i32 {N-1-i}" for i in range(N))
    w(f"{tn}.shuffle_reverse", f"define {VT} @f({VT} %a) {{\n  %r = shufflevector {VT} %a, {VT} poison, <{N} x i32> <{rev}>\n  ret {VT} %r\n}}\n")
    il = ", ".join(f"i32 {x}" for x in ([0, 2] if N == 2 else [0, 4, 1, 5]))
    w(f"{tn}.shuffle_interleave_lo", f"define {VT} @f({VT} %a, {VT} %b) {{\n  %r = shufflevector {VT} %a, {VT} %b, <{N} x i32> <{il}>\n  ret {VT} %r\n}}\n")
    de = ", ".join(f"i32 {x}" for x in ([1, 3] if N == 2 else [1, 3, 5, 7]))
    w(f"{tn}.shuffle_deinterleave_odd", f"define {VT} @f({VT} %a, {VT} %b) {{\n  %r = shufflevector {VT} %a, {VT} %b, <{N} x i32> <{de}>\n  ret {VT} %r\n}}\n")
    # interleave group as the loop vectorizer emits it: wide load of 2*N, two strided shuffles
    WV = f"<{2*N} x {ET}>"
    ev = ", ".join(f"i32 {2*i}" for i in range(N)); od = ", ".join(f"i32 {2*i+1}" for i in range(N))
    w(f"{tn}.interleaved_load_factor2", f"""define {VT} @f(ptr %p) {{
  %w = load {WV}, ptr %p, align {AL}
  %e = shufflevector {WV} %w, {WV} poison, <{N} x i32> <{ev}>
  %o = shufflevector {WV} %w, {WV} poison, <{N} x i32> <{od}>
  %r = add {VT} %e, %o
  ret {VT} %r
}}
""")
    # reductions
    for red in ["add", "smax", "smin", "umax", "umin", "and", "or", "xor", "mul"]:
        w(f"{tn}.reduce_{red}", f"""declare {ET} @llvm.vector.reduce.{red}.{MANGLE[tn]}({VT})
define {ET} @f({VT} %a) {{
  %r = call {ET} @llvm.vector.reduce.{red}.{MANGLE[tn]}({VT} %a)
  ret {ET} %r
}}
""")
    # widening
    W = WIDE[tn]
    wm = "v2i32" if N == 2 else "v4i32"
    w(f"{tn}.sext_to_i32", f"define {W} @f({VT} %a) {{\n  %r = sext {VT} %a to {W}\n  ret {W} %r\n}}\n")
    w(f"{tn}.zext_to_i32", f"define {W} @f({VT} %a) {{\n  %r = zext {VT} %a to {W}\n  ret {W} %r\n}}\n")
    w(f"{tn}.trunc_from_i32", f"define {VT} @f({W} %a) {{\n  %r = trunc {W} %a to {VT}\n  ret {VT} %r\n}}\n")
    for sx, nm in [("sext", "s"), ("zext", "u")]:
        w(f"{tn}.dot_{nm}_reduce", f"""declare i32 @llvm.vector.reduce.add.{wm}({W})
define i32 @f({VT} %a, {VT} %b) {{
  %ea = {sx} {VT} %a to {W}
  %eb = {sx} {VT} %b to {W}
  %m = mul nsw {W} %ea, %eb
  %r = call i32 @llvm.vector.reduce.add.{wm}({W} %m)
  ret i32 %r
}}
""")
        w(f"{tn}.dot_{nm}_reduce_acc", f"""declare i32 @llvm.vector.reduce.add.{wm}({W})
define i32 @f({VT} %a, {VT} %b, i32 %acc) {{
  %ea = {sx} {VT} %a to {W}
  %eb = {sx} {VT} %b to {W}
  %m = mul nsw {W} %ea, %eb
  %r = call i32 @llvm.vector.reduce.add.{wm}({W} %m)
  %s = add i32 %r, %acc
  ret i32 %s
}}
""")
    w(f"{tn}.sum_sext_reduce", f"""declare i32 @llvm.vector.reduce.add.{wm}({W})
define i32 @f({VT} %a) {{
  %ea = sext {VT} %a to {W}
  %r = call i32 @llvm.vector.reduce.add.{wm}({W} %ea)
  ret i32 %r
}}
""")
    # the vector-phi accumulator shape the loop vectorizer emits for "int s += b[i]*c[i]"
    w(f"{tn}.dot_s_loop_vecphi", f"""declare i32 @llvm.vector.reduce.add.{wm}({W})
define i32 @f(ptr %b, ptr %c, i32 %n) {{
entry:
  br label %vector.body
vector.body:
  %index = phi i32 [ 0, %entry ], [ %index.next, %vector.body ]
  %acc = phi {W} [ zeroinitializer, %entry ], [ %acc.next, %vector.body ]
  %pb = getelementptr inbounds {ET}, ptr %b, i32 %index
  %pc = getelementptr inbounds {ET}, ptr %c, i32 %index
  %vb = load {VT}, ptr %pb, align {AL}
  %vc = load {VT}, ptr %pc, align {AL}
  %eb = sext {VT} %vb to {W}
  %ec = sext {VT} %vc to {W}
  %m = mul nsw {W} %eb, %ec
  %acc.next = add {W} %acc, %m
  %index.next = add nuw i32 %index, {N}
  %done = icmp eq i32 %index.next, %n
  br i1 %done, label %exit, label %vector.body
exit:
  %r = call i32 @llvm.vector.reduce.add.{wm}({W} %acc.next)
  ret i32 %r
}}
""")
    # same loop written with a scalar accumulator (in-loop reduction, what
    # preferInLoopReduction would make the vectorizer emit)
    w(f"{tn}.dot_s_loop_inloop", f"""declare i32 @llvm.vector.reduce.add.{wm}({W})
define i32 @f(ptr %b, ptr %c, i32 %n) {{
entry:
  br label %vector.body
vector.body:
  %index = phi i32 [ 0, %entry ], [ %index.next, %vector.body ]
  %acc = phi i32 [ 0, %entry ], [ %acc.next, %vector.body ]
  %pb = getelementptr inbounds {ET}, ptr %b, i32 %index
  %pc = getelementptr inbounds {ET}, ptr %c, i32 %index
  %vb = load {VT}, ptr %pb, align {AL}
  %vc = load {VT}, ptr %pc, align {AL}
  %eb = sext {VT} %vb to {W}
  %ec = sext {VT} %vc to {W}
  %m = mul nsw {W} %eb, %ec
  %red = call i32 @llvm.vector.reduce.add.{wm}({W} %m)
  %acc.next = add i32 %red, %acc
  %index.next = add nuw i32 %index, {N}
  %done = icmp eq i32 %index.next, %n
  br i1 %done, label %exit, label %vector.body
exit:
  ret i32 %acc.next
}}
""")

for tn, (VT, ET, N, AL) in FP.items():
    for op in ["fadd", "fsub", "fmul", "fdiv"]:
        w(f"{tn}.{op}", f"define {VT} @f({VT} %a, {VT} %b) {{\n  %r = {op} {VT} %a, %b\n  ret {VT} %r\n}}\n")
    w(f"{tn}.fneg", f"define {VT} @f({VT} %a) {{\n  %r = fneg {VT} %a\n  ret {VT} %r\n}}\n")
    for op in ["minnum", "maxnum"]:
        w(f"{tn}.{op}", f"""declare {VT} @llvm.{op}.{MANGLE[tn]}({VT}, {VT})
define {VT} @f({VT} %a, {VT} %b) {{
  %r = call {VT} @llvm.{op}.{MANGLE[tn]}({VT} %a, {VT} %b)
  ret {VT} %r
}}
""")
    for op in ["fabs", "sqrt"]:
        w(f"{tn}.{op}", f"""declare {VT} @llvm.{op}.{MANGLE[tn]}({VT})
define {VT} @f({VT} %a) {{
  %r = call {VT} @llvm.{op}.{MANGLE[tn]}({VT} %a)
  ret {VT} %r
}}
""")
    w(f"{tn}.fmuladd", f"""declare {VT} @llvm.fmuladd.{MANGLE[tn]}({VT}, {VT}, {VT})
define {VT} @f({VT} %a, {VT} %b, {VT} %c) {{
  %r = call {VT} @llvm.fmuladd.{MANGLE[tn]}({VT} %a, {VT} %b, {VT} %c)
  ret {VT} %r
}}
""")
    w(f"{tn}.load", f"define {VT} @f(ptr %p) {{\n  %r = load {VT}, ptr %p, align 2\n  ret {VT} %r\n}}\n")
    w(f"{tn}.store", f"define void @f(ptr %p, {VT} %v) {{\n  store {VT} %v, ptr %p, align 2\n  ret void\n}}\n")
    w(f"{tn}.load_fmul_store", f"""define void @f(ptr %a, ptr %b, ptr %c) {{
  %vb = load {VT}, ptr %b, align 2
  %vc = load {VT}, ptr %c, align 2
  %m = fmul {VT} %vb, %vc
  store {VT} %m, ptr %a, align 2
  ret void
}}
""")
    w(f"{tn}.fcmp_olt_select", f"""define {VT} @f({VT} %a, {VT} %b) {{
  %c = fcmp olt {VT} %a, %b
  %r = select <2 x i1> %c, {VT} %a, {VT} %b
  ret {VT} %r
}}
""")
    w(f"{tn}.extract1", f"define {ET} @f({VT} %a) {{\n  %r = extractelement {VT} %a, i32 1\n  ret {ET} %r\n}}\n")
    w(f"{tn}.insert1", f"define {VT} @f({VT} %a, {ET} %s) {{\n  %r = insertelement {VT} %a, {ET} %s, i32 1\n  ret {VT} %r\n}}\n")
    w(f"{tn}.splat", f"""define {VT} @f({ET} %s) {{
  %i = insertelement {VT} poison, {ET} %s, i32 0
  %sp = shufflevector {VT} %i, {VT} poison, <2 x i32> zeroinitializer
  ret {VT} %sp
}}
""")
    w(f"{tn}.reduce_fadd_fast", f"""declare {ET} @llvm.vector.reduce.fadd.{MANGLE[tn]}({ET}, {VT})
define {ET} @f({VT} %a) {{
  %r = call reassoc {ET} @llvm.vector.reduce.fadd.{MANGLE[tn]}({ET} 0.0, {VT} %a)
  ret {ET} %r
}}
""")
    w(f"{tn}.sitofp_v2i16", f"define {VT} @f(<2 x i16> %a) {{\n  %r = sitofp <2 x i16> %a to {VT}\n  ret {VT} %r\n}}\n")
    w(f"{tn}.fptosi_v2i16", f"define <2 x i16> @f({VT} %a) {{\n  %r = fptosi {VT} %a to <2 x i16>\n  ret <2 x i16> %r\n}}\n")
print("generated", len(os.listdir(out)), "files in", out)
