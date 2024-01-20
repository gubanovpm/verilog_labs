module st_4BTN_4CDD(input clk, output wire [15:0] DEC,
                    input BTN0,
                    input BTN1,
                    input BTN2,
                    input BTN3, 
                    input ce,
                    input EN, 
                    input UP);

  wire st0, st1, st2, st3;
  assign CEO = ce & EN;

  BTN4_BL BTN4_BL(.BTN0(BTN0), .st0(st0),
                  .BTN1(BTN1), .st1(st1),
                  .BTN2(BTN2), .st2(st2),
                  .BTN3(BTN3), .st3(st3),
                  .clk(clk),
                  .ce(CEO));

  DEC4CD DEC4CD(.clk(clk), .DEC(DEC),
                .UP(UP),
                .st0(st0),
                .st1(st1),
                .st2(st2),
                .st3(st3));

endmodule

module BTN4_BL(input BTN0, output wire st0,
               input BTN1, output wire st1,
               input BTN2, output wire st2,
               input BTN3, output wire st3,
               input clk,
               input ce);

  BTN_WRP btn_0(.BTN(BTN0), .OUT(st0),
                .clk(clk),
                .ce(ce));

  BTN_WRP btn_1(.BTN(BTN1), .OUT(st1),
                .clk(clk),
                .ce(ce));

  BTN_WRP btn_2(.BTN(BTN2), .OUT(st2),
                .clk(clk),
                .ce(ce));

  BTN_WRP btn_3(.BTN(BTN3), .OUT(st3),
                .clk(clk),
                .ce(ce));

endmodule

module BTN_WRP(input BTN, output wire OUT,
               input clk,
               input ce);

  assign OUT = st;
  reg q1 = 0, q2 = 0;
  assign st = q1 & !q2 & ce;
  always @(posedge clk) begin
    q1 <= ce ? BTN : q1; q2 <= ce ? q1 : q2;
  end

endmodule


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