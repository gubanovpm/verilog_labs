module MUX16_4_1(input [15:0] A, output wire [15:0] E,
                 input [15:0] B,
                 input [15:0] C,
                 input [15:0] D,
                 input [ 1:0] S);

  assign E = (S == 0)? A :
				     (S == 1)? B :
				     (S == 2)? C : 
                       D ;

endmodule