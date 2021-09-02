#include "gonbe.h"
#include "function.h"



#define PIT_CTRL	0x0043
#define PIT_CNT0	0x0040

struct timerctl timerctl;
unsigned char APP_ch;
//struct timer timer[MAX_TIMER];


extern int mt_timer;
void mt_taskswitch(void);


void init_pit(void)
{
	io_out8(PIT_CTRL, 0x34);
	io_out8(PIT_CNT0, 0x9c);
	io_out8(PIT_CNT0, 0x2e);
	timerctl.count = 0;
}

void init_pic(void)
/* PICの初期化 */
{
	io_out8(PIC0_IMR,  0xff  ); /* 全ての割り込みを受け付けない */
	io_out8(PIC1_IMR,  0xff  ); /* 全ての割り込みを受け付けない */

	io_out8(PIC0_ICW1, 0x11  ); /* エッジトリガモード */
	io_out8(PIC0_ICW2, 0x20  ); /* IRQ0-7は、INT20-27で受ける */
	io_out8(PIC0_ICW3, 1 << 2); /* PIC1はIRQ2にて接続 */
	io_out8(PIC0_ICW4, 0x01  ); /* ノンバッファモード */

	io_out8(PIC1_ICW1, 0x11  ); /* エッジトリガモード */
	io_out8(PIC1_ICW2, 0x28  ); /* IRQ8-15は、INT28-2fで受ける */
	io_out8(PIC1_ICW3, 2     ); /* PIC1はIRQ2にて接続 */
	io_out8(PIC1_ICW4, 0x01  ); /* ノンバッファモード */

	io_out8(PIC0_IMR,  0xfb  ); /* 11111011 PIC1以外は全て禁止 */
	io_out8(PIC1_IMR,  0xff  ); /* 11111111 全ての割り込みを受け付けない */

	return;
}

void inthandler20(int *esp)
{
	struct TASK *task;
	int i, save;
//	int ts=0;
	
	io_out8(PIC0_OCW2, 0x60);	/* IRQ-00受付完了をPICに通知 */
	timerctl.count++;	/* tick のカウント */
	
	timer_key();	/* 10msec 毎のキー入力処理 */
	
	/***	タイマーの fire 処理	***/
	for(i=0; i<MAX_TIMER; i++){
		if(timerctl.timer[i].flag){	// counting
			if((GetTickCount() - timerctl.timer[i].start_time) >= timerctl.timer[i].duration){
				if(timerctl.timer[i].flag==1){			// one shot timer/
					if(fifo32_put(timerctl.timer[i].fifo, CMD_TIMER0 + i)==0){	// fifo OK
						timerctl.timer[i].flag = 0;	// stop
					}
				}
//				else if(timerctl.timer[i].flag==2){		// repeat timer
//					fifo32_put(timerctl.timer[i].fifo, CMD_TIMER0 + i);
//					timerctl.timer[i].start_time = GetTickCount();
//				}
				else if(timerctl.timer[i].flag==3){	// delay timer
					task = timerctl.timer[i].task;
					if(GetTickCount()-timerctl.timer[i].start_time >= timerctl.timer[i].duration &&
							taskctl->switch_task_a==0 &&
							task->flags!=2){	/* fire */
						timerctl.timer[i].flag = 0;	/* 未使用にする */
						save = taskctl->inhibit_task_switch;
						task_run(task, -1);	/* タスクを起こす */
						taskctl->inhibit_task_switch = save;
					}
				}

			}
		}
	}
	static int cnt=10;
	if(cnt) cnt--;		// farjmp() の後にタスクスイッチを行うため/
	if(cnt==0){
		task_switch();	// タスクスイッチ/
	}
}

//	return タイマー番号;	0～499
int set_oneshot_timer(struct fifo32 *fifo, unsigned int msec)
{
	int i;
	
	for(i=0; i<MAX_TIMER; i++){
		if(timerctl.timer[i].flag==0){		// stop(未使用)/
			timerctl.timer[i].fifo = fifo;
			timerctl.timer[i].start_time = GetTickCount();
			timerctl.timer[i].duration = msec;
			timerctl.timer[i].flag = 1;		// one shot timer
			return i;
		}
	}
	fatal_a("** timer area nothing\n");
//	fatal();
	return 0;
}

unsigned int GetTickCount()
{
	return timerctl.count*10;
}


int timer_key_mode = 0;

unsigned char ut_getc_tbl[][128]={
	{		// ut_getc_tbl[0][]
		0,	// 0x00
		ESC,
		'1',
		'2',
		'3',	// 0x04
		'4',
		'5',
		'6',
		'7',	// 0x08
		'8',
		'9',
		'0',
		'-',	// 0x0c
		'^',
		BS,
		TAB,
		
		'q',	// 0x10
		'w',
		'e',
		'r',
		't',	// 0x14
		'y',
		'u',
		'i',
		'o',	// 0x18
		'p',
		'@',
		'[',
		ENTER,	// 0x1c
		CONTROL,
		'a',
		's',
		
		'd',	// 0x20
		'f',
		'g',
		'h',
		'j',	// 0x24
		'k',
		'l',
		';',
		':',	// 0x28
		0,
		SHIFT,
		']',
		'z',	// 0x2c
		'x',
		'c',
		'v',
		
		'b',	// 0x30
		'n',
		'm',
		',',
		'.',	// 0x34
		'/',
		SHIFT,
		0,
		ALT,	// 0x38
		' ',
		CAPS_LOCK,
		F1,
		F2,	// 0x3c
		F3,
		F4,
		F5,
		
		F6,	// 0x40
		F7,
		F8,
		F9,
		F10,	// 0x44
		0,
		SCROLL_LOCK,
		0,
		UP,	// 0x48
		0,
		0,
		LEFT,
		0,	// 0x4c
		RIGHT,
		0,
		0,
		
		DOWN,	// 0x50
		0,
		0,
		0,
		0,	// 0x54
		0,
		0,
		F11,
		F12,	// 0x58
		0,
		0,
		HATA,
		0,	// 0x5c
		SHIKAKU,
		0,
		0,
		
		0,	// 0x60 使用禁止/
		0,
		0,
		0,
		0,	// 0x64
		0,
		0,
		0,
		0,	// 0x68
		0,
		0,
		0,
		0,	// 0x6c
		0,
		0,
		0,
		
		KANA,	// 0x70
		0,
		0,
		'\\',
		KANA,	// 0x74
		0,
		0,
		0,
		0,	// 0x78
		MARU,
		0,
		MARU_BATU,
		0,	// 0x7c
		'\\',
		0,
		0,
	},
	{		// ut_getc_tbl[1][] : SHIFT
		0,	// 0x00
		ESC,
		'!',
		'\"',
		'#',	// 0x04
		'$',
		'%',
		'&',
		'\'',	// 0x08
		'(',
		')',
		0,
		'=',	// 0x0c
		'~',
		BS,
		TAB,
		
		'Q',	// 0x10
		'W',
		'E',
		'R',
		'T',	// 0x14
		'Y',
		'U',
		'I',
		'O',	// 0x18
		'P',
		'`',
		'{',
		ENTER,	// 0x1c
		CONTROL,
		'A',
		'S',
		
		'D',	// 0x20
		'F',
		'G',
		'H',
		'J',	// 0x24
		'K',
		'L',
		'+',
		'*',	// 0x28
		0,
		SHIFT,
		'}',
		'Z',	// 0x2c
		'X',
		'C',
		'V',
		
		'B',	// 0x30
		'N',
		'M',
		'<',
		'>',	// 0x34
		'?',
		SHIFT,
		0,
		ALT,	// 0x38
		' ',
		CAPS_LOCK,
		F1,
		F2,	// 0x3c
		F3,
		F4,
		F5,
		
		F6,	// 0x40
		F7,
		F8,
		F9,
		F10,	// 0x44
		0,
		SCROLL_LOCK,
		0,
		SFT_UP,	// 0x48
		0,
		0,
		SFT_LEFT,
		0,	// 0x4c
		SFT_RIGHT,
		0,
		0,
		
		SFT_DOWN,	// 0x50
		0,
		0,
		0,
		0,	// 0x54
		0,
		0,
		F11,
		F12,	// 0x58
		0,
		0,
		0,
		0,	// 0x5c
		0,
		0,
		0,
		
		0,	// 0x60 使用禁止/
		0,
		0,
		0,
		0,	// 0x64
		0,
		0,
		0,
		0,	// 0x68
		0,
		0,
		0,
		0,	// 0x6c
		0,
		0,
		0,
		
		0,	// 0x70
		0,
		0,
		'_',
		KANA,	// 0x74
		0,
		0,
		0,
		0,	// 0x78
		0,
		0,
		MARU_BATU,
		0,	// 0x7c
		'|',
		0,
		0,
	},
	{		// ut_getc_tbl[2][] : CONTROL
		0,	// 0x00
		0,
		0,
		0,
		0,	// 0x04
		0,
		0,
		0,
		0,	// 0x08
		0,
		0,
		0,
		0,	// 0x0c
		0,
		0,
		0,
		
		0,	// 0x10
		0,
		0,
		0,
		0,	// 0x14
		0,
		0,
		0,
		0,	// 0x18
		0,
		0,
		0,
		0,	// 0x1c
		CONTROL,
		0,
		0,
		
		0,	// 0x20
		0,
		0,
		0,
		0,	// 0x24
		0,
		0,
		0,
		0,	// 0x28
		0,
		SHIFT,
		0,
		0,	// 0x2c
		0,
		CTL_C,
		0,
		
		0,	// 0x30
		0,
		0,
		0,
		0,	// 0x34
		0,
		SHIFT,
		0,
		ALT,	// 0x38
		0,
		0,
		0,
		0,	// 0x3c
		0,
		0,
		0,
		
		0,	// 0x40
		0,
		0,
		0,
		0,	// 0x44
		0,
		0,
		0,
		CTL_UP,	// 0x48
		0,
		0,
		CTL_LEFT,
		0,	// 0x4c
		CTL_RIGHT,
		0,
		0,
		
		CTL_DOWN,	// 0x50
		0,
		0,
		0,
		0,	// 0x54
		0,
		0,
		0,
		0,	// 0x58
		0,
		0,
		0,
		0,	// 0x5c
		0,
		0,
		0,
		
		0,	// 0x60 使用禁止/
		0,
		0,
		0,
		0,	// 0x64
		0,
		0,
		0,
		0,	// 0x68
		0,
		0,
		0,
		0,	// 0x6c
		0,
		0,
		0,
		
		0,	// 0x70
		0,
		0,
		0,
		0,	// 0x74
		0,
		0,
		0,
		0,	// 0x78
		0,
		0,
		0,
		0,	// 0x7c
		0,
		0,
		0,
		
	},
	{		// ut_getc_tbl[3][] : ALT
		0,	// 0x00
		0,
		0,
		0,
		0,	// 0x04
		0,
		0,
		0,
		0,	// 0x08
		0,
		0,
		0,
		0,	// 0x0c
		0,
		0,
		0,
		
		0,	// 0x10
		0,
		0,
		0,
		0,	// 0x14
		0,
		0,
		0,
		0,	// 0x18
		0,
		0,
		0,
		0,	// 0x1c
		CONTROL,
		0,
		0,
		
		0,	// 0x20
		0,
		0,
		0,
		0,	// 0x24
		0,
		0,
		0,
		0,	// 0x28
		0,
		SHIFT,
		0,
		0,	// 0x2c
		0,
		0,
		0,
		
		0,	// 0x30
		0,
		0,
		0,
		0,	// 0x34
		0,
		SHIFT,
		0,
		ALT,	// 0x38
		0,
		0,
		0,
		0,	// 0x3c
		0,
		0,
		0,
		
		0,	// 0x40
		0,
		0,
		0,
		0,	// 0x44
		0,
		0,
		0,
		ALT_UP,	// 0x48
		0,
		0,
		ALT_LEFT,
		0,	// 0x4c
		ALT_RIGHT,
		0,
		0,
		
		ALT_DOWN,	// 0x50
		0,
		0,
		0,
		0,	// 0x54
		0,
		0,
		0,
		0,	// 0x58
		0,
		0,
		0,
		0,	// 0x5c
		0,
		0,
		0,
		
		0,	// 0x60 使用禁止/
		0,
		0,
		0,
		0,	// 0x64
		0,
		0,
		0,
		0,	// 0x68
		0,
		0,
		0,
		0,	// 0x6c
		0,
		0,
		0,
		
		0,	// 0x70
		0,
		0,
		0,
		0,	// 0x74
		0,
		0,
		0,
		0,	// 0x78
		0,
		0,
		0,
		0,	// 0x7c
		0,
		0,
		0,
		
	},
	{		// ut_getc_tbl[4][] : HATA
		0,	// 0x00
		0,
		0,
		0,
		0,	// 0x04
		0,
		0,
		0,
		0,	// 0x08
		0,
		0,
		0,
		0,	// 0x0c
		0,
		0,
		0,
		
		0,	// 0x10
		0,
		0,
		0,
		0,	// 0x14
		0,
		0,
		0,
		0,	// 0x18
		0,
		0,
		0,
		0,	// 0x1c
		CONTROL,
		0,
		0,
		
		0,	// 0x20
		0,
		0,
		0,
		0,	// 0x24
		0,
		0,
		0,
		0,	// 0x28
		0,
		SHIFT,
		0,
		0,	// 0x2c
		0,
		0,
		0,
		
		0,	// 0x30
		0,
		0,
		0,
		0,	// 0x34
		0,
		SHIFT,
		0,
		ALT,	// 0x38
		0,
		0,
		0,
		0,	// 0x3c
		0,
		0,
		0,
		
		0,	// 0x40
		0,
		0,
		0,
		0,	// 0x44
		0,
		0,
		0,
		0,	// 0x48
		0,
		0,
		0,
		0,	// 0x4c
		0,
		0,
		0,
		
		0,	// 0x50
		0,
		0,
		0,
		0,	// 0x54
		0,
		0,
		0,
		0,	// 0x58
		0,
		0,
		0,
		0,	// 0x5c
		0,
		0,
		0,
		
		0,	// 0x60 使用禁止/
		0,
		0,
		0,
		0,	// 0x64
		0,
		0,
		0,
		0,	// 0x68
		0,
		0,
		0,
		0,	// 0x6c
		0,
		0,
		0,
		
		0,	// 0x70
		0,
		0,
		0,
		0,	// 0x74
		0,
		0,
		0,
		0,	// 0x78
		0,
		0,
		0,
		0,	// 0x7c
		0,
		0,
		0,
		
	},
	{		// ut_getc_tbl[5][] : MARU
		0,	// 0x00
		0,
		0,
		0,
		0,	// 0x04
		0,
		0,
		0,
		0,	// 0x08
		0,
		0,
		0,
		0,	// 0x0c
		0,
		0,
		0,
		
		0,	// 0x10
		0,
		0,
		0,
		0,	// 0x14
		0,
		0,
		0,
		0,	// 0x18
		0,
		0,
		0,
		0,	// 0x1c
		CONTROL,
		0,
		0,
		
		0,	// 0x20
		0,
		0,
		0,
		0,	// 0x24
		0,
		0,
		0,
		0,	// 0x28
		0,
		SHIFT,
		0,
		0,	// 0x2c
		0,
		0,
		0,
		
		0,	// 0x30
		0,
		0,
		0,
		0,	// 0x34
		0,
		SHIFT,
		0,
		ALT,	// 0x38
		0,
		0,
		0,
		0,	// 0x3c
		0,
		0,
		0,
		
		0,	// 0x40
		0,
		0,
		0,
		0,	// 0x44
		0,
		0,
		0,
		0,	// 0x48
		0,
		0,
		0,
		0,	// 0x4c
		0,
		0,
		0,
		
		0,	// 0x50
		0,
		0,
		0,
		0,	// 0x54
		0,
		0,
		0,
		0,	// 0x58
		0,
		0,
		0,
		0,	// 0x5c
		0,
		0,
		0,
		
		0,	// 0x60 使用禁止/
		0,
		0,
		0,
		0,	// 0x64
		0,
		0,
		0,
		0,	// 0x68
		0,
		0,
		0,
		0,	// 0x6c
		0,
		0,
		0,
		
		0,	// 0x70
		0,
		0,
		0,
		0,	// 0x74
		0,
		0,
		0,
		0,	// 0x78
		0,
		0,
		0,
		0,	// 0x7c
		0,
		0,
		0,
		
	},
};


//	割り込みルーチン用/
void timer_key()
{
	static unsigned int time1;
	static unsigned char key_buf[5];
	int code, shift, ascii;
	struct sheet *sht;		// 最上位シート/
	
	if(shtctl->top < 0){		// 表示状態のシートが無い/
		return;
	}
	sht = shtctl->sheets[shtctl->top];	// 最上位シート/
	
//	disable_interrupt();
//	write_idt();
	code = key_input();	// BIOS call にてキー入力/
	load_idtr(LIMIT_IDT, ADR_IDT);
//	enable_interrupt();

	key_buf[1] = key_buf[0];
	key_buf[0] = code;
	if(key_buf[0]==0x2a && key_buf[1]==0xe0){
		timer_key_mode = 0;
		return;
	}
	if(code & 0x80){
		APP_ch = 0;
	}
	else{
		APP_ch = ut_getc_tbl[sht->shift][code & 0xff];
	}
	if(timer_key_mode==0){		// キーが押されている状態 - 初期状態/
		if(code & 0x80){	// キーから手が離された/
			timer_key_mode = 1;
		}
	}
	else if(timer_key_mode==1){	// キーから手が離された状態/
		if((code & 0x80)==0){	// キーが押された/
			code &= 0x7f;
			timer_key_mode = 0;
//			if(key_buf[0]==0x2a && key_buf[1]==0xe0){
//				return;
//			}
			if(GetTickCount()-time1 < 90){
				time1 = GetTickCount();
				return;
			}
			time1 = GetTickCount();
			ascii = ut_getc_tbl[sht->shift][code];
			ascii &= 0xff;
			shift = 0;
			if(ascii==SHIFT){
				shift = 1;
			}
			else if(ascii==CONTROL){
				shift = 2;
			}
			else if(ascii==ALT){
				shift = 3;
			}
			else if(ascii==HATA){
				shift = 4;
			}
			else if(ascii==MARU){
				shift = 5;
			}

			if(shift){	// shift グループが押された/
				if(shift==sht->shift){
					sht->shift = 0;
				}
				else{
					sht->shift = shift;
				}
			}
//			APP_ch = ascii;
			fifo32_put(&main_fifo, ascii);
		}
	}
}
