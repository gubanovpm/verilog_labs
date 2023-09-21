module VCB4RE (input ce,  output reg [3:0] Q,
               input clk, output wire TC,
               input clr, output wire CEO);
	assign TC  = (Q == 4'd15);
	assign CEO = TC & ce;
	always @(posedge clk) begin
		Q <= clr ? 0 : (ce ? Q+1 : Q);
	end
endmodule
