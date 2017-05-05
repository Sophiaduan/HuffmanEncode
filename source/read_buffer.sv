// $Id: $
// File name:   tree_comb.sv
// Created:     4/15/2017
// Author:      Yuqin Duan
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: 

module read_buffer
(
 input wire clk,
 input wire reset,
 input wire [31:0] data_save,
 input wire [2:0] count_out,
 input wire count_enable,
 output reg [127:0][15:0] curr_count,
 output reg finish_cnt
);

 reg [7:0] data1;
 reg [7:0] data2;
 reg [7:0] data3;
 reg [7:0] data4;
 wire [7:0] data_pro;
 reg [127:0] sig_detect;
 integer i = 0;
 integer j;
 reg [127:0] count_choose;
 //wire [15:0][127:0] new_count = '0;
 reg [127:0][15:0] count_in = '0;
 reg finish_cnt_temp;
 //wire [15:0] adder_input;


assign data1 = data_save[7:0];
assign data2 = data_save[15:8];
assign data3 = data_save[23:16];
assign data4 = data_save[31:24];

//The mux to choose different 4 bytes
always_comb begin
  if (count_out == 4) begin
	finish_cnt_temp = 1;
  end
  else
	finish_cnt_temp = 0;
end

assign data_pro = (count_out == 1) ? data1:((count_out == 2) ? data2 : ((count_out == 3) ? data3:((count_out == 4) ? data4 : 0)));
//Assign which character is detected
/*always_comb begin
  sig_detect = '0;
  j = 0;
  while (data_pro != j) begin
	j = j+1;
	//sig_detect[j] = 1;
  end
  sig_detect[j] = count_enable;
end*/

always_comb begin
  sig_detect = '0;
  sig_detect[data_pro] = count_enable;
end

//Choose the count based on detect signal
always_comb begin
  for(i = 0; i < 128; i=i+1) begin
	if (sig_detect[i] == 1) begin
		count_in[i] = curr_count[i] + 1;
	end
	else 
		count_in[i] = curr_count[i];
  end
end

//Register to save count
always_ff @(posedge clk, negedge reset) begin
  if(reset == 0) begin
	curr_count <= 0;
	finish_cnt <= 0;
  end
  else begin
	curr_count <= count_in;
	finish_cnt <= finish_cnt_temp;
  end
end

endmodule


