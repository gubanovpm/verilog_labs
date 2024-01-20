`include "DISPLAY.v"
`include "VCDDMSLE.v"
`include "Gen_ce1s.v"
`include "RS_trigger.v"

module main(input clk,  output wire seg_P,
            input BTN0, output wire LED0,
            input BTN2, output wire [3:0] AN,
            input BTN3, output wire [6:0] seg,
            input [7:0] SW);

  wire ce1s, ce1ms, ce_end;
  wire TIME, RESET, CEO;
  wire [15:0] dat_displ;
  wire [3:0] cd_1MS_sec; wire [3:0] cb_10MS_sec;
  wire [3:0] cd_1MS_min; wire [3:0] cb_10MS_min;

  assign Lsec = BTN0 & ~BTN2;
  assign Lmin = BTN0 & BTN2;
  assign ce   = TIME & ce1s;

  RS_trigger RS_trigger(.r(BTN3),   .q(RESET),
                        .s(ce_end), .q_n(TIME));

  Gen_ce1s Gen_ce1s(.clk(clk),  .CO(ce1s),
                    .ce(ce1ms),
                    .R(RESET),
                    .Tmod(SW[7]));

  DISPLAY DISPLAY(.clk(clk),       .seg_P(seg_P),
                  .dat(dat_displ), .ce1ms(ce1ms),
                                   .AN(AN),
                                   .seg(seg));

  VCDDMSLE VCDDMSLE_sec(.clk(clk),    .CO(CEO),
                        .ce(ce),      .QMS(dat_displ[7:0]),
                        .L(Lsec),     .cd_1MS(cd_1MS_sec),
                        .DI(SW[6:0]), .cb_10MS(cb_10MS_sec));

  VCDDMSLE VCDDMSLE_min(.clk(clk),    .CO(ce_end),
                        .ce(CEO),     .QMS(dat_displ[15:8]),
                        .L(Lmin),     .cd_1MS(cd_1MS_min),
                        .DI(SW[6:0]), .cb_10MS(cb_10MS_min));

endmodule