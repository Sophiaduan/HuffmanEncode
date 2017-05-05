module sizeCounter
(
  input wire clk,
  input wire n_rst,
  input wire clear,
  input wire start_processing,
  input wire [15:0] data_size,
  output reg [15:0] count_size,
  output reg rollover_flag
);

	flex_counter
	#(
		.NUM_CNT_BITS(16)
	)
	CORE (
		.clk(clk),
		.n_rst(n_rst),
		.clear(clear),
		.count_enable(start_processing),
		.rollover_val(data_size),
		.count_out(count_size),
		.rollover_flag(rollover_flag)
	);
endmodule