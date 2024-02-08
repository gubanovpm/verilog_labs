`include "CONST.v"
`include "DISPLAY.v"
`include "MUX_dat.v"
`include "LED_BL.v"
`include "FSK_FRXD.v"
`include "MUX_FSK.v"
`include "BTN_REG_AMP.v"
`include "BTN_REG_DAT.v"
`include "Gen_FSK_byte.v"
`include "SPI_DAC8043.v"
`include "ADC_95.v"

module main(input clk,       output wire seg_P,
            input [3:0] BTN, output wire [3:0] AN,
            input [3:0] SW,  output wire [6:0] seg,
            input JC8,       output wire JA1,
            input JC9,       output wire JA8,
                             output wire JA9, 
                             output wire JA10,
                             output wire JB1,
                             output wire JB2,
                             output wire JB3,
                             output wire JB4,
                             output wire JC7,
                             output wire JC10,
                             output wire JD1,
                             output wire JD2,
                             output wire JD3,
                             output wire JD4,
                             output wire [7:0] LED);

  wire ce1s, ce10ms, ce100ms, st_MDAC, st_ADC, en_rx_byte;
  wire [7:0] RX_DAT;  wire [15:0] Amin;
  wire [15:0] SHdec;  wire [15:0] AMPdec;
  wire [15:0] AF1dec; wire [15:0] AF2dec;
  wire [12:0] SHbin;  wire [11:0] AMPbin;
  wire [11:0] FSK_IN; wire [7:0] TX_DAT;
  wire [11:0] MADC;   wire [11:0] FSK_FH;
  wire [7:0] Mamp;    wire [15:0] OUT_dat;

  assign JD1 = en_rx_byte;
  assign JB4 = st_ADC;

  BTN_REG_DAT BTN_REG_DAT(.BTN_UP(BTN[2]),  .DAT(TX_DAT),
                          .BTN_DOWN(BTN[1]),
                          .clk(clk),
                          .ce(ce10ms));

  BTN_REG_AMP BTN_REG_AMP(.BTN_UP(BTN[3]),   .M(Mamp),
                          .BTN_DOWN(BTN[0]),
                          .clk(clk),
                          .ce(ce10ms));

  Gen_FSK_byte Gen_FSK_byte(.clk(clk),     .ce_bit(JA1),
                            .st(ce_100ms), .en_tx(JB1),
                            .dat(TX_DAT),  .TXD(JB2),
                            .Mamp(Mamp),   .S(JB3),
                                           .ce_SIN(JD4),
                                           .ce_sd(st_MDAC),
                                           .FSK_SH(FSK_FH));

  SPI_DAC8043 SPI_DAC8043(.clk(clk),    .SCLK(JA8),
                          .st(st_MDAC), .SDAT(JA9),
                          .DI(FSH_FH),  .NLD(JA10));

  FSK_FRXD FSK_FRXD(.clk(clk),       .st_SADC(st_ADC),
                    .st(ce1s),       .en_rx_byte(en_rx_byte),
                    .FSK_IN(FSK_IN), .URXD(JD2),
                                     .OCD(JD3),
                                     .RX_dat(RX_DAT),
                                     .Amin(Amin),
                                     .SHdec(SHdec),
                                     .AMPdec(AMPdec),
                                     .AF1dec(AF1dec),
                                     .AF2dec(AF2dec),
                                     .SHbin(SHbin),
                                     .AMPbin(AMPbin));

  ADC_95 ADC_95(.clk(clk),  .st_ADC(JC10),
                .SDAT(JC8), .SCLK(JC7),
                .BUSY(JC9), .ADC_5000(MADC),
                .st(st_ADC));

  MUX_FSK MUX_FSK(.S(SW[3]), .O(FSK_IN),
                  .A(FSK_FH), 
                  .B(MADC));

  LED_BL LED_BL(.E(en_rx_byte), .DO(LED),
                .DI(Mamp));

  MUX_dat MUX_dat(.TX_DAT(TX_DAT), .OUT_dat(OUT_dat),
                  .RX_DAT(RX_DAT),
                  .Amin(Amin),
                  .SHdec(SHdec),
                  .AMPdec(AMPdec),
                  .AF1dec(AF1dec),
                  .AF2dec(AF2dec),
                  .SHbin(SHbin),
                  .AMPbin(AMPbin),
                  adr(SW[2:0]));

  DISPLAY DISPLAY(.clk(clk),     .seg_P(seg_P),
                  .dat(OUT_dat), .ce10ms(ce10ms),
                  .PTR(SW[2:0]), .ce100ms(ce100ms),
                                 .ce1s(ce1s),
                                 .AN(AN),
                                 .seg(seg));

endmodule