module VCB4RE_test;
	reg ce;
	reg clk;
	reg clr;

	wire [3:0] Q;
	wire TC;
	wire CEO;

	VCB4RE uut(.ce(ce),   .Q(Q),
						 .clk(clk), .TC(TC),
					   .clr(clr), .CEO(CEO));
	
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
		$dumpfile("VCB4RE.vcd");
    $dumpvars(0, VCB4RE_test);
		clr = 0;
		#380;  clr = 1;
		#10;   clr = 0;
		#811;  clr = 1;
		#270;  clr = 0;
		$finish();
	end
endmodule
