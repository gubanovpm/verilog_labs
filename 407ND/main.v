`include "SORCE_DAT.v"
`include "DISPLAY.v"
`include "Gen_st.v"
`include "MUX64_16.v"
`include "SPI_MASTER.v"
`include "SPI_SLAVE.v"

module main(input clk,     output wire JC2,
            input BTN0,     output wire JB1,
						input[2:0] SW, output wire JB2,
						input JC1,     output wire JB3,
						               output wire JC3,
													 output wire JC4,
													 output wire[3:0] AN,
													 output wire[6:0] seg,
													 output wire seg_P,
													 output wire LED0);

wire [15:0] DISPL_dat;
wire [`m-1:0] MTX_DAT; wire [`m-1:0] MRX_DAT;
wire [`m-1:0] sr_MTX;  wire [`m-1:0] sr_MRX;
wire [`m-1:0] sr_STX;  wire [`m-1:0] sr_SRX;
wire [`m-1:0] STX_DAT; wire [`m-1:0] SRX_DAT;
wire [7:0] cb_bit;
wire ce_st, ce;

wire LOAD = SW[2] ? JB1 : JC1;

assign JC2  = ce_st;
assign LED0 = ~LOAD;

DISPLAY DISPLAY(.clk(clk),       .ce1ms(JC4),
								.dat(DISPL_dat), .AN(AN),
								                 .seg(seg),
																 .seg_P(seg_p));

Gen_st Gen_st(.clk(clk), .ce_st(ce_st));

MUX64_16 MUX64_16(.A(MTX_DAT), .DO(DISPL_dat),
									.B(MRX_DAT),
									.C(STX_DAT),
									.D(SRX_DAT),
									.S(SW[1:0]));

SORCE_DAT SORCE_DAT(.MASTER_dat(MTX_DAT),
										.SLAVE_dat(STX_DAT));

SPI_MASTER SPI_MASTER(.st(ce_st),   .LOAD(JB1),
											.clk(clk),    .SCLK(JB2),
											.MISO(JB4),   .MOSI(JB3),
											.clr(BT0),    .ce(ce),
											.DI(MTX_DAT), .ce_tact(JC3),
																		.cb_bit(cb_bit),
																		.sr_MTX(sr_MTX),
																		.sr_MRX(sr_MRX),
																		.DO(MRX_DAT));

SPI_SLAVE SPI_SLAVE(.DI(STX_DAT), .DO(SRX_DAT),
                    .sclk(JB2),   .sr_STX(sr_STX),
										.MOSI(JB3),   .sr_SRX(sr_SRX),
										.load(LOAD),  .MISO(JB4),
										.clr(BT0));

endmodule