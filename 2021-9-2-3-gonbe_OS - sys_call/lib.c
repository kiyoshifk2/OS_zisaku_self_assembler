#include "gonbe.h"
#include "function.h"


//int shift_status;			// 0:lower case, 1:upper case




//int ut_getc()
//{
//	int c;
//	
//	while(APP_ch==0){
//		gonbe_hlt();
//	}
//	c = APP_ch;
//	APP_ch = 0;
//	return c;
//}

#define EFLAGS_AC_BIT		0x00040000
#define CR0_CACHE_DISABLE	0x60000000

unsigned int memcheck_sub(unsigned int start, unsigned int end)
{
	int *p;
	volatile int k1, k2;
	unsigned int addr;
	
	for(addr=start|0x0000ffff; addr<=end; addr+=0x00010000){
		p = (int*)addr;
		*p = addr;
		k1 = *p;
		*p = ~addr;
		k2 = *p;
		if(k1 != ~k2){
			return addr - 0x00010000;
		}
	}
	return addr - 0x00010000;
}

int memcheck(unsigned int start, unsigned int end)
{
	char flg486 = 0;
	unsigned int eflg, cr0, i;
	int mbyte;

	/* 386か、486以降なのかの確認 */
	eflg = io_load_eflags();
	eflg |= EFLAGS_AC_BIT; /* AC-bit = 1 */
	io_store_eflags(eflg);
	eflg = io_load_eflags();
	if ((eflg & EFLAGS_AC_BIT) != 0) { /* 386ではAC=1にしても自動で0に戻ってしまう */
		flg486 = 1;
	}
	eflg &= ~EFLAGS_AC_BIT; /* AC-bit = 0 */
	io_store_eflags(eflg);

	if (flg486 != 0) {
		cr0 = load_cr0();
		cr0 |= CR0_CACHE_DISABLE; /* キャッシュ禁止 */
		store_cr0(cr0);
	}

	i = memcheck_sub(start, end);

	if (flg486 != 0) {
		cr0 = load_cr0();
		cr0 &= ~CR0_CACHE_DISABLE; /* キャッシュ許可 */
		store_cr0(cr0);
	}

	mbyte = (int)(((long long)i+1) / (1024*1024));
//	ut_printf("%dMB OK\n", mbyte);

	return mbyte;
}

//----------------------------------------------------------------------------

//	実行速度測定　1sec 間のインクリメント回数/
//	sub パソコンにて    ... cnt=568M, 530M 入力処理が無い状態/
//	                        cnt=645M       10ms に１回 key_input() を呼ぶ/

void test_speed(struct sheet *sht)
{
	unsigned int time1;
	unsigned int cnt;
	
	time1 = GetTickCount();
	while(time1==GetTickCount())
		;
	time1 = GetTickCount();
	cnt = 0;
	for(;;){
		cnt++;
		if(GetTickCount()-time1 >=1000){
			break;
		}
	}
	ut_printf(sht, "cnt=%dM\n", cnt/1000000);
}

void bss_clear()
{
	unsigned int addr;
	
	for(addr=BSS_START; addr<BSS_END; addr++){
		*(char*)addr = 0;
	}
}

//----------------------------------------------------------------------------


int ut_getcA(struct sheet *sht)
{
	int ret;
	int eflags = io_load_eflags();
	
	while((ret = asm_int_0x40(1, (int)sht, 0))==0){
		if((eflags & 0x200)==0){	/* 割り込み禁止中	*/
			gonbe_hlt();
		}
		else{
			delay_task(10);
		}
	}
	return ret;
}

int ut_getc(struct sheet *sht)
{
	int c;
	
	for(;;){
		c = ut_getcA(sht);
		if(c>0 && c<128){
			return c;
		}
	}
}

void ut_gets(struct sheet *sht, char *buf, int len)
{
	int i;
	
	for(i=0; i<len-1; i++){
		buf[i] = ut_getc(sht);
		if(buf[i]=='\n'){
			buf[i+1] = 0;
			return;
		}
	}
	buf[i] = 0;
	while(ut_getc(sht) != '\n')
		;
}
