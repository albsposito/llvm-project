target datalayout = "e-m:e-p:32:32-i64:64-n32-S128"
target triple = "riscv32-unknown-unknown-elf"

define void @KerParMatMulDSP_Fix16(i32 %0, i1 %cmp55898.not, i1 %exitcond.not) #0 {
entry:
  br label %for.body23

for.cond53.preheader:                             ; preds = %for.body23
  br i1 %cmp55898.not, label %for.inc359, label %for.body56

for.body23:                                       ; preds = %for.body23, %entry
  br i1 %cmp55898.not, label %for.cond53.preheader, label %for.body23

for.body56:                                       ; preds = %if.end176, %for.cond53.preheader
  %Line.0899 = phi i32 [ %inc244, %if.end176 ], [ 0, %for.cond53.preheader ]
  br i1 %exitcond.not, label %if.end176, label %for.body69

for.body69:                                       ; preds = %for.body69, %for.body56
  br i1 %cmp55898.not, label %if.end176, label %for.body69

if.end176:                                        ; preds = %for.body69, %for.body56
  %inc244 = add i32 %Line.0899, 1
  %exitcond988.not = icmp eq i32 %inc244, %0
  br i1 %exitcond988.not, label %for.inc359, label %for.body56

for.inc359:                                       ; preds = %if.end176, %for.cond53.preheader
  ret void
}

attributes #0 = { "target-features"="+32bit,+c,+m,+xpulpv,+zfinx,+zicsr,+zmmul,-a,-b,-d,-e,-experimental-sdext,-experimental-sdtrig,-experimental-smctr,-experimental-ssctr,-experimental-svukte,-experimental-xqcia,-experimental-xqciac,-experimental-xqcicli,-experimental-xqcicm,-experimental-xqcics,-experimental-xqcicsr,-experimental-xqciint,-experimental-xqcilo,-experimental-xqcilsm,-experimental-xqcisls,-experimental-zalasr,-experimental-zicfilp,-experimental-zicfiss,-experimental-zvbc32e,-experimental-zvkgs,-f,-h,-relax,-sha,-shcounterenw,-shgatpa,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcsrind,-smdbltrp,-smepmp,-smmpm,-smnpm,-smrnmi,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssdbltrp,-ssnpm,-sspm,-ssqosid,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-supm,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-svvptc,-v,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xdma,-xfalthalf,-xfaltquarter,-xfauxalthalf,-xfauxaltquarter,-xfauxhalf,-xfauxquarter,-xfauxvecalthalf,-xfauxvecaltquarter,-xfauxvechalf,-xfauxvecquarter,-xfauxvecsingle,-xfexpauxvecalthalf,-xfexpauxvecaltquarter,-xfexpauxvechalf,-xfexpauxvecquarter,-xfquarter,-xfrep,-xfvecalthalf,-xfvecaltquarter,-xfvechalf,-xfvecquarter,-xfvecsingle,-xmempool,-xmipscmove,-xmipslsp,-xsfcease,-xsfvcp,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xssr,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-xwchc,-za128rs,-za64rs,-zaamo,-zabha,-zacas,-zalrsc,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zca,-zcb,-zcd,-zce,-zcf,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfbfmin,-zfh,-zfhmin,-zhinx,-zhinxmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zifencei,-zihintntl,-zihintpause,-zihpm,-zimop,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-ztso,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfbfmin,-zvfbfwma,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
