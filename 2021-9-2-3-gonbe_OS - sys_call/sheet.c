#include "gonbe.h"
#include "function.h"


struct memman memman;
struct shtctl *shtctl;

//------------------------------------------------------------------------------

void memman_init(struct memman *man, unsigned int start_addr, unsigned int mbyte)
{
	man->frees = 1;
	man->free[0].addr = start_addr;
	man->free[0].size = mbyte*(1024*1024) - start_addr;
	man->maxfrees = 0;
}

unsigned int memman_alloc(unsigned int size)
{
	int i, j;
	unsigned int address;
	
	size = (size + (ALLOC_SIZE-1)) & ~(ALLOC_SIZE-1);
	for(i=0; i<memman.frees; i++){
		if(size <= memman.free[i].size){
			address = memman.free[i].addr;
			if(size==memman.free[i].size){	// 空きエリア消滅/
				memman.frees--;
				for(j=i; j<memman.frees; j++){
					memman.free[i] = memman.free[i+1];
				}
				memset((char*)address, 0, size);
				return address;
			}
			memman.free[i].addr += size;
			memman.free[i].size -= size;
			memset((char*)address, 0, size);
			return address;
		}
	}
	fatal_a("*** memory alloc area nothing\n");
//	fatal();
	return 0;
}

void memman_free(unsigned int addr, unsigned int size)
{
	int i, j;
	
	/***	どこに入れるべきか決める	***/
	for(i=0; i<memman.frees; i++){
		if(memman.free[i].addr > addr){
			break;
		}
	}
	
	/***	free[i-1].addr < addr < free[i]	***/
	if(i > 0){			// 前が有る/
		if(memman.free[i-1].addr + memman.free[i-1].size == addr){
			/*	前の空き領域と結合	*/
			memman.free[i-1].size += size;
			if(i < memman.frees){	// 後ろも有る/
				if(addr+size == memman.free[i].addr){
					/*	後ろの領域と結合	*/
					memman.free[i-1].size += memman.free[i].size;
					/*	memman.free[i] の削除	*/
					memman.frees--;
					for(j=i; j<memman.frees; j++){
						memman.free[i] = memman.free[i+1];
					}
				}
			}
			return;
		}
	}
	/***	前とはまとめられなかった	***/
	if(i < memman.frees){		// 後ろが有る/
		if(addr+size == memman.free[i].addr){
			/*	後ろとまとめられる	*/
			memman.free[i].addr = addr;
			memman.free[i].size += size;
			return;
		}
	}
	/***	前にも後ろにもまとめられないから単独の free を作る	***/
	if(memman.frees < MEMMAN_FREES){	// free を作る余裕あり/
		/*	free[i] より後ろを後ろにずらす	*/
		for(j=memman.frees; j; j--){
			memman.free[j] = memman.free[j-1];
		}
		memman.frees++;
		if(memman.maxfrees < memman.frees){
			memman.maxfrees = memman.frees;	// 最大値を更新/
		}
		memman.free[i].addr = addr;
		memman.free[i].size = size;
		return;
	}
	/***	free の空きなし	***/
	fatal_a("*** memory memory alloc table area nothing\n");
//	fatal();
}

//---------------------------------------------------------------------------

void shtctl_init()
{
	struct shtctl *ctl;
	int i;
	
	ctl = (struct shtctl*)memman_alloc(sizeof(struct shtctl));
	ctl->vram = (unsigned char*)binfo->vram;
	ctl->map  = (unsigned short*)memman_alloc(binfo->scrnx * binfo->scrny * sizeof(unsigned short));
//	for(i=0; i<binfo->scrnx * binfo->scrny; i++){
//		ctl->map[i] = 0xffff;
//	}
	ctl->xsize = binfo->scrnx;
	ctl->ysize = binfo->scrny;
	ctl->top = -1;			// シートは１枚もない/
	for(i=0; i<MAX_SHEETS; i++){
		ctl->sheets0[i].flags = 0;	// 未使用マーク/
	}
	shtctl = ctl;
}

//	シートエリアを１枚確保/
struct sheet *sheet_alloc(int xsize, int ysize, int col_inv)
{
	struct sheet *sht;
	int i;
	
	for(i=0; i<MAX_SHEETS; i++){
		if(shtctl->sheets0[i].flags==0){	// 未割当/
			sht = &shtctl->sheets0[i];
			sht->flags = SHEET_USE;		// 使用中マーク/
			sht->sheet_numb = i;
			sht->height = -1;		// 非表示中/
			sht->buf = (unsigned char*)memman_alloc(xsize*ysize);
			sht->bxsize = xsize;
			sht->bysize = ysize;
			sht->col_inv = col_inv;
			sht->shift = 0;

			sht->cur_x_m = 0;
			sht->cur_y_m = 0;
			sht->text_color_m = COL8_000000;
			sht->back_color_m = COL8_FFFFFF;
			sht->rev_flag_m = 0;

			sht->cur_x_s = 0;
			sht->cur_y_s = 0;
			sht->text_color_s = COL8_000000;
			sht->back_color_s = COL8_C0C0C0;
			sht->rev_flag_s = 0;
			
			init_screen8(sht->buf, xsize, ysize, COL8_000000, COL8_FFFFFF, COL8_C0C0C0);
			select_main_disp(sht);
			return sht;
		}
	}
	fatal_a("*** sheet table area nothing\n");
//	fatal();
	return 0;
}

//	シートの変数初期化/
//void sheet_setbuf(struct sheet *sht, unsigned char *buf, int xsize, int ysize, int col_inv)
//{
//	sht->buf = buf;
//	sht->bxsize = xsize;
//	sht->bysize = ysize;
//	sht->col_inv = col_inv;
//}

//	シートの画面位置設定・表示/
void sheet_slide(struct sheet *sht, int vx0, int vy0)
{
	int eflags = io_load_eflags();
	
	if(vx0<0 || vx0+sht->bxsize >shtctl->xsize || vy0<0 || vy0+sht->bysize>shtctl->ysize){
		return;
	}
	disable_interrupt();
	sht->vx0 = vx0;
	sht->vy0 = vy0;
	if(sht->height >= 0){	// このシートが表示中ならば/
		sheet_refresh();	// 全部再表示/
		sheet_refreshmap();
	}
	io_store_eflags(eflags);
}

// sheet の main_disp エリアに描画する設定

void select_main_disp(struct sheet *sht)
{
	int eflags = io_load_eflags();
	
	disable_interrupt();
	sht->bx1 = 1;				// 描画エリアの開始位置/
	sht->by1 = 1;
	sht->bxsize1 = sht->bxsize - 2;		// 描画エリアの幅/
	sht->bysize1 = sht->bysize + (-1-22);

	sht->last_cur_x = sht->bxsize1 / 12;	// １行の文字数/
	sht->last_cur_y = sht->bysize1 / 16;	// １列の行数/
	sht->main_disp_flag = 1;		// main_display/
	
	sht->cur_x = &sht->cur_x_m;
	sht->cur_y = &sht->cur_y_m;
	sht->cur_data = sht->cur_data_m;
	sht->text_color = &sht->text_color_m;
	sht->back_color = &sht->back_color_m;
	sht->rev_flag = &sht->rev_flag_m;
	io_store_eflags(eflags);
}

// sheet の sub_disp エリアに描画する設定

void select_sub_disp(struct sheet *sht)
{
	int eflags = io_load_eflags();
	
	disable_interrupt();
	sht->bx1 = 1;				// 補助描画エリアの開始位置/
	sht->by1 = sht->bysize + (-22+1);
	sht->bxsize1 = sht->bxsize -2;		// 補助描画エリアの幅/
	sht->bysize1 = 20;

	sht->last_cur_x = sht->bxsize1 / 12;	// １行の文字数/
	sht->last_cur_y = sht->bysize1 / 16;	// １列の行数/
	sht->main_disp_flag = 0;		// sub_display/
	
	sht->cur_x = &sht->cur_x_s;
	sht->cur_y = &sht->cur_y_s;
	sht->cur_data = sht->cur_data_s;
	sht->text_color = &sht->text_color_s;
	sht->back_color = &sht->back_color_s;
	sht->rev_flag = &sht->rev_flag_s;
	io_store_eflags(eflags);
}

//	全部のシートを表示する
void sheet_refresh()
{
	int h, bx, by, vx, vy, numb, tmp;
	unsigned char *buf, c, *vram = shtctl->vram;
	struct sheet *sht;
	int eflags = io_load_eflags();
	unsigned short *map = shtctl->map;
	
	disable_interrupt();
	sheet_refreshmap();
	sht = &shtctl->sheets0[0];
	for(vy=0; vy<shtctl->ysize; vy++){
		by =vy-sht->vy0;
		for(vx=0; vx<shtctl->xsize; vx++){
			bx = vx-sht->vx0;
			tmp = vy*shtctl->xsize + vx;
			if(bx<0 || bx>=sht->bxsize || by<0 || by>=sht->bysize){
				vram[tmp] = COL8_FFFFFF;
			}
			else{
				if(map[tmp]==0){
					vram[tmp] = sht->buf[by*sht->bxsize + bx];
				}
			}
		}
	}
//	
//	for(i=0; i<binfo->scrnx*binfo->scrny; i++){
//		if(map[i]==0){
//			binfo->vram[i] = COL8_FFFFFF;
//		}
//	}
	for(h=0; h<=shtctl->top; h++){
		sht = shtctl->sheets[h];
		buf = sht->buf;
		numb = sht->sheet_numb;
		for(by=0; by<sht->bysize; by++){
			vy = sht->vy0 + by;
			for(bx=0; bx<sht->bxsize; bx++){
				vx = sht->vx0 + bx;
				tmp = vy*shtctl->xsize + vx;
				if(numb==map[tmp]){
					c = buf[by*sht->bxsize + bx];
					if(c != sht->col_inv){	// 透明色でなければ描画する/
						vram[tmp] = c;
					}
				}
			}
		}
	}
	sheet_top_disp();		// top sheet を赤枠にする
	io_store_eflags(eflags);
}

//	１枚のシートを表示する/
void sheet_refreshsub(struct sheet *sht)
{
	unsigned char *buf, *vram, c;
	unsigned short *map;
	int bx, by, vx, vy, numb, tmp, top;
	int eflags = io_load_eflags();
	
	if(sht==0){
		return;
	}
	disable_interrupt();
	vram = shtctl->vram;
	buf = sht->buf;
	map = shtctl->map;
	numb = sht->sheet_numb;
	for(by=0; by<sht->bysize; by++){
		vy = sht->vy0 + by;
		for(bx=0; bx<sht->bxsize; bx++){
			vx = sht->vx0 + bx;
			tmp = vy*shtctl->xsize + vx;
			if(numb==map[tmp]){
				c = buf[by*sht->bxsize + bx];
				if(c != sht->col_inv){	// 透明色でなければ描画/
					vram[tmp] = c;
				}
			}
		}
	}
	top = shtctl->top;
	if(top<0){
		io_store_eflags(eflags);
		return;
	}
	if(sht==shtctl->sheets[top]){
		sheet_top_disp();
	}
	io_store_eflags(eflags);
}

//	top の sheet を赤枠にする
void sheet_top_disp()
{
	unsigned char *vram;
	struct sheet *sht;
	int top, x0,y0, x1,y1;
	int eflags = io_load_eflags();
	
	vram = shtctl->vram;
	top = shtctl->top;
	if(top<0){
		return;
	}
	disable_interrupt();
	sht = shtctl->sheets[top];
//	sheet_refreshsub(sht);		// top sheet 表示
	x0 = sht->vx0;
	x1 = sht->vx0+sht->bxsize-1;
	y0 = sht->vy0;
	y1 = sht->vy0+sht->bysize-1;
	boxfill8(vram, shtctl->xsize, COL8_FF0000, x0, y0, x0, y1);
	boxfill8(vram, shtctl->xsize, COL8_FF0000, x0, y0, x1, y0);
	boxfill8(vram, shtctl->xsize, COL8_FF0000, x0, y1, x1, y1);
	boxfill8(vram, shtctl->xsize, COL8_FF0000, x1, y0, x1, y1);
	io_store_eflags(eflags);
}

//	map を作成する/
void sheet_refreshmap()
{
	int i, h, bx, by, vx, vy, numb;
	unsigned short *map;
	struct sheet *sht;
	int eflags = io_load_eflags();
	
	for(i=0; i<binfo->scrnx * binfo->scrny; i++){
		shtctl->map[i] = 0;
	}
	disable_interrupt();
	for(h=0; h<=shtctl->top; h++){
		sht = shtctl->sheets[h];
		map = shtctl->map;
		numb = sht->sheet_numb;
		for(by=0; by<sht->bysize; by++){
			vy = sht->vy0 + by;
			for(bx=0; bx<sht->bxsize; bx++){
				vx = sht->vx0 + bx;
				map[vy*shtctl->xsize + vx] = numb;
			}
		}
	}
	io_store_eflags(eflags);
}

//	シートを開放する
void sheet_free(struct sheet *sht)
{
	int eflags = io_load_eflags();
	
	disable_interrupt();
	if(sht->height >= 0){	// このシートが表示中ならば/
		sheet_updown(sht, -1);	//シートの表示順序を -1 つまり非表示にする/
	}
	sht->flags = 0;	// 未使用/
	memman_free((unsigned int)sht->buf, sht->bxsize * sht->bysize);
	io_store_eflags(eflags);
}

//	シートの表示順序を設定する/
void sheet_updown(struct sheet *sht, int height)
{
	int h, old = sht->height;	// 設定前の表示順序/
	int eflags = io_load_eflags();
	
	disable_interrupt();
	/***	設定値の上下限セット	***/
	if(height > shtctl->top+1){
		height = shtctl->top+1;
	}
	if(height < -1){
		height = -1;
	}
	sht->height = height;		// sheet 位置（高さ）
	
	/***	shtctl->sheets[] の並べ替え	***/
	if(old > height){	// 以前より前になる/
		if(height >= 0){	// 表示ならば/
			/*	間の物を後ろにする	*/
			for(h=old; h>height; h--){
				shtctl->sheets[h] = shtctl->sheets[h-1];
				shtctl->sheets[h]->height = h;
			}
			shtctl->sheets[height] = sht;
		}
		else{		// -1 だから非表示, shtctl->sheets[] から削除する/
			if(shtctl->top > old){	// 以前が最後尾でない場合/
				/*	後ろを１つ前にする	*/
				for(h=old; h<shtctl->top; h++){
					shtctl->sheets[h] = shtctl->sheets[h+1];
					shtctl->sheets[h]->height = h;
				}
			}
			shtctl->top--;	// 表示中のシートが１つ減った/
		}
		sheet_refresh();	// 再表示/
		sheet_refreshmap();
	}
	else if(old < height){		// 以前よりも後ろになる/
		if(old >= 0){		// 表示中ならば/
			/*	間の物を前にする	*/
			for(h=old; h<height; h++){
				shtctl->sheets[h] = shtctl->sheets[h+1];
				shtctl->sheets[h]->height = h;
			}
			shtctl->sheets[height] = sht;
		}
		else{			// 非表示状態から表示状態へ/
			/*	後ろを１つ後ろにする	*/
			for(h=shtctl->top; h>=height; h--){
				shtctl->sheets[h+1] = shtctl->sheets[h];
				shtctl->sheets[h+1]->height = h+1;
			}
			shtctl->sheets[height] = sht;
			shtctl->top++;	// 表示中のシートが１つ増えた/
		}
		sheet_refresh();	// 再表示/
		sheet_refreshmap();
	}
	io_store_eflags(eflags);
}

void sheet_resize(struct sheet *sht, int xsize, int ysize)
{
	int eflags = io_load_eflags();
	
	disable_interrupt();
	if(xsize<20) xsize = 20;
	if(ysize<50) ysize = 50;
	if(xsize+sht->vx0 > shtctl->xsize) xsize = shtctl->xsize - sht->vx0;
	if(ysize+sht->vy0 > shtctl->ysize) ysize = shtctl->ysize - sht->vy0;
	memman_free((unsigned int)sht->buf, sht->bxsize * sht->bysize);
	sht->bxsize = xsize;
	sht->bysize = ysize;
	sht->cur_x_m = sht->cur_y_m = sht->cur_x_s = sht->cur_y_s = 0;
	sht->buf = (unsigned char*)memman_alloc(xsize*ysize);
	init_screen8(sht->buf, xsize, ysize, COL8_000000, COL8_FFFFFF, COL8_C0C0C0);
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
	io_store_eflags(eflags);
}

struct sheet *test_mado()
{
	struct sheet *sht, *sht1;
	unsigned char *buf;
	
	buf = (unsigned char*)memman_alloc(200*200);
	init_screen8(buf, 200, 200, COL8_000000, COL8_FFFFFF, COL8_C0C0C0);
	sht1 = sheet_alloc(200, 200, 0x1234);
//	sheet_setbuf(sht, buf, 200, 200, 0x1234);
	sheet_slide(sht1, 200, 100);
	sheet_updown(sht1, 1000);
	
	buf = (unsigned char*)memman_alloc(300*250);
	init_screen8(buf, 300, 250, COL8_000000, COL8_FFFFFF, COL8_C0C0C0);
	sht = sheet_alloc(300, 250, 0x1234);
//	sheet_setbuf(sht, buf, 300, 250, 0x1234);
	sheet_slide(sht, 250, 150);
	sheet_updown(sht, 1000);
	
	return sht;
}

