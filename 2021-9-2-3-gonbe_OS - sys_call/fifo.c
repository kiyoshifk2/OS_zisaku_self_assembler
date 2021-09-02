/* FIFOライブラリ */

#include "gonbe.h"
#include "function.h"


int hoge1;


#define FLAGS_OVERRUN		0x0002

void fifo32_init(struct fifo32 *fifo, int size, int *buf, struct TASK *task)
/* FIFOバッファの初期化 */
{
	fifo->flags = 1;	// 初期化完了/
	fifo->size = size;	// エレメント数/
	fifo->buf = buf;
	fifo->free = size; /* 空き */
//	fifo->flags = 0;
	fifo->p = 0; /* 書き込み位置 */
	fifo->q = 0; /* 読み込み位置 */
	fifo->task = task;		// データが入った時に起こすタスク/
	return;
}

//	この関数は割り込みルーチンから呼ばれる
int fifo32_put(struct fifo32 *fifo, int data)
/* FIFOへデータを送り込んで蓄える */
{
	int save;
	
	if(fifo->flags==0){	// 初期化していない/
		return -1;	// あふれた事にする/
	}
	if (fifo->free == 0) {
		/* 空きがなくてあふれた */
		fifo->flags |= FLAGS_OVERRUN;
		return -1;
	}
	fifo->buf[fifo->p] = data;
	fifo->p++;
	if (fifo->p == fifo->size) {
		fifo->p = 0;
	}
	fifo->free--;
	if (fifo->task != 0 && taskctl->switch_task_a==0) {
		if (fifo->task->flags != 2) { /* タスクが寝ていたら */
			save = taskctl->inhibit_task_switch;
			task_run(fifo->task, -1); /* 起こしてあげる */
			taskctl->inhibit_task_switch = save;
//			hoge1 = 1;	/* wakeup された */
		}
	}
	return 0;
}

int fifo32_get(struct fifo32 *fifo)
/* FIFOからデータを一つとってくる */
{
	int data;

	if(fifo->flags==0){	// 初期化していない/
		return -1;	// 空であることにする/
	}
	if (fifo->free == fifo->size) {
		/* バッファが空っぽのときは、とりあえず-1が返される */
		return -1;
	}
	data = fifo->buf[fifo->q];
	fifo->q++;
	if (fifo->q == fifo->size) {
		fifo->q = 0;
	}
	fifo->free++;
	return data;
}

int fifo32_status(struct fifo32 *fifo)
/* どのくらいデータが溜まっているかを報告する */
{
	return fifo->size - fifo->free;
}
