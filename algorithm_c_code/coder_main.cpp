#include "global.h"
#include "math.h"
#include "string.h"

pixel *pscanline,*cscanline,*scanl0,*scanl1;

int columns,rows;


void read_one_line(pixel* line,int cols,FILE* infile)
{
	unsigned char* line8;
	int i;

	line8=(unsigned char *)safealloc(cols);
     
	if(fread(line8,1,cols,infile)!=cols)
		fprintf(stderr,"Input file is truncated");

	for(i=0;i<cols;i++)
		line[i]=line8[i];
	free(line8);

}

void swaplines()
{
	unsigned char *temp;
	temp = pscanline;
	pscanline = cscanline;
	cscanline = temp;
}


void initbuffers()
{
	scanl0=(pixel*)safecalloc(columns+LEFTMARGIN+RIGHTMARGIN,sizeof(pixel));
	scanl1=(pixel*)safecalloc(columns+LEFTMARGIN+RIGHTMARGIN,sizeof(pixel));
	pscanline=scanl0;
	cscanline=scanl1;
}

int closebuffers()
{
	int pos;
	bitoflush();

	fclose(in);

	pos=ftell(out);
	fclose(out);
	free(scanl0);
	free(scanl1);
	return pos;
}

void main(int argc,char *argv[])
{
	int n,n_c,n_r,my_i,n_s,i;
	double t0,t1,get_utime();
    
	static int  bb;//////////////////////
    bb=0;
     

	if (argc!=3)
	{
		fprintf(stderr,"The debug setting is woring,just the input image and output name!\n");
		return;
	}

	if ((in=fopen(argv[1],"rb"))==NULL)
	{
		fprintf(stderr,"Can't open the source 512*512 8bits raw image!\n");
		return;

	}

	if ((out=fopen(argv[2],"wb"))==NULL)
	{
        fprintf(stderr,"Can't open the output file!\n");
		return;
	}
	
	    columns=rows=512;
		initbuffers();

	t0=get_utime();

	 
			prepareLUTs();
			init_stats();
			init_process_run();

			bitoinit();

			n=0;
			while (++n<=rows)
			{
				printf("line%d\n",n);
				read_one_line(cscanline+1,columns,in);
				cscanline[0]=pscanline[1];

				lossless_doscanline(pscanline,cscanline,columns);
				cscanline[columns+1]=cscanline[columns];
				swaplines();
			//	flushbuff(out);
			}
			bitoflush();
		//	close_process_run();
           closebuffers();

		   return;

}