`include "Gen_ce.v"
`include "SPI_DAC8512.v"
`include "AGN_MSHSIN.v"
`include "Mes_AMP_Trf_Tsp.v"
`include "MUX12_2_1.v"
`include "BIN12_to_DEC4.v"
`include "MUX16_2_1.v"
`include "DISPLAY.v"
`include "REG_AMP.v"

module TASK43(input clk,  output wire seg_P,
              input BTN0, output wire [3:0] AN,
              input BTN3, output wire [6:0] seg,
              input SW0,  output wire JA4,
              input SW1,  output wire JA7,
                          output wire JA8,
                          output wire JA9,
                          output wire JA10, 
                          output wire JB1,
                          output wire JB2,
                          output wire JB4,
                          output wire [7:0] LED);

  wire ce1ms, ce100ms, ce1us, ce10us;
  wire end_Tfr, end_Tsp;
  wire [11:0] X;    wire [7:0] M;
  wire [11:0] NTfr; wire [11:0] NTsp;
  wire [11:0] PIC;  wire [11:0] BIN_AMP;
  wire [11:0] C2BIN; wire [15:0] C2dat;
  wire [15:0] DEC_Tfs; wire [15:0] DEC_AMP; 

  REG_AMP REG_AMP(.clk(clk),   .M(M),
                  .BTN1(BTN3),
                  .BTN2(BTN0), 
                  .ce(ce1ms));

  Gen_ce Gen_ce(.clk(clk), .ce1us(ce1us),
                           .ce10us(ce10us));

  SPI_DAC8512 SPI_DAC8512(.st(ce10us), .NCS(JA4),
                          .clk(clk),   .NCLR(JA7),
                          .DI(X),      .NLD(JA8),
                                       .SDAT(JA9),
                                       .SCLK(JA10));

  AGN_MSHSIN AGN(.clk(clk),  .MSH_SIN(X),
                 .ce(ce1us),
                 .M(M));

  Mes_AMP_Trf_Tsp Mes_AMP_Trf_Tsp(.clk(clk),         .Tfr(JB1),
                                  .ce1us(ce1us),     .Tsp(JB2),
                                  .X(X),             .NTfr(NTfr),
                                  .ext_res(ce100ms), .NTsp(NTsp),
                                                     .zX(JB4),
                                                     .AMP(BIN_AMP),
                                                     .PIC(PIC),
                                                     .end_Tfr(end_Tfr),
                                                     .end_Tsp(end_Tsp));

  assign O = SW1 ? end_Tsp : end_Tfr; // M2_1

  MUX12_2_1 MUX12_2_1(.S(SW1), .C(C2BIN),
                      .A(NTfr),
                      .B(BTsp));

  BIN12_to_DEC4 Tfs_BIN12_to_DEC4(.clk(clk),   .DEC(DEC_Tfs),
                                  .BIN(C2BIN), 
                                  .st(O));

  BIN12_to_DEC4 AMP_BIN12_to_DEC4(.clk(clk), .DEC(DEC_AMP),
                                  .BIN(BIN_AMP),
                                  .st(end_Tsp));

  MUX16_2_1 MUX16_2_1(.S(SW0), .C(C2dat),
                      .A(DEC_AMP),
                      .B(DEC_Tfs));

  assign LED = {M}; // OBUF8

  DISPLAY DISPLAY(.clk(clk),   .seg_P(seg_P),
                  .PTR(SW0),   .ce1ms(ce1ms),
                  .dat(C2dat), .ce100ms(ce100ms),
                               .AN(AN),
                               .seg(seg));

endmodule