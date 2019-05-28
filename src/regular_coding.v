`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:55:47 06/21/2010 
// Design Name: 
// Module Name:    regular_coding 
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
module regular_coding(clk,reset,en,
                       D1,D2,D3,
							  mode,
							  Px,
							  Ix,
							  //output
							  k,
							  MErrval,
							  en_out
							  );

    input       clk,reset,en;
    input [8:0] D1;
    input [8:0] D2;
    input [8:0] D3;
	 input [1:0] mode;
	 input [8:0] Px,Ix;
	 
	 output [3:0] k;
	 output [8:0] MErrval;
	 output en_out;
	 
    wire [8:0]  Q;
    wire sign;
	 wire en_tmp1;
	 wire en_tmp2;
	 
	 wire    [8:0] Ix_tmp;
    wire    [8:0] Px_tmp;
	 
	 assign en_tmp1=(mode==0)?en:0;
	 
	  
	 
context_Q_decoding context_Q_decoding(.clk(clk), .reset(reset),
                                      .en(en_tmp1), 
                                      .D1(D1), .D2(D2), .D3(D3), 
												  .Ix(Ix),.Px(Px),
												  .Q(Q), 
												  .Ix_out(Ix_tmp),.Px_out(Px_tmp),
												  .sign(sign),
												  .en_out(en_tmp2));

context_cal context_cal(.clk(clk), .reset(reset),
                          .en(en_tmp2), 
                          .Q(Q), .Ix(Ix_tmp), 
								  .Px(Px_tmp), .sign(sign),
								  .k(k),
								  .MErrval(MErrval),.en_out(en_out));

endmodule
