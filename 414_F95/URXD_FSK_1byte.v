`include "URXD1B.v"
`include "DET_FSK.v"

module URXD_FSK_1byte(output wire [11:0] DFSK_SH,//Задержаный сигнал FSK_SH
  input [11:0]FSK_SH, output wire OCD, //Превышение порога
  input clk,          output wire [12:0] bf_SH, //Буфер смещения SIN_FSK
                      output wire [10:0] bf_AMP, //Буфер амплитуды SIN_FSK
                      output wire RXD, //Принятый бит
                      output wire ce_Fd, //Сигнал дискретизации
                      output wire ok_rx_bit, //Сигнал приема бита
                      output wire en_rx_byte, //Интервал приема
                      output wire [3:0] cb_rx_bit,//Счетчик бит
                      output wire [7:0] RX_dat, //Принятый байт
                      output wire[10:0]F2_AMP, //DFT Амплитуда 2-й гармоники FSK
                      output wire[10:0]F1_AMP);//DFT Амплитуда 1-й гармоники FSK

  //--Детектор FSK бита
  DET_FSK DD1 (.FSK_SH(FSK_SH), .DFSK_SH(DFSK_SH),
               .clk(clk), .OCD(OCD),
               .bf_SH(bf_SH),
               .bf_AMP(bf_AMP),
               .RX_bit(RXD),
               .ce_Fd(ce_Fd),
               .ok_rx_bit(ok_rx_bit),
               .F2_AMP(F2_AMP), //Амплитуда второй гармоники
               .F1_AMP(F1_AMP)); //Амплитуда первой гармоники
  //--Приемник одного байта
  wire start_rx ;
  URXD1B DD2 (.inp(RXD), .en_rx_byte(en_rx_byte),
              .clk(clk), .RX_dat(RX_dat),
              .cb_bit(cb_rx_bit),
              .start_rx(start_rx));

  always @ (posedge clk) if (start_rx) begin
    bf_AMP <= AMP ;
  end

endmodule