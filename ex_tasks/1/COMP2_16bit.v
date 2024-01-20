module COMP2_16bit(input [15:0] A, output wire EQ,
                   input [15:0] B, 
                   input Q);

  assign EQ = (A == B) & Q;

endmodule