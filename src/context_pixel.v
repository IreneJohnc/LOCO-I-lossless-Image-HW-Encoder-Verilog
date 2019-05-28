`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CSSAR
// Engineer: ChenJun
// 
// Create Date:    19:52:06 01/19/2010 
// Design Name: 
// Module Name:    context_pixel 
// Project Name: 
// Target Devices: 
// Tool versions: ISE 8.2i

//
//////////////////////////////////////////////////////////////////////////////////
module context_pixel(clk, reset, en, data_in, a, b, c, d,Ix,END_LINE,en_out);
    input clk;
    input reset;
    input en;
    input  [7:0] data_in;
    output [7:0] a;
    output [7:0] b;
    output [7:0] c;
    output [7:0] d;
	 output [7:0] Ix;
	 output END_LINE;
	 output en_out;
	 
	 reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] d;
	 reg [7:0] Ix;
	 reg END_LINE;
	 reg en_out;
	 
	 reg [8:0] column_num;

	 reg [8:0] addra;
	 reg [8:0] addrb;
	 reg wea;

	 
	 reg [7:0] Rc_temp;
	 reg [7:0] Rb_temp;
	 
	 reg  [7:0] Ix_reg;
	 
	 wire [7:0] doutb;
	 
	 
			 
always@(posedge clk or negedge reset)
	  if(!reset)
	     en_out<=0;
	  else if(en)
		  en_out<=1;
	  else 
		  en_out<=0;
						 
	  
always@(posedge clk or negedge reset)
	 if(!reset)
		Ix<=0;
	 else if(en)
		Ix<=data_in;
	 else  
		Ix<=0;
	  
	 	
always@(posedge clk or negedge reset)
   if(!reset)
    addra<=0;
   else if(en)
	 addra<=addra+1;

always@*
     if(addra==9'd511)
	  addrb<=9'd0;
	  else 
	  addrb<=addra+1;
	   
		
always@(*)
	 if(!reset)
      wea=0;
    else if(en)
   	wea=1;
    else	
      wea=0;	 
	 

always@(posedge clk or negedge reset)
	 if(!reset)
	  column_num<=0;
	 else if((addra==9'b1111_1111_1)&&(en==1))
	  column_num<=column_num+1;

always@(posedge clk or negedge reset)
	 if(!reset)
	  END_LINE<=0;
	 else if(addra==9'b1111_1111_1)
	  END_LINE<=1;
	 else
	  END_LINE<=0;

always@(posedge clk or negedge reset)
	 if(!reset)
	  Rb_temp<=0;
	 else  if((addra==0)&&(en==1))
	  Rb_temp<=data_in;


always@(posedge clk or negedge reset)
	 if(!reset)
	  Rc_temp<=0;
	 else if((addra==1)&&(en==1))
	  Rc_temp<=a;

always@(posedge clk or negedge reset)
	 if(!reset)
	 begin
		a<=0;
		b<=0;
		c<=0;
		d<=0;
		Ix_reg<=0;
	 end
	 else if(en) 
	 begin
	   Ix_reg<=data_in;
	   if(column_num==0)
		 begin		
		   b<=0;
			c<=0;
			d<=0;
			if(addra==9'b0000_0000_0)
			  a<=0;
			else
			  a<=Ix_reg;
		 end
		else
		  begin
		   case(addra)
			9'b0000_0000_0:
			 begin
			 a<=Rb_temp;
			 b<=Rb_temp;
			 c<=Rc_temp;
			 d<=doutb;
			 end
			9'b1111_1111_1:
			 begin
			 a<=Ix_reg;
			 b<=d;
			 c<=b;
			 d<=d;	
          end			 
			default:
			 begin
			 a<=Ix_reg;
			 b<=d;
			 c<=b;
			 d<=doutb;
			 end
			endcase
		 end 
	 end
	  else begin
	   Ix_reg<=Ix_reg;
	   a<=a;
	   b<=b;
	   c<=c;
	   d<=d;
	  end
	 

	 
	 
row_ram myram(
	.addra(addra),
	.addrb(addrb),
	.clka(clk),
	.clkb(clk),
	.dina(data_in),
	.doutb(doutb),
	.wea(wea));
	
endmodule

