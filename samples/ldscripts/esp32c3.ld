/* [ESP32C3_MEMREGION_IROM]    = { 0x40000000,  0x60000 },
[ESP32C3_MEMREGION_DROM]    = { 0x3ff00000,  0x20000 },
[ESP32C3_MEMREGION_DRAM]    = { 0x3fc80000,  0x60000 }, */
/* Merge SRAM0 and SRAM1 into a single entry */
/* [ESP32C3_MEMREGION_IRAM]    = { 0x4037c000,  0x60000 + ESP32C3_INTERNAL_SRAM0_SIZE },
[ESP32C3_MEMREGION_RTCFAST] = { 0x50000000,   0x2000 },
[ESP32C3_MEMREGION_DCACHE]  = { 0x3c000000, 0x800000 },
[ESP32C3_MEMREGION_ICACHE]  = { 0x42000000, 0x800000 }, */

ICACHE_SIZE = 0x4000;
 /* Skip possible ICACHE area */
IRAM_START_ADDRESS = 0x4037C000 + ICACHE_SIZE;
IRAM_LEN = 0x64000 - ICACHE_SIZE;

DRAM_START_ADDRESS = 0x3FC80000;
DRAM_LEN = 0x60000;/* 0x40000; */

CPU_FREQUENCY = 20000000;
UART0_BAUD = 115200;

UART0_CLKDIV_REG = 0x60000014;
UART0_CLKDIV_VAL = CPU_FREQUENCY / UART0_BAUD;
UART0_STATUS = 0x6000001C;
UART0_TX_ADDR = 0x60000000;

MEMORY
{
  irom_seg  (RX) : org = 0x40000000, len = 0x60000
  drom_seg  (R) : org = 0x3ff00000, len = 0x20000
  iram_seg  (RX) : org = IRAM_START_ADDRESS, len = IRAM_LEN
  dram_seg  (RW) : org = DRAM_START_ADDRESS, len = DRAM_LEN
}

__stack = ORIGIN(dram_seg) + LENGTH(dram_seg) - 4;
__MIN_STACK_SIZE = 0x1000;

/* Default entry point */
ENTRY(_start)
SECTIONS
{
  .irom.text    :
  {
    /* Place the _start function at the beginning of IRAM.
     * Just in case some versions of QEMU ignore the entry address when loading the ELF file. */
    KEEP(*(.text._start))

    KEEP (*(SORT_NONE(.init)))
    *(.text .stub .text.* .gnu.linkonce.t.*)
    /* .gnu.warning sections are handled specially by elf32.em.  */
    *(.gnu.warning)
    KEEP (*(SORT_NONE(.fini)))
    PROVIDE (__etext = .);
    PROVIDE (_etext = .);
    PROVIDE (etext = .);
  } > irom_seg

  .iram.text :
  {
    _iram_start = ABSOLUTE(.);
    /* Vectors go to start of IRAM */
    ASSERT(ABSOLUTE(.) % 0x100 == 0, "vector address must be 256 byte aligned");
    KEEP(*(.exception_vectors_table.text));
    KEEP(*(.exception_vectors.text));

    _iram_end = .;

  } > iram_seg

  .rodata    :
  {
    *(.rodata .rodata.* .gnu.linkonce.r.*)
    *(.rodata1)
    *(.sdata2 .sdata2.* .gnu.linkonce.s2.*)
    *(.sbss2 .sbss2.* .gnu.linkonce.sb2.*)
    . = ALIGN(4);
    /* __cpu_frequency = .;
    LONG(CPU_FREQUENCY);
    __uart0_clkdiv_reg = .;
    LONG(UART0_CLKDIV_REG);
    __uart0_clkdiv_val = .;
    LONG(UART0_CLKDIV_VAL);
    __uart0_tx_addr = .;
    LONG(UART0_TX_ADDR);
    __uart0_status = .;
    LONG(UART0_STATUS); */
  } > dram_seg

  .preinit_array    :
  {
    PROVIDE_HIDDEN (__preinit_array_start = .);
    KEEP (*(.preinit_array))
    PROVIDE_HIDDEN (__preinit_array_end = .);
  } > dram_seg
  .init_array    :
  {
    PROVIDE_HIDDEN (__init_array_start = .);
    KEEP (*(SORT_BY_INIT_PRIORITY(.init_array.*) SORT_BY_INIT_PRIORITY(.ctors.*)))
    KEEP (*(.init_array EXCLUDE_FILE (*crtbegin.o *crtbegin?.o *crtend.o *crtend?.o ) .ctors))
    PROVIDE_HIDDEN (__init_array_end = .);
  } > dram_seg
  .fini_array    :
  {
    PROVIDE_HIDDEN (__fini_array_start = .);
    KEEP (*(SORT_BY_INIT_PRIORITY(.fini_array.*) SORT_BY_INIT_PRIORITY(.dtors.*)))
    KEEP (*(.fini_array EXCLUDE_FILE (*crtbegin.o *crtbegin?.o *crtend.o *crtend?.o ) .dtors))
    PROVIDE_HIDDEN (__fini_array_end = .);
  } > dram_seg
  .ctors          :
  {
    /* gcc uses crtbegin.o to find the start of
       the constructors, so we make sure it is
       first.  Because this is a wildcard, it
       doesn't matter if the user does not
       actually link against crtbegin.o; the
       linker won't look for a file to match a
       wildcard.  The wildcard also means that it
       doesn't matter which directory crtbegin.o
       is in.  */
    KEEP (*crtbegin.o(.ctors))
    KEEP (*crtbegin?.o(.ctors))
    /* We don't want to include the .ctor section from
       the crtend.o file until after the sorted ctors.
       The .ctor section from the crtend file contains the
       end of ctors marker and it must be last */
    KEEP (*(EXCLUDE_FILE (*crtend.o *crtend?.o ) .ctors))
    KEEP (*(SORT(.ctors.*)))
    KEEP (*(.ctors))
  } > dram_seg
  .dtors          :
  {
    KEEP (*crtbegin.o(.dtors))
    KEEP (*crtbegin?.o(.dtors))
    KEEP (*(EXCLUDE_FILE (*crtend.o *crtend?.o ) .dtors))
    KEEP (*(SORT(.dtors.*)))
    KEEP (*(.dtors))
  } > dram_seg

  /**
   * This section is required to skip .iram0.text area because iram0_0_seg and
   * dram0_0_seg reflect the same address space on different buses.
   */
  .dram0.dummy (NOLOAD):
  {
    /* Add a gap only in case we have separate iram/dram regions */
    /* . += ORIGIN(iram_seg) == ORIGIN(dram_seg) ? 0 : _iram_end - _iram_start; */
  } > dram_seg

  .data          :
  {
    _data_start = .;
    *(.data .data.* .gnu.linkonce.d.*)
    SORT(CONSTRUCTORS)
  } > dram_seg
  .data1          : { *(.data1) } > dram_seg

  /* .eh_frame_hdr   : { *(.eh_frame_hdr) *(.eh_frame_entry .eh_frame_entry.*) } > dram_seg
  .eh_frame       : { KEEP (*(.eh_frame)) *(.eh_frame.*) } > dram_seg */

  .eh_frame_hdr :
  {
    . = ALIGN(4);
    __eh_frame_hdr = ABSOLUTE(.);
    __eh_frame_hdr_start = ABSOLUTE(.);

    KEEP (*(.eh_frame_hdr)) *(.eh_frame_hdr) *(.eh_frame_entry .eh_frame_entry.*)

    __eh_frame_hdr_end = ABSOLUTE(.);

    . = ALIGN(ALIGNOF(.eh_frame));
  } > dram_seg

  .eh_frame :
  {
    . = ALIGN(4);
    __eh_frame = ABSOLUTE(.);
    __eh_frame_start = ABSOLUTE(.);

    KEEP (*(.eh_frame)) *(.eh_frame.*)
    /**
     * As we are not linking with crtend.o, which includes the CIE terminator
     * (see __FRAME_END__ in libgcc sources), it is manually provided here.
     */
    LONG(0);

    __eh_frame_end = ABSOLUTE(.);

    /* . = ALIGN(ALIGNOF(.flash.tdata)); */
  } > dram_seg

  /* We want the small data sections together, so single-instruction offsets
     can access them all, and initialized data all before uninitialized, so
     we can shorten the on-disk segment size.  */
  .sdata     : 
  {
    PROVIDE(__global_pointer$ = . + 0x800);
    *(.srodata.cst16) *(.srodata.cst8) *(.srodata.cst4) *(.srodata.cst2) *(.srodata .srodata.*)
    *(.sdata .sdata.* .gnu.linkonce.s.*)
    _edata = .; /*PROVIDE (edata = .);*/
    . = .;
  } > dram_seg

  .bss    (NOLOAD)  :
  {
    __bss_start = .;
    *(.dynsbss)
    *(.sbss .sbss.* .gnu.linkonce.sb.*)
    *(.scommon)
    *(.dynbss)
    *(.bss .bss.* .gnu.linkonce.b.*)
    *(COMMON)
    /* Align here to ensure that the .bss section occupies space up to
      _end.  Align after .bss to ensure correct alignment even if the
      .bss section disappears because there are no input sections.
      FIXME: Why do we need it? When there is no .bss section, we do not
      pad the .data section.  */
    . = ALIGN(. != 0 ? 32 / 8 : 1);

    . = ALIGN(32 / 8);
    . = ALIGN(32 / 8);
    __bss_end = .;/* PROVIDE (end = .);*/
  } > dram_seg

  .tdata :
  {
    _tdata_begin = .;
    *(.tdata .tdata.* .gnu.linkonce.td.*)
    _tdata_end = .;
  } > dram_seg

  .tbss (NOLOAD) :
  {
    _tbss_start = .;
    *(.tbss .tbss.* .gnu.linkonce.tb.*)
    *(.tcommon .tcommon.*)
    _tbss_end = .;
    /* put _end after data sections, it will be used by _sbrk to alloc memory */
    _end = .;
  } > dram_seg

  /* Check if data + heap + stack exceeds RAM limit */
  ASSERT(_end <= __stack - __MIN_STACK_SIZE, "region DRAM overflowed by .data and .bss sections")

  /* Stabs debugging sections.  */
  .stab          0 : { *(.stab) }
  .stabstr       0 : { *(.stabstr) }
  .stab.excl     0 : { *(.stab.excl) }
  .stab.exclstr  0 : { *(.stab.exclstr) }
  .stab.index    0 : { *(.stab.index) }
  .stab.indexstr 0 : { *(.stab.indexstr) }
  .comment       0 : { *(.comment) }
  .gnu.build.attributes : { *(.gnu.build.attributes .gnu.build.attributes.*) }
  /* DWARF debug sections.
     Symbols in the DWARF debugging sections are relative to the beginning
     of the section so we begin them at 0.  */
  /* DWARF 1 */
  .debug          0 : { *(.debug) }
  .line           0 : { *(.line) }
  /* GNU DWARF 1 extensions */
  .debug_srcinfo  0 : { *(.debug_srcinfo) }
  .debug_sfnames  0 : { *(.debug_sfnames) }
  /* DWARF 1.1 and DWARF 2 */
  .debug_aranges  0 : { *(.debug_aranges) }
  .debug_pubnames 0 : { *(.debug_pubnames) }
  /* DWARF 2 */
  .debug_info     0 : { *(.debug_info .gnu.linkonce.wi.*) }
  .debug_abbrev   0 : { *(.debug_abbrev) }
  .debug_line     0 : { *(.debug_line .debug_line.* .debug_line_end) }
  .debug_frame    0 : { *(.debug_frame) }
  .debug_str      0 : { *(.debug_str) }
  .debug_loc      0 : { *(.debug_loc) }
  .debug_macinfo  0 : { *(.debug_macinfo) }
  /* SGI/MIPS DWARF 2 extensions */
  .debug_weaknames 0 : { *(.debug_weaknames) }
  .debug_funcnames 0 : { *(.debug_funcnames) }
  .debug_typenames 0 : { *(.debug_typenames) }
  .debug_varnames  0 : { *(.debug_varnames) }
  /* DWARF 3 */
  .debug_pubtypes 0 : { *(.debug_pubtypes) }
  .debug_ranges   0 : { *(.debug_ranges) }
  /* DWARF Extension.  */
  .debug_macro    0 : { *(.debug_macro) }
  .debug_addr     0 : { *(.debug_addr) }
  .gnu.attributes 0 : { KEEP (*(.gnu.attributes)) }
  /DISCARD/ : { *(.note.GNU-stack) *(.gnu_debuglink) *(.gnu.lto_*) }
}
