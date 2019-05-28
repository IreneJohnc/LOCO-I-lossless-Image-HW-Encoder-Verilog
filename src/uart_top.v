`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:26:56 07/26/2010 
// Design Name: 
// Module Name:    uart_top 
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
module uart_top(clk,
                rst_n,
					 rx,
					 tx,
					 );
					 
 input             clk;    //AD16
 input             rst_n;  //user input  pin D10
 input				 rx;     //C8
 output				 tx;     //C9
 
 
wire rst;
reg t_out;
wire r_in;

 
reg [7:0] byte_out;

wire [7:0] rx_byte;
wire [7:0] tx_byte;
wire is_transmitting;
wire empty;

reg fifo_out_en;
reg uart_out;

wire recv_error;
wire is_receiving;

wire clk_out;
assign rst=!rst_n;

//wire CLKFX_OUT, LOCKED_OUT, CLKIN_IBUFG_OUT,clk_fd,clk_fdtmp;

//IBUFG mbufg(.I(clk_out),.O(clk_fdtmp));
/*mydcm mudcm(.CLKFB_IN(), 
             .CLKIN_IN(clk), 
             .CLKFX_OUT(clk_out), 
             .CLKIN_IBUFG_OUT(), 
             .CLK0_OUT(), 
             .LOCKED_OUT(LOCKED_OUT));
*/
//CLKDLL mydll(.CLKIN(clk),.CLKFB(clk_out),.RST(0),.CLK0(clk_out));				 
				
assign clk_out=clk;
always@(posedge clk_out)
begin

 if(rst)
   begin
	byte_out<=0;
	t_out<=0;
	end
 else if(r_in)
   begin
   byte_out<=rx_byte;
   t_out<=1;
   end
 else begin
      byte_out<=0;
      t_out<=0;
      end
end




always@(posedge clk_out)
begin
if(rst) begin
 fifo_out_en<=0;
 end
else if((empty==0)&&(is_transmitting==0))
 begin
 fifo_out_en<=1;
 end
 else 
 begin
 fifo_out_en<=0;
 end
 
 if(rst)
  uart_out<=0;
  else if(fifo_out_en)
  uart_out<=1;
  else
  uart_out<=0; 
end

 
myfifo ififo(
	      .clk(clk_out),
	      .din(byte_out),
	      .rd_en(fifo_out_en),
	      .rst(rst),        
	      .wr_en(t_out),
	      .dout(tx_byte),
	      .empty(empty),
	      .full());
			
 uart myuart(.clk(clk_out),.rst(rst),
      .send_data(tx_byte),.send(uart_out),
		.recv_data(rx_byte),.receved(r_in),
		.is_sending(is_transmitting),
		.rx(rx),.tx(tx)
    );
/*
uart  myuart(
     .clk(clk_out), 
     .rst(rst),
     .rx(rx), 
     .tx(tx), 
     .transmit(uart_out), 
     .tx_byte(tx_byte), 
     .received(r_in), 
     .rx_byte(rx_byte), 
     .is_receiving(is_receiving), 
     .is_transmitting(is_transmitting), 
     .recv_error(recv_error)
    );
	 */
	 
	 
	 
endmodule
