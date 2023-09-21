module BTN_WRP(input BTN_IN, output wire BTN_OUT,
               input ce);

	reg [1:0] Q;
	assign BTN_OUT = Q[0] & (~Q[1]);
	
	always @(posedge ce) begin
		Q[0] <= BTN_IN;
		Q[1] <= Q[0];
	end

endmodule
