`ifndef m
	`define m 4
`endif
module VCBDmSE(input ce,  output reg [`m-1:0] Q = (1 << `m)-1,
               input clk, output wire TC,
               input s,   output wire CEO);
	assign TC  = (Q == 0);
	assign CEO = ce & TC;
	always @(posedge clk) begin
		Q <= s ? ((1<<`m)-1) : (ce ? Q-1 : Q) ;
	end
endmodule
