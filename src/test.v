`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:26:42 07/27/2010
// Design Name:   uart_top
// Module Name:   D:/test_programing/keti/chenjun_jpeg_ls/uuuu/test.v
// Project Name:  uuuu
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: uart_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_v;

	// Inputs
	reg clk;
	reg rst_n;
	reg rx;
	

	// Outputs
	wire tx;

	// Instantiate the Unit Under Test (UUT)
	uart_top uut (
		.clk(clk), 
		.rst_n(rst_n), 
		.rx(rx), 
		.tx(tx)
		);

  always #10 clk=~clk;
  
	initial begin
		// Initialize Inputs
		clk = 0;
		rst_n = 1;
		rx = 1;
		//led = 0;

		// Wait 100 ns for global reset to finish
		#100 rst_n =0;
		#80 rst_n =1;
		#120;
		
			#8681 rx=0;
		
		#8681 rx=1;
		#8681 rx=0;
		#8681 rx=1;
		#8681 rx=1;
		#8681 rx=0;
		#8681 rx=1;
		#8681 rx=0;
		#8681 rx=0;
		
		#8681 rx=1;
		/*
		#103600 rx=0;
		
		#103600 rx=1;
		#103600 rx=0;
		#103600 rx=1;
		#103600 rx=1;
		#103600 rx=0;
		#103600 rx=1;
		#103600 rx=0;
		#103600 rx=0;
		
		#103600 rx=1;
        */
		// Add stimulus here

	end
      
endmodule

