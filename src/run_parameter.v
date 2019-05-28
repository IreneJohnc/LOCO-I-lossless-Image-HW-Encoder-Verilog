`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:18:01 06/20/2010 
// Design Name: 
// Module Name:    run_parameter 
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
module run_parameter(clk, reset, en_in,RItype, A, Nn, N, A_1, Nn_1, N_1, A_0, Nn_0, N_0);
    input clk;
    input reset;
    input en_in;
	 input RItype;
    input [12:0] A;
    input [6:0] Nn;
    input [6:0] N;
	 
    output [12:0] A_1;
    output [6:0] Nn_1;
    output [6:0] N_1;
    output [12:0] A_0;
    output [6:0] Nn_0;
    output [6:0] N_0;
	 
	 reg [12:0] A_1;
    reg [6:0] Nn_1;
    reg [6:0] N_1;
    reg [12:0] A_0;
    reg [6:0] Nn_0;
    reg [6:0] N_0;
	 
	 always@(posedge clk or negedge reset)   
	 if(!reset)
	   begin
		 A_1<=4;
       Nn_1<=0;
       N_1<=1;
       A_0<=4;
       Nn_0<=0;
       N_0<=1;
		end
	 else if(en_in)
	    begin
        if(RItype)
		    begin
			 A_1<=A;
          Nn_1<=Nn;
          N_1<=N;
			 end
			else
			 begin
			 A_0<=A;
          Nn_0<=Nn;
          N_0<=N;
			 end
	    end
	  else begin
	     	 A_1<=A_1;
          Nn_1<=Nn_1;
          N_1<=N_1;
          A_0<=A_0;
          Nn_0<=Nn_0;
          N_0<=N_0;
	     end

endmodule
