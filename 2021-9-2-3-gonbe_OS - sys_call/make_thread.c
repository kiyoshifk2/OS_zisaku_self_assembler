#include "gonbe.h"
#include "function.h"



void make_sheet_and_thread(struct TASK **task, struct sheet **sht, int xsize, int ysize, int stk_size, int start_addr, int level)
{
	int eflags = io_load_eflags();
	
	disable_interrupt();
	*sht = sheet_alloc(xsize, ysize, 0xffff);
	sheet_slide(*sht, (shtctl->xsize-xsize)/2, (shtctl->ysize-ysize)/2);
	sheet_updown(*sht, 1000);
	*task = task_alloc();
	(*task)->tss.esp = memman_alloc(stk_size) + stk_size -12;
	(*task)->tss.eip = start_addr;
	(*task)->tss.es = 1 * 8;
	(*task)->tss.cs = 2 * 8;
	(*task)->tss.ss = 1 * 8;
	(*task)->tss.ds = 1 * 8;
	(*task)->tss.fs = 1 * 8;
	(*task)->tss.gs = 1 * 8;
	*((int *) ((*task)->tss.esp + 4)) = (int) *sht;
	*((int *) ((*task)->tss.esp + 8)) = (int) *task;
	task_run(*task, level);
	io_store_eflags(eflags);
}
