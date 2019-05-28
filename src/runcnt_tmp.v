`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:00:30 06/21/2010 
// Design Name: 
// Module Name:    runcnt_tmp 
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
module runcnt_tmp(clk,en,reset,
                 k,
                 limit_reduce,
					  codes_len1_in,
					  codes_2_in,
					  codes_len2_in,
					  mode_in,
                 k_out,
                 glimit,
					  codes_r,
					  codes_r_len,
					  en_out 
						);

input         clk,en,reset;
input [3:0]   k;
input [3:0]   limit_reduce;
input [5:0]   codes_len1_in;
input [10:0]  codes_2_in;
input [3:0]   codes_len2_in;
input [1:0]   mode_in;
					  
output [4:0]  k_out;
output [5:0]  glimit;
output [31:0]  codes_r;
output [5:0] codes_r_len;

output        en_out;

reg [4:0]  k_out;
reg [5:0]  glimit;
 
reg [31:0] codes_r;
reg [5:0]  codes_r_len;
reg [5:0]  mode_out;
reg        en_out;

wire [31:0] code_temp1,code_tmp1,code_temp2,code_temp3;

assign code_temp1=(1<<codes_len1_in);
assign code_tmp1=code_temp1-1;
assign code_temp2=(code_tmp1<<codes_len2_in);
assign code_temp3=code_temp2|{21'd0,codes_2_in};

always@(posedge clk or negedge reset)
if(!reset)
 begin
   k_out<=0;
   glimit<=0;
	
   codes_r<=0;
   codes_r_len<=0; 
   en_out<=0; 
 end
else if(en)
 begin
   k_out<=k;
   glimit<=31-limit_reduce;
   codes_r<=code_temp3;
   codes_r_len<=codes_len1_in+codes_len2_in;
   en_out<=1; 
 end
else
 begin
   k_out<=0;
   glimit<=0;
   codes_r<=0;
   codes_r_len<=0; 
   en_out<=0; 
 end



endmodule
