module MUX16_2_1 (input [15:0] A, output wire [15:0] C,
                  input [15:0] B,
                  input S);

	assign C = (S ? B : A);

endmodule
