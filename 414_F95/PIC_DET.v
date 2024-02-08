module PIC_DET(input [10:0] A, output reg [10:0] PIC,
               input ce,
               input clk,
               input st);

  always @(posedge clk) begin
    PIC <= st? 0 : (ce & (A>PIC))? A : PIC ;
  end

endmodule