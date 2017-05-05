`timescale 1ns / 100ps

module tb_READ_BUFFER();

	localparam CLK_PERIOD = 2.5;
	localparam NAME = "test";

	//Declare DUT
	integer tb_test_num;
	reg tb_clk;
	reg tb_reset;
	reg [31:0] tb_data_save;
	reg tb_HREADY;
	//reg tb_enable;
	wire [127:0][15:0] tb_curr_cnt;
	wire tb_rollover_flag;
	wire tb_read_enable;

	//Declare under DUT
	reg [127:0][15:0] expect_curr_cnt;
	reg expect_rollover_flag;
	reg expect_read_enable;

	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end

	READ_BUFFER DUT(.clk(tb_clk), .reset(tb_reset), .data_save(tb_data_save), .curr_count(tb_curr_cnt), .HREADY(tb_HREADY), 
				.rollover_flag(tb_rollover_flag), .read_enable(read_enable));

	initial
	begin
	tb_test_num = 0;
	tb_reset = 1;
	tb_data_save = '0;
	tb_HREADY = 0;
	expect_curr_cnt = '0;
	expect_rollover_flag = 0;
	expect_read_enable = 0;

	#(0.1);
	//Test 1, check reset
	@(negedge tb_clk);
	tb_test_num = tb_test_num + 1;
	tb_reset = 0;
	@(negedge tb_clk);
	tb_data_save[7:0] = 3;
	tb_data_save[15:8] = 0;
	tb_data_save[23:16] = 20;
	tb_data_save[31:24] = 12;

	#1ns

	if ((expect_curr_cnt == tb_curr_cnt))
		$info("%s Case %0d:: PASSED", NAME, tb_test_num);
	else // Test case failed
		$error("%s Case %0d:: FAILED", NAME, tb_test_num);
	// De-assert reset for a cycle
	tb_reset = 1'b1;

	//Test2, have data input but no count enable
	@(negedge tb_clk)
	tb_test_num = tb_test_num + 1;

	@(negedge tb_clk)
	@(negedge tb_clk)

	#1ns

	if ((expect_curr_cnt == tb_curr_cnt) )
		$info("%s Case %0d:: PASSED", NAME, tb_test_num);
	else // Test case failed
		$error("%s Case %0d:: FAILED", NAME, tb_test_num);
	// De-assert reset for a cycle

	@(negedge tb_clk)
	tb_HREADY = 1;

	
	end
endmodule