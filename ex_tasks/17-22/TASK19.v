`define __NTASK__ 19;

`include "AGN_4PAR.v"
`include "BIN12_to_DEC4.v"
`include "DISPLAY.v"
`include "GEN_MCONST.v"
`include "MUX12_2_1.v"
`include "OBUF8.v"
`include "REG_AMP.v"
`include "RMS_BL.v"
`include "SPI_DAC8512.v"

module TASK19(input clk,       output wire seg_P,
              input BTN0,      output wire [3:0] AN,
              input BTN3,      output wire [6:0] seg,
              input SW0,       output wire JA4,
              input SW1,       output wire JA7,
              input [7:0] LED, output wire JA8,
                               output wire JA9,
                               output wire JA10,
                               output wire JB1,
                               output wire JB2);

  wire ce1us, ce1ms, ce10ms, ok_SQRT;
  wire [11:0] Sign;  wire [ 7:0] M;
  wire [11:0] Const; wire [11:0] X;
  wire [11:0] AMP ;  wire [11:0] RMS;
  wire [11:0] BIN;   wire [15:0] DEC;

  REG_AMP REG_AMP(.clk(clk), .M(M),
                  .BTN3(BTN3), 
                  .BTN2(BTN0),
                  .ce(ce1ms));

  AGN_4PAR AGN(.clk(clk),  .M4PAR(Sign),
               .ce(ce1us),
               .M(M));

  OBUF8 OBUF8(.M(M), .LED(LED));

  GEN_MCONST GEN_MCONST(.M(M), .CONST(Const));

  MUX12_2_1 SC_MUX12_2_1(.D0(Sign), .Q(X),
                         .D1(Const), 
                         .S(SW1));

  SPI_DAC8512 SPI_DAC8512(.st(ce1us), .NCS(JA4),
                          .clk(clk),  .NCLR(JA7),
                          .DI(X),     .NLD(JA8),
                                      .SDAT(JA9),
                                      .SCLK(JA10));

  RMS_BL RMS_BL(.X(X),           .UP(JB1),
                .clk(clk),       .ce(ce1us),
                .ce10ms(ce10ms), .Tmes(JB2),
                .SW(SW1),        .ok_SQRT(ok_SQRT),
                                 .PIC(AMP),
                                 .RMS(RMS));

  MUX12_2_1 RA_MUX12_2_1(.D0(RMS), .Q(BIN),
                         .D1(AMP), 
                         .S(SW0));

  BIN12_to_DEC4 BIN12_to_DEC4(.BIN(BIN), .DEC(DEC),
                              .clk(clk),
                              .st(ok_SQRT));

  DISPLAY DISPLAY(.clk(clk), .seg_P(seg_P),
                  .dat(DEC), .ce1ms(ce1ms),
                             .ce10ms(ce10ms),
                             .AN(AN),
                             .seg(seg));

endmodule