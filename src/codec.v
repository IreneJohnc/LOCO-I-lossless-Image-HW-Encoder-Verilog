`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:45:34 06/23/2010 
// Design Name: 
// Module Name:    codec 
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
module codec(clk,reset,en,
             data_in,
				 codes,
				 en_out,
				 cod_32,
				 len_32
				 );

input clk,reset,en;
input [7:0] data_in;

output[31:0] codes;
output       en_out;
output[31:0] cod_32;
output[5:0]  len_32;



    wire [7:0] a;
    wire [7:0] b;
    wire [7:0] c;
    wire [7:0] d;
	 wire [7:0] Ix;
	 wire END_LINE;
	 wire en_tmp1;

	 wire [8:0] D1;
	 wire [8:0] D2;
	 wire [8:0] D3;
    wire [1:0] mode;
    wire [8:0] Px;
	 wire [8:0] Ix_out;
	 wire [9:0] Runcnt;
	 wire [8:0] Ra;
	 wire [8:0] Rb;
	 wire en_tmp2;
	 
wire              en_regular,
						 en_run_1,
						 en_run_2;
wire [4:0]        k_run;
wire [5:0]        glimit_run;
 
wire [31:0]       codes_r;
wire [5:0]        codes_r_len;
 
wire [8:0]			 MErrval_run;

wire [3:0]        k_regular;
wire [8:0]        MErrval_regular;		

wire [4:0]   k_in;
wire [5:0]   glimit_in;
wire [5:0]   codes_r_len_in;
wire [31:0]  codes_r_in; 
wire   en_out1_in,en_out2_in;
wire [8:0]			EMErrval_in;

context_pixel context_pixel(.clk(clk), .reset(reset), .en(en),
                            .data_in(data_in), 
									 .a(a), .b(b), 
									 .c(c), .d(d),
									 .Ix(Ix),
									 .END_LINE(END_LINE),
									 .en_out(en_tmp1));

mode_decide mode_decide(.clk(clk), .reset(reset), .en(en_tmp1),.END_LINE(END_LINE),
                   .Ix_in(Ix), 
						 .a(a), .b(b), 
						 .c(c), .d(d),
						 .D1(D1),.D2(D2),.D3(D3),
						 .mode(mode),
						 .Px(Px),
						 .Ix_out(Ix_out),
						 .Runcnt(Runcnt),
						 .Ra(Ra),.Rb(Rb),
						 .en_out(en_tmp2));
						 
regular_coding regular_coding(.clk(clk),.reset(reset),.en(en_tmp2),
                       .D1(D1),.D2(D2),.D3(D3),
							  .mode(mode),
							  .Px(Px),
							  .Ix(Ix_out),
							  //output
							  .k(k_regular),
							  .MErrval(MErrval_regular),
							  .en_out(en_regular)
							  );
							  
run_coding_new run_coding(.clk(clk),.en(en_tmp2),.reset(reset),
                   .runcnt(Runcnt),
						 .mode(mode),
						 .Ra(Ra),
						 .Rb(Rb),
						 .Ix(Ix_out),
						 //output
		             .k(k_in),
                   .glimit(glimit_in),
                   .codes_r(codes_r_in),
         
                   .codes_r_len(codes_r_len_in),
                 
						 .en_out1(en_out1_in),
                   .EMErrval(EMErrval_in),
						 .en_out2(en_out2_in)
						 );		
runrun_daly runrun_daly(.clk(clk),.reset(reset), 
                   //output
		             .k_in(k_in),
                   .glimit_in(glimit_in),
                   .codes_r_in(codes_r_in),
                   .codes_r_len_in(codes_r_len_in),
						 .en_out1_in(en_out1_in),
                   .EMErrval_in(EMErrval_in),
						 .en_out2_in(en_out2_in),
						 
						 .k_out(k_run),
                   .glimit_out(glimit_run),
                   .codes_r_out(codes_r),
                   .codes_r_len_out(codes_r_len),
						 .en_out1_out(en_run_1),
                   .EMErrval_out(MErrval_run),
						 .en_out2_out(en_run_2)
						 );
code_stream  code_stream(.clk(clk),.reset(reset),
                   .en_regular(en_regular),
						 .en_run_1(en_run_1),
						 .en_run_2(en_run_2),
						 .k_run(k_run),
						 .k_regular(k_regular),
						 .MErrval_run(MErrval_run),
						 .MErrval_regular(MErrval_regular),
						 .glimit_run(glimit_run),

						 .codes_r(codes_r),
					 
						 .codes_r_len(codes_r_len),
						 //output
						  .codes(codes),
						  .en_out(en_out),
						  .cod_32(cod_32),
						  .len_32(len_32)
                   );	

						 
endmodule

