module ROM_18x100_Wim (input [6:0] k, output wire[17:0] Wim);

  reg [17:0]ROM[100:0] ;
  assign Wre = ROM[k] ; //Таблица Wim (слайсовая память)
  initial //Инициализация модуля памяти из файла Wi100.txt
  $readmemh ("Wi100.txt", ROM, 0, 100);

endmodule