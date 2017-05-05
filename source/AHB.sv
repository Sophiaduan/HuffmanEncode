/* Description:  The wrapper file of AHB
*/

module AHB
(
input wire HCLK,
input wire HRESETn,
input wire [31:0] HADDR,
input wire [31:0] HRDATA,
input wire [31:0] HWDATA,
input wire HWRITE,
input wire [2:0] HBURST,
input wire [2:0] HSIZE,
input wire finish_all,
input wire done,
output reg HRESP,
output reg stop,
output reg start,
output reg [15:0] file_size,
output reg [31:0] data_save,
output reg HREADY
);

ahb part1(.HCLK(HCLK), .HRESETn(HRESETn), .HADDR(HADDR), .HRDATA(HRDATA), .HWDATA(HWDATA), .HWRITE(HWRITE), .HBURST(HBURST), .HSIZE(HSIZE),
		.finish_cnt(finish_all), .HRESP(HRESP), .done_four_bit(done), .stop(stop), .start(start), .file_size(file_size), .data_save(data_save), .HREADY(HREADY));

ahb_resp RESP(.HCLK(HCLK), .HRESETn(HRESETn), .HREADY(HREADY), .HRESP(HRESP));

endmodule