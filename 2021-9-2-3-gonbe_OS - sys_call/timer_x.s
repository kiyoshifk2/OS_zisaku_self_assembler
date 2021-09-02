	.file	"timer.c"
	.text
	.globl	_timerctl
	.bss
	.align 32
_timerctl:
	.space 10004
	.globl	_APP_ch
_APP_ch:
	.space 1
	.text
	.globl	_init_pit
	.def	_init_pit;	.scl	2;	.type	32;	.endef
_init_pit:
LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	movl	$52, 4(%esp)
	movl	$67, (%esp)
	call	_io_out8
	movl	$156, 4(%esp)
	movl	$64, (%esp)
	call	_io_out8
	movl	$46, 4(%esp)
	movl	$64, (%esp)
	call	_io_out8
	movl	$0, _timerctl
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE0:
	.globl	_init_pic
	.def	_init_pic;	.scl	2;	.type	32;	.endef
_init_pic:
LFB1:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	movl	$255, 4(%esp)
	movl	$33, (%esp)
	call	_io_out8
	movl	$255, 4(%esp)
	movl	$161, (%esp)
	call	_io_out8
	movl	$17, 4(%esp)
	movl	$32, (%esp)
	call	_io_out8
	movl	$32, 4(%esp)
	movl	$33, (%esp)
	call	_io_out8
	movl	$4, 4(%esp)
	movl	$33, (%esp)
	call	_io_out8
	movl	$1, 4(%esp)
	movl	$33, (%esp)
	call	_io_out8
	movl	$17, 4(%esp)
	movl	$160, (%esp)
	call	_io_out8
	movl	$40, 4(%esp)
	movl	$161, (%esp)
	call	_io_out8
	movl	$2, 4(%esp)
	movl	$161, (%esp)
	call	_io_out8
	movl	$1, 4(%esp)
	movl	$161, (%esp)
	call	_io_out8
	movl	$251, 4(%esp)
	movl	$33, (%esp)
	call	_io_out8
	movl	$255, 4(%esp)
	movl	$161, (%esp)
	call	_io_out8
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE1:
	.globl	_inthandler20
	.def	_inthandler20;	.scl	2;	.type	32;	.endef
_inthandler20:
LFB2:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	$96, 4(%esp)
	movl	$32, (%esp)
	call	_io_out8
	movl	_timerctl, %eax
	addl	$1, %eax
	movl	%eax, _timerctl
	call	_timer_key
	movl	$0, -12(%ebp)
	jmp	L5
L8:
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	addl	$_timerctl+20, %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	je	L6
	call	_GetTickCount
	movl	%eax, %edx
	movl	-12(%ebp), %ecx
	movl	%ecx, %eax
	sall	$2, %eax
	addl	%ecx, %eax
	sall	$2, %eax
	addl	$_timerctl+12, %eax
	movl	(%eax), %eax
	movl	%edx, %ecx
	subl	%eax, %ecx
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	addl	$_timerctl+16, %eax
	movl	(%eax), %eax
	cmpl	%eax, %ecx
	jb	L6
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	addl	$_timerctl+20, %eax
	movl	(%eax), %eax
	cmpl	$1, %eax
	jne	L7
	movl	-12(%ebp), %eax
	leal	256(%eax), %ecx
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	addl	$_timerctl+4, %eax
	movl	(%eax), %eax
	movl	%ecx, 4(%esp)
	movl	%eax, (%esp)
	call	_fifo32_put
	testl	%eax, %eax
	jne	L6
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	addl	$_timerctl+20, %eax
	movl	$0, (%eax)
	jmp	L6
L7:
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	addl	$_timerctl+20, %eax
	movl	(%eax), %eax
	cmpl	$3, %eax
	jne	L6
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	addl	$_timerctl+8, %eax
	movl	(%eax), %eax
	movl	%eax, -16(%ebp)
	call	_GetTickCount
	movl	%eax, %edx
	movl	-12(%ebp), %ecx
	movl	%ecx, %eax
	sall	$2, %eax
	addl	%ecx, %eax
	sall	$2, %eax
	addl	$_timerctl+12, %eax
	movl	(%eax), %eax
	movl	%edx, %ecx
	subl	%eax, %ecx
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	addl	$_timerctl+16, %eax
	movl	(%eax), %eax
	cmpl	%eax, %ecx
	jb	L6
	movl	_taskctl, %eax
	movl	12(%eax), %eax
	testl	%eax, %eax
	jne	L6
	movl	-16(%ebp), %eax
	movl	4(%eax), %eax
	cmpl	$2, %eax
	je	L6
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	addl	$_timerctl+20, %eax
	movl	$0, (%eax)
	movl	_taskctl, %eax
	movl	(%eax), %eax
	movl	%eax, -20(%ebp)
	movl	$-1, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	_task_run
	movl	_taskctl, %eax
	movl	-20(%ebp), %edx
	movl	%edx, (%eax)
L6:
	addl	$1, -12(%ebp)
L5:
	cmpl	$499, -12(%ebp)
	jle	L8
	movl	_cnt.2, %eax
	testl	%eax, %eax
	je	L9
	movl	_cnt.2, %eax
	subl	$1, %eax
	movl	%eax, _cnt.2
L9:
	movl	_cnt.2, %eax
	testl	%eax, %eax
	jne	L11
	call	_task_switch
L11:
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE2:
	.data
LC0:
	.ascii "** timer area nothing\12\0"
	.text
	.globl	_set_oneshot_timer
	.def	_set_oneshot_timer;	.scl	2;	.type	32;	.endef
_set_oneshot_timer:
LFB3:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	$0, -12(%ebp)
	jmp	L13
L16:
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	addl	$_timerctl+20, %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	jne	L14
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	leal	_timerctl+4(%eax), %edx
	movl	8(%ebp), %eax
	movl	%eax, (%edx)
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
	movl	12(%ebp), %eax
	movl	%eax, (%edx)
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$2, %eax
	addl	$_timerctl+20, %eax
	movl	$1, (%eax)
	movl	-12(%ebp), %eax
	jmp	L15
L14:
	addl	$1, -12(%ebp)
L13:
	cmpl	$499, -12(%ebp)
	jle	L16
	movl	$LC0, (%esp)
	call	_fatal_a
	movl	$0, %eax
L15:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE3:
	.globl	_GetTickCount
	.def	_GetTickCount;	.scl	2;	.type	32;	.endef
_GetTickCount:
LFB4:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	movl	_timerctl, %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	addl	%eax, %eax
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE4:
	.globl	_timer_key_mode
	.bss
	.align 4
_timer_key_mode:
	.space 4
	.globl	_ut_getc_tbl
	.data
	.align 32
_ut_getc_tbl:
	.ascii "\0\33"
	.ascii "1234567890-^\10\11qwertyuiop@[\12\217asdfghjkl;:\0\216]zxcvbnm,./\216\0\224 \215\200\201\202\203\204\205\206\207\210\211\0\241\0\251\0\0\253\0\254\0\0\252\0\0\0\0\0\0\212\213\0\0\220\0\225\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\223\0\0\\\223\0\0\0\0\222\0\221\0\\\0\0"
	.ascii "\0\33!\"#$%&'()\0=~\10\11QWERTYUIOP`{\12\217ASDFGHJKL+*\0\216}ZXCVBNM<>?\216\0\224 \215\200\201\202\203\204\205\206\207\210\211\0\241\0\255\0\0\257\0\260\0\0\256\0\0\0\0\0\0\212\213\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0_\223\0\0\0\0\0\0\221\0|\0\0"
	.ascii "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\217\0\0\0\0\0\0\0\0\0\0\0\0\216\0\0\0\271\0\0\0\0\0\0\0\216\0\224\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\261\0\0\263\0\264\0\0\262\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
	.ascii "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\217\0\0\0\0\0\0\0\0\0\0\0\0\216\0\0\0\0\0\0\0\0\0\0\0\216\0\224\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\265\0\0\267\0\270\0\0\266\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
	.ascii "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\217\0\0\0\0\0\0\0\0\0\0\0\0\216\0\0\0\0\0\0\0\0\0\0\0\216\0\224\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
	.ascii "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\217\0\0\0\0\0\0\0\0\0\0\0\0\216\0\0\0\0\0\0\0\0\0\0\0\216\0\224\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
	.text
	.globl	_timer_key
	.def	_timer_key;	.scl	2;	.type	32;	.endef
_timer_key:
LFB5:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	_shtctl, %eax
	movl	16(%eax), %eax
	testl	%eax, %eax
	js	L34
	movl	_shtctl, %eax
	movl	_shtctl, %edx
	movl	16(%edx), %edx
	addl	$4, %edx
	movl	4(%eax,%edx,4), %eax
	movl	%eax, -16(%ebp)
	call	_key_input
	movl	%eax, -20(%ebp)
	movl	$2553856, 4(%esp)
	movl	$2047, (%esp)
	call	_load_idtr
	movzbl	_key_buf.1, %eax
	movb	%al, _key_buf.1+1
	movl	-20(%ebp), %eax
	movb	%al, _key_buf.1
	movzbl	_key_buf.1, %eax
	cmpb	$42, %al
	jne	L22
	movzbl	_key_buf.1+1, %eax
	cmpb	$-32, %al
	jne	L22
	movl	$0, _timer_key_mode
	jmp	L19
L22:
	movl	-20(%ebp), %eax
	andl	$128, %eax
	testl	%eax, %eax
	je	L23
	movb	$0, _APP_ch
	jmp	L24
L23:
	movl	-16(%ebp), %eax
	movl	144(%eax), %eax
	movl	-20(%ebp), %edx
	movzbl	%dl, %edx
	sall	$7, %eax
	addl	%edx, %eax
	addl	$_ut_getc_tbl, %eax
	movzbl	(%eax), %eax
	movb	%al, _APP_ch
L24:
	movl	_timer_key_mode, %eax
	testl	%eax, %eax
	jne	L25
	movl	-20(%ebp), %eax
	andl	$128, %eax
	testl	%eax, %eax
	je	L19
	movl	$1, _timer_key_mode
	jmp	L19
L25:
	movl	_timer_key_mode, %eax
	cmpl	$1, %eax
	jne	L19
	movl	-20(%ebp), %eax
	andl	$128, %eax
	testl	%eax, %eax
	jne	L19
	andl	$127, -20(%ebp)
	movl	$0, _timer_key_mode
	call	_GetTickCount
	movl	_time1.0, %edx
	subl	%edx, %eax
	cmpl	$89, %eax
	ja	L26
	call	_GetTickCount
	movl	%eax, _time1.0
	jmp	L19
L26:
	call	_GetTickCount
	movl	%eax, _time1.0
	movl	-16(%ebp), %eax
	movl	144(%eax), %eax
	sall	$7, %eax
	movl	%eax, %edx
	movl	-20(%ebp), %eax
	addl	%edx, %eax
	addl	$_ut_getc_tbl, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	movl	%eax, -24(%ebp)
	andl	$255, -24(%ebp)
	movl	$0, -12(%ebp)
	cmpl	$142, -24(%ebp)
	jne	L27
	movl	$1, -12(%ebp)
	jmp	L28
L27:
	cmpl	$143, -24(%ebp)
	jne	L29
	movl	$2, -12(%ebp)
	jmp	L28
L29:
	cmpl	$148, -24(%ebp)
	jne	L30
	movl	$3, -12(%ebp)
	jmp	L28
L30:
	cmpl	$144, -24(%ebp)
	jne	L31
	movl	$4, -12(%ebp)
	jmp	L28
L31:
	cmpl	$146, -24(%ebp)
	jne	L28
	movl	$5, -12(%ebp)
L28:
	cmpl	$0, -12(%ebp)
	je	L32
	movl	-16(%ebp), %eax
	movl	144(%eax), %eax
	cmpl	%eax, -12(%ebp)
	jne	L33
	movl	-16(%ebp), %eax
	movl	$0, 144(%eax)
	jmp	L32
L33:
	movl	-16(%ebp), %eax
	movl	-12(%ebp), %edx
	movl	%edx, 144(%eax)
L32:
	movl	-24(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$_main_fifo, (%esp)
	call	_fifo32_put
	jmp	L19
L34:
	nop
L19:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE5:
	.data
	.align 4
_cnt.2:
	.long	10
.lcomm _key_buf.1,5,4
.lcomm _time1.0,4,4
	.ident	"GCC: (GNU) 10.2.0"
	.def	_io_out8;	.scl	2;	.type	32;	.endef
	.def	_fifo32_put;	.scl	2;	.type	32;	.endef
	.def	_task_run;	.scl	2;	.type	32;	.endef
	.def	_task_switch;	.scl	2;	.type	32;	.endef
	.def	_fatal_a;	.scl	2;	.type	32;	.endef
	.def	_key_input;	.scl	2;	.type	32;	.endef
	.def	_load_idtr;	.scl	2;	.type	32;	.endef
