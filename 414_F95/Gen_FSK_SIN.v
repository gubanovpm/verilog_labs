`include "CONST.v"

module Gen_FSK_SIN (output reg S=1, //S=1 sin>0, знак SIN
         input clk, output wire[11:0]SIN, //SIN = S? Y : -Y
           input D, output wire ce_SIN, //Период SIN, Tce_SIN=NP*Tce_sd
    input[7:0]Mamp, output wire ce_sd); //Сигнал дискретизации SIN

  // D - бит управления частотой FSK (D=0 Fsin=2200Hz, D=1 Fsin=1200Hz)
  // Mamp[7:0] - Регулятор амплитуды SIN, AMPsin=NA*Mamp/128 (NA=2000)
  parameter Macc = 50000 ; //Емкость аккумулятора
  parameter Xmin=0 ; //Минимальное значение "пилы"
  parameter Xmax=`NP/4 ; //Xmax=`NP/4=250,

  wire [10:0] Y ; //Модуль SIN
  reg [7:0] X=0 ; //Регистр "пилы"
  reg up=1 ; //Триггер направления счета

  assign ce_SIN = (X==Xmin) & !S ; //Период SIN, Tce_SIN=NP*Tce_sd
  wire [19:0]MY=Y*Mamp ; //Умножение на Mamp
  wire[10:0] AY = MY >> 7 ; //Деление на 128
  //--Синтезатор частоты дискретизации SIN
  reg [15:0]ACC=0 ; //Аккумулятор синтезатора частоты
  wire [15:0]Xf= D? `F1ce : `F0ce ; //Накапливаемое число Xf=120 или Xf=220
  assign ce_sd = (ACC+Xf>=Macc) ; /*Сигнал переполнения аккумулятора или
  сигнал дискретизации SIN. Частота Fce_sd=100*Fsin=Xf*50MHz/Macc */
  always @ (posedge clk) begin
    ACC <= ce_sd? (ACC+Xf)-Macc : (ACC+Xf) ; //
  end
  //--Таблица значений четверти периода синусоиды
  //Y=NA*sin(2*pi*X/NP), NA=2000-амплитуда, NP=100 - число точек
  assign Y = (X==0)  ? 0    :
             (X==1)  ? 126  :
             (X==2)  ? 251  :
             (X==3)  ? 375  :
             (X==4)  ? 497  :
             (X==5)  ? 618  :
             (X==6)  ? 736  :
             (X==7)  ? 852  :
             (X==8)  ? 964  :
             (X==9)  ? 1072 :
             (X==10) ? 1176 :
             (X==11) ? 1275 :
             (X==12) ? 1369 :
             (X==13) ? 1458 :
             (X==14) ? 1541 :
             (X==15) ? 1618 :
             (X==16) ? 1689 :
             (X==17) ? 1753 :
             (X==18) ? 1810 :
             (X==19) ? 1860 :
             (X==20) ? 1902 :
             (X==21) ? 1937 :
             (X==22) ? 1965 :
             (X==23) ? 1984 :
             (X==24) ? 1996 :
             (X==25) ? 2000 : 0 ;
  assign SIN = S? AY: -AY;
  always @ (posedge clk) if (ce_sd) begin
    X<= up? X+1 : X-1 ; //Генератор "пилы"
    up <= (X==Xmin+1)? 1 : (X==Xmax-1)? 0 : up ;
    S <= ((X==Xmin+1) & !up)? !S : S ;
  end

endmodule