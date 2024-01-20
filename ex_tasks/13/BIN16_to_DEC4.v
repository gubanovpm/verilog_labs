module BIN16_to_DEC4(input[15:0]BIN, output wire [15:0]DEC,
                     input clk,			  output wire ok,
                     input st );
			
  reg [2:0]ptr_dig = 0;
  reg[3:0] D1dec = 0;	reg[3:0] D2dec = 0;	
  reg [3:0] D3dec=0;	reg [3:0] D4dec=0;

  reg en_conv = 0, q = 0 ;    
  reg [16:0] rest = 0;
  assign DEC= {D4dec, D3dec, D2dec, D1dec} ;

  wire d4 = (ptr_dig==4); wire d3 = (ptr_dig==3);
  wire d2 = (ptr_dig==2);	wire d1 = (ptr_dig==1);

  wire[15:0]Nd =	d4?  1000 : 
                  d3?  100 :	
                  d2?  10 :	
                  d1?  1 : 0 ;
  wire [16:0] dx = rest-Nd ; wire z = dx[16] ;
  wire en_inc_dig  = en_conv &  q & !z ; 
  wire en_dec_ptr  = en_conv & !q &  z ; 

  always @(posedge clk) begin
    q <= st? 0 : en_conv? !q : q ;
    en_conv <= st? 1 : (ptr_dig==0)? 0 : en_conv ;	
    rest <= st? BIN : en_inc_dig? dx : rest ;
    ptr_dig <= st? 4: en_dec_ptr?  ptr_dig-1 : ptr_dig ;

    D4dec <= st? 0 : (d4 & en_inc_dig)? D4dec+1 : D4dec ;
    D3dec <= st? 0 : (d3 & en_inc_dig)? D3dec+1 : D3dec ;
    D2dec <= st? 0 : (d2 & en_inc_dig)? D2dec+1 : D2dec ;
    D1dec <= st? 0 : (d1 & en_inc_dig)? D1dec+1 : D1dec ;
  end

endmodule