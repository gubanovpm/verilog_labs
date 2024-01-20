module AGN_4PAR(           output wire [11:0] M4PAR, //Умноженный импульс
                input clk, output reg [10:0] X=0, //Генератор "пилы"
                input ce,  output reg [10:0] P4PAR=0, //Импульс
                input [7:0]M);//Множитель

  parameter NP=100 ; //Число точек на периоде
  parameter MA= 1638 ; //MA=256*4000/((NP^2)/16)=1638
  //reg [10:0] P4PAR=0 ; //Импульс
  reg [7:0]cb_NP=0 ; //Счетчик точек
  wire CO_4PAR ; //Сигнал периода
  reg UP=1 ; //Направление счета
  //---M4PAR=(P4PAR*MA)/128
  wire [23:0] Y = (P4PAR*MA);//Умножение P4PAR на MA
  wire [26:0]MY = Y*M ; //Умножение Y на M
  
  assign M4PAR = MY>>15 ; //Деление на 2^15=32768
  assign CO_4PAR = (cb_NP==NP-1) ;
  
  always @ (posedge clk) if (ce) begin
    cb_NP <= CO_4PAR? 0 : cb_NP+1 ;
    UP <= CO_4PAR? 1 : (cb_NP==NP/4-1)? 0 : (cb_NP==(3*NP)/4-1)? 1 : UP ;
    X <= CO_4PAR? 0: UP? X+1 : X-1 ;
    P4PAR <= CO_4PAR? 0 : X+P4PAR ;
  end

endmodule