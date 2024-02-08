`define m 18 //Число разрядов результата

module SQRT_BL (input [2*`m-1:0] X, output reg[`m-1:0]Q=0,
                input st, output reg en=0,
                input clk);

  wire [2*`m-1:0]M=Q*Q ;
  wire DI =(M<=X);

  //---Регистр последовательного приближения---
  reg[`m:0] T=0 ; //Регистр сдвига импульсов T
  integer i ; //Индекс цикла for
  always @ (posedge clk) begin
    T <= st? 1<<`m :en? T>>1 : T ; //Сдвиг импульсов T вправо
    Q[`m-1] <= st? 1 : T[`m]? DI : Q[`m-1] ; //Загрузка старшего бита выходного регистра Q
    for (i=`m-2 ; i>= 0; i=i-1) // Цикл for
    Q[i] <= st? 0 : T[i+2]? 1 : T[i+1]? DI : Q[i] ; //Загрузка очередного бита регистра Q
    en<= st? 1 : (T[0] &en)? 0 :en ; //Интервал последовательного приближения
  end

endmodule