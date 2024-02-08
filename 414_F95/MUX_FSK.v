module MUX_FSK(input [11:0] A, output wire[11:0] O,
               input [11:0] B,
               input S);

  assign O = S? A : B ;

endmodule