	.file	"sheet.c"
	.text
	.globl	_memman
	.bss
	.align 32
_memman:
	.space 8008
	.globl	_shtctl
	.align 4
_shtctl:
	.space 4
	.text
	.globl	_memman_init
	.def	_memman_init;	.scl	2;	.type	32;	.endef
_memman_init:
LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	movl	8(%ebp), %eax
	movl	$1, (%eax)
	movl	8(%ebp), %eax
	movl	12(%ebp), %edx
	movl	%edx, 8(%eax)
	movl	16(%ebp), %eax
	sall	$20, %eax
	subl	12(%ebp), %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movl	%edx, 12(%eax)
	movl	8(%ebp), %eax
	movl	$0, 4(%eax)
	nop
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE0:
	.data
	.align 4
LC0:
	.ascii "*** memory alloc area nothing\12\0"
	.text
	.globl	_memman_alloc
	.def	_memman_alloc;	.scl	2;	.type	32;	.endef
_memman_alloc:
LFB1:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	8(%ebp), %eax
	addl	$4095, %eax
	andl	$-4096, %eax
	movl	%eax, 8(%ebp)
	movl	$0, -12(%ebp)
	jmp	L3
L9:
	movl	-12(%ebp), %eax
	movl	_memman+12(,%eax,8), %eax
	cmpl	%eax, 8(%ebp)
	ja	L4
	movl	-12(%ebp), %eax
	movl	_memman+8(,%eax,8), %eax
	movl	%eax, -20(%ebp)
	movl	-12(%ebp), %eax
	movl	_memman+12(,%eax,8), %eax
	cmpl	%eax, 8(%ebp)
	jne	L5
	movl	_memman, %eax
	subl	$1, %eax
	movl	%eax, _memman
	movl	-12(%ebp), %eax
	movl	%eax, -16(%ebp)
	jmp	L6
L7:
	movl	-12(%ebp), %eax
	addl	$1, %eax
	movl	-12(%ebp), %ecx
	movl	_memman+12(,%eax,8), %edx
	movl	_memman+8(,%eax,8), %eax
	movl	%eax, _memman+8(,%ecx,8)
	movl	%edx, _memman+12(,%ecx,8)
	addl	$1, -16(%ebp)
L6:
	movl	_memman, %eax
	cmpl	%eax, -16(%ebp)
	jl	L7
	movl	-20(%ebp), %eax
	movl	8(%ebp), %edx
	movl	%edx, 8(%esp)
	movl	$0, 4(%esp)
	movl	%eax, (%esp)
	call	_memset
	movl	-20(%ebp), %eax
	jmp	L8
L5:
	movl	-12(%ebp), %eax
	movl	_memman+8(,%eax,8), %edx
	movl	8(%ebp), %eax
	addl	%eax, %edx
	movl	-12(%ebp), %eax
	movl	%edx, _memman+8(,%eax,8)
	movl	-12(%ebp), %eax
	movl	_memman+12(,%eax,8), %eax
	subl	8(%ebp), %eax
	movl	%eax, %edx
	movl	-12(%ebp), %eax
	movl	%edx, _memman+12(,%eax,8)
	movl	-20(%ebp), %eax
	movl	8(%ebp), %edx
	movl	%edx, 8(%esp)
	movl	$0, 4(%esp)
	movl	%eax, (%esp)
	call	_memset
	movl	-20(%ebp), %eax
	jmp	L8
L4:
	addl	$1, -12(%ebp)
L3:
	movl	_memman, %eax
	cmpl	%eax, -12(%ebp)
	jl	L9
	movl	$LC0, (%esp)
	call	_fatal_a
	movl	$0, %eax
L8:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE1:
	.data
	.align 4
LC1:
	.ascii "*** memory memory alloc table area nothing\12\0"
	.text
	.globl	_memman_free
	.def	_memman_free;	.scl	2;	.type	32;	.endef
_memman_free:
LFB2:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	$0, -12(%ebp)
	jmp	L11
L14:
	movl	-12(%ebp), %eax
	movl	_memman+8(,%eax,8), %eax
	cmpl	%eax, 8(%ebp)
	jb	L25
	addl	$1, -12(%ebp)
L11:
	movl	_memman, %eax
	cmpl	%eax, -12(%ebp)
	jl	L14
	jmp	L13
L25:
	nop
L13:
	cmpl	$0, -12(%ebp)
	jle	L15
	movl	-12(%ebp), %eax
	subl	$1, %eax
	movl	_memman+8(,%eax,8), %edx
	movl	-12(%ebp), %eax
	subl	$1, %eax
	movl	_memman+12(,%eax,8), %eax
	addl	%edx, %eax
	cmpl	%eax, 8(%ebp)
	jne	L15
	movl	-12(%ebp), %eax
	subl	$1, %eax
	movl	_memman+12(,%eax,8), %ecx
	movl	-12(%ebp), %eax
	subl	$1, %eax
	movl	12(%ebp), %edx
	addl	%ecx, %edx
	movl	%edx, _memman+12(,%eax,8)
	movl	_memman, %eax
	cmpl	%eax, -12(%ebp)
	jge	L26
	movl	8(%ebp), %edx
	movl	12(%ebp), %eax
	addl	%eax, %edx
	movl	-12(%ebp), %eax
	movl	_memman+8(,%eax,8), %eax
	cmpl	%eax, %edx
	jne	L26
	movl	-12(%ebp), %eax
	subl	$1, %eax
	movl	_memman+12(,%eax,8), %ecx
	movl	-12(%ebp), %eax
	movl	_memman+12(,%eax,8), %edx
	movl	-12(%ebp), %eax
	subl	$1, %eax
	addl	%ecx, %edx
	movl	%edx, _memman+12(,%eax,8)
	movl	_memman, %eax
	subl	$1, %eax
	movl	%eax, _memman
	movl	-12(%ebp), %eax
	movl	%eax, -16(%ebp)
	jmp	L17
L18:
	movl	-12(%ebp), %eax
	addl	$1, %eax
	movl	-12(%ebp), %ecx
	movl	_memman+12(,%eax,8), %edx
	movl	_memman+8(,%eax,8), %eax
	movl	%eax, _memman+8(,%ecx,8)
	movl	%edx, _memman+12(,%ecx,8)
	addl	$1, -16(%ebp)
L17:
	movl	_memman, %eax
	cmpl	%eax, -16(%ebp)
	jl	L18
	jmp	L26
L15:
	movl	_memman, %eax
	cmpl	%eax, -12(%ebp)
	jge	L20
	movl	8(%ebp), %edx
	movl	12(%ebp), %eax
	addl	%eax, %edx
	movl	-12(%ebp), %eax
	movl	_memman+8(,%eax,8), %eax
	cmpl	%eax, %edx
	jne	L20
	movl	-12(%ebp), %eax
	movl	8(%ebp), %edx
	movl	%edx, _memman+8(,%eax,8)
	movl	-12(%ebp), %eax
	movl	_memman+12(,%eax,8), %edx
	movl	12(%ebp), %eax
	addl	%eax, %edx
	movl	-12(%ebp), %eax
	movl	%edx, _memman+12(,%eax,8)
	jmp	L10
L20:
	movl	_memman, %eax
	cmpl	$999, %eax
	jg	L21
	movl	_memman, %eax
	movl	%eax, -16(%ebp)
	jmp	L22
L23:
	movl	-16(%ebp), %eax
	subl	$1, %eax
	movl	-16(%ebp), %ecx
	movl	_memman+12(,%eax,8), %edx
	movl	_memman+8(,%eax,8), %eax
	movl	%eax, _memman+8(,%ecx,8)
	movl	%edx, _memman+12(,%ecx,8)
	subl	$1, -16(%ebp)
L22:
	cmpl	$0, -16(%ebp)
	jne	L23
	movl	_memman, %eax
	addl	$1, %eax
	movl	%eax, _memman
	movl	_memman+4, %edx
	movl	_memman, %eax
	cmpl	%eax, %edx
	jge	L24
	movl	_memman, %eax
	movl	%eax, _memman+4
L24:
	movl	-12(%ebp), %eax
	movl	8(%ebp), %edx
	movl	%edx, _memman+8(,%eax,8)
	movl	-12(%ebp), %eax
	movl	12(%ebp), %edx
	movl	%edx, _memman+12(,%eax,8)
	jmp	L10
L21:
	movl	$LC1, (%esp)
	call	_fatal_a
	jmp	L10
L26:
	nop
L10:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE2:
	.globl	_shtctl_init
	.def	_shtctl_init;	.scl	2;	.type	32;	.endef
_shtctl_init:
LFB3:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	$38932, (%esp)
	call	_memman_alloc
	movl	%eax, -16(%ebp)
	movl	_binfo, %eax
	movl	8(%eax), %edx
	movl	-16(%ebp), %eax
	movl	%edx, (%eax)
	movl	_binfo, %eax
	movzwl	4(%eax), %eax
	movswl	%ax, %edx
	movl	_binfo, %eax
	movzwl	6(%eax), %eax
	cwtl
	imull	%edx, %eax
	addl	%eax, %eax
	movl	%eax, (%esp)
	call	_memman_alloc
	movl	%eax, %edx
	movl	-16(%ebp), %eax
	movl	%edx, 4(%eax)
	movl	_binfo, %eax
	movzwl	4(%eax), %eax
	movswl	%ax, %edx
	movl	-16(%ebp), %eax
	movl	%edx, 8(%eax)
	movl	_binfo, %eax
	movzwl	6(%eax), %eax
	movswl	%ax, %edx
	movl	-16(%ebp), %eax
	movl	%edx, 12(%eax)
	movl	-16(%ebp), %eax
	movl	$-1, 16(%eax)
	movl	$0, -12(%ebp)
	jmp	L28
L29:
	movl	-16(%ebp), %edx
	movl	-12(%ebp), %eax
	imull	$148, %eax, %eax
	addl	%edx, %eax
	addl	$1076, %eax
	movl	$0, (%eax)
	addl	$1, -12(%ebp)
L28:
	cmpl	$255, -12(%ebp)
	jle	L29
	movl	-16(%ebp), %eax
	movl	%eax, _shtctl
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE3:
	.data
LC2:
	.ascii "*** sheet table area nothing\12\0"
	.text
	.globl	_sheet_alloc
	.def	_sheet_alloc;	.scl	2;	.type	32;	.endef
_sheet_alloc:
LFB4:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$56, %esp
	movl	$0, -12(%ebp)
	jmp	L31
L34:
	movl	_shtctl, %edx
	movl	-12(%ebp), %eax
	imull	$148, %eax, %eax
	addl	%edx, %eax
	addl	$1076, %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	jne	L32
	movl	_shtctl, %edx
	movl	-12(%ebp), %eax
	imull	$148, %eax, %eax
	addl	$1040, %eax
	addl	%edx, %eax
	addl	$4, %eax
	movl	%eax, -16(%ebp)
	movl	-16(%ebp), %eax
	movl	$1, 32(%eax)
	movl	-16(%ebp), %eax
	movl	-12(%ebp), %edx
	movl	%edx, 4(%eax)
	movl	-16(%ebp), %eax
	movl	$-1, 28(%eax)
	movl	8(%ebp), %eax
	imull	12(%ebp), %eax
	movl	%eax, (%esp)
	call	_memman_alloc
	movl	%eax, %edx
	movl	-16(%ebp), %eax
	movl	%edx, (%eax)
	movl	-16(%ebp), %eax
	movl	8(%ebp), %edx
	movl	%edx, 8(%eax)
	movl	-16(%ebp), %eax
	movl	12(%ebp), %edx
	movl	%edx, 12(%eax)
	movl	-16(%ebp), %eax
	movl	16(%ebp), %edx
	movl	%edx, 24(%eax)
	movl	-16(%ebp), %eax
	movl	$0, 144(%eax)
	movl	-16(%ebp), %eax
	movl	$0, 36(%eax)
	movl	-16(%ebp), %eax
	movl	$0, 40(%eax)
	movl	-16(%ebp), %eax
	movl	$0, 52(%eax)
	movl	-16(%ebp), %eax
	movl	$7, 56(%eax)
	movl	-16(%ebp), %eax
	movl	$0, 60(%eax)
	movl	-16(%ebp), %eax
	movl	$0, 64(%eax)
	movl	-16(%ebp), %eax
	movl	$0, 68(%eax)
	movl	-16(%ebp), %eax
	movl	$0, 80(%eax)
	movl	-16(%ebp), %eax
	movl	$8, 84(%eax)
	movl	-16(%ebp), %eax
	movl	$0, 88(%eax)
	movl	-16(%ebp), %eax
	movl	(%eax), %eax
	movl	$8, 20(%esp)
	movl	$7, 16(%esp)
	movl	$0, 12(%esp)
	movl	12(%ebp), %edx
	movl	%edx, 8(%esp)
	movl	8(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	_init_screen8
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	_select_main_disp
	movl	-16(%ebp), %eax
	jmp	L33
L32:
	addl	$1, -12(%ebp)
L31:
	cmpl	$255, -12(%ebp)
	jle	L34
	movl	$LC2, (%esp)
	call	_fatal_a
	movl	$0, %eax
L33:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE4:
	.globl	_sheet_slide
	.def	_sheet_slide;	.scl	2;	.type	32;	.endef
_sheet_slide:
LFB5:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	call	_io_load_eflags
	movl	%eax, -12(%ebp)
	cmpl	$0, 12(%ebp)
	js	L40
	movl	8(%ebp), %eax
	movl	8(%eax), %edx
	movl	12(%ebp), %eax
	addl	%eax, %edx
	movl	_shtctl, %eax
	movl	8(%eax), %eax
	cmpl	%eax, %edx
	jg	L40
	cmpl	$0, 16(%ebp)
	js	L40
	movl	8(%ebp), %eax
	movl	12(%eax), %edx
	movl	16(%ebp), %eax
	addl	%eax, %edx
	movl	_shtctl, %eax
	movl	12(%eax), %eax
	cmpl	%eax, %edx
	jg	L40
	call	_disable_interrupt
	movl	8(%ebp), %eax
	movl	12(%ebp), %edx
	movl	%edx, 16(%eax)
	movl	8(%ebp), %eax
	movl	16(%ebp), %edx
	movl	%edx, 20(%eax)
	movl	8(%ebp), %eax
	movl	28(%eax), %eax
	testl	%eax, %eax
	js	L39
	call	_sheet_refresh
	call	_sheet_refreshmap
L39:
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	_io_store_eflags
	jmp	L35
L40:
	nop
L35:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE5:
	.globl	_select_main_disp
	.def	_select_main_disp;	.scl	2;	.type	32;	.endef
_select_main_disp:
LFB6:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	call	_io_load_eflags
	movl	%eax, -12(%ebp)
	call	_disable_interrupt
	movl	8(%ebp), %eax
	movl	$1, 124(%eax)
	movl	8(%ebp), %eax
	movl	$1, 128(%eax)
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	leal	-2(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 132(%eax)
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	leal	-23(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 136(%eax)
	movl	8(%ebp), %eax
	movl	132(%eax), %ecx
	movl	$715827883, %edx
	movl	%ecx, %eax
	imull	%edx
	movl	%edx, %eax
	sarl	%eax
	sarl	$31, %ecx
	subl	%ecx, %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movl	%edx, 116(%eax)
	movl	8(%ebp), %eax
	movl	136(%eax), %eax
	leal	15(%eax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$4, %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movl	%edx, 120(%eax)
	movl	8(%ebp), %eax
	movl	$1, 140(%eax)
	movl	8(%ebp), %eax
	leal	36(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 92(%eax)
	movl	8(%ebp), %eax
	leal	40(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 96(%eax)
	movl	8(%ebp), %eax
	leal	44(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 100(%eax)
	movl	8(%ebp), %eax
	leal	52(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 104(%eax)
	movl	8(%ebp), %eax
	leal	56(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 108(%eax)
	movl	8(%ebp), %eax
	leal	60(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 112(%eax)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	_io_store_eflags
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE6:
	.globl	_select_sub_disp
	.def	_select_sub_disp;	.scl	2;	.type	32;	.endef
_select_sub_disp:
LFB7:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	call	_io_load_eflags
	movl	%eax, -12(%ebp)
	call	_disable_interrupt
	movl	8(%ebp), %eax
	movl	$1, 124(%eax)
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	leal	-21(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 128(%eax)
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	leal	-2(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 132(%eax)
	movl	8(%ebp), %eax
	movl	$20, 136(%eax)
	movl	8(%ebp), %eax
	movl	132(%eax), %ecx
	movl	$715827883, %edx
	movl	%ecx, %eax
	imull	%edx
	movl	%edx, %eax
	sarl	%eax
	sarl	$31, %ecx
	subl	%ecx, %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movl	%edx, 116(%eax)
	movl	8(%ebp), %eax
	movl	136(%eax), %eax
	leal	15(%eax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$4, %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movl	%edx, 120(%eax)
	movl	8(%ebp), %eax
	movl	$0, 140(%eax)
	movl	8(%ebp), %eax
	leal	64(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 92(%eax)
	movl	8(%ebp), %eax
	leal	68(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 96(%eax)
	movl	8(%ebp), %eax
	leal	72(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 100(%eax)
	movl	8(%ebp), %eax
	leal	80(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 104(%eax)
	movl	8(%ebp), %eax
	leal	84(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 108(%eax)
	movl	8(%ebp), %eax
	leal	88(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 112(%eax)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	_io_store_eflags
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE7:
	.globl	_sheet_refresh
	.def	_sheet_refresh;	.scl	2;	.type	32;	.endef
_sheet_refresh:
LFB8:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$88, %esp
	movl	_shtctl, %eax
	movl	(%eax), %eax
	movl	%eax, -32(%ebp)
	call	_io_load_eflags
	movl	%eax, -36(%ebp)
	movl	_shtctl, %eax
	movl	4(%eax), %eax
	movl	%eax, -40(%ebp)
	call	_disable_interrupt
	call	_sheet_refreshmap
	movl	_shtctl, %eax
	addl	$1044, %eax
	movl	%eax, -44(%ebp)
	movl	$0, -28(%ebp)
	jmp	L44
L50:
	movl	-44(%ebp), %eax
	movl	20(%eax), %edx
	movl	-28(%ebp), %eax
	subl	%edx, %eax
	movl	%eax, -20(%ebp)
	movl	$0, -24(%ebp)
	jmp	L45
L49:
	movl	-44(%ebp), %eax
	movl	16(%eax), %edx
	movl	-24(%ebp), %eax
	subl	%edx, %eax
	movl	%eax, -16(%ebp)
	movl	_shtctl, %eax
	movl	8(%eax), %eax
	imull	-28(%ebp), %eax
	movl	%eax, %edx
	movl	-24(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, -56(%ebp)
	cmpl	$0, -16(%ebp)
	js	L46
	movl	-44(%ebp), %eax
	movl	8(%eax), %eax
	cmpl	%eax, -16(%ebp)
	jge	L46
	cmpl	$0, -20(%ebp)
	js	L46
	movl	-44(%ebp), %eax
	movl	12(%eax), %eax
	cmpl	%eax, -20(%ebp)
	jl	L47
L46:
	movl	-56(%ebp), %edx
	movl	-32(%ebp), %eax
	addl	%edx, %eax
	movb	$7, (%eax)
	jmp	L48
L47:
	movl	-56(%ebp), %eax
	leal	(%eax,%eax), %edx
	movl	-40(%ebp), %eax
	addl	%edx, %eax
	movzwl	(%eax), %eax
	testw	%ax, %ax
	jne	L48
	movl	-44(%ebp), %eax
	movl	(%eax), %edx
	movl	-44(%ebp), %eax
	movl	8(%eax), %eax
	imull	-20(%ebp), %eax
	movl	%eax, %ecx
	movl	-16(%ebp), %eax
	addl	%ecx, %eax
	addl	%edx, %eax
	movl	-56(%ebp), %ecx
	movl	-32(%ebp), %edx
	addl	%ecx, %edx
	movzbl	(%eax), %eax
	movb	%al, (%edx)
L48:
	addl	$1, -24(%ebp)
L45:
	movl	_shtctl, %eax
	movl	8(%eax), %eax
	cmpl	%eax, -24(%ebp)
	jl	L49
	addl	$1, -28(%ebp)
L44:
	movl	_shtctl, %eax
	movl	12(%eax), %eax
	cmpl	%eax, -28(%ebp)
	jl	L50
	movl	$0, -12(%ebp)
	jmp	L51
L57:
	movl	_shtctl, %eax
	movl	-12(%ebp), %edx
	addl	$4, %edx
	movl	4(%eax,%edx,4), %eax
	movl	%eax, -44(%ebp)
	movl	-44(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -48(%ebp)
	movl	-44(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, -52(%ebp)
	movl	$0, -20(%ebp)
	jmp	L52
L56:
	movl	-44(%ebp), %eax
	movl	20(%eax), %edx
	movl	-20(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, -28(%ebp)
	movl	$0, -16(%ebp)
	jmp	L53
L55:
	movl	-44(%ebp), %eax
	movl	16(%eax), %edx
	movl	-16(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, -24(%ebp)
	movl	_shtctl, %eax
	movl	8(%eax), %eax
	imull	-28(%ebp), %eax
	movl	%eax, %edx
	movl	-24(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, -56(%ebp)
	movl	-56(%ebp), %eax
	leal	(%eax,%eax), %edx
	movl	-40(%ebp), %eax
	addl	%edx, %eax
	movzwl	(%eax), %eax
	movzwl	%ax, %eax
	cmpl	%eax, -52(%ebp)
	jne	L54
	movl	-44(%ebp), %eax
	movl	8(%eax), %eax
	imull	-20(%ebp), %eax
	movl	%eax, %edx
	movl	-16(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, %edx
	movl	-48(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	movb	%al, -57(%ebp)
	movzbl	-57(%ebp), %edx
	movl	-44(%ebp), %eax
	movl	24(%eax), %eax
	cmpl	%eax, %edx
	je	L54
	movl	-56(%ebp), %edx
	movl	-32(%ebp), %eax
	addl	%eax, %edx
	movzbl	-57(%ebp), %eax
	movb	%al, (%edx)
L54:
	addl	$1, -16(%ebp)
L53:
	movl	-44(%ebp), %eax
	movl	8(%eax), %eax
	cmpl	%eax, -16(%ebp)
	jl	L55
	addl	$1, -20(%ebp)
L52:
	movl	-44(%ebp), %eax
	movl	12(%eax), %eax
	cmpl	%eax, -20(%ebp)
	jl	L56
	addl	$1, -12(%ebp)
L51:
	movl	_shtctl, %eax
	movl	16(%eax), %eax
	cmpl	%eax, -12(%ebp)
	jle	L57
	call	_sheet_top_disp
	movl	-36(%ebp), %eax
	movl	%eax, (%esp)
	call	_io_store_eflags
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE8:
	.globl	_sheet_refreshsub
	.def	_sheet_refreshsub;	.scl	2;	.type	32;	.endef
_sheet_refreshsub:
LFB9:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$72, %esp
	call	_io_load_eflags
	movl	%eax, -20(%ebp)
	cmpl	$0, 8(%ebp)
	je	L68
	call	_disable_interrupt
	movl	_shtctl, %eax
	movl	(%eax), %eax
	movl	%eax, -24(%ebp)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -28(%ebp)
	movl	_shtctl, %eax
	movl	4(%eax), %eax
	movl	%eax, -32(%ebp)
	movl	8(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, -36(%ebp)
	movl	$0, -16(%ebp)
	jmp	L61
L65:
	movl	8(%ebp), %eax
	movl	20(%eax), %edx
	movl	-16(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, -44(%ebp)
	movl	$0, -12(%ebp)
	jmp	L62
L64:
	movl	8(%ebp), %eax
	movl	16(%eax), %edx
	movl	-12(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, -48(%ebp)
	movl	_shtctl, %eax
	movl	8(%eax), %eax
	imull	-44(%ebp), %eax
	movl	%eax, %edx
	movl	-48(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, -52(%ebp)
	movl	-52(%ebp), %eax
	leal	(%eax,%eax), %edx
	movl	-32(%ebp), %eax
	addl	%edx, %eax
	movzwl	(%eax), %eax
	movzwl	%ax, %eax
	cmpl	%eax, -36(%ebp)
	jne	L63
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	imull	-16(%ebp), %eax
	movl	%eax, %edx
	movl	-12(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, %edx
	movl	-28(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	movb	%al, -53(%ebp)
	movzbl	-53(%ebp), %edx
	movl	8(%ebp), %eax
	movl	24(%eax), %eax
	cmpl	%eax, %edx
	je	L63
	movl	-52(%ebp), %edx
	movl	-24(%ebp), %eax
	addl	%eax, %edx
	movzbl	-53(%ebp), %eax
	movb	%al, (%edx)
L63:
	addl	$1, -12(%ebp)
L62:
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	cmpl	%eax, -12(%ebp)
	jl	L64
	addl	$1, -16(%ebp)
L61:
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	cmpl	%eax, -16(%ebp)
	jl	L65
	movl	_shtctl, %eax
	movl	16(%eax), %eax
	movl	%eax, -40(%ebp)
	cmpl	$0, -40(%ebp)
	jns	L66
	movl	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	_io_store_eflags
	jmp	L58
L66:
	movl	_shtctl, %eax
	movl	-40(%ebp), %edx
	addl	$4, %edx
	movl	4(%eax,%edx,4), %eax
	cmpl	%eax, 8(%ebp)
	jne	L67
	call	_sheet_top_disp
L67:
	movl	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	_io_store_eflags
	jmp	L58
L68:
	nop
L58:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE9:
	.globl	_sheet_top_disp
	.def	_sheet_top_disp;	.scl	2;	.type	32;	.endef
_sheet_top_disp:
LFB10:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$72, %esp
	call	_io_load_eflags
	movl	%eax, -12(%ebp)
	movl	_shtctl, %eax
	movl	(%eax), %eax
	movl	%eax, -16(%ebp)
	movl	_shtctl, %eax
	movl	16(%eax), %eax
	movl	%eax, -20(%ebp)
	cmpl	$0, -20(%ebp)
	js	L72
	call	_disable_interrupt
	movl	_shtctl, %eax
	movl	-20(%ebp), %edx
	addl	$4, %edx
	movl	4(%eax,%edx,4), %eax
	movl	%eax, -24(%ebp)
	movl	-24(%ebp), %eax
	movl	16(%eax), %eax
	movl	%eax, -28(%ebp)
	movl	-24(%ebp), %eax
	movl	16(%eax), %edx
	movl	-24(%ebp), %eax
	movl	8(%eax), %eax
	addl	%edx, %eax
	subl	$1, %eax
	movl	%eax, -32(%ebp)
	movl	-24(%ebp), %eax
	movl	20(%eax), %eax
	movl	%eax, -36(%ebp)
	movl	-24(%ebp), %eax
	movl	20(%eax), %edx
	movl	-24(%ebp), %eax
	movl	12(%eax), %eax
	addl	%edx, %eax
	subl	$1, %eax
	movl	%eax, -40(%ebp)
	movl	_shtctl, %eax
	movl	8(%eax), %eax
	movl	-40(%ebp), %edx
	movl	%edx, 24(%esp)
	movl	-28(%ebp), %edx
	movl	%edx, 20(%esp)
	movl	-36(%ebp), %edx
	movl	%edx, 16(%esp)
	movl	-28(%ebp), %edx
	movl	%edx, 12(%esp)
	movl	$1, 8(%esp)
	movl	%eax, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	_boxfill8
	movl	_shtctl, %eax
	movl	8(%eax), %eax
	movl	-36(%ebp), %edx
	movl	%edx, 24(%esp)
	movl	-32(%ebp), %edx
	movl	%edx, 20(%esp)
	movl	-36(%ebp), %edx
	movl	%edx, 16(%esp)
	movl	-28(%ebp), %edx
	movl	%edx, 12(%esp)
	movl	$1, 8(%esp)
	movl	%eax, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	_boxfill8
	movl	_shtctl, %eax
	movl	8(%eax), %eax
	movl	-40(%ebp), %edx
	movl	%edx, 24(%esp)
	movl	-32(%ebp), %edx
	movl	%edx, 20(%esp)
	movl	-40(%ebp), %edx
	movl	%edx, 16(%esp)
	movl	-28(%ebp), %edx
	movl	%edx, 12(%esp)
	movl	$1, 8(%esp)
	movl	%eax, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	_boxfill8
	movl	_shtctl, %eax
	movl	8(%eax), %eax
	movl	-40(%ebp), %edx
	movl	%edx, 24(%esp)
	movl	-32(%ebp), %edx
	movl	%edx, 20(%esp)
	movl	-36(%ebp), %edx
	movl	%edx, 16(%esp)
	movl	-32(%ebp), %edx
	movl	%edx, 12(%esp)
	movl	$1, 8(%esp)
	movl	%eax, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	_boxfill8
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	_io_store_eflags
	jmp	L69
L72:
	nop
L69:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE10:
	.globl	_sheet_refreshmap
	.def	_sheet_refreshmap;	.scl	2;	.type	32;	.endef
_sheet_refreshmap:
LFB11:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$72, %esp
	call	_io_load_eflags
	movl	%eax, -28(%ebp)
	movl	$0, -12(%ebp)
	jmp	L74
L75:
	movl	_shtctl, %eax
	movl	4(%eax), %edx
	movl	-12(%ebp), %eax
	addl	%eax, %eax
	addl	%edx, %eax
	movw	$0, (%eax)
	addl	$1, -12(%ebp)
L74:
	movl	_binfo, %eax
	movzwl	4(%eax), %eax
	movswl	%ax, %edx
	movl	_binfo, %eax
	movzwl	6(%eax), %eax
	cwtl
	imull	%edx, %eax
	cmpl	%eax, -12(%ebp)
	jl	L75
	call	_disable_interrupt
	movl	$0, -16(%ebp)
	jmp	L76
L81:
	movl	_shtctl, %eax
	movl	-16(%ebp), %edx
	addl	$4, %edx
	movl	4(%eax,%edx,4), %eax
	movl	%eax, -32(%ebp)
	movl	_shtctl, %eax
	movl	4(%eax), %eax
	movl	%eax, -36(%ebp)
	movl	-32(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, -40(%ebp)
	movl	$0, -24(%ebp)
	jmp	L77
L80:
	movl	-32(%ebp), %eax
	movl	20(%eax), %edx
	movl	-24(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, -44(%ebp)
	movl	$0, -20(%ebp)
	jmp	L78
L79:
	movl	-32(%ebp), %eax
	movl	16(%eax), %edx
	movl	-20(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, -48(%ebp)
	movl	_shtctl, %eax
	movl	8(%eax), %eax
	imull	-44(%ebp), %eax
	movl	%eax, %edx
	movl	-48(%ebp), %eax
	addl	%edx, %eax
	leal	(%eax,%eax), %edx
	movl	-36(%ebp), %eax
	addl	%edx, %eax
	movl	-40(%ebp), %edx
	movw	%dx, (%eax)
	addl	$1, -20(%ebp)
L78:
	movl	-32(%ebp), %eax
	movl	8(%eax), %eax
	cmpl	%eax, -20(%ebp)
	jl	L79
	addl	$1, -24(%ebp)
L77:
	movl	-32(%ebp), %eax
	movl	12(%eax), %eax
	cmpl	%eax, -24(%ebp)
	jl	L80
	addl	$1, -16(%ebp)
L76:
	movl	_shtctl, %eax
	movl	16(%eax), %eax
	cmpl	%eax, -16(%ebp)
	jle	L81
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	_io_store_eflags
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE11:
	.globl	_sheet_free
	.def	_sheet_free;	.scl	2;	.type	32;	.endef
_sheet_free:
LFB12:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	call	_io_load_eflags
	movl	%eax, -12(%ebp)
	call	_disable_interrupt
	movl	8(%ebp), %eax
	movl	28(%eax), %eax
	testl	%eax, %eax
	js	L83
	movl	$-1, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_sheet_updown
L83:
	movl	8(%ebp), %eax
	movl	$0, 32(%eax)
	movl	8(%ebp), %eax
	movl	8(%eax), %edx
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	imull	%edx, %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	_memman_free
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	_io_store_eflags
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE12:
	.globl	_sheet_updown
	.def	_sheet_updown;	.scl	2;	.type	32;	.endef
_sheet_updown:
LFB13:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%ebx
	subl	$36, %esp
	.cfi_offset 3, -12
	movl	8(%ebp), %eax
	movl	28(%eax), %eax
	movl	%eax, -16(%ebp)
	call	_io_load_eflags
	movl	%eax, -20(%ebp)
	call	_disable_interrupt
	movl	_shtctl, %eax
	movl	16(%eax), %eax
	addl	$1, %eax
	cmpl	%eax, 12(%ebp)
	jle	L85
	movl	_shtctl, %eax
	movl	16(%eax), %eax
	addl	$1, %eax
	movl	%eax, 12(%ebp)
L85:
	cmpl	$-1, 12(%ebp)
	jge	L86
	movl	$-1, 12(%ebp)
L86:
	movl	8(%ebp), %eax
	movl	12(%ebp), %edx
	movl	%edx, 28(%eax)
	movl	-16(%ebp), %eax
	cmpl	12(%ebp), %eax
	jle	L87
	cmpl	$0, 12(%ebp)
	js	L88
	movl	-16(%ebp), %eax
	movl	%eax, -12(%ebp)
	jmp	L89
L90:
	movl	_shtctl, %edx
	movl	-12(%ebp), %eax
	leal	-1(%eax), %ecx
	movl	_shtctl, %eax
	addl	$4, %ecx
	movl	4(%edx,%ecx,4), %edx
	movl	-12(%ebp), %ecx
	addl	$4, %ecx
	movl	%edx, 4(%eax,%ecx,4)
	movl	_shtctl, %eax
	movl	-12(%ebp), %edx
	addl	$4, %edx
	movl	4(%eax,%edx,4), %eax
	movl	-12(%ebp), %edx
	movl	%edx, 28(%eax)
	subl	$1, -12(%ebp)
L89:
	movl	-12(%ebp), %eax
	cmpl	12(%ebp), %eax
	jg	L90
	movl	_shtctl, %eax
	movl	12(%ebp), %edx
	leal	4(%edx), %ecx
	movl	8(%ebp), %edx
	movl	%edx, 4(%eax,%ecx,4)
	jmp	L91
L88:
	movl	_shtctl, %eax
	movl	16(%eax), %eax
	cmpl	%eax, -16(%ebp)
	jge	L92
	movl	-16(%ebp), %eax
	movl	%eax, -12(%ebp)
	jmp	L93
L94:
	movl	_shtctl, %edx
	movl	-12(%ebp), %eax
	leal	1(%eax), %ecx
	movl	_shtctl, %eax
	addl	$4, %ecx
	movl	4(%edx,%ecx,4), %edx
	movl	-12(%ebp), %ecx
	addl	$4, %ecx
	movl	%edx, 4(%eax,%ecx,4)
	movl	_shtctl, %eax
	movl	-12(%ebp), %edx
	addl	$4, %edx
	movl	4(%eax,%edx,4), %eax
	movl	-12(%ebp), %edx
	movl	%edx, 28(%eax)
	addl	$1, -12(%ebp)
L93:
	movl	_shtctl, %eax
	movl	16(%eax), %eax
	cmpl	%eax, -12(%ebp)
	jl	L94
L92:
	movl	_shtctl, %eax
	movl	16(%eax), %edx
	subl	$1, %edx
	movl	%edx, 16(%eax)
L91:
	call	_sheet_refresh
	call	_sheet_refreshmap
	jmp	L95
L87:
	movl	-16(%ebp), %eax
	cmpl	12(%ebp), %eax
	jge	L95
	cmpl	$0, -16(%ebp)
	js	L96
	movl	-16(%ebp), %eax
	movl	%eax, -12(%ebp)
	jmp	L97
L98:
	movl	_shtctl, %edx
	movl	-12(%ebp), %eax
	leal	1(%eax), %ecx
	movl	_shtctl, %eax
	addl	$4, %ecx
	movl	4(%edx,%ecx,4), %edx
	movl	-12(%ebp), %ecx
	addl	$4, %ecx
	movl	%edx, 4(%eax,%ecx,4)
	movl	_shtctl, %eax
	movl	-12(%ebp), %edx
	addl	$4, %edx
	movl	4(%eax,%edx,4), %eax
	movl	-12(%ebp), %edx
	movl	%edx, 28(%eax)
	addl	$1, -12(%ebp)
L97:
	movl	-12(%ebp), %eax
	cmpl	12(%ebp), %eax
	jl	L98
	movl	_shtctl, %eax
	movl	12(%ebp), %edx
	leal	4(%edx), %ecx
	movl	8(%ebp), %edx
	movl	%edx, 4(%eax,%ecx,4)
	jmp	L99
L96:
	movl	_shtctl, %eax
	movl	16(%eax), %eax
	movl	%eax, -12(%ebp)
	jmp	L100
L101:
	movl	_shtctl, %edx
	movl	_shtctl, %eax
	movl	-12(%ebp), %ecx
	leal	1(%ecx), %ebx
	movl	-12(%ebp), %ecx
	addl	$4, %ecx
	movl	4(%edx,%ecx,4), %edx
	leal	4(%ebx), %ecx
	movl	%edx, 4(%eax,%ecx,4)
	movl	_shtctl, %eax
	movl	-12(%ebp), %edx
	addl	$1, %edx
	addl	$4, %edx
	movl	4(%eax,%edx,4), %eax
	movl	-12(%ebp), %edx
	addl	$1, %edx
	movl	%edx, 28(%eax)
	subl	$1, -12(%ebp)
L100:
	movl	-12(%ebp), %eax
	cmpl	12(%ebp), %eax
	jge	L101
	movl	_shtctl, %eax
	movl	12(%ebp), %edx
	leal	4(%edx), %ecx
	movl	8(%ebp), %edx
	movl	%edx, 4(%eax,%ecx,4)
	movl	_shtctl, %eax
	movl	16(%eax), %edx
	addl	$1, %edx
	movl	%edx, 16(%eax)
L99:
	call	_sheet_refresh
	call	_sheet_refreshmap
L95:
	movl	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	_io_store_eflags
	nop
	movl	-4(%ebp), %ebx
	leave
	.cfi_restore 5
	.cfi_restore 3
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE13:
	.data
LC3:
	.ascii "\12      \0"
LC4:
	.ascii "\12SHIFT \0"
LC5:
	.ascii "\12CNTL  \0"
LC6:
	.ascii "\12ALT   \0"
LC7:
	.ascii "\12HATA  \0"
LC8:
	.ascii "\12MARU  \0"
	.text
	.globl	_sheet_resize
	.def	_sheet_resize;	.scl	2;	.type	32;	.endef
_sheet_resize:
LFB14:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$56, %esp
	call	_io_load_eflags
	movl	%eax, -12(%ebp)
	call	_disable_interrupt
	cmpl	$19, 12(%ebp)
	jg	L103
	movl	$20, 12(%ebp)
L103:
	cmpl	$49, 16(%ebp)
	jg	L104
	movl	$50, 16(%ebp)
L104:
	movl	8(%ebp), %eax
	movl	16(%eax), %edx
	movl	12(%ebp), %eax
	addl	%eax, %edx
	movl	_shtctl, %eax
	movl	8(%eax), %eax
	cmpl	%eax, %edx
	jle	L105
	movl	_shtctl, %eax
	movl	8(%eax), %edx
	movl	8(%ebp), %eax
	movl	16(%eax), %ecx
	movl	%edx, %eax
	subl	%ecx, %eax
	movl	%eax, 12(%ebp)
L105:
	movl	8(%ebp), %eax
	movl	20(%eax), %edx
	movl	16(%ebp), %eax
	addl	%eax, %edx
	movl	_shtctl, %eax
	movl	12(%eax), %eax
	cmpl	%eax, %edx
	jle	L106
	movl	_shtctl, %eax
	movl	12(%eax), %edx
	movl	8(%ebp), %eax
	movl	20(%eax), %ecx
	movl	%edx, %eax
	subl	%ecx, %eax
	movl	%eax, 16(%ebp)
L106:
	movl	8(%ebp), %eax
	movl	8(%eax), %edx
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	imull	%edx, %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	_memman_free
	movl	8(%ebp), %eax
	movl	12(%ebp), %edx
	movl	%edx, 8(%eax)
	movl	8(%ebp), %eax
	movl	16(%ebp), %edx
	movl	%edx, 12(%eax)
	movl	8(%ebp), %eax
	movl	$0, 68(%eax)
	movl	8(%ebp), %eax
	movl	68(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 64(%eax)
	movl	8(%ebp), %eax
	movl	64(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 40(%eax)
	movl	8(%ebp), %eax
	movl	40(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 36(%eax)
	movl	12(%ebp), %eax
	imull	16(%ebp), %eax
	movl	%eax, (%esp)
	call	_memman_alloc
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movl	%edx, (%eax)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	$8, 20(%esp)
	movl	$7, 16(%esp)
	movl	$0, 12(%esp)
	movl	16(%ebp), %edx
	movl	%edx, 8(%esp)
	movl	12(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	_init_screen8
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_select_sub_disp
	movl	8(%ebp), %eax
	movl	144(%eax), %eax
	cmpl	$5, %eax
	ja	L107
	movl	L109(,%eax,4), %eax
	jmp	*%eax
	.data
	.align 4
L109:
	.long	L114
	.long	L113
	.long	L112
	.long	L111
	.long	L110
	.long	L108
	.text
L114:
	movl	$LC3, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_printf
	jmp	L107
L113:
	movl	$LC4, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_printf
	jmp	L107
L112:
	movl	$LC5, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_printf
	jmp	L107
L111:
	movl	$LC6, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_printf
	jmp	L107
L110:
	movl	$LC7, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_printf
	jmp	L107
L108:
	movl	$LC8, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_printf
	nop
L107:
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_select_main_disp
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	_io_store_eflags
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE14:
	.globl	_test_mado
	.def	_test_mado;	.scl	2;	.type	32;	.endef
_test_mado:
LFB15:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$56, %esp
	movl	$40000, (%esp)
	call	_memman_alloc
	movl	%eax, -12(%ebp)
	movl	$8, 20(%esp)
	movl	$7, 16(%esp)
	movl	$0, 12(%esp)
	movl	$200, 8(%esp)
	movl	$200, 4(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	_init_screen8
	movl	$4660, 8(%esp)
	movl	$200, 4(%esp)
	movl	$200, (%esp)
	call	_sheet_alloc
	movl	%eax, -16(%ebp)
	movl	$100, 8(%esp)
	movl	$200, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	_sheet_slide
	movl	$1000, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	_sheet_updown
	movl	$75000, (%esp)
	call	_memman_alloc
	movl	%eax, -12(%ebp)
	movl	$8, 20(%esp)
	movl	$7, 16(%esp)
	movl	$0, 12(%esp)
	movl	$250, 8(%esp)
	movl	$300, 4(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	_init_screen8
	movl	$4660, 8(%esp)
	movl	$250, 4(%esp)
	movl	$300, (%esp)
	call	_sheet_alloc
	movl	%eax, -20(%ebp)
	movl	$150, 8(%esp)
	movl	$250, 4(%esp)
	movl	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	_sheet_slide
	movl	$1000, 4(%esp)
	movl	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	_sheet_updown
	movl	-20(%ebp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE15:
	.ident	"GCC: (GNU) 10.2.0"
	.def	_memset;	.scl	2;	.type	32;	.endef
	.def	_fatal_a;	.scl	2;	.type	32;	.endef
	.def	_init_screen8;	.scl	2;	.type	32;	.endef
	.def	_io_load_eflags;	.scl	2;	.type	32;	.endef
	.def	_disable_interrupt;	.scl	2;	.type	32;	.endef
	.def	_io_store_eflags;	.scl	2;	.type	32;	.endef
	.def	_boxfill8;	.scl	2;	.type	32;	.endef
	.def	_ut_printf;	.scl	2;	.type	32;	.endef
