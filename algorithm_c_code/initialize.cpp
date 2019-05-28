#include <stdio.h>
#include <math.h>

#include "global.h"
#include "bitio.h"

int vLUT[3][2*256];
int classmap[9*9*9];

int N[367];
int A[367];
int B[367];
int C[367];

void prepareLUTs()
{
	int i,j,idx,lmax;
	byte k;

	lmax=256;

	for (i=-lmax+1;i<lmax;i++)
	{
		if(i<=-BASIC_T3)
			idx=7;
		else if(i<=-BASIC_T2)
			idx=5;
		else if(i<=-BASIC_T1)
			idx=3;
		else if(i<=-1)
			idx=1;
		else if(i==0)
			idx=0;
		else if(i<BASIC_T1)
			idx=2;
		else if(i<BASIC_T2)
			idx=4;
		else if(i<BASIC_T3)
			idx=6;
		else
            idx=8;
		vLUT[0][i + 256] = 9 * 9 * idx;
		vLUT[1][i + 256] = 9 * idx;
		vLUT[2][i + 256] = idx;
	}

	classmap[0]=0;
	for(i=1,j=0;i<729;i++)
	{
		int q1,q2,q3,n1=0,n2=0,n3=0,ineg,sgn;
		if(classmap[i])
			continue;

		q1=i/(9*9);  //第一个数
		q2=(i/9)%9;  //第二个数
		q3=i%9;      //第三个数

		if((q1%2)||(q1==0&&(q2%2))||(q1==0&&q2==0&&(q3%2)))
			sgn=-1;
		else
			sgn=1;

		if(q1) n1=q1+((q1%2)?1:-1);
		if(q2) n2=q2+((q2%2)?1:-1);
		if(q3) n3=q3+((q3%2)?1:-1);

		ineg=(n1*9+n2)*9+n3;
		j++;
		classmap[i]=sgn*j;
		classmap[ineg]=-sgn*j;
	}
}

void init_stats()    //(int absize)
{
	int i,initabstat,slack;
    
	slack=1<<6;
	initabstat=(256+slack/2)/slack;

	if(initabstat<=2) initabstat=2;

	for(i=0;i<367;i++)
	{
		C[i]=B[i]=0;
		N[i]=1;
	    A[i]=initabstat;
	}
}