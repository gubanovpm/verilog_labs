module DEC4CD(input clk, output wire [15:0] DEC,
              input UP,
              input st0,
              input st1,
              input st2,
              input st3);

  assign DEC = {Q0, Q1, Q2, Q3};
  wire [3:0] Q0; wire [3:0] Q1; 
  wire [3:0] Q2; wire [3:0] Q3; 

  CD4CD CD4CD_0(.clk(clk), .Q(Q0),
                .ce(st0),
                .UP(UP));

  CD4CD CD4CD_1(.clk(clk), .Q(Q1),
                .ce(st1),
                .UP(UP));

  CD4CD CD4CD_2(.clk(clk), .Q(Q2),
                .ce(st2),
                .UP(UP));

  CD4CD CD4CD_3(.clk(clk), .Q(Q3),
                .ce(st3),
                .UP(UP));

endmodule

module CD4CD(input clk, output reg [3:0] Q = 0,
             input ce,
             input UP);

  assign CO = ce & (Q == 9);
	
  always @(posedge clk) begin
		Q <= (UP & ce) ? Q+1 : (!UP & ce ? Q-1 : Q);
	end

endmodule