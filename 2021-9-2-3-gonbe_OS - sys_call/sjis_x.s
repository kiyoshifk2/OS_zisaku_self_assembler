	.file	"sjis.c"
	.text
	.globl	_char_to_sjis
	.data
	.align 32
_char_to_sjis:
	.long	1
	.long	10
	.long	41
	.long	84
	.long	80
	.long	83
	.long	85
	.long	39
	.long	42
	.long	43
	.long	86
	.long	60
	.long	4
	.long	28
	.long	5
	.long	31
	.long	204
	.long	205
	.long	206
	.long	207
	.long	208
	.long	209
	.long	210
	.long	211
	.long	212
	.long	213
	.long	7
	.long	8
	.long	67
	.long	65
	.long	68
	.long	9
	.long	87
	.long	221
	.long	222
	.long	223
	.long	224
	.long	225
	.long	226
	.long	227
	.long	228
	.long	229
	.long	230
	.long	231
	.long	232
	.long	233
	.long	234
	.long	235
	.long	236
	.long	237
	.long	238
	.long	239
	.long	240
	.long	241
	.long	242
	.long	243
	.long	244
	.long	245
	.long	246
	.long	46
	.long	79
	.long	47
	.long	16
	.long	18
	.long	38
	.long	253
	.long	254
	.long	255
	.long	256
	.long	257
	.long	258
	.long	259
	.long	260
	.long	261
	.long	262
	.long	263
	.long	264
	.long	265
	.long	266
	.long	267
	.long	268
	.long	269
	.long	270
	.long	271
	.long	272
	.long	273
	.long	274
	.long	275
	.long	276
	.long	277
	.long	278
	.long	48
	.long	35
	.long	49
	.long	33
	.long	62
	.text
	.globl	_dispinit
	.def	_dispinit;	.scl	2;	.type	32;	.endef
_dispinit:
LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	nop
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE0:
	.globl	_sjis_parse
	.def	_sjis_parse;	.scl	2;	.type	32;	.endef
_sjis_parse:
LFB1:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	movl	8(%ebp), %eax
	movzbl	(%eax), %eax
	movsbl	%al, %eax
	andl	$255, %eax
	movl	%eax, -12(%ebp)
	cmpl	$128, -12(%ebp)
	jle	L3
	cmpl	$159, -12(%ebp)
	jg	L3
	movl	-12(%ebp), %eax
	subl	$129, %eax
	addl	%eax, %eax
	addl	$1, %eax
	movl	%eax, -4(%ebp)
	jmp	L4
L3:
	cmpl	$223, -12(%ebp)
	jle	L5
	cmpl	$239, -12(%ebp)
	jg	L5
	movl	-12(%ebp), %eax
	subl	$224, %eax
	addl	%eax, %eax
	addl	$63, %eax
	movl	%eax, -4(%ebp)
	jmp	L4
L5:
	movl	12(%ebp), %eax
	movl	$1, (%eax)
	movl	-12(%ebp), %eax
	jmp	L6
L4:
	movl	8(%ebp), %eax
	addl	$1, %eax
	movzbl	(%eax), %eax
	movsbl	%al, %eax
	andl	$255, %eax
	movl	%eax, -12(%ebp)
	cmpl	$63, -12(%ebp)
	jle	L7
	cmpl	$126, -12(%ebp)
	jg	L7
	movl	-12(%ebp), %eax
	subl	$63, %eax
	movl	%eax, -8(%ebp)
	jmp	L8
L7:
	cmpl	$127, -12(%ebp)
	jle	L9
	cmpl	$158, -12(%ebp)
	jg	L9
	movl	-12(%ebp), %eax
	subl	$64, %eax
	movl	%eax, -8(%ebp)
	jmp	L8
L9:
	cmpl	$158, -12(%ebp)
	jle	L10
	cmpl	$252, -12(%ebp)
	jg	L10
	addl	$1, -4(%ebp)
	movl	-12(%ebp), %eax
	subl	$158, %eax
	movl	%eax, -8(%ebp)
	jmp	L8
L10:
	movl	12(%ebp), %eax
	movl	$1, (%eax)
	movl	-12(%ebp), %eax
	jmp	L6
L8:
	movl	12(%ebp), %eax
	movl	$2, (%eax)
	movl	-4(%ebp), %eax
	subl	$1, %eax
	imull	$94, %eax, %edx
	movl	-8(%ebp), %eax
	addl	%edx, %eax
L6:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE1:
	.globl	_sjis_strlen
	.def	_sjis_strlen;	.scl	2;	.type	32;	.endef
_sjis_strlen:
LFB2:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	movl	$0, -4(%ebp)
L14:
	leal	-8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_sjis_parse
	testl	%eax, %eax
	jne	L12
	movl	-4(%ebp), %eax
	jmp	L15
L12:
	addl	$1, -4(%ebp)
	movl	-8(%ebp), %eax
	addl	%eax, 8(%ebp)
	jmp	L14
L15:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE2:
	.globl	_disp_sjis
	.def	_disp_sjis;	.scl	2;	.type	32;	.endef
_disp_sjis:
LFB3:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%ebx
	subl	$52, %esp
	.cfi_offset 3, -12
	call	_io_load_eflags
	movl	%eax, -20(%ebp)
	call	_disable_interrupt
	movl	$0, -16(%ebp)
	jmp	L17
L26:
	movl	$0, -12(%ebp)
	jmp	L18
L25:
	movl	-16(%ebp), %eax
	leal	-1(%eax), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$2, %eax
	movl	%eax, %edx
	movl	-12(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, -24(%ebp)
	movl	-24(%ebp), %eax
	cltd
	shrl	$29, %edx
	addl	%edx, %eax
	andl	$7, %eax
	subl	%edx, %eax
	movl	$128, %edx
	movl	%eax, %ecx
	sarl	%cl, %edx
	movl	%edx, %eax
	movl	%eax, -28(%ebp)
	movl	-24(%ebp), %eax
	leal	7(%eax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$3, %eax
	movl	%eax, %ecx
	movl	20(%ebp), %edx
	movl	%edx, %eax
	sall	$3, %eax
	addl	%edx, %eax
	addl	%eax, %eax
	addl	%ecx, %eax
	addl	$_KanjiFont12b, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	movl	%eax, -32(%ebp)
	cmpl	$0, -16(%ebp)
	jle	L19
	cmpl	$12, -16(%ebp)
	jg	L19
	movl	-32(%ebp), %eax
	andl	-28(%ebp), %eax
	testl	%eax, %eax
	je	L19
	movl	8(%ebp), %eax
	movl	112(%eax), %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	jne	L20
	movl	8(%ebp), %eax
	movl	104(%eax), %eax
	movl	(%eax), %eax
	jmp	L21
L20:
	movl	8(%ebp), %eax
	movl	108(%eax), %eax
	movl	(%eax), %eax
L21:
	movl	16(%ebp), %ecx
	movl	-16(%ebp), %edx
	addl	%edx, %ecx
	movl	12(%ebp), %ebx
	movl	-12(%ebp), %edx
	addl	%ebx, %edx
	movl	%eax, 12(%esp)
	movl	%ecx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_pset
	jmp	L22
L19:
	movl	8(%ebp), %eax
	movl	112(%eax), %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	jne	L23
	movl	8(%ebp), %eax
	movl	108(%eax), %eax
	movl	(%eax), %eax
	jmp	L24
L23:
	movl	8(%ebp), %eax
	movl	104(%eax), %eax
	movl	(%eax), %eax
L24:
	movl	16(%ebp), %ecx
	movl	-16(%ebp), %edx
	addl	%edx, %ecx
	movl	12(%ebp), %ebx
	movl	-12(%ebp), %edx
	addl	%ebx, %edx
	movl	%eax, 12(%esp)
	movl	%ecx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_pset
L22:
	addl	$1, -12(%ebp)
L18:
	cmpl	$11, -12(%ebp)
	jle	L25
	addl	$1, -16(%ebp)
L17:
	cmpl	$15, -16(%ebp)
	jle	L26
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
LFE3:
	.globl	_disp_char
	.def	_disp_char;	.scl	2;	.type	32;	.endef
_disp_char:
LFB4:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	leal	-16(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	20(%ebp), %eax
	movl	%eax, (%esp)
	call	_sjis_parse
	movl	%eax, -12(%ebp)
	movl	-16(%ebp), %eax
	cmpl	$1, %eax
	jne	L28
	movl	20(%ebp), %eax
	movzbl	(%eax), %eax
	movsbl	%al, %eax
	subl	$32, %eax
	movl	_char_to_sjis(,%eax,4), %eax
	movl	%eax, -12(%ebp)
L28:
	movl	-12(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_disp_sjis
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE4:
	.globl	_clear_cur
	.def	_clear_cur;	.scl	2;	.type	32;	.endef
_clear_cur:
LFB5:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	nop
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE5:
	.globl	_read_cur
	.def	_read_cur;	.scl	2;	.type	32;	.endef
_read_cur:
LFB6:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	nop
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE6:
	.globl	_disp_cur
	.def	_disp_cur;	.scl	2;	.type	32;	.endef
_disp_cur:
LFB7:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	nop
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE7:
	.globl	_disp_U
	.def	_disp_U;	.scl	2;	.type	32;	.endef
_disp_U:
LFB8:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$4, %esp
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_clear_cur
	movl	8(%ebp), %eax
	movl	96(%eax), %eax
	movl	(%eax), %edx
	subl	$1, %edx
	movl	%edx, (%eax)
	movl	8(%ebp), %eax
	movl	96(%eax), %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	jns	L36
	movl	8(%ebp), %eax
	movl	96(%eax), %eax
	movl	$0, (%eax)
L36:
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_read_cur
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_disp_cur
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE8:
	.globl	_disp_D
	.def	_disp_D;	.scl	2;	.type	32;	.endef
_disp_D:
LFB9:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_clear_cur
	movl	8(%ebp), %eax
	movl	96(%eax), %eax
	movl	(%eax), %edx
	addl	$1, %edx
	movl	%edx, (%eax)
	movl	8(%ebp), %eax
	movl	96(%eax), %eax
	movl	(%eax), %edx
	movl	8(%ebp), %eax
	movl	120(%eax), %eax
	cmpl	%eax, %edx
	jl	L38
	movl	8(%ebp), %eax
	movl	120(%eax), %edx
	movl	8(%ebp), %eax
	movl	96(%eax), %eax
	subl	$1, %edx
	movl	%edx, (%eax)
	movl	$16, -16(%ebp)
	jmp	L39
L42:
	movl	$0, -12(%ebp)
	jmp	L40
L41:
	movl	-16(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_pget
	movl	-16(%ebp), %edx
	subl	$16, %edx
	movl	%eax, 12(%esp)
	movl	%edx, 8(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_pset
	addl	$1, -12(%ebp)
L40:
	movl	8(%ebp), %eax
	movl	132(%eax), %eax
	cmpl	%eax, -12(%ebp)
	jl	L41
	addl	$1, -16(%ebp)
L39:
	movl	8(%ebp), %eax
	movl	136(%eax), %eax
	cmpl	%eax, -16(%ebp)
	jl	L42
	subl	$16, -16(%ebp)
	jmp	L43
L46:
	movl	$0, -12(%ebp)
	jmp	L44
L45:
	movl	8(%ebp), %eax
	movl	108(%eax), %eax
	movl	(%eax), %eax
	movl	%eax, 12(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_pset
	addl	$1, -12(%ebp)
L44:
	movl	8(%ebp), %eax
	movl	132(%eax), %eax
	cmpl	%eax, -12(%ebp)
	jl	L45
	addl	$1, -16(%ebp)
L43:
	movl	8(%ebp), %eax
	movl	136(%eax), %eax
	cmpl	%eax, -16(%ebp)
	jl	L46
L38:
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_read_cur
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_disp_cur
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE9:
	.globl	_disp_R
	.def	_disp_R;	.scl	2;	.type	32;	.endef
_disp_R:
LFB10:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_clear_cur
	movl	8(%ebp), %eax
	movl	92(%eax), %eax
	movl	(%eax), %edx
	addl	$1, %edx
	movl	%edx, (%eax)
	movl	8(%ebp), %eax
	movl	92(%eax), %eax
	movl	(%eax), %edx
	movl	8(%ebp), %eax
	movl	116(%eax), %eax
	cmpl	%eax, %edx
	jl	L48
	movl	8(%ebp), %eax
	movl	92(%eax), %eax
	movl	$0, (%eax)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_read_cur
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_disp_D
	jmp	L47
L48:
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_read_cur
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_disp_cur
L47:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE10:
	.globl	_disp_L
	.def	_disp_L;	.scl	2;	.type	32;	.endef
_disp_L:
LFB11:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$4, %esp
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_clear_cur
	movl	8(%ebp), %eax
	movl	92(%eax), %eax
	movl	(%eax), %edx
	subl	$1, %edx
	movl	%edx, (%eax)
	movl	8(%ebp), %eax
	movl	92(%eax), %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	jns	L51
	movl	8(%ebp), %eax
	movl	116(%eax), %edx
	movl	8(%ebp), %eax
	movl	92(%eax), %eax
	subl	$1, %edx
	movl	%edx, (%eax)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_read_cur
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_disp_U
	jmp	L50
L51:
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_read_cur
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_disp_cur
L50:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE11:
	.globl	_ut_putc
	.def	_ut_putc;	.scl	2;	.type	32;	.endef
_ut_putc:
LFB12:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$56, %esp
	movl	12(%ebp), %eax
	movb	%al, -28(%ebp)
	call	_io_load_eflags
	movl	%eax, -12(%ebp)
	call	_disable_interrupt
	movl	8(%ebp), %eax
	movl	92(%eax), %eax
	movl	(%eax), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$2, %eax
	movl	%eax, -16(%ebp)
	movl	8(%ebp), %eax
	movl	96(%eax), %eax
	movl	(%eax), %eax
	sall	$4, %eax
	movl	%eax, -20(%ebp)
	cmpb	$31, -28(%ebp)
	ja	L54
	cmpb	$10, -28(%ebp)
	jne	L55
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_clear_cur
	movl	8(%ebp), %eax
	movl	92(%eax), %eax
	movl	$0, (%eax)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_read_cur
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_disp_D
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	_io_store_eflags
	jmp	L53
L55:
	cmpb	$9, -28(%ebp)
	jne	L57
	movl	$32, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_putc
	jmp	L58
L59:
	movl	$32, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_putc
L58:
	movl	8(%ebp), %eax
	movl	92(%eax), %eax
	movl	(%eax), %eax
	andl	$3, %eax
	testl	%eax, %eax
	jne	L59
	jmp	L60
L57:
	cmpb	$8, -28(%ebp)
	jne	L60
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_disp_L
	jmp	L60
L54:
	movzbl	-28(%ebp), %eax
	subl	$32, %eax
	movl	_char_to_sjis(,%eax,4), %eax
	movl	%eax, 12(%esp)
	movl	-20(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_disp_sjis
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_disp_R
L60:
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	_io_store_eflags
L53:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE12:
	.globl	_ut_puts
	.def	_ut_puts;	.scl	2;	.type	32;	.endef
_ut_puts:
LFB13:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$56, %esp
	call	_io_load_eflags
	movl	%eax, -16(%ebp)
	call	_disable_interrupt
L69:
	leal	-28(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	_sjis_parse
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	jne	L62
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	_io_store_eflags
	jmp	L70
L62:
	movl	-28(%ebp), %eax
	cmpl	$1, %eax
	jne	L71
	cmpl	$31, -12(%ebp)
	jle	L65
	cmpl	$127, -12(%ebp)
	jg	L65
	movl	-12(%ebp), %eax
	subl	$32, %eax
	movl	_char_to_sjis(,%eax,4), %eax
	movl	%eax, -12(%ebp)
	jmp	L64
L65:
	movl	-12(%ebp), %eax
	movzbl	%al, %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_putc
	addl	$1, 12(%ebp)
	jmp	L69
L71:
	nop
L64:
	movl	8(%ebp), %eax
	movl	116(%eax), %eax
	leal	-1(%eax), %edx
	movl	8(%ebp), %eax
	movl	92(%eax), %eax
	movl	(%eax), %eax
	cmpl	%eax, %edx
	jle	L67
	movl	8(%ebp), %eax
	movl	92(%eax), %eax
	movl	(%eax), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$2, %eax
	movl	%eax, -20(%ebp)
	movl	8(%ebp), %eax
	movl	96(%eax), %eax
	movl	(%eax), %eax
	sall	$4, %eax
	movl	%eax, -24(%ebp)
	movl	-12(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	-24(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_disp_sjis
	jmp	L68
L67:
	movl	$10, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_putc
	movl	8(%ebp), %eax
	movl	92(%eax), %eax
	movl	(%eax), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$2, %eax
	movl	%eax, -20(%ebp)
	movl	8(%ebp), %eax
	movl	96(%eax), %eax
	movl	(%eax), %eax
	sall	$4, %eax
	movl	%eax, -24(%ebp)
	movl	-12(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	-24(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_disp_sjis
L68:
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_disp_R
	movl	-28(%ebp), %eax
	addl	%eax, 12(%ebp)
	jmp	L69
L70:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE13:
	.globl	_cursor_set
	.def	_cursor_set;	.scl	2;	.type	32;	.endef
_cursor_set:
LFB14:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$4, %esp
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_clear_cur
	cmpl	$0, 12(%ebp)
	jns	L73
	movl	$0, 12(%ebp)
L73:
	movl	8(%ebp), %eax
	movl	116(%eax), %eax
	cmpl	%eax, 12(%ebp)
	jl	L74
	movl	8(%ebp), %eax
	movl	116(%eax), %eax
	subl	$1, %eax
	movl	%eax, 12(%ebp)
L74:
	cmpl	$0, 16(%ebp)
	jns	L75
	movl	$0, 16(%ebp)
L75:
	movl	8(%ebp), %eax
	movl	120(%eax), %eax
	cmpl	%eax, 16(%ebp)
	jl	L76
	movl	8(%ebp), %eax
	movl	120(%eax), %eax
	subl	$1, %eax
	movl	%eax, 16(%ebp)
L76:
	movl	8(%ebp), %eax
	movl	92(%eax), %eax
	movl	12(%ebp), %edx
	movl	%edx, (%eax)
	movl	8(%ebp), %eax
	movl	96(%eax), %eax
	movl	16(%ebp), %edx
	movl	%edx, (%eax)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_read_cur
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_disp_cur
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE14:
	.globl	_pset
	.def	_pset;	.scl	2;	.type	32;	.endef
_pset:
LFB15:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%ebx
	.cfi_offset 3, -12
	cmpl	$0, 12(%ebp)
	js	L81
	movl	8(%ebp), %eax
	movl	132(%eax), %eax
	cmpl	%eax, 12(%ebp)
	jge	L81
	cmpl	$0, 16(%ebp)
	js	L81
	movl	8(%ebp), %eax
	movl	136(%eax), %eax
	cmpl	%eax, 16(%ebp)
	jge	L81
	movl	8(%ebp), %eax
	movl	(%eax), %ecx
	movl	8(%ebp), %eax
	movl	128(%eax), %edx
	movl	16(%ebp), %eax
	addl	%eax, %edx
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	imull	%eax, %edx
	movl	8(%ebp), %eax
	movl	124(%eax), %ebx
	movl	12(%ebp), %eax
	addl	%ebx, %eax
	addl	%edx, %eax
	addl	%ecx, %eax
	movl	20(%ebp), %edx
	movb	%dl, (%eax)
	movl	8(%ebp), %eax
	movl	16(%eax), %edx
	movl	8(%ebp), %eax
	movl	124(%eax), %eax
	addl	%edx, %eax
	addl	%eax, 12(%ebp)
	movl	8(%ebp), %eax
	movl	20(%eax), %edx
	movl	8(%ebp), %eax
	movl	128(%eax), %eax
	addl	%edx, %eax
	addl	%eax, 16(%ebp)
	movl	_shtctl, %eax
	movl	4(%eax), %edx
	movl	_shtctl, %eax
	movl	8(%eax), %eax
	imull	16(%ebp), %eax
	movl	%eax, %ecx
	movl	12(%ebp), %eax
	addl	%ecx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	movzwl	(%eax), %eax
	movzwl	%ax, %edx
	movl	8(%ebp), %eax
	movl	4(%eax), %eax
	cmpl	%eax, %edx
	jne	L77
	movl	_binfo, %eax
	movl	8(%eax), %edx
	movl	_binfo, %eax
	movzwl	4(%eax), %eax
	cwtl
	imull	16(%ebp), %eax
	movl	%eax, %ecx
	movl	12(%ebp), %eax
	addl	%ecx, %eax
	addl	%edx, %eax
	movl	20(%ebp), %edx
	movb	%dl, (%eax)
	jmp	L77
L81:
	nop
L77:
	movl	-4(%ebp), %ebx
	leave
	.cfi_restore 5
	.cfi_restore 3
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE15:
	.globl	_pget
	.def	_pget;	.scl	2;	.type	32;	.endef
_pget:
LFB16:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%ebx
	.cfi_offset 3, -12
	cmpl	$0, 12(%ebp)
	js	L83
	movl	8(%ebp), %eax
	movl	132(%eax), %eax
	cmpl	%eax, 12(%ebp)
	jge	L83
	cmpl	$0, 16(%ebp)
	js	L83
	movl	8(%ebp), %eax
	movl	136(%eax), %eax
	cmpl	%eax, 16(%ebp)
	jl	L84
L83:
	movl	$0, %eax
	jmp	L85
L84:
	movl	8(%ebp), %eax
	movl	(%eax), %ecx
	movl	8(%ebp), %eax
	movl	128(%eax), %edx
	movl	16(%ebp), %eax
	addl	%eax, %edx
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	imull	%eax, %edx
	movl	8(%ebp), %eax
	movl	124(%eax), %ebx
	movl	12(%ebp), %eax
	addl	%ebx, %eax
	addl	%edx, %eax
	addl	%ecx, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
L85:
	movl	-4(%ebp), %ebx
	leave
	.cfi_restore 5
	.cfi_restore 3
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE16:
	.globl	_ut_strlen
	.def	_ut_strlen;	.scl	2;	.type	32;	.endef
_ut_strlen:
LFB17:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	movl	$0, -4(%ebp)
	jmp	L87
L88:
	addl	$1, -4(%ebp)
	addl	$1, 8(%ebp)
L87:
	movl	8(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	L88
	movl	-4(%ebp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE17:
	.globl	_sprintf_1x
	.def	_sprintf_1x;	.scl	2;	.type	32;	.endef
_sprintf_1x:
LFB18:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%ebx
	.cfi_offset 3, -12
	andl	$15, 12(%ebp)
	cmpl	$9, 12(%ebp)
	ja	L91
	movl	12(%ebp), %eax
	leal	48(%eax), %ebx
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	leal	1(%eax), %ecx
	movl	8(%ebp), %edx
	movl	%ecx, (%edx)
	movl	%ebx, %edx
	movb	%dl, (%eax)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movb	$0, (%eax)
	jmp	L93
L91:
	movl	12(%ebp), %eax
	leal	55(%eax), %ebx
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	leal	1(%eax), %ecx
	movl	8(%ebp), %edx
	movl	%ecx, (%edx)
	movl	%ebx, %edx
	movb	%dl, (%eax)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movb	$0, (%eax)
L93:
	nop
	movl	-4(%ebp), %ebx
	leave
	.cfi_restore 5
	.cfi_restore 3
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE18:
	.globl	_sprintf_x
	.def	_sprintf_x;	.scl	2;	.type	32;	.endef
_sprintf_x:
LFB19:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	cmpl	$15, 12(%ebp)
	jbe	L95
	movl	12(%ebp), %eax
	shrl	$4, %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_sprintf_x
L95:
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_sprintf_1x
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE19:
	.globl	_sprintf_u
	.def	_sprintf_u;	.scl	2;	.type	32;	.endef
_sprintf_u:
LFB20:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%ebx
	subl	$20, %esp
	.cfi_offset 3, -12
	cmpl	$9, 12(%ebp)
	jbe	L97
	movl	12(%ebp), %eax
	movl	$-858993459, %edx
	mull	%edx
	movl	%edx, %eax
	shrl	$3, %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_sprintf_u
L97:
	movl	12(%ebp), %ecx
	movl	$-858993459, %edx
	movl	%ecx, %eax
	mull	%edx
	shrl	$3, %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	addl	%eax, %eax
	subl	%eax, %ecx
	movl	%ecx, %edx
	movl	%edx, %eax
	leal	48(%eax), %ebx
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	leal	1(%eax), %ecx
	movl	8(%ebp), %edx
	movl	%ecx, (%edx)
	movl	%ebx, %edx
	movb	%dl, (%eax)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movb	$0, (%eax)
	nop
	movl	-4(%ebp), %ebx
	leave
	.cfi_restore 5
	.cfi_restore 3
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE20:
	.globl	_printf_x
	.def	_printf_x;	.scl	2;	.type	32;	.endef
_printf_x:
LFB21:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$88, %esp
	leal	-58(%ebp), %eax
	movl	%eax, -64(%ebp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-64(%ebp), %eax
	movl	%eax, (%esp)
	call	_sprintf_x
	leal	-58(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_puts
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE21:
	.globl	_sprintf_d
	.def	_sprintf_d;	.scl	2;	.type	32;	.endef
_sprintf_d:
LFB22:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	cmpl	$0, 12(%ebp)
	jns	L100
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	leal	1(%eax), %ecx
	movl	8(%ebp), %edx
	movl	%ecx, (%edx)
	movb	$45, (%eax)
	negl	12(%ebp)
L100:
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_sprintf_u
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE22:
	.globl	_printf_u
	.def	_printf_u;	.scl	2;	.type	32;	.endef
_printf_u:
LFB23:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	cmpl	$9, 12(%ebp)
	jbe	L102
	movl	12(%ebp), %eax
	movl	$-858993459, %edx
	mull	%edx
	movl	%edx, %eax
	shrl	$3, %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_printf_u
L102:
	movl	12(%ebp), %ecx
	movl	$-858993459, %edx
	movl	%ecx, %eax
	mull	%edx
	shrl	$3, %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	addl	%eax, %eax
	subl	%eax, %ecx
	movl	%ecx, %edx
	movl	%edx, %eax
	addl	$48, %eax
	movzbl	%al, %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_putc
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE23:
	.globl	_printf_d
	.def	_printf_d;	.scl	2;	.type	32;	.endef
_printf_d:
LFB24:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	cmpl	$0, 12(%ebp)
	jns	L104
	movl	$45, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_putc
	negl	12(%ebp)
L104:
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_printf_u
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE24:
	.globl	_vsprintf_param
	.def	_vsprintf_param;	.scl	2;	.type	32;	.endef
_vsprintf_param:
LFB25:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	movl	20(%ebp), %eax
	movl	$0, (%eax)
	movl	20(%ebp), %eax
	movl	(%eax), %edx
	movl	12(%ebp), %eax
	movl	%edx, (%eax)
	movl	16(%ebp), %eax
	movl	$32, (%eax)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	leal	1(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, (%eax)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movzbl	(%eax), %eax
	cmpb	$45, %al
	jne	L106
	movl	12(%ebp), %eax
	movl	$1, (%eax)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	leal	1(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, (%eax)
L106:
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movzbl	(%eax), %eax
	cmpb	$48, %al
	jne	L108
	movl	16(%ebp), %eax
	movl	$48, (%eax)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	leal	1(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, (%eax)
	jmp	L108
L110:
	movl	20(%ebp), %eax
	movl	(%eax), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	addl	%eax, %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movzbl	(%eax), %eax
	movsbl	%al, %eax
	addl	%edx, %eax
	leal	-48(%eax), %edx
	movl	20(%ebp), %eax
	movl	%edx, (%eax)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	leal	1(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, (%eax)
L108:
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movzbl	(%eax), %eax
	cmpb	$47, %al
	jle	L111
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movzbl	(%eax), %eax
	cmpb	$57, %al
	jle	L110
L111:
	nop
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE25:
	.globl	_vsprintf_pexec
	.def	_vsprintf_pexec;	.scl	2;	.type	32;	.endef
_vsprintf_pexec:
LFB26:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_strlen
	movl	%eax, -16(%ebp)
	movl	24(%ebp), %eax
	cmpl	-16(%ebp), %eax
	jle	L120
	cmpl	$0, 16(%ebp)
	je	L115
	movl	-16(%ebp), %eax
	movl	%eax, -12(%ebp)
	jmp	L116
L117:
	movl	12(%ebp), %eax
	movl	(%eax), %eax
	leal	1(%eax), %ecx
	movl	12(%ebp), %edx
	movl	%ecx, (%edx)
	movb	$32, (%eax)
	addl	$1, -12(%ebp)
L116:
	movl	-12(%ebp), %eax
	cmpl	24(%ebp), %eax
	jl	L117
	movl	12(%ebp), %eax
	movl	(%eax), %eax
	movb	$0, (%eax)
	jmp	L112
L115:
	movl	12(%ebp), %eax
	movl	(%eax), %edx
	movl	24(%ebp), %eax
	subl	-16(%ebp), %eax
	addl	%eax, %edx
	movl	12(%ebp), %eax
	movl	%edx, (%eax)
	movl	12(%ebp), %eax
	movl	(%eax), %eax
	movb	$0, (%eax)
	movl	-16(%ebp), %eax
	movl	24(%ebp), %edx
	subl	-16(%ebp), %edx
	movl	%edx, %ecx
	movl	8(%ebp), %edx
	addl	%ecx, %edx
	movl	%eax, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	_memmove
	movl	$0, -12(%ebp)
	jmp	L118
L119:
	movl	-12(%ebp), %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movl	20(%ebp), %edx
	movb	%dl, (%eax)
	addl	$1, -12(%ebp)
L118:
	movl	24(%ebp), %eax
	subl	-16(%ebp), %eax
	cmpl	%eax, -12(%ebp)
	jl	L119
	jmp	L112
L120:
	nop
L112:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE26:
	.globl	_ut_vsprintf
	.def	_ut_vsprintf;	.scl	2;	.type	32;	.endef
_ut_vsprintf:
LFB27:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$72, %esp
	call	_io_load_eflags
	movl	%eax, -16(%ebp)
	call	_disable_interrupt
	movl	12(%ebp), %eax
	movl	%eax, -28(%ebp)
	jmp	L122
L134:
	movl	-28(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$37, %al
	je	L123
	movl	-28(%ebp), %edx
	movl	8(%ebp), %eax
	leal	1(%eax), %ecx
	movl	%ecx, 8(%ebp)
	movzbl	(%edx), %edx
	movb	%dl, (%eax)
	jmp	L124
L123:
	leal	-40(%ebp), %eax
	movl	%eax, 12(%esp)
	leal	-36(%ebp), %eax
	movl	%eax, 8(%esp)
	leal	-32(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	_vsprintf_param
	movl	-28(%ebp), %eax
	movzbl	(%eax), %eax
	movsbl	%al, %eax
	subl	$99, %eax
	cmpl	$21, %eax
	ja	L125
	movl	L127(,%eax,4), %eax
	jmp	*%eax
	.data
	.align 4
L127:
	.long	L131
	.long	L130
	.long	L125
	.long	L125
	.long	L125
	.long	L125
	.long	L125
	.long	L125
	.long	L125
	.long	L125
	.long	L125
	.long	L125
	.long	L125
	.long	L125
	.long	L125
	.long	L125
	.long	L129
	.long	L125
	.long	L128
	.long	L125
	.long	L125
	.long	L126
	.text
L131:
	movl	16(%ebp), %eax
	leal	4(%eax), %edx
	movl	%edx, 16(%ebp)
	movl	(%eax), %eax
	movl	%eax, -20(%ebp)
	movl	8(%ebp), %eax
	movl	%eax, -24(%ebp)
	movl	8(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, 8(%ebp)
	movl	-20(%ebp), %edx
	movb	%dl, (%eax)
	movl	8(%ebp), %eax
	movb	$0, (%eax)
	movl	-40(%ebp), %ecx
	movl	-36(%ebp), %edx
	movl	-32(%ebp), %eax
	movl	%ecx, 16(%esp)
	movl	%edx, 12(%esp)
	movl	%eax, 8(%esp)
	leal	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	_vsprintf_pexec
	jmp	L124
L129:
	movl	16(%ebp), %eax
	leal	4(%eax), %edx
	movl	%edx, 16(%ebp)
	movl	(%eax), %eax
	movl	%eax, -12(%ebp)
	movl	8(%ebp), %eax
	movl	%eax, -24(%ebp)
	jmp	L132
L133:
	movl	-12(%ebp), %edx
	leal	1(%edx), %eax
	movl	%eax, -12(%ebp)
	movl	8(%ebp), %eax
	leal	1(%eax), %ecx
	movl	%ecx, 8(%ebp)
	movzbl	(%edx), %edx
	movb	%dl, (%eax)
L132:
	movl	-12(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	L133
	movl	8(%ebp), %eax
	movb	$0, (%eax)
	movl	-40(%ebp), %ecx
	movl	-36(%ebp), %edx
	movl	-32(%ebp), %eax
	movl	%ecx, 16(%esp)
	movl	%edx, 12(%esp)
	movl	%eax, 8(%esp)
	leal	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	_vsprintf_pexec
	jmp	L124
L130:
	movl	16(%ebp), %eax
	leal	4(%eax), %edx
	movl	%edx, 16(%ebp)
	movl	(%eax), %eax
	movl	%eax, -20(%ebp)
	movl	8(%ebp), %eax
	movl	%eax, -24(%ebp)
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_sprintf_d
	movl	-40(%ebp), %ecx
	movl	-36(%ebp), %edx
	movl	-32(%ebp), %eax
	movl	%ecx, 16(%esp)
	movl	%edx, 12(%esp)
	movl	%eax, 8(%esp)
	leal	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	_vsprintf_pexec
	jmp	L124
L128:
	movl	16(%ebp), %eax
	leal	4(%eax), %edx
	movl	%edx, 16(%ebp)
	movl	(%eax), %eax
	movl	%eax, -20(%ebp)
	movl	8(%ebp), %eax
	movl	%eax, -24(%ebp)
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_sprintf_u
	movl	-40(%ebp), %ecx
	movl	-36(%ebp), %edx
	movl	-32(%ebp), %eax
	movl	%ecx, 16(%esp)
	movl	%edx, 12(%esp)
	movl	%eax, 8(%esp)
	leal	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	_vsprintf_pexec
	jmp	L124
L126:
	movl	16(%ebp), %eax
	leal	4(%eax), %edx
	movl	%edx, 16(%ebp)
	movl	(%eax), %eax
	movl	%eax, -20(%ebp)
	movl	8(%ebp), %eax
	movl	%eax, -24(%ebp)
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_sprintf_x
	movl	-40(%ebp), %ecx
	movl	-36(%ebp), %edx
	movl	-32(%ebp), %eax
	movl	%ecx, 16(%esp)
	movl	%edx, 12(%esp)
	movl	%eax, 8(%esp)
	leal	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	_vsprintf_pexec
	jmp	L124
L125:
	movl	8(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, 8(%ebp)
	movb	$37, (%eax)
	movl	-28(%ebp), %edx
	movl	8(%ebp), %eax
	leal	1(%eax), %ecx
	movl	%ecx, 8(%ebp)
	movzbl	(%edx), %edx
	movb	%dl, (%eax)
	nop
L124:
	movl	-28(%ebp), %eax
	addl	$1, %eax
	movl	%eax, -28(%ebp)
L122:
	movl	-28(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	L134
	movl	8(%ebp), %eax
	movb	$0, (%eax)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	_io_store_eflags
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE27:
	.globl	_ut_printf
	.def	_ut_printf;	.scl	2;	.type	32;	.endef
_ut_printf:
LFB28:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$1064, %esp
	call	_io_load_eflags
	movl	%eax, -12(%ebp)
	call	_disable_interrupt
	leal	16(%ebp), %eax
	movl	%eax, -16(%ebp)
	movl	-16(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-1040(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_vsprintf
	leal	-1040(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_puts
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	_io_store_eflags
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE28:
	.globl	_dot
	.def	_dot;	.scl	2;	.type	32;	.endef
_dot:
LFB29:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	movl	_binfo, %eax
	movl	8(%eax), %ecx
	movl	_binfo, %eax
	movzwl	4(%eax), %eax
	movswl	%ax, %edx
	movl	_y.1, %eax
	imull	%eax, %edx
	movl	_x.0, %eax
	addl	%edx, %eax
	addl	%ecx, %eax
	movl	8(%ebp), %edx
	movb	%dl, (%eax)
	movl	_binfo, %eax
	movl	8(%eax), %ecx
	movl	_binfo, %eax
	movzwl	4(%eax), %eax
	movswl	%ax, %edx
	movl	_y.1, %eax
	imull	%eax, %edx
	movl	_x.0, %eax
	addl	$1, %eax
	addl	%edx, %eax
	addl	%ecx, %eax
	movl	8(%ebp), %edx
	movb	%dl, (%eax)
	movl	_binfo, %eax
	movl	8(%eax), %ecx
	movl	_binfo, %eax
	movzwl	4(%eax), %eax
	movswl	%ax, %edx
	movl	_y.1, %eax
	imull	%eax, %edx
	movl	_x.0, %eax
	addl	$2, %eax
	addl	%edx, %eax
	addl	%ecx, %eax
	movl	8(%ebp), %edx
	movb	%dl, (%eax)
	movl	_binfo, %eax
	movl	8(%eax), %ecx
	movl	_binfo, %eax
	movzwl	4(%eax), %eax
	cwtl
	movl	_y.1, %edx
	addl	$1, %edx
	imull	%eax, %edx
	movl	_x.0, %eax
	addl	%edx, %eax
	addl	%ecx, %eax
	movl	8(%ebp), %edx
	movb	%dl, (%eax)
	movl	_binfo, %eax
	movl	8(%eax), %ecx
	movl	_binfo, %eax
	movzwl	4(%eax), %eax
	cwtl
	movl	_y.1, %edx
	addl	$1, %edx
	imull	%eax, %edx
	movl	_x.0, %eax
	addl	$1, %eax
	addl	%edx, %eax
	addl	%ecx, %eax
	movl	8(%ebp), %edx
	movb	%dl, (%eax)
	movl	_binfo, %eax
	movl	8(%eax), %ecx
	movl	_binfo, %eax
	movzwl	4(%eax), %eax
	cwtl
	movl	_y.1, %edx
	addl	$1, %edx
	imull	%eax, %edx
	movl	_x.0, %eax
	addl	$2, %eax
	addl	%edx, %eax
	addl	%ecx, %eax
	movl	8(%ebp), %edx
	movb	%dl, (%eax)
	movl	_binfo, %eax
	movl	8(%eax), %ecx
	movl	_binfo, %eax
	movzwl	4(%eax), %eax
	cwtl
	movl	_y.1, %edx
	addl	$2, %edx
	imull	%eax, %edx
	movl	_x.0, %eax
	addl	%edx, %eax
	addl	%ecx, %eax
	movl	8(%ebp), %edx
	movb	%dl, (%eax)
	movl	_binfo, %eax
	movl	8(%eax), %ecx
	movl	_binfo, %eax
	movzwl	4(%eax), %eax
	cwtl
	movl	_y.1, %edx
	addl	$2, %edx
	imull	%eax, %edx
	movl	_x.0, %eax
	addl	$1, %eax
	addl	%edx, %eax
	addl	%ecx, %eax
	movl	8(%ebp), %edx
	movb	%dl, (%eax)
	movl	_binfo, %eax
	movl	8(%eax), %ecx
	movl	_binfo, %eax
	movzwl	4(%eax), %eax
	cwtl
	movl	_y.1, %edx
	addl	$2, %edx
	imull	%eax, %edx
	movl	_x.0, %eax
	addl	$2, %eax
	addl	%edx, %eax
	addl	%ecx, %eax
	movl	8(%ebp), %edx
	movb	%dl, (%eax)
	movl	_x.0, %eax
	addl	$4, %eax
	movl	%eax, _x.0
	movl	_binfo, %eax
	movzwl	4(%eax), %eax
	movswl	%ax, %edx
	movl	_x.0, %eax
	cmpl	%eax, %edx
	jg	L140
	movl	$1, _x.0
	movl	_y.1, %eax
	addl	$4, %eax
	movl	%eax, _y.1
	movl	_binfo, %eax
	movzwl	6(%eax), %eax
	movswl	%ax, %edx
	movl	_y.1, %eax
	cmpl	%eax, %edx
	jg	L140
	movl	$1, _y.1
	movl	$0, -4(%ebp)
	jmp	L138
L139:
	movl	_binfo, %eax
	movl	8(%eax), %edx
	movl	-4(%ebp), %eax
	addl	%edx, %eax
	movb	$7, (%eax)
	addl	$1, -4(%ebp)
L138:
	movl	_binfo, %eax
	movzwl	4(%eax), %eax
	movswl	%ax, %edx
	movl	_binfo, %eax
	movzwl	6(%eax), %eax
	cwtl
	imull	%edx, %eax
	cmpl	%eax, -4(%ebp)
	jl	L139
L140:
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE29:
	.globl	_fatal_a
	.def	_fatal_a;	.scl	2;	.type	32;	.endef
_fatal_a:
LFB30:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$1064, %esp
	call	_disable_interrupt
	movl	_main_sheet, %eax
	testl	%eax, %eax
	je	L145
	leal	12(%ebp), %eax
	movl	%eax, -16(%ebp)
	movl	-16(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-1040(%ebp), %eax
	movl	%eax, (%esp)
	call	_ut_vsprintf
	movl	_main_sheet, %eax
	movl	%eax, (%esp)
	call	_select_main_disp
	movl	_main_sheet, %eax
	movl	108(%eax), %eax
	movl	$7, (%eax)
	movl	_main_sheet, %eax
	movl	104(%eax), %eax
	movl	$1, (%eax)
	movl	_main_sheet, %eax
	leal	-1040(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	_ut_puts
	movl	$0, -12(%ebp)
	jmp	L143
L144:
	movl	_main_sheet, %eax
	movl	(%eax), %edx
	movl	-12(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %edx
	movl	_binfo, %eax
	movl	8(%eax), %ecx
	movl	-12(%ebp), %eax
	addl	%ecx, %eax
	movb	%dl, (%eax)
	addl	$1, -12(%ebp)
L143:
	movl	_binfo, %eax
	movzwl	6(%eax), %eax
	movswl	%ax, %edx
	movl	_binfo, %eax
	movzwl	4(%eax), %eax
	cwtl
	imull	%edx, %eax
	cmpl	%eax, -12(%ebp)
	jl	L144
L145:
	call	_disable_interrupt
	call	_gonbe_hlt
	jmp	L145
	.cfi_endproc
LFE30:
	.globl	_clear_screen
	.def	_clear_screen;	.scl	2;	.type	32;	.endef
_clear_screen:
LFB31:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$36, %esp
	movl	12(%ebp), %eax
	movb	%al, -20(%ebp)
	movl	$0, -8(%ebp)
	jmp	L147
L150:
	movl	$0, -4(%ebp)
	jmp	L148
L149:
	movsbl	-20(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	-4(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_pset
	addl	$1, -4(%ebp)
L148:
	movl	8(%ebp), %eax
	movl	132(%eax), %eax
	cmpl	%eax, -4(%ebp)
	jl	L149
	addl	$1, -8(%ebp)
L147:
	movl	8(%ebp), %eax
	movl	136(%eax), %eax
	cmpl	%eax, -8(%ebp)
	jl	L150
	nop
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE31:
	.data
	.align 4
_y.1:
	.long	1
	.align 4
_x.0:
	.long	1
	.ident	"GCC: (GNU) 10.2.0"
	.def	_io_load_eflags;	.scl	2;	.type	32;	.endef
	.def	_disable_interrupt;	.scl	2;	.type	32;	.endef
	.def	_io_store_eflags;	.scl	2;	.type	32;	.endef
	.def	_strlen;	.scl	2;	.type	32;	.endef
	.def	_memmove;	.scl	2;	.type	32;	.endef
	.def	_select_main_disp;	.scl	2;	.type	32;	.endef
	.def	_gonbe_hlt;	.scl	2;	.type	32;	.endef
