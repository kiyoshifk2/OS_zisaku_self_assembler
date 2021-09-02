;
;	boot drive number is always 0x80
;

[BITS 16]
		ORG		0x7c00

	JMP	entry_tmp
	DB	0x90
	DB	"GONBE   "	;8 byte
	DW	512		;セクタサイズ/
	DB	1		;クラスタサイズ/
	DW	0x200		;予約セクタ数/
	DB	2		;FAT数/
	DW	16		;ディレクトリエントリー数/
	DW	10000		;そうセクタ数/
	DB	0xf0		;0xf0:リムーバブルメディア/
	DW	1		;FAT が占めるセクタすう/
	DW	0		;トラック当たりのセクタ数/
	DW	0		;ヘッド数/
	DD	0
	DD	0
	db	0x80		;固定ディスクでは 0x80
	db	0		;reserved
	db	0x29		;シグネチャー/
	DD	0xffffffff	;ボリュームシリアルナンバー/
	DB	"GONBE      "	;ボリュームラベル 11byte
	DB	"FAT12   "
	TIMES	18 DB 0		;address=0000003e

CYLS		equ		0x0ff0

entry_tmp:
		jmp		0:entry


title:	db		'=== OS load 180 sector 512x2 ===',0x0d,0x0a,0
err_msg:	db		'*** disk 0x80 error',0x0d,0x0a,0
success_msg:	db	'=== load success',0x0d,0x0a,0

entry:
		MOV		AX,0			; initialize register
		MOV		DS,AX
		MOV		SS,AX
		MOV		SP,0x7c00
;;;        sti

		mov		bx,title
		call	dispstr

;-------------------------------------------------------------------------------

	mov	ax, 0x07e0
	mov	es,ax		;es = 0x07e0
	mov	bx,0		;buffer offset
	mov	dx,0		;LBA high
	mov	cx,1		;LBA low

main_L1:
	call	sector_read
	mov	ax,es
	add	ax,0x0020
	mov	es,ax
	inc	cx
	cmp	cx,384		;384 sector
	jnz	main_L1


;-----------------------------------------------------------------------------

	mov		bx,success_msg
	call	dispstr
		
		mov	ax,0x1ebc
		mov	es,ax
		call	dump

		mov	al,0x0d
		call	disp
		mov	al,0x0a
		call	disp

		mov	byte [CYLS],10

		jmp	0x8000				; jmp to OS

;success_end:
;		hlt
;		jmp		success_end		;0xc200	; jmp OS entry

;-------------------------------------------------------------------------------
;	1 sector read
;	es:bx   buffer address
;	cx      LBA low word
;	dx	LBA high word
;

packet:	dw		0x10			;  packet size
	dw		1				; number of block
	dw		0x0,0x07e0		; buffer address segment:offset
	dw		0x1,0,0,0		; start sector

sector_read:
	push		ax
	push		bx
	push		cx
	push		dx
	push		es
	mov		ax,es
	mov		[packet+6],ax	; buffer segment
	mov		[packet+4],bx	; buffer offset
	mov		[packet+8],cx	; LBA low word
	mov		[packet+10],dx	; LBA high word

	mov		dh,10				; retry counter
sector_read_L1:
	mov		dl,0x80				; drive number boot HDD
	mov		ah,0x42				; ext read
	mov		si,packet
;;	mov		al,0x00				; write

	push	dx
	int		0x13				; disk services
	pop		dx
	jnb		success				; nc if success
; error
	push	dx
	mov		ah,0				; system reset
	mov		dl,0
	int		0x13
	pop		dx
	dec		dh				; retry counter count
	jnz		sector_read_L1			; retry
	mov		bx,err_msg
	call	dispstr
error_end:
	hlt
	jmp		error_end

success:
	pop		es
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	ret

;-----------------------------------------------------------------------------

dump:
		mov	al, 0x0d
		call	disp
		mov	al, 0x0a
		call	disp
		mov	bx, 0
dump1:
		es
		mov	al, [bx]
		call	disphex_al
		mov	al, ' '
		call	disp
		inc	bx
		cmp	bx, 16
		jnz	dump1
		ret

disp:	; disp charactor al
		push	ax
		push	bx
		push	cx
		push	dx
		mov		ah,0x0e			; display 1 charactor
		mov		bx,15			; color code
		int		0x10			; call video bios
		pop		dx
		pop		cx
		pop		bx
		pop		ax
		ret

dispstr:	; cs:bx string addr '\0' terminate
		push	ax
		push	bx
dispstr1:
		cs
		mov		al,[bx]
		cmp		al,0
		jz		dispstr2
		call	disp
		inc		bx
		jmp		dispstr1
dispstr2:
		pop		bx
		pop		ax
		ret

disphex_al:	; display al hex
		push	ax
		push	cx
		mov		ah,al
		mov		cl,4
		shr		al,cl
		call	disphex1
		mov		al,ah
		and		al,0x0f
		call	disphex1
		pop		cx
		pop		ax
		ret

disphex1:
		cmp		al,10
		jb		disphex1a		; jmp on carry, 0～9
		; 10～15
		add		al, 'A'-10
		jmp		disp
disphex1a:
		add		al, '0'
		jmp		disp

;		resb	0x7dbe-$		; partition table start address
		TIMES	0x1be-($-$$) DB 0
partition_table:
	db		0x80,0,1,0, 0x01, 0xfe,0xff,0xff, 1,0,0,0, 0xff,0xff,0xff,0xff
        db		0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0
        db		0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0
        db		0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0

;		RESB	0x7dfe-$
;		TIMES	0x1fe-($-$$) DB 0

		DB		0x55, 0xaa
