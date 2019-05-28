`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:53:58 12/24/2010 
// Design Name: 
// Module Name:    clkdiv 
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
module clkdiv(rst,clk, clkout); 
input rst;
input clk;          //系统时钟 
output clkout;      //采样时钟输出 
reg clkout; 
reg [7:0] cnt; 

always @(posedge clk)   //分频进程 
begin 

if(rst) begin
cnt<=0;
clkout<=0;
end
else if(cnt==8'd12) 
begin clkout <= 1'b1; 
cnt<=cnt+8'd1; 
end 
else if(cnt==8'd26) 
begin 
clkout<=1'b0; 
cnt<=8'd0; 
end 
else 
begin 
cnt<=cnt+8'd1; 
end 
end 
endmodule 
