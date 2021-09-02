	.file	"sedit.c"
	.text
	.globl	_sed_buf
	.bss
	.align 4
_sed_buf:
	.space 4
.lcomm _no_of_line,4,4
.lcomm _buf_len,4,4
.lcomm _xpos,4,4
.lcomm _ypos,4,4
.lcomm _s_xpos,4,4
.lcomm _s_ypos,4,4
	.text
	.def	_get_line_top;	.scl	3;	.type	32;	.endef
_get_line_top:
LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	cmpl	$0, 8(%ebp)
	jne	L4
	movl	$0, %eax
	jmp	L3
L5:
	movl	_sed_buf, %edx
	movl	8(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	cmpb	$10, %al
	jne	L4
	movl	8(%ebp), %eax
	addl	$1, %eax
	jmp	L3
L4:
	subl	$1, 8(%ebp)
	cmpl	$0, 8(%ebp)
	jne	L5
	movl	$0, %eax
L3:
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE0:
	.def	_disp_cursor;	.scl	3;	.type	32;	.endef
_disp_cursor:
LFB1:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	_xpos, %eax
	movl	_s_xpos, %ecx
	subl	%ecx, %eax
	movl	%eax, %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$2, %eax
	movl	%eax, -16(%ebp)
	movl	_ypos, %eax
	movl	_s_ypos, %edx
	subl	%edx, %eax
	sall	$4, %eax
	addl	$15, %eax
	movl	%eax, -20(%ebp)
	movl	$0, -12(%ebp)
	jmp	L7
L8:
	movl	-16(%ebp), %edx
	movl	-12(%ebp), %eax
	leal	(%edx,%eax), %ecx
	movl	_cmd_sht, %eax
	movl	8(%ebp), %edx
	movl	%edx, 12(%esp)
	movl	-20(%ebp), %edx
	movl	%edx, 8(%esp)
	movl	%ecx, 4(%esp)
	movl	%eax, (%esp)
	call	_pset
	addl	$1, -12(%ebp)
L7:
	cmpl	$11, -12(%ebp)
	jle	L8
	nop
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE1:
	.def	_search_line;	.scl	3;	.type	32;	.endef
_search_line:
LFB2:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	$0, -12(%ebp)
	movl	$0, -16(%ebp)
	jmp	L10
L13:
	movl	_sed_buf, %edx
	movl	-12(%ebp), %eax
	addl	%edx, %eax
	movl	$10, 4(%esp)
	movl	%eax, (%esp)
	call	_strchr
	movl	%eax, -20(%ebp)
	cmpl	$0, -20(%ebp)
	jne	L11
	movl	-12(%ebp), %eax
	jmp	L12
L11:
	addl	$1, -16(%ebp)
	movl	_sed_buf, %edx
	movl	-20(%ebp), %eax
	subl	%edx, %eax
	addl	$1, %eax
	movl	%eax, -12(%ebp)
L10:
	movl	-16(%ebp), %eax
	cmpl	8(%ebp), %eax
	jl	L13
	movl	-12(%ebp), %eax
L12:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE2:
	.def	_cursor_to_ptr;	.scl	3;	.type	32;	.endef
_cursor_to_ptr:
LFB3:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	_ypos, %eax
	movl	%eax, (%esp)
	call	_search_line
	movl	%eax, -12(%ebp)
	movl	$0, -20(%ebp)
	jmp	L15
L19:
	movl	_sed_buf, %edx
	movl	-12(%ebp), %eax
	addl	%eax, %edx
	movl	_ypos, %eax
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	leal	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	_sed_disp_1_char
	movl	%eax, -16(%ebp)
	cmpl	$99, -16(%ebp)
	jg	L16
	movl	-16(%ebp), %eax
	addl	%eax, -12(%ebp)
	jmp	L15
L16:
	cmpl	$100, -16(%ebp)
	jne	L17
	movl	-12(%ebp), %eax
	jmp	L20
L17:
	cmpl	$101, -16(%ebp)
	jne	L15
	movl	-12(%ebp), %eax
	jmp	L20
L15:
	movl	-20(%ebp), %edx
	movl	_xpos, %eax
	cmpl	%eax, %edx
	jl	L19
	movl	-12(%ebp), %eax
L20:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE3:
	.def	_ptr_to_cursor;	.scl	3;	.type	32;	.endef
_ptr_to_cursor:
LFB4:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$56, %esp
	movl	$0, -16(%ebp)
	movl	_sed_buf, %eax
	movl	%eax, -12(%ebp)
	movl	$0, _xpos
	movl	$0, _ypos
L27:
	movl	8(%ebp), %eax
	cmpl	-16(%ebp), %eax
	jle	L34
	movl	$10, 4(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	_strchr
	movl	%eax, -20(%ebp)
	cmpl	$0, -20(%ebp)
	je	L35
	movl	-20(%ebp), %eax
	addl	$1, %eax
	movl	_sed_buf, %edx
	subl	%edx, %eax
	cmpl	%eax, 8(%ebp)
	jl	L36
	movl	_ypos, %eax
	addl	$1, %eax
	movl	%eax, _ypos
	movl	-20(%ebp), %eax
	addl	$1, %eax
	movl	%eax, -12(%ebp)
	jmp	L27
L35:
	nop
	jmp	L25
L36:
	nop
L25:
	movl	$0, -28(%ebp)
L32:
	movl	-28(%ebp), %eax
	movl	%eax, _xpos
	movl	_ypos, %eax
	movl	-12(%ebp), %edx
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	leal	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	_sed_disp_1_char
	movl	%eax, -24(%ebp)
	cmpl	$99, -24(%ebp)
	jg	L28
	movl	-24(%ebp), %eax
	addl	%eax, -12(%ebp)
	jmp	L29
L28:
	cmpl	$100, -24(%ebp)
	je	L37
	cmpl	$101, -24(%ebp)
	je	L38
L29:
	movl	_sed_buf, %edx
	movl	-12(%ebp), %eax
	subl	%edx, %eax
	cmpl	%eax, 8(%ebp)
	jl	L39
	jmp	L32
L34:
	nop
	jmp	L21
L37:
	nop
	jmp	L21
L38:
	nop
	jmp	L21
L39:
	nop
L21:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE4:
	.data
LC0:
	.ascii "\201\253\0"
	.text
	.def	_sed_disp_1_char;	.scl	3;	.type	32;	.endef
_sed_disp_1_char:
LFB5:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%ebx
	subl	$52, %esp
	.cfi_offset 3, -12
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	_s_xpos, %ecx
	subl	%ecx, %eax
	movl	%eax, %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$2, %eax
	movl	%eax, -16(%ebp)
	movl	_s_ypos, %edx
	movl	12(%ebp), %eax
	subl	%edx, %eax
	sall	$4, %eax
	movl	%eax, -28(%ebp)
	leal	-36(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	16(%ebp), %eax
	movl	%eax, (%esp)
	call	_sjis_parse
	movl	%eax, -32(%ebp)
	cmpl	$0, -32(%ebp)
	jne	L41
	movl	$100, %eax
	jmp	L53
L41:
	movl	-36(%ebp), %eax
	cmpl	$1, %eax
	jne	L43
	movl	$0, -24(%ebp)
	jmp	L44
L49:
	movl	$0, -20(%ebp)
	jmp	L45
L48:
	movl	_cmd_sht, %eax
	movl	112(%eax), %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	jne	L46
	movl	_cmd_sht, %eax
	movl	108(%eax), %eax
	movl	(%eax), %edx
	movl	-28(%ebp), %ecx
	movl	-24(%ebp), %eax
	leal	(%ecx,%eax), %ebx
	movl	-16(%ebp), %ecx
	movl	-20(%ebp), %eax
	addl	%eax, %ecx
	movl	_cmd_sht, %eax
	movl	%edx, 12(%esp)
	movl	%ebx, 8(%esp)
	movl	%ecx, 4(%esp)
	movl	%eax, (%esp)
	call	_pset
	jmp	L47
L46:
	movl	_cmd_sht, %eax
	movl	104(%eax), %eax
	movl	(%eax), %edx
	movl	-28(%ebp), %ecx
	movl	-24(%ebp), %eax
	leal	(%ecx,%eax), %ebx
	movl	-16(%ebp), %ecx
	movl	-20(%ebp), %eax
	addl	%eax, %ecx
	movl	_cmd_sht, %eax
	movl	%edx, 12(%esp)
	movl	%ebx, 8(%esp)
	movl	%ecx, 4(%esp)
	movl	%eax, (%esp)
	call	_pset
L47:
	addl	$1, -20(%ebp)
L45:
	cmpl	$5, -20(%ebp)
	jle	L48
	addl	$1, -24(%ebp)
L44:
	cmpl	$15, -24(%ebp)
	jle	L49
	cmpl	$9, -32(%ebp)
	jne	L50
	movl	$0, -12(%ebp)
L51:
	addl	$1, -12(%ebp)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	leal	1(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, (%eax)
	addl	$12, -16(%ebp)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	andl	$3, %eax
	testl	%eax, %eax
	jne	L51
	movl	$1, %eax
	jmp	L53
L50:
	cmpl	$10, -32(%ebp)
	jne	L52
	movl	-28(%ebp), %eax
	leal	4(%eax), %edx
	movl	_cmd_sht, %eax
	movl	$LC0, 12(%esp)
	movl	%edx, 8(%esp)
	movl	-16(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	_disp_char
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	leal	1(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, (%eax)
	movl	$101, %eax
	jmp	L53
L52:
	movl	-28(%ebp), %eax
	leal	4(%eax), %ecx
	movl	_cmd_sht, %eax
	movl	16(%ebp), %edx
	movl	%edx, 12(%esp)
	movl	%ecx, 8(%esp)
	movl	-16(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	_disp_char
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	leal	1(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, (%eax)
	movl	$1, %eax
	jmp	L53
L43:
	movl	_cmd_sht, %eax
	movl	16(%ebp), %edx
	movl	%edx, 12(%esp)
	movl	-28(%ebp), %edx
	movl	%edx, 8(%esp)
	movl	-16(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	_disp_char
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	leal	2(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, (%eax)
	movl	$2, %eax
L53:
	movl	-4(%ebp), %ebx
	leave
	.cfi_restore 5
	.cfi_restore 3
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE5:
	.def	_sed_disp_1_line;	.scl	3;	.type	32;	.endef
_sed_disp_1_line:
LFB6:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	$0, -16(%ebp)
L58:
	movl	12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	_sed_disp_1_char
	movl	%eax, -12(%ebp)
	cmpl	$99, -12(%ebp)
	jg	L59
	movl	-12(%ebp), %eax
	addl	%eax, 12(%ebp)
	jmp	L58
L59:
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE6:
	.def	_sed_display;	.scl	3;	.type	32;	.endef
_sed_display:
LFB7:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	_cmd_sht, %eax
	movl	$7, 4(%esp)
	movl	%eax, (%esp)
	call	_clear_screen
	movl	_s_ypos, %eax
	movl	%eax, (%esp)
	call	_search_line
	movl	%eax, -20(%ebp)
	cmpl	$0, -20(%ebp)
	js	L66
	movl	_sed_buf, %edx
	movl	-20(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, -16(%ebp)
	movl	$0, -12(%ebp)
	jmp	L63
L65:
	movl	_s_ypos, %edx
	movl	-12(%ebp), %eax
	addl	%eax, %edx
	movl	-16(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	_sed_disp_1_line
	movl	$10, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	_strchr
	movl	%eax, -16(%ebp)
	cmpl	$0, -16(%ebp)
	je	L67
	addl	$1, -16(%ebp)
	addl	$1, -12(%ebp)
L63:
	cmpl	$19, -12(%ebp)
	jle	L65
	jmp	L60
L66:
	nop
	jmp	L60
L67:
	nop
L60:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE7:
	.def	_redraw;	.scl	3;	.type	32;	.endef
_redraw:
LFB8:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	_ypos, %eax
	movl	_s_ypos, %edx
	subl	%edx, %eax
	movl	%eax, -20(%ebp)
	cmpl	$0, -20(%ebp)
	js	L76
	cmpl	$19, -20(%ebp)
	jg	L76
	movl	$0, -12(%ebp)
	jmp	L72
L75:
	movl	$0, -16(%ebp)
	jmp	L73
L74:
	movl	-20(%ebp), %eax
	sall	$4, %eax
	movl	%eax, %edx
	movl	-12(%ebp), %eax
	addl	%eax, %edx
	movl	_cmd_sht, %eax
	movl	$7, 12(%esp)
	movl	%edx, 8(%esp)
	movl	-16(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	_pset
	addl	$1, -16(%ebp)
L73:
	movl	_binfo, %eax
	movzwl	4(%eax), %eax
	cwtl
	cmpl	%eax, -16(%ebp)
	jl	L74
	addl	$1, -12(%ebp)
L72:
	cmpl	$15, -12(%ebp)
	jle	L75
	call	_cursor_to_ptr
	movl	%eax, (%esp)
	call	_get_line_top
	movl	%eax, -24(%ebp)
	movl	_sed_buf, %edx
	movl	-24(%ebp), %eax
	addl	%eax, %edx
	movl	_ypos, %eax
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	_sed_disp_1_line
	jmp	L68
L76:
	nop
L68:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE8:
	.def	_sed_init;	.scl	3;	.type	32;	.endef
_sed_init:
LFB9:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	movl	_sed_buf, %eax
	movl	$1048576, 8(%esp)
	movl	$0, 4(%esp)
	movl	%eax, (%esp)
	call	_memset
	movl	$0, _no_of_line
	movl	$0, _buf_len
	movl	$0, _xpos
	movl	$0, _ypos
	movl	$0, _s_xpos
	movl	$0, _s_ypos
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE9:
	.data
LC1:
	.ascii "\12\0"
	.align 4
LC2:
	.ascii "F1        ... \203w\203\213\203v\203\201\203b\203Z\201[\203W\12\0"
LC3:
	.ascii "F2        ... \214\273\215\335\215s\215\355\217\234\12\0"
LC4:
	.ascii "F5        ... \203v\203\215\203O\203\211\203\200\217I\227\271\12\0"
	.align 4
LC5:
	.ascii "F6        ... \216w\222\350\215s\224\324\215\206\202\326\224\362\202\324\12\0"
LC6:
	.ascii "---   push any key   ---\0"
	.text
	.def	_sed_help;	.scl	3;	.type	32;	.endef
_sed_help:
LFB10:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	movl	_cmd_sht, %eax
	movl	$LC1, 4(%esp)
	movl	%eax, (%esp)
	call	_ut_printf
	movl	_cmd_sht, %eax
	movl	$LC2, 4(%esp)
	movl	%eax, (%esp)
	call	_ut_printf
	movl	_cmd_sht, %eax
	movl	$LC3, 4(%esp)
	movl	%eax, (%esp)
	call	_ut_printf
	movl	_cmd_sht, %eax
	movl	$LC4, 4(%esp)
	movl	%eax, (%esp)
	call	_ut_printf
	movl	_cmd_sht, %eax
	movl	$LC5, 4(%esp)
	movl	%eax, (%esp)
	call	_ut_printf
	movl	_cmd_sht, %eax
	movl	$LC1, 4(%esp)
	movl	%eax, (%esp)
	call	_ut_printf
	movl	_cmd_sht, %eax
	movl	$LC6, 4(%esp)
	movl	%eax, (%esp)
	call	_ut_printf
	movl	_cmd_sht, %eax
	movl	%eax, (%esp)
	call	_ut_getcA
	movl	_cmd_sht, %eax
	movl	$LC1, 4(%esp)
	movl	%eax, (%esp)
	call	_ut_printf
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE10:
	.data
LC7:
	.ascii "\12\217I\227\271\202\265\202\334\202\267\202\251(y/n) ? \0"
	.text
	.def	_sed_exit;	.scl	3;	.type	32;	.endef
_sed_exit:
LFB11:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	_cmd_sht, %eax
	movl	$7, 4(%esp)
	movl	%eax, (%esp)
	call	_clear_screen
	movl	_cmd_sht, %eax
	movl	$LC7, 4(%esp)
	movl	%eax, (%esp)
	call	_ut_printf
	movl	_cmd_sht, %eax
	movl	%eax, (%esp)
	call	_ut_getc
	movl	%eax, -12(%ebp)
	cmpl	$121, -12(%ebp)
	je	L80
	cmpl	$89, -12(%ebp)
	jne	L81
L80:
	movl	_cmd_sht, %eax
	movl	$LC1, 4(%esp)
	movl	%eax, (%esp)
	call	_ut_printf
	movl	$0, %eax
	jmp	L82
L81:
	call	_sed_display
	movl	$1, %eax
L82:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE11:
	.data
LC8:
	.ascii "\12\215s\224\324\215\206\201F\0"
	.text
	.globl	_sed_jump
	.def	_sed_jump;	.scl	2;	.type	32;	.endef
_sed_jump:
LFB12:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$88, %esp
	movl	_cmd_sht, %eax
	movl	$7, 4(%esp)
	movl	%eax, (%esp)
	call	_clear_screen
	movl	_cmd_sht, %eax
	movl	$LC8, 4(%esp)
	movl	%eax, (%esp)
	call	_ut_printf
	movl	_cmd_sht, %eax
	movl	$64, 8(%esp)
	leal	-72(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	_ut_gets
	leal	-72(%ebp), %eax
	movl	%eax, (%esp)
	call	_atoi
	subl	$1, %eax
	movl	%eax, _ypos
	movl	$0, _xpos
	movl	_ypos, %eax
	testl	%eax, %eax
	jns	L84
	movl	$0, _ypos
	jmp	L85
L84:
	movl	_ypos, %edx
	movl	_no_of_line, %eax
	cmpl	%eax, %edx
	jle	L85
	movl	_no_of_line, %eax
	movl	%eax, _ypos
L85:
	movl	$0, _s_xpos
	movl	_ypos, %eax
	subl	$10, %eax
	movl	%eax, _s_ypos
	movl	_no_of_line, %eax
	leal	-1(%eax), %edx
	movl	_s_ypos, %eax
	cmpl	%eax, %edx
	jg	L86
	movl	_no_of_line, %eax
	subl	$1, %eax
	movl	%eax, _s_ypos
L86:
	movl	_s_ypos, %eax
	testl	%eax, %eax
	jns	L87
	movl	$0, _s_ypos
L87:
	call	_sed_display
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE12:
	.def	_sed_UP;	.scl	3;	.type	32;	.endef
_sed_UP:
LFB13:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	movl	_ypos, %eax
	testl	%eax, %eax
	je	L92
	movl	_ypos, %edx
	movl	_s_ypos, %eax
	cmpl	%eax, %edx
	jg	L91
	movl	_ypos, %eax
	subl	$1, %eax
	movl	%eax, _ypos
	movl	_ypos, %eax
	movl	%eax, _s_ypos
	call	_sed_display
	jmp	L88
L91:
	movl	_ypos, %eax
	subl	$1, %eax
	movl	%eax, _ypos
	jmp	L88
L92:
	nop
L88:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE13:
	.def	_sed_DOWN;	.scl	3;	.type	32;	.endef
_sed_DOWN:
LFB14:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	movl	_ypos, %edx
	movl	_no_of_line, %eax
	cmpl	%eax, %edx
	jge	L97
	movl	_s_ypos, %eax
	leal	18(%eax), %edx
	movl	_ypos, %eax
	cmpl	%eax, %edx
	jge	L96
	movl	_ypos, %eax
	addl	$1, %eax
	movl	%eax, _ypos
	movl	_s_ypos, %eax
	addl	$1, %eax
	movl	%eax, _s_ypos
	call	_sed_display
	jmp	L93
L96:
	movl	_ypos, %eax
	addl	$1, %eax
	movl	%eax, _ypos
	jmp	L93
L97:
	nop
L93:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE14:
	.def	_sed_RIGHT;	.scl	3;	.type	32;	.endef
_sed_RIGHT:
LFB15:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	$0, -12(%ebp)
	call	_cursor_to_ptr
	movl	%eax, -16(%ebp)
	movl	_buf_len, %eax
	cmpl	%eax, -16(%ebp)
	jge	L105
	movl	_sed_buf, %edx
	movl	-16(%ebp), %eax
	addl	%eax, %edx
	leal	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	_sjis_parse
	movl	-20(%ebp), %eax
	addl	%eax, -16(%ebp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	_ptr_to_cursor
	movl	_s_ypos, %eax
	leal	19(%eax), %edx
	movl	_ypos, %eax
	cmpl	%eax, %edx
	jge	L101
	movl	_s_ypos, %eax
	addl	$1, %eax
	movl	%eax, _s_ypos
	movl	$1, -12(%ebp)
L101:
	movl	_s_xpos, %edx
	movl	_xpos, %eax
	cmpl	%eax, %edx
	jle	L102
	movl	_xpos, %eax
	movl	%eax, _s_xpos
	movl	$1, -12(%ebp)
	jmp	L103
L102:
	movl	_s_xpos, %eax
	leal	73(%eax), %edx
	movl	_xpos, %eax
	cmpl	%eax, %edx
	jge	L103
	movl	_xpos, %eax
	subl	$73, %eax
	movl	%eax, _s_xpos
	movl	$1, -12(%ebp)
L103:
	cmpl	$0, -12(%ebp)
	je	L98
	call	_sed_display
	jmp	L98
L105:
	nop
L98:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE15:
	.def	_sed_LEFT;	.scl	3;	.type	32;	.endef
_sed_LEFT:
LFB16:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	$0, -16(%ebp)
	call	_cursor_to_ptr
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	je	L115
	cmpl	$1, -12(%ebp)
	jne	L109
	movl	$0, -12(%ebp)
	jmp	L110
L109:
	movl	_sed_buf, %edx
	movl	-12(%ebp), %eax
	subl	$2, %eax
	addl	%eax, %edx
	leal	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	_sjis_parse
	movl	-20(%ebp), %eax
	subl	%eax, -12(%ebp)
L110:
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	_ptr_to_cursor
	movl	_s_ypos, %edx
	movl	_ypos, %eax
	cmpl	%eax, %edx
	jle	L111
	movl	_ypos, %eax
	movl	%eax, _s_ypos
	movl	$1, -16(%ebp)
L111:
	movl	_s_xpos, %edx
	movl	_xpos, %eax
	cmpl	%eax, %edx
	jle	L112
	movl	_xpos, %eax
	movl	%eax, _s_xpos
	movl	$1, -16(%ebp)
	jmp	L113
L112:
	movl	_s_xpos, %eax
	leal	73(%eax), %edx
	movl	_xpos, %eax
	cmpl	%eax, %edx
	jge	L113
	movl	_xpos, %eax
	subl	$73, %eax
	movl	%eax, _s_xpos
	movl	$1, -16(%ebp)
L113:
	cmpl	$0, -16(%ebp)
	je	L106
	call	_sed_display
	jmp	L106
L115:
	nop
L106:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE16:
	.def	_sed_linedel;	.scl	3;	.type	32;	.endef
_sed_linedel:
LFB17:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%ebx
	subl	$36, %esp
	.cfi_offset 3, -12
	call	_cursor_to_ptr
	movl	%eax, (%esp)
	call	_get_line_top
	movl	%eax, -16(%ebp)
	movl	_sed_buf, %edx
	movl	-16(%ebp), %eax
	addl	%edx, %eax
	movl	$10, 4(%esp)
	movl	%eax, (%esp)
	call	_strchr
	movl	%eax, -20(%ebp)
	cmpl	$0, -20(%ebp)
	jne	L117
	movl	_buf_len, %eax
	movl	%eax, -12(%ebp)
	jmp	L118
L117:
	movl	_sed_buf, %edx
	movl	-20(%ebp), %eax
	subl	%edx, %eax
	addl	$1, %eax
	movl	%eax, -12(%ebp)
	movl	_no_of_line, %eax
	subl	$1, %eax
	movl	%eax, _no_of_line
L118:
	movl	_buf_len, %eax
	subl	-12(%ebp), %eax
	addl	$1, %eax
	movl	%eax, %ecx
	movl	_sed_buf, %edx
	movl	-12(%ebp), %eax
	addl	%eax, %edx
	movl	_sed_buf, %ebx
	movl	-16(%ebp), %eax
	addl	%ebx, %eax
	movl	%ecx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	_memmove
	movl	_buf_len, %edx
	movl	-12(%ebp), %eax
	subl	-16(%ebp), %eax
	movl	%eax, %ecx
	movl	%edx, %eax
	subl	%ecx, %eax
	movl	%eax, _buf_len
	movl	$0, _xpos
	call	_sed_display
	nop
	movl	-4(%ebp), %ebx
	leave
	.cfi_restore 5
	.cfi_restore 3
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE17:
	.def	_sed_BS;	.scl	3;	.type	32;	.endef
_sed_BS:
LFB18:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%esi
	pushl	%ebx
	subl	$32, %esp
	.cfi_offset 6, -12
	.cfi_offset 3, -16
	call	_cursor_to_ptr
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	je	L126
	cmpl	$1, -12(%ebp)
	jne	L122
	movl	$1, -16(%ebp)
	jmp	L123
L122:
	movl	_sed_buf, %edx
	movl	-12(%ebp), %eax
	subl	$2, %eax
	addl	%eax, %edx
	leal	-16(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	_sjis_parse
L123:
	movl	_sed_buf, %edx
	movl	-12(%ebp), %eax
	subl	$1, %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	cmpb	$10, %al
	jne	L124
	call	_sed_LEFT
	movl	_sed_buf, %edx
	movl	-12(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, (%esp)
	call	_strlen
	addl	$1, %eax
	movl	%eax, %ecx
	movl	_sed_buf, %edx
	movl	-12(%ebp), %eax
	addl	%eax, %edx
	movl	_sed_buf, %ebx
	movl	-12(%ebp), %eax
	subl	$1, %eax
	addl	%ebx, %eax
	movl	%ecx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	_memmove
	movl	_buf_len, %eax
	subl	$1, %eax
	movl	%eax, _buf_len
	movl	_no_of_line, %eax
	subl	$1, %eax
	movl	%eax, _no_of_line
	call	_sed_display
	jmp	L119
L124:
	movl	_sed_buf, %edx
	movl	-12(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, (%esp)
	call	_strlen
	addl	$1, %eax
	movl	%eax, %ecx
	movl	_sed_buf, %edx
	movl	-12(%ebp), %eax
	addl	%eax, %edx
	movl	_sed_buf, %ebx
	movl	-16(%ebp), %esi
	movl	-12(%ebp), %eax
	subl	%esi, %eax
	addl	%ebx, %eax
	movl	%ecx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	_memmove
	movl	_buf_len, %eax
	subl	$1, %eax
	movl	%eax, _buf_len
	call	_redraw
	call	_sed_LEFT
	jmp	L119
L126:
	nop
L119:
	addl	$32, %esp
	popl	%ebx
	.cfi_restore 3
	popl	%esi
	.cfi_restore 6
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE18:
	.data
LC9:
	.ascii "\12*** out of memory\12\0"
LC10:
	.ascii "---   push any key   ---\12\0"
	.text
	.def	_sed_txt;	.scl	3;	.type	32;	.endef
_sed_txt:
LFB19:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%ebx
	subl	$36, %esp
	.cfi_offset 3, -12
	cmpl	$9, 8(%ebp)
	je	L128
	cmpl	$10, 8(%ebp)
	je	L128
	cmpl	$31, 8(%ebp)
	jle	L127
	cmpl	$255, 8(%ebp)
	jg	L127
L128:
	call	_cursor_to_ptr
	movl	%eax, -12(%ebp)
	movl	_buf_len, %eax
	cmpl	$1048574, %eax
	jle	L130
	movl	_cmd_sht, %eax
	movl	$7, 4(%esp)
	movl	%eax, (%esp)
	call	_clear_screen
	movl	_cmd_sht, %eax
	movl	$LC9, 4(%esp)
	movl	%eax, (%esp)
	call	_ut_printf
	movl	_cmd_sht, %eax
	movl	$LC10, 4(%esp)
	movl	%eax, (%esp)
	call	_ut_printf
	movl	_cmd_sht, %eax
	movl	%eax, (%esp)
	call	_ut_getcA
	call	_sed_display
	jmp	L127
L130:
	movl	_buf_len, %eax
	subl	-12(%ebp), %eax
	addl	$1, %eax
	movl	%eax, %ecx
	movl	_sed_buf, %edx
	movl	-12(%ebp), %eax
	addl	%eax, %edx
	movl	_sed_buf, %ebx
	movl	-12(%ebp), %eax
	addl	$1, %eax
	addl	%ebx, %eax
	movl	%ecx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	_memmove
	movl	_sed_buf, %edx
	movl	-12(%ebp), %eax
	addl	%edx, %eax
	movl	8(%ebp), %edx
	movb	%dl, (%eax)
	movl	_buf_len, %eax
	addl	$1, %eax
	movl	%eax, _buf_len
	cmpl	$10, 8(%ebp)
	jne	L131
	movl	_no_of_line, %eax
	addl	$1, %eax
	movl	%eax, _no_of_line
	call	_sed_display
	jmp	L132
L131:
	call	_redraw
L132:
	call	_sed_RIGHT
L127:
	movl	-4(%ebp), %ebx
	leave
	.cfi_restore 5
	.cfi_restore 3
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE19:
	.globl	_sedit_main
	.def	_sedit_main;	.scl	2;	.type	32;	.endef
_sedit_main:
LFB20:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	_sed_buf, %eax
	testl	%eax, %eax
	jne	L134
	movl	$1048576, (%esp)
	call	_memman_alloc
	movl	%eax, _sed_buf
	call	_sed_init
L134:
	call	_sed_help
	call	_sed_display
L150:
	movl	$0, (%esp)
	call	_disp_cursor
	movl	_cmd_sht, %eax
	movl	%eax, (%esp)
	call	_ut_getcA
	movl	%eax, -12(%ebp)
	movl	$7, (%esp)
	call	_disp_cursor
	cmpl	$8, -12(%ebp)
	je	L135
	cmpl	$8, -12(%ebp)
	jl	L136
	cmpl	$172, -12(%ebp)
	jg	L136
	cmpl	$128, -12(%ebp)
	jl	L136
	movl	-12(%ebp), %eax
	addl	$-128, %eax
	cmpl	$44, %eax
	ja	L136
	movl	L138(,%eax,4), %eax
	jmp	*%eax
	.data
	.align 4
L138:
	.long	L145
	.long	L144
	.long	L136
	.long	L136
	.long	L143
	.long	L142
	.long	L136
	.long	L136
	.long	L136
	.long	L136
	.long	L136
	.long	L136
	.long	L136
	.long	L136
	.long	L136
	.long	L136
	.long	L136
	.long	L136
	.long	L136
	.long	L136
	.long	L136
	.long	L136
	.long	L136
	.long	L136
	.long	L136
	.long	L136
	.long	L136
	.long	L136
	.long	L136
	.long	L136
	.long	L136
	.long	L136
	.long	L136
	.long	L136
	.long	L136
	.long	L136
	.long	L136
	.long	L136
	.long	L136
	.long	L136
	.long	L136
	.long	L141
	.long	L140
	.long	L139
	.long	L137
	.text
L145:
	movl	_cmd_sht, %eax
	movl	$7, 4(%esp)
	movl	%eax, (%esp)
	call	_clear_screen
	call	_sed_help
	call	_sed_display
	jmp	L146
L144:
	call	_sed_linedel
	jmp	L146
L143:
	call	_sed_exit
	testl	%eax, %eax
	jne	L152
	jmp	L151
L142:
	call	_sed_jump
	jmp	L146
L135:
	call	_sed_BS
	jmp	L146
L141:
	call	_sed_UP
	jmp	L146
L140:
	call	_sed_DOWN
	jmp	L146
L137:
	call	_sed_RIGHT
	jmp	L146
L139:
	call	_sed_LEFT
	jmp	L146
L136:
	cmpl	$127, -12(%ebp)
	jg	L153
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	_sed_txt
	jmp	L153
L152:
	nop
	jmp	L150
L153:
	nop
L146:
	jmp	L150
L151:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE20:
	.ident	"GCC: (GNU) 10.2.0"
	.def	_pset;	.scl	2;	.type	32;	.endef
	.def	_strchr;	.scl	2;	.type	32;	.endef
	.def	_sjis_parse;	.scl	2;	.type	32;	.endef
	.def	_disp_char;	.scl	2;	.type	32;	.endef
	.def	_clear_screen;	.scl	2;	.type	32;	.endef
	.def	_memset;	.scl	2;	.type	32;	.endef
	.def	_ut_printf;	.scl	2;	.type	32;	.endef
	.def	_ut_getcA;	.scl	2;	.type	32;	.endef
	.def	_ut_getc;	.scl	2;	.type	32;	.endef
	.def	_ut_gets;	.scl	2;	.type	32;	.endef
	.def	_atoi;	.scl	2;	.type	32;	.endef
	.def	_memmove;	.scl	2;	.type	32;	.endef
	.def	_strlen;	.scl	2;	.type	32;	.endef
	.def	_memman_alloc;	.scl	2;	.type	32;	.endef
