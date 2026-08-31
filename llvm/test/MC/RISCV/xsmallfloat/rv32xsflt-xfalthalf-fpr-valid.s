# F-register style aliases of the Xfalthalf extension.
# RUN: llvm-mc %s -triple=riscv32 -mattr=xfalthalf,+d,+zfh -riscv-no-aliases -show-encoding \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM %s

# CHECK-ASM: encoding: [0x07,0x9f,0x88,0x59]
flah f30, 1432(x17)
# CHECK-ASM: encoding: [0x27,0x16,0x9c,0x02]
fsah f9, 44(x24)

# CHECK-ASM: encoding: [0xd3,0x8d,0x08,0xe4]
fmv.x.ah x27, f17
# CHECK-ASM: encoding: [0xd3,0x1f,0x0b,0xe4]
fclass.ah x31, f22
# CHECK-ASM: encoding: [0xd3,0x81,0x0e,0xf4]
fmv.ah.x f3, x29
# CHECK-ASM: encoding: [0x53,0x06,0x67,0x40]
fcvt.s.ah f12, f14
# CHECK-ASM: encoding: [0x53,0x56,0x07,0x44]
fcvt.ah.s f12, f14
# CHECK-ASM: encoding: [0xd3,0x85,0x67,0x42]
fcvt.d.ah f11, f15
# CHECK-ASM: encoding: [0x53,0x10,0x11,0x44]
fcvt.ah.d f0, f2, rtz
# CHECK-ASM: encoding: [0xd3,0xa4,0x20,0x44]
fcvt.ah.h f9, f1, rdn
# CHECK-ASM: encoding: [0xd3,0x98,0x23,0x44]
fcvt.h.ah f17, f7, rtz
