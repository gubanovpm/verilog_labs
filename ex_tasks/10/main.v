`include "st_4BTN_4CDD.v"
`include "DEC4_to_BIN16.v"
`include "ALD.v"
`include "BIN27_to_DEC8.v"
`include "MUX16_4_1.v"
`include "DISPLAY.v"

module main(input clk,      output wire LED0,
            input BTN0,     output wire LED1,
            input BTN1,     output wire LED2, 
            input BTN2,     output wire LED4, 
            input BTN3,     output wire LED5,
            input [7:0] SW, output wire LED6,
                            output wire LED7,
                            output wire seg_P,
                            output wire [6:0] seg,
                            output wire [3:0] AN);

  wire SQ, SAB, Sign, ce1ms;
  wire [15:0] A; wire [15:0] B; wire [15:0] dat;
  wire [31:0] REZULT; wire [31:0] BIN;
  wire [15:0] Adec;   wire [15:0] Bdec; 

  assign LED7 = SW[7];
  assign LED6 = SW[6];
  assign LED5 = SW[5];
  assign LED4 = SW[4];
  assign LED2 = SQ;
  assign LED1 = SAB;
  assign LED0 = Sign;

  assign is_EN_A = ({SW[1], SW[0]} == 2'b00);
  st_4BTN_4CDD A_st_4BTN_4CDD(.BTN0(BTN0), .DEC(Adec),
                              .BTN1(BTN1),
                              .BTN2(BTN2),
                              .BTN3(BTN3),
                              .ce(ce1ms),
                              .clk(clk),
                              .EN(is_EN_A),
                              .UP(SW[3]));


  assign is_EN_B = ({SW[1], SW[0]} == 2'b10);
  st_4BTN_4CDD B_st_4BTN_4CDD(.BTN0(BTN0), .DEC(Bdec),
                              .BTN1(BTN1),
                              .BTN2(BTN2),
                              .BTN3(BTN3),
                              .ce(ce1ms),
                              .clk(clk),
                              .EN(is_EN_B),
                              .UP(SW[2]));

  DEC4_to_BIN16 A_DEC4_to_BIN16(.clk(clk), .BIN(A),
                                .DI(Adec));

  DEC4_to_BIN16 B_DEC4_to_BIN16(.clk(clk), .BIN(B),
                                .DI(Bdec));

  BIN27_to_DEC8 BIN27_to_DEC8(.clk(clk),  .DEC(REZULT), 
                              .st(ce1ms),
                              .BIN(BIN[26:0]));

  DISPLAY DISPLAY(.clk(clk), .seg_P(seg_P),
                  .dat(dat), .AN(AN),
                             .seg(seg),
                             .ce1ms(ce1ms));

  MUX16_4_1 MUX16_4_1(.A(Adec), .E(dat),
                      .B(Bdec), 
                      .C(REZULT[15:0]),
                      .D(REZULT[31:16]),
                      .S(SW[1:0]));

  ALD ALD(.SA(SW[5]), .SQ(SQ),
          .SB(SW[4]), .SAB(SAB),
          .mod_A(A),  .S(Sign),
          .mod_B(B),  .mod_Q(BIN),
          .F(SW[7:6]),
          .ce(ce1ms));

endmodule