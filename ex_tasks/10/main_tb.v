`timescale 1ns/1ns
`include "main.v"

module main_tb;
  reg clk, BTN0, BTN1, BTN2, BTN3;
  reg [7:0] SW;

  wire LED0, LED1, LED2, LED4, LED5, LED6, LED7, seg_P;
  wire [3:0] AN; wire [6:0] seg;

  main main(.clk(clk),   .LED0(LED0),
            .BTN0(BTN0), .LED1(LED1),
            .BTN1(BTN1), .LED2(LED2), 
            .BTN2(BTN2), .LED4(LED4), 
            .BTN3(BTN3), .LED5(LED5),
            .SW(SW),     .LED6(LED6),
                         .LED7(LED7),
                         .seg_P(seg_P),
                         .seg(seg),
                         .AN(AN));

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
    BTN0 = 0; BTN1 = 0; BTN2 = 0; BTN3 = 0; SW = 8'b01001100;
    #999990; BTN1 = 1; BTN3 = 1;
    #2000000; BTN1 = 0; BTN3 = 0; SW = 8'b01001101;
    #2000000; BTN1 = 1; BTN3 = 1;
    #2000000; BTN1 = 0; BTN3 = 0;
    #2000000; BTN1 = 1;
    #2000000; BTN1 = 0;
    #2000000; SW = 8'b11001101;
    #2000000;
		$finish();
	end

endmodule