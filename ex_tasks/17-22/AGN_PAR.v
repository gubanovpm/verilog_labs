module AGN_PAR(input clk, output wire CO_PAR,
               input ce, output wire [11:0] MPAR,//Умноженный импульс
               input [7:0] M);//Множитель

  parameter NP=100 ; // Число точек на периоде
  parameter MA=(4000*2048)/1224 ; //Масштабный множитель ~6687

  reg [7:0]cb_NP=0 ; // Счетчик точек
  reg [10:0] X=49 ; //“Вычитающий счетчик”
  reg [10:0] PAR=0 ;//”Перевернутая парабола”
  wire [24:0]Y=(PAR*MA) ; //Умножение PAR на масштабный множитель
  wire [31:0]MY = Y*M ; //Умножение Y на регулятор амплитуды
  assign MPAR = MY>>18 ; //Деление на 2^(11+7)
  assign CO_PAR = (cb_NP==NP-1) ;// Граница импульса

  always @ (posedge clk) if (ce) begin
    cb_NP <= CO_PAR? 0 : cb_NP+1 ; // Счетчик точек
    X <= CO_PAR? NP/2-1 : X-1 ;// “Вычитающий счетчик”
    PAR <= CO_PAR? 0 : PAR+X ;//NP/2”интегрирование X”
  end

endmodule