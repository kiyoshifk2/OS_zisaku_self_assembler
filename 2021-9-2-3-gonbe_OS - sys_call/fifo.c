/* FIFO���C�u���� */

#include "gonbe.h"
#include "function.h"


int hoge1;


#define FLAGS_OVERRUN		0x0002

void fifo32_init(struct fifo32 *fifo, int size, int *buf, struct TASK *task)
/* FIFO�o�b�t�@�̏����� */
{
	fifo->flags = 1;	// ����������/
	fifo->size = size;	// �G�������g��/
	fifo->buf = buf;
	fifo->free = size; /* �� */
//	fifo->flags = 0;
	fifo->p = 0; /* �������݈ʒu */
	fifo->q = 0; /* �ǂݍ��݈ʒu */
	fifo->task = task;		// �f�[�^�����������ɋN�����^�X�N/
	return;
}

//	���̊֐��͊��荞�݃��[�`������Ă΂��
int fifo32_put(struct fifo32 *fifo, int data)
/* FIFO�փf�[�^�𑗂荞��Œ~���� */
{
	int save;
	
	if(fifo->flags==0){	// ���������Ă��Ȃ�/
		return -1;	// ���ӂꂽ���ɂ���/
	}
	if (fifo->free == 0) {
		/* �󂫂��Ȃ��Ă��ӂꂽ */
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
		if (fifo->task->flags != 2) { /* �^�X�N���Q�Ă����� */
			save = taskctl->inhibit_task_switch;
			task_run(fifo->task, -1); /* �N�����Ă����� */
			taskctl->inhibit_task_switch = save;
//			hoge1 = 1;	/* wakeup ���ꂽ */
		}
	}
	return 0;
}

int fifo32_get(struct fifo32 *fifo)
/* FIFO����f�[�^����Ƃ��Ă��� */
{
	int data;

	if(fifo->flags==0){	// ���������Ă��Ȃ�/
		return -1;	// ��ł��邱�Ƃɂ���/
	}
	if (fifo->free == fifo->size) {
		/* �o�b�t�@������ۂ̂Ƃ��́A�Ƃ肠����-1���Ԃ���� */
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
/* �ǂ̂��炢�f�[�^�����܂��Ă��邩��񍐂��� */
{
	return fifo->size - fifo->free;
}
