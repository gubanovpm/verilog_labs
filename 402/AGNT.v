`ifndef k
	`define k 11
`endif
module AGNT ( input [`k-1:0] N, output reg [`k-1:0] q=0,
							input ce,         output wire TC,
							input clk,				output wire ceo);
	assign TC = (q==N) ;
	assign ceo = ce & TC ;
	always @ (posedge clk) if (ce) begin
		q <= TC? 1 : q+1;
	end
endmodule
