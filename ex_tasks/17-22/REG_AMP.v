module REG_AMP(input clk, output reg [7:0] M=8'h80, //Множитель
               input BTN1,
               input BTN2,
               input ce);

  reg tBTN1=0, ttBTN1=0, tBTN2=0, ttBTN2=0;
  wire st_UP = tBTN1 & !ttBTN1 ; //Импульс сдвига влево (умножение на 2)
  wire st_DOWN = tBTN2 & !ttBTN2 ; //Импульс сдвига вправо (деление на 2)
  
  wire Mmax=(M==8'h80); //Максимальное значение M=128
  wire Mmin=(M==8'h01); //Минимальное значение M=1
  
  always @ (posedge clk) if (ce) begin
    tBTN1 <= BTN1 ; ttBTN1 <= tBTN1 ;
    tBTN2 <= BTN2 ; ttBTN2 <= tBTN2 ;
    M <= (!Mmax & st_UP)? M<<1 : (!Mmin & st_DOWN)? M>>1 : M ;
  end

endmodule