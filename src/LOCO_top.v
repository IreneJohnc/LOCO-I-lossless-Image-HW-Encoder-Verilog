`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:04:23 01/08/2011 
// Design Name: 
// Module Name:    loco_top 
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
module loco_top(clk,
           rst_n,
			  rx,
			  tx);

input  clk;
input  rst_n;
input  rx;
output tx;
 

wire        code_en;
wire [7:0]  data_in;
wire [31:0]  codes;
wire         en_out;
wire [31:0]  cod_32;
wire [5:0]   len_32;


 wire transmit;
 wire [7:0] tx_byte;
 wire received;
 wire [7:0] rx_byte;
 
 wire rst;
assign rst=!rst_n;
//===========fifo_in signals
wire [7:0] fifo_in_din;
wire	     fifo_in_rd;          
wire       fifo_in_wr;
wire [7:0] fifo_in_dout;
wire       empty_in;
wire       full_in;	

//===========fifo_in signals
wire [7:0] fifo_out_din;
wire	     fifo_out_rd;          
wire       fifo_out_wr;
wire [7:0] fifo_out_dout;
wire       empty_out;
wire       full_out;	
 
wire       is_sending;
 
wire  clk_g;
IBUFG  ibg(.O(clk_g),.I(clk));
ctrl ctrl(  .clk(clk_g),
            .rst_n(rst_n),				
				.code_en(code_en),
				.data_in(data_in),
				.codes(codes),
				.en_out(en_out),
				.cod_32(cod_32),
				.len_32(len_32),				
				.t_en(transmit),
				.t_data(tx_byte),
				.r_en(received),
				.r_data(rx_byte),
				.is_sending(is_sending),
				
				.fifo_in_din(fifo_in_din),
            .fifo_in_rd(fifo_in_rd),          
            .fifo_in_wr(fifo_in_wr),
            .fifo_in_dout(fifo_in_dout),
            .empty_in(empty_in),
            .full_in(full_in),
				
				.fifo_out_din(fifo_out_din),
            .fifo_out_rd( fifo_out_rd),          
            .fifo_out_wr(fifo_out_wr),
            .fifo_out_dout(fifo_out_dout),
            .empty_out(empty_out),
            .full_out(full_out)
				);

myfifo fifo_in(
	      .clk(clk_g),
	      .din(fifo_in_din),
	      .rd_en(fifo_in_rd),
	      .rst(rst),        
	      .wr_en(fifo_in_wr),
	      .dout(fifo_in_dout),
	      .empty(empty_in),
	      .full(full_in));	
			
myfifo fifo_out(
	      .clk(clk_g),
	      .din(fifo_out_din),
	      .rd_en(fifo_out_rd),
	      .rst(rst),        
	      .wr_en(fifo_out_wr),
	      .dout(fifo_out_dout),
	      .empty(empty_out),
	      .full(full_out));	
			

codec codec(.clk(clk_g),
            .reset(rst_n),
				.en(code_en),
            .data_in(data_in),
				.codes(codes),
				.en_out(en_out),
				.cod_32(cod_32),
				.len_32(len_32)
				 );


uart uart_115200(.clk(clk_g),.rst(rst),
                 .send_data(tx_byte),.send(transmit),
					  .recv_data(rx_byte),.receved(received),
					  .is_sending(is_sending),
					  .rx(rx),.tx(tx)
					  );
endmodule

