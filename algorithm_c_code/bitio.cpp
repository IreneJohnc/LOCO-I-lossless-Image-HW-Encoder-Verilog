

#include "global.h"
#include "bitio.h"

extern FILE *in,*out;

byte negbuff[BUFSIZE+4];

int fp;
int truebufzise;
int foundeof;


dword reg;
int bits;


void flushbuff(FILE *fil)
{
	fwrite(buff,1,fp,fil);
	fp=0;
}

void bitoflush()
{
	register unsigned int outbyte;

	while(bits<32){
		outbyte=reg>>24;
		myputc(outbyte,out);
		if (outbyte==0xff)
		{ bits+=7;
		  reg<<=7;
		  reg&=~(1<<(8*sizeof(reg)-1));
		}else{
			bits+=8;
			reg<<=8;
		  }
	}
	flushbuff(out);
	bitoinit();
}

void bitoinit()
{
	bits=32;
	reg=0;
	fp=0;
}