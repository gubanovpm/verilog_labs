module UTXD1B(input clk,     output wire UTXD, //Выход
              input[7:0]dat, output wire ce_tact, //Границы тактов
              input st,      output reg en_tx_byte = 0, //Интервал передачи байта
                             output reg [3:0] cb_bit=0, //Счетчик бит
                             output reg T_start = 0, //Старт такт
                             output reg T_dat = 0, //Интервал данных
                             output reg T_stop = 0, //Стоп такт
                             output wire ce_stop, //Конец кадра
                             output reg [7:0] sr_dat=0 ); //Регистр сдвига данных

  parameter Fclk=50000000 ; //50 MHz
  parameter Nt = Fclk/`Fbit ;

  reg [31:0] cb_tact=0 ; //Счетчик такта

  assign ce_tact = (cb_tact==Nt) ; //Компаратор cb_tact с Nt
  assign ce_stop = T_stop & ce_tact ; // Конец кадра
  assign UTXD = T_start? 0 : T_dat? sr_dat[0] : 1 ; //Последовательные данные sr_dat[0]

  wire start = st & !en_tx_byte ;
  //-------------
  always @ (posedge clk) begin
    cb_tact <= (start | ce_tact)? 1 : cb_tact+1 ; //”Сброс” в 1 при cb_tact==`Nt
    en_tx_byte <= st? 1 : ce_stop? 0 : en_tx_byte;
    cb_bit <= start? 0 : (ce_tact & en_tx_byte)? cb_bit+1 : cb_bit ;
    T_start <= ((cb_bit==4'b0000) & en_tx_byte); // Компаратор старт такта
    T_dat  <= (cb_bit<9) & (cb_bit>0); // Компаратор интервала данных
    T_stop <= ((cb_bit==9) & en_tx_byte); // Компаратор стоп такта
    sr_dat <= (T_start & ce_tact)? dat : (T_dat & ce_tact)? sr_dat>>1 : sr_dat ; /* Сдвиг sr_dat младшими битами вперед*/
  end
endmodule