`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:57:40 01/26/2010 
// Design Name: 
// Module Name:    Error_map 
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
module Error_map(k, B_Q, N_Q, Errval, MErrval);
   
	 input [3:0] k;
    input signed [6:0] B_Q;
    input [6:0] N_Q;
    input signed [8:0] Errval;
    output signed [8:0] MErrval;
   
	  
	 wire signed [7:0] B_Q_temp;
	 wire signed [7:0] N_Q_temp;
	  
	  
	 wire signed [8:0] abs_Errval;
	 wire signed [8:0] temp;
	 
	 assign #1 B_Q_temp=B_Q[6]?{B_Q[6],1'b1,B_Q[5:0]}:{B_Q[6],1'b0,B_Q[5:0]};
	      //{B_Q[6],1'b0,B_Q[5:0]};
	 assign #1 N_Q_temp={1'b0,N_Q[6:0]};
	 
	 assign #1 temp=((k==0)&&((B_Q_temp<<<1)+N_Q_temp<=0))?9'b0000_0000_1:9'b0000_0000_0;
	 assign #1 abs_Errval=(Errval>=0)?Errval:{1'b0,~(Errval[7:0])+8'b0000_0001};
	 
	 assign #1 MErrval=(Errval<0)?((abs_Errval<<1)-1-temp):((abs_Errval<<1)+temp);
	 
	 
	

endmodule
