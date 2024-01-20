`timescale 1ns/1ns
`include "main.v"

module main_tb;

  reg clk, ce, ce1ms = 0;
  reg [15:0] X;

  wire MFX, ce01us, ce1s;
  wire [15:0] out; wire [15:0] QTX; 
  wire [15:0] FTX; wire [9:0] cb_MT;
  wire frontMTX, ceMT;

  Gen_ce01us Gen_ce01us(.clk(clk), .CO(ce01us));

  Gen_MFX_Fce50 Gen_MFX_Fce50(.clk(clk),  .MFX(MFX),
                              .X(X));

  Mes_MTXM Mes_MTXM(.clk(clk),       .QTX(QTX),
                    .ce01us(ce01us), .FTX(FTX),
                    .MTX(MFX),       .ceMT(ceMT), 
                                     .frontMTX(frontMTX),
                                     .cb_MT(cb_MT));

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
    X = 16'b1111100111;
    #10000000;
		$finish();
	end

endmodule