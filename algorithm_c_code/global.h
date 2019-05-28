/*  Company:CSSAR
    This program is wrote by ChenJun in Jan ,2010. Most ideas come from 
	JPEG-LS IMPLEMENTATION v.2.1,which was freely distributed from University
	of British columbia.
	The program is for 512*512 8bits images,just for lossless image compression.
	I hope it suit for space application,because it's just a test in software and 
	this arithmetic will be used in FPGA.

    VERISON:1.0
	WRITE FORM 2010-1-6
*/
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>


#define RANGE 256
#define qbpp 8
#define bpp  8
#define NEAR 0
#define LIMIT  23
//#define CLOCKS_PER_SEC 10e6
#define reset 64

#define LEFTMARGIN 2
#define RIGHTMARGIN 1

extern int limit_reduce; //用于游程结束编码


#define EOLINE	 1
#define NOEOLINE 0


#ifndef max
#	define max(a,b)  (((a)>=(b))?(a):(b))
#	define min(a,b)  (((a)<=(b))?(a):(b))
#endif


#define BASIC_T1  3
#define BASIC_T2  7
#define BASIC_T3  21
#define BASIC_ta  5

extern FILE	*in, *out;
//extern static int  bb;
extern int classmap[9*9*9];
extern int vLUT[3][2 * 256];
extern int	N[367],
            A[367],
            B[367],
			C[367];

/* macro to predict Px */
#define predict(Rb, Ra, Rc)	\
{	\
	register pixel minx;	\
	register pixel maxx;	\
	\
	if (Rb > Ra) {	\
	minx = Ra;	\
	maxx = Rb;	\
	} else {	\
	maxx = Ra;	\
	minx = Rb;	\
}	\
	if (Rc >= maxx)	\
	Px = minx;	\
	else if (Rc <= minx)	\
	Px = maxx;	\
	else	\
	Px = Ra + Rb - Rc;	\
}


/****** Type prototypes */

/* Portability types */
typedef unsigned char byte;
typedef unsigned short word;
typedef unsigned long dword;

typedef unsigned char pixel;

void *safealloc(size_t size);
void *safecalloc(size_t numels, size_t size);


extern void flushbuff(FILE *fil);
extern void bitoflush();
extern void bitoinit();

extern void prepareLUTs();
extern void init_stats();

extern   process_run(int runlen,int eoline);
extern void init_process_run();


void lossless_regular_mode(int Q,int SIGN,int Px,pixel *xp);
void lossless_end_of_run(pixel Ra,pixel Rb,pixel Ix,int RItype);
void lossless_doscanline(pixel *psl,pixel *sl,int no);

 