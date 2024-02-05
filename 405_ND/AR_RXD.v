module AR_RXD(input clk,  output wire ce_wr,
              input inp0, output reg [23:0] sr_dat,
              input inp1, output reg [ 7:0] sr_adr);

  reg [5:0] cb = 0;
  assign ce_wr = (cb == 32);
  reg [31:0] tmp = 0;

  always @(posedge clk) begin
    tmp <= ce_wr ? 32'b0 : tmp | (inp1 << (32 - cb));
  end

  always @(posedge inp0 or posedge inp1) begin
    cb  <= ce_wr ? 1 : (inp0 | inp1) ? cb + 1 : cb;
  end

  always @(posedge ce_wr) begin
    sr_dat <= tmp[23:0];
    sr_adr <= tmp[31:24];
  end

endmodule