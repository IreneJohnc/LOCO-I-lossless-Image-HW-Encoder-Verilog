
#include "global.h"

#define BUFSIZE ((8*512)-4)   //缓冲器的大小，可以用其负地址
extern int fp;                //缓冲器中的指针。表示已用空间大小
extern int truebuffize;     
extern byte negbuff[];
#define buff (negbuff+4)      //可以用其负地址

extern dword reg;
extern int bits;

#define BITBUFSIZE (8*sizeof(reg))

extern FILE *in,*out;



extern void flushbuff(FILE *fil);

extern void bitoflush();

#define myputc(c,fil) ((fp>=BUFSIZE)?(flushbuff(fil),buff[fp++]=c):\
                                                (buff[fp++]=c))

//output n bits zero.  位缓冲区是32位的，正常情况下只要前byte存满就要清空
//变量bits表示剩下可用的位缓冲空间 当其小于24时，就要clear了
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
	  输出n bit数x，注意，如果输出含OXFF，为了防止和标志字节混淆，后面的字节应
	  以0bit起始
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