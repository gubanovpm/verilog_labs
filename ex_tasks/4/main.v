`include "Gen_ce_TASK4.v"
`include "VCDDYLE.v"
`include "DISPLAY.v"

module main(input clk,  output wire seg_P,
            input BTN0, output wire [3:0] AN,
            input BTN2, output wire [6:0] seg,
            input BTN3, 
            input [7:0] SW);

  wire ce1ms, COM, COY, CO;
  wire [15:0] displ_dat;

  DISPLAY DISPLAY(.clk(clk),       .seg_P(seg_P),
                  .dat(displ_dat), .ce1ms(ce1ms),
                                   .AN(AN),
                                   .seg(seg));

  VCDDYLE VCDDYLE(.clk(clk),  .COM(COM),
                  .ce(CO),    .COY(COY),
                  .L(BTN0),   .DM(displ_dat[7:0]),
                  .M_D(BTN2), .M(displ_dat[15:8]),
                  .DI(SW[5:0]),
                  .VY(BTN3));

  Gen_ce_TASK4 Gen_ce_TASK4(.clk(clk),  .CO(CO),
                            .ce(ce1ms),
                            .Tmod(SW[6]),
                            .R(SW[7]));

endmodule