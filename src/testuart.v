`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:58:52 12/24/2010
// Design Name:   clkdiv
// Module Name:   D:/test_programing/keti/chenjun_jpeg_ls/uart_v2_2000/UART_V22000_2/testuart.v
// Project Name:  UART_V22000_2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: clkdiv
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

 module testuart(clk, dataout, wrsig); 
input clk; 
output[7:0] dataout; 
output wrsig; 
reg [7:0] dataout; 
reg wrsig; 
reg [7:0] cnt; 
always @(posedge clk) 
begin 
if(cnt == 254) 
begin 
dataout <= dataout + 8'd1;  //ÿ�����ݼӡ�1�� 
wrsig <= 1'b1;              //������������ 
cnt <= 8'd0; 
end 
else 
begin 
wrsig <= 1'b0; 
cnt <= cnt + 8'd1; 
end 
end 
endmodule


