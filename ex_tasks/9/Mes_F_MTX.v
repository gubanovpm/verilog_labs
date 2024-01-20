module Mes_F_MTX(input clk,    output ce_end, //Конец интервала измерения
                 input ce01us, output [39:0] MX,//X*10^9
                 input ce1ms,  output reg [17:0] cb_Y=0,//Счетчик длительности синхр. интервала
                 input MTX,    output wire Tm, //Не синхронный интервал измерения
                               output wire Tmes); //Синхронный с MTX интервал измерения

  reg[3:0]cb_ce =1;
  reg [3:0]cb_Tm=0; // Счетчик периода измерения
  assign Tm =(cb_Tm==15) ; //Длительность 10ms, период 160ms
  
  reg Tmx=0 ; //Длительность X*Tx, средний период 160ms
  wire CO10ms=(cb_ce==10) & ce1ms; //Границы Tm
  reg tTmx=0, ttTmx=0, tttTmx=0 ;
  reg tMTX=0, ttMTX=0 ;
  wire front_MTX = tMTX & !ttMTX ;
  
  assign ce_start = tTmx & !ttTmx ; //Начало интервала измерения
  assign ce_end =!ttTmx & tttTmx; //Конец интервала измерения
  assign Tmes = ttTmx ;
  
  reg [9:0] cb_X=0 ;//Счетчик периодов меандра на синхронном интервале Tmes
  assign MX = cb_X*30'h3B9ACA00 ; //X*10^9

  always @ (posedge clk) begin
    cb_Tm <= CO10ms? cb_Tm+1 : cb_Tm ;
    cb_ce <= CO10ms? 1 : ce1ms? cb_ce+1 : cb_ce ; //Границы Tm
    tTmx <= Tmx ; ttTmx <= tTmx ; tttTmx <= ttTmx ; //Для фронтов и спадов
    tMTX <= MTX ; ttMTX <= tMTX ; //Для фронта входного сигнала
    cb_X <= ce_start? 0 : (Tmes & front_MTX)? cb_X+1 : cb_X ;
    cb_Y <= ce_start? 0 : (Tmes & ce01us)? cb_Y+1 : cb_Y ;
    Tmx <= front_MTX? Tm : Tmx; //Синхронный интервал измерения
  end

endmodule