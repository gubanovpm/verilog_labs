module GEN_MCONST(input [7:0] M, output wire [11:0] CONST);
  // parameter AMP = 4000 ; 
  parameter AMP = 322 ; 
  parameter Mk = (AMP/128)*65536 ; //(AMP/128)*65536=2048000

  // wire [37:0] MCONST = (M*Mk) ;
  wire [27:0] MCONST = (M*Mk) ;
  assign CONST = MCONST>>16 ;
endmodule