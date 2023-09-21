module Gen1ms (input clk, output wire ce1ms);
	parameter Fclk  = 50000000; // 50 MHz
	//parameter Fclk  = 1000;
	parameter F1kHz = 1000;    //  1 kHz

	reg[15:0]cb_ms = 0;
	assign ce1ms = (cb_ms==1);

	always @(posedge clk) begin
		cb_ms <= ce1ms? ((Fclk/F1kHz)) : cb_ms-1;
	end
endmodule
