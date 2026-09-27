/* ri5ky_testbench: 1 MB RAM at 0x0, boot address 0x80, MMIO at 0x10000000. */
OUTPUT_ARCH(riscv)
ENTRY(_start)

MEMORY
{
  RAM (rwx) : ORIGIN = 0x00000000, LENGTH = 1M
}

STACK_SIZE = DEFINED(STACK_SIZE) ? STACK_SIZE : 0x10000;

SECTIONS
{
  /* boot address 0x80 (RTL BOOT_ADDR); explicit VMA because '. =' is ignored
     for sections assigned to a MEMORY region by older GNU ld */
  .text 0x80 : {
    KEEP(*(.text.init))
    *(.text .text.* .gnu.linkonce.t.*)
  } > RAM
  .rodata : ALIGN(4) {
    *(.rodata .rodata.* .gnu.linkonce.r.*)
    *(.srodata .srodata.*)
  } > RAM
  .data : ALIGN(4) {
    *(.data .data.* .gnu.linkonce.d.*)
    __global_pointer$ = . + 0x800;
    *(.sdata .sdata.* .gnu.linkonce.s.*)
  } > RAM
  .bss (NOLOAD) : ALIGN(4) {
    __bss_start = .;
    *(.sbss .sbss.* .gnu.linkonce.sb.*)
    *(.bss .bss.* .gnu.linkonce.b.*)
    *(COMMON)
    . = ALIGN(4);
    __bss_end = .;
  } > RAM
  .stack (NOLOAD) : ALIGN(16) {
    . += STACK_SIZE;
    __stack_top = .;
  } > RAM
  _end = .;
  /DISCARD/ : { *(.comment) *(.riscv.attributes) *(.note*) *(.eh_frame*) }
}
