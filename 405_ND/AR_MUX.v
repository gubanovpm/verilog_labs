module AR_MUX(input [7:0]  ADR_TX,  output wire [15:0] DISPL,
              input [22:0] DAT_TX, 
              input [7:0]  ADR_RX,
              input [23:0] DAT_RX,
              input [1:0]  S);

  assign DISPL = (S == 2'b00) ? {DAT_TX[7:0], ADR_TX[7:0]} :
                 (S == 2'b01) ? {1'b0, DAT_TX[22:8]} : 
                 (S == 2'b10) ? {DAT_RX[7:0], ADR_RX[7:0]} :
                                {DAT_RX[23:8]};

endmodule