`include "CONST.v"
`include "DISPLAY.v"
`include "URXD_CRC_BL.v"
`include "RET_TXD_CRC_BL.v"
`include "my_BLOCK.v"

module main(input clk,      output wire seg_P,
            input JD4,      output wire [7:0] LED,
            input [7:0] SW, output wire [6:0] seg,
            input URXD,     output wire [3:0] AN,
                            output wire UTXD,
                            output wire JD3,
                            output wire JC1,
                            output wire JB1,
                            output wire JB2,
                            output wire JB3,
                            output wire JB4);

  wire [7:0] cb_byte; wire [7:0] rx_lbl;
  wire [15:0] CRC;    wire [7:0] rx_datl;
  wire [7:0] rx_com;  wire [15:0] wr_adr;
  wire [15:0] DISPL;  wire [7:0] my_dat;
  wire [7:0] tx_dat;  wire [15:0] tCRC;
  wire [7:0] cb_byte_2; wire [15:0] rd_adr;
  wire res, ce_wr_dat, ok_rx_bl, to_USB_TTL, st;

  assign O    = URXD & JD4;
  assign JB4  = st;
  assign JD3  = to_USB_TTL;
  assign UTXD = to_USB_TTL;

  URXD_CRC_BL URXD_CRC_BL(.URXD(O),   .en_rx_byte(JB1),
                          .clk(clk),  .en_rx_bl(JB3),
                                      .ok_rx_byte(JB2),
                                      .cb_byte(cb_byte),
                                      .res(res),
                                      .lbl(rx_lbl),
                                      .CRC(CRC),
                                      .ce_wr_dat(ce_wr_dat),
                                      .rx_dat(rx_datl),
                                      .com(rx_com),
                                      .wr_adr(wr_adr),
                                      .ok_rx_bl(st));

  DISPLAY DISPLAY(.clk(clk),   .seg_P(seg_P),
                  .dat(DISPL), .AN(AN),
                               .seg(seg));

  my_BLOCK my_BLOCK(.clk(clk),             .DISPL(DISPL),
                    .ce_wr_dat(ce_wr_dat), .LED(LED),
                    .rx_dat(rx_datl),      .my_dat(my_dat),
                    .com(rx_com),
                    .wr_adr(wr_adr),
                    .rd_adr(rd_adr),
                    .SW(SW));

  RET_TXD_CRC_BL RET_TXD_CRC_BL(.st(ok_rx_bl), .rd_adr(rd_adr),
                                .clk(clk),     .en_tx(JC1),
                                .com(rx_com),  .UTXD(to_USB_TTL),
                                .dat(my_dat),  .tx_dat(tx_dat),
                                               .CRC(tCRC),
                                               .cb_byte(cb_byte_2));

endmodule