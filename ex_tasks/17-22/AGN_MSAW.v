module AGN_MSAW(input ce, output wire [11:0] MSAW,
                input clk, output wire CO_MSAW,
                input [7:0] M);

  parameter NP=100 ;//
  parameter AMP=4000 ;//
  parameter k=(AMP/NP);

  reg [6:0]cb_NP=0 ;
  assign CO_MSAW = (cb_NP==NP);
  wire [11:0]SAW = cb_NP*k ;

  always @ (posedge clk) if (ce) begin
    cb_NP <= CO_MSAW? 0 : cb_NP+1 ;
  end

  wire [19:0]MkSAW=SAW*M ;
  assign MSAW= MkSAW>>7;

endmodule