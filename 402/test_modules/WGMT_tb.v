`timescale 1ns/1ns

`include "../WGMT.v"

module WGMT_test;
	reg st;
	reg clk;
	reg [15:0] NTclk;
	reg [10:0] MT;

	wire [10:0] Q;
	wire end_PW;
	wire CEO;
	wire PW;

	WGMT uut(.st(st),       .q(Q),
					 .clk(clk),     .end_PW(end_PW),
				   .NTclk(NTclk), .ceo(CEO),
				   .MT(MT),       .PW(PW));
	
	// sync signal generator
	parameter Tclk = 20; // period sync sig = 20 ns
	always begin
		clk = 1;
		#(Tclk/2);
		clk = 0;
		#(Tclk/2);
	end

	initial begin
		NTclk = 15'd20;
		MT    = 11'd16;
		$dumpfile("WGMT.vcd");
    $dumpvars(0, WGMT_test);
		st = 0; #20;  
		st = 1; #20;
		st = 0; #10000;
		$finish();
	end
endmodule
