`include "CONST.v"
`include "MEM12x128.v"

module Mes_AMP_SH(input [11:0]FSK_SH, output wire [11:0] DFSK_SH, //Задержанный сигнал FSK
                  input clk,          output reg [12:0]bf_SH=`SH, //Реверсивный счетчик
                  input res,          output wire [11:0] AMP, //Текущая амплитуда
                                      output reg OCD=0, //Превышение порога
                                      output wire ce_Fd); //Сигнал дискретизации

  parameter dREF=`Amin/4 ; //Гистерезис компаратора

  wire [11:0]DFSK = DFSK_SH-bf_SH ; //Вычитание среднего смещения
  wire [11:0]mod_DFSK = DFSK[11]? -DFSK : DFSK; //Абсолютное значение (модуль) DFSK
  wire [11:0]REF = AMP>>1 ; //Деление AMP на 2 (REF=AMP/2)

  reg [10:0] cb_ce =0 ; //Tce=1/Fce
  assign ce_Fd = (cb_ce==`Fclk/(`Fbit*`NP)) ; //Сигнал дискретизации

  reg [6:0] Adr_wr=0 ;
  wire [6:0] Adr_rd = Adr_wr-`ND ; //Задержка на Tbit=`ND*Tce=T1

  always @ (posedge clk) begin
    cb_ce <= (ce_Fd)? 1 : cb_ce+1 ; //
    Adr_wr <= ce_Fd? Adr_wr+1 : Adr_wr ;
  end
  //--Модуль памяти для задержки сигнала FSK
  MEM12x128 DD2 (.clk(clk), .DO(DFSK_SH),
                 .we(ce_Fd),
                 .DI(FSK_SH),
                 .Adr_wr(Adr_wr),
                 .Adr_rd(Adr_rd));

  reg [11:0]PIC_max = 0; //Регистр пикового детектора максимума сигнала FSK
  reg [11:0]PIC_min = 4095; //Регистр пикового детектора минимума сигнала FSK

  wire [12:0]SH = (PIC_max+PIC_min)>>1 ; //Полусумма
  assign AMP= (PIC_max-PIC_min)>>1 ; //Полуразность
  //--Получение максимума и минимума сигнала FSK
  always @ (posedge clk) begin //
    PIC_max <= res? 12'h000 : ((FSK_SH>PIC_max) & ce_Fd)? FSK_SH : PIC_max ;
    PIC_min <= res? 12'hFFF : ((FSK_SH<PIC_min) & ce_Fd)? FSK_SH : PIC_min ;
  end
  always @ (posedge clk) if (ce_Fd) begin
    //--Реверсивный следящий измеритель смещения
    bf_SH <= (SH>bf_SH)? bf_SH+1 : (SH<bf_SH)? bf_SH-1 : bf_SH ;
    //--Компаратор с гистерезисом
    OCD <= ((mod_DFSK>=REF+dREF) & (mod_DFSK>`Amin))? 1 : (mod_DFSK<=REF-dREF)? 0 : OCD ;
  end

endmodule