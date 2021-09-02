OUTPUT_FORMAT(pei-i386)
SECTIONS
{
	.text 0:
	{
		LONG (_bss_start);
		LONG (_data_end);
		LONG (0);
		LONG (0);
		LONG (0);
		LONG (0);
		LONG (0);
		LONG (0);
		*(.text_asm_lib)
		*(.text)
	}
	. = ALIGN(4);
	_text_end = .;

	. = _text_end + 0x00280000;
	_data_start = .;
	
	.reloc :
	{
		*(.reloc);
	}
	. = ALIGN(4);
	
	.rdata :
	{
		*(.rdata)
		*(.rdata$*)
	}
	. = ALIGN(4);
	
	.buildid :
	{
		*(.buildid)
	}
	. = ALIGN(4);
	
	.eh_frame :
	{
		*(.eh_frame*)
	}
	. = ALIGN(4);
	
	.drectve :
	{
		*(.drectve)
	}
	. = ALIGN(4);

	.data :
	{
		*(.data)
	}
	. = ALIGN(4);

	.bss :
	{
		*(.stack_area)
		_bss_start = .;
		*(.bss)
	}
	. = ALIGN(4);
	_data_end = .;
}