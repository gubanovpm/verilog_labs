module Gen_MFX_Fce50(input clk,     output reg MFX = 0,
                     input [15:0] X);

  parameter M = 25000;

  reg [19:0] ACC = 0;
  wire CO = (ACC + X >= M) ; 

  always @ (posedge clk) begin
    ACC <= CO ? ACC+X-M : ACC+X ;
    MFX <= CO ? !MFX : MFX ;
  end  

endmodule