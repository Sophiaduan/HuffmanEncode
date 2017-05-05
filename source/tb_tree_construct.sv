`timescale 1ns / 100ps

module tb_tree_construct();

	localparam CLK_PERIOD = 2.5;
	localparam NAME = "test";

	//Declare DUT
	integer tb_test_num;
	reg tb_clk;
	reg tb_reset;
	reg tb_build_tree_start;
	reg [127:0][15:0] tb_curr_count;
	wire tb_finish;
	wire [533:0][15:0] tb_array;

	//Declare under DUT
	reg expect_finish;
	reg [533:0][15:0] expect_array;

	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end

	tree_construct DUT(.clk(tb_clk), .reset(tb_reset), .build_tree_start(tb_build_tree_start), .curr_count(tb_curr_count), .build_tree_finish(tb_finish), .array(tb_array));

	initial
	begin
	tb_test_num = 0;
	tb_reset = 0;
	tb_build_tree_start = 0;
	tb_curr_count = 0;

	expect_finish = 0;
	expect_array = 0;

	#(0.1);
	tb_reset = 1;
	@(negedge tb_clk)
	tb_test_num = tb_test_num + 1;
	tb_reset = 0;
	@(negedge tb_clk)
	tb_curr_count[0] = 5;
	tb_curr_count[3] = 6;
	tb_curr_count[6] = 12;
	tb_curr_count[20] = 8;
	tb_curr_count[127] = 300;
	expect_array[520] = 16'hffff;

	#1ns
	if ((expect_finish == tb_finish) && (expect_array == tb_array))
		$info("%s Case %0d:: PASSED", NAME, tb_test_num);
	else // Test case failed
		$error("%s Case %0d:: FAILED", NAME, tb_test_num);
	tb_reset = 1;

	//Test 2
	@(negedge tb_clk)
	tb_test_num = tb_test_num + 1;
	tb_build_tree_start = 1;
	@(negedge tb_clk)
	@(negedge tb_clk)
	tb_test_num = tb_test_num + 1;
	
	end
endmodule
