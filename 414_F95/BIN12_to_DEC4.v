module BIN12_to_DEC4(input [11:0] BIN, output wire [15:0] DEC,
                     input st, output reg [2:0]ptr_dig=0, //Указатель номера декадной цифры
                     input clk, output reg en_conv=0); //Разрешение преобразования

  reg[3:0]D1dec=0; reg[3:0]D2dec=0;
  reg[3:0]D3dec=0; reg[3:0]D4dec=0;
  reg [16:0]rest=0; //Остаток
  
  assign DEC= {D4dec,D3dec,D2dec,D1dec} ;
  wire d4 = (ptr_dig==4); wire d3 = (ptr_dig==3);
  wire d2 = (ptr_dig==2); wire d1 = (ptr_dig==1);
  
  wire[15:0]Nd = d4 ? 1000 :
                 d3 ? 100 :
                 d2 ? 10 :
                 d1 ? 1 : 0 ;

  wire [16:0]dx = rest-Nd ; //Разность между остатком и di (i=,4,3,2,1)
  wire z = dx[16] ; // Знак разности

  wire en_inc_dig = en_conv & !z ; //Разрешение инкремента декадной цифры
  wire en_dec_ptr = en_conv &  z ; //Разрешение декремента указателя цифры

  always @(posedge clk) begin
    en_conv <= st? 1 : (ptr_dig==0)? 0 : en_conv ; //Разрешение преобразования
    rest <= st? BIN : en_inc_dig? dx : rest ; //Текущий остаток
    ptr_dig <= st? 4: en_dec_ptr? ptr_dig-1 : ptr_dig ; //Указатель очередной декадной цифры
    D4dec <= st? 0 : (d4 & en_inc_dig)? D4dec+1 : D4dec ;
    D3dec <= st? 0 : (d3 & en_inc_dig)? D3dec+1 : D3dec ;
    D2dec <= st? 0 : (d2 & en_inc_dig)? D2dec+1 : D2dec ;
    D1dec <= st? 0 : (d1 & en_inc_dig)? D1dec+1 : D1dec ;
    //ok <=(ptr_dig==0) & en_conv;
  end

endmodule