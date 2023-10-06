`timescale 1ns/1ns

`include "../MEG_BL.v"

module test_module;
	reg clk, st, Inp, REF, rst;
	
	wire [7:0] Q;

	MEG_BL uut(.clk(clk), .Q(Q),
						 .st(st),
						 .Inp(Inp),
						 .REF(REF), 
						 .rst(rst));
	
	// sync signal generator
	parameter Tclk = 20; // period sync sig = 20 ns
	always begin
		clk = 0; #(Tclk/2);
		clk = 1; #(Tclk/2);
	end

	initial begin
		Inp = 0; REF = 0; st = 0;
		$dumpfile("MEG_BL.vcd");
    $dumpvars(0, test_module);
		rst = 0; #100;
		rst = 1; #100;
		rst = 0; Inp = 1; REF = 1; #100;
		Inp = 0; #100;
		REF = 0; #10000;
		$finish();
	end

endmodule
