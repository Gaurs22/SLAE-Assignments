#!/usr/bin/python

print 'Usage: ./wrapper.py <port-no>' + '\n'
print 'Kindly use port greater than 1024'

print '\n'

import sys

shellcode=""; # Put shellcode here

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

print '\"' + encoded + '\"' + '\n' 
