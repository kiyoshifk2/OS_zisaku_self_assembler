#define SELF_ASSEMBLER

#ifdef SELF_ASSEMBLER
#include "gonbe.h"
#include "function.h"
#else
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <io.h>
#include <setjmp.h>
#endif


#ifdef SELF_ASSEMBLER
#define printf(...)	ut_printf(cmd_sht, __VA_ARGS__)
#endif


/*
*	obj レコードフォーマット
*	一般      | len | type | data... |      len,type は１バイト
*	type 1: データレコード
*		| len | 1 | addr | data... |
*	type 2: section
*		| len | 2 | section numb |      len=2, section numb 1byte
*/

#define SYM_LEN		64
#define SYM_TBL_LEN	10000
#define SECTION_TBL_LEN	100

#define TYPE1		1	/* 1バイト固定のオペコード */
#define TYPE2		2	/* 2バイト固定のオペコード */
#define TYPE3		3	/* adc	EA, acc imm, EA imm */
#define TYPE4		4	/* call xxxx		*/
#define TYPE5		5	/* dec reg,   dec EA	*/
#define TYPE6		6	/* div EA		*/
#define TYPE7		7	/* int imm		*/
#define TYPE8		8	/* jb addr		*/
#define TYPE9		9	/* mov			*/
#define TYPE10		10	/* pop reg, pop EA	*/
#define TYPE11		11	/* rlc EA,1  rlc EA,cl	*/
#define TYPE12		12	/* ret  ret imm		*/
#define TYPE13		13	/* test ...		*/
#define TYPE14		14	/* xchg al,ch  xchg reg,EA  xchg EA,reg		*/

#define TYPE_REG	200
#define TYPE_SYMBOL	1000	/* lable, equ */
#define TYPE_SECTION	1001
#define TYPE_ORG	1002
#define TYPE_EQU	1003
#define TYPE_DB		1004
#define TYPE_DW		1005
#define TYPE_DD		1006
#define TYPE_B_W_D	1007

struct sym_code{		/* 命令ニーモニックの一覧表 */
	char *symbol;		/* ニーモニック */
	int type;		/* 命令タイプ */
	int value;
};

struct sym_code a_sym_code[]={
	{"aaa", TYPE1, 0x37},
	{"aad", TYPE2, 0x0ad5},
	{"aam", TYPE2, 0x0ad4},
	{"aas", TYPE1, 0x3f},
	{"adc", TYPE3, 0x10801410},
	{"add", TYPE3, 0x00800400},
	{"and", TYPE3, 0x20802420},
	{"call", TYPE4, 0x9ae8},
	{"cbw", TYPE2, 0x9866},
	{"cmp", TYPE3, 0x38803c38},
	{"cwd", TYPE2, 0x9966},
	{"clc", TYPE1, 0xf8},
	{"cld", TYPE1, 0xfc},
	{"cli", TYPE1, 0xfa},
	{"cmc", TYPE1, 0xf5},
	{"daa", TYPE1, 0x27},
	{"das", TYPE1, 0x2f},
	{"dec", TYPE5, 0x08fe48},
	{"div", TYPE6, 0x30f6},
	{"hlt", TYPE1, 0xf4},
	{"idiv", TYPE6, 0x38f6},
	{"imul", TYPE6, 0x28f6},
	{"inc", TYPE5, 0x00fe40},
	{"int3", TYPE1, 0xcc},
	{"int", TYPE7, 0xcd},
	{"into", TYPE1, 0xce},
	{"iret", TYPE1, 0xcf},
	{"ja",   TYPE8, 0x870f},
	{"jae",  TYPE8, 0x830f},
	{"jb",   TYPE8, 0x820f},
	{"jbe",  TYPE8, 0x860f},
	{"jc",   TYPE8, 0x820f},
	{"je",   TYPE8, 0x840f},
	{"jg",   TYPE8, 0x8f0f},
	{"jge",  TYPE8, 0x8d0f},
	{"jl",   TYPE8, 0x8c0f},
	{"jle",  TYPE8, 0x8e0f},
	{"jna",  TYPE8, 0x860f},
	{"jnae", TYPE8, 0x820f},
	{"jnb",  TYPE8, 0x830f},
	{"jnbe", TYPE8, 0x870f},
	{"jnc",  TYPE8, 0x830f},
	{"jne",  TYPE8, 0x850f},
	{"jng",  TYPE8, 0x8e0f},
	{"jnge", TYPE8, 0x8c0f},
	{"jnl",  TYPE8, 0x8d0f},
	{"jnle", TYPE8, 0x8f0f},
	{"jno",  TYPE8, 0x810f},
	{"jns",  TYPE8, 0x890f},
	{"jnz",  TYPE8, 0x850f},
	{"jo",   TYPE8, 0x800f},
	{"jpe",  TYPE8, 0x8a0f},
	{"jpo",  TYPE8, 0x8b0f},
	{"js",   TYPE8, 0x880f},
	{"jz",   TYPE8, 0x840f},
	{"jmp",  TYPE4, 0xeae9},
	{"lahf", TYPE1, 0x9f},
	{"mov",  TYPE9, 0},
	{"mul",  TYPE6, 0x20f6},
	{"neg",  TYPE6, 0x18f6},
	{"nop",  TYPE1, 0x90},
	{"not",  TYPE6, 0x10f6},
	{"or",   TYPE3, 0x08800c08},
	{"pop",  TYPE10, 0x008f58},
	{"popf", TYPE1, 0x9d},
	{"push", TYPE10, 0x30ff50},
	{"pushf",TYPE1, 0x9c},
	{"rcl",  TYPE11, 0x10d0},
	{"rcr",  TYPE11, 0x18d0},
	{"ret",  TYPE12, 0xc2c3},
	{"retf", TYPE12, 0xcacb},
	{"rol",  TYPE11, 0x00d0},
	{"ror",  TYPE11, 0x08d0},
	{"sahf", TYPE1, 0x9e},
	{"sal",  TYPE11, 0x20d0},
	{"shl",  TYPE11, 0x20d0},
	{"sar",  TYPE11, 0x38d0},
	{"sbb",  TYPE3, 0x18801c18},
	{"shr",  TYPE11, 0x28d0},
	{"stc",  TYPE1, 0xf9},
	{"std",  TYPE1, 0xfd},
	{"sti",  TYPE1, 0xfb},
	{"sub",  TYPE3, 0x28802c28},
	{"test", TYPE13, 0x00f6a884},
	{"xchg", TYPE14, 0x8690},
	{"xor",  TYPE3, 0x30803430},
	
	{"db", TYPE_DB, 0},
	{"dd", TYPE_DD, 0},
	{"dw", TYPE_DW, 0},
	{"equ", TYPE_EQU, 0},
	{"org", TYPE_ORG, 0},
	{"section", TYPE_SECTION, 0},
	{"byte", TYPE_B_W_D, 1},
	{"word", TYPE_B_W_D, 2},
	{"dword", TYPE_B_W_D, 3},
	{"al",  TYPE_REG, 0x0100},
	{"cl",  TYPE_REG, 0x0101},
	{"dl",  TYPE_REG, 0x0102},
	{"bl",  TYPE_REG, 0x0103},
	{"ah",  TYPE_REG, 0x0104},
	{"ch",  TYPE_REG, 0x0105},
	{"dh",  TYPE_REG, 0x0106},
	{"bh",  TYPE_REG, 0x0107},
	{"ax",  TYPE_REG, 0x0200},
	{"cx",  TYPE_REG, 0x0201},
	{"dx",  TYPE_REG, 0x0202},
	{"bx",  TYPE_REG, 0x0203},
	{"sp",  TYPE_REG, 0x0204},
	{"bp",  TYPE_REG, 0x0205},
	{"si",  TYPE_REG, 0x0206},
	{"di",  TYPE_REG, 0x0207},
	{"eax", TYPE_REG, 0x0300},
	{"ecx", TYPE_REG, 0x0301},
	{"edx", TYPE_REG, 0x0302},
	{"ebx", TYPE_REG, 0x0303},
	{"esp", TYPE_REG, 0x0304},
	{"ebp", TYPE_REG, 0x0305},
	{"esi", TYPE_REG, 0x0306},
	{"edi", TYPE_REG, 0x0307},
	{"es",  TYPE_REG, 0x0400},
	{"cs",  TYPE_REG, 0x0401},
	{"ss",  TYPE_REG, 0x0402},
	{"ds",  TYPE_REG, 0x0403},
	
	{0,0},
};

struct symtbl{
	char symbol[SYM_LEN];
	int type;
	unsigned int value;
};

struct symtbl a_symtbl[SYM_TBL_LEN];
int a_symtbl_ptr;

struct section{
	char symbol[SYM_LEN];
	unsigned int addr;
};

struct section a_section[SECTION_TBL_LEN];
int a_section_ptr;
int a_section_numb;		/* 現在使用しているセクション */

#define T1	1	/* reg byte	*/
#define T2	2	/* reg word	*/
#define T3	3	/* reg dword	*/
#define T4	4	/* reg segment	*/
#define T10	10	/* byte 定数	*/
#define T11	11	/* word 定数	*/
#define T12	12	/* dword 定数	*/
#define T20	20	/* 1byte EA disp 無し	*/
#define T21	21	/* 1byte EA byte disp	*/
#define T22	22	/* 1byte EA dword disp	*/
#define T23	23	/* 2byte EA disp 無し	*/
#define T24	24	/* 2byte EA byte disp	*/
#define T25	25	/* 2byte EA dword disp	*/

struct operand{
	int type;
	int reg_numb;
	unsigned int value;
//	unsigned char prefix;
	unsigned char ea1;
	unsigned char ea2;
};

#define E_NOTSYMBOL			1
#define E_LINEEND			2
#define E_MULTIPLE_DEFINITION		3
#define E_UNDEFINED_SYMBOL		4
#define E_SYNTAX_ERROR			5
#define E_INTERNAL_ERROR		6

char *a_error[] = {
	"No error",			// 0
	"E_NOTSYMBOL",			// 1
	"E_LINEEND",			// 2
	"E_MULTIPLE_DEFINITION",	// 3
	"E_UNDEFINED_SYMBOL",		// 4
	"E_SYNTAX_ERROR",		// 5
	"E_INTERNAL_ERROR",		// 6
};

char *a_srcfile;
int a_srcfile_len;
int a_srcfile_ptr;
unsigned char *a_objfile;
int a_objfile_ptr;
unsigned char *a_binfile;
unsigned int a_addr_top, a_addr_end;
unsigned char *a_bindata;	/* ダブりチェック用の 0xff データ	*/
unsigned char a_inst[12];	/* 1行の命令バッファ */
int a_inst_ptr;
char a_linebuf[1024];
char *a_linebufp;
char a_symbuf[SYM_LEN];
unsigned int *a_addr;		/* 現在セクションのアドレス */
int a_linenumb;
int a_pass;
int a_chg_flag;

//#ifdef SELF_ASSEMBLER
//int asm_env;
//#else
//jmp_buf asm_env;
//#endif


extern char *sed_buf;
extern struct sheet *cmd_sht;


int a_expr(unsigned int *value);

//#################################################################################

/*	*a_linebufp がスペース/タブであったらスキップする	*/
void a_spskip()
{
	while(*a_linebufp==' ' || *a_linebufp=='\t')
		a_linebufp++;
}

/*	a_srcfile から１行 a_linebuf[] へ読み込む	*/
void a_get1line()
{
	int i, tmp;
	
	a_linebufp = a_linebuf;
	for(i=0; i<sizeof(a_linebuf)-1; i++){
		tmp = a_srcfile[a_srcfile_ptr];
		if(tmp==0){
			a_linebuf[i] = 0;
			return;
		}
		else if(tmp=='\n'){
			a_linebuf[i] = 0;
			a_srcfile_ptr++;
			return;
		}
		else if(tmp=='\r'){
			a_linebuf[i] = 0;
			a_srcfile_ptr++;
			if(a_srcfile[a_srcfile_ptr]=='\n'){
				a_srcfile_ptr++;
			}
			return;
		}
		else{
			a_linebuf[i] = tmp;
			a_srcfile_ptr++;
		}
	}
	a_linebuf[i] = 0;
}

void a_error_message(int err, int line)
{
	printf("Line %d *** %s\n", line, a_error[err]);
	printf("%d:	%s\n", a_linenumb, a_linebuf);
}

/*	シンボル先頭文字ならば return 1;	*/
int is_symtop()
{
	if(*a_linebufp=='.' || *a_linebufp=='_' || *a_linebufp=='@' || (*a_linebufp>='A' && *a_linebufp<='Z') || (*a_linebufp>='a' && *a_linebufp<='z')){
		return 1;
	}
	return 0;
}

/*	シンボル本体文字ならば return 1;	*/
int is_symbody()
{
	if(is_symtop()){
		return 1;
	}
	if(*a_linebufp>='0' && *a_linebufp<='9'){
		return 1;
	}
	return 0;
}

/*	a_linebufp から１シンボルを取り込み a_symbuf[] に入れる	*/
/*	a_linebufp が行末まで来たら a_srcfile からソースを a_linebuf[] に入れてから処理する	*/
int a_getsym()
{
	int i;
	
	a_spskip();
	if(is_symtop()==0){
		a_error_message(E_NOTSYMBOL, __LINE__);
		return -1;	/* error	*/
	}
	for(i=0; i<SYM_LEN-1; i++){
		if(is_symbody()){
			a_symbuf[i] = *a_linebufp++;
		}
		else{
			a_symbuf[i] = 0;
			return 0;	/* success	*/
		}
	}
	a_symbuf[i] = 0;
	return 0;	/* success	*/
}

/*	return -1:not found, 0～:テーブル番号	*/
int a_symsrch()
{
	int i;
	
	for(i=0; i<a_symtbl_ptr; i++){
		if(strcmp(a_symbuf, a_symtbl[i].symbol)==0){	/* 発見した */
			return i;
		}
	}
	return -1;	/* symbol not found */
}

void a_listout()
{
	int i;
	
	if(a_pass != 3){	/* pass3 でリストを出す */
		return;
	}
	printf("%08x  ", *a_addr);
	for(i=0; i<12; i++){
		if(i<a_inst_ptr){
			printf("%02x", a_inst[i]);
		}
		else{
			printf("  ");
		}
	}
	printf("%5d:	%s\n", a_linenumb, a_linebuf);
}

void a_listout_nosrc()
{
	int i;
	
	if(a_pass != 3){	/* pass3 でリストを出す */
		return;
	}
	printf("%08x  ", *a_addr);
	for(i=0; i<10; i++){
		if(i<a_inst_ptr){
			printf("%02x", a_inst[i]);
		}
		else{
			printf("  ");
		}
	}
	printf("\n");
}

/*	type 1: データレコード			*/
/*		| len | 1 | addr | data... |	*/

void a_objout()
{
	int len, i, addr;
	
	if(a_pass != 3){
		return;
	}
	len = 1+4+a_inst_ptr;
	a_objfile[a_objfile_ptr++] = len;
	a_objfile[a_objfile_ptr++] = 1;
	addr = *a_addr;
	for(i=0; i<4; i++){	/* addr 出力	*/
		a_objfile[a_objfile_ptr++] = addr;
		addr >>= 8;
	}
	for(i=0; i<a_inst_ptr; i++){
		a_objfile[a_objfile_ptr++] = a_inst[i];
	}
}

//#################################################################################

/*	a_getnumb = 1234, 0x1234	*/
int a_getnumb(unsigned int *value)
{
//	unsigned int value;
	
	a_spskip();
	if(*a_linebufp<'0' || *a_linebufp>'9'){
		a_error_message(E_SYNTAX_ERROR, __LINE__);
		return -1;	/* error	*/
	}
	if(a_linebufp[0]=='0' && a_linebufp[1]=='x'){	/* 0x...	*/
		a_linebufp += 2;
		*value = 0;
		for(;;){
			if(*a_linebufp>='0' && *a_linebufp<='9'){
				*value = *value*16 + *a_linebufp - '0';
			}
			else if(*a_linebufp>='A' && *a_linebufp<='F'){
				*value = *value*16 + *a_linebufp + (10-'A');
			}
			else if(*a_linebufp>='a' && *a_linebufp<='f'){
				*value = *value*16 + *a_linebufp + (10-'a');
			}
			else{
				return 0;	/* success	*/
			}
			a_linebufp++;
		}
	}
	*value = 0;
	for(;;){
		if(*a_linebufp>='0' && *a_linebufp<='9'){
			*value = *value * 10 + *a_linebufp - '0';
		}
		else{
			return 0;	/* success	*/
		}
		a_linebufp++;
	}
}

/*	a_factor = 定数、symbol、(a_expr)	*/
int a_factor(unsigned int *value)
{
//	unsigned int value;
	int numb;
	
	*value = 0;
	a_spskip();
	if(*a_linebufp>='0' && *a_linebufp<='9'){
		return a_getnumb(value);
	}
	else if(is_symtop()){
		if(a_getsym()){
			return -1;	/* error	*/
		}
		numb = a_symsrch();
		if(a_pass==1){
			*value = 0;
			return 0;	/* success	*/
		}
		if(numb < 0){
			a_error_message(E_UNDEFINED_SYMBOL, __LINE__);
			return -1;	/* error	*/
		}
		if(a_symtbl[numb].type != TYPE_SYMBOL && a_symtbl[numb].type != TYPE_EQU){
			a_error_message(E_SYNTAX_ERROR, __LINE__);
			return -1;	/* error	*/
		}
		*value = a_symtbl[numb].value;
		return 0;	/* success	*/
		
	}
	else if(*a_linebufp=='('){
		a_linebufp++;
		if(a_expr(value)){
			return -1;	/* error	*/
		}
		a_spskip();
		if(*a_linebufp==')'){
			a_linebufp++;
			return 0;	/* success	*/
		}
		a_error_message(E_SYNTAX_ERROR, __LINE__);
		return -1;	/* error	*/
	}
	else if(*a_linebufp=='$'){
		a_linebufp++;
		*value = *a_addr;
		return 0;	/* success	*/
	}
	else if(*a_linebufp=='\''){
		a_linebufp++;		/* ' skip	*/
		if(*a_linebufp=='\\'){
			a_linebufp++;	/* \ skip	*/
			if(*a_linebufp=='\\'){
				*value = '\\';
			}
			else if(*a_linebufp=='r'){
				*value = '\r';
			}
			else if(*a_linebufp=='n'){
				*value = '\n';
			}
			else if(*a_linebufp=='b'){
				*value = '\b';
			}
			else if(*a_linebufp=='t'){
				*value = '\t';
			}
			else if(*a_linebufp=='\''){
				*value = '\'';
			}
			else if(*a_linebufp=='\"'){
				*value = '\"';
			}
			else{
				*value = *a_linebufp;
			}
		}
		else{
			*value = *a_linebufp;
		}
		a_linebufp++;		/* 文字スキップ	*/
		if(*a_linebufp != '\''){
			a_error_message(E_SYNTAX_ERROR, __LINE__);
			return -1;	/* error	*/
		}
		a_linebufp++;		/* ' skip	*/
		return 0;	/* success	*/
	}
	return 0;	/* success	*/
}

/*	a_factor1 = a_factor & | a_factor	*/
int a_factor1(unsigned int *value)
{
	unsigned int v;
	
	if(a_factor(value)){
		return -1;	/* error	*/
	}
	a_spskip();
	if(*a_linebufp=='&'){
		a_linebufp++;
		if(a_factor(&v)){
			return -1;	/* error	*/
		}
		*value &= v;
	}
	else if(*a_linebufp=='|'){
		a_linebufp++;
		if(a_factor(&v)){
			return -1;	/* error	*/
		}
		*value |= v;
	}
	return 0;	/* success	*/
}

/*	a_term = a_factor1 * / % a_factor1 * / % a_factor1	*/
int a_term(unsigned int *value)
{
	unsigned int v;
	
	if(a_factor1(value)){
		return -1;	/* error	*/
	}
	for(;;){
		a_spskip();
		if(*a_linebufp=='*'){
			a_linebufp++;
			if(a_factor1(&v)){
				return -1;
			}
			*value *= v;
		}
		else if(*a_linebufp=='/'){
			a_linebufp++;
			if(a_factor1(&v)){
				return -1;
			}
			*value /= v;
		}
		else if(*a_linebufp=='%'){
			a_linebufp++;
			if(a_factor1(&v)){
				return -1;
			}
			*value %= v;
		}
		else{
			return 0;	/* success	*/
		}
	}
}

/*	a_expr = -a_term + a_term + ... + aterm	*/
int a_expr(unsigned int *value)
{
	int minus_flag;
	unsigned int v;
	
	minus_flag = 0;
	a_spskip();
	if(*a_linebufp=='-'){
		a_linebufp++;
		minus_flag = 1;
	}
	
	if(a_term(value)){
		return -1;	/* error	*/
	}
	if(minus_flag){
		*value = -*value;
	}
	
	for(;;){
		a_spskip();
		if(*a_linebufp=='+'){
			a_linebufp++;
			if(a_term(&v)){
				return -1;	/*	error	*/
			}
			*value += v;
			
		}
		else if(*a_linebufp=='-'){
			a_linebufp++;
			if(a_term(&v)){
				return -1;	/* error	*/
			}
			*value -= v;
		}
		else{
			return 0;	/* success	*/
		}
	}
}

//#################################################################################

/*	reg オペランドでなければ return 0;	*/
int a_get_regoperand(struct operand *op)
{
	int numb;
	char *linebufp_save;
	
	a_spskip();
	if(is_symtop()==0){
		return 0;	/* シンボルでなかった	*/
	}
	linebufp_save = a_linebufp;
	if(a_getsym()){		/* a_symbuf = シンボル	*/
		return 0;	/* シンボルでなかった	*/
	}
	numb = a_symsrch();
	if(numb>=0 && a_symtbl[numb].type==TYPE_REG){	/* register	*/
		op->type = a_symtbl[numb].value >> 8;	/* 1～4	*/
		op->reg_numb = a_symtbl[numb].value & 0xff;
		return 1;	/* reg オペランドだった	*/
	}
	a_linebufp = linebufp_save;
	return 0;	/* reg オペランドでなかった	*/
}

/*	数値でなかったらエラーになる	*/
int a_get_const_operand(struct operand *op)
{
	int numb;
	char *linebufp_save;

	a_spskip();
	if(is_symtop()){
		linebufp_save = a_linebufp;
		if(a_getsym()){
			return -1;	/* error	*/
		}
		numb = a_symsrch();
		if(numb >= 0){
			if(a_symtbl[numb].type==TYPE_B_W_D){
				if(a_expr(&op->value)){
					return -1;	/* error	*/
				}
				op->type = T10 + a_symtbl[numb].value-1;
				return 0;	/* success	*/
			}
		}
		a_linebufp = linebufp_save;
	}


	if(a_expr(&op->value)){		/* 定数		*/
		return -1;	/* error	*/
	}
	if((int)op->value >= -128 && (int)op->value <= 127){
		op->type = T10;		/* byte 定数	*/
	}
	else if((int)op->value >= -32768 && (int)op->value <= 32767){
		op->type = T11;		/* word 定数	*/
	}
	else{
		op->type = T12;		/* dword 定数	*/
	}
	return 0;	/* success	*/
}

/*	EA でなかったらエラーにする	*/
int a_get_EA_operand(struct operand *op2, struct operand *op3, struct operand *op4)
{
	memset(op2, 0, sizeof(struct operand));
	memset(op3, 0, sizeof(struct operand));
	memset(op4, 0, sizeof(struct operand));
	a_spskip();
	if(*a_linebufp != '['){
		a_error_message(E_SYNTAX_ERROR, __LINE__);
		return -1;	/* error	*/
	}
	a_linebufp++;
	if(a_get_regoperand(op2)==0){	/* reg でない	*/
		if(a_get_const_operand(op2)){	/* [数値]	*/
			return -1;	/* error	*/
		}
		a_spskip();
		if(*a_linebufp != ']'){
			a_error_message(E_SYNTAX_ERROR, __LINE__);
			return -1;	/* error	*/
		}
		a_linebufp++;
		return 0;	/* success	*/
	}
	/*	op2 に第一 reg が入っている	*/
	a_spskip();
	if(*a_linebufp==']'){
		a_linebufp++;
		return 0;	/* success	*/
	}
	if(*a_linebufp=='+'){
		a_linebufp++;
		if(a_get_regoperand(op3)==0){	/* reg でない	*/
			if(a_get_const_operand(op3)){	/* 数値	*/
				return -1;	/* error	*/
			}
			a_spskip();
			if(*a_linebufp != ']'){
				a_error_message(E_SYNTAX_ERROR, __LINE__);
				return -1;	/* error	*/
			}
			a_linebufp++;
			return 0;	/* success	*/
		}
	}
	else if(*a_linebufp=='-'){
		if(a_get_const_operand(op3)){	/* 数値	*/
			return -1;	/* error	*/
		}
		a_spskip();
		if(*a_linebufp != ']'){
			a_error_message(E_SYNTAX_ERROR, __LINE__);
			return -1;	/* error	*/
		}
		a_linebufp++;
		return 0;	/* success	*/
	}
	/*	op3 に第二 reg が入っている	*/
	a_spskip();
	if(*a_linebufp==']'){
		a_linebufp++;
		return 0;	/* success	*/
	}
	if(*a_linebufp=='+'){
		a_linebufp++;
	}
	else if(*a_linebufp=='-'){
	}
	else{
		a_error_message(E_SYNTAX_ERROR, __LINE__);
		return -1;	/* error	*/
	}
	if(a_get_const_operand(op4)){
		return -1;	/* error	*/
	}
	a_spskip();
	if(*a_linebufp != ']'){
		a_error_message(E_SYNTAX_ERROR, __LINE__);
		return -1;	/* error	*/
	}
	a_linebufp++;
	return 0;	/* success	*/
}

int a_make_EA_reg(struct operand *op, struct operand *op2)
{
	if(op2->type==T3){		/* reg dword	*/
		if(op2->reg_numb==4){	/* esp		*/
			op->type = T23;	/* 2byte EA disp 無し	*/
			op->ea1 = 0x04;
			op->ea2 = 0x24;
		}
		else if(op2->reg_numb==5){	/* ebp	*/
			op->type = T23;	/* 2byte EA disp 無し	*/
			op->ea1 = 0x45;
			op->ea2 = 0x00;
		}
		else{
			op->type = T20;	/* 1byte EA disp 無し	*/
			op->ea1 = 0x00+op2->reg_numb;
		}
	}
	else{
		a_error_message(E_SYNTAX_ERROR, __LINE__);
		return -1;	/* error	*/
	}
	return 0;	/* success	*/
}

int a_make_EA_reg_disp(struct operand *op, struct operand *op2, struct operand *op3)
{
	if(op2->type==T3){		/* reg dword	*/
		if(op3->type==T10){	/* byte 定数	*/
			if(op2->reg_numb==4){	/* esp		*/
				op->type = T24;	/* 2byte EA byte disp 	*/
				op->ea1 = 0x44;
				op->ea2 = 0x24;
				op->value = op3->value;
				return 0;	/* success	*/
			}
			else{
				op->type = T21;	/* 1byte EA byte disp 	*/
				op->ea1 = 0x40+op2->reg_numb;
				op->value = op3->value;
				return 0;	/* success	*/
			}
		}
		if(op3->type==T11){	/* word 定数→dword にする	*/
			op3->type = T12;	/* dword 定数	*/
		}
		if(op3->type==T12){	/* dword 定数	*/
			if(op2->reg_numb==4){	/* esp		*/
				op->type = T25;	/* 2byte EA dword disp 	*/
				op->ea1 = 0x84;
				op->ea2 = 0x24;
				op->value = op3->value;
				return 0;	/* success	*/
			}
			else{
				op->type = T22;	/* 1byte EA dword disp 	*/
				op->ea1 = 0x80+op2->reg_numb;
				op->value = op3->value;
			}
		}
	}
	else{
		a_error_message(E_SYNTAX_ERROR, __LINE__);
		return -1;	/* error	*/
	}
	return 0;	/* success	*/
}

int a_make_EA_reg_reg(struct operand *op, struct operand *op2, struct operand *op3)
{
	int tmp;
	
	if(op2->type==T3 && op3->type==T3){
		if(op2->reg_numb==4 && op3->reg_numb==4){	/* [esp+esp]	*/
			a_error_message(E_SYNTAX_ERROR, __LINE__);
			return -1;	/* error	*/
		}
		if(op3->reg_numb==4){		/* [xxx+ebp] → [ebp+xxx]	*/
			tmp = op2->reg_numb;
			op2->reg_numb = op3->reg_numb;
			op3->reg_numb = tmp;
		}
		if(op2->reg_numb==5){		/* ebp		*/
			if(op3->reg_numb==4){	/* [ebp+esp]	*/
				op->type = T23;	/* 2byte EA disp 無し	*/
				op->ea1 = 0x04;
				op->ea2 = 0x2c;
			}
			else{
				op->type = T24;	/* 2byte EA byte disp	*/
				op->ea1 = 0x44;
				op->ea2 = 0x05+op3->reg_numb*8;
				op->value = 0;	/* disp=0		*/
			}
		}
		else{
			op->type = T23;		/* 2byte EA disp 無し	*/
			op->ea1 = 0x04;
			op->ea2 = 0x00+op2->reg_numb+op3->reg_numb*8;
		}
	}
	else{
		a_error_message(E_SYNTAX_ERROR, __LINE__);
		return -1;	/* error	*/
	}
	return 0;	/* success	*/
}

int a_make_EA_reg_reg_disp(struct operand *op, struct operand *op2, struct operand *op3, struct operand *op4)
{
	int tmp;
	
	if(op2->type==T3 && op3->type==T3){
		if(op2->reg_numb==4 && op3->reg_numb==4){	/* [esp+esp+disp]	*/
			a_error_message(E_SYNTAX_ERROR, __LINE__);
			return -1;	/* error	*/
		}
		if(op3->reg_numb==4){		/* [xxx+ebp] → [ebp+xxx]	*/
			tmp = op2->reg_numb;
			op2->reg_numb = op3->reg_numb;
			op3->reg_numb = tmp;
		}
		if(op4->type==T11){		/* word 定数ならば dword にする	*/
			op4->type = T12;
		}
		if(op4->type==T10){		/* byte disp		*/
			op->type = T24;		/* 2byte EA byte disp	*/
			op->ea1 = 0x44;
			op->ea2 = 0x00+op2->reg_numb+op3->reg_numb*8;
			op->value = op4->value;
		}
		else if(op4->type==T12){
			op->type = T25;		/* 2byte EA dword disp	*/
			op->ea1 = 0x84;
			op->ea2 = 0x00+op2->reg_numb+op3->reg_numb*8;
			op->value = op4->value;
		}
		else{
			a_error_message(E_SYNTAX_ERROR, __LINE__);
			return -1;	/* errror	*/
		}
	}
	else{
		a_error_message(E_SYNTAX_ERROR, __LINE__);
		return -1;	/* error	*/
	}
	return 0;	/* success	*/
}

int a_make_EA(struct operand *op, struct operand *op2, struct operand *op3, struct operand *op4)
{
	memset(op, 0, sizeof(struct operand));
	if(op2->type >= T10 && op2->type <= T12){	/* disp(定数)	*/
		op->type = T22;		/* 1byte EA dword disp	*/
		op->ea1 = 0x05;
		op->value = op2->value;
	}
	else if(op2->type >= T1 && op2->type<=T3){	/* 一般 reg	*/
		if(op3->type==0){	/* op3 無し	*/
			if(a_make_EA_reg(op, op2)){
				return -1;	/* error	*/
			}
		}
		else if(op3->type>=T10 && op3->type<=T12){	/* disp		*/
			if(a_make_EA_reg_disp(op, op2, op3)){
				return -1;	/* error	*/
			}
		}
		else if(op3->type>=T1 && op3->type<=T3){	/* 一般 reg	*/
			if(op4->type==0){	/* op4 無し	*/
				if(a_make_EA_reg_reg(op, op2, op3)){
					return -1;	/* error	*/
				}
			}
			else if(op4->type>=T10 && op4->type<=T12){	/* disp		*/
				if(a_make_EA_reg_reg_disp(op, op2, op3, op4)){
					return -1;	/* error	*/
				}
			}
			else{
				a_error_message(E_SYNTAX_ERROR, __LINE__);
				return -1;	/* error	*/
			}
		}
		else{
			a_error_message(E_SYNTAX_ERROR, __LINE__);
			return -1;	/* error	*/
		}
	}
	else{
		a_error_message(E_SYNTAX_ERROR, __LINE__);
		return -1;	/* error	*/
	}
	return 0;	/* success	*/
}

int a_get1operand(struct operand *op)
{
	struct operand op2, op3, op4;
	
	a_spskip();
	if(*a_linebufp=='['){
		if(a_get_EA_operand(&op2, &op3, &op4)){
			return -1;	/* error	*/
		}
		return a_make_EA(op, &op2, &op3, &op4);
	}
	if(a_get_regoperand(op)){
		return 0;		/* reg だった	*/
	}
	return a_get_const_operand(op);
}

//#################################################################################

/*	1バイト固定	*/
void a_op_TYPE1(unsigned int value)
{
	a_inst[0] = value;
	a_inst_ptr = 1;
	a_objout();
}

/*	2バイト固定	*/
void a_op_TYPE2(unsigned int value)
{
	*(unsigned short *)a_inst = value;
	a_inst_ptr = 2;
	a_objout();
}

/*	add eax,0x1234	*/
void a_op_TYPE3_a(int value, struct operand *op1, struct operand *op2)
{
	if(op1->type==T1){		/* add al,0x12		*/
		a_inst[0] = (value>>8);
		a_inst[1] = op2->value;
		a_inst_ptr = 2;
	}
	else if(op1->type==T2){		/* add ax,0x12		*/
		a_inst[0] = 0x66;
		a_inst[1] = (value>>8) | 1;
		*(short*)&a_inst[2] = op2->value;
		a_inst_ptr = 4;
	}
	else if(op1->type==T3){		/* add eax,0x12		*/
		if(op2->type==T10){	/* byte 定数		*/
			a_inst[0] = (value>>16) | 0x03;
			a_inst[1] = 0xc0 | (value>>24);
			a_inst[2] = op2->value;
			a_inst_ptr = 3;
		}
		else{
			a_inst[0] = (value>>8) | 1;
			*(unsigned int*)&a_inst[1] = op2->value;
			a_inst_ptr = 5;
		}
	}
}

/*	add reg1,reg2		*/
int a_op_TYPE3_b(int value, struct operand *op1, struct operand *op2)
{
	if(op1->type==T1 && op2->type==T1){	/* byte reg		*/
		a_inst[0] = value;
		a_inst[1] = 0xc0+op1->reg_numb+op2->reg_numb*8;
		a_inst_ptr = 2;
	}
	else if(op1->type==T2 && op2->type==T2){	/* word reg		*/
		a_inst[0] = 0x66;
		a_inst[1] = value | 1;
		a_inst[2] = 0xc0+op1->reg_numb+op2->reg_numb*8;
		a_inst_ptr = 3;
	}
	else if(op1->type==T3 && op2->type==T3){	/* dword reg		*/
		a_inst[0] = value | 1;
		a_inst[1] = 0xc0+op1->reg_numb+op2->reg_numb*8;
		a_inst_ptr = 2;
	}
	else{
		a_error_message(E_SYNTAX_ERROR, __LINE__);
		return -1;	/* error	*/
	}
	return 0;	/* success	*/
}

int a_op_TYPE3_c_sub(int value, struct operand *op1, struct operand *op2, int or_bit, int start)
{
	switch(op2->type){
		case T20:	/* 1byte EA disp 無し	*/
			a_inst[start+0] = value | or_bit;
			a_inst[start+1] = op2->ea1 | op1->reg_numb*8;
			a_inst_ptr = start+2;
			break;
		case T21:	/* 1byte EA byte disp	*/
			a_inst[start+0] = value | or_bit;
			a_inst[start+1] = op2->ea1 | op1->reg_numb*8;
			a_inst[start+2] = op2->value;
			a_inst_ptr = start+3;
			break;
		case T22:	/* 1byte EA dword disp	*/
			a_inst[start+0] = value | or_bit;
			a_inst[start+1] = op2->ea1 | op1->reg_numb*8;
			*(unsigned int*)&a_inst[start+2] = op2->value;
			a_inst_ptr = start+6;
			break;
		case T23:	/* 2byte EA disp 無し	*/
			a_inst[start+0] = value | or_bit;
			a_inst[start+1] = op2->ea1 | op1->reg_numb*8;
			a_inst[start+2] = op2->ea2;
			a_inst_ptr = start+3;
			break;
		case T24:	/* 2byte EA byte disp	*/
			a_inst[start+0] = value | or_bit;
			a_inst[start+1] = op2->ea1 | op1->reg_numb*8;
			a_inst[start+2] = op2->ea2;
			a_inst[start+3] = op2->value;
			a_inst_ptr = start+4;
			break;
		case T25:	/* 2byte EA dword disp	*/
			a_inst[start+0] = value | or_bit;
			a_inst[start+1] = op2->ea1 | op1->reg_numb*8;
			a_inst[start+2] = op2->ea2;
			*(unsigned int*)&a_inst[start+3] = op2->value;
			a_inst_ptr = start+7;
			break;
		default:
			a_error_message(E_SYNTAX_ERROR, __LINE__);
			return -1;	/* error	*/
	}
	return 0;	/* success	*/
}

/*	add reg,EA	*/
int a_op_TYPE3_c(int value, struct operand *op1, struct operand *op2)
{
	if(op1->type==T1){		/* byte reg		*/
		if(a_op_TYPE3_c_sub(value, op1, op2, 2, 0)){
			return -1;	/* error	*/
		}
	}
	else if(op1->type==T2){		/* word reg		*/
		a_inst[0] = 0x66;
		if(a_op_TYPE3_c_sub(value, op1, op2, 3, 1)){
			return -1;	/* error	*/
		}
	}
	else if(op1->type==T3){		/* dword reg		*/
		if(a_op_TYPE3_c_sub(value, op1, op2, 3, 0)){
			return -1;	/* error	*/
		}
	}
	else{
		a_error_message(E_SYNTAX_ERROR, __LINE__);
		return -1;	/* error	*/
	}
	return 0;	/* success	*/
}

/*	add EA,reg	*/
int a_op_TYPE3_d(int value, struct operand *op1, struct operand *op2)
{
	if(op2->type==T1){		/* byte reg		*/
		if(a_op_TYPE3_c_sub(value, op2, op1, 0, 0)){
			return -1;	/* error	*/
		}
	}
	else if(op2->type==T2){		/* word reg		*/
		a_inst[0] = 0x66;
		if(a_op_TYPE3_c_sub(value, op2, op1, 1, 1)){
			return -1;	/* error	*/
		}
	}
	else if(op2->type==T3){		/* dword reg		*/
		if(a_op_TYPE3_c_sub(value, op2, op1, 1, 0)){
			return -1;	/* error	*/
		}
	}
	else{
		a_error_message(E_SYNTAX_ERROR, __LINE__);
		return -1;	/* error	*/
	}
	return 0;	/* success	*/
}

int a_op_TYPE3_e_sub(int value, struct operand *op1, struct operand *op2, int or_bit, int start)
{
	switch(op1->type){
		case T20:	/* 1byte EA disp 無し	*/
			a_inst[start+0] = (value>>16) | or_bit;
			a_inst[start+1] = op1->ea1 | (value>>24);
			a_inst_ptr = start+2;
			break;
		case T21:	/* 1byte EA byte disp	*/
			a_inst[start+0] = (value>>16) | or_bit;
			a_inst[start+1] = op1->ea1 | (value>>24);
			a_inst[start+2] = op1->value;
			a_inst_ptr = start+3;
			break;
		case T22:	/* 1byte EA dword disp	*/
			a_inst[start+0] = (value>>16) | or_bit;
			a_inst[start+1] = op1->ea1 | (value>>24);
			*(unsigned int*)&a_inst[start+2] = op1->value;
			a_inst_ptr = start+6;
			break;
		case T23:	/* 2byte EA disp 無し	*/
			a_inst[start+0] = (value>>16) | or_bit;
			a_inst[start+1] = op1->ea1 | (value>>24);
			a_inst[start+2] = op1->ea2;
			a_inst_ptr = start+3;
			break;
		case T24:	/* 2byte EA byte disp	*/
			a_inst[start+0] = (value>>16) | or_bit;
			a_inst[start+1] = op1->ea1 | (value>>24);
			a_inst[start+2] = op1->ea2;
			a_inst[start+3] = op1->value;
			a_inst_ptr = start+4;
			break;
		case T25:	/* 2byte EA dword disp	*/
			a_inst[start+0] = (value>>16) | or_bit;
			a_inst[start+1] = op1->ea1 | (value>>24);
			a_inst[start+2] = op1->ea2;
			*(unsigned int*)&a_inst[start+3] = op1->value;
			a_inst_ptr = start+7;
			break;
		default:
			a_error_message(E_SYNTAX_ERROR, __LINE__);
			return -1;	/* error	*/
	}
	if(op2->type==T10){		/* byte 定数		*/
		a_inst[a_inst_ptr] = op2->value;
		a_inst_ptr++;
	}
	else if(op2->type==T11){		/* word 定数		*/
		*(short*)&a_inst[a_inst_ptr] = op2->value;
		a_inst_ptr += 2;
	}
	else if(op2->type==T12){		/* dword 定数		*/
		*(int*)&a_inst[a_inst_ptr] = op2->value;
		a_inst_ptr += 4;
	}
	else{
		a_error_message(E_SYNTAX_ERROR, __LINE__);
		return -1;	/* error	*/
	}
	return 0;	/* success	*/
}

/*	add EA,imm	*/
int a_op_TYPE3_e(int value, struct operand *op1, struct operand *op2)
{
	if(op2->type==T10){		/* byte 定数		*/
		if(a_op_TYPE3_e_sub(value, op1, op2, 0, 0)){
			return -1;	/* error	*/
		}
	}
	else if(op2->type==T11){		/* word 定数		*/
		a_inst[0] = 0x66;
		if(a_op_TYPE3_e_sub(value, op1, op2, 1, 1)){
			return -1;	/* error	*/
		}
	}
	else if(op2->type==T12){		/* dword 定数		*/
		if(a_op_TYPE3_e_sub(value, op1, op2, 1, 0)){
			return -1;	/* error	*/
		}
	}
	else{
		a_error_message(E_SYNTAX_ERROR, __LINE__);
		return -1;	/* error	*/
	}
	return 0;	/* success	*/
}

/*	add reg,imm	*/
int a_op_TYPE3_f(int value, struct operand *op1, struct operand *op2)
{
	if(op1->type==T1){		/* byte reg		*/
		a_inst[0] = value>>16;
		a_inst[1] = 0xc0 | op1->reg_numb | (value>>24);
		a_inst[2] = op2->value;
		a_inst_ptr = 3;
	}
	else if(op1->type==T2){		/* word reg		*/
		if(op2->type==T10){	/* byte 定数		*/
			a_inst[0] = 0x66;
			a_inst[1] = (value>>16) | 3;
			a_inst[2] = 0xc0 | op1->reg_numb | (value>>24);
			a_inst[3] = op2->value;
			a_inst_ptr = 4;
		}
		else{
			a_inst[0] = 0x66;
			a_inst[1] = (value>>16) | 1;
			a_inst[2] = 0xc0 | op1->reg_numb | (value>>24);
			*(short*)&a_inst[3] = op2->value;
			a_inst_ptr = 5;
		}
	}
	else if(op1->type==T3){		/* dword reg		*/
		if(op2->type==T10){	/* byte 定数		*/
			a_inst[0] = (value>>16) | 3;
			a_inst[1] = 0xc0 | op1->reg_numb | (value>>24);
			a_inst[2] = op2->value;
			a_inst_ptr = 3;
		}
		else{
			a_inst[0] = (value>>16) | 1;
			a_inst[1] = 0xc0 | op1->reg_numb | (value>>24);
			*(int*)&a_inst[2] = op2->value;
			a_inst_ptr = 6;
		}
	}
	else{
		a_error_message(E_SYNTAX_ERROR, __LINE__);
		return -1;	/* error	*/
	}
	return 0;	/* success	*/
}

/*	adc	EA, acc imm, EA imm	*/
int a_op_TYPE3(unsigned int value)
{
	struct operand op1, op2;
	
	if(a_get1operand(&op1)){
		return -1;	/* error	*/
	}
	a_spskip();
	if(*a_linebufp != ','){
		a_error_message(E_SYNTAX_ERROR, __LINE__);
		return -1;	/* error	*/
	}
	a_linebufp++;
	if(a_get1operand(&op2)){
		return -1;	/* error	*/
	}
	
	if(op1.type>=T1 && op1.type<=T3 && op1.reg_numb==0 && op2.type>=T10 && op2.type<=T12){
		/*	add eax,0x1234	*/
		a_op_TYPE3_a(value, &op1, &op2);
	}
	else if(op1.type>=T1 && op1.type<=T3 && op2.type>=T1 && op2.type<=T3){
		/*	add reg1,reg2	*/
		if(a_op_TYPE3_b(value, &op1, &op2)){
			return -1;	/* error	*/
		}
	}
	else if(op1.type>=T1 && op1.type<=T3 && op2.type>=T20 && op2.type<=T25){
		/*	add reg,EA	*/
		if(a_op_TYPE3_c(value, &op1, &op2)){
			return -1;	/* error	*/
		}
	}
	else if(op1.type>=T20 && op1.type<=T25 && op2.type>=T1 && op2.type<=T3){
		/*	add EA,reg	*/
		if(a_op_TYPE3_d(value, &op1, &op2)){
			return -1;	/* error	*/
		}
	}
	else if(op1.type>=T20 && op1.type<=T25 && op2.type>=T10 && op2.type<=T12){
		/*	add EA,imm	*/
		if(a_op_TYPE3_e(value, &op1, &op2)){
			return -1;	/* error	*/
		}
	}
	else if(op1.type>=T1 && op1.type<=T3 && op2.type>=T10 && op2.type<=T12){
		/*	add reg,imm	*/
		if(a_op_TYPE3_f(value, &op1, &op2)){
			return -1;	/* error	*/
		}
	}
	else{
		a_error_message(E_SYNTAX_ERROR, __LINE__);
		return -1;	/* error	*/
	}
	a_objout();
	return 0;	/* success	*/
}

/*	call xxxx	*/
int a_op_TYPE4(unsigned int value)
{
	unsigned int value1, value2;
	
	if(a_expr(&value1)){
		return -1;	/* error	*/
	}
	a_spskip();
	if(*a_linebufp==':'){
		a_linebufp++;
		if(a_expr(&value2)){
			return -1;	/* error	*/
		}
		a_inst[0] = value>>8;
		*(int*)&a_inst[1] = value2;
		*(short*)&a_inst[5] = value1;
		a_inst_ptr = 7;
	}
	else{
		a_inst[0] = value;
		*(int*)&a_inst[1] = value1 - (*a_addr+5);
		a_inst_ptr = 5;
	}
	a_objout();
	return 0;	/* success	*/
}

/*	dec reg		*/
int a_op_TYPE5_a(unsigned int value, struct operand *op)
{
	if(op->type==T1){		/* byte reg	*/
		a_inst[0] = value>>8;
		a_inst[1] = 0xc0 | (value>>16) | op->reg_numb;
		a_inst_ptr = 2;
	}
	else if(op->type==T2){		/* word reg	*/
		a_inst[0] = 0x66;
		a_inst[1] = value | op->reg_numb;
		a_inst_ptr = 2;
	}
	else if(op->type==T3){		/* dword reg	*/
		a_inst[0] = value | op->reg_numb;
		a_inst_ptr = 1;
	}
	else{
		a_error_message(E_SYNTAX_ERROR, __LINE__);
		return -1;	/* error	*/
	}
	return 0;	/* success	*/
}

int a_op_TYPE5_b_sub(int value, struct operand *op, int or_bit, int start)
{
	switch(op->type){
		case T20:	/* 1byte EA disp 無し	*/
			a_inst[start+0] = (value>>8) | or_bit;
			a_inst[start+1] = op->ea1 | (value>>16);
			a_inst_ptr = start+2;
			break;
		case T21:	/* 1byte EA byte disp	*/
			a_inst[start+0] = (value>>8) | or_bit;
			a_inst[start+1] = op->ea1 | (value>>16);
			a_inst[start+2] = op->value;
			a_inst_ptr = start+3;
			break;
		case T22:	/* 1byte EA dword disp	*/
			a_inst[start+0] = (value>>8) | or_bit;
			a_inst[start+1] = op->ea1 | (value>>16);
			*(unsigned int*)&a_inst[start+2] = op->value;
			a_inst_ptr = start+6;
			break;
		case T23:	/* 2byte EA disp 無し	*/
			a_inst[start+0] = (value>>8) | or_bit;
			a_inst[start+1] = op->ea1 | (value>>16);
			a_inst[start+2] = op->ea2;
			a_inst_ptr = start+3;
			break;
		case T24:	/* 2byte EA byte disp	*/
			a_inst[start+0] = (value>>8) | or_bit;
			a_inst[start+1] = op->ea1 | (value>>16);
			a_inst[start+2] = op->ea2;
			a_inst[start+3] = op->value;
			a_inst_ptr = start+4;
			break;
		case T25:	/* 2byte EA dword disp	*/
			a_inst[start+0] = (value>>8) | or_bit;
			a_inst[start+1] = op->ea1 | (value>>16);
			a_inst[start+2] = op->ea2;
			*(unsigned int*)&a_inst[start+3] = op->value;
			a_inst_ptr = start+7;
			break;
		default:
			a_error_message(E_SYNTAX_ERROR, __LINE__);
			return -1;	/* error	*/
	}
	return 0;	/* success	*/
}

/*	dec EA		*/
int a_op_TYPE5_b(unsigned int value, int b_w_d, struct operand *op)
{
	if(b_w_d==1){		/* byte		*/
		if(a_op_TYPE5_b_sub(value, op, 0, 0)){
			return -1;	/* error	*/
		}
	}
	else if(b_w_d==2){	/* word		*/
		a_inst[0] = 0x66;
		if(a_op_TYPE5_b_sub(value, op, 1, 1)){
			return -1;	/* error	*/
		}
	}
	else if(b_w_d==3){	/* dword	*/
		if(a_op_TYPE5_b_sub(value, op, 1, 0)){
			return -1;	/* error	*/
		}
	}
	return 0;	/* success	*/
}

/* dec reg,   dec EA	*/
int a_op_TYPE5(unsigned int value)
{
	struct operand op;
	int b_w_d, numb;
	char *linebufp_save;
	
	linebufp_save = a_linebufp;
	if(a_getsym()){
		return -1;	/* error	*/
	}
	numb = a_symsrch();
	if(numb>=0 && a_symtbl[numb].type==TYPE_B_W_D){
		b_w_d = a_symtbl[numb].value;
		if(a_get1operand(&op)){
			return -1;	/* error	*/
		}
		if(op.type>=T20 && op.type<=T25){	/* dec EA	*/
			if(a_op_TYPE5_b(value, b_w_d, &op)){
				return -1;	/* error	*/
			}
		}
		else{
			a_error_message(E_SYNTAX_ERROR, __LINE__);
			return -1;	/* error	*/
		}
	}
	else{
		a_linebufp = linebufp_save;
		if(a_get1operand(&op)){
			return -1;	/* error	*/
		}
		if(op.type>=T1 && op.type<=T3){		/* dec reg	*/
			if(a_op_TYPE5_a(value, &op)){
				return -1;	/* error	*/
			}
		}
		else{
			a_error_message(E_SYNTAX_ERROR, __LINE__);
			return -1;	/* error	*/
		}
	}
	a_objout();
	return 0;	/* success	*/
}

/*	div reg		*/
int a_op_TYPE6_a(unsigned int value, struct operand *op)
{
	if(op->type==TYPE1){		/* byte reg		*/
		a_inst[0] = value;
		a_inst[1] = 0xc0 | (value>>8) | op->reg_numb;
		a_inst_ptr = 2;
	}
	else if(op->type==TYPE2){	/* word reg		*/
		a_inst[0] = 0x66;
		a_inst[1] = value | 1;
		a_inst[2] = 0xc0 | (value>>8) | op->reg_numb;
		a_inst_ptr = 3;
	}
	else if(op->type==TYPE3){	/* dword reg		*/
		a_inst[0] = value | 1;
		a_inst[1] = 0xc0 | (value>>8) | op->reg_numb;
		a_inst_ptr = 2;
	}
	else{
		a_error_message(E_SYNTAX_ERROR, __LINE__);
		return -1;	/* error	*/
	}
	return 0;
}

/*	div EA		*/
int a_op_TYPE6(unsigned int value)
{
	struct operand op;
	int b_w_d, numb;
	char *linebufp_save;
	
	linebufp_save = a_linebufp;
	if(a_getsym()){
		return -1;
	}
	numb = a_symsrch();
	if(numb>=0 && a_symtbl[numb].type==TYPE_B_W_D){
		b_w_d = a_symtbl[numb].value;
		if(a_get1operand(&op)){
			return -1;	/* error	*/
		}
		if(op.type>=T20 && op.type<=T25){	/* div EA	*/
			if(a_op_TYPE5_b(value<<8, b_w_d, &op)){
				return -1;	/* error	*/
			}
		}
		else{
			a_error_message(E_SYNTAX_ERROR, __LINE__);
			return -1;	/* error	*/
		}
	}
	else{
		a_linebufp = linebufp_save;
		if(a_get1operand(&op)){
			return -1;	/* error	*/
		}
		if(op.type>=T1 && op.type<=T3){		/* div reg	*/
			if(a_op_TYPE6_a(value, &op)){
				return -1;	/* error	*/
			}
		}
		else{
			a_error_message(E_SYNTAX_ERROR, __LINE__);
			return -1;	/* error	*/
		}
	}
	a_objout();
	return 0;	/* success	*/
}

/*	int imm		*/
int a_op_TYPE7(unsigned int value)
{
	unsigned int v;
	
	a_inst[0] = value;
	if(a_expr(&v)){
		return -1;	/* error	*/
	}
	a_inst[1] = v;
	a_inst_ptr = 2;
	a_objout();
	return 0;	/* success	*/
}

/*	jb addr		*/
int a_op_TYPE8(unsigned int value)
{
	unsigned int value2;
	
	if(a_expr(&value2)){
		return -1;	/* error	*/
	}
	*(short*)&a_inst[0] = value;
	*(int*)&a_inst[2] = value2 - (*a_addr+6);
	a_inst_ptr = 6;
	a_objout();
	return 0;	/* success	*/
}

/*	mov [0x12345678],al	*/
int a_op_TYPE9_a(struct operand *op1, struct operand *op2)
{
	if(op2->type==T1){		/* mov [0x12345678],al		*/
		a_inst[0] = 0xa2;
		*(int*)&a_inst[1] = op1->value;
		a_inst_ptr = 5;
	}
	else if(op2->type==T2){		/* mov [0x12345678],ax		*/
		a_inst[0] = 0x66;
		a_inst[1] = 0xa2 | 1;
		*(int*)&a_inst[2] = op1->value;
		a_inst_ptr = 6;
	}
	else if(op2->type==T3){		/* mov [0x12345678],eax		*/
		a_inst[0] = 0xa2 | 1;
		*(int*)&a_inst[1] = op1->value;
		a_inst_ptr = 5;
	}
	else{
		a_error_message(E_SYNTAX_ERROR, __LINE__);
		return -1;	/* error	*/
	}
	return 0;	/* success	*/
}

/*	mov al,[0x12345678]	*/
int a_op_TYPE9_b(struct operand *op1, struct operand *op2)
{
	if(op1->type==T1){		/* mov al,[0x12345678]		*/
		a_inst[0] = 0xa0;
		*(int*)&a_inst[1] = op2->value;
		a_inst_ptr = 5;
	}
	else if(op1->type==T2){		/* mov ax,[0x12345678]		*/
		a_inst[0] = 0x66;
		a_inst[1] = 0xa0 | 1;
		*(int*)&a_inst[2] = op2->value;
		a_inst_ptr = 6;
	}
	else if(op1->type==T3){		/* mov eax,[0x12345678]		*/
		a_inst[0] = 0xa0 | 1;
		*(int*)&a_inst[1] = op2->value;
		a_inst_ptr = 5;
	}
	else{
		a_error_message(E_SYNTAX_ERROR, __LINE__);
		return -1;	/* error	*/
	}
	return 0;	/* success	*/
}

/*	mov reg,0x1234		*/
int a_op_TYPE9_c(struct operand *op1, struct operand *op2)
{
	if(op1->type==T1){		/* mov byte reg,imm	*/
		a_inst[0] = 0xb0 | op1->reg_numb;
		a_inst[1] = op2->value;
		a_inst_ptr = 2;
	}
	else if(op1->type==T2){		/* mov word reg,imm	*/
		a_inst[0] = 0x66;
		a_inst[1] = 0xb0 | 0x08 | op1->reg_numb;
		*(short*)&a_inst[2] = op2->value;
		a_inst_ptr = 4;
	}
	else if(op1->type==T3){		/* mov dword reg,imm	*/
		a_inst[0] = 0xb0 | 0x08 | op1->reg_numb;
		*(int*)&a_inst[1] = op2->value;
		a_inst_ptr = 5;
	}
	else{
		a_error_message(E_SYNTAX_ERROR, __LINE__);
		return -1;	/* error	*/
	}
	return 0;	/* success	*/
}

/*	mov EA,0x1234	*/
/*	return 0:この項目ではない	*/
int a_op_TYPE9_d()
{
	struct operand op1, op2;
	int b_w_d, numb;
	char *linebufp_save;
	
	linebufp_save = a_linebufp;
	a_spskip();
	if(is_symtop()==0){
		return 0;
	}
	if(a_getsym()){
		return -1;	/* error	*/
	}
	numb = a_symsrch();
	if(numb>=0 && a_symtbl[numb].type==TYPE_B_W_D){
		b_w_d = a_symtbl[numb].value;
		if(a_get1operand(&op1)){
			return -1;	/* error	*/
		}
		if(op1.type>=T20 && op1.type<=T25){	/* dec EA	*/
			if(a_op_TYPE5_b(0x00c600, b_w_d, &op1)){
				return -1;	/* error	*/
			}
		}
		else{
			a_error_message(E_SYNTAX_ERROR, __LINE__);
			return -1;	/* error	*/
		}
		a_spskip();
		if(*a_linebufp != ','){
			a_error_message(E_SYNTAX_ERROR, __LINE__);
			return -1;	/*	error	*/
		}
		a_linebufp++;
		if(a_get1operand(&op2)){
			return -1;	/* error	*/
		}
		if(op2.type<T10 || op2.type>T12){	/* 定数 でない	*/
			a_error_message(E_SYNTAX_ERROR, __LINE__);
			return -1;	/* error	*/
		}
		if(b_w_d==1){		/* byte		*/
			a_inst[a_inst_ptr] = op2.value;
			a_inst_ptr++;
		}
		else if(b_w_d==2){	/* word		*/
			*(short*)&a_inst[a_inst_ptr] = op2.value;
			a_inst_ptr += 2;
		}
		else if(b_w_d==3){	/* dword	*/
			*(int*)&a_inst[a_inst_ptr] = op2.value;
			a_inst_ptr += 4;
		}
	}
	else{
		a_linebufp = linebufp_save;
		return 0;
	}
	return 1;
}

/*	mov	*/
int a_op_TYPE9()
{
	struct operand op1, op2;
	
	/*	mov EA,0x1234	*/
	if(a_op_TYPE9_d()){
		a_objout();
		return 0;	/* success	*/
	}
	if(a_get1operand(&op1)){
		return -1;	/* error	*/
	}
	a_spskip();
	if(*a_linebufp != ','){
		a_error_message(E_SYNTAX_ERROR, __LINE__);
		return -1;	/* error	*/
	}
	a_linebufp++;
	if(a_get1operand(&op2)){
		return -1;	/* error	*/
	}
	
	if(op1.type==T22 && op1.ea1==0x05 && op2.type>=T1 && op2.type<=T3 && op2.reg_numb==0){
		/*	mov [0x12345678],al	*/
		if(a_op_TYPE9_a(&op1, &op2)){
			return -1;	/* error	*/
		}
	}
	else if(op1.type>=T1 && op1.type<=T3 && op1.reg_numb==0 && op2.type==T22 && op2.ea1==0x05){
		/*	mov al,[0x12345678]	*/
		if(a_op_TYPE9_b(&op1, &op2)){
			return -1;	/* error	*/
		}
	}
	else if(op1.type>=T1 && op1.type<=T3 && op2.type>=T10 && op2.type<=T12){
		/*	mov reg,0x1234		*/
		if(a_op_TYPE9_c(&op1, &op2)){
			return -1;	/* error	*/
		}
	}
	else if(op1.type>=T1 && op1.type<=T3 && op2.type>=T20 && op2.type<=T25){
		/*	mov reg,EA	*/
		if(a_op_TYPE3_c(0x88, &op1, &op2)){
			return -1;	/* error	*/
		}
	}
	else if(op1.type>=T20 && op1.type<=T25 && op2.type>=T1 && op2.type<=T3){
		/*	mov EA,reg	*/
		if(a_op_TYPE3_d(0x88, &op1, &op2)){
			return -1;	/* error	*/
		}
	}
	else if(op1.type>=T1 && op1.type<=T3 && op2.type>=T1 && op2.type<=T3){
		/*	mov reg1,reg2	*/
		if(a_op_TYPE3_b(0x88, &op1, &op2)){
			return -1;	/* error	*/
		}
	}
	else{
		a_error_message(E_SYNTAX_ERROR, __LINE__);
		return -1;	/* error	*/
	}
	a_objout();
	return 0;	/* success	*/
}

/*	pop reg, pop EA		*/
int a_op_TYPE10(unsigned int value)
{
	struct operand op;
	int b_w_d, numb;
	char *linebufp_save;
	
	linebufp_save = a_linebufp;
	if(a_getsym()){
		return -1;	/* error	*/
	}
	numb = a_symsrch();
	if(numb>=0 && a_symtbl[numb].type==TYPE_B_W_D){
		b_w_d = a_symtbl[numb].value;
		if(a_get1operand(&op)){
			return -1;	/* error	*/
		}
		if(op.type>=T20 && op.type<=T25 && b_w_d != 1){	/* div EA	*/
			if(a_op_TYPE5_b(value, b_w_d, &op)){
				return -1;	/* error	*/
			}
		}
		else{
			a_error_message(E_SYNTAX_ERROR, __LINE__);
			return -1;	/* error	*/
		}
	}
	else{
		a_linebufp = linebufp_save;
		if(a_get1operand(&op)){
			return -1;	/* error	*/
		}
		if(op.type>=/*T1*/ T2 && op.type<=T3){		/* div reg	*/
			if(a_op_TYPE5_a(value, &op)){
				return -1;	/* error	*/
			}
		}
		else{
			a_error_message(E_SYNTAX_ERROR, __LINE__);
			return -1;	/* error	*/
		}
	}
	a_objout();
	return 0;	/* success	*/
}

/*	rcl EA,1  rcl EA,cl	*/
int a_op_TYPE11(unsigned int value)
{
	struct operand op, op2;
	int b_w_d, numb, or_flag;
	char *linebufp_save;
	
	linebufp_save = a_linebufp;
	if(a_getsym()){
		return -1;	/* error	*/
	}
	numb = a_symsrch();
	if(numb>=0 && a_symtbl[numb].type==TYPE_B_W_D){
		b_w_d = a_symtbl[numb].value;
		if(a_get1operand(&op)){
			return -1;	/* error	*/
		}
		a_spskip();
		if(*a_linebufp++ != ','){
			a_error_message(E_SYNTAX_ERROR, __LINE__);
			return -1;	/* error	*/
		}
		if(a_get1operand(&op2)){
			return -1;	/* error	*/
		}
		if(op2.type==T10 && op2.value==1){		/* 1	*/
			or_flag = 0;
		}
		else if(op2.type==T1 && op2.reg_numb==1){	/* cl	*/
			or_flag = 2;
		}
		if(op.type>=T20 && op.type<=T25){	/* rcl EA,---	*/
			if(a_op_TYPE5_b((value | or_flag)<<8, b_w_d, &op)){
				return -1;	/* error	*/
			}
		}
		else{
			a_error_message(E_SYNTAX_ERROR, __LINE__);
			return -1;	/* error	*/
		}
	}
	else{
		a_linebufp = linebufp_save;
		if(a_get1operand(&op)){
			return -1;	/* error	*/
		}
		a_spskip();
		if(*a_linebufp++ != ','){
			a_error_message(E_SYNTAX_ERROR, __LINE__);
			return -1;	/* error	*/
		}
		if(a_get1operand(&op2)){
			return -1;	/* error	*/
		}
		if(op2.type==T10 && op2.value==1){		/* 1	*/
			or_flag = 0;
		}
		else if(op2.type==T1 && op2.reg_numb==1){	/* cl	*/
			or_flag = 2;
		}
		if(op.type>=T1 && op.type<=T3){		/* rcl reg,---	*/
			if(a_op_TYPE6_a(value | or_flag, &op)){
				return -1;	/* error	*/
			}
		}
		else{
			a_error_message(E_SYNTAX_ERROR, __LINE__);
			return -1;	/* error	*/
		}
	}
	a_objout();
	return 0;	/* success	*/
}

/*	ret   ret imm		*/
int a_op_TYPE12(unsigned int value)
{
	unsigned int v;
	
	a_spskip();
	if(*a_linebufp==0 || *a_linebufp==';'){
		a_inst[0] = value;
		a_inst_ptr = 1;
	}
	else{
		a_inst[0] = value>>8;
		if(a_expr(&v)){
			return -1;	/* error	*/
		}
		*(short*)&a_inst[1] = v;
		a_inst_ptr = 3;
	}
	a_objout();
	return 0;	/* success	*/
}

/*	test ...	*/
int a_op_TYPE13(unsigned int value)
{
	struct operand op1, op2;
	char *linebufp_save;
	
	linebufp_save = a_linebufp;
	if(a_get1operand(&op1)){
		return -1;	/* error	*/
	}
	a_spskip();
	if(*a_linebufp != ','){
		a_error_message(E_SYNTAX_ERROR, __LINE__);
		return -1;	/* error	*/
	}
	a_linebufp++;
	if(a_get1operand(&op2)){
		return -1;	/* error	*/
	}
	
	if(op1.type>=T1 && op1.type<=T3 && op2.type>=T1 && op2.type<=T3){
		/*	add reg1,reg2	*/
		if(a_op_TYPE3_b(value, &op1, &op2)){
			return -1;	/* error	*/
		}
	}
	else if(op1.type>=T1 && op1.type<=T3 && op2.type>=T20 && op2.type<=T25){
		/*	add reg,EA	*/
		if(a_op_TYPE3_c(value, &op1, &op2)){
			return -1;	/* error	*/
		}
	}
	else if(op1.type>=T20 && op1.type<=T25 && op2.type>=T1 && op2.type<=T3){
		/*	add EA,reg	*/
		if(a_op_TYPE3_d(value, &op1, &op2)){
			return -1;	/* error	*/
		}
	}
	else{
		a_linebufp = linebufp_save;
		return a_op_TYPE3(value);
	}
	if(a_inst[0]==0x66){
		a_inst[1] &= ~2;
	}
	else{
		a_inst[0] &= ~2;
	}
	a_objout();
	return 0;	/* success	*/
}

/*	xchg acc,reg  xchg reg,reg  xchg reg,EA  xchg EA,reg	*/
int a_op_TYPE14(unsigned int value)
{
	struct operand op1, op2, tmp;
	
	if(a_get1operand(&op1)){
		return -1;	/* error	*/
	}
	a_spskip();
	if(*a_linebufp++ != ','){
		a_error_message(E_SYNTAX_ERROR, __LINE__);
		return -1;	/* error	*/
	}
	if(a_get1operand(&op2)){
		return -1;	/* error	*/
	}
	if(op1.type>=T1 && op1.type<=T3 && op2.type>=T1 && op2.type<=T3){
		/*	xchg reg1,reg2	*/
		if(op1.type != op2.type){
			a_error_message(E_SYNTAX_ERROR, __LINE__);
			return -1;	/* error	*/
		}
		if(op2.reg_numb==0){		/* acc なら	*/
			tmp = op1;
			op1 = op2;
			op2 = tmp;
		}
		if(op1.type==T2 && op1.reg_numb==0){	/* xchg AX,reg		*/
			a_inst[0] = 0x66;
			a_inst[1] = value | op2.reg_numb;
			a_inst_ptr = 2;
		}
		else if(op1.type==T3 && op1.reg_numb==0){	/* xchg eax,reg	*/
			a_inst[0] = value | op2.reg_numb;
			a_inst_ptr = 1;
		}
		else{		/* xchg reg,reg		*/
			if(a_op_TYPE3_b(value>>8, &op1, &op2)){
				return -1;	/* success	*/
			}
		}
	}
	else if(op1.type>=T1 && op1.type<=T3 && op2.type>=T20 && op2.type<=T25){
		/*	xchg reg,EA	*/
		if(a_op_TYPE3_c(value>>8, &op1, &op2)){
			return -1;	/* error	*/
		}
	}
	else if(op1.type>=T20 && op1.type<=T25 && op2.type>=T1 && op2.type<=T3){
		/*	xchg EA,reg	*/
		if(a_op_TYPE3_d(value>>8, &op1, &op2)){
			return -1;	/* error	*/
		}
	}
	
	a_objout();
	return 0;	/* success	*/
}

/*	section	.text		*/
/*	org	0		*/
/*	section .data		*/
/*	org	0x10000		*/

/*	type 2: section		*/
/*		| len | 2 | section numb |      len=2, section numb 1byte	*/

int a_op_TYPE_SECTION()
{
	int i;
	
	if(a_getsym()){		/* a_symbuf = section 名	*/
		return -1;	/* error	*/
	}
	for(i=0; i<a_section_ptr; i++){
		if(strcmp(a_symbuf, a_section[i].symbol)==0){
			a_section_numb = i;
			a_addr = &a_section[i].addr;
			a_objfile[a_objfile_ptr++] = 2;
			a_objfile[a_objfile_ptr++] = 2;
			a_objfile[a_objfile_ptr++] = i;
			return 0;	/* success	*/
		}
	}
	strcpy(a_section[a_section_ptr].symbol, a_symbuf);
	a_section_numb = a_section_ptr;
	a_addr = &a_section[a_section_ptr].addr;
	a_objfile[a_objfile_ptr++] = 2;
	a_objfile[a_objfile_ptr++] = 2;
	a_objfile[a_objfile_ptr++] = a_section_ptr;
	a_section_ptr++;
	return 0;	/* success	*/
}

int a_op_ORG()
{
	return a_expr(a_addr);
}

int a_op_EQU()
{
	int numb;
	unsigned int value;
	char *linebufp_save;
	
	linebufp_save = a_linebufp;
	a_linebufp = a_linebuf;
	if(a_getsym()){		/* label get	*/
		return -1;	/* error	*/
	}
	numb = a_symsrch();
	if(numb < 0){
		a_error_message(E_INTERNAL_ERROR, __LINE__);
		return -1;	/* error	*/
	}
	a_linebufp = linebufp_save;
	
	if(a_expr(&value)){
		return -1;	/* error	*/
	}
	if(a_symtbl[numb].type==TYPE_EQU){
		if(value != a_symtbl[numb].value){
			a_chg_flag = 1;		/* シンボルが再定義で変化した	*/
		}
	}
	a_symtbl[numb].value = value;
	a_symtbl[numb].type  = TYPE_EQU;
	
	*(unsigned int *)a_inst = a_symtbl[numb].value;
	a_inst_ptr = 4;
	a_listout();
	a_inst_ptr = 0;
	return 0;	/* success	*/
}

int a_op_DB()
{
	int first;
	unsigned int v;
	
	first = 1;
	for(;;){
		if(a_expr(&v)){
			return -1;	/* error	*/
		}
		a_inst[a_inst_ptr++] = v;
		
		if(a_inst_ptr >= 10){
			if(first){
				first = 0;
				a_listout();
			}
			else{
				a_listout_nosrc();
			}
			a_objout();
			*a_addr += a_inst_ptr;
			a_inst_ptr = 0;
		}
		a_spskip();
		if(*a_linebufp != ','){
			if(a_inst_ptr){
				if(first){
					first = 0;
					a_listout();
				}
				else{
					a_listout_nosrc();
				}
				a_objout();
				*a_addr += a_inst_ptr;
				a_inst_ptr = 0;
			}
			return 0;	/* success	*/
		}
		a_linebufp++;
	}
}

int a_op_DD()
{
	int first;
	unsigned int v;
	
	first = 1;
	for(;;){
		if(a_expr(&v)){
			return -1;	/* error	*/
		}
		*(unsigned int *)&a_inst[a_inst_ptr] = v;
		a_inst_ptr += 4;
		
		if(a_inst_ptr >= 8){
			if(first){
				first = 0;
				a_listout();
			}
			else{
				a_listout_nosrc();
			}
			a_objout();
			*a_addr += a_inst_ptr;
			a_inst_ptr = 0;
		}
		a_spskip();
		if(*a_linebufp != ','){
			if(a_inst_ptr){
				if(first){
					first = 0;
					a_listout();
				}
				else{
					a_listout_nosrc();
				}
				a_objout();
				*a_addr += a_inst_ptr;
				a_inst_ptr = 0;
			}
			return 0;	/* success	*/
		}
		a_linebufp++;
	}
}

int a_op_DW()
{
	int first;
	unsigned int v;
	
	first = 1;
	for(;;){
		if(a_expr(&v)){
			return -1;	/* error	*/
		}
		*(unsigned short *)&a_inst[a_inst_ptr] = v;
		a_inst_ptr += 2;
		
		if(a_inst_ptr >= 10){
			if(first){
				first = 0;
				a_listout();
			}
			else{
				a_listout_nosrc();
			}
			a_objout();
			*a_addr += a_inst_ptr;
			a_inst_ptr = 0;
		}
		a_spskip();
		if(*a_linebufp != ','){
			if(a_inst_ptr){
				if(first){
					first = 0;
					a_listout();
				}
				else{
					a_listout_nosrc();
				}
				a_objout();
				*a_addr += a_inst_ptr;
				a_inst_ptr = 0;
			}
			return 0;	/* success	*/
		}
		a_linebufp++;
	}
}

//#################################################################################

int a_label_process()
{
	int numb;
	
	if(a_getsym()){		/* symbuf = label */
		return -1;	/* error	*/
	}
	if(*a_linebufp==':'){
		a_linebufp++;
	}
	if(a_pass==1){		/* pass1 ならばラベルを登録する */
		numb = a_symsrch();
		if(numb >= 0){
			a_error_message(E_MULTIPLE_DEFINITION, __LINE__);
			return -1;	/* error	*/
		}
		/*	シンボル登録	*/
		strcpy(a_symtbl[a_symtbl_ptr].symbol, a_symbuf);
		a_symtbl[a_symtbl_ptr].type = TYPE_SYMBOL;
		a_symtbl[a_symtbl_ptr].value = *a_addr;
		a_symtbl_ptr++;
	}
	else if(a_pass==2){	/* シンボル再定義フェーズ	*/
		numb = a_symsrch();
		if(numb < 0){
			a_error_message(E_UNDEFINED_SYMBOL, __LINE__);
			return -1;	/* error	*/
		}
		if(a_symtbl[numb].type==TYPE_SYMBOL){
			if(*a_addr != a_symtbl[numb].value){
				a_chg_flag = 1;		/* シンボルが再定義で変化した	*/
			}
			a_symtbl[numb].value = *a_addr;
		}
	}
	return 0;	/* success	*/
}

/*	return 0:norml listout, 1:no listout, -1:error	*/
int a_opcode()
{
	int numb;
	unsigned int v;
	
	if(a_getsym()){		/* symbuf = op code */
		return -1;	/* error	*/
	}
	numb = a_symsrch();
	if(numb < 0){
		printf("%s  ", a_symbuf);
		a_error_message(E_UNDEFINED_SYMBOL, __LINE__);
		return -1;	/* error	*/
	}
	a_inst_ptr = 0;
	v = a_symtbl[numb].value;
	switch(a_symtbl[numb].type){
		case TYPE1:		/* 1バイト固定 */
			a_op_TYPE1(v);
			break;
		case TYPE2:		/* 2バイト固定 */
			a_op_TYPE2(v);
			break;
		case TYPE3:		/* EA, acc imm, EA imm */
			if(a_op_TYPE3(v)){
				return -1;	/* error	*/
			}
			break;
		case TYPE4:		/* call xxxx		*/
			if(a_op_TYPE4(v)){
				return -1;	/* error	*/
			}
			break;
		case TYPE5:		/* dec reg,   dec EA	*/
			if(a_op_TYPE5(v)){
				return -1;	/* error	*/
			}
			break;
		case TYPE6:		/* div EA		*/
			if(a_op_TYPE6(v)){
				return -1;	/* error	*/
			}
			break;
		case TYPE7:		/* int imm		*/
			if(a_op_TYPE7(v)){
				return -1;	/* error	*/
			}
			break;
		case TYPE8:		/* jb addr	*/
			if(a_op_TYPE8(v)){
				return -1;	/* error	*/
			}
			break;
		case TYPE9:		/* mov		*/
			if(a_op_TYPE9()){
				return -1;
			}
			break;
		case TYPE10:		/* pop reg, pop EA	*/
			if(a_op_TYPE10(v)){
				return -1;	/* error	*/
			}
			break;
		case TYPE11:		/* rcl EA,1  rcl EA,cl	*/
			if(a_op_TYPE11(v)){
				return -1;	/* error	*/
			}
			break;
		case TYPE12:		/* ret   ret imm	*/
			if(a_op_TYPE12(v)){
				return -1;	/* error	*/
			}
			break;
		case TYPE13:		/* test ...		*/
			if(a_op_TYPE13(v)){
				return -1;	/* error	*/
			}
			break;
		case TYPE14:		/* xchg acc,reg  xchg reg,EA  xchg EA,reg	*/
			if(a_op_TYPE14(v)){
				return -1;	/* error	*/
			}
			break;
		case TYPE_DB:
			if(a_op_DB()){
				return -1;	/* error	*/
			}
			return 1;	/* no listout	*/
		case TYPE_DD:
			if(a_op_DD()){
				return -1;	/* error	*/
			}
			return 1;	/* no listout	*/
		case TYPE_DW:
			if(a_op_DW()){
				return -1;	/* error	*/
			}
			return 1;	/* no listout	*/
		case TYPE_EQU:
			if(a_op_EQU()){
				return -1;	/* success	*/
			}
			return 1;	/* no listout	*/
		case TYPE_ORG:
			if(a_op_ORG()){
				return -1;
			}
			break;
		case TYPE_SECTION:
			if(a_op_TYPE_SECTION()){
				return -1;	/* error	*/
			}
			break;
		default:
			a_error_message(E_SYNTAX_ERROR, __LINE__);
			return -1;	/* error	*/
	}
	return 0;	/* nomal listout */
}

int a_asm()
{
	int ret;
	
	for(a_linenumb=1; ; a_linenumb++){
		if(a_srcfile_ptr >= a_srcfile_len){	/* 入力ファイル末端 */
			return 0;	/* success	*/
		}
		a_get1line();		/* 1行入力 */

		a_inst_ptr = 0;
		if(is_symtop()){	/* label が有る */
			if(a_label_process()){
				return -1;	/* error	*/
			}
		}

		a_spskip();
		if(*a_linebufp==0 || *a_linebufp==';'){	/* label の後が行末 */
			a_listout();
			continue;
		}

		ret = a_opcode();	/* オペコード処理, ret:0 normal listout, ret:1 no linstout, ret:-1 error */
		if(ret== -1){
			return -1;	/* error	*/
		}
		a_spskip();
		if(*a_linebufp==0 || *a_linebufp==';'){	/* 行末 */
			if(ret==0){
				a_listout();
				*a_addr += a_inst_ptr;
			}
			continue;
		}
		a_error_message(E_LINEEND, __LINE__);
		return -1;	/* error	*/
	}
}

int registration()
{
	int i, numb;
	
	for(i=0; a_sym_code[i].symbol; i++){
		strcpy(a_symbuf, a_sym_code[i].symbol);
		numb = a_symsrch();
		if(numb >= 0){
			printf("registration %s *** MULTILPLE_DEFINITION\n", a_sym_code[i].symbol);
			return -1;	/* error	*/
		}
		/*	シンボル登録	*/
		strcpy(a_symtbl[a_symtbl_ptr].symbol, a_symbuf);
		a_symtbl[a_symtbl_ptr].type = a_sym_code[i].type;
		a_symtbl[a_symtbl_ptr].value = a_sym_code[i].value;
		a_symtbl_ptr++;
	}
	return 0;	/* success	*/
}

int a_binout(unsigned int *addr_top, unsigned int *addr_end)
{
	unsigned int addr;
	int i, j, len, type;
	
	*addr_top = 0xffffffff;
	*addr_end = 0;
	for(i=0; i<a_objfile_ptr; ){
		len = a_objfile[i++];
		type = a_objfile[i++];
		if(type==1){
			len -= 1+4;	/* type と addr カウント	*/
			addr = *(unsigned int*)&a_objfile[i];
			i += 4;
			for(j=0; j<len; j++){
				if(addr < *addr_top){
					*addr_top = addr;
				}
				if(addr > *addr_end){
					*addr_end = addr;
				}
				if(a_bindata[addr]==0){
					printf("*** obj addr overlap %x\n", addr);
					return -1;	/* error	*/
				}
				a_bindata[addr] = 0;
				a_binfile[addr] = a_objfile[i++];
				addr++;
			}
		}
		else if(type==2){
			i += len-1;
		}
		else{
			printf("*** obj file type error %d\n", type);
			return -1;	/* error	*/
		}
	}
	if(*addr_end < *addr_top){
		*addr_end = *addr_top = 0;
	}
	else{
		(*addr_end)++;
	}
	return 0;	/* success	*/
}


#ifndef SELF_ASSEMBLER
int main(int argc, char *argv[])
{
	int i;
//	unsigned int addr_top, addr_end;
	int fd;
	
	a_srcfile = (char*)malloc(1024*1024);
	a_objfile = (unsigned char*)malloc(1024*1024);
	a_binfile = (unsigned char*)malloc(1024*1024);
	a_bindata = (unsigned char*)malloc(1024*1024);
	if(a_objfile==0 || a_binfile==0 || a_bindata==0){
		printf("*** out of memory\n");
		return -1;
	}
	if(argc != 2){
		printf("> asm80386 <srcfile>\n");
		return -1;
	}
	fd = _open(argv[1], O_RDONLY);
	if(fd<0){
		printf("*** file open error\n");
		return -1;
	}
	a_srcfile_len = _read(fd, a_srcfile, 1024*1024);
	_close(fd);
#else
int asm_main()
{
//	unsigned int addr_top, addr_end;

	a_srcfile = sed_buf;
	a_objfile = (unsigned char*)memman_alloc(1024*1024);
	a_binfile = (unsigned char*)memman_alloc(1024*1024);
	a_bindata = (unsigned char*)memman_alloc(1024*1024);
	if(a_objfile==0 || a_binfile==0 || a_bindata==0){
		printf("*** out of memory\n");
		return -1;
	}
	a_srcfile_len = strlen(a_srcfile);
#endif

	memset(a_binfile, 0, 1024*1024);
	memset(a_bindata, 0xff, 1024*1024);
	memset(a_symtbl, 0, sizeof(a_symtbl));
	a_symtbl_ptr = 0;
	if(registration()){
		return -1;	/* error	*/
	}
	memset(a_section, 0, sizeof(a_section));
	a_section_ptr = 0;
	a_objfile_ptr = 0;
//	a_binfile_ptr = 0;
	a_addr = &a_section[0].addr;
	a_srcfile_ptr = 0;

	printf("[PASS1]\n");
	a_pass = 1;		/* アドレス計算、シンボル登録 */
	if(a_asm()){
		return -1;	/* error	*/
	}

	for(;;){
		printf("[PASS2]\n");
		a_addr = &a_section[0].addr;
		a_srcfile_ptr = 0;
		memset(a_section, 0, sizeof(a_section));
		a_section_ptr = 0;
		a_objfile_ptr = 0;
		a_pass = 2;		/* シンボル再定義 */
		a_chg_flag = 0;
		if(a_asm()){
			return -1;	/* error	*/
		}
		if(a_chg_flag==0){	/* シンボル定義が変化していない	*/
			break;
		}
	}
	
	printf("[PASS3]\n");
	a_addr = &a_section[0].addr;
	a_srcfile_ptr = 0;
	memset(a_section, 0, sizeof(a_section));
	a_section_ptr = 0;
	a_objfile_ptr = 0;
	a_pass = 3;		/* コード生成 */
	if(a_asm()){
		return -1;	/* error	*/
	}
	
	/*	bin 作成	*/
	if(a_binout(&a_addr_top, &a_addr_end)){
		return -1;	/* error	*/
	}
	
#ifndef SELF_ASSEMBLER
	/*	file output	*/
	char *ptr;
	char name[256];
	
	strcpy(name, argv[1]);
	ptr = strrchr(name, '.');
	if(ptr){
		strcpy(ptr, ".obj");
	}
	else{
		strcat(name, ".obj");
	}
	fd = _open(name, O_WRONLY|O_BINARY|O_TRUNC|O_CREAT, 0777);
	if(fd<0){
		printf("*** obj file open error\n");
		return -1;
	}
	_write(fd, a_objfile, a_objfile_ptr);
	_close(fd);
	
	ptr = strrchr(name, '.');
	if(ptr){
		strcpy(ptr, ".bin");
	}
	else{
		strcat(name, ".bin");
	}
	fd = _open(name, O_WRONLY|O_BINARY|O_TRUNC|O_CREAT, 0777);
	if(fd<0){
		printf("*** obj file open error\n");
		return -1;
	}
	_write(fd, &a_binfile[a_addr_top], a_addr_end-a_addr_top);
	_close(fd);
#else
//	for(i=a_addr_top; i<a_addr_end; i++){
//		if(i%16==15){
//			printf("\n");
//		}
//		printf("%02x ", a_binfile[i]);
//	}
//	printf("\n");
#endif

	printf("srcfile %d/%d\n", a_srcfile_ptr, 1024*1024);
	printf("objfile %d/%d\n", a_objfile_ptr, 1024*1024);
	printf("binfile %d/%d\n", a_addr_end, 1024*1024);
	printf("symtbl  %d/%d\n", a_symtbl_ptr, SYM_TBL_LEN);
	printf("section %d/%d\n", a_section_ptr, SECTION_TBL_LEN);
	printf("=== success\n");
	return 0;
}
