#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <io.h>
#include <string.h>


char buf[1024];

int main(int argc, char *argv[])
{
	FILE *fpsrc, *fpdst;
	
	if(argc != 3){
		printf("*** $ del_.rdata <srcfile> <dstfile>\n");
		return 0;
	}
	fpsrc = fopen(argv[1], "r");
	fpdst = fopen(argv[2], "w");
	if(fpsrc==0 || fpdst==0){
		printf("*** file open error\n");
		return 0;
	}
	while(fgets(buf, 1024, fpsrc)){
		if(strstr(buf, ".section .rdata")){
			fprintf(fpdst, "	.data\n");
			continue;
		}
		fprintf(fpdst, "%s", buf);
	}
	
	fclose(fpsrc);
	fclose(fpdst);
	return 0;
}
