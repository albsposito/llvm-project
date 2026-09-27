import random, sys
seed = int(sys.argv[1]); r = random.Random(seed)
V = ['acc', 's', 't']
def idx(d): return f"(({r.choice(['i%d'%j for j in range(d)] + V)} + {r.randint(0,63)}u) & 63u)"
def expr(d, e=0):
    c = r.randint(0,5) if e < 3 else r.randint(0,1)
    if c == 0: return f"A[{idx(d)}]"
    if c == 1: return f"B[{idx(d)}]"
    if c == 2: return f"({expr(d,e+1)} * {r.randint(1,7)}u)"
    if c == 3: return f"({expr(d,e+1)} ^ {r.choice(V)})"
    if c == 4: return f"({expr(d,e+1)} + {expr(d,e+1)})"
    return f"{r.randint(0,99)}u"
def stmt(d, depth):
    c = r.randint(0, 9)
    if c <= 2: return f"{r.choice(V)} += {expr(d)};"
    if c == 3: return f"out[{idx(d)}] = {expr(d)};"
    if c <= 5 and depth < 3: return loop(d, depth+1)
    if c == 6: return f"if ({expr(d)} & {r.choice([1,2,3,4,8])}u) {{ {block(d, depth)} }}"
    if c == 7: return f"if ({expr(d)} & 1u) {{ {block(d, depth)} }} else {{ {block(d, depth)} }}"
    if c == 8 and d > 0: return f"if (({expr(d)} & 7u) == 0) continue;"
    return f"t = (t << 1) | (s >> 31);"
def block(d, depth):
    return ' '.join(stmt(d, depth) for _ in range(r.randint(1,3)))
cnt = 0
def loop(d, depth):
    iv = f"i{depth-1}"
    bound = r.choice(['n', 'm', 'k', 'n', 'm', f'{r.randint(1,9)}u', '(n+1u)', '(m&3u)'])
    body = block(depth, depth)
    return f"for (unsigned {iv} = 0; {iv} < {bound}; {iv}++) {{ {body} }}"
fn = []
fn.append("#include <stdint.h>\n__attribute__((noinline)) unsigned kern(unsigned *A, unsigned *B, unsigned *out, unsigned n, unsigned m, unsigned k) {")
fn.append("unsigned acc = 1, s = 2, t = 3;")
for _ in range(r.randint(1,3)): fn.append(loop(0, 1))
fn.append("return acc ^ s ^ t;}")
print('\n'.join(fn))
