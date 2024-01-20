module MUX12_2_1 (input [11:0] D0, output wire [11:0] Q,
                  input [11:0] D1,
                  input S);

	assign Q = (S ? D1 : D0);

endmodule
