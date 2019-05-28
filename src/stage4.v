`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:33:04 01/28/2010 
// Design Name: 
// Module Name:    stage4 
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
module stage4(clk, reset, en, A_Q, B_Q, C_Q, N_Q, 
               Errval0, Errval1, Errval2, C_sign, 
					A_Q_update, B_Q_update, C_Q_update, N_Q_update,
					MErrval, k, en_out);
    input clk;
    input reset;
    input en;
    input [12:0] A_Q;
    input [6:0] B_Q;
    input [7:0] C_Q;
    input [6:0] N_Q;
    input [8:0] Errval0;
    input [8:0] Errval1;
    input [8:0] Errval2;
    input C_sign;
    output [12:0] A_Q_update;
    output [6:0] B_Q_update;
    output [7:0] C_Q_update;
    output [6:0] N_Q_update;
    output [8:0] MErrval;
    output [3:0] k;
    output en_out;
	 
	
	 
	 wire [1:0] c_q_sign_temp;
	 wire [8:0] Errval_temp1,Errval_temp2;
	 wire [3:0] k_temp;
	 wire [8:0] MErrval_temp;
	 reg [1:0]  C_Q_sign; //表示C是加1，减1，或不变：
	                      //0：表示不变
								 //1：表示加1
								 //2：表示减1
	 reg [8:0] MErrval;
	 reg [3:0] k;
	 reg en_out;
	 
	//wire tmp1,tmp2;
	//
	// assign #1 tmp1=(C_sign==1'b1)&&(C_Q_sign==1)?1:0;
	// assign #1 tmp2=(C_sign==1'b1)&&(C_Q_sign==2)?1:0;
	 
	 assign #1 Errval_temp1=((C_sign==1)&&(C_Q_sign==1))?Errval1:Errval0;
	 assign #1 Errval_temp2=((C_sign==1)&&(C_Q_sign==2))?Errval2:Errval_temp1;
	 
	 always@(posedge clk or negedge reset)
	 if(!reset)
	 begin
	  C_Q_sign<=0;
	  en_out<=0;
	  MErrval<=0;
	  k<=0;
	 end
	 else if(en)
	    begin
		 C_Q_sign<=c_q_sign_temp;
	    en_out<=1;
	    MErrval<=MErrval_temp;
	    k<=k_temp;
		 end
	  else
	    begin
		 C_Q_sign<=0;
	    en_out<=0;
	    MErrval<=0;
	    k<=0;
		 end
		 
		 
	 

golomb_k itsgolomb_k( .N_Q(N_Q),.A_Q(A_Q), .k(k_temp));					  

Error_map itsError_map(.k(k_temp), .B_Q(B_Q), .N_Q(N_Q), 
                       .Errval(Errval_temp2), .MErrval(MErrval_temp));

context_update itscontext_update( .Errval(Errval_temp2),
                                .A_Q(A_Q), .B_Q(B_Q), .C_Q(C_Q), .N_Q(N_Q), 
                                .A_Q_update(A_Q_update), .B_Q_update(B_Q_update), .C_Q_update(C_Q_update), 
							           .N_Q_update(N_Q_update),.C_Q_sign(c_q_sign_temp));

endmodule
