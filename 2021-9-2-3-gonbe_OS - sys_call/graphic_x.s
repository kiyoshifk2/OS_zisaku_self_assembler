	.file	"graphic.c"
	.text
	.globl	_init_palette
	.def	_init_palette;	.scl	2;	.type	32;	.endef
_init_palette:
LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	movl	$_table_rgb.0, 8(%esp)
	movl	$23, 4(%esp)
	movl	$0, (%esp)
	call	_set_palette
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE0:
	.globl	_set_palette
	.def	_set_palette;	.scl	2;	.type	32;	.endef
_set_palette:
LFB1:
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
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$968, (%esp)
	call	_io_out8
	movl	8(%ebp), %eax
	movl	%eax, -12(%ebp)
	jmp	L4
L5:
	movl	16(%ebp), %eax
	movzbl	(%eax), %eax
	shrb	$2, %al
	movzbl	%al, %eax
	movl	%eax, 4(%esp)
	movl	$969, (%esp)
	call	_io_out8
	movl	16(%ebp), %eax
	addl	$1, %eax
	movzbl	(%eax), %eax
	shrb	$2, %al
	movzbl	%al, %eax
	movl	%eax, 4(%esp)
	movl	$969, (%esp)
	call	_io_out8
	movl	16(%ebp), %eax
	addl	$2, %eax
	movzbl	(%eax), %eax
	shrb	$2, %al
	movzbl	%al, %eax
	movl	%eax, 4(%esp)
	movl	$969, (%esp)
	call	_io_out8
	addl	$3, 16(%ebp)
	addl	$1, -12(%ebp)
L4:
	movl	-12(%ebp), %eax
	cmpl	12(%ebp), %eax
	jle	L5
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	_io_store_eflags
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE1:
	.globl	_boxfill8
	.def	_boxfill8;	.scl	2;	.type	32;	.endef
_boxfill8:
LFB2:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$20, %esp
	movl	16(%ebp), %eax
	movb	%al, -20(%ebp)
	movl	24(%ebp), %eax
	movl	%eax, -8(%ebp)
	jmp	L8
L11:
	movl	20(%ebp), %eax
	movl	%eax, -4(%ebp)
	jmp	L9
L10:
	movl	-8(%ebp), %eax
	imull	12(%ebp), %eax
	movl	%eax, %edx
	movl	-4(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	addl	%eax, %edx
	movzbl	-20(%ebp), %eax
	movb	%al, (%edx)
	addl	$1, -4(%ebp)
L9:
	movl	-4(%ebp), %eax
	cmpl	28(%ebp), %eax
	jle	L10
	addl	$1, -8(%ebp)
L8:
	movl	-8(%ebp), %eax
	cmpl	32(%ebp), %eax
	jle	L11
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE2:
	.globl	_init_screen8
	.def	_init_screen8;	.scl	2;	.type	32;	.endef
_init_screen8:
LFB3:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%ebx
	subl	$28, %esp
	.cfi_offset 3, -12
	movl	16(%ebp), %eax
	leal	-1(%eax), %ecx
	movl	12(%ebp), %eax
	leal	-1(%eax), %edx
	movl	24(%ebp), %eax
	movzbl	%al, %eax
	movl	%ecx, 24(%esp)
	movl	%edx, 20(%esp)
	movl	$0, 16(%esp)
	movl	$0, 12(%esp)
	movl	%eax, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_boxfill8
	movl	16(%ebp), %eax
	leal	-1(%eax), %ebx
	movl	12(%ebp), %eax
	leal	-1(%eax), %ecx
	movl	16(%ebp), %eax
	leal	-22(%eax), %edx
	movl	28(%ebp), %eax
	movzbl	%al, %eax
	movl	%ebx, 24(%esp)
	movl	%ecx, 20(%esp)
	movl	%edx, 16(%esp)
	movl	$0, 12(%esp)
	movl	%eax, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_boxfill8
	movl	16(%ebp), %eax
	leal	-22(%eax), %ebx
	movl	12(%ebp), %eax
	leal	-1(%eax), %ecx
	movl	16(%ebp), %eax
	leal	-22(%eax), %edx
	movl	20(%ebp), %eax
	movzbl	%al, %eax
	movl	%ebx, 24(%esp)
	movl	%ecx, 20(%esp)
	movl	%edx, 16(%esp)
	movl	$0, 12(%esp)
	movl	%eax, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_boxfill8
	movl	12(%ebp), %eax
	leal	-1(%eax), %edx
	movl	20(%ebp), %eax
	movzbl	%al, %eax
	movl	$0, 24(%esp)
	movl	%edx, 20(%esp)
	movl	$0, 16(%esp)
	movl	$0, 12(%esp)
	movl	%eax, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_boxfill8
	movl	16(%ebp), %eax
	leal	-1(%eax), %edx
	movl	20(%ebp), %eax
	movzbl	%al, %eax
	movl	%edx, 24(%esp)
	movl	$0, 20(%esp)
	movl	$0, 16(%esp)
	movl	$0, 12(%esp)
	movl	%eax, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_boxfill8
	movl	16(%ebp), %eax
	leal	-1(%eax), %ebx
	movl	12(%ebp), %eax
	leal	-1(%eax), %ecx
	movl	12(%ebp), %eax
	leal	-1(%eax), %edx
	movl	20(%ebp), %eax
	movzbl	%al, %eax
	movl	%ebx, 24(%esp)
	movl	%ecx, 20(%esp)
	movl	$0, 16(%esp)
	movl	%edx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_boxfill8
	movl	16(%ebp), %eax
	leal	-1(%eax), %ebx
	movl	12(%ebp), %eax
	leal	-1(%eax), %ecx
	movl	16(%ebp), %eax
	leal	-1(%eax), %edx
	movl	20(%ebp), %eax
	movzbl	%al, %eax
	movl	%ebx, 24(%esp)
	movl	%ecx, 20(%esp)
	movl	%edx, 16(%esp)
	movl	$0, 12(%esp)
	movl	%eax, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_boxfill8
	nop
	movl	-4(%ebp), %ebx
	leave
	.cfi_restore 5
	.cfi_restore 3
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE3:
	.data
	.align 32
_table_rgb.0:
	.ascii "\0\0\0\377\0\0\0\377\0\377\377\0\0\0\377\377\0\377\0\377\377\377\377\377\300\300\300\200\0\0\0\200\0\200\200\0\0\0\200\200\0\200\0\200\200\200\200\200   @\0\0\0@\0@@\0\0\0@@\0@\0@@@@@"
	.ident	"GCC: (GNU) 10.2.0"
	.def	_io_load_eflags;	.scl	2;	.type	32;	.endef
	.def	_disable_interrupt;	.scl	2;	.type	32;	.endef
	.def	_io_out8;	.scl	2;	.type	32;	.endef
	.def	_io_store_eflags;	.scl	2;	.type	32;	.endef
