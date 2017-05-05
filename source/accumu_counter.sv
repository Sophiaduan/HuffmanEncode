module accumu_counter
(
  input wire clk,
  input wire n_rst,
  input wire clear,
  input wire count_enable,
  output reg [2:0] count_out,
  output reg rollover_flag
);

wire [2:0] rollover_val = 4;

	flex_counter
	#(
		.NUM_CNT_BITS(3)
	)
	CORE (
		.clk(clk),
		.n_rst(n_rst),
		.clear(clear),
		.count_enable(count_enable),
		.rollover_val(rollover_val),
		.count_out(count_out),
		.rollover_flag(rollover_flag)
	);
endmodule