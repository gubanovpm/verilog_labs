module TASK16_BL(input [26:0] BIN, output wire ok,
                 input clk, output wire [26:0] SQRT, 
                 input st);

  parameter M = 50'h38D7EA4C68000;

  wire [80:0] MxBIN = BIN*M;
  CUBRT_BL CUBRT_BL(.X(MxBIN), .Q(SQRT),
                    .st(st),  .ok_CUBRT(ok),
                    .clk(clk));

endmodule

`define m 27 //Число разрядов результата
module CUBRT_BL(input [`m*3-1:0] X, output reg [`m-1:0] Q=0,
                input clk, output wire ok_CUBRT,
                input st);

  reg en_CUBRT=0 ; //Интервал последовательного приближения.
  wire [3*`m-1:0] M=Q*Q*Q ; //Возведение в куб очередной "пробы"
  wire DI = (M<=X);//Сравнение "пробы" с X
  //---Регистр последовательного приближения---
  reg[`m:0] T=0 ; //Регистр сдвига импульсов T
  assign ok_CUBRT = T[0] ; //Конец цикла последовательного приближения
  integer i ; //Индекс цикла for (Фу, у Вас integer в коде)
  
  always @ (posedge clk) begin
    T <= st? 1<<`m : en_CUBRT? T>>1 : T ; //Сдвиг импульсов T вправо
    Q[`m-1] <= st? 1 : T[`m]? DI : Q[`m-1] ; //Загрузка старшего бита выходного регистра Q
    for (i=`m-2 ; i>=0; i=i-1) // Цикл for
    Q[i] <= st? 0 : T[i+2]? 1 : T[i+1]? DI : Q[i] ;//Загрузка очередного бита регистра Q
    en_CUBRT<= st? 1 : T[0]? 0 : en_CUBRT ; //Интервал последовательного приближения
  end

endmodule