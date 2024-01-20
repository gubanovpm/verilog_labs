`include "RS_Trigger.v"
`include "CD16E.v"
`include "Gen_ce1us.v"
`include "COMP_16bit.v"
`include "CD10kD.v"
`include "DISPLAY.v"

module main(input clk,  output wire seg_P,
            input BTN0, output wire [6:0] seg,
            input BTN3, output wire [3:0] AN,
                        output wire LED0,
                        output wire LED7);

  wire UP, ce1ms, EQ, ce1us;
  wire [15:0] REF; wire [15:0] SAW;

  assign CE   = ce1ms & (BTN0 | BTN3);
  assign LED7 = UP;

  RS_Trigger RS_Trigger(.r(BTN0), .q(UP),
                        .s(BTN3));

  CD10kD CD10kD(.clk(clk), .Q4D(REF),
                .ce(CE),
                .UP(UP));

  DISPLAY DISPLAY(.clk(clk), .seg_P(seg_P),
                  .dat(REF), .ce1ms(ce1ms),
                             .AN(AN),
                             .seg(seg));

  COMP_16bit COMP_16bit(.A(REF), .EQ(EQ),
                        .B(SAW), .MO(LED0));

  CD16E CD16E(.clk(clk),  .Q16D(SAW),
              .ce(ce1us));

  Gen_ce1us Gen_ce1us(.clk(clk), .CO(ce1us));

endmodule