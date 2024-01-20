`define Fclk  50000000	
`define Fce   1000000	 
`define F1MHz 1000000	
`define N     100

module Mes_AMP_Trf_Tsp(input clk,      output wire Tfr,
                       input ce1us,    output wire Tsp,
                       input [11:0] X, output wire [11:0] NTfr,
                       input ext_res,  output wire [11:0] NTsp,
                                       output wire zX,
                                       output wire [11:0] AMP,
                                       output wire [11:0] PIC,
                                       output wire end_Tfr,
                                       output wire end_Tsp);

  reg [6:0] cb_tact=0;
  reg[3:0]cb_ce=0;    
  assign ce=(cb_ce==`F1MHz/`Fce) & ce1us; //FiMHz/Fce=10
  reg [11:0]cb_PW =0 ;
  reg [6:0]cb_DEL=0 ;
  wire UP_REF = (DPI > PImax>>1) & (PImax>Amin);
  assign front_PW = UP_REF & !PW & ce;//  
  reg T_DEL=0 ;
  assign res = (cb_DEL==`N) & ce & !UP_REF;

  always @ (posedge clk) begin
    cb_ce <= ce? 1 : ce1us? cb_ce+1 : cb_ce ; 
    cb_tact <= ce? cb_tact+1 : cb_tact ;
    T_DEL <= front_PW? 1 : (res)? 0 : T_DEL ;
    cb_DEL <= front_PW? 1 : (T_DEL & ce)? cb_DEL+1 : cb_DEL ; 
    PImax <= ext_res? 0 : res? Amin : (ce & (X>=PImax))? X : PImax ;//
    AMP <= (res | ext_res)? PImax : AMP ;
    cb_PW <= front_PW ? 0 : (PW & ce1us)? cb_PW+1 : cb_PW ;// 
    TIME_PW <=  ext_res? 0 : res? cb_PW : TIME_PW ;//
  end

  always @ (posedge clk) if (ce & (PImax>Amin)) begin
    PW <= (DPI > (PImax>>1)+Amin/8)? 1 : (DPI < (PImax>>1)-Amin/8)? 0 : PW ;
  end

  wire [6:0] Adr_rd = cb_tact - `N/2 ;
  MEM12x128 DD1 (	.clk(clk),				.DO(DPI),
                  .we(ce),
                  .DI(X),
                  .Adr_wr(cb_tact),
                  .Adr_rd(Adr_rd));  

endmodule

module MEM12x128(input clk,				output reg [11:0] DO,
                 input we,
                 input [11:0] DI,
                 input [6:0] Adr_wr,
                 input [6:0] Adr_rd);
    
  reg [11:0]MEM[127:0] ;
  initial
  $readmemh ("Init_MEM12x128.txt", MEM, 0, 127);  
  always @ (posedge clk) begin
    MEM[Adr_wr] <= we? DI : MEM[Adr_wr] ;
    DO <= MEM[Adr_rd] ;
  end
endmodule