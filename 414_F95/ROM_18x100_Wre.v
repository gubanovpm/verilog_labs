module ROM_18x100_Wre (input [6:0] k, output wire[17:0] Wre);

  reg [17:0]ROM[100:0] ;
  assign Wre = ROM[k] ; //Таблица Wre (слайсовая память)
  initial //Инициализация модуля памяти из файла Wr100.txt
  $readmemh ("Wr100.txt", ROM, 0, 100);

endmodule