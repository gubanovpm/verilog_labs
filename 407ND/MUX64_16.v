`ifndef m
  `define m 16
`endif

module MUX64_16(input [`m-1:0] A, output wire [15:0] DO,
                input [`m-1:0] B,
                input [`m-1:0] C,
                input [`m-1:0] D,
                input [1:0]  S);

  assign DO = (S == 2'b00) ? 16'b0 | A :
              (S == 2'b01) ? 16'b0 | B :
              (S == 2'b10) ? 16'b0 | C :
                             16'b0 | D ;

endmodule