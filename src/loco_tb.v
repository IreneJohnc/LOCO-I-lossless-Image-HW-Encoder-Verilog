`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:57:31 01/08/2011
// Design Name:   loco_top
// Module Name:   D:/keti/LOCO_I_1.01/loco_tb.v
// Project Name:  LOCO_I_1.01
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: loco_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:57:31 01/08/2011
// Design Name:   loco_top
// Module Name:   D:/keti/LOCO_I_1.01/loco_tb.v
// Project Name:  LOCO_I_1.01
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: loco_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module loco_tb;
// Inputs
	reg clk;
	reg rst_n;
	reg rx;

	// Outputs
	wire tx;
  
  reg [7:0] data;
  
  integer i;
	// Instantiate the Unit Under Test (UUT)
	loco_top uut (
		.clk(clk), 
		.rst_n(rst_n), 
		.rx(rx), 
		.tx(tx)
	);

	reg[7:0] mem[0:262143];
	
	initial $readmemh("test33.hex",mem);
	
    always #10 clk=~clk;
	
	initial begin
		// Initialize Inputs
		clk = 0;
		rst_n = 1;
		rx = 1;

      #121 rst_n =0;
		#200 rst_n = 1;

      for(i=0;i<262144;i=i+1)
		   recv;  

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	
    task recv;
	  begin
	  
	  data=mem[i];
	  #8681 rx=0;
	  
	  #8681 rx=data[0];
	  #8681 rx=data[1];
	  #8681 rx=data[2];
	  #8681 rx=data[3];
	  #8681 rx=data[4];
	  #8681 rx=data[5];
	  #8681 rx=data[6];
	  #8681 rx=data[7];
	  
	 
	  #8681 rx=1;
	  #8681 rx=1;
	  #8681 rx=1;
	  
	  end
	  endtask

	 endmodule
/*	// Inputs
	reg clk;
	reg rst_n;
	reg rx;

	// Outputs
	wire tx;
  
  integer i;
	// Instantiate the Unit Under Test (UUT)
	loco_top uut (
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

      #121 rst_n =0;
		#200 rst_n = 1;

      for(i=0;i<5120;i=i+1)
		   recv;  

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	
      task recv;
	  begin
	  #8681 rx=0;
	  
	  #8681 rx=1;
	  #8681 rx=0;
	  #8681 rx=0;
	  #8681 rx=0;
	  #8681 rx=0;
	  #8681 rx=0;
	  #8681 rx=0;
	  #8681 rx=0;
	  
	 
	  #8681 rx=1;
	   #8681 rx=1;
	    #8681 rx=1;
	  end
	  endtask
endmodule

*/
