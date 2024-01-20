module MODUL_BL(input [13:0] A, output wire ok,
                input [13:0] B, output wire [23:0] Q_mod,
                input clk, 
                input st);

  parameter M = 1000000;

  wire [27:0] SQ_A = A * A;
  wire [27:0] SQ_B = B * B;
  wire [28:0] SUM_SQAB = SQ_A + SQ_B;
  wire [47:0] M_SUM_SQAB = SUM_SQAB * M;

  SQRT_BL SQRT_BL(.X(M_SUM_SQAB), .Q(Q_mod),
                  .st(st),        .ok_SQRT(ok),
                  .clk(clk));

endmodule

`define m 24 //Число разрядов результата
module SQRT_BL (input [`m*2-1:0] X, output reg [`m-1:0]Q=0, //Регистр результата
                input st,           output wire ok_SQRT,    //Конец вычисления корня
                input clk);

  reg en_SQRT=0 ; //Интервал последовательного приближения.
  wire [2*`m-1:0] M=Q*Q ; //Возведение в квадрат очередной “пробы”
  wire DI = (M<=X);//Сравнение “пробы” с X

  //---Регистр последовательного приближения---
  reg[`m:0] T=0 ; //Регистр сдвига импульсов T
  assign ok_SQRT = T[0] ; //Конец цикла последовательного приближения
  integer i ; //Индекс цикла for (АСУЖДАЮ!!!1!!)
  
  always @ (posedge clk) begin
    T <= st? 1<<`m : en_SQRT? T>>1 : T ; //Сдвиг импульсов T вправо
    Q[`m-1] <= st? 1 : T[`m]? DI : Q[`m-1] ; //Загрузка старшего бита выходного регистра Q
    for (i=`m-2 ; i>=0; i=i-1) // Цикл for
      Q[i] <= st? 0 : T[i+2]? 1 : T[i+1]? DI : Q[i] ;//Загрузка очередного бита регистра Q
    en_SQRT<= st? 1 : T[0]? 0 : en_SQRT ; //Интервал последовательного приближения
  end
endmodule