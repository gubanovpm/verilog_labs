module URXD1B(input Inp, output reg en_rx_byte = 0,
              input clk, output wire ok_rx_byte,
                         output wire start,
                         output reg T_dat,
                         output wire ce_tact,
                         output wire ce_bit,
                         output reg T_start,
                         output reg T_stop,
                         output wire RXD,
                         output reg [7:0] sr_dat = 0,
                         output reg [3:0] cb_bit = 0);

  parameter Fclk = 50000000;
  parameter Nt = Fclk / `Fbit;

  reg [31:0] cb_tact = 0;

  assign ce_bit = (cb_tact == (Nt/2));
  assign ce_tact = (cb_tact == Nt);

  
  assign RXD = T_start ? 0 : T_dat ? sr_dat[0] : 1 ; //Последовательные данные sr_dat[0]

  reg dRXD = 0;
  assign ce_stop = T_stop & ce_bit;
  assign start = dRXD & !en_rx_byte;
  assign ok_rx_byte = ce_bit & T_stop;

  always @(posedge clk) begin
    T_start <= ((cb_bit == 0) & en_rx_byte);
    T_stop  <= (cb_bit == 9);
    T_dat   <= ((cb_bit < 9) & (cb_bit > 0));
    dRXD <= ~Inp ? 1 : 0;
    cb_tact <= (start | ce_tact) ? 1 : cb_tact + 1;
    en_rx_byte <= dRXD ? 1 : ce_stop ? 0 : en_rx_byte;
    cb_bit <= start ? 0 : (ce_tact & en_rx_byte) ? cb_bit + 1 : cb_bit;
    sr_dat <= (T_start & ce_tact) ? Inp : (T_dat & ce_tact) ? sr_dat >> 1 : sr_dat ;
  end

endmodule