	.file	"lib.c"
	.text
	.globl	_memcheck_sub
	.def	_memcheck_sub;	.scl	2;	.type	32;	.endef
_memcheck_sub:
LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	movl	8(%ebp), %eax
	orl	$65535, %eax
	movl	%eax, -4(%ebp)
	jmp	L2
L5:
	movl	-4(%ebp), %eax
	movl	%eax, -8(%ebp)
	movl	-4(%ebp), %edx
	movl	-8(%ebp), %eax
	movl	%edx, (%eax)
	movl	-8(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -12(%ebp)
	movl	-4(%ebp), %eax
	notl	%eax
	movl	%eax, %edx
	movl	-8(%ebp), %eax
	movl	%edx, (%eax)
	movl	-8(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -16(%ebp)
	movl	-16(%ebp), %eax
	notl	%eax
	movl	%eax, %edx
	movl	-12(%ebp), %eax
	cmpl	%eax, %edx
	je	L3
	movl	-4(%ebp), %eax
	subl	$65536, %eax
	jmp	L4
L3:
	addl	$65536, -4(%ebp)
L2:
	movl	-4(%ebp), %eax
	cmpl	12(%ebp), %eax
	jbe	L5
	movl	-4(%ebp), %eax
	subl	$65536, %eax
L4:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE0:
	.globl	_memcheck
	.def	_memcheck;	.scl	2;	.type	32;	.endef
_memcheck:
LFB1:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$76, %esp
	.cfi_offset 7, -12
	.cfi_offset 6, -16
	.cfi_offset 3, -20
	movb	$0, -25(%ebp)
	call	_io_load_eflags
	movl	%eax, -32(%ebp)
	orl	$262144, -32(%ebp)
	movl	-32(%ebp), %eax
	movl	%eax, (%esp)
	call	_io_store_eflags
	call	_io_load_eflags
	movl	%eax, -32(%ebp)
	movl	-32(%ebp), %eax
	andl	$262144, %eax
	testl	%eax, %eax
	je	L7
	movb	$1, -25(%ebp)
L7:
	andl	$-262145, -32(%ebp)
	movl	-32(%ebp), %eax
	movl	%eax, (%esp)
	call	_io_store_eflags
	cmpb	$0, -25(%ebp)
	je	L8
	call	_load_cr0
	movl	%eax, -36(%ebp)
	orl	$1610612736, -36(%ebp)
	movl	-36(%ebp), %eax
	movl	%eax, (%esp)
	call	_store_cr0
L8:
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_memcheck_sub
	movl	%eax, -40(%ebp)
	cmpb	$0, -25(%ebp)
	je	L9
	call	_load_cr0
	movl	%eax, -36(%ebp)
	andl	$-1610612737, -36(%ebp)
	movl	-36(%ebp), %eax
	movl	%eax, (%esp)
	call	_store_cr0
L9:
	movl	-40(%ebp), %eax
	movl	$0, %edx
	addl	$1, %eax
	adcl	$0, %edx
	movl	%eax, -64(%ebp)
	movl	%edx, -60(%ebp)
	movl	-60(%ebp), %eax
	sarl	$31, %eax
	cltd
	movl	%eax, %ebx
	andl	$1048575, %ebx
	movl	%ebx, %esi
	movl	%edx, %eax
	andl	$0, %eax
	movl	%eax, %edi
	movl	%esi, %eax
	movl	%edi, %edx
	addl	-64(%ebp), %eax
	adcl	-60(%ebp), %edx
	shrdl	$20, %edx, %eax
	sarl	$20, %edx
	movl	%eax, -44(%ebp)
	movl	-44(%ebp), %eax
	addl	$76, %esp
	popl	%ebx
	.cfi_restore 3
	popl	%esi
	.cfi_restore 6
	popl	%edi
	.cfi_restore 7
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE1:
	.data
LC0:
	.ascii "cnt=%dM\12\0"
	.text
	.globl	_test_speed
	.def	_test_speed;	.scl	2;	.type	32;	.endef
_test_speed:
LFB2:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	call	_GetTickCount
	movl	%eax, -16(%ebp)
	nop
L12:
	call	_GetTickCount
	cmpl	%eax, -16(%ebp)
	je	L12
	call	_GetTickCount
	movl	%eax, -16(%ebp)
	movl	$0, -12(%ebp)
L15:
	addl	$1, -12(%ebp)
	call	_GetTickCount
	subl	-16(%ebp), %eax
	cmpl	$999, %eax
	ja	L17
	jmp	L15
L17:
	nop
	movl	-12(%ebp), %eax
	movl	$1125899907, %edx
	mull	%edx
	movl	%edx, %eax
	shrl	$18, %eax
	movl	%eax, 8(%esp)
	movl	$LC0, 4(%esp)
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
	.globl	_bss_clear
	.def	_bss_clear;	.scl	2;	.type	32;	.endef
_bss_clear:
LFB3:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	movl	$2621440, %eax
	movl	(%eax), %eax
	movl	%eax, -4(%ebp)
	jmp	L19
L20:
	movl	-4(%ebp), %eax
	movb	$0, (%eax)
	addl	$1, -4(%ebp)
L19:
	movl	$2621444, %eax
	movl	(%eax), %eax
	cmpl	%eax, -4(%ebp)
	jb	L20
	nop
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE3:
	.globl	_ut_getcA
	.def	_ut_getcA;	.scl	2;	.type	32;	.endef
_ut_getcA:
LFB4:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	call	_io_load_eflags
	movl	%eax, -12(%ebp)
	jmp	L22
L24:
	movl	-12(%ebp), %eax
	andl	$512, %eax
	testl	%eax, %eax
	jne	L23
	call	_gonbe_hlt
	jmp	L22
L23:
	movl	$10, (%esp)
	call	_delay_task
L22:
	movl	8(%ebp), %eax
	movl	$0, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$1, (%esp)
	call	_asm_int_0x40
	movl	%eax, -16(%ebp)
	cmpl	$0, -16(%ebp)
	je	L24
	movl	-16(%ebp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE4:
	.globl	_ut_getc
	.def	_ut_getc;	.scl	2;	.type	32;	.endef
_ut_getc:
LFB5:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
L29:
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_getcA
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	jle	L29
	cmpl	$127, -12(%ebp)
	jg	L29
	movl	-12(%ebp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE5:
	.globl	_ut_gets
	.def	_ut_gets;	.scl	2;	.type	32;	.endef
_ut_gets:
LFB6:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	$0, -12(%ebp)
	jmp	L32
L35:
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_getc
	movl	%eax, %edx
	movl	-12(%ebp), %ecx
	movl	12(%ebp), %eax
	addl	%ecx, %eax
	movb	%dl, (%eax)
	movl	-12(%ebp), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	cmpb	$10, %al
	jne	L33
	movl	-12(%ebp), %eax
	leal	1(%eax), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movb	$0, (%eax)
	jmp	L31
L33:
	addl	$1, -12(%ebp)
L32:
	movl	16(%ebp), %eax
	subl	$1, %eax
	cmpl	%eax, -12(%ebp)
	jl	L35
	movl	-12(%ebp), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movb	$0, (%eax)
	nop
L36:
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_getc
	cmpl	$10, %eax
	jne	L36
L31:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE6:
	.ident	"GCC: (GNU) 10.2.0"
	.def	_io_load_eflags;	.scl	2;	.type	32;	.endef
	.def	_io_store_eflags;	.scl	2;	.type	32;	.endef
	.def	_load_cr0;	.scl	2;	.type	32;	.endef
	.def	_store_cr0;	.scl	2;	.type	32;	.endef
	.def	_GetTickCount;	.scl	2;	.type	32;	.endef
	.def	_ut_printf;	.scl	2;	.type	32;	.endef
	.def	_gonbe_hlt;	.scl	2;	.type	32;	.endef
	.def	_delay_task;	.scl	2;	.type	32;	.endef
	.def	_asm_int_0x40;	.scl	2;	.type	32;	.endef
