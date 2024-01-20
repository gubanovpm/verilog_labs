`include "st_4BTN_4CDD.v"
`include "DEC4_to_BIN16.v"
`include "MULT_AxM.v"
`include "DIV_AB_Q.v"
`include "BIN27_to_DEC8.v"
`include "MUX16_4_1.v"
`include "DISPLAY.v"

module main(input clk,  output wire seg_P,
            input BTN0, output wire [3:0] AN,
            input BTN1, output wire [6:0] seg,
            input BTN2,
            input BTN3,
            input [4:0] SW);

  wire ok_DIV, ce1ms;

  wire [15:0] Ad; wire [15:0] Bd;
  wire [15:0] A_BIN; wire [15:0] B_BIN;
  wire [26:0] AxM; wire [26:0] QF;
  wire [31:0] DQF; wire [15:0] dat;

  st_4BTN_4CDD A_st_4BTN_4CDD(.clk(clk),   .DEC(Ad),
                              .BTN0(BTN0), 
                              .BTN1(BTN1),
                              .BTN2(BTN2),
                              .BTN3(BTN3),
                              .ce(ce1ms),
                              .EN(SW[3]),
                              .UP(SW[4]));

  DEC4_to_BIN16 A_DEC4_to_BIN16(.clk(clk), .BIN(A_BIN),
                                .DI(Ad));

  st_4BTN_4CDD B_st_4BTN_4CDD(.clk(clk),   .DEC(Bd),
                              .BTN0(BTN0), 
                              .BTN1(BTN1),
                              .BTN2(BTN2),
                              .BTN3(BTN3),
                              .ce(ce1ms),
                              .EN(SW[2]),
                              .UP(SW[4]));

  DEC4_to_BIN16 B_DEC4_to_BIN16(.clk(clk), .BIN(B_BIN),
                                .DI(Bd));

  MULT_AxM MULT_AxM(.clk(clk), .AxM(AxM),
                    .A(A_BIN));

  DIV_AB_Q DIV_AB_Q(.clk(clk),  .ok_div(ok_DIV),
                    .st(ce1ms), .Q(QF),
                    .A(AxM),
                    .B(B_BIN));

  BIN27_to_DEC8 BIN27_to_DEC8(.clk(clk),   .DEC(DQF),
                              .st(ok_DIV),
                              .BIN(QF));

  MUX16_4_1 MUX16_4_1(.A(Ad), .E(dat),
                      .B(Bd),
                      .C(DQF[15:0]),
                      .D(DQF[31:16]),
                      .S(SW[1:0]));

  DISPLAY DISPLAY(.clk(clk), .seg_P(seg_P),
                  .dat(dat), .AN(AN),
                             .seg(seg),
                             .ce1ms(ce1ms));

endmodule