`include "DISPLAY.v"
`include "Gen_MFX_Fce50.v"
`include "DEC4_to_BIN16.v"
`include "DEC4CD.v"
`include "Mes_MTXM.v"
`include "BTN4_BL.v"
`include "Gen_ce01us.v"
`include "MUX16_2_1.v"

module main(input clk,  output wire JB1,
            input BTN0, output wire JC1,
            input BTN1, output wire seg_P,
            input BTN2, output wire [3:0] AN,
            input BTN3, output wire [6:0] seg,
            input SW0,  
            input SW1,
            input SW6, 
            input SW7, 
            input JA1);

  wire MFX, ce01us, ce1ms, frontMTX;
  wire st0, st1, st2, st3;
  wire [9:0] cb_MT;

  // wire [15:0] MFX2B; 
  wire [15:0] C2B;   wire [15:0] out_DEC;
  wire [15:0] BIN2X; wire [15:0] C2dat;
  wire [15:0] QTX;   wire [15:0] FTX;

  assign JB1 = MFX;
  assign O = SW7 ? MFX : JA1; //M2_1

  Gen_ce01us Gen_ce01us(.clk(clk), .CO(ce01us));

  Gen_MFX_Fce50 Gen_MFX_Fce50(.clk(clk),  .MFX(MFX),
                              .X(BIN2X));

  DEC4_to_BIN16 DEC4_to_BIN16(.clk(clk),  .BIN(BIN2X),
                              .ce(ce01us),
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

  Mes_MTXM Mes_MTXM(.clk(clk),       .QTX(QTX),
                    .ce01us(ce01us), .FTX(FTX),
                    .MTX(O),         .ceMT(JC1),
                                     .frontMTX(frontMTX),
                                     .cb_MT(cb_MT));

  MUX16_2_1 FMUX16_2_1(.s(SW1), .C(C2B),
                       .A(QTX),
                       .B(FTX));

  MUX16_2_1 SMUX16_2_1(.s(SW0), .C(C2dat),
                       .A(out_DEC),
                       .B(C2B));

  DISPLAY DISPLAY(.clk(clk),   .seg_P(seg_P),
                  .dat(C2dat), .AN(AN),
                               .seg(seg),
                               .ce1ms(ce1ms));

endmodule