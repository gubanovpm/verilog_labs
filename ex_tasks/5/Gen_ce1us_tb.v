`timescale 1ns/1ns
`include "Gen_ce1us.v"

module Gen_ce1us_tb;
	reg clk;
  wire CO;

  Gen_ce1us uut(.clk(clk), .CO(CO));

  // Tclk = 20 ns
	parameter Tclk = 20;
	always begin
		clk = 0;
		#(Tclk/2);
		clk = 1;
		#(Tclk/2);
	end

	initial begin
		$dumpfile("Gen_ce1us_tb.vcd");
    $dumpvars(0, Gen_ce1us_tb);
    #300000;
		$finish();
	end
endmodule
