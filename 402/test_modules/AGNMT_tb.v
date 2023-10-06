`timescale 1ns/1ns

`include "../AGNMT.v"

module test_module;
	reg ce;
	reg clk;
	reg [10:0] N;
	reg [10:0] MT;

	wire [10:0] q;
	wire PW;
	wire start_PW;
	wire end_PW;

	AGNMT uut(.N(N),     .PW(PW),
				    .MT(MT),   .start_PW(start_PW),
						.ce(ce),   .end_PW(end_PW),
					  .clk(clk), .q(q));
	
	// sync signal generator
	parameter Tclk = 20; // period sync sig = 20 ns
	always begin
		clk = 0; #(Tclk/2);
		clk = 1; #(Tclk/2);
	end

	parameter Tce = 40;
	always begin
		ce = 0; #(Tce/2);
		ce = 1; #(Tce/2);
	end

	initial begin
		MT = 11'd20;
		N  = 11'd15;
		$dumpfile("AGNMT.vcd");
    $dumpvars(0, test_module);
		#10000;
		$finish();
	end

endmodule
