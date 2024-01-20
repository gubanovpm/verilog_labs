module TASK15_BL(input [26:0] BIN, output wire ok,
                 input clk, output wire [26:0] SQRT, 
                 input st);

  parameter M = 100000000000000;

  wire [53:0] MBIN = BIN * M;
  SQRT_BL SQRT_BL(.X(MBIN), .Q(SQRT),
                  .st(st),  .ok_SQRT(ok),
                  .clk(clk));

endmodule

`define m 27 //Число разрядов результата
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