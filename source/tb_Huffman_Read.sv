`timescale 1ns / 100ps

module tb_Huffman_Read();

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
	
	wire tb_start;
	wire [127:0][15:0] tb_curr_count;
	wire tb_HRESP;
	wire tb_flag_accum;
	wire [15:0] tb_count_size;
	wire tb_stop;
	wire tb_flag_size;

	//Declare under DUT
	reg expect_start;
	reg [127:0][15:0] expect_curr_count;
	reg expect_HRESP;
	reg expect_flag_accum;
	reg [15:0] expect_count_size;
	reg expect_stop;
	reg expect_flag_size;


	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end

	Huffman_Read DUT(.clk(tb_clk), .reset(tb_reset), .HADDR(tb_HADDR), .HRDATA(tb_HRDATA), .HWDATA(tb_HWDATA), .HWRITE(tb_HWRITE), .HBURST(tb_HBURST), .HSIZE(tb_HSIZE),
				.clear(tb_clear), .start(tb_start), .curr_count(tb_curr_count), .HRESP(tb_HRESP), .flag_accum(tb_flag_accum), 
					.count_size(tb_count_size), .stop(tb_stop), .flag_size(tb_flag_size));

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

	expect_start = 0;
	expect_curr_count = 0;
	expect_HRESP = 0;
	expect_flag_accum = 0;
	expect_count_size = 0;
	expect_stop = 0;
	expect_flag_size = 0;

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
	if ((expect_start == tb_start) && (expect_curr_count == tb_curr_count) && (expect_flag_accum == tb_flag_accum) 
		&& (expect_stop == tb_stop) && (expect_count_size == tb_count_size) && (expect_HRESP == tb_HRESP))
		$info("%s Case %0d:: PASSED", NAME, tb_test_num);
	else // Test case failed
		$error("%s Case %0d:: FAILED", NAME, tb_test_num);
	// De-assert reset for a cycle
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
	expect_stop = 1;
	expect_count_size = 4;
	expect_curr_count[3] = 1;
	expect_curr_count[0] = 1;
	expect_curr_count[20] = 1;
	expect_curr_count[12] = 1;
	#1ns
	if ((expect_start == tb_start) && (expect_curr_count == tb_curr_count) && (expect_flag_accum == tb_flag_accum) 
		&& (expect_stop == tb_stop) && (expect_count_size == tb_count_size) && (expect_HRESP == tb_HRESP))
		$info("%s Case %0d:: PASSED", NAME, tb_test_num);
	else // Test case failed
		$error("%s Case %0d:: FAILED", NAME, tb_test_num);


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
	expect_stop = 1;
	expect_count_size = 8;
	expect_curr_count[3] = 1;
	expect_curr_count[0] = 2;
	expect_curr_count[20] = 1;
	expect_curr_count[12] = 2;
	expect_curr_count[8] = 1;
	expect_curr_count[9] = 1;
	#1ns
	if ((expect_start == tb_start) && (expect_curr_count == tb_curr_count) && (expect_flag_accum == tb_flag_accum) 
		&& (expect_stop == tb_stop) && (expect_count_size == tb_count_size) && (expect_HRESP == tb_HRESP))
		$info("%s Case %0d:: PASSED", NAME, tb_test_num);
	else // Test case failed
		$error("%s Case %0d:: FAILED", NAME, tb_test_num);
/*
	tb_HRDATA = 1;
	@(negedge tb_clk)
	expect_start = 1;

	if ((expect_start == tb_start) && (expect_curr_count == tb_curr_count) && (expect_flag_accum == tb_flag_accum) 
		&& (expect_stop == tb_stop) && (expect_count_size == tb_count_size) && (expect_HRESP == tb_HRESP))
		$info("%s Case %0d:: PASSED", NAME, tb_test_num);
	else // Test case failed
		$error("%s Case %0d:: FAILED", NAME, tb_test_num);
	// De-assert reset for a cycle

	//Test 3 Check file size
	@(negedge tb_clk)
	tb_test_num = tb_test_num + 1;
	tb_HADDR = 1001;
	tb_HRDATA = 12;
	expect_start = 0;
	@(negedge tb_clk)

	//Test 4
	@(negedge tb_clk)
	tb_test_num = tb_test_num + 1;
	tb_HADDR = 1002;
	tb_HRDATA[7:0] = 3;
	tb_HRDATA[15:8] = 0;
	tb_HRDATA[23:16] = 20;
	tb_HRDATA[31:24] = 12;
	@(negedge tb_clk)
	tb_HADDR = 1003;

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
	expect_stop = 1;

	//Test 5
	@(negedge tb_clk)
	tb_test_num = tb_test_num + 1;
	tb_HADDR = 1000;
	tb_HRDATA = 1;
	@(negedge tb_clk)
	expect_start = 1;
	expect_count_size = 12;
	expect_stop = 0;

	#1ns
	if ((expect_start == tb_start) && (expect_curr_count == tb_curr_count) && (expect_flag_accum == tb_flag_accum) 
		&& (expect_stop == tb_stop) && (expect_count_size == tb_count_size) && (expect_HRESP == tb_HRESP))
		$info("%s Case %0d:: PASSED", NAME, tb_test_num);
	else // Test case failed
		$error("%s Case %0d:: FAILED", NAME, tb_test_num);
	// De-assert reset for a cycle

	//Test 6 Check file size
	@(negedge tb_clk)
	tb_test_num = tb_test_num + 1;
	tb_HADDR = 1001;
	tb_HRDATA = 12;
	expect_start = 0;
	@(negedge tb_clk)

//Test 4
	@(negedge tb_clk)
	tb_test_num = tb_test_num + 1;
	tb_HADDR = 1002;
	tb_HRDATA[7:0] = 3;
	tb_HRDATA[15:8] = 8;
	tb_HRDATA[23:16] = 9;
	tb_HRDATA[31:24] = 12;
	@(negedge tb_clk)
	tb_HADDR = 1003;

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
	expect_stop = 1;

	//Test 5
	@(negedge tb_clk)
	tb_test_num = tb_test_num + 1;
	tb_HADDR = 1000;
	tb_HRDATA = 1;
	@(negedge tb_clk)
	expect_start = 1;
	expect_count_size = 12;
	expect_stop = 0;

	#1ns
	if ((expect_start == tb_start) && (expect_curr_count == tb_curr_count) && (expect_flag_accum == tb_flag_accum) 
		&& (expect_stop == tb_stop) && (expect_count_size == tb_count_size) && (expect_HRESP == tb_HRESP))
		$info("%s Case %0d:: PASSED", NAME, tb_test_num);
	else // Test case failed
		$error("%s Case %0d:: FAILED", NAME, tb_test_num);
	// De-assert reset for a cycle

	//Test 6 Check file size
	@(negedge tb_clk)
	tb_test_num = tb_test_num + 1;
	tb_HADDR = 1001;
	tb_HRDATA = 12;
	expect_start = 0;
	@(negedge tb_clk)

//Test 4
	@(negedge tb_clk)
	tb_test_num = tb_test_num + 1;
	tb_HADDR = 1002;
	tb_HRDATA[7:0] = 126;
	tb_HRDATA[15:8] = 127;
	tb_HRDATA[23:16] = 12;
	tb_HRDATA[31:24] = 120;
	@(negedge tb_clk)
	tb_HADDR = 1003;

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
	expect_stop = 1;
*/
end
endmodule