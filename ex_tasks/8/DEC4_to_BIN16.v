module DEC4_to_BIN16(input [15:0] DEC, output wire [15:0] BIN,
                     input ce, 
                     input clk);

  assign st0 = DEC[ 3:0]; assign st1 = DEC[ 7: 4];
  assign st2 = DEC[11:8]; assign st3 = DEC[15:12];

  reg [15:0] out;
  assign BIN = out;

  always @(posedge clk) if (ce) begin
    out <= 1000*st3 + 100*st2 + 10*st1 + st0;
  end

endmodule