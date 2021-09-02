	.file	"gonbe_main.c"
	.text
	.globl	_stack_buf
	.section	.stack_area,"w"
	.align 32
_stack_buf:
	.space 100000
	.globl	_stack_40
	.align 32
_stack_40:
	.space 10000
	.globl	_main_fifo
	.bss
	.align 4
_main_fifo:
	.space 28
	.globl	_main_fifo_buf
	.align 32
_main_fifo_buf:
	.space 512
	.globl	_binfo
	.align 4
_binfo:
	.space 4
	.globl	_memory_mb
	.align 4
_memory_mb:
	.space 4
	.globl	_main_sheet
	.align 4
_main_sheet:
	.space 4
	.globl	_getc_char
	.align 4
_getc_char:
	.space 4
	.data
LC0:
	.ascii "bss_clear() %x-%x\12\0"
LC1:
	.ascii "%dMB OK\12\0"
LC2:
	.ascii "scrnx=%d scrny=%d\12\0"
LC3:
	.ascii "\226\\\221\226 read_idt\12\0"
LC4:
	.ascii "=== 1234 \203e\203X\203g\12\0"
LC5:
	.ascii "\201\223d = |%d|\12\0"
LC6:
	.ascii "\201\223"
	.ascii "6d = |%6d|\12\0"
LC7:
	.ascii "\201\223"
	.ascii "06d = |%06d|\12\0"
LC8:
	.ascii "\201\223-6d = |%-6d|\12\0"
LC9:
	.ascii "\201\223"
	.ascii "06x = |%06x|\12\0"
LC10:
	.ascii "1234\0"
LC11:
	.ascii "\201\223"
	.ascii "6s = |%6s|\12\0"
LC12:
	.ascii "\201\223"
	.ascii "06c = |%06c|\12\0"
LC13:
	.ascii "\12      \0"
LC14:
	.ascii "\12SHIFT \0"
LC15:
	.ascii "\12CNTL  \0"
LC16:
	.ascii "\12ALT   \0"
LC17:
	.ascii "\12HATA  \0"
LC18:
	.ascii "\12MARU  \0"
LC19:
	.ascii "=== 10sec timeout\12\0"
LC20:
	.ascii "*** undefined cmd %d\12\0"
	.text
	.globl	_gonbe_main
	.def	_gonbe_main;	.scl	2;	.type	32;	.endef
_gonbe_main:
LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$56, %esp
	call	_init
	movl	$2621444, %eax
	movl	(%eax), %ecx
	movl	$2621440, %eax
	movl	(%eax), %edx
	movl	_main_sheet, %eax
	movl	%ecx, 12(%esp)
	movl	%edx, 8(%esp)
	movl	$LC0, 4(%esp)
	movl	%eax, (%esp)
	call	_ut_printf
	movl	_memory_mb, %edx
	movl	_main_sheet, %eax
	movl	%edx, 8(%esp)
	movl	$LC1, 4(%esp)
	movl	%eax, (%esp)
	call	_ut_printf
	movl	_binfo, %eax
	movzwl	6(%eax), %eax
	movswl	%ax, %ecx
	movl	_binfo, %eax
	movzwl	4(%eax), %eax
	movswl	%ax, %edx
	movl	_main_sheet, %eax
	movl	%ecx, 12(%esp)
	movl	%edx, 8(%esp)
	movl	$LC2, 4(%esp)
	movl	%eax, (%esp)
	call	_ut_printf
	movl	_main_sheet, %eax
	movl	$LC3, 4(%esp)
	movl	%eax, (%esp)
	call	_ut_printf
	movl	_main_sheet, %eax
	movl	$LC4, 4(%esp)
	movl	%eax, (%esp)
	call	_ut_printf
	movl	_main_sheet, %eax
	movl	$1234, 8(%esp)
	movl	$LC5, 4(%esp)
	movl	%eax, (%esp)
	call	_ut_printf
	movl	_main_sheet, %eax
	movl	$1234, 8(%esp)
	movl	$LC6, 4(%esp)
	movl	%eax, (%esp)
	call	_ut_printf
	movl	_main_sheet, %eax
	movl	$1234, 8(%esp)
	movl	$LC7, 4(%esp)
	movl	%eax, (%esp)
	call	_ut_printf
	movl	_main_sheet, %eax
	movl	$1234, 8(%esp)
	movl	$LC8, 4(%esp)
	movl	%eax, (%esp)
	call	_ut_printf
	movl	_main_sheet, %eax
	movl	$4660, 8(%esp)
	movl	$LC9, 4(%esp)
	movl	%eax, (%esp)
	call	_ut_printf
	movl	_main_sheet, %eax
	movl	$LC10, 8(%esp)
	movl	$LC11, 4(%esp)
	movl	%eax, (%esp)
	call	_ut_printf
	movl	_main_sheet, %eax
	movl	$49, 8(%esp)
	movl	$LC12, 4(%esp)
	movl	%eax, (%esp)
	call	_ut_printf
	movl	$10000, 4(%esp)
	movl	$_main_fifo, (%esp)
	call	_set_oneshot_timer
	addl	$256, %eax
	movl	%eax, -12(%ebp)
	call	_task_init
	movl	%eax, -16(%ebp)
	movl	-16(%ebp), %eax
	movl	%eax, _main_fifo+24
	movl	$1, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	_task_run
	movl	_taskctl, %eax
	movl	-16(%ebp), %edx
	movl	%edx, 12(%eax)
	call	_task_alloc
	movl	%eax, -20(%ebp)
	movl	$8192, (%esp)
	call	_memman_alloc
	addl	$8180, %eax
	movl	%eax, %edx
	movl	-20(%ebp), %eax
	movl	%edx, 68(%eax)
	movl	$_task_idle, %edx
	movl	-20(%ebp), %eax
	movl	%edx, 44(%eax)
	movl	-20(%ebp), %eax
	movl	$8, 84(%eax)
	movl	-20(%ebp), %eax
	movl	$16, 88(%eax)
	movl	-20(%ebp), %eax
	movl	$8, 92(%eax)
	movl	-20(%ebp), %eax
	movl	$8, 96(%eax)
	movl	-20(%ebp), %eax
	movl	$8, 100(%eax)
	movl	-20(%ebp), %eax
	movl	$8, 104(%eax)
	movl	$9, 4(%esp)
	movl	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	_task_run
	call	_command_init
	movl	$254, 4(%esp)
	movl	$33, (%esp)
	call	_io_out8
L29:
	movl	$10, (%esp)
	call	_delay_task
	call	_disable_interrupt
	movl	$_main_fifo, (%esp)
	call	_fifo32_status
	testl	%eax, %eax
	jne	L2
	call	_enable_interrupt
	call	_gonbe_hlt
	jmp	L29
L2:
	movl	$_main_fifo, (%esp)
	call	_fifo32_get
	movl	%eax, -24(%ebp)
	call	_enable_interrupt
	cmpl	$0, -24(%ebp)
	js	L4
	cmpl	$255, -24(%ebp)
	jg	L4
	movl	_shtctl, %eax
	movl	16(%eax), %eax
	movl	%eax, -28(%ebp)
	movl	_shtctl, %eax
	movl	-28(%ebp), %edx
	addl	$4, %edx
	movl	4(%eax,%edx,4), %eax
	movl	%eax, -32(%ebp)
	movl	-32(%ebp), %eax
	movl	%eax, (%esp)
	call	_select_sub_disp
	movl	-32(%ebp), %eax
	movl	144(%eax), %eax
	cmpl	$5, %eax
	ja	L5
	movl	L7(,%eax,4), %eax
	jmp	*%eax
	.data
	.align 4
L7:
	.long	L12
	.long	L11
	.long	L10
	.long	L9
	.long	L8
	.long	L6
	.text
L12:
	movl	$LC13, 4(%esp)
	movl	-32(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_printf
	jmp	L5
L11:
	movl	$LC14, 4(%esp)
	movl	-32(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_printf
	jmp	L5
L10:
	movl	$LC15, 4(%esp)
	movl	-32(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_printf
	jmp	L5
L9:
	movl	$LC16, 4(%esp)
	movl	-32(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_printf
	jmp	L5
L8:
	movl	$LC17, 4(%esp)
	movl	-32(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_printf
	jmp	L5
L6:
	movl	$LC18, 4(%esp)
	movl	-32(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_printf
	nop
L5:
	movl	-32(%ebp), %eax
	movl	%eax, (%esp)
	call	_select_main_disp
	movl	$0, _getc_char
	cmpl	$184, -24(%ebp)
	jne	L13
	cmpl	$0, -28(%ebp)
	jle	L30
	movl	_shtctl, %eax
	movl	20(%eax), %eax
	movl	-28(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	_sheet_updown
	jmp	L30
L13:
	cmpl	$183, -24(%ebp)
	jne	L15
	cmpl	$0, -28(%ebp)
	jle	L30
	movl	_shtctl, %eax
	movl	-28(%ebp), %edx
	addl	$4, %edx
	movl	4(%eax,%edx,4), %eax
	movl	$0, 4(%esp)
	movl	%eax, (%esp)
	call	_sheet_updown
	jmp	L30
L15:
	cmpl	$177, -24(%ebp)
	jne	L16
	cmpl	$0, -28(%ebp)
	js	L30
	movl	-32(%ebp), %eax
	movl	20(%eax), %eax
	leal	-20(%eax), %edx
	movl	-32(%ebp), %eax
	movl	%edx, 20(%eax)
	movl	-32(%ebp), %eax
	movl	20(%eax), %eax
	testl	%eax, %eax
	jns	L17
	movl	-32(%ebp), %eax
	movl	$0, 20(%eax)
L17:
	call	_sheet_refresh
	jmp	L30
L16:
	cmpl	$178, -24(%ebp)
	jne	L18
	cmpl	$0, -28(%ebp)
	js	L30
	movl	-32(%ebp), %eax
	movl	20(%eax), %eax
	leal	20(%eax), %edx
	movl	-32(%ebp), %eax
	movl	%edx, 20(%eax)
	movl	-32(%ebp), %eax
	movl	20(%eax), %edx
	movl	-32(%ebp), %eax
	movl	12(%eax), %eax
	addl	%eax, %edx
	movl	_shtctl, %eax
	movl	12(%eax), %eax
	cmpl	%eax, %edx
	jle	L19
	movl	_shtctl, %eax
	movl	12(%eax), %edx
	movl	-32(%ebp), %eax
	movl	12(%eax), %eax
	subl	%eax, %edx
	movl	-32(%ebp), %eax
	movl	%edx, 20(%eax)
L19:
	call	_sheet_refresh
	jmp	L30
L18:
	cmpl	$180, -24(%ebp)
	jne	L20
	cmpl	$0, -28(%ebp)
	js	L30
	movl	-32(%ebp), %eax
	movl	16(%eax), %eax
	leal	20(%eax), %edx
	movl	-32(%ebp), %eax
	movl	%edx, 16(%eax)
	movl	-32(%ebp), %eax
	movl	16(%eax), %edx
	movl	-32(%ebp), %eax
	movl	8(%eax), %eax
	addl	%eax, %edx
	movl	_shtctl, %eax
	movl	8(%eax), %eax
	cmpl	%eax, %edx
	jle	L21
	movl	_shtctl, %eax
	movl	8(%eax), %edx
	movl	-32(%ebp), %eax
	movl	8(%eax), %eax
	subl	%eax, %edx
	movl	-32(%ebp), %eax
	movl	%edx, 16(%eax)
L21:
	call	_sheet_refresh
	jmp	L30
L20:
	cmpl	$179, -24(%ebp)
	jne	L22
	cmpl	$0, -28(%ebp)
	js	L30
	movl	-32(%ebp), %eax
	movl	16(%eax), %eax
	leal	-20(%eax), %edx
	movl	-32(%ebp), %eax
	movl	%edx, 16(%eax)
	movl	-32(%ebp), %eax
	movl	16(%eax), %eax
	testl	%eax, %eax
	jns	L23
	movl	-32(%ebp), %eax
	movl	$0, 16(%eax)
L23:
	call	_sheet_refresh
	jmp	L30
L22:
	cmpl	$173, -24(%ebp)
	jne	L24
	cmpl	$0, -28(%ebp)
	js	L30
	movl	-32(%ebp), %eax
	movl	12(%eax), %eax
	leal	-20(%eax), %edx
	movl	-32(%ebp), %eax
	movl	8(%eax), %eax
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	-32(%ebp), %eax
	movl	%eax, (%esp)
	call	_sheet_resize
	call	_sheet_refresh
	jmp	L30
L24:
	cmpl	$174, -24(%ebp)
	jne	L25
	cmpl	$0, -28(%ebp)
	js	L30
	movl	-32(%ebp), %eax
	movl	12(%eax), %eax
	leal	20(%eax), %edx
	movl	-32(%ebp), %eax
	movl	8(%eax), %eax
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	-32(%ebp), %eax
	movl	%eax, (%esp)
	call	_sheet_resize
	call	_sheet_refresh
	jmp	L30
L25:
	cmpl	$176, -24(%ebp)
	jne	L26
	cmpl	$0, -28(%ebp)
	js	L30
	movl	-32(%ebp), %eax
	movl	12(%eax), %eax
	movl	-32(%ebp), %edx
	movl	8(%edx), %edx
	addl	$20, %edx
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	-32(%ebp), %eax
	movl	%eax, (%esp)
	call	_sheet_resize
	call	_sheet_refresh
	jmp	L30
L26:
	cmpl	$175, -24(%ebp)
	jne	L27
	cmpl	$0, -28(%ebp)
	js	L30
	movl	-32(%ebp), %eax
	movl	12(%eax), %eax
	movl	-32(%ebp), %edx
	movl	8(%edx), %edx
	subl	$20, %edx
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	-32(%ebp), %eax
	movl	%eax, (%esp)
	call	_sheet_resize
	call	_sheet_refresh
	jmp	L30
L27:
	movl	-24(%ebp), %eax
	movl	%eax, _getc_char
	jmp	L30
L4:
	movl	-24(%ebp), %eax
	cmpl	-12(%ebp), %eax
	jne	L28
	movl	_main_sheet, %eax
	movl	$LC19, 4(%esp)
	movl	%eax, (%esp)
	call	_ut_printf
	movl	$10000, 4(%esp)
	movl	$_main_fifo, (%esp)
	call	_set_oneshot_timer
	addl	$256, %eax
	movl	%eax, -12(%ebp)
	jmp	L29
L28:
	movl	_main_sheet, %eax
	movl	-24(%ebp), %edx
	movl	%edx, 8(%esp)
	movl	$LC20, 4(%esp)
	movl	%eax, (%esp)
	call	_ut_printf
	jmp	L29
L30:
	nop
	jmp	L29
	.cfi_endproc
LFE0:
	.globl	_init
	.def	_init;	.scl	2;	.type	32;	.endef
_init:
LFB1:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	call	_bss_clear
	movl	$4080, _binfo
	movl	_binfo, %eax
	movzwl	4(%eax), %eax
	movswl	%ax, %edx
	movl	_binfo, %eax
	movzwl	6(%eax), %eax
	cwtl
	imull	%edx, %eax
	movl	%eax, %edx
	movl	_binfo, %eax
	movl	8(%eax), %eax
	movl	%edx, 8(%esp)
	movl	$7, 4(%esp)
	movl	%eax, (%esp)
	call	_memset
	call	_init_gdtidt
	call	_init_palette
	call	_dispinit
	movl	$-1, 4(%esp)
	movl	$4194304, (%esp)
	call	_memcheck
	movl	%eax, _memory_mb
	movl	_memory_mb, %eax
	movl	%eax, 8(%esp)
	movl	$4194304, 4(%esp)
	movl	$_memman, (%esp)
	call	_memman_init
	call	_shtctl_init
	movl	_binfo, %eax
	movzwl	6(%eax), %eax
	movswl	%ax, %edx
	movl	_binfo, %eax
	movzwl	4(%eax), %eax
	cwtl
	movl	$65535, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	_sheet_alloc
	movl	%eax, -12(%ebp)
	movl	$0, 8(%esp)
	movl	$0, 4(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	_sheet_slide
	movl	$0, 4(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	_sheet_updown
	movl	-12(%ebp), %eax
	movl	%eax, _main_sheet
	movl	$0, 12(%esp)
	movl	$_main_fifo_buf, 8(%esp)
	movl	$128, 4(%esp)
	movl	$_main_fifo, (%esp)
	call	_fifo32_init
	call	_init_pic
	call	_enable_interrupt
	call	_init_pit
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE1:
	.globl	_task_idle
	.def	_task_idle;	.scl	2;	.type	32;	.endef
_task_idle:
LFB2:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
L33:
	call	_gonbe_hlt
	jmp	L33
	.cfi_endproc
LFE2:
	.data
LC21:
	.ascii "=== start task_b\12\0"
LC22:
	.ascii "\12count=%d\0"
	.text
	.globl	_task_b_main
	.def	_task_b_main;	.scl	2;	.type	32;	.endef
_task_b_main:
LFB3:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$584, %esp
	movl	$0, -12(%ebp)
	movl	_main_sheet, %eax
	movl	$LC21, 4(%esp)
	movl	%eax, (%esp)
	call	_ut_printf
	movl	12(%ebp), %eax
	movl	%eax, 12(%esp)
	leal	-560(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$128, 4(%esp)
	leal	-48(%ebp), %eax
	movl	%eax, (%esp)
	call	_fifo32_init
	movl	$1000, 4(%esp)
	leal	-48(%ebp), %eax
	movl	%eax, (%esp)
	call	_set_oneshot_timer
	addl	$256, %eax
	movl	%eax, -16(%ebp)
L37:
	addl	$1, -12(%ebp)
	call	_disable_interrupt
	leal	-48(%ebp), %eax
	movl	%eax, (%esp)
	call	_fifo32_status
	testl	%eax, %eax
	jne	L35
	call	_enable_interrupt
	jmp	L37
L35:
	leal	-48(%ebp), %eax
	movl	%eax, (%esp)
	call	_fifo32_get
	movl	%eax, -20(%ebp)
	call	_enable_interrupt
	movl	-20(%ebp), %eax
	cmpl	-16(%ebp), %eax
	jne	L37
	movl	-12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$LC22, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_printf
	movl	$1000, 4(%esp)
	leal	-48(%ebp), %eax
	movl	%eax, (%esp)
	call	_set_oneshot_timer
	addl	$256, %eax
	movl	%eax, -16(%ebp)
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	_task_sleep
	jmp	L37
	.cfi_endproc
LFE3:
	.data
LC23:
	.ascii "in=%x\12\0"
	.text
	.globl	_task_c_main
	.def	_task_c_main;	.scl	2;	.type	32;	.endef
_task_c_main:
LFB4:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
L39:
	movzbl	_APP_ch, %eax
	movzbl	%al, %eax
	movl	%eax, 8(%esp)
	movl	$LC23, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_printf
	jmp	L39
	.cfi_endproc
LFE4:
	.ident	"GCC: (GNU) 10.2.0"
	.def	_ut_printf;	.scl	2;	.type	32;	.endef
	.def	_set_oneshot_timer;	.scl	2;	.type	32;	.endef
	.def	_task_init;	.scl	2;	.type	32;	.endef
	.def	_task_run;	.scl	2;	.type	32;	.endef
	.def	_task_alloc;	.scl	2;	.type	32;	.endef
	.def	_memman_alloc;	.scl	2;	.type	32;	.endef
	.def	_command_init;	.scl	2;	.type	32;	.endef
	.def	_io_out8;	.scl	2;	.type	32;	.endef
	.def	_delay_task;	.scl	2;	.type	32;	.endef
	.def	_disable_interrupt;	.scl	2;	.type	32;	.endef
	.def	_fifo32_status;	.scl	2;	.type	32;	.endef
	.def	_enable_interrupt;	.scl	2;	.type	32;	.endef
	.def	_gonbe_hlt;	.scl	2;	.type	32;	.endef
	.def	_fifo32_get;	.scl	2;	.type	32;	.endef
	.def	_select_sub_disp;	.scl	2;	.type	32;	.endef
	.def	_select_main_disp;	.scl	2;	.type	32;	.endef
	.def	_sheet_updown;	.scl	2;	.type	32;	.endef
	.def	_sheet_refresh;	.scl	2;	.type	32;	.endef
	.def	_sheet_resize;	.scl	2;	.type	32;	.endef
	.def	_bss_clear;	.scl	2;	.type	32;	.endef
	.def	_memset;	.scl	2;	.type	32;	.endef
	.def	_init_gdtidt;	.scl	2;	.type	32;	.endef
	.def	_init_palette;	.scl	2;	.type	32;	.endef
	.def	_dispinit;	.scl	2;	.type	32;	.endef
	.def	_memcheck;	.scl	2;	.type	32;	.endef
	.def	_memman_init;	.scl	2;	.type	32;	.endef
	.def	_shtctl_init;	.scl	2;	.type	32;	.endef
	.def	_sheet_alloc;	.scl	2;	.type	32;	.endef
	.def	_sheet_slide;	.scl	2;	.type	32;	.endef
	.def	_fifo32_init;	.scl	2;	.type	32;	.endef
	.def	_init_pic;	.scl	2;	.type	32;	.endef
	.def	_init_pit;	.scl	2;	.type	32;	.endef
	.def	_task_sleep;	.scl	2;	.type	32;	.endef
