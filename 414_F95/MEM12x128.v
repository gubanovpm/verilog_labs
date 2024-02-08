module MEM12x128(input clk, output reg [11:0] DO,
                 input we,
                 input [11:0] DI,
                 input [6:0] Adr_wr,
                 input [6:0] Adr_rd);

  reg [11:0]MEM[127:0] ;
  //assign DO = MEM[Adr_rd] ; //Слайсовая память
  initial //Инициализация модуля памяти из файла init_MEM12x64.txt
  $readmemh ("init_MEM12x128.txt", MEM, 0, 127);
  always @ (posedge clk) begin
    MEM[Adr_wr] <= we? DI : MEM[Adr_wr] ;
    DO <= MEM[Adr_rd] ;//Блочная память
  end
endmodule