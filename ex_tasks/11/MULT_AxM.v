module MULT_AxM(input clk, output reg [26:0] AxM,
                input [15:0] A);

  parameter M = 10000;

  always @(posedge clk) begin
    AxM <= A * M;
  end

endmodule