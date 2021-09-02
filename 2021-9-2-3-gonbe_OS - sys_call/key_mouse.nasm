;------------------------------------------------------------------------
	org	0x7e00


IDT_SAVE		equ	0x0fe8	; 6byte idtr
key_input_return	equ	0x20


[BITS 16]

;;;	LGDT	[GDTR0]			; 暫定GDTを設定/
	mov	eax,cr0
	and	eax,0xfffffffe	;bit0(PEビット)を0にする（リアルモード移行のため）/
	mov	cr0,eax

	jmp	key_input_flash
key_input_flash:
	mov	ax,0
	mov	ds,ax
	mov	es,ax
;	mov	fs,ax
;	mov	gs,ax
	mov	ss,ax

	CALL	waitkbdout
	MOV	AL,0xd1
	OUT	0x64,AL
	CALL	waitkbdout
;;	MOV	AL,0xdf			; enable A20
	mov	al,0xdd			; disable A20
	OUT	0x60,AL
	CALL	waitkbdout

	jmp	0:key_input_real
key_input_real:

	lidt	[IDT_SAVE]		; idtr load
	;************************* 16bit real mode code
	mov	ah,0x21		;get key stroke
	int	0x16
	;************************* 16bit real mode code
	push	ax		;al:ascii, ah:scan code

	CALL	waitkbdout
	MOV		AL,0xd1
	OUT		0x64,AL
	CALL	waitkbdout
	MOV		AL,0xdf			; enable A20
;;;	mov		al,0xdd			; disable A20
	OUT		0x60,AL
	CALL	waitkbdout

;;;	LGDT	[GDTR0]			; 暫定GDTを設定
	MOV	EAX,CR0
	AND	EAX,0x7fffffff	; bit31を0にする（ページング禁止のため）/
	OR	EAX,0x00000001	; bit0を1にする（プロテクトモード移行のため）/
	MOV	CR0,EAX
	JMP	key_flash
key_flash:
	MOV	AX,1*8			;  読み書き可能セグメント32bit
	MOV	DS,AX
	MOV	ES,AX
	MOV	FS,AX
	MOV	GS,AX
	MOV	SS,AX
	pop	ax
	
	jmp	dword 2*8:key_input_return

waitkbdout:
		IN		 AL,0x64
		AND		 AL,0x02
		IN		 AL,0x60 		; から読み(受信バッファが悪さをしないように)/
		JNZ		waitkbdout		; ANDの結果が0でなければwaitkbdoutへ/
		RET





	times	0x200-($-$$)	db 0
