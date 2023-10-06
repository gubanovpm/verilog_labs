module MEG_BL(input clk, output reg [7:0] Q,
							input st,
							input Inp,
							input REF,
							input rst);

	reg[1:0] prev = 2'b00;
	wire front = prev[0] & !prev[1];

	always @(posedge clk) begin
		prev[0] <= Inp ;
		prev[1] <= prev[0];
		Q <= st ? 0 : ( (REF & front) ? Q+1 : Q );
	end
endmodule
