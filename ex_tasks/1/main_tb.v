`timescale 1ns/1ns
`include "main.v"

module main_tb;
	reg clk;
  reg BTN0, BTN2, BTN3;
	reg [7:0] SW;

  wire LED0;
	wire seg_P;
  wire [3:0] AN;
  wire [6:0] seg;

  main uut(.clk(clk),   .LED0(LED0),
           .BTN0(BTN0), .seg_P(seg_P),
           .BTN2(BTN2), .AN(AN),
           .BTN3(BTN3), .seg(seg),
           .SW(SW));

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
    SW = 7'b1000000; BTN2 = 0; BTN0 = 1; // 0 hours
    #1000; SW = 7'b0000001; BTN2 = 1;     // 1 min
    #1000; BTN0 = 0; BTN2 = 0;
    #3000000;
		$finish();
	end
endmodule
