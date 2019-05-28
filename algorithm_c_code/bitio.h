
#include "global.h"

#define BUFSIZE ((8*512)-4)   //�������Ĵ�С���������为��ַ
extern int fp;                //�������е�ָ�롣��ʾ���ÿռ��С
extern int truebuffize;     
extern byte negbuff[];
#define buff (negbuff+4)      //�������为��ַ

extern dword reg;
extern int bits;

#define BITBUFSIZE (8*sizeof(reg))

extern FILE *in,*out;



extern void flushbuff(FILE *fil);

extern void bitoflush();

#define myputc(c,fil) ((fp>=BUFSIZE)?(flushbuff(fil),buff[fp++]=c):\
                                                (buff[fp++]=c))

//output n bits zero.  λ��������32λ�ģ����������ֻҪǰbyte������Ҫ���
//����bits��ʾʣ�¿��õ�λ����ռ� ����С��24ʱ����Ҫclear��
#define put_zeros(n)                          \
   bits-=n;                                   \
   while (bits<=24){                                             \
	   if(fp>=BUFSIZE)                        \
	   {  fwrite(buff,1,fp,out);              \
	      fp=0;                               \
	   }                                      \
	   buff[fp++]=reg>>24;                    \
	   reg<<=8;                               \
	   bits+=8;                               \
}   

#define PUT_ZEROS(n) put_zeros(n)             

#define put_ones(n)                                             \
{                                                               \
	if ( n < 24 ) {						\
	    putbits((1<<n)-1,n);				\
	}							\
	else {							\
	    register unsigned nn = n;				\
	    while ( nn >= 24 ) {				\
		putbits((1<<24)-1,24);				\
		nn -= 24;					\
		}							\
		if ( nn ) putbits((1<<nn)-1,nn);			\
}							\
}                                      
	   
	   
#define PUT_ONES(n) put_ones(n)

/*
	  ���n bit��x��ע�⣬��������OXFF��Ϊ�˷�ֹ�ͱ�־�ֽڻ�����������ֽ�Ӧ
	  ��0bit��ʼ
 */
	   
#define putbits(x, n)                                           \
	   assert(n <= 24 && n >= 0 && ((1<<n)>x));	               	\
	   bits -= n;                                               \
	   reg |= x << bits;                                        \
	   while (bits <= 24) {                                   	\
	   register unsigned int outbyte;	                    	\
	   if (fp >= BUFSIZE) {                       		        \
	   fwrite(buff, 1, fp, out);								\
	   fp = 0;												    \
	   }														\
	   outbyte = (buff[fp++] = (reg >> 24) );					\
	   if ( outbyte == 0xff ) {									\
	   bits += 7;												\
	   reg <<= 7;												\
	   /* stuff a 0 at MSB */									\
	   reg &= ~(1<<(8*sizeof(reg)-1));							\
	   }														\
	   else {													\
	   bits += 8;												\
	   reg <<= 8;												\
	 }															\
	 }
	   	   
#define PUTBITS(x,n) putbits(x,n)
	   
extern void bitoinit();