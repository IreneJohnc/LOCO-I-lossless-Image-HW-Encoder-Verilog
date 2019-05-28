`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CSSAR
// Engineer: ChenJun
// 
// Create Date:    15:17:52 01/25/2010 
// Design Name: 
// Module Name:    Errval 
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
module Errval(clk, reset, en, Q, sign, C_Q, Ix, Px,
              C_sign,Q_out, Errval0, Errval1, Errval2, en_out);
    input clk;
    input reset;
    input en;
    input [8:0] Q;
    input sign;
	 input signed [7:0] C_Q;
    input  signed [8:0] Ix;
    input  signed [8:0] Px;
	// input signed [7:0] C_Q_update;
    output   C_sign;
	 output [8:0] Q_out;
    output [8:0] Errval0;
    output [8:0] Errval1;
    output [8:0] Errval2;
    output en_out;
   
	 reg  C_sign;
	 reg [8:0] Q_out;
    reg signed [8:0] Errval0;
    reg signed [8:0] Errval1;
    reg signed [8:0] Errval2;
    reg en_out;
	 
	 reg [8:0] Q_temp;// Q value in the last clock
	 
 
	 wire signed [7:0] C_Q;
	 
	 wire signed [9:0] px01,px02,px03;
	 wire signed [9:0] px11,px12,px13;
	 wire signed [9:0] px21,px22,px23;
	 
	 wire signed [9:0] errval_0,errval0_temp1,errval0_temp2;
	 wire signed [9:0] errval_1,errval1_temp1,errval1_temp2;
	 wire signed [9:0] errval_2,errval2_temp1,errval2_temp2;
	 
	 //assign C_Q=C_Q_in;//(Q==Q_out)?C_Q_update:C_Q_in;
	 
	 assign #1 px01=(sign==0)?(Px+C_Q):(Px-C_Q);  //A 4.2 prediction correction
	 assign #1  px02=(px01<256)?px01:10'b00_1111_1111;
	 assign #1 px03=(px02<0)?10'b00_0000_0000:px02;  //clamped to the range[0...255]
	 assign #1 errval_0=(sign==0)?(Ix-px03):(px03-Ix); //A 4.3 computation of predicton error
	 assign #1 errval0_temp1=(errval_0<0)?(errval_0+256):errval_0;
	 //A 4.5 modulo reduction of the predictor error
	 assign errval0_temp2=(errval0_temp1>127)?(errval0_temp1-256):errval0_temp1;
	 
	 
	 assign #1 px11=(sign==0)?(Px+C_Q+1):(Px-C_Q-1);
	 assign #1 px12=(px11<256)?px11:10'b00_1111_1111;
	 assign #1 px13=(px12<0)?10'b00_0000_0000:px12;
	 assign #1 errval_1=(sign==0)?(Ix-px13):(px13-Ix);
	 assign #1 errval1_temp1=(errval_1<0)?(errval_1+256):errval_1;
	 assign #1 errval1_temp2=(errval1_temp1>127)?(errval1_temp1-256):errval1_temp1;
	 
	 
	 assign #1 px21=(sign==0)?(Px+C_Q-1):(Px-C_Q+1);
	 assign #1 px22=(px21<256)?px21:10'b00_1111_1111;
	 assign #1 px23=(px22<0)?10'b00_0000_0000:px22;
	 assign #1 errval_2=(sign==0)?(Ix-px23):(px23-Ix);
	 assign #1 errval2_temp1=(errval_2<0)?(errval_2+256):errval_2;
	 assign #1 errval2_temp2=(errval2_temp1>127)?(errval2_temp1-256):errval2_temp1;
	 
	 
	 always@(posedge clk or negedge reset)
	 if(!reset)
	 begin
	 Errval0<=0;
	 Errval1<=0;
	 Errval2<=0;
	 en_out<=0;
	 end
	 else
	 if(en)
	  begin
	  en_out<=1;
	  Errval0<=errval0_temp2;
	  Errval1<=errval1_temp2;
	  Errval2<=errval2_temp2;
	  end
	 else
	  begin
	  en_out<=0;
	  Errval0<=0;
	  Errval1<=0;
	  Errval2<=0;
	  end
	 
	 always@(posedge clk or negedge reset)
	 if(!reset)
	 begin
	 Q_temp<=0;
	 Q_out<=0;
	 end
	 else if(en)
	 begin
	 Q_temp<=Q;
	 Q_out<=Q;
	 end
	 else
	 begin
	 Q_temp<=0;
	 Q_out<=0;
	 end
	 
	 always@(posedge clk or negedge reset)
	 if(!reset)
	 C_sign<=0;
	 else if(en)
	 C_sign<=(Q_temp==Q)?1:0;
	 else
	 C_sign<=0;
	 
	 


endmodule
