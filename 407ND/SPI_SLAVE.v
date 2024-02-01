module SPI_SLAVE(input [`m-1:0] DI, output  reg [`m-1:0] DO,
                 input sclk,        output wire [`m-1:0] sr_STX,
                 input MOSI,        output reg  [`m-1:0] sr_SRX = 0,
                 input load,        output wire MISO,
                 input clr);

  reg [4:0] ptr_bit = 0;
  assign MISO = DI[ptr_bit];

  always @(posedge load or negedge sclk) begin
    ptr_bit <= load ? `m-1 : ptr_bit - 1;
  end

  always @(posedge sclk) sr_SRX <= sr_SRX << 1 | MOSI;
  always @(posedge load) DO <= sr_SRX;

endmodule