`timescale 1ns/1ns
`include "main.v"

module main_tb;
	reg clk; reg [7:0] SW;
  reg BTN0, BTN2, BTN3;
  
	wire seg_P, LED0;
  wire [3:0] AN;
  wire [6:0] seg;

  main uut(.clk(clk),   .seg_P(seg_P),
           .BTN0(BTN0), .LED0(LED0), 
           .BTN2(BTN2), .seg(seg),
           .BTN3(BTN3), .AN(AN),
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
    BTN0 = 0; BTN2 = 0; BTN3 = 0;
		#100; SW = 7'b0000000; BTN0 = 1; // load sec
    #100; BTN0 = 0; BTN2 = 1;
    #100; SW = 7'b0000000; BTN0 = 1;
    #30000;
		$finish();
	end
endmodule
