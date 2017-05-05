module Huffman_Read
(
input wire clk,
input wire reset,
input wire [31:0] HADDR,
input wire [31:0] HRDATA,
input wire [31:0] HWDATA,
input wire HWRITE,
input wire [2:0] HBURST,
input wire [2:0] HSIZE,
input wire clear,
output reg HRESP,
output reg start,
output reg [127:0][15:0] curr_count,
output reg flag_accum,
output reg [15:0] count_size,
output reg stop,
output reg flag_size
);

//reg flag_size;
reg [15:0] file_size;
reg [31:0] data_save;
reg HREADY;
reg read_enable;
reg finish_cnt;
reg flag_size_temp;
AHB ahb(.HCLK(clk), .HRESETn(reset), .HADDR(HADDR), .HRDATA(HRDATA), .HWDATA(HWDATA), .HWRITE(HWRITE), .HBURST(HBURST), .HSIZE(HSIZE), .finish_all(flag_size_temp), 
		.done(finish_cnt), .HRESP(HRESP), .start(start), .stop(stop), .file_size(file_size), .data_save(data_save), .HREADY(HREADY));

READ_BUFFER buffer(.clk(clk), .reset(reset), .data_save(data_save), .HREADY(HREADY), .rollover_flag(flag_accum), .curr_count(curr_count), .read_enable(read_enable), .finish_cnt(finish_cnt));

sizeCounter counter(.clk(clk), .n_rst(reset), .clear(clear), .start_processing(read_enable), .data_size(file_size), .count_size(count_size), .rollover_flag(flag_size_temp));

always_ff @(posedge clk, negedge reset) begin
if (reset == 0) 
	flag_size <= 0;
else
 	flag_size <= flag_size_temp;
end

endmodule