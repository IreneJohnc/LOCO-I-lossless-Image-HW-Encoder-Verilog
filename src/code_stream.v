`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:37:09 06/22/2010 
// Design Name: 
// Module Name:    code_stream 
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
module code_stream(clk,reset,
                   en_regular,
						 en_run_1,
						 en_run_2,
						 k_run,
						 k_regular,
						 MErrval_run,
						 MErrval_regular,
						 glimit_run,

						 codes_r,
					 
						 codes_r_len,
						 //output
						  codes,
						  en_out,
						  cod_32,
						  len_32
                   );
						 
						 
input              clk,reset,
                   en_regular,
						 en_run_1,
						 en_run_2;
input [4:0]        k_run;
input [5:0]        glimit_run;
 
input [31:0]       codes_r;
input [5:0]        codes_r_len;
 
input [8:0]			 MErrval_run;

input [3:0]        k_regular;
input [8:0]        MErrval_regular;					 
						 //output
output[31:0]		 codes;
output             en_out; 
output [31:0] cod_32;
output [5:0] len_32;
/////////////////////////////////////////////////////////////////////						 
wire				 en_out_golomb;
wire [31:0]		 codes_g;
wire [5:0]		 codes_g_len;
						 
 

wire en_golomb;
wire [8:0] MErrval;
wire [4:0] k;
wire [5:0] glimit;

reg en_tmp;
reg [31:0] codes_runcnt;
reg [5:0]  codes_runcnt_len;

assign en_golomb=en_regular|en_run_2;
assign MErrval=en_regular?MErrval_regular:MErrval_run;
assign k=en_regular?k_regular:k_run;
assign glimit=en_regular?6'd32:glimit_run;

always@(posedge clk or negedge reset)
if(!reset)
  begin
  en_tmp<=0;
  codes_runcnt<=0;
  codes_runcnt_len<=0;
  end
 else if(en_run_1)
  begin
    en_tmp<=en_run_1;
    codes_runcnt<=codes_r;
    codes_runcnt_len<=codes_r_len;
  end
 else begin
   en_tmp<=0;
   codes_runcnt<=0;
   codes_runcnt_len<=0;
  end

golomb its_golomb(.clk(clk),.reset(reset),.en(en_golomb),
                   .Merrval(MErrval),
						 .k(k),
						 .limit(glimit),
						 .length(codes_g_len), 
						 .code(codes_g),
						 .en_out(en_out_golomb));
						 
///////////////////////////////////////////////////
//wire				 en_out_golomb,
//wire [31:0]		 codes_g,
//wire [5:0]		 codes_g_len,
///////////////////////////////////////////////////						 
						 
				
///////////////////////////////////////////////////
//input              en_run_1;
//input [31:0]       codes_r;
//input [5:0]        codes_r_len;
///////////////////////////////////////////////////				
						 
						 
wire [63:0] codes_g_tmp;	
wire [63:0] codes_r_tmp;		

assign #1 codes_g_tmp={(codes_g<<(32-codes_g_len)),32'd0};
assign #1 codes_r_tmp={(codes_runcnt<<(32-codes_runcnt_len)),32'd0};
				 
						 
/////Æ´  µ÷Õû Êä³ö///////////////////
wire [63:0] codes_tmp1,codes_tmp2;
wire [6:0] len2;
wire en_code; 



assign #1 codes_tmp1=codes_r_tmp|(codes_g_tmp>>codes_runcnt_len);
//assign #1 codes_tmp2=(en_out_golomb|en_tmp)?codes_tmp1:codes_g_tmp;						 
assign #1 codes_tmp2=(en_tmp)?codes_tmp1:codes_g_tmp;						 
//assign #1 len1=en_run_1?codes_r_len:0;
//assign #1 len2=(en_out_golomb&en_tmp)?(codes_g_len+codes_runcnt_len):codes_g_len;							 
assign #1 len2=(en_tmp)?(codes_g_len+codes_runcnt_len):codes_g_len;							 
assign #2 en_code=en_tmp|en_out_golomb;



load_stream its_load_stream(.clk(clk), .en(en_code), 
                            .reset(reset),
									 .codes(codes_tmp2), .len(len2), 
									 .code_out(codes), .en_out(en_out),
									 .cod_32(cod_32),.len_32(len_32));						 
						 
						 
						 
endmodule
