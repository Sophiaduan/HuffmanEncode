module control_read
(
  input wire clk,
  input wire reset,
  input wire finish_cnt,
  input wire HREADY,
  output reg enable,
  output reg clear,
  output reg read_enable
);

reg enable_temp;
reg clear_temp;;
reg read_enable_temp;

typedef enum logic [1:0] {idle, counter, read, clean}
state_type;
state_type state, nextstate;

always_ff @(posedge clk, negedge reset) begin
  if(reset == 0) begin
	state <= idle;
  end
  else
	state <= nextstate;
end

always_comb begin: statemachine
  nextstate = state;
  case(state)
  idle: begin 
	if (!HREADY) 
		nextstate = counter;
  end

  counter: begin
		nextstate = read;
  end

  read: begin
	if (finish_cnt)
		nextstate = clean;
	else
		nextstate = counter;
  end

  clean: begin
	nextstate = idle;
  end
endcase
end

always_comb begin
enable_temp = 0;
clear_temp = 0;
read_enable_temp = 0;
if (state == counter) 
	enable_temp = 1;
if ((state == read) && !finish_cnt)
	read_enable_temp = 1;
if (state == clean)
	clear_temp = 1;
end
 
always_ff @(posedge clk, negedge reset) begin
if (reset == 0) begin
	enable <= 0;
	read_enable <= 0;
	clear <= 0;
end
else begin
	enable <= enable_temp;
	read_enable <= read_enable_temp;
	clear <= clear_temp;
end
end

endmodule
	