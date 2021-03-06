`timescale 1ns / 100ps

module tb_read_buffer();

	localparam CLK_PERIOD = 2.5;
	localparam NAME = "test";

	//Declare DUT
	integer tb_test_num;
	reg tb_clk;
	reg tb_reset;
	reg [31:0] tb_data_save;
	reg [2:0] tb_count_out;
	reg tb_count_enable;
	wire [127:0][15:0] tb_curr_cnt;
	wire tb_finish_cnt;

	//Declare under DUT
	reg [127:0][15:0] expect_curr_cnt;
	reg expect_finish_cnt;

	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end

	read_buffer DUT(.clk(tb_clk), .reset(tb_reset), .data_save(tb_data_save), .count_enable(tb_count_enable), .count_out(tb_count_out), .curr_count(tb_curr_cnt), .finish_cnt(tb_finish_cnt));

	initial
	begin
	tb_test_num = 0;
	tb_reset = 1;
	tb_data_save = '0;
	tb_count_out = '0;
	tb_count_enable = 0;
	expect_curr_cnt = '0;
	expect_finish_cnt = 0;

	#(0.1);
	//Test 1, check reset
	@(negedge tb_clk);
	tb_test_num = tb_test_num + 1;
	tb_reset = 0;
	@(negedge tb_clk);
	tb_data_save = 0;
	tb_count_out = 0;

	#1ns

	if ((expect_curr_cnt == tb_curr_cnt) && (expect_finish_cnt == tb_finish_cnt))
		$info("%s Case %0d:: PASSED", NAME, tb_test_num);
	else // Test case failed
		$error("%s Case %0d:: FAILED", NAME, tb_test_num);
	// De-assert reset for a cycle
	tb_reset = 1'b1;

	//Test2, have data input but no count enable
	@(negedge tb_clk)
	tb_test_num = tb_test_num + 1;
	tb_data_save[7:0] = 3;
	tb_data_save[15:8] = 0;
	tb_data_save[23:16] = 20;
	tb_data_save[31:24] = 12;
	tb_count_out = 0;
	@(negedge tb_clk)
	@(negedge tb_clk)

	#1ns

	if ((expect_curr_cnt == tb_curr_cnt) && (expect_finish_cnt == tb_finish_cnt))
		$info("%s Case %0d:: PASSED", NAME, tb_test_num);
	else // Test case failed
		$error("%s Case %0d:: FAILED", NAME, tb_test_num);
	// De-assert reset for a cycle

	//Test3, have data input and start to count
	@(negedge tb_clk)
	tb_test_num = tb_test_num + 1;
	tb_count_out = 1;
	tb_count_enable = 1;
	@(negedge tb_clk)
	expect_curr_cnt[3] = 1;
	expect_finish_cnt = 0;

	#1ns

	if ((expect_curr_cnt == tb_curr_cnt) && (expect_finish_cnt == tb_finish_cnt))
		$info("%s Case %0d:: PASSED", NAME, tb_test_num);
	else // Test case failed
		$error("%s Case %0d:: FAILED", NAME, tb_test_num);

	//Test4, keep counting
	tb_test_num = tb_test_num + 1;
	tb_count_out = 3'd2;
	@(negedge tb_clk)
	tb_count_out = 3'd3;
	@(negedge tb_clk)
	tb_count_out = 3'd4;
	expect_curr_cnt[0] = 1;
	expect_curr_cnt[20] = 1;
	expect_curr_cnt[12] = 1;
	expect_finish_cnt = 1;
	@(negedge tb_clk)
	expect_finish_cnt = 1;
	tb_count_enable = 0;
	//tb_count_out = 0;

	#1ns

	if ((expect_curr_cnt == tb_curr_cnt) && (expect_finish_cnt == tb_finish_cnt))
		$info("%s Case %0d:: PASSED", NAME, tb_test_num);
	else // Test case failed
		$error("%s Case %0d:: FAILED", NAME, tb_test_num);
	
end
endmodule