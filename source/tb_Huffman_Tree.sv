`timescale 1ns / 100ps

module tb_Huffman_Tree();

	localparam CLK_PERIOD = 2.5;
	localparam NAME = "test";

	//Declare DUT
	integer tb_test_num;
	reg tb_clk;
	reg tb_reset;
	reg [31:0] tb_HADDR;
	reg [31:0] tb_HRDATA;
	reg [31:0] tb_HWDATA;
	reg tb_HWRITE;
	reg [2:0] tb_HBURST;
	reg [2:0] tb_HSIZE;
	reg tb_clear;
	
	wire tb_HRESP;
	wire tb_start;
	wire tb_flag_accum;
	wire [15:0] tb_count_size;
	wire tb_stop;
	wire [533:0][15:0] tb_array;
	wire tb_build_tree_finish;

	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end

	Huffman_Tree Tree(.clk(tb_clk), .reset(tb_reset), .HADDR(tb_HADDR), .HRDATA(tb_HRDATA), .HWDATA(tb_HWDATA), .HWRITE(tb_HWRITE), .HBURST(tb_HBURST), .HSIZE(tb_HSIZE), .flag_accum(tb_flag_accum),
				.clear(tb_clear), .HRESP(tb_HRESP), .start(tb_start), .count_size(tb_count_size), .stop(tb_stop), .array(tb_array), .build_tree_finish(tb_build_tree_finish));

	initial 
	begin
	tb_test_num = 0;
	tb_reset = 0;
	tb_HADDR = 0;
	tb_HRDATA = 0;
	tb_HWDATA = 0;
	tb_HWRITE = 0;
	tb_HBURST = 0;
	tb_HSIZE = 2;
	tb_clear = 0;

	#(0.1);
	tb_reset = 1;
	//Test1 check reset
	@(negedge tb_clk)
	tb_test_num = tb_test_num + 1;
	tb_reset = 0;
	@(negedge tb_clk)
	tb_HADDR = 50;
	tb_HWDATA = 33;
	#1ns
	tb_reset = 1;

//Test 2, check start sign
	@(negedge tb_clk)
	tb_test_num = tb_test_num + 1;
	tb_HADDR = 1000;
	@(negedge tb_clk)
	tb_HADDR = 1001;
	tb_HWDATA = 1;
	@(negedge tb_clk)
	tb_HADDR = 1002;
	tb_HWDATA = 12;
	@(negedge tb_clk)
	tb_HADDR = 1003;
	tb_HWDATA[7:0] = 3;
	tb_HWDATA[15:8] = 0;
	tb_HWDATA[23:16] = 20;
	tb_HWDATA[31:24] = 12;

	@(negedge tb_clk)
	tb_HADDR = 1004;

	@(negedge tb_clk)

	@(negedge tb_clk)
	@(negedge tb_clk)
	@(negedge tb_clk)
	@(negedge tb_clk)
	@(negedge tb_clk)
	@(negedge tb_clk)
	@(negedge tb_clk)
	@(negedge tb_clk)
	@(negedge tb_clk)
	@(negedge tb_clk)
	@(negedge tb_clk)
	@(negedge tb_clk)
	#1ns

//Test 2, check start sign
	@(negedge tb_clk)
	tb_test_num = tb_test_num + 1;
	tb_HADDR = 1000;
	@(negedge tb_clk)
	tb_HADDR = 1001;
	tb_HWDATA = 1;
	@(negedge tb_clk)
	tb_HADDR = 1002;
	tb_HWDATA = 12;
	@(negedge tb_clk)
	tb_HADDR = 1003;
	tb_HWDATA[7:0] = 8;
	tb_HWDATA[15:8] = 0;
	tb_HWDATA[23:16] = 9;
	tb_HWDATA[31:24] = 12;

	@(negedge tb_clk)
	tb_HADDR = 1004;

	@(negedge tb_clk)

	@(negedge tb_clk)
	@(negedge tb_clk)
	@(negedge tb_clk)
	@(negedge tb_clk)
	@(negedge tb_clk)
	@(negedge tb_clk)
	@(negedge tb_clk)
	@(negedge tb_clk)
	@(negedge tb_clk)
	@(negedge tb_clk)
	@(negedge tb_clk)
	@(negedge tb_clk)

//Test 3, check start sign
	@(negedge tb_clk)
	tb_test_num = tb_test_num + 1;
	tb_HADDR = 1000;
	@(negedge tb_clk)
	tb_HADDR = 1001;
	tb_HWDATA = 1;
	@(negedge tb_clk)
	tb_HADDR = 1002;
	tb_HWDATA = 12;
	@(negedge tb_clk)
	tb_HADDR = 1003;
	tb_HWDATA[7:0] = 125;
	tb_HWDATA[15:8] = 0;
	tb_HWDATA[23:16] = 124;
	tb_HWDATA[31:24] = 127;

	@(negedge tb_clk)
	tb_HADDR = 1004;

	@(negedge tb_clk)

	@(negedge tb_clk)
	@(negedge tb_clk)
	@(negedge tb_clk)
	@(negedge tb_clk)
	@(negedge tb_clk)
	@(negedge tb_clk)
	@(negedge tb_clk)
	@(negedge tb_clk)
	@(negedge tb_clk)
	@(negedge tb_clk)
	@(negedge tb_clk)
	@(negedge tb_clk)

//Test 3, check start sign
	@(negedge tb_clk)
	tb_test_num = tb_test_num + 1;
	

end

endmodule