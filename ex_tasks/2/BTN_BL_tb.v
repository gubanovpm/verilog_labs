`timescale 1ns/1ns
`include "BTN_BL.v"

module BTN_BL_tb;
	reg clk;
  reg ce;
  reg BTN;

	wire EN;
  wire RES;

  BTN_BL uut(.clk(clk), .RES(RES),
             .BTN(BTN), .EN(EN),
             .ce(ce));

  // Tclk = 20 ns
	parameter Tclk = 2;
	always begin
		clk = 0;
		#(Tclk/2);
		clk = 1;
		#(Tclk/2);
	end

  parameter Tce = 8;
	always begin
		ce = 0;
		#(Tce/2);
		ce = 1;
		#(Tce/2);
	end

	initial begin
		$dumpfile("BTN_BL_tb.vcd");
    $dumpvars(0, BTN_BL_tb);
    BTN = 0;
    #100; BTN = 1;
    #100; BTN = 0;
    #100; BTN = 1;
    #100; BTN = 0;
    #100; BTN = 1;
    #100; BTN = 0;
    #100; BTN = 1;
    #100; BTN = 0;
    #100; BTN = 1;
    #100; BTN = 0;
    #300;
		$finish();
	end
endmodule
