`include "CONST.v"

module RET_TXD_CRC_BL(input clk, output wire UTXD, //Последовательные данные
                      input st, output reg en_tx=0, //Интервал передачи блока байт
                      input [7:0] com, output wire [7:0] tx_dat, //Передаваемые байты
                      input [7:0] lbl, output reg [15:0] CRC=16'hFFFF, //Контрольный CRC код
                      input [15:0] adr, output reg [7:0] cb_byte=0, //Счетчик передаваемых байт
                      input [7:0] dat, output reg[15:0] rd_adr=0); //Адрес передаваемых байт данных

  wire com_rd=(com==8'h80) | (com==8'h81); //Команда чтения
  wire com_wr=(com==8'h00) | (com==8'h01); //Команда записи
  //------Передатчик блока байт-------------------------------------
  reg [15:0] cb_tact ; //Счетчик длительности такта (бита)
  wire ce_tact = (cb_tact==`Nt) ; //Tce_tact=1/BAUDRATE
  reg [3:0] cb_bit=0 ; //Счетчик бит байта
  reg [7:0] sr_dat=0 ; //Регистр сдвига бит байта
  
  wire T_start = ((cb_bit==0) & en_tx) ; //Интервал старт бита
  wire ce_sh=(cb_bit<9) & (cb_bit>0) & ce_tact; //Разрешение сдвига бит байта
  assign ce_stop = (cb_bit==9) & ce_tact ; //Импульс конца байта
  wire rep_st = st | (ce_stop & en_tx); //Импульсы запуска передачи байт
  assign UTXD = T_start? 0 :en_tx? sr_dat[0] : 1 ; //UTXD блока байт
  wire [7:0]N_byte = com_rd? lbl+4 : //com, lbl, Hb_adr, Lb_adr, dat0,dat1,….
                     com_wr? 4 :     //com, lbl, adr[15:8], adr[7:0]
                             1 ;     //com («чужая» команда)

  wire T_com = (cb_byte==0) ; // Интервал команды
  wire T_lbl = (cb_byte==1) ; // Интервал длинны блока
  wire T_Hb_adr = (cb_byte==2) ; // Интервал старшего байта адреса
  wire T_Lb_adr = (cb_byte==3) ; // Интервал младшего байта адреса
  wire T_Lb_CRC = (cb_byte==N_byte); // Интервал младшего байта CRC
  wire T_Hb_CRC = (cb_byte==N_byte+1); // Интервал старшего байта CRC
  wire ce_adr = (ce_stop & cb_byte>3) & !(T_Lb_CRC | T_Hb_CRC) ;

  //--------Функциональное назначение байт ответа
  assign tx_dat= T_com? com : //Команда
                 T_Lb_CRC? CRC[ 7:0] : //Младший байт CRC
                 T_Hb_CRC? CRC[15:8] : //Старший байт CRC
                 T_lbl?    lbl :       //Число байт данных
                 T_Hb_adr? adr[15:8] : //Старший байт адреса
                 T_Lb_adr? adr[ 7:0] : //Младший байт адреса :
                           dat ;       //Данные
  wire ce_crc = ce_sh& !(T_Lb_CRC | T_Hb_CRC);
  wire x0 = CRC[0] ^ sr_dat[0] ;

  always @ (posedge clk) begin
    cb_tact <= (st | ce_tact)? 1 : cb_tact+1;
    cb_byte <= st? 0 : ce_stop? cb_byte+1 : cb_byte ;
    cb_bit <= rep_st? 0 : (ce_tact & en_tx)? cb_bit+1 : cb_bit ;
    sr_dat <= (T_start & ce_tact)? tx_dat : ce_sh? sr_dat>>1 | 1<<7 : sr_dat ;
    en_tx <= st? 1 : ((cb_byte==N_byte+1) & ce_stop)? 0 : en_tx ;
    rd_adr <= st? adr : ce_adr? rd_adr+1 : rd_adr ;
    //-- Вычисление CRC передатчика-------------------
    CRC <= st? `INIT_CRC : (x0 & ce_crc)? (((CRC^`XCRC16)>>1) | 1<<15): ce_crc? (CRC>>1) : CRC ;
  end
endmodule