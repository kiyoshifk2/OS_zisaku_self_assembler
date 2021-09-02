#include "stdarg.h"
//#include "ctype.h"


#define F1	0x80
#define F2	0x81
#define F3	0x82
#define F4	0x83
#define F5	0x84
#define F6	0x85
#define F7	0x86
#define F8	0x87
#define F9	0x88
#define F10	0x89
#define F11	0x8a
#define F12	0x8b
#define ESC	0x1b
#define ZENKAKU	0x8c
#define BS	'\b'
#define TAB	'\t'
#define ENTER	'\n'
#define CAPS_LOCK	0x8d
#define SHIFT	0x8e
#define CONTROL	0x8f
#define HATA	0x90
#define MARU_BATU	0x91
#define MARU	0x92
#define KANA	0x93
#define ALT	0x94
#define SHIKAKU	0x95
#define PRINT_SCREEN	0xa0
#define SCROLL_LOCK	0xa1
#define PAUSE	0xa2
#define INSERT	0xa3
#define HOME	0xa4
#define PAGE_UP	0xa5
#define DELETE	0xa6
#define END	0xa7
#define PAGE_DOWN	0xa8
#define UP	0xa9
#define DOWN	0xaa
#define LEFT	0xab
#define RIGHT	0xac
#define SFT_UP		0xad
#define SFT_DOWN	0xae
#define SFT_LEFT	0xaf
#define SFT_RIGHT	0xb0
#define CTL_UP		0xb1
#define CTL_DOWN	0xb2
#define CTL_LEFT	0xb3
#define CTL_RIGHT	0xb4
#define ALT_UP		0xb5
#define ALT_DOWN	0xb6
#define ALT_LEFT	0xb7
#define ALT_RIGHT	0xb8
#define CTL_C		0xb9


#define ADR_BOOTINFO		0x00000ff0
#define PHYSICAL_START_ADDR	0x00280000
#define BSS_START		*(unsigned int*)PHYSICAL_START_ADDR
#define BSS_END			*(unsigned int*)(PHYSICAL_START_ADDR+4)

struct BOOTINFO { /* 0x0ff0-0x0fff */
	char cyls; /* ブートセクタはどこまでディスクを読んだのか */
	char leds; /* ブート時のキーボードのLEDの状態 */
	char vmode; /* ビデオモード  何ビットカラーか */
	char reserve;
	short scrnx, scrny; /* 画面解像度 */
	char *vram;
};

struct SEGMENT_DESCRIPTOR {
	short limit_low;
	short base_low;
	char base_mid;
	char access_right;
	char limit_high;
	char base_high;
};
struct GATE_DESCRIPTOR {
	short offset_low, selector;
	char dw_count, access_right;
	short offset_high;
};


#define COL8_000000		0
#define COL8_FF0000		1
#define COL8_00FF00		2
#define COL8_FFFF00		3
#define COL8_0000FF		4
#define COL8_FF00FF		5
#define COL8_00FFFF		6
#define COL8_FFFFFF		7
#define COL8_C0C0C0		8
#define COL8_800000		9
#define COL8_008000		10
#define COL8_808000		11
#define COL8_000080		12
#define COL8_800080		13
#define COL8_008080		14
#define COL8_808080		15
#define COL8_202020		16
#define COL8_400000		17
#define COL8_004000		18
#define COL8_404000		19
#define COL8_000040		20
#define COL8_400040		21
#define COL8_004040		22
#define COL8_404040		23

#define ADR_IDT			0x0026f800
#define LIMIT_IDT		0x000007ff
#define ADR_GDT			0x00270000
#define LIMIT_GDT		0x0000ffff
#define ADR_BOTPAK		0x00280000
//AAAAA #define LIMIT_BOTPAK	0x0007ffff
#define LIMIT_BOTPAK	0x00ffffff
#define AR_DATA32_RW	0x4092
#define AR_CODE32_ER	0x409a
#define AR_CODE16_ER	0x009a
#define AR_INTGATE32	0x008e
#define AR_TSS32		0x0089

#define PIC0_ICW1		0x0020
#define PIC0_OCW2		0x0020
#define PIC0_IMR		0x0021
#define PIC0_ICW2		0x0021
#define PIC0_ICW3		0x0021
#define PIC0_ICW4		0x0021
#define PIC1_ICW1		0x00a0
#define PIC1_OCW2		0x00a0
#define PIC1_IMR		0x00a1
#define PIC1_ICW2		0x00a1
#define PIC1_ICW3		0x00a1
#define PIC1_ICW4		0x00a1

#define MEMMAN_FREES	1000
#define ALLOC_SIZE	0x1000		// メモリ割り当てユニットサイズ/
#define MEMORY_START_ADDR	0x00400000

struct freeinfo{	/* 空き情報	*/
	unsigned int addr;
	unsigned int size;
};
struct memman{		/* メモリ管理	*/
	int frees;			// フリーエリアの数
	int maxfrees;			// フリーエリアの今まででの最大数
	struct freeinfo free[MEMMAN_FREES];
};


struct sheet{
	unsigned char *buf;
	int sheet_numb;
	int bxsize;		// sheet の 幅/
	int bysize;		// sheet の 高さ/
	int vx0;		// 画面上の sheet 位置/
	int vy0;		// 画面上の sheet 位置/
	int col_inv;		// 透明色/
	int height;		// sheet 位置（高さ）
	int flags;
	
	int cur_x_m;		// 文字単位のカーソル位置/
	int cur_y_m;		// 文字単位のカーソル位置/
	char cur_data_m[8];	// カーソル置き換えデータ/
	int text_color_m;
	int back_color_m;
	int rev_flag_m;		// 0:text_color が文字色、back_color がバック色   1:text_color と back_color の役割反転/
	
	int cur_x_s;		// 文字単位のカーソル位置/
	int cur_y_s;		// 文字単位のカーソル位置/
	char cur_data_s[8];	// カーソル置き換えデータ/
	int text_color_s;
	int back_color_s;
	int rev_flag_s;		// 0:text_color が文字色、back_color がバック色   1:text_color と back_color の役割反転/
	
	int *cur_x;		// 文字単位のカーソル位置/
	int *cur_y;		// 文字単位のカーソル位置/
	char *cur_data;		// カーソル置き換えデータ/
	int *text_color;
	int *back_color;
	int *rev_flag;		// 0:text_color が文字色、back_color がバック色   1:text_color と back_color の役割反転/

	int last_cur_x;		// １行の文字数、文字幅は 6 dot 固定/
	int last_cur_y;		// １列の行数、文字高は 16 dot 固定/
//	int bxsize;		// sheet の幅
	int bx1;		// 描画エリアの開始位置（相対座標）/
	int by1;
	int bxsize1;		// 描画エリアの幅/
	int bysize1;
	int main_disp_flag;	// 1:main_display, 0:sub_display
	int shift;		// 1:shift, 2:ctl, 3:alt, 4:hata, 5:maru
};

#define MAX_SHEETS		256
#define SHEET_USE		1

struct shtctl{
	unsigned char *vram;	// vram address
	unsigned short *map;	// 重ね合わせのマップ/
	int xsize;		// スクリーンサイズ/
	int ysize;		// スクリーンサイズ/
	int top;		// 使用しているシートの数 - 1
	struct sheet *sheets[MAX_SHEETS];	// 表示順の sheet
	struct sheet sheets0[MAX_SHEETS];	// sheet のエリア/
};

#define MAX_TIMER		500
#define CMD_TIMER0		256	// 256～755
//#define CMD_KEYIN		756

struct timer{
	struct fifo32 *fifo;
	struct TASK *task;
	unsigned int start_time;	//動作中a
	unsigned int duration;
//	int cmd;		// CMD_xxSEC
	int flag;		// 0:stop(free), -1:stop(used), 1: one shot timer, (2:repeat timer), 3:delay timer
};

struct timerctl{
	unsigned int count;
	struct timer timer[MAX_TIMER];
};

/* fifo.c */
struct fifo32 {
	int *buf;
	int p, q, size, free, flags;	// flags: 0:未使用、1:初期化完了、2:overrun
	struct TASK *task;		// データが入った時に起こすタスク/
};

/* mtask.c */
#define MAX_TASKS		1000	/* 最大タスク数 */
#define TASK_GDT0		4		/* TSSをGDTの何番から割り当てるのか */
#define MAX_TASKS_LV	100
#define MAX_TASKLEVELS	10
struct TSS32 {
	int backlink, esp0, ss0, esp1, ss1, esp2, ss2, cr3;
	int eip, eflags, eax, ecx, edx, ebx, esp, ebp, esi, edi;
	int es, cs, ss, ds, fs, gs;
	int ldtr, iomap;
};
struct TASK {
	int sel, flags; /* selはGDTの番号のこと */
				// flags: 0:初期化していない、1:スリープ中、2:動作中/
	int level;		// level:0 が最高レベル/
	struct TSS32 tss;
};
struct TASKLEVEL {
	int running; /* 動作しているタスクの数 */
	int now; /* 現在動作しているタスクがどれだか分かるようにするための変数 */
	struct TASK *tasks[MAX_TASKS_LV];
};
struct TASKCTL {
	int inhibit_task_switch;	/* 実行中タスク無し、タスクスイッチ禁止状態 */
	int now_lv;			/* 現在動作中のレベル */
	char lv_change;			/* 次回タスクスイッチのときに、レベルも変えたほうがいいかどうか */
	struct TASK *switch_task_a;	// task_a ポインタ、初回の farjmp() での排除タスク/
	struct TASKLEVEL level[MAX_TASKLEVELS];
	struct TASK tasks0[MAX_TASKS];
};


extern struct fifo32 main_fifo;
extern struct BOOTINFO *binfo;
extern unsigned char KanjiFont12b[7896+1][18];
extern unsigned char chara_gene[];		// 6x8 charactor, bit0 が上/
extern int shift_status;			// 0:lower case, 1:upper case
extern struct memman memman;
extern struct shtctl *shtctl;
extern struct sheet *main_sheet;		// 一番下のシート（画面全面）/
extern struct timerctl timerctl;
extern unsigned char APP_ch;			// 10ms 割り込みでのキー入力/
//extern struct timer timer[MAX_TIMER];
extern char *fatal_str;
//extern int task_timer;			// task switch 用のタイマー番号
extern struct TASKCTL *taskctl;
//extern struct TASK *switch_task_a;	// task_a ポインタ、初回の farjmp() での排除タスク/
//extern int inhibit_task_switch;
extern int hoge1;
//extern struct delay delay[MAX_DELAY];
extern int getc_char;
