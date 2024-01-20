module SPI_DAC8512(input [11:0] DI, output reg NCLR=1, //Асинхронный сброс
                   input st,        output reg NLD=1, //Асинхронная загрузка
                   input clk,       output wire SDAT, //Последовательные данные
                                    output reg NCS=1, //Выбор кристалла
                                    output wire SCLK ); //Сигнал синхронизации

  parameter Tsclk = 80 ; //Tsclk=Tcl+Tch=40+40 ns
  parameter Tclk = 20 ; //Период сигнала синхронизации

  reg [2:0]cb_ce=0; //Счетчик тактов
  wire ce = (cb_ce==Tsclk/Tclk-1) ;
  assign SCLK = cb_ce[1] | NCS ;

  reg[3:0]cb_bit=0 ; //Счетчик бит
  reg [11:0]sr_dat=0;
  assign SDAT = sr_dat[11];

  always @ (posedge clk) begin
    NCLR <= st? 1 : NCLR ;
    cb_ce <= (st | ce)? 0 : cb_ce+1 ;
    NCS <= st? 0 : ((cb_bit==11) & ce)? 1 : NCS ;
    cb_bit <= st? 0 : (!NCS & ce)? cb_bit+1 : cb_bit ;
    sr_dat <= st? DI : (ce & !NCS)? sr_dat<<1 : sr_dat ;
    NLD <= st? 1 : ce? !(cb_bit==11) : NLD ;
  end

endmodule