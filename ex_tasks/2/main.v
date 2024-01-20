`include "Gen_ce10ms.v"
`include "CD8RE.v"
`include "DISPLAY.v"
`include "BTN_BL.v"

module main(input clk,  output wire [3:0] AN,
            input BTN0, output wire [6:0] seg,
                        output wire seg_P);

  wire ce10ms;
  wire ce1ms;
  wire RESET;
  wire CEO;
  wire EN;

  wire COSec;
  wire CO8;

  wire [15:0] TIME;

  wire [3:0] cd_DL8;
  wire [3:0] cd_DH8;

  wire [3:0] cd_DLSec;
  wire [3:0] cd_DHSec;

  Gen_ce10ms DD1(.clk(clk),  .CO(ce10ms),
                 .ce(ce1ms), .CEO(CEO),
                 .R(RESET),
                 .EN(EN));

  BTN_BL DD2(.BTN(BTN0), .EN(EN),
             .ce(ce1ms), .RES(RESET),
             .clk(clk));

  DISPLAY DD3(.clk(clk),  .seg_P(seg_P),
              .dat(TIME), .ce1ms(ce1ms),
                          .AN(AN),
                          .seg(seg));

  CD8RE DD4(.ce(ce10ms), .CO(CO8),
            .clk(clk),   .DHL(TIME[7:0]),
            .R(RESET),   .cd_DL(cd_DL8),
                         .cd_DH(cd_DH8));

  CD8RE DD5(.clk(clk), .CO(COSec),
            .ce(CO8),  .DHL(TIME[15:8]),
            .R(RESET), .cd_DL(cd_DLSec),
                       .cd_DH(cd_DHSec));

endmodule