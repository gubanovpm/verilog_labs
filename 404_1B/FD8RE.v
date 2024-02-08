module FD8RE(input [7:0] D, output reg [7:0] Q = 0,
             input CE, 
             input C,
             input R);

  always @(posedge C) begin
    Q <= R ? 0 : CE ? D : Q;
  end

endmodule