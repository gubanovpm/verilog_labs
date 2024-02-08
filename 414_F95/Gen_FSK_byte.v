`include "CONST.v"
`include "Gen_FSK_SIN.v"

module Gen_FSK_byte (input clk,       output wire ce_bit, //Границы бит
                     input st,        output reg en_tx=0, //Интервал передачи
                     input [7:0]dat,  output wire TXD, //Биты данных
                     input [7:0]Mamp, output wire [11:0]FSK_SH, //Пакет смещенных синусоид
                                      output wire S, //Знак синусоиды
                                      output wire ce_SIN, // Период синусоиды
                                      output wire ce_sd ); //Период дискретизации синусоиды

  //--Mamp[7:0] - Регулятор амплитуды SIN, AMPsin=NA*Mamp/128 (NA=2000)
  wire [11:0]SIN; //Синусоида
  assign FSK_SH = en_tx? SIN+`SH : `SH ; //Пакет смещенных синусоид
  
  parameter Macc=50000 ; //Емкость аккумулятора синтезатора частоты
  
  reg [15:0]ACC_ce=0 ; //Аккумулятор синтезатора частоты сигнала ce
  wire ce = (ACC_ce+`Fce>=Macc) ; //Сигнал переполнения аккумулятора
  
  reg [6:0] cb_tact=0 ; //Счетчик такта
  assign ce_bit = (cb_tact==`NP) & ce ; // Период ce_bit 1/1200Hz
  
  reg [3:0] cb_bit=0; //Счетчик бит
  wire ce_end = (cb_bit==`Nbit+1) & ce_bit ; // Конец кадра
  
  wire T_dat = (cb_bit>0) & (cb_bit<(`Nbit+1)) ; // Интервал данных
  reg [7:0] sr_dat =0 ; //Регистр сдвига данных
  assign TXD = ((cb_bit==0) & en_tx)? 0 : T_dat? sr_dat[0] : 1 ; //Биты данных
  
  always @ (posedge clk) begin
    ACC_ce <= st? 0 : ce? (ACC_ce+`Fce)-Macc : ACC_ce+`Fce ;
    cb_tact <= (st | ce_bit)? 1 : ce? cb_tact+1 : cb_tact ;
    cb_bit <= st? 0 : (ce_bit & en_tx)? cb_bit+1 : cb_bit ;
    en_tx <= st? 1 : ce_end? 0 : en_tx ;
    sr_dat <= st? dat : (T_dat & ce_bit)? sr_dat>>1 : sr_dat ;
  end
  //--Генератор синусоиды: TXD=0 Fsin=2200Hz, TXD=1 Fsin=1200Hz
  Gen_FSK_SIN DD1 (.clk(clk), .S(S), //S=1 sin>0
                  .D(TXD), .SIN(SIN), //Синусоида
                  .Mamp(Mamp), .ce_SIN(ce_SIN), //Период синусоиды
                  .ce_sd(ce_sd)); //Период дискретизации синусоиды

endmodule