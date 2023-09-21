module VCJ4RE0(input ce,  output reg[3:0] Q = 0,
               input clk, output wire TC,
						   input clr, output wire CEO);
	assign TC  = (Q == 15);
	assign CEO = ce & TC;
	always @(posedge clk) begin
		Q <= clr ? 0 : (ce ? Q << 1 | !Q[3]: Q);
	end
endmodule

module VCJ4RE2(input ce,  output reg[3:0] Q = 2,
               input clk, output wire TC,
						   input clr, output wire CEO);
	assign TC  = (Q == 15);
	assign CEO = ce & TC;
	always @(posedge clk) begin
		Q <= clr ? 2 : (ce ? Q << 1 | !Q[3]: Q);
	end
endmodule
