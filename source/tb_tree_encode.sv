`timescale 1ns / 100ps

module tb_tree_encode();

   localparam CLK_TIME = 6;
   localparam DELAY    = 1;
   localparam RAM_DELAY = 5;
   localparam MEMORY_SIZE = 553;
   localparam MEMORY_MAX_BIT = MEMORY_SIZE - 1;

   reg       tb_clk;
   reg 	     tb_reset;
   reg 	     tb_CT_start;
   reg [7:0] tb_SN_data;
   reg [7:0] tb_RC_data;
   reg [9:0] tb_CT_addr;
   reg 	     tb_CT_R;
   reg 	     tb_CT_W;
   reg	     tb_CT_finish;
   reg [7:0] data[MEMORY_MAX_BIT:0];
   reg [9:0] count;
   reg [9:0] count_w;
   reg [9:0] node_cnt;

// DUT portmap
    tree_encode DUT (.clk(tb_clk), .reset(tb_reset), .const_tree_start(tb_CT_start), .search_node_data(tb_SN_data), .const_tree_addr(tb_CT_addr), .CT_R(tb_CT_R), .CT_W(tb_CT_W), .RC_data(tb_RC_data), .const_tree_finish(tb_CT_finish));

// Generate clock
   always
     begin
	tb_clk = 1'b0;
	#(CLK_TIME/2);
	tb_clk = 1'b1;
	#(CLK_TIME/2);
     end

// clear all blocks
   task clear;
	integer i;
   begin
	@(negedge tb_clk);
	for (i = 0; i < MEMORY_SIZE; i++)
	begin
		data[i] = 0;
	end
   end
   endtask

// setup number                 ///////////////////////////////////////  setup huffman tree
   task setup;
   begin
	data[257] = 2;
	data[258] = 1;

	data[260] = 4;
	data[261] = 128;

	data[263] = 3;
	data[264] = 0;

	data[266] = 129;
	data[267] = 5;

	data[268] = 23;
	data[269] = 130;
	data[270] = 131;

	data[271] = 'hFF;
   end
   endtask

// simulation of memory
   task memory;
   begin
	//@RAM_DELAY;
	if (1 == tb_CT_R)
	begin
		tb_SN_data = data[tb_CT_addr];
	end
	if (1 == tb_CT_W)
	begin
		data[tb_CT_addr] = tb_RC_data;
	end
   end
   endtask

// check find_end
   task check_read;
	input [9:0] count;
	integer i;


   begin
	for (i = 0; i < MEMORY_SIZE; i++)
	begin
		@(negedge tb_clk);  // find_end 
		memory;
		@(negedge tb_clk);  // wait
		memory;
		if (count <= 128)
		begin
			check_result(tb_CT_addr, tb_SN_data, count+128, data[count+128], count);  // check read
		end
		else
		begin
			check_result(tb_CT_addr, tb_SN_data, (256+(count-128)*3), data[(256+(count-128)*3)], count);  // check read
		end
		count++;
		@(negedge tb_clk);  // check_end
		memory;
		if ('hFF == tb_SN_data)
		begin
			i = 999;
		end
	end
   end
   endtask

// check write
   task check_write;
	input [7:0] result;
	input [7:0] digit;
	input [9:0] result_addr;
	input [9:0] digit_addr;
   begin
	@(negedge tb_clk);  // store_code
	memory;
	@(negedge tb_clk);  // swait
	memory;
	check_result(tb_CT_addr, tb_RC_data, result_addr, result, 100);  // check read
	@(negedge tb_clk);  // store_cnt
	memory;
	@(negedge tb_clk);  // cwait
	memory;
	check_result(tb_CT_addr, tb_RC_data, digit_addr, digit, 101);  // check read
   end
   endtask

// check result
   task check_result;
	input [9:0] check_addr;
	input [7:0] check_data;
	input [9:0] expected_addr;
	input [7:0] expected_data;
	input [9:0] cnt;

      begin
	#DELAY;
	if ((check_addr == expected_addr) && (check_data == expected_data)) begin
	   $info("case 1: build %d node correct!!\n", cnt);
		if ('hFF == check_data)
		begin
			$info("reach the end of memory\n");
		end
	end
	else begin
	   $error("case 1: build %d node failed!!! \ncheck:    %d, %d\nexpected: %d, %d\n", cnt, check_addr, check_data, expected_addr, expected_data);
	end
      end
   endtask

// check finish
   task check_finish;
   begin

	@(negedge tb_clk);  // finish
	if (1 == tb_CT_finish)
	begin
		print_all;
	end
	else
	begin
		$error("BT_finish != 1, BT_finish = %d\n", tb_CT_finish);
	end

   end
   endtask


// print all data in memory
   task print_all;
	integer i;
   begin
	$info("start to print all data in memory!\n");
	for (i = 0; i < MEMORY_SIZE; i++)
	begin
		$info("data[%d] = %d\n", i, data[i]);
	end
   end
   endtask

// start of tb
   initial
   begin
	//  case 1: FIRST NODE
	count = 128;
	count_w = 0;
	tb_reset = 0;
	tb_CT_start = 0;
	tb_SN_data = 0;
	@(negedge tb_clk);
	@(negedge tb_clk);
	tb_reset = 1;
	@(negedge tb_clk);
	clear;
	@(negedge tb_clk);
	setup;
	@(negedge tb_clk);  // idle
	tb_CT_start = 1;
	memory;

	check_read(count);

	tb_CT_start = 0;

	@(negedge tb_clk);  // zero_dig
	memory;
	@(negedge tb_clk);  // wait
	memory;
	node_cnt = 132;
	check_result(tb_CT_addr, tb_SN_data, (256+(node_cnt-128)*3)+2, data[(256+(node_cnt-128)*3)+2], 1);  // check read
	@(negedge tb_clk);  // check0
	memory;
	@(negedge tb_clk);  // fst_dig
	memory;
	@(negedge tb_clk);  // wait
	memory;
	node_cnt = 131;
	check_result(tb_CT_addr, tb_SN_data, (256+(node_cnt-128)*3)+2, data[(256+(node_cnt-128)*3)+2], 2);  // check read
	@(negedge tb_clk);  // check1
	memory;

	check_write(8'b11000000, 2, 5+128, 5); // F

	@(negedge tb_clk);  // fst_dig
	memory;
	@(negedge tb_clk);  // wait
	memory;
	node_cnt = 131;
	check_result(tb_CT_addr, tb_SN_data, (256+(node_cnt-128)*3)+1, data[(256+(node_cnt-128)*3)+1], 10);  // check read
	@(negedge tb_clk);  // check1
	memory;	
	@(negedge tb_clk);  // sec_dig
	memory;
	@(negedge tb_clk);  // wait
	memory;
	node_cnt = 129;
	check_result(tb_CT_addr, tb_SN_data, (256+(node_cnt-128)*3)+2, data[(256+(node_cnt-128)*3)+2], 11);  // check read
	@(negedge tb_clk);  // check2
	memory;	
	@(negedge tb_clk);  // trd_dig
	memory;
	@(negedge tb_clk);  // wait
	memory;
	node_cnt = 128;
	check_result(tb_CT_addr, tb_SN_data, (256+(node_cnt-128)*3)+2, data[(256+(node_cnt-128)*3)+2], 12);  // check read
	@(negedge tb_clk);  // check3
	memory;

	check_write(8'b10110000, 4, 1+128, 1); // B

	@(negedge tb_clk);  // trd_dig
	memory;
	@(negedge tb_clk);  // wait
	memory;
	node_cnt = 128;
	check_result(tb_CT_addr, tb_SN_data, (256+(node_cnt-128)*3)+1, data[(256+(node_cnt-128)*3)+1], 20);  // check read
	@(negedge tb_clk);  // check3
	memory;

	check_write(8'b10100000, 4, 2+128, 2); // C

	@(negedge tb_clk);  // trd_dig
	memory;
	@(negedge tb_clk);  // wait
	memory;
	node_cnt = 128;
	check_result(tb_CT_addr, tb_SN_data, (256+(node_cnt-128)*3), data[(256+(node_cnt-128)*3)], 30);  // check read    return to sec_dig
	@(negedge tb_clk);  // check3
	memory;
	@(negedge tb_clk);  // sec_dig
	memory;
	@(negedge tb_clk);  // wait
	memory;
	node_cnt = 129;
	check_result(tb_CT_addr, tb_SN_data, (256+(node_cnt-128)*3)+1, data[(256+(node_cnt-128)*3)+1], 31);  // check read
	@(negedge tb_clk);  // check2
	memory;	

	check_write(8'b10000000, 3, 4+128, 4); // E

	@(negedge tb_clk);  // sec_dig
	memory;
	@(negedge tb_clk);  // wait
	memory;
	node_cnt = 129;
	check_result(tb_CT_addr, tb_SN_data, (256+(node_cnt-128)*3), data[(256+(node_cnt-128)*3)], 40);  // check read  return to fst_dig
	@(negedge tb_clk);  // check2
	memory;	
	@(negedge tb_clk);  // fst_dig
	memory;
	@(negedge tb_clk);  // wait
	memory;
	node_cnt = 131;
	check_result(tb_CT_addr, tb_SN_data, (256+(node_cnt-128)*3), data[(256+(node_cnt-128)*3)], 10);  // check read  return to zero_dig
	@(negedge tb_clk);  // check1
	memory;	
	@(negedge tb_clk);  // zero_dig
	memory;
	@(negedge tb_clk);  // wait
	memory;
	node_cnt = 132;
	check_result(tb_CT_addr, tb_SN_data, (256+(node_cnt-128)*3)+1, data[(256+(node_cnt-128)*3)+1], 1);  // check read
	@(negedge tb_clk);  // check0
	memory;
	@(negedge tb_clk);  // fst_dig
	memory;
	@(negedge tb_clk);  // wait
	memory;
	node_cnt = 130;
	check_result(tb_CT_addr, tb_SN_data, (256+(node_cnt-128)*3)+2, data[(256+(node_cnt-128)*3)+2], 2);  // check read
	@(negedge tb_clk);  // check1
	memory;

	check_write(8'b01000000, 2, 0+128, 0); // A

	@(negedge tb_clk);  // fst_dig
	memory;
	@(negedge tb_clk);  // wait
	memory;
	node_cnt = 130;
	check_result(tb_CT_addr, tb_SN_data, (256+(node_cnt-128)*3)+1, data[(256+(node_cnt-128)*3)+1], 2);  // check read
	@(negedge tb_clk);  // check1
	memory;

	check_write(8'b00000000, 2, 3+128, 3); // D

	@(negedge tb_clk);  // fst_dig
	memory;
	@(negedge tb_clk);  // wait
	memory;
	node_cnt = 130;
	check_result(tb_CT_addr, tb_SN_data, (256+(node_cnt-128)*3), data[(256+(node_cnt-128)*3)], 2);  // check read  return to zero_dig
	@(negedge tb_clk);  // check1
	memory;
	@(negedge tb_clk);  // zero_dig
	memory;
	@(negedge tb_clk);  // wait
	memory;
	node_cnt = 132;
	check_result(tb_CT_addr, tb_SN_data, (256+(node_cnt-128)*3), data[(256+(node_cnt-128)*3)], 1);  // check read  go to finish state
	@(negedge tb_clk);  // check0
	memory;

	check_finish;





   end
endmodule

