`timescale 1ns/1ns
`include "main.v"

module main_tb();

  reg clk = 0; reg BTN0 = 0, JC1 = 0;
  reg [2:0] SW = 3'b100;

  wire JC2, JB1, JB2, JB3, JC4, seg_P, LED0;
  wire [6:0] seg; wire [3:0] AN;

  parameter Tclk = 20;
	always begin
		clk = 0; #(Tclk/2);
		clk = 1; #(Tclk/2);
	end

  main main(.clk(clk),   .JC2(JC2),
            .BTN0(BTN0), .JB1(JB1),
            .SW(SW),     .JB2(JB2),
            .JC1(JC1),   .JB3(JB3),
                         .JC4(JC4),
                         .AN(AN),
                         .seg(seg),
                         .seg_P(seg_P),
                         .LED0(LED0));

  initial begin
		$dumpfile("main_tb.vcd");
    $dumpvars(0, main_tb);
    #65000000;
		$finish();
	end

endmodule