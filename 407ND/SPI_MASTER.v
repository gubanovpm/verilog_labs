`ifndef m
  `define m 16
`endif

`ifndef Fbit
  `define Fbit 50000
`endif

module SPI_MASTER(input st,         output wire LOAD,
                  input clk,        output wire SCLK,
                  input MISO,       output wire MOSI,
                  input clr,        output wire ce,
                  input[`m-1:0] DI, output wire ce_tact,
                                    output wire[7:0] cb_bit,
                                    output wire[`m-1:0] sr_MTX,
                                    output wire[`m-1:0] sr_MRX,
                                    output wire[`m-1:0] DO);

  wire START, COMP_CE, R, COMP_BIT;
  wire [7:0] cb_tact;

  assign COMP_TACT = ce_tact & COMP_BIT;

  parameter Fclk = 50000000;

  wire [7:0] Nt = Fclk / `Fbit - 1;

  RS_T rs_trigger(.R(st), .Q(LOAD),
                  .clk(clk),
                  .S(COMP_TACT));
  assign START = LOAD & st;
  assign R = START | COMP_CE;

  COUNTER_TACT COUNTER_TACT(.clk(clk), .cb_tact(cb_tact),
                            .R(R));

  CMP CMP_1(.A(cb_tact), .RES(COMP_CE),
            .N(Nt));

  T_T T_T(.T(COMP_CE), .Q(SCLK),
          .R(LOAD),
          .clk(clk));

  assign ce_tact = COMP_CE & SCLK;

  COUNTER_BIT COUNTER_BIT(.R(START), .cb_bit(cb_bit),
                          .ce(ce_tact), 
                          .clk(clk));

  wire [7:0] temp = `m-1;
  CMP CMP_2(.A(cb_bit), .RES(COMP_BIT),
            .N(temp));

  SLAVE_SDVIG SLAVE_SDVIG(.clk(SCLK), .sr_MRX(sr_MRX),
                          .SLI(MISO));

  MASTER_SDVIG MASTER_SDVIG(.clk(clk), .sr_MTX(sr_MTX),
                            .ce(ce_tact),
                            .L(LOAD),
                            .DI(DO));

  assign MOSI = sr_MTX[0];

  BUFFER BUFFER(.SLI(sr_MRX), .MRX_DAT(DO),
                .clk(LOAD));  

endmodule

module RS_T(input R, output wire Q,
            input S,
            input clk);

  assign q_n = ~(S | Q);
  assign Q   = ~(R | q_n);

endmodule

module T_T(input T, output reg Q,
           input R,
           input clk);

  always @(posedge clk) if (T) begin
    Q <= R ? 0 : ~Q;
  end

endmodule

module COUNTER_TACT(input clk, output reg [7:0] cb_tact = 0,
                    input R);

  always @(posedge clk) begin
    cb_tact <= R ? 0 : cb_tact + 1;
  end

endmodule

module COUNTER_BIT(input clk, output reg [7:0] cb_bit = 0,
                   input ce,
                   input R);

  always @(posedge clk) begin
    cb_bit <= R ? 0 : ce ? cb_bit + 1 : cb_bit;
  end

endmodule

module CMP(input [7:0] A, output wire RES,
           input [7:0] N);

  assign RES = (A == N);
endmodule

module BUFFER(input [`m-1:0] SLI, output reg [`m-1:0] MRX_DAT = 0,
              input clk);

  always @(posedge clk) begin
    MRX_DAT <= SLI ;
  end

endmodule

module SLAVE_SDVIG(input SLI, output reg [`m-1:0] sr_MRX = 0,
                   input clk);

  always @(posedge clk) begin
    sr_MRX <= sr_MRX << 1 | SLI ;
  end

endmodule

module MASTER_SDVIG(input clk, output wire [`m-1:0] sr_MTX,
                    input ce, 
                    input L, 
                    input [`m-1:0] DI);
  reg [`m-1:0] tmp;
  assign sr_MTX = tmp;

  always @(posedge clk) begin
    tmp <= L ? DI : ce ? tmp << 1 : tmp ;
  end

endmodule