GNU ld (GNU Binutils) 2.36.1
  Supported emulations:
   i386pe
   i386pep
using internal linker script:
==================================================
/* Default linker script, for normal executables */
/* Copyright (C) 2014-2021 Free Software Foundation, Inc.
   Copying and distribution of this script, with or without modification,
   are permitted in any medium without royalty provided the copyright
   notice and this notice are preserved.  */
OUTPUT_FORMAT(pei-i386)
SEARCH_DIR("/usr/i686-pc-cygwin/lib"); SEARCH_DIR("/usr/lib"); SEARCH_DIR("/usr/lib/w32api");
SECTIONS
{
  /* Make the virtual address and file offset synced if the alignment is
     lower than the target page size. */
  . = SIZEOF_HEADERS;
  . = ALIGN(__section_alignment__);
  .text  __image_base__ + ( __section_alignment__ < 0x1000 ? . : __section_alignment__ ) :
  {
    KEEP (*(SORT_NONE(.init)))
    *(.text)
    *(SORT(.text$*))
     *(.text.*)
     *(.gnu.linkonce.t.*)
    *(.glue_7t)
    *(.glue_7)
       /* Note: we always define __CTOR_LIST__ and ___CTOR_LIST__ here,
          we do not PROVIDE them.  This is because the ctors.o startup
	  code in libgcc defines them as common symbols, with the
          expectation that they will be overridden by the definitions
	  here.  If we PROVIDE the symbols then they will not be
	  overridden and global constructors will not be run.
	  See PR 22762 for more details.

	  This does mean that it is not possible for a user to define
	  their own __CTOR_LIST__ and __DTOR_LIST__ symbols; if they do,
	  the content from those variables are included but the symbols
	  defined here silently take precedence.  If they truly need to
	  be redefined, a custom linker script will have to be used.
	  (The custom script can just be a copy of this script with the
	  PROVIDE() qualifiers added).
	  In particular this means that ld -Ur does not work, because
	  the proper __CTOR_LIST__ set by ld -Ur is overridden by a
	  bogus __CTOR_LIST__ set by the final link.  See PR 46.  */
       ___CTOR_LIST__ = .;
       __CTOR_LIST__ = .;
       LONG (-1);
       KEEP(*(.ctors));
       KEEP(*(.ctor));
       KEEP(*(SORT_BY_NAME(.ctors.*)));
       LONG (0);
       /* See comment about __CTOR_LIST__ above.  The same reasoning
          applies here too.  */
       ___DTOR_LIST__ = .;
       __DTOR_LIST__ = .;
       LONG (-1);
       KEEP(*(.dtors));
       KEEP(*(.dtor));
       KEEP(*(SORT_BY_NAME(.dtors.*)));
       LONG (0);
    KEEP (*(SORT_NONE(.fini)))
    /* ??? Why is .gcc_exc here?  */
     *(.gcc_exc)
    PROVIDE (etext = .);
    PROVIDE (_etext = .);
     KEEP (*(.gcc_except_table))
  }
  /* The Cygwin32 library uses a section to avoid copying certain data
     on fork.  This used to be named ".data".  The linker used
     to include this between __data_start__ and __data_end__, but that
     breaks building the cygwin32 dll.  Instead, we name the section
     ".data_cygwin_nocopy" and explicitly include it after __data_end__. */
  .data BLOCK(__section_alignment__) :
  {
    __data_start__ = . ;
    *(.data)
    *(.data2)
    *(SORT(.data$*))
    KEEP(*(.jcr))
    __data_end__ = . ;
    *(.data_cygwin_nocopy)
  }
  .rdata BLOCK(__section_alignment__) :
  {
    *(.rdata)
	     *(SORT(.rdata$*))
    . = ALIGN(4);
    __rt_psrelocs_start = .;
    KEEP(*(.rdata_runtime_pseudo_reloc))
    __rt_psrelocs_end = .;
  }
  __rt_psrelocs_size = __rt_psrelocs_end - __rt_psrelocs_start;
  ___RUNTIME_PSEUDO_RELOC_LIST_END__ = .;
  __RUNTIME_PSEUDO_RELOC_LIST_END__ = .;
  ___RUNTIME_PSEUDO_RELOC_LIST__ = . - __rt_psrelocs_size;
  __RUNTIME_PSEUDO_RELOC_LIST__ = . - __rt_psrelocs_size;
  .eh_frame BLOCK(__section_alignment__) :
  {
    KEEP(*(.eh_frame*))
  }
  .pdata BLOCK(__section_alignment__) :
  {
    KEEP(*(.pdata*))
  }
  .bss BLOCK(__section_alignment__) :
  {
    __bss_start__ = . ;
    *(.bss)
    *(COMMON)
    __bss_end__ = . ;
  }
  .edata BLOCK(__section_alignment__) :
  {
    *(.edata)
  }
  /DISCARD/ :
  {
    *(.debug$S)
    *(.debug$T)
    *(.debug$F)
    *(.drectve)
     *(.note.GNU-stack)
     *(.gnu.lto_*)
  }
  .idata BLOCK(__section_alignment__) :
  {
    /* This cannot currently be handled with grouped sections.
	See pe.em:sort_sections.  */
    KEEP (SORT(*)(.idata$2))
    KEEP (SORT(*)(.idata$3))
    /* These zeroes mark the end of the import list.  */
    LONG (0); LONG (0); LONG (0); LONG (0); LONG (0);
    KEEP (SORT(*)(.idata$4))
    __IAT_start__ = .;
    KEEP (SORT(*)(.idata$5))
    __IAT_end__ = .;
    KEEP (SORT(*)(.idata$6))
    KEEP (SORT(*)(.idata$7))
  }
  .CRT BLOCK(__section_alignment__) :
  {
    ___crt_xc_start__ = . ;
    KEEP (*(SORT(.CRT$XC*)))  /* C initialization */
    ___crt_xc_end__ = . ;
    ___crt_xi_start__ = . ;
    KEEP (*(SORT(.CRT$XI*)))  /* C++ initialization */
    ___crt_xi_end__ = . ;
    ___crt_xl_start__ = . ;
    KEEP (*(SORT(.CRT$XL*)))  /* TLS callbacks */
    /* ___crt_xl_end__ is defined in the TLS Directory support code */
    ___crt_xp_start__ = . ;
    KEEP (*(SORT(.CRT$XP*)))  /* Pre-termination */
    ___crt_xp_end__ = . ;
    ___crt_xt_start__ = . ;
    KEEP (*(SORT(.CRT$XT*)))  /* Termination */
    ___crt_xt_end__ = . ;
  }
  /* Windows TLS expects .tls$AAA to be at the start and .tls$ZZZ to be
     at the end of section.  This is important because _tls_start MUST
     be at the beginning of the section to enable SECREL32 relocations with TLS
     data.  */
  .tls BLOCK(__section_alignment__) :
  {
    ___tls_start__ = . ;
    KEEP (*(.tls$AAA))
    KEEP (*(.tls))
    KEEP (*(.tls$))
    KEEP (*(SORT(.tls$*)))
    KEEP (*(.tls$ZZZ))
    ___tls_end__ = . ;
  }
  .endjunk BLOCK(__section_alignment__) :
  {
    /* end is deprecated, don't use it */
    PROVIDE (end = .);
    PROVIDE ( _end = .);
     __end__ = .;
  }
  .rsrc BLOCK(__section_alignment__) : SUBALIGN(4)
  {
    KEEP (*(.rsrc))
    KEEP (*(.rsrc$*))
  }
  .reloc BLOCK(__section_alignment__) :
  {
    *(.reloc)
  }
  .stab BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.stab)
  }
  .stabstr BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.stabstr)
  }
  /* DWARF debug sections.
     Symbols in the DWARF debugging sections are relative to the beginning
     of the section.  Unlike other targets that fake this by putting the
     section VMA at 0, the PE format will not allow it.  */
  /* DWARF 1.1 and DWARF 2.  */
  .debug_aranges BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.debug_aranges)
  }
  .zdebug_aranges BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.zdebug_aranges)
  }
  .debug_pubnames BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.debug_pubnames)
  }
  .zdebug_pubnames BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.zdebug_pubnames)
  }
  .debug_pubtypes BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.debug_pubtypes)
  }
  .zdebug_pubtypes BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.zdebug_pubtypes)
  }
  /* DWARF 2.  */
  .debug_info BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.debug_info .gnu.linkonce.wi.*)
  }
  .zdebug_info BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.zdebug_info .zdebug.gnu.linkonce.wi.*)
  }
  .debug_abbrev BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.debug_abbrev)
  }
  .zdebug_abbrev BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.zdebug_abbrev)
  }
  .debug_line BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.debug_line)
  }
  .zdebug_line BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.zdebug_line)
  }
  .debug_frame BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.debug_frame*)
  }
  .zdebug_frame BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.zdebug_frame*)
  }
  .debug_str BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.debug_str)
  }
  .zdebug_str BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.zdebug_str)
  }
  .debug_loc BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.debug_loc)
  }
  .zdebug_loc BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.zdebug_loc)
  }
  .debug_macinfo BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.debug_macinfo)
  }
  .zdebug_macinfo BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.zdebug_macinfo)
  }
  /* SGI/MIPS DWARF 2 extensions.  */
  .debug_weaknames BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.debug_weaknames)
  }
  .zdebug_weaknames BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.zdebug_weaknames)
  }
  .debug_funcnames BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.debug_funcnames)
  }
  .zdebug_funcnames BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.zdebug_funcnames)
  }
  .debug_typenames BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.debug_typenames)
  }
  .zdebug_typenames BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.zdebug_typenames)
  }
  .debug_varnames BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.debug_varnames)
  }
  .zdebug_varnames BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.zdebug_varnames)
  }
  .debug_macro BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.debug_macro)
  }
  .zdebug_macro BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.zdebug_macro)
  }
  /* DWARF 3.  */
  .debug_ranges BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.debug_ranges)
  }
  .zdebug_ranges BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.zdebug_ranges)
  }
  /* DWARF 4.  */
  .debug_types BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.debug_types .gnu.linkonce.wt.*)
  }
  .zdebug_types BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.zdebug_types .gnu.linkonce.wt.*)
  }
  /* For Go and Rust.  */
  .debug_gdb_scripts BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.debug_gdb_scripts)
  }
  .zdebug_gdb_scripts BLOCK(__section_alignment__) (NOLOAD) :
  {
    *(.zdebug_gdb_scripts)
  }
}


==================================================
/usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/bin/ld: mode i386pe
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../crt0.o succeeded
/usr/lib/gcc/i686-pc-cygwin/10/../../../crt0.o
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/crtbegin.o succeeded
/usr/lib/gcc/i686-pc-cygwin/10/crtbegin.o
attempt to open /tmp/ccMaB7eJ.o succeeded
/tmp/ccMaB7eJ.o
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/libgcc_s.dll.a succeeded
/usr/lib/gcc/i686-pc-cygwin/10/libgcc_s.dll.a
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/libgcc.dll.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/gcc.dll.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/libgcc.a succeeded
/usr/lib/gcc/i686-pc-cygwin/10/libgcc.a
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/libcygwin.dll.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/cygwin.dll.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/libcygwin.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/cygwin.lib failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/libcygwin.lib failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/cygcygwin.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/libcygwin.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/cygwin.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/libcygwin.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/libcygwin.dll.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/cygwin.dll.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/libcygwin.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/cygwin.lib failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/libcygwin.lib failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/cygcygwin.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/libcygwin.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/cygwin.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/libcygwin.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.dll.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../cygwin.dll.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a succeeded
/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)d000027.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)t-d000027.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)cygwin_crt0.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)libcmain.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)premain0.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)premain1.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)premain2.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)premain3.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)d000000.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)d000001.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)d000083.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)d000225.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)d002044.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)d002071.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)d002077.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)d002371.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)t-d000083.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)t-d002044.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)t-d002071.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)t-d002077.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)_cygwin_crt0_common.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)dll_entry.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)dll_main.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)pseudo-reloc-dummy.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)d000410.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)d000838.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)d000978.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)d000980.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)d001189.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)d001523.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)d001635.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)d001820.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)t-d000838.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)t-d000978.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)t-d000980.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)t-d001189.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)t-d001523.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)t-d001635.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)t-d001820.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)cygwin_attach_dll.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)d001012.o
(/usr/lib/gcc/i686-pc-cygwin/10/../../../libcygwin.a)t-d001012.o
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/libadvapi32.dll.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/advapi32.dll.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/libadvapi32.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/advapi32.lib failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/libadvapi32.lib failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/cygadvapi32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/libadvapi32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/advapi32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/libadvapi32.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/libadvapi32.dll.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/advapi32.dll.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/libadvapi32.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/advapi32.lib failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/libadvapi32.lib failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/cygadvapi32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/libadvapi32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/advapi32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/libadvapi32.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../libadvapi32.dll.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../advapi32.dll.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../libadvapi32.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../advapi32.lib failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../libadvapi32.lib failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../cygadvapi32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../libadvapi32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../advapi32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../libadvapi32.a failed
attempt to open /usr/i686-pc-cygwin/lib/libadvapi32.dll.a failed
attempt to open /usr/i686-pc-cygwin/lib/advapi32.dll.a failed
attempt to open /usr/i686-pc-cygwin/lib/libadvapi32.a failed
attempt to open /usr/i686-pc-cygwin/lib/advapi32.lib failed
attempt to open /usr/i686-pc-cygwin/lib/libadvapi32.lib failed
attempt to open /usr/i686-pc-cygwin/lib/cygadvapi32.dll failed
attempt to open /usr/i686-pc-cygwin/lib/libadvapi32.dll failed
attempt to open /usr/i686-pc-cygwin/lib/advapi32.dll failed
attempt to open /usr/i686-pc-cygwin/lib/libadvapi32.a failed
attempt to open /usr/lib/libadvapi32.dll.a failed
attempt to open /usr/lib/advapi32.dll.a failed
attempt to open /usr/lib/libadvapi32.a failed
attempt to open /usr/lib/advapi32.lib failed
attempt to open /usr/lib/libadvapi32.lib failed
attempt to open /usr/lib/cygadvapi32.dll failed
attempt to open /usr/lib/libadvapi32.dll failed
attempt to open /usr/lib/advapi32.dll failed
attempt to open /usr/lib/libadvapi32.a failed
attempt to open /usr/lib/w32api/libadvapi32.dll.a failed
attempt to open /usr/lib/w32api/advapi32.dll.a failed
attempt to open /usr/lib/w32api/libadvapi32.a succeeded
/usr/lib/w32api/libadvapi32.a
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/libshell32.dll.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/shell32.dll.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/libshell32.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/shell32.lib failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/libshell32.lib failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/cygshell32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/libshell32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/shell32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/libshell32.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/libshell32.dll.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/shell32.dll.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/libshell32.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/shell32.lib failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/libshell32.lib failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/cygshell32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/libshell32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/shell32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/libshell32.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../libshell32.dll.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../shell32.dll.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../libshell32.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../shell32.lib failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../libshell32.lib failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../cygshell32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../libshell32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../shell32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../libshell32.a failed
attempt to open /usr/i686-pc-cygwin/lib/libshell32.dll.a failed
attempt to open /usr/i686-pc-cygwin/lib/shell32.dll.a failed
attempt to open /usr/i686-pc-cygwin/lib/libshell32.a failed
attempt to open /usr/i686-pc-cygwin/lib/shell32.lib failed
attempt to open /usr/i686-pc-cygwin/lib/libshell32.lib failed
attempt to open /usr/i686-pc-cygwin/lib/cygshell32.dll failed
attempt to open /usr/i686-pc-cygwin/lib/libshell32.dll failed
attempt to open /usr/i686-pc-cygwin/lib/shell32.dll failed
attempt to open /usr/i686-pc-cygwin/lib/libshell32.a failed
attempt to open /usr/lib/libshell32.dll.a failed
attempt to open /usr/lib/shell32.dll.a failed
attempt to open /usr/lib/libshell32.a failed
attempt to open /usr/lib/shell32.lib failed
attempt to open /usr/lib/libshell32.lib failed
attempt to open /usr/lib/cygshell32.dll failed
attempt to open /usr/lib/libshell32.dll failed
attempt to open /usr/lib/shell32.dll failed
attempt to open /usr/lib/libshell32.a failed
attempt to open /usr/lib/w32api/libshell32.dll.a failed
attempt to open /usr/lib/w32api/shell32.dll.a failed
attempt to open /usr/lib/w32api/libshell32.a succeeded
/usr/lib/w32api/libshell32.a
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/libuser32.dll.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/user32.dll.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/libuser32.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/user32.lib failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/libuser32.lib failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/cyguser32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/libuser32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/user32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/libuser32.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/libuser32.dll.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/user32.dll.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/libuser32.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/user32.lib failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/libuser32.lib failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/cyguser32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/libuser32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/user32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/libuser32.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../libuser32.dll.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../user32.dll.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../libuser32.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../user32.lib failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../libuser32.lib failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../cyguser32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../libuser32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../user32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../libuser32.a failed
attempt to open /usr/i686-pc-cygwin/lib/libuser32.dll.a failed
attempt to open /usr/i686-pc-cygwin/lib/user32.dll.a failed
attempt to open /usr/i686-pc-cygwin/lib/libuser32.a failed
attempt to open /usr/i686-pc-cygwin/lib/user32.lib failed
attempt to open /usr/i686-pc-cygwin/lib/libuser32.lib failed
attempt to open /usr/i686-pc-cygwin/lib/cyguser32.dll failed
attempt to open /usr/i686-pc-cygwin/lib/libuser32.dll failed
attempt to open /usr/i686-pc-cygwin/lib/user32.dll failed
attempt to open /usr/i686-pc-cygwin/lib/libuser32.a failed
attempt to open /usr/lib/libuser32.dll.a failed
attempt to open /usr/lib/user32.dll.a failed
attempt to open /usr/lib/libuser32.a failed
attempt to open /usr/lib/user32.lib failed
attempt to open /usr/lib/libuser32.lib failed
attempt to open /usr/lib/cyguser32.dll failed
attempt to open /usr/lib/libuser32.dll failed
attempt to open /usr/lib/user32.dll failed
attempt to open /usr/lib/libuser32.a failed
attempt to open /usr/lib/w32api/libuser32.dll.a failed
attempt to open /usr/lib/w32api/user32.dll.a failed
attempt to open /usr/lib/w32api/libuser32.a succeeded
/usr/lib/w32api/libuser32.a
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/libkernel32.dll.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/kernel32.dll.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/libkernel32.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/kernel32.lib failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/libkernel32.lib failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/cygkernel32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/libkernel32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/kernel32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/libkernel32.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/libkernel32.dll.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/kernel32.dll.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/libkernel32.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/kernel32.lib failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/libkernel32.lib failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/cygkernel32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/libkernel32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/kernel32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../../i686-pc-cygwin/lib/libkernel32.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../libkernel32.dll.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../kernel32.dll.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../libkernel32.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../kernel32.lib failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../libkernel32.lib failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../cygkernel32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../libkernel32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../kernel32.dll failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../libkernel32.a failed
attempt to open /usr/i686-pc-cygwin/lib/libkernel32.dll.a failed
attempt to open /usr/i686-pc-cygwin/lib/kernel32.dll.a failed
attempt to open /usr/i686-pc-cygwin/lib/libkernel32.a failed
attempt to open /usr/i686-pc-cygwin/lib/kernel32.lib failed
attempt to open /usr/i686-pc-cygwin/lib/libkernel32.lib failed
attempt to open /usr/i686-pc-cygwin/lib/cygkernel32.dll failed
attempt to open /usr/i686-pc-cygwin/lib/libkernel32.dll failed
attempt to open /usr/i686-pc-cygwin/lib/kernel32.dll failed
attempt to open /usr/i686-pc-cygwin/lib/libkernel32.a failed
attempt to open /usr/lib/libkernel32.dll.a failed
attempt to open /usr/lib/kernel32.dll.a failed
attempt to open /usr/lib/libkernel32.a failed
attempt to open /usr/lib/kernel32.lib failed
attempt to open /usr/lib/libkernel32.lib failed
attempt to open /usr/lib/cygkernel32.dll failed
attempt to open /usr/lib/libkernel32.dll failed
attempt to open /usr/lib/kernel32.dll failed
attempt to open /usr/lib/libkernel32.a failed
attempt to open /usr/lib/w32api/libkernel32.dll.a failed
attempt to open /usr/lib/w32api/kernel32.dll.a failed
attempt to open /usr/lib/w32api/libkernel32.a succeeded
/usr/lib/w32api/libkernel32.a
(/usr/lib/w32api/libkernel32.a)dsiecs00976.o
(/usr/lib/w32api/libkernel32.a)dsiecs00728.o
(/usr/lib/w32api/libkernel32.a)dsiecs00693.o
(/usr/lib/w32api/libkernel32.a)dsiecs00636.o
(/usr/lib/w32api/libkernel32.a)dsiecs00432.o
(/usr/lib/w32api/libkernel32.a)dsiech.o
(/usr/lib/w32api/libkernel32.a)dsiect.o
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/libgcc_s.dll.a succeeded
/usr/lib/gcc/i686-pc-cygwin/10/libgcc_s.dll.a
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/libgcc.dll.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/gcc.dll.a failed
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/libgcc.a succeeded
/usr/lib/gcc/i686-pc-cygwin/10/libgcc.a
(/usr/lib/gcc/i686-pc-cygwin/10/libgcc.a)_ctors.o
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/../../../default-manifest.o succeeded
/usr/lib/gcc/i686-pc-cygwin/10/../../../default-manifest.o
attempt to open /usr/lib/gcc/i686-pc-cygwin/10/crtend.o succeeded
/usr/lib/gcc/i686-pc-cygwin/10/crtend.o
