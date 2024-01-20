`include "BIN24_to_DEC8.v"
`include "DEC4_to_BIN16.v"
`include "DISPLAY.v"
`include "MODUL_BL.v"
`include "MUX16_4_1.v"
`include "st_4BTN_4CDD.v"

module main(input clk, output wire seg_P,
            input [3:0] BTN, output wire [3:0] AN,
            input [4:0] SW,  output wire [6:0] seg);

  wire ok_SQRT, ce1ms; wire [15:0] dat;
  wire [15:0] Adec; wire [15:0] Bdec;
  wire [15:0] Abin; wire [15:0] Bbin;
  wire [23:0] SQRTbin; wire [31:0] SQRTdec;

  st_4BTN_4CDD Re_st_4BTN_4CDD(.BTN(BTN),  .DEC(Adec),
                               .ce(ce1ms),
                               .clk(clk),
                               .EN(SW[2]),
                               .UP(SW[4]));

  DEC4_to_BIN16 Re_DEC4_to_BIN16(.clk(clk), .BIN(Abin),
                                 .DI(Adec));

  st_4BTN_4CDD Im_st_4BTN_4CDD(.BTN(BTN),  .DEC(Bdec),
                               .ce(ce1ms),
                               .clk(clk),
                               .EN(SW[3]),
                               .UP(SW[4]));

  DEC4_to_BIN16 Im_DEC4_to_BIN16(.clk(clk), .BIN(Bbin),
                                 .DI(Bdec));

  MODUL_BL MODUL_BL(.clk(clk),  .ok(ok_SQRT),
                    .st(ce1ms), .Q_mod(SQRTbin),
                    .A(Abin[13:0]),
                    .B(Bbin[13:0]));

  BIN24_to_DEC8 BIN24_to_DEC8(.st(ok_SQRT), .DEC(SQRTdec),
                              .clk(clk),
                              .BIN(SQRTbin));

  DISPLAY DISPLAY(.clk(clk),    .seg_P(seg_P),
                  .dat(dat),    .AN(AN),
                  .SW(SW[1:0]), .seg(seg),
                                .ce1ms(ce1ms));

  MUX16_4_1 D_MUX16_4_1(.A(Adec), .E(dat),
                        .B(Bdec),
                        .C(SQRTdec[15:0]),
                        .D(SQRTdec[31:16]),
                        .S(SW[1:0]));

endmodule