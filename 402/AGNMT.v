`ifndef s
	`define s 11
`endif
module AGNMT (input [`s-1:0] N,  output reg PW = 0,
							input [`s-1:0] MT, output wire start_PW,
							input ce,          output wire end_PW,
							input clk,         output reg [`s-1:0] q=0);

	assign start_PW = (q==N);
	assign end_PW = (q==MT);
	always @ (posedge clk) if (ce) begin
		PW <= end_PW? 0: start_PW? 1 : PW ;
		q <= start_PW? 1 : q+1 ;
	end

endmodule
