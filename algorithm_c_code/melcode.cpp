#include <stdio.h>
#include "global.h"
#include "bitio.h"

static J[32]={	0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,5,5,6,6,7,
	7,8,9,10,11,12,13,14,15 };

static int melcstate,melclen;
static unsigned long melcorder;

void init_process_run()
{
 
	melcstate=0;
	melclen=J[0];
	melcorder=1<<melclen;
}

 process_run(int runlen,int eoline)
{
	int hits=0;
	while (runlen>=melcorder)
	{
		hits++;
		runlen-=melcorder;
		if (melcstate<32)
		{
			melclen=J[++melcstate];
			melcorder=(1L<<melclen);
		}
	}
	PUT_ONES(hits);

	if(eoline==EOLINE)
	{
		if(runlen)
			PUT_ONES(1);
		return;
	}
	limit_reduce=melclen+1;
	PUTBITS(runlen,limit_reduce);

	if(melcstate){
		melclen=J[--melcstate];
		melcorder=(1L<<melclen);
	}
	return;
}