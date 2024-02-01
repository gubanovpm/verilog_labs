module Gen_st(input clk, output wire ce_st);
  reg [15:0] cb_ms = 0;
  assign ce_st = (cb_ms == `Nrep);

  always  @(posedge clk) begin
    cb_ms <= ce_st ? 0 : cb_ms + 1;
  end
endmodule