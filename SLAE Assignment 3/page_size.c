#include <stdio.h>
#include <unistd.h> /* sysconf(3) */

/*

Compilation : gcc -o page_size page_size.c
Execution   : ./page_size

*/

int main(void)
{
	printf("The page size for this system is %ld bytes.\n",
		sysconf(_SC_PAGESIZE)); /* _SC_PAGE_SIZE is OK too. */

	return 0;
}
