`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:00:49 12/24/2010 
// Design Name: 
// Module Name:    uartrx 
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
module uartrx(clk, rx, dataout, rdsig, dataerror, frameerror); 
input clk;          //����ʱ�� 
input rx;           //UART�������� 
output dataout;     //����������� 
output rdsig; 
output dataerror;   //���ϳ���ָʾ 
output frameerror;  //֡����ָʾ 
reg[7:0] dataout; 
reg rdsig, dataerror; 
reg frameerror; 
 
  reg [7:0] cnt; 
reg rxbuf, rxfall, receive; 
parameter paritymode = 1'b0; 
reg presult, idle; 
always @(posedge clk)   //�����·���½��� 
begin 
rxbuf <= rx; 
rxfall <= rxbuf & (~rx); 
end 
always @(posedge clk) 
begin 
if (rxfall && (~idle))  //��⵽��·���½��ز���ԭ����·Ϊ���У������������ݽ��� 
begin 
receive <= 1'b1; 
end 
else if(cnt == 8'd175)  //����������� 
begin 
receive <= 1'b0; 
end 
end 
always @(posedge clk) 
begin 
if(receive == 1'b1) 
begin case (cnt) 
8'd0: 
begin 
idle <= 1'b1; 
cnt <= cnt + 8'd1; 
rdsig <= 1'b0; 
end 
8'd24:  //���յ� 0λ���� 
begin 
idle <= 1'b1; 
dataout[0] <= rx; 
presult <= paritymode^rx; 
cnt <= cnt + 8'd1; 
rdsig <= 1'b0; 
end 
8'd40: //���յ� 1λ���� 
begin 
idle <= 1'b1; 
dataout[1] <= rx; 
presult <= presult^rx; 
cnt <= cnt + 8'd1; 
rdsig <= 1'b0; 
end 
8'd56: //���յ� 2λ���� 
begin 
idle <= 1'b1; 
dataout[2] <= rx; 
presult <= presult^rx; 
cnt <= cnt + 8'd1; 
rdsig <= 1'b0; 
end 
8'd72: //���յ� 3λ���� 
begin 
idle <= 1'b1; 
dataout[3] <= rx; 
presult <= presult^rx; 
cnt <= cnt + 8'd1; 
rdsig <= 1'b0; 
end 
8'd88: //���յ� 4λ���� 
begin 
idle <= 1'b1; 
dataout[4] <= rx; 
presult <= presult^rx; 
cnt <= cnt + 8'd1; 
rdsig <= 1'b0; 
end 
8'd104: //���յ� 5λ���� 
begin 
idle <= 1'b1; 
dataout[5] <= rx; 
presult <= presult^rx; 
cnt <= cnt + 8'd1; 
rdsig <= 1'b0; 
end 
8'd120:     //���յ� 6λ���� 
begin 
idle <= 1'b1; 
dataout[6] <= rx; 
presult <= presult^rx; 
cnt <= cnt + 8'd1; 
rdsig <= 1'b0; 
end 
8'd136:     //���յ� 7λ���� 
begin 
idle <= 1'b1; 
dataout[7] <= rx; 
presult <= presult^rx; 
cnt <= cnt + 8'd1; 
rdsig <= 1'b1; 
end 
8'd152:     //������żУ��λ 
begin 
idle <= 1'b1; 
if(presult == rx) 
dataerror <= 1'b0; 
else 
dataerror <= 1'b1;  //�����żУ��λ���ԣ���ʾ���ݳ���    
cnt <= cnt + 8'd1; 
rdsig <= 1'b1; 
end 
8'd168: 
begin 
idle <= 1'b1; 
if(1'b1 == rx) 
frameerror <= 1'b0; 
else 
frameerror <= 1'b1;     //���û�н��յ�ֹͣλ����ʾ֡���� 
cnt <= cnt + 8'd1; 
rdsig <= 1'b1; 
end 
default: 
begin 
cnt <= cnt + 8'd1; 
end 
endcase end 
else 
begin 
cnt <= 8'd0; 
idle <= 1'b0; 
rdsig <= 1'b0; 
end 
end 
endmodule
