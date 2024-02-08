module SPI_AD7895 (input clk,  output wire SCLK, //Импульсы синхронизации
                   input BUSY, output reg st_ADC=1,//CONVST
                   input SDAT, output reg [11:0]ADC_dat=0, //Буфер данных
                   input st,   output reg ok_adc=0, //Конец преобразования
                               output reg [11:0]sr_DAT=0, //Регистр сдвига данных
                               output reg [4:0]cb_bit=0, //Счетчик бит
                               output wire ce_tact); //Границы тактов

  reg tBUSY=0, ttBUSY=0, Q=0 ;
  reg [1:0]cb_ce=0 ; //Счетчик такта

  wire ce=(cb_ce==3); //Период ce Tce=80 ns
  wire ce_bit = ce & !Q ; //Период Q=160 ns
  assign ce_tact = ce & Q ; //Период Q=160 ns

  wire start_SCLK = !tBUSY & ttBUSY & ce;
  wire stop_SCLK = (cb_bit==16) & ce_tact;

  reg en_SCLK=0 ; //Интервал считывания данных
  assign SCLK = Q & en_SCLK ; //Период SCLK=160 ns

  always @ (posedge clk) begin
    cb_ce <= st? 0 : cb_ce+1 ;
    Q <= st? 0 : ce? !Q : Q ;
    st_ADC <= st? 0 : ce? 1 : st_ADC ;
    tBUSY <= ce? BUSY : tBUSY ; ttBUSY <= ce? tBUSY : ttBUSY;
    en_SCLK <= start_SCLK? 1 : stop_SCLK? 0 : en_SCLK ;
    cb_bit <= st? 0 : (en_SCLK & ce_tact)? cb_bit+1 : cb_bit ;
    sr_DAT <= st? 0 : (ce_bit & en_SCLK)? sr_DAT<<1 | SDAT : sr_DAT ;
    ok_adc <= stop_SCLK? 1 : ce? 0 : ok_adc ;
    ADC_dat <= ok_adc? sr_DAT : ADC_dat ;
  end

endmodule