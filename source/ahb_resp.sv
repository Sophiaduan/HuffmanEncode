/* Description:  The ahb_resp module is used to recogize if there is an error
When hready is 0, HRESP is going to at ERROR state,
other wise it's okay.
*/

module ahb_resp
(
  input wire HCLK,
  input wire HRESETn,
  input wire HREADY,
  output reg HRESP
);

typedef enum logic [1:0] {OKAY, ERROR}
state_type;
state_type state, nextstate;


always_ff @(posedge HCLK, negedge HRESETn) begin

if (HRESETn == 0) begin
	state <= OKAY;
end
else begin
	state <= nextstate;
end
end

//The statemachine to go through between OKAY and ERROR state
always_comb begin: statemachine
  nextstate = state;
  case(state)
  OKAY: begin
	if (HREADY == 0)
		nextstate = ERROR;
  end

  ERROR: begin
	if (HREADY == 1)
		nextstate = OKAY;
  end

endcase
end

//The output collaborated with statemachine. If state is at OKAY, output Low HRESP, else output high HRESP
always_comb begin
HRESP = 0;
  if (state == OKAY) 
	HRESP = 0;
  if (state == ERROR)
	HRESP = 1;
end
endmodule