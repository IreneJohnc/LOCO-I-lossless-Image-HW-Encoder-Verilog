`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CSSAR
// Engineer: ChenJun
// Create Date:    14:16:33 01/19/201
// Module Name:    golomb  :for Golomb Rice coding 
// Project Name: 
// Target Devices: 
// Tool versions: ISE 8.2
// Description: Merrval is the mapped error in LOCO-I,limit is LIMIT in JPEG_LS standard.
//              the code bits are in code,and the length stands for how many bits are valid
//              in the 32bits of code.
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module golomb(clk,reset,en,Merrval,k,limit, length, code,en_out);
    input clk;
	 input reset;
	 input en;
    input [8:0] Merrval;
	 input [4:0] k;
    input [5:0] limit;
    output [5:0] length;
    output [31:0] code;
	 output en_out;
	 
	 reg[5:0] length;
	 reg[31:0] code;
	 reg en_out;
	 
	 wire[31:0] value1;
	 wire[31:0] value2;
	 wire[31:0] value3;
	 wire[7:0]  mee;
	 
	 assign value1=(Merrval>>k);
	 assign value2=Merrval&((1<<k)-1);
	 assign value3=limit-9;
	 
	 assign mee=Merrval[7:0]-1;
	 always@(posedge clk or negedge reset)
	 begin
	   if(!reset)
		 begin
		 length<=0;
		 code<=0;
		 en_out<=0;
		 end
		else if(en)
		     begin
			    en_out<=1;
		       if(value1<value3)
				   begin
					length<=1+k+value1;
					code<=(1<<k)|(value2);
					end
				 else
				   begin
					length<=limit;
					code<={24'h001,mee};
					end
		     end
	    else begin
		   length<=0;
		   code<=0;
		   en_out<=0;
		   end
	 end
	 

endmodule
