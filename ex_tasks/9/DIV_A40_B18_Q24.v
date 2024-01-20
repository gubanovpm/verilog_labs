module Div_A40_B18_Q24(input clk, output reg [23:0] Q=0, //Регистр сдвига частного `m_A -`m_B разрядов
                       input [39:0] A, output reg ok_div=0,
                       input [17:0] B,
                       input st);

  reg [39:0]bf_A=0 ; //Буфер делимого `m_A разрядов
  reg [56:0]bf_B=0 ; //Буфер делителя `m_B +`m_A-2 разрядов
  reg[7:0]cb_tact=0; //Счетчик тактов деления
  reg TQ=0 ; //Интервал деления

  wire bit_Q = (bf_A>=bf_B) ; //Текущий бит деления
  wire T_end = (cb_tact==39) ; //Последний такт деления
  
  always @ (posedge clk) begin
    bf_A <= st? A: (TQ & bit_Q)? bf_A-bf_B : bf_A ; //
    bf_B <= st? B<<39: TQ? bf_B>>1 : bf_B ; //
    cb_tact <= st? 0 : TQ? cb_tact+1 : cb_tact ;
    TQ <= T_end? 0 : st? 1 : TQ ;
    Q <= st? 0: TQ? Q<<1 | bit_Q : Q ; //частное
    ok_div <= T_end ;
  end

endmodule