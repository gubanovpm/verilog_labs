`include "CONST.v"
`include "MULT18x12.v"
`include "ROM_18x100_Wim.v"
`include "ROM_18x100_Wre.v"
`include "SQRT_BL.v"

module DFTn (input[11:0]X, output wire [10:0]modY, //Амплитуда гармоники
             input ce,     output wire [17:0]Wre, //Реальная часть поворотного множителя
             input clk,    output wire [17:0]Wim, //Мнимая часть поворотного множителя
             input st,     output wire [11:0]WXre, //Реальная часть произведения X(k) на W(k)
             input ce_bit, output wire [11:0]WXim, //Мнимая часть произведения X(k) на W(k)
             input [6:0]n, output reg [18:0]Yre=0, //Аккумулятор реальных частей произведений
                           output reg [18:0]Yim=0, //Аккумулятор мнимых частей произведений
                           output wire [35:0]SQreim, //Сумма квадратов Yre и Yim
                           output wire [6:0]k, //Адрес поворотного множителя k=|k*n|modNP
                           output reg [7:0]ACC=0); //Аккумулятор адреса поворотных множителей

  assign k =(ACC>=`NP)? ACC-`NP : ACC[6:0] ; //k=ACC по модулю NP
  //--Умножение на поворотный множитель Wre=cos(2*pi*n*k/N)
  MULT18x12 DD1 (.X(X), .WX(WXre),
                 .W(Wre),
                 .clk(clk));
  //--Умножение на поворотный множитель Wim=sin(2*pi*n*k/N)
  MULT18x12 DD2 (.X(X), .WX(WXim),
                 .W(Wim),
                 .clk(clk));
  //--Таблица реальной части Wre поворотных множителей
  ROM_18x100_Wre DD3 (.k(k), .Wre(Wre));
  //--Таблица мнимой части Wim поворотных множителей
  ROM_18x100_Wim DD4 (.k(k), .Wim(Wim));

  reg st_SQRT=0 ; //Старт извлечения корня
  reg tce_bit=0 , tst=0;
  reg [18:0] bfYre=0 ; reg [18:0] bfYim=0 ; // Суммы Yre и Yim в конце Tbit
  wire CO = (ACC>=`NP) & ce ; //Сигнал переполнеия аккумулятора
  always @ (posedge clk) begin
    tce_bit <= ce_bit ; tst <= st ; //Задежка на Tclk=20ns=1/50Mhz
    ACC <= (ce_bit)? 0 : CO? (ACC+n)-`NP : ce? ACC+n : ACC;
    Yre <= (tst | tce_bit)? {{7{WXre[11]}},WXre} : ce? Yre+{{7{WXre[11]}},WXre} : Yre ;
    Yim <= (tst | tce_bit)? {{7{WXim[11]}},WXim} : ce? Yim+{{7{WXim[11]}},WXim} : Yim ;
    bfYre <= ce_bit? Yre : bfYre ;
    bfYim <= ce_bit? Yim : bfYim ;
    st_SQRT <= tce_bit ;
  end

  wire S_Yre=bfYre[18] ; wire S_Yim=bfYim[18] ; //Знаки сумм
  wire [17:0]modYre = S_Yre? -bfYre : bfYre ; //Модуль суммы bfYre
  wire [17:0]modYim = S_Yim? -bfYim : bfYim ; //Модуль суммы bfYim
  wire [35:0]SQre = modYre[17:0]*modYre[17:0] ; //Квадрат модуля суммы bfYre
  wire [35:0]SQim = modYim[17:0]*modYim[17:0] ; //Квадрат модуля суммы bfYim

  assign SQreim = SQre+SQim ; //Сумма квадратов сумм Yre и Yim
  wire [17:0]SQRT ;
  assign modY = (SQRT*1310)>>16 ; //Деление на 50, а не на 100
  //--Модуль извлечения квадратного корня
  SQRT_BL DD5 (.X(SQreim), .Q(SQRT),
               .st(st_SQRT),
               .clk(clk));

endmodule