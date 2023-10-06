`ifndef k
	`define k 11
`endif

module AGNTD( input [`k-1:0] N, output wire TC,
							input ce,					output reg [`k-1:0] q=1,
							input clk);
	
	assign TC = (q==1) ;
	always @ (posedge clk) if (ce) begin
		q <= TC? N : q-1 ;
	end
endmodule
