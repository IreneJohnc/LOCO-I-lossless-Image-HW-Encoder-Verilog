`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:29:21 01/26/2010 
// Design Name: 
// Module Name:    golomb_k 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module golomb_k(N_Q, A_Q, k);
   
    input [6:0] N_Q;
    input [12:0] A_Q;
    output [3:0] k;
 

 
  
   wire [19:0] N_Q_temp;
	//wire [19:0] A_Q_temp;
   wire s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13;
   
   //wire [3:0] k_tmp1;	
 
	assign #1 N_Q_temp={8'b0000_0000,N_Q[6:0]};
	assign #1 s0=(N_Q_temp<A_Q)?1:0;
	//assign A_Q_temp={7'b0000_0000,A_Q[12:0]};
	assign #1 s1=((N_Q_temp<<1)<A_Q)?1:0;
	assign #1 s2=((N_Q_temp<<2)<A_Q)?1:0;
   assign #1 s3=((N_Q_temp<<3)<A_Q)?1:0;
	assign #1 s4=((N_Q_temp<<4)<A_Q)?1:0;
   assign #1 s5=((N_Q_temp<<5)<A_Q)?1:0;
	
	assign #1 s6=((N_Q_temp<<6)<A_Q)?1:0;
	assign #1 s7=((N_Q_temp<<7)<A_Q)?1:0;
   assign #1 s8=((N_Q_temp<<8)<A_Q)?1:0;
	assign #1 s9=((N_Q_temp<<9)<A_Q)?1:0;
   assign #1 s10=((N_Q_temp<<10)<A_Q)?1:0;
	
	assign #1 s11=((N_Q_temp<<11)<A_Q)?1:0;
	assign #1 s12=((N_Q_temp<<12)<A_Q)?1:0;
   assign #1 s13=((N_Q_temp<<13)<A_Q)?1:0;
	
   	
   assign #1 k=(s0&1'b1)+(s1&1'b1)+(s2&1'b1)+(s3&1'b1)+(s4&1'b1)+(s5&1'b1)
	         +(s6&1'b1)+(s7&1'b1)+(s8&1'b1)+(s9&1'b1)+(s10&1'b1)
				+(s11&1'b1)+(s12&1'b1)+(s13&1'b1);//+1'b1;
  
   

endmodule
