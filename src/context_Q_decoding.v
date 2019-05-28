`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:12:24 01/21/2010 
// Design Name: 
// Module Name:    context_Q_decoding 
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
module context_Q_decoding(clk, reset, en,Ix,Px, D1, D2, D3, Q,Ix_out,Px_out, sign,en_out);
    input clk;
    input reset;
    input en;
    input [8:0] D1;
    input [8:0] D2;
    input [8:0] D3;
	 input [8:0] Ix;
	 input [8:0] Px;
	 
    output [8:0]  Q;
	 output [8:0] Ix_out;
	 output [8:0] Px_out;
    output sign;
	 output en_out;
	 
	 wire [4:0] Q1;
	 wire [4:0] Q2;
	 wire [4:0] Q3;
	 wire en_context;
	 wire sign;
	 
	reg en_tmp;
	reg [8:0] Ix_out;
	reg [8:0] Px_out;
	reg [8:0] Ix_tmp;
	reg [8:0] Px_tmp;
	
	 always@(posedge clk or negedge reset)
	 if(!reset)
	    begin
	    en_tmp<=0;
		 Ix_tmp<=0;
		 Px_tmp<=0;
	    end
	 else if(en)
	   begin
		Ix_tmp<=Ix;
		 Px_tmp<=Px;
		 en_tmp<=1;
		end
	 else
	   begin
		 en_tmp<=0;
		 Ix_tmp<=0;
		 Px_tmp<=0;
		end

always@(posedge clk or negedge reset)
	 if(!reset)
	 begin
	 Ix_out<=0;
	 Px_out<=0;
	 end
	 else if(en_tmp)
	   begin
		Ix_out<=Ix_tmp;
	   Px_out<=Px_tmp;
		end
	 else
	   begin
		Ix_out<=0;
	   Px_out<=0;
		end

Q_quanlify  my_Q_quanlify(.clk(clk), .reset(reset), .en(en), 
                          .D1(D1), .D2(D2), .D3(D3), 
								  .Q1(Q1), .Q2(Q2), .Q3(Q3), 
								  .en_out(en_context));

context_Q   my_context_Q(.clk(clk),.reset(reset),.en(en_context),
                          .Q1(Q1), .Q2(Q2), .Q3(Q3), .Q(Q),
								  .sign(sign),.en_out(en_out));

endmodule
