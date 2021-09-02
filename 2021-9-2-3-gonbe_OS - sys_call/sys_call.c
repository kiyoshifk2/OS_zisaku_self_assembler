#include "gonbe.h"
#include "function.h"


//	int	0x40
//	ebx:	int syscall_numb;
//	edx:	union syscall *syscall;
//
//	ebx: 1		�L�[����  ret: eax=key code, if 0 no keyinput
//	ecx: sheet
//
//	ebx: 2		�P�����o��
//	ecx: sheet
//	dl:  �P����
//
//	ebx: 3		��ʂ�h��Ԃ�
//	ecx: sheet
//	dl:  color
//
//	ebx: 4		�P�o�C�g�w�L�T�\���i�Q�����j
//	ecx: sheet
//	dl:  hex code
//
//	ebx: 5		�S�o�C�g�w�L�T�\���A�O�T�v���X
//	ecx: sheet
//	edx: hex code
//
//	ebx: 6		�S�o�C�g�P�O�i�\���A�O�T�v���X
//	ecx: sheet
//	edx: ���l
//

int syscall_1();


int syscall40(int ebx, int ecx, int edx)
{
	if(ebx==1){		/* �L�[����	*/
		return syscall_1((struct sheet*)ecx);
	}
	else if(ebx==2){	/* �P�����o��	*/
		ut_printf((struct sheet*)ecx, "%c", edx & 0x7f);
	}
	else if(ebx==3){	/* ��ʓh��Ԃ�	*/
		clear_screen((struct sheet*)ecx, edx & 0xff);
	}
	else if(ebx==4){	/* �P�o�C�g�w�L�T�\��	*/
		ut_printf((struct sheet*)ecx, "%02x", edx & 0xff);
	}
	else if(ebx==5){	/* �S�o�C�g�w�L�T�\��	*/
		ut_printf((struct sheet*)ecx, "%x", edx);
	}
	else if(ebx==6){	/* �S�o�C�g�P�O�i�\��	*/
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
	return save;			// ���͂��������� 0
}
