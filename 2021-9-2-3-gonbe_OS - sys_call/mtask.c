/* マルチタスク関係 */

#include "gonbe.h"
#include "function.h"


struct TASKCTL *taskctl;
//struct TIMER *task_timer;
//int task_timer;
//int inhibit_task_switch;
//struct TASK *switch_task_a;




struct TASK *task_now(void)
{
	struct TASK *task;
	int eflags = io_load_eflags();
	
	disable_interrupt();
	struct TASKLEVEL *tl = &taskctl->level[taskctl->now_lv];
	task = tl->tasks[tl->now];
	io_store_eflags(eflags);
	return task;
}

void task_add(struct TASK *task)
{
	int eflags = io_load_eflags();
	
	disable_interrupt();
	struct TASKLEVEL *tl = &taskctl->level[task->level];
	tl->tasks[tl->running] = task;
	tl->running++;
	task->flags = 2; /* 動作中 */
	taskctl->inhibit_task_switch = 0;		// running task 有
	io_store_eflags(eflags);
	return;
}

//	割り込み禁止で呼び出される、hlt の前に割り込みフラグを復元する
//	return 0:normal, 1:hlt から抜けた
int task_remove(struct TASK *task, int eflags)
{
	int i;
	struct TASKLEVEL *tl = &taskctl->level[task->level];

	/* taskがどこにいるかを探す */
	for (i = 0; i < tl->running; i++) {
		if (tl->tasks[i] == task) {
			/* ここにいた */
			break;
		}
	}

	tl->running--;
	if (i < tl->now) {
		tl->now--; /* ずれるので、これもあわせておく */
	}
	if (tl->now >= tl->running) {
		/* nowがおかしな値になっていたら、修正する */
		tl->now = 0;
	}
	task->flags = 1; /* スリープ中 */

	/* ずらし */
	for (; i < tl->running; i++) {
		tl->tasks[i] = tl->tasks[i + 1];
	}
	
	/* 動作可能タスクが無くなった時の処理 */
	if(tl->running==0){
		for(;;){
			task_switchsub();
			if(taskctl->inhibit_task_switch==0){
				return 1;	// 正常終了
			}
			io_store_eflags(eflags);
			gonbe_hlt();
			disable_interrupt();
		}
	}

	return 0;
}

void task_switchsub(void)
{
	int i;
	int eflags = io_load_eflags();
	
	disable_interrupt();
	/* 一番上のレベルを探す */
	for (i = 0; i < MAX_TASKLEVELS; i++) {
		if (taskctl->level[i].running > 0) {
			taskctl->inhibit_task_switch = 0;	// running task 有
			break; /* 見つかった */
		}
	}
	if(i==MAX_TASKLEVELS){
		taskctl->inhibit_task_switch = 1;	// running task 無し
	}
	taskctl->now_lv = i;
	taskctl->lv_change = 0;
	io_store_eflags(eflags);
	return;
}

struct TASK *task_init()
{
	int i;
	struct TASK *task;
	struct SEGMENT_DESCRIPTOR *gdt = (struct SEGMENT_DESCRIPTOR *) ADR_GDT;
	taskctl = (struct TASKCTL *) memman_alloc(sizeof (struct TASKCTL));
	for (i = 0; i < MAX_TASKS; i++) {
		taskctl->tasks0[i].flags = 0;
		taskctl->tasks0[i].sel = (TASK_GDT0 + i) * 8;
		set_segmdesc(gdt + TASK_GDT0 + i, 103, (int) &taskctl->tasks0[i].tss, AR_TSS32);
	}
	for (i = 0; i < MAX_TASKLEVELS; i++) {
		taskctl->level[i].running = 0;
		taskctl->level[i].now = 0;
	}
	task = task_alloc();
	task->flags = 2;	/* 動作中マーク */
	taskctl->inhibit_task_switch = 0;	// running task 有
	task->level = 0;	/* 最高レベル */
//AAAAA	task_add(task);
	task_switchsub();	/* レベル設定 */
	load_tr(task->sel);
	return task;
}

struct TASK *task_alloc(void)
{
	int i;
	struct TASK *task;
	for (i = 0; i < MAX_TASKS; i++) {
		if (taskctl->tasks0[i].flags == 0) {
			task = &taskctl->tasks0[i];
			task->flags = 1; /* 使用中マーク */
			task->tss.eflags = 0x00000202; /* IF = 1; */
			task->tss.eax = 0; /* とりあえず0にしておくことにする */
			task->tss.ecx = 0;
			task->tss.edx = 0;
			task->tss.ebx = 0;
			task->tss.ebp = 0;
			task->tss.esi = 0;
			task->tss.edi = 0;
			task->tss.es = 0;
			task->tss.ds = 0;
			task->tss.fs = 0;
			task->tss.gs = 0;
			task->tss.ldtr = 0;
			task->tss.iomap = 0x40000000;
			return task;
		}
	}
	fatal_a("*** task_alloc table full\n");
	return 0; /* もう全部使用中 */
}

//	この関数はタスクレベルと割り込みレベルの両方から呼び出される
//	内部の task_remove() 内で hlt することが有るから、割り込みから呼ぶときは hlt しない条件でのみ呼び出せる
//	この為には引数の level を -1 にして置けばよい
void task_run(struct TASK *task, int level)
{
	int eflags = io_load_eflags();
	
	disable_interrupt();
	if (level < 0) {
		level = task->level; /* レベルを変更しない */
	}
	if (task->flags == 2 && task->level != level) { /* 動作中のレベルの変更 */
		task_remove(task, eflags); /* これを実行するとflagsは1になるので下のifも実行される */
		
	}
	if (task->flags != 2) {
		/* スリープから起こされる場合 */
		task->level = level;
//if(hoge1)ut_printf(main_sheet,"--- task_run call task_add()\n");
		task_add(task);
	}

	taskctl->lv_change = 1; /* 次回タスクスイッチのときにレベルを見直す */
	io_store_eflags(eflags);
	return;
}

//	タスクレベルで呼び出される
void task_sleep(struct TASK *task)
{
	struct TASK *now_task;
	int eflags = io_load_eflags();
	
	disable_interrupt();
	if (task->flags == 2) {
		/* 動作中だったら */
		now_task = task_now();
		task_remove(task, eflags); /* これを実行するとflagsは1になる */
		if (task == now_task) {
			/* 自分自身のスリープだったので、タスクスイッチが必要 */
			task_switchsub();
			now_task = task_now(); /* 設定後での、「現在のタスク」を教えてもらう */
			if(now_task != task){	/* 自分自身へのディスパッチ禁止 */
//if(hoge1)fatal_a("task_sleep farjmp");
				farjmp(0, now_task->sel);
			}
		}
	}
//if(hoge1)ut_printf(main_sheet, "ret task_sleep");
	io_store_eflags(eflags);
	return;
}

//	タイマー割り込みルーチン内で呼び出される
void task_switch(void)
{
	int i, j;
	struct TASKLEVEL *tl;
	struct TASK *new_task, *now_task;

	if(taskctl->switch_task_a){		/* 初回 farjmp()	*/
		for(i=0; i<MAX_TASKLEVELS; i++){
			tl = &taskctl->level[i];
			for(j=0; j<MAX_TASKS_LV; j++){
				now_task = tl->tasks[j];
				if(now_task!=taskctl->switch_task_a && now_task->flags==2){	// 動作中ならば
					taskctl->now_lv = i;
					tl->now = j;
					taskctl->switch_task_a = 0;
					taskctl->lv_change = 1;		/* 最上位タスクを実行する為 */
					farjmp(0, now_task->sel);
				}
			}
		}
		return;
	}

	
	if(taskctl->inhibit_task_switch){	/* running task 無し */
		return;
	}

	tl = &taskctl->level[taskctl->now_lv];
	now_task = tl->tasks[tl->now];
//if(hoge1)ut_printf(main_sheet, "=== now_lv=%d tl->now=%d\n", taskctl->now_lv, tl->now);
	tl->now++;
	if (tl->now == tl->running) {
		tl->now = 0;
	}
	if (taskctl->lv_change != 0) {		/* level の変化有 */
		task_switchsub();
		tl = &taskctl->level[taskctl->now_lv];
	}
	new_task = tl->tasks[tl->now];
//if(hoge1)ut_printf(main_sheet, "*** now_lv=%d tl->now=%d\n", taskctl->now_lv, tl->now);

	if (new_task != now_task) {
//if(hoge1)fatal_a("task_switch farjmp");
		farjmp(0, new_task->sel);
	}
	return;
}
