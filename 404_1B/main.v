// CHANGE ME:
`define Fbit 38400

`include "UTXD1B.v"
`include "DISPLAY.v"
`include "URXD1B.v"
`include "FD8RE.v"

module main(input clk,      output wire LED0,
            input BTN0,     output wire LED7,
            input BTN3,     output wire seg_P,
            input URXD,     output wire JB2,
            input JD4,      output wire JB3,
            input [7:0] SW, output wire JB4,
                            output wire JB7,
                            output wire JB8,
                            output wire UTXD,
                            output wire [3:0] AN,
                            output wire [6:0] seg,
                            output wire JD3,
                            output wire JC1,
                            output wire JC2, 
                            output wire JC3,
                            output wire JC4,
                            output wire JC7,
                            output wire JC8);

  wire en_tx_byte, ce1ms, ce_stop, en_rx_byte, O;
  wire ok_rx_byte, start, ce_bit, bf_TXD;
  wire [3:0] cb_bit; wire [7:0] sr_dat;
  assign LED7 = en_tx_byte; wire [7:0] sr_dat_D;
  assign JB2  = en_tx_byte; wire [7:0] RX_DAT;

  assign LED0 = en_rx_byte;
  assign JC2  = en_rx_byte;

  assign JD3  = bf_TXD;
  assign UTXD = bf_TXD;

  assign D0 = JD4 & URXD;
  assign O  = BTN3 ? bf_TXD : D0;

  UTXD1B UTXD1B(.clk(clk),  .UTXD(bf_TXD),
                .st(ce1ms), .ce_tact(JB8),
                .dat(SW),   .en_tx_byte(en_tx_byte),
                            .T_start(JB3),
                            .T_dat(JB4),
                            .T_stop(JB7),
                            .ce_stop(ce_stop),
                            .cb_bit(cb_bit),
                            .sr_dat(sr_dat));

  DISPLAY DISPLAY(.clk(clk),   .seg_P(seg_P),
                  .HB(SW),     .ce1ms(ce1ms),
                  .LB(RX_DAT), .AN(AN),
                               .seg(seg));

  URXD1B URXD1B(.clk(clk), .en_rx_byte(en_rx_byte),
                .Inp(O),   .ok_rx_byte(ok_rx_byte),
                           .start(start),
                           .T_dat(JC4),
                           .ce_tact(JC8),
                           .ce_bit(ce_bit),
                           .T_start(JC3),
                           .T_stop(JC7),
                           .RXD(JC1),
                           .sr_dat(sr_dat_D),
                           .cb_bit(cb_bit));

  FD8RE FD8RE(.D(sr_dat_D),    .Q(RX_DAT),
              .CE(ok_rx_byte), 
              .C(clk),
              .R(BTN0));

endmodule