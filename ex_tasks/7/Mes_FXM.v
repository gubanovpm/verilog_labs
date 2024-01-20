module Mes_FXM(input clk, output reg [15:0] FXM = 0,
               input ce, 
               input MX);

  reg [1:0] tMx = 0;
  assign frontMX = tMx[0] & (~tMx[1]);

  always @(posedge clk) begin
    tMx[0] <= MX;
    tMx[1] <= tMx[0];
  end

  reg [15:0] Q = 0;
  always @(posedge frontMX) begin
    Q <= ce ? 0 : Q + 1;
  end

  always @(posedge ce) begin
    FXM <= Q;
  end

endmodule