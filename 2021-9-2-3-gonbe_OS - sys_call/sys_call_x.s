	.file	"sys_call.c"
	.text
	.data
LC0:
	.ascii "%c\0"
LC1:
	.ascii "%02x\0"
LC2:
	.ascii "%x\0"
LC3:
	.ascii "%d\0"
	.text
	.globl	_syscall40
	.def	_syscall40;	.scl	2;	.type	32;	.endef
_syscall40:
LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	cmpl	$1, 8(%ebp)
	jne	L2
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	_syscall_1
	jmp	L3
L2:
	cmpl	$2, 8(%ebp)
	jne	L4
	movl	16(%ebp), %eax
	andl	$127, %eax
	movl	%eax, %edx
	movl	12(%ebp), %eax
	movl	%edx, 8(%esp)
	movl	$LC0, 4(%esp)
	movl	%eax, (%esp)
	call	_ut_printf
	jmp	L5
L4:
	cmpl	$3, 8(%ebp)
	jne	L6
	movl	16(%ebp), %eax
	movsbl	%al, %edx
	movl	12(%ebp), %eax
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	_clear_screen
	jmp	L5
L6:
	cmpl	$4, 8(%ebp)
	jne	L7
	movl	16(%ebp), %eax
	movzbl	%al, %edx
	movl	12(%ebp), %eax
	movl	%edx, 8(%esp)
	movl	$LC1, 4(%esp)
	movl	%eax, (%esp)
	call	_ut_printf
	jmp	L5
L7:
	cmpl	$5, 8(%ebp)
	jne	L8
	movl	12(%ebp), %eax
	movl	16(%ebp), %edx
	movl	%edx, 8(%esp)
	movl	$LC2, 4(%esp)
	movl	%eax, (%esp)
	call	_ut_printf
	jmp	L5
L8:
	cmpl	$6, 8(%ebp)
	jne	L5
	movl	12(%ebp), %eax
	movl	16(%ebp), %edx
	movl	%edx, 8(%esp)
	movl	$LC3, 4(%esp)
	movl	%eax, (%esp)
	call	_ut_printf
L5:
	movl	$0, %eax
L3:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE0:
	.globl	_syscall_1
	.def	_syscall_1;	.scl	2;	.type	32;	.endef
_syscall_1:
LFB1:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	movl	_getc_char, %eax
	movl	%eax, -4(%ebp)
	movl	_shtctl, %eax
	movl	16(%eax), %eax
	movl	%eax, -8(%ebp)
	cmpl	$0, -8(%ebp)
	jns	L10
	movl	$0, %eax
	jmp	L11
L10:
	movl	_shtctl, %eax
	movl	-8(%ebp), %edx
	addl	$4, %edx
	movl	4(%eax,%edx,4), %eax
	cmpl	%eax, 8(%ebp)
	je	L12
	movl	$0, %eax
	jmp	L11
L12:
	movl	$0, _getc_char
	movl	-4(%ebp), %eax
L11:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE1:
	.ident	"GCC: (GNU) 10.2.0"
	.def	_ut_printf;	.scl	2;	.type	32;	.endef
	.def	_clear_screen;	.scl	2;	.type	32;	.endef
