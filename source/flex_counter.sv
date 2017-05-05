module flex_counter
#(
  parameter NUM_CNT_BITS = 4
)
(
  input wire clk,
  input wire n_rst,
  input wire clear,
  input wire count_enable,
  input wire [NUM_CNT_BITS-1:0] rollover_val,
  output reg [NUM_CNT_BITS-1:0] count_out,
  output reg rollover_flag
);
reg [NUM_CNT_BITS - 1:0] result;
reg [NUM_CNT_BITS - 1:0] outcome;
reg flag;





always_comb begin
	result = '0;
	if((clear == 1'b0) && (rollover_val != 0)) begin
		if ((count_enable == 1'b1) && (rollover_val <= outcome)) begin
			result = 1;
		end
		else if (count_enable == 1'b1)begin
			result = outcome + 1;
		end
		else if (count_enable == 1'b0) begin
			result = outcome;
		end
	end
end

always_comb begin
	flag = 1'b0;
	if ((clear == 1'b0) && ((rollover_val <= outcome) && (count_enable == 1'b1)) || ((outcome == rollover_val - 1) && (count_enable == 1'b1)) || ((rollover_val == 1'b1) && (clear == 1'b0))) begin   //Just modify this
		flag = 1'b1;
	end
end

always_ff @ (posedge clk, negedge n_rst) begin
	if (1'b0 == n_rst) begin
		outcome <= '0;
		rollover_flag <= 0;
	end
	else begin
		outcome <= result;
		rollover_flag <= flag;
		/*if (count_out == rollover_val - 1) begin
			rollover_flag <= 1'b1;
		end
		else begin
			rollover_flag <= 1'b0;
		end*/
	end
end

assign count_out = outcome;

                
endmodule