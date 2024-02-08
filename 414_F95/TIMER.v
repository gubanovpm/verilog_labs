`include "CONST.v"

module TIMER(input clk, output wire ce,
             input st,  output wire ce_bit);

  parameter M=50000 ; //Емкость аккумулятора синтезатора частоты

  reg [15:0]ACC_ce=0 ;
  assign ce = (ACC_ce+`F1ce>=M) ;

  reg [6:0] cb_bit=0 ;
  assign ce_bit = (cb_bit==`NP) & ce ;

  always @ (posedge clk) begin
    ACC_ce <= st? 0 : ce? (ACC_ce+`F1ce)-M : ACC_ce+`F1ce ;
    cb_bit <= (st | ce_bit)? 1 : ce? cb_bit+1 : cb_bit ;
  end

endmodule