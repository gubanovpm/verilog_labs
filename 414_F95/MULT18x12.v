module MULT18x12 (input [11:0] X, output wire[11:0] WX, //WX=X*W/2^16
                  input [17:0] W,
                  input clk);

  reg[27:0] P=0 ; //Регистр произведения P=X*W

  wire SX=X[11] ; //Знак X
  wire SW=W[17] ; //Знак поворотного множителя W
  wire SP= SX^SW ; //Знак произведения

  wire [10:0]mod_X = SX? -X : X ; //Модуль X
  wire [16:0]mod_W = SW? -W : W ; //Модуль поворотного множителя W
  wire [27:0]mod_P = mod_X*mod_W; //Произведение модулей X и W

  assign WX = P>>16 ; //Деление P[27:0] на 2^16
  always @ (posedge clk) begin
    P = SP? -mod_P : mod_P ; //Восстановление знака произведения
  end

endmodule