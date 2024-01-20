module DEC4_to_BIN16(input [15:0] DI, output wire [15:0] BIN, 
                     input clk);

  assign st0 = DI[ 3:0]; assign st1 = DI[ 7: 4];
  assign st2 = DI[11:8]; assign st3 = DI[15:12];

  reg [15:0] out;
  assign BIN = out;

  always @(posedge clk) begin
    out <= 1000*st3 + 100*st2 + 10*st1 + st0;
  end

endmodule