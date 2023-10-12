`ifndef TEST_MODULE
	`include "DAT_BL.v"
	`include "BUTTON_BL.v"
	`include "WGMT.v"
	`include "AGNT.v"
	`include "AGNMT.v"
	`include "AGSAW_YX.v"
	`include "ACCM.v"
	`include "Display.v"
	`include "MEG_BL.v"
`else
	`include "../DAT_BL.v"
	`include "../BUTTON_BL.v"
	`include "../WGMT.v"
	`include "../AGNT.v"
	`include "../AGNMT.v"
	`include "../AGSAW_YX.v"
	`include "../ACCM.v"
	`include "../Display.v"
	`include "../MEG_BL.v"
`endif

module Sch_Lab402 ( input BTN0,				output wire JA1,
										input clk,				output wire JA2,
										input [7:0] SW,		output wire JA3,
										input BTN3,				output wire JA4,
																			output wire JC1,
																			output wire JC2,
																			output wire JC3,
																			output wire JC4,
																			output wire JD1,
																			output wire JD2,
																			output wire JD3,
																			output wire JD4,
																			output wire JB7,
																			output wire JB8,
																			output wire JB9,
																			output wire JB10,
																			output wire seg_P,
																			output wire [3:0] AN,
																			output wire [6:0] seg );

	wire [15:0] NTclk;
	wire [10:0] MT;
	wire [10:0] N;
	wire [7:0] QMx;
	
	wire st;
	wire ceo;
	wire PW;
	
	wire [10:0] q1;
	wire [10:0] q2;
	wire [10:0] q3;
	wire [10:0] ACC;
	wire [3:0] q;

	assign JA2 = ceo;
	assign JA3 = PW;

	MEG_BL MEG_BL(.clk(clk), .Q(QMx),
								.Inp(JD4), 
								.REF(JA2),
								.st(st),
								.rst(BTN3));

	DAT_BL DAT_BL(.NTclk(NTclk),
								.MT(MT),
								.N(N));

	BUTTON_BL BUTTON_BL(.BUTTON(BTN0), .st(st),
											.clk(clk));
	
	WGMT WGMT(.st(st),       .end_PW(JA1),
						.clk(clk),     .ceo(ceo),
						.NTclk(NTclk), .PW(PW),
						.MT(MT),       .q(q1));
	
	AGNT AGNT(.ce(ceo),  .TC(JA4),
						.clk(clk), .ceo(JC1),
						.N(N),     .q(q2));

	AGNMT AGNMT(.ce(ceo),   .start_PW(JC2),
							.clk(clk),  .PW(JC3),
							.MT(MT),    .end_PW(JC4),
						  .N(N),      .q(q3));

	AGSAW_YX AGSAW(.ce(ceo),    .tc_X(JD1),
								 .clk(clk),   .tc_Y(JD2),
								 .X(SW[7:4]), .q(q),
								 .Y(SW[3:0]));

	ACCM ACCM(.ce(ceo),  .CO(JD3),
						.clk(clk), .Mx(JD4),
						.X(SW),    .ACC(ACC));

	Display Display(.clk(clk), .seg_P(seg_P),
									.LB(SW),   .AN(AN),
									.HB(QMx),  .seg(seg));

endmodule
