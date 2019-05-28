`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:42:48 06/22/2010 
// Design Name: 
// Module Name:    load_stream 
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
module load_stream(clk, en, reset, codes, len, code_out, en_out,cod_32,len_32);
    input clk;
    input en;
    input reset;
    input [63:0] codes;
    input [6:0] len;
    output [31:0] code_out;
    output en_out;
    output [31:0] cod_32;
	 output [5:0] len_32;
	 
	 reg [31:0] code_out;
    reg en_out;
	 
	 reg [63:0] code_64;
	 reg [6:0] len_64;
	 
	 wire [63:0] code_temp;
//	 wire [63:0] code_temp_1;
	 wire [63:0] code_temp_2;
	 wire [6:0] len_tmp;

//assign    #1   code_temp_1={codes[31:0],32'h0000_0000};	 
assign    #1    code_temp_2=codes>>(len_64);	 
assign	#1	   code_temp=code_64|code_temp_2;
assign	#1		len_tmp=len_64+len;
			
wire [63:0] code_tmp1,code_tmp2,code_tmp3,code_tmp4;
wire [6:0]  len_1,len_2,len_3,len_4; 

wire en_1,en_2,en_3,en_4;

assign #1 en_1=(len_tmp>=32)&&(code_temp[63:56]==8'hFF);
assign #1 en_2=(len_tmp>=32)&&(code_tmp1[55:48]==8'hFF);
assign #1 en_3=(len_tmp>=32)&&(code_tmp2[47:40]==8'hFF);
assign #1 en_4=(len_tmp>=32)&&(code_tmp3[39:32]==8'hFF);

   assign #1 code_tmp1=en_1?{code_temp[63:56],1'b0,code_temp[55:1]}:code_temp;
	assign #1 len_1    =en_1?(len_tmp+1):len_tmp;
   
   assign #1 code_tmp2=en_2?{code_tmp1[63:48],1'b0,code_tmp1[47:1]}:code_tmp1;
	assign #1 len_2    =en_2?(len_1+1):len_1;
	
	assign #1 code_tmp3=en_3?{code_tmp2[63:40],1'b0,code_tmp2[39:1]}:code_tmp2;
	assign #1 len_3    =en_3?(len_2+1):len_2;
	
	assign #1 code_tmp4=en_4?{code_tmp3[63:32],1'b0,code_tmp3[31:1]}:code_tmp3;
	assign #1 len_4    =en_4?(len_3+1):len_3;
	
	always@(posedge clk or negedge reset)
	 if(!reset)
	  begin
	  code_out<=0;
	  en_out<=0;
	  code_64<=0;
	  len_64<=0;
	  end
	 else if(en)
	   begin
		  
		  if(len_4>=32)
		    begin
			  code_64<=(code_tmp4<<32);
		     len_64<=len_4-32;
		     code_out<=code_tmp4[63:32];
		     en_out<=1;
		    end
		  else 
		    begin
			  code_64<=code_tmp4;
		     len_64<=len_4;
		     code_out<=0;
		     en_out<=0;
		   end
		 
		end
	 else 
	   begin
		code_out<=0;
	   en_out<=0;
	   code_64<=code_64;
	   len_64<=len_64;
		end
	
 assign	cod_32=code_64[63:32];
 assign  len_32=len_64[5:0]; 
	 
endmodule
