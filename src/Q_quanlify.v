`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:56:05 01/21/2010 
// Design Name: 
// Module Name:    Q_quanlify 
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
module Q_quanlify(clk, reset, en, D1, D2, D3, Q1, Q2, Q3, en_out);
    input clk;
    input reset;
    input en;
    input signed [8:0] D1;
    input signed [8:0] D2;
    input signed [8:0] D3;
    output signed [4:0] Q1;
    output signed [4:0] Q2;
    output signed [4:0] Q3;
    output en_out;
	 
	  
    reg signed [4:0] Q1;
    reg signed [4:0] Q2;
    reg signed [4:0] Q3;
    reg en_out;
	 
	 always@(posedge clk or negedge reset)
	 if(!reset)
	 Q1<=0;
	 else
	 if(en)
	  begin
      if (D1==0)                     Q1<=0; 
      else if ((D1<=-1)&&(D1>-3))    Q1<=-1;
      else if ((D1<=-3)&&(D1>-7))    Q1<=-2;
      else if ((D1<=-7)&&(D1>-21))   Q1<=-3;
      else if (D1<=-21)              Q1<=-4;
      else if ((D1<=2)&&(D1>0))      Q1<=1;
      else if ((D1<=6)&&(D1>2))      Q1<=2;   
      else if ((D1<=20)&&(D1>6))     Q1<=3; 
      else if (D1>20)                Q1<=4;                      
     end   	  
	 else
	  Q1<=0;
	 
	  always@(posedge clk or negedge reset)
	 if(!reset)
	 Q2<=0;
	 else
	 if(en)
	  begin
      if (D2==0)                    Q2<=0; 
      else if ((D2<=-1)&&(D2>-3))    Q2<=-1;
      else if ((D2<=-3)&&(D2>-7))    Q2<=-2;
      else if ((D2<=-7)&&(D2>-21))   Q2<=-3;
      else if (D2<=-21)             Q2<=-4;
      else if ((D2<=2)&&(D2>0))      Q2<=1;
      else if ((D2<=6)&&(D2>2))      Q2<=2;   
      else if ((D2<=20)&&(D2>6))     Q2<=3; 
      else if (D2>20)               Q2<=4;                      
     end   	  
	 else
	  Q2<=0;
	 
	 
	  always@(posedge clk or negedge reset)
	 if(!reset)
	 Q3<=0;
	 else
	 if(en)
	  begin
      if (D3==0)                    Q3<=0; 
      else if ((D3<=-1)&&(D3>-3))    Q3<=-1;
      else if ((D3<=-3)&&(D3>-7))    Q3<=-2;
      else if ((D3<=-7)&&(D3>-21))   Q3<=-3;
      else if (D3<=-21)             Q3<=-4;
      else if ((D3<=2)&&(D3>0))      Q3<=1;
      else if ((D3<=6)&&(D3>2))      Q3<=2;   
      else if ((D3<=20)&&(D3>6))     Q3<=3; 
      else if (D3>20)               Q3<=4;                      
     end   	  
	 else
	  Q3<=0;
	  
	  always@(posedge clk or negedge reset)
	  if(!reset)
	  en_out<=0;
	  else if(en)
	  en_out<=1;
	  else
	   en_out<=0;
	 


endmodule
