`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:57:15 01/08/2011 
// Design Name: 
// Module Name:    ctrl 
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
module ctrl(clk,
            rst_n,
				
				code_en,
				data_in,
				codes,
				en_out,
				cod_32,
				len_32,
				
				t_en,
				t_data,
				r_en,
				r_data,	
				is_sending,
				
				fifo_in_din,
            fifo_in_rd,          
            fifo_in_wr,
            fifo_in_dout,
            empty_in,
            full_in,
				
				fifo_out_din,
            fifo_out_rd,          
            fifo_out_wr,
            fifo_out_dout,
            empty_out,
            full_out
				);

input  clk;
input  rst_n;


output  code_en;
output [7:0]   data_in;
input  [31:0]  codes;
input          en_out;
input  [31:0]  cod_32;
input  [5:0]   len_32;

output       t_en;
output [7:0] t_data;
input        r_en;
input  [7:0] r_data;
input        is_sending;
output [7:0]		fifo_in_din;
output            fifo_in_rd;          
output            fifo_in_wr;
input  [7:0]      fifo_in_dout;
input             empty_in;
input             full_in;
				
output [7:0]		fifo_out_din;
output            fifo_out_rd;          
output            fifo_out_wr;
input  [7:0]      fifo_out_dout;
input             empty_out;
input             full_out;

reg [7:0]		fifo_in_din;
reg            fifo_in_rd;          
reg            fifo_in_wr;

reg [7:0]		fifo_out_din;
reg            fifo_out_rd;          
reg            fifo_out_wr;

 

reg t_en;
reg [7:0] t_data;

reg  code_en;
reg [7:0]   data_in;

reg [13:0] count;
reg count_en;

reg [31:0] codec_buf;
reg code_out_buf;

 

 reg [2:0] counter;
 
		
//receive data from uart ,then put it in fifo_in,
//after empty changed then give it to codec
always@(posedge clk)
if(!rst_n)
begin
 fifo_in_wr<=0;
 fifo_in_din<=0;
end
else if(r_en)
 begin
 fifo_in_wr<=1;
 fifo_in_din<=r_data;
 end
else
 begin
 fifo_in_wr<=0;
 fifo_in_din<=0; 
 end
 
 reg en_able_fifo;
 
 always@(posedge clk)
 if(!rst_n)
  en_able_fifo<=0;
 else if(full_in)
  en_able_fifo<=1;
  
always@(empty_in)
fifo_in_rd=~empty_in&en_able_fifo;
//always@(posedge clk)
//if(!rst_n)
//fifo_in_rd<=0;
//else if(!empty_in)
//fifo_in_rd<=1;
//else fifo_in_rd<=0;

reg fifo_in_rdtmp;

always@(posedge clk)
if(!rst_n)
fifo_in_rdtmp<=0;
else if(fifo_in_rd)
fifo_in_rdtmp<=1;
else fifo_in_rdtmp<=0;

always@(posedge clk)
if(!rst_n)
begin
 code_en<=0;
 data_in<=0;
end
else if(fifo_in_rdtmp)
 begin
 code_en<=1;
 data_in<=fifo_in_dout;
 end
else
 begin
 code_en<=0;
 data_in<=0; 
 end
//receive code stream from codec and give it to fifo_out
always@(posedge clk)
if(!rst_n)
begin
 codec_buf<=0;
 code_out_buf<=0;
end
else begin
 if(en_out) 
 begin
 codec_buf<=codes;
 code_out_buf<=1;
 end
 else if(counter>=3'b100)
  begin
  codec_buf<=0;
  code_out_buf<=0;
  end
 else
  begin
  codec_buf<=codec_buf;
  code_out_buf<=code_out_buf;
  end  
end
// 
always@(posedge clk)
if(!rst_n)
 counter<=0;
else if(code_out_buf)
 counter<=counter+1;
 else counter<=0;
 
 always@*
  if(!rst_n)  begin
  fifo_out_wr<=0;
  fifo_out_din<=0;
  end
  else if(code_out_buf)   begin
   case(counter)
	3'b001:begin
          fifo_out_wr<=1;
          fifo_out_din<=codec_buf[31:24];
          end
	3'b010:begin
          fifo_out_wr<=1;
          fifo_out_din<=codec_buf[23:16];
          end
	3'b011:begin
          fifo_out_wr<=1;
          fifo_out_din<=codec_buf[15:8];
          end
	3'b100:begin
          fifo_out_wr<=1;
          fifo_out_din<=codec_buf[7:0];
          end
	default:begin
          fifo_out_wr<=0;
          fifo_out_din<=0;
          end
	endcase
   end
  else begin
   fifo_out_wr<=0;
   fifo_out_din<=0;
	end
	
// when fifo_out is not empty ,output data to uart	
parameter IDLE   =2'd0,
          FIFO_RD=2'd1,
			 SEND   =2'd2,
			 WAIT   =2'd3;
reg[15:0] timer;
reg  [1:0]     state;

reg is_send_reg0;
reg is_send_reg1;
always@(posedge clk)
  if(!rst_n) 
   state<=IDLE;
  else if(!empty_out) begin
      case(state)
		IDLE   :if(!empty_out) state<=FIFO_RD;
		        else           state<=IDLE;
		FIFO_RD: state<=SEND;
		SEND   :
		        if(~is_send_reg1&is_send_reg0)
		        state<=WAIT;
				  else state<=SEND;
	   WAIT   :if(timer>=16'h1fff)
		        state<=IDLE;
				  else
				  state<=WAIT;
		default:state<=IDLE;
		endcase
		end
	
 always@(posedge clk)
 if(!rst_n) is_send_reg0<=0;
 else is_send_reg0<=is_send_reg1;
 
 always@(posedge clk)
 if(!rst_n) is_send_reg1<=0;
 else is_send_reg1<=is_sending;
 
 always@(posedge clk)
 if(!rst_n)
     timer<=0;
 else if(state==WAIT) 
	  timer<=timer+1;
	else timer<=0;	
	 
always@(*)
if(!rst_n)
 fifo_out_rd<=0;
else if(state==FIFO_RD)
     fifo_out_rd<=1;
else fifo_out_rd<=0;
/*
reg[15:0] timer;
reg       flag;
reg lock;
reg is_send_reg0;
reg is_send_reg1;

always@(posedge clk)
if(!rst_n)
 fifo_out_rd<=0;
 else if(!empty_out) begin   
       if(timer==16'h0fff) 
		     fifo_out_rd<=flag;
		 else(timer==0) fifo_out_rd<=~lock;
		end	
 else
            fifo_out_rd<=0;

always@(posedge clk)
if(!rst_n)
  lock<=0;
 else if(fifo_out_rd) 
  lock<=1;
 
 always@(*)
 if(!rst_n)
   can_send=0;
  else if(timer>=16h0fff)
   can_send=1;
  else if()
 
always@(*)
 if(!rst_n)
     flag=0;
 else if(~is_send_reg1&is_send_reg0)  
     flag=1;
 else if(timer>=16'h0fff) 
	  flag=0; 
 
 always@(posedge clk)
 if(!rst_n) is_send_reg0<=0;
 else is_send_reg0<=is_send_reg1;
 
 always@(posedge clk)
 if(!rst_n) is_send_reg1<=0;
 else is_send_reg1<=is_sending;
 
 always@(posedge clk)
 if(!rst_n)
     timer<=0;
 else if(flag) 
	  timer<=timer+1;
	else timer<=0;
*/
reg fifo_out_rdtmp;

always@(posedge clk)
if(!rst_n)
fifo_out_rdtmp<=0;
else if(fifo_out_rd)
fifo_out_rdtmp<=1;
else fifo_out_rdtmp<=0;   

always@(posedge clk)	  
 if(!rst_n) begin
  t_en<=0;
  t_data<=0;
  end
  else if(fifo_out_rdtmp) begin
  t_en<=1;
  t_data<=fifo_out_dout;
  end
  else begin
   t_en<=0;
   t_data<=0;
  end
  
endmodule