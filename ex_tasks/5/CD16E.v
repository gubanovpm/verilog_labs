module CD16E(input clk, output wire [15:0]Q16D,
             input ce);

  wire [3:0] Q1; wire[3:0] Q2;
  wire [3:0] Q3; wire[3:0] Q4;

  assign Q16D = {Q4, Q3, Q2, Q1};
  assign EN = Q16D<16'h9999;
  
  wire ce1 = EN & ce ;
  wire CO1, CO2, CO3, CO4;

  CD4RE DD1 ( .clk(clk), .Q(Q1),
              .ce(ce1), .CO(CO1));
  CD4RE DD2 ( .clk(clk), .Q(Q2),
              .ce(CO1), .CO(CO2));
  CD4RE DD3 ( .clk(clk), .Q(Q3),
              .ce(CO2), .CO(CO3));
  CD4RE DD4 ( .clk(clk), .Q(Q4),
              .ce(CO3), .CO(CO4));

endmodule

module CD4RE(input ce,  output reg [3:0] Q = 0,
             input clk, output wire CO);
	
	assign CO = ce & (Q == 9);
	
  always @(posedge clk) begin
		Q <= ce ? Q+1 : Q;
	end

endmodule