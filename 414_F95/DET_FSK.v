`include "CONST.v"

module DET_FSK(     output wire [11:0] DFSK_SH,//Задержанный сигнал FSK_SH
input [11:0]FSK_SH, output wire OCD, // (OCD=(mod_DFSK>=AMP/2))
input clk,          output wire [11:0] AMP, // Текущая амплитуда
                    output wire [12:0] bf_SH, // Среднее смещение
                    output wire FSK_tact, // Период FSK_tact=833us
                    output reg [6:0]cb_tact=0, // Счетчик такта
                    output wire FSK_start, // Старт приема бит
                    output reg FSK_en_rx=0, // Интервал приема бит
                    output reg[3:0]cb_rx_bit=0, //Счетчик принятых бит
                    output wire ce_Fd, //Сигнал дискретизации
                    output wire FSK_res, //Импульс "сброса" в паузе
                    output wire[10:0]F1_AMP, //Амплитуда первой гармоники
                    output wire[10:0]F2_AMP, //Амплитуда второй гармоники
                    output reg RX_bit=1, //Декодированный бит по DFT
                    output wire ok_rx_bit);
  //--Измеритель смещения и амплитуды--------
  Mes_AMP_SH DD1(.FSK_SH(FSK_SH), .DFSK_SH(DFSK_SH),//Задержанный FSK_SH
                 .clk(clk), .AMP(AMP), // Текущая амплитуда
                 .res(FSK_res), .bf_SH(bf_SH), // Среднее смещение
                 .ce_Fd(ce_Fd), // Сигнал дискретизации
                 .OCD(OCD)); // Сигнал превышения порога
  //--------------------------------------------
  wire [11:0]DFSK = DFSK_SH-bf_SH ; //Вычитание среднего смещения
  assign FSK_tact = (cb_tact==`NP) & ce_Fd ; //
  
  reg tFSK_tact=0 ;
  reg tOCD=0 ; //
  
  wire front_OCD = (OCD & !tOCD);
  assign FSK_start = front_OCD & !FSK_en_rx & ce_Fd ;//
  reg [6:0]cb_FSK_res=0; //Счетчик паузы
  
  assign FSK_res = ((cb_FSK_res==`NP/2) & FSK_en_rx) & ce_Fd ;
  always @ (posedge clk) if (ce_Fd) begin
    tOCD <= OCD ;
    FSK_en_rx <= front_OCD? 1 : FSK_res? 0 : FSK_en_rx ;
    cb_rx_bit <= FSK_start? 0 : (FSK_en_rx & FSK_tact)? cb_rx_bit+1 : cb_rx_bit ;
    cb_FSK_res <= OCD? 0 : FSK_en_rx? cb_FSK_res+1 : cb_FSK_res ;
    cb_tact <= (FSK_tact | FSK_start)? 1 : cb_tact+1 ;
    tFSK_tact <= FSK_tact ;
  end
  wire st_DFT = tFSK_start | (FSK_en_rx & FSK_tact) ;
  assign ok_rx_bit = tFSK_tact & FSK_en_rx & ce_Fd;
  //--Измеритель амплитуды первой гармоники
  wire [6:0]n1= 1 ; //99
  DFTn DD2 (.X(DFSK), .modY(F1_AMP),
            .ce(ce_Fd),
            .clk(clk),
            .st(st_DFT),
            .ce_bit(FSK_tact),
            .n(n1));
  //--Измеритель амплитуды второй гармоники
  wire [6:0]n0= 2 ;//98
  DFTn DD3 (.X(DFSK), .modY(F2_AMP),
            .ce(ce_Fd),
            .clk(clk),
            .st(st_DFT),
            .ce_bit(FSK_tact),
            .n(n0));
  always @ (posedge clk) begin
    RX_bit <= FSK_res? 1 : ok_rx_bit? (F1_AMP>F2_AMP) : RX_bit ;
  end

endmodule