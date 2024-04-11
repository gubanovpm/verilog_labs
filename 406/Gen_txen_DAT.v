module Gen_txen_DAT(input st, 	output reg txen = 0,
                    input clk, 	output wire[15:0] CW_TX,
																output wire[15:0] DAT,
																output wire[15:0] DW_TX);

assign CW_TX = 16'h3344 ; // my CW (Таблица 1)
assign DW_TX = 16'hBCDE ; // my DW (Таблица 1)
assign DAT = txen? CW_TX : DW_TX ;

reg [10:0] cb_txen = 0;
wire ce_end = (cb_txen==1100) ; //20ns*1100=22000ns=22us>20us

always @ (posedge clk) begin
    txen <= st ? 1 : ce_end ? 0 : txen ;
    cb_txen <= st ? 0 : txen? cb_txen+1 : cb_txen ;
end

endmodule