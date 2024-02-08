module DISPLAY(input clk,       output wire[3:0] AN, //Аноды
               input [15:0]dat, output wire [6:0]seg, //Сегменты
               input [2:0]PTR,  output wire seg_P, //Точка
                                output wire ce10ms, //10 милисекунд
                                output wire ce100ms, //100 милисекунд
                                output reg ce1s=0); //1 секунда

  parameter Fclk=50000000 ; //50000000 Hz
  parameter F1kHz=1000 ; //1 kHz
  parameter F100Hz=100 ; //100 Hz

  wire [1:0]ptr_P = (PTR==0)? 2'b10 : //Точка в центре (XX.XX)
                    (PTR==7)? 2'b00 : //Точка справа (XXXX.)
                              2'b11 ; //Точка слева (X.XXX)

  reg [15:0] cb_1ms = 0 ;
  wire ce = (cb_1ms==Fclk/F1kHz) ;

  reg [3:0]cb_10ms=0 ;
  assign ce10ms = (cb_10ms==10) & ce ;

  reg [3:0]cb_100ms=0 ;
  assign ce100ms = (cb_100ms==10) & ce10ms ;

  reg [3:0]cb_1s=0 ;
  //--Генератор сигнала ce (период 1 мс, длительность Tclk=20 нс)--
  always @ (posedge clk) begin
    cb_1ms <= ce? 1 : cb_1ms+1 ;
    cb_10ms <= ce10ms? 1 : ce? cb_10ms+1 : cb_10ms ;
    cb_100ms <= ce100ms? 1 : ce10ms? cb_100ms+1 : cb_100ms ;
    cb_1s <= ce1s? 1 : ce100ms? cb_1s+1 : cb_1s ;
    ce1s <= (cb_1s==10) & ce100ms ;
  end
  //------ Счетчик цифр -----------------------------------------
  reg [1:0]cb_dig=0 ;
  always @ (posedge clk) if (ce) begin
    cb_dig <= cb_dig+1 ;
  end
  //-------Переключатель «анодов»-------------
  assign AN = (cb_dig==0)? 4'b1110 : //включение цифры 0 (младшей)
              (cb_dig==1)? 4'b1101 : //включение цифры 1
              (cb_dig==2)? 4'b1011 : //включение цифры 2
                           4'b0111 ; //включение цифры 3 (старшей)
  //-------Переключатель тетрад (HEX цифр)-------------
  wire[3:0] dig =(cb_dig==0)? dat[3:0]:
                 (cb_dig==1)? dat[7:4]:
                 (cb_dig==2)? dat[11:8]: 
                              dat[15:12];
  //-------Семи сегментный дешифратор----------
  //gfedcba
  assign seg= (dig== 0)? 7'b1000000 ://0 a
              (dig== 1)? 7'b1111001 ://1 f| |b
              (dig== 2)? 7'b0100100 ://2 g
              (dig== 3)? 7'b0110000 ://3 e| |c
              (dig== 4)? 7'b0011001 ://4 d
              (dig== 5)? 7'b0010010 ://5
              (dig== 6)? 7'b0000010 ://6
              (dig== 7)? 7'b1111000 ://7
              (dig== 8)? 7'b0000000 ://8
              (dig== 9)? 7'b0010000 ://9
              (dig==10)? 7'b0001000 ://A
              (dig==11)? 7'b0000011 ://b
              (dig==12)? 7'b1000110 ://C
              (dig==13)? 7'b0100001 ://d
              (dig==14)? 7'b0000110 ://E
                         7'b0001110 ;//F
  //-------Указатель точки-------
  assign seg_P = !(ptr_P == cb_dig) ;

endmodule