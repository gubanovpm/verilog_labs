`include "CONST.v"
`include "URXD_FSK_1byte.v"
`include "PIC_DET.v"
`include "BIN12_to_DEC4.v"

module FSK_FRXD (                    output wire st_SADC, //Старт АЦП AD7895
                 input [11:0]FSK_IN, output wire en_rx_byte, //JD1
                 input clk,          output wire URXD, //JD2
                 input st,           output wire OCD, //JD3
                                     output wire [7:0] RX_dat, //Принятый байт
                                     output wire [15:0] Amin, //Минимальная амплитуда
                                     output wire [15:0] SHdec, //Смещение (DEC)
                                     output wire [15:0] AMPdec,//Амплитуда (DEC)
                                     output wire [15:0] AF1dec, //Первая гармоника
                                     output wire [15:0] AF2dec, //Вторая гармоника
                                     output wire [12:0] bf_SH, //Смещение (HEX)
                                     output wire [11:0]bf_AMP);//Амплитуда (HEX)

  wire ok_rx_bit ;
  wire [10:0] F2_AMP ; wire [10:0] F1_AMP ;

  URXD_FSK_1byte DD1 ( .RXD(URXD),
            .clk(clk), .RX_dat(RX_dat),
      .FSK_SH(FSK_IN), .en_rx_byte(en_rx_byte),
                       .OCD(OCD),
                       .bf_AMP(bf_AMP),
                       .bf_SH(bf_SH),
                       .ce_Fd(st_SADC),
                       .F2_AMP(F2_AMP),
                       .F1_AMP(F1_AMP),
                       .ok_rx_bit(ok_rx_bit));
  //--Пиковый детектор амплитуды первой гармоники F1 AMP
  wire [11:0]PIC_F1 ;
  PIC_DET DD2 (.A(F1_AMP), .PIC(PIC_F1),
               .ce(ok_rx_bit),
               .clk(clk),
               .st(st));
  //--Пиковый детектор амплитуды второй гармоники F2 AMP
  wire [11:0]PIC_F2 ;
  PIC_DET DD3 (.A(F2_AMP), .PIC(PIC_F2),
               .ce(ok_rx_bit),
               .clk(clk),
               .st(st));
  //--Преобразователь двоичного числа PIC_AMP в двоично-десятичное AMPdec
  BIN12_to_DEC4 DD4 (.BIN(bf_AMP), .DEC(AMPdec),
                     .st(st),
                     .clk(clk));
  //--Преобразователь двоичного числа PIC_SH в двоично-десятичное SHdec
  BIN12_to_DEC4 DD5 (.BIN(bf_SH), .DEC(SHdec),
                     .st(st),
                     .clk(clk));
  //--Преобразователь двоичного числа PIC_F1 в двоично десятичное AF1dec
  BIN12_to_DEC4 DD6 (.BIN(PIC_F1), .DEC(AF1dec),
                     .clk(clk),
                     .st(st));
  //--Преобразователь двоичного числа PIC_F2 в двоично десятичное AF2dec
  BIN12_to_DEC4 DD7 (.BIN(PIC_F2), .DEC(AF2dec),
                     .clk(clk),
                     .st(st));
  //--Преобразователь двоичного числа `Amin в двоично десятичное Amin
  wire [11:0]bin_Amin=`Amin ;
  BIN12_to_DEC4 DD8 (.BIN(bin_Amin),.DEC(Amin),
                     .clk(clk),
                     .st(st));

endmodule