`timescale 1ns/1ns

`include "../AGNTD.v"

module test_module;
	reg ce;
	reg clk;
	reg [10:0] N;

	wire [10:0] q;
	wire TC;

	AGNTD uut(.N(N),     .q(q),
				   .clk(clk), .TC(TC),
				   .ce(ce));
	
	// sync signal generator
	parameter Tclk = 20; // period sync sig = 20 ns
	always begin
		clk = 0; #(Tclk/2);
		clk = 1; #(Tclk/2);
	end

	parameter Tce = 20;
	always begin
		ce = 0; #(Tce/2);
		ce = 1; #(Tce/2);
	end

	initial begin
		N  = 15'd20;
		$dumpfile("AGNTD.vcd");
    $dumpvars(0, test_module);
		#10000;
		$finish();
	end

endmodule
