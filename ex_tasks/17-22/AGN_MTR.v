module AGN_MTR(input clk, output reg UP=1,
               input ce, output wire [11:0] MTR,//Умноженный импульс
               input [7:0]M); //Множитель

  parameter NP=100 ; //Число точек на периоде (AMP(TR)=NP/2=50)
  parameter MA=4000/(NP/2); //Масштабный множитель (4000/50=80)

  reg [7:0] cb_NP=0 ;
  wire CO_TR ;
  reg [7:0] TR=0 ;
  wire [11:0]Y=TR*MA ; //Умножение на масштабный множитель
  wire [19:0]MY=Y*M ; //Умножение на регулятор амплитуды
  
  assign MTR=MY>>7 ;
  assign CO_TR = (cb_NP==NP+1) ;
  
  always @ (posedge clk) if (ce) begin
    cb_NP <= CO_TR? 0 : cb_NP+1 ;
    UP <= (cb_NP==NP/2)? 0 : (CO_TR)? 1 : UP ;
    TR <= CO_TR? 0 :(UP & !(cb_NP==NP/2))? TR+1:(!UP & !(cb_NP==NP/2))? TR-1 : TR;
  end

endmodule