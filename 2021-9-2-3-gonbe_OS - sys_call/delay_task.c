#include "gonbe.h"
#include "function.h"

/*
*struct TASK *current_task;	���v�Z����ɂ�
*  tl = &taskctl->level[taskctl->now_lv];
*  current_task = tl->tasks[tl->now];		�A�� inhibit_task_switch �� 0 �ł��鎖
*  current_task �͂��̌v�Z���ł��ł��v�Z�ł���
*
*struct delay{
*	int flag;	0:���g�p�A1:�g�p��
*	sturct TASK *task;
*	unsigned int start_time;
*	unsigned int duration;
*};
*
*struct delay delay[100];
*
*  msec �̊� wait ����
*void delay_task(unsigned int msec);
*  �܂��� delay ���T�[�`���ăG�������g��ݒ肷��
*  task_sleep() �����s���� task �͎��^�X�N�icurrent_task�j
*
*10msec ���荞�݃��[�`������ delay_timer() ���Ăяo��
*
*void delay_timer()
*  delay[100] ���Ȃ߂� fire �����̂��T�[�`����
*  fire ���Ă����炻�̃^�X�N�� task_run() �ɂĎ��s�\�^�X�N�Ƃ��ēo�^���� flag �𖢎g�p�ɖ߂�
*  ���̎� inhibit_task_switch �͕ύX���Ȃ��悤�ɂ��鎖
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
		if(timerctl.timer[i].flag==0){	/* ���g�p�u���b�N���� */
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
//				delay[i].flag = 0;	/* ���g�p�ɂ��� */
//				save = taskctl->inhibit_task_switch;
//				task_run(delay[i].task, -1);	/* �^�X�N���N���� */
//				taskctl->inhibit_task_switch = save;
//			}
//		}
//	}
//}
