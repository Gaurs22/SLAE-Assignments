#include<stdio.h>
#include<stdlib.h>
#include<string.h>

/* 
gshetty

Compilation : gcc -o RC5Decrypter RC5Decrypter
Execution   : ./RC5Decrypter <decryption_key>

*/

typedef unsigned long int WORD;

#define w 32
#define r 20
#define b 16
#define c 4
#define t 26

#define row  sizeof(encrypted_shellcode)/sizeof(encrypted_shellcode[0])


WORD S[t];

WORD P = 0xb7e15163 , Q=0x9e3779b9;	

#define ROTL(x,y) (((x) << (y & (w-1)) | ((x)) >> (w - (y & (w-1)))))

#define ROTR(x,y) (((x) >> (y & (w-1)) | ((x)) << (w - (y & (w-1)))))

void RC5Encrypt(WORD *pt , WORD *ct)
{

	WORD i;
	WORD A = pt[0] + S[0];
	WORD B = pt[1] + S[1];

	for (i = 1; i <= r; i++)
   	{
      		A = ROTL(A ^ B, B) + S[2*i];
      		B = ROTL(B ^ A, A) + S[2*i + 1];
   	}	
   
	ct[0] = A; ct[1] = B;
}

void RC5Decrypt(WORD *ct, WORD *pt)
{

	WORD i, B=ct[1], A=ct[0];
   
   	for (i = r; i > 0; i--)
   	{
      		B = ROTR(B - S[2*i + 1], A) ^ A;
      		A = ROTR(A - S[2*i], B) ^ B;
   	}
   
   	pt[1] = B - S[1]; pt[0] = A - S[0];
}

void RC5KeySchedule(unsigned char *K)
{
  
	 WORD i, j, k, u = w/8, A, B, L[c];
   
   	for (i = b-1, L[c-1] = 0; i != -1; i--)
      		L[i/u] = (L[i/u] << 8) + K[i];
   
   	for (S[0] = P, i = 1; i < t; i++)
      		S[i] = S[i-1] + Q;
   
   	for (A = B = i = j = k = 0; k < 3 * t; k++, i = (i+1) % t, j = (j+1) % c)
   	{
      		A = S[i] = ROTL(S[i] + (A + B), 3);
      		B = L[j] = ROTL(L[j] + (A + B), (A + B));
   	}
}

WORD encrypted_shellcode[][2] = \

{

{ 0x92e9595a , 0x174ce936 },
{ 0xcad6592 , 0xe4cf597d },
{ 0x897980ae , 0x4f8d19c0 },
{ 0x250176a8 , 0xc1de0a9b },
{ 0xf37aaf5a , 0xb674a8e3 },
{ 0x168582b3 , 0xfca4aedd },
{ 0xb8713a3f , 0xede30371 },
{ 0xe953d61d , 0xc18b4b13 },
{ 0xad79508b , 0x3d554e42 },
{ 0xec92380b , 0x6758a58b },
{ 0x56792a76 , 0xceeb949a },
{ 0x33f9e46f , 0xb2f438e0 },
{ 0x48d9b98 , 0x93629fa6 }

};

main (int argc , char *argv[])
{
	
	WORD i,j,pt1[2],pt2[2];
	unsigned char *key;
	int m,n,l=0,s=0,odd_test,key_length; 

	key=(unsigned char *)argv[1];	

	key_length = strlen(key);  // Accepts 16 characters encryption key

	if(key_length != 16)
	{
		printf("\nEntered Key length:%d bytes\n\nEncryption key length should be 16 bytes\n\nExiting.....!\n",(int)key_length);
		exit(2);
	}

	WORD ct[2] = {encrypted_shellcode[0][0] , encrypted_shellcode[0][1]};
	RC5KeySchedule(key);
	RC5Decrypt(ct ,pt1);

	printf("\nOriginal shellcode:\n\n\"");

	if (pt1[0] == 0x90)
	{
			odd_test=1;
			printf("\\x%02x" , (unsigned int)pt1[1]);
	}
	else
	{
		odd_test=0;
		printf("\\x%02x\\x%02x" , (unsigned int)pt1[0],(unsigned int)pt1[1]);
	}		

	for (m=1; m<row ; m++)
	{
			WORD ct[2] = {encrypted_shellcode[m][0] , encrypted_shellcode[m][1]};
			RC5KeySchedule(key);
			RC5Decrypt(ct ,pt1);
			printf("\\x%02x\\x%02x" , (unsigned int)pt1[0],(unsigned int)pt1[1]);
	}

	printf("\"\n\n");
}
