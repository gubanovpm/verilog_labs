`include "CONST.v"

module my_BLOCK(input clk,           output reg [15:0] DISPL=16'h3456,
                input ce_wr_dat,     output reg [7:0] LED=8'h12,
                input [7:0] rx_dat,  output wire [7:0] my_dat,
                input [15:0] wr_adr,
                input [15:0] rd_adr,
                input [7:0] SW,
                input [7:0] com);

  assign wr_my_MEM = ((`MY_ADR <= wr_adr) & (wr_adr <= `MY_ADR + 255));
  assign rd_my_MEM = ((`MY_ADR <= rd_adr) & (rd_adr <= `MY_ADR + 255));

  assign ce_wr_REG =  (com == 8'h00) ? ce_wr_dat : 0 ;
  assign ce_wr_MEM = ((com == 8'h81) & wr_my_MEM);
  assign ce_rd_MEM = ((com == 8'h81) & rd_my_MEM);

  wire [7:0] dat_MEM;

  always @(posedge clk) begin
    LED <= (wr_adr == `MY_ADR) ? rx_dat : LED;
    DISPL[15:8] <= (wr_adr == `MY_ADR + 1) ? rx_dat : DISPL[15:8];
    DISPL[ 7:0] <= (wr_adr == `MY_ADR + 2) ? rx_dat : DISPL[ 7:0];
  end

  BMEM_256x8 BMEM_256x8(.we(ce_wr_MEM), .DO(dat_MEM),
                        .clk(clk),
                        .DI(rx_dat[7:0]),
                        .Adr_wr(wr_adr[7:0]),
                        .Adr_rd(rd_adr[7:0]));

  wire [7:0] dat_REG = (rd_adr == `MY_ADR + 0) ? LED[7:0]    : 
                       (rd_adr == `MY_ADR + 1) ? DISPL[15:8] : 
                       (rd_adr == `MY_ADR + 2) ? DISPL[7:0]  : 
                       (rd_adr == `MY_ADR + 3) ? SW[7:0]     : 8'hFF;

  assign my_dat[7:0] = (com == 8'h80) ? dat_REG : 
                       (com == 8'h81 & rd_my_MEM) ? dat_MEM : 8'h55 ;

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