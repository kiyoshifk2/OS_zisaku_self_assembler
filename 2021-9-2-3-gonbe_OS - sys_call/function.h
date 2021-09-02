//	asm_lib.nasm
void asm_inthandler20();
void asm_syscall40();
int asm_int_0x40(int ebx, int ecx, int edx);
void disable_interrupt();
void enable_interrupt();
void farjmp(int eip, int cs);
void gonbe_hlt();
int io_load_eflags(void);
void io_out8(int port, int data);
void io_store_eflags(int eflags);
int  key_input();
int  load_cr0();
void load_tr(int tr);
void store_cr0(int cr0);
void load_gdtr(int limit, int addr);
void load_idtr(int limit, int addr);
int ut_longjmp(int env);
int ut_setjmp(int *env);

//	delay_task.c
void delay_task(unsigned int msec);
//void delay_timer();

//	fifo.c
void fifo32_init(struct fifo32 *fifo, int size, int *buf, struct TASK *task);
int fifo32_put(struct fifo32 *fifo, int data);
int fifo32_get(struct fifo32 *fifo);
int fifo32_status(struct fifo32 *fifo);

//	gdt-tble-set.c
void init_gdtidt(void);
void set_gatedesc(struct GATE_DESCRIPTOR *gd, int offset, int selector, int ar);
void set_segmdesc(struct SEGMENT_DESCRIPTOR *sd, unsigned int limit, int base, int ar);

//	graphic.c
void boxfill8(unsigned char *vram, int xsize, unsigned char c, int x0, int y0, int x1, int y1);
void init_palette(void);
void init_screen8(unsigned char *vram, int x, int y, int waku_color, int main_back_color, int sub_back_color);
void set_palette(int start, int end, unsigned char *rgb);

//	lib.c
void bss_clear();
void lib_init();
int memcheck(unsigned int start, unsigned int end);
unsigned int memman_alloc(unsigned int size);
void memman_free(unsigned int addr, unsigned int size);
void memman_init(struct memman *man, unsigned int start_addr, unsigned int mbyte);
void printf_u(struct sheet *sht, unsigned int d);
void printf_d(struct sheet *sht, int d);
void printf_x(struct sheet *sht, unsigned int d);
struct sheet *sheet_alloc(int xsize, int ysize, int col_inv);
void sheet_free(struct sheet *sht);
void sheet_refresh();
void sheet_refreshmap();
void sheet_refreshsub(struct sheet *sht);
void sheet_resize(struct sheet *sht, int xsize, int ysize);
void test_speed(struct sheet *sht);
void sheet_slide(struct sheet *sht, int vx0, int vy0);
void sheet_top_disp();
void sheet_updown(struct sheet *sht, int height);
void shtctl_init();
struct sheet *test_mado();
void ut_gets(struct sheet *sht, char *buf, int len);
int ut_getc(struct sheet *sht);
int ut_getcA(struct sheet *sht);
void ut_printf(struct sheet *sht, char *fmt, ...);
int ut_strlen(char *str);
void ut_vsprintf(char *buf, char *fmt, va_list ap);

//	make_thread.c
void make_sheet_and_thread(struct TASK **task, struct sheet **sht, int xsize, int ysize, int stk_size, int start_addr, int level);

//	sjis.c
void clear_cur(struct sheet *sht);
void dot(int color);
void fatal_a(char *fmt, ...);
void fatal(void);
void cursor_set(struct sheet *sht, int x, int y);
void disp_cur(struct sheet *sht);
void disp_D(struct sheet *sht);
void disp_L(struct sheet *sht);
void disp_R(struct sheet *sht);
void disp_sjis(struct sheet *sht, int x, int y, int c);
void disp_U(struct sheet *sht);
//void dispchar(struct sheet *sht, int x, int y, int c);
void disp_char(struct sheet *sht, int x, int y, char *str);
void dispinit();
void dispstr(struct sheet *sht, int x, int y, const char * str);
void pset(struct sheet *sht, int x, int y, int color);
int pget(struct sheet *sht, int x, int y);
void read_cur(struct sheet *sht);
void select_main_disp(struct sheet *sht);
void select_sub_disp(struct sheet *sht);
int sjis_parse(const char *str, int *byte);
int sjis_strlen(const char *str);
void ut_putc(struct sheet *sht, unsigned char c);
void ut_puts(struct sheet *sht, const char *str);
void clear_screen(struct sheet *sht, char color);

//	string.c
int atoi(const char *str);
int memcmp(const void *dst, const void *src, unsigned int size);
void *memcpy(void *dst, const void *src, unsigned int size);
void *memset(void *dst, int data, unsigned int size);
void *memmove(void *dst, const void *src, unsigned int cnt);
char *strcat(char *dst, char *src);
int strcmp(char *dst, char *src);
char *strcpy(char *dst, char *src);
char *strchr(const char *str, int c);
char *strrchr(const char *str, int c);
int strlen(char *str);

//	timer.c / mtask.c
unsigned int GetTickCount();
void init_pic(void);
void init_pit(void);
void inthandler20(int *esp);
int set_oneshot_timer(struct fifo32 *fifo, unsigned int msec);
int set_repeat_timer(struct fifo32 *fifo, unsigned int msec);
void timer_key();
struct TASK *task_now(void);
void task_add(struct TASK *task);
int task_remove(struct TASK *task, int eflags);
void task_switchsub(void);
struct TASK *task_init();
struct TASK *task_alloc(void);
void task_run(struct TASK *task, int level);
void task_sleep(struct TASK *task);
void task_switch(void);

//	sys_call.c
int syscall40(int ebx, int ecx, int edx);
