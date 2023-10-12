`timescale 1ns/1ns

`define TEST_MODULE
`include "../Sch_Lab402.v"

// Don't forget to change data for your variant in DAT_BL.v

module test_module;
	reg clk;
	reg BTN0;
	reg BTN3;
	reg [7:0] SW;

	wire JA1, JA2, JA3, JA4 ;
	wire JC1, JC2, JC3, JC4 ;
	wire JD1, JD2, JD3, JD4 ;
	wire JB7, JB8, JB9, JB10;
	wire seg_P;
	wire [3:0] AN;
	wire [6:0] seg;

	Sch_Lab402 uut(.BTN0(BTN0), .JA1(JA1),
								 .clk(clk),   .JA2(JA2),
								 .SW(SW),     .JA3(JA3),
								 .BTN3(BTN3), .JA4(JA4),
															.JC1(JC1),
															.JC2(JC2),
															.JC3(JC3),
															.JC4(JC4),
															.JD1(JD1),
															.JD2(JD2),
															.JD3(JD3),
															.JD4(JD4),
															.JB7(JB7),
															.JB8(JB8),
															.JB9(JB9),
															.JB10(JB10),
															.seg_P(seg_P),
															.AN(AN),
															.seg(seg));
	
	// sync signal generator
	parameter Tclk = 20; // period sync sig = 20 ns
	always begin
		clk = 0; #(Tclk/2);
		clk = 1; #(Tclk/2);
	end

	initial begin
		SW  = 8'hE4;	// X = 14, Y = 4
		$dumpfile("Sch_Lab402.vcd");
    $dumpvars(0, test_module);
		BTN0 = 0; BTN3 = 1; #100;
		BTN0 = 1; BTN3 = 0; #100;
		BTN0 = 0; #10000000;
		$finish();
	end

endmodule
