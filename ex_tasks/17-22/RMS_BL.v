module RMS_BL(input [11:0] X, output wire UP,
              input clk,      output wire ce,
              input ce10ms,   output wire Tmes,
              input SW,       output wire ok_SQRT,
                              output reg [11:0] PIC,
                              output reg [11:0] RMS);

  parameter Fclk  = 50000000;
  parameter F1MHz =  1000000;
  parameter NP = 100 ; // Число точек

  reg [11:0] AMP;
  reg [5:0] cb_1us   = 0;
  reg [7:0] cb_tact  = 0;
  wire ce1us  = (cb_1us  == Fclk/F1MHz) ;
  wire ce01ms = (cb_tact == NP * (Fclk/F1MHz));
  assign ce = ce1us;

  reg [6:0] cb_DEL   = 0;
  reg [23:0] SUM_AMP = 0;

  SQRT_BL SQRT_BL(.X(SUM_AMP), .Q(RMS),
                  .st(ce10ms), .ok_SQRT(ok_SQRT),
                  .clk(clk));

  always @(posedge clk) begin
    cb_1us  <= ce1us  ? 1 : cb_1us +1 ;
    cb_tact <= ce01ms ? 1 : cb_tact+1 ;
    PIC <= ce01ms ? AMP : PIC ;
    AMP <= ce01ms ?  0  : (ce1us & (X >= AMP))? X : AMP ;
    SUM_AMP <= ce10ms ? 0 : ce01ms ? SUM_AMP + PIC*PIC/NP : SUM_AMP;
  end

endmodule

`define m 12 //Число разрядов результата
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