import sys,re
# For each lp.setup: header = label of next real instr, or the target of an immediately following 'j'.
lines=[l.rstrip('\n') for l in open(sys.argv[1])]
setups=[]
for i,l in enumerate(lines):
    m=re.match(r'\s+lp\.setupi?\s+(x[01]),\s*([^,]+),\s*(\S+)',l)
    if not m: continue
    end=m.group(3); hdr=None
    for l2 in lines[i+1:]:
        if re.match(r'^\.?L\w+:',l2) or re.match(r'^\s*(#|\.)',l2) or not l2.strip():
            continue
        mj=re.match(r'\s+j\s+(\S+)',l2)
        hdr = mj.group(1) if mj else ('after@%d'%i)
        break
    setups.append((i,end,hdr))
# map fallthrough headers to label: label preceding the next instruction
for k,(i,end,hdr) in enumerate(setups):
    if hdr.startswith('after@'):
        labs=[]
        for l2 in lines[i+1:]:
            ml=re.match(r'^(\.?L\w+):',l2)
            if ml: labs.append(ml.group(1)); continue
            if re.match(r'^\s*(#|\.)',l2) or not l2.strip() or re.match(r'\s+nop\b',l2): continue
            break
        setups[k]=(i,end,tuple(labs))
    else:
        setups[k]=(i,end,(hdr,))
groups={}
for i,end,labs in setups:
    for lab in labs:
        groups.setdefault(lab,set()).add(end)
# merge by header label
out=set()
for i,end,labs in setups:
    ends=set()
    for lab in labs: ends|=groups.get(lab,set())
    if len(ends)>1: out.add(' '.join(sorted(ends)))
for o in sorted(out): print('MULTI-END', o)
