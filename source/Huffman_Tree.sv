module Huffman_Tree
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
output reg flag_accum,
output reg [15:0]count_size,
output reg stop,
output reg [533:0][15:0] array,
output reg build_tree_finish
);

reg [127:0][15:0] curr_count;
reg build_tree_start;


Huffman_Read huffman(.clk(clk), .reset(reset), .HADDR(HADDR), .HRDATA(HRDATA), .HWDATA(HWDATA), .HWRITE(HWRITE), .HBURST(HBURST), .HSIZE(HSIZE), .clear(clear),
			.HRESP(HRESP), .start(start), .curr_count(curr_count), .flag_accum(flag_accum), .count_size(count_size), .stop(stop), .flag_size(build_tree_start));
tree_construct TREE(.clk(clk), .reset(reset), .build_tree_start(build_tree_start), .curr_count(curr_count), .build_tree_finish(build_tree_finish), .array(array));

endmodule
	
