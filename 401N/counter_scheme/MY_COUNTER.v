`include "../submodules/D7seg.v"
`include "../submodules/Gen4an.v"
`include "../submodules/MUX16_4.v"
`include "../submodules/Gen1ms.v"
`include "../submodules/Gen_P.v"
`include "../submodules/Gen_Nms_1s.v"
`include "../submodules/DISPLAY.v"

`include "../VCBDmSE/VCBDmSE.v"
`include "../VCBmCLED/VCBmCLED.v"
`include "../VCD4RE/VCD4RE.v"
`include "../VCJ4RE/VCJ4RE.v"

`define m 4
`define N 18

module MY_COUNTER (input wire [0:0] BTN0, output wire [3:0] AN ,
                   input wire [0:0] BTN3, output wire [7:0] SEG,
                   input wire [7:0] SW,
                   input wire [0:0] clk);

	wire ce1ms ;
	wire [15:0] data;

	wire [4:0] CEO;
	wire [3:0]  TC;

	DISPLAY DISPLAY(.clk(clk),     .ce1ms(ce1ms),
                  .dat(data),    .AN(AN),
									.PTR(SW[1:0]), .SEG(SEG));

	Gen_Nms_1s Gen_Nms_1s(.clk(clk),  .CEO(CEO[0]),
                        .ce(ce1ms), 
                        .Tmod(SW[7]));

	VCBDmSE  VCBDmSE (.ce(CEO[0]), .Q(data[3:0]),
                    .clk(clk),   .TC(TC[0]), 
                    .s(BTN0),    .CEO(CEO[1]));
  
	VCBmCLED VCBmCLED(.ce(CEO[1]),  .Q(data[7:4]),
                    .up(SW[6]),   .CEO(CEO[2]),
                    .di(SW[5:2]), .TC(TC[1]),
                    .L(BTN3),
                    .clk(clk),
                    .clr(BTN0));
	
	VCD4RE     VCD4RE(.clk(clk),   .Q(data[11:8]),
	                  .clr(BTN0),  .TC(TC[2]),
	                  .ce(CEO[2]), .CEO(CEO[3]));

	VCJ4RE0    VCJ4RE(.clk(clk),   .Q(data[15:12]),
	                  .clr(BTN0),  .TC(TC[3]),
	                  .ce(CEO[3]), .CEO(CEO[4]));
	
endmodule
