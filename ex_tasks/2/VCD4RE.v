module VCD4RE(input ce,  output reg [3:0] Q = 0,
              input clk, output wire TC, 
						  input clr, output wire CEO);
	assign TC  = (Q == 9);
	assign CEO = ce & TC;
	always @(posedge clk) begin
		Q <= (clr | CEO) ? 0 : (ce ? Q+1 : Q);
	end
endmodule
