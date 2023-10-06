`timescale 1ns/1ns

`include "../AGSAW_YX.v"

module test_module;
	reg ce;
	reg clk;
	reg [3:0] Y;
	reg [3:0] X;

	wire [3:0] q;
	wire PW;
	wire tc_X;
	wire tc_Y;

	AGSAW_YX uut(.Y(Y),
							 .X(X),     .tc_Y(tc_X),
							 .ce(ce),   .tc_X(tc_Y),
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
		Y = 11'd6;
		X = 11'd6;
		$dumpfile("AGSAW_YX.vcd");
    $dumpvars(0, test_module);
		#10000;
		$finish();
	end

endmodule
