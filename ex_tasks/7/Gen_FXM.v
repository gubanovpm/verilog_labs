module Gen_FXM(input clk, output reg FXM = 0,
               input ce,  
               input [15:0] X);

  parameter M = 500000;

  reg [19:0] ACC = 0;
  wire CO = (ACC + X >= M) ; 

  always @ (posedge clk) if (ce) begin
    ACC <= CO ? ACC+X-M : ACC+X ;
    FXM <= CO ? !FXM : FXM ;
  end  

endmodule