module COMP_16bit(input [15:0] A, output wire EQ,
                  input [15:0] B, output wire MO);

  assign EQ = (A == B);
  assign MO = (B >= A);

endmodule