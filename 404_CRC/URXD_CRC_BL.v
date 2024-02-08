`include "CONST.v"

module URXD_CRC_BL(input URXD, output reg[7:0] com=0, //Команда
                   input clk,  output reg[7:0] lbl=0, //Длина блока данных
                               output reg[15:0] wr_adr=0, //Базовый адрес данных
                               output reg[7:0] rx_dat=0, //Принятый байт
                               output reg en_rx_byte=0, //Интервал приема байта
                               output reg en_rx_bl=0, //Интервал приема блока байт
                               output reg[7:0] cb_byte=0, //Счетчик принятых байт
                               output wire ok_rx_byte, //Подтверждение приема байта
                               output wire ce_wr_dat, //Разрешение записи данных
                               output wire res, //Сброс в конце паузы
                               output reg [15:0] CRC=0, //Контрольный код CRC
                               output wire ok_rx_bl ); //Конец приема блока байт

  parameter REF_PAUESE =10 ; //Допустимая пауза между байтами
  //--------Приемник строки байт------------------------------
  reg [11:0] cb_tact=0 ; //Счетчик длительности такта (бита)

  wire ce_tact = (cb_tact==`Nt) ; //Tce_tact=1/BAUDRATE
  wire ce_bit = (cb_tact==(`Nt/2)); //Середина такта
  reg [3:0]cb_bit=0 ; //Счетчик бит в кадре UART
  reg [4:0]cb_res=0 ; //Счетчик паузы
  reg RXD=0, tRXD=0 ; //
  assign res = (cb_res>=REF_PAUESE) & ce_tact & en_rx_bl ;
  wire com_wr = (com==8'h00) | (com==8'h01) ;
  wire com_rd = (com==8'h80) | (com==8'h81) ;
  //---Адреса регистров--------------------------
  wire T_com = (cb_byte==0) ; //Команда
  wire T_lbl = (cb_byte==1) ; //Длина блока
  wire T_Hb_adr = (cb_byte==2) ; //Старший байт адреса
  wire T_Lb_adr = (cb_byte==3) ; //Младший байт адреса
  wire T_dat = (cb_byte>3) ; //Интервал данных
  wire dRXD = !RXD & tRXD ; //"Спады" входного сигнала RXD

  assign ok_rx_byte = (ce_bit & (cb_bit==9) & en_rx_byte & tRXD); //Успешный прием байта

  wire st_rx_byte = dRXD & !en_rx_byte ;//Старт приема очередного байта
  wire st_rx_bl = dRXD & !en_rx_bl ; //Старт приема блока байт

  assign ok_rx_bl = res & (CRC==0); /*Успешный прием блока байт (по паузе в 10 тактов между байтами)*/
  wire T_sh = (cb_bit<9) & (cb_bit>0); //Интервал данных байта
  wire x0 = CRC[0] ^ RXD ;
  wire ce_crc = ce_bit & T_sh ;
  reg[7:0] cb_wr_byte=0 ; //
  assign ce_wr_dat = T_dat & ok_rx_byte & com_wr & (cb_wr_byte<lbl);

  always @ (posedge clk) begin
    RXD <= URXD ; tRXD <= RXD ;
    cb_tact <= ((dRXD & !en_rx_byte) | ce_tact)? 1 : cb_tact+1;
    cb_bit <= (st_rx_byte | ((cb_bit==9) & ce_tact))? 0 : (ce_tact & en_rx_byte)? cb_bit+1 : cb_bit ;
    en_rx_byte <= (ce_bit & !RXD)? 1 : ((cb_bit==9) & ce_bit)? 0 : en_rx_byte ;
    rx_dat <= (ce_bit & T_sh)? rx_dat>>1 | RXD<<7 : rx_dat ; //
    cb_byte <= ok_rx_bl? 0 : ok_rx_byte? cb_byte+1 : cb_byte ;
    cb_res <= en_rx_byte? 0 : (ce_tact)? cb_res+1 : cb_res ;// & en_rx_bl
    en_rx_bl <= st_rx_byte? 1 : ok_rx_bl? 0 : en_rx_bl ;
    CRC <= st_rx_bl? `INIT_CRC : (x0 & ce_crc)? (((CRC^`XCRC16)>>1) | 1<<15): ce_crc? (CRC>>1) : CRC ;//16'h4002
  end
  //---Загрузка регистров: команды и длиннны блока и адреса
  always @ (posedge clk) begin
    com <= (T_com & ok_rx_byte)? rx_dat : com ;
    lbl <= (T_lbl & ok_rx_byte)? rx_dat : lbl ;
    cb_wr_byte <= (T_com & ok_rx_byte)? 0 :
                  (T_lbl & com_rd & ok_rx_byte)? rx_dat :
                  ce_wr_dat? cb_wr_byte+1 : cb_wr_byte ;
    wr_adr[15:8] <= (T_Hb_adr & ok_rx_byte)? rx_dat :
    (T_dat & ce_wr_dat & (wr_adr[7:0]==8'hFF))? wr_adr[15:8]+1 : wr_adr[15:8] ;
    wr_adr[ 7:0] <= (T_Lb_adr & ok_rx_byte)? rx_dat :
                    (T_dat & ce_wr_dat)? wr_adr[7:0]+1 : wr_adr[7:0] ;
  end
endmodule