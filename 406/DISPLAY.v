module DISPLAY(input clk,         output wire[3:0] AN, //Аноды
               input [15:0]dat,   output wire[6:0] seg, //Сегменты
               input [1:0]ptr_P,  output wire seg_P, //Точка
                                  output reg ce1ms = 0);

parameter Fclk = 50000 ; //50000 kHz
parameter F1kHz = 1 ; //1 kHz
reg [15:0] cb_1ms = 0 ;
wire ce = (cb_1ms==Fclk/F1kHz) ;
//-------Генератор сигнала ce1ms (период 1 мс, длительность Tclk=20 нс) --------
always @ (posedge clk) begin
cb_1ms <= ce? 1 : cb_1ms+1 ;
ce1ms <= ce ;
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
(cb_dig==2)? dat[11:8]: dat[15:12];
//-------Семисегментный дешифратор----------
//gfedcba
assign seg= (dig== 0)? 7'b1000000 : //0 a
(dig== 1)? 7'b1111001 : //1 f| |b
(dig== 2)? 7'b0100100 : //2 g
(dig== 3)? 7'b0110000 : //3 e| |c
(dig== 4)? 7'b0011001 : //4 d
(dig== 5)? 7'b0010010 : //5
(dig== 6)? 7'b0000010 : //6
(dig== 7)? 7'b1111000 : //7
(dig== 8)? 7'b0000000 : //8
(dig== 9)? 7'b0010000 : //9
(dig==10)?7'b0001000 : //A
(dig==11)? 7'b0000011 : //b
(dig==12)? 7'b1000110 : //C
(dig==13)? 7'b0100001 : //d
(dig==14)? 7'b0000110 : //E
7'b0001110 ; //F
//-------Указатель точки-------
assign seg_P = !(ptr_P == cb_dig) ;

endmodule