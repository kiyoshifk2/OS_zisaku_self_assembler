#include "gonbe.h"
#include "function.h"

/*
*struct TASK *current_task;	を計算するには
*  tl = &taskctl->level[taskctl->now_lv];
*  current_task = tl->tasks[tl->now];		但し inhibit_task_switch が 0 である事
*  current_task はこの計算式でいつでも計算できる
*
*struct delay{
*	int flag;	0:未使用、1:使用中
*	sturct TASK *task;
*	unsigned int start_time;
*	unsigned int duration;
*};
*
*struct delay delay[100];
*
*  msec の間 wait する
*void delay_task(unsigned int msec);
*  まず空き delay をサーチしてエレメントを設定する
*  task_sleep() を実行する task は自タスク（current_task）
*
*10msec 割り込みルーチンから delay_timer() を呼び出す
*
*void delay_timer()
*  delay[100] をなめて fire したのをサーチする
*  fire していたらそのタスクを task_run() にて実行可能タスクとして登録して flag を未使用に戻す
*  この時 inhibit_task_switch は変更しないようにする事
*};
*/


//struct delay delay[MAX_DELAY];


void delay_task(unsigned int msec)
{
	struct TASKLEVEL *tl;
	struct TASK *task;
	int i;
	int eflags = io_load_eflags();
	
	disable_interrupt();
	tl = &taskctl->level[taskctl->now_lv];
	task = tl->tasks[tl->now];
	
	for(i=0; i<MAX_TIMER; i++){
		if(timerctl.timer[i].flag==0){	/* 未使用ブロック発見 */
			break;
		}
	}
	if(i==MAX_TIMER){
		fatal_a("*** delay_task table area nothing");
	}
	timerctl.timer[i].fifo = 0;
	timerctl.timer[i].start_time = GetTickCount();
	timerctl.timer[i].duration = msec;
	timerctl.timer[i].task = task;
	timerctl.timer[i].flag = 3;	/* delay timer */
	
	io_store_eflags(eflags);
	task_sleep(task);
}

//void delay_timer()
//{
//	int i, save;
////	volatile int k=100000000;
//	
//	for(i=0; i<MAX_DELAY; i++){
//		if(delay[i].flag==1){
////ut_printf(main_sheet,"--- flag==1\n");//AAAAA
//			if(GetTickCount()-delay[i].start_time >= delay[i].duration &&
//					taskctl->switch_task_a==0 &&
//					delay[i].task->flags!=2){	/* fire */
////ut_printf(main_sheet,"*** fire\n");//AAAAA
////for(k=0; k<100000000; k++){}
//
////while(k)
////	k--;
//				delay[i].flag = 0;	/* 未使用にする */
//				save = taskctl->inhibit_task_switch;
//				task_run(delay[i].task, -1);	/* タスクを起こす */
//				taskctl->inhibit_task_switch = save;
//			}
//		}
//	}
//}
