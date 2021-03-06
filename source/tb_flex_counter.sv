`timescale 1ns / 100ps

module tb_flex_counter ();
	
	localparam CLK_PERIOD = 2.5;
	localparam SIZE = 4, NAME = "DEFAULT";
	localparam MAX_SIZE = SIZE - 1;
	localparam DEFAULT_SIZE = 4;

	//tb_flex_counter_DUT #(.SIZE(8),		  .MSB(1), .NAME("config1")) stp_config1(.tb_clk);
	//tb_flex_counter_DUT #(.SIZE(4),		  .MSB(0), .NAME("config2")) stp_config2(.tb_clk);

	//Declare DUT signals
	integer tb_test_num;
	reg tb_clk;
	reg tb_n_rst;
	reg tb_clear;
	reg tb_count_enable;
	reg [MAX_SIZE:0] tb_rollover_val;
	wire [MAX_SIZE:0] tb_count_out;
	wire tb_rollover_flag;

	//Declare under DUT
	reg [MAX_SIZE:0] expect_output;
	reg [MAX_SIZE:0] tb_test_data;
	reg expect_flag;

	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end


	flex_counter DUT(.clk(tb_clk), .n_rst(tb_n_rst), .clear(tb_clear), .count_enable(tb_count_enable), .rollover_val(tb_rollover_val), .count_out(tb_count_out), .rollover_flag(tb_rollover_flag));

	initial
	begin
		//Initial all inputs
		tb_n_rst = 1'b1;
		tb_clear = 1'b0;
		tb_count_enable = 1'b1;
		tb_rollover_val = 0;
		tb_test_num = 0;
		tb_test_data = '0;
		expect_output = '0;
		expect_flag = 1'b0;

		tb_n_rst <= 0'b1;

		#(0.1);

		//Test 1 check for proper reset
		@(negedge tb_clk);
		tb_test_num = tb_test_num + 1;
		tb_clear = 1'b0;
		tb_count_enable = 1'b0;
		tb_rollover_val = 0;
		@(posedge tb_clk);
		tb_n_rst = 1'b0;
		tb_test_data = '1;
		expect_output = '0;
		expect_flag = 0; 
		//@(posedge tb_clk);
		#1ns

		if ((expect_output == tb_count_out) && (expect_flag == tb_rollover_flag))
			$info("%s Case %0d:: PASSED", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED", NAME, tb_test_num);
		// De-assert reset for a cycle
		tb_n_rst = 1'b1;


		//Test 2 check for proper reset
		@(negedge tb_clk);
		tb_test_num = tb_test_num + 1;
		tb_clear = 1'b0;
		tb_count_enable = 1'b1;
		tb_rollover_val = 2;
		@(posedge tb_clk);	
		tb_n_rst = 1'b0;	
		tb_test_data = '1;
		expect_output = '0;
		expect_flag = 0;
		#1ns

		if ((expect_output == tb_count_out) && (expect_flag == tb_rollover_flag))
			$info("%s Case %0d:: PASSED", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED", NAME, tb_test_num);
		// De-assert reset for a cycle
		tb_n_rst <= 1'b1;


		//Test 3 check count enable
		@(negedge tb_clk);
		tb_test_num = tb_test_num + 1;
		tb_clear = 1'b0;
		tb_count_enable = 1'b1;
		tb_rollover_val = 2;
		@(posedge tb_clk);	
		tb_test_data = '0;
		expect_output = '0 + 1;
		expect_flag = 0;
		//@(posedge tb_clk);
		#1ns
		if ((expect_output == tb_count_out) && (expect_flag == tb_rollover_flag))
			$info("%s Case %0d:: PASSED", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED", NAME, tb_test_num);
		// De-assert reset for a cycle


		//Test 4 check count enable
		@(negedge tb_clk);
		tb_test_num = tb_test_num + 1;
		tb_clear = 1'b0;
		tb_count_enable = 1'b1;
		tb_rollover_val = 2;
		@(posedge tb_clk);	
		expect_output = 2;
		expect_flag = 1;
		//@(posedge tb_clk);
		#(1ns)
		
		if ((expect_output == tb_count_out) && (expect_flag == tb_rollover_flag))
			$info("%s Case %0d:: PASSED", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED", NAME, tb_test_num);
		// De-assert reset for a cycle

		//Test 5 check count enable
		@(negedge tb_clk);
		tb_test_num = tb_test_num + 1;
		tb_clear = 1'b1;
		tb_count_enable = 1'b1;
		tb_rollover_val = 2;
		@(posedge tb_clk);	
		expect_output = 0;
		expect_flag = 0;
		//@(posedge tb_clk);
		#(1ns)
		
		if ((expect_output == tb_count_out) && (expect_flag == tb_rollover_flag))
			$info("%s Case %0d:: PASSED", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED", NAME, tb_test_num);
		// De-assert reset for a cycle

		//Test 6 check count enable
		@(negedge tb_clk);
		tb_test_num = tb_test_num + 1;
		tb_clear = 1'b0;
		tb_count_enable = 1'b1;
		tb_rollover_val = 2;
		@(posedge tb_clk);	
		expect_output = 1;
		expect_flag = 0;
		//@(posedge tb_clk);
		#(1ns)
		
		if ((expect_output == tb_count_out) && (expect_flag == tb_rollover_flag))
			$info("%s Case %0d:: PASSED", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED", NAME, tb_test_num);
		// De-assert reset for a cycle

		//Test 7 check count enable
		@(negedge tb_clk);
		tb_test_num = tb_test_num + 1;
		tb_clear = 1'b0;
		tb_count_enable = 1'b1;
		tb_rollover_val = 2;
		@(posedge tb_clk);	
		expect_output = 2;
		expect_flag = 1;
		//@(posedge tb_clk);
		#(1ns)
		
		if ((expect_output == tb_count_out) && (expect_flag == tb_rollover_flag))
			$info("%s Case %0d:: PASSED", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED", NAME, tb_test_num);
		// De-assert reset for a cycle

		//Test 8 check count enable
		@(negedge tb_clk);
		tb_test_num = tb_test_num + 1;
		tb_clear = 1'b0;
		tb_count_enable = 1'b1;
		tb_rollover_val = 2;
		@(posedge tb_clk);	
		expect_output = 1;
		expect_flag = 0;
		//@(posedge tb_clk);
		#(1ns)
		
		if ((expect_output == tb_count_out) && (expect_flag == tb_rollover_flag))
			$info("%s Case %0d:: PASSED", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED", NAME, tb_test_num);
		// De-assert reset for a cycle

		//Test 9 check count enable
		@(negedge tb_clk);
		tb_test_num = tb_test_num + 1;
		tb_clear = 1'b0;
		tb_count_enable = 1'b1;
		tb_rollover_val = 2;
		@(posedge tb_clk);	
		expect_output = 2;
		expect_flag = 1;
		//@(posedge tb_clk);
		#(1ns)
		
		if ((expect_output == tb_count_out) && (expect_flag == tb_rollover_flag))
			$info("%s Case %0d:: PASSED", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED", NAME, tb_test_num);
		// De-assert reset for a cycle

		//Test 10 check count enable
		@(negedge tb_clk);
		tb_test_num = tb_test_num + 1;
		tb_clear = 1'b0;
		tb_count_enable = 1'b0;
		tb_rollover_val = 2;
		@(posedge tb_clk);	
		expect_output = 2;
		expect_flag = 1;
		//@(posedge tb_clk);
		#(1ns)
		
		if ((expect_output == tb_count_out) && (expect_flag == tb_rollover_flag))
			$info("%s Case %0d:: PASSED", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED", NAME, tb_test_num);
		// De-assert reset for a cycle

		//Test 11 reset
		@(negedge tb_clk);
		tb_test_num = tb_test_num + 1;
		tb_clear = 1'b1;
		tb_count_enable = 1'b0;
		tb_rollover_val = 2;
		@(posedge tb_clk);	
		tb_n_rst = 1'b1;	
		expect_output = '0;
		expect_flag = 0;
		//@(posedge tb_clk);
		#1ns
		if ((expect_output == tb_count_out) && (expect_flag == tb_rollover_flag))
			$info("%s Case %0d:: PASSED", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED", NAME, tb_test_num);
		// De-assert reset for a cycle
		//tb_n_rst <= 1'b1;

		//Test 12 big value rollover
		@(negedge tb_clk);
		tb_test_num = tb_test_num + 1;
		tb_clear = 1'b0;
		tb_count_enable = 1'b1;
		tb_rollover_val = 8;
		@(posedge tb_clk);	
		tb_n_rst = 1'b1;	
		expect_output = 1;
		expect_flag = 0;
		//@(posedge tb_clk);
		#1ns
		if ((expect_output == tb_count_out) && (expect_flag == tb_rollover_flag))
			$info("%s Case %0d:: PASSED", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED", NAME, tb_test_num);
		// De-assert reset for a cycle

		//Test 13 big value rollover
		@(negedge tb_clk);
		tb_test_num = tb_test_num + 1;
		tb_clear = 1'b0;
		tb_count_enable = 1'b1;
		tb_rollover_val = 8;
		@(posedge tb_clk);	
		tb_n_rst = 1'b1;	
		expect_output = 2;
		expect_flag = 0;
		//@(posedge tb_clk);
		#1ns
		if ((expect_output == tb_count_out) && (expect_flag == tb_rollover_flag))
			$info("%s Case %0d:: PASSED", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED", NAME, tb_test_num);
		// De-assert reset for a cycle
		
		//Test 14 big value rollover
		@(negedge tb_clk);
		tb_test_num = tb_test_num + 1;
		tb_clear = 1'b0;
		tb_count_enable = 1'b1;
		tb_rollover_val = 8;
		@(posedge tb_clk);
		@(posedge tb_clk);	
		@(posedge tb_clk);	
		@(posedge tb_clk);
		@(posedge tb_clk);			
		tb_n_rst = 1'b1;	
		expect_output = 7;
		expect_flag = 0;
		//@(posedge tb_clk);
		#1ns
		if ((expect_output == tb_count_out) && (expect_flag == tb_rollover_flag))
			$info("%s Case %0d:: PASSED", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED", NAME, tb_test_num);
		// De-assert reset for a cycle
		
		//Test 15 big value rollover
		@(negedge tb_clk);
		tb_test_num = tb_test_num + 1;
		tb_clear = 1'b0;
		tb_count_enable = 1'b1;
		tb_rollover_val = 8;
		@(posedge tb_clk);		
		tb_n_rst = 1'b1;	
		expect_output = 8;
		expect_flag = 1;
		//@(posedge tb_clk);
		#1ns
		if ((expect_output == tb_count_out) && (expect_flag == tb_rollover_flag))
			$info("%s Case %0d:: PASSED", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED", NAME, tb_test_num);
		// De-assert reset for a cycle

		//Test 16 check if it comes back to one when meet the max
		@(negedge tb_clk);
		tb_test_num = tb_test_num + 1;
		tb_clear = 1'b0;
		tb_count_enable = 1'b1;
		tb_rollover_val = 8;
		@(posedge tb_clk);	
		@(posedge tb_clk);	
		@(posedge tb_clk);		
		tb_n_rst = 1'b1;	
		expect_output = 3;
		expect_flag = 0;
		//@(posedge tb_clk);
		#1ns
		if ((expect_output == tb_count_out) && (expect_flag == tb_rollover_flag))
			$info("%s Case %0d:: PASSED", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED", NAME, tb_test_num);
		// De-assert reset for a cycle

		//Test 17 check if it comes back to one when meet the max
		@(negedge tb_clk);
		tb_test_num = tb_test_num + 1;
		tb_clear = 1'b0;
		tb_count_enable = 1'b1;
		tb_rollover_val = 8;
		@(posedge tb_clk);	
		@(posedge tb_clk);	
		@(posedge tb_clk);	
		@(posedge tb_clk);
		@(posedge tb_clk);	
		tb_n_rst = 1'b1;	
		expect_output = 8;
		expect_flag = 1;
		//@(posedge tb_clk);
		#1ns
		if ((expect_output == tb_count_out) && (expect_flag == tb_rollover_flag))
			$info("%s Case %0d:: PASSED", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED", NAME, tb_test_num);
		// De-assert reset for a cycle

		//Test 18 check if it comes back to one when meet the max
		@(negedge tb_clk);
		tb_test_num = tb_test_num + 1;
		tb_clear = 1'b0;
		tb_count_enable = 1'b0;
		tb_rollover_val = 8;
		@(posedge tb_clk);	
		tb_n_rst = 1'b1;	
		expect_output = 8;
		expect_flag = 1;
		//@(posedge tb_clk);
		#1ns
		if ((expect_output == tb_count_out) && (expect_flag == tb_rollover_flag))
			$info("%s Case %0d:: PASSED", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED", NAME, tb_test_num);
		// De-assert reset for a cycle

		//Test 19 check if it comes back to one when meet the max
		@(negedge tb_clk);
		tb_test_num = tb_test_num + 1;
		tb_clear = 1'b1;
		tb_count_enable = 1'b1;
		tb_rollover_val = 1;
		@(posedge tb_clk);			
		tb_n_rst = 1'b1;	
		expect_output = 0;
		expect_flag = 0;
		//@(posedge tb_clk);
		#1ns
		if ((expect_output == tb_count_out) && (expect_flag == tb_rollover_flag))
			$info("%s Case %0d:: PASSED", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED", NAME, tb_test_num);
		// De-assert reset for a cycle

		//Test 20 reset again
		@(negedge tb_clk);
		tb_test_num = tb_test_num + 1;
		tb_clear = 1'b0;
		tb_count_enable = 1'b1;
		tb_rollover_val = 1;
		@(posedge tb_clk);			
		tb_n_rst = 1'b0;	
		expect_output = 0;
		expect_flag = 0;
		//@(posedge tb_clk);
		#1ns
		if ((expect_output == tb_count_out) && (expect_flag == tb_rollover_flag))
			$info("%s Case %0d:: PASSED", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED", NAME, tb_test_num);
		// De-assert reset for a cycle
		tb_n_rst = 1'b1;	

		//Test 21 check rollover = 1
		@(negedge tb_clk);
		tb_test_num = tb_test_num + 1;
		tb_clear = 1'b0;
		tb_count_enable = 1'b1;
		tb_rollover_val = 1;
		@(posedge tb_clk);			
		tb_n_rst = 1'b1;	
		expect_output = 1;
		expect_flag = 1;
		//@(posedge tb_clk);
		#1ns
		if ((expect_output == tb_count_out) && (expect_flag == tb_rollover_flag))
			$info("%s Case %0d:: PASSED", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED", NAME, tb_test_num);
		// De-assert reset for a cycle

		//Test 22 check rollover = 1
		@(negedge tb_clk);
		tb_test_num = tb_test_num + 1;
		tb_clear = 1'b0;
		tb_count_enable = 1'b1;
		tb_rollover_val = 1;
		@(posedge tb_clk);			
		tb_n_rst = 1'b1;	
		expect_output = 1;
		expect_flag = 1;
		//@(posedge tb_clk);
		#1ns
		if ((expect_output == tb_count_out) && (expect_flag == tb_rollover_flag))
			$info("%s Case %0d:: PASSED", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED", NAME, tb_test_num);
		// De-assert reset for a cycle

		//Test 22 check rollover = 1
		@(negedge tb_clk);
		tb_test_num = tb_test_num + 1;
		tb_clear = 1'b1;
		tb_count_enable = 1'b1;
		tb_rollover_val = 1;
		@(posedge tb_clk);			
		tb_n_rst = 1'b1;	
		expect_output = 0;
		expect_flag = 0;
		//@(posedge tb_clk);
		#1ns
		if ((expect_output == tb_count_out) && (expect_flag == tb_rollover_flag))
			$info("%s Case %0d:: PASSED", NAME, tb_test_num);
		else // Test case failed
			$error("%s Case %0d:: FAILED", NAME, tb_test_num);
		// De-assert reset for a cycle
	end









endmodule