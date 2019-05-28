`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:48:40 01/19/2010 
// Design Name: 
// Module Name:    mode_decide 
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
module mode_decide(clk, reset, en,END_LINE,
                   Ix_in, a, b, c, d,
				   D1,D2,D3,
				   mode,Px,Ix_out,Runcnt,Ra,Rb,en_out);
    input clk;
    input reset;
    input en;
	input END_LINE;// if '1',stand for the last pixel of line
    input  [7:0] Ix_in;
    input  [7:0] a;
	input  [7:0] b;
	input  [7:0] c;
	input  [7:0] d;
	
	output [8:0] D1;
	output [8:0] D2;
	output [8:0] D3;
    output [1:0] mode;
    output [8:0] Px;
	output [8:0] Ix_out;
	output [9:0] Runcnt;
	output [8:0] Ra;
	output [8:0] Rb;
	output en_out;
	 
	reg [8:0] D1;
	reg [8:0] D2;
	reg [8:0] D3;
    reg [1:0] mode;  // mode=0:it's regular mode
	                 // mode=1:it's in run mode
					 // mode=2:jump form run mode because of END_LINE
					 // mode=3:jump form run mode because of another pixel
    reg [8:0] Px;
	reg [8:0] Ix_out;
	reg [9:0] Runcnt;
	reg [9:0] Runcnt_tmp;
	reg [8:0] Ra;
	reg [8:0] Rb;
	reg en_out;
	
	wire [8:0] Max;
	wire [8:0] Min;
	 
	wire value1;
	wire value2;
	wire value3;
	wire [2:0] cont;
	
	reg [1:0] state;
	 
	parameter  Idle=2'b01,
	           Run=2'b10;

	
	assign #1 Max=(a>=b)?a:b;
	assign #1 Min=(a>=b)?b:a;
	 
	assign #1 value1=(d==c)?1:0;
	assign #1 value2=(b==d)?1:0;
	assign #1 value3=(d==a)?1:0;
	assign #1 cont={value1,value2,value3};
	
	
	
	// calculate rude Px value;
	 always@(posedge clk or negedge reset)
	 if(!reset)
		Px<=0;
	 else if(en)
	 begin      
		if(c>=Max)
			Px<=Min;
		else if(c<=Min)
			Px<=Max;
         else
			Px<=a+b-c;			
	 end	
	 else Px<=0;
	
	// register Ix,Ra,Rb;
	always@(posedge clk or negedge reset)
	if(!reset) begin
	Ix_out<=0;
	Ra<=0;
	Rb<=0;
	end
	else if(en) begin
	Ix_out<=Ix_in;
	Ra<=a;
	Rb<=b;
	end
	else begin
	Ix_out<=0;
	Ra<=0;
	Rb<=0;
	end
	
	// calculate local gradient
	always@(posedge clk or negedge reset)
	if(!reset) begin
		D1<=0;
		D2<=0;
		D3<=0;
		end
	else if(en) begin
		D1<=d-b;
		D2<=b-c;
		D3<=c-a;
		end
	else begin
		D1<=0;
		D2<=0;
		D3<=0;
		end
	//generate en_out signal
	always@(posedge clk or negedge reset)
	if(!reset)
	  en_out<=0;
	 else if(en)
		case(state)
		Idle:begin
	      if(cont==3'b111)
				begin
			   if((Ix_in==a)&&(END_LINE==0))
			       en_out<=0;
			    else
				   en_out<=1;
				end
			 else
			    en_out<=1;
			end
		 Run:begin
	     if((Ix_in==a)&&(END_LINE==0))
			  en_out<=0;
			 else
			  en_out<=1;
			  end
	   default: en_out<=0;
		endcase
	 else
	    en_out<=0;
	
	
//mode register recoding and mode deciding
always@(posedge clk or negedge reset)
	 if(!reset)
	 begin
	 state<=Idle;
	 mode<=0;
	 Runcnt<=0;
	 Runcnt_tmp<=0;
	 end
	 else
	 if(en) begin 
	 case(state)
	 Idle:begin
	      if(cont==3'b111) begin
			    if(Ix_in==a)
				  begin				  
				  if(END_LINE)
				    begin
				    mode<=2'b10;
					 state<=Idle;
					 Runcnt<=1;
					 end
					else
					 begin
					 mode<=2'b01;
					 state<=Run;
					 Runcnt_tmp<=1;
					 end
				  end
				 else
				  begin
					mode<=2'b11;
				   Runcnt_tmp<=0;
			      Runcnt<=0; 				  
			      state<=Idle;
				  end
				end
         else
            begin
				  mode<=2'b00;
				  Runcnt_tmp<=0; 
			     Runcnt<=0;
				  state<=Idle;
            end 
			end
	 Run:begin
	     if(Ix_in==a)
		
			if(END_LINE)
			 begin
			 Runcnt<=Runcnt_tmp+1;
			 Runcnt_tmp<=0;
			 mode<=2'b10;
			 state<=Idle;
			 end
		   else
			 begin
			 Runcnt_tmp<=Runcnt_tmp+1;
			 mode<=2'b01;
			 state<=Run;
			 end
			 
		  else
		   begin		 
			Runcnt<=Runcnt_tmp;
			Runcnt_tmp<=0;
			mode<=2'b11;
			state<=Idle;
		   end
	          		  
		 end
	 default:
	        begin
	        state<=Idle;
			  Runcnt<=0;
	        Runcnt_tmp<=0;
	        mode<=0;
			  end
			endcase
	 
	 
	 end
endmodule

