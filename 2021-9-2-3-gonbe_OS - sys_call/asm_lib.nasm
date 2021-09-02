; naskfunc
; TAB=4

[BITS 32]						; 32ビットモード用の機械語を作らせる/

	GLOBAL	_enable_interrupt, _disable_interrupt
	GLOBAL	_io_out8
	GLOBAL	_key_input, key_input_return
	GLOBAL	_load_gdtr, _load_idtr, _load_tr
	GLOBAL	_load_cr0, _store_cr0
	GLOBAL	_io_load_eflags, _io_store_eflags
	GLOBAL	_gonbe_hlt
	GLOBAL	_asm_inthandler20
;;;	GLOBAL	_read_idt, _write_idt, _idt_save
	GLOBAL	_farjmp
	GLOBAL	_asm_syscall40, _asm_int_0x40
	GLOBAL	_asm_ut_puts
	GLOBAL	_ut_setjmp, _ut_longjmp
	GLOBAL	_dbg1

	EXTERN	_inthandler20, _dot_brue
	EXTERN	_gonbe_main, _stack_buf
	EXTERN	_syscall40, _stack_40

[SECTION .data]

_idt_save:	dw 0x1234,0x5678,0x9abc

[SECTION .text_asm_lib]

key_input_return:	;org 0+0x20	; 0x20 はリンカスクリプト先頭で宣言したテーブルのサイズ/
;;;	sti		;割り込み許可
	ret

	times	0x10 - ($-$$)	nop
gonbe_main_jmp:		; org 0x10+0x20
	jmp	_gonbe_main

	times	0x20 - ($-$$)	nop
stack_address:		; org 0x20+0x20
	dd	_stack_buf

_key_input:	; int key_input(void);

;	このルーチンを呼び出すときは上位にて割り込み禁止/許可を行う事/

;;;	cli				;割り込み禁止/
	jmp	dword 3*8:0x7e00	;16bit プロテクトモードのセグメント/
	
	
waitkbdout:
		IN		 AL,0x64
		AND		 AL,0x02
		IN		 AL,0x60 		; から読み(受信バッファが悪さをしないように)/
		JNZ		waitkbdout		; ANDの結果が0でなければwaitkbdoutへ/
		RET

;-------------------------------------------------------------------------------

_enable_interrupt:	; void enable_interrupt();
	sti
	ret

_disable_interrupt:	; void disable_interrupt();
	cli
	ret

_io_out8:	; void io_out8(int port, int data);
		MOV		EDX,[ESP+4]		; port
		MOV		AL,[ESP+8]		; data
		OUT		DX,AL
		RET

;-----------------------------------------------------------------------------------------

_load_gdtr:	; void load_gdtr(int limit, int addr);
	MOV	AX,[ESP+4]		; limit
	MOV	[ESP+6],AX
	LGDT	[ESP+6]
	RET

_load_idtr:		; void load_idtr(int limit, int addr);
		MOV		AX,[ESP+4]		; limit
		MOV		[ESP+6],AX
		LIDT	[ESP+6]
		RET

_read_idt:	; void read_idt();
	sidt	[_idt_save]
	ret

_write_idt:	; void write_idt();
	lidt	[_idt_save]
	ret

_load_tr:		; void load_tr(int tr);
		LTR		[ESP+4]			; tr
		RET

;----------------------------------------------------------------------------------------

_load_cr0:	;int load_cr0();
	mov	eax,cr0
	ret

_store_cr0:	;void store_cr0(int cr0);
	mov	eax,[esp+4]
	mov	cr0,eax
	ret

;-------------------------------------------------------------------------

_io_load_eflags:	; int io_load_eflags(void);
	PUSHFD		; PUSH EFLAGS という意味/
	POP	EAX
	RET

_io_store_eflags:	; void io_store_eflags(int eflags);
	MOV	EAX,[ESP+4]
	PUSH	EAX
	POPFD		; POP EFLAGS という意味/
	RET

;-----------------------------------------------------------------------

_ut_setjmp:		; int ut_setjmp(int *env);
	mov	edx,[esp+4]
	mov	[edx],esp
	mov	eax,0
	ret

_ut_longjmp:		; int ut_longjmp(int env);
	mov	esp,[esp+4]
	mov	eax,1
	ret

;-----------------------------------------------------------------------

_gonbe_hlt:	;void gonbe_hlt();
	hlt
	ret

;---------------------------------------------------------------------

_asm_inthandler20:

;L10:	hlt
;	jmp L10

		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		EAX,ESP
		PUSH	EAX
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	_inthandler20
		POP		EAX
		POPAD
		POP		DS
		POP		ES
		IRETD

;---------------------------------------------------------------------

_farjmp:		; void farjmp(int eip, int cs);
		JMP		FAR	[ESP+4]				; eip, cs
		RET

;---------------------------------------------------------------------
;	このプログラムは main_task ではなくて別のコンテキストになる/
;	ds,es: は main_task の data エリアを使う/

_asm_syscall40:
	push	fs
	push	gs
	push	ds
	push	es
	mov	ax,1 * 8
	mov	fs,ax
	mov	gs,ax
	mov	ds,ax
	mov	es,ax

	mov	ax,ss
	mov	[_stack_40],ax
	mov	[_stack_40+2],esp
	mov	ax,1 * 8
	mov	ss,ax
	mov	esp,_stack_40+10000

	push	edx
	push	ecx
	push	ebx

	call	_syscall40

;;;	add	esp,12

	mov	bx,[_stack_40]
	mov	ss,bx
	mov	esp,[_stack_40+2]

	pop	es
	pop	ds
	pop	gs
	pop	fs
	iretd


_asm_int_0x40:	; int asm_int_0x40(int ebx, int ecx, int edx);
	mov	edx,[esp+12]
	mov	ecx,[esp+8]
	mov	ebx,[esp+4]
	int	0x40
	ret

;------------------------------------------------------------------------------

_dbg1:		; int dbg1(int addr);
	mov	edx,[esp+4]
	mov	eax,0
	mov	al,[cs:edx]
	ret
