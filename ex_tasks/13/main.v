`include "BIN16_to_DEC4.v"
`include "COMP_MULT.v"
`include "DEC4_to_BIN16.v"
`include "DISPLAY.v"
`include "Gen_12ROT.v"
`include "MUX16_2_1.v"
`include "OBUF8.v"
`include "st_4BTN_4CDD.v"

module main(input clk,       output wire seg_P,
            input [7:0] SW,  output wire [7:0] LED,
            input [3:0] BTN, output wire [3:0] AN,
                             output wire [6:0] seg);

  wire ce1ms; wire [15:0] RX;
  wire [15:0] DXre; wire [15:0] DXim;
  wire [15:0] RXre; wire [15:0] RXim;
  wire [15:0]  Xre; wire [15:0]  Xim;
  wire [15:0]  Pre; wire [15:0]  Pim;
  wire [17:0]  COS; wire [17:0]  SIN;

  OBUF8 OBUF8(.SW(SW), .LED(LED));

  st_4BTN_4CDD Re_st_4BTN_4CDD(.BTN(BTN),  .DEC(DXre),
                               .ce(ce1ms),
                               .clk(clk),
                               .EN(SW[1]),
                               .UP(SW[3]));

  DEC4_to_BIN16 Re_DEC4_to_BIN16(.clk(clk), .BIN(Xre),
                                 .DI(DXre));

  st_4BTN_4CDD Im_st_4BTN_4CDD(.BTN(BTN),  .DEC(DXim),
                               .ce(ce1ms),
                               .clk(clk),
                               .EN(SW[2]),
                               .UP(SW[3]));

  DEC4_to_BIN16 Im_DEC4_to_BIN16(.clk(clk), .BIN(Xim),
                                 .DI(DXim));

  DISPLAY DISPLAY(.clk(clk), .seg_P(seg_P),
                  .dat(RX),  .AN(AN),
                             .seg(seg),
                             .ce1ms(ce1ms));

  Gen_12ROT Gen_12ROT(.k(SW[7:4]), .Rre(COS),
                                   .Rim(SIN));

  COMP_MULT COMP_MULT(.Xi(Xim), .Pim(Pim),
                      .Xr(Xre), .Pre(Pre),
                      .clk(clk),
                      .COS(COS),
                      .SIN(SIN));

  BIN16_to_DEC4 Re_BIN16_to_DEC4(.clk(clk), .DEC(RXre),
                                 .st(ce1ms),
                                 .BIN(Pre));

  BIN16_to_DEC4 Im_BIN16_to_DEC4(.clk(clk), .DEC(RXim),
                                 .st(ce1ms),
                                 .BIN(Pim));

  MUX16_2_1 D_MUX16_2_1(.s(SW[0]), .C(RX),
                        .A(RXim),
                        .B(RXre));

endmodule