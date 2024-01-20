module COMP_MULT(input [15:0] Xr, output reg [15:0] Pre=0, //Реальная часть произведения
                 input [15:0] Xi, output reg [15:0] Pim=0, //Мнимая часть произведения
                 input [17:0] COS, //COS=cos(x)*2^16
                 input [17:0] SIN, //SIN=sin(x)*2^16
                 input clk);

  //Поворот против часовой стрелки
  //(Xr+j*Xi)*(COS+j*SIN)= (Xr*COS-Xi*SIN)+j(Xr*SIN+Xi*COS)
  wire [15:0] M1r ; //Xr*COS
  wire [15:0] M2r ; //Xi*SIN
  wire [15:0] M1i ; //Xi*COS
  wire [15:0] M2i ; //Xr*SIN
  
  always @ (posedge clk) begin
    Pre <= M1r-M2r ; //Xr*COS-Xi*SIN
    Pim <= M2i+M1i ; //Xr*SIN+Xi*COS
  end
  //Умножители чисел со знаком
  SMULT DD1 (.A(Xr), .AB(M1r), // Ar*COS
             .B(COS),
             .clk(clk));
  SMULT DD2 (.A(Xi), .AB(M2r), // Ai*SIN
             .B(SIN),
             .clk(clk));
  SMULT DD3 (.A(Xi), .AB(M1i), // Ai*COS
             .B(COS),
             .clk(clk));
  SMULT DD4 (.A(Xr), .AB(M2i), // Ar*SIN
             .B(SIN),
             .clk(clk));

endmodule

`define m_A 16 //Число разрядов X
`define m_B 18 //Число разрядов B
module SMULT (input [`m_A-1:0] A, output wire [`m_A-1:0] AB, //A*cos или A*sin
              input [`m_B-1:0] B,                            // Это cos*2^16 или sin*2^16
              input clk);

  reg [`m_A+`m_B-1:0] MAB = 0; //Полное произведение
  assign AB = MAB>>16 ; //AB=MAB/2^16 (деление на 2 16 )
  wire s_A = A[`m_A-1]; //Знак числа A
  wire s_B = B[`m_B-1]; //Знак числа B
  wire s_M = s_A^s_B ; //Знак произведения M
  wire [`m_A-1:0]mod_A= s_A? -A : A; //Модуль числа A
  wire [`m_B-1:0]mod_B= s_B? -B : B; //Модуль числа B
  wire [`m_A+`m_B-1:0]mod_M = mod_A * mod_B; // Произведение модулей
  
  always @ (posedge clk) begin
    MAB <= s_M? -mod_M : mod_M; //Восстановление знака произведения
  end

endmodule