`include "SPI_AD7895.v"
`include "MULT_5000_DIV_4096.v"

module ADC_95(input clk,  output wire [11:0]ADC_5000, //ADC_5000=(Uin/5.000V)*5000
              input SDAT, output wire st_ADC, //Convst
              input st,   output wire SCLK, //Импульсы синхронизации
              input BUSY);

  wire [11:0]ADC_4096 ;//ADC_4096=(Uin/4.096V)*4096

  SPI_AD7895 DD1 (.clk(clk), .SCLK(SCLK),
                  .st(st),   .st_ADC(st_ADC),
                  .SDAT(SDAT), .ADC_dat(ADC_4096),
                  .BUSY(BUSY));

  MULT_5000_DIV_4096 DD2 (.A(ADC_4096), .B(ADC_5000));//B=(A*5000)/4096
endmodule