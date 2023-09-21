`timescale 1ns/1ns

module my_counter_test;

	reg clk;
	reg BTN0;
	reg BTN2;
	reg BTN3;
	reg [7:0] SW;

	wire [15:0] DATA;
	wire [3:0] AN;
	wire [7:0] SEG;

	parameter Tclk = 20; // period clk=20ns, Fclk=50MHz
	always begin
		clk = 1;
		#(Tclk/2); clk = 0;
		#(Tclk/2);
	end

	STRANGE_COUNTER uut(.BTN0(BTN0), .AN(AN),
	                    .BTN3(BTN3), .SEG(SEG),
	                    .BTN2(BTN2),
											.SW(SW), 
	                    .clk(clk));

	initial begin
		$dumpfile("MY_COUNTER.vcd");
		$dumpvars(0, my_counter_test);
		BTN0 = 0;
		SW = 8'b11011000;
		#1; BTN0 = 1;
		#10000; BTN0 = 0; BTN3 = 1;
		#1; BTN3 = 0;
		#10; BTN2 = 1;
		#1000; BTN2 = 0;
		#200000000;
		$finish();
	end

endmodule
