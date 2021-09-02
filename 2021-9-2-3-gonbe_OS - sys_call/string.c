#include "gonbe.h"
#include "function.h"


/********************************************************************************/
/*		memcpy																	*/
/********************************************************************************/
void *memcpy(void *dst, const void *src, unsigned int size)
{
	int i;
	unsigned char *dst1 = (unsigned char *)dst;
	unsigned char *src1 = (unsigned char *)src;
	
	for(i=0; i<size; i+=1){
		dst1[i] = src1[i];
	}
	return dst;
}
/********************************************************************************/
/*		memset																	*/
/********************************************************************************/
void *memset(void *dst, int data, unsigned int size)
{
	int i;
	unsigned char *dst1 = (unsigned char *)dst;
	
	for(i=0; i<size; i+=1){
		dst1[i] = data;
	}
	return dst;
}
/********************************************************************************/
/*		memcmp																	*/
/********************************************************************************/
int memcmp(const void *dst, const void *src, unsigned int size)
{
	int i;
	int tmp;
	unsigned char *dst1 = (unsigned char *)dst;
	unsigned char *src1 = (unsigned char *)src;
	
	for(i=0; i<size; i+=1){
		if((tmp = dst1[i]-src1[i]))
			return tmp;
	}
	return 0;
}
/********************************************************************************/
/*		memmove																*/
/********************************************************************************/
void *memmove(void *dst, const void *src, unsigned int cnt)
{
	int i;
	unsigned char *dst1 = (unsigned char *)dst;
	unsigned char *src1 = (unsigned char *)src;
	
	if((int)(dst1-src1) <= 0){
		for(i=0; i<cnt; i++){
			*dst1++ = *src1++;
		}
	}
	else{
		dst1 += (cnt-1);
		src1 += (cnt-1);
		for(i=0; i<cnt; i++){
			*dst1-- = *src1--;
		}
	}
	return dst;
}
/********************************************************************************/
/*		strcpy																	*/
/********************************************************************************/
char *strcpy(char *dst, char *src)
{
	int i;
	
	for(i=0; (dst[i] = src[i]); i+=1){
	}
	return dst;
}
/********************************************************************************/
/*		strlen																	*/
/********************************************************************************/
int strlen(char *str)
{
	int i;
	
	for(i=0; str[i]; i+=1)
		;
	return i;
}
/********************************************************************************/
/*		strcmp																	*/
/********************************************************************************/
int strcmp(char *dst, char *src)
{
	int i;
	int tmp;
	
	for(i=0; ; i+=1){
		if((tmp = (unsigned char)dst[i]-(unsigned char)src[i]))
			return tmp;
		if(src[i]==0)
			return 0;
	}
}
/********************************************************************************/
/*		strcat																	*/
/********************************************************************************/
char *strcat(char *dst, char *src)
{
	int i, j;
	
	for(i=0; dst[i]; i+=1){
	}
	for(j=0; (dst[i+j] = src[j]); j+=1){
	}
	return dst;
}
/********************************************************************************/
/*		strchr								*/
/********************************************************************************/
char *strchr(const char *str, int c)
{
	for(;;){
		if(*str==c){
			return (char*)str;
		}
		if(*str==0){
			return 0;
		}
		str++;
	}
}
/********************************************************************************/
/*		strrchr								*/
/********************************************************************************/
char *strrchr(const char *str, int c)
{
	char *pt;
	
	str = strchr(str, c);
	if(str==0){
		return 0;
	}
	for(;;){
		pt=strchr(str+1, c);
		if(pt==0){
			return (char*)str;
		}
		str = pt;
	}
}
/********************************************************************************/
/*		atoi								*/
/********************************************************************************/
int atoi(const char *str)
{
	int v, minus;
	
	while(*str==' ' || *str=='\t'){
		str++;
	}
	minus = 0;
	if(*str=='-'){
		minus = 1;
	}
	v = 0;
	while(*str>='0' && *str<='9'){
		v = v*10 + *str++ - '0';
	}
	if(minus){
		return -v;
	}
	return v;
}
