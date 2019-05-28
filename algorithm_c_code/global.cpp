
#include "global.h"
#include <time.h>


FILE *in,*out;

int limit_reduce;

void *safealloc(size_t size) {
	void *temp;
	
	temp = malloc(size);
	if (temp == NULL)
		fprintf(stderr,"\nsafealloc: Out of memory. Aborting...\n");
	return temp;
}

 
void *safecalloc(size_t numels, size_t size) {
	void *temp;
	
	temp = calloc(numels, size);
	if (temp == NULL)
		fprintf(stderr,"\nsafecalloc: Out of memory. Aborting...\n");
	return temp;
}



  

double get_utime()
{
	return (double)clock()/CLOCKS_PER_SEC;
}