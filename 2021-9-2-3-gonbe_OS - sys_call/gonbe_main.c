#include "gonbe.h"
#include "function.h"


//struct BOOTINFO { /* 0x0ff0-0x0fff */
//	char cyls; /* ブートセクタはどこまでディスクを読んだのか */
//	char leds; /* ブート時のキーボードのLEDの状態 */
//	char vmode; /* ビデオモード  何ビットカラーか */
//	char reserve;
//	short scrnx, scrny; /* 画面解像度 */
//	char *vram;
//};
//#define ADR_BOOTINFO	0x00000ff0


char __attribute__((section(".stack_area"))) stack_buf[100000];
char __attribute__((section(".stack_area"))) stack_40[10000];
struct fifo32 main_fifo;
int main_fifo_buf[128];
struct BOOTINFO *binfo;
//char stack_buf[100000];
int memory_mb;
struct sheet *main_sheet;		// 一番下のシート（画面全面）/
//int hoge_gonbe_main=1;
int getc_char;

void init();
void task_b_main(struct sheet *sht_back, struct TASK *task);
void task_c_main(struct sheet *sht_back, struct TASK *task);
void task_idle();
void mt_init();
void command_init();


void idt_save();

int gonbe_main(void)
{
	int i, cmd_10sec;
	struct TASK *task_a, *task_i;
//	struct TASK *task_b[3];
//	struct sheet *sht_win_b[3];
//	unsigned char *buf_win_b;
	
	init();

	ut_printf(main_sheet, "bss_clear() %x-%x\n", BSS_START, BSS_END);
	ut_printf(main_sheet, "%dMB OK\n", memory_mb);
	ut_printf(main_sheet, "scrnx=%d scrny=%d\n", binfo->scrnx, binfo->scrny);
	ut_printf(main_sheet, "暴\走 read_idt\n");
	
	ut_printf(main_sheet, "=== 1234 テスト\n");
	ut_printf(main_sheet, "％d = |%d|\n", 1234);
	ut_printf(main_sheet, "％6d = |%6d|\n", 1234);
	ut_printf(main_sheet, "％06d = |%06d|\n", 1234);
	ut_printf(main_sheet, "％-6d = |%-6d|\n", 1234);
	ut_printf(main_sheet, "％06x = |%06x|\n", 0x1234);
	ut_printf(main_sheet, "％6s = |%6s|\n", "1234");
	ut_printf(main_sheet, "％06c = |%06c|\n", '1');
	
	cmd_10sec = set_oneshot_timer(&main_fifo, 10000) + CMD_TIMER0;

	task_a = task_init();		/* taskctl エリアとメインタスク情報を初期化 */
	main_fifo.task = task_a;	/* fifo にタスクを関係づける */
	task_run(task_a, 1);	/* メインタスクを実行可能タスクとして登録する */
	taskctl->switch_task_a = task_a;	/* 初回実行拒否タスクとして登録 */
	
	/***	idle task	***/
	task_i = task_alloc();
	task_i->tss.esp = memman_alloc(8*1024) + 8*1024 -8-4;
	task_i->tss.eip = (int)&task_idle;
	task_i->tss.es = 1 * 8;
	task_i->tss.cs = 2 * 8;
	task_i->tss.ss = 1 * 8;
	task_i->tss.ds = 1 * 8;
	task_i->tss.fs = 1 * 8;
	task_i->tss.gs = 1 * 8;
	task_run(task_i, MAX_TASKLEVELS-1);

	command_init();		/* コマンドプロンプト */

#if 0
	/* sht_win_b */
	for (i = 0; i < 3; i++) {
		sht_win_b[i] = sheet_alloc(144, 100, 0xffff);

		task_b[i] = task_alloc();
		task_b[i]->tss.esp = memman_alloc(64 * 1024) + 64 * 1024 - 8-4;
		if(i<2){
			task_b[i]->tss.eip = (int) &task_b_main;
		}
		else{
			task_b[i]->tss.eip = (int) &task_c_main;
		}
		task_b[i]->tss.es = 1 * 8;
		task_b[i]->tss.cs = 2 * 8;
		task_b[i]->tss.ss = 1 * 8;
		task_b[i]->tss.ds = 1 * 8;
		task_b[i]->tss.fs = 1 * 8;
		task_b[i]->tss.gs = 1 * 8;
		*((int *) (task_b[i]->tss.esp + 4)) = (int) sht_win_b[i];
		*((int *) (task_b[i]->tss.esp + 8)) = (int)task_b[i];
		task_run(task_b[i], 2);
	}
	sheet_slide(sht_win_b[0], 200+500,  50);
	sheet_slide(sht_win_b[1],     500, 300);
	sheet_slide(sht_win_b[2], 200+500, 300);
	sheet_updown(sht_win_b[0], 1);
	sheet_updown(sht_win_b[1], 2);
	sheet_updown(sht_win_b[2], 3);
#endif

	io_out8(PIC0_IMR, 0xfe); /* PITを許可(11111110) */

	for(;;){
		struct sheet *sht;
		int top;
		
		delay_task(10);
		disable_interrupt();
		if(fifo32_status(&main_fifo)==0){	// fifo にデータが入っていない/
			enable_interrupt();
			gonbe_hlt();			// hlt
		}
		else{
			i = fifo32_get(&main_fifo);	// fifo から１こアイテムを取り出す/
			enable_interrupt();
			if(i>=0 && i<256){		// key input ascii code
				top = shtctl->top;
				sht = shtctl->sheets[top];
				select_sub_disp(sht);
				switch(sht->shift){
					case 0:
						ut_printf(sht, "\n      ");
						break;
					case 1:
						ut_printf(sht, "\nSHIFT ");
						break;
					case 2:
						ut_printf(sht, "\nCNTL  ");
						break;
					case 3:
						ut_printf(sht, "\nALT   ");
						break;
					case 4:
						ut_printf(sht, "\nHATA  ");
						break;
					case 5:
						ut_printf(sht, "\nMARU  ");
						break;
				}
				select_main_disp(sht);
				
				getc_char = 0;
				if(i==ALT_RIGHT){	// sheet up
					if(top >= 1){
						sheet_updown(shtctl->sheets[0], top);
					}
				}
				else if(i==ALT_LEFT){
					if(top >= 1){
						sheet_updown(shtctl->sheets[top], 0);
					}
				}

				else if(i==CTL_UP){
					if(top >= 0){
						sht->vy0 -= 20;
						if(sht->vy0 < 0) sht->vy0 = 0;
						sheet_refresh();
					}
				}
				else if(i==CTL_DOWN){
					if(top >= 0){
						sht->vy0 += 20;
						if(sht->vy0+sht->bysize > shtctl->ysize) sht->vy0 = shtctl->ysize - sht->bysize;
						sheet_refresh();
					}
				}
				else if(i==CTL_RIGHT){
					if(top >= 0){
						sht->vx0 += 20;
						if(sht->vx0+sht->bxsize > shtctl->xsize) sht->vx0 = shtctl->xsize - sht->bxsize;
						sheet_refresh();
					}
				}
				else if(i==CTL_LEFT){
					if(top >= 0){
						sht->vx0 -= 20;
						if(sht->vx0 < 0) sht->vx0 = 0;
						sheet_refresh();
					}
				}

				else if(i==SFT_UP){
					if(top >= 0){
						sheet_resize(sht, sht->bxsize, sht->bysize-20);
						sheet_refresh();
					}
				}
				else if(i==SFT_DOWN){
					if(top >= 0){
						sheet_resize(sht, sht->bxsize, sht->bysize+20);
						sheet_refresh();
					}
				}
				else if(i==SFT_RIGHT){
					if(top >= 0){
						sheet_resize(sht, sht->bxsize+20, sht->bysize);
						sheet_refresh();
					}
				}
				else if(i==SFT_LEFT){
					if(top >= 0){
						sheet_resize(sht, sht->bxsize-20, sht->bysize);
						sheet_refresh();
					}
				}
				else{
					getc_char = i;
				}
			}
			else if(i==cmd_10sec){
				ut_printf(main_sheet, "=== 10sec timeout\n");
				cmd_10sec = set_oneshot_timer(&main_fifo, 10000) + CMD_TIMER0;
			}
//			else if(i==cmd_100msec){
//				dot(COL8_FF0000);//AAAAA
//				cmd_100msec = set_oneshot_timer(&main_fifo, 100) + CMD_TIMER0;
//			}
			else{
				ut_printf(main_sheet, "*** undefined cmd %d\n", i);
			}
		}
	}
}

void init()
{
//	unsigned char *buf;
	struct sheet *sht;

	bss_clear();
	binfo = (struct BOOTINFO *)ADR_BOOTINFO;
	memset(binfo->vram, COL8_FFFFFF, binfo->scrnx * binfo->scrny);
	init_gdtidt();
	init_palette();
	dispinit();
	memory_mb = memcheck(MEMORY_START_ADDR, 0xffffffff);
	memman_init(&memman, MEMORY_START_ADDR, memory_mb);
	shtctl_init();
	sht = sheet_alloc(binfo->scrnx, binfo->scrny, 0xffff);
	sheet_slide(sht, 0, 0);
	
//	下記行を生かせば main_sheet を前面に出せる
	sheet_updown(sht, 0);
	main_sheet = sht;
	fifo32_init(&main_fifo, 128, main_fifo_buf, 0);

	init_pic();
	enable_interrupt();
	init_pit();
//	io_out8(PIC0_IMR, 0xfe); /* PITを許可(11111110) */
}

void task_idle()
{
	for(;;){
		gonbe_hlt();
	}
}

void task_b_main(struct sheet *sht, struct TASK *task)
{
	struct fifo32 fifo;
//	struct timer *timer_put;
	int i, fifobuf[128], count = 0;
//	char s[12];
	int cmd_1sec;
	
ut_printf(main_sheet,"=== start task_b\n");
	
	fifo32_init(&fifo, 128, fifobuf, task);
	cmd_1sec = set_oneshot_timer(&fifo, 1000) + CMD_TIMER0;
	
	for (;;) {
		count++;
		disable_interrupt();
		if (fifo32_status(&fifo) == 0) {
			enable_interrupt();
		} else {
			i = fifo32_get(&fifo);
			enable_interrupt();
			if (i == cmd_1sec) {
				ut_printf(sht, "\ncount=%d", count);
//				sheet_refreshsub(sht);
				cmd_1sec = set_oneshot_timer(&fifo, 1000) + CMD_TIMER0;
				task_sleep(task);
			}
		}
	}
}

void task_c_main(struct sheet *sht, struct TASK *task)
{
//	char buf[100];
	
	for(;;){
		ut_printf(sht, "in=%x\n", APP_ch);
//		ut_gets(sht, buf, 100);
//		ut_printf(sht, "%s", buf);
	}
}
