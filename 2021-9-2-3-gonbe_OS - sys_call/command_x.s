	.file	"command.c"
	.text
	.globl	_cmd_sht
	.bss
	.align 4
_cmd_sht:
	.space 4
	.globl	_cmd_task
	.align 4
_cmd_task:
	.space 4
	.globl	_run_task
	.align 4
_run_task:
	.space 4
	.text
	.globl	_command_init
	.def	_command_init;	.scl	2;	.type	32;	.endef
_command_init:
LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	$_command, %eax
	movl	$3, 24(%esp)
	movl	%eax, 20(%esp)
	movl	$65536, 16(%esp)
	movl	$400, 12(%esp)
	movl	$500, 8(%esp)
	movl	$_cmd_sht, 4(%esp)
	movl	$_cmd_task, (%esp)
	call	_make_sheet_and_thread
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE0:
	.data
LC0:
	.ascii "*** GDT table overflow\12\0"
	.text
	.globl	_command_make_task
	.def	_command_make_task;	.scl	2;	.type	32;	.endef
_command_make_task:
LFB1:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$56, %esp
	movl	$2555904, -24(%ebp)
	movl	$8, 8(%esp)
	movl	$0, 4(%esp)
	leal	-32(%ebp), %eax
	movl	%eax, (%esp)
	call	_memset
	movl	$0, -20(%ebp)
	movl	-20(%ebp), %eax
	movl	%eax, -16(%ebp)
	movl	$4, -12(%ebp)
	jmp	L3
L7:
	movl	-12(%ebp), %eax
	leal	0(,%eax,8), %edx
	movl	-24(%ebp), %eax
	addl	%edx, %eax
	movl	$8, 8(%esp)
	movl	%eax, 4(%esp)
	leal	-32(%ebp), %eax
	movl	%eax, (%esp)
	call	_memcmp
	testl	%eax, %eax
	jne	L4
	cmpl	$0, -16(%ebp)
	jne	L5
	movl	-12(%ebp), %eax
	movl	%eax, -16(%ebp)
	jmp	L4
L5:
	movl	-12(%ebp), %eax
	movl	%eax, -20(%ebp)
	jmp	L6
L4:
	addl	$1, -12(%ebp)
L3:
	cmpl	$8190, -12(%ebp)
	jle	L7
L6:
	cmpl	$8191, -12(%ebp)
	jne	L8
	movl	$LC0, (%esp)
	call	_fatal_a
L8:
	movl	_a_binfile, %eax
	movl	%eax, %edx
	movl	-20(%ebp), %eax
	leal	0(,%eax,8), %ecx
	movl	-24(%ebp), %eax
	addl	%ecx, %eax
	movl	$16538, 12(%esp)
	movl	%edx, 8(%esp)
	movl	$1048575, 4(%esp)
	movl	%eax, (%esp)
	call	_set_segmdesc
	movl	_a_binfile, %eax
	movl	%eax, %edx
	movl	-16(%ebp), %eax
	leal	0(,%eax,8), %ecx
	movl	-24(%ebp), %eax
	addl	%ecx, %eax
	movl	$16530, 12(%esp)
	movl	%edx, 8(%esp)
	movl	$1048575, 4(%esp)
	movl	%eax, (%esp)
	call	_set_segmdesc
	call	_task_alloc
	movl	%eax, _run_task
	movl	$65536, (%esp)
	call	_memman_alloc
	leal	65524(%eax), %edx
	movl	_run_task, %eax
	movl	%edx, 68(%eax)
	movl	_run_task, %eax
	movl	$0, 44(%eax)
	movl	_run_task, %eax
	movl	-16(%ebp), %edx
	sall	$3, %edx
	movl	%edx, 84(%eax)
	movl	_run_task, %eax
	movl	-20(%ebp), %edx
	sall	$3, %edx
	movl	%edx, 88(%eax)
	movl	_run_task, %eax
	movl	$8, 92(%eax)
	movl	_run_task, %eax
	movl	-16(%ebp), %edx
	sall	$3, %edx
	movl	%edx, 96(%eax)
	movl	_run_task, %eax
	movl	-16(%ebp), %edx
	sall	$3, %edx
	movl	%edx, 100(%eax)
	movl	_run_task, %eax
	movl	-16(%ebp), %edx
	sall	$3, %edx
	movl	%edx, 104(%eax)
	movl	_cmd_sht, %edx
	movl	_run_task, %eax
	movl	%edx, 56(%eax)
	movl	_run_task, %eax
	movl	$5, 4(%esp)
	movl	%eax, (%esp)
	call	_task_run
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE1:
	.data
LC1:
	.ascii "\12\0"
	.align 4
LC2:
	.ascii "> help         ... this message\12\0"
	.align 4
LC3:
	.ascii "> cls          ... clear screen\12\0"
	.align 4
LC4:
	.ascii "> sedit        ... screen editor\12\0"
LC5:
	.ascii "> asm80386     ... assemble\12\0"
	.align 4
LC6:
	.ascii "> run          ... program run\12\0"
	.text
	.globl	_cmd_help
	.def	_cmd_help;	.scl	2;	.type	32;	.endef
_cmd_help:
LFB2:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	movl	$LC1, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_printf
	movl	$LC2, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_printf
	movl	$LC3, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_printf
	movl	$LC4, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_printf
	movl	$LC5, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_printf
	movl	$LC6, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_printf
	movl	$LC1, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_printf
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE2:
	.data
LC7:
	.ascii "Help message is \"help\"\12\0"
LC8:
	.ascii "> \0"
LC9:
	.ascii "%c\0"
LC10:
	.ascii "help\0"
LC11:
	.ascii "cls\0"
LC12:
	.ascii "sedit\0"
LC13:
	.ascii "asm80386\0"
LC14:
	.ascii "run\0"
LC15:
	.ascii "int40\0"
LC16:
	.ascii "*** error\12\0"
	.text
	.globl	_command
	.def	_command;	.scl	2;	.type	32;	.endef
_command:
LFB3:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$168, %esp
	movl	$LC7, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_printf
L29:
	movl	$LC8, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_printf
	movl	$0, -12(%ebp)
	jmp	L11
L16:
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_getcA
	movl	%eax, -16(%ebp)
	cmpl	$10, -16(%ebp)
	jne	L12
	movl	$LC1, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_printf
	leal	-144(%ebp), %edx
	movl	-12(%ebp), %eax
	addl	%edx, %eax
	movb	$0, (%eax)
	jmp	L13
L12:
	cmpl	$0, -16(%ebp)
	jle	L14
	cmpl	$127, -16(%ebp)
	jg	L14
	movl	-16(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$LC9, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_printf
	movl	-16(%ebp), %eax
	movl	%eax, %edx
	leal	-144(%ebp), %ecx
	movl	-12(%ebp), %eax
	addl	%ecx, %eax
	movb	%dl, (%eax)
	jmp	L15
L14:
	subl	$1, -12(%ebp)
L15:
	addl	$1, -12(%ebp)
L11:
	movl	-12(%ebp), %eax
	cmpl	$127, %eax
	jbe	L16
L13:
	cmpl	$128, -12(%ebp)
	jne	L17
	movl	-12(%ebp), %eax
	subl	$1, %eax
	movb	$0, -144(%ebp,%eax)
L17:
	movl	$LC10, 4(%esp)
	leal	-144(%ebp), %eax
	movl	%eax, (%esp)
	call	_strcmp
	testl	%eax, %eax
	jne	L18
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_cmd_help
	jmp	L29
L18:
	movl	$LC11, 4(%esp)
	leal	-144(%ebp), %eax
	movl	%eax, (%esp)
	call	_strcmp
	testl	%eax, %eax
	jne	L20
	movl	8(%ebp), %eax
	movl	108(%eax), %eax
	movl	(%eax), %eax
	movsbl	%al, %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_clear_screen
	movl	8(%ebp), %eax
	movl	96(%eax), %eax
	movl	$0, (%eax)
	jmp	L29
L20:
	movl	$LC12, 4(%esp)
	leal	-144(%ebp), %eax
	movl	%eax, (%esp)
	call	_strcmp
	testl	%eax, %eax
	jne	L21
	call	_sedit_main
	jmp	L29
L21:
	movl	$LC13, 4(%esp)
	leal	-144(%ebp), %eax
	movl	%eax, (%esp)
	call	_strcmp
	testl	%eax, %eax
	jne	L22
	call	_asm_main
	jmp	L29
L22:
	movl	$LC14, 4(%esp)
	leal	-144(%ebp), %eax
	movl	%eax, (%esp)
	call	_strcmp
	testl	%eax, %eax
	jne	L23
	call	_command_make_task
	jmp	L24
L27:
	movl	8(%ebp), %eax
	movl	$0, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$1, (%esp)
	call	_asm_int_0x40
	movl	%eax, -16(%ebp)
	cmpl	$185, -16(%ebp)
	jne	L25
	call	_disable_interrupt
	movl	_run_task, %eax
	movl	$0, 4(%esp)
	movl	%eax, (%esp)
	call	_task_remove
	call	_enable_interrupt
	movl	_run_task, %eax
	movl	$0, 4(%eax)
	jmp	L19
L25:
	movl	$100, (%esp)
	call	_delay_task
L24:
	movl	_run_task, %eax
	movl	4(%eax), %eax
	cmpl	$2, %eax
	je	L27
	jmp	L29
L23:
	movl	$LC15, 4(%esp)
	leal	-144(%ebp), %eax
	movl	%eax, (%esp)
	call	_strcmp
	testl	%eax, %eax
	jne	L28
	movl	8(%ebp), %eax
	movl	$4660, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$5, (%esp)
	call	_asm_int_0x40
	jmp	L29
L28:
	movl	$LC16, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_printf
L19:
	jmp	L29
	.cfi_endproc
LFE3:
	.ident	"GCC: (GNU) 10.2.0"
	.def	_make_sheet_and_thread;	.scl	2;	.type	32;	.endef
	.def	_memset;	.scl	2;	.type	32;	.endef
	.def	_memcmp;	.scl	2;	.type	32;	.endef
	.def	_fatal_a;	.scl	2;	.type	32;	.endef
	.def	_set_segmdesc;	.scl	2;	.type	32;	.endef
	.def	_task_alloc;	.scl	2;	.type	32;	.endef
	.def	_memman_alloc;	.scl	2;	.type	32;	.endef
	.def	_task_run;	.scl	2;	.type	32;	.endef
	.def	_ut_printf;	.scl	2;	.type	32;	.endef
	.def	_ut_getcA;	.scl	2;	.type	32;	.endef
	.def	_strcmp;	.scl	2;	.type	32;	.endef
	.def	_clear_screen;	.scl	2;	.type	32;	.endef
	.def	_sedit_main;	.scl	2;	.type	32;	.endef
	.def	_asm_main;	.scl	2;	.type	32;	.endef
	.def	_asm_int_0x40;	.scl	2;	.type	32;	.endef
	.def	_disable_interrupt;	.scl	2;	.type	32;	.endef
	.def	_task_remove;	.scl	2;	.type	32;	.endef
	.def	_enable_interrupt;	.scl	2;	.type	32;	.endef
	.def	_delay_task;	.scl	2;	.type	32;	.endef
