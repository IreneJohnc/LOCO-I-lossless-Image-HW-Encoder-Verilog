

#include <stdio.h>
#include <math.h>

#include "global.h"
#include "bitio.h"

static int eor_limit;
static int  bb;//////////////////////
void lossless_regular_mode(int Q,int SIGN,int Px,pixel *xp)
{
	int At,Nt,Bt,absErrval,Errval,MErrval,
		Ix=*xp;
	int unary;
	int temp;
	byte k;

	Nt=N[Q];
	At=A[Q];

	//Ԥ��ֵ
	Px=Px+(SIGN)*C[Q];
    
	if(Px<0) Px=0;
	else if(Px>255) Px=255;
	Errval=SIGN*(Ix-Px);

	if(Errval<0) Errval+=256;
    //������ײ��������
	{
		register nst=Nt;
		for(k=0;nst<At;nst<<=1,k++);
	}
	
	if(k==0)
		printf("Noting ");
	Bt=B[Q];

	temp=(k==0&&((Bt<<1)<=-Nt));
	if (Errval>=128)
	{ 
		Errval-=256;
		absErrval=-Errval;
		MErrval=(absErrval<<1)-1-temp;
	}else{
		absErrval=Errval;
		MErrval=(Errval<<1)+temp;
	}

	//���²���
	B[Q]=(Bt+=Errval);
	A[Q]+=absErrval;

	if (Nt==reset)
	{
		N[Q]=(Nt>>=1);
		A[Q]>>=1;
		B[Q]=(Bt>>=1);
	}

	N[Q]=(++Nt);

	if(Bt<=-Nt){
		if(C[Q]>-128)
			--C[Q];
		if((B[Q]+=Nt)<=-Nt)
			B[Q]=-Nt+1;
	}else if (Bt>0)
	{
		if(C[Q]<127)
			++C[Q];
		if((B[Q]-=Nt)>0)
			B[Q]=0;
	}
//	printf("M:%x ",MErrval);

	//ʵ���������
	unary=MErrval>>k;
	if ( unary <LIMIT ) {
		put_zeros(unary);
		putbits((1 << k) + (MErrval & ((1 << k) - 1)), k + 1);
	}
	else {
		put_zeros(LIMIT);
		putbits((1<<qbpp) + MErrval - 1, qbpp+1);
	}
}

void lossless_end_of_run(pixel Ra,pixel Rb,pixel Ix,int RItype)
{
	int Errval,
	    MErrval,
		Q,
		absErrval,
		oldmap,
		k,
		At,
		unary;

	register int Nt;

	Q=365+RItype;
	Nt=N[Q];
	At=A[Q];

	Errval=Ix-Rb;
	if(RItype)
		At+=Nt>>1;
	else{
		if(Rb<Ra)
			Errval=-Errval;
	}

	//Estimate k
	for(k=0;Nt<At;Nt<<=1,k++);

		if(Errval<0)
			Errval+=256;
		if(Errval>=128)
			Errval-=256;

    oldmap=(k==0&&Errval&&(B[Q]<<1)<Nt);

	if (Errval<0)
	{
		MErrval=-(Errval<<1)-1-RItype+oldmap;
		B[Q]++;
	} 
	else
		MErrval=(Errval<<1)-RItype-oldmap;

		absErrval=(MErrval+1-RItype)>>1;
		A[Q]+=absErrval;
		if (N[Q]==reset)
		{
			N[Q]>>=1;
			A[Q]>>=1;
			B[Q]>>=1;
		}
		N[Q]++;

		eor_limit=LIMIT-limit_reduce;
		unary=MErrval>>k;
		if (unary<eor_limit)
		{
			put_zeros(unary);
			putbits((1<<k)+(MErrval&((1<<k)-1)),k+1);
		}else{
			put_zeros(eor_limit);
			putbits((1<<qbpp)+MErrval-1,qbpp+1)
		}
	 			
}


void lossless_doscanline(pixel *psl,pixel *sl,int no)
{
	int i;
	pixel Ra,Rb,Rc,Rd,
		  Ix,
		  Px;
	int SIGN;
	int cont;


	i=1;  //����ָ����1 �� no

	Rc=psl[0];
	Rb=psl[1];
	Ra=sl[0];

    do 
    {
		int RUNcnt;
		Ix=sl[i];
		bb++;
		Rd=psl[i+1];

		cont=vLUT[0][Rd-Rb+256]+
			 vLUT[1][Rb-Rc+256]+
			 vLUT[2][Rc-Ra+256];
         
 	printf("%x ",Ix);
    
	if (bb==232959)
	  printf("bb=18560 ");

      if (cont==0)
      {
		  ///////////////RUN STATE//////////////////
		  RUNcnt=0;
		  if (Ix==Ra)
		  {
			  while (1)
			  {
				  ++RUNcnt;
				  if (++i>no)
				  {
					  process_run(RUNcnt,EOLINE/*color*/);
					  return;
				  }
				  Ix=sl[i];
				  bb++;
				  printf("%x ",Ix);
                  
				  if (bb==232959)
	                printf("bb=18580 ");
				  if (Ix!=Ra)
				  {
					  Rd=psl[i+1];
					  Rb=psl[i];
					  break;
				  }
				  // RUN continues
			  }
		  }
		  //����Ƿ�ƥ�����أ�����run
		  process_run(RUNcnt,NOEOLINE);
		  
		  lossless_end_of_run(Ra,Rb,Ix,(Ra==Rb));
      }else{
		  /////////////////////////����ģʽ////////////////////////////////
         predict(Rb,Ra,Rc);

		 cont=classmap[cont];
		 if(cont<0){
			 SIGN=-1;
			 cont=-cont;
		 }
		 else
			  SIGN=+1;
		 lossless_regular_mode(cont,SIGN,Px,&Ix);		

	  }
	  sl[i]=Ix;
	  
	  Ra=Ix;
	  Rc=Rb;
	  Rb=Rd;

    } while (++i<=no);

}