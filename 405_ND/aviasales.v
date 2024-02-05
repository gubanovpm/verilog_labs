`include "DISPLAY.v"
`include "ADR_DAT_BL.v"
`include "AR_TXD.v"
`include "AR_MUX.v"
`include "BUF32bit.v"

`include "AR_RXD.v"

// https://www.aviasales.ru/
module aviasales(input clk,     output wire LED0,
                 input BTN0,    output wire seg_P,
                 input BTN3,    output wire [6:0] seg,
                 input JA1,     output wire [3:0] AN,
                 input JA7,     output wire JB1,
                 input [3:0]SW, output wire JB2, 
                                output wire JB3,
                                output wire JB4,
                                output wire JB7,
                                output wire JB8,
                                output wire JB9,
                                output wire JC1,
                                output wire JC2,
                                output wire JC4);

  wire ce1ms, ce_wr;
  wire [15:0] dat_displ; wire [7:0] ADR_RX;
  wire [22:0] DAT_TX; wire [5:0] cb_bit;
  wire [1:0] N_VEL;   wire [7:0] ADR_TX;
  wire [23:0] DAT_RX; wire [23:0] sr_dat;
  wire [7:0] sr_adr;

  AR_TXD AR_TXD(.clk(clk),    .ce_tact(JB2),
                .st(ce1ms),   .SLP(LED7),
                .Nvel(N_VEL), .QM(JB9),
                .ADR(ADR_TX), .en_tx_word(JC2),
                .DAT(DAT_TX), .cb_bit(cb_bit),
                              .TXD1(JB1),
                              .TXD0(JB7),
                              .en_tx(JC1),
                              .T_cp(JB3),
                              .FT_cp(JB4),
                              .SDAT(JB8));

  ADR_DAT_BL ADR_DAT_BL(.BTN(BTN3), .VEL(N_VEL),
                                    .ADR(ADR_TX),
                                    .DAT(DAT_TX));

  AR_MUX AR_MUX(.ADR_TX(ADR_TX), .DISPL(dat_displ),
                .DAT_TX(DAT_TX),
                .ADR_RX(ADR_RX),
                .DAT_RX(DAT_RX),
                .S(SW[1:0]));

  DISPLAY DISPLAY(.clk(clk), .ce1ms(ce1ms),
                  .dat(dat_displ), .AN(AN),
                  .set_P(SW[2]), .seg(seg),
                                 .seg_P(seg_P));

  assign O0 = SW[3] ? JA7 : JB7;
  assign O1 = SW[3] ? JA1 : JB1;
  assign JC4 = ce_wr;

  AR_RXD AR_RXD(.inp0(O0), .ce_wr(ce_wr),
                .inp1(O1), .sr_dat(sr_dat),
                .clk(clk), .sr_adr(sr_adr));

  BUF32bit BUF32bit(.ce(ce_wr),      .RX_DAT(DAT_RX),
                    .sr_dat(sr_dat), .RX_ADR(ADR_RX),
                    .sr_adr(sr_adr), 
                    .clk(clk),
                    .R(BTN0));

endmodule