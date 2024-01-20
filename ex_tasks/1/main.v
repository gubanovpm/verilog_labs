`include "DISPLAY.v"
`include "MUX16_2_1.v"
`include "GEN_ce1min.v"
`include "COMP2_16bit.v"
`include "VCDHMLE.v"
`include "FDHMLE.v"

module main(input clk,      output wire LED0, 
            input BTN0,     output wire seg_P,
            input BTN2,     output wire [3:0] AN,
            input BTN3,     output wire [6:0] seg,
            input [7:0] SW);

  wire CO_1s_1M;
  wire ce1ms;
  wire VCO;
  wire Q;
  wire [15:0] disp_dat;
  wire [15:0] VQMH;
  wire [15:0] FQMH;
  wire [7:0] VQH;
  wire [7:0] VQM;
  wire [7:0] FQH;
  wire [7:0] FQM;

  assign L_TIME  = BTN0 & !SW[7];
  assign L_ALARM = BTN0 &  SW[7]; 

  DISPLAY DD1( .clk(clk),      .seg_P(seg_P),
               .dat(disp_dat), .ce1ms(ce1ms),
                               .AN(AN),
                               .seg(seg));

  GEN_ce1min DD2( .clk(clk),     .CO(CO_1s_1M),
                  .ce1ms(ce1ms), .Q(Q),
                  .Tmod(BTN3));

  MUX16_2_1 DD3( .S(SW[7]), .C(disp_dat),
                 .A(VQMH),
                 .B(FQMH));

  COMP2_16bit DD4( .A(VQMH), .EQ(LED0),
                   .B(FQMH), 
                   .Q(Q));
  
  VCDHMLE DD5( .clk(clk),     .CO(VCO),
               .ce(CO_1s_1M), .QHM(VQMH),
               .L(L_TIME),    .QH(VQH),
               .H_M(BTN2),    .QM(VQM),
               .DI(SW[6:0]));

  FDHMLE DD6( .clk(clk),   .QHM(FQMH),
              .L(L_ALARM), .QH(FQH),
              .ce(ce1ms),  .QM(FQM),
              .H_M(BTN2),
              .DI(SW[6:0]));

endmodule