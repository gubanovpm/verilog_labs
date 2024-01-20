`include "Gen_ce5us.v"
`include "Gen_MTX.v"
`include "BTN4_BL.v"
`include "DEC4CD.v"
`include "DEC4_to_BIN16.v"
`include "MUX16_2_1.v"
`include "Mes_F_MTX.v"
`include "Div_A40_B18_Q24.v"
`include "BIN24_to_DEC8.v"
`include "DISPLAY.v"
`include "Gen_ce01us.v"

module main(input clk,  output wire JB1,
            input BTN0, output wire JB2,
            input BTN1, output wire JC1,
            input BTN2, output wire JC4,
            input BTN3, output wire seg_P,
            input SW0,  output wire [3:0] AN,
            input SW1,  output wire [6:0] seg,
            input SW6, 
            input SW7,
            input JA1);

  wire ce5us, ce01us, MTX, ce1ms, ok_DIV;
  wire st0, st1, st2, st3, st_DIV;
  wire [15:0] BIN2X; wire [15:0] Mdec;
  wire [15:0] FMTX;  wire [31:0] Fdec;
  wire [15:0] C2dat; wire [23:0] Q;
  wire [17:0] cb_Y;  wire [39:0] MX;

  assign O = SW7 ? MTX : JA1;

  Gen_ce5us  Gen_ce5us(.clk(clk), .CO(ce5us));
  Gen_ce01us Gen_ce01us(.clk(clk), .CO(ce01us));
  Gen_MTX Gen_MTX(.clk(clk), .MTX(MTX),
                  .ce(ce5us), 
                  .X(BIN2X));

  BTN4_BL BTN4_BL(.BTN0(BTN0), .st0(st0),
                  .BTN1(BTN1), .st1(st1),
                  .BTN2(BTN2), .st2(st2),
                  .BTN3(BTN3), .st3(st3),
                  .ce(ce1ms),
                  .clk(clk));

  DEC4CD DEC4CD(.clk(clk), .DEC(Mdec),
                .UP(SW6),
                .st0(st0),
                .st1(st1),
                .st2(st2),
                .st3(st3));

  DEC4_to_BIN16 DEC4_to_BIN16(.DEC(Mdec), .BIN(BIN2X),
                              .clk(clk),
                              .ce(ce5us));

  MUX16_2_1 FMUX16_2_1(.s(SW0), .C(FMTX),
                       .A(Fdec[31:16]),
                       .B(Fdec[15:0]));

  MUX16_2_1 SMUX16_2_1(.s(SW1), .C(C2dat),
                       .A(Mdec),
                       .B(FMTX));

  DISPLAY DISPLAY(.clk(clk),   .seg_P(seg_P),
                  .SW0(SW0),   .ce1ms(ce1ms),
                  .SW1(SW1),   .AN(AN), 
                  .dat(C2dat), .seg(seg));

  BIN24_to_DEC8 BIN24_to_DEC8(.clk(clk), .Ddec(Fdec),
                              .st(ok_DIV),
                              .Dbin(Q));

  Div_A40_B18_Q24 Div_A40_B18_Q24(.st(st_DIV), .ok_div(ok_DIV),
                                  .A(MX),      .Q(Q),
                                  .B(cb_Y),
                                  .clk(clk));

  Mes_F_MTX Mes_F_MTX(.clk(clk),       .ce_end(st_DIV),
                      .ce01us(ce01us), .MX(MX),
                      .ce1ms(ce1ms),   .cb_Y(cb_Y),
                      .MTX(O),         .Tmes(JC1),
                                       .Tm(JB2)); 

endmodule