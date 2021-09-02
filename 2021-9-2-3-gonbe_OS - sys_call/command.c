#include "gonbe.h"
#include "function.h"


struct sheet *cmd_sht;
struct TASK *cmd_task;
struct TASK *run_task;

extern unsigned char *a_binfile;
extern unsigned int a_addr_top, a_addr_end;


void command(struct sheet *sht, struct TASK *task);
void sedit_main();
int asm_main();
int dbg1(int addr);


void command_init()
{
//	struct TASK *cmd_task;
//	struct sheet *cmd_sht;

	make_sheet_and_thread(&cmd_task, &cmd_sht, 500,400, 0x10000, (int)&command, 3);
}

void command_make_task()
{
	struct SEGMENT_DESCRIPTOR *gdt = (struct SEGMENT_DESCRIPTOR *) ADR_GDT;
	int i, i1, i2;
	char test[8];
	
	/***	GDT set		***/
	memset(test, 0, sizeof(test));
	i1 = i2 = 0;
	for(i=4; i<LIMIT_GDT/8; i++){
		if(memcmp(test, gdt+i, 8)==0){	/* ‹ó‚Ì GDT ”­Œ©	*/
			if(i1==0){
				i1 = i;
			}
			else{
				i2 = i;
				break;
			}
		}
	}
	if(i==LIMIT_GDT/8){
		fatal_a("*** GDT table overflow\n");
	}
	set_segmdesc(gdt+i2, 0x000fffff, (int)a_binfile, AR_CODE32_ER);
	set_segmdesc(gdt+i1, 0x000fffff, (int)a_binfile, AR_DATA32_RW);
	
	/***	task set	***/
	run_task = task_alloc();
	run_task->tss.esp = memman_alloc(0x10000) + 0x10000 -12;
	run_task->tss.eip = 0; //(int)a_binfile-0x00280000; //a_addr_top;
	run_task->tss.es = i1 * 8;
	run_task->tss.cs = i2 * 8;
	run_task->tss.ss =  1 * 8;
	run_task->tss.ds = i1 * 8;
	run_task->tss.fs = i1 * 8;
	run_task->tss.gs = i1 * 8;
	
	run_task->tss.ecx = (int)cmd_sht;	/* task ‚Ö‚Ìˆø”	*/
//	*((int *) (run_task->tss.esp + 4)) = (int) cmd_sht;
//	*((int *) (run_task->tss.esp + 8)) = (int) run_task;
	task_run(run_task, 5);
}

void cmd_help(struct sheet *sht)
{
	ut_printf(sht, "\n");
	ut_printf(sht, "> help         ... this message\n");
	ut_printf(sht, "> cls          ... clear screen\n");
	ut_printf(sht, "> sedit        ... screen editor\n");
	ut_printf(sht, "> asm80386     ... assemble\n");
	ut_printf(sht, "> run          ... program run\n");
	ut_printf(sht, "\n");
}

extern int char_to_sjis[];

void command(struct sheet *sht, struct TASK *task)
{
	char buf[128];
	int i, c;
	
//	cmd_help(sht);
	ut_printf(sht, "Help message is \"help\"\n");
	for(;;){
		ut_printf(sht, "> ");
		
		for(i=0; i<sizeof(buf); i++){
			c = ut_getcA(sht);
			if(c=='\n'){
				ut_printf(sht, "\n");
				buf[i] = 0;
				break;
			}
			else if(c>0 && c<128){
				ut_printf(sht, "%c", c);
				buf[i] = c;
			}
			else{
				i--;
			}
		}
		if(i==sizeof(buf)){
			buf[i-1] = 0;
		}
		
		if(strcmp(buf, "help")==0){
			cmd_help(sht);
		}
		else if(strcmp(buf, "cls")==0){
			clear_screen(sht, *sht->back_color);
			*sht->cur_y = 0;
		}
		else if(strcmp(buf, "sedit")==0){
			sedit_main();
		}
		else if(strcmp(buf, "asm80386")==0){
			if(asm_main()){
//				ut_printf(sht, "*** error\n");
			}
		}
		else if(strcmp(buf, "run")==0){
			command_make_task();
			while(run_task->flags==2){
				c = asm_int_0x40(1, (int)sht, 0);
				if(c==CTL_C){
					disable_interrupt();
					task_remove(run_task, 0);
					enable_interrupt();
					run_task->flags = 0;	/* ”ñŽg—p‚É‚·‚é		*/
					break;
				}
				delay_task(100);
			}
		}
		else if(strcmp(buf, "int40")==0){
			asm_int_0x40(5, (int)sht, 0x1234);
		}
		else{
			ut_printf(sht, "*** error\n");
		}
	}
}
