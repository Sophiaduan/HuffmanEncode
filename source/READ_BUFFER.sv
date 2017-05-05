module READ_BUFFER
(
  input wire clk,
  input wire reset,
  input wire [31:0] data_save,
  input wire HREADY,
  output reg rollover_flag,
  output reg [127:0][15:0] curr_count,
  output reg read_enable,
  output reg finish_cnt
);

  reg [2:0] count_out;
  reg clear;
  reg enable;
  //reg read_enable;
  //reg finish_cnt;

  control_read control(.clk(clk), .reset(reset), .finish_cnt(finish_cnt), .HREADY(HREADY), .enable(enable), .clear(clear), .read_enable(read_enable));
  accumu_counter counter(.clk(clk), .n_rst(reset), .clear(finish_cnt), .count_enable(enable), .count_out(count_out), .rollover_flag(rollover_flag));
  read_buffer read(.clk(clk), .reset(reset), .data_save(data_save), .count_out(count_out), .count_enable(read_enable), .curr_count(curr_count), .finish_cnt(finish_cnt));


endmodule