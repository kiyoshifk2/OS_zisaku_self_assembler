/* �}���`�^�X�N�֌W */

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
	task->flags = 2; /* ���쒆 */
	taskctl->inhibit_task_switch = 0;		// running task �L
	io_store_eflags(eflags);
	return;
}

//	���荞�݋֎~�ŌĂяo�����Ahlt �̑O�Ɋ��荞�݃t���O�𕜌�����
//	return 0:normal, 1:hlt ���甲����
int task_remove(struct TASK *task, int eflags)
{
	int i;
	struct TASKLEVEL *tl = &taskctl->level[task->level];

	/* task���ǂ��ɂ��邩��T�� */
	for (i = 0; i < tl->running; i++) {
		if (tl->tasks[i] == task) {
			/* �����ɂ��� */
			break;
		}
	}

	tl->running--;
	if (i < tl->now) {
		tl->now--; /* �����̂ŁA��������킹�Ă��� */
	}
	if (tl->now >= tl->running) {
		/* now���������Ȓl�ɂȂ��Ă�����A�C������ */
		tl->now = 0;
	}
	task->flags = 1; /* �X���[�v�� */

	/* ���炵 */
	for (; i < tl->running; i++) {
		tl->tasks[i] = tl->tasks[i + 1];
	}
	
	/* ����\�^�X�N�������Ȃ������̏��� */
	if(tl->running==0){
		for(;;){
			task_switchsub();
			if(taskctl->inhibit_task_switch==0){
				return 1;	// ����I��
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
	/* ��ԏ�̃��x����T�� */
	for (i = 0; i < MAX_TASKLEVELS; i++) {
		if (taskctl->level[i].running > 0) {
			taskctl->inhibit_task_switch = 0;	// running task �L
			break; /* �������� */
		}
	}
	if(i==MAX_TASKLEVELS){
		taskctl->inhibit_task_switch = 1;	// running task ����
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
	task->flags = 2;	/* ���쒆�}�[�N */
	taskctl->inhibit_task_switch = 0;	// running task �L
	task->level = 0;	/* �ō����x�� */
//AAAAA	task_add(task);
	task_switchsub();	/* ���x���ݒ� */
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
			task->flags = 1; /* �g�p���}�[�N */
			task->tss.eflags = 0x00000202; /* IF = 1; */
			task->tss.eax = 0; /* �Ƃ肠����0�ɂ��Ă������Ƃɂ��� */
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
	return 0; /* �����S���g�p�� */
}

//	���̊֐��̓^�X�N���x���Ɗ��荞�݃��x���̗�������Ăяo�����
//	������ task_remove() ���� hlt ���邱�Ƃ��L�邩��A���荞�݂���ĂԂƂ��� hlt ���Ȃ������ł̂݌Ăяo����
//	���ׂ̈ɂ͈����� level �� -1 �ɂ��Ēu���΂悢
void task_run(struct TASK *task, int level)
{
	int eflags = io_load_eflags();
	
	disable_interrupt();
	if (level < 0) {
		level = task->level; /* ���x����ύX���Ȃ� */
	}
	if (task->flags == 2 && task->level != level) { /* ���쒆�̃��x���̕ύX */
		task_remove(task, eflags); /* ��������s�����flags��1�ɂȂ�̂ŉ���if�����s����� */
		
	}
	if (task->flags != 2) {
		/* �X���[�v����N�������ꍇ */
		task->level = level;
//if(hoge1)ut_printf(main_sheet,"--- task_run call task_add()\n");
		task_add(task);
	}

	taskctl->lv_change = 1; /* ����^�X�N�X�C�b�`�̂Ƃ��Ƀ��x���������� */
	io_store_eflags(eflags);
	return;
}

//	�^�X�N���x���ŌĂяo�����
void task_sleep(struct TASK *task)
{
	struct TASK *now_task;
	int eflags = io_load_eflags();
	
	disable_interrupt();
	if (task->flags == 2) {
		/* ���쒆�������� */
		now_task = task_now();
		task_remove(task, eflags); /* ��������s�����flags��1�ɂȂ� */
		if (task == now_task) {
			/* �������g�̃X���[�v�������̂ŁA�^�X�N�X�C�b�`���K�v */
			task_switchsub();
			now_task = task_now(); /* �ݒ��ł́A�u���݂̃^�X�N�v�������Ă��炤 */
			if(now_task != task){	/* �������g�ւ̃f�B�X�p�b�`�֎~ */
//if(hoge1)fatal_a("task_sleep farjmp");
				farjmp(0, now_task->sel);
			}
		}
	}
//if(hoge1)ut_printf(main_sheet, "ret task_sleep");
	io_store_eflags(eflags);
	return;
}

//	�^�C�}�[���荞�݃��[�`�����ŌĂяo�����
void task_switch(void)
{
	int i, j;
	struct TASKLEVEL *tl;
	struct TASK *new_task, *now_task;

	if(taskctl->switch_task_a){		/* ���� farjmp()	*/
		for(i=0; i<MAX_TASKLEVELS; i++){
			tl = &taskctl->level[i];
			for(j=0; j<MAX_TASKS_LV; j++){
				now_task = tl->tasks[j];
				if(now_task!=taskctl->switch_task_a && now_task->flags==2){	// ���쒆�Ȃ��
					taskctl->now_lv = i;
					tl->now = j;
					taskctl->switch_task_a = 0;
					taskctl->lv_change = 1;		/* �ŏ�ʃ^�X�N�����s����� */
					farjmp(0, now_task->sel);
				}
			}
		}
		return;
	}

	
	if(taskctl->inhibit_task_switch){	/* running task ���� */
		return;
	}

	tl = &taskctl->level[taskctl->now_lv];
	now_task = tl->tasks[tl->now];
//if(hoge1)ut_printf(main_sheet, "=== now_lv=%d tl->now=%d\n", taskctl->now_lv, tl->now);
	tl->now++;
	if (tl->now == tl->running) {
		tl->now = 0;
	}
	if (taskctl->lv_change != 0) {		/* level �̕ω��L */
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
