module MUX_dat(input [7:0] TX_DAT, output wire [15:0] OUT_dat,
               input [7:0] RX_DAT,
               input [15:0] Amin,
               input [15:0] SHdec,
               input [15:0] AMPdec,
               input [15:0] AF1dec,
               input [15:0] AF2dec,
               input [12:0] SHbin,
               input [11:0] AMPbin,
               input [2:0]adr);

  assign OUT_dat = (adr[2:0]==0)? {TX_DAT,RX_DAT} :
                   (adr[2:0]==1)? Amin :
                   (adr[2:0]==2)? SHdec :
                   (adr[2:0]==3)? AMPdec :
                   (adr[2:0]==4)? AF1dec :
                   (adr[2:0]==5)? AF2dec :
                   (adr[2:0]==6)? {3'b000,SHbin} : {4'b0000,AMPbin};

endmodule