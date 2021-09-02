	.file	"delay_task.c"
	.text
	.data
	.align 4
LC0:
	.ascii "*** delay_task table area nothing\0"
	.text
	.globl	_delay_task
	.def	_delay_task;	.scl	2;	.type	32;	.endef
_delay_task:
LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	call	_io_load_eflags
	movl	%eax, -16(%ebp)
	call	_disable_interrupt
	movl	_taskctl, %edx
	movl	_taskctl, %eax
	movl	4(%eax), %eax
	imull	$408, %eax, %eax
	addl	$16, %eax
	addl	%edx, %eax
	movl	%eax, -20(%ebp)
	movl	-20(%ebp), %eax
	movl	4(%eax), %edx
	movl	-20(%ebp), %eax
	movl	8(%eax,%edx,4), %eax
	movl	%eax, -24(%ebp)
	movl	$0, -12(%ebp)
	jmp	L2
L5:
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	addl	$_timerctl+20, %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	je	L7
	addl	$1, -12(%ebp)
L2:
	cmpl	$499, -12(%ebp)
	jle	L5
	jmp	L4
L7:
	nop
L4:
	cmpl	$500, -12(%ebp)
	jne	L6
	movl	$LC0, (%esp)
	call	_fatal_a
L6:
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	addl	$_timerctl+4, %eax
	movl	$0, (%eax)
	call	_GetTickCount
	movl	%eax, %edx
	movl	-12(%ebp), %ecx
	movl	%ecx, %eax
	sall	$2, %eax
	addl	%ecx, %eax
	sall	$2, %eax
	addl	$_timerctl+12, %eax
	movl	%edx, (%eax)
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	leal	_timerctl+16(%eax), %edx
	movl	8(%ebp), %eax
	movl	%eax, (%edx)
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	leal	_timerctl+8(%eax), %edx
	movl	-24(%ebp), %eax
	movl	%eax, (%edx)
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	addl	$_timerctl+20, %eax
	movl	$3, (%eax)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	_io_store_eflags
	movl	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	_task_sleep
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
	.def	_fatal_a;	.scl	2;	.type	32;	.endef
	.def	_GetTickCount;	.scl	2;	.type	32;	.endef
	.def	_io_store_eflags;	.scl	2;	.type	32;	.endef
	.def	_task_sleep;	.scl	2;	.type	32;	.endef
