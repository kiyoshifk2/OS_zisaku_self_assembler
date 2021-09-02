	.file	"string.c"
	.text
	.globl	_memcpy
	.def	_memcpy;	.scl	2;	.type	32;	.endef
_memcpy:
LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	movl	8(%ebp), %eax
	movl	%eax, -8(%ebp)
	movl	12(%ebp), %eax
	movl	%eax, -12(%ebp)
	movl	$0, -4(%ebp)
	jmp	L2
L3:
	movl	-4(%ebp), %edx
	movl	-12(%ebp), %eax
	addl	%edx, %eax
	movl	-4(%ebp), %ecx
	movl	-8(%ebp), %edx
	addl	%ecx, %edx
	movzbl	(%eax), %eax
	movb	%al, (%edx)
	addl	$1, -4(%ebp)
L2:
	movl	-4(%ebp), %eax
	cmpl	%eax, 16(%ebp)
	ja	L3
	movl	8(%ebp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE0:
	.globl	_memset
	.def	_memset;	.scl	2;	.type	32;	.endef
_memset:
LFB1:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	movl	8(%ebp), %eax
	movl	%eax, -8(%ebp)
	movl	$0, -4(%ebp)
	jmp	L6
L7:
	movl	-4(%ebp), %edx
	movl	-8(%ebp), %eax
	addl	%edx, %eax
	movl	12(%ebp), %edx
	movb	%dl, (%eax)
	addl	$1, -4(%ebp)
L6:
	movl	-4(%ebp), %eax
	cmpl	%eax, 16(%ebp)
	ja	L7
	movl	8(%ebp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE1:
	.globl	_memcmp
	.def	_memcmp;	.scl	2;	.type	32;	.endef
_memcmp:
LFB2:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	movl	8(%ebp), %eax
	movl	%eax, -8(%ebp)
	movl	12(%ebp), %eax
	movl	%eax, -12(%ebp)
	movl	$0, -4(%ebp)
	jmp	L10
L13:
	movl	-4(%ebp), %edx
	movl	-8(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	movl	-4(%ebp), %ecx
	movl	-12(%ebp), %edx
	addl	%ecx, %edx
	movzbl	(%edx), %edx
	movzbl	%dl, %edx
	subl	%edx, %eax
	movl	%eax, -16(%ebp)
	cmpl	$0, -16(%ebp)
	je	L11
	movl	-16(%ebp), %eax
	jmp	L12
L11:
	addl	$1, -4(%ebp)
L10:
	movl	-4(%ebp), %eax
	cmpl	%eax, 16(%ebp)
	ja	L13
	movl	$0, %eax
L12:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE2:
	.globl	_memmove
	.def	_memmove;	.scl	2;	.type	32;	.endef
_memmove:
LFB3:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	movl	8(%ebp), %eax
	movl	%eax, -8(%ebp)
	movl	12(%ebp), %eax
	movl	%eax, -12(%ebp)
	movl	-8(%ebp), %eax
	subl	-12(%ebp), %eax
	testl	%eax, %eax
	jg	L15
	movl	$0, -4(%ebp)
	jmp	L16
L17:
	movl	-12(%ebp), %edx
	leal	1(%edx), %eax
	movl	%eax, -12(%ebp)
	movl	-8(%ebp), %eax
	leal	1(%eax), %ecx
	movl	%ecx, -8(%ebp)
	movzbl	(%edx), %edx
	movb	%dl, (%eax)
	addl	$1, -4(%ebp)
L16:
	movl	-4(%ebp), %eax
	cmpl	%eax, 16(%ebp)
	ja	L17
	jmp	L18
L15:
	movl	16(%ebp), %eax
	subl	$1, %eax
	addl	%eax, -8(%ebp)
	movl	16(%ebp), %eax
	subl	$1, %eax
	addl	%eax, -12(%ebp)
	movl	$0, -4(%ebp)
	jmp	L19
L20:
	movl	-12(%ebp), %edx
	leal	-1(%edx), %eax
	movl	%eax, -12(%ebp)
	movl	-8(%ebp), %eax
	leal	-1(%eax), %ecx
	movl	%ecx, -8(%ebp)
	movzbl	(%edx), %edx
	movb	%dl, (%eax)
	addl	$1, -4(%ebp)
L19:
	movl	-4(%ebp), %eax
	cmpl	%eax, 16(%ebp)
	ja	L20
L18:
	movl	8(%ebp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE3:
	.globl	_strcpy
	.def	_strcpy;	.scl	2;	.type	32;	.endef
_strcpy:
LFB4:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	movl	$0, -4(%ebp)
	jmp	L23
L24:
	addl	$1, -4(%ebp)
L23:
	movl	-4(%ebp), %edx
	movl	12(%ebp), %eax
	addl	%eax, %edx
	movl	-4(%ebp), %ecx
	movl	8(%ebp), %eax
	addl	%ecx, %eax
	movzbl	(%edx), %edx
	movb	%dl, (%eax)
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	L24
	movl	8(%ebp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE4:
	.globl	_strlen
	.def	_strlen;	.scl	2;	.type	32;	.endef
_strlen:
LFB5:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	movl	$0, -4(%ebp)
	jmp	L27
L28:
	addl	$1, -4(%ebp)
L27:
	movl	-4(%ebp), %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	L28
	movl	-4(%ebp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE5:
	.globl	_strcmp
	.def	_strcmp;	.scl	2;	.type	32;	.endef
_strcmp:
LFB6:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	movl	$0, -4(%ebp)
L34:
	movl	-4(%ebp), %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	movl	-4(%ebp), %ecx
	movl	12(%ebp), %edx
	addl	%ecx, %edx
	movzbl	(%edx), %edx
	movzbl	%dl, %edx
	subl	%edx, %eax
	movl	%eax, -8(%ebp)
	cmpl	$0, -8(%ebp)
	je	L31
	movl	-8(%ebp), %eax
	jmp	L32
L31:
	movl	-4(%ebp), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	L33
	movl	$0, %eax
	jmp	L32
L33:
	addl	$1, -4(%ebp)
	jmp	L34
L32:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE6:
	.globl	_strcat
	.def	_strcat;	.scl	2;	.type	32;	.endef
_strcat:
LFB7:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	movl	$0, -4(%ebp)
	jmp	L36
L37:
	addl	$1, -4(%ebp)
L36:
	movl	-4(%ebp), %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	L37
	movl	$0, -8(%ebp)
	jmp	L38
L39:
	addl	$1, -8(%ebp)
L38:
	movl	-8(%ebp), %edx
	movl	12(%ebp), %eax
	addl	%eax, %edx
	movl	-4(%ebp), %ecx
	movl	-8(%ebp), %eax
	addl	%ecx, %eax
	movl	%eax, %ecx
	movl	8(%ebp), %eax
	addl	%ecx, %eax
	movzbl	(%edx), %edx
	movb	%dl, (%eax)
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	L39
	movl	8(%ebp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE7:
	.globl	_strchr
	.def	_strchr;	.scl	2;	.type	32;	.endef
_strchr:
LFB8:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
L45:
	movl	8(%ebp), %eax
	movzbl	(%eax), %eax
	movsbl	%al, %eax
	cmpl	%eax, 12(%ebp)
	jne	L42
	movl	8(%ebp), %eax
	jmp	L43
L42:
	movl	8(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	L44
	movl	$0, %eax
	jmp	L43
L44:
	addl	$1, 8(%ebp)
	jmp	L45
L43:
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE8:
	.globl	_strrchr
	.def	_strrchr;	.scl	2;	.type	32;	.endef
_strrchr:
LFB9:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_strchr
	movl	%eax, 8(%ebp)
	cmpl	$0, 8(%ebp)
	jne	L47
	movl	$0, %eax
	jmp	L48
L47:
	movl	8(%ebp), %eax
	leal	1(%eax), %edx
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	_strchr
	movl	%eax, -4(%ebp)
	cmpl	$0, -4(%ebp)
	jne	L49
	movl	8(%ebp), %eax
	jmp	L48
L49:
	movl	-4(%ebp), %eax
	movl	%eax, 8(%ebp)
	jmp	L47
L48:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE9:
	.globl	_atoi
	.def	_atoi;	.scl	2;	.type	32;	.endef
_atoi:
LFB10:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	jmp	L51
L52:
	addl	$1, 8(%ebp)
L51:
	movl	8(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$32, %al
	je	L52
	movl	8(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$9, %al
	je	L52
	movl	$0, -8(%ebp)
	movl	8(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$45, %al
	jne	L53
	movl	$1, -8(%ebp)
L53:
	movl	$0, -4(%ebp)
	jmp	L54
L56:
	movl	-4(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	addl	%eax, %eax
	movl	%eax, %ecx
	movl	8(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, 8(%ebp)
	movzbl	(%eax), %eax
	movsbl	%al, %eax
	addl	%ecx, %eax
	subl	$48, %eax
	movl	%eax, -4(%ebp)
L54:
	movl	8(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$47, %al
	jle	L55
	movl	8(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$57, %al
	jle	L56
L55:
	cmpl	$0, -8(%ebp)
	je	L57
	movl	-4(%ebp), %eax
	negl	%eax
	jmp	L58
L57:
	movl	-4(%ebp), %eax
L58:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE10:
	.ident	"GCC: (GNU) 10.2.0"
