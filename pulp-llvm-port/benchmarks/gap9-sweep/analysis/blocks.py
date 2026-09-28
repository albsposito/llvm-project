import sys,re
# group consecutive profile lines with equal exec count into blocks: count, ninstr, cycles, first pc, last pc
rows=[]
for l in open(sys.argv[1]):
    m=re.match(r'^\s*(\d+)\s+(\d+)\s+([0-9a-f]{6})\s+(.*)$',l)
    if m: rows.append((int(m.group(1)),int(m.group(2)),m.group(3),m.group(4)))
div=int(sys.argv[2]) if len(sys.argv)>2 else 5
blk=[]
def flush():
    if not blk: return
    c=blk[0][0]; cy=sum(r[1] for r in blk)
    print(f'{blk[0][2]}-{blk[-1][2]} exec/call={c/div:8.1f} n={len(blk):3d} instr/call={c*len(blk)/div:9.1f} cyc/call={cy/div:9.1f} cyc/exec={cy/c:6.2f}')
for r in rows:
    if blk and r[0]!=blk[-1][0]: flush(); blk=[]
    blk.append(r)
flush()
