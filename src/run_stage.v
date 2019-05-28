`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:03:31 07/08/2010 
// Design Name: 
// Module Name:    run_stage 
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
module run_stage(clk,en,reset,
                 Errval,RItype,
					  A_0,N_0,
					  A_1,N_1,
					  Nn_0,Nn_1,
					  //Errval_out,
					  //RItype_out,
					  A_Q_out,
					  N_Q_out,
					  Nn_Q_out,
					//  RItype_out,
					  EMErrval,
					  k,
					  en_out);

input clk,en,reset;
input signed [8:0] Errval;
input RItype;

input [12:0] A_0;
input [6:0] N_0;
input [12:0] A_1;
input [6:0] N_1;
input [6:0] Nn_0,Nn_1;


//output RItype_out;
output[12:0]		A_Q_out;
output[6:0]			N_Q_out;
output[6:0]			Nn_Q_out;
output[8:0]			EMErrval;
output [3:0] k;
output en_out;

reg [3:0] k;
reg [8:0] EMErrval;
reg en_out;
//======================================================================//
//====================¼ÆËãErrval-map-k==================================//
//======================================================================//
//======================================================================//

//--------A.7.2----------------------------------------------
//-----------------------------------------------------------
wire signed [8:0] Errval2,Errval3;
wire [12:0] TEMP;
wire [3:0] k_temp;
wire [6:0] N_Q,Nn_Q;
wire [12:0]A_Q;
wire s11,s12,s13,s1,s21,s22,s2,s3;

wire map,map1,map2,map3;

//assign Errval1=((RItype==0)&&(Ra>Rb))?(0-Errval):Errval;
//A 4.5 modulo reduction of the predictor error
assign #1 Errval2=(Errval<0)?(Errval+256):Errval;
assign #1 Errval3=(Errval2>127)?(Errval2-256):Errval2;

assign #1 TEMP=RItype?(A_1+{7'b0000_000,N_1[6:1]}):A_0;
assign #1 N_Q=RItype?N_1:N_0;
assign #1 Nn_Q=RItype?Nn_1:Nn_0;
assign #1 A_Q=RItype?A_1:A_0;
	
golomb_k run_golomb_k( .N_Q(N_Q),.A_Q(TEMP), .k(k_temp));
	
assign #1 s11=(k_temp==0)?1:0;
assign #1 s12=(Errval3>0)?1:0;
assign #1 s13=((Nn_Q<<<1)<N_Q)?1:0;
assign #1 s1=((s11)&(s12))&s13;

assign #1 s21=(Errval3<0)?1:0;
assign #1 s22=((Nn_Q<<<1)>=N_Q)?1:0;
assign #1 s2=s21&s22;

assign #1 s3=s21&(~s11);

assign #1 map3=s3?1:0;
assign #1 map2=s2?1:map3;
assign #1 map1=s1?1:map2;
assign #1 map=map1;

//==========================
//if(s1) map<=1;
//   else if(s2) map<=1;
//   else if(s3) map<=1;
//  else map<=0;
//==========================

//======================================================================//
//====================¼ÆËãMErrval-update==================================//
//======================================================================//
//======================================================================//
wire signed [8:0]      abs_Errval;
wire signed [8:0]      EMErrval_tmp1;
wire signed [8:0] 		 EMErrval_tmp2;
wire signed [8:0] 		 tmp;
				  
wire [12:0] A_tmp1,A_tmp2;
wire [6:0] Nn_tmp1,Nn_tmp2;	
wire [6:0] N_tmp1,N_tmp2;			  

assign #1 abs_Errval=(Errval3>=0)?Errval3:(0-Errval3);
assign #1 EMErrval_tmp1=(abs_Errval<<1);
assign #1 EMErrval_tmp2=EMErrval_tmp1-{8'b0000_0000,RItype}-{8'b0000_0000,map}; 
 
assign #1 Nn_tmp1=(Errval<0)?(Nn_Q+1):Nn_Q;

assign #1 tmp=EMErrval_tmp2+9'b0000_0000_1-{8'b0000_0000,RItype};
assign #1 A_tmp1=A_Q+{5'b00000,tmp[8:1]};

assign #1 A_tmp2=(N_Q==64)?(A_tmp1>>1):A_tmp1;
assign #1 Nn_tmp2=(N_Q==64)?(Nn_tmp1>>1):Nn_tmp1;
assign #1 N_tmp1=(N_Q==64)?(N_Q>>1):N_Q; 
assign #1 N_tmp2=N_tmp1+1;

assign #1 A_Q_out=A_tmp2;
assign #1 N_Q_out=N_tmp2;
assign #1 Nn_Q_out=Nn_tmp2;

always@(posedge clk or negedge reset)
if(!reset)
 begin
 k<=0;
 EMErrval<=0;
 en_out<=0;
 end
else if(en)
 begin
  k<=k_temp;
  EMErrval<=EMErrval_tmp2;
  en_out<=1;
 end
else 
 begin
  k<=0;
 EMErrval<=0;
 en_out<=0;
 end

endmodule
