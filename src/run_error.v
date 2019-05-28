`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:56:13 06/20/2010 
// Design Name: 
// Module Name:    run_error 
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
module run_error(clk,en,reset,
                 Ra,Rb,Ix,
					  Errval,RItype,en_out);
input clk,en,reset;
//input [1:0] mode;
input signed [8:0] Ra,Rb,Ix;
output signed [8:0] Errval;
output RItype;
output en_out;

reg signed [8:0] Errval;
reg RItype;
reg en_out;


wire [8:0] Px;

assign Px=(Ra==Rb)?Ra:Rb;

always@(posedge clk or negedge reset)
if(!reset)
begin
Errval<=0;
RItype<=0;
en_out<=0;
end
else if(en)
 begin
  en_out<=1;
  if(Ra==Rb)  begin
      RItype<=1;
	   Errval<=Ix-Px;
	 end
   else  
	 begin
      RItype<=0;
	 
	   if(Ra>Rb) Errval<=Px-Ix;
	   else Errval<=Ix-Px;
	 end
 end
 else begin
       Errval<=0;
       RItype<=0;
       en_out<=0;
      end  
endmodule
