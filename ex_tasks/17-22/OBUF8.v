module OBUF8(input [7:0] M, output wire [7:0] LED); assign LED = {M}; endmodule