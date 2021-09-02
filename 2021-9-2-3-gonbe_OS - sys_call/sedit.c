#include "gonbe.h"
#include "function.h"


#define BUF_LEN				(1024*1024)
#define MAX_SYMBUF_LEN			64
#define X_MAX				448				// 画面ドット数
#define Y_MAX				320
#define X_SIZE				74				// 半角文字数
#define Y_SIZE				20				// ライン数


char *sed_buf;
//static char filename[MAX_SYMBUF_LEN];
static int no_of_line;						// 行数（'\n' の数）
static int buf_len;							// sed_buf に入っているテキストバイト数
static int xpos;							// 現在位置(バイト数)  0～
static int ypos;							// 現在行番号（０から始まる）
static int s_xpos;							// 画面先頭の xpos
static int s_ypos;							// 画面先頭の現在行番号（０から始まる）


extern struct sheet *cmd_sht;


static int sed_disp_1_char(int *xpos, int ypos, char *str);


/********************************************************************************/
/*		get_line_top															*/
/********************************************************************************/
 static int get_line_top(int ptr)
{
	if(ptr==0)
		return 0;
	while(--ptr){
		if(sed_buf[ptr]=='\n'){
			return ptr+1;
		}
	}
	return 0;
}
/********************************************************************************/
/*		disp_cursor																*/
/********************************************************************************/
static void disp_cursor(int color)
{
	int xbit, ybit, x;
	
	xbit = (xpos - s_xpos)*12;
	ybit = (ypos - s_ypos)*16 + 15;
	for(x=0; x<12; x++){
		pset(cmd_sht, xbit+x, ybit, color);
	}
}
/********************************************************************************/
/*		search_line																*/
/*		ypos で行番号（０から始まる）を指定して先頭位置を返す					*/
/********************************************************************************/
static int search_line(int ypos)
{
	int ptr, line;
	char *pt;
	
	ptr = 0;
	for(line=0; line<ypos; ){
		pt = strchr(&sed_buf[ptr], '\n');
		if(pt==0){							// ファイル末端に達した
			return ptr;
		}
		line++;								// 次の行に移る
		ptr = (pt-sed_buf)+1;
	}
	return ptr;
}
/********************************************************************************/
/*		cursor_to_ptr															*/
/********************************************************************************/
static int cursor_to_ptr()
{
	int ptr, xp, ret;
	
	ptr = search_line(ypos);				// 行の先端にする
	xp = 0;
	while(xp < xpos){
		ret = sed_disp_1_char(&xp, ypos, &sed_buf[ptr]);
		if(ret < 100){
			ptr += ret;
		}
		else if(ret==100){					// ファイル末端
			return ptr;
		}
		else if(ret==101){					// '\n'
			return ptr;
		}
	}
	return ptr;
}

static void ptr_to_cursor(int ptr)
{
	int p, xp, ret;
	char *pt, *tmp;
	
	p = 0;
	pt = sed_buf;
	xpos = 0;
	ypos = 0;
	for(;;){
		if(ptr <= p){
			return;
		}
		tmp = strchr(pt, '\n');
		if(tmp==0){
			break;
		}
		if((tmp+1)-sed_buf > ptr){
			break;
		}
		ypos++;
		pt = tmp+1;
	}
	//	pt は行頭
	//	pt<=ptr での最大の pt の位置で xpos/ypos をセットする
	xp = 0;
	for(;;){
		xpos = xp;
		ret = sed_disp_1_char(&xp, ypos, pt);
		if(ret < 100){
			pt += ret;
		}
		else if(ret==100){					// ファイル末端
			return;
		}
		else if(ret==101){					// '\n'
			return;
		}
		if((pt-sed_buf) > ptr){
			return;
		}
	}
}
/********************************************************************************/
/*		sed_disp_1_char															*/
/********************************************************************************/
static int sed_disp_1_char(int *xpos, int ypos, char *str)
{
	int byte, c, cnt, xbit, ybit, x, y;
	
	xbit = (*xpos- s_xpos)*12;
	ybit = (ypos - s_ypos)*16;
	c = sjis_parse(str, &byte);
	if(c=='\0'){
		return 100;							// ファイル末端
	}
	if(byte==1){
		for(y=0; y<16; y++){
			for(x=0; x<6; x++){
				if(*cmd_sht->rev_flag==0){
					pset(cmd_sht, xbit+x, ybit+y, *cmd_sht->back_color);	// 背景塗りつぶし
				}
				else{
					pset(cmd_sht, xbit+x, ybit+y, *cmd_sht->text_color);
				}
			}
		}
		if(c=='\t'){
			cnt = 0;
			do{
				cnt++;
				(*xpos)++;
				xbit += 12;
			}
			while(*xpos & 3);
			return 1;						// 表示文字数１
		}
		else if(c=='\n'){
			disp_char(cmd_sht, xbit, ybit+4, "↓");
			(*xpos)++;
			return 101;						// 行末
		}
		else{
			disp_char(cmd_sht, xbit, ybit+4, str);
			(*xpos)++;
			return 1;						// 表示文字数１
		}
	}
	else{
		disp_char(cmd_sht, xbit, ybit, str);
		*xpos += 2;
		return 2;							// 表示文字数２
	}
}
/********************************************************************************/
/*		sed_disp_1_line															*/
/*		１行表示																*/
/*		ypos: 行番号（０から始まる）											*/
/********************************************************************************/
static void sed_disp_1_line(int ypos, char *str)
{
	int xp, ret;
	
	xp = 0;
	for(;;){
		ret = sed_disp_1_char(&xp, ypos, str);
		if(ret < 100){
			str += ret;
		}
		else{
			return;
		}
	}
}
/********************************************************************************/
/*		sed_display																*/
/********************************************************************************/
static void sed_display()
{
	int i, pos;
	char *pt;
	
//	memset(video, 0, sizeof(video));
	clear_screen(cmd_sht, COL8_FFFFFF);
	pos = search_line(s_ypos);				// first line
	if(pos < 0)								// EOF
		return;
	pt = &sed_buf[pos];
	for(i=0; i<Y_SIZE; i++){
		sed_disp_1_line(s_ypos+i, pt);
		pt = strchr(pt, '\n');
		if(pt==0){
			return;							// EOF
		}
		pt++;
	}
}
/********************************************************************************/
/*		redraw																	*/
/*		現在行再描画															*/
/********************************************************************************/
static void redraw()
{
	int i, ptr, x, y;
	
	y = ypos - s_ypos;
	if(y<0 || y>=Y_SIZE)
		return;
//	for(i=0; i<16; i++){
//		memset(video[y*16+i], 0, sizeof(video[y*16+i]));
//	}
	for(i=0; i<16; i++){
		for(x=0; x<binfo->scrnx; x++){
			pset(cmd_sht, x, y*16+i, COL8_FFFFFF);
		}
	}
	ptr = get_line_top(cursor_to_ptr());
	sed_disp_1_line(ypos, &sed_buf[ptr]);
}
/********************************************************************************/
/*		sed_init																*/
/********************************************************************************/
static void sed_init()
{
	memset(sed_buf, 0, BUF_LEN);
	no_of_line = 0;
	buf_len = 0;
	xpos = 0;
	ypos = 0;
	s_xpos = 0;
	s_ypos = 0;
}
/********************************************************************************/
/*		sed_help																	*/
/********************************************************************************/
static void sed_help()
{
	ut_printf(cmd_sht, "\n");
	ut_printf(cmd_sht, "F1        ... ヘルプメッセージ\n");
	ut_printf(cmd_sht, "F2        ... 現在行削除\n");
//	ut_printf(cmd_sht, "F3        ... ファイルへの書き込み\n");
//	ut_printf(cmd_sht, "F4        ... ファイル名を指定して書き込み\n");
	ut_printf(cmd_sht, "F5        ... プログラム終了\n");
	ut_printf(cmd_sht, "F6        ... 指定行番号へ飛ぶ\n");
	ut_printf(cmd_sht, "\n");
	ut_printf(cmd_sht, "---   push any key   ---");
	ut_getcA(cmd_sht);
	ut_printf(cmd_sht, "\n");
}
/********************************************************************************/
/*		sed_exit																*/
/********************************************************************************/
static int sed_exit()
{
	int c;
	
//	memset(video, 0, sizeof(video));
	clear_screen(cmd_sht, COL8_FFFFFF);
	ut_printf(cmd_sht, "\n終了しますか(y/n) ? ");
	c = ut_getc(cmd_sht);
	if(c=='y' || c=='Y'){
        ut_printf(cmd_sht, "\n");
		return 0;							// 終了
    }
	sed_display();
	return 1;								// 取り消し
}
/********************************************************************************/
/*		sed_write_name															*/
/*		ファイル名を指定して書き込み											*/
/********************************************************************************/
//static void sed_write_name()
//{
//}
/********************************************************************************/
/*		sed_write_exit															*/
/********************************************************************************/
//static void sed_write()
//{
//}
/********************************************************************************/
/*		sed_jump																*/
/*		指定行番号へ飛ぶ														*/
/********************************************************************************/
void sed_jump()
{
	char buf[MAX_SYMBUF_LEN];
	
//	memset(video, 0, sizeof(video));
	clear_screen(cmd_sht, COL8_FFFFFF);
	ut_printf(cmd_sht, "\n行番号：");
	ut_gets(cmd_sht, buf, MAX_SYMBUF_LEN);
	ypos = atoi(buf) - 1;
	xpos = 0;
	if(ypos<0){
		ypos = 0;
	}
	else if(ypos > no_of_line){
		ypos = no_of_line;
	}
	s_xpos = 0;
	s_ypos = ypos - 10;
	if(s_ypos >= no_of_line-1){
		s_ypos = no_of_line - 1;
	}
	if(s_ypos<0){
		s_ypos = 0;
	}
	
	sed_display();
}
/********************************************************************************/
/*		sed_UP																	*/
/********************************************************************************/
static void sed_UP()
{
	if(ypos==0)
		return;
	if(s_ypos > ypos-1){
		ypos--;
		s_ypos = ypos;
		sed_display();
	}
	else{
		ypos--;
	}
	
}

static void sed_DOWN()
{
	if(ypos >= no_of_line)
		return;
	if(s_ypos+Y_SIZE <= ypos+1){
		ypos++;
		s_ypos++;
		sed_display();
	}
	else{
		ypos++;
	}
}

static void sed_RIGHT()
{
	int ptr, byte;
	int flag = 0;
	
	ptr = cursor_to_ptr();					// カーソル位置からバッファ位置を求める
	if(ptr >= buf_len)
		return;
	sjis_parse(&sed_buf[ptr], &byte);
	ptr += byte;
	ptr_to_cursor(ptr);						// バッファ位置からカーソル位置を求める
	if(ypos >= s_ypos+Y_SIZE){
		s_ypos++;
//		sed_display();
		flag = 1;
	}
	if(s_xpos > xpos){
		s_xpos = xpos;
		flag = 1;
	}
	else if(s_xpos+X_SIZE <= xpos){
		s_xpos = xpos-(X_SIZE-1);
		flag = 1;
	}
	if(flag){
		sed_display();
	}
}

static void sed_LEFT()
{
	int ptr, byte;
	int flag = 0;
	
	ptr = cursor_to_ptr();					// カーソル位置からバッファ位置を求める
	if(ptr==0){
		return;
	}
	if(ptr==1){
		ptr = 0;
	}
	else{
		sjis_parse(&sed_buf[ptr-2], &byte);
		ptr -= byte;
	}
	ptr_to_cursor(ptr);						// バッファ位置からカーソル位置を求める
	if(s_ypos > ypos){
		s_ypos = ypos;
//		sed_display();
		flag = 1;
	}
	if(s_xpos > xpos){
		s_xpos = xpos;
		flag = 1;
	}
	else if(s_xpos+X_SIZE <= xpos){
		s_xpos = xpos-(X_SIZE-1);
		flag = 1;
	}
	if(flag){
		sed_display();
	}
}
/********************************************************************************/
/*		sed_PGUP																*/
/********************************************************************************/
#if 0
static void sed_PGUP()
{
	int ytmp;
	
	ytmp = s_ypos-(Y_SIZE-3);
	if(ytmp < 0){
		ytmp = 0;
	}
	ypos -= (s_ypos-ytmp);
	s_ypos = ytmp;
	sed_display();
}
#endif

#if 0
static void sed_PGDN()
{
	int ytmp;
	
	ytmp = s_ypos + (Y_SIZE-3);
	if(ytmp > no_of_line - (Y_SIZE-3)){
		ytmp = no_of_line - (Y_SIZE-3);
	}
	if(ytmp < 0){
		ytmp = 0;
	}
	ypos += (ytmp-s_ypos);
	s_ypos = ytmp;
	sed_display();
}
#endif

#if 0
static void sed_HOME()
{
	int flag = 0;
	
	xpos = 0;

	if(s_xpos > xpos){
		s_xpos = xpos;
		flag = 1;
	}
	else if(s_xpos+X_SIZE <= xpos){
		s_xpos = xpos-(X_SIZE-1);
		flag = 1;
	}
	if(flag){
		sed_display();
	}
}
#endif

#if 0
static void sed_END()
{
	int ptr;
	char *pt;
	int flag = 0;
	
	ptr = cursor_to_ptr();
	pt = strchr(&sed_buf[ptr], '\n');
	if(pt==0){
		ptr = buf_len;
	}
	else{
		ptr = (pt-sed_buf);
	}
	ptr_to_cursor(ptr);

	if(s_xpos > xpos){
		s_xpos = xpos;
		flag = 1;
	}
	else if(s_xpos+X_SIZE <= xpos){
		s_xpos = xpos-(X_SIZE-1);
		flag = 1;
	}
	if(flag){
		sed_display();
	}
}
#endif
/********************************************************************************/
/*		sed_linedel																*/
/********************************************************************************/
static void sed_linedel()
{
	int linetop, nextline;
	char *pt;
	
	linetop = get_line_top(cursor_to_ptr());
	pt = strchr(&sed_buf[linetop], '\n');
	if(pt==0){
		nextline = buf_len;
	}
	else{
		nextline = (pt-sed_buf) + 1;
		no_of_line--;
	}
	memmove(&sed_buf[linetop], &sed_buf[nextline], buf_len-nextline+1);
	buf_len -= nextline-linetop;
	xpos = 0;
	sed_display();
}
/********************************************************************************/
/*		sed_DEL																	*/
/********************************************************************************/
#if 0
static void sed_DEL()
{
	int ptr, byte;
	
	ptr = cursor_to_ptr();
	if(ptr >= buf_len)
		return;
	sjis_parse(&sed_buf[ptr], &byte);
	if(sed_buf[ptr]=='\n'){
		memmove(&sed_buf[ptr], &sed_buf[ptr+1], strlen(&sed_buf[ptr]));
		buf_len--;
		no_of_line--;
		sed_display();
	}
	else{
		memmove(&sed_buf[ptr], &sed_buf[ptr+byte], strlen(&sed_buf[ptr]));
		buf_len -= byte;
		redraw();
	}
}
#endif
/********************************************************************************/
/*		sed_BS																	*/
/********************************************************************************/
static void sed_BS()
{
	int ptr, byte;
	
	ptr = cursor_to_ptr();
	if(ptr==0)
		return;
	if(ptr==1){
		byte = 1;
	}
	else{
		sjis_parse(&sed_buf[ptr-2], &byte);
	}
	if(sed_buf[ptr-1]=='\n'){
		sed_LEFT();
		memmove(&sed_buf[ptr-1], &sed_buf[ptr], strlen(&sed_buf[ptr])+1);
		buf_len--;
		no_of_line--;
		sed_display();
	}
	else{
		memmove(&sed_buf[ptr-byte], &sed_buf[ptr], strlen(&sed_buf[ptr])+1);
		buf_len--;
		redraw();
		sed_LEFT();
	}
}
/********************************************************************************/
/*		sed_txt																	*/
/********************************************************************************/
static void sed_txt(int c)
{
	int ptr;
	
	if(c=='\t' || c=='\n' ||
			(c>=0x20 && c<0x100)){
		ptr = cursor_to_ptr();
		if(buf_len >= BUF_LEN-1){
//			memset(video, 0, sizeof(video));
			clear_screen(cmd_sht, COL8_FFFFFF);
			ut_printf(cmd_sht, "\n*** out of memory\n");
			ut_printf(cmd_sht, "---   push any key   ---\n");
			ut_getcA(cmd_sht);
			sed_display();
			return;
		}
		memmove(&sed_buf[ptr+1], &sed_buf[ptr], buf_len-ptr+1);
		sed_buf[ptr] = c;
		buf_len++;
		if(c=='\n'){
			no_of_line++;
			sed_display();
		}
		else{
			redraw();
		}
		sed_RIGHT();
	}
}
/********************************************************************************/
/*		sedit_main																*/
/********************************************************************************/
void sedit_main()
{
	int c;
	
	if(sed_buf==0){
//		新規ファイル;
		sed_buf = (char*)memman_alloc(BUF_LEN);
		sed_init();
	}
	else{
//		old file
	}
	sed_help();
	sed_display();
	for(;;){
		disp_cursor(COL8_000000);
		c = ut_getcA(cmd_sht);
		disp_cursor(COL8_FFFFFF);
		switch(c){
			case F1:						// sed_help
				clear_screen(cmd_sht, COL8_FFFFFF);
				sed_help();
				sed_display();
				break;
			case F2:						// line del
				sed_linedel();
				break;
//			case F3:						// write
//				sed_write();
//				break;
//			case F4:						// write with file name
//				sed_write_name();
//				break;
			case F5:						// exit
				if(sed_exit()==0)
					return;
				break;
			case F6:						// jump line number
				sed_jump();
				break;
//			case DEL:						// 1 charactor del
//				sed_DEL();
//				break;
			case '\b':						// back space
				sed_BS();
				break;
			case UP:
				sed_UP();
				break;
			case DOWN:
				sed_DOWN();
				break;
			case RIGHT:
				sed_RIGHT();
				break;
			case LEFT:
				sed_LEFT();
				break;
//			case PGUP:
//				sed_PGUP();
//				break;
//			case PGDN:
//				sed_PGDN();
//				break;
//			case HOME:
//				sed_HOME();
//				break;
//			case END:
//				sed_END();
//				break;
			default:
				if(c<128){
					sed_txt(c);
				}
				break;
		}
	}
}
