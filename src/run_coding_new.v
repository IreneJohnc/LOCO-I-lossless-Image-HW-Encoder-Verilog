`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:54:17 07/08/2010 
// Design Name: 
// Module Name:    run_coding_new 
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
module run_coding_new(clk,en,reset,
                   runcnt,
						 mode,
						 Ra,
						 Rb,
						 Ix,
						 //output
		             k,
                   glimit,
                   codes_r,
         
                   codes_r_len,
                 
						 en_out1,
                   EMErrval,
						 en_out2);

input        clk,en,reset;
input [9:0]  runcnt;
input [1:0]  mode;
input [8:0]  Ra;
input [8:0]  Rb;
input [8:0]  Ix;

output [4:0]   k;
output [5:0]   glimit;
output [5:0]   codes_r_len;
output [31:0]  codes_r;
 
output   en_out1,en_out2;
output[8:0]			EMErrval;

wire [3:0]   k_tmp;
wire [3:0]   limit_reduce;
wire [5:0]  codes_len1_tmp;
wire [10:0] codes_2_tmp;
wire [3:0]  codes_len2_tmp;

wire [1:0]   mode_tmp;
wire         en_tmp,en_temp, en_tmp1,en_tmp2,en_tmp3,en_tmp4;

wire [8:0] Errval_1,Errval_2;
wire       RItype_1,RItype_2,RItype_3;
wire       map;
    wire [12:0] A_1;
    wire [6:0] Nn_1;
    wire [6:0] N_1;
    wire [12:0] A_0;
    wire [6:0] Nn_0;
    wire [6:0] N_0;
	 
	 wire [12:0] A_tt1;
    wire [6:0] Nn_tt1;
    wire [6:0] N_tt1;
    wire [12:0] A_tt0;
    wire [6:0] Nn_tt0;
    wire [6:0] N_tt0;
	 
	 assign en_tmp=(mode>=2'b10)?en:0;
	 assign en_temp=(mode==3)?en:0;
////////////////EMErrval_tp en_out2_tp/////////////// relate for one clock	 
wire   [8:0]	EMErrval_temp;
wire   en_out2_temp;
reg   [8:0]	EMErrval_tp;
reg   en_out2_tp;
always@(posedge clk or negedge reset)
if(!reset)
 begin
 EMErrval_tp<=0;
 en_out2_tp<=0;
 end
else if(en_out2_temp)
 begin
  EMErrval_tp<=EMErrval_temp;
  en_out2_tp<=1;
 end
else
 begin
  EMErrval_tp<=0;
  en_out2_tp<=0;
 end 
////////////////////////////////////// relate for one clock
reg [4:0]   k;
reg [5:0]   glimit;
reg [5:0]   codes_r_len;
reg [31:0]  codes_r;
 
reg   en_out1,en_out2;
reg  [8:0]			EMErrval;

wire [4:0]   k_tp;
wire [5:0]   glimit_tp;
wire [5:0]   codes_r_len_tp;
wire [31:0]  codes_r_tp;
 
wire   en_out1_tp;//en_out2_tp;
//reg  [8:0]			EMErrval_tp;
	 
	 always@(posedge clk or negedge reset)
	  if(!reset)
	   begin
	  //  k<=0;
     //  glimit<=0;
       codes_r_len<=0;
       codes_r<=0;
 
       en_out1<=0;
		// en_out2<=0;
      // EMErrval<=0;
		end
	   else if(en_out1_tp)
		  begin
		 //  k<=k_tp;
       //  glimit<=glimit_tp;
         codes_r_len<=codes_r_len_tp;
         codes_r<=codes_r_tp;
 
         en_out1<=1;
		  // en_out2<=en_out2_tp;
        // EMErrval<=EMErrval_tp;
		  end
		 else begin
        //      k<=0;
        //      glimit<=0;
              codes_r_len<=0;
              codes_r<=0;
 
              en_out1<=0;
		   //     en_out2<=0;
          //    EMErrval<=0;
             end	
				 
	 	 always@(posedge clk or negedge reset)
	  if(!reset)
	   begin
	     k<=0;
        glimit<=0;
     //  codes_r_len<=0;
     //  codes_r<=0;
 
     //  en_out1<=0;
		  en_out2<=0;
        EMErrval<=0;
		end
	   else if(en_out2_tp)
		  begin
		   k<=k_tp;
         glimit<=glimit_tp;
      //   codes_r_len<=codes_r_len_tp;
      //   codes_r<=codes_r_tp;
 
     //    en_out1<=en_out1_tp;
		   en_out2<=1;
         EMErrval<=EMErrval_tp;
		  end
		 else begin
              k<=0;
              glimit<=0;
      //        codes_r_len<=0;
      //        codes_r<=0;
 
      //        en_out1<=0;
		        en_out2<=0;
              EMErrval<=0;
             end	
	 ////////////////////////////////////
	 
//==================================================================
//----------------runcnt pipeline-----------------------------------
//==================================================================
run_cnt its_run_cnt(.clk(clk),.reset(reset),.en(en_tmp),
                .runcnt_in(runcnt),
					 .mode(mode),
					 .limit_reduce(limit_reduce),
				//	 codes_1,
					 .codes_len1(codes_len1_tmp),
					 .codes_2(codes_2_tmp),
					 .codes_len2(codes_len2_tmp),
					 .mode_out(mode_tmp),
					 .en_out(en_tmp1));
runcnt_tmp its_runcnt_tmp(.clk(clk),.en(en_tmp1),.reset(reset),
                 .k(k_tmp),
                 .limit_reduce(limit_reduce),
					  .codes_len1_in(codes_len1_tmp),
					  .codes_2_in(codes_2_tmp),
					  .codes_len2_in(codes_len2_tmp),
					  .mode_in(mode_tmp),
                 .k_out(k_tp),
                 .glimit(glimit_tp),
					  .codes_r(codes_r_tp),
					  .codes_r_len(codes_r_len_tp),
					  .en_out(en_out1_tp) 
						);		
//==================================================================
//----------------run interruption pipeline-------------------------
//==================================================================
						
run_error its_run_error(.clk(clk),.en(en_temp),.reset(reset),
                 .Ra(Ra),.Rb(Rb),.Ix(Ix),
					  .Errval(Errval_1),.RItype(RItype_1),.en_out(en_tmp2));		

run_parameter its_run_parameter(.clk(clk), .reset(reset), .en_in(en_tmp2),
                      .RItype(RItype_1), 
							 .A(A_tt1), .Nn(Nn_tt1), .N(N_tt1), 
							 .A_1(A_1), .Nn_1(Nn_1), .N_1(N_1), 
							 .A_0(A_0),. Nn_0(Nn_0), .N_0(N_0));	

run_stage itsrun_stage(.clk(clk),.en(en_tmp2),.reset(reset),
                 .Errval(Errval_1),.RItype(RItype_1),
					  .A_0(A_0),.N_0(N_0),
					  .A_1(A_1),.N_1(N_1),
					  .Nn_0(Nn_0),.Nn_1(Nn_1),
					  //Errval_out,
					  //RItype_out,
					  .A_Q_out(A_tt1),
					  .N_Q_out(N_tt1),
					  .Nn_Q_out(Nn_tt1),
					 // .RItype_out(RItype_3),
					  .EMErrval(EMErrval_temp),
					  .k(k_tmp),
					  .en_out(en_out2_temp));
endmodule
