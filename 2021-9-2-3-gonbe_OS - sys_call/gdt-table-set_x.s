	.file	"gdt-table-set.c"
	.text
	.globl	_init_gdtidt
	.def	_init_gdtidt;	.scl	2;	.type	32;	.endef
_init_gdtidt:
LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	$2555904, -16(%ebp)
	movl	$2553856, -20(%ebp)
	movl	$0, -12(%ebp)
	jmp	L2
L3:
	movl	-12(%ebp), %eax
	leal	0(,%eax,8), %edx
	movl	-16(%ebp), %eax
	addl	%edx, %eax
	movl	$0, 12(%esp)
	movl	$0, 8(%esp)
	movl	$0, 4(%esp)
	movl	%eax, (%esp)
	call	_set_segmdesc
	addl	$1, -12(%ebp)
L2:
	cmpl	$8191, -12(%ebp)
	jle	L3
	movl	-16(%ebp), %eax
	addl	$8, %eax
	movl	$16530, 12(%esp)
	movl	$0, 8(%esp)
	movl	$-1, 4(%esp)
	movl	%eax, (%esp)
	call	_set_segmdesc
	movl	-16(%ebp), %eax
	addl	$16, %eax
	movl	$16538, 12(%esp)
	movl	$2621440, 8(%esp)
	movl	$16777215, 4(%esp)
	movl	%eax, (%esp)
	call	_set_segmdesc
	movl	-16(%ebp), %eax
	addl	$24, %eax
	movl	$154, 12(%esp)
	movl	$0, 8(%esp)
	movl	$65535, 4(%esp)
	movl	%eax, (%esp)
	call	_set_segmdesc
	movl	$2555904, 4(%esp)
	movl	$65535, (%esp)
	call	_load_gdtr
	movl	$0, -12(%ebp)
	jmp	L4
L5:
	movl	-12(%ebp), %eax
	leal	0(,%eax,8), %edx
	movl	-20(%ebp), %eax
	addl	%edx, %eax
	movl	$0, 12(%esp)
	movl	$0, 8(%esp)
	movl	$0, 4(%esp)
	movl	%eax, (%esp)
	call	_set_gatedesc
	addl	$1, -12(%ebp)
L4:
	cmpl	$255, -12(%ebp)
	jle	L5
	movl	$2553856, 4(%esp)
	movl	$2047, (%esp)
	call	_load_idtr
	movl	$_asm_inthandler20, %edx
	movl	-20(%ebp), %eax
	addl	$256, %eax
	movl	$142, 12(%esp)
	movl	$16, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	_set_gatedesc
	movl	$_asm_syscall40, %edx
	movl	-20(%ebp), %eax
	addl	$512, %eax
	movl	$142, 12(%esp)
	movl	$16, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	_set_gatedesc
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE0:
	.globl	_set_segmdesc
	.def	_set_segmdesc;	.scl	2;	.type	32;	.endef
_set_segmdesc:
LFB1:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	cmpl	$1048575, 12(%ebp)
	jbe	L8
	orl	$32768, 20(%ebp)
	movl	12(%ebp), %eax
	shrl	$12, %eax
	movl	%eax, 12(%ebp)
L8:
	movl	12(%ebp), %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movw	%dx, (%eax)
	movl	16(%ebp), %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movw	%dx, 2(%eax)
	movl	16(%ebp), %eax
	sarl	$16, %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movb	%dl, 4(%eax)
	movl	20(%ebp), %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movb	%dl, 5(%eax)
	movl	12(%ebp), %eax
	shrl	$16, %eax
	andl	$15, %eax
	movl	%eax, %edx
	movl	20(%ebp), %eax
	sarl	$8, %eax
	andl	$-16, %eax
	orl	%edx, %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movb	%dl, 6(%eax)
	movl	16(%ebp), %eax
	shrl	$24, %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movb	%dl, 7(%eax)
	nop
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE1:
	.globl	_set_gatedesc
	.def	_set_gatedesc;	.scl	2;	.type	32;	.endef
_set_gatedesc:
LFB2:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	movl	12(%ebp), %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movw	%dx, (%eax)
	movl	16(%ebp), %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movw	%dx, 2(%eax)
	movl	20(%ebp), %eax
	sarl	$8, %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movb	%dl, 4(%eax)
	movl	20(%ebp), %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movb	%dl, 5(%eax)
	movl	12(%ebp), %eax
	shrl	$16, %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movw	%dx, 6(%eax)
	nop
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE2:
	.ident	"GCC: (GNU) 10.2.0"
	.def	_load_gdtr;	.scl	2;	.type	32;	.endef
	.def	_load_idtr;	.scl	2;	.type	32;	.endef
	.def	_asm_inthandler20;	.scl	2;	.type	32;	.endef
	.def	_asm_syscall40;	.scl	2;	.type	32;	.endef
