`timescale 1ns/1ns

`include "main.v"

module main_tb();

  reg clk = 0, BTN0 = 0, JA1 = 0, JA2 = 0;
  reg [4:0] SW = 5'b10000; 
  
  wire LED0, LED7, seg_P, JB1, JB2;
  wire JC1, JC3, JC4, JC7, JC8;
  wire [3:0] AN; wire [6:0] seg; 

  parameter Tclk = 20.0;
	always begin
		clk = 0; #(Tclk/2);
		clk = 1; #(Tclk/2);
	end


  main main(.clk(clk),    .JB1(JB1),
            .JA1(JA1),    .JB2(JB2),
            .JA2(JA2),    .JC1(JC1),
            .BTN0(BTN0),  .JC3(JC3),
            .SW(SW),      .JC4(JC4),
                          .JC7(JC7),
                          .JC8(JC8),
                          .LED0(LED0),
                          .LED7(LED7),
                          .seg_P(seg_P),
                          .AN(AN),
                          .seg(seg));

  initial begin
		$dumpfile("main_tb.vcd");
    $dumpvars(0, main_tb);
    #100; SW = 5'b10000;
    #2500000

		$finish();
	end

endmodule