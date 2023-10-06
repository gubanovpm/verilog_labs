module DAT_BL(output wire [15:0]NTclk,
							output wire [10:0]N,
							output wire [10:0]MT);

	assign NTclk = 16'd5000;
	assign N     = 11'd60;
	assign MT    = 11'd15;

endmodule
