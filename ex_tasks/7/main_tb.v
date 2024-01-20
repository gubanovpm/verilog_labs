`timescale 1ns/1ns
`include "main.v"

module main_tb;

  reg clk, ce, ce1ms = 0;
  reg [15:0] X;

  wire FXM, ce1us, ce1s;
  wire [15:0] out;

  // main uut(.clk(clk),   .JB1(JB1),
  //          .BTN0(BTN0), .JB3(JB3),
  //          .BTN1(BTN1), .JA1(JA1),
  //          .BTN2(BTN2), .AN(AN),
  //          .BTN3(BTN3), .seg(seg),
  //          .SW0(SW0),   .seg_P(seg_P),
  //          .SW6(SW6),
  //          .SW7(SW7));

  Gen_ce05us Gen_ce05us(.clk(clk), .CO(ce1us));

  Gen_FXM Gen_FXM(.clk(clk),  .FXM(FXM),
                  .ce(ce1us),
                  .X(X));

  Mes_FXM Mes_FXM(.clk(clk), .FXM(out),
                  .ce(ce),
                  .MX(FXM));

  // Tclk = 20 ns
	parameter Tclk = 20;
	always begin
		clk = 0;
		#(Tclk/2);
		clk = 1;
		#(Tclk/2);
	end

  parameter Tce = 8000;
	always begin
		ce = 0;
		#(Tce/2);
		ce = 1;
		#(Tce/2);
	end

	initial begin
		$dumpfile("main_tb.vcd");
    $dumpvars(0, main_tb);
    X = 16'b10011100001111;
    #1000000;
		$finish();
	end

endmodule