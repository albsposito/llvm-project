import sys,re
# dump.py file N  -> print Nth IR dump (1-based) 
txt=open(sys.argv[1]).read().split('# *** IR Dump')
print('# *** IR Dump'+txt[int(sys.argv[2])])
