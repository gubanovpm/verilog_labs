`include "DISPLAY.v"
`include "Gen_FXM.v"
`include "DEC4_to_BIN16.v"
`include "DEC4CD.v"
`include "Mes_FXM.v"
`include "BTN4_BL.v"
`include "Gen_ce05us.v"
`include "MUX16_2_1.v"

module main(input clk,  output wire JB1,
            input BTN0, output wire JB3,
            input BTN2, output wire seg_P,
            input BTN3, output wire [3:0] AN,
            input SW0,  output wire [6:0] seg,
            input BTN1,
            input SW6, 
            input SW7,
            input JA1);

  wire FXM, ce05us, ce1ms;
  wire st0, st1, st2, st3;
  wire [15:0] BIN2X; wire [15:0] out_DEC; 
  wire [15:0] FXM2B; wire [15:0] C2dat;

  assign JB1 = FXM;
  assign JB3 = FXM;
  assign O = SW7 ? FXM : JA1;

  Gen_ce05us Gen_ce05us(.clk(clk), .CO(ce05us));

  Gen_FXM Gen_FXM(.clk(clk),  .FXM(FXM),
                  .ce(ce1us),
                  .X(BIN2X));

  DEC4_to_BIN16 DEC4_to_BIN16(.clk(clk),  .BIN(BIN2X),
                              .ce(ce1us),
                              .DEC(out_DEC));

  BTN4_BL BTN4_BL(.BTN0(BTN0), .st0(st0),
                  .BTN1(BTN1), .st1(st1),
                  .BTN2(BTN2), .st2(st2),
                  .BTN3(BTN3), .st3(st3),
                  .ce(ce1ms),
                  .clk(clk));

  DEC4CD DEC4CD(.clk(clk), .DEC(out_DEC),
                .UP(SW6),
                .st0(st0),
                .st1(st1),
                .st2(st2),
                .st3(st3));

  Mes_FXM Mes_FXM(.clk(clk), .FXM(FXM2B),
                  .ce(ce1us),
                  .MX(O));

  MUX16_2_1 MUX16_2_1(.s(SW0), .C(C2dat),
                      .A(out_DEC),
                      .B(FXM2B));

  DISPLAY DISPLAY(.clk(clk),   .seg_P(seg_P),
                  .dat(C2dat), .AN(AN),
                               .seg(seg),
                               .ce1ms(ce1ms));

endmodule