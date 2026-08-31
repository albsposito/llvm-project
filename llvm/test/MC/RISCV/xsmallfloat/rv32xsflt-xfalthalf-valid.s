# Scalar fp16alt (bf16) instructions - Xfalthalf.
# The computational, comparison and word-conversion instructions use the
# Zfinx/Zhinx-style GPR operands and carry the fp16alt encodings verified
# against GAP GCC (fp16 encodings with funct3/rm = 0b101, or funct3 | 0b100
# for sign-injection/min/max/compares; ah-source conversions use rs2 = 6).
# RUN: llvm-mc %s -triple=riscv32 -mattr=xfalthalf,+zfinx,+zhinx -riscv-no-aliases -show-encoding \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM %s


# CHECK-ASM: encoding: [0x43,0x55,0xb5,0x64]
fmadd.ah x10, x10, x11, x12
# CHECK-ASM: encoding: [0x47,0x55,0xb5,0x64]
fmsub.ah x10, x10, x11, x12
# CHECK-ASM: encoding: [0x4b,0x55,0xb5,0x64]
fnmsub.ah x10, x10, x11, x12
# CHECK-ASM: encoding: [0x4f,0x55,0xb5,0x64]
fnmadd.ah x10, x10, x11, x12
# CHECK-ASM: encoding: [0x53,0x55,0xb5,0x04]
fadd.ah x10, x10, x11
# CHECK-ASM: encoding: [0x53,0x55,0xb5,0x0c]
fsub.ah x10, x10, x11
# CHECK-ASM: encoding: [0x53,0x55,0xb5,0x14]
fmul.ah x10, x10, x11
# CHECK-ASM: encoding: [0x53,0x55,0xb5,0x1c]
fdiv.ah x10, x10, x11
# CHECK-ASM: encoding: [0x53,0x45,0xa5,0x24]
fsgnj.ah x10, x10, x10
# CHECK-ASM: encoding: [0x53,0x55,0xa5,0x24]
fsgnjn.ah x10, x10, x10
# CHECK-ASM: encoding: [0x53,0x65,0xa5,0x24]
fsgnjx.ah x10, x10, x10
# CHECK-ASM: encoding: [0x53,0xc5,0xa5,0x2c]
fmin.ah x10, x11, x10
# CHECK-ASM: encoding: [0x53,0xd5,0xa5,0x2c]
fmax.ah x10, x11, x10
# CHECK-ASM: encoding: [0x53,0x65,0xb5,0xa4]
feq.ah x10, x10, x11
# CHECK-ASM: encoding: [0x53,0x55,0xb5,0xa4]
flt.ah x10, x10, x11
# CHECK-ASM: encoding: [0x53,0x45,0xb5,0xa4]
fle.ah x10, x10, x11
# CHECK-ASM: encoding: [0x53,0x55,0x05,0xc4]
fcvt.w.ah x10, x10
# CHECK-ASM: encoding: [0x53,0x55,0x15,0xc4]
fcvt.wu.ah x10, x10
# CHECK-ASM: encoding: [0x53,0x55,0x05,0xd4]
fcvt.ah.w x10, x10
# CHECK-ASM: encoding: [0x53,0x55,0x15,0xd4]
fcvt.ah.wu x10, x10
# CHECK-ASM: encoding: [0x53,0x05,0x65,0x40]
fcvt.s.ah x10, x10
# CHECK-ASM: encoding: [0x53,0x55,0x05,0x44]
fcvt.ah.s x10, x10

# fp16alt sign manipulation pseudo instructions
# CHECK-ASM: encoding: [0x53,0xc5,0xb5,0x24]
fmv.ah x10, x11
# CHECK-ASM: encoding: [0x53,0xe5,0xb5,0x24]
fabs.ah x10, x11
# CHECK-ASM: encoding: [0x53,0xd5,0xb5,0x24]
fneg.ah x10, x11
