`define m 16
`define Fbit 50000
`define Nrep 30000

module SORCE_DAT(output wire[`m - 1:0] MASTER_dat,
                 output wire[`m - 1:0] SLAVE_dat );

  assign MASTER_dat = 16'b0110100100111100;
  assign SLAVE_dat  = 16'b1110110110101010;

endmodule