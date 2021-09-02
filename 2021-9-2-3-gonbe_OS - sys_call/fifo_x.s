	.file	"fifo.c"
	.text
	.globl	_hoge1
	.bss
	.align 4
_hoge1:
	.space 4
	.text
	.globl	_fifo32_init
	.def	_fifo32_init;	.scl	2;	.type	32;	.endef
_fifo32_init:
LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	movl	8(%ebp), %eax
	movl	$1, 20(%eax)
	movl	8(%ebp), %eax
	movl	12(%ebp), %edx
	movl	%edx, 12(%eax)
	movl	8(%ebp), %eax
	movl	16(%ebp), %edx
	movl	%edx, (%eax)
	movl	8(%ebp), %eax
	movl	12(%ebp), %edx
	movl	%edx, 16(%eax)
	movl	8(%ebp), %eax
	movl	$0, 4(%eax)
	movl	8(%ebp), %eax
	movl	$0, 8(%eax)
	movl	8(%ebp), %eax
	movl	20(%ebp), %edx
	movl	%edx, 24(%eax)
	nop
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE0:
	.globl	_fifo32_put
	.def	_fifo32_put;	.scl	2;	.type	32;	.endef
_fifo32_put:
LFB1:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	8(%ebp), %eax
	movl	20(%eax), %eax
	testl	%eax, %eax
	jne	L4
	movl	$-1, %eax
	jmp	L5
L4:
	movl	8(%ebp), %eax
	movl	16(%eax), %eax
	testl	%eax, %eax
	jne	L6
	movl	8(%ebp), %eax
	movl	20(%eax), %eax
	orl	$2, %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movl	%edx, 20(%eax)
	movl	$-1, %eax
	jmp	L5
L6:
	movl	8(%ebp), %eax
	movl	(%eax), %edx
	movl	8(%ebp), %eax
	movl	4(%eax), %eax
	sall	$2, %eax
	addl	%eax, %edx
	movl	12(%ebp), %eax
	movl	%eax, (%edx)
	movl	8(%ebp), %eax
	movl	4(%eax), %eax
	leal	1(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 4(%eax)
	movl	8(%ebp), %eax
	movl	4(%eax), %edx
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	cmpl	%eax, %edx
	jne	L7
	movl	8(%ebp), %eax
	movl	$0, 4(%eax)
L7:
	movl	8(%ebp), %eax
	movl	16(%eax), %eax
	leal	-1(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 16(%eax)
	movl	8(%ebp), %eax
	movl	24(%eax), %eax
	testl	%eax, %eax
	je	L8
	movl	_taskctl, %eax
	movl	12(%eax), %eax
	testl	%eax, %eax
	jne	L8
	movl	8(%ebp), %eax
	movl	24(%eax), %eax
	movl	4(%eax), %eax
	cmpl	$2, %eax
	je	L8
	movl	_taskctl, %eax
	movl	(%eax), %eax
	movl	%eax, -12(%ebp)
	movl	8(%ebp), %eax
	movl	24(%eax), %eax
	movl	$-1, 4(%esp)
	movl	%eax, (%esp)
	call	_task_run
	movl	_taskctl, %eax
	movl	-12(%ebp), %edx
	movl	%edx, (%eax)
L8:
	movl	$0, %eax
L5:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE1:
	.globl	_fifo32_get
	.def	_fifo32_get;	.scl	2;	.type	32;	.endef
_fifo32_get:
LFB2:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	movl	8(%ebp), %eax
	movl	20(%eax), %eax
	testl	%eax, %eax
	jne	L10
	movl	$-1, %eax
	jmp	L11
L10:
	movl	8(%ebp), %eax
	movl	16(%eax), %edx
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	cmpl	%eax, %edx
	jne	L12
	movl	$-1, %eax
	jmp	L11
L12:
	movl	8(%ebp), %eax
	movl	(%eax), %edx
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	sall	$2, %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	%eax, -4(%ebp)
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	leal	1(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 8(%eax)
	movl	8(%ebp), %eax
	movl	8(%eax), %edx
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	cmpl	%eax, %edx
	jne	L13
	movl	8(%ebp), %eax
	movl	$0, 8(%eax)
L13:
	movl	8(%ebp), %eax
	movl	16(%eax), %eax
	leal	1(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 16(%eax)
	movl	-4(%ebp), %eax
L11:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE2:
	.globl	_fifo32_status
	.def	_fifo32_status;	.scl	2;	.type	32;	.endef
_fifo32_status:
LFB3:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	movl	8(%ebp), %eax
	movl	12(%eax), %edx
	movl	8(%ebp), %eax
	movl	16(%eax), %ecx
	movl	%edx, %eax
	subl	%ecx, %eax
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE3:
	.ident	"GCC: (GNU) 10.2.0"
	.def	_task_run;	.scl	2;	.type	32;	.endef
