module tree_construct
(
  input wire clk,
  input wire reset,
  input wire build_tree_start,
  input wire [127:0][15:0] curr_count,
  output reg build_tree_finish,
  output reg [533:0][15:0] array
);

  typedef enum logic [3:0] {IDLE, PUSH, GET_DATA, COMPARE, CHECK_END, CALC_SUM, FINISH, STORE_SUM, CLEAR, RESET}
state_type;
state_type state, nextstate;

integer i;
reg [533:0][15:0] array_temp;
reg [15:0] freq_sel;
reg [9:0] freq_addr;
reg [15:0] freq_sel_temp;
reg [9:0] freq_addr_temp;
reg finish_temp;
reg [15:0] min1;
reg [15:0] min1_temp;
reg [15:0] min2;
reg [15:0] min2_temp;
reg [9:0]char1;
reg [9:0]char1_temp;
reg [9:0]char2;
reg [9:0]char2_temp;
reg [15:0] sum;
reg [15:0] sum_temp;
reg [9:0] build_tree_addr;
reg [9:0] build_tree_addr_temp;
reg [9:0] left_tree_addr;
reg [9:0] left_tree_addr_temp;
reg [9:0] right_tree_addr;
reg [9:0] right_tree_addr_temp;

always_ff @(posedge clk, negedge reset) begin
  if (reset == 0) begin
	build_tree_finish <= 0;
	array <= 0;
	array[520] <= 16'hffff;
	freq_sel <= 0;
	freq_addr <= 128;
	build_tree_finish <= 0;
	state <= IDLE;
	min1 <= 16'hffff;
	min2 <= 16'hffff;
	char1 <= 0;
	char2 <= 0;
	sum <= 0;
	build_tree_addr <= 256;
	left_tree_addr <= 257;
	right_tree_addr <= 258;

	

  end
  else begin
	build_tree_finish <= finish_temp;
  	array <= array_temp;
	freq_sel <= freq_sel_temp;
	freq_addr <= freq_addr_temp;
	build_tree_finish <= finish_temp; 
	state <= nextstate;
	min1 <= min1_temp;
	min2 <= min2_temp;
	char1 <= char1_temp;
	char2 <= char2_temp;
	sum <= sum_temp;
	build_tree_addr <= build_tree_addr_temp;
	left_tree_addr <= left_tree_addr_temp;
	right_tree_addr <= right_tree_addr_temp;
  end
end

always_comb begin
  nextstate = state;
  array_temp = array;
  freq_sel_temp = freq_sel;
  freq_addr_temp = freq_addr;
  finish_temp = build_tree_finish;
  min1_temp = min1;
  min2_temp = min2;
  char1_temp = char1;
  char2_temp = char2;
  sum_temp = sum;
  build_tree_addr_temp = build_tree_addr;
  left_tree_addr_temp = left_tree_addr;
  right_tree_addr_temp = right_tree_addr;

  case(state) 
  IDLE: begin
	if (build_tree_start == 1)
		nextstate = PUSH;
  end

  PUSH: begin
	for(i = 128; i <256; i++) begin
		array_temp[i] = curr_count[i - 128];
	end
	nextstate = GET_DATA;
  end

GET_DATA: begin
	freq_sel_temp = array[freq_addr];
	nextstate = COMPARE;
  end

COMPARE: begin
  if (freq_sel == 0) begin
	if (freq_addr < 256) 
		freq_addr_temp = freq_addr + 1;
	else
		freq_addr_temp = freq_addr + 3;
	nextstate = GET_DATA;
  end

  else begin	
	if (min1 > freq_sel) begin  //next min is smaller than the previous one
		min1_temp = freq_sel;
		char1_temp = freq_addr;
		min2_temp = min1;	//min2 is always bigger than min 1
		char2_temp = char1;
	end
	else if (min2 > freq_sel) begin	//If the min data is bigger than the smallest but smaller than the second smallest
		min2_temp = freq_sel;
		char2_temp = freq_addr;
	end
	nextstate = CHECK_END;
  end
end

CHECK_END: begin
	if (freq_sel == 16'hffff)
		nextstate = CALC_SUM;
	else begin
		if (freq_addr < 256)
			freq_addr_temp = freq_addr + 1;
		else
			freq_addr_temp = freq_addr + 3;
		nextstate = GET_DATA;
	end
end

CALC_SUM:  begin
  if (min2 == 16'hffff) //If read to last
	nextstate = FINISH;
  else begin  
	sum_temp = min1 + min2;
	nextstate = STORE_SUM;
  end
end

STORE_SUM: begin
  	array_temp[build_tree_addr] = sum;
	array_temp[left_tree_addr] = char1;
	array_temp[right_tree_addr] = char2;
	build_tree_addr_temp = build_tree_addr + 3;
	left_tree_addr_temp = left_tree_addr + 3;
	right_tree_addr_temp = right_tree_addr + 3;
	nextstate = CLEAR;
end

CLEAR: begin
	array_temp[char1] = 0;
	array_temp[char2] = 0;
	nextstate = RESET;
end

RESET: begin
	freq_sel_temp = 0;
	freq_addr_temp = 128;
	min1_temp = 16'hffff;
	min2_temp = 16'hffff;
	char1_temp = 0;
	char2_temp= 0;
	sum_temp = 0;
	nextstate = GET_DATA;
end

FINISH: begin
	finish_temp = 1;
	min1_temp = 16'hffff;
	min2_temp = 16'hffff;
	nextstate = IDLE;
end

endcase
end

endmodule
	
	
