module Gen_MTX(input clk, output reg MTX = 0,
               input ce,  
               input [15:0] X);

  parameter M = 1000000000; // mb in this task M id different

  reg [31:0] ACC = 0;
  wire CO = (ACC + X >= M) ; 

  always @ (posedge clk) if (ce) begin
    ACC <= CO ? ACC+X-M : ACC+X ;
    MTX <= CO ? !MTX : MTX ;
  end  

endmodule