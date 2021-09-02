#!/bin/sh
#!/bin/sh -x

rm boot_loader.bin
rm boot_loader.lst
rm key_mouse.bin
rm key_mouse.lst
rm os_start.bin
rm os_start.lst
rm asm_lib.o
rm asm_lib.lst

rm gonbe_rear.elf
rm gonbe_rear.srec
rm gonbe_rear.img
rm gonbe.img
rm gonbe_rear.map

rm gonbe_main.o
rm gonbe_main.s
rm gonbe_main_x.s
rm gonbe_main.lst

rm gdt-table-set.o
rm gdt-table-set.s
rm gdt-table-set_x.s
rm gdt-table-set.lst

rm font_lib.o
rm font_lib.s
rm font_lib_x.s
#rm font_lib.lst

rm sjis.o
rm sjis.s
rm sjis_x.s
rm sjis.lst

rm lib.o
rm lib.s
rm lib_x.s
rm lib.lst

rm sheet.o
rm sheet.s
rm sheet_x.s
rm sheet.lst

rm string.o
rm string.s
rm string_x.s
rm string.lst

rm graphic.o
rm graphic.s
rm graphic_x.s
rm graphic.lst

rm timer.o
rm timer.s
rm timer_x.s
rm timer.lst

rm fifo.o
rm fifo.s
rm fifo_x.s
rm fifo.lst

rm mtask.o
rm mtask.s
rm mtask_x.s
rm mtask.lst

rm delay_task.o
rm delay_task.s
rm delay_task_x.s
rm delay_task.lst

rm sys_call.o
rm sys_call.s
rm sys_call_x.s
rm sys_call.lst

rm make_thread.o
rm make_thread.s
rm make_thread_x.s
rm make_thread.lst

rm command.o
rm command.s
rm command_x.s
rm command.lst

rm sedit.o
rm sedit.s
rm sedit_x.s
rm sedit.lst

rm asm80386.o
rm asm80386.s
rm asm80386_x.s
rm asm80386.lst

nasm -f bin -o boot_loader.bin -l boot_loader.lst boot_loader.nasm
nasm -f bin -o key_mouse.bin -l key_mouse.lst key_mouse.nasm
nasm -f bin -o os_start.bin -l os_start.lst os_start.nasm
nasm -f elf32 -o asm_lib.o -l asm_lib.lst asm_lib.nasm

gcc -x c -c -O0 -Werror -Wall -o gonbe_main.s -S gonbe_main.c 
gcc -x c -c -O0 -Werror -Wall -o font_lib.s -S font_lib.c 
gcc -x c -c -O0 -Werror -Wall -o sjis.s -S sjis.c 
gcc -x c -c -O0 -Werror -Wall -o lib.s -S lib.c 
gcc -x c -c -O0 -Werror -Wall -o gdt-table-set.s -S gdt-table-set.c
gcc -x c -c -O0 -Werror -Wall -o graphic.s -S graphic.c
gcc -x c -c -O0 -Werror -Wall -o sheet.s -S sheet.c
gcc -x c -c -O0 -Werror -Wall -o string.s -S string.c
gcc -x c -c -O0 -Werror -Wall -o timer.s -S timer.c
gcc -x c -c -O0 -Werror -Wall -o fifo.s -S fifo.c
gcc -x c -c -O0 -Werror -Wall -o mtask.s -S mtask.c
gcc -x c -c -O0 -Werror -Wall -o delay_task.s -S delay_task.c
gcc -x c -c -O0 -Werror -Wall -o sys_call.s -S sys_call.c
gcc -x c -c -O0 -Werror -Wall -o make_thread.s -S make_thread.c
gcc -x c -c -O0 -Werror -Wall -o command.s -S command.c
gcc -x c -c -O0 -Werror -Wall -o sedit.s -S sedit.c
gcc -x c -c -O0 -Werror -Wall -o asm80386.s -S asm80386.c

../tools/del_.rdata/del_.rdata gonbe_main.s gonbe_main_x.s
../tools/del_.rdata/del_.rdata font_lib.s font_lib_x.s
../tools/del_.rdata/del_.rdata sjis.s sjis_x.s
../tools/del_.rdata/del_.rdata lib.s lib_x.s
../tools/del_.rdata/del_.rdata gdt-table-set.s gdt-table-set_x.s
../tools/del_.rdata/del_.rdata graphic.s graphic_x.s
../tools/del_.rdata/del_.rdata sheet.s sheet_x.s
../tools/del_.rdata/del_.rdata string.s string_x.s
../tools/del_.rdata/del_.rdata timer.s timer_x.s
../tools/del_.rdata/del_.rdata fifo.s fifo_x.s
../tools/del_.rdata/del_.rdata mtask.s mtask_x.s
../tools/del_.rdata/del_.rdata delay_task.s delay_task_x.s
../tools/del_.rdata/del_.rdata sys_call.s sys_call_x.s
../tools/del_.rdata/del_.rdata make_thread.s make_thread_x.s
../tools/del_.rdata/del_.rdata command.s command_x.s
../tools/del_.rdata/del_.rdata sedit.s sedit_x.s
../tools/del_.rdata/del_.rdata asm80386.s asm80386_x.s

as -c -Wall -o gonbe_main.o gonbe_main_x.s > gonbe_main.lst
as -c -Wall -o font_lib.o font_lib_x.s > /dev/null
as -c -Wall -o sjis.o sjis_x.s > sjis.lst
as -c -Wall -o lib.o lib_x.s > lib.lst
as -c -Wall -o gdt-table-set.o gdt-table-set_x.s > gdt-table-set.lst
as -c -Wall -o graphic.o graphic_x.s > graphic.lst
as -c -Wall -o sheet.o sheet_x.s > sheet.lst
as -c -Wall -o string.o string_x.s > string.lst
as -c -Wall -o timer.o timer_x.s > timer.lst
as -c -Wall -o fifo.o fifo_x.s > fifo.lst
as -c -Wall -o mtask.o mtask_x.s > mtask.lst
as -c -Wall -o delay_task.o delay_task_x.s > delay_task.lst
as -c -Wall -o sys_call.o sys_call_x.s > sys_call.lst
as -c -Wall -o make_thread.o make_thread_x.s > make_thread.lst
as -c -Wall -o command.o command_x.s > command.lst
as -c -Wall -o sedit.o sedit_x.s > sedit.lst
as -c -Wall -o asm80386.o asm80386_x.s > asm80386.lst

gcc -o gonbe_rear.elf gonbe_main.o lib.o sjis.o asm_lib.o gdt-table-set.o graphic.o sheet.o string.o timer.o fifo.o mtask.o delay_task.o sys_call.o make_thread.o command.o sedit.o asm80386.o font_lib.o -nostdlib -Tlinker.ld -Wl,-Map=gonbe_rear.map
objcopy -O srec gonbe_rear.elf gonbe_rear.srec
../tools/srec_to_img_with_map/srec_to_img_with_map.exe gonbe_rear.srec gonbe_rear.img
cat boot_loader.bin key_mouse.bin os_start.bin gonbe_rear.img > gonbe.img


