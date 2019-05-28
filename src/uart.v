`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:02:09 12/24/2010 
// Design Name: 
// Module Name:    uart 
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
module uart(clk,rst,send_data,send,recv_data,receved,is_sending,rx,tx
    );
input clk;
input rst;
input [7:0] send_data;
input send;
output [7:0] recv_data;
output receved;
output is_sending;

input rx;
output tx;

reg a0,a1;
reg [7:0] data_rev0,data_rev1;

wire clkout;
wire [7:0] dataout;
wire rdsig;

reg wrsig;
reg [7:0] datain;
wire idle;

reg is_sending;
//============receiveing=================

assign receved=~a0&a1;
assign recv_data=(~a0&a1)?data_rev1:0;

always@(posedge clk) 
if(rst)
begin
a0<=0;
a1<=0;
data_rev0<=0;
data_rev1<=0;
end
else
begin
a0<=rdsig;
a1<=a0;
data_rev0<=dataout;
data_rev1<=data_rev0;
end
//==============================

reg m0,m1;
always@(posedge clk) 
if(rst) begin
m0<=0;
m1<=0;
end
else begin
m0<=idle;
m1<=m0;
end

always@(posedge clk) 
if(rst)
begin
wrsig<=0;
datain<=0;
is_sending<=0;
end
else if(send)
begin
wrsig<=1;
datain<=send_data;
is_sending<=1;
end
else if(~m0&m1)
begin
wrsig<=0;
datain<=0;
is_sending<=0;
end
 



clkdiv myclkdiv(.rst(rst),.clk(clk), .clkout(clkout));
uartrx myrx(.clk(clkout), .rx(rx), .dataout(dataout), .rdsig(rdsig), .dataerror(), .frameerror()); 
uarttx mytx(.clk(clkout), .datain(datain), .wrsig(wrsig), .idle(idle), .tx(tx)); 
endmodule
