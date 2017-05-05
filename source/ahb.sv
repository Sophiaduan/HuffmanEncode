
/* Description:  The ahb module is used to read the data from data bus. 
Different address contains different data value. 
Also control the change of address by output HREADY
*/

module ahb
(
input wire HCLK,
input wire HRESETn,
input wire [31:0] HADDR,
input wire [31:0] HRDATA,
input wire [31:0] HWDATA,
input wire HWRITE,
input wire [2:0] HBURST,
input wire [2:0] HSIZE,
input wire finish_cnt,
input wire HRESP,
input wire done_four_bit,
output reg stop,
output reg start,
output reg [15:0] file_size,
output reg [31:0] data_save,
output reg HREADY
);

reg start_temp;
reg stop_temp;
reg [15:0] file_size_temp;
reg [15:0] file_size_pro;
reg [31:0] data_in;
reg HREADY_1;
reg HREADY_def;
typedef enum logic [1:0] {idle, delay}
state_type;
state_type state, nextstate;

always_ff @(posedge HCLK, negedge HRESETn) begin

if (HRESETn == 0) begin
	state <= idle;
end
else begin
	state <= nextstate;
end
end

//The state machine to push the HREADY low when read buffer is counting data
always_comb begin: statemachine
	nextstate = state;
	case(state)
	idle: begin
		if (HADDR == 1003)
			nextstate = delay;
	end
	
	delay: begin
		if (done_four_bit)
		nextstate = idle;
	end
endcase
end







always_comb begin
  start_temp = 0;
  stop_temp = 0;
  file_size_pro = '0;
  data_in = '0;

  //When address = 1000, start signal on the bus
  if (HADDR == 1001) 
	start_temp = 1;

  //When address = 1001, file_size signal on the bus
  else if (HADDR == 1002) 
	file_size_pro = HWDATA[15:0];

  //When address = 1002, file data on the bus
  else if ((HADDR == 1003) || ((HADDR == 1004) && !(HREADY_def && HREADY_1)))
	data_in = HWDATA;

  //When address = 1003, stop signal on the bus
  else if (HADDR == 1004 && (HREADY_def && HREADY_1))
	stop_temp = 1;
end

//The output logic combined with statemachine
//When it's at delay state, pull HREADY down so that address won't keep changing
always_comb begin
  HREADY_def = 1;
  HREADY_1 = 1;
  file_size_temp = file_size;
  if ((state == delay))
	HREADY_1 = 0;
  if (HADDR == 1002) begin
	file_size_temp = file_size_pro;
  end
  if ((!finish_cnt) && (HADDR != 1002)) begin
	file_size_temp = file_size;
  end
  HREADY = HREADY_def && HREADY_1;
end

//The register to save input 4 bytes data

always_ff @ (posedge HCLK, negedge HRESETn) begin
  if (HRESETn == 0) begin
	data_save <= 0;
	start <= 0;
	stop <= 0;
	file_size <= 0;
  end
  else begin
	data_save <= data_in; 
	start <= start_temp;
	stop <= stop_temp;
	file_size <= file_size_temp;
  end
end

endmodule
