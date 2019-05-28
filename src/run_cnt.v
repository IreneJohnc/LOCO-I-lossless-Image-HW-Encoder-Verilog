`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:44:33 06/18/2010 
// Design Name: 
// Module Name:    run_cnt 
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
module run_cnt(clk,reset,en,
                runcnt_in,
					 mode,
					 limit_reduce,
				//	 codes_1,
					 codes_len1,
					 codes_2,
					 codes_len2,
					 mode_out,
					 en_out);
					 
input        clk;
input        reset;
input        en;
input signed [9:0]  runcnt_in;
input [1:0]  mode;	
output  [3:0]  limit_reduce;

//output[23:0] codes_1;
output[5:0]  codes_len1;
output[10:0] codes_2;
output[3:0]  codes_len2;
output[1:0] mode_out;
output       en_out;				 
					 
wire s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,
     s14,s15,s16,s17,s18,s19,s20,s21,s22,s23,s24;
wire en_tmp;	  
reg signed [9:0] runcnt_reduce;
reg [1:0] mode_tmp;
reg [5:0] run_index;
reg [3:0] tmp;
reg [3:0] tmp_1;
reg en_next;

reg [5:0] index_tmp;
reg signed [9:0]  runcnt_con;
//reg [23:0] codes_1;
reg [5:0]  codes_len1;
reg [10:0] codes_2;
reg [3:0]  codes_len2;
reg [3:0]  limit_reduce;
reg [1:0] mode_out;
reg       en_out;

wire signed [9:0]  runcnt; 
wire [23:0] sig;
assign en_tmp=(mode>1)?1:0;	 
	 
assign runcnt=runcnt_in+runcnt_con;	 	 
assign s1=(runcnt>=10'b0000_0000_01)?1:0;
assign s2=(runcnt>=10'b0000_0000_10)?1:0;
assign s3=(runcnt>=10'b0000_0000_11)?1:0;
assign s4=(runcnt>=10'b0000_0001_00)?1:0;
assign s5=(runcnt>=10'b0000_0001_10)?1:0;
assign s6=(runcnt>=10'b0000_0010_00)?1:0;
assign s7=(runcnt>=10'b0000_0010_10)?1:0;
assign s8=(runcnt>=10'b0000_0011_00)?1:0;
assign s9=(runcnt>=10'b0000_0100_00)?1:0;
assign s10=(runcnt>=10'b0000_0101_00)?1:0;	 

assign s11=(runcnt>=10'b0000_0110_00)?1:0;
assign s12=(runcnt>=10'b0000_0111_00)?1:0;
assign s13=(runcnt>=10'b0000_1001_00)?1:0;
assign s14=(runcnt>=10'b0000_1011_00)?1:0;
assign s15=(runcnt>=10'b0000_1101_00)?1:0;
assign s16=(runcnt>=10'b0000_1111_00)?1:0;
assign s17=(runcnt>=10'b0001_0011_00)?1:0;
assign s18=(runcnt>=10'b0001_0111_00)?1:0;
assign s19=(runcnt>=10'b0001_1111_00)?1:0;
assign s20=(runcnt>=10'b0010_0111_00)?1:0;	  

assign s21=(runcnt>=10'b0011_0111_00)?1:0;
assign s22=(runcnt>=10'b0100_0111_00)?1:0;
assign s23=(runcnt>=10'b0110_0111_00)?1:0;
assign s24=(runcnt>=10'b1000_0111_00)?1:0;
assign sig={s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20,s21,s22,s23,s24};

always@(posedge clk or negedge reset)
if(!reset)
begin
 runcnt_reduce<=0;
 mode_tmp<=0;
 run_index<=0;
 tmp<=0;
 tmp_1<=0;
 en_next<=0;
end
else if(en&en_tmp)
begin
 mode_tmp<=mode;
 en_next<=1;
case(sig)
24'b1000_0000_0000_0000_0000_0000: //1
                 begin
					  runcnt_reduce<=0;
					  run_index<=1;
					  tmp<=0;
					  tmp_1<=0;
					  end
24'b1100_0000_0000_0000_0000_0000: //2
                 begin
					  runcnt_reduce<=0;
					  run_index<=2;
					  tmp<=0;
					  tmp_1<=0;
					  end
24'b1110_0000_0000_0000_0000_0000: //3
                 begin
					  runcnt_reduce<=0;
					  run_index<=3;
					  tmp<=0;
					  tmp_1<=0;
					  end
24'b1111_0000_0000_0000_0000_0000://4
                 begin
					  runcnt_reduce<=runcnt-10'b0000_0001_00;
					  run_index<=4;
					  tmp<=1;
					  tmp_1<=0;
					  end
24'b1111_1000_0000_0000_0000_0000://5
                 begin
					  runcnt_reduce<=runcnt-10'b0000_0001_10;
					  run_index<=5;
					  tmp<=1;
					  tmp_1<=1;
					  end
24'b1111_1100_0000_0000_0000_0000://6
                 begin
					  runcnt_reduce<=runcnt-10'b0000_0010_00;
					  run_index<=6;
					  tmp<=1;
					  tmp_1<=1;
					  end
24'b1111_1110_0000_0000_0000_0000://7
                 begin
					  runcnt_reduce<=runcnt-10'b0000_0010_10;
					  run_index<=7;
					  tmp<=1;
					  tmp_1<=1;
					  end
24'b1111_1111_0000_0000_0000_0000://8
                 begin
					  runcnt_reduce<=runcnt-10'b0000_0011_00;
					  run_index<=8;
					  tmp<=2;
					  tmp_1<=1;
					  end
24'b1111_1111_1000_0000_0000_0000://9
                 begin
					  runcnt_reduce<=runcnt-10'b0000_0100_00;
					  run_index<=9;
					  tmp<=2;
					  tmp_1<=2;
					  end
24'b1111_1111_1100_0000_0000_0000://10
                 begin
					  runcnt_reduce<=runcnt-10'b0000_0101_00;
					  run_index<=10;
					  tmp<=2;
					  tmp_1<=2;
					  end
24'b1111_1111_1110_0000_0000_0000://11
                 begin
					  runcnt_reduce<=runcnt-10'b0000_0110_00;
					  run_index<=11;
					  tmp<=2;
					  tmp_1<=2;
					  end
24'b1111_1111_1111_0000_0000_0000://12
                 begin
					  runcnt_reduce<=runcnt-10'd28;
					  run_index<=12;
					  tmp<=3;
					  tmp_1<=2;
					  end
24'b1111_1111_1111_1000_0000_0000://13
                 begin
					  runcnt_reduce<=runcnt-10'd36;
					  run_index<=13;
					  tmp<=3;
					  tmp_1<=3;
					  end
24'b1111_1111_1111_1100_0000_0000://14
                 begin
					  runcnt_reduce<=runcnt-10'd44;
					  run_index<=14;
					  tmp<=3;
					  tmp_1<=3;
					  end
24'b1111_1111_1111_1110_0000_0000://15
                 begin
					  runcnt_reduce<=runcnt-10'd52;
					  run_index<=15;
					  tmp<=3;
					  tmp_1<=3;
					  end
24'b1111_1111_1111_1111_0000_0000://16
                 begin
					  runcnt_reduce<=runcnt-10'd60;
					  run_index<=16;
					  tmp<=4;
					  tmp_1<=3;
					  end
24'b1111_1111_1111_1111_1000_0000://17
                 begin
					  runcnt_reduce<=runcnt-10'd76;
					  run_index<=17;
					  tmp<=4;
					  tmp_1<=4;
					  end
24'b1111_1111_1111_1111_1100_0000://18
                 begin
					  runcnt_reduce<=runcnt-10'd92;
					  run_index<=18;
					  tmp<=5;
					  tmp_1<=4;
					  end
24'b1111_1111_1111_1111_1110_0000://19
                 begin
					  runcnt_reduce<=runcnt-10'd124;
					  run_index<=19;
					  tmp<=5;
					  tmp_1<=5;
					  end
24'b1111_1111_1111_1111_1111_0000://20
                 begin
					  runcnt_reduce<=runcnt-10'd156;
					  run_index<=20;
					  tmp<=6;
					  tmp_1<=5;
					  end
24'b1111_1111_1111_1111_1111_1000://21
                 begin
					  runcnt_reduce<=runcnt-10'd220;
					  run_index<=21;
					  tmp<=6;
					  tmp_1<=6;
					  end
24'b1111_1111_1111_1111_1111_1100://22
                 begin
					  runcnt_reduce<=runcnt-10'd284;
					  run_index<=22;
					  tmp<=7;
					  tmp_1<=6;
					  end		
24'b1111_1111_1111_1111_1111_1110://23
                 begin
					  runcnt_reduce<=runcnt-10'd412;
					  run_index<=23;
					  tmp<=7;
					  tmp_1<=7;
					  end
24'b1111_1111_1111_1111_1111_1111://24
                 begin
					  runcnt_reduce<=runcnt-10'd540;
					  run_index<=24;
					  tmp<=8;
					  tmp_1<=7;
					  end		
default:		     begin
                 runcnt_reduce<=0;
					  run_index<=0;
					  tmp<=0;
					  tmp_1<=0;
                 end	
  endcase					  
end
else begin
     runcnt_reduce<=0;
     mode_tmp<=0;
     run_index<=0;
     en_next<=0;
	  tmp<=0;
	  tmp_1<=0;
     end
	  
always@(posedge clk or negedge reset)	  
 if(!reset)
   begin
	runcnt_con<=0;
	end
 else 
   if(en&en_tmp)
	 begin
	 if(mode==2'b11) begin
	 
	 case(sig)
	 24'b0000_0000_0000_0000_0000_0000:runcnt_con<=0;		
	 24'b1000_0000_0000_0000_0000_0000:runcnt_con<=0;
	 24'b1100_0000_0000_0000_0000_0000:runcnt_con<=1;
	 24'b1110_0000_0000_0000_0000_0000:runcnt_con<=2;
	 24'b1111_0000_0000_0000_0000_0000:runcnt_con<=3;
	 24'b1111_1000_0000_0000_0000_0000:runcnt_con<=4;
	 24'b1111_1100_0000_0000_0000_0000:runcnt_con<=6;
	 24'b1111_1110_0000_0000_0000_0000:runcnt_con<=8;
	 24'b1111_1111_0000_0000_0000_0000:runcnt_con<=10;
	 24'b1111_1111_1000_0000_0000_0000:runcnt_con<=12;
	 24'b1111_1111_1100_0000_0000_0000:runcnt_con<=16;
	 24'b1111_1111_1110_0000_0000_0000:runcnt_con<=20;
	 24'b1111_1111_1111_0000_0000_0000:runcnt_con<=24;
	 24'b1111_1111_1111_1000_0000_0000:runcnt_con<=28;
	 24'b1111_1111_1111_1100_0000_0000:runcnt_con<=36;
	 24'b1111_1111_1111_1110_0000_0000:runcnt_con<=44;
	 24'b1111_1111_1111_1111_0000_0000:runcnt_con<=52;
	 24'b1111_1111_1111_1111_1000_0000:runcnt_con<=60;
	 24'b1111_1111_1111_1111_1100_0000:runcnt_con<=76;
	 24'b1111_1111_1111_1111_1110_0000:runcnt_con<=92;
	 24'b1111_1111_1111_1111_1111_0000:runcnt_con<=124;
	 24'b1111_1111_1111_1111_1111_1000:runcnt_con<=156;
	 24'b1111_1111_1111_1111_1111_1100:runcnt_con<=220;
	 24'b1111_1111_1111_1111_1111_1110:runcnt_con<=284;
	 24'b1111_1111_1111_1111_1111_1111:runcnt_con<=412;
					//24:runcnt_con<=540;
					default:runcnt_con<=runcnt_con;
				endcase
		end
	 else if(mode==2'b10)
	  begin
	   case(sig)
	 24'b0000_0000_0000_0000_0000_0000:runcnt_con<=0;		
	 24'b1000_0000_0000_0000_0000_0000:runcnt_con<=1;
	 24'b1100_0000_0000_0000_0000_0000:runcnt_con<=2;
	 24'b1110_0000_0000_0000_0000_0000:runcnt_con<=3;
	 24'b1111_0000_0000_0000_0000_0000:runcnt_con<=4;
	 24'b1111_1000_0000_0000_0000_0000:runcnt_con<=6;
	 24'b1111_1100_0000_0000_0000_0000:runcnt_con<=8;
	 24'b1111_1110_0000_0000_0000_0000:runcnt_con<=10;
	 24'b1111_1111_0000_0000_0000_0000:runcnt_con<=12;
	 24'b1111_1111_1000_0000_0000_0000:runcnt_con<=16;
	 24'b1111_1111_1100_0000_0000_0000:runcnt_con<=20;
	 24'b1111_1111_1110_0000_0000_0000:runcnt_con<=24;
	 24'b1111_1111_1111_0000_0000_0000:runcnt_con<=28;
	 24'b1111_1111_1111_1000_0000_0000:runcnt_con<=36;
	 24'b1111_1111_1111_1100_0000_0000:runcnt_con<=44;
	 24'b1111_1111_1111_1110_0000_0000:runcnt_con<=52;
	 24'b1111_1111_1111_1111_0000_0000:runcnt_con<=60;
	 24'b1111_1111_1111_1111_1000_0000:runcnt_con<=76;
	 24'b1111_1111_1111_1111_1100_0000:runcnt_con<=92;
	 24'b1111_1111_1111_1111_1110_0000:runcnt_con<=124;
	 24'b1111_1111_1111_1111_1111_0000:runcnt_con<=156;
	 24'b1111_1111_1111_1111_1111_1000:runcnt_con<=220;
	 24'b1111_1111_1111_1111_1111_1100:runcnt_con<=284;
	 24'b1111_1111_1111_1111_1111_1110:runcnt_con<=412;
	 24'b1111_1111_1111_1111_1111_1111:runcnt_con<=540;
	 default:runcnt_con<=runcnt_con;
				endcase
	  end
	 else 
	   runcnt_con<=runcnt_con;
			
	 end
  else
    begin
	  runcnt_con<=runcnt_con;
	 end
	
    
always@(posedge clk or negedge reset)
if(!reset)
begin
//codes_1<=0;
codes_len1<=0;
codes_2<=0;
codes_len2<=0;
index_tmp<=0;
limit_reduce<=0;
//runcnt_con<=0;
mode_out<=0;
en_out<=0;
end
else if(en_next)
begin
   en_out<=1;
	mode_out<=mode_tmp;
   case(mode_tmp)
    2'b10:begin
	      limit_reduce<=0;
			codes_len1<=run_index-index_tmp;
			index_tmp<=run_index;
	//		runcnt_con<=runcnt_con;
			
		//	if(index>)
			
	      if(runcnt_reduce>0)
			 begin
			  codes_2<=1;
			  codes_len2<=1;
			 end
			else
			 begin
			  codes_2<=0;
			  codes_len2<=0;
			 end
			
         end
    2'b11:begin
			codes_2<=runcnt_reduce;
			codes_len2<=tmp+1;
			codes_len1<=run_index-index_tmp;
			
			if(run_index>0) begin
			    limit_reduce<=tmp_1; 
				 index_tmp<=run_index-1;	  
				   end
			 else  begin
			     limit_reduce<=tmp;
			     index_tmp<=run_index;  
				  end
          end
   default:begin
          codes_len1<=0;
          codes_2<=0;
          codes_len2<=0;
          limit_reduce<=0;
			 index_tmp<=index_tmp;
//			 runcnt_con<=runcnt_con;
          end
			 endcase
end
else begin
//codes_1<=0;
codes_len1<=0;
codes_2<=0;
codes_len2<=0;
limit_reduce<=0;
mode_out<=0;
index_tmp<=index_tmp;
//runcnt_con<=runcnt_con;
en_out<=0;
end


endmodule
