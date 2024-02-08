module URXD1B(input inp, output reg en_rx_byte=0,
              input clk, output reg [7:0] RX_dat=0,
                         output wire start_rx,
                         output wire ok_rx_byte,
                         output reg [3:0]cb_bit=0,
                         output wire T_dat,
                         output wire ce_tact,
                         output wire ce_bit );

  parameter Fclk=50000000 ; //Fclk=50MHz
  parameter F1=1200 ; //1200 Bod

  reg tin=0, ttin=0;//
  reg [15:0]cb_tact=0 ;

  assign ce_tact = (cb_tact==Fclk/F1) ;
  reg [7:0] sr_dat=0 ;

  wire spad_inp = !tin & ttin ;//spad_inp

  assign start_rx = spad_inp & !en_rx_byte ;
  assign ce_bit = (cb_tact==Fclk/(2*F1));
  assign ok_rx_byte = (ce_bit & (cb_bit==9) & en_rx_byte & tin);
  assign T_dat = ((cb_bit>=1) & (cb_bit<=8));

  always @ (posedge clk) begin
    tin <= inp ; ttin <= tin ;
    cb_tact <= (start_rx | ce_tact)? 1 : cb_tact+1;
    en_rx_byte <= ((cb_bit==9) & ce_bit)? 0 : (ce_bit & !tin)? 1: en_rx_byte ;
    cb_bit <= (start_rx | ((cb_bit==9) & ce_tact))? 0 : (ce_tact & en_rx_byte)? cb_bit+1 : cb_bit ;
    sr_dat <= start_rx? 0 : (ce_bit & T_dat)? sr_dat >>1 | tin<<7 : sr_dat ;//in
    RX_dat <= ok_rx_byte? sr_dat : RX_dat ;
  end

endmodule