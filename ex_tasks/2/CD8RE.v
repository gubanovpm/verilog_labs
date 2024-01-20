`include "VCD4RE.v"

module CD8RE(input ce,  output wire CO,
             input clk, output wire [7:0] DHL,
             input R,   output wire [3:0] cd_DL,
                        output wire [3:0] cd_DH);

  wire TC1,   TC2;
  wire CEO1, CEO2;

  assign DHL = { cd_DH, cd_DL }; 
  assign CO = CEO2 & TC2;

  VCD4RE C1(.ce(ce),   .Q(cd_DL),
            .clk(clk), .TC(TC1),
            .clr(R),   .CEO(CEO1));

  VCD4RE C2(.ce(CEO1),  .Q(cd_DH),
            .clk(clk),  .TC(TC2),
            .clr(R),    .CEO(CEO2));

endmodule
