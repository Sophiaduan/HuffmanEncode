module tree_encode
(
	input clk,
	input reset,
	input const_tree_start,
	input [7:0] search_node_data,
	output reg const_tree_finish,
	output reg [9:0] const_tree_addr,
	output reg CT_R,
	output reg CT_W,
	output reg [7:0] RC_data
);

	reg [7:0] num0;
	reg [7:0] num1;
	reg [7:0] num2;
	reg [7:0] num3;
	reg [7:0] num4;
	reg [7:0] num5;
	reg [7:0] num6;
	reg [7:0] num7;

	reg [1:0] cnt0;
	reg [1:0] cnt1;
	reg [1:0] cnt2;
	reg [1:0] cnt3;
	reg [1:0] cnt4;
	reg [1:0] cnt5;
	reg [1:0] cnt6;
	reg [1:0] cnt7;
	reg [1:0] next_cnt0;
	reg [1:0] next_cnt1;
	reg [1:0] next_cnt2;
	reg [1:0] next_cnt3;
	reg [1:0] next_cnt4;
	reg [1:0] next_cnt5;
	reg [1:0] next_cnt6;
	reg [1:0] next_cnt7;

	reg [7:0] addrend;
	reg [7:0] search_node_addr;
	reg [7:0] next_search_node_addr;
	reg [9:0] next_const_tree_addr;
	reg [7:0] next_RC_data;
	reg [3:0] digit_num;
	reg [3:0] next_digit_num;
	reg next_CT_W;
	reg next_CT_R;

   	typedef enum bit [5:0] {idle, find_end, waitend, check_end, zero_dig, wait0, check0, fst_dig, wait1, check1, sec_dig, wait2, check2, thi_dig, wait3, check3, for_dig, wait4, check4, fif_dig, wait5, check5, six_dig, wait6, check6, sev_dig, wait7, check7, store_code, swait, store_cnt, cwait, finish} stateType;
   	stateType state;
  	stateType next_state;

 	always_ff @(posedge clk, negedge reset)
     	begin
		if (reset == 0)
	  	begin
	     		state <= idle;
			const_tree_addr <= 0;
			RC_data <= 0;
			search_node_addr <= 128;
			cnt0 <= 2'b10;
			cnt1 <= 2'b10;
			cnt2 <= 2'b10;
			cnt3 <= 2'b10;
			cnt4 <= 2'b10;
			cnt5 <= 2'b10;
			cnt6 <= 2'b10;
			cnt7 <= 2'b10;
			digit_num <= 0;
			CT_W <= 0;
			CT_R <= 0;
	  	end
		else
	  	begin
	     		state <= next_state;
			const_tree_addr <= next_const_tree_addr;
			RC_data <= next_RC_data;
			search_node_addr <= next_search_node_addr;
			cnt0 <= next_cnt0;
			cnt1 <= next_cnt1;
			cnt2 <= next_cnt2;
			cnt3 <= next_cnt3;
			cnt4 <= next_cnt4;
			cnt5 <= next_cnt5;
			cnt6 <= next_cnt6;
			cnt7 <= next_cnt7;
			digit_num <= next_digit_num;
			CT_W <= next_CT_W;
			CT_R <= next_CT_R;
	  	end // else: !if(reset == 0)
     	end // always_ff @

   	always_comb
     	begin
		next_state = state;
		next_const_tree_addr = const_tree_addr;
		next_RC_data = RC_data;
		next_search_node_addr = search_node_addr;
		const_tree_finish = 0;
		next_CT_R = 0;
		next_CT_W = 0;
		next_cnt0 = cnt0;
		next_cnt1 = cnt1;
		next_cnt2 = cnt2;
		next_cnt3 = cnt3;
		next_cnt4 = cnt4;
		next_cnt5 = cnt5;
		next_cnt6 = cnt6;
		next_cnt7 = cnt7;
		next_digit_num = digit_num;

		case(state)
	  	idle:
	    	begin
			next_CT_R = 0;
			next_CT_W = 0;
			if (1 == const_tree_start) 
			begin
				next_state = find_end;
			end
			else 
			begin
				next_state = idle;
			end
		end
		find_end:
		begin
			next_CT_R = 1;
			next_CT_W = 0;
			if (128 >= search_node_addr) 
			begin
				next_const_tree_addr = search_node_addr + 128;
			end
			else
			begin
				next_const_tree_addr = 256 + (search_node_addr - 128) * 3;
			end
			next_state = waitend;
		end
		waitend:
		begin
			next_CT_R = 1;
			next_CT_W = 0;
			next_state = check_end;
		end
		check_end:
		begin
			next_CT_R = 0;
			next_CT_W = 0;
			if (8'hFF == search_node_data)
			begin
				addrend = search_node_addr - 1;
				next_state = zero_dig;
			end
			else
			begin
				next_search_node_addr = search_node_addr + 1;
				next_state = find_end;
			end
		end
		zero_dig:
		begin
			next_CT_R = 1;
			next_CT_W = 0;
			if (128 == addrend) 
			begin
				next_state = finish;
			end
			else
			begin
				next_const_tree_addr = 256 + (addrend - 128) * 3 + cnt0;
			end
			next_state = wait0;
		end
		wait0:
		begin
			next_CT_R = 1;
			next_CT_W = 0;
			next_state = check0;
		end
		check0:
		begin
			next_CT_R = 0;
			next_CT_W = 0;
			num0 = search_node_data;
			if (0 == cnt0)
			begin
				next_cnt0 = 2'b10;
			end
			else
			begin
				next_cnt0 = cnt0 - 1;
			end

			if (2'b00 == cnt0)
			begin
				next_state = finish;
			end
			else if (128 > search_node_data)	
			begin
				next_digit_num = 1;
				next_state = store_code;
			end
			else
			begin
				next_state = fst_dig;
			end
		end
		fst_dig:
		begin
			next_CT_R = 1;
			next_CT_W = 0;
			next_const_tree_addr = 256 + (num0 - 128) * 3 + cnt1;
			next_state = wait1;
		end
		wait1:
		begin
			next_CT_R = 1;
			next_CT_W = 0;
			next_state = check1;
		end
		check1:
		begin
			next_CT_R = 0;
			next_CT_W = 0;
			num1 = search_node_data;
			if (0 == cnt1)
			begin
				next_cnt1 = 2'b10;
			end
			else
			begin
				next_cnt1 = cnt1 - 1;	
			end

			if (2'b00 == cnt1)
			begin
				next_state = zero_dig;
			end
			else if (128 > search_node_data)
			begin
				next_digit_num = 2;
				next_state = store_code;
			end
			else
			begin
				next_state = sec_dig;
			end
		end
		sec_dig:
		begin
			next_CT_R = 1;
			next_CT_W = 0;
			next_const_tree_addr = 256 + (num1 - 128) * 3 + cnt2;
			next_state = wait2;
		end
		wait2:
		begin
			next_CT_R = 1;
			next_CT_W = 0;
			next_state = check2;
		end
		check2:
		begin
			next_CT_R = 0;
			next_CT_W = 0;
			num2= search_node_data;
			if (0 == cnt2)
			begin
				next_cnt2 = 2'b10;
			end
			else
			begin
				next_cnt2 = cnt2 - 1;	
			end

			if (2'b00 == cnt2)
			begin
				next_state = fst_dig;
			end
			else if (128 > search_node_data)
			begin
				next_digit_num = 3;
				next_state = store_code;
			end
			else
			begin
				next_state = thi_dig;
			end
		end
		thi_dig:
		begin
			next_CT_R = 1;
			next_CT_W = 0;
			next_const_tree_addr = 256 + (num2 - 128) * 3 + cnt3;
			next_state = wait3;
		end
		wait3:
		begin
			next_CT_R = 1;
			next_CT_W = 0;
			next_state = check3;
		end
		check3:
		begin
			next_CT_R = 0;
			next_CT_W = 0;
			num3 = search_node_data;
			if (0 == cnt3)
			begin
				next_cnt3 = 2'b10;
			end
			else
			begin
				next_cnt3 = cnt3 - 1;	
			end

			if (2'b00 == cnt3)
			begin
				next_state = sec_dig;
			end
			else if (128 > search_node_data)
			begin
				next_digit_num = 4;
				next_state = store_code;
			end
			else
			begin
				next_state = for_dig;
			end
		end
		for_dig:
		begin
			next_CT_R = 1;
			next_CT_W = 0;
			next_const_tree_addr = 256 + (num3 - 128) * 3 + cnt4;
			next_state = wait4;
		end
		wait4:
		begin
			next_CT_R = 1;
			next_CT_W = 0;
			next_state = check4;
		end
		check4:
		begin
			next_CT_R = 0;
			next_CT_W = 0;
			num4 = search_node_data;
			if (0 == cnt4)
			begin
				next_cnt4 = 2'b10;
			end
			else
			begin
				next_cnt4 = cnt4 - 1;
			end

			if (2'b00 == cnt4)
			begin
				next_state = thi_dig;
			end
			else if (128 > search_node_data)
			begin
				next_digit_num = 5;
				next_state = store_code;
			end
			else
			begin
				next_state = fif_dig;
			end
		end
		fif_dig:
		begin
			next_CT_R = 1;
			next_CT_W = 0;
			next_const_tree_addr = 256 + (num4 - 128) * 3 + cnt5;
			next_state = wait5;
		end
		wait5:
		begin
			next_CT_R = 1;
			next_CT_W = 0;
			next_state = check5;
		end
		check5:
		begin
			next_CT_R = 0;
			next_CT_W = 0;
			num5 = search_node_data;
			if (0 == cnt5)
			begin
				next_cnt5 = 2'b10;
			end
			else
			begin
				next_cnt5 = cnt5 - 1;	
			end

			if (2'b00 == cnt5)
			begin
				next_state = for_dig;
			end
			else if (128 > search_node_data)
			begin
				next_digit_num = 6;
				next_state = store_code;
			end
			else
			begin
				next_state = six_dig;
			end
		end
		six_dig:
		begin
			next_CT_R = 1;
			next_CT_W = 0;
			next_const_tree_addr = 256 + (num5 - 128) * 3 + cnt6;
			next_state = wait6;
		end
		wait6:
		begin
			next_CT_R = 1;
			next_CT_W = 0;
			next_state = check6;
		end
		check6:
		begin
			next_CT_R = 0;
			next_CT_W = 0;
			num6 = search_node_data;
			if (0 == cnt6)
			begin
				next_cnt6 = 2'b10;
			end
			else
			begin
				next_cnt6 = cnt6 - 1;
			end

			if (2'b00 == cnt6)
			begin
				next_state = fif_dig;
			end
			else if (128 > search_node_data)
			begin
				next_digit_num = 7;
				next_state = store_code;
			end
			else
			begin
				next_state = sev_dig;
			end
		end
		sev_dig:
		begin
			next_CT_R = 1;
			next_CT_W = 0;
			next_const_tree_addr = 256 + (num6 - 128) * 3 + cnt7;
			next_state = wait7;
		end
		wait7:
		begin
			next_CT_R = 1;
			next_CT_W = 0;
			next_state = check7;
		end
		check7:
		begin
			next_CT_R = 0;
			next_CT_W = 0;
			num7 = search_node_data;
			if (0 == cnt7)
			begin
				next_cnt7 = 2'b10;
			end
			else
			begin
				next_cnt7 = cnt7 - 1;
			end

			if (2'b00 == cnt7)
			begin
				next_state = six_dig;
			end
			else if (128 <= search_node_data)
			begin
				$error("error: code more than 8 digits");
			end
			else
			begin
				next_digit_num = 8;
				next_state = store_code;
			end
		end

		store_code:
		begin
			if (1 == digit_num)
			begin
				next_const_tree_addr = 128 + num0;
				next_RC_data[7:0] = {cnt0[0],1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
			end
			else if (2 == digit_num)
			begin
				next_const_tree_addr = 128 + num1;
				next_RC_data[7:0] = {cnt0[0], cnt1[0],1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
			end
			else if (3 == digit_num)
			begin
				next_const_tree_addr = 128 + num2;
				next_RC_data[7:0] = {cnt0[0], cnt1[0],cnt2[0],1'b0,1'b0,1'b0,1'b0,1'b0};
			end
			else if (4 == digit_num)
			begin
				next_const_tree_addr = 128 + num3;
				next_RC_data[7:0] = {cnt0[0], cnt1[0], cnt2[0], cnt3[0], 1'b0, 1'b0, 1'b0, 1'b0};
			end
			else if (5 == digit_num)
			begin
				next_const_tree_addr = 128 + num4;
				next_RC_data[7:0] = {cnt0[0], cnt1[0], cnt2[0], cnt3[0], cnt4[0],1'b0,1'b0,1'b0};
			end
			else if (6 == digit_num)
			begin
				next_const_tree_addr = 128 + num5;
				next_RC_data[7:0] = {cnt0[0], cnt1[0], cnt2[0], cnt3[0], cnt4[0], cnt5[0],1'b0,1'b0};
			end
			else if (7 == digit_num)
			begin
				next_const_tree_addr = 128 + num6;
				next_RC_data[7:0] = {cnt0[0], cnt1[0], cnt2[0], cnt3[0], cnt4[0], cnt5[0], cnt6[0],1'b0};
			end
			else if (8 == digit_num)
			begin
				next_const_tree_addr = 128 + num7;
				next_RC_data[7:0] = {cnt0[0], cnt1[0], cnt2[0], cnt3[0], cnt4[0], cnt5[0], cnt6[0], cnt7[0]};
			end
			else
			begin
				next_const_tree_addr = '1;
				next_RC_data = '1;
			end
			next_CT_R = 0;
			next_CT_W = 1;
			next_state = swait;
		end
		swait:
		begin
			next_CT_R = 0;
			next_CT_W = 1;
			next_state = store_cnt;
		end
		store_cnt:
		begin
			if (1 == digit_num)
			begin
				next_const_tree_addr = num0;
				next_RC_data = digit_num;
			end
			else if (2 == digit_num)
			begin
				next_const_tree_addr = num1;
				next_RC_data = digit_num;
			end
			else if (3 == digit_num)
			begin
				next_const_tree_addr = num2;
				next_RC_data = digit_num;
			end
			else if (4 == digit_num)
			begin
				next_const_tree_addr = num3;
				next_RC_data = digit_num;
			end
			else if (5 == digit_num)
			begin
				next_const_tree_addr = num4;
				next_RC_data = digit_num;
			end
			else if (6 == digit_num)
			begin
				next_const_tree_addr = num5;
				next_RC_data = digit_num;
			end
			else if (7 == digit_num)
			begin
				next_const_tree_addr = num6;
				next_RC_data = digit_num;
			end
			else if (8 == digit_num)
			begin
				next_const_tree_addr = num7;
				next_RC_data = digit_num;
			end
			next_CT_R = 0;
			next_CT_W = 1;
			next_state = cwait;
		end
		cwait:
		begin
			next_CT_R = 0;
			next_CT_W = 1;
			if (1 == digit_num)
			begin
				next_state = zero_dig;
			end
			else if (2 == digit_num)
			begin
				next_state = fst_dig;
			end
			else if (3 == digit_num)
			begin
				next_state = sec_dig;
			end
			else if (4 == digit_num)
			begin
				next_state = thi_dig;
			end
			else if (5 == digit_num)
			begin
				next_state = for_dig;
			end
			else if (6 == digit_num)
			begin
				next_state = fif_dig;
			end
			else if (7 == digit_num)
			begin
				next_state = six_dig;
			end
			else if (8 == digit_num)
			begin
				next_state = sev_dig;
			end
			else
			begin
				next_state = finish;
				$error("more than 8 digits in cwait");
			end
		end
		finish:
		begin
			next_CT_R = 0;
			next_CT_W = 0;
			const_tree_finish = 1;
	     		next_state = idle;
			next_const_tree_addr = 0;
			next_RC_data = 0;
			next_search_node_addr = 128;
			next_cnt0 = 2'b10;
			next_cnt1 = 2'b10;
			next_cnt2 = 2'b10;
			next_cnt3 = 2'b10;
			next_cnt4 = 2'b10;
			next_cnt5 = 2'b10;
			next_cnt6 = 2'b10;
			next_cnt7 = 2'b10;
		end
		endcase
	end
endmodule