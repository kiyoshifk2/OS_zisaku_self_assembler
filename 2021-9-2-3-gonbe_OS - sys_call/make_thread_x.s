	.file	"make_thread.c"
	.text
	.globl	_make_sheet_and_thread
	.def	_make_sheet_and_thread;	.scl	2;	.type	32;	.endef
_make_sheet_and_thread:
LFB0:
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
	movl	$65535, 8(%esp)
	movl	20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	16(%ebp), %eax
	movl	%eax, (%esp)
	call	_sheet_alloc
	movl	12(%ebp), %edx
	movl	%eax, (%edx)
	movl	_shtctl, %eax
	movl	12(%eax), %eax
	subl	20(%ebp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	movl	%eax, %ecx
	movl	_shtctl, %eax
	movl	8(%eax), %eax
	subl	16(%ebp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	movl	%eax, %edx
	movl	12(%ebp), %eax
	movl	(%eax), %eax
	movl	%ecx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	_sheet_slide
	movl	12(%ebp), %eax
	movl	(%eax), %eax
	movl	$1000, 4(%esp)
	movl	%eax, (%esp)
	call	_sheet_updown
	call	_task_alloc
	movl	8(%ebp), %edx
	movl	%eax, (%edx)
	movl	24(%ebp), %eax
	movl	%eax, (%esp)
	call	_memman_alloc
	movl	24(%ebp), %edx
	addl	%edx, %eax
	leal	-12(%eax), %edx
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	%edx, 68(%eax)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	28(%ebp), %edx
	movl	%edx, 44(%eax)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	$8, 84(%eax)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	$16, 88(%eax)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	$8, 92(%eax)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	$8, 96(%eax)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	$8, 100(%eax)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	$8, 104(%eax)
	movl	12(%ebp), %eax
	movl	(%eax), %edx
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	68(%eax), %eax
	addl	$4, %eax
	movl	%edx, (%eax)
	movl	8(%ebp), %eax
	movl	(%eax), %edx
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	68(%eax), %eax
	addl	$8, %eax
	movl	%edx, (%eax)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	32(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	_task_run
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	_io_store_eflags
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE0:
	.ident	"GCC: (GNU) 10.2.0"
	.def	_io_load_eflags;	.scl	2;	.type	32;	.endef
	.def	_disable_interrupt;	.scl	2;	.type	32;	.endef
	.def	_sheet_alloc;	.scl	2;	.type	32;	.endef
	.def	_sheet_slide;	.scl	2;	.type	32;	.endef
	.def	_sheet_updown;	.scl	2;	.type	32;	.endef
	.def	_task_alloc;	.scl	2;	.type	32;	.endef
	.def	_memman_alloc;	.scl	2;	.type	32;	.endef
	.def	_task_run;	.scl	2;	.type	32;	.endef
	.def	_io_store_eflags;	.scl	2;	.type	32;	.endef
