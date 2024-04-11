`include "MIL_TXD.v"
`include "Gen_txen_DAT.v"
`include "MUX16_4_1.v"
`include "DISPLAY.v"
`include "MIL_RXD.v"
`include "BUF_RX_DAT.v"

module main(input clk,      output wire JB1,
            input JA1,      output wire JB2,
            input JA2,     	output wire JC1,
            input BTN0,     output wire JC3,
            input [4:0] SW, output wire JC4,
                            output wire JC7,
                            output wire JC8,
                            output wire LED0,
                            output wire LED7,
                            output wire seg_P,
                            output wire [3:0] AN,
                            output wire [6:0] seg);

wire [15:0] DAT;     wire [15:0] CW_TX;
wire [15:0] DW_TX;   wire [15:0] dat_displ;
wire [15:0] CW_DAT;  wire [15:0] DW_DAT;
wire [5:0]  cb_tact; wire [15:0] sr_DAT;
wire [7:0]  cb_XOR;
wire [4:0]  cb_bit;  wire [4:0] cb_bit_;
wire txen, ce1ms, ok_rx, CW_DW;
wire T_end, T_end_, FT_cp, ce_tact;
assign LED7 = JC1;

MIL_TXD MIL_TXD(.clk(clk),  .TXP(JB1),
                .txen(txen),.TXN(JB2),
                .dat(DAT),  .SY2(JC2),
                        		.en_tx(JC1),
                        		.T_end(T_end),
                        		.SDAT(JC3),
                        		.cb_bit(cb_bit));

Gen_txen_DAT Gen_txen_DAT(.clk(clk), 	.DAT(DAT),
                          .st(ce1ms),	.txen(txen),
                                    	.CW_TX(CW_TX),
                                    	.DW_TX(DW_TX));

MUX16_4_1 MUX16_4_1(.A(CW_TX),		.E(dat_displ),
                    .B(DW_TX),
                    .C(CW_DAT),
                    .D(DW_DAT),
                    .adr(SW[1:0]));

DISPLAY DISPLAY(.clk(clk),       	.seg_P(seg_P),
                .dat(dat_displ), 	.ce1ms(ce1ms),
								.ptr_P(SW[3:2]),	.seg(seg));

assign O1 = SW[4] ? JB1 : JA1;
assign O2	= SW[4] ? JB2 : JA2;

MIL_RXD MIL_RXD(.clk(clk),	.ok_rx(ok_rx),
								.In_P(O1),	.sr_dat(sr_DAT),
								.In_N(O2),	.CW_DW(CW_DW),
														.T_end(T_end_),
														.FT_cp(FT_cp),
														.en_rx(LED0),
														.cb_tact(cb_tact),
														.cb_bit(cb_bit_),
														.en_wr(JC8),
														.ce_tact(ce_tact),
														.QM(JC7),
														.cb_XOR(cb_XOR),
														.ok_SY(JC4));

BUF_RX_DAT BUF_RX_DAT(.clk(clk),			.DAT_CW(CW_DAT),
											.ce(ok_rx),			.DAT_DW(DW_DAT),
											.DAT_RX(sr_DAT),
											.CW_DW(CW_DW),
											.R(BTN0));													

endmodule