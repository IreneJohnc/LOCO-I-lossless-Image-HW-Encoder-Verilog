`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:49:53 01/26/2010 
// Design Name: 
// Module Name:    context_update 
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
module context_update(  Errval,A_Q, B_Q, C_Q, N_Q, 
                      A_Q_update, B_Q_update, C_Q_update, 
							 N_Q_update,C_Q_sign );
     
	 input signed [8:0] Errval;
    input [12:0] A_Q;
    input signed [6:0] B_Q;
    input signed[7:0] C_Q;
    input [6:0] N_Q;
    output [12:0] A_Q_update;
    output signed [6:0] B_Q_update;
    output [7:0] C_Q_update;
    output signed [6:0] N_Q_update;
	 output [1:0] C_Q_sign;
	 
	  
	 
	 
	 wire [12:0] abs_Errval;
	 
	 wire [12:0] A_Q1,A_Q2;
    wire signed [8:0] B_Q1,B_Q2,B_Q3,B_Q4,B_Q5,B_Q6;
    wire signed[7:0] C_Q1,C_Q2;
    wire [6:0] N_Q1,N_Q2;
	 
	 wire signed [8:0] N_temp;
	 wire [1:0] C_Q_sign1,C_Q_sign2;  //表示C是加1，减1，或不变：
	                                  //0：表示不变
												 //1：表示加1
												 //2：表示减1
	 wire signed[8:0]  B_Q_temp;
	 
	 assign #1 B_Q_temp=(B_Q[6]==1'b0)?{B_Q[6],2'b00,B_Q[5:0]}:{B_Q[6],2'b11,B_Q[5:0]};
	 
	 assign #1 abs_Errval=(Errval[8]==0)?({4'b0000,Errval[8:0]}):({5'b00000,(~Errval[7:0]+8'b0000_0001)});
	 // A 6.1 update
	 assign #1 A_Q1=A_Q+abs_Errval;
	 assign #1 A_Q2=(N_Q==64)?(A_Q1>>1):A_Q1;
	 
	 assign #1 B_Q1=B_Q_temp+Errval;
	 assign #1 B_Q2=(N_Q==64)?(B_Q1>>>1):B_Q1;
	 
	 assign #1 N_Q1=(N_Q==64)?(N_Q>>1):N_Q;
	 assign #1 N_Q2=N_Q1+1;
	 
	 assign #1 N_temp={2'b00,N_Q2};
	 //A 6.2 Bias computation

    assign #1 B_Q3=B_Q2+N_temp;
	 assign #1 B_Q5=B_Q2-N_temp;
	 
	 assign #1 B_Q4=((B_Q2+ N_temp)<=0)?(((B_Q3+ N_temp)<=0)?(9'b0000_0000_1- N_temp):B_Q3):B_Q2;
	 assign #1 B_Q6=(B_Q2>0)?((B_Q5>0)?0:B_Q5):B_Q4;
 
    assign #1 C_Q1=((B_Q2+ N_temp)<=0)?((C_Q>-128)?C_Q-1:C_Q):C_Q;
	 assign #1 C_Q2=(B_Q2>0)?((C_Q1<127)?(C_Q1+1):C_Q1):C_Q1;
	 
	 assign #1 C_Q_sign1=((B_Q2+ N_temp)<=0)?((C_Q>-128)?2:0):0;
	 assign #1 C_Q_sign2=(B_Q2>0)?((C_Q1<127)?1:C_Q_sign1):C_Q_sign1;


     assign  #1 A_Q_update=A_Q2;
	  assign  #1 B_Q_update={B_Q6[8],B_Q6[5:0]};
	  assign  #1 C_Q_update=C_Q2;
	  assign  #1 N_Q_update=N_Q2;
	  assign  #1 C_Q_sign=C_Q_sign2;
   
	
endmodule
