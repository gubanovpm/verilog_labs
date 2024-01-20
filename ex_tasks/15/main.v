`include "BIN27_to_DEC8.v"
`include "DEC8_to_BIN27.v"
`include "DISPLAY.v"
`include "MUX16_4_1.v"
`include "st_4BTN_4CDD.v"
`include "TASK15_BL.v"

module main(input clk,       output wire seg_P,
            input [3:0] BTN, output wire [3:0] AN,
            input [4:0] SW,  output wire [6:0] seg);

  wire ce1ms, ok_BIN, ok_SQRT; 
  wire [26:0] BIN; wire [26:0] SQRTbin;
  wire [31:0] Y;   wire [31:0] X; 
  wire [15:0] dat;

  st_4BTN_4CDD H_st_4BTN_4CDD(.BTN(BTN),  .DEC(X[31:16]),
                              .ce(ce1ms),
                              .clk(clk),
                              .EN(SW[2]),
                              .UP(SW[4]));

  st_4BTN_4CDD L_st_4BTN_4CDD(.BTN(BTN),  .DEC(X[15:0]),
                              .ce(ce1ms),
                              .clk(clk),
                              .EN(SW[3]),
                              .UP(SW[4]));

  DEC8_to_BIN27 DEC8_to_BIN27(.clk(clk), .ok(ok_BIN),
                              .DEC(X),   .BIN(BIN),
                              .st(ce1ms));

  TASK15_BL TASK15_BL(.clk(clk), .ok(ok_SQRT),
                      .BIN(BIN), .SQRT(SQRTbin),
                      .st(ok_BIN));

  BIN27_to_DEC8 BIN27_to_DEC8(.clk(clk), .DEC(Y),
                              .st(ok_SQRT),
                              .BIN(SQRTbin));

  MUX16_4_1 MUX16_4_1(.A(X[31:16]), .E(dat),
                      .B(X[15:0]),
                      .C(Y[31:16]),
                      .D(Y[15:0]),
                      .S(SW[1:0]));

  DISPLAY DISPLAY(.clk(clk),    .seg_P(seg_P),
                  .dat(dat),    .ce1ms(ce1ms),
                  .SW(SW[1:0]), .AN(AN),
                                .seg(seg));

endmodule