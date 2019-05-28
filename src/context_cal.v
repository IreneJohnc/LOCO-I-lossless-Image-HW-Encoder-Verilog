`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CSSAR
// Engineer: ChenJun
// 
// Create Date:    14:09:26 01/27/2010 
// Design Name: 
// Module Name:    context_cal 
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
module context_cal(clk, reset, en, Q, Ix, Px, sign,k,MErrval,en_out);
    input clk;
    input reset;
    input en;
    input [8:0] Q;
    input [8:0] Ix;
    input [8:0] Px;
    input sign;
	 
	 output [3:0] k;
	 output [8:0] MErrval;
	 output en_out;
	 
	 wire [7:0] C1_a;
	 wire [7:0] C1_a_in;
	 wire [8:0] Q_out;
	 wire [12:0] A_Q_update;
    wire [6:0] B_Q_update;
    wire [7:0] C_Q_update;
    wire [6:0] N_Q_update; 
	 
	 wire [12:0] A_douta;
    wire [6:0] B_douta;
    wire [7:0] C2_douta;
    wire [6:0] N_douta; 
	 
	 wire [8:0] Errval0;
	 wire [8:0] Errval1;
	 wire [8:0] Errval2;
	 
	 wire C_sign;
	 
	 wire en_temp2;
	 reg en_temp1;
	 
	  wire [8:0] Q_pp;
	 wire [8:0] Q_temp;
	 reg [8:0] Q_temp1;
	 reg [8:0] Ix_temp;
    reg [8:0] Px_temp;
	 reg sign_temp;
	 
	 
	 reg [12:0] A_Q_temp;
    reg [6:0] B_Q_temp;
    reg [7:0] C_Q_temp;
    reg [6:0] N_Q_temp; 
	 
	 wire [12:0] A_Q_in;
    wire [6:0] B_Q_in;
    wire [7:0] C2_Q_in;
    wire [6:0] N_Q_in; 
	 
	 always@(posedge clk or negedge reset)
	 if(!reset)
	   begin
		A_Q_temp<=0;
		B_Q_temp<=0;
		C_Q_temp<=0;
		N_Q_temp<=0;
		end
	  else if(en_temp2)
	   begin
		A_Q_temp<=A_Q_update;
		B_Q_temp<=B_Q_update;
		C_Q_temp<=C_Q_update;
		N_Q_temp<=N_Q_update;
		end
	  else
	    begin
		A_Q_temp<=0;
		B_Q_temp<=0;
		C_Q_temp<=0;
		N_Q_temp<=0;
		 end
	 
	 assign #1 A_Q_in=((C_sign==1)?A_Q_temp:A_douta);
	 assign #1 B_Q_in=((C_sign==1)?B_Q_temp:B_douta);
	 assign #1 C2_Q_in=((C_sign==1)?C_Q_temp:C2_douta);
	 assign #1 N_Q_in=((C_sign==1)?N_Q_temp:N_douta);
	 
	 
	 
	 always@(posedge clk or negedge reset)
	 if(!reset)
	   begin
		en_temp1<=0;
		Q_temp1<=0;
		Ix_temp<=0;
		Px_temp<=0;
		sign_temp<=0;
	   end
	 else if(en)
	   begin
		en_temp1<=1;
		Q_temp1<=Q;
		Ix_temp<=Ix;
		Px_temp<=Px;
		sign_temp<=sign;
	   end
	 else
	   begin
		en_temp1<=0;
		Q_temp1<=0;
		Ix_temp<=0;
		Px_temp<=0;
		sign_temp<=0;
	   end
		
		
	  reg [8:0] Q_MErrval_out; 
	  always@(posedge clk or negedge reset)
	  if(!reset)
	   Q_MErrval_out<=0;
	  else if(en_temp2)
	   Q_MErrval_out<=Q_out;
	  else
	   Q_MErrval_out<=0;
	 
	 assign #1 Q_temp=Q_temp1;
	 assign #1 Q_pp=Q;//((Q==Q_temp1)?0:Q);
	 assign #1 C1_a_in=(Q_temp1==Q_MErrval_out)?C_Q_temp:C1_a;
Errval itsErrval(.clk(clk), .reset(reset), .en(en_temp1), .Q(Q_temp1), .sign(sign_temp),
                 .C_Q(C1_a_in), .Ix(Ix_temp), .Px(Px_temp), .C_sign(C_sign),.Q_out(Q_out), 
					  .Errval0(Errval0), .Errval1(Errval1), .Errval2(Errval2), .en_out(en_temp2));

stage4 itsstage4(.clk(clk), .reset(reset), .en(en_temp2), 
               .A_Q(A_Q_in), .B_Q(B_Q_in), .C_Q(C2_Q_in), .N_Q(N_Q_in), 
               .Errval0(Errval0), .Errval1(Errval1), .Errval2(Errval2), .C_sign(C_sign), 
					.A_Q_update(A_Q_update), .B_Q_update(B_Q_update),
					.C_Q_update(C_Q_update),.N_Q_update(N_Q_update),
					.MErrval(MErrval), .k(k), .en_out(en_out));					  

							 
rama itsrama(
	.addra(Q_temp),
	.addrb(Q_out),
	.clka(clk),
	.clkb(clk),
	.dinb(A_Q_update),
	.douta(A_douta),
	.web(en_temp2));
	
ramb itsramb(
	.addra(Q_temp),
	.addrb(Q_out),
	
	.clka(clk),
	.clkb(clk),
	.dinb(B_Q_update),
	.douta(B_douta),
	.web(en_temp2));
	
ramc itsramc1(
	.addra(Q_pp),
	.addrb(Q_out),
	.clka(clk),
	.clkb(clk),
	.dinb(C_Q_update),
	.douta(C1_a),
	.web(en_temp2));
	
ramc itsramc2(
	.addra(Q_temp),
	.addrb(Q_out),
	.clka(clk),
	.clkb(clk),
	.dinb(C_Q_update),
	.douta(C2_douta),
	.web(en_temp2));
	
ramn itsramn(
	.addra(Q_temp),
	.addrb(Q_out),
	.clka(clk),
	.clkb(clk),
	.dinb(N_Q_update),
	.douta(N_douta),
	.web(en_temp2));

endmodule
