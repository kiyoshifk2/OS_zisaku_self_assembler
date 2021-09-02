/* �O���t�B�b�N�����֌W */

#include "gonbe.h"
#include "function.h"


void init_palette(void)
{
	static unsigned char table_rgb[] = {
		0x00, 0x00, 0x00,	/*  0:�� */
		0xff, 0x00, 0x00,	/*  1:���邢�� */
		0x00, 0xff, 0x00,	/*  2:���邢�� */
		0xff, 0xff, 0x00,	/*  3:���邢���F */
		0x00, 0x00, 0xff,	/*  4:���邢�� */
		0xff, 0x00, 0xff,	/*  5:���邢�� */
		0x00, 0xff, 0xff,	/*  6:���邢���F */
		0xff, 0xff, 0xff,	/*  7:�� */
		0xc0, 0xc0, 0xc0,	/*  8:���邢�D�F */
		0x80, 0x00, 0x00,	/*  9:�Â��� */
		0x00, 0x80, 0x00,	/* 10:�Â��� */
		0x80, 0x80, 0x00,	/* 11:�Â����F */
		0x00, 0x00, 0x80,	/* 12:�Â��� */
		0x80, 0x00, 0x80,	/* 13:�Â��� */
		0x00, 0x80, 0x80,	/* 14:�Â����F */
		0x80, 0x80, 0x80,	/* 15:�Â��D�F */
		0x20, 0x20, 0x20,	/* 16:�Â��D�F */
		0x40, 0x00, 0x00,	/* 17:�Â��� */
		0x00, 0x40, 0x00,	/* 18:�Â��� */
		0x40, 0x40, 0x00,	/* 19:�Â����F */
		0x00, 0x00, 0x40,	/* 20:�Â��� */
		0x40, 0x00, 0x40,	/* 21:�Â��� */
		0x00, 0x40, 0x40,	/* 22:�Â����F */
		0x40, 0x40, 0x40	/* 23:�Â��D�F */
	};
	set_palette(0, 23, table_rgb);
	return;

	/* static char ���߂́A�f�[�^�ɂ����g���Ȃ�����DB���ߑ��� */
}

void set_palette(int start, int end, unsigned char *rgb)
{
	int i, eflags;
	eflags = io_load_eflags();	/* ���荞�݋��t���O�̒l���L�^���� */
	disable_interrupt(); 		/* ���t���O��0�ɂ��Ċ��荞�݋֎~�ɂ��� */
	io_out8(0x03c8, start);
	for (i = start; i <= end; i++) {
		io_out8(0x03c9, rgb[0] / 4);
		io_out8(0x03c9, rgb[1] / 4);
		io_out8(0x03c9, rgb[2] / 4);
		rgb += 3;
	}
	io_store_eflags(eflags);	/* ���荞�݋��t���O�����ɖ߂� */
	return;
}

void boxfill8(unsigned char *vram, int xsize, unsigned char c, int x0, int y0, int x1, int y1)
{
	int x, y;
	for (y = y0; y <= y1; y++) {
		for (x = x0; x <= x1; x++)
			vram[y * xsize + x] = c;
	}
	return;
}

void init_screen8(unsigned char *vram, int x, int y, int waku_color, int main_back_color, int sub_back_color)
{
	boxfill8(vram, x, main_back_color,    0,     0,   x-1,   y-1);
	boxfill8(vram, x, sub_back_color,     0,  y-22,   x-1,   y-1);
	
	boxfill8(vram, x, waku_color,         0,  y-22,   x-1,  y-22);
	boxfill8(vram, x, waku_color,         0,     0,   x-1,     0);
	boxfill8(vram, x, waku_color,         0,     0,     0,   y-1);
	boxfill8(vram, x, waku_color,      x-1 ,     0,   x-1,   y-1);
	boxfill8(vram, x, waku_color,         0,   y-1,   x-1,   y-1);
	
	return;
}

#if 0
void putfont8(char *vram, int xsize, int x, int y, char c, char *font)
{
	int i;
	char *p, d /* data */;
	for (i = 0; i < 16; i++) {
		p = vram + (y + i) * xsize + x;
		d = font[i];
		if ((d & 0x80) != 0) { p[0] = c; }
		if ((d & 0x40) != 0) { p[1] = c; }
		if ((d & 0x20) != 0) { p[2] = c; }
		if ((d & 0x10) != 0) { p[3] = c; }
		if ((d & 0x08) != 0) { p[4] = c; }
		if ((d & 0x04) != 0) { p[5] = c; }
		if ((d & 0x02) != 0) { p[6] = c; }
		if ((d & 0x01) != 0) { p[7] = c; }
	}
	return;
}
#endif

#if 0
void putfonts8_asc(char *vram, int xsize, int x, int y, char c, unsigned char *s)
{
	extern char hankaku[4096];
	for (; *s != 0x00; s++) {
		putfont8(vram, xsize, x, y, c, hankaku + *s * 16);
		x += 8;
	}
	return;
}
#endif

#if 0
void init_mouse_cursor8(char *mouse, char bc)
/* �}�E�X�J�[�\���������i16x16�j */
{
	static char cursor[16][16] = {
		"**************..",
		"*OOOOOOOOOOO*...",
		"*OOOOOOOOOO*....",
		"*OOOOOOOOO*.....",
		"*OOOOOOOO*......",
		"*OOOOOOO*.......",
		"*OOOOOOO*.......",
		"*OOOOOOOO*......",
		"*OOOO**OOO*.....",
		"*OOO*..*OOO*....",
		"*OO*....*OOO*...",
		"*O*......*OOO*..",
		"**........*OOO*.",
		"*..........*OOO*",
		"............*OO*",
		".............***"
	};
	int x, y;

	for (y = 0; y < 16; y++) {
		for (x = 0; x < 16; x++) {
			if (cursor[y][x] == '*') {
				mouse[y * 16 + x] = COL8_000000;
			}
			if (cursor[y][x] == 'O') {
				mouse[y * 16 + x] = COL8_FFFFFF;
			}
			if (cursor[y][x] == '.') {
				mouse[y * 16 + x] = bc;
			}
		}
	}
	return;
}
#endif

#if 0
void putblock8_8(char *vram, int vxsize, int pxsize,
	int pysize, int px0, int py0, char *buf, int bxsize)
{
	int x, y;
	for (y = 0; y < pysize; y++) {
		for (x = 0; x < pxsize; x++) {
			vram[(py0 + y) * vxsize + (px0 + x)] = buf[y * bxsize + x];
		}
	}
	return;
}
#endif
