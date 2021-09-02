#include "gonbe.h"
#include "function.h"



int char_to_sjis[]={		/* 半角から全角への変換 */
0x1,0xa,0x29,0x54,0x50,0x53,0x55,0x27,0x2a,0x2b,0x56,0x3c,0x4,0x1c,0x5,0x1f,
0xcc,0xcd,0xce,0xcf,0xd0,0xd1,0xd2,0xd3,0xd4,0xd5,0x7,0x8,0x43,0x41,0x44,0x9,
0x57,0xdd,0xde,0xdf,0xe0,0xe1,0xe2,0xe3,0xe4,0xe5,0xe6,0xe7,0xe8,0xe9,0xea,0xeb,
0xec,0xed,0xee,0xef,0xf0,0xf1,0xf2,0xf3,0xf4,0xf5,0xf6,0x2e,0x4f,0x2f,0x10,0x12,
0x26,0xfd,0xfe,0xff,0x100,0x101,0x102,0x103,0x104,0x105,0x106,0x107,0x108,0x109,0x10a,0x10b,
0x10c,0x10d,0x10e,0x10f,0x110,0x111,0x112,0x113,0x114,0x115,0x116,0x30,0x23,0x31,0x21,0x3e,
};


/********************************************************************************/
/*	dispinit								*/
/********************************************************************************/
void dispinit()
{
//	cur_x = 0;
//	cur_y = 0;
//	text_color = COL8_FFFFFF;
//	back_color = 0;
//	last_cur_x = binfo->scrnx / 6;
//	last_cur_y = binfo->scrny / 16;
//	rev_flag = 0;
}
/********************************************************************************/
/*		sjis_parse																*/
/*		文字列から１文字（1/2 バイトコード）取り出し							*/
/*		return: キャラゼネコード												*/
/********************************************************************************/
int sjis_parse(const char *str, int *byte)
{
	int c, ku, ten;
	
	c = *str & 0xff;
	if(c>=0x81 && c<=0x9f){
		ku = (c - 0x81)*2 + 1;				// 1～62
	}
	else if(c>=0xe0 && c<=0xef){			// 63～94
		ku = (c - 0xe0)*2 + 63;
	}
	else{
		*byte = 1;							// 1 バイトコード/
		return c;
	}
	
	c = str[1] & 0xff;
	if(c>=0x40 && c<=0x7e){					// 1～63
		ten = c - 0x40 + 1;
	}
	else if(c>=0x80 && c<=0x9e){			// 64～94
		ten = c - 0x80 + 64;
	}
	else if(c>=0x9f && c<=0xfc){			// 1～94
		ku++;
		ten = c - 0x9f + 1;
	}
	else{									// 1 バイトコード  エラー/
		*byte = 1;
		return c;
	}
	
    *byte = 2;
	return (ku-1)*94 + ten /* - 1 */;
}
/********************************************************************************/
/*		sjis_strlen																*/
/********************************************************************************/
int sjis_strlen(const char *str)
{
	int i, byte;
	
	for(i=0; ; ){
		if(sjis_parse(str, &byte)==0)
			return i;
		i++;
		str += byte;
	}
}
/********************************************************************************/
/*	dispchar								*/
/*	半角文字表示								*/
/*	rev_flag: 1なら text_color と back_color を入れ替える			*/
/********************************************************************************/

void disp_sjis(struct sheet *sht, int x, int y, int c)
{
	int i, bit, x1, y1, c1;
	int eflags = io_load_eflags();
	
	disable_interrupt();
//	for(i=0; i<12*16; i++){
	for(y1=0; y1<16; y1++){
		for(x1=0; x1<12; x1++){
			i = (y1-1)*12 + x1;
			bit = 0x80 >> (i%8);
			c1 = KanjiFont12b[c][i/8];
			if(y1>=1 && y1<13 && (c1 & bit)){	// CG のビットが立っていて範囲内/
				pset(sht, x+x1, y+y1, *sht->rev_flag==0 ? *sht->text_color : *sht->back_color);
			}
			else{
				pset(sht, x+x1, y+y1, *sht->rev_flag==0 ? *sht->back_color : *sht->text_color);
			}
		}
	}
	io_store_eflags(eflags);
}

void disp_char(struct sheet *sht, int x, int y, char *str)
{
	int byte, c;
	
	c = sjis_parse(str, &byte);
	if(byte==1){
		c = char_to_sjis[*str-0x20];
	}
	disp_sjis(sht, x, y, c);
}

/********************************************************************************/

//	char cur_x
//	char cur_y
//	char cur_data: カーソル置き換えデータ/

//	カーソル位置に元のグラフィックデータを書き込む/
void clear_cur(struct sheet *sht)
{
	int i, x, y;
	
return;
	x = *sht->cur_x * 12;
	y = *sht->cur_y * 16 + 15;
	for(i=0; i<6; i++){
		pset(sht, x++, y, sht->cur_data[i]);
	}
}

//	カーソル位置のグラフィックデータを読み取る/
void read_cur(struct sheet *sht)
{
	int i, x, y;
	
return;
	x = *sht->cur_x * 12;
	y = *sht->cur_y * 16 + 15;
	for(i=0; i<6; i++){
		sht->cur_data[i] = pget(sht, x++, y);
	}
}

void disp_cur(struct sheet *sht)
{
	int i, x, y;
	
return;
	x = *sht->cur_x * 12;
	y = *sht->cur_y * 16 + 15;
	for(i=0; i<6; i++){
		pset(sht, x++, y, *sht->text_color);
	}
}

void disp_U(struct sheet *sht)
{
	clear_cur(sht);
	--*sht->cur_y;
	if(*sht->cur_y < 0){
		*sht->cur_y = 0;
	}
	read_cur(sht);
	disp_cur(sht);
}

void disp_D(struct sheet *sht)
{
	int x, y;
	
	clear_cur(sht);
	++ *sht->cur_y;
	if(*sht->cur_y >= sht->last_cur_y){
		*sht->cur_y = sht->last_cur_y - 1;
		for(y=16; y<sht->bysize1; y++){		// スクロール/
			for(x=0; x<sht->bxsize1; x++){
				pset(sht, x,y-16, pget(sht, x,y));
			}
		}
		for(y-=16; y<sht->bysize1; y++){	// 最下行クリア/
			for(x=0; x<sht->bxsize1; x++){
				pset(sht, x,y, *sht->back_color);
			}
		}
	}
	read_cur(sht);
	disp_cur(sht);
}

void disp_R(struct sheet *sht)
{
	clear_cur(sht);
	++*sht->cur_x;
	if(*sht->cur_x >= sht->last_cur_x){
		*sht->cur_x = 0;
		read_cur(sht);
		disp_D(sht);
		return;
	}
	read_cur(sht);
	disp_cur(sht);
}

void disp_L(struct sheet *sht)
{
	clear_cur(sht);
	--*sht->cur_x;
	if(*sht->cur_x < 0){
		*sht->cur_x = sht->last_cur_x - 1;
		read_cur(sht);
		disp_U(sht);
		return;
	}
	read_cur(sht);
	disp_cur(sht);
}

//	半角専用
void ut_putc(struct sheet *sht, unsigned char c)
{
	int x, y;
	int eflags = io_load_eflags();
	
	disable_interrupt();
	x = *sht->cur_x * 12;
	y = *sht->cur_y * 16;
	if(c<0x20){
		if(c=='\n'){
			clear_cur(sht);
			*sht->cur_x = 0;
			read_cur(sht);
			disp_D(sht);
			io_store_eflags(eflags);
			return;
		}
		else if(c=='\t'){					// 4文字毎のタブ/
			ut_putc(sht, ' ');
			while(*sht->cur_x & 0x03){
				ut_putc(sht, ' ');
			}
		}
		else if(c=='\b'){
			disp_L(sht);
		}
	}
	else{
//		dispchar(sht, x, y, c);
		disp_sjis(sht, x, y, char_to_sjis[c-0x20]);
		disp_R(sht);
	}
	io_store_eflags(eflags);
}

//	全角　半角混在
void ut_puts(struct sheet *sht, const char *str)
{
	int byte, c, x, y;
	int eflags = io_load_eflags();
	
	disable_interrupt();
	for(;;){
		c = sjis_parse(str, &byte);
		if(c==0){
			io_store_eflags(eflags);
			return;
		}
		if(byte==1){
			if(c>=0x20 && c<0x80){
				c = char_to_sjis[c-0x20];
				goto sjis;
			}
			ut_putc(sht, c);
			str++;
		}
		else{
sjis:;
			if(*sht->cur_x <= sht->last_cur_x - 2){
				x = *sht->cur_x * 12;
				y = *sht->cur_y * 16;
				disp_sjis(sht, x, y, c);
			}
			else{
				ut_putc(sht, '\n');
				x = *sht->cur_x * 12;
				y = *sht->cur_y * 16;
				disp_sjis(sht, x, y, c);
			}
			disp_R(sht);
			str += byte;
		}
	}
	
//	while(*str) disp_1char(*str++);
}

#if 0
void ut_printf(const char *fmt, ...)
{
	char buf[256];
	va_list ap;

	va_start(ap, fmt);
	vsprintf(buf, fmt, ap);
	va_end(ap);
	
    disp_str(buf);
}
#endif

void cursor_set(struct sheet *sht, int x, int y)
{
	clear_cur(sht);
	if(x<0)
		x = 0;
	if(x>=sht->last_cur_x)
		x = sht->last_cur_x - 1;
	if(y<0)
		y = 0;
	if(y>=sht->last_cur_y)
		y = sht->last_cur_y - 1;
	*sht->cur_x = x;
	*sht->cur_y = y;
	read_cur(sht);
	disp_cur(sht);
}
/********************************************************************************/
/*	pset									*/
/********************************************************************************/
void pset(struct sheet *sht, int x, int y, int color)
{
//	if(x<0 || x>=binfo->scrnx || y<0 || y>=binfo->scrny)
//		return;
//	binfo->vram[y * binfo->scrnx + x] = color;

	if(x<0 || x>=sht->bxsize1 || y<0 || y>=sht->bysize1)
		return;
	sht->buf[(y+sht->by1) * sht->bxsize + (x+sht->bx1)] = color;
	
	x += sht->vx0 + sht->bx1;
	y += sht->vy0 + sht->by1;
	if(shtctl->map[shtctl->xsize * y + x] == sht->sheet_numb){
		binfo->vram[y * binfo->scrnx + x] = color;
	}
}

int pget(struct sheet *sht, int x, int y)
{
//	if(x<0 || x>=binfo->scrnx || y<0 || y>=binfo->scrny)
//		return 0;
//	return binfo->vram[y * binfo->scrnx + x];

	if(x<0 || x>=sht->bxsize1 || y<0 || y>=sht->bysize1)
		return 0;
	return sht->buf[(y+sht->by1) * sht->bxsize + (x+sht->bx1)];
}
//*******************************************************************************

int ut_strlen(char *str)
{
	int i;
	
	i = 0;
	while(*str){
		i++;
		str++;
	}
	return i;
}

void sprintf_1x(char **buf, unsigned int d)
{
	d &= 0x0000000f;
	if(d < 10){
		*(*buf)++ = '0' + d;
		**buf = 0;
	}
	else{
		*(*buf)++ = 'A' + d - 10;
		**buf = 0;
	}
}

//void sprintf_x(char **buf, unsigned int d)
//{
//	int i;
//	
//	for(i=0; i<8; i++){
//		sprintf_1x(buf, d>>28);
//		d <<= 4;
//	}
//}

void sprintf_x(char **buf, unsigned int d)
{
	if(d / 16){
		sprintf_x(buf, d/16);
	}
	sprintf_1x(buf, d);
}

void sprintf_u(char **buf, unsigned int d)
{
	if(d / 10){
		sprintf_u(buf, d/10);
	}
	*(*buf)++ = '0' + d%10;
	**buf = 0;
}

void printf_x(struct sheet *sht, unsigned int d)
{
	char buffer[50];
	char *buf = buffer;
	
	sprintf_x(&buf, d);
	ut_puts(sht, buffer);
}

void sprintf_d(char **buf, int d)
{
	if(d<0){
		*(*buf)++ = '-';
		d = -d;
	}
	sprintf_u(buf, d);
}

void printf_u(struct sheet *sht, unsigned int d)
{
	
	if(d / 10){
		printf_u(sht, d / 10);
	}
	ut_putc(sht, '0' + d%10);
}


void printf_d(struct sheet *sht, int d)
{
	if(d < 0){
		ut_putc(sht, '-');
		d = -d;
	}
	printf_u(sht, d);
}

void vsprintf_param(char **p, int *minus_flag, int *zero_flag, int *keta)
{
	*minus_flag = *keta = 0;
	*zero_flag = ' ';
	(*p)++;				// '%' スキップ
	if(**p=='-'){
		*minus_flag = 1;
		(*p)++;
	}
	if(**p=='0'){
		*zero_flag = '0';
		(*p)++;
	}
	while(**p>='0' && **p<='9'){
		*keta = *keta * 10 + **p - '0';
		(*p)++;
	}
}

void vsprintf_pexec(char *buf_save, char **buf, int minus_flag, int zero_flag, int keta)
{
	int i, len;
	
	len = strlen(buf_save);
	if(keta <= len){
		return;
	}
	if(minus_flag){		/* 左詰め */
		for(i=len; i<keta; i++){
			*(*buf)++ = ' ';
		}
		**buf = 0;
	}
	else{			/* 右詰め */
		*buf += keta - len;
		**buf = 0;
		memmove(buf_save + (keta-len), buf_save, len);
		for(i=0; i<keta-len; i++){
			buf_save[i] = zero_flag;
		}
	}
}

void ut_vsprintf(char *buf, char *fmt, va_list ap)
{
	char *p, *sval, *buf_save;
	int ival, minus_flag, zero_flag, keta;
	int eflags = io_load_eflags();
	
	disable_interrupt();
	for(p=fmt; *p; p++){
		if(*p != '%'){
			*buf++ = *p;
			continue;
		}
		vsprintf_param(&p, &minus_flag, &zero_flag, &keta);
		switch(*p){
			case 'c':
				ival = va_arg(ap, int);
				buf_save = buf;
				*buf++ = ival;
				*buf = 0;
				vsprintf_pexec(buf_save, &buf, minus_flag, zero_flag, keta);
				break;
			case 's':
				sval = va_arg(ap, char *);
				buf_save = buf;
				while(*sval){
					*buf++ = *sval++;
				}
				*buf = 0;
				vsprintf_pexec(buf_save, &buf, minus_flag, zero_flag, keta);
				break;
			case 'd':
				ival = va_arg(ap, int);
				buf_save = buf;
				sprintf_d(&buf, ival);
				vsprintf_pexec(buf_save, &buf, minus_flag, zero_flag, keta);
				break;
			case 'u':
				ival = va_arg(ap, unsigned int);
				buf_save = buf;
				sprintf_u(&buf, ival);
				vsprintf_pexec(buf_save, &buf, minus_flag, zero_flag, keta);
				break;
			case 'x':
				ival = va_arg(ap, unsigned int);
				buf_save = buf;
				sprintf_x(&buf, ival);
				vsprintf_pexec(buf_save, &buf, minus_flag, zero_flag, keta);
				break;
			default:
				*buf++ = '%';
				*buf++ = *p;
				break;
		}
	}
	*buf = 0;
	io_store_eflags(eflags);
}

void ut_printf(struct sheet *sht, char *fmt, ...)
{
	va_list ap;
	char buf[1024];
	int eflags = io_load_eflags();
	
	disable_interrupt();
	va_start(ap, fmt);
	ut_vsprintf(buf, fmt, ap);
	va_end(ap);
	ut_puts(sht, buf);
	io_store_eflags(eflags);
}

void dot(int color)
{
	static int x = 1;
	static int y = 1;
	int i;
	
	binfo->vram[binfo->scrnx * (y+0) + (x+0)] = color;
	binfo->vram[binfo->scrnx * (y+0) + (x+1)] = color;
	binfo->vram[binfo->scrnx * (y+0) + (x+2)] = color;
	
	binfo->vram[binfo->scrnx * (y+1) + (x+0)] = color;
	binfo->vram[binfo->scrnx * (y+1) + (x+1)] = color;
	binfo->vram[binfo->scrnx * (y+1) + (x+2)] = color;
	
	binfo->vram[binfo->scrnx * (y+2) + (x+0)] = color;
	binfo->vram[binfo->scrnx * (y+2) + (x+1)] = color;
	binfo->vram[binfo->scrnx * (y+2) + (x+2)] = color;
	
	x += 4;
	if(x>=binfo->scrnx){
		x = 1;
		y += 4;
		if(y>=binfo->scrny){
			y = 1;
			for(i=0; i<binfo->scrnx * binfo->scrny; i++){
				binfo->vram[i] = COL8_FFFFFF;
			}
		}
	}
}

void fatal_a(char *fmt, ...)
{
	va_list ap;
	char buf[1024];
	int i;
	
	disable_interrupt();
	if(main_sheet){
		va_start(ap, fmt);
		ut_vsprintf(buf, fmt, ap);
		va_end(ap);
		select_main_disp(main_sheet);
		*main_sheet->back_color = COL8_FFFFFF;
		*main_sheet->text_color = COL8_FF0000;
		ut_puts(main_sheet, buf);
		for(i=0; i<binfo->scrny*binfo->scrnx; i++){
			binfo->vram[i] = main_sheet->buf[i];
		}
	}
	for(;;){
		disable_interrupt();
		gonbe_hlt();
	}
}


void clear_screen(struct sheet *sht, char color)
{
	int x, y;
	
	for(y=0; y<sht->bysize1; y++){
		for(x=0; x<sht->bxsize1; x++){
			pset(sht, x, y, color);
		}
	}
}
