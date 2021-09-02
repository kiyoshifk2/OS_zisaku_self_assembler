	.file	"mtask.c"
	.text
	.globl	_taskctl
	.bss
	.align 4
_taskctl:
	.space 4
	.text
	.globl	_task_now
	.def	_task_now;	.scl	2;	.type	32;	.endef
_task_now:
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
	movl	_taskctl, %edx
	movl	_taskctl, %eax
	movl	4(%eax), %eax
	imull	$408, %eax, %eax
	addl	$16, %eax
	addl	%edx, %eax
	movl	%eax, -16(%ebp)
	movl	-16(%ebp), %eax
	movl	4(%eax), %edx
	movl	-16(%ebp), %eax
	movl	8(%eax,%edx,4), %eax
	movl	%eax, -20(%ebp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	_io_store_eflags
	movl	-20(%ebp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE0:
	.globl	_task_add
	.def	_task_add;	.scl	2;	.type	32;	.endef
_task_add:
LFB1:
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
	movl	_taskctl, %edx
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	imull	$408, %eax, %eax
	addl	$16, %eax
	addl	%edx, %eax
	movl	%eax, -16(%ebp)
	movl	-16(%ebp), %eax
	movl	(%eax), %edx
	movl	-16(%ebp), %eax
	movl	8(%ebp), %ecx
	movl	%ecx, 8(%eax,%edx,4)
	movl	-16(%ebp), %eax
	movl	(%eax), %eax
	leal	1(%eax), %edx
	movl	-16(%ebp), %eax
	movl	%edx, (%eax)
	movl	8(%ebp), %eax
	movl	$2, 4(%eax)
	movl	_taskctl, %eax
	movl	$0, (%eax)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	_io_store_eflags
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE1:
	.globl	_task_remove
	.def	_task_remove;	.scl	2;	.type	32;	.endef
_task_remove:
LFB2:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	_taskctl, %edx
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	imull	$408, %eax, %eax
	addl	$16, %eax
	addl	%edx, %eax
	movl	%eax, -16(%ebp)
	movl	$0, -12(%ebp)
	jmp	L6
L9:
	movl	-16(%ebp), %eax
	movl	-12(%ebp), %edx
	movl	8(%eax,%edx,4), %eax
	cmpl	%eax, 8(%ebp)
	je	L18
	addl	$1, -12(%ebp)
L6:
	movl	-16(%ebp), %eax
	movl	(%eax), %eax
	cmpl	%eax, -12(%ebp)
	jl	L9
	jmp	L8
L18:
	nop
L8:
	movl	-16(%ebp), %eax
	movl	(%eax), %eax
	leal	-1(%eax), %edx
	movl	-16(%ebp), %eax
	movl	%edx, (%eax)
	movl	-16(%ebp), %eax
	movl	4(%eax), %eax
	cmpl	%eax, -12(%ebp)
	jge	L10
	movl	-16(%ebp), %eax
	movl	4(%eax), %eax
	leal	-1(%eax), %edx
	movl	-16(%ebp), %eax
	movl	%edx, 4(%eax)
L10:
	movl	-16(%ebp), %eax
	movl	4(%eax), %edx
	movl	-16(%ebp), %eax
	movl	(%eax), %eax
	cmpl	%eax, %edx
	jl	L11
	movl	-16(%ebp), %eax
	movl	$0, 4(%eax)
L11:
	movl	8(%ebp), %eax
	movl	$1, 4(%eax)
	jmp	L12
L13:
	movl	-12(%ebp), %eax
	leal	1(%eax), %edx
	movl	-16(%ebp), %eax
	movl	8(%eax,%edx,4), %ecx
	movl	-16(%ebp), %eax
	movl	-12(%ebp), %edx
	movl	%ecx, 8(%eax,%edx,4)
	addl	$1, -12(%ebp)
L12:
	movl	-16(%ebp), %eax
	movl	(%eax), %eax
	cmpl	%eax, -12(%ebp)
	jl	L13
	movl	-16(%ebp), %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	jne	L14
L17:
	call	_task_switchsub
	movl	_taskctl, %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	jne	L15
	movl	$1, %eax
	jmp	L16
L15:
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	_io_store_eflags
	call	_gonbe_hlt
	call	_disable_interrupt
	jmp	L17
L14:
	movl	$0, %eax
L16:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE2:
	.globl	_task_switchsub
	.def	_task_switchsub;	.scl	2;	.type	32;	.endef
_task_switchsub:
LFB3:
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
	movl	$0, -12(%ebp)
	jmp	L20
L23:
	movl	_taskctl, %edx
	movl	-12(%ebp), %eax
	imull	$408, %eax, %eax
	addl	%edx, %eax
	addl	$16, %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	jle	L21
	movl	_taskctl, %eax
	movl	$0, (%eax)
	jmp	L22
L21:
	addl	$1, -12(%ebp)
L20:
	cmpl	$9, -12(%ebp)
	jle	L23
L22:
	cmpl	$10, -12(%ebp)
	jne	L24
	movl	_taskctl, %eax
	movl	$1, (%eax)
L24:
	movl	_taskctl, %eax
	movl	-12(%ebp), %edx
	movl	%edx, 4(%eax)
	movl	_taskctl, %eax
	movb	$0, 8(%eax)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	_io_store_eflags
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE3:
	.globl	_task_init
	.def	_task_init;	.scl	2;	.type	32;	.endef
_task_init:
LFB4:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	$2555904, -16(%ebp)
	movl	$120096, (%esp)
	call	_memman_alloc
	movl	%eax, _taskctl
	movl	$0, -12(%ebp)
	jmp	L27
L28:
	movl	_taskctl, %edx
	movl	-12(%ebp), %eax
	imull	$116, %eax, %eax
	addl	%edx, %eax
	addl	$4100, %eax
	movl	$0, (%eax)
	movl	-12(%ebp), %eax
	addl	$4, %eax
	movl	_taskctl, %ecx
	leal	0(,%eax,8), %edx
	movl	-12(%ebp), %eax
	imull	$116, %eax, %eax
	addl	%ecx, %eax
	addl	$4096, %eax
	movl	%edx, (%eax)
	movl	_taskctl, %edx
	movl	-12(%ebp), %eax
	imull	$116, %eax, %eax
	addl	$4096, %eax
	addl	%edx, %eax
	addl	$12, %eax
	movl	%eax, %edx
	movl	-12(%ebp), %eax
	addl	$4, %eax
	leal	0(,%eax,8), %ecx
	movl	-16(%ebp), %eax
	addl	%ecx, %eax
	movl	$137, 12(%esp)
	movl	%edx, 8(%esp)
	movl	$103, 4(%esp)
	movl	%eax, (%esp)
	call	_set_segmdesc
	addl	$1, -12(%ebp)
L27:
	cmpl	$999, -12(%ebp)
	jle	L28
	movl	$0, -12(%ebp)
	jmp	L29
L30:
	movl	_taskctl, %edx
	movl	-12(%ebp), %eax
	imull	$408, %eax, %eax
	addl	%edx, %eax
	addl	$16, %eax
	movl	$0, (%eax)
	movl	_taskctl, %edx
	movl	-12(%ebp), %eax
	imull	$408, %eax, %eax
	addl	%edx, %eax
	addl	$20, %eax
	movl	$0, (%eax)
	addl	$1, -12(%ebp)
L29:
	cmpl	$9, -12(%ebp)
	jle	L30
	call	_task_alloc
	movl	%eax, -20(%ebp)
	movl	-20(%ebp), %eax
	movl	$2, 4(%eax)
	movl	_taskctl, %eax
	movl	$0, (%eax)
	movl	-20(%ebp), %eax
	movl	$0, 8(%eax)
	call	_task_switchsub
	movl	-20(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	_load_tr
	movl	-20(%ebp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE4:
	.data
LC0:
	.ascii "*** task_alloc table full\12\0"
	.text
	.globl	_task_alloc
	.def	_task_alloc;	.scl	2;	.type	32;	.endef
_task_alloc:
LFB5:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	$0, -12(%ebp)
	jmp	L33
L36:
	movl	_taskctl, %edx
	movl	-12(%ebp), %eax
	imull	$116, %eax, %eax
	addl	%edx, %eax
	addl	$4100, %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	jne	L34
	movl	_taskctl, %edx
	movl	-12(%ebp), %eax
	imull	$116, %eax, %eax
	addl	$4096, %eax
	addl	%edx, %eax
	movl	%eax, -16(%ebp)
	movl	-16(%ebp), %eax
	movl	$1, 4(%eax)
	movl	-16(%ebp), %eax
	movl	$514, 48(%eax)
	movl	-16(%ebp), %eax
	movl	$0, 52(%eax)
	movl	-16(%ebp), %eax
	movl	$0, 56(%eax)
	movl	-16(%ebp), %eax
	movl	$0, 60(%eax)
	movl	-16(%ebp), %eax
	movl	$0, 64(%eax)
	movl	-16(%ebp), %eax
	movl	$0, 72(%eax)
	movl	-16(%ebp), %eax
	movl	$0, 76(%eax)
	movl	-16(%ebp), %eax
	movl	$0, 80(%eax)
	movl	-16(%ebp), %eax
	movl	$0, 84(%eax)
	movl	-16(%ebp), %eax
	movl	$0, 96(%eax)
	movl	-16(%ebp), %eax
	movl	$0, 100(%eax)
	movl	-16(%ebp), %eax
	movl	$0, 104(%eax)
	movl	-16(%ebp), %eax
	movl	$0, 108(%eax)
	movl	-16(%ebp), %eax
	movl	$1073741824, 112(%eax)
	movl	-16(%ebp), %eax
	jmp	L35
L34:
	addl	$1, -12(%ebp)
L33:
	cmpl	$999, -12(%ebp)
	jle	L36
	movl	$LC0, (%esp)
	call	_fatal_a
	movl	$0, %eax
L35:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE5:
	.globl	_task_run
	.def	_task_run;	.scl	2;	.type	32;	.endef
_task_run:
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
	cmpl	$0, 12(%ebp)
	jns	L38
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	%eax, 12(%ebp)
L38:
	movl	8(%ebp), %eax
	movl	4(%eax), %eax
	cmpl	$2, %eax
	jne	L39
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	cmpl	%eax, 12(%ebp)
	je	L39
	movl	-12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_task_remove
L39:
	movl	8(%ebp), %eax
	movl	4(%eax), %eax
	cmpl	$2, %eax
	je	L40
	movl	8(%ebp), %eax
	movl	12(%ebp), %edx
	movl	%edx, 8(%eax)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_task_add
L40:
	movl	_taskctl, %eax
	movb	$1, 8(%eax)
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
	.globl	_task_sleep
	.def	_task_sleep;	.scl	2;	.type	32;	.endef
_task_sleep:
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
	movl	4(%eax), %eax
	cmpl	$2, %eax
	jne	L43
	call	_task_now
	movl	%eax, -16(%ebp)
	movl	-12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_task_remove
	movl	8(%ebp), %eax
	cmpl	-16(%ebp), %eax
	jne	L43
	call	_task_switchsub
	call	_task_now
	movl	%eax, -16(%ebp)
	movl	-16(%ebp), %eax
	cmpl	8(%ebp), %eax
	je	L43
	movl	-16(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$0, (%esp)
	call	_farjmp
L43:
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
	.globl	_task_switch
	.def	_task_switch;	.scl	2;	.type	32;	.endef
_task_switch:
LFB8:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$56, %esp
	movl	_taskctl, %eax
	movl	12(%eax), %eax
	testl	%eax, %eax
	je	L46
	movl	$0, -12(%ebp)
	jmp	L47
L51:
	movl	_taskctl, %edx
	movl	-12(%ebp), %eax
	imull	$408, %eax, %eax
	addl	$16, %eax
	addl	%edx, %eax
	movl	%eax, -20(%ebp)
	movl	$0, -16(%ebp)
	jmp	L48
L50:
	movl	-20(%ebp), %eax
	movl	-16(%ebp), %edx
	movl	8(%eax,%edx,4), %eax
	movl	%eax, -24(%ebp)
	movl	_taskctl, %eax
	movl	12(%eax), %eax
	cmpl	%eax, -24(%ebp)
	je	L49
	movl	-24(%ebp), %eax
	movl	4(%eax), %eax
	cmpl	$2, %eax
	jne	L49
	movl	_taskctl, %eax
	movl	-12(%ebp), %edx
	movl	%edx, 4(%eax)
	movl	-20(%ebp), %eax
	movl	-16(%ebp), %edx
	movl	%edx, 4(%eax)
	movl	_taskctl, %eax
	movl	$0, 12(%eax)
	movl	_taskctl, %eax
	movb	$1, 8(%eax)
	movl	-24(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$0, (%esp)
	call	_farjmp
L49:
	addl	$1, -16(%ebp)
L48:
	cmpl	$99, -16(%ebp)
	jle	L50
	addl	$1, -12(%ebp)
L47:
	cmpl	$9, -12(%ebp)
	jle	L51
	jmp	L45
L46:
	movl	_taskctl, %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	jne	L57
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
	movl	-20(%ebp), %eax
	movl	4(%eax), %eax
	leal	1(%eax), %edx
	movl	-20(%ebp), %eax
	movl	%edx, 4(%eax)
	movl	-20(%ebp), %eax
	movl	4(%eax), %edx
	movl	-20(%ebp), %eax
	movl	(%eax), %eax
	cmpl	%eax, %edx
	jne	L54
	movl	-20(%ebp), %eax
	movl	$0, 4(%eax)
L54:
	movl	_taskctl, %eax
	movzbl	8(%eax), %eax
	testb	%al, %al
	je	L55
	call	_task_switchsub
	movl	_taskctl, %edx
	movl	_taskctl, %eax
	movl	4(%eax), %eax
	imull	$408, %eax, %eax
	addl	$16, %eax
	addl	%edx, %eax
	movl	%eax, -20(%ebp)
L55:
	movl	-20(%ebp), %eax
	movl	4(%eax), %edx
	movl	-20(%ebp), %eax
	movl	8(%eax,%edx,4), %eax
	movl	%eax, -28(%ebp)
	movl	-28(%ebp), %eax
	cmpl	-24(%ebp), %eax
	je	L58
	movl	-28(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$0, (%esp)
	call	_farjmp
	jmp	L58
L57:
	nop
	jmp	L45
L58:
	nop
L45:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE8:
	.ident	"GCC: (GNU) 10.2.0"
	.def	_io_load_eflags;	.scl	2;	.type	32;	.endef
	.def	_disable_interrupt;	.scl	2;	.type	32;	.endef
	.def	_io_store_eflags;	.scl	2;	.type	32;	.endef
	.def	_gonbe_hlt;	.scl	2;	.type	32;	.endef
	.def	_memman_alloc;	.scl	2;	.type	32;	.endef
	.def	_set_segmdesc;	.scl	2;	.type	32;	.endef
	.def	_load_tr;	.scl	2;	.type	32;	.endef
	.def	_fatal_a;	.scl	2;	.type	32;	.endef
	.def	_farjmp;	.scl	2;	.type	32;	.endef
