module Mes_MTXM(input clk,    output reg[15:0] QTX=0,  //Целая часть
                input ce01us, output reg[15:0] FTX=0,  //Дробная часть
                input MTX,    output wire ceMT,        //Границы M периодов
                              output reg [9:0]cb_MT=0, //Счетчик периодов
                              output wire frontMTX);   //Фронты MTX

  //MTX Входной периодический сигнал
  parameter M=1000 ;//Множитель периода

  reg tMTX=0, ttMTX=0, tceMT ;

  assign frontMTX = tMTX & !ttMTX ;
  assign ceMT = (cb_MT==M) & frontMTX ;

  wire [15:0] Q4DF, Q4DQ ; //4-х декадные счетчики

  always @ (posedge clk) begin
    tMTX <= MTX ; ttMTX <= tMTX ; tceMT <= ceMT ;
    cb_MT <= ceMT? 1 : frontMTX? cb_MT+1 : cb_MT ;
    QTX <= ceMT? Q4DQ : QTX ;
    FTX <= ceMT? Q4DF : FTX ;
  end

  wire COF, COF1 ;//Сигнал переноса
  //Декадный счетчик дробной части
  VCD4DECRE DD1 (.clk(clk),   .Q4D(Q4DF),
                 .ce(ce01us), .CO(COF),
                 .R(tceMT));
  //Декадный счетчик целой части
  VCD4DECRE DD2 (.clk(clk), .Q4D(Q4DQ),
                 .ce(COF),  .CO(COF1),
                 .R(tceMT));

endmodule

module VCD4DECRE(input clk, output wire [15:0] Q4D,
                 input ce,  output wire CO, 
                 input R);

  wire [3:0] Q1; wire[3:0] Q2;
  wire [3:0] Q3; wire[3:0] Q4;
  assign Q4D = {Q4, Q3, Q2, Q1};
  assign EN = (Q4D < 16'h9999);
  
  wire ce1 = EN & ce ;
  wire CO1, CO2, CO3, CO4;
  assign CO = CO3;

  CD4ED DD1 ( .clk(clk), .Q(Q1),
              .ce(ce1), .CO(CO1), //Сигнал переполнения
              .R(R));
  CD4ED DD2 ( .clk(clk), .Q(Q2),
              .ce(CO1), .CO(CO2), //Сигнал переполнения
              .R(R));
  CD4ED DD3 ( .clk(clk), .Q(Q3),
              .ce(CO2), .CO(CO3), //Сигнал переполнения
              .R(R));
  CD4ED DD4 ( .clk(clk), .Q(Q4),
              .ce(CO3), .CO(CO4), //Сигнал переполнения
              .R(R));

endmodule

module CD4ED(input ce,  output reg [3:0] Q = 0,
             input clk, output wire CO, 
						 input R);
	
	assign CO = ce & (Q == 9);
	
  always @(posedge clk) begin
		Q <= (R | CO) ? 0 : (ce ? Q+1 : Q);
	end

endmodule