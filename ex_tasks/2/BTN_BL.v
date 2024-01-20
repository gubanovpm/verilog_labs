module BTN_BL(input BTN, output wire EN,
              input ce,  output wire RES,
              input clk);

  reg [1:0] Q = 2'b00;
  reg TEN = 0;

  assign ST  = Q[0] & (~Q[1]);
  assign EN  = TEN;
  assign RES = ~EN;

  always @(posedge ce) begin
    Q[0] <= BTN;
    Q[1] <= Q[0];
  end

  always @(posedge ST) begin
    TEN <= ~TEN;
  end

endmodule