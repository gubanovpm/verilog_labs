module AGN_MSHSIN(           output reg S=1, //Знак
                  input clk, output wire CO_SIN, //Сигнал периода синусоиды
                  input ce, output wire [11:0] MSH_SIN, //Умноженная смещенная синусоида
                  input [7:0]M); //Множитель

  parameter AMP=2000; // Амплитуда
  parameter SH=2000; // Смещение
  parameter NP=100 ; // Число точек
  parameter Xmin=0 ; //Минимальное значение
  parameter Xmax=NP/4 ;// Xmax=NP/4=25,
  
  wire [11:0] SH_SIN ; //Смещенная синусоида
  reg [4:0] X=0 ; // Регистр генератора "пилы"
  reg UP=1 ; //Триггер направления счета
  wire [11:0] Y ; //Таблица синусоиды
  assign CO_SIN = ce & (X==Xmin) & !S ;
  
  always @ (posedge clk) if (ce) begin
    X<= UP? X+1 : X-1 ;
    UP <= (X==Xmin+1)? 1 : (X==Xmax-1)? 0 : UP ;
    S <= ((X==Xmin+1) & !UP)? !S : S ;
  end
  // Модуль памяти с таблицей четверти периода синусоиды
  // Число точек на периоде NP=100 Амплитуда AMP=2000
  ROM_SIN_25_2000 DD1 (.adr(X), .Y(Y));

  assign SH_SIN = S? SH+Y : SH-Y ; //Умножение на 2
  
  wire [19:0]MSHS=SH_SIN*M ; //Умножение на M
  assign MSH_SIN=MSHS>>7 ; //Деление на 128
endmodule

module ROM_SIN_25_2000(input [4:0] adr, output wire [11:0] Y );
  reg [11:0]ROM[25:0] ;
  assign Y = ROM[adr] ; //Слайсовая память

  initial //Инициализация модуля памяти из файла ROM_SIN_25_2000.txt
  $readmemh ("ROM_SIN_25_2000.txt", ROM, 0, 25);
endmodule