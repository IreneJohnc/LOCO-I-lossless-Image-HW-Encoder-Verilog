`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:35:54 01/21/2010 
// Design Name: 
// Module Name:    context_Q 
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
module context_Q(clk,reset,en,Q1, Q2, Q3, Q, sign,en_out);
    input clk;
	 input reset;
	 input en;
    input signed [4:0] Q1;
    input signed [4:0] Q2;
    input signed [4:0] Q3;
    output  [8:0] Q;
	 output en_out;
    output sign;
	 
	 reg [8:0] Q;
	 reg sign;
	 reg en_out;
	 
	 wire  signed [4:0] Q1_p;
	 wire  signed [4:0] Q2_p;
	 wire  signed [4:0] Q3_p;
//	 wire [8:0] Q1_c;
	 wire signed [4:0] Q2_c;
	 wire signed [4:0] Q3_c;
	 
	 wire signed [8:0] Q_temp2;
	 wire signed [8:0] Q_temp3;
	 wire signed [8:0] Q_temp4;
	 wire signed [8:0] Q_temp5;
	 
	 wire s1,s2;//s3;

   assign  Q1_p=(Q1>=0)?Q1:{1'b0,(~Q1[3:0])+4'b0001};  //jue dui zhi
	assign  Q2_p=(Q2>=0)?Q2:{1'b0,(~Q2[3:0])+4'b0001};
	assign  Q3_p=(Q3>=0)?Q3:{1'b0,(~Q3[3:0])+4'b0001};
	
//	assign Q1_c=(Q1<0)?Q1_p:{1'b1,~Q1[7:0]+1};  //-Q1
	assign  Q2_c=(Q2<=0)?Q2_p:{1'b1,(~Q2[3:0])+4'b0001};  //-Q2
	assign  Q3_c=(Q3<=0)?Q3_p:{1'b1,(~Q3[3:0])+4'b0001};  //-Q3
	

	
	assign Q_temp2=5+((Q2_p-1)<<3)+Q2_p-1+4+Q3_c;
	assign Q_temp3=41+((Q1_p-1)<<6)+((Q1_p-1)<<4)+(Q1_p-1)+((Q2_c+4)<<3)+(Q2_c+4)+Q3_c+4;
	assign Q_temp4=41+((Q1-1)<<6)+((Q1-1)<<4)+(Q1-1)+((Q2+4)<<3)+(Q2+4)+Q3+4;
	assign Q_temp5=5+((Q2-1)<<3)+Q2-1+4+Q3;
	always@(posedge clk or negedge reset)
	if(!reset)
	  begin
	  Q<=0;
	  en_out<=0;
	  end
	 else if(en)
	  begin
	     en_out<=1;
        if(Q1<0)
          Q<=Q_temp3;
        else if((Q1==0)&&(Q2<0))
		    Q<=Q_temp2;
		  else if((Q1==0)&&(Q2==0))
		    Q<=Q3_p;
	     else  if((Q1==0)&&(Q2>0))
		    Q<=Q_temp5;
		  else
			 Q<=Q_temp4;     
	  end
	  else begin
	      en_out<=0;
			Q<=0;
			end
			 
	always@(posedge clk or negedge reset)
	if(!reset)
	  begin
	  sign<=0;
	  end
	 else if(en)
	  begin
        if(Q1<0)	   
		    sign<=1;
        else if((Q1==0)&&(Q2<0))
		    sign<=1;
		  else if(((Q1==0)&&(Q2==0))&&(Q3<0))
		    sign<=1;
	     else
		    sign<=0;

             	
             		  	  
	  end
	  
	  
	  
	
	
endmodule
