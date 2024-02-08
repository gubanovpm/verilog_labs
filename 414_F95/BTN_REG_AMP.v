module BTN_REG_AMP(input BTN_UP, output reg [7:0] M=8'h80, //Множитель
                   input BTN_DOWN,
                   input clk,
                   input ce);//ce1ms или ct10ms

  reg [1:0]Q_UP ;//
  reg [1:0]Q_DOWN ;//

  wire st_UP= Q_UP[0] & !Q_UP[1] & ce ;//Для сдвига вправо (делить на 2)
  wire st_DOWN= Q_DOWN[0] & !Q_DOWN[1] & ce ;//Для сдвига влево (умножить на 2)
  wire Mmax=(M==8'h80); //Максимальное значение M=128
  wire Mmin=(M==8'h01); //Минимальное значение M=1

  always @ (posedge clk) if (ce) begin
    Q_UP <= Q_UP<<1 | BTN_UP ;//Сдвиг BTN_UP
    Q_DOWN <= Q_DOWN<<1 | BTN_DOWN ;//Сдвиг BTN_DOWN
    M <= (!Mmax & st_UP)? M<<1 : (!Mmin & st_DOWN)? M>>1 : M ;
  end

endmodule