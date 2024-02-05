`timescale 1ns/1ns
`include "aviasales.v"

module aviasales_tb();
  reg clk, BTN0 = 0, BTN3 = 0, JA1 = 0, JA7 = 0;
  reg [3:0] SW = 4'b0;

  wire LED0, seg_P, JB1, JB2, JB3, JB4, JB7, JB8, JB9, JC1, JC2, JC4;
  wire [6:0] seg; wire [3:0] AN;

	parameter Tclk = 20;
	always begin
		clk = 0; #(Tclk/2);
		clk = 1; #(Tclk/2);
	end

  aviasales main(.clk(clk),   .LED0(LED0),
                 .BTN0(BTN0), .seg_P(seg_P),
                 .BTN3(BTN3), .seg(seg),
                 .JA1(JA1),   .AN(AN),
                 .JA7(JA7),   .JB1(JB1),
                 .SW(SW),     .JB2(JB2),
                              .JB3(JB3),
                              .JB4(JB4),
                              .JB7(JB7),
                              .JB8(JB8),
                              .JB9(JB9),
                              .JC1(JC1),
                              .JC2(JC2),
                              .JC4(JC4));

  initial begin
		$dumpfile("aviasales_tb.vcd");
    $dumpvars(0, main);
		#1000; BTN3 = 1;
    #1000; BTN3 = 0;
    #10000000;
		$finish();
	end

endmodule