`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:24:42 06/23/2010
// Design Name:   codec
// Module Name:   D:/test_programing/keti/chenjun_jpeg_ls/chen_jpegls_1.0/codec_t.v
// Project Name:  chen_jpegls_1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: codec
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module codec_t_v;

	// Inputs
	reg clk;
	reg clk_temp;
	reg reset;
	reg en;
	reg [7:0] data_in;

	// Outputs
	wire [31:0] codes;
	wire en_out;
	wire [31:0] cod_32;
	wire [5:0] len_32;

	// Instantiate the Unit Under Test (UUT)
	codec uut (
		.clk(clk), 
		.reset(reset), 
		.en(en), 
		.data_in(data_in), 
		.codes(codes), 
		.en_out(en_out), 
		.cod_32(cod_32), 
		.len_32(len_32)
	);

  

 integer write_out_file;
 integer record_out_file;
//$fdisplay(write_out_file,"@%h\n£¥h"£¬addr£¬data)£»

//$fclose("write_out_file");

        reg[7:0] mem[0:262143];
        
   parameter dely=25;
	initial $readmemh("test33.hex",mem);  
	initial write_out_file=$fopen("write_out_file.txt","w");
	initial record_out_file=$fopen("record_out_file.txt","w");
	 
  always@(posedge clk)
  if(en_out&en) begin
   $fwrite(write_out_file,"%h",codes);
	$fwrite(record_out_file,"%h:time %d, ",codes,$time);
	end
  
	
	initial begin
		// Initialize Inputs
		clk = 0;
	   
		reset = 0;
		data_in = 0;
		en = 0;

		// Wait 100 ns for global reset to finish
	
		  
		#dely;
		#dely;
		#(dely/2);
		clk_temp=1;
		#(dely/2);
		#dely;
		 reset = 1;
		 
		 
		#7000000 $fclose(write_out_file);
		         $fclose(record_out_file);

		
	end
        

always #(dely/2) clk=~clk;
always #(dely/2) clk_temp=~clk_temp;

integer	i;
always@(negedge clk_temp or negedge reset)
begin  
	if (!reset)
		i <= 0;
	else if(i == 262152)
		i <= i;
	else
		i <= i + 1;
end
		


always@(negedge clk_temp or negedge reset)
begin  
	if (!reset)
		en<= 0;
	else
		if((i > 2) && (i<262146))
			en <= 1;
		else
			en <= 0;
end      

always@(negedge clk_temp or negedge reset)
begin  
	if (!reset)
		data_in <= 0;
	else
		if((i > 2) && (i<262146))
			data_in <= mem[i - 3];
		else
			data_in <= 0;
		
end
		 
endmodule

