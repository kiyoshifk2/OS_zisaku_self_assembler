#include "gonbe.h"
#include "function.h"


//	int	0x40
//	ebx:	int syscall_numb;
//	edx:	union syscall *syscall;
//
//	ebx: 1		キー入力  ret: eax=key code, if 0 no keyinput
//	ecx: sheet
//
//	ebx: 2		１文字出力
//	ecx: sheet
//	dl:  １文字
//
//	ebx: 3		画面を塗りつぶす
//	ecx: sheet
//	dl:  color
//
//	ebx: 4		１バイトヘキサ表示（２文字）
//	ecx: sheet
//	dl:  hex code
//
//	ebx: 5		４バイトヘキサ表示、０サプレス
//	ecx: sheet
//	edx: hex code
//
//	ebx: 6		４バイト１０進表示、０サプレス
//	ecx: sheet
//	edx: 数値
//

int syscall_1();


int syscall40(int ebx, int ecx, int edx)
{
	if(ebx==1){		/* キー入力	*/
		return syscall_1((struct sheet*)ecx);
	}
	else if(ebx==2){	/* １文字出力	*/
		ut_printf((struct sheet*)ecx, "%c", edx & 0x7f);
	}
	else if(ebx==3){	/* 画面塗りつぶし	*/
		clear_screen((struct sheet*)ecx, edx & 0xff);
	}
	else if(ebx==4){	/* １バイトヘキサ表示	*/
		ut_printf((struct sheet*)ecx, "%02x", edx & 0xff);
	}
	else if(ebx==5){	/* ４バイトヘキサ表示	*/
		ut_printf((struct sheet*)ecx, "%x", edx);
	}
	else if(ebx==6){	/* ４バイト１０進表示	*/
		ut_printf((struct sheet*)ecx, "%d", edx);
	}
	return 0;
}

int syscall_1(struct sheet *sht)
{
	int save = getc_char;
	int top;
	
	top = shtctl->top;
	if(top < 0){
		return 0;
	}
	if(sht != shtctl->sheets[top]){
		return 0;
	}
	
	getc_char = 0;
	return save;			// 入力が無い時は 0
}
