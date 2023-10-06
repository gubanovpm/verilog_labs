`ifndef m
	`define m 4
`endif

module AGSAW_YX(input ce,
								input [`m-1:0] Y, output wire tc_Y,
								input [`m-1:0] X, output wire tc_X,
								input clk,				output reg [`m-1:0] q=0);

	assign tc_X = (q==X) ;
	assign tc_Y = (q==Y) ;
	reg UP = 1;
	always @ (posedge clk) if (ce) begin
		q <= UP? q+1 : q-1 ;
		UP <= (q==Y+1)? 1 : (q==X-1)? 0 : UP ;
	end

endmodule
