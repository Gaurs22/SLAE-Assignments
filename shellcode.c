/*

Compilation: gcc -fno-stack-protector -z execstack shellcode.c -o shellcode
Usage : ./shellcode
*/

#include<stdio.h>
#include<string.h>

unsigned char shellcode[] = \

"";  //Put your shellcode here 

main()
{
	
	printf("Shellcode length: %d\n",strlen(shellcode));

	int (*ret)() = (int(*)())shellcode;

	ret();
	
}
