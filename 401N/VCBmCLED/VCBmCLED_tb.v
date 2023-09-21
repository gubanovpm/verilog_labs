module VCBmCLED_test;
	reg ce;
	reg clk;
	reg clr;

	wire [3:0] Q;
	wire [3:0] DI = 4'b0110;
	wire TC;
	wire CEO;

	reg L  = 1'b1;
	reg up = 1'b1;

	VCBmCLED uut(.ce(ce),   .Q(Q),
						  .up(up), .TC(TC),
					    .di(DI), .CEO(CEO),
						  .L(L),
						  .clk(clk),
						  .clr(clr));
	
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
		$dumpfile("VCBmCLED.vcd");
    $dumpvars(0, VCBmCLED_test);
		clr = 0;
		#20;   L = 1'b0;
		#380;  clr = 1; L = 1'b1;
		#40;   clr = 0;
		#40;   up = 1'b0; L = 1'b0;
		#811;  clr = 1;
		#270;  clr = 0;
		$finish();
	end
endmodule
