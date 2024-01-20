module VCDDMSLE(input clk, output wire [7:0] QMS, //Минуты
                input ce, output wire CO, //"Конец" часа
                input [6:0] DI, output reg [3:0]cd_1MS=0, //Счетчик единиц минут/секунд
                input L, output reg [3:0]cb_10MS=0);//Счетчик десятков минут/секунд

  wire CO10MS = (cd_1MS==0) & ce ; //"Конец" десятка минут/секунд

  assign CO = CO10MS & (cb_10MS==0); //"Конец" часа/минуты
  assign QMS = {cb_10MS,cd_1MS}; //Число часов/минут
  
  always @ (posedge clk) begin
    cd_1MS <= L? DI[3:0] : CO10MS? 9 : ce? cd_1MS-1 : cd_1MS ;
    cb_10MS <= L? DI[6:4] : CO? 5 : CO10MS? cb_10MS-1 : cb_10MS ;
  end
endmodule