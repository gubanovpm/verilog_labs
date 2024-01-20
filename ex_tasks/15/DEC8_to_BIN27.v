module DEC8_to_BIN27(input [31:0] DEC, output reg[26:0] BIN,
                     input clk,        output reg ok,
                     input st);

  reg [3:0]cb_tact=0;
  reg en_conv=0;
  //Таблица цифр
  wire [3:0]Dig = (cb_tact==0) ? DEC[ 3: 0] :
                  (cb_tact==1) ? DEC[ 7: 4] :
                  (cb_tact==2) ? DEC[11: 8] :
                  (cb_tact==3) ? DEC[15:12] :
                  (cb_tact==4) ? DEC[19:16] :
                  (cb_tact==5) ? DEC[23:20] :
                  (cb_tact==6) ? DEC[27:24] :
                  (cb_tact==7) ? DEC[31:28] : 0 ;

  //Таблица весов декадных разрядов
  wire [32:0]WD = (cb_tact==0)? 1 :
                  (cb_tact==1)? 10 :
                  (cb_tact==2)? 100 :
                  (cb_tact==3)? 1000 :
                  (cb_tact==4)? 10000 :
                  (cb_tact==5)? 100000 :
                  (cb_tact==6)? 1000000 :
                  (cb_tact==7)? 10000000 : 0 ;
  //Цикл суммирования
  always @ (posedge clk) begin
    en_conv <= st? 1 : (cb_tact==7)? 0 : en_conv ;
    cb_tact <= st? 0 : en_conv? cb_tact+1 : cb_tact ;
    BIN <= st? 0 : en_conv? BIN+WD*Dig : BIN ;
    ok <= (cb_tact==7) ;
  end

endmodule