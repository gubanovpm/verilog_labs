`include "CONST.v"

module my_BLOCK(input clk,           output wire [15:0] DISPL,
                input ce_wr_dat,     output wire [7:0] LED,
                input [7:0] rx_dat,  output wire [7:0] my_dat,
                input [15:0] wr_adr,
                input [15:0] rd_adr,
                input [7:0] SW,
                input [7:0] com);

  assign ew0 = (wr_adr == `MY_ADR + 0);
  assign ew1 = (wr_adr == `MY_ADR + 1);
  assign ew2 = (wr_adr == `MY_ADR + 2);

  assign er0 = (rd_adr == `MY_ADR + 0);
  assign er1 = (rd_adr == `MY_ADR + 1);
  assign er2 = (rd_adr == `MY_ADR + 2);
  assign er3 = (rd_adr == `MY_ADR + 3);

  assign wr_my_MEM = ((`MY_ADR <= wr_adr) & (wr_adr <= `MY_ADR + 255));
  assign rd_my_MEM = ((`MY_ADR <= rd_adr) & (rd_adr <= `MY_ADR + 255));

  assign ce_wr_REG =  (com == 8'h00) ? ce_wr_dat : 0 ;
  assign ce_wr_MEM = ((com == 8'h81) & wr_my_MEM);
  assign ce_rd_MEM = ((com == 8'h81) & rd_my_MEM);

  assign ce_0 = ce_wr_REG ? ew0 : 0;
  assign ce_1 = ce_wr_REG ? ew1 : 0;
  assign ce_2 = ce_wr_REG ? ew2 : 0;

  wire [7:0] dat_MEM;

  FD8E FD8E_0(.D(rx_dat[7:0]), .Q(LED),
              .ce(ce_0),
              .c(clk));

  FD8E FD8E_1(.D(rx_dat[7:0]), .Q(DISPL[15:8]),
              .ce(ce_1),
              .c(clk));

  FD8E FD8E_2(.D(rx_dat[7:0]), .Q(DISPL[7:0]),
              .ce(ce_2),
              .c(clk));

  BMEM_256x8 BMEM_256x8(.we(ce_wr_MEM), .DO(dat_MEM),
                        .clk(clk),
                        .DI(rx_dat[7:0]),
                        .Adr_wr(wr_adr[7:0]),
                        .Adr_rd(rd_adr[7:0]));

  wire [7:0] dat_REG = er0 ? LED[7:0]    : 
                       er1 ? DISPL[15:8] : 
                       er2 ? DISPL[7:0]  : 
                       er3 ? SW[7:0]     : 8'h00;

  assign my_dat[7:0] = (com == 8'h80) ? dat_REG : 
                       (com == 8'h81 & rd_my_MEM) ? dat_MEM : 8'h00 ;

endmodule

module FD8E(input [7:0] D, output reg [7:0] Q = 0,
            input ce,
            input c);

  always @(posedge c) begin
    Q <= ce ? D : Q;
  end

endmodule

module BMEM_256x8 (input clk, output reg [7:0]DO,
                   input we,
                   input [7:0] DI,
                   input [7:0] Adr_wr,
                   input [7:0] Adr_rd);

  reg [7:0] MEM [255:0] ; //блочная память 8 x 256 bit.

  always @ (posedge clk) begin
    MEM[Adr_wr]<= we? DI :MEM[Adr_wr]; //Запись в память
    DO <= MEM[Adr_rd];
  end
endmodule