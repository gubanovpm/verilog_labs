module MULT_5000_DIV_4096(input [11:0]A, output wire[11:0] B);
  wire [24:0]MA = A*5000 ; //Умножение на 5000
  assign B = MA>>12 ; //Деление на 2^12=4096
endmodule