`timescale 1ns / 100ps

module tb_AHB();

	localparam CLK_PERIOD = 2.5;
	localparam NAME = "test";

	//Declare DUT
	integer tb_test_num;
	reg tb_HCLK;
	reg tb_HRESETn;
	reg [31:0] tb_HADDR;
	reg [31:0] tb_HRDATA;
	reg [31:0] tb_HWDATA;
	reg tb_HWRITE;
	reg [2:0] tb_HBURST;
	reg tb_finish_cnt;
	reg [2:0] tb_HSIZE;
	reg tb_done;
	
	wire tb_HRESP;
	wire tb_stop;
	wire tb_start;
	wire [15:0] tb_file_size;
	wire [31:0] tb_data_save;
	wire tb_HREADY;

	//Declare under DUT
	reg expect_stop;
	reg expect_start;
	reg [15:0] expect_file_size;
	reg [31:0] expect_data_save;
	reg expect_HREADY;
	reg expect_HRESP;

	always
	begin
		tb_HCLK = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_HCLK = 1'b1;
		#(CLK_PERIOD/2.0);
	end

	AHB DUT(.HCLK(tb_HCLK), .HRESETn(tb_HRESETn), .HADDR(tb_HADDR), .HRDATA(tb_HRDATA), .HWDATA(tb_HWDATA), .HREADY(tb_HREADY), .HRESP(tb_HRESP),
			.HWRITE(tb_HWRITE), .HBURST(tb_HBURST), .HSIZE(tb_HSIZE), .finish_all(tb_finish_cnt), .done(tb_done), .start(tb_start), .stop(tb_stop), 
				.file_size(tb_file_size), .data_save(tb_data_save));

	initial
	begin
	tb_test_num = 0;
	tb_HRESETn = 0;
	tb_HADDR = 0;
	tb_HRDATA = 0;
	tb_HWDATA = 0;
	tb_HWRITE = 0;
	tb_HBURST = 0;
	tb_HSIZE = 2;
	tb_finish_cnt = 0;
	tb_done = 0;
	expect_HRESP = 0;
	expect_start = 0;
	expect_stop = 0;
	expect_file_size = 0;
	expect_data_save = 0;
	expect_HREADY = 1;

	#(0.1);
	tb_HRESETn = 1;
	//Test 1, check reset
	@(negedge tb_HCLK);
	tb_test_num = tb_test_num + 1;
	tb_HRESETn = 0;
	@(negedge tb_HCLK);
	tb_HADDR = 50;
	tb_HRDATA = 33;
	#1ns

	if ((expect_file_size == tb_file_size) && (expect_data_save == tb_data_save) && (expect_start == tb_start) 
		&& (expect_stop == tb_stop) && (expect_HREADY == tb_HREADY) && (expect_HRESP == tb_HRESP))
		$info("%s Case %0d:: PASSED", NAME, tb_test_num);
	else // Test case failed
		$error("%s Case %0d:: FAILED", NAME, tb_test_num);
	// De-assert reset for a cycle
	tb_HRESETn = 1;

	//Test 2, check start sign
	@(negedge tb_HCLK);
	tb_test_num = tb_test_num + 1;
	tb_HADDR = 1000;
	tb_HRDATA = 1;
	@(negedge tb_HCLK);
	expect_start = 1;

	#1ns
	if ((expect_file_size == tb_file_size) && (expect_data_save == tb_data_save) && (expect_start == tb_start) 
		&& (expect_stop == tb_stop) && (expect_HREADY == tb_HREADY) && (expect_HRESP == tb_HRESP))
		$info("%s Case %0d:: PASSED", NAME, tb_test_num);
	else // Test case failed
		$error("%s Case %0d:: FAILED", NAME, tb_test_num);

	//Test 3: Check the file size
	@(negedge tb_HCLK);
	tb_test_num = tb_test_num + 1;
	tb_HADDR = 1001;
	tb_HRDATA = 25;
	expect_start = 0;
	@(negedge tb_HCLK);
	expect_file_size = 25;

	#1ns
	if ((expect_file_size == tb_file_size) && (expect_data_save == tb_data_save) && (expect_start == tb_start) 
		&& (expect_stop == tb_stop) && (expect_HREADY == tb_HREADY) && (expect_HRESP == tb_HRESP))
		$info("%s Case %0d:: PASSED", NAME, tb_test_num);
	else // Test case failed
		$error("%s Case %0d:: FAILED", NAME, tb_test_num);

	//Test 4: Check reading data
	@(negedge tb_HCLK);
	tb_test_num = tb_test_num + 1;
	tb_HADDR = 1002;
	tb_HRDATA[7:0] = 3;
	tb_HRDATA[15:8] = 0;
	tb_HRDATA[23:16] = 20;
	tb_HRDATA[31:24] = 12;
	@(negedge tb_HCLK);
	tb_HADDR = 1003;
	expect_HREADY = 0;
	@(negedge tb_HCLK);
	@(negedge tb_HCLK);
	@(negedge tb_HCLK);
	expect_data_save[7:0] = 3;
	expect_data_save[15:8] = 0;
	expect_data_save[23:16] = 20;
	expect_data_save[31:24] = 12;
	expect_HRESP = 1;

	#1ns
	if ((expect_file_size == tb_file_size) && (expect_data_save == tb_data_save) && (expect_start == tb_start) 
		&& (expect_stop == tb_stop) && (expect_HREADY == tb_HREADY) && (expect_HRESP == tb_HRESP))
		$info("%s Case %0d:: PASSED", NAME, tb_test_num);
	else // Test case failed
		$error("%s Case %0d:: FAILED", NAME, tb_test_num);
end
endmodule