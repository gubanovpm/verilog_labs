module COUNT_GEN_NMS (input ceo, output wire [9:0] bf_cb10R1,
                      input clk);
	
	reg [9:0] cb10R1 = 10'd0;
	reg [9:0] temp   = 10'd0;

	assign bf_cb10R1 = temp;

	always @(posedge clk) begin
		temp   <= ceo ? cb10R1 : temp;
		cb10R1 <= ceo ? 1 : cb10R1+1;
	end
endmodule
