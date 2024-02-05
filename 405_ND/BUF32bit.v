module BUF32bit(input ce,            output reg [23:0] RX_DAT = 0,
                input [23:0] sr_dat, output reg [ 7:0] RX_ADR = 0,
                input [ 7:0] sr_adr,
                input clk,
                input R);

  always @(posedge clk) begin
    RX_DAT <= R ? 0 : ce ? sr_dat : RX_DAT;
    RX_ADR <= R ? 0 : ce ? sr_adr : RX_ADR;
  end

endmodule