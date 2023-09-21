`include "../submodules/D7seg.v"
`include "../submodules/Gen4an.v"
`include "../submodules/MUX16_4.v"
`include "../submodules/Gen1ms.v"
`include "../submodules/Gen_P.v"
`include "../submodules/Gen_Nms_1s.v"
`include "../submodules/DISPLAY.v"

module COUNT_GEN_NMS_tb;
	reg ce;
	reg clk;
	reg clr;
	reg Tmod = 1'b1;
	reg [1:0] SW;

	wire [9:0] Q;
	wire TC;
	wire CEO;
	wire [3:0] AN;
	wire [7:0] SEG;

	wire ce1ms ;
	wire [15:0] dat;



	DISPLAY DISPLAY(.clk(clk),     .ce1ms(ce1ms),
	                .dat(dat),     .AN(AN),
	                .PTR(SW[1:0]), .SEG(SEG));

	Gen_Nms_1s Gen_Nms_1s(.clk(clk), .CEO(CEO),
	                      .ce(ce1ms), 
	                      .Tmod(Tmod));

	COUNT_GEN_NMS Count_Gen_Nms(.ceo(CEO),   .bf_cb10R1(Q),
						                  .clk(clk));
	
	// sync signal generator
	parameter Tclk = 2; // period sync sig = 20 ns
	always begin
		clk = 1;
		#(Tclk/2);
		clk = 0;
		#(Tclk/2);
	end

	initial begin
		$dumpfile("COUNT_GEN_NMS.vcd");
    $dumpvars(0, COUNT_GEN_NMS_tb);
		#1000000;
		$finish();
	end
endmodule
