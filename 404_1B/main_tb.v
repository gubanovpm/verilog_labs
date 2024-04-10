`timescale 1ns/1ns

`include "main.v"

module main_tb();

  reg clk = 0, BTN0 = 0, BTN3 = 0, URXD = 0, JD4 = 0;
  reg [7:0] SW = 8'h00; 

  wire LED0, LED7, seg_P, JB2, JB3, JB4, JB7, JB8;
  wire UTXD, JD3, JC1, JC2, JC3, JC4, JC7, JC8;
  wire [3:0] AN; wire [6:0] seg;

  parameter Tclk = 20;
	always begin
		clk = 0; #(Tclk/2);
		clk = 1; #(Tclk/2);
	end

  main main(.clk(clk),   .LED0(LED0),
            .BTN0(BTN0), .LED7(LED7),
            .BTN3(BTN3), .seg_P(seg_P),
            .URXD(URXD), .AN(AN), 
            .JD4(JD4),   .seg(seg),
            .SW(SW),     .JB2(JB2),
                         .JB3(JB3),
                         .JB4(JB4),
                         .JB7(JB7),
                         .UTXD(UTXD),
                         .JD3(JD3),
                         .JC1(JC1),
                         .JC2(JC2),
                         .JC3(JC3),
                         .JC4(JC4),
                         .JC7(JC7),
                         .JC8(JC8));

  initial begin
		$dumpfile("main_tb.vcd");
    $dumpvars(0, main_tb);
    URXD = 1; JD4 = 1;
    SW = 7'b1010101;
    #1000010
    #26000 
    #26000 URXD = 0;
    #26000 URXD = 1;
    #234000 URXD = 0;
    #26000 URXD = 1;
    #26000 URXD = 0;
    #26000 URXD = 1;
    #100000 

		$finish();
	end

endmodule