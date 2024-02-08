`timescale 1ns/1ns
`include "main.v"

module main_tb();

  reg clk, URXD, JD4 = 0;
  reg [7:0] SW = 7'b0;

  wire seg_P, UTXD, JD3, JC1, JB2, JB3, JB4;
  wire [6:0] seg; wire [3:0] AN; wire [7:0] LED;

	parameter Tclk = 20;
	always begin
		clk = 0; #(Tclk/2);
		clk = 1; #(Tclk/2);
	end

  main main(.clk(clk),   .LED(LED),
            .SW(SW),     .seg_P(seg_P),
            .URXD(URXD), .seg(seg),
            .JD4(JD4),   .AN(AN),
                         .UTXD(UTXD), 
                         .JD3(JD3),
                         .JC1(JC1),
                         .JB2(JB2),
                         .JB3(JB3),
                         .JB4(JB4));

  initial begin
		$dumpfile("main_tb.vcd");
    $dumpvars(0, main_tb);
    #10000000;
		$finish();
	end

endmodule