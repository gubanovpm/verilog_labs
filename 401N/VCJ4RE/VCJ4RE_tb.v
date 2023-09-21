module VCJ4RE_test;
	reg ce;
	reg clk;
	reg clr;

	wire [3:0] Q0; wire [3:0] Q2;
	wire TC0;      wire TC2;
	wire CEO0;     wire CEO2;

	VCJ4RE0 uut0(.ce(ce),   .Q(Q0),
						   .clk(clk), .TC(TC0),
					     .clr(clr), .CEO(CEO0));

	VCJ4RE2 uut2(.ce(ce),   .Q(Q2),
	             .clk(clk), .TC(TC2),
						   .clr(clr), .CEO(CEO2));
	// sync signal generator
	parameter Tclk = 20; // period sync sig = 20 ns
	always begin
		clk = 1;
		#(Tclk/2);
		clk = 0;
		#(Tclk/2);
	end

	// periodic ce sig generator
	parameter Tce = 40; // period ce sig = 160 ns
	always begin
		ce = 0;
		#(Tce/2);
		ce = 1;
		#(Tce/2);
	end

	initial begin
		$dumpfile("VCJ4RE.vcd");
    $dumpvars(0, VCJ4RE_test);
		clr = 0;
		#380;  clr = 1;
		#10;   clr = 0;
		#811;  clr = 1;
		#270;  clr = 0;
		$finish();
	end
endmodule
