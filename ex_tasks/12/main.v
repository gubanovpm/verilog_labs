`include "ACC_ROT.v"
`include "BIN16_to_DEC4.v"
`include "BTN1_BL.v"
`include "DEC4_to_BIN16.v"
`include "DISPLAY.v"
`include "MUX16_2_1.v"
`include "st_4BTN_4CDD.v"

module main(input clk,  output wire seg_P,
            input BTN0, output wire [3:0] AN,
            input BTN1, output wire [6:0] seg,
            input BTN2, 
            input BTN3, 
            input [5:0] SW);

  wire ce1ms, st; wire [15:0] dat;
  wire [15:0] DXre; wire [15:0] DXim;
  wire [15:0] BXre; wire [15:0] BXim;
  wire [15:0] DQre; wire [15:0] DQim;
  wire [15:0]  Qre; wire [15:0]  Qim;
  wire [15:0]   Re; wire [15:0]   Im;

  st_4BTN_4CDD Re_st_4BTN_4CDD(.clk(clk), .DEC(DXre),
                               .BTN0(BTN0),
                               .BTN1(BTN1),
                               .BTN2(BTN2),
                               .BTN3(BTN3),
                               .ce(ce1ms),
                               .EN(SW[1]),
                               .UP(SW[5]));

  DEC4_to_BIN16 Re_DEC4_to_BIN16(.clk(clk), .BIN(BXre),
                                 .DI(DXre));

  st_4BTN_4CDD Im_st_4BTN_4CDD(.clk(clk), .DEC(DXim),
                               .BTN0(BTN0),
                               .BTN1(BTN1),
                               .BTN2(BTN2),
                               .BTN3(BTN3),
                               .ce(ce1ms),
                               .EN(SW[2]),
                               .UP(SW[5]));

  DEC4_to_BIN16 Im_DEC4_to_BIN16(.clk(clk), .BIN(BXim),
                                 .DI(DXim));

  ACC_ROT ACC_ROT(.Xre(BXre), .Qre(Qre),
                  .Xim(BXim), .Qim(Qim),
                  .clk(clk),  
                  .L(SW[3]),
                  .st(st));

  BIN16_to_DEC4 Re_BIN16_to_DEC4(.clk(clk), .DEC(DQre),
                                 .st(ce1ms),
                                 .BIN(Qre));

  BIN16_to_DEC4 Im_BIN16_to_DEC4(.clk(clk), .DEC(DQim),
                                 .st(ce1ms),
                                 .BIN(Qim));

  MUX16_2_1 Re_MUX16_2_1(.s(SW[4]), .C(Re),
                         .A(DQre), 
                         .B(DXre));

  MUX16_2_1 Im_MUX16_2_1(.s(SW[4]), .C(Im),
                         .A(DQim), 
                         .B(DXim));

  MUX16_2_1 D_MUX16_2_1(.s(SW[0]), .C(dat),
                        .A(Im), 
                        .B(Re));

  DISPLAY DISPLAY(.clk(clk), .seg_P(seg_P),
                  .dat(dat), .AN(AN),
                             .seg(seg),
                             .ce1ms(ce1ms));

endmodule