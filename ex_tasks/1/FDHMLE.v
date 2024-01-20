// Модуль счетчика минут
module FDMLE(input clk,      output wire [7:0] QM,      //Минуты
             input ce,       output wire CO,            //"Конец" часа
             input [6:0] DI, output reg [3:0]cd_1M=0,   //Счетчик единиц минут
             input L,        output reg [3:0]cb_10M=0); //Счетчик десятков минут

  wire CO10M = (cd_1M==9) & ce ; //"Конец" десятка минут
  
  assign CO = CO10M & (cb_10M==5); //"Конец" часа
  assign QM = {cb_10M,cd_1M}; //Число минут
  
  always @ (posedge clk) begin
    cd_1M  <= L? DI[3:0] : CO10M? 0 : ce? cd_1M+1 : cd_1M ;    // Счет минут
    cb_10M <= L? DI[6:4] : CO? 0 : CO10M? cb_10M+1 : cb_10M ; // Счет часов
  end
endmodule

// Модуль счетчика часов
module FDHLE(input clk,      output [7:0] QH,            //Часы
             input ce,       output CO,                  //"Конец" суток
             input [6:0] DI, output reg [3:0] cd_1H=0,   //Счетчик единиц часов
             input L,        output reg [3:0] cb_10H=0); //Счетчик десятков часов

  wire CO10H = (cd_1H==9) & ce ;//"Конец" суток

  assign CO = ce & (cb_10H==2) & (cd_1H==3);
  assign QH = {cb_10H,cd_1H};

  always @ (posedge clk) begin
    cd_1H  <= L? DI[3:0] : (CO10H | CO)? 0 : ce? cd_1H+1 : cd_1H ;
    cb_10H <= L? DI[6:4] : CO? 0 : CO10H? cb_10H+1 : cb_10H ;
  end
endmodule

// Модуль счетчика минут и часов
module FDHMLE(input clk,      output wire [15:0] QHM, //Часы минуты
              input ce,       output wire [7:0]  QH,  //Часы
              input [6:0] DI, output wire [7:0]  QM,  //Минуты
              input L,                                //”Конец” суток
              input H_M);                             //Управление загрузкой

  wire COmin, COh ;
  wire Lm = L & H_M ; //Загрузка минут
  wire Lh = L & !H_M ; //Загрузка часов

  assign QHM = {QH,QM} ; //Часы минуты
  assign CO = COmin & COh; //”Конец” суток
  //Счетчик минут
  FDMLE DD1 (.clk(clk), .QM(QM),
             .ce(ce),   .CO(COmin),
             .DI(DI),
             .L(Lm));
  //Счетчик часов
  FDHLE DD2 ( .clk(clk), .QH(QH),
              .ce(COmin), .CO(COh),
              .DI(DI),
              .L(Lh));
endmodule