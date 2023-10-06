`timescale 1ns/1ns

`include "../ACCM.v"

module test_module;
	reg ce;
	reg clk;
	reg [7:0] X;

	wire [10:0] ACC;
	wire CO;
	wire Mx;

	ACCM uut(.X(X),     .ACC(ACC),
				   .ce(ce),   .CO(CO),
					 .clk(clk), .Mx(Mx));
	
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
		X = 4'd3;
		$dumpfile("ACCM.vcd");
    $dumpvars(0, test_module);
		#10000;
		$finish();
	end

endmodule
