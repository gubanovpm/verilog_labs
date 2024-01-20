`timescale 1ns/1ns
`include "main.v"

module main_tb;
	reg clk, BTN0, BTN3;
  wire LED0, LED7, seg_P;
  wire [3:0] AN; wire [6:0] seg;

  main uut(.clk(clk),   .seg_P(seg_P),
           .BTN0(BTN0), .seg(seg),
           .BTN3(BTN3), .AN(AN),
                        .LED0(LED0),
                        .LED7(LED7));

  // Tclk = 20 ns
	parameter Tclk = 20;
	always begin
		clk = 0;
		#(Tclk/2);
		clk = 1;
		#(Tclk/2);
	end

	initial begin
		$dumpfile("main_tb.vcd");
    $dumpvars(0, main_tb);
    BTN0 = 0;
    BTN3 = 1;
    #30000000;
		$finish();
	end
endmodule
