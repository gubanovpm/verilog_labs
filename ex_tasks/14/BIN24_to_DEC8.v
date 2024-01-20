module BIN24_to_DEC8(input[23:0]BIN, output wire [31:0]DEC,
                     input clk,
                     input st );

  reg [3:0]ptr_dig=0; //Указатель номера декадной цифры
  reg[3:0]D1dec=0; reg[3:0]D2dec=0; reg[3:0]D3dec=0; reg[3:0]D4dec=0;
  reg[3:0]D5dec=0; reg[3:0]D6dec=0; reg[3:0]D7dec=0; reg[3:0]D8dec=0;
  reg en_conv=0 ; // Интервал преобразования
  reg [24:0]rest=0; //Остаток
  assign DEC= {D8dec, D7dec, D6dec, D5dec, D4dec, D3dec, D2dec, D1dec} ;
  //Указатели декадных цифр
  wire d8 = (ptr_dig==8); wire d7 = (ptr_dig==7);
  wire d6 = (ptr_dig==6); wire d5 = (ptr_dig==5);
  wire d4 = (ptr_dig==4); wire d3 = (ptr_dig==3);
  wire d2 = (ptr_dig==2); wire d1 = (ptr_dig==1);
  //Веса декадных разрядов
  wire[26:0]Nd = d8? 10000000 :
                 d7? 1000000 :
                 d6? 100000 :
                 d5? 10000 :
                 d4? 1000 :
                 d3? 100 :
                 d2? 10 :
                 d1? 1 : 0 ;

  wire [24:0]dx = rest-Nd ; //Разность между остатком и di (i=8,7,6,5,4,3,2,1)
  wire z = dx[24] ; // Знак разности
  wire en_inc_dig = en_conv & !z ; //Разрешение инкремента декадной цифры
  wire en_dec_ptr = en_conv & z ; //Разрешение декремента указателя цифры

  always @(posedge clk) begin
    en_conv <= st? 1 : (ptr_dig==0)? 0 : en_conv ; //Разрешение преобразования
    rest <= st? BIN : en_inc_dig? dx : rest ; //Остаток
    ptr_dig <= st? 8: en_dec_ptr? ptr_dig-1 : ptr_dig ; /*Указатель очередной декадной цифры*/
    D8dec <= st? 0 : (d8 & en_inc_dig)? D8dec+1 : D8dec ;
    D7dec <= st? 0 : (d7 & en_inc_dig)? D7dec+1 : D7dec ;
    D6dec <= st? 0 : (d6 & en_inc_dig)? D6dec+1 : D6dec ;
    D5dec <= st? 0 : (d5 & en_inc_dig)? D5dec+1 : D5dec ;
    D4dec <= st? 0 : (d4 & en_inc_dig)? D4dec+1 : D4dec ;
    D3dec <= st? 0 : (d3 & en_inc_dig)? D3dec+1 : D3dec ;
    D2dec <= st? 0 : (d2 & en_inc_dig)? D2dec+1 : D2dec ;
    D1dec <= st? 0 : (d1 & en_inc_dig)? D1dec+1 : D1dec ;
  end
endmodule