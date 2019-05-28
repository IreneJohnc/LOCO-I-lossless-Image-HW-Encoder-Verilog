`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:58:24 07/06/2010 
// Design Name: 
// Module Name:    runrun_daly 
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
module runrun_daly(clk,reset, 
                   //output
		             k_in,
                   glimit_in,
                   codes_r_in,
                   codes_r_len_in,
						 en_out1_in,
                   EMErrval_in,
						 en_out2_in,
						 
						 k_out,
                   glimit_out,
                   codes_r_out,
                   codes_r_len_out,
						 en_out1_out,
                   EMErrval_out,
						 en_out2_out
						 );
input clk,reset;						 
input [4:0]   k_in;
input [5:0]   glimit_in;
input [5:0]   codes_r_len_in;
input [31:0]  codes_r_in; 
input   en_out1_in,en_out2_in;
input[8:0]			EMErrval_in;
						 
output [4:0]   k_out;
output [5:0]   glimit_out;
output [5:0]   codes_r_len_out;
output [31:0]  codes_r_out;
output   en_out1_out,en_out2_out;
output[8:0]			EMErrval_out;

reg [4:0]   k_out;
reg [5:0]   glimit_out;
reg [5:0]   codes_r_len_out;
reg [31:0]  codes_r_out;
 
reg   en_out1_out,en_out2_out;
reg [8:0]			EMErrval_out;
     
	  always@(posedge clk or negedge reset)
	  if(!reset)begin
	   codes_r_len_out<=0;
		codes_r_out<=0;
		en_out1_out<=0;
	  end
	  else if(en_out1_in)
	   begin
		 codes_r_len_out<=codes_r_len_in;
		 codes_r_out<=codes_r_in;
		 en_out1_out<=en_out1_in;
		end else begin
		    codes_r_len_out<=0;
		    codes_r_out<=0;
		    en_out1_out<=0;
		    end
	  
	  always@(posedge clk or negedge reset)
	  if(!reset)begin
	     k_out<=0;
		  glimit_out<=0;
		  en_out2_out<=0;
		  EMErrval_out<=0;
	  end
	  else if(en_out2_in)
	   begin
		  k_out<=k_in;
		  glimit_out<=glimit_in;
		  en_out2_out<=en_out2_in;
		  EMErrval_out<=EMErrval_in;
		end
		else begin
		   k_out<=0;
		   glimit_out<=0;
		   en_out2_out<=0;
			EMErrval_out<=0;
		  end
	  
endmodule
