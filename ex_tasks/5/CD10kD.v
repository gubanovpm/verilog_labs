module CD10kD(input clk, output wire [15:0]Q4D,
              input ce,  output wire EN,
              input UP);

  wire [3:0] Q1; wire[3:0] Q2;
  wire [3:0] Q3; wire[3:0] Q4;
  assign Q4D = {Q4, Q3, Q2, Q1};
  assign EN = UP ? (Q4D<16'h9999) : (Q4D>16'h0000);
  
  wire ce1 = EN & ce ;
  wire CO1, CO2, CO3, CO4;

  CD4ED DD1 ( .clk(clk), .Q(Q1),
              .ce(ce1), .CO(CO1), //Сигнал переполнения
              .UP(UP));
  CD4ED DD2 ( .clk(clk), .Q(Q2),
              .ce(CO1), .CO(CO2), //Сигнал переполнения
              .UP(UP));
  CD4ED DD3 ( .clk(clk), .Q(Q3),
              .ce(CO2), .CO(CO3), //Сигнал переполнения
              .UP(UP));
  CD4ED DD4 ( .clk(clk), .Q(Q4),
              .ce(CO3), .CO(CO4), //Сигнал переполнения
              .UP(UP));

endmodule

module CD4ED(input ce,  output reg [3:0] Q = 0,
             input clk, output wire CO, 
						 input UP);
	
	assign CO = ce & (Q == 9);
	
  always @(posedge clk) begin
		Q <= (UP & ce) ? Q+1 : (!UP & ce ? Q-1 : Q);
	end

endmodule